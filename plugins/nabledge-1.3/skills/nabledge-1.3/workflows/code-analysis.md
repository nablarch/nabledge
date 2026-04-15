# Code Analysis Workflow

Analyze existing code, trace dependencies, generate structured documentation.

## Overview

**Purpose**:
1. Identify target code and trace dependencies
2. Search relevant Nablarch knowledge
3. Generate documentation

**Input**: User's request (target code specification)

**Output**: Documentation file (Markdown + Mermaid diagrams) in .nabledge/YYYYMMDD/

**Tools**: Read, Bash with jq, Write

## Process flow

> **Bash usage: restricted commands only**
> For file operations (search, read, grep), always use Bash scripts — never raw `find`, `ls`, or `grep` commands.

### Confirm analysis target (required before Step 0)

**Tool**: AskUserQuestion

Check whether the user's invocation explicitly names a specific class or file.

- If specified → save as `target` and proceed to Step 0
- If not specified → ask now, do not proceed until the user answers:

  "解析対象のクラスまたはファイルを指定してください (例: ImportZipCodeFileAction)"

  Save the user's answer as `target`.

**Do NOT infer or assume a target from context, history, or file system.**

---

### Step 0: Record start time (CRITICAL)

**Tool**: Bash

**Action** - Store start time with unique session ID in output directory.

```bash
bash .claude/skills/nabledge-1.3/scripts/record-start.sh
```

**Output example**:
```
Start time recorded: 2026-02-10 14:54:00
Session ID: 1707559440123-12345
Output directory: .nabledge/20260210
```

**IMPORTANT**:
- Session ID stored in: `.nabledge/YYYYMMDD/.nabledge-code-analysis-id`
- Start time stored in: `.nabledge/YYYYMMDD/.nabledge-code-analysis-start-$UNIQUE_ID`
- UNIQUE_ID format: `{millisecond_timestamp}-{process_PID}`
- Epoch time (seconds since 1970) for accurate duration calculation
- Step 3.5 reads session ID from output directory
- Files stored in same directory as code analysis output
- All intermediate and final outputs must stay in .nabledge/YYYYMMDD/ directory

**Why this matters**: `{{analysis_duration}}` placeholder must contain actual elapsed time. Users compare against "Cooked for X" time in IDE.

---

### Step 1: Identify target and analyze dependencies

**Prerequisite**: `target` must be set from the "Confirm analysis target" step above.

**Tools**: Bash (find-file.sh, read-file.sh)

**Action**:

1. **Parse `target`** to understand target scope:
   - Specific class (e.g., "LoginAction")
   - Specific feature (e.g., "login feature")
   - Package (e.g., "under web.action")

2. **Find target files**:
   ```bash
   bash .claude/skills/nabledge-1.3/scripts/find-file.sh "<TargetClass>.java"
   ```
   Replace `<TargetClass>` with the actual class name from `target`. Add more patterns if multiple files are needed (e.g., `"*Form.java"`).

3. **Read target files** (pass paths from step 2):
   ```bash
   bash .claude/skills/nabledge-1.3/scripts/read-file.sh "<path/to/file.java>"
   ```
   Replace `<path/to/file.java>` with the actual path(s) returned by find-file.sh. Pass paths exactly as output (e.g., `./src/main/java/Foo.java`) — do not modify or normalize the path.

4. **Read target files** and extract dependencies:
   - Imports → External dependencies
   - Field types, method parameters → Direct dependencies
   - Method calls → Behavioral dependencies

5. **Classify dependencies**:
   - Project code (proman-*): Trace further
   - Nablarch framework: Note for knowledge search
   - JDK/Java EE: Note but don't trace
   - Third-party libraries: Note but don't trace

6. **Determine trace depth** (ask user if unclear):
   - Default: Trace project code until reaching framework/entities/utilities
   - Stop at Nablarch framework boundaries
   - Stop at Entity classes (pure data objects)

7. **Build dependency graph** (mental model):
   ```
   LoginAction
   ├─→ LoginForm (Form, validation)
   ├─→ SystemAccountEntity (Entity, data)
   ├─→ UniversalDao (Nablarch, database access)
   └─→ ExecutionContext (Nablarch, request context)
   ```

