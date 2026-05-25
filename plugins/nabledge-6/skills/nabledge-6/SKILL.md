---
name: nabledge-6
description: Provides Nablarch 6 framework knowledge and code analysis capabilities. Use when developing Nablarch applications, implementing features, reviewing code, or answering questions about Nablarch 6.
user-invocable: false
disable-model-invocation: true
---

# Nabledge-6: Nablarch 6 Knowledge Base

Knowledge base and code analysis tool for Nablarch 6 framework.

## Usage

**Interactive mode**:
```
nabledge-6
```

**Question answering**:
```
nabledge-6 "<question>"
```

**Code analysis**:
```
nabledge-6 code-analysis
```

**Keyword search** (precise, term-based):
```
nabledge-6 keyword-search "<term1> <term2> ..."
```

**Semantic search** (exploratory, natural language):
```
nabledge-6 semantic-search "<question>"
```

## Execution Instructions

### Step 0: Determine Workflow

**No arguments** (`nabledge-6`):
- Ask user to choose: Question Answering or Code Analysis

**Text argument** (`nabledge-6 "<question>"`):
- Execute `workflows/qa.md`

**"code-analysis" argument** (`nabledge-6 code-analysis`):
- Execute `workflows/code-analysis.md`

**"keyword-search" argument** (`nabledge-6 keyword-search "<terms>"`):
- Split `<terms>` on spaces to get a keyword list
- Execute `workflows/keyword-search.md` with `{keywords}` = that list

**"semantic-search" argument** (`nabledge-6 semantic-search "<question>"`):
- Execute `workflows/semantic-search.md` with the provided question

