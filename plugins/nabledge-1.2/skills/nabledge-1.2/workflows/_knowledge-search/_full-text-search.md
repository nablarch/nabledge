# Full-Text Search

Run keyword OR search across all sections of all knowledge files.

## Input

Keyword list

## Output

List of matched sections (file, section_id)

### Output format

```
features/libraries/universal-dao.json|s3
features/libraries/universal-dao.json|s1
```

Each line: `relative-file-path|section-id`

## Steps

### Step 1: Run full-text search

**Tool**: Bash (`scripts/full-text-search.sh`)

**Action**: Execute `scripts/full-text-search.sh` and pass the keyword list as arguments.

**Command**:
```bash
bash .claude/skills/nabledge-1.2/scripts/full-text-search.sh "paging" "paging" "UniversalDao"
```

**Search rules**:

| Rule | Setting |
|---|---|
| Combination | OR (sections containing any keyword match) |
| Case sensitivity | Case-insensitive |
| Match type | Partial match |
| Search target | All sections of all knowledge files |
| Hit limit | None (filtered in section-judgement) |

**Output**: List of matched sections

## Error handling

| State | Action |
|---|---|
| 0 hits | Return empty result (caller falls back to route 2) |
| jq error | Log to stderr, skip that file and continue |
| 0 knowledge files | Return empty result |
