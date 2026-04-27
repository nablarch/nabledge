# メッセージング実行制御基盤

messaging_request_reply
messaging_receive

[メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging.md) とは、外部から送信される各要求電文に対し、電文中のリクエストIDに対応する
業務アプリケーションを実行する仕組みであり、以下の2つの方式が存在する。

* [同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md)
* [応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md)

[同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) では、業務処理の実行結果をもとに、要求電文に対する応答電文を作成して送信することができる。
オーソリ業務のような即時応答を必要とする業務で使用される。

[応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md) では、応答電文の送信は行わず、受信した要求電文の内容をDB上のテーブルに格納する。
業務処理は、このテーブルを入力とするバッチ処理によって実行される。
