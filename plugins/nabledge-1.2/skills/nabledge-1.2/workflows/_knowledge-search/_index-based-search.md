# Index-Based Search

Fallback route when full-text search returns no hits. Selects candidate files from `index.toon`, then enumerates their sections as candidates for judgement.

## Input

Search query + keyword list

## Output

List of candidate sections in `file|section_id` format

## Steps

### Step 1: File selection

**Tool**: _knowledge-search/_file-search.md

**Action**: Execute `_knowledge-search/_file-search.md`. Input is the search query and index.toon.

**Output**: List of candidate files

**Branch**: If 0 candidate files, return empty list and exit.

### Step 2: Enumerate sections of candidate files

**Tool**: Bash (jq)

**Action**: For each candidate file, enumerate all sections. Section judgement (the next common step) reads each section and decides relevance, so there is no pre-filter here.

**Command**:
```bash
for file in component/libraries/libraries-universal-dao.json \
            component/libraries/libraries-database.json; do
  jq -r --arg f "$file" '.sections[] | "\($f)|\(.id)"' \
    .claude/skills/nabledge-1.2/knowledge/"$file"
done
```

**Output**: List of candidate sections in `file|section_id` format

### Step 3: Return results

**Action**: Return the candidate section list from Step 2 to the caller.
