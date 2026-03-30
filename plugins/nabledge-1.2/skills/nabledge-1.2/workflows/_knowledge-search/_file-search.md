# File Search

Select files relevant to the search query from index.toon.

## Input

Search query + index.toon

## Output

List of candidate files (paths, max 10)

### Output format

```
features/libraries/universal-dao.json
features/libraries/database-access.json
features/handlers/common/db-connection-management-handler.json
```

## Steps

### Step 1: Load index.toon

**Tool**: Read (load index.toon)

**Action**: Load index.toon.

**Command**:
```bash
# Use Read tool
Read knowledge/index.toon
```

### Step 2: Select candidate files

**Tool**: In-memory (agent judgment)

**Action**: Match index.toon content against the search query and select candidate files.

**Selection criteria (evaluate on 3 axes, any match qualifies as a candidate)**:

**Axis 1: Semantic matching with title**

Determine if the query intent is semantically related to the title.
- Example: "want to implement paging" → "UniversalDAO" has paging functionality, so it's a candidate
- Example: "how to launch batch" → "Nablarch Batch (on-demand/resident)" is a candidate

**Axis 2: Filtering by Type/Category**

Infer Type/Category from query intent and select matching files as candidates.

| Intent pattern | Inferred Type/Category |
|---|---|
| "want to implement ~" / "how to use ~" | component/libraries |
| "~ handler configuration" / "~ control" | component/handlers |
| "batch configuration" / "REST design" | processing-pattern |
| "how to test" | development-tools/testing-framework |
| "how to create a project" | setup/blank-project |
| "security check" | check/security-check |

**Axis 3: Filtering by processing_patterns**

When the query contains processing pattern context, select files with matching processing_patterns.
- Example: "DB connection in batch" → files containing `nablarch-batch`
- Example: "REST validation" → files containing `restful-web-service`

**Selection rules**:
- Max files: **10**
- Exclude `not yet created` files
- Select by total relevance across 3 axes, highest first
- Do not include clearly unrelated files

**Output**: List of candidate files

## Error handling

| State | Action |
|---|---|
| index.toon does not exist | Return error message |
| 0 candidates | Return empty list |
| All candidates are `not yet created` | Return empty list and append title of matching entries |
