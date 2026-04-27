#!/bin/bash
# Run keyword OR search across all sections of all knowledge files
#
# Arguments: keywords (one or more)
# Output: list of matching files and section IDs (score descending, top 15)
# Output format: relative-file-path|section-id

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
KNOWLEDGE_DIR="$SKILL_DIR/knowledge"
MAX_RESULTS=15

if [ $# -eq 0 ]; then
  echo "Usage: $0 <keyword1> [keyword2] ..." >&2
  exit 1
fi

# Build jq count expression for each keyword argument
count_exprs=""
for kw in "$@"; do
  if [ -n "$count_exprs" ]; then
    count_exprs="$count_exprs + "
  fi
  escaped=$(echo "$kw" | sed 's/[.[\\(*+?{|^$]/\\&/g')
  count_exprs="${count_exprs}(if test(\"$escaped\"; \"i\") then 1 else 0 end)"
done

# Search all JSON files, output with score → sort descending by score → take top N
find "$KNOWLEDGE_DIR" -name "*.json" | sort | while read -r filepath; do
  relpath="${filepath#$KNOWLEDGE_DIR/}"
  jq -r --arg file "$relpath" \
    '.sections[] |
     ((.title + " " + .content) | '"$count_exprs"') as $score |
     select($score > 0) |
     "\($score)\t\($file)|\(.id)"' \
    "$filepath" 2>/dev/null
done | sort -t$'\t' -k1 -rn | head -n "$MAX_RESULTS" | cut -f2
