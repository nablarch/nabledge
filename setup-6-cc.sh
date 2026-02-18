#!/bin/bash
set -e

# Navigate to repository root (or current directory if not in git repo)
if git rev-parse --show-toplevel &>/dev/null; then
  PROJECT_ROOT="$(git rev-parse --show-toplevel)"
else
  PROJECT_ROOT="$(pwd)"
fi

echo "Setting up Nabledge-6 skill for Claude Code..."
echo "Project root: $PROJECT_ROOT"

# Configuration (can be overridden with environment variables)
NABLEDGE_REPO="${NABLEDGE_REPO:-nablarch/nabledge}"
NABLEDGE_BRANCH="${NABLEDGE_BRANCH:-main}"

# Build repository URL
REPO_URL="https://github.com/${NABLEDGE_REPO}"
REPO_NAME="${NABLEDGE_REPO##*/}"
BRANCH="$NABLEDGE_BRANCH"
TEMP_DIR=$(mktemp -d)

# Ensure cleanup on exit
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "Repository: $NABLEDGE_REPO"
echo "Branch: $BRANCH"
echo "Downloading nabledge-6 skill from $REPO_URL (branch: $BRANCH)..."
cd "$TEMP_DIR"
git clone --depth 1 --filter=blob:none --sparse --branch "$BRANCH" "$REPO_URL"
cd "$REPO_NAME"
git sparse-checkout set plugins/nabledge-6

# Verify repository structure
if [ ! -d "plugins/nabledge-6" ]; then
    echo "Error: plugins/nabledge-6 directory not found in repository"
    echo "Repository structure may have changed."
    echo "Please report this issue at: https://github.com/nablarch/nabledge/issues"
    exit 1
fi

# Create .claude/skills directory
echo "Creating .claude/skills directory..."
mkdir -p "$PROJECT_ROOT/.claude/skills"

# Copy skills/nabledge-6 directory as-is
echo "Copying nabledge-6 skill to project..."
cp -r "$TEMP_DIR/$REPO_NAME/plugins/nabledge-6/skills/nabledge-6" "$PROJECT_ROOT/.claude/skills/"

# Verify installation
echo "Verifying installation..."
if [ ! -f "$PROJECT_ROOT/.claude/skills/nabledge-6/SKILL.md" ]; then
    echo "Error: Installation verification failed"
    echo "SKILL.md not found at expected location"
    exit 1
fi

if [ ! -d "$PROJECT_ROOT/.claude/skills/nabledge-6/knowledge" ]; then
    echo "Warning: knowledge/ directory not found"
fi

if [ ! -d "$PROJECT_ROOT/.claude/skills/nabledge-6/workflows" ]; then
    echo "Warning: workflows/ directory not found"
fi

echo "Installation verified successfully!"

# Function to show completion message
show_completion_message() {
    local jq_warning="${1:-}"
    echo ""
    echo "Setup complete! The nabledge-6 skill is now available in your project."
    echo "Location: $PROJECT_ROOT/.claude/skills/nabledge-6"
    echo ""
    if [ -n "$jq_warning" ]; then
        echo "IMPORTANT: Please install jq before using the skill."
    else
        echo "Claude Code will automatically recognize the skill without restart."
        echo "Commit the .claude/skills/ directory to share this skill with your team."
        echo ""
        echo "You can now use nabledge-6 with Claude Code by typing /nabledge-6"
    fi
}

# Check if jq is installed, if not, try to install it
if ! command -v jq &> /dev/null; then
    echo ""
    echo "jq is not installed. The nabledge-6 skill requires jq to run."
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
