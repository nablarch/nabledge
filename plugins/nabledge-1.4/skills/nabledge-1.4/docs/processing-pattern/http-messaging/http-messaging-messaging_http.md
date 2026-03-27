# HTTP同期応答メッセージング実行制御基盤

## 基本構造

HTTP同期応答メッセージング（[messaging_http](http-messaging-messaging_http.md)）は、受信HTTPリクエストのリクエストIDをもとに業務アプリケーションを決定し、処理結果からHTTPレスポンスを作成・送信する制御基盤。サーブレット方式のためWebコンテナ上での動作が前提。

構造は **実行基盤部分** と **制御基盤部分** の2つに分かれる:

- **実行基盤部分**: [../handler/WebFrontController](../../component/handlers/handlers-WebFrontController.md) を起点として、[../handler/HttpResponseHandler](../../component/handlers/handlers-HttpResponseHandler.md)、[../handler/HttpMessagingErrorHandler](../../component/handlers/handlers-HttpMessagingErrorHandler.md) 等を使用しHTTP送受信処理を行う
- **制御基盤部分**: [../handler/ServiceAvailabilityCheckHandler](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md)、[../handler/MessageResendHandler](../../component/handlers/handlers-MessageResendHandler.md) 等を使用してエンタープライズメッセージング処理の実行制御を行う
- 2つの主要機能間のデータ形式差異は [../handler/HttpMessagingRequestParsingHandler](../../component/handlers/handlers-HttpMessagingRequestParsingHandler.md) と [../handler/HttpMessagingResponseBuildingHandler](../../component/handlers/handlers-HttpMessagingResponseBuildingHandler.md) が吸収する

<details>
<summary>keywords</summary>

HTTP同期応答メッセージング, WebFrontController, HttpResponseHandler, HttpMessagingErrorHandler, ServiceAvailabilityCheckHandler, MessageResendHandler, HttpMessagingRequestParsingHandler, HttpMessagingResponseBuildingHandler, 実行基盤, 制御基盤, Webコンテナ

</details>

## 業務アクションハンドラの実装

業務アクションハンドラはFWが提供するテンプレートクラスを継承して作成する。詳細は [../handler/MessagingAction](../../component/handlers/handlers-MessagingAction.md) を参照。

<details>
<summary>keywords</summary>

MessagingAction, 業務アクションハンドラ, テンプレートクラス

</details>

## 標準ハンドラ構成と主要処理フロー

## 標準ハンドラ構成

標準ハンドラキュー（上から順に）:

1. NablarchServletContextListener
2. WebFrontController
3. ThreadContextClearHandler
4. GlobalErrorHandler
5. HttpResponseHandler
6. ThreadContextHandler_request
7. HttpAccessLogHandler
8. HttpMessagingErrorHandler
9. ServiceAvailabilityCheckHandler
10. RequestPathJavaPackageMapping
11. HttpMessagingRequestParsingHandler
12. PermissionCheckHandler
13. DbConnectionManagementHandler
14. HttpMessagingResponseBuildingHandler
15. TransactionManagementHandler
16. HttpMessagingResponseBuildingHandler
17. MessageResendHandler
18. MessagingAction

## 主要処理フロー一覧

| 区分 | 種別 | 処理フロー名 | 概要 |
|---|---|---|---|
| アプリケーション初期化 | 正常フロー | 正常起動 | デプロイ時にリポジトリ・ハンドラキュー等を初期化 |
| リクエストスレッド内制御 | 正常フロー | 業務処理正常終了 | 業務処理正常完了後、呼び出し元に処理結果を返却（HTTP 200） |
| リクエストスレッド内制御 | 代替フロー | ユーザエラー | 利用者起因エラー発生時、業務トランザクションをロールバックしHTTP 400を返却 |
| リクエストスレッド内制御 | 代替フロー | 再送応答 | 再送要求フラグヘッダが設定されている場合、送信済み電文テーブルを参照して応答を作成・送信 |
| リクエストスレッド内制御 | 代替フロー | 業務処理エラー応答 | 業務処理エラー時、業務トランザクションをロールバックし、業務側作成の応答電文オブジェクトをもとに電文を作成して送信 |
| リクエストスレッド内制御 | 異常フロー | システムエラー | 業務ロジック内エラー時、業務トランザクションをロールバックし、障害ログ出力後HTTP 500を返却 |
| リクエストスレッド内制御 | 異常フロー | 認可エラー | 権限なしリクエスト時、HTTP 403を返却 |
| リクエストスレッド内制御 | 異常フロー | 開閉局エラー | 閉局中業務機能リクエスト時、HTTP 503を返却 |

## 正常起動フロー

1. NablarchServletContextListener (往路)
2. WebFrontController (往路) — 全リクエストを対象とするサーブレットフィルタとしてデプロイされる

## 業務処理正常終了フロー

1. WebFrontController (往路)
2. ThreadContextHandler_request (往路)
3. HttpAccessLogHandler (往路)
4. RequestPathJavaPackageMapping (往路)
5. HttpMessagingRequestParsingHandler (往路)
6. DbConnectionManagementHandler (往路)
7. TransactionManagementHandler (往路)
8. MessagingAction (往路)
9. MessagingAction (復路)
10. HttpMessagingResponseBuildingHandler (復路)
11. TransactionManagementHandler (復路)
12. DbConnectionManagementHandler (復路)
13. HttpAccessLogHandler (復路)
14. HttpResponseHandler (復路) — デフォルトステータスコード: 200
15. WebFrontController (復路)