8. **Categorize components** by role:
   - Action/Controller, Form, Entity, Service/Logic, Utility, Handler, Configuration

9. **Identify Nablarch components** for knowledge search:
   - UniversalDao, ValidationUtil, ExecutionContext, Handler chain, etc.

10. **Extract key concepts** for knowledge search:
    - Technical terms: DAO, transaction, handler
    - Operations: search, register, update, validation
    - Patterns: CRUD, pagination, error handling

**Output**: Target files list, dependency graph, component list with Nablarch components identified

### Step 2: Search Nablarch knowledge

**Tools**: Bash (scripts/full-text-search.sh, scripts/read-sections.sh)

**Action**: Search relevant knowledge for all Nablarch components identified in Step 1.

**Search process**:

1. **Collect search keywords** from Step 1 analysis:
   - Use Nablarch component names identified in Step 1 as search keywords
   - Include class names, Japanese feature names, and related technical terms
   - Example: ["UniversalDao", "ExecutionContext", "ValidationUtil", "validation", "transaction"]

2. **Execute full-text search**:
   ```bash
   bash .claude/skills/nabledge-1.3/scripts/full-text-search.sh "UniversalDao" "ExecutionContext" "ValidationUtil" "validation" "transaction"
   ```
   - Output: Scored and ranked candidate sections (max 15 results)

3. **Execute section judgement**:
   - Read `workflows/_knowledge-search/_section-judgement.md`
   - Before passing candidates: convert pipe separators to colons (`file|section_id` → `file:section_id`)
   - Follow the workflow with candidate sections from step 2
   - Output: Filtered sections (High and Partial relevance only)

4. **Collect knowledge file basenames** for Step 3.2:
   - Extract unique knowledge files from section-judgement output
   - Use basenames only (filename without path and extension)
   - Example: `libraries-universal_dao,libraries-data_bind`
   - prefill-template.sh will automatically search and include all matches
   - Deduplicate: Multiple sections may come from same file
   - Format as comma-separated list for --knowledge-files parameter

5. **Collect knowledge content** for documentation:
   - Use `scripts/read-sections.sh` to read High-relevance sections
   - Collect: API usage patterns, configuration requirements, code examples, best practices

**Output**: Knowledge file basenames for Step 3.2, and relevant knowledge content for documentation

### Step 3: Generate and output documentation

**Tools**: Read (template files), Bash (prefill script, mermaid script), Write

**Action**:

#### 3.1: Read template and guide

**MUST READ FIRST** (use single cat command for efficiency):
```bash
cat .claude/skills/nabledge-1.3/assets/code-analysis-template.md \
    .claude/skills/nabledge-1.3/assets/code-analysis-template-guide.md
```

**Note**: Template examples are inlined in Step 3.4 below. Do NOT read code-analysis-template-examples.md.

**Extract from templates**:
- All `{{placeholder}}` variables
- Section structure and order (DO NOT deviate)
- Component Summary Table format
- Nablarch Usage structure with important points (✅ ⚠️ 💡 🎯 ⚡)
- Link generation rules (relative paths + line references)

#### 3.2: Pre-fill deterministic placeholders

**Tool**: Bash

**Action**: Execute prefill script to pre-populate 9 deterministic placeholders.

```bash
bash .claude/skills/nabledge-1.3/scripts/prefill-template.sh --target-name "<target-name>" --target-desc "<one-line-description>" --modules "<module1, module2>" --source-files "File1.java,File2.java" --knowledge-files "libraries-universal_dao,libraries-data_bind"
```

After the script completes, find the `Output: <path>` line in the result and save that path as `OUTPUT_PATH`.

**Parameters**:
- `target-name`: Target code name (e.g., "LoginAction")
- `target-desc`: One-line description (e.g., "login authentication processing")
- `modules`: Affected modules (e.g., "proman-web, proman-common")
- `source-files`: Comma-separated source file basenames from Step 1
  - Example: "LoginAction.java,LoginForm.java"
  - **Important**: Pass basenames only (e.g., 'File.java'). Script handles paths defensively but workflows should use basenames.
  - Script searches from project root and includes all matches
  - If multiple files found, directory path added to labels for disambiguation
