---
name: nabledge-5
description: Provides Nablarch 5 framework knowledge and code analysis capabilities. Use when developing Nablarch applications, implementing features, reviewing code, or answering questions about Nablarch 5.
user-invocable: false
disable-model-invocation: true
---

# Nabledge-5: Nablarch 5 Knowledge Base

Knowledge base and code analysis tool for Nablarch 5 framework.

## Usage

**Interactive mode**:
```
nabledge-5
```

**Direct knowledge search**:
```
nabledge-5 "<question>"
```

**Direct code analysis**:
```
nabledge-5 code-analysis
```

## Execution Instructions

### Step 0: Determine Workflow

**No arguments** (`nabledge-5`):
- Show greeting
- Ask user to choose: Knowledge Search or Code Analysis

**Text argument** (`nabledge-5 "<question>"`):
- Execute `workflows/qa.md` to answer question
- This workflow orchestrates _knowledge-search pipeline

**"code-analysis" argument** (`nabledge-5 code-analysis`):
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

**Files**: `knowledge/features/`, `knowledge/checks/`, `knowledge/releases/`
**Index**: `knowledge/index.toon` (all entries with search hints)
**Schemas**: `schemas/*.json` (JSON validation schemas)
**Scripts**: `scripts/*.sh` (pre-built processing scripts)
