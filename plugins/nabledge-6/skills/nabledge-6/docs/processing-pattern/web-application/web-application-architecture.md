# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html)

## ウェブアプリケーションの構成

ウェブアプリケーション構築にはServletAPIの使用を前提とする。

**コンポーネント**:

- [nablarch_servlet_context_listener](web-application-nablarch_servlet_context_listener.md) (`NablarchServletContextListener`): システムリポジトリやログの初期化処理を行うサーブレットコンテキストリスナー
- [web_front_controller](web-application-web_front_controller.md) (`WebFrontController`): 受け取ったリクエストに対する処理をハンドラキューに委譲するサーブレットフィルタ

<details>
<summary>keywords</summary>

NablarchServletContextListener, WebFrontController, ウェブアプリケーション構成, サーブレットコンテキストリスナー, ハンドラキュー, ServletAPI

</details>

## ウェブアプリケーションの処理の流れ

1. [web_front_controller](web-application-web_front_controller.md) (`jakarta.servlet.Filter`の実装クラス)がrequestを受信する。
2. [web_front_controller](web-application-web_front_controller.md) はrequestに対する処理をハンドラキュー(handler queue)に委譲する。
3. ハンドラキューのディスパッチハンドラ(`DispatchHandler`)が、URIを元に処理すべきアクションクラスを特定しハンドラキューの末尾に追加する。
4. アクションクラス(action class)は、フォームクラス(form class)やエンティティクラス(entity class)を使用して業務ロジックを実行する。各クラスの詳細は [application_design](web-application-application_design.md) を参照。
5. アクションクラスは処理結果を示す`HttpResponse`を作成し返却する。
6. `HttpResponseHandler`が`HttpResponse`をクライアントへのレスポンスに変換する（例: JSPのServlet Forward）。
7. responseが返却される。

<details>
<summary>keywords</summary>

WebFrontController, DispatchHandler, HttpResponse, HttpResponseHandler, リクエスト処理フロー, ディスパッチハンドラ, アクションクラス, jakarta.servlet.Filter

</details>

## ウェブアプリケーションで使用するハンドラ

プロジェクトの要件に従い、ハンドラキューを構築すること。要件によっては、プロジェクトカスタムなハンドラを作成することになる。

**リクエスト・レスポンス変換ハンドラ**:
- [http_character_encoding_handler](../../component/handlers/handlers-http_character_encoding_handler.md)
- [http_response_handler](../../component/handlers/handlers-http_response_handler.md)
- [forwarding_handler](../../component/handlers/handlers-forwarding_handler.md)
- [multipart_handler](../../component/handlers/handlers-multipart_handler.md)
- [session_store_handler](../../component/handlers/handlers-SessionStoreHandler.md)
- [normalize_handler](../../component/handlers/handlers-normalize_handler.md)
- [secure_handler](../../component/handlers/handlers-secure_handler.md)

**リクエストフィルタリングハンドラ**:
- :ref:`service_availability`
- :ref:`permission_check_handler`

**データベース関連ハンドラ**:
- [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)
- [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)

**リクエスト検証ハンドラ**:
- [csrf_token_verification_handler](../../component/handlers/handlers-csrf_token_verification_handler.md)

**エラー処理ハンドラ**:
- [http_error_handler](../../component/handlers/handlers-HttpErrorHandler.md)
- [global_error_handler](../../component/handlers/handlers-global_error_handler.md)

**その他**:
- [http_request_java_package_mapping](../../component/handlers/handlers-http_request_java_package_mapping.md)
- [nablarch_tag_handler](../../component/handlers/handlers-nablarch_tag_handler.md)
- [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md)
- [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md)
- [http_access_log_handler](../../component/handlers/handlers-http_access_log_handler.md)
- [file_record_writer_dispose_handler](../../component/handlers/handlers-file_record_writer_dispose_handler.md)
- [health_check_endpoint_handler](../../component/handlers/handlers-health_check_endpoint_handler.md)

**最小ハンドラ構成**:

これをベースに、プロジェクト要件に従ってNablarchの標準ハンドラやプロジェクトで作成したカスタムハンドラを追加する。

| No. | ハンドラ | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|
| 1 | [http_character_encoding_handler](../../component/handlers/handlers-http_character_encoding_handler.md) | リクエストとレスポンスに文字エンコーディングを設定する | — | — |
| 2 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | — | — | 実行時例外・エラー時にログ出力する |
| 3 | [http_response_handler](../../component/handlers/handlers-http_response_handler.md) | — | サーブレットフォーワード・リダイレクト・レスポンス書き込みのいずれかを行う | 実行時例外・エラー時に既定のエラーページを表示する |
| 4 | [secure_handler](../../component/handlers/handlers-secure_handler.md) | — | レスポンスオブジェクト(`HttpResponse`)にセキュリティ関連のレスポンスヘッダを設定する | — |
| 5 | [multipart_handler](../../component/handlers/handlers-multipart_handler.md) | マルチパートリクエストの内容を一時ファイルに保存する | 保存した一時ファイルを削除する | — |
| 6 | [session_store_handler](../../component/handlers/handlers-SessionStoreHandler.md) | セッションストアから内容を読み込む | セッションストアに内容を書き込む | — |
| 7 | [normalize_handler](../../component/handlers/handlers-normalize_handler.md) | リクエストパラメータのノーマライズ処理を行う | — | — |
| 8 | [forwarding_handler](../../component/handlers/handlers-forwarding_handler.md) | — | 遷移先が内部フォーワードの場合、後続ハンドラを再実行する | — |
| 9 | [http_error_handler](../../component/handlers/handlers-HttpErrorHandler.md) | — | — | 例外の種類に応じたログ出力とレスポンスの生成を行う |
| 10 | [nablarch_tag_handler](../../component/handlers/handlers-nablarch_tag_handler.md) | Nablarchカスタムタグの動作に必要な事前処理を行う | — | — |
| 11 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md) | DB接続を取得する | DB接続を解放する | — |
| 12 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) | トランザクションを開始する | トランザクションをコミットする | トランザクションをロールバックする |
| 13 | [router_adaptor](../../component/adapters/adapters-router_adaptor.md) | リクエストパスをもとに呼び出すアクションを決定する | — | — |

<details>
<summary>keywords</summary>

ハンドラキュー構成, 最小ハンドラ構成, 文字エンコーディング, セッションストア, CSRFトークン検証, トランザクション管理, router_adaptor, セキュリティヘッダ

</details>
