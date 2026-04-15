#!/bin/bash
# Record start time and session ID for code analysis duration tracking
#
# Usage: record-start.sh
# (no arguments; uses repo root automatically)
#
# Output (stdout):
#   Start time recorded: YYYY-MM-DD HH:MM:SS
#   Session ID: {millisecond_timestamp}-{PID}
#   Output directory: .nabledge/YYYYMMDD
#
# Side effects:
#   Creates .nabledge/YYYYMMDD/.nabledge-code-analysis-id    (session ID)
#   Creates .nabledge/YYYYMMDD/.nabledge-code-analysis-start-{UNIQUE_ID}  (epoch seconds)

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
OUTPUT_DIR="$REPO_ROOT/.nabledge/$(date '+%Y%m%d')"
mkdir -p "$OUTPUT_DIR"

UNIQUE_ID="$(date '+%s%3N')-$$"
echo "$UNIQUE_ID" > "$OUTPUT_DIR/.nabledge-code-analysis-id"
date '+%s' > "$OUTPUT_DIR/.nabledge-code-analysis-start-$UNIQUE_ID"

echo "Start time recorded: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Session ID: $UNIQUE_ID"
echo "Output directory: $OUTPUT_DIR"
