# Keyword Search Workflow

Search knowledge base files using keyword matching and return candidate sections.

## Input

User's query (natural language)

## Output

JSON with candidate sections for section-judgement workflow

## Steps

### Step 1: Extract Keywords

Extract keywords at two levels from user's query:

- **L1 (Technical components)**: DAO, JDBC, UniversalDao, ValidationUtil, DataReader, etc.
- **L2 (Functional terms)**: ページング, 検索, 登録, 更新, 削除, 接続, etc.

Include Japanese, English, abbreviations, and related concepts.

**Example**:
- Query: "ページングを実装したい"
- L1: ["DAO", "UniversalDao", "O/Rマッパー"]
- L2: ["ページング", "paging", "per", "page", "limit", "offset"]

Create JSON:
```json
{
  "query": "ページングを実装したい",
  "keywords": {
    "l1": ["DAO", "UniversalDao", "O/Rマッパー"],
    "l2": ["ページング", "paging", "per", "page", "limit", "offset"]
  }
}
```

### Step 2: Match Files

**Script + Agent**: Parse index → Agent judges semantically

**Action**: Use script to parse index.toon into JSON, then agent matches semantically.

1. **Execute parse-index.sh** (mechanical parsing):
   ```bash
   .claude/skills/nabledge-6/scripts/parse-index.sh
   ```

   Output:
   ```json
   {
     "entries": [
       {"title": "ユニバーサルDAO", "hints": "データベース DAO O/Rマッパー...", "path": "features/..."},
       ...
     ]
   }
   ```

2. **Agent judges semantically** (flexible matching):
   - Read JSON output from script
   - For each entry, judge if hints semantically match L1/L2 keywords
   - **Prioritize flexible matching**:
     - Japanese/English variations (e.g., "ページング" ⇔ "paging")
     - Abbreviations (e.g., "DAO" ⇔ "UniversalDao")
     - Related terms (e.g., "検索" ⇔ "search", "retrieve", "find")
     - Synonyms and conceptually related terms
   - **Use semantic understanding**, not exact string matching

3. **Score files** (Agent calculates):
   - L1 keyword match: +2 points per matched hint
   - L2 keyword match: +1 point per matched hint
   - Sum scores for each file
   - Sort by score (descending)
   - Select top 10 files with score ≥ 2

**Output format** (for Step 3):
```json
{
  "query": "original query",
  "keywords": {"l1": [...], "l2": [...]},
  "files": [
    {"path": ".claude/skills/nabledge-6/knowledge/features/file1.json", "score": 5, "title": "Title"},
    ...
  ]
}
```

**Why this design**:
- Script: Mechanical parsing (fast, deterministic)
- Agent: Semantic matching (flexible, handles 表記揺れ)

### Step 3: Extract Section Hints

**Script**: Use extract-section-hints.sh (mechanical extraction)

**Action**: Extract section hints from selected files using script:

```bash
echo '<json_from_step2>' | .claude/skills/nabledge-6/scripts/extract-section-hints.sh
```

Script extracts `.index` field from each file and builds sections array.

**Output**:
```json
{
  "query": "...",
  "keywords": {"l1": [...], "l2": [...]},
  "sections": [
    {
      "file_path": ".claude/skills/nabledge-6/knowledge/features/...",
      "section_id": "paging",
      "hints": ["DAO", "ページング", "per", "page"],
      "relevance": 0,
      "reasoning": ""
    },
    ...
  ]
}
```

### Step 4: Score Section Relevance

**Agent**: Judge relevance semantically (judgment required)

**Action**: For each section in JSON from Step 3, judge relevance:

- Compare section hints with L1/L2 keywords
- Consider semantic overlap, not just exact matches
- Think about whether section would help answer the query

**Assign relevance score**:
- **3 (high)**: Multiple L1+L2 matches, directly answers query
- **2 (medium)**: Some L1 or L2 matches, partially relevant
- **1 (low)**: Weak keyword overlap, tangentially related
- **0 (not relevant)**: No meaningful keyword overlap

**Update JSON**: Add `relevance` and `reasoning` for each section

**Output**: Same JSON structure with scores filled in

### Step 5: Sort and Filter

**Script**: Use sort-sections.sh (mechanical sorting)

**Action**: Sort and filter using script:

```bash
echo '<json_from_step4>' | .claude/skills/nabledge-6/scripts/sort-sections.sh
```

Script performs:
- Sort by relevance (descending)
- Filter sections with relevance ≥ 2

**Output**: JSON with candidate sections for section-judgement workflow

Return this output to caller (knowledge-search.md).

## Error Handling

**No keyword matches** (Step 2 returns empty files array):
- Output message: "キーワードがマッチしませんでした"
- List extracted keywords
- Show available categories from index.toon

**No sections after filtering** (Step 5 returns empty sections array):
- Output message: "該当するセクションが見つかりませんでした"
- Return empty candidate list to caller
