# 応答不要メッセージ送信常駐バッチ

## 

送信要求テーブルを定期監視し、各レコードからメッセージを作成・送信する常駐バッチ。応答を伴わないメッセージ送信処理で使用する。利用側は対象テーブルへINSERTするだけでメッセージ送信が可能。

<details>
<summary>keywords</summary>

応答不要メッセージ送信, 常駐バッチ, 送信要求テーブル監視, メッセージ送信, INSERT

</details>

## 基本構造

[messaging_sending_batch](libraries-messaging_sending_batch.md) の構成は [../architectural_pattern/batch_resident_thread_sync](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident_thread_sync.md) に以下のハンドラを追加したもの:

1. [../handler/MessagingContextHandler](../handlers/handlers-MessagingContextHandler.md)
2. [../handler/AsyncMessageSendAction](../handlers/handlers-AsyncMessageSendAction.md)

業務アクションハンドラの新規作成不要。[../handler/AsyncMessageSendAction](../handlers/handlers-AsyncMessageSendAction.md) の設定と、以下のSQL文・フォーマット定義を作成する。

| 内容 | リソース名 |
|---|---|
| 送信要求テーブルから送信対象レコードを取得するSQL | (SQL定義配置パッケージ設定値).(メッセージリクエストID)#SELECT_SEND_DATA |
| 送信完了後、対象レコードの処理ステータスを"送信済み"に変更するSQL | (SQL定義配置パッケージ設定値).(メッセージリクエストID)#UPDATE_NORMAL_END |
| エラー発生時、対象レコードの処理ステータスを"エラー"に変更するSQL | (SQL定義配置パッケージ設定値).(メッセージリクエストID)#UPDATE_ABNORMAL_END |
| フレームワーク制御ヘッダ部のフォーマット定義ファイル | (フォーマット定義ファイル配置先論理パス名)/(フレームワーク制御ヘッダフォーマットファイル名) |
| メッセージボディ部のフォーマット定義ファイル | (フォーマット定義ファイル配置先論理パス名)/(メッセージリクエストID)_SEND |

各種設定値は [../handler/AsyncMessageSendAction](../handlers/handlers-AsyncMessageSendAction.md) を参照。

<details>
<summary>keywords</summary>

MessagingContextHandler, AsyncMessageSendAction, SELECT_SEND_DATA, UPDATE_NORMAL_END, UPDATE_ABNORMAL_END, 基本構造, SQL定義, フォーマット定義, メッセージリクエストID

</details>

## 標準ハンドラ構成と主要処理フロー

処理フロー一覧は [../architectural_pattern/batch_resident_thread_sync](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident_thread_sync.md) 参照。

**標準ハンドラ構成**:

| No. | ハンドラ |
|---|---|
| 1 | Main |
| 2 | StatusCodeConvertHandler |
| 3 | GlobalErrorHandler |
| 4 | ThreadContextHandler_main |
| 5 | DuplicateProcessCheckHandler |
| 6 | ProcessResidentHandler |
| 7 | RetryHandler |
| 8 | ProcessStopHandler |
| 9 | ServiceAvailabilityCheckHandler |
| 10 | DbConnectionManagementHandler_main |
| 11 | TransactionManagementHandler_main |
| 12 | RequestPathJavaPackageMapping |
| 13 | MultiThreadExecutionHandler |
| 14 | MessagingContextHandler |
| 15 | DbConnectionManagementHandler |
| 16 | LoopHandler |
| 17 | DataReadHandler |
| 18 | AsyncMessageSendAction |

**主要処理フロー（各フローの決定ポイント）**:

- **正常起動**: Main → ThreadContextHandler_main → ProcessResidentHandler（以降、常駐処理を開始する。監視間隔ごとに後続のハンドラキューの処理が繰り返し実行される。）
- **重複起動エラー**: ThreadContextHandler_mainが起動引数`-requestPath`からリクエストIDを決定。DuplicateProcessCheckHandlerに起動停止時の終了コードを設定。GlobalErrorHandlerで障害ログ出力。
- **常駐処理正常実行**: ProcessResidentHandlerが常駐処理の起点。MultiThreadExecutionHandlerは処理開始前・データリーダ作成時にBatchActionへコールバック（イベント: 1.処理開始前、2.データリーダ作成、3.業務コミット後、4.全件終了後）。LoopHandlerはコミット時にBatchActionへコールバックし、結果セットが空になるまでループ。正常終了後にMultiThreadExecutionHandlerがBatchActionへコールバック。
- **処理対象データ待機**: LoopHandlerは要求管理テーブルの処理対象データが0件の場合、後続処理を行わずDataReader.NoMoreRecordをリターン。
- **閉局中処理待機**: ServiceAvailabilityCheckHandlerがサービス閉局例外を送出。ProcessResidentHandlerはサービス閉局例外捕捉時にINFOログ出力しループ継続。
- **常駐処理異常終了**: BatchActionで業務処理をエラー終了させる場合は実行時例外を送出（トランザクションロールバック・障害ログ出力）。LoopHandlerは複数件コミット使用時、未コミット処理もロールバック。MultiThreadExecutionHandlerは異常終了後にBatchActionへコールバック。
- **プロセス正常停止**: ProcessStopHandlerのリクエストIDはバッチ起動引数`-requestPath`の値から決定。ProcessResidentHandlerはProcessStop捕捉時にINFOログ出力後、処理結果オブジェクト（ステータスコード:200）をリターン。StatusCodeConvertHandlerがステータスコード200→終了コード0に変換。
- **強制停止（ProcessAbnormalEnd）**: BatchActionでProcessAbnormalEnd例外を送出すると、実行中の処理だけでなくプロセス全体がエラー終了。ProcessResidentHandlerはProcessAbnormalEndをそのまま再送出（ループ中断）。GlobalErrorHandlerがProcessAbnormalEnd捕捉時に障害ログ出力。

<details>
<summary>keywords</summary>

ProcessResidentHandler, MultiThreadExecutionHandler, DuplicateProcessCheckHandler, ProcessStopHandler, ServiceAvailabilityCheckHandler, DbConnectionManagementHandler, TransactionManagementHandler, LoopHandler, DataReadHandler, AsyncMessageSendAction, MessagingContextHandler, StatusCodeConvertHandler, GlobalErrorHandler, ThreadContextHandler_main, RetryHandler, RequestPathJavaPackageMapping, BatchAction, 標準ハンドラ構成, 処理フロー, 常駐バッチ, ProcessAbnormalEnd

</details>
