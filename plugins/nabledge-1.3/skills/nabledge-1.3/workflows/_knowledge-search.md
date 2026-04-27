# Knowledge Search Workflow

Controls the entire knowledge search pipeline. Generates pointer JSON from a search query.

## Input

Search query (user's question or search request from a workflow)

## Output

Pointer JSON

### Pointer JSON schema

```json
{
  "results": [
    {
      "file": "features/handlers/common/db-connection-management-handler.json",
      "section_id": "s1",
      "relevance": "high"
    },
    {
      "file": "features/libraries/universal-dao.json",
      "section_id": "s2",
      "relevance": "partial"
    }
  ]
}
```

| Field | Type | Description |
|---|---|---|
| file | string | Relative path from knowledge directory |
| section_id | string | Section identifier (s1, s2, s3... format) |
| relevance | "high" \| "partial" | high: can directly answer / partial: partially relevant |

results sorted by relevance descending (high → partial). Empty array means no match.

## Steps

### Step 1: Keyword extraction

**Tool**: In-memory (agent judgment)

**Action**: Extract keywords effective for searching from the search query.

**Extraction criteria**:
- Japanese feature names and concept names (e.g., paging, transaction, batch processing)
- English technical terms (e.g., UniversalDao, DbConnectionManagementHandler)
- Class names, annotation names, property names
- Abbreviations and aliases (e.g., DAO, DB, NTF)

**Example**:
```
Question: "want to implement paging"
→ Keywords: ["paging", "paging", "UniversalDao", "DAO", "per", "page"]
```

**Rules**:
- Include both Japanese and English
- Include technical terms associated with the query intent
- Target 3-10 keywords

**Output**: Keyword list

### Step 2: Full-text search (route 1)

**Tool**: _knowledge-search/_full-text-search.md

**Action**: Execute `_knowledge-search/_full-text-search.md`. Input is the keyword list from Step 1.

**Output**: List of matched sections (file, section_id)

### Step 3: Branch decision

**Tool**: In-memory (agent judgment)

**Action**: Evaluate Step 2 results and decide next step.

**Decision criteria**:

| Hit count | Decision | Next step |
|---|---|---|
| 1 or more | Has hits | Step 6 (section judgement) |
| 0 | No hits | Step 4 (file selection → index-based search) |

### Step 4: File selection (route 2)

**Tool**: _knowledge-search/_file-search.md

**Action**: Execute `_knowledge-search/_file-search.md`. Input is the search query and index.toon.

**Output**: List of candidate files

**Branch**: If 0 candidate files, return empty pointer JSON and exit.

Empty pointer JSON: `{"results": []}`

### Step 5: Enumerate sections of candidate files (route 2)

**Tool**: Bash (jq)

**Action**: For each candidate file from Step 4, enumerate all sections to build the candidate section list. Section judgement (Step 6) reads each section content and decides relevance, so there is no pre-filter here.

**Command**:
```bash
for file in component/libraries/libraries-universal-dao.json \
            component/libraries/libraries-database.json; do
  jq -r --arg f "$file" '.sections[] | "\($f)|\(.id)"' \
    .claude/skills/nabledge-1.3/knowledge/"$file"
done
```

**Output**: List of candidate sections in `file|section_id` format

### Step 6: Section judgement (common)

**Tool**: _knowledge-search/_section-judgement.md

**Action**: Execute `_knowledge-search/_section-judgement.md`. Input is the candidate section list (from Step 2 or Step 5).

**Output**: Relevant sections (High/Partial)

### Step 7: Return pointer JSON

**Tool**: In-memory (agent assembles JSON)

**Action**: Convert relevant sections from Step 6 to pointer JSON format.

**Assembly rules**:
- Sort by relevance descending (high → partial)
- Within same relevance, sort by file path (stable order)
- No count limit (already filtered in Step 6)

**Output**: Pointer JSON
