# アーキテクチャ概要

HTTPメッセージングでは、外部(ブラウザや外部システムなど)から送信されたhttpメッセージ
を処理するウェブサービスを構築するための機能を提供している。

> **Important:**
> 本機能ではなく、 [RESTfulウェブサービス](../../processing-pattern/restful-web-service/restful-web-service-rest.md#restfulウェブサービス編) の使用を推奨する。
> 詳細は、 [RESTfulウェブサービスを推奨する理由](../../processing-pattern/restful-web-service/restful-web-service-web-service.md#ウェブサービス編) を参照。

## HTTPメッセージングの構成

Nablarchウェブアプリケーションと同じ構成となる。
詳細は、 [ウェブアプリケーションの構成](../../processing-pattern/web-application/web-application-architecture.md#ウェブアプリケーションの構成) を参照。

## HTTPメッセージングの処理の流れ

HTTPメッセージング機能がリクエストを処理し、レスポンスを返却するまでの処理の流れを以下に示す。

![http_messaging_flow.png](../../../knowledge/assets/http-messaging-architecture/http_messaging_flow.png)

1. [WebFrontController](../../processing-pattern/web-application/web-application-web-front-controller.md#webフロントコントローラ) ( javax.servlet.Filter の実装クラス)がrequestを受信する。
2. [WebFrontController](../../processing-pattern/web-application/web-application-web-front-controller.md#webフロントコントローラ) は、requestに対する処理をハンドラキュー(handler queue)に委譲する。
3. ハンドラキューに設定されたディスパッチハンドラ(DispatchHandler) が、URIを元に処理すべきアクションクラス(action class)を特定しハンドラキューの末尾に追加する。
4. アクションクラス(action class)は、フォームクラス(form class)やエンティティクラス(entity class)を使用して業務ロジック(business logic) を実行する。 
  
  各クラスの詳細は、 [アプリケーションの責務配置](../../processing-pattern/http-messaging/http-messaging-application-design.md#アプリケーションの責務配置) を参照。
5. アクションクラス(action class)は、処理結果を示す ResponseMessage を作成し返却する。
6. ハンドラキュー内の [HTTPメッセージングレスポンス変換ハンドラ](../../component/handlers/handlers-http-messaging-response-building-handler.md#httpメッセージングレスポンス変換ハンドラ) が、 ResponseMessage をクライアントに返却するレスポンス(jsonやxmlなど)に変換し、クライアントへ応答を返す。

## HTTPメッセージングで使用するハンドラ

Nablarchでは、HTTPメッセージングを使用したウェブサービスを構築するために必要なハンドラを標準で幾つか提供している。
プロジェクトの要件に従い、ハンドラキューを構築すること。(要件によっては、プロジェクトカスタムなハンドラを作成することになる)

各ハンドラの詳細は、リンク先を参照すること。

リクエストやレスポンスの変換を行うハンドラ

* [HTTPレスポンスハンドラ](../../component/handlers/handlers-http-response-handler.md#httpレスポンスハンドラ)
* [HTTPメッセージングリクエスト変換ハンドラ](../../component/handlers/handlers-http-messaging-request-parsing-handler.md#httpメッセージングリクエスト変換ハンドラ)
* [HTTPメッセージングレスポンス変換ハンドラ](../../component/handlers/handlers-http-messaging-response-building-handler.md#httpメッセージングレスポンス変換ハンドラ)
* [再送電文制御ハンドラ](../../component/handlers/handlers-message-resend-handler.md#再送電文制御ハンドラ)

リクエストのフィルタリングを行うハンドラ

* [サービス提供可否チェック](../../component/libraries/libraries-service-availability.md#サービス提供可否チェック)
* [認可チェックハンドラ](../../component/handlers/handlers-permission-check-handler.md#認可チェックハンドラ)

データベースに関連するハンドラ

* [データベース接続管理ハンドラ](../../component/handlers/handlers-database-connection-management-handler.md#データベース接続管理ハンドラ)
* [トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#トランザクション制御ハンドラ)

エラー処理に関するハンドラ

* [グローバルエラーハンドラ](../../component/handlers/handlers-global-error-handler.md#グローバルエラーハンドラ)
* [HTTPメッセージングエラー制御ハンドラ](../../component/handlers/handlers-http-messaging-error-handler.md#httpメッセージングエラー制御ハンドラ)

その他のハンドラ

* [HTTPリクエストディスパッチハンドラ](../../component/handlers/handlers-http-request-java-package-mapping.md#httpリクエストディスパッチハンドラ)
* [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#スレッドコンテキスト変数管理ハンドラ)
* [スレッドコンテキスト変数削除ハンドラ](../../component/handlers/handlers-thread-context-clear-handler.md#スレッドコンテキスト変数削除ハンドラ)
* [HTTPアクセスログハンドラ](../../component/handlers/handlers-http-access-log-handler.md#httpアクセスログハンドラ)

## HTTPメッセージングの最小ハンドラ構成

HTTPメッセージングを使用したウェブサービスを構築する際の必要最小限のハンドラキューを以下に示す。
これをベースに、プロジェクト要件に従ってNablarchの標準ハンドラやプロジェクトで作成したカスタムハンドラを追加する。

最小ハンドラ構成

| No. | ハンドラ | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|
| 1 | [スレッドコンテキスト変数削除ハンドラ](../../component/handlers/handlers-thread-context-clear-handler.md#スレッドコンテキスト変数削除ハンドラ) |  | [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#スレッドコンテキスト変数管理ハンドラ) でスレッドローカル上に設定した値を全て削除する。 |  |
| 2 | [グローバルエラーハンドラ](../../component/handlers/handlers-global-error-handler.md#グローバルエラーハンドラ) |  |  | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 3 | [HTTPレスポンスハンドラ](../../component/handlers/handlers-http-response-handler.md#httpレスポンスハンドラ) |  | サーブレットフォーワード、リダイレクト、レスポンス書き込みのいずれかを行う。 | 実行時例外、またはエラーの場合、既定のエラーページを表示する。 |
| 4 | [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#スレッドコンテキスト変数管理ハンドラ) | リクエストの情報からリクエストIDなどのスレッドコンテキスト変数を初期化する。 |  |  |
| 5 | [HTTPメッセージングエラー制御ハンドラ](../../component/handlers/handlers-http-messaging-error-handler.md#httpメッセージングエラー制御ハンドラ) |  | 後続ハンドラで生成したレスポンスのボディが空の場合、ステータスコードに応じたデフォルトのボディを設定する。 | ログ出力及び、例外に応じたレスポンスを生成する。 |
| 6 | [リクエストディスパッチハンドラ](../../component/handlers/handlers-request-path-java-package-mapping.md#リクエストディスパッチハンドラ) | リクエストパスから処理対象の業務アクションを特定し、ハンドラキューの末尾に追加する。 |  |  |
| 7 | [HTTPメッセージングリクエスト変換ハンドラ](../../component/handlers/handlers-http-messaging-request-parsing-handler.md#httpメッセージングリクエスト変換ハンドラ) | httpリクエストのボディを解析し RequestMessage を生成し、 後続のハンドラにリクエストオブジェクトとして引き渡す。 |  |  |
| 8 | [データベース接続管理ハンドラ](../../component/handlers/handlers-database-connection-management-handler.md#データベース接続管理ハンドラ) | DB接続を取得する。 | DB接続を解放する。 |  |
| 9 | [HTTPメッセージングレスポンス変換ハンドラ](../../component/handlers/handlers-http-messaging-response-building-handler.md#httpメッセージングレスポンス変換ハンドラ) |  |  | 業務アクションが生成したエラー用のメッセージを元に、エラー用のhttpスポンスを生成する。 |
| 10 | [トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#トランザクション制御ハンドラ) | トランザクションを開始する。 | トランザクションをコミットする。 | トランザクションをロールバックする。 |
| 11 | [HTTPメッセージングレスポンス変換ハンドラ](../../component/handlers/handlers-http-messaging-response-building-handler.md#httpメッセージングレスポンス変換ハンドラ) |  | 業務アクションが生成したメッセージを元に、http用のレスポンスを生成する。 | 後続ハンドラで発生した例外を元にエラー用のhttpレスポンスを生成する。 |

## HTTPメッセージングで使用するアクション

Nablarchでは、HTTPメッセージングを構築するために必要なアクションクラスを標準で提供している。
詳細は、リンク先を参照すること。

* MessagingAction (同期応答メッセージング用アクションのテンプレートクラス)
