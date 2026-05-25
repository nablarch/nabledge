# Keyword Search Workflow

Keyword-based search using terms.json inverted index.

## Input

- `{keywords}`: List of search keywords (e.g., `UniversalDao`, `batchUpdate`, `ページング`)

## Output

Pointer JSON:
```json
{
  "results": [
    {"file": "processing-pattern/nablarch-batch/page.json", "section_id": "s1", "relevance": "partial"},
    {"file": "component/libraries/universal-dao.json", "section_id": "s3", "relevance": "partial"}
  ]
}
```

## Steps

### Step 1: Execute keyword search

**Tool**: Bash

```bash
bash scripts/keyword-search.sh <keyword1> [keyword2] ...
```

Replace `<keyword1>`, `[keyword2]` etc. with the keywords from `{keywords}`.

If `{keywords}` is empty, return `{"results": []}` immediately.

The script outputs a JSON array. Each element is:
```json
{
  "category": "processing-pattern/nablarch-batch",
  "pages": [
    {
      "page_title": "Nablarchバッチアーキテクチャ",
      "sections": [
        {"section_id": "processing-pattern/nablarch-batch/page.json:s1", "section_title": "起動方法"}
      ]
    }
  ]
}
```

Note: `section_id` in the script output is the full `"file_path:section_id"` form (e.g., `"processing-pattern/nablarch-batch/page.json:s1"`).

If the output is an empty array `[]`, return `{"results": []}` immediately.

### Step 2: Convert to pointer JSON

For each section entry in the script output:
- Split `section_id` on the **last** `:` to get `file` (e.g., `processing-pattern/nablarch-batch/page.json`) and `sid` (e.g., `s1`)
- Create entry: `{"file": file, "section_id": sid, "relevance": "partial"}`

Deduplicate by `(file, section_id)`.

Return:
```json
{
  "results": [/* converted entries */]
}
```
