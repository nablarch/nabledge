# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/http_messaging/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/RequestMessage.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/MessagingAction.html)

## HTTPメッセージングの構成

> **重要**: 本機能ではなく、:ref:`RESTfulウェブサービス <restful_web_service>` の使用を推奨する。詳細は、[RESTfulウェブサービスを推奨する理由](../restful-web-service/restful-web-service-web_service.md) を参照。

Nablarchウェブアプリケーションと同じ構成となる。詳細は、[web_application-structure](../web-application/web-application-architecture.md) を参照。

<details>
<summary>keywords</summary>

HTTPメッセージング構成, RESTfulウェブサービス推奨, web_application-structure, ウェブサービス構築

</details>

## HTTPメッセージングの処理の流れ

HTTPメッセージング機能がリクエストを処理し、レスポンスを返却するまでの処理の流れ:

1. [WebFrontController](../web-application/web-application-web_front_controller.md) (`javax.servlet.Filter` の実装クラス)がrequestを受信する。
2. [WebFrontController](../web-application/web-application-web_front_controller.md) は、requestに対する処理をハンドラキュー(handler queue)に委譲する。
3. ハンドラキューに設定されたディスパッチハンドラ(`DispatchHandler`) が、URIを元に処理すべきアクションクラス(action class)を特定しハンドラキューの末尾に追加する。
4. アクションクラス(action class)は、フォームクラス(form class)やエンティティクラス(entity class)を使用して業務ロジック(business logic) を実行する。各クラスの詳細は、:ref:`http_messaging-design` を参照。
5. アクションクラス(action class)は、処理結果を示す `ResponseMessage` を作成し返却する。
6. ハンドラキュー内の [http_messaging_response_building_handler](../../component/handlers/handlers-http_messaging_response_building_handler.md) が、`ResponseMessage` をクライアントに返却するレスポンス(jsonやxmlなど)に変換し、クライアントへ応答を返す。

<details>
<summary>keywords</summary>

WebFrontController, DispatchHandler, ResponseMessage, HTTPメッセージング処理フロー, アクションクラス, ハンドラキュー

</details>

## HTTPメッセージングで使用するハンドラ

**リクエストやレスポンスの変換を行うハンドラ**
- [http_response_handler](../../component/handlers/handlers-http_response_handler.md)
- [http_messaging_request_parsing_handler](../../component/handlers/handlers-http_messaging_request_parsing_handler.md)
- [http_messaging_response_building_handler](../../component/handlers/handlers-http_messaging_response_building_handler.md)
- [message_resend_handler](../../component/handlers/handlers-message_resend_handler.md)

**リクエストのフィルタリングを行うハンドラ**
- :ref:`service_availability`
- :ref:`permission_check_handler`

**データベースに関連するハンドラ**
- [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)
- [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)

**エラー処理に関するハンドラ**
- [global_error_handler](../../component/handlers/handlers-global_error_handler.md)
- [http_messaging_error_handler](../../component/handlers/handlers-http_messaging_error_handler.md)

**その他のハンドラ**
- [http_request_java_package_mapping](../../component/handlers/handlers-http_request_java_package_mapping.md)
- [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md)
- [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md)
- [http_access_log_handler](../../component/handlers/handlers-http_access_log_handler.md)

<details>
<summary>keywords</summary>

http_response_handler, http_messaging_request_parsing_handler, http_messaging_response_building_handler, message_resend_handler, service_availability, permission_check_handler, database_connection_management_handler, transaction_management_handler, global_error_handler, http_messaging_error_handler, http_request_java_package_mapping, thread_context_handler, thread_context_clear_handler, http_access_log_handler, ハンドラキュー構築

</details>

## HTTPメッセージングの最小ハンドラ構成

| No. | ハンドラ | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|
| 1 | [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md) | — | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) でスレッドローカル上に設定した値を全て削除する。 | — |
| 2 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | — | — | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 3 | [http_response_handler](../../component/handlers/handlers-http_response_handler.md) | — | サーブレットフォーワード、リダイレクト、レスポンス書き込みのいずれかを行う。 | 実行時例外、またはエラーの場合、既定のエラーページを表示する。 |
| 4 | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) | リクエストの情報からリクエストIDなどのスレッドコンテキスト変数を初期化する。 | — | — |
| 5 | [http_messaging_error_handler](../../component/handlers/handlers-http_messaging_error_handler.md) | — | 後続ハンドラで生成したレスポンスのボディが空の場合、ステータスコードに応じたデフォルトのボディを設定する。 | ログ出力及び、例外に応じたレスポンスを生成する。 |
| 6 | [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) | リクエストパスから処理対象の業務アクションを特定し、ハンドラキューの末尾に追加する。 | — | — |
| 7 | [http_messaging_request_parsing_handler](../../component/handlers/handlers-http_messaging_request_parsing_handler.md) | httpリクエストのボディを解析し `RequestMessage` を生成し、後続のハンドラにリクエストオブジェクトとして引き渡す。 | — | — |
| 8 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md) | DB接続を取得する。 | DB接続を解放する。 | — |
| 9 | [http_messaging_response_building_handler](../../component/handlers/handlers-http_messaging_response_building_handler.md) | — | — | 業務アクションが生成したエラー用のメッセージを元に、エラー用のhttpスポンスを生成する。 |
| 10 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) | トランザクションを開始する。 | トランザクションをコミットする。 | トランザクションをロールバックする。 |
| 11 | [http_messaging_response_building_handler](../../component/handlers/handlers-http_messaging_response_building_handler.md) | — | 業務アクションが生成したメッセージを元に、http用のレスポンスを生成する。 | 後続ハンドラで発生した例外を元にエラー用のhttpレスポンスを生成する。 |

<details>
<summary>keywords</summary>

最小ハンドラ構成, thread_context_clear_handler, global_error_handler, http_response_handler, thread_context_handler, http_messaging_error_handler, request_path_java_package_mapping, http_messaging_request_parsing_handler, database_connection_management_handler, http_messaging_response_building_handler, transaction_management_handler, RequestMessage

</details>

## HTTPメッセージングで使用するアクション

- `MessagingAction (同期応答メッセージング用アクションのテンプレートクラス)`

<details>
<summary>keywords</summary>

MessagingAction, nablarch.fw.messaging.action.MessagingAction, 同期応答メッセージング, アクションクラス

</details>
