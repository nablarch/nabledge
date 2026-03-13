# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DispatchHandler.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/StatusCodeConvertHandler.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseRecordReader.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/FileDataReader.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ValidatableFileDataReader.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ResumeDataReader.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/BatchAction.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/FileBatchAction.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/NoInputDataBatchAction.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/AsyncMessageSendAction.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessStopHandler.ProcessStop.html)

## Nablarchバッチアプリケーションの構成

Nablarchバッチアプリケーションは以下の2種別に分かれる。

**都度起動バッチ**: 日次・月次など定期的にプロセスを起動してバッチ処理を実行する。

**常駐バッチ**: プロセスを起動し続け、一定間隔でバッチ処理を実行する。オンライン処理で作成された要求データを定期的に一括処理する場合などに使用する。

> **重要**: 常駐バッチはマルチスレッド実行時に、処理が遅いスレッドの終了を他のスレッドが待つことで、要求データの取り込み遅延が発生する可能性がある。新規開発プロジェクトでは常駐バッチではなく :ref:`db_messaging` を使用することを推奨する。既存プロジェクトで上記問題が発生する可能性がある場合（既に発生している場合）は :ref:`db_messaging` への変更を検討すること。

Nablarchバッチアプリケーションはjavaコマンドから直接起動するスタンドアロンアプリケーションとして実行する。

![アプリケーション構成](../../../knowledge/processing-pattern/nablarch-batch/assets/nablarch-batch-architecture/application_structure.png)

**:ref:`main` (Main)**: 起点となるメインクラス。javaコマンドから直接起動し、システムリポジトリやログの初期化処理を行い、ハンドラキューを実行する。

## 提供ハンドラ一覧

| カテゴリ | ハンドラ |
|---|---|
| リクエスト/レスポンス変換 | [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md), [data_read_handler](../../component/handlers/handlers-data_read_handler.md) |
| バッチ実行制御 | [duplicate_process_check_handler](../../component/handlers/handlers-duplicate_process_check_handler.md), [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md), [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md), [loop_handler](../../component/handlers/handlers-loop_handler.md), [dbless_loop_handler](../../component/handlers/handlers-dbless_loop_handler.md), [retry_handler](../../component/handlers/handlers-retry_handler.md), [process_resident_handler](../../component/handlers/handlers-process_resident_handler.md), [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md) |
| データベース関連 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md), [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) |
| エラー処理 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) |
| その他 | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md), [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md), :ref:`ServiceAvailabilityCheckHandler`, [file_record_writer_dispose_handler](../../component/handlers/handlers-file_record_writer_dispose_handler.md) |

## 都度起動バッチの最小ハンドラ構成

### DB接続有り

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md) | メイン | — | ステータスコードをプロセス終了コードに変換 | — |
| 2 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | メイン | — | — | 実行時例外/エラー時にログ出力 |
| 3 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)（初期処理/終了処理用） | メイン | DB接続を取得 | DB接続を解放 | — |
| 4 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)（初期処理/終了処理用） | メイン | トランザクション開始 | トランザクションコミット | トランザクションロールバック |
| 5 | [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) | メイン | コマンドライン引数をもとに呼び出すアクションを決定 | — | — |
| 6 | [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md) | メイン | サブスレッドを作成し後続ハンドラを並行実行 | 全スレッドの正常終了まで待機 | 処理中スレッドが完了するまで待機し起因例外を再送出 |
| 7 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)（業務処理用） | サブ | DB接続を取得 | DB接続を解放 | — |
| 8 | [loop_handler](../../component/handlers/handlers-loop_handler.md) | サブ | 業務トランザクション開始 | コミット間隔毎に業務トランザクションをコミット。データリーダに処理対象データが残っていればループ継続 | 業務トランザクションをロールバック |
| 9 | [data_read_handler](../../component/handlers/handlers-data_read_handler.md) | サブ | データリーダでレコードを1件読み込み後続ハンドラに渡す。[実行時ID](../../component/libraries/libraries-log.md)を採番 | — | 読み込んだレコードをログ出力後、元例外を再送出 |