- `knowledge-files`: Comma-separated knowledge file basenames from Step 2
  - Example: "libraries-universal_dao,libraries-data_bind" (extension .json is optional)
  - **Important**: Pass basenames without extension (e.g., 'universal-dao'). Script handles paths and .json extension defensively but workflows should use basenames.
  - Script searches in .claude/skills/nabledge-1.3/knowledge/ and includes all matches
  - Automatically converts .json paths to .md paths
  - If multiple files found, category path added to labels for disambiguation

**Automatic behavior**:
- **Output path**: Script automatically generates output path: `.nabledge/YYYYMMDD/code-analysis-<target-name>.md`
- **Official docs**: Official documentation URLs are automatically extracted from `official_doc_urls` field in knowledge JSON files

**File Resolution**:
- Script searches automatically by basename
- Warns if not found (link omitted, processing continues)
- Includes all matches if multiple files found (with path disambiguation in labels)

**Pre-filled placeholders (9/17)**:
- `{{target_name}}`: From target-name parameter
- `{{generation_date}}`: Current date (auto-generated)
- `{{generation_time}}`: Current time (auto-generated)
- `{{target_description}}`: From target-desc parameter
- `{{modules}}`: From modules parameter
- `{{output_path}}`: Output file path (auto-generated, e.g., `.nabledge/YYYYMMDD/code-analysis-<target>.md`)
- `{{source_files_links}}`: Generated from source-files parameter
- `{{knowledge_base_links}}`: Generated from knowledge-files parameter
- `{{official_docs_links}}`: Automatically extracted from knowledge JSON files' `official_doc_urls` field

**Output**: Template file with 9 placeholders pre-filled, 8 remaining for LLM

**Error handling**: If script fails:
- Check error message on stderr for specific issue
- Common causes: missing template file, invalid file paths, permission errors
- Verify all source files exist and are readable
- If script succeeds but output is incorrect, verify parameters match expected format

**Validation**: After script completes, verify:
- Output file was created at specified path
  - **If missing**: Check stderr for errors, report to user, HALT workflow
- Script reported "9/17" placeholders filled
  - **If different**: Read output file to inspect which placeholders failed, report to user, HALT workflow
- No error messages on stderr
  - **If errors present**: Report full stderr output to user, HALT workflow

#### 3.3: Generate Mermaid diagram skeletons

**Tool**: Bash (.claude/skills/nabledge-1.3/scripts/generate-mermaid-skeleton.sh)

**Action**: Generate diagram skeletons to reduce LLM workload:

**Class Diagram Skeleton**:
```bash
bash .claude/skills/nabledge-1.3/scripts/generate-mermaid-skeleton.sh --source-files "<file1.java,file2.java>" --diagram-type class
```

**Sequence Diagram Skeleton**:
```bash
bash .claude/skills/nabledge-1.3/scripts/generate-mermaid-skeleton.sh --source-files "<main-file.java>" --diagram-type sequence --main-class "<MainClass>"
```

**Output**: Mermaid diagram syntax with:
- Class diagram: class names, basic relationships (extends, implements, uses)
- Sequence diagram: participants, basic flow structure

**LLM refinement needed**:
- Add `<<Nablarch>>` annotations to framework classes
- Add relationship labels (e.g., "validates", "uses", "creates")
- Add detailed method calls and error handling in sequence diagrams
- Add notes and annotations for complex logic

**Error handling**: If script fails:
- Check error message on stderr for specific issue
- Common causes: source file not found, invalid diagram type, parse errors
- Verify all source files are valid Java files
- If output is incomplete, script may have encountered parse error (check file syntax)

**Validation**: After script completes, verify:
- Mermaid syntax is valid (starts with "classDiagram" or "sequenceDiagram")
  - **If invalid**: Report syntax error to user, HALT workflow
- All source files' classes are represented
  - **If missing classes**: Report which classes are missing, HALT workflow
- Basic structure is present (classes/participants + relationships/flow)
  - **If incomplete**: Report what's missing (e.g., "no relationships", "no participants"), HALT workflow

