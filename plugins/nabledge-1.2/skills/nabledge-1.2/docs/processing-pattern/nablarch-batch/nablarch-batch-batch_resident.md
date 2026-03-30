# 常駐バッチ実行制御基盤

## 基本構造

オンライン処理で作成されたトランザクションデータを定期的に一括処理するような場合に使用される常駐型プロセスを作成するための制御基盤。

[batch_resident](nablarch-batch-batch_resident.md) の構造は、メインスレッド側に以下の2つのハンドラが追加されている点を除き、[batch_single_shot](nablarch-batch-batch_single_shot.md) と同じ。

**追加ハンドラ:**

1. **ProcessResidentHandler** ([../handler/ProcessResidentHandler](../../component/handlers/handlers-ProcessResidentHandler.md)): 後続のハンドラキューの内容を一定間隔ごとに繰り返し実行するハンドラ。[batch_single_shot](nablarch-batch-batch_single_shot.md) による処理を定期的に実行するよう拡張したもの。
2. **ProcessStopHandler** ([../handler/ProcessStopHandler](../../component/handlers/handlers-ProcessStopHandler.md)): ProcessResidentHandlerは特定の例外が送出されない限り後続ハンドラを再実行し続けるため、ProcessResidentHandlerの後続に配置してプロセスを外部から正常停止できるようにする必要がある。

<details>
<summary>keywords</summary>

ProcessResidentHandler, ProcessStopHandler, 常駐バッチ, 常駐型プロセス, batch_resident, batch_single_shot, 基本構造, オンライン処理, トランザクションデータ, 定期的に一括処理

</details>

## 業務アクションハンドラの実装

業務アクションはFW側で提供されるテンプレートクラスを継承して作成する。詳細は [../handler/BatchAction](../../component/handlers/handlers-BatchAction.md) を参照。

<details>
<summary>keywords</summary>

BatchAction, 業務アクション, テンプレートクラス, BatchAction継承

</details>

## 標準ハンドラ構成と主要処理フロー

**標準ハンドラ構成 (ハンドラキュー順):**

1. Main
2. StatusCodeConvertHandler
3. ThreadContextClearHandler
4. GlobalErrorHandler
5. ThreadContextHandler_main
6. DuplicateProcessCheckHandler
7. RetryHandler
8. ProcessResidentHandler
9. ProcessStopHandler
10. ServiceAvailabilityCheckHandler
11. FileRecordWriterDisposeHandler
12. DbConnectionManagementHandler_main
13. TransactionManagementHandler_main
14. RequestPathJavaPackageMapping
15. MultiThreadExecutionHandler
16. DbConnectionManagementHandler
17. LoopHandler
18. DataReadHandler
19. BatchAction

**主要処理フロー一覧:**

| 区分 | 種別 | 処理フロー名 | 概要 |
|---|---|---|---|
| プロセス起動制御 | 正常フロー | 正常起動 | Javaコマンドからプロセスを起動し、常駐処理を開始する |
| プロセス起動制御 | 異常フロー | 重複起動エラー | 起動時に既に同一プロセスが起動していた場合は異常終了する |
| 常駐処理制御 | 正常フロー | 常駐処理正常実行 | 要求管理テーブルから未処理レコードを取得し業務処理を実行。完了後、次の実行タイミングまで待機 |
| 常駐処理制御 | 代替フロー | 処理対象データ待機 | 未処理レコードが存在しない場合は処理を行わず待機 |
| 常駐処理制御 | 代替フロー | 閉局中処理待機 | 業務機能が閉局中の場合は処理を行わず待機 |
| 常駐処理制御 | 異常フロー | 常駐処理業務エラー | 実行時例外が送出された場合は障害ログを出力し次の実行タイミングまで待機。エラーレコードはエラーステータスとなり、データメンテを行なわない限り再実行の対象とならない。リトライ可能例外（DBやMQなどへの接続エラー等）の場合は、障害原因が復旧することで処理継続できるため即障害通知不要として、ワーニングログを出力して処理継続 |
| プロセス停止制御 | 正常フロー | プロセス正常停止 | プロセス管理テーブルの停止フラグを設定することで、次の実行タイミングにて処理せずに正常終了 |
| プロセス停止制御 | 異常フロー | プロセス異常停止 | java.lang.Errorが発生した場合は障害ログを出力し異常終了 |
| プロセス停止制御 | 異常フロー | 常駐処理強制終了 | ProcessAbnormalEnd例外を送出することで、常駐プロセス全体を異常終了させる |
| プロセス停止制御 | 異常フロー | エラー発生頻度上限超過によるプロセス強制停止 | 一定時間内のエラー回数が上限値を超えた場合は障害ログを出力しプロセスを異常終了 |

