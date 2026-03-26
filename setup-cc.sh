#!/bin/bash
set -e

# ============================================================
# Nabledge Setup Script for Claude Code
# ============================================================
#
# Usage:
#   setup-cc.sh [options]
#
# Options:
#   -v <version>  Version(s) to install. Comma-separated or "all".
#                 Default: all
#
# Examples:
#   setup-cc.sh                  # Install all versions
#   setup-cc.sh -v all           # Install all versions (explicit)
#   setup-cc.sh -v 6             # Install nabledge-6 only
#   setup-cc.sh -v 5             # Install nabledge-5 only
#   setup-cc.sh -v 5,6           # Install nabledge-5 and nabledge-6
#
# Environment variables (optional):
#   NABLEDGE_REPO    GitHub repository (default: nablarch/nabledge)
#   NABLEDGE_BRANCH  Branch or tag (default: main)
# ============================================================

# Available versions
ALL_VERSIONS=(6 5 1.4)

# Parse options
VERSIONS_ARG="all"
while getopts "v:h" opt; do
    case "$opt" in
        v) VERSIONS_ARG="$OPTARG" ;;
        h)
            echo "Usage: setup-cc.sh [-v <version>]"
            echo ""
            echo "Options:"
            echo "  -v <version>  Version(s) to install. Comma-separated or 'all'."
            echo "                Available: 5, 6, all (default: all)"
            echo ""
            echo "Examples:"
            echo "  setup-cc.sh            # Install all versions"
            echo "  setup-cc.sh -v 6       # Install nabledge-6 only"
            echo "  setup-cc.sh -v 5       # Install nabledge-5 only"
            echo "  setup-cc.sh -v 5,6     # Install nabledge-5 and nabledge-6"
            exit 0
            ;;
        *)
            echo "Error: Unknown option -$OPTARG"
            echo "Run 'setup-cc.sh -h' for usage."
            exit 1
            ;;
    esac
done

# Resolve versions to install
if [ "$VERSIONS_ARG" = "all" ]; then
    VERSIONS=("${ALL_VERSIONS[@]}")
else
    IFS=',' read -ra VERSIONS <<< "$VERSIONS_ARG"
    # Validate each version
    for v in "${VERSIONS[@]}"; do
        v_trimmed="${v// /}"
        valid=false
        for av in "${ALL_VERSIONS[@]}"; do
            if [ "$v_trimmed" = "$av" ]; then
                valid=true
                break
            fi
        done
        if [ "$valid" = false ]; then
            echo "Error: Unknown version '$v_trimmed'. Available versions: ${ALL_VERSIONS[*]}"
            exit 1
        fi
    done
fi

# Navigate to repository root (or current directory if not in git repo)
if git rev-parse --show-toplevel &>/dev/null; then
  PROJECT_ROOT="$(git rev-parse --show-toplevel)"
else
  PROJECT_ROOT="$(pwd)"
fi

echo "Nabledge setup for Claude Code"
echo "Project root: $PROJECT_ROOT"
echo "Versions to install: ${VERSIONS[*]}"

# Configuration (can be overridden with environment variables)
NABLEDGE_REPO="${NABLEDGE_REPO:-nablarch/nabledge}"
NABLEDGE_BRANCH="${NABLEDGE_BRANCH:-main}"

# Build repository URL
REPO_URL="${NABLEDGE_REPO_URL:-https://github.com/${NABLEDGE_REPO}}"
REPO_NAME="${NABLEDGE_REPO##*/}"
BRANCH="$NABLEDGE_BRANCH"
TEMP_DIR=$(mktemp -d)

# Ensure cleanup on exit
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Repository: $NABLEDGE_REPO"
echo "Branch: $BRANCH"

# Build sparse-checkout paths for all requested versions
SPARSE_PATHS=()
for v in "${VERSIONS[@]}"; do
    SPARSE_PATHS+=("plugins/nabledge-${v}")
done

echo "Downloading from $REPO_URL (branch: $BRANCH)..."
cd "$TEMP_DIR"
git clone --depth 1 --filter=blob:none --sparse --branch "$BRANCH" "$REPO_URL"
cd "$REPO_NAME"
git sparse-checkout set "${SPARSE_PATHS[@]}"

