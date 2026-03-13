# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/mom/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/FwHeaderReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/MessageReader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/ResponseMessage.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/StatusCodeConvertHandler.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessStopHandler.ProcessStop.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/MessagingAction.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/AsyncMessageReceiveAction.html)

## MOMメッセージングの構成

MOMメッセージングは外部から送信される要求電文に対し、電文中のリクエストIDに対応するアクションを実行する機能。メッセージキューはMQと称す。

MOMメッセージングは以下の2種類:

- **同期応答メッセージング**: 業務処理の実行結果をもとに応答電文を作成してMQに送信する。即時応答が必要な場合（オーソリ業務など）に使用する。
- **応答不要メッセージング**: 応答電文の送信は行わず、受信した要求電文の内容をDBテーブルに格納する。業務処理は後続バッチ（:ref:`db_messaging` 参照）で実行する。

> **補足**: 応答不要メッセージングは電文内容をテーブルに格納するだけの単純な処理のため、フレームワーク提供のアクションクラスをそのまま使用可能。コーディング不要。

> **重要**: MOMメッセージングで扱える形式は、[data_format](../../component/libraries/libraries-data_format.md) の固定長データのみ。

メッセージの送受信には [mom_system_messaging](../../component/libraries/libraries-mom_system_messaging.md) を使用する。

MOMメッセージングの構成は [nablarch_batch](../nablarch-batch/nablarch-batch-nablarch_batch.md) とまったく同じ。詳細は [nablarch_batch-structure](../nablarch-batch/nablarch-batch-architecture.md) を参照。

<details>
<summary>keywords</summary>

同期応答メッセージング, 応答不要メッセージング, MOMメッセージング構成, 固定長データ, mom_system_messaging, nablarch_batch, MOMメッセージング概要

</details>

## 要求電文によるアクションとリクエストIDの指定

MOMメッセージングでは要求電文中の特定フィールドをリクエストIDとして使用する。リクエストIDにはウェブアプリのリクエストパスと異なり階層構造が含まれないため、[request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) を使用してアクションクラスのパッケージやクラス名のサフィックスを設定で指定し、リクエストIDに対応するクラスにディスパッチする。

リクエストIDは要求電文中のフレームワーク制御ヘッダ部に含める必要がある。詳細は [フレームワーク制御ヘッダ](../../component/libraries/libraries-mom_system_messaging.md) を参照。

<details>
<summary>keywords</summary>

リクエストID, request_path_java_package_mapping, フレームワーク制御ヘッダ, ディスパッチ, 要求電文, アクションクラス指定

</details>

## MOMメッセージングの処理の流れ

MOMメッセージングが要求電文を受信し応答電文を返却するまでの処理の流れ（応答不要メッセージングは応答電文を返却しない点のみ異なる）:

1. :ref:`共通起動ランチャ(Main) <main>` がハンドラキューを実行する
2. `FwHeaderReader` / `MessageReader` がMQを監視し、受信電文を1件ずつ提供する
3. [nablarch_batch-structure](../nablarch-batch/nablarch-batch-architecture.md) がリクエストIDを元にアクションクラスを特定し、ハンドラキューの末尾に追加する
4. アクションクラスがフォームクラス・エンティティクラスを使用して業務ロジックを実行する
5. アクションクラスが `ResponseMessage` を返却する
6. プロセス停止要求があるまで2〜5を繰り返す
7. `StatusCodeConvertHandler` がステータスコードをプロセス終了コードに変換し、処理結果として返す

<details>
<summary>keywords</summary>

FwHeaderReader, MessageReader, ResponseMessage, StatusCodeConvertHandler, 処理の流れ, ハンドラキュー, nablarch.fw.messaging.reader.FwHeaderReader, nablarch.fw.messaging.reader.MessageReader, nablarch.fw.messaging.ResponseMessage, nablarch.fw.handler.StatusCodeConvertHandler

</details>

## MOMメッセージングで使用するハンドラ

