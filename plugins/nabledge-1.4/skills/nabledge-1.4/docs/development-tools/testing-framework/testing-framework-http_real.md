# リクエスト単体テストの実施方法（HTTP同期応答メッセージ受信処理）

## 

HTTP同期応答メッセージ受信処理のリクエスト単体テストの実施方法は :ref:`real_request_test` を参照すること。本ドキュメントでは :ref:`real_request_test` と記述方法が異なる箇所のみ解説する。

<details>
<summary>keywords</summary>

HTTP同期応答メッセージ受信処理, リクエスト単体テスト, real_request_test, テスト実施方法差分

</details>

## テストデータの書き方

テストショット一覧（LIST_MAPデータタイプ、ID: `testShots`）のHTTP同期応答メッセージ受信処理特有のカラム定義:

| カラム名 | 説明 | 必須 |
|---|---|---|
| diConfig | HTTP同期応答メッセージ受信リクエスト単体テスト用コンポーネント設定ファイルへのパス（例: http-messaging-test-component-configuration.xml） | ○ |
| expectedStatusCode | JSON/XMLデータ形式使用時は空欄にする | ○ |
| requestPath | アクション実行URLからホスト名を除いた部分（例: /msgaction/ss11AC/RM11AC0102） | ○ |
| userId | 認証認可に使用するユーザID | ○ |

> **注意**: JSON/XMLデータ形式使用時は、ステータスコードの比較もExcelファイルのメッセージボディとの比較で行う。フレームワーク制御ヘッダもメッセージボディに含まれるため。

<details>
<summary>keywords</summary>

テストショット一覧, diConfig, expectedStatusCode, requestPath, userId, HTTP同期応答メッセージ受信処理特有カラム, testShots, JSON/XMLデータ形式

</details>

## 各種準備データ

テスト実施に際して必要となる各種準備データの記述方法を説明する。バッチでは、データベース、リクエストメッセージの準備を行う。

<details>
<summary>keywords</summary>

各種準備データ, テスト準備データ, データベース準備, リクエストメッセージ準備

</details>

## リクエストメッセージ

要求電文の記述形式（名前: `MESSAGE=setUpMessages`固定）:

1. **先頭行**: `MESSAGE=setUpMessages`（固定）
2. **共通情報**（key-value形式）: ディレクティブとフレームワーク制御ヘッダを記載。リクエストメッセージ全体で共通の値となる。
3. **メッセージボディ**:

| 行 | 記述内容 | 備考 |
|---|---|---|
| 1行目 | フィールド名称 | 先頭セルは"no" |
| 2行目 | データタイプ | 先頭セルは空白 |
| 3行目 | フィールド長 | 先頭セルは空白 |
| 4行目以降 | XMLデータまたはJSONデータ | 先頭セルは1からの通番。フィールドを跨いで記載可能 |

<details>
<summary>keywords</summary>

MESSAGE=setUpMessages, setUpMessages, 要求電文, フレームワーク制御ヘッダ, メッセージボディ, XMLデータ, JSONデータ, ディレクティブ

</details>

## 

> **注意**: JSON/XMLデータ形式使用時は、1Excelシートに1テストケースのみ記述すること。NTFの制約（各行の文字列長が同一であることを期待）により、JSON/XMLはリクエスト毎に長さが異なるため事実上1テストケースのみ記述可能。

> **警告**: フィールド名称に重複した名称は許容されない。同名フィールドが2つ以上存在してはならない（例:「氏名」フィールドが2つ以上ある場合は「本会員氏名」「家族会員氏名」のようにユニークな名称を付与すること）。

<details>
<summary>keywords</summary>

JSON/XMLテストケース制約, NTF制約, 1シート1テストケース, フィールド名称重複禁止, メッセージボディ制約

</details>

## レスポンスメッセージ

期待応答電文の記述形式はリクエストメッセージ（`MESSAGE=setUpMessages`）と同様。以下の点が異なる:

- 名前: `MESSAGE=expectedMessages`（固定）
- 応答電文のフィールド長: `"-"`（ハイフン）を設定する

<details>
<summary>keywords</summary>

各種期待値, 期待値データ, レスポンスメッセージ期待値, HTTP同期応答期待値, MESSAGE=expectedMessages, expectedMessages, 応答電文, フィールド長ハイフン, 期待応答電文

</details>
