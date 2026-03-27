# リクエスト単体テスト（HTTP同期応答メッセージ送信処理）

## HTTP同期応答メッセージ送信のリクエスト単体テスト

HTTP同期応答メッセージ送信のリクエスト単体テストは [RequestUnitTest_send_sync](testing-framework-RequestUnitTest_send_sync.md) と同じ方法。ただし、以下のように読み替えること：

| 同期応答メッセージ送信 | HTTP同期応答メッセージ送信 |
|---|---|
| MockMessagingContext | MockMessagingClient |
| RequestTestingMessagingProvider | RequestTestingMessagingClient |

<details>
<summary>keywords</summary>

MockMessagingClient, MockMessagingContext, RequestTestingMessagingClient, RequestTestingMessagingProvider, HTTP同期応答メッセージ送信, リクエスト単体テスト, クラス読み替え

</details>
