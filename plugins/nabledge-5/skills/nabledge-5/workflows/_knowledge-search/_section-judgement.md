# Section Judgement

Read candidate section content and judge relevance to the search query. Common workflow called from both full-text search (route 1) and index-based search (route 2).

## Input

- List of candidate sections in `file:section_id` format (colon-separated)
  - **Note**: `full-text-search.sh` outputs `file|section_id` (pipe-separated). Convert `|` to `:` before passing here.
  - Example: `component/libraries/libraries-universal_dao.json|s3` → `component/libraries/libraries-universal_dao.json:s3`
- Search keyword list (in caller's memory; used in Step 0)

## Output

List of relevant sections (file, section_id, relevance)

### Output format

```
file: features/libraries/universal-dao.json, section_id: s3, relevance: high
file: features/libraries/universal-dao.json, section_id: s1, relevance: partial
```

Caller converts to pointer JSON.

## Steps

### Step A: Bulk read candidate section content

**Tool**: Bash (`scripts/read-sections.sh`)

**Action**: Read candidate section content in bulk. Retrieve all section content in a single tool call. Split into 2-3 calls if there are many candidates (max ~10 sections per call).

**Command**:
```bash
bash .claude/skills/nabledge-5/scripts/read-sections.sh "features/libraries/universal-dao.json:s3" "features/libraries/universal-dao.json:s1" "features/libraries/database-access.json:s2"
```

**Output**: Body text of each section

### Step B: Judge relevance of each section

**Tool**: In-memory (agent judgment)

**Action**: Read section content and judge.

**Judgment criteria**:

| Judgment | Condition | Example |
|---|---|---|
| **High** | Contains information that **directly answers** the search query. Has concrete actionable content such as method names, configuration examples, code examples, or procedures | For "how to implement paging": a section with usage examples of `per()`, `page()` methods and code |
| **Partial** | Contains **prerequisite knowledge, related features, or contextual information**. Not a direct answer but necessary for understanding | For "how to implement paging": a section explaining basic UniversalDao usage (prerequisite knowledge) |
| **None** | **Unrelated** to the search query | For "how to implement paging": a section explaining log output configuration |

**Judgment procedure**:
1. Does this section contain information that directly answers the search query? → YES: **High** / NO: next
2. Does this section contain prerequisite knowledge or related information needed to understand the query? → YES: **Partial** / NO: **None**

**When uncertain**: If torn between High and Partial, choose **Partial** (conservative judgment).

### Step C: Filter and sort

**Tool**: In-memory (agent judgment)

**Action**: Filter and sort judgment results.

**Processing**:
- Exclude None
- Sort High → Partial
- Within same relevance, sort by file path

**Output**: List of relevant sections

## Early termination conditions

| Condition | Behavior |
|---|---|
| Sections read reaches **20** | Stop processing remaining candidates |
| **5** High sections found | Stop processing remaining candidates |
| Whichever condition is reached first | Stop processing |

## Error handling

| State | Action |
|---|---|
| 0 candidate sections | Return empty list |
| Section content is `SECTION_NOT_FOUND` | Skip that section |
| All sections judged None | Return empty list |
