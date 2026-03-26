# MOM応答不要メッセージング実行制御基盤

## 

[messaging_receive](mom-messaging-messaging_receive.md) は、受信した要求電文をDBに格納し後続バッチで業務処理を行う方式。応答電文の送信は行わない。

先行処理部分は [messaging_request_reply](mom-messaging-messaging_request_reply.md) の構造を踏襲するが、以下の4点が異なる。

1. **応答電文を送信しない**: [../handler/MessageReplyHandler](../../component/handlers/handlers-MessageReplyHandler.md) および [../handler/MessageResendHandler](../../component/handlers/handlers-MessageResendHandler.md) は使用しない
2. **業務アクションハンドラは作成不要**: 1電文をDBの1レコードとして保存する定型処理は [../handler/AsyncMessageReceiveAction](../../component/handlers/handlers-AsyncMessageReceiveAction.md) が担う。設定のみで動作し、コーディング不要
3. **2相コミットを使用する**: 電文保存失敗時にエラー応答を送信できないため、取得電文をキューに戻してリトライする。DBへの登録処理とキュー操作を1トランザクションとして扱う（2相コミット制御）必要があり、トランザクション制御ハンドラを2相コミット対応実装に差し替える
4. **閉局時の挙動が異なる**: [messaging_request_reply](mom-messaging-messaging_request_reply.md) は閉局中にエラー応答電文を送信して即通知するが、本方式は応答を送信しない。[../handler/DataReadHandler](../../component/handlers/handlers-DataReadHandler.md) の上位に [../handler/ServiceAvailabilityCheckHandler](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md) を配置し、閉局中はキュー上の受信電文を取得せず滞留させ、開局後に処理する

<details>
<summary>keywords</summary>

MOM応答不要メッセージング, messaging_receive, AsyncMessageReceiveAction, MessageReplyHandler, MessageResendHandler, ServiceAvailabilityCheckHandler, DataReadHandler, 2相コミット, 閉局中待機, 応答不要メッセージング

</details>

## 業務アクションハンドラの実装

業務アクションハンドラの実装は不要。[../handler/AsyncMessageReceiveAction](../../component/handlers/handlers-AsyncMessageReceiveAction.md) に対して必要な設定を行うだけでよい。

<details>
<summary>keywords</summary>

AsyncMessageReceiveAction, 業務アクションハンドラ, MOM受信アクション, 受信電文DB保存

</details>

## 標準ハンドラ構成と主要処理フロー

**処理フロー一覧**

| 区分 | 種別 | 処理フロー名 | 概要 |
|---|---|---|---|
| プロセス起動制御 | 正常フロー | 正常起動 | Javaコマンドからプロセスを起動し、リクエストスレッドを初期化する。各スレッドは受信キュー上で電文を待機する |
| プロセス起動制御 | 異常フロー | 重複起動エラー | プロセス起動時、既に同一プロセスが起動していた場合は異常終了する |
| リクエストスレッド内制御 | 正常フロー | 受付正常終了 | 受信電文の受付後、電文内のレコードを電文テーブルに保存する |
| リクエストスレッド内制御 | 代替フロー | 受信待機タイムアウト | 受信キューでの待機が一定時間継続した場合、プロセス管理テーブルの状態を確認するため待機を解除してスレッドループ先頭に戻る |
| リクエストスレッド内制御 | 異常フロー | 受付エラー | アクションハンドラ側でエラーが発生した場合、業務トランザクションをロールバックし障害ログを出力する |
| リクエストスレッド内制御 | 代替フロー | 認可エラー | 要求電文中のリクエストID/ユーザIDヘッダをもとに認可チェックし、権限が無い場合は障害ログを出力する |
| リクエストスレッド内制御 | 代替フロー | 閉局中待機 | 業務機能が閉局中の場合、受信電文取得処理を休止し開局まで待機する。閉局中に滞留した電文は開局後に処理される |
| リクエストスレッド内制御 | 異常フロー | DB/MQ接続エラー | DB/MQへの接続失敗時は障害ログ出力後、再接続処理を行う |
| プロセス停止制御 | 正常フロー | プロセス正常停止 | プロセス管理テーブルのフラグ変更により新規処理受付を停止し、全スレッドの終了を待ってプロセスを正常終了させる |

**標準ハンドラ構成**

1. Main
2. StatusCodeConvertHandler
3. GlobalErrorHandler
4. ThreadContextClearHandler
5. ThreadContextHandler_main
6. DuplicateProcessCheckHandler
7. RequestPathJavaPackageMapping
8. MultiThreadExecutionHandler
9. RetryHandler
10. MessagingContextHandler
11. DbConnectionManagementHandler
12. RequestThreadLoopHandler
13. ThreadContextClearHandler
14. ThreadContextHandler_request
15. ProcessStopHandler
16. ServiceAvailabilityCheckHandler
17. TransactionManagementHandler
18. DataReadHandler_messaging
19. PermissionCheckHandler
20. AsyncMessageReceiveAction

