# 応答不要メッセージング実行制御基盤

## 概要・messaging_request_replyとの差異

応答不要メッセージングは、外部から送信された要求電文をDB上に格納し、後続バッチが業務処理を行う方式。応答電文は送信しない。先行処理部分は [messaging_request_reply](mom-messaging-messaging_request_reply.md) の構造を踏襲するが、以下の4点が異なる。

**1. 応答電文を送信しない**

以下のハンドラは使用しない:
- [../handler/MessageReplyHandler](../../component/handlers/handlers-MessageReplyHandler.md)
- [../handler/MessageResendHandler](../../component/handlers/handlers-MessageResendHandler.md)

**2. 業務アクションハンドラは作成不要**

定型処理（1電文の内容をDBの1レコードとして保存）は [../handler/AsyncMessageReceiveAction](../../component/handlers/handlers-AsyncMessageReceiveAction.md) が提供するため、設定のみで対応可能。コーディング不要。

**3. 2相コミットを使用する**

電文保存失敗時にエラー応答を送信できないため、取得した電文をキューに戻してリトライする。DBへの登録処理とキューへの操作を1つのトランザクションとして扱う必要がある（2相コミット制御）。TransactionManagementHandlerの設定を変更し、2相コミット対応の実装に差し替える。

**4. 閉局時の挙動が異なる**

[messaging_request_reply](mom-messaging-messaging_request_reply.md) では閉局中にエラー応答電文を送信するが、本方式では応答を送信しないため、[../handler/DataReadHandler](../../component/handlers/handlers-DataReadHandler.md) の上位に [../handler/ServiceAvailabilityCheckHandler](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md) を配置し、閉局中は受信電文を取得せず滞留させ、開局後に処理する。

<details>
<summary>keywords</summary>

AsyncMessageReceiveAction, MessageReplyHandler, MessageResendHandler, DataReadHandler, ServiceAvailabilityCheckHandler, 応答不要メッセージング, 2相コミット, 業務アクションハンドラ, 閉局中待機, TransactionManagementHandler

</details>

## 業務アクションハンドラの実装

業務アクションハンドラの実装は不要。定型処理（1電文→DBの1レコード保存）は [../handler/AsyncMessageReceiveAction](../../component/handlers/handlers-AsyncMessageReceiveAction.md) が提供するため、設定のみで対応。

<details>
<summary>keywords</summary>

AsyncMessageReceiveAction, 業務アクションハンドラ, 定型処理

</details>

## 標準ハンドラ構成と主要処理フロー

**標準ハンドラ構成**（ハンドラキュー順）:

| No. | ハンドラ |
|---|---|
| 1 | Main |
| 2 | StatusCodeConvertHandler |
| 3 | GlobalErrorHandler |
| 4 | ThreadContextClearHandler |
| 5 | ThreadContextHandler_main |
| 6 | DuplicateProcessCheckHandler |
| 7 | RequestPathJavaPackageMapping |
| 8 | MultiThreadExecutionHandler |
| 9 | RetryHandler |
| 10 | MessagingContextHandler |
| 11 | DbConnectionManagementHandler |
| 12 | RequestThreadLoopHandler |
| 13 | ThreadContextClearHandler |
| 14 | ThreadContextHandler_request |
| 15 | ProcessStopHandler |
| 16 | ServiceAvailabilityCheckHandler |
| 17 | TransactionManagementHandler |
| 18 | DataReadHandler_messaging |
| 19 | PermissionCheckHandler |
| 20 | AsyncMessageReceiveAction |

**主要処理フロー**:

| 区分 | 種別 | 処理フロー名 | 概要 |
|---|---|---|---|
| プロセス起動制御 | 正常 | 正常起動 | Javaコマンドからプロセスを起動し、リクエストスレッドを初期化。各スレッドは受信キュー上で電文を待機する。 |
| プロセス起動制御 | 異常 | 重複起動エラー | 既に同一プロセスが起動していた場合は異常終了する。 |
| リクエストスレッド内制御 | 正常 | 受付正常終了 | 受信電文の受付後、電文内のレコードを電文テーブルに保存する。 |
| リクエストスレッド内制御 | 代替 | 受信待機タイムアウト | 受信キューでの待機状態が一定時間継続した場合、プロセス管理テーブルの状態を確認するために待機を解除してスレッドループの先頭に戻る。 |
| リクエストスレッド内制御 | 異常 | 受付エラー | アクションハンドラ側でエラーが発生した場合、業務トランザクションをロールバックし、障害ログを出力する。 |
| リクエストスレッド内制御 | 代替 | 認可エラー | 要求電文中のリクエストID/ユーザIDヘッダの値をもとに認可チェックを行い、権限が無い場合は障害ログを出力する。 |
| リクエストスレッド内制御 | 代替 | 閉局中待機 | 業務機能が閉局中の場合、メッセージキュー上の受信電文取得処理を休止し、再度開局するまで待機する。閉局中に滞留した電文は開局後に処理される。 |
| リクエストスレッド内制御 | 異常 | DB/MQ接続エラー | DB/MQに対する接続に失敗した場合は障害ログを出力した後、再接続処理を行う。 |
| プロセス停止制御 | 正常 | プロセス正常停止 | プロセス管理テーブルのフラグを変更することで新規処理受付を停止し、全スレッドの終了を待ってプロセスを正常終了させる。 |

