#!/bin/bash
# Get hints for candidate knowledge sections
#
# Arguments: "relative-file-path:section-id" pairs separated by spaces
# Output: "file:section|hints" for each pair (comma-separated hints)
#
# Example:
#   get-hints.sh "component/libraries/libraries-universal_dao.json:s3" \
#                "component/libraries/libraries-database.json:s2"
#
# Output format:
#   component/libraries/libraries-universal_dao.json:s3|UniversalDao,DAO,database
#   component/libraries/libraries-database.json:s2|

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
KNOWLEDGE_DIR="$SKILL_DIR/knowledge"

if [ $# -eq 0 ]; then
  echo "Usage: $0 <file:section> [file:section] ..." >&2
  exit 1
fi

for pair in "$@"; do
  file="${pair%%:*}"
  section="${pair##*:}"

  # Validate file path doesn't escape knowledge directory
  case "$file" in
    /*|*../*) echo "Error: Invalid file path: $file" >&2; exit 1 ;;
  esac

  hints=$(jq -r --arg sec "$section" \
    '.index[] | select(.id == $sec) | .hints | join(",")' \
    "$KNOWLEDGE_DIR/$file" 2>/dev/null)
  echo "$file:$section|$hints"
done
