# リクエスト単体テストの実施方法(HTTP同期応答メッセージ送信処理)

## 

リクエスト単体テストの実施方法は :ref:`message_sendSyncMessage_test` に準じる。ただし「送信キュー」「受信キュー」は「通信先」と読み替えること。

<details>
<summary>keywords</summary>

HTTP同期応答メッセージ送信処理, リクエスト単体テスト, 送信キュー, 受信キュー, 通信先, 読み替え

</details>

## テストデータの書き方

![HTTP同期応答メッセージ送信処理のテストデータ例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-02_RequestUnitTest/http_send_sync.png)

<details>
<summary>keywords</summary>

テストデータ, Excelテストデータ, HTTP同期応答, テストデータ形式

</details>

## 

モックアップを使用する場合、testShotsの"expectedMessageByClient"および"responseMessageByClient"にグループIDを設定する。

![モックアップ使用時のtestShots設定例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-02_RequestUnitTest/http_send_sync_shot.png)

<details>
<summary>keywords</summary>

expectedMessageByClient, responseMessageByClient, モックアップ, testShots, グループID

</details>

## 

同一アクション内でMOMによる同期応答メッセージ送信処理とHTTP同期応答メッセージ送信処理が同時に行われる場合:
- "expectedMessage"、"responseMessage"にMOM用グループIDを指定
- "expectedMessageByClient"、"responseMessageByClient"にHTTP用グループIDを指定

![MOM+HTTP同時使用時のtestShots設定例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-http_send_sync-02_RequestUnitTest/http_mom_send_sync_shot.png)

<details>
<summary>keywords</summary>

MOM, HTTP同期応答メッセージ送信処理, 同時使用, expectedMessage, responseMessage, expectedMessageByClient, responseMessageByClient

</details>

## 

> **注意**: グループIDはMOMによる同期応答メッセージ送信処理とHTTP同期応答メッセージ送信処理でそれぞれ別の値を設定すること。同一グループIDを指定した場合、正しく結果検証が行われない。

<details>
<summary>keywords</summary>

グループID, MOM, HTTP同期応答, 結果検証, 同一グループID, グループID重複

</details>

## 

テストデータのディレクティブ行に設定されたfile-typeの値により、要求電文のアサート方法が変化する。

<details>
<summary>keywords</summary>

file-type, 要求電文, アサート方法, ディレクティブ行

</details>

## フレームワークで使用するクラスの設定

通常、アーキテクトが設定する（アプリケーションプログラマの設定は不要）。

**モックアップクラスの設定**

**クラス**: `nablarch.test.core.messaging.RequestTestingMessagingClient`

```xml
<component name="defaultMessageSenderClient"
           class="nablarch.test.core.messaging.RequestTestingMessagingClient">
</component>
```

<details>
<summary>keywords</summary>

defaultMessageSenderClient, RequestTestingMessagingClient, モックアップクラス, コンポーネント設定, nablarch.test.core.messaging.RequestTestingMessagingClient

</details>
