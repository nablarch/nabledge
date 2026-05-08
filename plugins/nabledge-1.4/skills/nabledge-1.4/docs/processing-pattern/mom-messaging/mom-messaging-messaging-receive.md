## MOM応答不要メッセージング実行制御基盤

本節で解説する [MOM応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md) では、
外部から送信された要求電文の内容をDB上に一旦格納した後で、後続のバッチにより業務処理を行う仕組みを提供する。
また、受信電文に対する応答電文の送信は行わない。

本方式では、先行処理部分が極めて単純な構造となるため、フレームワークが提供する業務アクションハンドラをそのまま使用することができる。
その場合、必要な設定を行うだけでよく、コーディングは不要である。

後続のバッチ処理は、通常のバッチとして作成する。
バッチ処理の実装については、以下の各稿を参照すること。

* [都度起動バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-single-shot.md)
* [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md)

先行処理部分は、基本的に [MOM同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) の構造を踏襲する。
差異となる部分は以下の3点である。

**1. 応答電文を送信しない**

本方式では要求電文に対する応答を行わないため
[MOM同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) で使用していた以下のハンドラについては使用しない。

* [電文応答制御ハンドラ](../../component/handlers/handlers-MessageReplyHandler.md)
* [再送電文制御ハンドラ](../../component/handlers/handlers-MessageResendHandler.md)

**2. 業務アクションハンドラは作成不要**

先行処理の業務アクションハンドラは、1電文の内容をDBの1レコードとして保存する定型処理となるため、
基本的にはフレームワークが提供するハンドラに対して設定を行うだけでよい。
詳細については、以下を参照すること。

* [応答不要電文受信処理用アクションハンドラ](../../component/handlers/handlers-AsyncMessageReceiveAction.md)

**3. 2相コミットを使用する**

本方式では、電文の保存に失敗した場合にエラー応答を送信することができないので、
取得した電文を一旦キューに戻した後で既定回数に達するまでリトライする。
このため、DBに対する登録処理とキューに対する操作を1つのトランザクションとして扱う必要がある(2相コミット制御)。
具体的には、トランザクション制御ハンドラの設定を変更し、2相コミットに対応した実装に差し替える必要がある。

**4. 閉局時の挙動が異なる**

[MOM同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) では、要求された業務機能が閉局中だった場合にエラー応答電文を送信し、
業務閉局中であることを直ちに通知する設計となっている。
しかし、 [MOM応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md) では応答の送信を行わないため、
[データリードハンドラ](../../component/handlers/handlers-DataReadHandler.md) の上位に [開閉局制御ハンドラ](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md) を配置し、
閉局中はメッセージキュー上の受信電文は取得せずに滞留させ、開局後に処理するような設計となっている。

-----

-----

### 業務アクションハンドラの実装

先に述べたように、本方式での業務処理は定型処理となるため、業務アクションハンドラを実装する必要は無く、
定型処理を実装した下記のハンドラに対して必要な設定を行うだけでよい。

* [応答不要電文受信処理用アクションハンドラ](../../component/handlers/handlers-AsyncMessageReceiveAction.md)

### 標準ハンドラ構成と主要処理フロー

以下は、 [MOM応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md) の標準ハンドラ構成とその上で発生しうる処理フローを表した図である。

| 区分 | 種別 | 処理フロー名 | 概要 | 機能 |
|---|---|---|---|---|
| プロセス起動制御 | 正常フロー | 正常起動 | Javaコマンドからプロセスを起動し、 リクエストスレッドを初期化する。 各スレッドは受信キュー上で電文を待機する。 | フローを表示 |
|  | 異常フロー | 重複起動エラー | プロセス起動時、既に同一プロセスが 起動していた場合は異常終了する。 | フローを表示 |
| リクエストスレッド内 制御 | 正常フロー | 受付正常終了 | 各リクエストスレッドは、受信電文の受付後、 電文内のレコードを電文テーブルに保存する。 | フローを表示 |
|  | 代替フロー | 受信待機タイムアウト | 各リクエストスレッドは、受信キューでの 待機状態が一定時間異常継続した場合は、 プロセス管理テーブルの状態を確認するために 待機を解除してスレッドループの先頭に戻る。 | フローを表示 |
|  | 異常フロー | 受付エラー | アクションハンドラ側でエラーが発生した 場合、業務トランザクションをロールバック し、障害ログを出力する。 | フローを表示 |
|  | 代替フロー | 認可エラー | 要求電文中のリクエストID/ユーザIDヘッダの 値をもとに認可チェックを行い、 権限が無い場合は、障害ログを出力する。 | フローを表示 |
|  | 代替フロー | 閉局中待機 | 業務機能が閉局中であった場合は、 メッセージキュー上の受信電文取得処理を 休止し、再度開局するまで待機する。 閉局中に滞留した電文は開局後に処理される。 | フローを表示 |
|  | 異常フロー | DB/MQ接続エラー | DB/MQに対する接続に失敗した場合は 障害ログを出力した後、 再接続処理を行う。 | フローを表示 |
| プロセス停止制御 | 正常フロー | プロセス正常停止 | プロセス管理テーブルのフラグを変更する ことで、リクエストスレッドでの新規処理 受付を停止する。その後、全スレッドの 終了を待ってプロセスを正常終了させる。 | フローを表示 |

