# リクエスト単体テスト（HTTP同期応答メッセージ送信処理）

## クラス名の読み替え

HTTP同期応答メッセージ送信処理のリクエスト単体テストは、[RequestUnitTest_send_sync](testing-framework-RequestUnitTest_send_sync.md) のテスト方法を参照し、以下のクラス名を読み替えて使用すること。

| 同期応答メッセージ送信 | HTTP同期応答メッセージ送信 |
|---|---|
| MockMessagingContext | MockMessagingClient |
| RequestTestingMessagingProvider | RequestTestingMessagingClient |

> **補足**: リクエスト単体テストの概要については、:ref:`message_httpSendSyncMessage_test` を参照。
