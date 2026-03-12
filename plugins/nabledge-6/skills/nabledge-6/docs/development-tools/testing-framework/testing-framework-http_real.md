# リクエスト単体テストの実施方法（HTTP同期応答メッセージ受信処理）

**公式ドキュメント**: [リクエスト単体テストの実施方法（HTTP同期応答メッセージ受信処理）](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/http_real.html)

## 概要

本ページは :ref:`real_request_test` との記述方法の差異についてのみ解説する。基本的な実施方法は :ref:`real_request_test` を参照すること。

<details>
<summary>keywords</summary>

HTTP同期応答メッセージ受信処理, リクエスト単体テスト, real_request_test, 記述方法の差異

</details>

## テストデータの書き方

## テストショット一覧

LIST_MAPのデータタイプで1テストメソッド分のテストショット表を記載する。IDは **testShots** 固定。

| カラム名 | 説明 | 必須 |
|---|---|---|
| diConfig | HTTP同期応答メッセージ受信リクエスト単体テスト用のコンポーネント設定ファイルへのパス (例: http-messaging-test-component-configuration.xml) | ○ |
| expectedStatusCode | JSON及びXMLデータ形式使用時は空欄にする | ○ |
| requestPath | アクションを実行するためのURLからホスト名を抜いた部分 (例: /msgaction/ss11AC/RM11AC0102) | ○ |
| userId | 認証認可チェックに使用するユーザID | ○ |

> **補足**: JSON及びXMLデータ形式使用時は、ステータスコードの比較もExcelファイルのメッセージボディとの比較で行う。フレームワーク制御ヘッダもメッセージボディに含まれるため。

<details>
<summary>keywords</summary>

testShots, diConfig, expectedStatusCode, requestPath, userId, テストショット一覧, LIST_MAP, テストデータ

</details>

## リクエストメッセージ

テスト入力データとなる要求電文の記述形式。名前は `MESSAGE=setUpMessages` 固定。

**共通情報** (ディレクティブ、フレームワーク制御ヘッダ): key-value形式で記載。リクエストメッセージの全メッセージで共通の値となる。

> **重要**: フレームワーク制御ヘッダの項目をPJで変更している場合、propertiesファイルに `reader.fwHeaderfields` キーでフレームワーク制御ヘッダ名をカンマ区切りで指定すること。

```properties
# フレームワーク制御ヘッダ名をカンマ区切りで指定する。
reader.fwHeaderfields=requestId,addHeader
```

**メッセージボディ**:

| 行 | 記述内容 | 備考 |
|---|---|---|
| 1行目 | フィールド名称 | 先頭セルは"no" |
| 2行目 | データタイプ | 先頭セルは空白 |
| 3行目 | フィールド長 | 先頭セルは空白 |
| 4行目以降 | XMLデータおよびJSONデータ | 先頭セルは1からの通番。フィールドを跨いで記載可能 |

> **補足**: JSON及びXMLデータ形式使用時は、1Excelシートに1テストケースのみ記述すること。NTFの制約として各行の文字列長が同一であることを期待するため。JSON/XMLは要求電文の長さがリクエストごとに異なるので事実上1テストケースしか記述できない。

> **重要**: フィールド名称に重複した名称は許容されない（例: 「氏名」フィールドが2つ以上存在してはならない）。

<details>
<summary>keywords</summary>

MESSAGE=setUpMessages, reader.fwHeaderfields, フレームワーク制御ヘッダ, メッセージボディ, XML, JSON, 要求電文, リクエストメッセージ書式

</details>

## 各種準備データ

テスト実施に際して必要となる各種準備データ: データベースおよびリクエストメッセージを準備する。

<details>
<summary>keywords</summary>

準備データ, データベース, リクエストメッセージ, テストデータ準備

</details>

## 各種期待値

各種期待値として、レスポンスメッセージ（名前: `MESSAGE=expectedMessages`）を準備する。

<details>
<summary>keywords</summary>

期待値, レスポンスメッセージ, expectedMessages, 応答電文

</details>

## レスポンスメッセージ

リクエストメッセージと同じ形式。名前は `MESSAGE=expectedMessages` 固定。応答電文のフィールド長は `-`（ハイフン）を設定する。

![レスポンスメッセージテストデータ例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-http_real/http_real_test_data.png)

<details>
<summary>keywords</summary>

MESSAGE=expectedMessages, 応答電文, フィールド長, ハイフン, レスポンスメッセージ書式

</details>