**処理フロー詳細**:

正常起動:
1. Main (inbound)
2. ThreadContextHandler_main (inbound)
3. MultiThreadExecutionHandler (inbound)
4. MessagingContextHandler (inbound) — MQ接続を取得し以降の処理で使いまわす
5. DbConnectionManagementHandler (inbound) — DB接続を取得し以降の処理で使いまわす
6. RequestThreadLoopHandler (inbound) — 以降の処理をリクエスト毎にループ
7. DataReadHandler_messaging (inbound) — 各スレッドはここで受信キュー上の要求電文を待機

重複起動エラー:
1. Main (inbound)
2. ThreadContextHandler_main (inbound) — 起動引数-requestPathからリクエストIDを決定
3. DuplicateProcessCheckHandler (inbound) — 起動停止時の終了コードはこのハンドラに設定
4. GlobalErrorHandler (error) — 障害ログ出力
5. StatusCodeConvertHandler (outbound)
6. Main (outbound) — 異常終了

受付正常終了:
1. RequestPathJavaPackageMapping (inbound) — AsyncMessageReceiveActionにディスパッチ
2. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
3. ThreadContextHandler_request (inbound)
4. TransactionManagementHandler (inbound)
5. DataReadHandler_messaging (inbound)
6. AsyncMessageReceiveAction (inbound)
7. AsyncMessageReceiveAction (outbound)
8. TransactionManagementHandler (outbound)
9. RequestThreadLoopHandler (outbound) — ②へ

電文受信タイムアウト:
1. DataReadHandler_messaging (outbound) — タイムアウト間隔経過後メッセージ未受信の場合、DataReader.NoMoreRecordをリターン
2. RequestThreadLoopHandler (outbound) — ③へ
3. RequestThreadLoopHandler (inbound)
4. ProcessStopHandler (inbound) — プロセス停止フラグ確認後、⑤にもどる
5. DataReadHandler_messaging (inbound)

受付エラー:
1. RequestPathJavaPackageMapping (inbound) — AsyncMessageReceiveActionにディスパッチ
2. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
3. ThreadContextHandler_request (inbound)
4. TransactionManagementHandler (inbound)
5. DataReadHandler_messaging (inbound)
6. AsyncMessageReceiveAction (inbound) — 電文データ部の形式エラー等により実行時例外が発生
7. TransactionManagementHandler (error)
8. RequestThreadLoopHandler (error) — 障害ログ出力後、②へ

認可エラー:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound)
3. DataReadHandler_messaging (inbound)
4. PermissionCheckHandler (inbound) — 認可エラー(Result.Forbidden/ステータスコード:403)を送出
5. TransactionManagementHandler (error)
6. RequestThreadLoopHandler (error) — 起因例外を障害ログとして出力後、①へ

閉局中待機:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound)
3. ServiceAvailabilityCheckHandler (inbound) — 閉局エラー(Result.ServiceUnavailable)を送出
4. RequestThreadLoopHandler (error) — INFOログ出力、一定時間待機後、①へ。開局するまでループ

DB/MQ接続エラー:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. AsyncMessageReceiveAction (inbound) — 電文保存中にDB接続エラーが発生した場合、リトライ可能実行時例外(Retryableを実装した例外)が送出される
3. RequestThreadLoopHandler (error) — リトライ可能例外はそのまま再送出
4. RetryHandler (error) — ⑤へ
5. MessagingContextHandler (inbound) — MQ再接続
6. DbConnectionManagementHandler (inbound) — DB再接続、①にもどる

プロセス正常停止:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound) — リクエストIDの値が起動引数-requestPathで指定された値に戻される
3. ProcessStopHandler (inbound)
4. RequestThreadLoopHandler (error) — プロセス停止要求(ProcessStop)を捕捉、INFOログ出力後、処理結果オブジェクトをリターン(ステータスコード:200)
5. MultiThreadExecutionHandler (outbound)
6. StatusCodeConvertHandler (outbound) — ステータスコード:200 → 終了コード:0
7. Main (outbound) — 正常終了

<details>
<summary>keywords</summary>

Main, StatusCodeConvertHandler, GlobalErrorHandler, ThreadContextClearHandler, ThreadContextHandler_main, DuplicateProcessCheckHandler, RequestPathJavaPackageMapping, MultiThreadExecutionHandler, RetryHandler, MessagingContextHandler, DbConnectionManagementHandler, RequestThreadLoopHandler, ThreadContextHandler_request, ProcessStopHandler, ServiceAvailabilityCheckHandler, TransactionManagementHandler, DataReadHandler_messaging, PermissionCheckHandler, AsyncMessageReceiveAction, DataReader, ProcessStop, Retryable, Result, ハンドラ構成, 処理フロー, 正常起動, 重複起動エラー, 受付正常終了, 受信待機タイムアウト, 受付エラー, 認可エラー, 閉局中待機, DB/MQ接続エラー, プロセス正常停止

</details>