### DB接続無し

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md) | メイン | — | ステータスコードをプロセス終了コードに変換 | — |
| 2 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | メイン | — | — | 実行時例外/エラー時にログ出力 |
| 3 | [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) | メイン | コマンドライン引数をもとに呼び出すアクションを決定 | — | — |
| 4 | [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md) | メイン | サブスレッドを作成し後続ハンドラを並行実行 | 全スレッドの正常終了まで待機 | 処理中スレッドが完了するまで待機し起因例外を再送出 |
| 5 | [dbless_loop_handler](../../component/handlers/handlers-dbless_loop_handler.md) | サブ | — | データリーダに処理対象データが残っていればループ継続 | — |
| 6 | [data_read_handler](../../component/handlers/handlers-data_read_handler.md) | サブ | データリーダでレコードを1件読み込み後続ハンドラに渡す。[実行時ID](../../component/libraries/libraries-log.md)を採番 | — | 読み込んだレコードをログ出力後、元例外を再送出 |

## 常駐バッチの最小ハンドラ構成

都度起動バッチに加えて、以下のハンドラがメインスレッド側に追加される:
- [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md)（[process_stop_handler](../../component/handlers/handlers-process_stop_handler.md)のために必要）
- [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md)
- [retry_handler](../../component/handlers/handlers-retry_handler.md)
- [process_resident_handler](../../component/handlers/handlers-process_resident_handler.md)
- [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md)

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md) | メイン | — | ステータスコードをプロセス終了コードに変換 | — |
| 2 | [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md) | メイン | — | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md)でスレッドローカルに設定した値を全て削除 | — |
| 3 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | メイン | — | — | 実行時例外/エラー時にログ出力 |
| 4 | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) | メイン | コマンドライン引数からリクエストID・ユーザID等のスレッドコンテキスト変数を初期化 | — | — |
| 5 | [retry_handler](../../component/handlers/handlers-retry_handler.md) | メイン | — | — | リトライ可能な実行時例外を捕捉し、リトライ上限未達の場合は後続ハンドラを再実行 |
| 6 | [process_resident_handler](../../component/handlers/handlers-process_resident_handler.md) | メイン | データ監視間隔ごとに後続ハンドラを繰り返し実行 | ループを継続 | ログ出力後、実行時例外はリトライ可能例外にラップして送出。エラーはそのまま再送出 |
| 7 | [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md) | メイン | リクエストテーブルの処理停止フラグがオンの場合、後続ハンドラを実行せず`ProcessStop`を送出 | — | — |
| 8 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)（初期処理/終了処理用） | メイン | DB接続を取得 | DB接続を解放 | — |
| 9 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)（初期処理/終了処理用） | メイン | トランザクション開始 | トランザクションコミット | トランザクションロールバック |
| 10 | [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) | メイン | コマンドライン引数をもとに呼び出すアクションを決定 | — | — |
| 11 | [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md) | メイン | サブスレッドを作成し後続ハンドラを並行実行 | 全スレッドの正常終了まで待機 | 処理中スレッドが完了するまで待機し起因例外を再送出 |
| 12 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)（業務処理用） | サブ | DB接続を取得 | DB接続を解放 | — |
| 13 | [loop_handler](../../component/handlers/handlers-loop_handler.md) | サブ | 業務トランザクション開始 | コミット間隔毎に業務トランザクションをコミット。データリーダに処理対象データが残っていればループ継続 | 業務トランザクションをロールバック |
| 14 | [data_read_handler](../../component/handlers/handlers-data_read_handler.md) | サブ | データリーダでレコードを1件読み込み後続ハンドラに渡す。[実行時ID](../../component/libraries/libraries-log.md)を採番 | — | 読み込んだレコードをログ出力後、元例外を再送出 |

<details>
<summary>keywords</summary>