## ユーザエラーフロー（HTTP 400）

入力精査処理等でNullPointerException等の実行時例外が送出された場合:

1. WebFrontController (往路)
2. ThreadContextHandler_request (往路)
3. HttpAccessLogHandler (往路)
4. HttpMessagingRequestParsingHandler (例外) — NullPointerException等の実行時例外が送出
5. HttpAccessLogHandler (例外)
6. HttpResponseHandler (例外) — デフォルトステータスコード: 400
7. WebFrontController (復路)

## 再送応答フロー

再送要求フラグヘッダが設定されていた場合（業務アクションは実行されない）:

1. WebFrontController (往路)
2. ThreadContextHandler_request (往路)
3. RequestPathJavaPackageMapping (往路) — 再送応答時、ディスパッチされた業務アクションは実行されない
4. TransactionManagementHandler (往路)
5. MessageResendHandler (往路)
6. HttpMessagingResponseBuildingHandler (復路)
7. TransactionManagementHandler (復路)
8. HttpResponseHandler (復路) — デフォルトステータスコード: 200
9. WebFrontController (復路)

## 業務処理エラー応答フロー

業務処理で実行時例外が送出された場合:

1. WebFrontController (往路)
2. ThreadContextHandler_request (往路)
3. RequestPathJavaPackageMapping (往路)
4. HttpMessagingRequestParsingHandler (往路)
5. TransactionManagementHandler (往路)
6. MessagingAction (往路)
7. MessagingAction (例外) — 業務処理をエラー終了させる場合は実行時例外を送出。トランザクションがロールバックされ障害ログが出力される
8. TransactionManagementHandler (例外) — 業務アクションをコールバックし、その処理結果（エラー応答電文オブジェクト）を送出。起因例外をネスト
9. TransactionManagementHandler (コールバック)
10. MessagingAction (コールバック)
11. HttpMessagingResponseBuildingHandler (復路)
12. HttpMessagingErrorHandler (例外) — 一般の実行時例外を捕捉した場合は障害ログが出力される
13. HttpAccessLogHandler (復路)
14. HttpResponseHandler (例外) — 業務エラー処理で指定されたステータスコード
15. WebFrontController (復路)

## システムエラーフロー（HTTP 500）

業務ロジック内でNullPointerException等の実行時例外が送出された場合:

1. WebFrontController (往路)
2. ThreadContextHandler_request (往路)
3. HttpAccessLogHandler (往路)
4. HttpMessagingRequestParsingHandler (往路)
5. DbConnectionManagementHandler (往路)
6. TransactionManagementHandler (往路)
7. MessagingAction (往路)
8. MessagingAction (復路) — NullPointerException等の実行時例外が送出
9. HttpMessagingResponseBuildingHandler (復路)
10. TransactionManagementHandler (例外)
11. DbConnectionManagementHandler (例外)
12. HttpMessagingErrorHandler (例外) — 一般の実行時例外を捕捉した場合は障害ログが出力される
13. HttpAccessLogHandler (復路)
14. HttpResponseHandler (例外) — デフォルトステータスコード: 500
15. WebFrontController (復路)

## 認可エラーフロー（HTTP 403）

1. WebFrontController (往路) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (往路)
3. HttpMessagingRequestParsingHandler (往路)
4. PermissionCheckHandler (往路) — 認可エラー（Result.Forbidden/ステータスコード: 403）を送出
5. HttpResponseHandler (例外) — FW制御ヘッダ部のみを出力して送信し、認可エラーを再送出
6. WebFrontController (例外) — 再送出された起因例外を障害ログとして出力

## 開閉局エラーフロー（HTTP 503）

1. WebFrontController (往路) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (往路)
3. ServiceAvailabilityCheckHandler (往路) — 開閉局エラー（Result.ServiceUnavailable/ステータスコード: 503）を送出
4. HttpResponseHandler (例外) — FW制御ヘッダ部のみを出力して送信し、開閉局エラーを再送出
5. WebFrontController (例外) — 再送出された起因例外を障害ログとして出力

<details>
<summary>keywords</summary>

NablarchServletContextListener, WebFrontController, ThreadContextClearHandler, GlobalErrorHandler, HttpResponseHandler, ThreadContextHandler_request, HttpAccessLogHandler, HttpMessagingErrorHandler, ServiceAvailabilityCheckHandler, RequestPathJavaPackageMapping, HttpMessagingRequestParsingHandler, PermissionCheckHandler, DbConnectionManagementHandler, HttpMessagingResponseBuildingHandler, TransactionManagementHandler, MessageResendHandler, MessagingAction, 正常起動, 業務処理正常終了, ユーザエラー, 再送応答, 業務処理エラー応答, システムエラー, 認可エラー, 開閉局エラー, Result.Forbidden, Result.ServiceUnavailable, ハンドラ構成, 処理フロー

</details>
