# QA Workflow

Question-answering workflow. Searches knowledge files for information relevant to the user's question and responds in Japanese.

## Input

User's question (natural Japanese text)

## Output

Answer in Japanese

## Steps

### Step 1: Call knowledge search

**Tool**: workflows/_knowledge-search.md

**Action**: Execute `workflows/_knowledge-search.md`. Pass the user's question as-is as input.

**Output**: Pointer JSON

**Branch**: If pointer JSON is empty (`results: []`), proceed to "No match response" in Step 3.

### Step 2: Read section content

**Tool**: Bash (scripts/read-sections.sh)

**Action**: Read section content from `results` in pointer JSON, in order from the top.

**Command**:
```bash
bash scripts/read-sections.sh \
  "features/handlers/common/db-connection-management-handler.json:setup" \
  "features/libraries/universal-dao.json:paging"
```

**Output format**:
```
=== features/handlers/common/db-connection-management-handler.json : setup ===
[section content]
=== END ===
=== features/libraries/universal-dao.json : paging ===
[section content]
=== END ===
```

**Reading rules**:
- Read high relevance sections first
- Max count: **10**

### Step 3: Generate answer

**Tool**: In-memory (LLM generation)

**Action**: Generate an answer in the following format based on the section content obtained in Step 2.

**Answer format** (output in Japanese to user):
```
**結論**: [direct answer to the question]

**根拠**: [code examples, configuration examples, specification information from knowledge files]

**注意点**: [constraints, limitations, common pitfalls]

参照: [knowledge-file-id#section-id]
```

**Answer rules**:
- Answer based **only** on information from knowledge files
- Do not fill in information not in knowledge files with inference
- Cite sources explicitly (e.g., `universal-dao.json#paging`)
- Target length: within 500 tokens (up to 800 tokens for complex questions)

**No match response** (when pointer JSON is empty):
```
この情報は知識ファイルに含まれていません。

関連する知識ファイル:
- [list title and path of entries from index.toon that may be related]
- [for entries with path "not yet created", show that fact]
```

**Important**: Do **not** provide alternative answers from LLM training data.
