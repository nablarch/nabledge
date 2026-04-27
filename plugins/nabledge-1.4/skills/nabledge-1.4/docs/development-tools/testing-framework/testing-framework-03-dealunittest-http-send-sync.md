# HTTP同期応答メッセージ送信処理を伴う取引単体テストの実施方法

HTTP同期応答メッセージ送信処理を伴う画面オンライン処理で、取引単体テストを行う場合は、Nablarchが提供するモックアップクラスを使用する。

取引単体テスト実施方法は、 [同期応答メッセージ送信処理を伴う取引単体テストの実施方法](../../development-tools/testing-framework/testing-framework-03-dealunittest-send-sync.md#dealunittest-send-sync) を参照すること。

ただし、「送信キュー」「受信キュー」を「通信先」と読み替えること。

本項では、 [同期応答メッセージ送信処理を伴う取引単体テストの実施方法](../../development-tools/testing-framework/testing-framework-03-dealunittest-send-sync.md#dealunittest-send-sync) と異なる箇所の解説を行う。

## モックアップクラスを使用した取引単体テストの実施方法

### Excelファイルの書き方

取引単体テストを行う場合は、定められた記述ルールに従いExcelファイルを記載する。

Excelファイルに定義した応答電文のフォーマットおよびデータは、モックアップクラスが返却する応答電文を生成するために使用される。
また要求電文のフォーマットは、モックアップクラスが要求電文のログを出力するために使用される。

#### 書き方の例

以下に、Excelファイルの記載例を示す。

![http_send_sync_test_data.png](../../../knowledge/assets/testing-framework-03-dealunittest-http-send-sync/http_send_sync_test_data.png)

#### 電文のフォーマットおよびデータの記載方法

同期応答メッセージ送信処理の [電文のフォーマットおよびデータの記載方法](../../development-tools/testing-framework/testing-framework-03-dealunittest-send-sync.md#send-sync-test-data-format) と同じ。

ただし、HTTP通信は要求、応答電文ともにヘッダが存在しないため、本文のみ定義する。

### フレームワークで使用するクラスの設定

通常、これらの設定はアーキテクトが行うものでありアプリケーションプログラマが設定する必要はない。

#### モックアップクラスの設定

コンポーネント設定ファイルに、取引単体テストで使用するモックアップクラスを設定する。

```xml
<!-- HTTP通信用クライアント -->
<component name="defaultMessageSenderClient"
           class="nablarch.test.core.messaging.MockMessagingClient">
</component>
```
