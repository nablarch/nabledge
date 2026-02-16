#!/bin/bash
set -e

# Navigate to repository root (or current directory if not in git repo)
if git rev-parse --show-toplevel &>/dev/null; then
  PROJECT_ROOT="$(git rev-parse --show-toplevel)"
else
  PROJECT_ROOT="$(pwd)"
fi

echo "Setting up Nabledge-6 skill for GitHub Copilot..."
echo "Project root: $PROJECT_ROOT"

# Configuration (can be overridden with environment variables)
NABLEDGE_REPO="${NABLEDGE_REPO:-nablarch/nabledge}"
NABLEDGE_BRANCH="${NABLEDGE_BRANCH:-main}"

# Build repository URL
REPO_URL="https://github.com/${NABLEDGE_REPO}"
REPO_NAME="${NABLEDGE_REPO##*/}"
BRANCH="$NABLEDGE_BRANCH"
TEMP_DIR=$(mktemp -d)

echo "Repository: $NABLEDGE_REPO"
echo "Branch: $BRANCH"
echo "Downloading nabledge-6 plugin from $REPO_URL (branch: $BRANCH)..."
cd "$TEMP_DIR"
git clone --depth 1 --filter=blob:none --sparse --branch "$BRANCH" "$REPO_URL"
cd "$REPO_NAME"
git sparse-checkout set plugins/nabledge-6

# Create .claude/skills directory
echo "Creating .claude/skills directory..."
mkdir -p "$PROJECT_ROOT/.claude/skills"

# Copy skills/nabledge-6 directory as-is
echo "Copying nabledge-6 skill to project..."
cp -r "$TEMP_DIR/$REPO_NAME/plugins/nabledge-6/skills/nabledge-6" "$PROJECT_ROOT/.claude/skills/"

# Clean up
rm -rf "$TEMP_DIR"

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
            echo "Installing jq via apt-get (requires sudo)..."
            sudo apt-get update && sudo apt-get install -y jq
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "Detected GitBash environment"
            echo "Downloading jq..."
            JQ_URL="https://github.com/stedolan/jq/releases/latest/download/jq-win64.exe"
            JQ_PATH="/usr/bin/jq.exe"
            curl -L -o "$JQ_PATH" "$JQ_URL"
            chmod +x "$JQ_PATH"
            ;;
        Darwin*)
            echo "Detected macOS"
            echo "Please install jq manually:"
            echo "  brew install jq"
            echo ""
            echo "Setup complete! The nabledge-6 skill is now available in your project."
            echo "Location: $PROJECT_ROOT/.claude/skills/nabledge-6"
            echo ""
            echo "IMPORTANT: Please install jq before using the skill."
            exit 0
            ;;
        *)
            echo "Error: Unsupported OS: $OS"
            echo "Please install jq manually: https://stedolan.github.io/jq/download/"
            echo ""
            echo "Setup complete! The nabledge-6 skill is now available in your project."
            echo "Location: $PROJECT_ROOT/.claude/skills/nabledge-6"
            echo ""
            echo "IMPORTANT: Please install jq before using the skill."
            exit 0
            ;;
    esac

    # Verify installation
    if ! command -v jq &> /dev/null; then
        echo "Warning: Failed to install jq automatically"
        echo "Please install jq manually: https://stedolan.github.io/jq/download/"
        echo ""
        echo "Setup complete! The nabledge-6 skill is now available in your project."
        echo "Location: $PROJECT_ROOT/.claude/skills/nabledge-6"
        echo ""
        echo "IMPORTANT: Please install jq before using the skill."
        exit 0
    fi

    echo "jq installed successfully!"
fi

# Configure VS Code settings for GitHub Copilot skills
echo "Configuring VS Code settings for GitHub Copilot skills..."
mkdir -p "$PROJECT_ROOT/.vscode"

if [ -f "$PROJECT_ROOT/.vscode/settings.json" ]; then
    # Existing file - check if chat.useAgentSkills already exists
    if jq -e '.["chat.useAgentSkills"]' "$PROJECT_ROOT/.vscode/settings.json" > /dev/null 2>&1; then
        echo "chat.useAgentSkills setting already exists in .vscode/settings.json"
    else
        # Add setting to existing file
        jq '. + {"chat.useAgentSkills": true}' "$PROJECT_ROOT/.vscode/settings.json" > "$PROJECT_ROOT/.vscode/settings.json.tmp"
        mv "$PROJECT_ROOT/.vscode/settings.json.tmp" "$PROJECT_ROOT/.vscode/settings.json"
        echo "Added chat.useAgentSkills to existing .vscode/settings.json"
    fi
else
    # Create new file
    echo '{"chat.useAgentSkills": true}' | jq '.' > "$PROJECT_ROOT/.vscode/settings.json"
    echo "Created .vscode/settings.json with chat.useAgentSkills setting"
fi

echo ""
echo "Setup complete! The nabledge-6 skill is now available in your project."
echo "Location: $PROJECT_ROOT/.claude/skills/nabledge-6"
echo ""
echo "GitHub Copilot skills have been enabled in .vscode/settings.json"
echo "Commit .vscode/settings.json to share this configuration with your team."
echo ""
echo "You can now use nabledge-6 with GitHub Copilot by asking questions in natural language."
