# 都度起動バッチ実行制御基盤

## 概要

[batch_single_shot](nablarch-batch-batch_single_shot.md) は、DBやファイルに格納されたデータレコード1件ごとに業務処理を繰り返し実行する基本的なバッチ処理の仕組みを提供する。

<details>
<summary>keywords</summary>

都度起動バッチ, batch_single_shot, データレコード処理, バッチ処理基盤, 都度起動バッチ実行制御基盤

</details>

## 基本構造

## 基本構造

データレコード1件ごとに業務処理を実行するループ構造が基本。[data_reader](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) と業務アクションハンドラを交互に呼び出し、データリーダからレコードが読み込めなくなった時点で終了する。データリーダは業務アクションハンドラが生成したものを使用する。

**リクエストパスによる業務アクションの指定**

起動引数 `-requestPath` にリクエストパスを指定する。書式:

```bash
(業務アクションクラス名)/(リクエストID)
```

リクエストIDは各バッチプロセスの識別子として使用される（同一業務アクションクラスを複数プロセス起動する場合の識別子）。

<details>
<summary>keywords</summary>

基本構造, DataReader, data_reader, 業務アクションハンドラ, ループ構造, リクエストパス, requestPath, リクエストID, BatchAction

</details>

## 業務アクションハンドラの実装

## 業務アクションハンドラの実装

業務アクションはFW提供のテンプレートクラスを継承して実装する。

<details>
<summary>keywords</summary>

業務アクションハンドラ, BatchAction, テンプレートクラス, 業務アクション実装

</details>

## 標準ハンドラ構成と主要処理フロー

## 標準ハンドラ構成と主要処理フロー

### 処理フロー一覧

| 種別 | 処理フロー名 | 概要 |
|---|---|---|
| 正常フロー | 全件正常終了 | Javaコマンドからバッチプロセスを起動し、全件正常終了後プロセスも正常終了（終了コード=0） |
| 異常フロー | 重複起動エラー | 起動時に同一プロセスが既存する場合は異常終了 |
| 異常フロー | エラー終了 | 業務処理中にエラー発生時、処理中断・障害ログ出力・異常終了（終了コード=20） |
| 異常フロー | 閉局エラー | リクエストIDに対する業務機能が閉局中の場合、業務処理を実行せず異常終了（終了コード=20） |

### 標準ハンドラキュー

Main → StatusCodeConvertHandler → ThreadContextClearHandler → GlobalErrorHandler → ThreadContextHandler_main → DuplicateProcessCheckHandler → ServiceAvailabilityCheckHandler → FileRecordWriterDisposeHandler → DbConnectionManagementHandler_main → TransactionManagementHandler_main → RequestPathJavaPackageMapping → MultiThreadExecutionHandler → DbConnectionManagementHandler → LoopHandler → ProcessStopHandler → DataReadHandler → BatchAction

### 全件正常終了フロー

1. Main (inbound)
2. ThreadContextHandler_main (inbound): 起動引数 `-requestPath` からリクエストIDを決定
3. DbConnectionManagementHandler_main (inbound)
4. TransactionManagementHandler_main (inbound)
5. RequestPathJavaPackageMapping (inbound)
6. MultiThreadExecutionHandler (inbound): 処理開始前及びデータリーダ作成時にBatchActionへコールバック
7. BatchAction (callback): 1.処理開始前、2.データリーダ作成、3.業務コミット後、4.全件終了後
8. DbConnectionManagementHandler (inbound)
9. LoopHandler (inbound)
10. DataReadHandler (inbound)
11. BatchAction (inbound)
12. BatchAction (outbound)
13. LoopHandler (outbound): コミット時にBatchActionへコールバック。結果セットが空になるまでループ
14. BatchAction (callback)
15. DbConnectionManagementHandler (outbound)
16. MultiThreadExecutionHandler (outbound): 全件正常終了後にBatchActionへコールバック
17. BatchAction (callback)
18. TransactionManagementHandler_main (outbound)
19. DbConnectionManagementHandler_main (outbound)
20. StatusCodeConvertHandler (outbound): ステータスコード 207(MultiStatus) → 終了コード 0
21. Main (outbound): 正常終了（終了コード=0）

### 重複起動エラーフロー

1. Main (inbound)
2. ThreadContextHandler_main (inbound): 起動引数 `-requestPath` からリクエストIDを決定
3. DuplicateProcessCheckHandler (inbound): 起動停止時の終了コードはこのハンドラに設定する
4. GlobalErrorHandler (error): 障害ログ出力
5. Main (outbound)

### エラー終了フロー

1. Main (inbound)
2. ThreadContextHandler_main (inbound): 起動引数 `-requestPath` からリクエストIDを決定
3. DbConnectionManagementHandler_main (inbound)
4. TransactionManagementHandler_main (inbound)
5. RequestPathJavaPackageMapping (inbound)
6. MultiThreadExecutionHandler (inbound): 処理開始前及びデータリーダ作成時にBatchActionへコールバック
7. BatchAction (callback): 1.処理開始前、2.データリーダ作成、3.エラー終了後、4.全件終了後
8. DbConnectionManagementHandler (inbound)
9. LoopHandler (inbound)
10. DataReadHandler (inbound)
11. BatchAction (inbound)
12. BatchAction (error): 実行時例外を送出するとトランザクションがロールバックされ障害ログが出力される
13. LoopHandler (outbound): 複数件コミット使用時は未コミット処理もロールバック。BatchActionへコールバック
14. BatchAction (callback)
15. DbConnectionManagementHandler (error)
16. MultiThreadExecutionHandler (error): 全件終了後にBatchActionへコールバック
17. BatchAction (callback)
18. TransactionManagementHandler_main (error)
19. DbConnectionManagementHandler_main (error)
20. GlobalErrorHandler (error): 障害ログ出力（一般実行時例外のステータスコードは500）
21. StatusCodeConvertHandler (outbound): ステータスコード 500 → 終了コード 20
22. Main (outbound): 異常終了（終了コード=20）

### 閉局エラーフロー

1. Main (inbound)
2. ThreadContextHandler_main (inbound): 起動引数 `-requestPath` からリクエストIDを決定
3. ServiceAvailabilityCheckHandler (inbound): 閉局エラー例外を送出する
4. GlobalErrorHandler (error): 障害ログ出力（閉局エラーのステータスコードは503）
5. StatusCodeConvertHandler (outbound): ステータスコード 503 → 終了コード 20
6. Main (outbound): 異常終了（終了コード=20）

<details>
<summary>keywords</summary>

標準ハンドラ構成, 処理フロー, Main, StatusCodeConvertHandler, ThreadContextClearHandler, GlobalErrorHandler, ThreadContextHandler_main, DuplicateProcessCheckHandler, ServiceAvailabilityCheckHandler, FileRecordWriterDisposeHandler, DbConnectionManagementHandler, DbConnectionManagementHandler_main, TransactionManagementHandler, TransactionManagementHandler_main, RequestPathJavaPackageMapping, MultiThreadExecutionHandler, LoopHandler, ProcessStopHandler, DataReadHandler, BatchAction, 全件正常終了, 重複起動エラー, エラー終了, 閉局エラー

</details>
