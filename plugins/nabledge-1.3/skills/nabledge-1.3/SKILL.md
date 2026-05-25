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

**Question answering**:
```
nabledge-1.3 "<question>"
```

**Code analysis**:
```
nabledge-1.3 code-analysis
```

**Keyword search** (precise, term-based):
```
nabledge-1.3 keyword-search "<term1> <term2> ..."
```

**Semantic search** (exploratory, natural language):
```
nabledge-1.3 semantic-search "<question>"
```

## Execution Instructions

### Step 0: Determine Workflow

**No arguments** (`nabledge-1.3`):
- Ask user to choose: Question Answering or Code Analysis

**Text argument** (`nabledge-1.3 "<question>"`):
- Execute `workflows/qa.md`

**"code-analysis" argument** (`nabledge-1.3 code-analysis`):
- Execute `workflows/code-analysis.md`

**"keyword-search" argument** (`nabledge-1.3 keyword-search "<terms>"`):
- Split `<terms>` on spaces to get a keyword list
- Execute `workflows/keyword-search.md` with `{keywords}` = that list

**"semantic-search" argument** (`nabledge-1.3 semantic-search "<question>"`):
- Execute `workflows/semantic-search.md` with the provided question

