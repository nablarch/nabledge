#!/bin/bash
# Generate Mermaid diagram skeletons from Java source files
# This script reduces LLM generation time by pre-generating basic diagram structures

set -e

# Usage message
usage() {
    cat << EOF
Usage: $0 --source-files <files> --diagram-type <type> [--main-class <class>]

Generate Mermaid diagram skeletons from Java source files.

Required arguments:
  --source-files <files>   Comma-separated Java source file paths
  --diagram-type <type>    Diagram type: "class" or "sequence"

Optional arguments:
  --main-class <class>     Main class name for sequence diagram entry point

Diagram types:
  class      - Generate classDiagram showing class relationships
  sequence   - Generate sequenceDiagram showing method call flow

Example:
  # Generate class diagram skeleton
  $0 --source-files "src/LoginAction.java,src/LoginForm.java" --diagram-type class

  # Generate sequence diagram skeleton
  $0 --source-files "src/LoginAction.java" --diagram-type sequence --main-class LoginAction

Output:
  Outputs Mermaid diagram syntax to stdout
EOF
    exit 1
}

# Parse arguments
SOURCE_FILES=""
DIAGRAM_TYPE=""
MAIN_CLASS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --source-files)
            SOURCE_FILES="$2"
            shift 2
            ;;
        --diagram-type)
            DIAGRAM_TYPE="$2"
            shift 2
            ;;
        --main-class)
            MAIN_CLASS="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown option $1" >&2
            usage
            ;;
    esac
done

# Validate required arguments
if [[ -z "$SOURCE_FILES" || -z "$DIAGRAM_TYPE" ]]; then
    echo "Error: Missing required arguments" >&2
    usage
fi

if [[ "$DIAGRAM_TYPE" != "class" && "$DIAGRAM_TYPE" != "sequence" ]]; then
    echo "Error: Invalid diagram type: $DIAGRAM_TYPE (must be 'class' or 'sequence')" >&2
    exit 1
fi

# Validate source files exist and are readable
IFS=',' read -ra FILE_ARRAY <<< "$SOURCE_FILES"
for file in "${FILE_ARRAY[@]}"; do
    file=$(echo "$file" | xargs) # trim whitespace
    if [[ ! -f "$file" ]]; then
        echo "Error: Source file not found: $file" >&2
        exit 1
    fi
    if [[ ! -r "$file" ]]; then
        echo "Error: Source file is not readable: $file" >&2
        exit 1
    fi
done

# Parse Java file to extract class name and imports
parse_java_file() {
    local file="$1"
    local class_name=""
    local imports=()
    local extends_class=""
    local implements_interfaces=()

    if [[ ! -f "$file" ]]; then
        echo "Error: File not found: $file" >&2
        return 1
    fi

    # Extract class name (support class/interface/enum)
    class_name=$(grep -E '^\s*(public\s+)?(abstract\s+)?(final\s+)?(class|interface|enum|record)\s+\w+' "$file" | head -1 | sed -E 's/.*\s(class|interface|enum|record)\s+(\w+).*/\2/')

    # Extract extends
    extends_class=$(grep -E '^\s*(public\s+)?(abstract\s+)?(final\s+)?class\s+\w+\s+extends\s+\w+' "$file" | head -1 | sed -E 's/.*extends\s+(\w+).*/\1/')

    # Extract implements (can be multiple)
    implements_line=$(grep -E 'implements\s+' "$file" | head -1 | sed -E 's/.*implements\s+([^{]+).*/\1/')
    if [[ -n "$implements_line" ]]; then
        IFS=',' read -ra implements_interfaces <<< "$implements_line"
    fi

    # Extract imports (Java classes only, skip java.lang.*)
    while IFS= read -r line; do
        if [[ "$line" =~ ^import[[:space:]]+([^[:space:]]+)\; ]]; then
            import="${BASH_REMATCH[1]}"
            # Skip java.lang.* and java.util.* (too common)
            if [[ ! "$import" =~ ^java\.(lang|util)\. ]]; then
                # Extract simple class name
                simple_name="${import##*.}"
                imports+=("$simple_name")
            fi
        fi
    done < "$file"

    # Output as JSON-like format
    echo "CLASS:$class_name"
    [[ -n "$extends_class" ]] && echo "EXTENDS:$extends_class"
    for impl in "${implements_interfaces[@]}"; do
        impl=$(echo "$impl" | xargs) # trim whitespace
        [[ -n "$impl" ]] && echo "IMPLEMENTS:$impl"
    done
    for imp in "${imports[@]}"; do
        echo "IMPORT:$imp"
    done
}

