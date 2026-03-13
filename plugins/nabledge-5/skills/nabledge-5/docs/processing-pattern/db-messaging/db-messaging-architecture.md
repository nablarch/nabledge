# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseRecordReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseTableQueueReader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessStopHandler.ProcessStop.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/BatchAction.html)

## 構成

データベースをキューとして扱うタイプのメッセージング処理では、定期的にデータベース上のテーブルを監視し未処理のレコードを順次処理するための機能を提供している。

> **重要**: 未処理のレコードの判定はテーブルのレコード上で表す必要があり、処理が終わったレコードの状態を処理済みへ変更する処理が必要となる。

Nablarchバッチアプリケーションと同じ構成となる。詳細は [Nablarchバッチアプリケーションの構成](../nablarch-batch/nablarch-batch-architecture.md) を参照。

<details>
<summary>keywords</summary>

DBキューメッセージング構成, Nablarchバッチアプリケーション構成, 未処理レコード判定, 処理済みレコード更新, 定期的テーブル監視, 未処理レコード順次処理

</details>

## リクエストパスによるアクションとリクエストIDの指定

Nablarchバッチアプリケーションと同じようにコマンドライン引数で実行するアクションとリクエストIDを指定する。詳細は [NablarchバッチアプリケーションのアクションとリクエストIDの指定](../nablarch-batch/nablarch-batch-architecture.md) を参照。

<details>
<summary>keywords</summary>

コマンドライン引数, アクション指定, リクエストID指定, リクエストパス

</details>

## 処理の流れ

Nablarchバッチアプリケーションと同じ処理の流れとなる。詳細は [nablarch_batch-process_flow](../nablarch-batch/nablarch-batch-architecture.md) を参照。

<details>
<summary>keywords</summary>

処理フロー, DBキューメッセージング処理フロー, バッチ処理の流れ

</details>

## 使用するハンドラ

プロジェクトの要件に従ってハンドラキューを構築すること（要件によってはカスタムハンドラの作成が必要）。

**リクエスト/レスポンス変換ハンドラ**:
- [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md)
- [data_read_handler](../../component/handlers/handlers-data_read_handler.md)

**実行制御ハンドラ**:
- [duplicate_process_check_handler](../../component/handlers/handlers-duplicate_process_check_handler.md)
- [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md)
- [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md)
- [retry_handler](../../component/handlers/handlers-retry_handler.md)
- [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md)
- [request_thread_loop_handler](../../component/handlers/handlers-request_thread_loop_handler.md)

**データベース関連ハンドラ**:
- [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)
- [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)

**エラー処理ハンドラ**:
- [global_error_handler](../../component/handlers/handlers-global_error_handler.md)

**その他**:
- [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md)
- [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md)
- :ref:`ServiceAvailabilityCheckHandler`
- [file_record_writer_dispose_handler](../../component/handlers/handlers-file_record_writer_dispose_handler.md)

<details>
<summary>keywords</summary>

ハンドラキュー, status_code_convert_handler, data_read_handler, multi_thread_execution_handler, transaction_management_handler, database_connection_management_handler, global_error_handler, duplicate_process_check_handler, retry_handler, process_stop_handler, request_thread_loop_handler, thread_context_handler, thread_context_clear_handler, ServiceAvailabilityCheckHandler, file_record_writer_dispose_handler

</details>

## ハンドラの最小構成

データベースをキューとして扱うメッセージング処理の必要最小限のハンドラキューを以下に示す。これをベースに、プロジェクト要件に従ってNablarchの標準ハンドラやプロジェクトで作成したカスタムハンドラを追加する。

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md) | メイン | — | ステータスコードをプロセス終了コードに変換 | — |
| 2 | [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md) | メイン | — | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) でスレッドローカルに設定した値を全て削除 | — |
| 3 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | メイン | — | — | 実行時例外/エラーのログ出力 |
| 4 | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) | メイン | コマンドライン引数からリクエストID・ユーザID等のスレッドコンテキスト変数を初期化 | — | — |
| 5 | [retry_handler](../../component/handlers/handlers-retry_handler.md) | メイン | — | — | リトライ可能な実行時例外を捕捉し、リトライ上限未達なら後続ハンドラを再実行 |
| 6 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md) (初期処理/終了処理用) | メイン | DB接続を取得 | DB接続を解放 | — |
| 7 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) (初期処理/終了処理用) | メイン | トランザクション開始 | トランザクションコミット | トランザクションロールバック |
| 8 | [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) | メイン | コマンドライン引数をもとに呼び出すアクションを決定 | — | — |
| 9 | [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md) | メイン | サブスレッドを作成し後続ハンドラを並行実行 | 全スレッドの正常終了まで待機 | 処理中スレッドの完了待機後に起因例外を再送出 |
| 10 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md) (業務処理用) | サブ | DB接続を取得 | DB接続を解放 | — |
| 11 | [request_thread_loop_handler](../../component/handlers/handlers-request_thread_loop_handler.md) | サブ | — | 再度後続ハンドラに処理委譲 | 例外/エラーに応じたログ出力と再送出 |
| 12 | [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md) | サブ | リクエストテーブルの処理停止フラグがオンの場合、`ProcessStop` を送出し後続ハンドラは実行しない | — | — |
| 13 | [data_read_handler](../../component/handlers/handlers-data_read_handler.md) | サブ | データリーダでレコードを1件読み込み後続ハンドラの引数として渡す。[実行時ID](../../component/libraries/libraries-log.md) を採番 | — | 読み込んだレコードをログ出力後に元例外を再送出 |
| 14 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) (業務処理用) | サブ | トランザクション開始 | トランザクションコミット | トランザクションロールバック |

<details>
<summary>keywords</summary>

最小ハンドラ構成, process_stop_handler, request_thread_loop_handler, ProcessStop, サブスレッド, メインスレッド, retry_handler, status_code_convert_handler, thread_context_clear_handler, global_error_handler, thread_context_handler, database_connection_management_handler, transaction_management_handler, request_path_java_package_mapping, multi_thread_execution_handler, data_read_handler

</details>

## 使用するデータリーダ

> **注意**: `DatabaseRecordReader` (バッチ用) を使用した場合、繰り返しテーブルを監視できないので注意すること。

データベースをキューとして扱う場合には、以下のデータリーダを使用する。

- `DatabaseTableQueueReader`

プロジェクトでカスタムリーダを作成する場合の要件:
- 対象データがなくなった場合でも継続して対象データを監視できること
- マルチスレッド環境下で同一データを複数スレッドで処理しないこと

`DatabaseTableQueueReader` の実装（上記要件を満たすための内部処理）:
- 未処理データがなくなった場合、再度検索SQLを実行して未処理データを抽出
- 現在処理中データの識別子（主キー値）を保持し、複数スレッドによる同一データの重複処理を防止

<details>
<summary>keywords</summary>

DatabaseTableQueueReader, DatabaseRecordReader, テーブル監視, マルチスレッド重複処理防止, カスタムリーダ要件

</details>

## 使用するアクションのテンプレートクラス

使用するテンプレートクラス: `BatchAction` (汎用的なバッチアクション)

<details>
<summary>keywords</summary>

BatchAction, アクションテンプレートクラス, nablarch.fw.action.BatchAction

</details>
