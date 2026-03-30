# 常駐バッチ実行制御基盤（スレッド同期型）

## 基本構造

[batch_resident_thread_sync](nablarch-batch-batch_resident_thread_sync.md) は、一定間隔ごとにバッチ処理を実行する常駐型プロセスを作成するための制御基盤を提供する。例えば、オンライン処理で作成されたトランザクションデータを定期的に一括処理するような場合に使用される。

> **警告**: 処理が遅いスレッドの終了を他のスレッドが待つことで要求データの取り込み遅延が発生する。新規開発プロジェクトでは [batch_resident_thread_sync](nablarch-batch-batch_resident_thread_sync.md) ではなく [batch_resident](nablarch-batch-batch_resident.md) を使用することを推奨する。既存プロジェクトで問題が発生する（または発生している）場合は [batch_resident](nablarch-batch-batch_resident.md) への変更を検討すること。

[batch_resident_thread_sync](nablarch-batch-batch_resident_thread_sync.md) の構造は [batch_single_shot](nablarch-batch-batch_single_shot.md) と同じだが、メインスレッド側に以下の2ハンドラが追加されている。

1. [../handler/ProcessResidentHandler](../../component/handlers/handlers-ProcessResidentHandler.md): 後続ハンドラキューを一定間隔ごとに繰り返し実行するハンドラ。このハンドラを組み込むことで [batch_single_shot](nablarch-batch-batch_single_shot.md) の処理を定期的に実行するよう拡張したもの。
2. [../handler/ProcessStopHandler](../../component/handlers/handlers-ProcessStopHandler.md): [../handler/ProcessResidentHandler](../../component/handlers/handlers-ProcessResidentHandler.md) の後続に配置し、プロセスを外部から正常停止できるようにするハンドラ。特定の例外が送出されない限り [../handler/ProcessResidentHandler](../../component/handlers/handlers-ProcessResidentHandler.md) は後続ハンドラを再実行し続けるため、必須。

<details>
<summary>keywords</summary>

ProcessResidentHandler, ProcessStopHandler, batch_resident, batch_single_shot, 常駐バッチ, スレッド同期型, 要求データ取り込み遅延, 常駐型プロセス, トランザクションデータ, 定期的に一括処理

</details>

## 業務アクションハンドラの実装

業務アクションは FW提供のテンプレートクラス（[../handler/BatchAction](../../component/handlers/handlers-BatchAction.md)）を継承して作成する。

<details>
<summary>keywords</summary>

BatchAction, テンプレートクラス, 業務アクション実装

</details>

## 標準ハンドラ構成と主要処理フロー

**標準ハンドラ構成**（ハンドラキュー順）:

| No. | ハンドラ |
|---|---|
| 1 | StatusCodeConvertHandler |
| 2 | ThreadContextClearHandler |
| 3 | GlobalErrorHandler |
| 4 | ThreadContextHandler_main |
| 5 | DuplicateProcessCheckHandler |
| 6 | RetryHandler |
| 7 | ProcessResidentHandler |
| 8 | ProcessStopHandler |
| 9 | ServiceAvailabilityCheckHandler |
| 10 | FileRecordWriterDisposeHandler |
| 11 | DbConnectionManagementHandler_main |
| 12 | TransactionManagementHandler_main |
| 13 | RequestPathJavaPackageMapping |
| 14 | MultiThreadExecutionHandler |
| 15 | DbConnectionManagementHandler |
| 16 | LoopHandler |
| 17 | DataReadHandler |
| 18 | BatchAction |

**主要処理フロー**:

**正常起動**:
1. Main (inbound)
2. ThreadContextHandler_main (inbound)
3. ProcessResidentHandler (inbound): 以降、常駐処理を開始。監視間隔ごとに後続ハンドラキューが繰り返し実行される。

**重複起動エラー**:
1. Main (inbound)
2. ThreadContextHandler_main (inbound): 起動引数 `-requestPath` からリクエストIDを決定
3. DuplicateProcessCheckHandler (inbound): 同一プロセスが既に起動中の場合は異常終了。起動停止時の終了コードをここで設定。
4. GlobalErrorHandler (error): 障害ログを出力
5. Main (outbound): 異常終了

**常駐処理正常実行**:
1. ProcessResidentHandler (inbound): 常駐処理の起点
2. DbConnectionManagementHandler_main (inbound)
3. TransactionManagementHandler_main (inbound)
4. RequestPathJavaPackageMapping (inbound)
5. MultiThreadExecutionHandler (inbound): 処理開始前・データリーダ作成時に BatchAction へコールバック
6. BatchAction (callback): コールバックイベント: 処理開始前、データリーダ作成、業務コミット後、全件終了後
7. DbConnectionManagementHandler (inbound)
8. LoopHandler (inbound)
9. DataReadHandler (inbound)
10. BatchAction (inbound/outbound): 業務処理実行
11. LoopHandler (outbound): コミット時に BatchAction コールバック。結果セットが空になるまでループ
12. BatchAction (callback)
13. DbConnectionManagementHandler (outbound)
14. MultiThreadExecutionHandler (outbound): 正常終了後に BatchAction コールバック
15. BatchAction (callback)
16. TransactionManagementHandler_main (outbound)
17. DbConnectionManagementHandler_main (outbound)
18. ProcessResidentHandler (outbound)

