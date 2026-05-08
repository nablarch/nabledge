## HTTP同期応答メッセージング実行制御基盤

本節で解説する [HTTP同期応答メッセージング実行制御基盤](../../processing-pattern/http-messaging/http-messaging-messaging-http.md) では、
外部から送信されたHTTPリクエスト中のリクエストIDをもとに、実行する業務アプリケーションを決定し、
その処理結果をもとにHTTPレスポンスを作成して送信する制御基盤を提供する。
サーブレットとしての処理方式を採用しているため、Webコンテナ上での動作を前提とする。

-----

-----

-----

### 基本構造

[HTTP同期応答メッセージング実行制御基盤](../../processing-pattern/http-messaging/http-messaging-messaging-http.md) の構造は、前半の **実行基盤部分** と後半の **制御基盤部分** の2つに大きく分かれる。

**実行基盤部分** は [Webフロントコントローラ (サーブレットフィルタ)](../../component/handlers/handlers-WebFrontController.md) を起点として、
[HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) や [HTTPメッセージングエラー制御ハンドラ](../../component/handlers/handlers-HttpMessagingErrorHandler.md) といった
[画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) にて利用されるハンドラを利用することでHTTPを通信プロトコルとした送受信処理を行う。

**制御基盤部分** は [開閉局制御ハンドラ](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md) や [再送電文制御ハンドラ](../../component/handlers/handlers-MessageResendHandler.md) といった
[MOM同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) にて利用されるハンドラを利用することでエンタープライズメッセージング処理としての実行制御を行う。

これら２つの主要機能は取り扱うデータ形式が異なるため、その差異を吸収する役割を [HTTPメッセージングリクエスト変換ハンドラ](../../component/handlers/handlers-HttpMessagingRequestParsingHandler.md) と
[HTTPメッセージングレスポンス変換ハンドラ](../../component/handlers/handlers-HttpMessagingResponseBuildingHandler.md) が担う。

具体的なハンドラ構成については後述の標準ハンドラ構成を参照のこと。

### 業務アクションハンドラの実装

業務アクションハンドラはFWが提供するテンプレートクラスを継承して作成する。
詳細は以下のドキュメントを参照すること。

* [同期応答電文送信処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-MessagingAction.md)

### 標準ハンドラ構成と主要処理フロー

以下は、 [HTTP同期応答メッセージング実行制御基盤](../../processing-pattern/http-messaging/http-messaging-messaging-http.md) の標準ハンドラ構成と、その上で発生しうる主要な処理フローを表したものである。

| 区分 | 種別 | 処理フロー名 | 概要 | 機能 |
|---|---|---|---|---|
| アプリケーション初期化 | 正常フロー | 正常起動 | アプリケーションデプロイ時に、 リポジトリ、ハンドラキュー等の初期化を 行う。 | フローを表示 |
| リクエストスレッド内 制御 | 正常フロー | 業務処理正常終了 | 業務処理が正常に完了し、 呼び出し元に処理結果を返却する。 | フローを表示 |
|  | 代替フロー | ユーザエラー | 入力精査処理等で、利用者起因と思われる エラーが発生した場合は、 業務トランザクションをロールバックし、 HTTPステータス400を返却する。 | フローを表示 |
|  | 代替フロー | 再送応答 | 要求電文の再送要求フラグヘッダが設定されて いた場合、送信済み電文テーブルの内容を参照 し、該当する送信済み電文が存在した場合は、 その内容をもとに応答を作成して送信する。 | フローを表示 |
|  | 代替フロー | 業務処理エラー応答 | 業務処理でエラーが発生した場合、 業務トランザクションをロールバックし、 業務側で作成した応答電文オブジェクトを もとに電文を作成して送信する。 | フローを表示 |
|  | 異常フロー | システムエラー | 業務ロジック内で不具合等による エラーが発生した場合は、 業務トランザクションをロールバックし、 障害ログを出力した上で、 HTTPステータス500を返却する。 | フローを表示 |
|  | 異常フロー | 認可エラー | リクエストされた機能に対して、 権限を持っていなかった 場合は、HTTPステータス403を返却する。 | フローを表示 |
|  | 異常フロー | 開閉局エラー | リクエストされた業務機能 が閉局中であった場合は、 HTTPステータス503を返却する。 | フローを表示 |

