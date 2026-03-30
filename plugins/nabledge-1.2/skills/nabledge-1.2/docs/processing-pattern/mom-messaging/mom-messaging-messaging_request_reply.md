# 同期応答メッセージング実行制御基盤

## 基本構造

オーソリ業務のような、要求電文に対する即時応答を必要とする業務処理において使用される。

同期応答メッセージング実行制御基盤は**プロセス制御部分**（メインスレッド）と**リクエストスレッド**の2部構成。

**プロセス制御部分（メインスレッド）**: Javaコマンドから [../handler/Main](../../component/handlers/handlers-Main.md) を実行することで開始。リポジトリ初期化でハンドラキューと [../reader/FwHeaderReader](../../component/readers/readers-FwHeaderReader.md) を生成し、 [../handler/MultiThreadExecutionHandler](../../component/handlers/handlers-MultiThreadExecutionHandler.md) でリクエストスレッドを作成・完了を待機。

**リクエストスレッド**: メインスレッドで作成したデータリーダを使用し、受信キュー上の要求電文を待機。要求電文受信後、 :ref:`フレームワーク制御ヘッダ<fw_header>` 中の**リクエストIDヘッダー**を読み込み、対応する [業務アクションハンドラ](../../component/handlers/handlers-MessagingAction.md) を生成して業務処理を実行。処理結果から応答電文オブジェクトを作成し、 [../handler/MessageReplyHandler](../../component/handlers/handlers-MessageReplyHandler.md) が要求元に送信。その後 [../handler/RequestThreadLoopHandler](../../component/handlers/handlers-RequestThreadLoopHandler.md) により最初の要求電文待機に戻る（繰り返し）。

> **注意**: ループ処理には [../handler/RequestThreadLoopHandler](../../component/handlers/handlers-RequestThreadLoopHandler.md) を使用すること。 [batch_resident](../nablarch-batch/nablarch-batch-batch_resident.md) で使用する [../handler/ProcessResidentHandler](../../component/handlers/handlers-ProcessResidentHandler.md) は代用不可。

> **注意**: [batch](../nablarch-batch/nablarch-batch-batch-architectural_pattern.md) ではデータリーダを業務アクションハンドラが作成するが、 [messaging](mom-messaging-messaging.md) ではリポジトリで初期化する。

<details>
<summary>keywords</summary>

MessagingAction, FwHeaderReader, MultiThreadExecutionHandler, MessageReplyHandler, RequestThreadLoopHandler, ProcessResidentHandler, 同期応答メッセージング, プロセス制御, リクエストスレッド, 要求電文, 応答電文

</details>

## 業務アクションハンドラの実装

業務アクションハンドラはFWが提供するテンプレートクラスを継承して作成する。詳細は [../handler/MessagingAction](../../component/handlers/handlers-MessagingAction.md) を参照。

<details>
<summary>keywords</summary>

MessagingAction, 業務アクションハンドラ, テンプレートクラス継承

</details>

## 標準ハンドラ構成と主要処理フロー

## 標準ハンドラキュー

1. Main
2. StatusCodeConvertHandler
3. GlobalErrorHandler
4. ThreadContextClearHandler
5. ThreadContextHandler_main
6. DuplicateProcessCheckHandler
7. MultiThreadExecutionHandler
8. RetryHandler
9. MessagingContextHandler
10. DbConnectionManagementHandler
11. RequestThreadLoopHandler
12. ThreadContextClearHandler
13. ThreadContextHandler_request
14. ProcessStopHandler
15. MessageReplyHandler
16. DataReadHandler_messaging
17. PermissionCheckHandler
18. RequestPathJavaPackageMapping
19. ServiceAvailabilityCheckHandler
20. TransactionManagementHandler
21. MessageResendHandler
22. MessagingAction

## 主要処理フロー

### 正常起動
1. Main (往路)
2. ThreadContextHandler_main (往路)
3. MultiThreadExecutionHandler (往路)
4. DbConnectionManagementHandler (往路) — ここで取得したDB接続を以降の処理で使いまわす
5. MessagingContextHandler (往路) — ここで取得したMQ接続を以降の処理で使いまわす
6. RequestThreadLoopHandler (往路) — このハンドラ以降の処理をリクエスト毎にループ
7. DataReadHandler_messaging (往路) — 各リクエストスレッドはここで受信キュー上の要求電文を待機

