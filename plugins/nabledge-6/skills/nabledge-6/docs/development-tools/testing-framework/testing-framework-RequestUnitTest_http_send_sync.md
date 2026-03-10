# リクエスト単体テスト（HTTP同期応答メッセージ送信処理）

**公式ドキュメント**: [リクエスト単体テスト（HTTP同期応答メッセージ送信処理）](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/RequestUnitTest_http_send_sync.html)

## クラス名の読み替え

HTTP同期応答メッセージ送信処理のリクエスト単体テストは、[RequestUnitTest_send_sync](testing-framework-RequestUnitTest_send_sync.md) のテスト方法を参照し、以下のクラス名を読み替えて使用すること。

| 同期応答メッセージ送信 | HTTP同期応答メッセージ送信 |
|---|---|
| MockMessagingContext | MockMessagingClient |
| RequestTestingMessagingProvider | RequestTestingMessagingClient |

> **補足**: リクエスト単体テストの概要については、:ref:`message_httpSendSyncMessage_test` を参照。

<details>
<summary>keywords</summary>

MockMessagingClient, MockMessagingContext, RequestTestingMessagingClient, RequestTestingMessagingProvider, HTTP同期応答メッセージ送信, リクエスト単体テスト, クラス名読み替え

</details>
