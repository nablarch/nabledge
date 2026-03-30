# メッセージング実行制御基盤

## メッセージング実行制御基盤の概要と方式

[messaging](mom-messaging-messaging.md) は、外部から送信される各要求電文に対し、電文中のリクエストIDに対応する業務アプリケーションを実行する仕組み。以下の2方式がある。

- [messaging_request_reply](mom-messaging-messaging_request_reply.md): 業務処理の実行結果をもとに応答電文を作成して送信。オーソリ業務のような即時応答が必要な業務で使用。
- [messaging_receive](mom-messaging-messaging_receive.md): 応答電文の送信は行わず、受信した要求電文の内容をDB上のテーブルに格納。業務処理はこのテーブルを入力とするバッチ処理で実行。

<details>
<summary>keywords</summary>

メッセージング実行制御, 要求応答型メッセージング, 応答不要メッセージング, 即時応答, 非同期バッチ処理, messaging_request_reply, messaging_receive

</details>
