# HTTP同期応答メッセージ送信処理を伴う取引単体テストの実施方法

## 概要

HTTP同期応答メッセージ送信処理を伴うウェブアプリケーションで取引単体テストを行う場合は、Nablarchが提供するモックアップクラスを使用する。

取引単体テスト実施方法は :ref:`dealUnitTest_send_sync` に準じる。ただし、「送信キュー」「受信キュー」は「通信先」と読み替えること。

## モックアップクラスを使用した取引単体テストの実施方法

## Excelファイルの書き方

Excelファイルに定義した応答電文のフォーマットおよびデータは、モックアップクラスが返却する応答電文を生成するために使用される。また要求電文のフォーマットは、モックアップクラスが要求電文のログを出力するために使用される。

電文フォーマットおよびデータの記載方法は :ref:`send_sync_test_data_format` と同じ。ただし、HTTP通信は要求・応答電文ともにヘッダが存在しないため、本文のみ定義する。

![Excelファイルの記載例](../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-03_DealUnitTest/http_send_sync_test_data.png)

## モックアップクラスの設定

アーキテクトが設定するものであり、アプリケーションプログラマが設定する必要はない。

**クラス**: `nablarch.test.core.messaging.MockMessagingClient`

```xml
<component name="defaultMessageSenderClient"
           class="nablarch.test.core.messaging.MockMessagingClient">
  <property name="charset" value="Shift-JIS"/>
</component>
```

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| charset |  | UTF-8 | ログ出力の文字コード名。省略時はUTF-8 |
