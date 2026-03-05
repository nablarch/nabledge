# Index-Based Search

全文検索でヒットしなかった場合のフォールバック経路。file-search.md → section-search.md の順で実行する。

## 入力

検索クエリ + キーワードリスト

## 出力

候補セクションのリスト

## 手順

### Step 1: ファイル選定

**ツール**: _knowledge-search/_file-search.md

**やること**: `_knowledge-search/_file-search.md` を実行する。入力は検索クエリとindex.toon。

**出力**: 候補ファイルのリスト

**分岐**: 候補ファイルが0件の場合は空のリストを返して終了。

### Step 2: セクション選定

**ツール**: _knowledge-search/_section-search.md

**やること**: `_knowledge-search/_section-search.md` を実行する。入力はStep 1の候補ファイルのリストとキーワードリスト。

**出力**: 候補セクションのリスト

### Step 3: 結果の返却

**やること**: Step 2の候補セクションのリストを呼び出し元に返す。