プロジェクト要件に従ってハンドラキューを構築する。要件によってはプロジェクトカスタムハンドラの作成が必要。

**ハンドラ一覧**

リクエスト・レスポンス変換:
- [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md)
- [data_read_handler](../../component/handlers/handlers-data_read_handler.md)

プロセス実行制御:
- [duplicate_process_check_handler](../../component/handlers/handlers-duplicate_process_check_handler.md)
- [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md)
- [retry_handler](../../component/handlers/handlers-retry_handler.md)
- [request_thread_loop_handler](../../component/handlers/handlers-request_thread_loop_handler.md)
- [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md)
- [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md)

メッセージング関連:
- [messaging_context_handler](../../component/handlers/handlers-messaging_context_handler.md)
- [message_reply_handler](../../component/handlers/handlers-message_reply_handler.md)
- [message_resend_handler](../../component/handlers/handlers-message_resend_handler.md)

DB関連:
- [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)
- [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)

エラー処理:
- [global_error_handler](../../component/handlers/handlers-global_error_handler.md)

その他:
- [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md)
- [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md)
- :ref:`ServiceAvailabilityCheckHandler`

### 同期応答メッセージングの最小ハンドラ構成

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md) | メイン | — | ステータスコードをプロセス終了コードに変換 | — |
| 2 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | メイン | — | — | 実行時例外・エラーのログ出力 |
| 3 | [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md) | メイン | サブスレッド作成・後続ハンドラを並行実行 | 全スレッドの正常終了まで待機 | 処理中スレッド完了まで待機し起因例外を再送出 |
| 4 | [retry_handler](../../component/handlers/handlers-retry_handler.md) | サブ | — | — | リトライ可能な実行時例外を捕捉しリトライ上限未達なら後続ハンドラを再実行 |
| 5 | [messaging_context_handler](../../component/handlers/handlers-messaging_context_handler.md) | サブ | MQ接続を取得 | MQ接続を解放 | — |
| 6 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md) | サブ | DB接続を取得 | DB接続を解放 | — |
| 7 | [request_thread_loop_handler](../../component/handlers/handlers-request_thread_loop_handler.md) | サブ | 後続ハンドラを繰り返し実行 | ハンドラキュー復旧しループ継続 | プロセス停止要求か致命的エラー発生時のみループ停止 |
| 8 | [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md) | サブ | — | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) でスレッドローカルに設定した値を全削除 | — |
| 9 | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) | サブ | コマンドライン引数からリクエストID・ユーザID等のスレッドコンテキスト変数を初期化 | — | — |
| 10 | [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md) | サブ | 処理停止フラグがオンの場合、後続ハンドラを実行せずプロセス停止例外(`ProcessStop`)を送出 | — | — |
| 11 | [message_reply_handler](../../component/handlers/handlers-message_reply_handler.md) | サブ | — | 後続ハンドラから返される応答電文をMQに送信 | エラー内容をもとに電文を作成してMQに送信 |
| 12 | [data_read_handler](../../component/handlers/handlers-data_read_handler.md) | サブ | データリーダで要求電文を1件読み込み後続ハンドラに渡す。実行時IDを採番 | — | 読み込んだ電文をログ出力後、元例外を再送出 |
| 13 | [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) | サブ | リクエストIDをもとに呼び出すアクションを決定 | — | — |
| 14 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) | サブ | トランザクション開始 | トランザクションをコミット | トランザクションをロールバック |

### 応答不要メッセージングの最小ハンドラ構成

同期応答メッセージングの最小ハンドラ構成から [message_reply_handler](../../component/handlers/handlers-message_reply_handler.md) と [message_resend_handler](../../component/handlers/handlers-message_resend_handler.md) を除いた構成。