**標準ハンドラ構成** (説明文をクリックすると、その処理のステップレベルでの詳細が表示されます。)

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| 共通起動ランチャ | nablarch.fw.handler.Main | CommandLine | Integer | Javaコマンドから直接実行することで、DIリポジトリを初期化し、ハンドラキューを構築・実行する。 | 後続ハンドラの処理結果(整数値)を終了コードに指定し、プロセスを停止する。 | Fatalログを出力しプロセスを異常終了させる。 | - |
| ステータスコード→プロセス終了コード変換 | nablarch.fw.handler.StatusCodeConvertHandler | CommandLine | Integer | - | 後続ハンドラの処理結果をもとに、プロセス終了コード(整数値)を決定して返す。 | - | - |
| グローバルエラーハンドラ | nablarch.fw.handler.GlobalErrorHandler | Object | Result | - | - | 全ての実行時例外・エラーを捕捉し、ログ出力を行う | - |
| スレッドコンテキスト変数削除ハンドラ | nablarch.common.handler.threadcontext.ThreadContextClearHandler | Object | Object | - | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | - |
| スレッドコンテキスト変数設定ハンドラ(メインスレッド) | nablarch.common.handler.threadcontext.ThreadContextHandler_main | Object | Object | 起動引数の内容からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。 | - | - | - |
| プロセス多重起動防止ハンドラ | nablarch.fw.handler.DuplicateProcessCheckHandler | Object | Object | スレッドコンテキスト上のリクエストIDを用いて、リクエスト管理テーブル上の一致するレコードの実行ステータスを参照し、実行中であった場合は例外を送出する。 | - | - | - |
| リクエストディスパッチハンドラ | nablarch.fw.handler.RequestPathJavaPackageMapping | Request | Object | 引数として渡されたリクエストオブジェクトのリクエストパスから、処理対象の業務アクションを決定しハンドラキューに追加する。 | - | - | - |
| マルチスレッド実行制御ハンドラ | nablarch.fw.handler.MultiThreadExecutionHandler | Object | MultiStatus | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 実行コンテキスト上にデータリーダが存在しない場合は、コールバックを行う。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 | 1. 処理開始前 / 2. データリーダ作成 / 3. スレッド異常終了時 / 4. 処理完了時 |
| リトライ制御ハンドラ | nablarch.fw.handler.RetryHandler | Object | Object | - | - | リトライ可能な実行時例外を捕捉し、かつリトライ上限に達していなければ後続のハンドラを再実行する。 | - |
| メッセージングコンテキスト管理ハンドラ | nablarch.fw.messaging.handler.MessagingContextHandler | Object | Object | メッセージングコンテキスト(MQ接続)を取得し、スレッドローカルに保持する。 | メッセージングコンテキストを開放する。（プールに戻す） | メッセージングコンテキストを開放する。（プールに戻す） | - |
| データベース接続管理ハンドラ | nablarch.common.handler.DbConnectionManagementHandler | Object | Object | 業務処理用ＤＢ接続を取得し、スレッドローカル上に保持する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | - |
| リクエストスレッド内ループ制御ハンドラ | nablarch.fw.handler.RequestThreadLoopHandler | Object | Object | データリーダが閉じられるまで、後続のハンドラを繰り返し実行する。 | ハンドラキューの内容を復旧しループを継続する。 | プロセス停止か致命的なエラーが発生した場合のみループを停止する。 | - |
| スレッドコンテキスト変数削除ハンドラ | nablarch.common.handler.threadcontext.ThreadContextClearHandler | Object | Object | - | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | - |
| スレッドコンテキスト変数設定ハンドラ(リクエストスレッド) | nablarch.common.handler.threadcontext.ThreadContextHandler_request | Object | Object | 前のループで設定されたスレッドコンテキスト変数をクリアするためここで再初期化する。 | - | - | - |
| 処理停止制御ハンドラ | nablarch.fw.handler.ProcessStopHandler | Object | Object | リクエストテーブル上の処理停止フラグがオンであった場合は、後続の処理は行なわずにプロセス停止例外(ProcessStop)を送出する。 | - | - | - |
| 開閉局制御ハンドラ | nablarch.fw.common.handler.ServiceAvailabilityCheckHandler | Object | Object | リクエストＩＤ単位での開閉局制御を行う | - | - | - |
| トランザクション制御ハンドラ | nablarch.fw.common.handler.TransactionManagementHandler | Object | Object | 業務トランザクションの開始 | トランザクションをコミットする。 | トランザクションをロールバックする。 | 1.コミット完了後 / 2.ロールバック後 |
| データリードハンドラ(FW制御ヘッダリーダ/メッセージリーダ利用) | nablarch.fw.handler.DataReadHandler_messaging | Object | Result | 要求電文を受信しFW制御ヘッダ部を解析して要求電文オブジェクト(RequestMessage)を作成し後続のハンドラに渡す。また、FW制御ヘッダのrequestId/userIdの値をメッセージコンテキストに設定する。 | - | - | - |
| 認可制御ハンドラ | nablarch.fw.common.handler.PermissionCheckHandler | Object | Object | スレッドコンテキスト上の userId/requestId をもとに認可判定を行う。認可判定に失敗した場合は例外を送出して終了する。成功した場合は、認可情報オブジェクトをスレッドローカルに設定する。 | - | - | - |
| 応答不要電文受信処理用アクションハンドラ | nablarch.fw.messaging.action.AsyncMessageReceiveAction | RequestMessage | Result | 要求電文内のデータレコードを指定されたテーブルに保存する。 | 正常終了(Result.Success)をリターンする。 | - | - |
