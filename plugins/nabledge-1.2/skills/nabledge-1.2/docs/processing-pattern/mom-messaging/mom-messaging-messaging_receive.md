# 応答不要メッセージング実行制御基盤

## 概要と messaging_request_reply との差異

[messaging_receive](mom-messaging-messaging_receive.md) は、外部から送信された要求電文の内容をDB上に格納した後、後続のバッチで業務処理を行う方式。応答電文の送信は行わない。

先行処理部分は基本的に [messaging_request_reply](mom-messaging-messaging_request_reply.md) の構造を踏襲するが、以下4点が異なる。

**1. 応答電文を送信しない**
以下のハンドラは使用しない。
- [../handler/MessageReplyHandler](../../component/handlers/handlers-MessageReplyHandler.md)
- [../handler/MessageResendHandler](../../component/handlers/handlers-MessageResendHandler.md)

**2. 業務アクションハンドラは作成不要**
1電文の内容をDBの1レコードとして保存する定型処理のため、[../handler/AsyncMessageReceiveAction](../../component/handlers/handlers-AsyncMessageReceiveAction.md) に対して設定を行うだけでよい。

**3. 2相コミットを使用する**
電文保存失敗時にエラー応答を送信できないため、取得した電文を一旦キューに戻し、既定回数に達するまでリトライする。DBへの登録処理とキューへの操作を1つのトランザクションとして扱う必要がある（2相コミット制御）。TransactionManagementHandlerの設定を変更し、2相コミット対応の実装に差し替える必要がある。

**4. 閉局時の挙動が異なる**
[messaging_receive](mom-messaging-messaging_receive.md) では応答送信を行わないため、[../handler/DataReadHandler](../../component/handlers/handlers-DataReadHandler.md) の上位に [../handler/ServiceAvailabilityCheckHandler](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md) を配置し、閉局中はメッセージキュー上の受信電文を取得せずに滞留させ、開局後に処理する設計とする。

<details>
<summary>keywords</summary>

AsyncMessageReceiveAction, MessageReplyHandler, MessageResendHandler, ServiceAvailabilityCheckHandler, DataReadHandler, TransactionManagementHandler, 応答不要メッセージング, 2相コミット, 閉局中待機, messaging_receive

</details>

## 業務アクションハンドラの実装

業務アクションハンドラの実装は不要。[../handler/AsyncMessageReceiveAction](../../component/handlers/handlers-AsyncMessageReceiveAction.md) に必要な設定を行うだけでよい。

<details>
<summary>keywords</summary>

AsyncMessageReceiveAction, 業務アクションハンドラ, 定型処理, DB格納

</details>

## 標準ハンドラ構成と主要処理フロー

### ハンドラキュー（上から順）

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

### 処理フロー一覧

| 区分 | 種別 | 処理フロー名 | 概要 |
|---|---|---|---|
| プロセス起動制御 | 正常フロー | 正常起動 | Javaコマンドからプロセスを起動し、リクエストスレッドを初期化する。各スレッドは受信キュー上で電文を待機する。 |
| プロセス起動制御 | 異常フロー | 重複起動エラー | プロセス起動時、既に同一プロセスが起動していた場合は異常終了する。 |
| リクエストスレッド内制御 | 正常フロー | 受付正常終了 | 受信電文受付後、電文内のレコードを電文テーブルに保存する。 |
| リクエストスレッド内制御 | 代替フロー | 受信待機タイムアウト | 受信キューでの待機が一定時間継続した場合、プロセス管理テーブルの状態確認のため待機を解除してスレッドループ先頭に戻る。 |
| リクエストスレッド内制御 | 異常フロー | 受付エラー | アクションハンドラ側でエラーが発生した場合、業務トランザクションをロールバックし、障害ログを出力する。 |
| リクエストスレッド内制御 | 代替フロー | 認可エラー | 要求電文中のリクエストID/ユーザIDヘッダの値をもとに認可チェックを行い、権限がない場合は障害ログを出力する。 |
| リクエストスレッド内制御 | 代替フロー | 閉局中待機 | 業務機能が閉局中の場合、メッセージキュー上の受信電文取得処理を休止し、開局するまで待機する。滞留電文は開局後に処理される。 |
| リクエストスレッド内制御 | 異常フロー | DB/MQ接続エラー | DB/MQへの接続失敗時は障害ログ出力後、再接続処理を行う。 |
| プロセス停止制御 | 正常フロー | プロセス正常停止 | プロセス管理テーブルのフラグ変更により新規処理受付を停止し、全スレッド終了後にプロセスを正常終了させる。 |

### 処理フロー詳細

