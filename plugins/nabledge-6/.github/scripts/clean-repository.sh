#!/bin/bash
set -e
set -u
set -o pipefail

# Remove all files except .git/ from target repository
# Usage: ./clean-repository.sh <target-directory>

# Validate required parameters
TARGET_DIR="${1:-}"
if [ -z "$TARGET_DIR" ]; then
  echo "Error: Target directory required"
  echo "Usage: $0 <target-directory>"
  exit 1
fi

# Validate target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Target directory does not exist: $TARGET_DIR"
  exit 1
fi

echo "Cleaning repository: $TARGET_DIR"

# Change to target directory
cd "$TARGET_DIR"

# Remove all files except .git/
find . -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

echo "Repository cleaned successfully"
