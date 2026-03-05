#!/bin/bash
# 全知識ファイルの全セクションに対してキーワードOR検索を実行
#
# 引数: キーワード（1つ以上）
# 出力: ヒットしたファイルとセクションIDの一覧（スコア降順、上位15件）
# 出力形式: ファイル相対パス|セクションID

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
KNOWLEDGE_DIR="$SKILL_DIR/knowledge"
MAX_RESULTS=15

if [ $# -eq 0 ]; then
  echo "Usage: $0 <keyword1> [keyword2] ..." >&2
  exit 1
fi

# 引数からjqの個別カウント式を組み立てる
count_exprs=""
for kw in "$@"; do
  if [ -n "$count_exprs" ]; then
    count_exprs="$count_exprs + "
  fi
  escaped=$(echo "$kw" | sed 's/[.[\\(*+?{|^$]/\\&/g')
  count_exprs="${count_exprs}(if test(\"$escaped\"; \"i\") then 1 else 0 end)"
done

# 全JSONファイルに対して検索し、スコア付きで出力 → スコア降順ソート → 上位N件
find "$KNOWLEDGE_DIR" -name "*.json" | sort | while read -r filepath; do
  relpath="${filepath#$KNOWLEDGE_DIR/}"
  jq -r --arg file "$relpath" \
    '.sections | to_entries[] |
     (.value | '"$count_exprs"') as $score |
     select($score > 0) |
     "\($score)\t\($file)|\(.key)"' \
    "$filepath" 2>/dev/null
done | sort -t$'\t' -k1 -rn | head -n "$MAX_RESULTS" | cut -f2
