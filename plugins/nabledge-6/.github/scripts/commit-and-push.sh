#!/bin/bash
set -e
set -u
set -o pipefail

# Commit and push changes to repository
# Usage: ./commit-and-push.sh <commit-message> [commit-body] [branch]
# Environment: Working directory should be the target repository

# Validate required parameters
COMMIT_MESSAGE="${1:-}"
COMMIT_BODY="${2:-}"
BRANCH="${3:-main}"

if [ -z "$COMMIT_MESSAGE" ]; then
  echo "Error: Commit message required"
  echo "Usage: $0 <commit-message> [commit-body] [branch]"
  exit 1
fi

echo "Preparing to commit changes..."

# Configure git user
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

# Stage all changes
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
  echo "No changes to commit"
  exit 0
fi

# Create commit with message and optional body
if [ -n "$COMMIT_BODY" ]; then
  git commit -m "$COMMIT_MESSAGE" -m "$COMMIT_BODY"
else
  git commit -m "$COMMIT_MESSAGE"
fi

# Push to origin
echo "Pushing to origin ${BRANCH}..."
git push origin "${BRANCH}"

echo "Changes committed and pushed successfully to ${BRANCH}"