# Generate class diagram skeleton
generate_class_diagram() {
    local files="$1"

    echo "classDiagram"

    declare -A classes
    declare -A relationships

    # Parse all files and extract class information
    IFS=',' read -ra FILE_ARRAY <<< "$files"
    for file in "${FILE_ARRAY[@]}"; do
        file=$(echo "$file" | xargs) # trim whitespace

        local class_name=""
        local extends_class=""
        declare -a implements_interfaces=()
        declare -a imports=()

        # Parse file
        while IFS= read -r line; do
            if [[ "$line" =~ ^CLASS:(.+) ]]; then
                class_name="${BASH_REMATCH[1]}"
                classes["$class_name"]=1
            elif [[ "$line" =~ ^EXTENDS:(.+) ]]; then
                extends_class="${BASH_REMATCH[1]}"
                relationships["$class_name--|>$extends_class"]=1
            elif [[ "$line" =~ ^IMPLEMENTS:(.+) ]]; then
                impl="${BASH_REMATCH[1]}"
                implements_interfaces+=("$impl")
                relationships["$class_name..|>$impl"]=1
            elif [[ "$line" =~ ^IMPORT:(.+) ]]; then
                imports+=("${BASH_REMATCH[1]}")
            fi
        done < <(parse_java_file "$file")

        # Generate class definition
        if [[ -n "$class_name" ]]; then
            # Check if class is Nablarch framework class (heuristic: starts with common prefixes)
            if [[ "$class_name" =~ ^(Universal|Business|System|Validation|Execution|Database|File|Object|Entity) ]]; then
                echo "    class ${class_name} {"
                echo "        <<Nablarch>>"
                echo "    }"
            else
                echo "    class ${class_name}"
            fi

            # Add dependency relationships to imported classes that are also in our file list
            for imp in "${imports[@]}"; do
                # Check if imported class is in our class list
                if [[ -n "${classes[$imp]}" ]]; then
                    relationships["${class_name}..>${imp}"]=1
                fi
            done
        fi
    done

    echo ""

    # Output relationships
    for rel in "${!relationships[@]}"; do
        echo "    $rel : uses"
    done
}

# Generate sequence diagram skeleton
generate_sequence_diagram() {
    local files="$1"
    local main_class="$2"

    echo "sequenceDiagram"

    # Parse first file to get main class if not specified
    if [[ -z "$main_class" ]]; then
        IFS=',' read -ra FILE_ARRAY <<< "$files"
        first_file="${FILE_ARRAY[0]}"
        first_file=$(echo "$first_file" | xargs)

        while IFS= read -r line; do
            if [[ "$line" =~ ^CLASS:(.+) ]]; then
                main_class="${BASH_REMATCH[1]}"
                break
            fi
        done < <(parse_java_file "$first_file")
    fi

    if [[ -z "$main_class" ]]; then
        echo "Error: Could not determine main class" >&2
        exit 1
    fi

    # Define participants
    echo "    participant User"
    echo "    participant ${main_class}"

    # Parse all files to find imported classes
    declare -A participants
    IFS=',' read -ra FILE_ARRAY <<< "$files"
    for file in "${FILE_ARRAY[@]}"; do
        file=$(echo "$file" | xargs)

        while IFS= read -r line; do
            if [[ "$line" =~ ^IMPORT:(.+) ]]; then
                import_class="${BASH_REMATCH[1]}"
                # Check if this class is likely used (heuristic: contains Dao, Service, Form, Entity, Util)
                if [[ "$import_class" =~ (Dao|Service|Form|Entity|Util|Manager|Handler) ]]; then
                    participants["$import_class"]=1
                fi
            fi
        done < <(parse_java_file "$file")
    done

    # Add participants for commonly used classes
    for participant in "${!participants[@]}"; do
        echo "    participant ${participant}"
    done

    # Add Database participant if we found Dao classes
    for participant in "${!participants[@]}"; do
        if [[ "$participant" =~ Dao ]]; then
            echo "    participant Database"
            break
        fi
    done

    echo ""

    # Generate basic flow skeleton
    echo "    User->>${main_class}: request"

    # Add basic method calls based on common patterns
    for participant in "${!participants[@]}"; do
        if [[ "$participant" =~ Form ]]; then
            echo "    ${main_class}->>${participant}: validate"
        elif [[ "$participant" =~ Dao ]]; then
            echo "    ${main_class}->>${participant}: query"
            echo "    ${participant}->>Database: SQL"
            echo "    Database-->>${participant}: result"
            echo "    ${participant}-->>${main_class}: data"
        elif [[ "$participant" =~ Service ]]; then
            echo "    ${main_class}->>${participant}: process"
            echo "    ${participant}-->>${main_class}: result"
        fi
    done

    echo "    ${main_class}-->>User: response"
}

# Generate diagram based on type
if [[ "$DIAGRAM_TYPE" == "class" ]]; then
    generate_class_diagram "$SOURCE_FILES"
elif [[ "$DIAGRAM_TYPE" == "sequence" ]]; then
    generate_sequence_diagram "$SOURCE_FILES" "$MAIN_CLASS"
fi

# Exit successfully
exit 0