### 重複起動エラー
1. Main (往路)
2. ThreadContextHandler_main (往路) — 起動引数-requestPathからリクエストIDを決定
3. DuplicateProcessCheckHandler (往路) — 起動停止時の終了コードはこのハンドラに設定
4. GlobalErrorHandler (例外) — 障害ログ出力
5. StatusCodeConvertHandler (復路)
6. Main (復路) — 異常終了

### 正常受信・正常応答
1. RequestThreadLoopHandler (往路) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (往路)
3. DataReadHandler_messaging (往路)
4. RequestPathJavaPackageMapping (往路)
5. TransactionManagementHandler (往路)
6. MessagingAction (往路)
7. MessagingAction (復路)
8. MessageResendHandler (復路)
9. TransactionManagementHandler (復路)
10. MessageReplyHandler (復路)
11. RequestThreadLoopHandler (復路) — →① へ

### 再送応答
再送要求フラグヘッダが設定されている場合、送信済み電文テーブルを参照し、該当する送信済み電文で応答を作成して送信する。

1. RequestThreadLoopHandler (往路)
2. ThreadContextHandler_request (往路)
3. DataReadHandler_messaging (往路)
4. RequestPathJavaPackageMapping (往路) — 再送応答時、ディスパッチされた業務アクションは実行されない
5. TransactionManagementHandler (往路)
6. MessageResendHandler (往路)
7. TransactionManagementHandler (復路)
8. MessageReplyHandler (復路) — 再送応答
9. RequestThreadLoopHandler (復路) — →① へ

### 受信待機タイムアウト
受信キューでの待機が一定時間継続した場合、プロセス管理テーブルの状態確認のために待機を解除してスレッドループ先頭に戻る。

1. DataReadHandler_messaging (往路)
2. DataReadHandler_messaging (復路) — タイムアウト間隔を経過してもメッセージを受信できなかった場合、DataReader.NoMoreRecordをリターン
3. MessageReplyHandler (復路) — DataRecord.NoMoreRecordが返された場合は何もせずリターン
4. RequestThreadLoopHandler (復路) — →⑤ へ
5. RequestThreadLoopHandler (往路)
6. ProcessStopHandler (往路) — プロセス停止フラグ確認後、再び① にもどる

### 業務処理エラー応答
業務処理でエラーが発生した場合、業務トランザクションをロールバックし、業務側で作成した応答電文オブジェクトで電文を送信する。

1. RequestThreadLoopHandler (往路)
2. ThreadContextHandler_request (往路)
3. DataReadHandler_messaging (往路)
4. RequestPathJavaPackageMapping (往路)
5. TransactionManagementHandler (往路)
6. MessagingAction (往路)
7. MessagingAction (例外) — 業務処理エラー時は実行時例外を送出→トランザクションロールバック・障害ログ出力
8. TransactionManagementHandler (例外) — 業務アクションをコールバックし処理結果（エラー応答電文オブジェクト）を送出、起因例外をネスト
9. TransactionManagementHandler (コールバック)
10. MessagingAction (コールバック)
11. MessageReplyHandler (例外) — 業務アクションが作成したエラー応答電文オブジェクトを送信後、起因例外を再送出
12. RequestThreadLoopHandler (例外) — 再送出された起因例外を障害ログ出力後、→① へ

### 認可エラー
リクエストID/ユーザIDヘッダの値で認可チェックを行い、権限がない場合はエラー応答を送信する。

1. RequestThreadLoopHandler (往路)
2. ThreadContextHandler_request (往路)
3. DataReadHandler_messaging (往路)
4. PermissionCheckHandler (往路) — 認可エラー(Result.Forbidden/ステータスコード:403)を送出
5. MessageReplyHandler (例外) — FW制御ヘッダ部のみを出力して送信し、認可エラーを再送出
6. RequestThreadLoopHandler (例外) — 再送出された起因例外を障害ログ出力後、→① へ