都度起動バッチ, 常駐バッチ, db_messaging推奨, スタンドアロン, Main, アーキテクチャ構成, 取り込み遅延, マルチスレッド, ハンドラキュー, 最小ハンドラ構成, StatusCodeConvertHandler, GlobalErrorHandler, DatabaseConnectionManagementHandler, TransactionManagementHandler, RequestPathJavaPackageMapping, MultiThreadExecutionHandler, LoopHandler, DblessLoopHandler, RetryHandler, ProcessResidentHandler, ProcessStopHandler, DataReadHandler, ThreadContextHandler, ThreadContextClearHandler, DuplicateProcessCheckHandler, FileRecordWriterDisposeHandler

</details>

## リクエストパスによるアクションとリクエストIDの指定

コマンドライン引数 `-requestPath` で実行するアクションクラスとリクエストIDを指定する。

```properties
# 書式
-requestPath=アクションのクラス名/リクエストID

# 指定例
-requestPath=com.sample.SampleBatchAction/BATCH0001
```

リクエストIDは各バッチプロセスの識別子として用いられる。同一の業務アクションクラスを実行するプロセスを複数起動する場合などは、リクエストIDが識別子となる。

標準で提供されるデータリーダ:

- `DatabaseRecordReader (データベース読み込み)`
- `FileDataReader (ファイル読み込み)`
- `ValidatableFileDataReader (バリデージョン機能付きファイル読み込み)`
- `ResumeDataReader (レジューム機能付き読み込み)`

> **補足**: 要件を満たせない場合は、`DataReader`インタフェースを実装したカスタムクラスを作成すること。

> **重要**: `FileDataReader`および`ValidatableFileDataReader`はデータアクセスに[data_format](../../component/libraries/libraries-data_format.md)を使用する。[data_bind](../../component/libraries/libraries-data_bind.md)を使用する場合はこれらのデータリーダを使用しないこと。

<details>
<summary>keywords</summary>

-requestPath, リクエストパス, アクションクラス, リクエストID, コマンドライン引数, データリーダ, DatabaseRecordReader, FileDataReader, ValidatableFileDataReader, ResumeDataReader, DataReader, data_format, data_bind

</details>

## Nablarchバッチアプリケーションの処理の流れ

1. :ref:`共通起動ランチャ(Main) <main>` がハンドラキューを実行する。
2. `データリーダ(DataReader)` が入力データを読み込み、データレコードを1件ずつ提供する。
3. `ディスパッチハンドラ(DispatchHandler)` がコマンドライン引数（-requestPath）で指定するリクエストパスを元にアクションクラスを特定し、ハンドラキューの末尾に追加する。
4. アクションクラスはフォームクラスやエンティティクラスを使用して、データレコード1件ごとの業務ロジックを実行する。
5. アクションクラスは処理結果を示す `Result` を返却する。
6. 処理対象データがなくなるまで2〜5を繰り返す。
7. `ステータスコード→プロセス終了コード変換ハンドラ(StatusCodeConvertHandler)` が処理結果のステータスコードをプロセス終了コードに変換し、バッチアプリケーションの処理結果として返す。

標準で提供されるアクションクラス:

- `BatchAction (汎用的なバッチアクションのテンプレートクラス)`
- `FileBatchAction (ファイル入力のバッチアクションのテンプレートクラス)`
- `NoInputDataBatchAction (入力データを使用しないバッチアクションのテンプレートクラス)`
- `AsyncMessageSendAction (応答不要メッセージ送信用のアクションクラス)`

> **重要**: `FileBatchAction`はデータアクセスに[data_format](../../component/libraries/libraries-data_format.md)を使用する。[data_bind](../../component/libraries/libraries-data_bind.md)を使用する場合は他のアクションクラスを使用すること。

<details>
<summary>keywords</summary>

DataReader, DispatchHandler, StatusCodeConvertHandler, Result, 処理フロー, ハンドラキュー, nablarch.fw.DataReader, nablarch.fw.handler.DispatchHandler, nablarch.fw.Result, nablarch.fw.handler.StatusCodeConvertHandler, バッチアクション, BatchAction, FileBatchAction, NoInputDataBatchAction, AsyncMessageSendAction, data_format, data_bind

</details>
