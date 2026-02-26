#!/bin/bash
# Extract section hints from selected knowledge files
# Input: JSON with query, keywords, and files array (stdin or file)
# Output: JSON with sections array for agent scoring (stdout)

set -euo pipefail

# Read input JSON
if [ $# -eq 1 ]; then
  input=$(cat "$1")
else
  input=$(cat)
fi

# Extract query, keywords, and file paths
query=$(echo "$input" | jq -r '.query')
l1_keywords=$(echo "$input" | jq -c '.keywords.l1')
l2_keywords=$(echo "$input" | jq -c '.keywords.l2')
file_paths=$(echo "$input" | jq -r '.files[].path')

# Build sections array
sections=()
for file_path in $file_paths; do
  if [ ! -f "$file_path" ]; then
    continue
  fi

  # Extract all section IDs and hints from .index
  section_data=$(jq -r '.index[] | "\(.id)|\(.hints | join(","))"' "$file_path" 2>/dev/null || echo "")

  if [ -z "$section_data" ]; then
    continue
  fi

  # Convert to JSON objects
  while IFS='|' read -r section_id hints; do
    section_json=$(jq -n \
      --arg fp "$file_path" \
      --arg sid "$section_id" \
      --arg h "$hints" \
      '{
        file_path: $fp,
        section_id: $sid,
        hints: ($h | split(",")),
        relevance: 0,
        reasoning: ""
      }')
    sections+=("$section_json")
  done <<< "$section_data"
done

# Output JSON
jq -n \
  --arg q "$query" \
  --argjson l1 "$l1_keywords" \
  --argjson l2 "$l2_keywords" \
  --argjson secs "$(printf '%s\n' "${sections[@]}" | jq -s .)" \
  '{
    query: $q,
    keywords: {l1: $l1, l2: $l2},
    sections: $secs
  }'