**処理フロー詳細**

**正常起動**

1. Main (inbound)
2. ThreadContextHandler_main (inbound)
3. MultiThreadExecutionHandler (inbound)
4. MessagingContextHandler (inbound): 取得したMQ接続を以降の処理で使いまわす
5. DbConnectionManagementHandler (inbound): 取得したDB接続を以降の処理で使いまわす
6. RequestThreadLoopHandler (inbound): このハンドラ以降の処理をリクエスト毎にループする
7. DataReadHandler_messaging (inbound): 受信キュー上の要求電文を待機する。要求電文受信後は業務処理を繰り返す

**重複起動エラー**

1. Main (inbound)
2. ThreadContextHandler_main (inbound): 起動引数-requestPathからリクエストIDを決定する
3. DuplicateProcessCheckHandler (inbound): 起動停止時の終了コードはこのハンドラに設定する
4. GlobalErrorHandler (error): 障害ログを出力する
5. StatusCodeConvertHandler (outbound)
6. Main (outbound): 異常終了

**受付正常終了**

1. RequestPathJavaPackageMapping (inbound): AsyncMessageReceiveActionにディスパッチする
2. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
3. ThreadContextHandler_request (inbound)
4. TransactionManagementHandler (inbound)
5. DataReadHandler_messaging (inbound)
6. AsyncMessageReceiveAction (inbound)
7. AsyncMessageReceiveAction (outbound)
8. TransactionManagementHandler (outbound)
9. RequestThreadLoopHandler (outbound): →②へ

**電文受信タイムアウト**

1. DataReadHandler_messaging (outbound): タイムアウト間隔を経過してもメッセージを受信できなかった場合、DataReader.NoMoreRecordをリターンする
2. RequestThreadLoopHandler (outbound): →③へ
3. RequestThreadLoopHandler (inbound)
4. ProcessStopHandler (inbound): プロセス停止フラグ確認後、⑤にもどる
5. DataReadHandler_messaging (inbound)

**受付エラー**

1. RequestPathJavaPackageMapping (inbound): AsyncMessageReceiveActionにディスパッチする
2. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
3. ThreadContextHandler_request (inbound)
4. TransactionManagementHandler (inbound)
5. DataReadHandler_messaging (inbound)
6. AsyncMessageReceiveAction (inbound): 電文データ部の形式エラー等の事由により実行時例外が発生
7. TransactionManagementHandler (error)
8. RequestThreadLoopHandler (error): 障害ログを出力した後、→②へ

**認可エラー**

1. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound)
3. DataReadHandler_messaging (inbound)
4. PermissionCheckHandler (inbound): 認可エラー(Result.Forbidden/ステータスコード:403)を送出する
5. TransactionManagementHandler (error)
6. RequestThreadLoopHandler (error): 起因例外を障害ログとして出力した後、→①へ

**閉局中待機**

1. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound)
3. ServiceAvailabilityCheckHandler (inbound): 閉局エラー(Result.ServiceUnavailable)を送出する
4. RequestThreadLoopHandler (error): INFOログを出力し、一定時間待機後、→①へ。開局するまでループする

**DB/MQ接続エラー**

1. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
2. AsyncMessageReceiveAction (inbound): 電文保存中にDB接続エラーが発生した場合、リトライ可能実行時例外(Retryableを実装した例外)が送出される
3. RequestThreadLoopHandler (error): リトライ可能例外はそのまま再送出する
4. RetryHandler (error): →⑤へ
5. MessagingContextHandler (inbound): MQ再接続
6. DbConnectionManagementHandler (inbound): DB再接続 → ①にもどる

**プロセス正常停止**

1. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound): リクエストIDの値が起動引数-requestPathで指定された値に戻される
3. ProcessStopHandler (inbound)
4. RequestThreadLoopHandler (error): プロセス停止要求(ProcessStop)を捕捉するとINFOログを出力後、処理結果オブジェクトをリターンする（ステータスコード:200）
5. MultiThreadExecutionHandler (outbound)
6. StatusCodeConvertHandler (outbound): ステータスコード:200 → 終了コード:0
7. Main (outbound): 正常終了

<details>
<summary>keywords</summary>

標準ハンドラ構成, 処理フロー, 正常起動, 重複起動エラー, 受付正常終了, 受信待機タイムアウト, 受付エラー, 認可エラー, 閉局中待機, DB/MQ接続エラー, プロセス正常停止, StatusCodeConvertHandler, GlobalErrorHandler, ThreadContextClearHandler, ThreadContextHandler_main, ThreadContextHandler_request, MultiThreadExecutionHandler, RequestPathJavaPackageMapping, RequestThreadLoopHandler, MessagingContextHandler, DbConnectionManagementHandler, AsyncMessageReceiveAction, ServiceAvailabilityCheckHandler, RetryHandler, ProcessStopHandler, DuplicateProcessCheckHandler, TransactionManagementHandler, DataReadHandler_messaging, PermissionCheckHandler

</details>