#### 正常起動
1. Main（inbound）
2. ThreadContextHandler_main（inbound）
3. MultiThreadExecutionHandler（inbound）
4. MessagingContextHandler（inbound）: MQ接続取得（以降の処理で再利用）
5. DbConnectionManagementHandler（inbound）: DB接続取得（以降の処理で再利用）
6. RequestThreadLoopHandler（inbound）: このハンドラ以降の処理をリクエスト毎にループ
7. DataReadHandler_messaging（inbound）: 各スレッドがここで受信キュー上の要求電文を待機

#### 重複起動エラー
1. Main（inbound）
2. ThreadContextHandler_main（inbound）: 起動引数-requestPathからリクエストID決定
3. DuplicateProcessCheckHandler（inbound）: 起動停止時の終了コードをここに設定
4. GlobalErrorHandler（error）: 障害ログ出力
5. StatusCodeConvertHandler（outbound）
6. Main（outbound）: 異常終了

#### 受付正常終了
1. RequestPathJavaPackageMapping（inbound）: AsyncMessageReceiveActionにディスパッチ
2. RequestThreadLoopHandler（inbound）: リクエストスレッド内処理の起点
3. ThreadContextHandler_request（inbound）
4. TransactionManagementHandler（inbound）
5. DataReadHandler_messaging（inbound）
6. AsyncMessageReceiveAction（inbound）
7. AsyncMessageReceiveAction（outbound）
8. TransactionManagementHandler（outbound）
9. RequestThreadLoopHandler（outbound）

#### 電文受信タイムアウト
1. DataReadHandler_messaging（outbound）: タイムアウト間隔経過後NoMoreRecordを返却
2. RequestThreadLoopHandler（outbound）
3. RequestThreadLoopHandler（inbound）
4. ProcessStopHandler（inbound）: プロセス停止フラグ確認後、受信待機に戻る
5. DataReadHandler_messaging（inbound）

#### 受付エラー
1. RequestPathJavaPackageMapping（inbound）: AsyncMessageReceiveActionにディスパッチ
2. RequestThreadLoopHandler（inbound）: リクエストスレッド内処理の起点
3. ThreadContextHandler_request（inbound）
4. TransactionManagementHandler（inbound）
5. DataReadHandler_messaging（inbound）
6. AsyncMessageReceiveAction（inbound）: 電文データ部の形式エラー等により実行時例外が発生
7. TransactionManagementHandler（error）
8. RequestThreadLoopHandler（error）: 障害ログ出力

#### 認可エラー
1. RequestThreadLoopHandler（inbound）: リクエストスレッド内処理の起点
2. ThreadContextHandler_request（inbound）
3. DataReadHandler_messaging（inbound）
4. PermissionCheckHandler（inbound）: 認可エラー（Result.Forbidden/ステータスコード403）を送出
5. TransactionManagementHandler（error）
6. RequestThreadLoopHandler（error）: 障害ログ出力

#### 閉局中待機
1. RequestThreadLoopHandler（inbound）: リクエストスレッド内処理の起点
2. ThreadContextHandler_request（inbound）
3. ServiceAvailabilityCheckHandler（inbound）: 閉局エラー（Result.ServiceUnavailable）を送出
4. RequestThreadLoopHandler（error）: INFOログ出力後、一定時間待機して再度受信処理へ。開局するまでループ

#### DB/MQ接続エラー
1. RequestThreadLoopHandler（inbound）: リクエストスレッド内処理の起点
2. AsyncMessageReceiveAction（inbound）: 電文保存中にDB接続エラーが発生。リトライ可能実行時例外（Retryableを実装した例外）を送出
3. RequestThreadLoopHandler（error）: リトライ可能例外をそのまま再送出
4. RetryHandler（error）
5. MessagingContextHandler（inbound）: MQ再接続
6. DbConnectionManagementHandler（inbound）: DB再接続

#### プロセス正常停止
1. RequestThreadLoopHandler（inbound）: リクエストスレッド内処理の起点
2. ThreadContextHandler_request（inbound）: リクエストIDを起動引数-requestPathの値に戻す
3. ProcessStopHandler（inbound）
4. RequestThreadLoopHandler（error）: ProcessStopを捕捉してINFOログ出力後、処理結果オブジェクトを返却（ステータスコード200）
5. MultiThreadExecutionHandler（outbound）
6. StatusCodeConvertHandler（outbound）: ステータスコード200→終了コード0
7. Main（outbound）: 正常終了

<details>
<summary>keywords</summary>

Main, StatusCodeConvertHandler, GlobalErrorHandler, ThreadContextClearHandler, ThreadContextHandler_main, ThreadContextHandler_request, DuplicateProcessCheckHandler, RequestPathJavaPackageMapping, MultiThreadExecutionHandler, RetryHandler, MessagingContextHandler, DbConnectionManagementHandler, RequestThreadLoopHandler, ProcessStopHandler, ServiceAvailabilityCheckHandler, TransactionManagementHandler, DataReadHandler_messaging, PermissionCheckHandler, AsyncMessageReceiveAction, ハンドラ構成, 処理フロー

</details>