**Storage**: Save outputs for use in Steps 3.4 and 3.5:
- Store class diagram output as `CLASS_DIAGRAM_SKELETON` in working memory
- Store sequence diagram output as `SEQUENCE_DIAGRAM_SKELETON` in working memory
- You will retrieve these skeletons in the following steps

#### 3.4: Build documentation content

**Output budget** (MANDATORY):

Total output: **10-15 KB** (10,000-15,000 characters)

| Section | Budget | Guideline |
|---------|--------|-----------|
| overview_content | 200-400 chars | Purpose and structure, concise |
| dependency_graph | 15-30 lines | Class names only, no methods/fields |
| component_summary_table | 1 line per component | Role in 5-10 words |
| flow_content | 300-600 chars | Main flow + helper/private methods (one level deep), exception flows optional |
| flow_sequence_diagram | 20-40 lines | Main path only, max 1-2 important alt/loop |
| components_details | 300-500 chars per component | Max 3 key methods |
| nablarch_usage | 200-400 chars per component | Max 3 important points |

**When over budget**: If total is likely to exceed 15 KB, reduce in this priority:
1. Reduce detail in components_details (shorten method descriptions)
2. Limit nablarch_usage important points to 3
3. Reduce alt/loop in flow_sequence_diagram

**CRITICAL**: All diagram work REFINES skeletons from Step 3.3. REFINE, not REGENERATE.

**Refinement**:
- Start with skeleton structure (classes, participants, relationships present)
- Add semantic information (annotations, labels, control flow)
- Preserve skeleton-generated base structure

**Permitted actions**:
- Add annotations/stereotypes (e.g., `<<Nablarch>>`)
- Add or improve relationship labels (e.g., "validates", "uses", "creates")
- Add control flow elements (`alt`/`else`, `loop`, `Note over`)
- Add missing relationships discovered during analysis
- Fix incorrect relationship types (`--` vs `..`)

**Prohibited actions**:
- Delete skeleton and create new diagram from scratch
- Reorder existing participants/classes
- Remove skeleton-generated relationships
- Change diagram type (class to sequence)

**Exception**: If skeleton is malformed, report error and request manual intervention.

**Refinement workflow**:

**For class diagrams**:
1. Retrieve `CLASS_DIAGRAM_SKELETON` from working memory (saved in Step 3.3)
2. Add `<<Nablarch>>` stereotype to framework classes (UniversalDao, ExecutionContext, etc.)
3. Replace generic labels with specific relationship types (see criteria below)
4. Verify all key dependencies are present (see key dependency criteria below)
5. Preserve all skeleton structure (classes, basic relationships)

**For sequence diagrams**:
1. Retrieve `SEQUENCE_DIAGRAM_SKELETON` from working memory (saved in Step 3.3)
2. Replace generic arrows with specific method names ("execute()", "validate()")
3. Add error handling branches using `alt`/`else` blocks where applicable
4. Add loops for repetitive operations using `loop` blocks
5. Add explanatory notes using `Note over` syntax for complex logic
6. Preserve all skeleton structure (participants, basic flow)

**Dependency diagram** (Mermaid classDiagram):

**Step 1**: Retrieve skeleton from working memory
- Retrieve `CLASS_DIAGRAM_SKELETON` saved in Step 3.3
- This skeleton already contains class names and basic relationships

**Step 2**: Refine skeleton:
- Add `<<Nablarch>>` stereotype to framework classes
- Add specific relationship labels:
  - Data operations: "validates", "serializes", "queries", "persists"
  - Lifecycle operations: "creates", "initializes", "configures"
  - Control flow: "invokes", "delegates to", "calls back"
  - Avoid generic labels: "uses", "calls", "has"
- Verify key dependencies shown:
  - Direct field injection or constructor parameter
  - Method called in primary business logic path
  - Required for transaction or validation
  - Framework class enabling core functionality

**Example**:
```mermaid
classDiagram
    class LoginAction
    class LoginForm
    class UniversalDao {
        <<Nablarch>>
    }

    LoginAction ..> LoginForm : validates
    LoginAction ..> UniversalDao : uses
```

