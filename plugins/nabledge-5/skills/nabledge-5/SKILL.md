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

**Question answering**:
```
nabledge-5 "<question>"
```

**Code analysis**:
```
nabledge-5 code-analysis
```

**Keyword search** (precise, term-based):
```
nabledge-5 keyword-search "<term1> <term2> ..."
```

**Semantic search** (exploratory, natural language):
```
nabledge-5 semantic-search "<question>"
```

## Execution Instructions

### Step 0: Determine Workflow

**No arguments** (`nabledge-5`):
- Ask user to choose: Question Answering or Code Analysis

**Text argument** (`nabledge-5 "<question>"`):
- Execute `workflows/qa.md`

**"code-analysis" argument** (`nabledge-5 code-analysis`):
- Execute `workflows/code-analysis.md`

**"keyword-search" argument** (`nabledge-5 keyword-search "<terms>"`):
- Split `<terms>` on spaces to get a keyword list
- Execute `workflows/keyword-search.md` with `{keywords}` = that list

**"semantic-search" argument** (`nabledge-5 semantic-search "<question>"`):
- Execute `workflows/semantic-search.md` with the provided question

