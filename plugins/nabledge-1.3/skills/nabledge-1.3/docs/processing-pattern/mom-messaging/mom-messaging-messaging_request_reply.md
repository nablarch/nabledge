# 同期応答メッセージング実行制御基盤

## 基本構造

オーソリ業務のような、要求電文に対する即時応答を必要とする業務処理において使用される。

[messaging_request_reply](mom-messaging-messaging_request_reply.md) の構造は **プロセス制御部分** (メインスレッド) と **リクエストスレッド** の2つに分かれる。

**プロセス制御部分** (メインスレッド):
- Javaコマンドから [../handler/Main](../../component/handlers/handlers-Main.md) を実行して開始
- リポジトリ初期化処理でハンドラキューとデータリーダ ([../reader/FwHeaderReader](../../component/readers/readers-FwHeaderReader.md)) を生成
- [../handler/MultiThreadExecutionHandler](../../component/handlers/handlers-MultiThreadExecutionHandler.md) でリクエストスレッドを作成後、完了を待機

**リクエストスレッド**:
- データリーダを使用し受信キュー上の要求電文を待機
- 要求電文受信後、:ref:`フレームワーク制御ヘッダ<fw_header>` の **リクエストIDヘッダー** を読み込み、対応する [業務アクションハンドラ](../../component/handlers/handlers-MessagingAction.md) を生成
- 業務処理を実行し、応答電文オブジェクトを [../handler/MessageReplyHandler](../../component/handlers/handlers-MessageReplyHandler.md) によって要求元に送信
- [../handler/RequestThreadLoopHandler](../../component/handlers/handlers-RequestThreadLoopHandler.md) により最初の要求電文待機処理に戻り、以降繰り返す

> **注意**: [messaging](mom-messaging-messaging.md) では、リクエストスレッド上のループ処理に [../handler/RequestThreadLoopHandler](../../component/handlers/handlers-RequestThreadLoopHandler.md) を使用する。

> **注意**: [batch](../nablarch-batch/nablarch-batch-batch-architectural_pattern.md) では業務アクションハンドラがデータリーダを作成するが、[messaging](mom-messaging-messaging.md) ではリポジトリで初期化する。

<details>
<summary>keywords</summary>

Main, FwHeaderReader, MultiThreadExecutionHandler, MessagingAction, MessageReplyHandler, RequestThreadLoopHandler, プロセス制御部分, リクエストスレッド, 受信キュー, フレームワーク制御ヘッダ, リクエストIDヘッダ, 同期応答メッセージング, オーソリ業務, 即時応答

</details>

## 業務アクションハンドラの実装

業務アクションハンドラはFWが提供するテンプレートクラスを継承して作成する。詳細は [../handler/MessagingAction](../../component/handlers/handlers-MessagingAction.md) を参照。

<details>
<summary>keywords</summary>

MessagingAction, 業務アクションハンドラ, テンプレートクラス継承, MessagingAction実装

</details>

## 標準ハンドラ構成と主要処理フロー

## 処理フロー一覧

| 区分 | 種別 | 処理フロー名 | 概要 |
|---|---|---|---|
| プロセス起動制御 | 正常フロー | 正常起動 | Javaコマンドからプロセスを起動し、リクエストスレッドを初期化する。各スレッドは受信キュー上で電文を待機する。|
| プロセス起動制御 | 異常フロー | 重複起動エラー | プロセス起動時、既に同一プロセスが起動していた場合は異常終了する。|
| リクエストスレッド内制御 | 正常フロー | 正常受信・正常応答 | 受信電文のリクエストIDヘッダをもとに業務処理を決定し委譲する。業務処理結果をもとに応答電文を構築し送信する。|
| リクエストスレッド内制御 | 代替フロー | 再送応答 | 要求電文の再送要求フラグヘッダが設定されていた場合、送信済み電文テーブルを参照し、該当する送信済み電文が存在した場合はその内容をもとに応答を作成して送信する。|
| リクエストスレッド内制御 | 代替フロー | 受信待機タイムアウト | 受信キューでの待機状態が一定時間継続した場合、プロセス管理テーブルの状態確認のため待機を解除してスレッドループの先頭に戻る。|
| リクエストスレッド内制御 | 代替フロー | 業務処理エラー応答 | 業務処理でエラーが発生した場合、業務トランザクションをロールバックし、業務側で作成した応答電文オブジェクトをもとに電文を作成して送信する。|
| リクエストスレッド内制御 | 代替フロー | 認可エラー | 要求電文中のリクエストID/ユーザIDヘッダの値をもとに認可チェックを行い、権限が無い場合はエラー応答を送信する。|
| リクエストスレッド内制御 | 代替フロー | 開閉局エラー | 要求電文中のリクエストIDに対する業務機能が閉局中の場合はエラー応答を送信する。|
| リクエストスレッド内制御 | 異常フロー | DB/MQ接続エラー | DB/MQへの接続失敗時、エラー応答を送信後に再接続処理を行う。|
| プロセス停止制御 | 正常フロー | プロセス正常停止 | プロセス管理テーブルのフラグ変更で新規処理受付を停止する。全スレッドの終了を待ってプロセスを正常終了させる。|
| プロセス停止制御 | 代替フロー | プロセス異常停止 | 致命的なエラーが発生した場合、新規処理受付を停止した上で、全スレッド終了を待ってプロセスを異常終了させる。|
| プロセス停止制御 | 異常フロー | DB/MQ接続リトライ失敗 | DB/MQ接続リトライが上限回数に達しても成功しなかった場合はプロセスを異常停止させる。|

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

