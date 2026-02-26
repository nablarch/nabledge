#!/bin/bash
# Sort sections by relevance score and filter threshold
# Usage: sort-sections.sh [threshold] < input.json
# Input: JSON with sections array (stdin or file)
# Output: JSON with sorted, filtered sections (stdout)
# Default threshold: 2

set -euo pipefail

# Parse arguments
THRESHOLD=2
INPUT_FILE=""

while [ $# -gt 0 ]; do
  case "$1" in
    [0-9]*)
      THRESHOLD="$1"
      shift
      ;;
    *)
      INPUT_FILE="$1"
      shift
      ;;
  esac
done

# Read input JSON
if [ -n "$INPUT_FILE" ]; then
  input=$(cat "$INPUT_FILE")
else
  input=$(cat)
fi

# Sort by relevance (descending) and filter relevance >= threshold
echo "$input" | jq --argjson threshold "$THRESHOLD" '{
  query: .query,
  keywords: .keywords,
  sections: (.sections | sort_by(-.relevance) | map(select(.relevance >= $threshold)))
}'
