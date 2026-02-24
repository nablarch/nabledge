# Keyword Search Workflow

This workflow searches the knowledge index (index.toon) using keyword matching to find relevant files and sections.

## Table of Contents

- [Overview](#overview)
- [Search process](#search-process)
  - [Step 1: Extract keywords and match against index](#step-1-extract-keywords-and-match-against-index)
  - [Step 2: Extract candidate sections](#step-2-extract-candidate-sections)
  - [Step 3: Judge relevance and return results](#step-3-judge-relevance-and-return-results)
- [Error handling](#error-handling)
- [Example execution](#example-execution)
- [Notes](#notes)

## Overview

**Who executes**: Claude Code (you)

**Input**: User's request (natural language)

**Output**: Candidates list for section-judgement workflow

**Strategy**: Technical axis - match keywords from the request against search hints in index.toon

**Tools you will use**:
- Read tool: Read knowledge/index.toon
- Grep tool (optional): Search for keywords in index.toon
- Bash tool with jq: Batch extract .index from knowledge files

**Expected tool calls**: 3-5 calls (reduced from 10-15 via batch processing)

**Expected output**: 20-30 candidate sections

## Search process

### Step 1: Extract keywords and match against index

**Tools**: Read tool

**Action**: Extract keywords from the user request at three levels, then read index.toon and match keywords against hints.

**Keyword extraction at 3 levels**:

1. **Technical domain** (技術領域): データベース, バッチ, ハンドラ, Web, REST, テスト, etc.
2. **Technical component** (技術要素): DAO, JDBC, JPA, Bean Validation, JSON, XML, etc.
3. **Functional** (機能): ページング, 検索, 登録, 更新, 削除, 接続, コミット, etc.

**Example**: Request "ページングを実装したい"
- Technical domain: ["データベース", "database"]
- Technical component: ["DAO", "UniversalDao", "O/Rマッパー"]
- Functional: ["ページング", "paging", "per", "page", "limit", "offset"]

**Critical**: Include Japanese and English terms, abbreviations, and related concepts at all levels.

**Matching process**:

1. Read knowledge/index.toon (93 entries, format: `Title, hint1 hint2 ..., path.json`)
2. For each entry, match your extracted keywords against hints using this **scoring strategy**:
   - L1 (Technical domain) or L2 (Technical component) keyword match: **+2 points** per hint
   - L3 (Functional) keyword match: **+1 point** per hint
   - Case-insensitive matching
   - Partial matching allowed (e.g., "ページ" matches "ページング")
   - Sum up all matched hint scores for each entry
3. Sort files by total score (descending)
4. Select top 10-15 files with score ≥2

**Rationale**: L1+L2 keywords indicate the technical domain/component, which is more reliable for file selection. L3 keywords provide additional context but are weighted lower to avoid over-matching on functional terms that may appear across many files.

**Output**: List of candidate files with their scores and matched hints breakdown.

### Step 2: Extract candidate sections

**Tools**: Bash with jq

**Action**: Batch process all 10-15 selected files in a single bash script to reduce tool calls.

**Batch processing script example**:
```bash
# Batch extract .index from all selected files
# Input: Array of file paths with scores from Step 1
# Output: Candidates list with file_path, section_id, score, matched_hints

for file in knowledge/features/libraries/universal-dao.json \
            knowledge/features/web/handlers.json \
            knowledge/features/database/database-access.json; do
  # Extract .index field
  jq -r --arg file "$file" '.index | to_entries[] | "\($file)|\(.key)|\(.value.hints | join(","))"' "$file" 2>/dev/null
done | while IFS='|' read -r filepath section hints; do
  # Score each section by matching L2/L3 keywords against hints
  score=0
  matched=""

  # L2 keywords matching (+2 points each)
  for kw in "${l2_keywords[@]}"; do
    if echo "$hints" | grep -iq "$kw"; then
      score=$((score + 2))
      matched="$matched,$kw(L2)"
    fi
  done

  # L3 keywords matching (+2 points each)
  for kw in "${l3_keywords[@]}"; do
    if echo "$hints" | grep -iq "$kw"; then
      score=$((score + 2))
      matched="$matched,$kw(L3)"
    fi
  done

  # Output sections with score ≥2
  if [ $score -ge 2 ]; then
    echo "$filepath|$section|$score|${matched:1}"  # ${matched:1} removes leading comma
  fi
done | sort -t'|' -k3 -rn | head -30
```

**Note**: The script assumes `l2_keywords` and `l3_keywords` arrays are defined from Step 1 keyword extraction. Example:
```bash
l2_keywords=("DAO" "UniversalDao" "O/Rマッパー")
l3_keywords=("ページング" "paging" "per" "page" "limit" "offset")
```

**Scoring strategy** (implemented in the batch script):
- L2 (Technical component) keyword match: **+2 points** per hint
- L3 (Functional) keyword match: **+2 points** per hint
- L1 (Technical domain) keywords are **not scored** (too broad for section-level matching)
- Case-insensitive matching, partial matching allowed
- Sum up all matched hint scores for each section
- Keep sections with score ≥2
- Limit to top 20-30 candidates

**Key advantages of batch processing**:
- **Reduced tool calls**: 10-15 individual jq calls → 1 batch script call
- **Consistent scoring**: All sections scored in single execution context
- **Efficient sorting**: Use unix sort to rank candidates by score
- **Early termination**: Stop at 30 candidates without processing remaining files

**Rationale**: At section level, both technical components (L2) and specific functions (L3) are equally important for identifying the right content. L1 keywords are too broad for section discrimination.

**Output**: List of candidates with file_path, section_id, score, and matched_hints breakdown.

### Step 3: Judge relevance and return results

**Action**: Pass the candidates list to section-judgement workflow (workflows/section-judgement.md):

```json
{
  "candidates": [
    {
      "file_path": "features/libraries/universal-dao.json",
      "section": "paging",
      "score": 7,
      "matched_hints": [
        {"hint": "DAO", "level": "L2", "points": 2},
        {"hint": "ページング", "level": "L3", "points": 2},
        {"hint": "per", "level": "L3", "points": 2},
        {"hint": "page", "level": "L3", "points": 1}
      ]
    }
  ]
}
```

**Note**: The detailed score breakdown is optional for section-judgement. A simplified format with just `matched_hints: ["DAO", "ページング", "per", "page"]` is also acceptable.

Section-judgement will:
- Read actual section content
- Judge relevance (High=2, Partial=1, None=0)
- Filter out None-relevance sections
- Return 5-15 relevant sections with scores

Use the returned sections to answer the user's question (knowledge files only).

## Error handling

**No keyword matches**: Inform user, list extracted keywords, show available categories from index.toon.

**Too many candidates (>30)**: Select files with 2+ matched hints, limit to top 15 files and 30 sections.

**Section-judgement returns no results**: State "この情報は知識ファイルに含まれていません", show available knowledge from index.toon. DO NOT answer from LLM training data.

## Example execution

**Request**: "ページングを実装したい"

**Extract keywords at 3 levels**:
- Level 1 (Technical domain): ["データベース", "database"]
- Level 2 (Technical component): ["DAO", "UniversalDao", "O/Rマッパー"]
- Level 3 (Functional): ["ページング", "paging", "per", "page", "limit", "offset"]

**Step 1**: Match against index.toon with scoring
- universal-dao.json: score=7 (データベース[L1]:2 + DAO[L2]:2 + O/Rマッパー[L2]:2 + ページング[L3]:1)
- database-access.json: score=2 (データベース[L1]:2)
- Top files selected: universal-dao.json, database-access.json

**Step 2**: Extract sections with scoring
- universal-dao/paging: score=7 (DAO[L2]:2 + ページング[L3]:2 + per[L3]:2 + page[L3]:1)
- universal-dao/overview: score=4 (DAO[L2]:2 + O/Rマッパー[L2]:2)
- universal-dao/crud: score=2 (DAO[L2]:2)
- Candidates: paging (score=7), overview (score=4), crud (score=2)

**Step 3**: Section-judgement → paging judged as High (2), overview as Partial (1), crud as None (0)

**Result**: 1 primary section (paging) with pagination API and examples

## Notes

- Technical axis search (keyword matching) complements intent-search (purpose-oriented search)
- Uses Read tool for index.toon and Bash+jq for extracting section indexes
- Final relevance scoring happens in section-judgement workflow
- Expected output: 5-15 relevant sections filtered by section-judgement

**Scoring strategy rationale**:

| Stage | L1 Weight | L2 Weight | L3 Weight | Rationale |
|-------|-----------|-----------|-----------|-----------|
| **File selection** | +2 | +2 | +1 | L1/L2 identify technical domain/component (primary discriminator). L3 provides context (secondary). |
| **Section selection** | 0 | +2 | +2 | L2/L3 identify specific technology/function (equal importance). L1 too broad for section-level. |

**Why weighted scoring?**:
- **Deterministic**: Same input always produces same scores (no ambiguous judgment)
- **Flexible**: Handles edge cases (L3-only matches get lower scores but aren't excluded)
- **Debuggable**: Score breakdown makes it clear why files/sections were selected
- **L2 acts as bridge**: Used in both stages with high weight, ensuring continuity between file→section selection

**Threshold settings**:
- File selection: ≥2 points ensures at least 1 L1 or L2 match
- Section selection: ≥2 points ensures at least 1 L2 or L3 match
