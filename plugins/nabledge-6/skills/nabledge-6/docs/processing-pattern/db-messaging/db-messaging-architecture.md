# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseRecordReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseTableQueueReader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessStopHandler.ProcessStop.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/BatchAction.html)

## 構成

データベースをキューとして扱うタイプのメッセージング処理では、定期的にデータベース上のテーブルを監視し未処理のレコードを順次処理するための機能を提供している。

> **重要**: 未処理のレコードの判定はテーブルのレコード上で表す必要がある。処理が終わったレコードの状態を処理済みへ変更する処理が必要。

Nablarchバッチアプリケーションと同じ構成となる。詳細は :ref:`Nablarchバッチアプリケーションの構成 <nablarch_batch-structure>` を参照。

<details>
<summary>keywords</summary>

Nablarchバッチアプリケーション構成, DBキューメッセージング構成, nablarch_batch-structure, 未処理レコード処理済み変更, DBキューメッセージング概要, 定期的なテーブル監視, 未処理レコード順次処理

</details>

## リクエストパスによるアクションとリクエストIDの指定

コマンドライン引数で実行するアクションとリクエストIDを指定する（Nablarchバッチアプリケーションと同様）。詳細は :ref:`NablarchバッチアプリケーションのアクションとリクエストIDの指定 <nablarch_batch-resolve_action>` を参照。

<details>
<summary>keywords</summary>

コマンドライン引数, アクション指定, リクエストID指定, nablarch_batch-resolve_action

</details>

## 処理の流れ

Nablarchバッチアプリケーションと同じ処理の流れ。詳細は :ref:`nablarch_batch-process_flow` を参照。

<details>
<summary>keywords</summary>

処理の流れ, Nablarchバッチ処理フロー, nablarch_batch-process_flow

</details>

## 使用するハンドラ

プロジェクト要件に従いハンドラキューを構築すること（プロジェクトカスタムハンドラの作成が必要な場合もある）。

**リクエスト/レスポンス変換ハンドラ**:
- :ref:`status_code_convert_handler`
- :ref:`data_read_handler`

**実行制御ハンドラ**:
- :ref:`duplicate_process_check_handler`
- :ref:`request_path_java_package_mapping`
- :ref:`multi_thread_execution_handler`
- :ref:`retry_handler`
- :ref:`process_stop_handler`
- :ref:`request_thread_loop_handler`

**データベース関連ハンドラ**:
- :ref:`database_connection_management_handler`
- :ref:`transaction_management_handler`

**エラー処理ハンドラ**:
- :ref:`global_error_handler`

**その他**:
- :ref:`thread_context_handler`
- :ref:`thread_context_clear_handler`
- :ref:`ServiceAvailabilityCheckHandler`
- :ref:`file_record_writer_dispose_handler`

<details>
<summary>keywords</summary>

ハンドラキュー, status_code_convert_handler, data_read_handler, duplicate_process_check_handler, request_path_java_package_mapping, multi_thread_execution_handler, retry_handler, process_stop_handler, request_thread_loop_handler, database_connection_management_handler, transaction_management_handler, global_error_handler, thread_context_handler, thread_context_clear_handler, ServiceAvailabilityCheckHandler, file_record_writer_dispose_handler

</details>

## ハンドラの最小構成

最小ハンドラ構成（これをベースにプロジェクト要件に従い標準ハンドラやカスタムハンドラを追加すること）:

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | :ref:`status_code_convert_handler` | メイン | — | ステータスコードをプロセス終了コードに変換 | — |
| 2 | :ref:`thread_context_clear_handler` | メイン | — | :ref:`thread_context_handler` でスレッドローカル上の値を全削除 | — |
| 3 | :ref:`global_error_handler` | メイン | — | — | 実行時例外またはエラーの場合ログ出力 |
| 4 | :ref:`thread_context_handler` | メイン | コマンドライン引数からリクエストID・ユーザID等のスレッドコンテキスト変数を初期化 | — | — |
| 5 | :ref:`retry_handler` | メイン | — | — | リトライ可能な実行時例外を捕捉しリトライ上限未達なら後続ハンドラを再実行 |
| 6 | :ref:`database_connection_management_handler`（初期処理/終了処理用） | メイン | DB接続取得 | DB接続解放 | — |
| 7 | :ref:`transaction_management_handler`（初期処理/終了処理用） | メイン | トランザクション開始 | コミット | ロールバック |
| 8 | :ref:`request_path_java_package_mapping` | メイン | コマンドライン引数をもとに呼び出すアクションを決定 | — | — |
| 9 | :ref:`multi_thread_execution_handler` | メイン | サブスレッドを作成し後続ハンドラを並行実行 | 全スレッドの正常終了まで待機 | 処理中スレッド完了まで待機し起因例外を再送出 |
| 10 | :ref:`database_connection_management_handler`（業務処理用） | サブ | DB接続取得 | DB接続解放 | — |
| 11 | :ref:`request_thread_loop_handler` | サブ | — | 後続ハンドラに処理を再委譲 | 例外/エラーに応じたログ出力と再送出 |
| 12 | :ref:`process_stop_handler` | サブ | リクエストテーブルの処理停止フラグがオンの場合、`ProcessStop` を送出 | — | — |
| 13 | :ref:`data_read_handler` | サブ | データリーダで1件読み込み後続ハンドラに渡す。実行時IDを採番 | — | 読み込んだレコードをログ出力後に元例外を再送出 |
| 14 | :ref:`transaction_management_handler`（業務処理用） | サブ | トランザクション開始 | コミット | ロールバック |

<details>
<summary>keywords</summary>

最小ハンドラ構成, ProcessStop, MultiThreadExecutionHandler, DataReadHandler, スレッドコンテキスト, サブスレッド, RetryHandler, ProcessStopHandler

</details>

## 使用するデータリーダ

> **注意**: `DatabaseRecordReader` を使用した場合、繰り返しテーブルを監視できないので注意すること。

使用するデータリーダ: `DatabaseTableQueueReader`

> **重要**: プロジェクトでカスタムリーダを作成する場合の実装要件:
> - 対象データがなくなっても継続して監視できること
> - マルチスレッド環境で同一データを複数スレッドで処理しないこと
>
> `DatabaseTableQueueReader` の実装:
> - 未処理データがなくなった場合、再度検索SQLを実行して未処理データを抽出する
> - 処理中データの識別子（主キー値）を保持し、複数スレッドによる重複処理を防ぐ

<details>
<summary>keywords</summary>

DatabaseTableQueueReader, DatabaseRecordReader, データリーダ, キュー監視, マルチスレッド重複処理防止, db_messaging_architecture-reader

</details>

## 使用するアクションのテンプレートクラス

**クラス**: `BatchAction`（汎用的なバッチアクション）

<details>
<summary>keywords</summary>

BatchAction, テンプレートクラス, nablarch.fw.action.BatchAction

</details>
