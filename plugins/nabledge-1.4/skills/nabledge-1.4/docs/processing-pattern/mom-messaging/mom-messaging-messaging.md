# メッセージング実行制御基盤

## メッセージング実行制御基盤の方式概要

## メッセージング実行制御基盤の方式概要

[messaging](mom-messaging-messaging.md) は外部から送信される要求電文に対し、電文中のリクエストIDに対応する業務アプリケーションを実行する仕組みで、以下の3方式が存在する。

- **同期応答メッセージング実行制御基盤**: [messaging_request_reply](mom-messaging-messaging_request_reply.md), [messaging_http](../http-messaging/http-messaging-messaging_http.md)
- **応答不要メッセージング実行制御基盤**: [messaging_receive](mom-messaging-messaging_receive.md)

### 各方式の用途・特徴

**[messaging_request_reply](mom-messaging-messaging_request_reply.md)**
- 業務処理の実行結果をもとに応答電文を作成して送信する
- オーソリ業務など即時応答を必要とする業務で使用する

**[messaging_receive](mom-messaging-messaging_receive.md)**
- 応答電文の送信は行わない
- 受信した要求電文の内容をDBテーブルに格納する
- 業務処理はこのテーブルを入力とするバッチ処理によって実行される

**[messaging_http](../http-messaging/http-messaging-messaging_http.md)**
- [messaging_request_reply](mom-messaging-messaging_request_reply.md) と同様に即時応答を必要とする業務で使用できる
- 通信プロトコルとしてHTTPを利用することを前提とした実行制御基盤

<details>
<summary>keywords</summary>

同期応答メッセージング, 応答不要メッセージング, HTTPメッセージング, messaging_request_reply, messaging_receive, messaging_http, メッセージング実行制御基盤, オーソリ業務, 即時応答, バッチ処理

</details>
