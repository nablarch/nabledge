#!/bin/bash
# 複数セクションの内容を一括読み出し
#
# 引数: "ファイル相対パス:セクションID" のペアをスペース区切り
# 出力: 各セクションの内容を区切り付きで出力
#
# 出力形式:
#   === ファイル相対パス : セクションID ===
#   [セクション内容]
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
