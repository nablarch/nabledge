#!/bin/bash
# Usage: read-file.sh <filepath> [<filepath> ...]
# Outputs the content of each file with a header showing the path.

set -euo pipefail

if [[ $# -eq 0 ]]; then
    echo "Usage: read-file.sh <filepath> [<filepath> ...]" >&2
    exit 1
fi

for filepath in "$@"; do
    echo "=== $filepath ==="
    cat "$filepath"
    echo
done
