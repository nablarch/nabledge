#!/bin/bash
set -e
set -u
set -o pipefail

# Create and push version tag if it doesn't exist
# Usage: ./create-version-tag.sh <version>
# Environment: Working directory should be the target repository

# Validate required parameters
VERSION="${1:-}"

if [ -z "$VERSION" ]; then
  echo "Error: Version required"
  echo "Usage: $0 <version>"
  exit 1
fi

TAG_NAME="${VERSION}"

echo "Processing version tag: ${TAG_NAME}"

# Check if tag already exists on remote
if git ls-remote --tags origin | grep -q "refs/tags/${TAG_NAME}"; then
  echo "Tag ${TAG_NAME} already exists on remote, skipping tag creation"
  exit 0
fi

# Create and push tag
echo "Creating tag: ${TAG_NAME}"
git tag -a "${TAG_NAME}" -m "Release version ${VERSION}"
git push origin "${TAG_NAME}"

echo "Successfully created and pushed tag: ${TAG_NAME}"
