# 常駐バッチ実行制御基盤

## 基本構造

常駐バッチは一定間隔ごとに要求データを検索し随時処理を行う常駐型プロセス。マルチスレッド実行時、各スレッドが一定間隔で要求データの有無をチェックするため、処理遅延が発生したスレッドがあっても残りのスレッドで随時処理を継続できる。

> **注意**: Nablarchバージョン1.4.3でハンドラ構成が大きく変更された。1.4.2以前のハンドラ構成は[batch_resident_thread_sync](nablarch-batch-batch_resident_thread_sync.md)参照。旧ハンドラ構成では処理の遅いスレッドの終了を他スレッドが待つため要求データの取り込み遅延が発生する。新規プロジェクトでは新しいハンドラ構成を推奨。

常駐バッチの構造は **プロセス制御部分(メインスレッド)** と **リクエスト処理部分(サブスレッド)** の2つに分かれる。

**プロセス制御部分(メインスレッド)**

Javaコマンドから[../handler/Main](../../component/handlers/handlers-Main.md)を実行して開始。リポジトリ初期化後、ハンドラキューのハンドラを順次実行し、[業務アクションハンドラ](../../component/handlers/handlers-BatchAction.md)の初期化とDataReaderの生成を行う。[../handler/MultiThreadExecutionHandler](../../component/handlers/handlers-MultiThreadExecutionHandler.md)でサブスレッドを作成後、サブスレッドが終了するまで待機する。

**リクエスト処理部分(サブスレッド)**

プロセス制御部分で生成したDataReaderで要求管理テーブルを検索する。未処理の要求データが存在する場合、そのデータを読み込み[業務アクションハンドラ](../../component/handlers/handlers-BatchAction.md)を実行する。業務処理終了後、[../handler/RequestThreadLoopHandler](../../component/handlers/handlers-RequestThreadLoopHandler.md)により要求管理テーブルの検索処理に戻り繰り返す。

> **注意**: 業務アクションハンドラの指定はバッチプロセス起動時の引数で行う。詳細は[batch_single_shot](nablarch-batch-batch_single_shot.md)参照。

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, RequestThreadLoopHandler, BatchAction, DataReadHandler, 常駐バッチ, マルチスレッド, プロセス制御部分, リクエスト処理部分, 要求管理テーブル

</details>

## 業務アクションハンドラの実装

業務アクションを実装するには、FW側で提供されるテンプレートクラスを継承して作成する。詳細は[../handler/BatchAction](../../component/handlers/handlers-BatchAction.md)参照。

<details>
<summary>keywords</summary>

BatchAction, 業務アクションハンドラ, テンプレートクラス継承

</details>

## 標準ハンドラ構成と主要処理フロー

## 標準ハンドラキュー

| No. | ハンドラ |
|---|---|
| 1 | Main |
| 2 | StatusCodeConvertHandler |
| 3 | ThreadContextClearHandler |
| 4 | GlobalErrorHandler |
| 5 | ThreadContextHandler_main |
| 6 | DuplicateProcessCheckHandler |
| 7 | RetryHandler |
| 8 | DbConnectionManagementHandler_main |
| 9 | TransactionManagementHandler_main |
| 10 | RequestPathJavaPackageMapping |
| 11 | MultiThreadExecutionHandler |
| 12 | DbConnectionManagementHandler |
| 13 | RequestThreadLoopHandler |
| 14 | FileRecordWriterDisposeHandler |
| 15 | ProcessStopHandler |
| 16 | ServiceAvailabilityCheckHandler |
| 17 | DataReadHandler |
| 18 | TransactionManagementHandler |
| 19 | BatchAction |

## 処理フロー

### 正常起動
1. Main (inbound)
2. ThreadContextHandler_main (inbound)
3. DbConnectionManagementHandler_main: メインスレッドで使用するDB接続を生成
4. TransactionManagementHandler_main: メインスレッドで使用するDBトランザクションを生成
5. RequestPathJavaPackageMapping: 起動引数-requestPathを元に業務アクションハンドラを生成
6. MultiThreadExecutionHandler: 処理開始前・データリーダ作成時にBatchActionへコールバック
7. BatchAction (callback): リクエストスレッド起動前、データリーダ作成、リクエストスレッド終了後にコールバック
8. DbConnectionManagementHandler: ここで取得したDB接続を以降の処理で使いまわす
9. RequestThreadLoopHandler (inbound)
10. DataReadHandler: 各リクエストスレッドは要求データを検索し、取得→業務処理実行を繰り返す

### 重複起動エラー
1. Main (inbound)
2. ThreadContextHandler_main: 起動引数-requestPathからバッチのリクエストIDを決定
3. DuplicateProcessCheckHandler: 同一プロセスが起動済みの場合に検出（起動停止時の終了コードを設定）
4. GlobalErrorHandler (error): 障害ログを出力
5. StatusCodeConvertHandler (outbound)
6. Main (outbound): 異常終了

