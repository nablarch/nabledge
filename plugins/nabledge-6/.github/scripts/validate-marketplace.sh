#!/bin/bash
set -e
set -u
set -o pipefail

# Validate marketplace directory structure and JSON formats
# Usage: ./validate-marketplace.sh <marketplace-root-directory>

# Validate required parameters
MARKETPLACE_ROOT="${1:-}"
if [ -z "$MARKETPLACE_ROOT" ]; then
  echo "Error: Marketplace root directory required"
  echo "Usage: $0 <marketplace-root-directory>"
  exit 1
fi

# Validate directory exists
if [ ! -d "$MARKETPLACE_ROOT" ]; then
  echo "Error: Marketplace root directory does not exist: $MARKETPLACE_ROOT"
  exit 1
fi

echo "Validating marketplace structure in: $MARKETPLACE_ROOT"

# Check marketplace files exist
echo "Checking marketplace files..."
test -f "$MARKETPLACE_ROOT/.claude-plugin/marketplace.json" || { echo "Error: marketplace.json not found"; exit 1; }
test -f "$MARKETPLACE_ROOT/README.md" || { echo "Error: Root README.md not found"; exit 1; }
test -f "$MARKETPLACE_ROOT/LICENSE" || { echo "Error: Root LICENSE not found"; exit 1; }

# Check nabledge-6 plugin structure
echo "Checking nabledge-6 plugin structure..."
test -f "$MARKETPLACE_ROOT/plugins/nabledge-6/.claude-plugin/plugin.json" || { echo "Error: nabledge-6/plugin.json not found"; exit 1; }
test -f "$MARKETPLACE_ROOT/plugins/nabledge-6/skills/nabledge-6/SKILL.md" || { echo "Error: nabledge-6/SKILL.md not found"; exit 1; }
test -f "$MARKETPLACE_ROOT/plugins/nabledge-6/README.md" || { echo "Error: nabledge-6/README.md not found"; exit 1; }
test -f "$MARKETPLACE_ROOT/plugins/nabledge-6/CHANGELOG.md" || { echo "Error: nabledge-6/CHANGELOG.md not found"; exit 1; }

# Check nabledge-6 supporting directories (inside skills/nabledge-6/)
echo "Checking nabledge-6 supporting directories..."
test -d "$MARKETPLACE_ROOT/plugins/nabledge-6/skills/nabledge-6/workflows" || { echo "Error: nabledge-6/skills/nabledge-6/workflows not found"; exit 1; }
test -d "$MARKETPLACE_ROOT/plugins/nabledge-6/skills/nabledge-6/assets" || { echo "Error: nabledge-6/skills/nabledge-6/assets not found"; exit 1; }
test -d "$MARKETPLACE_ROOT/plugins/nabledge-6/skills/nabledge-6/knowledge" || { echo "Error: nabledge-6/skills/nabledge-6/knowledge not found"; exit 1; }
test -d "$MARKETPLACE_ROOT/plugins/nabledge-6/skills/nabledge-6/docs" || { echo "Error: nabledge-6/skills/nabledge-6/docs not found"; exit 1; }

# Check setup scripts exist at root
echo "Checking setup scripts..."
test -f "$MARKETPLACE_ROOT/setup-6-cc.sh" || { echo "Error: setup-6-cc.sh not found at root"; exit 1; }
test -f "$MARKETPLACE_ROOT/setup-6-ghc.sh" || { echo "Error: setup-6-ghc.sh not found at root"; exit 1; }

# Validate JSON formats
echo "Validating JSON formats..."
jq empty "$MARKETPLACE_ROOT/.claude-plugin/marketplace.json" || { echo "Error: Invalid marketplace.json"; exit 1; }
jq empty "$MARKETPLACE_ROOT/plugins/nabledge-6/.claude-plugin/plugin.json" || { echo "Error: Invalid plugin.json"; exit 1; }

# Validate marketplace.json structure
echo "Validating marketplace.json structure..."
jq -e '.name' "$MARKETPLACE_ROOT/.claude-plugin/marketplace.json" > /dev/null || { echo "Error: marketplace.json missing 'name' field"; exit 1; }
jq -e '.plugins' "$MARKETPLACE_ROOT/.claude-plugin/marketplace.json" > /dev/null || { echo "Error: marketplace.json missing 'plugins' array"; exit 1; }

# Validate plugin.json structure
echo "Validating plugin.json structure..."
jq -e '.name' "$MARKETPLACE_ROOT/plugins/nabledge-6/.claude-plugin/plugin.json" > /dev/null || { echo "Error: plugin.json missing 'name' field"; exit 1; }
jq -e '.version' "$MARKETPLACE_ROOT/plugins/nabledge-6/.claude-plugin/plugin.json" > /dev/null || { echo "Error: plugin.json missing 'version' field"; exit 1; }

echo "Marketplace structure validation passed!"
