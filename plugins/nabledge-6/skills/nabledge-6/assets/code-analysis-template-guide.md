# Code Analysis Template Guide

This guide explains how to use the code analysis documentation template.

## Template File

**Location**: `.claude/skills/nabledge-6/assets/code-analysis-template.md`

The template provides a structured format for the generated documentation. See the template file for the complete structure with placeholders.

## Template Sections

1. **Header**: Target name, generation date/time, analysis duration, modules
2. **Overview**: Purpose and high-level architecture
3. **Architecture**: Mermaid class diagram + component summary table
4. **Flow**: Processing flow description + Mermaid sequence diagram
5. **Components**: Detailed analysis for each component
   - File location with relative link
   - Role description
   - Key methods with line references
   - Dependencies
   - Nablarch knowledge excerpts
   - Key implementation points
6. **Nablarch Framework Usage**: Framework-specific usage patterns
7. **References**: Links to source files, knowledge files, official docs

## Key Features

- **Mermaid diagrams**: Class diagram (relationships) and sequence diagram (timeline)
- **Relative links**: Links to source files and knowledge files use relative paths
- **Line references**: Method locations include line number ranges (e.g., `L42-58`)
- **Knowledge excerpts**: Relevant Nablarch knowledge quoted from knowledge files
- **Structured format**: Consistent sections across all analyses

## Placeholders

Replace the following placeholders with actual content (using `{{variable}}` format):

### Header Section

- `{{target_name}}`: Name of analyzed code/feature (e.g., "LoginAction", "ログイン機能")
- `{{generation_date}}`: Current date in YYYY-MM-DD format (e.g., "2026-02-10")
- `{{generation_time}}`: Current time in HH:MM:SS format (e.g., "14:30:15")
- `{{DURATION_PLACEHOLDER}}`: Placeholder for analysis duration (replaced by sed after Write completes)
  - Initial value: "{{DURATION_PLACEHOLDER}}" (literal string in template)
  - Final value: "約2分30秒", "約45秒", etc. (replaced by workflow Step 3.3-7)
- `{{target_description}}`: One-line description of the target
- `{{modules}}`: Affected modules (e.g., "proman-web, proman-common")

### Overview Section

- `{{overview_content}}`: Purpose and high-level architecture

### Architecture Section

- `{{dependency_graph}}`: Mermaid classDiagram syntax (class names only, show relationships)
- `{{component_summary_table}}`: Markdown table of components

### Flow Section

- `{{flow_content}}`: Request/response flow description text
- `{{flow_sequence_diagram}}`: Mermaid sequenceDiagram syntax (processing flow with timeline)

### Components Section

- `{{components_details}}`: Detailed analysis for each component (numbered sections)

### Nablarch Framework Usage Section

- `{{nablarch_usage}}`: Framework-specific usage patterns

### References Section

- `{{source_files_links}}`: List of source file links with relative paths
- `{{knowledge_base_links}}`: List of knowledge base links (`.claude/skills/nabledge-6/docs`)
- `{{official_docs_links}}`: List of official Nablarch documentation links

## Usage Instructions

### Step 1: Read the Template

Read the template file to understand the structure:

```bash
Read: .claude/skills/nabledge-6/assets/code-analysis-template.md
```

### Step 2: Build Content for Each Placeholder

Based on analysis results from workflow Steps 0-5, build content for each placeholder:

1. **Header placeholders**: Use current timestamp ({{DURATION_PLACEHOLDER}} stays as-is)
2. **Overview**: Summarize purpose and architecture
3. **Architecture diagrams**: Generate Mermaid classDiagram (class names only)
4. **Flow diagrams**: Generate Mermaid sequenceDiagram (with phases)
5. **Components**: Write detailed analysis with line references
6. **Nablarch usage**: Extract framework usage patterns
7. **References**: Build relative file path links

### Step 3: Replace Placeholders (except duration)

Replace all `{{variable}}` placeholders with actual content, EXCEPT {{DURATION_PLACEHOLDER}}.

**IMPORTANT**: Leave {{DURATION_PLACEHOLDER}} as-is. It will be replaced after Write completes.

### Step 4: Write Output File

Use Write tool to create the documentation file:

```
file_path: .nabledge/YYYYMMDD/code-analysis-<target>.md
content: [Generated documentation with {{DURATION_PLACEHOLDER}} still present]
```

### Step 5: Calculate and Replace Duration

**IMMEDIATELY after Write completes**:

**Step 5.1**: Get end time and calculate duration
```bash
date '+%Y-%m-%d %H:%M:%S'
```
- Calculate elapsed time from Step 0 start time
- Format as Japanese text (e.g., "約5分18秒")

