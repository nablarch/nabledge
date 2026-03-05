# Knowledge Search Workflow

知識検索パイプライン全体を制御するワークフロー。検索クエリからポインタJSONを生成する。

## 入力

検索クエリ（ユーザーの質問 or ワークフローからの検索要求）

## 出力

ポインタJSON

### ポインタJSON スキーマ

```json
{
  "results": [
    {
      "file": "features/handlers/common/db-connection-management-handler.json",
      "section_id": "setup",
      "relevance": "high"
    },
    {
      "file": "features/libraries/universal-dao.json",
      "section_id": "configuration",
      "relevance": "partial"
    }
  ]
}
```

| フィールド | 型 | 説明 |
|---|---|---|
| file | string | knowledgeディレクトリからの相対パス |
| section_id | string | セクション識別子 |
| relevance | "high" \| "partial" | high: 直接回答できる / partial: 部分的に関連 |

resultsはrelevance降順（high → partial）でソート。空配列は該当なし。

## 手順

### Step 1: キーワード抽出

**ツール**: メモリ内（エージェント判断）

**やること**: 検索クエリから検索に有効なキーワードを抽出する。

**抽出観点**:
- 日本語の機能名・概念名（例: ページング、トランザクション、バッチ処理）
- 英語の技術用語（例: UniversalDao、DbConnectionManagementHandler）
- クラス名、アノテーション名、プロパティ名
- 略語・別名（例: DAO、DB、NTF）

**例**:
```
質問: "ページングを実装したい"
→ キーワード: ["ページング", "paging", "UniversalDao", "DAO", "per", "page"]
```

**ルール**:
- 日本語と英語の両方を含める
- 質問の意図から連想される技術用語も含める
- 3〜10個を目安

**出力**: キーワードリスト

### Step 2: 全文検索（経路1）

**ツール**: _knowledge-search/_full-text-search.md

**やること**: `_knowledge-search/_full-text-search.md` を実行する。入力はStep 1のキーワードリスト。

**出力**: ヒットしたセクションのリスト（file, section_id）

### Step 3: 分岐判定

**ツール**: メモリ内（エージェント判断）

**やること**: Step 2の結果を評価し、次のステップを決定する。

**判断基準**:

| ヒット件数 | 判定 | 次のステップ |
|---|---|---|
| 1件以上 | ヒットあり | Step 6（セクション判定） |
| 0件 | ヒットなし | Step 4（ファイル選定 → インデックス検索） |

### Step 4: ファイル選定（経路2）

**ツール**: _knowledge-search/_file-search.md

**やること**: `_knowledge-search/_file-search.md` を実行する。入力は検索クエリとindex.toon。

**出力**: 候補ファイルのリスト

**分岐**: 候補ファイルが0件の場合は空のポインタJSONを返して終了。

空のポインタJSON: `{"results": []}`

### Step 5: セクション選定（経路2）

**ツール**: _knowledge-search/_section-search.md

**やること**: `_knowledge-search/_section-search.md` を実行する。入力はStep 4の候補ファイルのリストとStep 1のキーワードリスト。

**出力**: 候補セクションのリスト

### Step 6: セクション判定（共通）

**ツール**: _knowledge-search/_section-judgement.md

**やること**: `_knowledge-search/_section-judgement.md` を実行する。入力は候補セクションのリスト（Step 2またはStep 5から）。

**出力**: 関連セクション（High/Partial）

### Step 7: ポインタJSON返却

**ツール**: メモリ内（エージェントがJSON組み立て）

**やること**: Step 6の関連セクションをポインタJSON形式に変換する。

**組み立てルール**:
- relevance降順でソート（high → partial）
- 同一relevance内はファイルパスでソート（安定順序）
- 件数上限: なし（Step 6で絞り込み済み）

**出力**: ポインタJSON