## 各処理フローの詳細

**正常起動**:
1. Main (inbound)
2. ThreadContextHandler_main (inbound)
3. MultiThreadExecutionHandler (inbound)
4. DbConnectionManagementHandler (inbound) — 取得したDB接続を以降の処理で使いまわす
5. MessagingContextHandler (inbound) — 取得したMQ接続を以降の処理で使いまわす
6. RequestThreadLoopHandler (inbound) — このハンドラ以降の処理をリクエスト毎にループする
7. DataReadHandler_messaging (inbound) — 各リクエストスレッドはここで受信キュー上の要求電文を待機する。以降は要求電文の受信→業務処理の実行→応答電文の送信を繰り返す

**重複起動エラー**:
1. Main (inbound)
2. ThreadContextHandler_main (inbound) — 起動引数-requestPathからリクエストIDを決定する
3. DuplicateProcessCheckHandler (inbound) — 起動停止時の終了コードはこのハンドラに設定する
4. GlobalErrorHandler (error) — 障害ログが出力される
5. StatusCodeConvertHandler (outbound)
6. Main (outbound) — 異常終了

**正常受信・正常応答**:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound)
3. DataReadHandler_messaging (inbound)
4. RequestPathJavaPackageMapping (inbound)
5. TransactionManagementHandler (inbound)
6. MessagingAction (inbound)
7. MessagingAction (outbound)
8. MessageResendHandler (outbound)
9. TransactionManagementHandler (outbound)
10. MessageReplyHandler (outbound)
11. RequestThreadLoopHandler (outbound) — →① へ

**再送応答**:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound)
3. DataReadHandler_messaging (inbound)
4. RequestPathJavaPackageMapping (inbound) — 再送応答時、ディスパッチされた業務アクションは実行されない
5. TransactionManagementHandler (inbound)
6. MessageResendHandler (inbound)
7. TransactionManagementHandler (outbound)
8. MessageReplyHandler (outbound) — 再送応答
9. RequestThreadLoopHandler (outbound) — →① へ

**受信待機タイムアウト**:
1. DataReadHandler_messaging (inbound)
2. DataReadHandler_messaging (outbound) — タイムアウト間隔を経過してもメッセージを受信できなかった場合、DataReader.NoMoreRecordをリターンする
3. MessageReplyHandler (outbound) — DataRecord.NoMoreRecordが返された場合は何もせずにリターンする
4. RequestThreadLoopHandler (outbound) — →⑤ へ
5. RequestThreadLoopHandler (inbound)
6. ProcessStopHandler (inbound) — プロセス停止フラグ確認後、再び① にもどる

**業務処理エラー応答**:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound)
3. DataReadHandler_messaging (inbound)
4. RequestPathJavaPackageMapping (inbound)
5. TransactionManagementHandler (inbound)
6. MessagingAction (inbound)
7. MessagingAction (error) — 業務処理をエラー終了させる場合は実行時例外を送出する。これによりトランザクションがロールバックされ、障害ログが出力される
8. TransactionManagementHandler (error) — 業務アクションをコールバックし、その処理結果(エラー応答電文オブジェクト)を送出する。起因例外をネストさせる
9. TransactionManagementHandler (callback)
10. MessagingAction (callback)
11. MessageReplyHandler (error) — 業務アクションが作成したエラー応答電文オブジェクトを送信後、起因例外を再送出する
12. RequestThreadLoopHandler (error) — 再送出された起因例外を障害ログとして出力後、→① へ

