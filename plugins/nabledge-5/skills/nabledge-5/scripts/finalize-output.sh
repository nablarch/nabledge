#!/bin/bash
# Calculate analysis duration and replace {{DURATION_PLACEHOLDER}} in output file
#
# Usage: finalize-output.sh <target-name> <date-dir>
#   target-name: Target class/feature name (e.g., "ImportZipCodeFileAction")
#   date-dir:    Output date directory (e.g., "20260210")
#
# Output (stdout):
#   Duration: approx. Xs  (or "approx. Xm Ys")
#
# Side effects:
#   Replaces {{DURATION_PLACEHOLDER}} in .nabledge/<date-dir>/code-analysis-<target>.md
#   Removes session temp files from .nabledge/<date-dir>/

if [ $# -ne 2 ]; then
  echo "Usage: $0 <target-name> <date-dir>" >&2
  exit 1
fi

TARGET_NAME="$1"
DATE_DIR="$2"

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
OUTPUT_DIR="$REPO_ROOT/.nabledge/$DATE_DIR"

# Retrieve session ID from Step 0
UNIQUE_ID=$(cat "$OUTPUT_DIR/.nabledge-code-analysis-id" 2>/dev/null || echo "")

# Get current time
end_time=$(date '+%s')

# Calculate duration with error handling
START_TIME_FILE="$OUTPUT_DIR/.nabledge-code-analysis-start-$UNIQUE_ID"
if [ -z "$UNIQUE_ID" ] || [ ! -f "$START_TIME_FILE" ]; then
  echo "WARNING: Start time file not found. Duration will be set to 'unknown'." >&2
  duration_text="unknown"
else
  start_time=$(cat "$START_TIME_FILE")
  duration_seconds=$((end_time - start_time))

  if [ "$duration_seconds" -lt 60 ]; then
    duration_text="approx. ${duration_seconds}s"
  else
    minutes=$((duration_seconds / 60))
    seconds=$((duration_seconds % 60))
    duration_text="approx. ${minutes}m ${seconds}s"
  fi
fi

# Replace placeholder in output file
OUTPUT_FILE="$OUTPUT_DIR/code-analysis-${TARGET_NAME}.md"
if [ -f "$OUTPUT_FILE" ]; then
  sed -i "s|{{DURATION_PLACEHOLDER}}|${duration_text}|g" "$OUTPUT_FILE"
else
  echo "WARNING: Output file not found: $OUTPUT_FILE" >&2
fi

# Clean up temp files
rm -f "$START_TIME_FILE"
rm -f "$OUTPUT_DIR/.nabledge-code-analysis-id"

echo "Duration: $duration_text"
