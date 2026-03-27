# 常駐バッチ実行制御基盤（スレッド同期型）

## 

[batch_resident_thread_sync](nablarch-batch-batch_resident_thread_sync.md) は、一定間隔ごとにバッチ処理を実行する常駐型プロセスを作成するための制御基盤を提供する。例えば、オンライン処理で作成されたトランザクションデータを定期的に一括処理するような場合に使用される。

> **警告**: [batch_resident_thread_sync](nablarch-batch-batch_resident_thread_sync.md) では処理が遅いスレッドの終了を他のスレッドが待つため、要求データの取り込み遅延が発生する。新規開発プロジェクトでは [batch_resident_thread_sync](nablarch-batch-batch_resident_thread_sync.md) ではなく [batch_resident](nablarch-batch-batch_resident.md) を使用すること。既存プロジェクトで上記問題が発生している（または発生する可能性がある）場合は [batch_resident](nablarch-batch-batch_resident.md) への変更を検討すること。

<details>
<summary>keywords</summary>

常駐バッチ, スレッド同期型, 要求データ取り込み遅延, batch_resident_thread_sync, batch_resident, 新規プロジェクト推奨, 常駐型プロセス, 一定間隔, トランザクションデータ定期処理

</details>

## 基本構造

[batch_resident_thread_sync](nablarch-batch-batch_resident_thread_sync.md) の構造は [batch_single_shot](nablarch-batch-batch_single_shot.md) と同じだが、以下の2ハンドラがメインスレッド側に追加されている。

1. **[../handler/ProcessResidentHandler](../../component/handlers/handlers-ProcessResidentHandler.md)**: 後続ハンドラキューを一定間隔で繰り返し実行するハンドラ。このハンドラを組み込むことで [batch_single_shot](nablarch-batch-batch_single_shot.md) の処理を定期実行に拡張する。
2. **[../handler/ProcessStopHandler](../../component/handlers/handlers-ProcessStopHandler.md)**: [../handler/ProcessResidentHandler](../../component/handlers/handlers-ProcessResidentHandler.md) の後続に配置し、プロセスを外部から正常停止できるようにする。ProcessResidentHandlerは特定の例外が送出されない限り後続ハンドラを再実行し続けるため、このハンドラの配置が必須。

<details>
<summary>keywords</summary>

ProcessResidentHandler, ProcessStopHandler, batch_single_shot, 常駐処理, 定期実行, ハンドラ追加, メインスレッド

</details>

## 業務アクションハンドラの実装

業務アクションはFW側で提供されるテンプレートクラスを継承して実装する。詳細は [../handler/BatchAction](../../component/handlers/handlers-BatchAction.md) を参照。

<details>
<summary>keywords</summary>

BatchAction, 業務アクション, テンプレートクラス継承, BatchAction実装

</details>

## 標準ハンドラ構成と主要処理フロー

## 標準ハンドラ構成

**ハンドラキュー**:
Main → StatusCodeConvertHandler → ThreadContextClearHandler → GlobalErrorHandler → ThreadContextHandler_main → DuplicateProcessCheckHandler → RetryHandler → ProcessResidentHandler → ProcessStopHandler → ServiceAvailabilityCheckHandler → FileRecordWriterDisposeHandler → DbConnectionManagementHandler_main → TransactionManagementHandler_main → RequestPathJavaPackageMapping → MultiThreadExecutionHandler → DbConnectionManagementHandler → LoopHandler → DataReadHandler → BatchAction

## 主要処理フロー

| 区分 | 種別 | フロー名 | 概要 |
|---|---|---|---|
| プロセス起動制御 | 正常 | 正常起動 | Javaコマンドからプロセス起動し常駐処理を開始する |
| プロセス起動制御 | 異常 | 重複起動エラー | 起動時に同一プロセスが既に起動中の場合は異常終了する |
| 常駐処理制御 | 正常 | 常駐処理正常実行 | 要求管理テーブルの未処理レコードを取得し業務処理を実行。完了後、次回実行タイミングまで待機 |
| 常駐処理制御 | 代替 | 処理対象データ待機 | 要求管理テーブルに未処理レコードがない場合は処理せず次回まで待機 |
| 常駐処理制御 | 代替 | 閉局中処理待機 | 業務機能が閉局中の場合は処理せず次回まで待機 |
| 常駐処理制御 | 異常 | 常駐処理業務エラー | 実行時例外発生時は障害ログ出力後次回まで待機。処理が完了していないレコードは次回以降の実行タイミングで処理される。ただしエラーが発生したレコードはエラーステータスとなりデータメンテを行わない限り再実行されない。リトライ可能例外（DBやMQ接続エラー等）の場合は障害ログではなくワーニングログを出力し処理継続 |
| プロセス停止制御 | 正常 | プロセス正常停止 | プロセス管理テーブルの停止フラグ設定で次回実行タイミングに正常終了（ステータスコード200→終了コード0）。ProcessStopHandlerがProcessStop例外を送出し、ProcessResidentHandlerがこれを捕捉してINFOログ出力後に処理結果をリターンする |
| プロセス停止制御 | 異常 | プロセス異常停止 | java.lang.Errorのサブクラス発生時は即時処理中断・障害ログ出力・異常終了 |
| プロセス停止制御 | 異常 | 常駐処理強制終了 | 業務処理でProcessAbnormalEnd例外を送出すると実行中処理だけでなくプロセス全体が異常終了する |
| プロセス停止制御 | 異常 | エラー発生頻度上限超過によるプロセス強制停止 | 一定時間内のエラー回数が上限を超えた場合はRetryHandlerがProcessAbnormalEndを送出し、障害ログ出力後プロセス異常終了する |

<details>
<summary>keywords</summary>

StatusCodeConvertHandler, ThreadContextClearHandler, GlobalErrorHandler, ThreadContextHandler_main, DuplicateProcessCheckHandler, RetryHandler, ProcessResidentHandler, ProcessStopHandler, ProcessStop, ServiceAvailabilityCheckHandler, FileRecordWriterDisposeHandler, DbConnectionManagementHandler, TransactionManagementHandler, RequestPathJavaPackageMapping, MultiThreadExecutionHandler, LoopHandler, DataReadHandler, BatchAction, ProcessAbnormalEnd, 正常起動, 重複起動エラー, 常駐処理正常実行, 処理対象データ待機, 閉局中処理待機, 常駐処理業務エラー, プロセス正常停止, プロセス異常停止, 常駐処理強制終了, エラー発生頻度上限超過

</details>
