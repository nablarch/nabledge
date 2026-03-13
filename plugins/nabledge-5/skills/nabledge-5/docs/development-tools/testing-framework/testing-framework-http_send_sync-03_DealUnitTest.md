# HTTP同期応答メッセージ送信処理を伴う取引単体テストの実施方法

**公式ドキュメント**: [HTTP同期応答メッセージ送信処理を伴う取引単体テストの実施方法](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/http_send_sync.html)

## 

HTTP同期応答メッセージ送信処理を伴うウェブアプリケーションの取引単体テストには、Nablarchが提供するモックアップクラスを使用する。

基本的な実施方法は :ref:`dealUnitTest_send_sync` を参照。その際、「送信キュー」「受信キュー」は「通信先」と読み替える。

<details>
<summary>keywords</summary>

HTTP同期応答メッセージ送信, 取引単体テスト, モックアップクラス, MockMessagingClient

</details>

## モックアップクラスを使用した取引単体テストの実施方法

## Excelファイルの書き方

- 応答電文のフォーマットおよびデータ: モックアップクラスが返す応答電文の生成に使用
- 要求電文のフォーマット: モックアップクラスが要求電文ログを出力するために使用
- フォーマット/データ記載方法: [send_sync_test_data_format](testing-framework-send_sync-03_DealUnitTest.md) と同じ。ただし、HTTP通信は要求・応答ともにヘッダなし（本文のみ定義）

![Excelファイルの記載例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-03_DealUnitTest/http_send_sync_test_data.png)

## モックアップクラスの設定

通常はアーキテクトが設定（アプリケーションプログラマによる設定不要）。

**クラス**: `nablarch.test.core.messaging.MockMessagingClient`

```xml
<component name="defaultMessageSenderClient"
           class="nablarch.test.core.messaging.MockMessagingClient">
  <property name="charset" value="Shift-JIS"/>
</component>
```

`charset`プロパティでログに出力する文字コードを変更できる（省略時はUTF-8）。

<details>
<summary>keywords</summary>

nablarch.test.core.messaging.MockMessagingClient, MockMessagingClient, defaultMessageSenderClient, charset, HTTP同期応答メッセージ送信, 取引単体テスト, Excelファイル書き方, モックアップクラス設定

</details>
