# リクエスト単体テストの実施方法（応答不要メッセージ送信処理）

## 概要

応答不要メッセージ送信処理用のアクションクラスはNablarchが提供するため、条件網羅・限界値テストは実施不要。

**テスト対象の成果物**:
- 電文のレイアウトを定義したフォーマット定義ファイル
- 電文送信テーブルからステータスが未送信のデータを取得するSELECT文
- 電文送信後に該当データのステータスを処理済みに更新するUPDATE文
- 電文送信失敗時に該当データのステータスを送信失敗(エラー)に更新するUPDATE文

<details>
<summary>keywords</summary>

応答不要メッセージ送信処理, フォーマット定義ファイル, 電文送信テーブル, テスト対象の成果物, 条件網羅不要, 限界値テスト不要

</details>

## テストクラスの書き方

テストクラス作成ルール:
1. テスト対象機能と同一パッケージ
2. クラス名は `<電文のリクエストID>RequestTest`
3. `nablarch.test.core.batch.BatchRequestTestSupport` を継承

<details>
<summary>keywords</summary>

BatchRequestTestSupport, RequestTest, テストクラス命名規則, 電文リクエストID, nablarch.test.core.batch.BatchRequestTestSupport

</details>

## データシートの書き方

データシートの記述方法は :ref:`message_sendSyncMessage_test` を参照。本項では記述方法が異なる箇所のみ説明する。

**正常系ケース**: testShotsの定義に `KEY=messageRequestId`、`VALUE=メッセージのリクエストID` を追加すること。

> **注意**: 以下の設定は不要:
> - testShots: `responseMessage`
> - 期待値・準備データ: `RESPONSE_HEADER_MESSAGES`、`RESPONSE_BODY_MESSAGES`

**異常系ケース**: testShotsの定義に `KEY=errorCase`、`VALUE=true` を設定する。異常系では電文が送信されないため送信電文の期待値設定は不要。

> **注意**: 異常系テストケースでは、応答不要メッセージ送信処理用共通アクションをテスト用アクションに切り替える必要がある。

本番用設定:
```xml
<component name="requestPathJavaPackageMapping" class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage" value="nablarch.fw.messaging.action.AsyncMessageSendAction" />
  <property name="immediate" value="false" />
</component>
```

テスト用設定（`nablarch.test.core.messaging.AsyncMessageSendActionForUt` で上書き）:
```xml
<component name="requestPathJavaPackageMapping" class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage" value="nablarch.test.core.messaging.AsyncMessageSendActionForUt" />
  <property name="immediate" value="false" />
</component>
```

<details>
<summary>keywords</summary>

AsyncMessageSendAction, AsyncMessageSendActionForUt, messageRequestId, errorCase, testShots, 応答不要メッセージ, 異常系テスト, RESPONSE_HEADER_MESSAGES, RESPONSE_BODY_MESSAGES, RequestPathJavaPackageMapping

</details>