> **重要**: 応答不要メッセージングでは電文保存失敗時にエラー応答を送信できないため、電文を一旦キューに戻してリトライする。DBへの登録処理とキュー操作を1つのトランザクションとして扱う必要がある（2相コミット制御）。[transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) の設定を変更し2相コミット対応実装に差し替える必要がある。IBM MQ向けの2相コミット用アダプタは [webspheremq_adaptor](../../component/adapters/adapters-webspheremq_adaptor.md) を参照。

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md) | メイン | — | ステータスコードをプロセス終了コードに変換 | — |
| 2 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | メイン | — | — | 実行時例外・エラーのログ出力 |
| 3 | [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md) | メイン | サブスレッド作成・後続ハンドラを並行実行 | 全スレッドの正常終了まで待機 | 処理中スレッド完了まで待機し起因例外を再送出 |
| 4 | [retry_handler](../../component/handlers/handlers-retry_handler.md) | サブ | — | — | リトライ可能な実行時例外を捕捉しリトライ上限未達なら後続ハンドラを再実行 |
| 5 | [messaging_context_handler](../../component/handlers/handlers-messaging_context_handler.md) | サブ | MQ接続を取得 | MQ接続を解放 | — |
| 6 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md) | サブ | DB接続を取得 | DB接続を解放 | — |
| 7 | [request_thread_loop_handler](../../component/handlers/handlers-request_thread_loop_handler.md) | サブ | 後続ハンドラを繰り返し実行 | ハンドラキュー復旧しループ継続 | プロセス停止要求か致命的エラー発生時のみループ停止 |
| 8 | [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md) | サブ | — | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) でスレッドローカルに設定した値を全削除 | — |
| 9 | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) | サブ | コマンドライン引数からリクエストID・ユーザID等のスレッドコンテキスト変数を初期化 | — | — |
| 10 | [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md) | サブ | 処理停止フラグがオンの場合、後続ハンドラを実行せずプロセス停止例外(`ProcessStop`)を送出 | — | — |
| 11 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) | サブ | トランザクション開始 | トランザクションをコミット | トランザクションをロールバック |
| 12 | [data_read_handler](../../component/handlers/handlers-data_read_handler.md) | サブ | データリーダで要求電文を1件読み込み後続ハンドラに渡す。実行時IDを採番 | — | 読み込んだ電文をログ出力後、元例外を再送出 |
| 13 | [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) | サブ | リクエストIDをもとに呼び出すアクションを決定 | — | — |

<details>
<summary>keywords</summary>

status_code_convert_handler, global_error_handler, multi_thread_execution_handler, retry_handler, messaging_context_handler, database_connection_management_handler, request_thread_loop_handler, thread_context_handler, thread_context_clear_handler, process_stop_handler, message_reply_handler, message_resend_handler, data_read_handler, transaction_management_handler, duplicate_process_check_handler, ServiceAvailabilityCheckHandler, 同期応答メッセージング最小ハンドラ構成, 応答不要メッセージング最小ハンドラ構成, 2相コミット, webspheremq_adaptor, ProcessStop

</details>

## MOMメッセージングで使用するデータリーダ

MOMメッセージングで使用するデータリーダ:

- `FwHeaderReader (電文からフレームワーク制御ヘッダの読み込み)`
- `MessageReader (MQから電文の読み込み)`

> **補足**: 上記で要件を満たせない場合は、`DataReader` インタフェースを実装したクラスをプロジェクトで作成する。

<details>
<summary>keywords</summary>

FwHeaderReader, MessageReader, DataReader, データリーダ, フレームワーク制御ヘッダ, nablarch.fw.messaging.reader.FwHeaderReader, nablarch.fw.messaging.reader.MessageReader, nablarch.fw.DataReader

</details>

## MOMメッセージングで使用するアクション

MOMメッセージングで使用するアクションクラス:

- `MessagingAction (同期応答メッセージング用アクションのテンプレートクラス)`
- `AsyncMessageReceiveAction (応答不要メッセージングのアクションクラス)`

<details>
<summary>keywords</summary>

MessagingAction, AsyncMessageReceiveAction, アクションクラス, 同期応答メッセージング, 応答不要メッセージング, nablarch.fw.messaging.action.MessagingAction, nablarch.fw.messaging.action.AsyncMessageReceiveAction

</details>
