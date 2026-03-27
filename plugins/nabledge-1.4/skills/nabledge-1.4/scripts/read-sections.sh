#!/bin/bash
# Read multiple sections in bulk
#
# Arguments: "relative-file-path:section-id" pairs separated by spaces
# Output: content of each section with delimiters
#
# Output format:
#   === relative-file-path : section-id ===
#   [section content]
#   === END ===

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

  echo "=== $file : $section ==="
  jq -r --arg sec "$section" '.sections[$sec] // "SECTION_NOT_FOUND"' "$KNOWLEDGE_DIR/$file" 2>/dev/null || echo "FILE_NOT_FOUND"
  echo "=== END ==="
done
