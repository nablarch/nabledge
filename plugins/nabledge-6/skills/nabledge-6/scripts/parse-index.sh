#!/bin/bash
# Parse index.toon and output JSON for agent matching
# Input: None
# Output: JSON with all entries

set -euo pipefail

index_file=".claude/skills/nabledge-6/knowledge/index.toon"

# Parse index.toon and extract entries
awk '
BEGIN {
  in_files=0
  count=0
  print "{"
  print "  \"entries\": ["
}

/^files\[/ {
  in_files=1
  next
}

in_files && /^  [^ ]/ {
  # Parse line: Title, hints, path
  line=$0
  sub(/^  /, "", line)

  # Split by comma
  split(line, parts, ", ")

  if (length(parts) >= 3) {
    title = parts[1]
    hints = parts[2]
    path = parts[3]

    # Escape quotes
    gsub(/"/, "\\\"", title)
    gsub(/"/, "\\\"", hints)
    gsub(/"/, "\\\"", path)

    # Print JSON entry
    if (count > 0) print "    ,"
    printf "    {\n"
    printf "      \"title\": \"%s\",\n", title
    printf "      \"hints\": \"%s\",\n", hints
    printf "      \"path\": \"%s\"\n", path
    printf "    }"
    count++
  }
}

END {
  print ""
  print "  ]"
  print "}"
}
' "$index_file"