### 開閉局エラー
リクエストIDに対する業務機能が閉局中の場合はエラー応答を送信する。

1. RequestThreadLoopHandler (往路)
2. ThreadContextHandler_request (往路)
3. DataReadHandler_messaging (往路)
4. ServiceAvailabilityCheckHandler (往路) — 閉局エラー(Result.ServiceUnavailable/ステータスコード:503)を送出
5. MessageReplyHandler (例外) — FW制御ヘッダ部のみを出力して送信し、認可エラーを再送出
6. RequestThreadLoopHandler (例外) — INFOログ出力後、一定時間waitしてから→① へ

### DB/MQ接続エラー
DB/MQへの接続失敗時はエラー応答を送信後、再接続処理を行う。

1. RequestThreadLoopHandler (往路)
2. MessagingAction (往路) — リクエスト処理中にDB/MQ接続エラー発生→リトライ可能実行時例外(Retryableを実装した例外)を送出
3. MessageReplyHandler (例外)
4. RequestThreadLoopHandler (例外) — リトライ可能例外はそのまま再送出
5. RetryHandler (例外)
6. MessagingContextHandler (往路) — MQ再接続
7. DbConnectionManagementHandler (往路) — DB再接続

### プロセス正常停止
プロセス管理テーブルのフラグ変更→新規処理受付停止→全スレッド終了後にプロセス正常終了。

1. RequestThreadLoopHandler (往路)
2. ThreadContextHandler_request (往路) — リクエストIDの値が起動引数-requestPathで指定された値に戻される
3. ProcessStopHandler (往路)
4. RequestThreadLoopHandler (例外) — プロセス停止要求(ProcessStop)を捕捉→INFOログ出力後、処理結果オブジェクトをリターン(ステータスコード:200)
5. MultiThreadExecutionHandler (復路)
6. StatusCodeConvertHandler (復路) — ステータスコード:200 → 終了コード:0
7. Main (復路) — 正常終了

### プロセス異常停止
致命的エラー発生時は新規処理受付を停止し、全スレッド終了後にプロセス異常終了させる。

1. MessagingAction (往路) — リクエスト処理中に致命的エラー(VM系エラー、ProcessAbnormalEnd)発生
2. MessageReplyHandler (例外)
3. RequestThreadLoopHandler (例外) — 致命的エラーはここで例外を再送出し、リクエストスレッドを停止
4. MultiThreadExecutionHandler (例外)
5. GlobalErrorHandler (例外)
6. StatusCodeConvertHandler (復路)
7. Main (復路) — 異常終了

### DB/MQ接続リトライ失敗
接続リトライが上限回数に達しても成功しなかった場合はプロセスを異常停止させる。

1. MessagingAction (往路) — リトライ可能実行時例外(Retryableを実装した例外)を送出
2. MessageReplyHandler (例外)
3. RequestThreadLoopHandler (例外) — リトライ可能例外はそのまま再送出
4. RetryHandler (例外) — リトライ回数が上限値を超過した場合、例外を再送出しリクエストスレッドを停止
5. MultiThreadExecutionHandler (例外)
6. GlobalErrorHandler (例外)
7. StatusCodeConvertHandler (復路)
8. Main (復路) — 異常終了

<details>
<summary>keywords</summary>

Main, StatusCodeConvertHandler, GlobalErrorHandler, ThreadContextClearHandler, DuplicateProcessCheckHandler, MessagingContextHandler, DbConnectionManagementHandler, ProcessStopHandler, DataReadHandler_messaging, PermissionCheckHandler, RequestPathJavaPackageMapping, ServiceAvailabilityCheckHandler, TransactionManagementHandler, MessageResendHandler, RetryHandler, ThreadContextHandler, ProcessStop, ProcessAbnormalEnd, Result.Forbidden, Result.ServiceUnavailable, DataReader.NoMoreRecord, DataRecord.NoMoreRecord, Retryable, 標準ハンドラ構成, 処理フロー, 正常起動, 重複起動エラー, 再送応答, 受信待機タイムアウト, 業務処理エラー, 認可エラー, 開閉局エラー, DB/MQ接続エラー, プロセス停止

</details>
