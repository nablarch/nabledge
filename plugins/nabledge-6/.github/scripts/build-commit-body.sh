#!/bin/bash
# Build commit body with trigger information
# Usage: build-commit-body.sh <repository> <commit-sha> <commit-body>

set -euo pipefail

REPOSITORY="${1:-}"
COMMIT_SHA="${2:-}"
COMMIT_BODY="${3:-}"

# Validate inputs
if [ -z "$REPOSITORY" ]; then
  echo "Error: Repository is required"
  exit 1
fi

if [ -z "$COMMIT_SHA" ]; then
  echo "Error: Commit SHA is required"
  exit 1
fi

# Build trigger URL
TRIGGER_COMMIT_URL="https://github.com/${REPOSITORY}/commit/${COMMIT_SHA}"

# Combine original message with trigger information
if [ -n "$COMMIT_BODY" ]; then
  FULL_BODY="${COMMIT_BODY}

---

Triggered by: ${TRIGGER_COMMIT_URL}"
else
  FULL_BODY="Triggered by: ${TRIGGER_COMMIT_URL}"
fi

# Output to GitHub environment file
{
  echo "FULL_COMMIT_BODY<<NABLEDGE_EOF_DELIMITER_FULL_BODY"
  echo "$FULL_BODY"
  echo "NABLEDGE_EOF_DELIMITER_FULL_BODY"
} >> "$GITHUB_ENV"