# Verify and install each version
install_errors=()
for v in "${VERSIONS[@]}"; do
    plugin_dir="plugins/nabledge-${v}"
    if [ ! -d "$plugin_dir" ]; then
        echo "Error: $plugin_dir directory not found in repository"
        echo "Repository structure may have changed."
        echo "Please report this issue at: https://github.com/nablarch/nabledge/issues"
        install_errors+=("nabledge-${v}")
        continue
    fi

    # Create .claude/skills directory
    mkdir -p "$PROJECT_ROOT/.claude/skills"

    # Copy skills/nabledge-{v} directory as-is
    echo "Installing nabledge-${v} skill..."
    cp -r "$TEMP_DIR/$REPO_NAME/$plugin_dir/skills/nabledge-${v}" "$PROJECT_ROOT/.claude/skills/"

    # Copy CC-specific command
    echo "Setting up /n${v} command..."
    mkdir -p "$PROJECT_ROOT/.claude/commands"
    if [ -f "$TEMP_DIR/$REPO_NAME/$plugin_dir/commands/n${v}.md" ]; then
        cp "$TEMP_DIR/$REPO_NAME/$plugin_dir/commands/n${v}.md" "$PROJECT_ROOT/.claude/commands/n${v}.md"
        echo "Command installed: $PROJECT_ROOT/.claude/commands/n${v}.md"
    else
        echo "Warning: n${v}.md not found in plugin"
    fi

    # Verify installation
    echo "Verifying nabledge-${v} installation..."
    if [ ! -f "$PROJECT_ROOT/.claude/skills/nabledge-${v}/SKILL.md" ]; then
        echo "Error: Installation verification failed for nabledge-${v}"
        echo "SKILL.md not found at expected location"
        install_errors+=("nabledge-${v}")
        continue
    fi

    if [ ! -f "$PROJECT_ROOT/.claude/commands/n${v}.md" ]; then
        echo "Warning: /n${v} command not installed"
    fi

    if [ ! -d "$PROJECT_ROOT/.claude/skills/nabledge-${v}/knowledge" ]; then
        echo "Warning: knowledge/ directory not found for nabledge-${v}"
    fi

    if [ ! -d "$PROJECT_ROOT/.claude/skills/nabledge-${v}/workflows" ]; then
        echo "Warning: workflows/ directory not found for nabledge-${v}"
    fi

    echo "nabledge-${v} installed successfully!"
done

# Report errors
if [ ${#install_errors[@]} -gt 0 ]; then
    echo ""
    echo "Error: Installation failed for: ${install_errors[*]}"
    exit 1
fi

# Function to show completion message
show_completion_message() {
    local jq_warning="${1:-}"
    echo ""
    echo "Setup complete! The following skills are now available:"
    for v in "${VERSIONS[@]}"; do
        echo "  - nabledge-${v}: $PROJECT_ROOT/.claude/skills/nabledge-${v}"
    done
    echo ""
    if [ -n "$jq_warning" ]; then
        echo "IMPORTANT: Please install jq before using the skills."
    else
        echo "Claude Code will automatically recognize the skills without restart."
        echo "Commit the .claude/ directory to share these skills with your team."
        echo ""
        echo "Available commands:"
        for v in "${VERSIONS[@]}"; do
            echo "  - Type /nabledge-${v} or /n${v} followed by your question"
        done
    fi
}

# Check if jq is installed, if not, try to install it
if ! command -v jq &> /dev/null; then
    echo ""
    echo "jq is not installed. Nabledge skills require jq to run."
    echo "Attempting to install..."

    # Detect OS
    OS="$(uname -s)"
    case "$OS" in
        Linux*)
            echo "Detected Linux/WSL environment"
            echo ""
            echo "jq installation requires sudo privileges for apt-get."
            read -p "Install jq via apt-get? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                if sudo apt-get update && sudo apt-get install -y jq; then
                    echo "jq installed successfully!"
                else
                    echo "Warning: Failed to install jq"
                    echo "Please install manually: sudo apt-get install jq"
                    show_completion_message "jq_required"
                    exit 0
                fi
            else
                echo "Skipping jq installation."
                echo "Please install manually: sudo apt-get install jq"
                show_completion_message "jq_required"
                exit 0
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "Detected GitBash environment"
            echo "Downloading jq..."

            JQ_VERSION="1.7.1"
            JQ_URL="https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-win64.exe"
            JQ_SHA256="4dd97ea0d27b66e21a86e47c43e6c03ece7b3b9b8e68e2037be56b7eb2e77a0c"

            # Determine installation path
            if [ -w "/usr/bin" ]; then
                JQ_PATH="/usr/bin/jq.exe"
            else
                mkdir -p "$HOME/bin"
                JQ_PATH="$HOME/bin/jq.exe"
                export PATH="$HOME/bin:$PATH"
            fi

            # Download
            if ! curl -L -f -o "$JQ_PATH" "$JQ_URL"; then
                echo "Error: Failed to download jq"
                echo "Please install manually from: https://jqlang.github.io/jq/"
                show_completion_message "jq_required"
                exit 0
            fi

            # Verify checksum
            if ! echo "${JQ_SHA256}  ${JQ_PATH}" | sha256sum -c - 2>/dev/null; then
                echo "Warning: Could not verify jq checksum"
                echo "Please verify the download manually"
            fi

            chmod +x "$JQ_PATH"
            echo "jq installed successfully!"
            ;;
        Darwin*)
            echo "Detected macOS"
            echo "Please install jq manually:"
            echo "  brew install jq"
            show_completion_message "jq_required"
            exit 0
            ;;
        *)
            echo "Error: Unsupported OS: $OS"
            echo "Please install jq manually: https://jqlang.github.io/jq/download/"
            show_completion_message "jq_required"
            exit 0
            ;;
    esac

    # Verify installation
    if ! command -v jq &> /dev/null; then
        echo "Warning: Failed to install jq automatically"
        echo "Please install jq manually: https://jqlang.github.io/jq/download/"
        show_completion_message "jq_required"
        exit 0
    fi
fi

show_completion_message