**標準ハンドラ構成** (説明文をクリックすると、その処理のステップレベルでの詳細が表示されます。)

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| Nablarchサーブレットコンテキスト初期化リスナ | nablarch.fw.web.servlet.NablarchServletContextListener | - | - | サーブレットコンテキスト初期化時に、リポジトリおよびハンドラキューの初期化処理を行う。 | - | Fatalログを出力した上で再送出する。(デプロイエラーになる。) | - |
| Webフロントコントローラ (サーブレットフィルタ) | nablarch.fw.web.servlet.WebFrontController | ServletRequest/Response | - | HttpServletRequest/HttpServletResponseからHTTPリクエストオブジェクトを作成し、ハンドラキューに処理を委譲する。 | (Webコンテナ側に制御を戻す。) | このハンドラでは例外およびエラーの捕捉は行なわず、そのまま送出する。 | - |
| スレッドコンテキスト変数削除ハンドラ | nablarch.common.handler.threadcontext.ThreadContextClearHandler | Object | Object | - | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | - |
| グローバルエラーハンドラ | nablarch.fw.handler.GlobalErrorHandler | Object | Result | - | - | 全ての実行時例外・エラーを捕捉し、ログ出力を行う | - |
| HTTPレスポンスハンドラ | nablarch.fw.web.handler.HttpResponseHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容に沿ってレスポンス処理かサーブレットフォーワードのいずれかを行う。 | 既定のエラー画面をレスポンス後、例外を再送出する。ただしサーブレットフォーワード処理中にエラーが発生した場合はログ出力のみを行なう。 | - |
| スレッドコンテキスト変数設定ハンドラ(リクエストスレッド) | nablarch.common.handler.threadcontext.ThreadContextHandler_request | Object | Object | 前のループで設定されたスレッドコンテキスト変数をクリアするためここで再初期化する。 | - | - | - |
| HTTPアクセスログハンドラ | nablarch.common.web.handler.HttpAccessLogHandler | HttpRequest | HttpResponse | HTTPリクエストの内容についてログに出力する。 | 送信するHTTPレスポンスの内容についてログに出力する。 | 送信するHTTPレスポンスの内容についてログに出力する。 | - |
| HTTPメッセージングエラー制御ハンドラ | nablarch.fw.messaging.handler.HttpMessagingErrorHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容が設定されていない場合は、ステータスコードに応じたデフォルトページを遷移先に設定する。 | 送出されたエラーに応じた遷移先のHTTPレスポンスオブジェクトを返却する。送出されたエラーはリクエストスコープに設定される。 | - |
| 開閉局制御ハンドラ | nablarch.fw.common.handler.ServiceAvailabilityCheckHandler | Object | Object | リクエストＩＤ単位での開閉局制御を行う | - | - | - |
| リクエストディスパッチハンドラ | nablarch.fw.handler.RequestPathJavaPackageMapping | Request | Object | 引数として渡されたリクエストオブジェクトのリクエストパスから、処理対象の業務アクションを決定しハンドラキューに追加する。 | - | - | - |
| HTTPメッセージングリクエスト変換ハンドラ | nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler | HttpRequest | Object | HTTPリクエストデータを解析し、後続ハンドラの引数（RequestMessage）のレコードとして設定する。 | - | - | - |
| 認可制御ハンドラ | nablarch.fw.common.handler.PermissionCheckHandler | Object | Object | スレッドコンテキスト上の userId/requestId をもとに認可判定を行う。認可判定に失敗した場合は例外を送出して終了する。成功した場合は、認可情報オブジェクトをスレッドローカルに設定する。 | - | - | - |
| データベース接続管理ハンドラ | nablarch.common.handler.DbConnectionManagementHandler | Object | Object | 業務処理用ＤＢ接続を取得し、スレッドローカル上に保持する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | - |
| HTTPメッセージングレスポンス変換ハンドラ | nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler | Object | Object | - | 返却された応答データを解析し、HTTPレスポンスデータに変換する。 | エラー応答電文の内容を解析し、HTTPエラーレスポンスとして再送出する。 | - |
| トランザクション制御ハンドラ | nablarch.fw.common.handler.TransactionManagementHandler | Object | Object | 業務トランザクションの開始 | トランザクションをコミットする。 | トランザクションをロールバックする。 | 1.コミット完了後 / 2.ロールバック後 |
| HTTPメッセージングレスポンス変換ハンドラ | nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler | Object | Object | - | 返却された応答データを解析し、HTTPレスポンスデータに変換する。 | エラー応答電文の内容を解析し、HTTPエラーレスポンスとして再送出する。 | - |
| 再送電文制御ハンドラ | nablarch.fw.messaging.handler.MessageResendHandler | RequestMessage | ResponseMessage | 再送要求に対し、以前応答した電文が保存されていれば、その内容をリターンする。(後続ハンドラは実行しない) | 業務トランザクションが正常終了(コミット)された場合のみ電文を保存する | - | - |
| 同期応答電文処理用業務アクションハンドラ | nablarch.fw.action.MessagingAction | RequestMessage | ResponseMessage | 要求電文の内容をもとに業務処理を実行する。 | 業務処理の結果と要求電文の内容から応答電文の内容を作成して返却する。 | - | トランザクションロールバック時にエラー応答電文を作成する。 |
