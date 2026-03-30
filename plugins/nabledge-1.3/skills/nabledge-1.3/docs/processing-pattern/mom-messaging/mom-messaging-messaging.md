# メッセージング実行制御基盤

## メッセージング実行制御基盤 概要

[messaging](mom-messaging-messaging.md) とは、外部から送信される各要求電文に対し、電文中のリクエストIDに対応する業務アプリケーションを実行する仕組み。以下の2方式がある。

- [messaging_request_reply](mom-messaging-messaging_request_reply.md): 業務処理の実行結果をもとに応答電文を作成して送信する。オーソリ業務のような即時応答を必要とする業務で使用される。
- [messaging_receive](mom-messaging-messaging_receive.md): 応答電文の送信は行わず、受信した要求電文の内容をDBテーブルに格納する。業務処理はこのテーブルを入力とするバッチ処理によって実行される。

<details>
<summary>keywords</summary>

メッセージング実行制御基盤, 要求電文, 応答電文, messaging_request_reply, messaging_receive, オーソリ業務, 即時応答, バッチ処理, リクエストID

</details>
