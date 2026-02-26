# Section Judgement Workflow

Judge relevance of candidate sections by reading content.

## Input

JSON with candidate sections from keyword-search workflow

## Output

JSON with relevant sections (High and Partial only) for knowledge-search workflow

## Steps

### Step 1: Read Section Content

For each candidate section:

```bash
jq -r '.sections[<section_id>]' <file_path>
```

Extract only the specified section content. Do not read entire file.

### Step 2: Judge Relevance

Stop after reading 10 sections or finding 5 High-relevance sections, whichever comes first.

For each section read, judge relevance based ONLY on section content:

**High (2)**: Section directly addresses goal AND contains actionable information (methods, examples, configuration)

**Partial (1)**: Section provides prerequisite knowledge, related functionality, or context

**None (0)**: Section addresses different topic

When in doubt between High and Partial, choose Partial.

### Step 3: Filter and Output

**Script**: Use sort-sections.sh with threshold=1 (mechanical sorting)

```bash
echo '<json_from_step2>' | .claude/skills/nabledge-6/scripts/sort-sections.sh 1
```

Script performs:
- Filter: relevance >= 1 (removes None)
- Sort: by relevance descending (High first, then Partial)

**Output**: JSON with filtered and sorted sections for knowledge-search workflow

## Validation

Validate output JSON:
- Contains filtered sections with relevance ≥ 1
- Sorted by relevance (High first, then Partial)
- Ready for knowledge-search workflow to generate answer
