#!/bin/bash
# Pre-fill deterministic placeholders in code analysis template
# This script reduces LLM generation time by pre-filling 9 deterministic placeholders

set -e

# Usage message
usage() {
    cat << EOF
Usage: $0 --target-name <name> --target-desc <description> --modules <modules> --source-files <files> --knowledge-files <files>

Pre-fill deterministic placeholders in code analysis template.

Required arguments:
  --target-name <name>        Target name (e.g., "LoginAction", "login feature")
  --target-desc <description> One-line description of the target
  --modules <modules>         Affected modules (e.g., "proman-web, proman-common")
  --source-files <files>      Comma-separated source file basenames (e.g., "LoginAction.java,LoginForm.java")
                              Script searches from project root and includes all matches.
                              Paths are accepted but only basenames are used.
                              If multiple files found, directory path added to label for disambiguation.
  --knowledge-files <files>   Comma-separated knowledge file basenames (e.g., "universal-dao,web-application")
                              Script searches in .claude/skills/nabledge-1.3/knowledge/ and includes all matches.
                              Extension (.json) is optional. Automatically converts to .md paths.
                              Paths are accepted but only basenames are used.
                              Official documentation URLs are extracted from knowledge JSON files.

Note:
  - Output path is automatically calculated as: .nabledge/YYYYMMDD/code-analysis-{target-name}.md
  - Official documentation links are automatically extracted from knowledge JSON files

Example:
  $0 --target-name "LoginAction" \\
     --target-desc "login authentication processing" \\
     --modules "proman-web" \\
     --source-files "LoginAction.java,LoginForm.java" \\
     --knowledge-files "universal-dao,web-application"

# Example output:
# Pre-filled template written to: .nabledge/20260303/code-analysis-LoginAction.md
# ...
# Output: .nabledge/20260303/code-analysis-LoginAction.md
EOF
    exit 1
}

# Parse arguments
TARGET_NAME=""
TARGET_DESC=""
MODULES=""
SOURCE_FILES=""
KNOWLEDGE_FILES=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --target-name)
            TARGET_NAME="$2"
            shift 2
            ;;
        --target-desc)
            TARGET_DESC="$2"
            shift 2
            ;;
        --modules)
            MODULES="$2"
            shift 2
            ;;
        --source-files)
            SOURCE_FILES="$2"
            shift 2
            ;;
        --knowledge-files)
            KNOWLEDGE_FILES="$2"
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
if [[ -z "$TARGET_NAME" || -z "$TARGET_DESC" || -z "$MODULES" || -z "$SOURCE_FILES" || -z "$KNOWLEDGE_FILES" ]]; then
    echo "Error: Missing required arguments" >&2
    usage
fi

# Validate jq availability (required for official docs extraction)
if ! command -v jq &> /dev/null; then
    echo "Warning: jq not found. Official documentation links cannot be extracted from knowledge files." >&2
    echo "Install jq to enable automatic official docs extraction." >&2
fi

# Calculate output path internally
OUTPUT_DIR=".nabledge/$(date '+%Y%m%d')"
OUTPUT_FILE="code-analysis-${TARGET_NAME}.md"
OUTPUT_PATH="$OUTPUT_DIR/$OUTPUT_FILE"

# Find project root
if git rev-parse --show-toplevel &>/dev/null; then
    PROJECT_ROOT="$(git rev-parse --show-toplevel)"
else
    PROJECT_ROOT="$(pwd)"
fi

# Template file location
TEMPLATE_FILE="$PROJECT_ROOT/.claude/skills/nabledge-1.3/assets/code-analysis-template.md"

# Validate template file exists and is readable
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file not found at $TEMPLATE_FILE" >&2
    exit 1
fi

