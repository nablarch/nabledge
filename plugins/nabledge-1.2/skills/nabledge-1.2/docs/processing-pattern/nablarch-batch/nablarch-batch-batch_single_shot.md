# 都度起動バッチ実行制御基盤

## 基本構造

バッチ処理の基本ループ構造: [data_reader](../../about/about-nablarch/about-nablarch-concept.md) と業務アクションハンドラを交互に呼び出し、データリーダからレコードが読み込めなくなった時点で終了する。データリーダは業務アクションハンドラが生成したものを使用する。

**リクエストパスによる業務アクションの指定**

バッチプロセスの起動引数 `-requestPath` にリクエストパスを指定する。書式:

```bash
(業務アクションクラス名)/(リクエストID)
```

リクエストIDはバッチプロセスの識別子として用いられる（同一の業務アクションクラスを実行するプロセスを複数起動する場合の識別子）。

<details>
<summary>keywords</summary>

都度起動バッチ, データリーダ, 業務アクションハンドラ, リクエストパス, -requestPath, requestPath, ループ構造, data_reader

</details>

## 業務アクションハンドラの実装

業務アクションは、FW提供のテンプレートクラスを継承して実装する（[../handler/BatchAction](../../component/handlers/handlers-BatchAction.md)）。

<details>
<summary>keywords</summary>

業務アクションハンドラ実装, テンプレートクラス継承, BatchAction

</details>

## 標準ハンドラ構成と主要処理フロー

| 区分 | 種別 | 処理フロー名 | 概要 |
|---|---|---|---|
| バッチ処理制御 | 正常フロー | 全件正常終了 | 対象レコード全件の業務処理が正常終了し、プロセスも正常終了する |
| バッチ処理制御 | 異常フロー | 重複起動エラー | 起動時に同一プロセスが既に起動していた場合は異常終了する |
| バッチ処理制御 | 異常フロー | エラー終了 | 業務処理実行中にエラーが発生した場合は処理中断・障害ログ出力・異常終了する |
| バッチ処理制御 | 異常フロー | 閉局エラー | バッチのリクエストIDに対する業務機能が閉局中の場合は業務処理を実行せず異常終了する |

**標準ハンドラキュー**:
`Main` → `StatusCodeConvertHandler` → `ThreadContextClearHandler` → `GlobalErrorHandler` → `ThreadContextHandler_main` → `DuplicateProcessCheckHandler` → `ServiceAvailabilityCheckHandler` → `FileRecordWriterDisposeHandler` → `DbConnectionManagementHandler_main` → `TransactionManagementHandler_main` → `RequestPathJavaPackageMapping` → `MultiThreadExecutionHandler` → `DbConnectionManagementHandler` → `LoopHandler` → `ProcessStopHandler` → `DataReadHandler` → `BatchAction`

**全件正常終了フロー**:
1. Main（inbound）
2. ThreadContextHandler_main（inbound）: 起動引数 `-requestPath` からリクエストIDを決定
3. DbConnectionManagementHandler_main（inbound）
4. TransactionManagementHandler_main（inbound）
5. RequestPathJavaPackageMapping（inbound）
6. MultiThreadExecutionHandler（inbound）: 処理開始前・データリーダ作成時にBatchActionへコールバック
7. BatchAction（callback）: イベント — 1.処理開始前、2.データリーダ作成、3.業務コミット後、4.全件終了後
8. DbConnectionManagementHandler（inbound）
9. LoopHandler（inbound）
10. DataReadHandler（inbound）
11. BatchAction（inbound）
12. BatchAction（outbound）
13. LoopHandler（outbound）: コミット時にBatchActionへコールバック。結果セットが空になるまでループ
14. BatchAction（callback）
15. DbConnectionManagementHandler（outbound）
16. MultiThreadExecutionHandler（outbound）: 全件正常終了後にBatchActionへコールバック
17. BatchAction（callback）
18. TransactionManagementHandler_main（outbound）
19. DbConnectionManagementHandler_main（outbound）
20. StatusCodeConvertHandler（outbound）: ステータスコード207（MultiStatus）→ 終了コード0
21. Main（outbound）: 正常終了（終了コード=0）

**重複起動エラーフロー**:
1. Main（inbound）
2. ThreadContextHandler_main（inbound）: 起動引数 `-requestPath` からリクエストIDを決定
3. DuplicateProcessCheckHandler（inbound）: 起動停止時の終了コードをこのハンドラに設定する
4. GlobalErrorHandler（error）: 障害ログ出力
5. Main（outbound）: 異常終了

**エラー終了フロー**:
1. Main（inbound）
2. ThreadContextHandler_main（inbound）: 起動引数 `-requestPath` からリクエストIDを決定
3. DbConnectionManagementHandler_main（inbound）
4. TransactionManagementHandler_main（inbound）
5. RequestPathJavaPackageMapping（inbound）
6. MultiThreadExecutionHandler（inbound）: 処理開始前・データリーダ作成時にBatchActionへコールバック
7. BatchAction（callback）: イベント — 1.処理開始前、2.データリーダ作成、3.エラー終了後、4.全件終了後
8. DbConnectionManagementHandler（inbound）
9. LoopHandler（inbound）
10. DataReadHandler（inbound）
11. BatchAction（inbound）
12. BatchAction（error）: 業務処理をエラー終了させる場合は実行時例外を送出→トランザクションロールバック＋障害ログ出力
13. LoopHandler（outbound）: 複数件コミット使用時は未コミット処理もロールバック。BatchActionへコールバック
14. BatchAction（callback）
15. DbConnectionManagementHandler（error）
16. MultiThreadExecutionHandler（error）: 全件終了後にBatchActionへコールバック
17. BatchAction（callback）
18. TransactionManagementHandler_main（error）
19. DbConnectionManagementHandler_main（error）
20. GlobalErrorHandler（error）: 障害ログ出力。一般の実行時例外のステータスコードは500
21. StatusCodeConvertHandler（outbound）: ステータスコード500 → 終了コード20
22. Main（outbound）: 異常終了（終了コード=20）

**閉局エラーフロー**:
1. Main（inbound）
2. ThreadContextHandler_main（inbound）: 起動引数 `-requestPath` からリクエストIDを決定
3. ServiceAvailabilityCheckHandler（inbound）: 閉局エラー例外を送出
4. GlobalErrorHandler（error）: 障害ログ出力。閉局エラーのステータスコードは503
5. StatusCodeConvertHandler（outbound）: ステータスコード503 → 終了コード20
6. Main（outbound）: 異常終了（終了コード=20）

<details>
<summary>keywords</summary>

標準ハンドラ構成, 処理フロー, 全件正常終了, 重複起動エラー, エラー終了, 閉局エラー, DuplicateProcessCheckHandler, ServiceAvailabilityCheckHandler, MultiThreadExecutionHandler, LoopHandler, DataReadHandler, StatusCodeConvertHandler, GlobalErrorHandler, TransactionManagementHandler, DbConnectionManagementHandler, ThreadContextClearHandler, FileRecordWriterDisposeHandler, RequestPathJavaPackageMapping, ProcessStopHandler, ThreadContextHandler_main

</details>