### 要求データあり（正常フロー）
1. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
2. DataReadHandler (inbound)
3. TransactionManagementHandler (inbound)
4. BatchAction (inbound/outbound)
5. TransactionManagementHandler (outbound): コミット時にBatchActionへコールバック
6. BatchAction (callback): 業務トランザクションコミット後のコールバック（処理例: 要求データのステータスを処理済みに変更）
7. FileRecordWriterDisposeHandler: 現在スレッドでファイル出力のために開かれたリソースを解放
8. RequestThreadLoopHandler (outbound): ①へ

> **注意**: 要求の2重取り込み防止のため、処理中データをヒープ上で管理する。処理が遅いスレッドが処理中のデータが未処理として要求管理テーブルに残り続けた場合でも、2重取り込みを防止できる。

### 要求データなし（代替フロー）
1. DataReadHandler (inbound)
2. DataReadHandler (outbound): 要求データが存在しない場合、DataReader.NoMoreRecordをリターン
3. RequestThreadLoopHandler (outbound): ④へ（スレッドループの先頭に戻る）
4. RequestThreadLoopHandler (inbound)
5. ProcessStopHandler: プロセス停止フラグ確認後、再び①へ

スレッドループ先頭から処理を再実行することで、プロセス管理テーブルの状態が確認され、処理停止や閉局状態への変更が可能となる。

### 閉局中処理待機（代替フロー）
1. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
2. ServiceAvailabilityCheckHandler: サービス閉局例外を送出
3. RequestThreadLoopHandler (error): 一定時間wait後、①へ

### 業務エラー（異常フロー）
1. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
2. TransactionManagementHandler (inbound)
3. BatchAction: 業務処理をエラー終了させる場合は実行時例外を送出 → トランザクションロールバック・障害ログ出力
4. TransactionManagementHandler (error): 業務アクションへコールバック
5. BatchAction (callback): 業務トランザクションロールバック後のコールバック（処理例: 要求データのステータスを処理失敗に変更）
6. RequestThreadLoopHandler (error): 起因例外を障害ログとして出力後、リトライ可能例外を送出
7. RetryHandler (error): リトライ処理を実行
8. MultiThreadExecutionHandler: リクエストスレッドを再作成し要求データ監視を再開

> **注意**: エラーが発生した要求データはエラーステータスとなり、データメンテを行わない限り再処理されない。

### DB接続エラー→リトライ（異常フロー）
1. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
2. BatchAction: 要求データ処理中にDB接続エラーが発生した場合、リトライ可能実行時例外（Retryableを実装した例外）を送出
3. RequestThreadLoopHandler (error): リトライ可能例外をそのまま再送出
4. RetryHandler (error): データリーダを破棄（DB接続エラーの場合、データリーダが使用しているDB接続も使用不可となるため）
5. DbConnectionManagementHandler_main: DB再接続
6. MultiThreadExecutionHandler: データリーダを再生成
7. DbConnectionManagementHandler: DB再接続

### プロセス正常停止（正常フロー）
1. RequestThreadLoopHandler (inbound): リクエストスレッド内での処理の起点
2. ProcessStopHandler (inbound): プロセス管理テーブルのフラグを確認
3. RequestThreadLoopHandler (error): プロセス停止要求(ProcessStop)を捕捉 → INFOログ出力後、処理結果オブジェクトをリターン（ステータスコード:200）
4. MultiThreadExecutionHandler (outbound)
5. StatusCodeConvertHandler (outbound): ステータスコード200 → 終了コード0
6. Main (outbound): 正常終了

### プロセス異常停止（異常フロー）
1. BatchAction: リクエスト処理実行中に致命的エラー（VM系エラーやProcessAbnormalEnd）が発生
2. RequestThreadLoopHandler (error): 致命的エラーを再送出しリクエストスレッドを停止
3. MultiThreadExecutionHandler (error)
4. BatchAction (callback)
5. StatusCodeConvertHandler (outbound)
6. Main (outbound): 異常終了

### DB接続リトライ失敗（異常フロー）
1. BatchAction: リクエスト処理実行中にDB接続エラーが発生した場合、リトライ可能実行時例外（Retryableを実装した例外）を送出
2. RequestThreadLoopHandler (error): リトライ可能例外をそのまま再送出
3. RetryHandler (error): リトライ回数が上限値を超過した場合、例外を再送出しリクエストスレッドを停止
4. MultiThreadExecutionHandler (error)
5. GlobalErrorHandler (error)
6. StatusCodeConvertHandler (outbound)
7. Main (outbound): 異常終了

<details>
<summary>keywords</summary>

Main, StatusCodeConvertHandler, ThreadContextClearHandler, GlobalErrorHandler, ThreadContextHandler_main, DuplicateProcessCheckHandler, RetryHandler, DbConnectionManagementHandler_main, TransactionManagementHandler_main, RequestPathJavaPackageMapping, MultiThreadExecutionHandler, DbConnectionManagementHandler, RequestThreadLoopHandler, FileRecordWriterDisposeHandler, ProcessStopHandler, ServiceAvailabilityCheckHandler, DataReadHandler, TransactionManagementHandler, BatchAction, ProcessStop, ProcessAbnormalEnd, Retryable, 重複起動エラー, プロセス正常停止, DB接続リトライ失敗, 常駐バッチハンドラ構成

</details>
