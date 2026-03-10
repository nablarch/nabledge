# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/http_messaging/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/RequestMessage.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/MessagingAction.html)

## HTTPメッセージングの構成

HTTPメッセージングでは、外部(ブラウザや外部システムなど)から送信されたhttpメッセージを処理するウェブサービスを構築するための機能を提供している。

> **重要**: 本機能ではなく、:ref:`RESTfulウェブサービス <restful_web_service>` の使用を推奨する。詳細は、:ref:`RESTfulウェブサービスを推奨する理由 <web_service-recommended_jaxrs>` を参照。

Nablarchウェブアプリケーションと同じ構成となる。詳細は、:ref:`web_application-structure` を参照。

<details>
<summary>keywords</summary>

HTTPメッセージング, RESTfulウェブサービス推奨, ウェブサービス構成, web_application-structure, Nablarchウェブアプリケーション, 外部システム, httpメッセージ処理, ウェブサービス構築

</details>

## HTTPメッセージングの処理の流れ

1. :ref:`WebFrontController <web_front_controller>` (`jakarta.servlet.Filter` の実装クラス)がrequestを受信する。
2. :ref:`WebFrontController <web_front_controller>` は、requestに対する処理をハンドラキュー(handler queue)に委譲する。
3. ディスパッチハンドラ(`DispatchHandler`)が、URIを元に処理すべきアクションクラスを特定しハンドラキューの末尾に追加する。
4. アクションクラスは、フォームクラスやエンティティクラスを使用して業務ロジックを実行する。各クラスの詳細は、:ref:`http_messaging-design` を参照。
5. アクションクラスは、処理結果を示す `ResponseMessage` を作成し返却する。
6. :ref:`http_messaging_response_building_handler` が、`ResponseMessage` をレスポンス(jsonやxmlなど)に変換し、クライアントへ応答を返す。

<details>
<summary>keywords</summary>

HTTPメッセージング処理フロー, ハンドラキュー, DispatchHandler, ResponseMessage, リクエスト処理, WebFrontController

</details>

## HTTPメッセージングで使用するハンドラ

リクエスト・レスポンス変換ハンドラ:
- :ref:`http_response_handler`
- :ref:`http_messaging_request_parsing_handler`
- :ref:`http_messaging_response_building_handler`
- :ref:`message_resend_handler`

リクエストフィルタリングハンドラ:
- :ref:`service_availability`
- :ref:`permission_check_handler`

データベース関連ハンドラ:
- :ref:`database_connection_management_handler`
- :ref:`transaction_management_handler`

エラー処理ハンドラ:
- :ref:`global_error_handler`
- :ref:`http_messaging_error_handler`

その他ハンドラ:
- :ref:`http_request_java_package_mapping`
- :ref:`thread_context_handler`
- :ref:`thread_context_clear_handler`
- :ref:`http_access_log_handler`

<details>
<summary>keywords</summary>

ハンドラキュー, http_response_handler, http_messaging_request_parsing_handler, http_messaging_response_building_handler, message_resend_handler, service_availability, permission_check_handler, database_connection_management_handler, transaction_management_handler, global_error_handler, http_messaging_error_handler, http_request_java_package_mapping, thread_context_handler, thread_context_clear_handler, http_access_log_handler

</details>

## HTTPメッセージングの最小ハンドラ構成

最小ハンドラキュー構成（これをベースにプロジェクト要件に従ってNablarch標準ハンドラまたはカスタムハンドラを追加する）:

| No. | ハンドラ | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|
| 1 | :ref:`thread_context_clear_handler` | — | :ref:`thread_context_handler` でスレッドローカル上に設定した値を全て削除する | — |
| 2 | :ref:`global_error_handler` | — | — | 実行時例外・エラーのログ出力 |
| 3 | :ref:`http_response_handler` | — | サーブレットフォーワード、リダイレクト、レスポンス書き込み | 既定のエラーページ表示 |
| 4 | :ref:`thread_context_handler` | リクエストの情報からリクエストIDなどのスレッドコンテキスト変数を初期化する | — | — |
| 5 | :ref:`http_messaging_error_handler` | — | レスポンスボディが空の場合、ステータスコードに応じたデフォルトボディを設定 | ログ出力と例外に応じたレスポンス生成 |
| 6 | :ref:`request_path_java_package_mapping` | リクエストパスから業務アクションを特定しハンドラキューの末尾に追加 | — | — |
| 7 | :ref:`http_messaging_request_parsing_handler` | httpリクエストのボディを解析し `RequestMessage` を生成し後続ハンドラに引き渡す | — | — |
| 8 | :ref:`database_connection_management_handler` | DB接続取得 | DB接続解放 | — |
| 9 | :ref:`http_messaging_response_building_handler` | — | — | 業務アクションが生成したエラー用メッセージからエラー用httpレスポンス生成 |
| 10 | :ref:`transaction_management_handler` | トランザクション開始 | トランザクションコミット | トランザクションロールバック |
| 11 | :ref:`http_messaging_response_building_handler` | — | 業務アクションが生成したメッセージからhttp用レスポンス生成 | 後続ハンドラで発生した例外からエラー用httpレスポンス生成 |

<details>
<summary>keywords</summary>

最小ハンドラ構成, thread_context_clear_handler, global_error_handler, http_response_handler, thread_context_handler, http_messaging_error_handler, request_path_java_package_mapping, http_messaging_request_parsing_handler, RequestMessage, database_connection_management_handler, http_messaging_response_building_handler, transaction_management_handler

</details>

## HTTPメッセージングで使用するアクション

**クラス**: `MessagingAction` — 同期応答メッセージング用アクションのテンプレートクラス

<details>
<summary>keywords</summary>

MessagingAction, nablarch.fw.messaging.action.MessagingAction, 同期応答メッセージング, アクションクラス

</details>
