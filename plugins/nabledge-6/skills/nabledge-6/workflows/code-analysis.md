# Code Analysis Workflow

This workflow analyzes existing code, traces dependencies, and generates structured documentation to help understand the codebase.

## Table of Contents

- [Overview](#overview)
- [Process flow](#process-flow)
  - [Step 1: Identify target and analyze dependencies](#step-1-identify-target-and-analyze-dependencies)
  - [Step 2: Search Nablarch knowledge](#step-2-search-nablarch-knowledge)
  - [Step 3: Generate and output documentation](#step-3-generate-and-output-documentation)
- [Output template](#output-template)
- [Error handling](#error-handling)
- [Best practices](#best-practices)
- [Example execution](#example-execution)

## Overview

**Purpose**: Help users understand existing code by:
1. Identifying target code and tracing dependencies
2. Searching relevant Nablarch knowledge
3. Generating comprehensive documentation

**Input**: User's request (target code specification)

**Output**: Structured documentation file (Markdown + Mermaid diagrams)

**Tools**:
- Read, Glob, Grep: Read and search source files
- Bash with jq: Execute keyword-search workflow
- Write: Generate documentation file

**Expected output**: 1 documentation file (~3,000-10,000 tokens) in .nabledge/YYYYMMDD/

## Process flow

### Step 0: Record start time (CRITICAL)

**Tool**: Bash

**Action** - Store start time with unique session ID:
```bash
UNIQUE_ID="$(date '+%s%3N')-$$"
echo "$UNIQUE_ID" > /tmp/nabledge-code-analysis-id
date '+%s' > "/tmp/nabledge-code-analysis-start-$UNIQUE_ID"
echo "Start time recorded: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Session ID: $UNIQUE_ID"
```

**Output example**:
```
Start time recorded: 2026-02-10 14:54:00
Session ID: 1707559440123-12345
```

**IMPORTANT**:
- **Session ID stored in**: `/tmp/nabledge-code-analysis-id` (fixed path for retrieval in Step 3.3)
- **Start time stored in**: `/tmp/nabledge-code-analysis-start-$UNIQUE_ID` (unique file per session)
- **UNIQUE_ID format**: `{millisecond_timestamp}-{process_PID}` ensures uniqueness across parallel executions
- Epoch time (seconds since 1970) stored for accurate duration calculation
- No need to remember values - Step 3.3 will read session ID from fixed file path

**Why this matters**: The `{{analysis_duration}}` placeholder must contain the actual elapsed time, not an estimate. Users will compare it against the "Cooked for X" time shown in their IDE.

---

### Step 1: Identify target and analyze dependencies

**Tools**: AskUserQuestion (if needed), Read, Glob, Grep

**Action**:

1. **Parse user request** to understand target scope:
   - Specific class (e.g., "LoginAction")
   - Specific feature (e.g., "ログイン機能")
   - Package (e.g., "web.action配下")

2. **Ask clarifying questions** if scope is unclear

3. **Find target files** using Glob or Grep

4. **Read target files** and extract dependencies:
   - Imports → External dependencies
   - Field types, method parameters → Direct dependencies
   - Method calls → Behavioral dependencies

5. **Classify dependencies**:
   - Project code (proman-*): Trace further
   - Nablarch framework: Note for knowledge search
   - JDK/Jakarta EE: Note but don't trace
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
    - Technical terms: DAO, トランザクション, ハンドラ
    - Operations: 検索, 登録, 更新, バリデーション
    - Patterns: CRUD, pagination, error handling

**Output**: Target files list, dependency graph, component list with Nablarch components identified

### Step 2: Search Nablarch knowledge

**Tools**: Read (index.toon), Bash with jq (keyword-search workflow)

**Action**: Batch process knowledge searches for all Nablarch components to reduce tool calls.

**Batch processing approach**:

1. **Identify all Nablarch components** from Step 1 analysis:
   - Example: ["UniversalDao", "ExecutionContext", "ValidationUtil", "DbAccessException"]

2. **Combine keywords for batch search**:
   - Merge component names + technical terms from all components
   - Extract L1/L2/L3 keywords for all components at once

   **Bash script example for keyword combination**:
   ```bash
   # Declare arrays for combined keywords
   declare -a l1_all l2_all l3_all

   # UniversalDao component keywords
   l1_all+=("データベース" "database")
   l2_all+=("DAO" "UniversalDao" "O/Rマッパー")
   l3_all+=("CRUD" "検索" "登録" "更新" "ページング")

   # ExecutionContext component keywords
   l1_all+=("リクエスト" "request")
   l2_all+=("ExecutionContext" "コンテキスト")
   l3_all+=("リクエスト処理" "データ取得")

   # ValidationUtil component keywords
   l1_all+=("バリデーション" "validation")
   l2_all+=("ValidationUtil" "Bean Validation")
   l3_all+=("検証" "エラー" "例外処理")

   # Remove duplicates and prepare for keyword-search workflow
   l1_keywords=($(printf '%s\n' "${l1_all[@]}" | sort -u))
   l2_keywords=($(printf '%s\n' "${l2_all[@]}" | sort -u))
   l3_keywords=($(printf '%s\n' "${l3_all[@]}" | sort -u))
   ```

   **Result** - Combined keywords ready for keyword-search:
     - L1: ["データベース", "database", "バリデーション", "validation", "リクエスト", "request"]
     - L2: ["DAO", "UniversalDao", "O/Rマッパー", "ExecutionContext", "コンテキスト", "ValidationUtil", "Bean Validation"]
     - L3: ["CRUD", "検索", "登録", "更新", "ページング", "リクエスト処理", "データ取得", "検証", "エラー", "例外処理"]

3. **Execute keyword-search workflow once** (see workflows/keyword-search.md):
   - Use combined keywords for all components
   - Batch process file selection (Step 1)
   - Batch extract candidate sections (Step 2)
   - Get 20-30 candidates covering all components

4. **Execute section-judgement workflow once** (see workflows/section-judgement.md):
   - Batch extract all candidate sections (2-3 jq calls instead of 5-10)
   - Judge relevance for each section
   - Keep only High and Partial relevance sections

5. **Group knowledge by component** after receiving results:
   - Parse returned sections and map to original components
   - UniversalDao → [universal-dao.json:overview, universal-dao.json:crud]
   - ValidationUtil → [data-bind.json:validation]

6. **Collect knowledge** for documentation:
   - API usage patterns
   - Configuration requirements
   - Code examples
   - Error handling
   - Best practices

**Tool call reduction**:
- **Before**: Sequential processing per component = ~36 calls
  - Per component: keyword-search (12 calls) + section-judgement (5-10 calls) = ~18 calls
  - For 2-3 components: 36-54 calls total
- **After**: Batch processing for all components = ~15 calls
  - keyword-search batch (3 calls) + section-judgement batch (2-3 calls) + grouping (0 calls) = ~6 calls once
  - Additional overhead for multi-component coordination: ~5-10 calls (dependency grouping and knowledge mapping)
  - Total: ~15 calls

**Efficiency**: Collect High-relevance sections only (5-10 sections per component). Skip components with no relevant knowledge.

**Output**: Relevant knowledge sections with API usage, patterns, and best practices

### Step 3: Generate and output documentation

**Tools**: Read (template files), Bash (prefill script, mermaid script), Write

**Action**:

#### 3.1: Read template and guide

**MUST READ FIRST** (use single cat command for efficiency):
```bash
cat .claude/skills/nabledge-6/assets/code-analysis-template.md \
    .claude/skills/nabledge-6/assets/code-analysis-template-guide.md \
    .claude/skills/nabledge-6/assets/code-analysis-template-examples.md
```

**Extract from templates**:
- All `{{placeholder}}` variables
- Section structure and order (DO NOT deviate)
- Component Summary Table format
- Nablarch Usage structure with important points (✅ ⚠️ 💡 🎯 ⚡)
- Link generation rules (relative paths + line references)

#### 3.2: Pre-fill deterministic placeholders

**Tool**: Bash (.claude/skills/nabledge-6/scripts/prefill-template.sh)

**Action**: Execute prefill script to pre-populate 8 deterministic placeholders:

```bash
.claude/skills/nabledge-6/scripts/prefill-template.sh \
  --target-name "<target-name>" \
  --target-desc "<one-line-description>" \
  --modules "<module1, module2>" \
  --source-files "<file1.java,file2.java>" \
  --knowledge-files "<knowledge1.md,knowledge2.md>" \
  --official-docs "<url1,url2>" \
  --output-path ".nabledge/YYYYMMDD/code-analysis-<target>.md"
```

**Parameters**:
- `target-name`: Target code name (e.g., "LoginAction")
- `target-desc`: One-line description (e.g., "ログイン認証処理")
- `modules`: Affected modules (e.g., "proman-web, proman-common")
- `source-files`: Comma-separated source file paths from Step 1
- `knowledge-files`: Comma-separated knowledge file paths from Step 2
- `official-docs`: Comma-separated official doc URLs (optional)
- `output-path`: Output file path

**Pre-filled placeholders (8/16)**:
- `{{target_name}}`: From target-name parameter
- `{{generation_date}}`: Current date (auto-generated)
- `{{generation_time}}`: Current time (auto-generated)
- `{{target_description}}`: From target-desc parameter
- `{{modules}}`: From modules parameter
- `{{source_files_links}}`: Generated from source-files parameter
- `{{knowledge_base_links}}`: Generated from knowledge-files parameter
- `{{official_docs_links}}`: Generated from official-docs parameter

**Output**: Template file with 8 placeholders pre-filled, 8 remaining for LLM

**Error handling**: If script fails:
- Check error message on stderr for specific issue
- Common causes: missing template file, invalid file paths, permission errors
- Verify all source files exist and are readable
- If script succeeds but output is incorrect, verify parameters match expected format

**Validation**: After script completes, verify:
- Output file was created at specified path
  - **If missing**: Check stderr for errors, report to user, HALT workflow
- Script reported "8/16" placeholders filled
  - **If different**: Read output file to inspect which placeholders failed, report to user, HALT workflow
- No error messages on stderr
  - **If errors present**: Report full stderr output to user, HALT workflow

#### 3.3: Generate Mermaid diagram skeletons

**Tool**: Bash (.claude/skills/nabledge-6/scripts/generate-mermaid-skeleton.sh)

**Action**: Generate diagram skeletons to reduce LLM workload:

**Class Diagram Skeleton**:
```bash
.claude/skills/nabledge-6/scripts/generate-mermaid-skeleton.sh \
  --source-files "<file1.java,file2.java>" \
  --diagram-type class
```

**Sequence Diagram Skeleton**:
```bash
.claude/skills/nabledge-6/scripts/generate-mermaid-skeleton.sh \
  --source-files "<main-file.java>" \
  --diagram-type sequence \
  --main-class "<MainClass>"
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

**CRITICAL INSTRUCTION**: All diagram work in this step REFINES skeletons from Step 3.3. Your task is to REFINE, not REGENERATE.

**What is refinement?**
- Start with skeleton structure (classes, participants, relationships already present)
- Add semantic information (annotations, labels, control flow)
- Preserve all skeleton-generated base structure

**Refinement scope** (permitted actions):
- Add annotations/stereotypes (e.g., `<<Nablarch>>`)
- Add or improve relationship labels (e.g., "validates", "uses", "creates")
- Add control flow elements (`alt`/`else`, `loop`, `Note over`)
- Add missing relationships discovered during analysis
- Fix incorrect relationship types (`--` vs `..`)

**Regeneration** (prohibited actions):
- Deleting skeleton and creating new diagram from scratch
- Reordering existing participants/classes
- Removing skeleton-generated relationships
- Changing diagram type (class to sequence)

**Exception**: If skeleton is malformed (syntax error, missing critical classes), report error to user and request manual intervention instead of attempting to fix.

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

**Time savings**: Skeletons save ~20 seconds (baseline: ~35s for manual diagram creation, with skeleton: ~15s for refinement, ~57% reduction) by providing structure; focus refinement on semantics, not syntax.

**Dependency diagram** (Mermaid classDiagram):

**Step 1**: Retrieve skeleton from working memory
- Retrieve `CLASS_DIAGRAM_SKELETON` saved in Step 3.3
- This skeleton already contains class names and basic relationships

**Step 2**: Refine skeleton with semantic information:
- Add `<<Nablarch>>` stereotype to framework classes (UniversalDao, ExecutionContext, etc.)
- Add specific relationship labels that describe the interaction:
  - **Data operations**: "validates", "serializes", "queries", "persists"
  - **Lifecycle operations**: "creates", "initializes", "configures"
  - **Control flow**: "invokes", "delegates to", "calls back"
  - **Avoid generic labels**: "uses", "calls", "has" (replace with specific action)
- Verify all key dependencies are shown:
  - **Key dependencies** (include if ANY apply):
    - Direct field injection or constructor parameter
    - Method called in primary business logic path
    - Required for transaction or validation
    - Framework class that enables core functionality

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
| LoginAction | ログイン処理 | Action | LoginForm, UniversalDao |
```

**Flow description with sequence diagram** (Mermaid sequenceDiagram):

**Step 1**: Retrieve skeleton from working memory
- Retrieve `SEQUENCE_DIAGRAM_SKELETON` saved in Step 3.3
- This skeleton already contains participants and basic flow structure

**Step 2**: Refine skeleton with semantic information:
- Add detailed method calls with specific method names (e.g., "execute()", "validate()" instead of generic "request")
- Add error handling branches using `alt`/`else` blocks where applicable
- Add loops for repetitive operations using `loop` blocks
- Add explanatory notes using `Note over` syntax for complex logic

**Example**:
```mermaid
sequenceDiagram
    participant User
    participant Action as LoginAction
    participant DB as Database

    User->>Action: HTTP Request
    Action->>DB: query
    DB-->>Action: result
    Action-->>User: response
```

**Key points**:
- Start with skeleton (reduces generation time)
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

**See detailed examples**: assets/code-analysis-template-examples.md

#### 3.5: Fill remaining placeholders and output

1. **Read pre-filled template**: Use Read tool on the file created in Step 3.2
   - File path: `.nabledge/YYYYMMDD/code-analysis-<target>.md`
   - This file already contains 8/16 placeholders filled (deterministic content)

2. **Construct complete content**: Build the full document content in memory by:
   - Keeping all pre-filled content from Step 3.2 (8 deterministic placeholders)
   - Replacing 8 remaining placeholders with generated content (see list below)
   - Using refined skeletons from Step 3.3 for diagram placeholders

   **Placeholders to fill** (LLM-generated content):
   - `{{DURATION_PLACEHOLDER}}`: Leave as-is (filled after Write completes in Step 5)
   - `{{overview_content}}`: Overview section (generate)
   - `{{dependency_graph}}`: Mermaid classDiagram (refine skeleton from Step 3.3)
   - `{{component_summary_table}}`: Component table (generate)
   - `{{flow_content}}`: Flow description (generate)
   - `{{flow_sequence_diagram}}`: Mermaid sequenceDiagram (refine skeleton from Step 3.3)
   - `{{components_details}}`: Detailed analysis (generate)
   - `{{nablarch_usage}}`: Framework usage with important points (generate)

   **Already pre-filled (from Step 3.2, keep as-is)**:
   - `{{target_name}}`: Target code name
   - `{{generation_date}}`: Current date
   - `{{generation_time}}`: Current time
   - `{{target_description}}`: One-line description
   - `{{modules}}`: Affected modules
   - `{{source_files_links}}`: Source file links
   - `{{knowledge_base_links}}`: Knowledge base links
   - `{{official_docs_links}}`: Official docs links

   **Important**: For diagram placeholders (`{{dependency_graph}}` and `{{flow_sequence_diagram}}`), retrieve refined skeletons from working memory (`CLASS_DIAGRAM_SKELETON` and `SEQUENCE_DIAGRAM_SKELETON` from Step 3.3). Do not generate new diagrams from scratch.

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
   - File path: Same as Step 3.2 (`.nabledge/YYYYMMDD/code-analysis-<target>.md`)
   - Content: Complete document with all 16 placeholders filled (8 pre-filled + 8 generated)
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

   Execute single bash script to fill duration placeholder:
   ```bash
   # Retrieve session ID from Step 0
   UNIQUE_ID=$(cat /tmp/nabledge-code-analysis-id 2>/dev/null || echo "")

   # Get current time
   end_time=$(date '+%s')

   # Calculate duration with error handling
   START_TIME_FILE="/tmp/nabledge-code-analysis-start-$UNIQUE_ID"
   if [ -z "$UNIQUE_ID" ] || [ ! -f "$START_TIME_FILE" ]; then
     echo "WARNING: Start time file not found. Duration will be set to '不明'."
     duration_text="不明"
   else
     start_time=$(cat "$START_TIME_FILE")
     duration_seconds=$((end_time - start_time))

     # Format as Japanese text
     if [ $duration_seconds -lt 60 ]; then
       duration_text="約${duration_seconds}秒"
     else
       minutes=$((duration_seconds / 60))
       seconds=$((duration_seconds % 60))
       duration_text="約${minutes}分${seconds}秒"
     fi
   fi

   # Replace duration placeholder in the output file
   sed -i "s/{{DURATION_PLACEHOLDER}}/$duration_text/g" .nabledge/YYYYMMDD/code-analysis-<target>.md

   # Clean up temp files
   rm -f "$START_TIME_FILE"
   rm -f /tmp/nabledge-code-analysis-id

   # Output for user
   echo "Duration: $duration_text"
   ```

   **Replace in command**:
   - `YYYYMMDD`: Actual date directory
   - `<target>`: Actual target name

   **IMPORTANT**:
   - Execute immediately after Step 4 with no other operations between them
   - This script handles: session ID retrieval, duration calculation, and file update
   - **Error handling**: If start time file is missing, duration is set to "不明" (unknown) with warning message
   - Script continues execution even if duration calculation fails, ensuring placeholder is always replaced
   - If sed fails (permission error, file locked, etc.), inform user of the calculated duration so they can manually edit the file

6. **Inform user**: Show output path and actual duration
6. **Inform user**: Show output path and actual duration

**Expected time savings** (with baseline context):
- Pre-filled deterministic placeholders: ~25-30 seconds saved
  - Baseline: ~40 seconds for manual placeholder filling
  - With prefill: ~10 seconds (LLM only generates 8 remaining placeholders)
  - Reduction: ~67% faster
- Mermaid diagram skeletons: ~15-20 seconds saved
  - Baseline: ~35 seconds for manual diagram creation from scratch
  - With skeleton: ~15 seconds for refinement
  - Reduction: ~57% faster
- **Total expected reduction**: ~40-50 seconds
  - **Baseline Step 3 execution**: ~100 seconds (LLM generation time)
  - **Target LLM generation time**: ~45-55 seconds
  - **Overall improvement**: ~55% reduction in LLM generation time

**Output**: Documentation file at .nabledge/YYYYMMDD/code-analysis-<target-name>.md

## Output template

**Template file**: `.claude/skills/nabledge-6/assets/code-analysis-template.md`
**Template guide**: `.claude/skills/nabledge-6/assets/code-analysis-template-guide.md`
**Template examples**: `.claude/skills/nabledge-6/assets/code-analysis-template-examples.md`

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

**Template compliance (CRITICAL)**:
- Always read template file before generating content
- Never add section numbers to template sections
- Never add sections outside template structure
- If additional info is valuable, integrate into existing sections as subsections
- Verify compliance before outputting file

**Scope management**:
- Start with narrow scope, expand if needed
- Ask user before expanding beyond initial request
- Clearly document scope boundaries

**Dependency tracing**:
- Stop at framework boundaries
- Stop at Entity classes
- Focus on project-specific code

**Knowledge integration**:
- Only use knowledge from knowledge files
- Cite sources clearly (file + section)
- Don't supplement with external knowledge

**Documentation quality**:
- Keep explanations concise
- Use diagrams for complex relationships
- Provide actionable information
- Link to sources for deep dives

## Example execution

**User request**: "LoginActionを理解したい"

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

**Summary**: 5 components, 2 diagrams, 2 Nablarch knowledge sections, duration ~2分
