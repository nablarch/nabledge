---
name: nabledge-1.3
description: Provides Nablarch 1.3 framework knowledge and code analysis capabilities. Use when developing Nablarch applications, implementing features, reviewing code, or answering questions about Nablarch 1.3.
user-invocable: false
disable-model-invocation: true
---

# Nabledge-1.3: Nablarch 1.3 Knowledge Base

Knowledge base and code analysis tool for Nablarch 1.3 framework.

## Usage

**Interactive mode**:
```
nabledge-1.3
```

**Direct knowledge search**:
```
nabledge-1.3 "<question>"
```

**Direct code analysis**:
```
nabledge-1.3 code-analysis
```

## Execution Instructions

### Step 0: Determine Workflow

**No arguments** (`nabledge-1.3`):
- Show greeting
- Ask user to choose: Knowledge Search or Code Analysis

**Text argument** (`nabledge-1.3 "<question>"`):
- Execute `workflows/qa.md` to answer question
- This workflow orchestrates _knowledge-search pipeline

**"code-analysis" argument** (`nabledge-1.3 code-analysis`):
- Execute `workflows/code-analysis.md` to analyze user's code

## Critical Constraints

**Knowledge files only**: Answer using ONLY information in `knowledge/*.json`. DO NOT use external knowledge or LLM training data.

**When knowledge is missing**:
- Output: "この情報は知識ファイルに含まれていません"
- List related available knowledge from `knowledge/index.toon`
- DO NOT answer from external knowledge

## Error Handling

**Knowledge not found** (Knowledge Search):
- Message: "この情報は知識ファイルに含まれていません"
- List related entries from index.toon

**Target code not found** (Code Analysis):
- Message: "指定されたコードが見つかりませんでした"
- Show search patterns used
- Ask for clarification

**Workflow execution failure**:
- Inform which step failed
- Show error details
- Suggest retry or alternative

## Knowledge Structure

**Files**: `knowledge/about/`, `knowledge/component/`, `knowledge/development-tools/`, `knowledge/extension/`, `knowledge/guide/`, `knowledge/processing-pattern/`
**Index**: `knowledge/index.toon` (all entries with search hints)
**Scripts**: `scripts/*.sh` (pre-built processing scripts)