**処理フロー詳細:**

**正常起動:**
1. Main (往路)
2. ThreadContextHandler_main (往路)
3. ProcessResidentHandler (往路) — 以降、常駐処理を開始する。監視間隔ごとに後続のハンドラキューの処理が繰り返し実行される

**重複起動エラー:**
1. Main (往路)
2. ThreadContextHandler_main (往路) — 起動引数 `-requestPath` からリクエストIDを決定する
3. DuplicateProcessCheckHandler (往路) — 起動停止時の終了コードはこのハンドラに設定する
4. GlobalErrorHandler (例外) — ここで障害ログが出力される
5. Main (復路) — 異常終了

**常駐処理正常実行:**
1. ProcessResidentHandler (往路) — 常駐処理の起点
2. DbConnectionManagementHandler_main (往路)
3. TransactionManagementHandler_main (往路)
4. RequestPathJavaPackageMapping (往路)
5. MultiThreadExecutionHandler (往路) — 処理開始前及びデータリーダ作成時に業務アクションへのコールバックを行う
6. BatchAction (コールバック) — コールバックイベント: 1.処理開始前、2.データリーダ作成、3.業務コミット後、4.全件終了後
7. DbConnectionManagementHandler (往路)
8. LoopHandler (往路)
9. DataReadHandler (往路)
10. BatchAction (往路)
11. BatchAction (復路)
12. LoopHandler (復路) — コミット時に業務アクションへのコールバック。結果セットが空になるまでループ
13. BatchAction (コールバック)
14. DbConnectionManagementHandler (復路)
15. MultiThreadExecutionHandler (復路) — 正常終了後に業務アクションへのコールバック
16. BatchAction (コールバック)
17. TransactionManagementHandler_main (復路)
18. DbConnectionManagementHandler_main (復路)
19. ProcessResidentHandler (復路)

**処理対象データ待機:**
1. ProcessResidentHandler (往路) — 常駐処理の起点
2. DbConnectionManagementHandler_main (往路)
3. TransactionManagementHandler_main (往路)
4. RequestPathJavaPackageMapping (往路)
5. MultiThreadExecutionHandler (往路) — 処理開始前及びデータリーダ作成時に業務アクションへのコールバック
6. DbConnectionManagementHandler (往路)
7. LoopHandler (往路) — 要求管理テーブル上の処理対象データが0件の場合は後続処理を行わず DataReader.NoMoreRecord をリターン
8. DbConnectionManagementHandler (復路)
9. MultiThreadExecutionHandler (復路)
10. TransactionManagementHandler_main (復路)
11. DbConnectionManagementHandler_main (復路)
12. ProcessResidentHandler (復路) — ①へ戻る

**閉局中処理待機:**
1. ProcessResidentHandler (往路) — 常駐処理の起点
2. ServiceAvailabilityCheckHandler (往路) — サービス閉局例外を送出する
3. ProcessResidentHandler (例外) — サービス閉局例外を捕捉した場合、INFOログを出力しループを継続する。①へ戻る

**常駐処理業務エラー:**
1. ProcessResidentHandler (往路) — 常駐処理の起点
2. DbConnectionManagementHandler_main (往路)
3. TransactionManagementHandler_main (往路)
4. RequestPathJavaPackageMapping (往路)
5. MultiThreadExecutionHandler (往路) — 処理開始前及びデータリーダ作成時に業務アクションへのコールバック
6. BatchAction (コールバック) — コールバックイベント: 1.処理開始前、2.データリーダ作成、3.エラー終了後、4.全件終了後
7. DbConnectionManagementHandler (往路)
8. LoopHandler (往路)
9. DataReadHandler (往路)
10. BatchAction (往路)
11. BatchAction (例外) — 業務処理をエラー終了させる場合は実行時例外を送出する。トランザクションがロールバックされ障害ログが出力される
12. LoopHandler (例外) — 複数件コミットの場合は未コミット処理もロールバック。業務アクションへコールバック
13. BatchAction (コールバック)
14. DbConnectionManagementHandler (例外)
15. MultiThreadExecutionHandler (例外) — 異常終了後に業務アクションへのコールバック
16. BatchAction (コールバック)
17. TransactionManagementHandler_main (例外)
18. DbConnectionManagementHandler_main (例外)
19. ProcessResidentHandler (例外)
20. RetryHandler (例外) — ①へ戻る