**Key points**:
- Start with skeleton (reduces generation time)
- Use `classDiagram` syntax (NOT `graph TD`)
- Show class names only (NO methods/fields)
- Show inheritance with `--|>`, dependencies with `..>`
- Mark framework classes with `<<Nablarch>>`

**Component summary table**:
```markdown
| Component | Role | Type | Dependencies |
|-----------|------|------|--------------|
| LoginAction | Login processing | Action | LoginForm, UniversalDao |
```

**Flow description with sequence diagram** (Mermaid sequenceDiagram):

**Step 1**: Retrieve skeleton from working memory
- Retrieve `SEQUENCE_DIAGRAM_SKELETON` saved in Step 3.3
- This skeleton already contains participants and basic flow structure

**Step 2**: Refine skeleton with semantic information:
- Add detailed method calls with specific method names (e.g., "execute()", "validate()" instead of generic "request")
- **Use Java method names, not HTTP paths**: For web actions, show `doRW11AC0201()` not `POST RW11AC0201`
- Add error handling branches using `alt`/`else` blocks where applicable
- Add loops for repetitive operations using `loop` blocks
- Add explanatory notes using `Note over` syntax for complex logic

**Example (web action pattern)**:
```mermaid
sequenceDiagram
    participant Client
    participant Action as W11AC02Action
    participant DB as Database
    participant Mail as MailRequester

    Client->>Action: doRW11AC0201()
    Action->>DB: findAllBySqlFile(SystemAccountEntity)
    DB-->>Action: entities
    Action-->>Client: forward(W11AC0201.jsp)

    Client->>Action: doRW11AC0204()
    Action->>DB: update(SystemAccountEntity)
    Action->>Mail: sendMailToRegisteredUser()
    Mail-->>Action: result
    Action-->>Client: redirect
```

**Example (batch action pattern)**:
```mermaid
sequenceDiagram
    participant Handler
    participant Action as B11AC014Action
    participant Validator as FileLayoutValidatorAction
    participant DB as Database

    Handler->>Action: initialize()
    Handler->>Action: doHeader()
    loop Each record
        Handler->>Action: doData()
        Action->>Validator: getValidatorAction()
        Validator-->>Action: validator
    end
    Handler->>Action: doTrailer()
    Handler->>Action: doEnd()
```

**Key points**:
- Start with skeleton (reduces generation time)
- Use Java method names (e.g., `doRW11AC0204()`, `initialize()`) — not HTTP paths or generic labels
- Use `->>` for calls, `-->>` for returns
- Use `alt`/`else` for error handling
- Use `loop` for repetition
- Use `Note over` to explain logic

**Component details**:
- Component name and role
- Key methods with line references (`:42-58` format)
- Dependencies
- File path with relative link + line references

**Nablarch usage** (for each component):
- Class name and description
- Code example
- Important points with prefixes: ✅ Must do / ⚠️ Caution / 💡 Benefit / 🎯 When to use / ⚡ Performance
- Usage in this code
- Knowledge base link

**Output format examples**:

**Component Summary Table**:
```markdown
| Component | Role | Type | Dependencies |
|-----------|------|------|--------------|
| LoginAction | Login processing | Action | LoginForm, UniversalDao |
| LoginForm | Login input validation | Form | none |
```

**Important Points prefixes**:
- ✅ **Must do**: Critical actions that must be performed
- ⚠️ **Caution**: Gotchas, limitations, common mistakes
- 💡 **Benefit**: Why use this, advantages, design philosophy
- 🎯 **When to use**: Use cases, scenarios, applicability
- ⚡ **Performance**: Performance considerations, optimization tips

