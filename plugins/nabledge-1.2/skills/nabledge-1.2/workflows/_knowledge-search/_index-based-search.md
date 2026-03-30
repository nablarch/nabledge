# Index-Based Search

Fallback route when full-text search returns no hits. Executes file-search.md followed by section-search.md.

## Input

Search query + keyword list

## Output

List of candidate sections

## Steps

### Step 1: File selection

**Tool**: _knowledge-search/_file-search.md

**Action**: Execute `_knowledge-search/_file-search.md`. Input is the search query and index.toon.

**Output**: List of candidate files

**Branch**: If 0 candidate files, return empty list and exit.

### Step 2: Section selection

**Tool**: _knowledge-search/_section-search.md

**Action**: Execute `_knowledge-search/_section-search.md`. Input is the candidate file list from Step 1 and the keyword list.

**Output**: List of candidate sections

### Step 3: Return results

**Action**: Return the candidate section list from Step 2 to the caller.
