# Semantic Search Workflow

Searches knowledge files and returns relevant sections for the question.

## Input

- `{question}`: User's question.

## Output

Pointer JSON:
```json
{
  "selected_sections": [
    {"file": "processing-pattern/nablarch-batch/page.json", "section_id": "s1", "relevance": "high"},
    {"file": "component/libraries/universal-dao.json", "section_id": "s3", "relevance": "partial"}
  ]
}
```

---

## Step 1: Read index.md

Read `knowledge/index.md` (relative to skill root). Save content as `index_content`.

---

## Step 2: Select pages

1. Read the question. Write one sentence: what does the user want to know?
2. Extract constraints: if the question contains `（処理方式: X）`, note X as the processing type constraint. If it contains `（目的: X）`, note X as the purpose.
3. For each page in the index, apply this decision procedure and collect all candidates:
   - Does this page cover the exact feature, component, or topic the question is asking about? → **candidate**
   - Does this page cover a feature that directly solves the technical problem in the question? → **candidate**
   - Does this page cover the processing type in the question (if one was specified)? → **candidate**; if it covers a *different* processing type → **skip**
   - All other pages → **skip**
4. If a purpose was noted, sort candidates using the priority categories for that purpose: pages in the priority categories come first.

   | 目的 | Priority categories |
   |------|-------------------|
   | 実装したい | processing-pattern/*, component/libraries, component/adapters |
   | 仕組み・動作を理解したい | component/handlers, component/libraries, about/about-nablarch |
   | 不具合・エラーを調査したい | component/handlers, component/libraries, processing-pattern/* |
   | テストを書きたい | development-tools/testing-framework, component/libraries |
   | バージョンアップしたい | releases/releases, about/release-notes |
   | セキュリティ対応したい | check/security-check, component/handlers, processing-pattern/* |

5. Take up to 10 candidates in order. If fewer than 3 candidates exist, do not pad. If no candidates exist, return `{"selected_sections": []}` immediately.
6. Save the selected page paths (relative to knowledge/) as `selected_pages`.

---

## Step 3: Select sections

For each path in `selected_pages` (up to 10):
1. Read `knowledge/{path}`
2. For each section, apply this decision procedure:
   - Ask: "Would a reader answering this question be unable to give a complete answer without this section?" → **high**
   - Ask: "Does this section provide background or configuration that a reader would need when using a high section — and that cannot be inferred from the high sections alone?" → **partial**
   - Otherwise → **skip**

   Always skip:
   - Sections with only general overview and no specific information
   - Module lists, revision histories, and other boilerplate
   - Sections that only restate information already present in a selected high section
   - Sections that contain only concept definitions with no implementation details
   - Sections that explain the same information as a high section from a different angle

Collect all high sections first. Fill remaining slots with partial sections until the total reaches 30. If 30 high sections already exist, add no partial sections.

Return:
```json
{
  "selected_sections": [
    {"file": "<path relative to knowledge/>", "section_id": "sN", "relevance": "high|partial"}
  ]
}
```

---

## Step 4: Augment with referenced Javadoc

After Step 3, scan the `content` of every section already in `selected_sections`
for internal Javadoc links of the form `[text](../javadoc/javadoc-*.json)`.

For each unique Javadoc path found:
1. Resolve it to `knowledge/javadoc/javadoc-*.json` (the link path is already
   `.json`; no extension rewriting is needed).
2. Add it to `selected_sections` with `relevance` inherited from the section
   that referenced it (a Javadoc referenced from a high section is high; from a
   partial section is partial). If the same Javadoc is referenced from both,
   keep the higher relevance.

Limits and guards:
- Add at most 10 Javadoc files in total across all selected sections (not per
  section). If more than 10 distinct Javadoc links exist, keep those referenced
  from high sections first, then partial, in document order.
- Deduplicate by Javadoc path: never add the same file twice.
- Only follow links matching `../javadoc/javadoc-*.json`. Ignore external URLs
  (`http(s)://...`) and non-Javadoc internal links.
- If a referenced Javadoc file does not exist, skip it silently (do not fail).

---

Results sorted by relevance descending (high → partial).