**認可エラー**:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound)
3. DataReadHandler_messaging (inbound)
4. PermissionCheckHandler (inbound) — 認可エラー(Result.Forbidden/ステータスコード:403)を送出する
5. MessageReplyHandler (error) — 業務処理は実行できないので、FW制御ヘッダ部のみを出力して送信し、認可エラーを再送出する
6. RequestThreadLoopHandler (error) — 再送出された起因例外を障害ログとして出力後、→① へ

**開閉局エラー**:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound)
3. DataReadHandler_messaging (inbound)
4. ServiceAvailabilityCheckHandler (inbound) — 閉局エラー(Result.ServiceUnavailable/ステータスコード:503)を送出する
5. MessageReplyHandler (error) — 業務処理は実行できないので、FW制御ヘッダ部のみを出力して送信し、認可エラーを再送出する
6. RequestThreadLoopHandler (error) — INFOログを出力し、一定時間waitした後、→① へ

**DB/MQ接続エラー**:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. MessagingAction (inbound) — リクエスト処理実行中にDB/MQ接続エラーが発生した場合、リトライ可能実行時例外(Retryableを実装した例外)が送出される
3. MessageReplyHandler (error)
4. RequestThreadLoopHandler (error) — リトライ可能例外はそのまま再送出する
5. RetryHandler (error)
6. MessagingContextHandler (inbound) — MQ再接続
7. DbConnectionManagementHandler (inbound) — DB再接続

**プロセス正常停止**:
1. RequestThreadLoopHandler (inbound) — リクエストスレッド内での処理の起点
2. ThreadContextHandler_request (inbound) — リクエストIDの値が起動引数-requestPathで指定された値に戻される
3. ProcessStopHandler (inbound)
4. RequestThreadLoopHandler (error) — プロセス停止要求(ProcessStop)を捕捉するとINFOログを出力後、処理結果オブジェクトをリターンする(ステータスコード:200)
5. MultiThreadExecutionHandler (outbound)
6. StatusCodeConvertHandler (outbound) — ステータスコード:200 → 終了コード:0
7. Main (outbound) — 正常終了

**プロセス異常終了**:
1. MessagingAction (inbound) — リクエスト処理実行中に致命的なエラー(VM系のエラーやProcessAbnormalEnd)が発生
2. MessageReplyHandler (error)
3. RequestThreadLoopHandler (error) — 致命的エラーはここで例外を再送出し、リクエストスレッドを停止する
4. MultiThreadExecutionHandler (error)
5. GlobalErrorHandler (error)
6. StatusCodeConvertHandler (outbound)
7. Main (outbound) — 異常終了

**DB/MQ接続リトライ失敗**:
1. MessagingAction (inbound) — リクエスト処理実行中にDB/MQ接続エラーが発生し、リトライ可能実行時例外(Retryableを実装した例外)が送出される
2. MessageReplyHandler (error)
3. RequestThreadLoopHandler (error) — リトライ可能例外はそのまま再送出する
4. RetryHandler (error) — リトライ回数が上限値を超過した場合は例外を再送出し、リクエストスレッドを停止する
5. MultiThreadExecutionHandler (error)
6. GlobalErrorHandler (error)
7. StatusCodeConvertHandler (outbound)
8. Main (outbound) — 異常終了

<details>
<summary>keywords</summary>

Main, StatusCodeConvertHandler, GlobalErrorHandler, ThreadContextClearHandler, ThreadContextHandler_main, ThreadContextHandler_request, DuplicateProcessCheckHandler, MultiThreadExecutionHandler, RetryHandler, MessagingContextHandler, DbConnectionManagementHandler, RequestThreadLoopHandler, ProcessStopHandler, MessageReplyHandler, DataReadHandler_messaging, PermissionCheckHandler, RequestPathJavaPackageMapping, ServiceAvailabilityCheckHandler, TransactionManagementHandler, MessageResendHandler, ハンドラキュー, 正常起動, 重複起動エラー, 正常受信・正常応答, 再送応答, 受信待機タイムアウト, 業務処理エラー応答, 認可エラー, 開閉局エラー, DB/MQ接続エラー, プロセス正常停止, プロセス異常停止, DB/MQ接続リトライ失敗, Retryable, ProcessAbnormalEnd, ProcessStop

</details>
