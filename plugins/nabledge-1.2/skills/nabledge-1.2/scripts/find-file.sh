#!/bin/bash
# Usage: find-file.sh <filename-pattern> [<filename-pattern> ...]
# Searches for files matching any of the given patterns from cwd.
# Outputs matching paths one per line. Exits 0 even if no files found.

set -euo pipefail

if [[ $# -eq 0 ]]; then
    echo "Usage: find-file.sh <pattern> [<pattern> ...]" >&2
    exit 1
fi

for pattern in "$@"; do
    find . -name "$pattern" -not -path '*/.git/*' 2>/dev/null
done
