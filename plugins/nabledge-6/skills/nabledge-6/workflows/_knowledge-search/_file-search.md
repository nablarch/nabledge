# File Search

index.toonから検索クエリに関連するファイルを選定する。

## 入力

検索クエリ + index.toon

## 出力

候補ファイルのリスト（パス、最大10件）

### 出力形式

```
features/libraries/universal-dao.json
features/libraries/database-access.json
features/handlers/common/db-connection-management-handler.json
```

## 手順

### Step 1: index.toonの読み込み

**ツール**: Read（index.toon読み込み）

**やること**: index.toonを読み込む。

**コマンド**:
```bash
# Read tool を使用
Read knowledge/index.toon
```

### Step 2: 候補ファイルの選定

**ツール**: メモリ内（エージェント判断）

**やること**: index.toonの内容と検索クエリを照合し、候補ファイルを選定する。

**判断基準（3軸で評価、いずれかにマッチすれば候補とする）**:

**軸1: titleとの意味的マッチング**

検索クエリの意図とtitleが意味的に関連するかを判断する。
- 例: 「ページングを実装したい」→ 「ユニバーサルDAO」はページング機能を持つので候補
- 例: 「バッチの起動方法」→ 「Nablarchバッチ（都度起動型・常駐型）」が候補

**軸2: Type/Categoryによる絞り込み**

検索クエリの意図からType/Categoryを推定し、該当するファイルを候補とする。

| 意図パターン | 推定Type/Category |
|---|---|
| 「〜を実装したい」「〜の使い方」 | component/libraries |
| 「〜ハンドラの設定」「〜の制御」 | component/handlers |
| 「バッチの構成」「RESTの設計」 | processing-pattern |
| 「テストの方法」 | development-tools/testing-framework |
| 「プロジェクトの作り方」 | setup/blank-project |
| 「セキュリティチェック」 | check/security-check |

**軸3: processing_patternsによる絞り込み**

検索クエリに処理パターンの文脈が含まれる場合、該当するprocessing_patternsを持つファイルを候補とする。
- 例: 「バッチでのDB接続」→ `nablarch-batch` を含むファイル
- 例: 「RESTのバリデーション」→ `restful-web-service` を含むファイル

**選定ルール**:
- 最大ファイル数: **10件**
- `not yet created` のファイルは**除外**
- 3軸の合計で関連度が高い順に選定
- 明らかに無関係なファイルは含めない

**出力**: 候補ファイルのリスト

## エラーハンドリング

| 状態 | 対応 |
|---|---|
| index.toonが存在しない | エラーメッセージを返す |
| 候補が0件 | 空リストを返す |
| 全候補が `not yet created` | 空リストを返し、該当エントリのtitleを付記 |
