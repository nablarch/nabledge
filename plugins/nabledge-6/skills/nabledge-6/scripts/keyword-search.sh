#!/bin/bash
# Keyword search by full-text scanning all knowledge JSON files.
#
# - Case-insensitive partial match (substring) against section title and content
# - Multiple keywords: page-level AND, section-level OR
#   (page must have hits for ALL keywords; return all hit sections)
# - Minimum keyword length: 2
# - No result limit
#
# Arguments: keywords (one or more, each 2+ chars)
# Output: JSON — category > page > section hierarchy

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
KNOWLEDGE_DIR="${KNOWLEDGE_DIR:-$SKILL_DIR/knowledge}"

if [ $# -eq 0 ]; then
  echo "Usage: $0 <keyword1> [keyword2] ..." >&2
  exit 1
fi

python3 - "$KNOWLEDGE_DIR" "$@" << 'PYEOF'
import sys
import json
from collections import defaultdict
from pathlib import Path

knowledge_dir = Path(sys.argv[1])
keywords = [kw for kw in sys.argv[2:] if len(kw) >= 2]

if not keywords:
    print(json.dumps([], ensure_ascii=False))
    sys.exit(0)

keywords_lower = [kw.lower() for kw in keywords]


def section_matches(sec: dict, kw_lower: str) -> bool:
    title = sec.get("title", "").lower()
    content = sec.get("content", "").lower()
    return kw_lower in title or kw_lower in content


def page_matches(data: dict, kw_lower: str) -> bool:
    return any(section_matches(sec, kw_lower) for sec in data.get("sections", []))


results = []
json_files = sorted(knowledge_dir.rglob("*.json"))

for json_path in json_files:
    try:
        data = json.loads(json_path.read_text(encoding="utf-8"))
    except Exception:
        continue

    if data.get("no_knowledge_content"):
        continue

    rel_path = json_path.relative_to(knowledge_dir).as_posix()

    # Page-level AND: all keywords must hit somewhere in this file
    if not all(page_matches(data, kw) for kw in keywords_lower):
        continue

    # Section-level OR: collect sections that hit any keyword
    for sec in data.get("sections", []):
        sid = sec.get("id", "")
        if not sid:
            continue
        if any(section_matches(sec, kw) for kw in keywords_lower):
            path_parts = rel_path.split("/")
            category = "/".join(path_parts[:2]) if len(path_parts) >= 3 else path_parts[0]
            results.append({
                "section_id": f"{rel_path}:{sid}",
                "section_title": sec.get("title", ""),
                "page_title": data.get("title", ""),
                "page_path": rel_path,
                "category": category,
            })

cat_map = defaultdict(lambda: defaultdict(list))
for r in results:
    cat_map[r["category"]][(r["page_path"], r["page_title"])].append(r)

sorted_cats = sorted(cat_map.keys())

output = []
for cat in sorted_cats:
    pages = cat_map[cat]
    sorted_pages = sorted(pages.keys(), key=lambda p: (-len(pages[p]), p[1]))
    page_list = []
    for (page_path, page_title) in sorted_pages:
        secs = pages[(page_path, page_title)]
        sorted_secs = sorted(secs, key=lambda s: s["section_id"])
        section_list = [
            {"section_id": s["section_id"], "section_title": s["section_title"]}
            for s in sorted_secs
        ]
        page_list.append({"page_title": page_title, "sections": section_list})
    output.append({"category": cat, "pages": page_list})

print(json.dumps(output, ensure_ascii=False, indent=2))
PYEOF
