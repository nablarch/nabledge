# 都度起動バッチ実行制御基盤

## 基本構造

都度起動バッチの基本ループ構造: [data_reader](../../about/about-nablarch/about-nablarch-concept.md) と業務アクションハンドラを交互に呼び出し、データリーダからレコードが読み込めなくなった時点で終了する。データリーダは業務アクションハンドラが生成したものを使用する。

**リクエストパスによる業務アクションの指定**

バッチ処理では [リクエストパス](../../about/about-nablarch/about-nablarch-concept.md) をバッチプロセスの起動引数 `-requestPath` に指定する。書式:

```bash
"(業務アクションクラス名)" + "/" + "(リクエストID)"
```

リクエストIDは各バッチプロセスの識別子として使用される（同一業務アクションクラスで複数プロセス起動時の識別に用いる）。

<details>
<summary>keywords</summary>

data_reader, BatchAction, -requestPath, リクエストパス, 業務アクション, ループ構造, バッチ起動引数, リクエストID

</details>

## 業務アクションハンドラの実装

業務アクションは、FW側で提供されるテンプレートクラス（[../handler/BatchAction](../../component/handlers/handlers-BatchAction.md)）を継承して作成する。

<details>
<summary>keywords</summary>

BatchAction, 業務アクションハンドラ実装, テンプレートクラス継承

</details>

## 標準ハンドラ構成と主要処理フロー

**標準ハンドラ構成**

Main → StatusCodeConvertHandler → ThreadContextClearHandler → GlobalErrorHandler → ThreadContextHandler_main → DuplicateProcessCheckHandler → ServiceAvailabilityCheckHandler → FileRecordWriterDisposeHandler → DbConnectionManagementHandler_main → TransactionManagementHandler_main → RequestPathJavaPackageMapping → MultiThreadExecutionHandler → DbConnectionManagementHandler → LoopHandler → ProcessStopHandler → DataReadHandler → BatchAction

**主要処理フロー**

| 種別 | 処理フロー名 | 概要 |
|---|---|---|
| 正常フロー | 全件正常終了 | Javaコマンドからバッチプロセスを起動する。対象レコード全件に対する業務処理が正常終了し、プロセス自体も正常終了する |
| 異常フロー | 重複起動エラー | 起動時に同一プロセスが既に起動していた場合は異常終了する |
| 異常フロー | エラー終了 | 業務処理実行中にエラーが発生した場合、処理を中断し障害ログを出力して異常終了する |
| 異常フロー | 閉局エラー | バッチのリクエストIDに対する業務機能が閉局中の場合、業務処理未実行で異常終了する |

**全件正常終了フロー**

1. ThreadContextHandler_main (往路): 起動引数 `-requestPath` からリクエストIDを決定する
2. MultiThreadExecutionHandler (往路): 処理開始前及びデータリーダ作成時に業務アクションへのコールバックを行う
3. BatchAction (コールバック): 1.処理開始前、2.データリーダ作成、3.業務コミット後、4.全件終了後にコールバックされる
4. LoopHandler (復路): コミット時に業務アクションへのコールバックを行う。結果セットが空になるまでループする
5. MultiThreadExecutionHandler (復路): 全件正常終了後に業務アクションへのコールバックを行う
6. StatusCodeConvertHandler: ステータスコード207(MultiStatus) → 終了コード0
7. Main: 正常終了（終了コード=0）

**重複起動エラーフロー**

1. ThreadContextHandler_main (往路): 起動引数 `-requestPath` からリクエストIDを決定する
2. DuplicateProcessCheckHandler (往路): 同一プロセス起動検知。起動停止時の終了コードをこのハンドラに設定する
3. GlobalErrorHandler (例外): 障害ログが出力される

**エラー終了フロー**

1. ThreadContextHandler_main (往路): 起動引数 `-requestPath` からリクエストIDを決定する
2. MultiThreadExecutionHandler (往路): 処理開始前及びデータリーダ作成時に業務アクションへのコールバックを行う
3. BatchAction (コールバック): 1.処理開始前、2.データリーダ作成、3.エラー終了後、4.全件終了後にコールバックされる
4. BatchAction (例外): 業務処理をエラー終了させる場合は実行時例外を送出する。トランザクションがロールバックされ、障害ログが出力される
5. LoopHandler (復路): 複数件コミット使用時は未コミットの処理もロールバックされる。業務アクションをコールバックする
6. MultiThreadExecutionHandler (例外): 全件終了後に業務アクションへのコールバックを行う
7. BatchAction (コールバック)
8. GlobalErrorHandler (例外): 障害ログが出力される。一般の実行時例外のステータスコードは500
9. StatusCodeConvertHandler: ステータスコード500 → 終了コード20
10. Main: 異常終了（終了コード=20）

**閉局エラーフロー**

1. ServiceAvailabilityCheckHandler (往路): 閉局エラー例外を送出する
2. GlobalErrorHandler (例外): 障害ログが出力される。閉局エラーのステータスコードは503
3. StatusCodeConvertHandler: ステータスコード503 → 終了コード20
4. Main: 異常終了（終了コード=20）

<details>
<summary>keywords</summary>

Main, StatusCodeConvertHandler, ThreadContextClearHandler, GlobalErrorHandler, ThreadContextHandler_main, DuplicateProcessCheckHandler, ServiceAvailabilityCheckHandler, FileRecordWriterDisposeHandler, DbConnectionManagementHandler, DbConnectionManagementHandler_main, TransactionManagementHandler_main, RequestPathJavaPackageMapping, MultiThreadExecutionHandler, LoopHandler, ProcessStopHandler, DataReadHandler, BatchAction, 全件正常終了, 重複起動エラー, エラー終了, 閉局エラー, ハンドラ構成, 処理フロー, 終了コード

</details>
