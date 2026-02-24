#!/bin/bash
set -e
set -u
set -o pipefail

# Validate version consistency and increment before syncing to public repository
# Usage: ./validate-version-updates.sh

echo "Validating version consistency..."

# Get version from marketplace.json
MARKETPLACE_VERSION=$(jq -r '.metadata.version' .claude/marketplace/.claude-plugin/marketplace.json)
if [ -z "$MARKETPLACE_VERSION" ] || [ "$MARKETPLACE_VERSION" = "null" ]; then
  echo "Error: Could not read version from marketplace.json"
  exit 1
fi
echo "Marketplace version: $MARKETPLACE_VERSION"

# Get latest version from CHANGELOG.md
CHANGELOG_VERSION=$(grep -m 1 '^## \[' .claude/skills/nabledge-6/plugin/CHANGELOG.md | sed 's/^## \[\(.*\)\].*/\1/')
if [ -z "$CHANGELOG_VERSION" ]; then
  echo "Error: Could not read latest version from CHANGELOG.md"
  exit 1
fi
echo "CHANGELOG latest version: $CHANGELOG_VERSION"

# Check if versions match
if [ "$MARKETPLACE_VERSION" != "$CHANGELOG_VERSION" ]; then
  echo "Error: Version mismatch between marketplace.json ($MARKETPLACE_VERSION) and CHANGELOG.md ($CHANGELOG_VERSION)"
  exit 1
fi
echo "✓ Versions are consistent"

# Get latest tag from nablarch/nabledge repository
LATEST_TAG=$(gh api repos/nablarch/nabledge/tags --jq '.[0].name' 2>/dev/null || echo "")
if [ -z "$LATEST_TAG" ]; then
  echo "Warning: Could not fetch latest tag from nablarch/nabledge (repository might be empty)"
  echo "✓ Skipping version increment check"
else
  echo "Latest tag in nablarch/nabledge: $LATEST_TAG"

  # Compare versions (sort -V handles semantic versioning)
  HIGHER_VERSION=$(printf "%s\n%s" "$LATEST_TAG" "$MARKETPLACE_VERSION" | sort -V | tail -n 1)

  if [ "$HIGHER_VERSION" = "$LATEST_TAG" ]; then
    echo "Error: New version ($MARKETPLACE_VERSION) must be greater than latest tag ($LATEST_TAG)"
    exit 1
  fi
  echo "✓ Version is incremented properly"
fi

echo "Version validation completed successfully"
