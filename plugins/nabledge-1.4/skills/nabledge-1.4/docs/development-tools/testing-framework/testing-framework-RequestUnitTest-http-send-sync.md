# リクエスト単体テスト（HTTP同期応答メッセージ送信処理）

リクエスト単体テストのテスト方法は、 [リクエスト単体テスト（同期応答メッセージ送信処理）](../../development-tools/testing-framework/testing-framework-RequestUnitTest-send-sync.md) を参照すること。

本項では、 [リクエスト単体テスト（同期応答メッセージ送信処理）](../../development-tools/testing-framework/testing-framework-RequestUnitTest-send-sync.md) と異なる箇所の解説を行う。

ただし、以下のように読み替えること。

| 同期応答メッセージ送信 | HTTP同期応答メッセージ送信 |
|---|---|
| MockMessagingContext | MockMessagingClient |
| RequestTestingMessagingProvider | RequestTestingMessagingClient |

> **Note:**
> リクエスト単体テストそのものの概要については、
> [リクエスト単体テストの実施方法(HTTP同期応答メッセージ送信処理)](../../development-tools/testing-framework/testing-framework-02-requestunittest-http-send-sync.md#message-httpsendsyncmessage-test)
> を参照。
