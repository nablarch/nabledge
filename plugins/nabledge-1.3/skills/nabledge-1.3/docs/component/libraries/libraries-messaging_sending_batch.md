# 応答不要メッセージ送信常駐バッチ

## 基本構造

利用側からは対象テーブルへのINSERT文を発行するだけでメッセージを送信することができる。

[messaging_sending_batch](libraries-messaging_sending_batch.md) は通常の [../architectural_pattern/batch_resident_thread_sync](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident_thread_sync.md) に対し、以下のハンドラを追加した構成。

1. [../handler/MessagingContextHandler](../handlers/handlers-MessagingContextHandler.md)
2. [../handler/AsyncMessageSendAction](../handlers/handlers-AsyncMessageSendAction.md)

業務アクションハンドラの新規作成は不要。[../handler/AsyncMessageSendAction](../handlers/handlers-AsyncMessageSendAction.md) の設定・SQL文・送信電文フォーマット定義のみ作成すればよい。

作成が必要なリソース一覧:

| 内容 | リソース名 |
|---|---|
| 送信要求テーブルから送信対象レコードを取得するSQL | `(SQL定義配置パッケージ設定値).(メッセージリクエストID)#SELECT_SEND_DATA` |
| 送信完了後、処理ステータスを"送信済み"に変更するSQL | `(SQL定義配置パッケージ設定値).(メッセージリクエストID)#UPDATE_NORMAL_END` |
| エラー発生時、処理ステータスを"エラー"に変更するSQL | `(SQL定義配置パッケージ設定値).(メッセージリクエストID)#UPDATE_ABNORMAL_END` |
| フレームワーク制御ヘッダ部フォーマット定義ファイル | `(フォーマット定義ファイル配置先論理パス名)/(フレームワーク制御ヘッダフォーマットファイル名)` |
| メッセージボディ部フォーマット定義ファイル | `(フォーマット定義ファイル配置先論理パス名)/(メッセージリクエストID)_SEND` |

各種設定値は [../handler/AsyncMessageSendAction](../handlers/handlers-AsyncMessageSendAction.md) を参照。

<details>
<summary>keywords</summary>

MessagingContextHandler, AsyncMessageSendAction, SELECT_SEND_DATA, UPDATE_NORMAL_END, UPDATE_ABNORMAL_END, 応答不要メッセージ送信, 送信要求テーブル, フォーマット定義ファイル, 常駐バッチ構成, メッセージリクエストID

</details>

## 標準ハンドラ構成と主要処理フロー

標準ハンドラ構成 (batch residentコンテキスト):

1. Main
2. StatusCodeConvertHandler
3. GlobalErrorHandler
4. ThreadContextHandler_main
5. DuplicateProcessCheckHandler
6. ProcessResidentHandler
7. RetryHandler
8. ProcessStopHandler
9. ServiceAvailabilityCheckHandler
10. DbConnectionManagementHandler_main
11. TransactionManagementHandler_main
12. RequestPathJavaPackageMapping
13. MultiThreadExecutionHandler
14. MessagingContextHandler
15. DbConnectionManagementHandler
16. LoopHandler
17. DataReadHandler
18. AsyncMessageSendAction

処理フロー一覧は [../architectural_pattern/batch_resident_thread_sync](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident_thread_sync.md) を参照。

**正常起動**:
1. Main → ThreadContextHandler_main → ProcessResidentHandler (inbound): 以降、監視間隔ごとに後続ハンドラキューの処理が繰り返し実行される。

**重複起動エラー**:
1. ThreadContextHandler_main: 起動引数 `-requestPath` からリクエストIDを決定。
2. DuplicateProcessCheckHandler: 起動停止時の終了コードはこのハンドラに設定する。
3. GlobalErrorHandler (error): 障害ログが出力される。

**常駐処理正常実行**:
1. MultiThreadExecutionHandler: 処理開始前・DataReader作成時にBatchActionへコールバック (イベント: 処理開始前、データリーダ作成、業務コミット後、全件終了後)。
2. LoopHandler: DataReadHandlerで取得した結果セットが空になるまでループ。コミット時にBatchActionへコールバック。
3. MultiThreadExecutionHandler: 正常終了後にBatchActionへコールバック。

**処理対象データ待機**:
- LoopHandler: 要求管理テーブル上の処理対象データが0件の場合、後続処理を行わず `DataReader.NoMoreRecord` をリターン。

**閉局中処理待機**:
- ServiceAvailabilityCheckHandler: サービス閉局例外を送出。
- ProcessResidentHandler (error): サービス閉局例外を捕捉した場合、INFOログを出力してループを継続。

**常駐処理異常終了**:
- BatchAction: 業務処理をエラー終了させる場合は実行時例外を送出 → トランザクションがロールバックされ障害ログが出力される。
- LoopHandler (error): 複数件コミット使用時は未コミット処理もロールバック。業務アクションをコールバック。

**プロセス正常停止**:
1. ProcessStopHandler: リクエストIDは起動引数 `-requestPath` の値から決定。
2. ProcessResidentHandler (error): ProcessStop例外を捕捉するとINFOログ出力後、処理結果オブジェクトをリターン (ステータスコード: 200)。
3. StatusCodeConvertHandler: ステータスコード 200 → 終了コード 0 に変換。

**強制停止 (プロセス全体のエラー終了)**:
- BatchAction: `ProcessAbnormalEnd` 例外を送出すると、実行中の処理だけでなくプロセス全体がエラー終了する。
- ProcessResidentHandler (error): `ProcessAbnormalEnd` はそのまま再送出 (ループ中断)。
- GlobalErrorHandler: `ProcessAbnormalEnd` を捕捉して障害ログを出力し、例外を処理結果オブジェクトとしてリターン。

<details>
<summary>keywords</summary>

ProcessResidentHandler, MultiThreadExecutionHandler, DuplicateProcessCheckHandler, ProcessStopHandler, ServiceAvailabilityCheckHandler, LoopHandler, DataReadHandler, StatusCodeConvertHandler, ProcessAbnormalEnd, GlobalErrorHandler, BatchAction, 常駐バッチ標準ハンドラ, 重複起動エラー, プロセス停止, DataReader.NoMoreRecord, ThreadContextHandler_main, DbConnectionManagementHandler_main, TransactionManagementHandler_main, RequestPathJavaPackageMapping, RetryHandler, DbConnectionManagementHandler, MessagingContextHandler

</details>