**処理対象データ待機**:
1. ProcessResidentHandler (inbound): 常駐処理の起点
2. DbConnectionManagementHandler_main (inbound)
3. TransactionManagementHandler_main (inbound)
4. RequestPathJavaPackageMapping (inbound)
5. MultiThreadExecutionHandler (inbound)
6. DbConnectionManagementHandler (inbound)
7. LoopHandler (inbound): 処理対象データが0件の場合、後続処理は行わず `DataReader.NoMoreRecord` をリターン
8. DbConnectionManagementHandler (outbound)
9. MultiThreadExecutionHandler (outbound)
10. TransactionManagementHandler_main (outbound)
11. DbConnectionManagementHandler_main (outbound)
12. ProcessResidentHandler (outbound): → ① へ

**閉局中処理待機**:
1. ProcessResidentHandler (inbound): 常駐処理の起点
2. ServiceAvailabilityCheckHandler (inbound): サービス閉局例外を送出
3. ProcessResidentHandler (error): サービス閉局例外を捕捉しINFOログ出力。ループ継続 → ① へ

**常駐処理業務エラー**:
1. ProcessResidentHandler (inbound): 常駐処理の起点
2. MultiThreadExecutionHandler (inbound): 処理開始前・データリーダ作成時にコールバック
3. BatchAction (callback): コールバックイベント: 処理開始前、データリーダ作成、エラー終了後、全件終了後
4. BatchAction (error): 実行時例外を送出するとトランザクションがロールバックされ障害ログが出力される
5. LoopHandler (error): 複数件コミット使用時は未コミット処理もロールバック。BatchAction コールバック
6. MultiThreadExecutionHandler (error): 異常終了後に BatchAction コールバック
7. ProcessResidentHandler (error)
8. RetryHandler (error): → ① へ（次の実行タイミングまで待機）

> **注意**: 処理が完了していないレコードは、次回以降の実行タイミングで処理される。ただし、エラーが発生したレコードはエラーステータスとなり、データメンテを行わない限り再実行の対象とならない。リトライ可能例外（DBやMQへの接続エラー等）の場合は障害ログではなくワーニングログを出力し処理継続。

**プロセス正常停止**:
プロセス管理テーブルの停止フラグを設定することで、次回実行タイミングにてプロセスを正常終了させる。
1. ProcessResidentHandler (inbound): 常駐処理の起点
2. ProcessStopHandler (inbound): リクエストIDはバッチ起動引数 `-requestPath` の値から決定
3. ProcessResidentHandler (error): ProcessStop 捕捉でINFOログ出力後、ステータスコード:200でリターン
4. StatusCodeConvertHandler (outbound): ステータスコード:200 → 終了コード:0
5. Main (outbound): 正常終了

**プロセス異常停止**:
`java.lang.Error` のサブクラスが送出された場合:
1. 各ハンドラ error 経由
2. ProcessResidentHandler (error): エラーをそのまま再送出（ループ中断）
3. GlobalErrorHandler (error): 障害ログを出力
4. StatusCodeConvertHandler (outbound)
5. Main (outbound): 異常終了

**常駐処理強制終了**:
業務処理でプロセス全体を終了させる場合は `ProcessAbnormalEnd` 例外を送出:
1. BatchAction (inbound): `ProcessAbnormalEnd` 例外を送出するとプロセス全体をエラー終了させる
2. 各ハンドラ error 経由
3. ProcessResidentHandler (error): `ProcessAbnormalEnd` をそのまま再送出（ループ中断）
4. GlobalErrorHandler (error): `ProcessAbnormalEnd` 捕捉で障害ログ出力
5. StatusCodeConvertHandler (outbound)
6. Main (outbound): 異常終了

**エラー発生頻度上限超過によるプロセス強制停止**:
一定時間内のエラー回数が上限を超えた場合:
1. 常駐処理業務エラーと同様に業務処理エラーが発生
2. RetryHandler (error): リトライ頻度が上限に達した場合は `ProcessAbnormalEnd` を送出
3. GlobalErrorHandler (error): 障害ログを出力
4. StatusCodeConvertHandler (outbound)
5. Main (outbound): 異常終了

<details>
<summary>keywords</summary>

StatusCodeConvertHandler, ThreadContextClearHandler, GlobalErrorHandler, ThreadContextHandler_main, DuplicateProcessCheckHandler, RetryHandler, ProcessResidentHandler, ProcessStopHandler, ServiceAvailabilityCheckHandler, FileRecordWriterDisposeHandler, DbConnectionManagementHandler, TransactionManagementHandler, RequestPathJavaPackageMapping, MultiThreadExecutionHandler, LoopHandler, DataReadHandler, BatchAction, ProcessAbnormalEnd, DataReader, 常駐処理制御, プロセス停止制御, ハンドラ構成, 処理フロー

</details>
