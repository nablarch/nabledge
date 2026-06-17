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

## Phase A: Select pages from index.md

1. Read `knowledge/index.md` (relative to skill root). Save content as `index_content`.
2. Read the question. Write one sentence: what does the user want to know?
3. Extract constraints: if the question contains `（処理方式: X）`, note X as the processing type constraint. If it contains `（目的: X）`, note X as the purpose.
4. For each page in `index_content`, apply this decision procedure and collect all candidates:
   - Does this page cover the exact feature, component, or topic the question is asking about? → **candidate**
   - Does this page cover a feature that directly solves the technical problem in the question? → **candidate**
   - Does this page cover the processing type in the question (if one was specified)? → **candidate**; if it covers a *different* processing type → **skip**
   - All other pages → **skip**
5. If a purpose was noted, sort candidates using the priority categories for that purpose: pages in the priority categories come first.

   | 目的 | Priority categories |
   |------|-------------------|
   | 実装したい | processing-pattern/*, component/libraries, component/adapters |
   | 仕組み・動作を理解したい | component/handlers, component/libraries, component/adapters, about/about-nablarch |
   | 不具合・エラーを調査したい | component/handlers, component/libraries, processing-pattern/* |
   | テストを書きたい | development-tools/testing-framework, component/libraries |
   | バージョンアップしたい | about/migration, releases/releases, about/release-notes |
   | セキュリティ対応したい | check/security-check, component/handlers, processing-pattern/* |

6. Take up to 10 candidates in order. Save the selected page paths (relative to `knowledge/`) as `index_pages`. If no candidates exist, `index_pages = []`.

---

## Phase B: Select pages from classes.md

`classes.md` indexes each page by the **class names** it documents. Use it to reach pages whose relevance is expressed through a class the question implies but does not name.

1. Read `knowledge/classes.md`. Save content as `classes_content`. Each entry has the form:
   ```
   ### <page title>
   path: <page path>
   - <ClassName>
   - <ClassName>
   ```
2. From the question (and any noted processing type / purpose), list the Nablarch **concepts or operations** involved (e.g. "JSONボディ変換", "ルーティング", "排他制御"). The question usually does **not** contain class names — derive the concepts, not literal strings.
3. For each page entry in `classes_content`, apply this decision procedure:
   - Does any class listed under this page implement, handle, or directly relate to a concept from step 2? → **candidate**
   - If a processing type constraint was noted and this page clearly belongs to a *different* processing type → **skip**
   - Otherwise → **skip**
4. When judging step 3, reason from the class's evident responsibility (inferable from its name and the page title), not from a string match against the question. Example: when the question asks about a concept (e.g. a kind of data conversion, transaction handling, or validation), a page whose listed class clearly performs that responsibility is a candidate — even when the question never names that class.
5. Take up to 10 candidates. Save the selected page paths (relative to `knowledge/`) as `class_pages`. If none, `class_pages = []`.

---

## Phase C: Merge pages

1. Concatenate `index_pages` then `class_pages`.
2. Deduplicate by page path, keeping first occurrence (index order, then class order).
3. Keep at most 20 pages. Save as `merged_pages`.
4. For each page in `merged_pages`, record its `source`: `"index"` if it appears only in `index_pages`, `"classes"` if it appears only in `class_pages`, `"both"` if it appears in both. Determine this from actual set membership, not from reasoning about the question.
5. If `merged_pages` is empty, return `{"selected_sections": []}` immediately and stop.

---

## Phase D: Select sections

For each path in `merged_pages` (up to 20):
1. Read `knowledge/{path}`.
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

Collect all high sections first. Fill remaining slots with partial sections until the total reaches 20. If 20 high sections already exist, add no partial sections.

Save as `selected_sections`.

---

## Phase E: Augment with referenced Javadoc

After Phase D, scan the `content` of every section already in `selected_sections`
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
- Note: the caller (qa.md Step 4) reads at most 12 entries total, counting both
  body sections and Javadoc together. Javadoc does not get a separate budget.
- Deduplicate by Javadoc path: never add the same file twice.
- Only follow links matching `../javadoc/javadoc-*.json`. Ignore external URLs
  (`http(s)://...`) and non-Javadoc internal links.
- If a referenced Javadoc file does not exist, skip it silently (do not fail).

Return:
```json
{
  "selected_sections": [
    {"file": "<path relative to knowledge/>", "section_id": "sN", "relevance": "high|partial"}
  ]
}
```

Results sorted by relevance descending (high → partial).
