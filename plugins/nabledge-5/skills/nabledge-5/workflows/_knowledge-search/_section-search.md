# Section Search

Match `index[].hints` of candidate files against keywords and select candidate sections.

## Input

List of candidate files + keyword list

## Output

List of candidate sections (file, section_id)

### Output format

```
features/libraries/universal-dao.json|paging
features/libraries/universal-dao.json|overview
```

Same format as full-text search output.

## Steps

### Step 1: Bulk extraction of section hints

**Tool**: Bash (jq)

**Action**: Extract `index[].hints` from candidate files in bulk.

**Command**:
```bash
KNOWLEDGE_DIR="$(cd "$(dirname "$0")/.." && pwd)/knowledge"  # when called from script

for file in features/libraries/universal-dao.json \
            features/libraries/database-access.json; do
  jq -r --arg f "$file" \
    '.index[] | "\($f)|\(.id)|\(.hints | join(","))"' \
    "$KNOWLEDGE_DIR/$file" 2>/dev/null
done
```

**Output example**:
```
features/libraries/universal-dao.json|overview|UniversalDao,DAO,O/R mapper,CRUD
features/libraries/universal-dao.json|paging|paging,paging,per,page,Pagination
```

### Step 2: Matching and scoring

**Tool**: In-memory (agent judgment)

**Action**: For each section's hints, perform partial match against each keyword in the keyword list.

**Matching logic**:
- Partial match (hints element contains keyword, or keyword contains hints element)
- Case-insensitive
- +1 point per matched keyword
- Sections with score **1 or more** become candidates

**Selection rules**:
- Max sections: **20**
- Select by descending score

**Output**: List of candidate sections

## Error handling

| State | Action |
|---|---|
| 0 candidate files | Return empty list |
| Section with empty hints | Skip |
| JSON read error | Skip that file |