**Nablarch Usage structure**:
```markdown
### ObjectMapper

**Class**: `nablarch.common.databind.ObjectMapper`

**Description**: Provides functionality to handle CSV, TSV, and fixed-length data as Java Beans

**Usage**:
\```java
ObjectMapper<ProjectDto> mapper = ObjectMapperFactory.create(ProjectDto.class, outputStream);
mapper.write(dto);
mapper.close();
\```

**Important points**:
- ✅ **Always call `close()`**: Flushes the buffer and releases resources
- ⚠️ **Large data processing**: Does not hold all data in memory, so large volumes are handled safely
- 💡 **Annotation-driven**: Formats can be declared with `@Csv`, `@CsvFormat`

**Usage in this code**:
- ObjectMapper created in `initialize()` (Line 25-28)
- Each record output via `mapper.write(dto)` in `handle()` (Line 52)
- Resources released via `mapper.close()` in `terminate()` (Line 60)

**Details**: [Data Bind](../../.claude/skills/nabledge-1.3/docs/features/libraries/data-bind.md)
```

#### 3.5: Fill remaining placeholders and output

1. **Read pre-filled template**: Use Read tool on the file created in Step 3.2
   - File path: `$OUTPUT_PATH` (captured from script output in Step 3.2)
   - This file already contains 9/17 placeholders filled (deterministic content)

2. **Construct complete content**: Build the full document content in memory by:
   - Keeping all pre-filled content from Step 3.2 (9 deterministic placeholders)
   - Replacing 8 remaining placeholders with generated content (see list below)
   - Using refined skeletons from Step 3.3 for diagram placeholders

   **Placeholders to fill** (LLM-generated content):
   - `{{DURATION_PLACEHOLDER}}`: Leave as-is (filled after Write completes in Step 5). **CRITICAL: Write the literal string `{{DURATION_PLACEHOLDER}}` exactly as-is. Do NOT replace it with a variable name or value — Step 5 bash command performs the substitution.**
   - `{{overview_content}}`: Overview section (generate)
   - `{{dependency_graph}}`: Mermaid classDiagram (refine skeleton from Step 3.3)
   - `{{component_summary_table}}`: Component table (generate)
   - `{{flow_content}}`: Flow description (generate) — include main flow methods AND helper/private methods called one level deep
   - `{{flow_sequence_diagram}}`: Mermaid sequenceDiagram (refine skeleton from Step 3.3)
   - `{{components_details}}`: Detailed analysis (generate)
   - `{{nablarch_usage}}`: Framework usage with important points (generate)

   **Already pre-filled (from Step 3.2, keep as-is)**:
   - `{{target_name}}`: Target code name
   - `{{generation_date}}`: Current date
   - `{{generation_time}}`: Current time
   - `{{target_description}}`: One-line description
   - `{{modules}}`: Affected modules
   - `{{output_path}}`: Output file path
   - `{{source_files_links}}`: Source file links
   - `{{knowledge_base_links}}`: Knowledge base links
   - `{{official_docs_links}}`: Official docs links

   **Important**: For diagram placeholders, retrieve refined skeletons from working memory (`CLASS_DIAGRAM_SKELETON` and `SEQUENCE_DIAGRAM_SKELETON` from Step 3.3).

   **CRITICAL: Build and Write must be a single step**:
   - Items 2 (Construct), 3 (Verify), 4 (Write) in this Step 3.5 must be executed as one continuous operation
   - DO NOT split Build and Write into separate tool calls
   - Splitting causes the generated content to be re-read as input tokens in each subsequent step, multiplying token usage by 2-3x

3. **Verify template compliance** before writing:
   - All template sections present
   - Section order matches template
   - NO section numbers (1., 2., etc.)
   - NO additional sections outside template
   - All placeholders replaced (except {{DURATION_PLACEHOLDER}})
   - Relative links with line references
   - Knowledge base links included
   - Mermaid diagrams refined from skeletons (not regenerated)

4. **Write complete file**: Use Write tool with full document content
   - File path: actual expanded path captured from Step 3.2 output (e.g., `.nabledge/20260414/code-analysis-ImportZipCodeFileAction.md`). DO NOT pass the variable name `$OUTPUT_PATH` literally — use the actual path string.
   - Content: Complete document with all 17 placeholders filled (9 pre-filled + 8 generated)
   - This will overwrite the pre-filled template from Step 3.2 with the complete version
   - Write tool requires prior Read (already done in step 1)

   **Validation checkpoint**: Before proceeding to Step 5, verify:
   - Write operation succeeded (no error message)
     - **If failed**: Report error to user, HALT workflow
   - Output file path matches expected location
     - **If wrong path**: Report actual path to user, HALT workflow
   - File size is reasonable (typically 10-50 KB for code analysis docs)
     - **If too small (<5 KB)**: Likely missing content, report to user, HALT workflow
     - **If too large (>100 KB)**: Possible duplicate content, report to user, HALT workflow

