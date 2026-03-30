# 応答不要メッセージ送信常駐バッチ

## 基本構造

応答を伴わないメッセージ送信処理で用いる常駐バッチ。利用側からは対象テーブルへのINSERT文を発行するだけでメッセージを送信することができる。

[messaging_sending_batch](libraries-messaging_sending_batch.md) は [../architectural_pattern/batch_resident](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident.md) に以下のハンドラを追加した構成：

1. [../handler/MessagingContextHandler](../handlers/handlers-MessagingContextHandler.md)
2. [../handler/AsyncMessageSendAction](../handlers/handlers-AsyncMessageSendAction.md)

業務アクションハンドラの新規作成は不要。[../handler/AsyncMessageSendAction](../handlers/handlers-AsyncMessageSendAction.md) の設定と、以下のSQL文・フォーマット定義を作成すればよい。

| 内容 | リソース名 |
|---|---|
| 送信対象レコード取得クエリ | (SQL定義配置パッケージ設定値).(メッセージリクエストID)#SELECT_SEND_DATA |
| 送信完了後、処理ステータスを"送信済み"に変更するSQL | (SQL定義配置パッケージ設定値).(メッセージリクエストID)#UPDATE_NORMAL_END |
| エラー発生時、処理ステータスを"エラー"に変更するSQL | (SQL定義配置パッケージ設定値).(メッセージリクエストID)#UPDATE_ABNORMAL_END |
| フレームワーク制御ヘッダ部フォーマット定義ファイル | (フォーマット定義ファイル配置先論理パス名)/(フレームワーク制御ヘッダフォーマットファイル名) |
| メッセージボディ部フォーマット定義ファイル | (フォーマット定義ファイル配置先論理パス名)/(メッセージリクエストID)_SEND |

各種設定値は [../handler/AsyncMessageSendAction](../handlers/handlers-AsyncMessageSendAction.md) を参照。

<details>
<summary>keywords</summary>

MessagingContextHandler, AsyncMessageSendAction, SELECT_SEND_DATA, UPDATE_NORMAL_END, UPDATE_ABNORMAL_END, 応答不要メッセージ送信, 送信要求テーブル, メッセージ送信バッチ設定, フォーマット定義ファイル

</details>

## 標準ハンドラ構成と主要処理フロー

**標準ハンドラ構成**（順序）：

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

処理フロー一覧は [../architectural_pattern/batch_resident](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident.md) を参照。

**主要処理フロー**

正常起動：
1. Main → ThreadContextHandler_main → ProcessResidentHandler（常駐処理開始。監視間隔ごとに後続ハンドラキューを繰り返し実行）

重複起動エラー：
1. ThreadContextHandler_main：起動引数`-requestPath`からリクエストIDを決定
2. DuplicateProcessCheckHandler：起動停止時の終了コードはこのハンドラに設定
3. GlobalErrorHandler：障害ログ出力

常駐処理正常実行：
1. MultiThreadExecutionHandler（inbound）：処理開始前及びデータリーダ作成時に業務アクションへコールバック（イベント：1.処理開始前、2.データリーダ作成、3.業務コミット後、4.全件終了後）
2. LoopHandler（outbound）：コミット時に業務アクションへコールバック。結果セットが空になるまでループ
3. MultiThreadExecutionHandler（outbound）：正常終了後に業務アクションへコールバック

処理対象データ待機：
- LoopHandler（inbound）：要求管理テーブル上の処理対象データが0件の場合、DataReader.NoMoreRecordをリターン。後続処理は行わない

閉局中処理待機：
- ServiceAvailabilityCheckHandler（inbound）：サービス閉局例外を送出
- ProcessResidentHandler（error）：サービス閉局例外を捕捉した場合、INFOログを出力しループを継続

常駐処理異常終了：
- MultiThreadExecutionHandler（inbound）：処理開始前及びデータリーダ作成時に業務アクションへコールバック（イベント：1.処理開始前、2.データリーダ作成、3.エラー終了後、4.全件終了後）※正常実行フローの3番目のイベントが「業務コミット後」であるのに対し、異常終了フローでは「エラー終了後」となる
- BatchAction（error）：業務処理をエラー終了させる場合は実行時例外を送出。トランザクションがロールバックされ障害ログが出力される
- LoopHandler（error）：複数件コミット使用時は未コミット処理もロールバック。業務アクションへコールバック
- MultiThreadExecutionHandler（error）：異常終了後に業務アクションへコールバック

プロセス正常停止：
- ProcessStopHandler（inbound）：リクエストIDは起動引数`-requestPath`の値から決定
- ProcessResidentHandler（error）：ProcessStop捕捉時、INFOログ出力後に処理結果オブジェクトをリターン（ステータスコード:200）
- StatusCodeConvertHandler（outbound）：ステータスコード:200 → 終了コード:0

強制停止（ProcessAbnormalEnd）：
- BatchAction（error）：常駐プロセス全体を終了させる場合はProcessAbnormalEnd例外を送出
- LoopHandler（error）：複数件コミット使用時は未コミット処理もロールバック。業務アクションへコールバック
- MultiThreadExecutionHandler（error）：異常終了後に業務アクションへコールバック
- ProcessResidentHandler（error）：ProcessAbnormalEndをそのまま再送出（ループ中断）
- GlobalErrorHandler（error）：ProcessAbnormalEndを捕捉した場合、障害ログを出力し例外を処理結果オブジェクトとしてリターン

<details>
<summary>keywords</summary>

ProcessResidentHandler, MultiThreadExecutionHandler, DbConnectionManagementHandler, TransactionManagementHandler, LoopHandler, DataReadHandler, StatusCodeConvertHandler, DuplicateProcessCheckHandler, ServiceAvailabilityCheckHandler, ProcessAbnormalEnd, GlobalErrorHandler, RetryHandler, ProcessStopHandler, ThreadContextHandler_main, RequestPathJavaPackageMapping, BatchAction, 常駐バッチハンドラ構成, 処理フロー

</details>
