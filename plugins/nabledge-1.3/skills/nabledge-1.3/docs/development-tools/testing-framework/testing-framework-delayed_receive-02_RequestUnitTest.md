# リクエスト単体テストの実施方法（応答不要メッセージ受信処理）

## 概要

応答不要メッセージ受信処理のリクエスト単体テストでは、Nablarch提供のアクションクラスを使用する。条件網羅・限界値テストは実施不要。

**テスト対象の成果物**:
- 電文レイアウトを定義したフォーマット定義ファイル
- データベースへ電文を登録するFormクラス
- データベースへ電文を登録するINSERT文

<details>
<summary>keywords</summary>

応答不要メッセージ受信処理, リクエスト単体テスト, テスト対象の成果物, フォーマット定義ファイル, Formクラス, INSERT文

</details>

## テストクラスの書き方

テストクラス作成ルール: (1) テスト対象機能と同一パッケージ (2) クラス名は`{電文のリクエストID}RequestTest` (3) `nablarch.test.core.messaging.MessagingReceiveTestSupport`を継承

例えば、テスト対象機能のパッケージが`nablarch.sample.ss21AA`、電文のリクエストIDが`RM21AA100`の場合:

```java
package nablarch.sample.ss21AA;

// ～中略～

public class RM21AA100RequestTest extends MessagingReceiveTestSupport {
```

<details>
<summary>keywords</summary>

MessagingReceiveTestSupport, nablarch.test.core.messaging.MessagingReceiveTestSupport, テストクラス命名規則, RequestTest, MessagingReceiveTestSupport継承

</details>

## データシートの書き方

データシートの記述方法は :ref:`real_request_test` に準じる。以下の点が異なる。

**正常系のケース**:

このケースでは、電文が正しくデータベースに取り込まれることを確認する。

> **注意**: 応答不要メッセージ受信処理では応答電文が存在しないため、応答電文の確認は不要。データシートへの以下の記述は不要:
> - `MESSAGE=expectedMessages` の定義

<details>
<summary>keywords</summary>

データシート, 応答電文不要, MESSAGE=expectedMessages, 正常系テスト, real_request_test

</details>