**プロセス正常停止:**
1. ProcessResidentHandler (往路) — 常駐処理の起点
2. ProcessStopHandler (往路) — リクエストIDはバッチの起動引数 `-requestPath` の値から決定される
3. ProcessResidentHandler (例外) — プロセス停止要求(ProcessStop)を捕捉するとINFOログを出力後、処理結果オブジェクトをリターン（ステータスコード:200）
4. StatusCodeConvertHandler (復路) — ステータスコード:200 → 終了コード:0
5. Main (復路) — 正常終了

**常駐処理強制終了:**
1. BatchAction (往路) — 常駐プロセス自体を終了させる場合は ProcessAbnormalEnd 例外を送出する
2. LoopHandler (例外) — 複数件コミットの場合は未コミット処理もロールバック。業務アクションへコールバック
3. BatchAction (コールバック)
4. DbConnectionManagementHandler (例外)
5. MultiThreadExecutionHandler (例外) — 異常終了後に業務アクションへのコールバック
6. BatchAction (コールバック)
7. TransactionManagementHandler_main (例外)
8. DbConnectionManagementHandler_main (例外)
9. ProcessResidentHandler (例外) — ProcessAbnormalEndをそのまま再送出（ループ中断）
10. GlobalErrorHandler (例外) — ProcessAbnormalEndを捕捉した場合、障害ログを出力し例外を処理結果オブジェクトとしてリターン
11. StatusCodeConvertHandler (復路)
12. Main (復路) — 異常終了

**プロセス異常停止:**
1. BatchAction (往路) — 処理中に java.lang.Error のサブクラスが送出されたとする
2. LoopHandler (例外) — 複数件コミットの場合は未コミット処理もロールバック。業務アクションへコールバック
3. BatchAction (コールバック)
4. DbConnectionManagementHandler (例外)
5. MultiThreadExecutionHandler (例外) — 異常終了後に業務アクションへのコールバック
6. BatchAction (コールバック)
7. TransactionManagementHandler_main (例外)
8. DbConnectionManagementHandler_main (例外)
9. ProcessResidentHandler (例外) — 発生したエラーをそのまま再送出（ループ中断）
10. GlobalErrorHandler (例外) — 障害ログを出力し、異常終了を表す処理結果オブジェクトをリターン
11. StatusCodeConvertHandler (復路)
12. Main (復路) — 異常終了

**エラー発生頻度上限超過によるプロセス強制停止:**
1. ProcessResidentHandler (往路) — 常駐処理の起点
2. DbConnectionManagementHandler_main (往路)
3. TransactionManagementHandler_main (往路)
4. RequestPathJavaPackageMapping (往路)
5. MultiThreadExecutionHandler (往路) — 処理開始前及びデータリーダ作成時に業務アクションへのコールバック
6. BatchAction (コールバック) — コールバックイベント: 1.処理開始前、2.データリーダ作成、3.エラー終了後、4.全件終了後
7. DbConnectionManagementHandler (往路)
8. LoopHandler (往路)
9. DataReadHandler (往路)
10. BatchAction (往路)
11. BatchAction (例外) — 実行時例外を送出。トランザクションがロールバックされ障害ログが出力される
12. LoopHandler (例外) — 複数件コミットの場合は未コミット処理もロールバック。業務アクションへコールバック
13. BatchAction (コールバック)
14. DbConnectionManagementHandler (例外)
15. MultiThreadExecutionHandler (例外) — 異常終了後に業務アクションへのコールバック
16. BatchAction (コールバック)
17. TransactionManagementHandler_main (例外)
18. DbConnectionManagementHandler_main (例外)
19. ProcessResidentHandler (例外)
20. RetryHandler (例外) — リトライ頻度が上限に達した場合はProcessAbnormalEndを送出
21. GlobalErrorHandler (例外) — 障害ログを出力し、異常終了を表す処理結果オブジェクトをリターン
22. StatusCodeConvertHandler (復路)
23. Main (復路) — 異常終了

<details>
<summary>keywords</summary>

標準ハンドラ構成, 処理フロー, StatusCodeConvertHandler, ThreadContextClearHandler, GlobalErrorHandler, ThreadContextHandler_main, FileRecordWriterDisposeHandler, DbConnectionManagementHandler_main, TransactionManagementHandler_main, RequestPathJavaPackageMapping, DbConnectionManagementHandler, ProcessStop, DuplicateProcessCheckHandler, RetryHandler, ServiceAvailabilityCheckHandler, MultiThreadExecutionHandler, LoopHandler, DataReadHandler, DataReader, ProcessAbnormalEnd, 常駐処理正常実行, 重複起動エラー, プロセス正常停止, エラー発生頻度上限超過, プロセス強制停止

</details>