5. **Calculate duration and update file** (IMMEDIATE execution after Write):

   **CRITICAL SEQUENCING**: Execute time calculation and file update in a single Bash tool call using `&&` to ensure no operations occur between them.

   ```bash
   bash .claude/skills/nabledge-1.3/scripts/finalize-output.sh "<target-name>" "YYYYMMDD"
   ```

   **Replace in command**:
   - `<target-name>`: Actual target name (e.g., `ImportZipCodeFileAction`)
   - `YYYYMMDD`: Date portion from `$OUTPUT_PATH` captured in Step 3.2 (e.g., if `OUTPUT_PATH` is `.nabledge/20260210/code-analysis-Foo.md`, pass `20260210`)

   **IMPORTANT**:
   - Execute immediately after Step 4 with no other operations between them
   - This script handles: session ID retrieval, duration calculation, and file update
   - **Error handling**: If start time file is missing, duration is set to "unknown" with warning message
   - Script continues execution even if duration calculation fails, ensuring placeholder is always replaced
   - If sed fails (permission error, file locked, etc.), inform user of the calculated duration so they can manually edit the file

6. **Inform user**: Show output path and actual duration

**Output**: Documentation file at .nabledge/YYYYMMDD/code-analysis-<target-name>.md

## Output template

**Template file**: `.claude/skills/nabledge-1.3/assets/code-analysis-template.md`
**Template guide**: `.claude/skills/nabledge-1.3/assets/code-analysis-template-guide.md`
**Note**: Template examples are inlined in Step 3.4

The template provides structured format with sections:
1. Header (date/time, duration, modules)
2. Overview
3. Architecture (class diagram + component table)
4. Flow (description + sequence diagram)
5. Components (detailed analysis)
6. Nablarch Framework Usage (with important points)
7. References (source files, knowledge base, official docs)

## Error handling

**See SKILL.md "Error Handling Policy" section for comprehensive guidelines.**

Key scenarios:
- **Target code not found**: Ask user for clarification, suggest similar files
- **Dependency analysis too complex**: Ask user to narrow scope
- **Output file already exists**: Ask user whether to overwrite
- **No Nablarch knowledge found**: Note in documentation, proceed with code analysis only

## Best practices

**Template compliance**:
- Read template file before generating content
- Never add section numbers
- Never add sections outside template structure
- Integrate additional info into existing sections as subsections
- Verify compliance before output

**Scope management**:
- Start narrow, expand if needed
- Ask user before expanding
- Document scope boundaries

**Dependency tracing**:
- Stop at framework boundaries
- Stop at Entity classes
- Focus on project-specific code

**Knowledge integration**:
- Only use knowledge from knowledge files
- Cite sources (file + section)
- Don't supplement with external knowledge

**Documentation quality**:
- Keep explanations concise
- Use diagrams for complex relationships
- Provide actionable information
- Link to sources for details

## Example execution

**User request**: "I want to understand LoginAction"

**Step 1**: Identify target and analyze
- Target: LoginAction.java
- Dependencies: LoginForm, SystemAccountEntity, UniversalDao, ExecutionContext
- Components: Action (LoginAction), Form (LoginForm), Entity (SystemAccountEntity), Nablarch (UniversalDao, ExecutionContext)

**Step 2**: Search Nablarch knowledge
- UniversalDao → universal-dao.json:overview, crud sections
- Bean Validation → data-bind.json:validation section

**Step 3**: Generate and output
- Read template files
- Build classDiagram and sequenceDiagram
- Create component summary table
- Write component details with line references
- Write Nablarch usage with important points (✅ ⚠️ 💡)
- Apply template with all placeholders
- Output: .nabledge/20260210/code-analysis-login-action.md

**Summary**: 5 components, 2 diagrams, 2 Nablarch knowledge sections, duration ~2m
