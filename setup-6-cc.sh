#!/bin/bash
set -e

# Navigate to repository root (or current directory if not in git repo)
if git rev-parse --show-toplevel &>/dev/null; then
  PROJECT_ROOT="$(git rev-parse --show-toplevel)"
else
  PROJECT_ROOT="$(pwd)"
fi

echo "Setting up Nabledge-6 plugin for Claude Code..."
echo "Project root: $PROJECT_ROOT"

# Configuration (can be overridden with environment variables)
NABLEDGE_REPO="${NABLEDGE_REPO:-nablarch/nabledge}"
NABLEDGE_BRANCH="${NABLEDGE_BRANCH:-main}"

# Parse repository owner and name from NABLEDGE_REPO
REPO_OWNER="${NABLEDGE_REPO%/*}"
REPO_NAME="${NABLEDGE_REPO#*/}"
BRANCH="$NABLEDGE_BRANCH"
MARKETPLACE_NAME="nabledge"
PLUGIN_NAME="nabledge-6"

echo "Repository: $NABLEDGE_REPO"
echo "Branch: $BRANCH"

# Create .claude directory if it doesn't exist
mkdir -p "$PROJECT_ROOT/.claude"

SETTINGS_FILE="$PROJECT_ROOT/.claude/settings.json"

# Check if jq is installed, if not, try to install it
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Attempting to install..."

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
            exit 1
            ;;
        *)
            echo "Error: Unsupported OS: $OS"
            echo "Please install jq manually: https://stedolan.github.io/jq/download/"
            exit 1
            ;;
    esac

    # Verify installation
    if ! command -v jq &> /dev/null; then
        echo "Error: Failed to install jq"
        exit 1
    fi

    echo "jq installed successfully!"
fi

# Initialize settings.json if it doesn't exist
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Creating new settings.json..."
    echo '{}' > "$SETTINGS_FILE"
fi

# Read current settings
CURRENT_SETTINGS=$(cat "$SETTINGS_FILE")

# Build marketplace configuration
MARKETPLACE_CONFIG=$(jq -n \
  --arg repo "$REPO_OWNER/$REPO_NAME" \
  --arg branch "$BRANCH" \
  '{
    "source": {
      "source": "github",
      "repo": $repo,
      "ref": $branch
    }
  }')

# Build plugin configuration
PLUGIN_KEY="${PLUGIN_NAME}@${MARKETPLACE_NAME}"

# Merge configurations
UPDATED_SETTINGS=$(echo "$CURRENT_SETTINGS" | jq \
  --arg marketplace_name "$MARKETPLACE_NAME" \
  --argjson marketplace_config "$MARKETPLACE_CONFIG" \
  --arg plugin_key "$PLUGIN_KEY" \
  '
  .extraKnownMarketplaces = (.extraKnownMarketplaces // {}) |
  .extraKnownMarketplaces[$marketplace_name] = $marketplace_config |
  .enabledPlugins = (.enabledPlugins // {}) |
  .enabledPlugins[$plugin_key] = true
  ')

# Write updated settings
echo "$UPDATED_SETTINGS" > "$SETTINGS_FILE"

echo ""
echo "Setup complete! The nabledge-6 plugin configuration has been added to:"
echo "$SETTINGS_FILE"
echo ""
echo "Next steps:"
echo "1. Commit .claude/settings.json to your repository"
echo "2. When team members clone the repository and start Claude Code,"
echo "   they will be prompted to install the marketplace and plugin"
echo ""
echo "You can verify the configuration with:"
echo "  cat $SETTINGS_FILE"
