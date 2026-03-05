# QA Workflow

質問応答ワークフロー。ユーザーの質問に対して知識ファイルから関連情報を検索し、日本語で回答する。

## 入力

ユーザーの質問（日本語の自然文）

## 出力

日本語の回答

## 手順

### Step 1: 知識検索の呼び出し

**ツール**: workflows/_knowledge-search.md

**やること**: `workflows/_knowledge-search.md` を実行する。入力はユーザーの質問をそのまま渡す。

**出力**: ポインタJSON

**分岐**: ポインタJSONが空（`results: []`）の場合は Step 3の「該当なしの応答」へ進む。

### Step 2: セクション内容の読み出し

**ツール**: Bash（scripts/read-sections.sh）

**やること**: ポインタJSONの `results` を上から順に、セクション内容を取り出す。

**コマンド**:
```bash
bash scripts/read-sections.sh \
  "features/handlers/common/db-connection-management-handler.json:setup" \
  "features/libraries/universal-dao.json:paging"
```

**出力形式**:
```
=== features/handlers/common/db-connection-management-handler.json : setup ===
[セクション内容]
=== END ===
=== features/libraries/universal-dao.json : paging ===
[セクション内容]
=== END ===
```

**読み出しルール**:
- relevanceがhighのものから先に読み出す
- 最大件数: **10件**

### Step 3: 回答の生成

**ツール**: メモリ内（LLM生成）

**やること**: Step 2で取得したセクション内容を基に、以下のフォーマットで回答を生成する。

**回答フォーマット**:
```
**結論**: [質問への直接的な回答]

**根拠**: [知識ファイルから得たコード例・設定例・仕様情報]

**注意点**: [制約、制限事項、よくある落とし穴]

参照: [知識ファイルID#セクションID]
```

**回答ルール**:
- 知識ファイルの情報**のみ**に基づいて回答する
- 知識ファイルに書いてない情報を推測で補完しない
- 参照元を明示する（例: `universal-dao.json#paging`）
- 目安の長さ: 500トークン以内（複雑な質問は800トークンまで許容）

**該当なしの応答**（ポインタJSONが空の場合）:
```
この情報は知識ファイルに含まれていません。

関連する知識ファイル:
- [index.toonから関連しそうなエントリのtitleとpathを列挙]
- [pathが "not yet created" のものはその旨を表示]
```

**重要**: LLM学習データでの代替回答は**行わない**。