if [[ ! -r "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file is not readable: $TEMPLATE_FILE" >&2
    exit 1
fi

# Get current date and time
GENERATION_DATE=$(date '+%Y-%m-%d')
GENERATION_TIME=$(date '+%H:%M:%S')

# Search for file by basename
# Usage: search_files <file_pattern> <search_dir> <file_type>
# Returns: all matching paths on stdout (one per line), or empty if not found
search_files() {
    local file_pattern="$1"
    local search_dir="$2"
    local file_type="$3"  # "source" or "knowledge"

    # Search for file
    local matches
    if [[ "$file_type" == "knowledge" ]]; then
        # For knowledge files, search for .json files
        local basename="${file_pattern%.json}"  # Remove .json if present
        matches=$(find "$search_dir" -type f -name "${basename}.json" 2>/dev/null)
    else
        # For source files, search by exact basename
        matches=$(find "$search_dir" -type f -name "$file_pattern" 2>/dev/null)
    fi

    # Check if matches is empty
    if [[ -z "$matches" ]]; then
        echo "Warning: ${file_type} file not found: '$file_pattern' (searched in: $search_dir) - link will be omitted" >&2
        return 0
    fi

    # Return all matches
    echo "$matches"
    return 0
}

# Fixed relative path prefix (2-level depth: .nabledge/YYYYMMDD/)
RELATIVE_PREFIX="../../"

# Build source files links
SOURCE_FILES_LINKS=""
IFS=',' read -ra FILES <<< "$SOURCE_FILES"
for file in "${FILES[@]}"; do
    file=$(echo "$file" | xargs) # trim whitespace
    [[ -z "$file" ]] && continue

    # Extract basename defensively (in case path is provided)
    file=$(basename "$file")

    # Search for files (returns all matches)
    matches=$(search_files "$file" "." "source")

    # If file not found, skip (warning already printed)
    if [[ -z "$matches" ]]; then
        continue
    fi

    # Count matches
    match_count=$(echo "$matches" | wc -l)

    # Process each match
    while IFS= read -r resolved_path; do
        # Remove leading ./ from path
        resolved_path=$(echo "$resolved_path" | sed 's|^\./||')

        filename=$(basename "$resolved_path")
        relative_path="${RELATIVE_PREFIX}${resolved_path}"

        # If multiple matches, add directory path to label
        if [[ $match_count -gt 1 ]]; then
            # Extract parent directory path for disambiguation
            dir_path=$(dirname "$resolved_path")
            label="${filename} (${dir_path})"
        else
            label="${filename}"
        fi

        # Extract simple description from filename (remove extension)
        desc=$(basename "$resolved_path" | sed 's/\.[^.]*$//')
        SOURCE_FILES_LINKS+="- [${label}](${relative_path}) - ${desc}"$'\n'
    done <<< "$matches"
done
SOURCE_FILES_LINKS=$(echo "$SOURCE_FILES_LINKS" | sed 's/^$//')

# Build knowledge base links
KNOWLEDGE_BASE_LINKS=""
IFS=',' read -ra FILES <<< "$KNOWLEDGE_FILES"
for file in "${FILES[@]}"; do
    file=$(echo "$file" | xargs) # trim whitespace
    [[ -z "$file" ]] && continue

    # Extract basename defensively (in case path is provided)
    file=$(basename "$file")
    # Remove .json extension if present
    file="${file%.json}"

    # Search for files (returns all matches)
    matches=$(search_files "$file" ".claude/skills/nabledge-1.3/knowledge" "knowledge")

    # If file not found, skip (warning already printed)
    if [[ -z "$matches" ]]; then
        continue
    fi

    # Count matches
    match_count=$(echo "$matches" | wc -l)

    # Process each match
    while IFS= read -r resolved_path; do
        # Remove leading ./ from path
        resolved_path=$(echo "$resolved_path" | sed 's|^\./||')

        # Convert knowledge JSON paths to docs MD paths
        # Example: .claude/skills/nabledge-1.3/knowledge/features/X.json
        #       → .claude/skills/nabledge-1.3/docs/features/X.md
        doc_file="${resolved_path/\/knowledge\//\/docs\/}"
        doc_file="${doc_file/.json/.md}"

        filename=$(basename "$doc_file" .md)
        relative_path="${RELATIVE_PREFIX}${doc_file}"

        # Use filename as description (capitalize first letter)
        desc=$(echo "$filename" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

        # If multiple matches, add category path to label for disambiguation
        if [[ $match_count -gt 1 ]]; then
            # Extract category from path (e.g., features/libraries, features/handlers)
            category=$(echo "$resolved_path" | sed 's|.*/knowledge/\(.*\)/[^/]*$|\1|')
            label="${desc} (${category})"
        else
            label="${desc}"
        fi

        KNOWLEDGE_BASE_LINKS+="- [${label}](${relative_path})"$'\n'
    done <<< "$matches"
done
KNOWLEDGE_BASE_LINKS=$(echo "$KNOWLEDGE_BASE_LINKS" | sed 's/^$//')

# Extract official docs links from knowledge JSON files
OFFICIAL_DOCS_LINKS=""
IFS=',' read -ra FILES <<< "$KNOWLEDGE_FILES"
for file in "${FILES[@]}"; do
    file=$(echo "$file" | xargs) # trim whitespace
    [[ -z "$file" ]] && continue

    # Extract basename defensively (in case path is provided)
    file=$(basename "$file")
    # Remove .json extension if present
    file="${file%.json}"

    # Find the JSON file
    json_path=$(find ".claude/skills/nabledge-1.3/knowledge" -type f -name "${file}.json" 2>/dev/null | head -1)

    if [[ -n "$json_path" ]]; then
        # Extract official_doc_urls using jq (if jq is available)
        if command -v jq &> /dev/null; then
            urls=$(jq -r '.official_doc_urls[]?' "$json_path" 2>/dev/null)
            if [[ -n "$urls" ]]; then
                while IFS= read -r url; do
                    # Extract title from URL (last segment before .html)
                    title=$(basename "$url" .html | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
                    OFFICIAL_DOCS_LINKS+="- [${title}](${url})"$'\n'
                done <<< "$urls"
            fi
        fi
    fi
done

# Remove duplicates and sort
OFFICIAL_DOCS_LINKS=$(echo "$OFFICIAL_DOCS_LINKS" | sort -u)

if [[ -z "$OFFICIAL_DOCS_LINKS" ]]; then
    OFFICIAL_DOCS_LINKS="(No official documentation links available)"
fi

# Create output directory if it doesn't exist
mkdir -p "$(dirname "$OUTPUT_PATH")"

# Copy template and replace placeholders
# Use temporary file in output directory to avoid environment dependencies
OUTPUT_DIR_REAL=$(dirname "$OUTPUT_PATH")
TEMP_FILE="$OUTPUT_DIR_REAL/.prefill-template-$$.tmp"

# Set up cleanup trap to remove temp files on exit/error
trap 'rm -f "$TEMP_FILE" "$TEMP_FILE.tmp"' EXIT INT TERM

cp "$TEMPLATE_FILE" "$TEMP_FILE"

# Escape special characters for sed
# Handles: & / \ [ ] * . ^ $ and newlines
escape_sed() {
    echo "$1" | sed 's/[&/\[\]*.\^$]/\\&/g; s/\\/\\\\/g'
}

TARGET_NAME_ESC=$(escape_sed "$TARGET_NAME")
TARGET_DESC_ESC=$(escape_sed "$TARGET_DESC")
MODULES_ESC=$(escape_sed "$MODULES")
GENERATION_DATE_ESC=$(escape_sed "$GENERATION_DATE")
GENERATION_TIME_ESC=$(escape_sed "$GENERATION_TIME")
OUTPUT_PATH_ESC=$(escape_sed "$OUTPUT_PATH")
SOURCE_FILES_LINKS_ESC=$(escape_sed "$SOURCE_FILES_LINKS")
KNOWLEDGE_BASE_LINKS_ESC=$(escape_sed "$KNOWLEDGE_BASE_LINKS")
OFFICIAL_DOCS_LINKS_ESC=$(escape_sed "$OFFICIAL_DOCS_LINKS")

# Replace placeholders (one by one to avoid conflicts)
sed -i "s/{{target_name}}/$TARGET_NAME_ESC/g" "$TEMP_FILE"
sed -i "s/{{target_description}}/$TARGET_DESC_ESC/g" "$TEMP_FILE"
sed -i "s/{{modules}}/$MODULES_ESC/g" "$TEMP_FILE"
sed -i "s/{{generation_date}}/$GENERATION_DATE_ESC/g" "$TEMP_FILE"
sed -i "s/{{generation_time}}/$GENERATION_TIME_ESC/g" "$TEMP_FILE"
sed -i "s/{{output_path}}/$OUTPUT_PATH_ESC/g" "$TEMP_FILE"

# For multi-line replacements, use a different approach
# Replace source_files_links
awk -v links="$SOURCE_FILES_LINKS" '{gsub(/\{\{source_files_links\}\}/, links); print}' "$TEMP_FILE" > "$TEMP_FILE.tmp" && mv "$TEMP_FILE.tmp" "$TEMP_FILE"

# Replace knowledge_base_links
awk -v links="$KNOWLEDGE_BASE_LINKS" '{gsub(/\{\{knowledge_base_links\}\}/, links); print}' "$TEMP_FILE" > "$TEMP_FILE.tmp" && mv "$TEMP_FILE.tmp" "$TEMP_FILE"

# Replace official_docs_links
awk -v links="$OFFICIAL_DOCS_LINKS" '{gsub(/\{\{official_docs_links\}\}/, links); print}' "$TEMP_FILE" > "$TEMP_FILE.tmp" && mv "$TEMP_FILE.tmp" "$TEMP_FILE"

# Copy to output path
cp "$TEMP_FILE" "$OUTPUT_PATH"

# Verify write succeeded
if [ ! -f "$OUTPUT_PATH" ]; then
    echo "Error: Failed to write output file to $OUTPUT_PATH" >&2
    exit 1
fi

# Trap will clean up temp files automatically

# Count official docs links (exclude the placeholder message)
official_docs_count=0
if [[ "$OFFICIAL_DOCS_LINKS" != "(No official documentation links available)" ]]; then
    official_docs_count=$(echo "$OFFICIAL_DOCS_LINKS" | grep -c '^\- \[')
fi

echo "Pre-filled template written to: $OUTPUT_PATH"
echo ""
echo "Pre-filled placeholders (9/17):"
echo "  ✓ target_name: $TARGET_NAME"
echo "  ✓ generation_date: $GENERATION_DATE"
echo "  ✓ generation_time: $GENERATION_TIME"
echo "  ✓ target_description: $TARGET_DESC"
echo "  ✓ modules: $MODULES"
echo "  ✓ output_path: $OUTPUT_PATH"
echo "  ✓ source_files_links: $(echo "$SOURCE_FILES" | tr ',' '\n' | wc -l) files"
echo "  ✓ knowledge_base_links: $(echo "$KNOWLEDGE_FILES" | tr ',' '\n' | wc -l) files"
echo "  ✓ official_docs_links: $official_docs_count links"
echo ""
echo "Remaining placeholders for LLM (8/17):"
echo "  - analysis_duration (to be filled after Write completes)"
echo "  - overview_content"
echo "  - dependency_graph"
echo "  - component_summary_table"
echo "  - flow_content"
echo "  - flow_sequence_diagram"
echo "  - components_details"
echo "  - nablarch_usage"
echo ""
echo "Output: $OUTPUT_PATH"
