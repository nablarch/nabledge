# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html)

## ウェブアプリケーションの構成

NablarchのウェブアプリケーションはServletAPIの使用を前提としている。

- [nablarch_servlet_context_listener](web-application-nablarch_servlet_context_listener.md) (NablarchServletContextListener): システムリポジトリやログの初期化処理を行うサーブレットコンテキストリスナー
- [web_front_controller](web-application-web_front_controller.md) (WebFrontController): 受け取ったリクエストに対する処理をハンドラキューに委譲するサーブレットフィルタ

<details>
<summary>keywords</summary>

NablarchServletContextListener, WebFrontController, ウェブアプリケーション構成, サーブレットコンテキストリスナー, ハンドラキュー, ServletAPI

</details>

## ウェブアプリケーションの処理の流れ

1. [web_front_controller](web-application-web_front_controller.md) (`javax.servlet.Filter`の実装クラス)がrequestを受信する。
2. [web_front_controller](web-application-web_front_controller.md) は、requestに対する処理をハンドラキュー(handler queue)に委譲する。
3. ディスパッチハンドラ(`DispatchHandler`)がURIを元に処理すべきaction classを特定しハンドラキューの末尾に追加する。
4. アクションクラス(action class)は、フォームクラス(form class)やエンティティクラス(entity class)を使用して業務ロジックを実行する。各クラスの詳細は [application_design](web-application-application_design.md) を参照。
5. action classは処理結果を示す`HttpResponse`を作成し返却する。
6. ハンドラキュー内の`HttpResponseHandler`が`HttpResponse`をクライアントへのレスポンスに変換する（例: JSPのServlet Forward）。
7. responseが返却される。

<details>
<summary>keywords</summary>

DispatchHandler, HttpResponse, HttpResponseHandler, リクエスト処理フロー, アクションクラス, handler queue

</details>

## ウェブアプリケーションで使用するハンドラ

プロジェクトの要件に従い、ハンドラキューを構築すること。(要件によっては、プロジェクトカスタムなハンドラを作成することになる)

**リクエストやレスポンスの変換を行うハンドラ**
- [http_character_encoding_handler](../../component/handlers/handlers-http_character_encoding_handler.md)
- [http_response_handler](../../component/handlers/handlers-http_response_handler.md)
- [forwarding_handler](../../component/handlers/handlers-forwarding_handler.md)
- [multipart_handler](../../component/handlers/handlers-multipart_handler.md)
- [session_store_handler](../../component/handlers/handlers-SessionStoreHandler.md)
- [normalize_handler](../../component/handlers/handlers-normalize_handler.md)
- [secure_handler](../../component/handlers/handlers-secure_handler.md)

**リクエストのフィルタリングを行うハンドラ**
- :ref:`service_availability`
- :ref:`permission_check_handler`

**データベースに関連するハンドラ**
- [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)
- [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)

**リクエストの検証を行うハンドラ**
- [csrf_token_verification_handler](../../component/handlers/handlers-csrf_token_verification_handler.md)

**エラー処理に関するハンドラ**
- [http_error_handler](../../component/handlers/handlers-HttpErrorHandler.md)
- [global_error_handler](../../component/handlers/handlers-global_error_handler.md)

**その他**
- [http_request_java_package_mapping](../../component/handlers/handlers-http_request_java_package_mapping.md)
- [nablarch_tag_handler](../../component/handlers/handlers-nablarch_tag_handler.md)
- [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md)
- [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md)
- [http_access_log_handler](../../component/handlers/handlers-http_access_log_handler.md)
- [file_record_writer_dispose_handler](../../component/handlers/handlers-file_record_writer_dispose_handler.md)
- [health_check_endpoint_handler](../../component/handlers/handlers-health_check_endpoint_handler.md)

## 最小ハンドラ構成

これをベースに、プロジェクト要件に従ってNablarchの標準ハンドラやプロジェクトで作成したカスタムハンドラを追加する。

| No. | ハンドラ | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|
| 1 | [http_character_encoding_handler](../../component/handlers/handlers-http_character_encoding_handler.md) | リクエストとレスポンスに文字エンコーディングを設定する。 | — | — |
| 2 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | — | — | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 3 | [http_response_handler](../../component/handlers/handlers-http_response_handler.md) | — | サーブレットフォーワード、リダイレクト、レスポンス書き込みのいずれかを行う。 | 実行時例外、またはエラーの場合、既定のエラーページを表示する。 |
| 4 | [secure_handler](../../component/handlers/handlers-secure_handler.md) | — | レスポンスオブジェクト(`HttpResponse`)にセキュリティ関連のレスポンスヘッダを設定する。 | — |
| 5 | [multipart_handler](../../component/handlers/handlers-multipart_handler.md) | リクエストがマルチパート形式の場合、その内容を一時ファイルに保存する。 | 保存した一時ファイルを削除する。 | — |
| 6 | [session_store_handler](../../component/handlers/handlers-SessionStoreHandler.md) | セッションストアから内容を読み込む。 | セッションストアに内容を書き込む。 | — |
| 7 | [normalize_handler](../../component/handlers/handlers-normalize_handler.md) | リクエストパラメータのノーマライズ処理を行う。 | — | — |
| 8 | [forwarding_handler](../../component/handlers/handlers-forwarding_handler.md) | — | 遷移先が内部フォーワードの場合、後続のハンドラを再実行する。 | — |
| 9 | [http_error_handler](../../component/handlers/handlers-HttpErrorHandler.md) | — | — | 例外の種類に応じたログ出力とレスポンスの生成を行う。 |
| 10 | [nablarch_tag_handler](../../component/handlers/handlers-nablarch_tag_handler.md) | Nablarchカスタムタグの動作に必要な事前処理を行う。 | — | — |
| 11 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md) | DB接続を取得する。 | DB接続を解放する。 | — |
| 12 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) | トランザクションを開始する。 | トランザクションをコミットする。 | トランザクションをロールバックする。 |
| 13 | [router_adaptor](../../component/adapters/adapters-router_adaptor.md) | リクエストパスをもとに呼び出すアクションを決定する。 | — | — |

<details>
<summary>keywords</summary>

http_character_encoding_handler, http_response_handler, session_store_handler, transaction_management_handler, 最小ハンドラ構成, ハンドラキュー構成, router_adaptor, csrf_token_verification_handler

</details>
