# リクエスト単体テストの実施方法（応答不要メッセージ受信処理）

## 概要

応答不要メッセージ処理用のアクションクラスはNablarchの一部として提供される。このため、リクエスト単体テストではこのアクションクラスを使用して以下のテスト対象成果物の確認を行う。

> **注意**: アクションクラスはNablarch提供のため、条件網羅や限界値テストなどは実施不要。

テスト対象の成果物:
- 電文のレイアウトを定義したフォーマット定義ファイル
- データベースへ電文を登録する際に使用するFormクラス
- データベースへ電文を登録するためのINSERT文

<details>
<summary>keywords</summary>

応答不要メッセージ受信処理, リクエスト単体テスト, テスト対象成果物, フォーマット定義ファイル, Formクラス, INSERT文, 条件網羅不要, Nablarch提供アクションクラス

</details>

## テストクラスの書き方

テストクラス作成ルール: (1) テスト対象機能と同一パッケージ (2) クラス名は`{電文のリクエストID}RequestTest` (3) `MessagingReceiveTestSupport`を継承

**クラス**: `nablarch.test.core.messaging.MessagingReceiveTestSupport`

<details>
<summary>keywords</summary>

MessagingReceiveTestSupport, nablarch.test.core.messaging.MessagingReceiveTestSupport, テストクラス命名規則, リクエストID, RequestTest

</details>

## データシートの書き方

正常系ケースでは、電文が正しくデータベースに取り込まれることを確認する。

> **注意**: 応答不要メッセージ受信処理では応答電文が存在しないため、正常系ケースで`MESSAGE=expectedMessages`の定義は不要。

<details>
<summary>keywords</summary>

データシート記述方法, MESSAGE=expectedMessages, 応答電文なし, 正常系テスト, expectedMessages不要

</details>
