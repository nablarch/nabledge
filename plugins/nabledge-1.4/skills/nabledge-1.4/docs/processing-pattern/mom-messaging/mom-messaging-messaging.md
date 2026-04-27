# メッセージング実行制御基盤

messaging_request_reply
messaging_receive
messaging_http

[メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) とは、外部から送信される各要求電文に対し、電文中のリクエストIDに対応する
業務アプリケーションを実行する仕組みであり、以下の3つの方式が存在する。

* 同期応答メッセージング実行制御基盤

  * [MOM同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md)
  * [HTTP同期応答メッセージング実行制御基盤](../../processing-pattern/http-messaging/http-messaging-messaging-http.md)
* 応答不要メッセージング実行制御基盤

  * [MOM応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md)

[MOM同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) では、業務処理の実行結果をもとに、要求電文に対する応答電文を作成して送信することができる。
オーソリ業務のような即時応答を必要とする業務で使用される。

[MOM応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md) では、応答電文の送信は行わず、受信した要求電文の内容をDB上のテーブルに格納する。
業務処理は、このテーブルを入力とするバッチ処理によって実行される。

[HTTP同期応答メッセージング実行制御基盤](../../processing-pattern/http-messaging/http-messaging-messaging-http.md) は、[MOM同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) と同様に即時応答を必要する業務で使用することができ、
通信プロトコルとしてHTTPを利用することを前提とした実行制御基盤である。
