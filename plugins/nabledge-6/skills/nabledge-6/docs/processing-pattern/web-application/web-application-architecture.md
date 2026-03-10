# アーキテクチャ概要

## ウェブアプリケーションの構成

ウェブアプリケーション構築にはServletAPIの使用を前提とする。

**コンポーネント**:

- :ref:`nablarch_servlet_context_listener` (`NablarchServletContextListener`): システムリポジトリやログの初期化処理を行うサーブレットコンテキストリスナー
- :ref:`web_front_controller` (`WebFrontController`): 受け取ったリクエストに対する処理をハンドラキューに委譲するサーブレットフィルタ

## ウェブアプリケーションの処理の流れ

1. :ref:`web_front_controller` (`jakarta.servlet.Filter`の実装クラス)がrequestを受信する。
2. :ref:`web_front_controller` はrequestに対する処理をハンドラキュー(handler queue)に委譲する。
3. ハンドラキューのディスパッチハンドラ(`DispatchHandler`)が、URIを元に処理すべきアクションクラスを特定しハンドラキューの末尾に追加する。
4. アクションクラス(action class)は、フォームクラス(form class)やエンティティクラス(entity class)を使用して業務ロジックを実行する。各クラスの詳細は [application_design](db-messaging-application_design.md) を参照。
5. アクションクラスは処理結果を示す`HttpResponse`を作成し返却する。
6. `HttpResponseHandler`が`HttpResponse`をクライアントへのレスポンスに変換する（例: JSPのServlet Forward）。
7. responseが返却される。

## ウェブアプリケーションで使用するハンドラ

プロジェクトの要件に従い、ハンドラキューを構築すること。要件によっては、プロジェクトカスタムなハンドラを作成することになる。

**リクエスト・レスポンス変換ハンドラ**:
- :ref:`http_character_encoding_handler`
- :ref:`http_response_handler`
- :ref:`forwarding_handler`
- :ref:`multipart_handler`
- :ref:`session_store_handler`
- :ref:`normalize_handler`
- :ref:`secure_handler`

**リクエストフィルタリングハンドラ**:
- :ref:`service_availability`
- :ref:`permission_check_handler`

**データベース関連ハンドラ**:
- :ref:`database_connection_management_handler`
- :ref:`transaction_management_handler`

**リクエスト検証ハンドラ**:
- :ref:`csrf_token_verification_handler`

**エラー処理ハンドラ**:
- :ref:`http_error_handler`
- :ref:`global_error_handler`

**その他**:
- :ref:`http_request_java_package_mapping`
- :ref:`nablarch_tag_handler`
- :ref:`thread_context_handler`
- :ref:`thread_context_clear_handler`
- :ref:`http_access_log_handler`
- :ref:`file_record_writer_dispose_handler`
- :ref:`health_check_endpoint_handler`

**最小ハンドラ構成**:

これをベースに、プロジェクト要件に従ってNablarchの標準ハンドラやプロジェクトで作成したカスタムハンドラを追加する。

| No. | ハンドラ | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|
| 1 | :ref:`http_character_encoding_handler` | リクエストとレスポンスに文字エンコーディングを設定する | — | — |
| 2 | :ref:`global_error_handler` | — | — | 実行時例外・エラー時にログ出力する |
| 3 | :ref:`http_response_handler` | — | サーブレットフォーワード・リダイレクト・レスポンス書き込みのいずれかを行う | 実行時例外・エラー時に既定のエラーページを表示する |
| 4 | :ref:`secure_handler` | — | レスポンスオブジェクト(`HttpResponse`)にセキュリティ関連のレスポンスヘッダを設定する | — |
| 5 | :ref:`multipart_handler` | マルチパートリクエストの内容を一時ファイルに保存する | 保存した一時ファイルを削除する | — |
| 6 | :ref:`session_store_handler` | セッションストアから内容を読み込む | セッションストアに内容を書き込む | — |
| 7 | :ref:`normalize_handler` | リクエストパラメータのノーマライズ処理を行う | — | — |
| 8 | :ref:`forwarding_handler` | — | 遷移先が内部フォーワードの場合、後続ハンドラを再実行する | — |
| 9 | :ref:`http_error_handler` | — | — | 例外の種類に応じたログ出力とレスポンスの生成を行う |
| 10 | :ref:`nablarch_tag_handler` | Nablarchカスタムタグの動作に必要な事前処理を行う | — | — |
| 11 | :ref:`database_connection_management_handler` | DB接続を取得する | DB接続を解放する | — |
| 12 | :ref:`transaction_management_handler` | トランザクションを開始する | トランザクションをコミットする | トランザクションをロールバックする |
| 13 | :ref:`router_adaptor` | リクエストパスをもとに呼び出すアクションを決定する | — | — |
