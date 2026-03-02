#!/bin/bash
# Capture and transform commit message for nabledge sync
# Usage: capture-commit-message.sh <commit-sha> <full-commit-message>

set -euo pipefail

COMMIT_SHA="${1:-}"
FULL_MESSAGE="${2:-}"

# Validate inputs
if [ -z "$COMMIT_SHA" ]; then
  echo "Error: Commit SHA is required"
  exit 1
fi

if [ -z "$FULL_MESSAGE" ]; then
  echo "Error: Commit message is required"
  exit 1
fi

# Split commit message into subject and body
# Subject is the first line, body is everything after the first blank line
COMMIT_SUBJECT=$(echo "$FULL_MESSAGE" | head -n 1)
COMMIT_BODY=$(echo "$FULL_MESSAGE" | tail -n +2 | sed '/^$/d' || echo "")

# Transform issue references from #123 to nablarch/nabledge-dev#123
# Pattern avoids double-transformation of already-transformed references
TRANSFORMED_SUBJECT=$(echo "$COMMIT_SUBJECT" | sed -E 's/(^|[^a-zA-Z0-9\/-])#([0-9]+)/\1nablarch\/nabledge-dev#\2/g')
TRANSFORMED_BODY=$(echo "$COMMIT_BODY" | sed -E 's/(^|[^a-zA-Z0-9\/-])#([0-9]+)/\1nablarch\/nabledge-dev#\2/g')

# Output to GitHub environment file
{
  echo "COMMIT_SUBJECT<<NABLEDGE_EOF_DELIMITER_SUBJECT"
  echo "$TRANSFORMED_SUBJECT"
  echo "NABLEDGE_EOF_DELIMITER_SUBJECT"
  echo "COMMIT_BODY<<NABLEDGE_EOF_DELIMITER_BODY"
  echo "$TRANSFORMED_BODY"
  echo "NABLEDGE_EOF_DELIMITER_BODY"
} >> "$GITHUB_ENV"