**Step 5.2**: Replace placeholder using sed
```bash
sed -i 's/{{DURATION_PLACEHOLDER}}/約5分18秒/g' .nabledge/YYYYMMDD/code-analysis-<target>.md
```

**Error handling**:
- If sed fails, inform user of the calculated duration
- User can manually edit the file to replace {{DURATION_PLACEHOLDER}}
- The documentation remains valid even with the placeholder

**Why this matters**: This ensures the analysis duration includes all work including the Write operation itself, providing accurate timing that matches the "Baked for" time shown in the IDE.

## Example Placeholder Values

### Example: ExportProjectsInPeriodAction

```
{{target_name}} = "ExportProjectsInPeriodAction"
{{generation_date}} = "2026-02-10"
{{generation_time}} = "14:30:15"
{{analysis_duration}} = "約2分"
{{target_description}} = "期間内プロジェクト一覧出力バッチアクション"
{{modules}} = "proman-batch"
```

### {{component_summary_table}}

```markdown
| Component | Role | Type | Dependencies |
|-----------|------|------|--------------|
| ExportProjectsInPeriodAction | CSV出力バッチアクション | Action | DatabaseRecordReader, ObjectMapper, FilePathSetting |
| ProjectDto | プロジェクト情報DTO | Bean | なし |
| FIND_PROJECT_IN_PERIOD | 期間内プロジェクト検索SQL | SQL | なし |
```

### {{nablarch_usage}}

For each Nablarch component, include:
1. **クラス名**: Full class name
2. **説明**: Brief description
3. **使用方法**: Code example
4. **重要ポイント**: Critical points (why use, gotchas, performance)
5. **このコードでの使い方**: How it's used in analyzed code
6. **詳細**: Link to knowledge base

**Example**:

```markdown
### ObjectMapper

**クラス**: `nablarch.common.databind.ObjectMapper`

**説明**: CSVやTSV、固定長データをJava Beansとして扱う機能を提供する

**使用方法**:
\`\`\`java
ObjectMapper<ProjectDto> mapper = ObjectMapperFactory.create(ProjectDto.class, outputStream);
mapper.write(dto);
mapper.close();
\`\`\`

**重要ポイント**:
- ✅ **必ず`close()`を呼ぶ**: バッファをフラッシュし、リソースを解放する（`terminate()`で実施）
- ⚠️ **大量データ処理時**: メモリに全データを保持しないため、大量データでも問題なく処理可能
- ⚠️ **型変換の制限**: `EntityUtil`と同様に、型変換が必要な項目は個別設定が必要
- 💡 **アノテーション駆動**: `@Csv`, `@CsvFormat`でフォーマットを宣言的に定義できる

**このコードでの使い方**:
- `initialize()`でProjectDto用のObjectMapperを生成
- `handle()`で各レコードを`mapper.write(dto)`で出力
- `terminate()`で`mapper.close()`してリソース解放

**詳細**: [データバインド知識ベース](../../.claude/skills/nabledge-6/docs/features/libraries/data-bind.md)
```

### {{knowledge_base_links}}

```markdown
- [Nablarchバッチ処理](../../.claude/skills/nabledge-6/docs/features/processing/nablarch-batch.md) - BatchActionの詳細、DB to FILEパターン
- [データバインド](../../.claude/skills/nabledge-6/docs/features/libraries/data-bind.md) - ObjectMapperの詳細仕様
- [業務日付管理](../../.claude/skills/nabledge-6/docs/features/libraries/business-date.md) - BusinessDateUtilの使い方
- [ファイルパス管理](../../.claude/skills/nabledge-6/docs/features/libraries/file-path-management.md) - FilePathSettingの設定方法
```

### {{official_docs_links}}

```markdown
- [Nablarchバッチ処理](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/index.html)
- [データバインド](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/data_io/data_bind.html)
- [業務日付管理](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/system_utility/business_date.html)
```

## Tips

### Diagram Generation

**Class Diagram**:
- Keep it simple: class names only
- Use `--|>` for inheritance (extends/implements)
- Use `..>` for dependencies (uses/creates)
- Mark framework classes with `<<Nablarch>>` stereotype

**Sequence Diagram**:
- Use `participant` to define actors/components
- Use `->>` for synchronous calls
- Use `-->>` for return values
- Use `alt`/`else` for error handling
- Use `loop` for repetitive operations
- Add `Note` to explain phases

### Link Generation

Use relative paths from the output file location:

```
Output: .nabledge/20260210/code-analysis-login-action.md
Source: proman-web/src/main/java/com/nablarch/example/proman/web/action/LoginAction.java
Link: ../../proman-web/src/main/java/com/nablarch/example/proman/web/action/LoginAction.java
```

## See Also

- **Template File**: `assets/code-analysis-template.md`
- **Workflow**: `workflows/code-analysis.md`
- **Skill Definition**: `SKILL.md`
