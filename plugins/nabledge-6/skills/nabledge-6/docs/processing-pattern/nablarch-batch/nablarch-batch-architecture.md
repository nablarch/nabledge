# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/DataReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DispatchHandler.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/StatusCodeConvertHandler.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseRecordReader.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/FileDataReader.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ValidatableFileDataReader.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ResumeDataReader.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/BatchAction.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/FileBatchAction.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/NoInputDataBatchAction.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/AsyncMessageSendAction.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessStopHandler.ProcessStop.html)

## Nablarchバッチアプリケーションの構成

Nablarchバッチアプリケーションは、DBやファイルのデータレコード1件ごとに処理を繰り返すバッチ処理構築機能を提供する。以下の2種類がある。

**都度起動バッチ**: 日次や月次など定期的にプロセスを起動してバッチ処理を実行する。

**常駐バッチ**: プロセスを起動しておき一定間隔でバッチ処理を実行する。オンライン処理で作成された要求データを定期的に一括処理するような場合に使用する。

> **重要**: 常駐バッチはマルチスレッドで実行した場合、処理が遅いスレッドの終了を他のスレッドが待つことにより、要求データの取り込み遅延が発生する可能性がある。新規開発プロジェクトでは常駐バッチではなく :ref:`db_messaging` を使用することを推奨する。既存プロジェクトでは常駐バッチをこのまま稼働させることはできるが、上記問題が発生する可能性がある場合（既に発生している場合）には、:ref:`db_messaging` への変更を検討すること。

Nablarchバッチアプリケーションは、javaコマンドから直接起動するスタンドアロンアプリケーションとして実行する。

構成要素:
- **:ref:`main` (Main)**: アプリケーションの起点となるメインクラス。javaコマンドから直接起動し、システムリポジトリやログの初期化処理を行い、ハンドラキューを実行する。

**リクエスト/レスポンス変換**
- [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md)
- [data_read_handler](../../component/handlers/handlers-data_read_handler.md)

**バッチ実行制御**
- [duplicate_process_check_handler](../../component/handlers/handlers-duplicate_process_check_handler.md)
- [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md)
- [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md)
- [loop_handler](../../component/handlers/handlers-loop_handler.md)
- [dbless_loop_handler](../../component/handlers/handlers-dbless_loop_handler.md)
- [retry_handler](../../component/handlers/handlers-retry_handler.md)
- [process_resident_handler](../../component/handlers/handlers-process_resident_handler.md)
- [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md)

**DB関連**
- [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)
- [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)

**エラー処理**
- [global_error_handler](../../component/handlers/handlers-global_error_handler.md)

**その他**
- [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md)
- [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md)
- :ref:`ServiceAvailabilityCheckHandler`
- [file_record_writer_dispose_handler](../../component/handlers/handlers-file_record_writer_dispose_handler.md)

## 都度起動バッチの最小ハンドラ構成（DB接続有り）

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md) | メイン | — | ステータスコードをプロセス終了コードに変換する。 | — |
| 2 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | メイン | — | — | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 3 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)（初期処理/終了処理用） | メイン | DB接続を取得する。 | DB接続を解放する。 | — |
| 4 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)（初期処理/終了処理用） | メイン | トランザクションを開始する。 | トランザクションをコミットする。 | トランザクションをロールバックする。 |
| 5 | [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) | メイン | コマンドライン引数をもとに呼び出すアクションを決定する。 | — | — |
| 6 | [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md) | メイン | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 |
| 7 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)（業務処理用） | サブ | DB接続を取得する。 | DB接続を解放する。 | — |
| 8 | [loop_handler](../../component/handlers/handlers-loop_handler.md) | サブ | 業務トランザクションを開始する。 | コミット間隔毎に業務トランザクションをコミットする。データリーダ上に処理対象データが残っていればループを継続する。 | 業務トランザクションをロールバックする。 |
| 9 | [data_read_handler](../../component/handlers/handlers-data_read_handler.md) | サブ | データリーダを使用してレコードを1件読み込み、後続ハンドラの引数として渡す。[実行時ID](../../component/libraries/libraries-log.md) を採番する。 | — | 読み込んだレコードをログ出力した後、元例外を再送出する。 |

## 都度起動バッチの最小ハンドラ構成（DB接続無し）

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md) | メイン | — | ステータスコードをプロセス終了コードに変換する。 | — |
| 2 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | メイン | — | — | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 3 | [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) | メイン | コマンドライン引数をもとに呼び出すアクションを決定する。 | — | — |
| 4 | [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md) | メイン | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 |
| 5 | [dbless_loop_handler](../../component/handlers/handlers-dbless_loop_handler.md) | サブ | — | データリーダ上に処理対象データが残っていればループを継続する。 | — |
| 6 | [data_read_handler](../../component/handlers/handlers-data_read_handler.md) | サブ | データリーダを使用してレコードを1件読み込み、後続ハンドラの引数として渡す。[実行時ID](../../component/libraries/libraries-log.md) を採番する。 | — | 読み込んだレコードをログ出力した後、元例外を再送出する。 |

## 常駐バッチの最小ハンドラ構成

都度起動バッチに以下のハンドラをメインスレッド側に追加した構成:
- [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md)（[process_stop_handler](../../component/handlers/handlers-process_stop_handler.md) のために必要）
- [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md)
- [retry_handler](../../component/handlers/handlers-retry_handler.md)
- [process_resident_handler](../../component/handlers/handlers-process_resident_handler.md)
- [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md)

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | [status_code_convert_handler](../../component/handlers/handlers-status_code_convert_handler.md) | メイン | — | ステータスコードをプロセス終了コードに変換する。 | — |
| 2 | [thread_context_clear_handler](../../component/handlers/handlers-thread_context_clear_handler.md) | メイン | — | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) でスレッドローカル上に設定した値を全て削除する。 | — |
| 3 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | メイン | — | — | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 4 | [thread_context_handler](../../component/handlers/handlers-thread_context_handler.md) | メイン | コマンドライン引数からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。 | — | — |
| 5 | [retry_handler](../../component/handlers/handlers-retry_handler.md) | メイン | — | — | リトライ可能な実行時例外を捕捉し、かつリトライ上限に達していなければ後続のハンドラを再実行する。 |
| 6 | [process_resident_handler](../../component/handlers/handlers-process_resident_handler.md) | メイン | データ監視間隔ごとに後続のハンドラを繰り返し実行する。 | ループを継続する。 | ログ出力を行い、実行時例外が送出された場合はリトライ可能例外にラップして送出する。エラーが送出された場合はそのまま再送出する。 |
| 7 | [process_stop_handler](../../component/handlers/handlers-process_stop_handler.md) | メイン | リクエストテーブル上の処理停止フラグがオンであった場合は、後続ハンドラの処理は行なわずにプロセス停止例外（`ProcessStop`）を送出する。 | — | — |
| 8 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)（初期処理/終了処理用） | メイン | DB接続を取得する。 | DB接続を解放する。 | — |
| 9 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)（初期処理/終了処理用） | メイン | トランザクションを開始する。 | トランザクションをコミットする。 | トランザクションをロールバックする。 |
| 10 | [request_path_java_package_mapping](../../component/handlers/handlers-request_path_java_package_mapping.md) | メイン | コマンドライン引数をもとに呼び出すアクションを決定する。 | — | — |
| 11 | [multi_thread_execution_handler](../../component/handlers/handlers-multi_thread_execution_handler.md) | メイン | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 |
| 12 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)（業務処理用） | サブ | DB接続を取得する。 | DB接続を解放する。 | — |
| 13 | [loop_handler](../../component/handlers/handlers-loop_handler.md) | サブ | 業務トランザクションを開始する。 | コミット間隔毎に業務トランザクションをコミットする。データリーダ上に処理対象データが残っていればループを継続する。 | 業務トランザクションをロールバックする。 |
| 14 | [data_read_handler](../../component/handlers/handlers-data_read_handler.md) | サブ | データリーダを使用してレコードを1件読み込み、後続ハンドラの引数として渡す。[実行時ID](../../component/libraries/libraries-log.md) を採番する。 | — | 読み込んだレコードをログ出力した後、元例外を再送出する。 |

<details>
<summary>keywords</summary>

都度起動バッチ, 常駐バッチ, スタンドアロンアプリケーション, db_messaging, Mainクラス, ハンドラキュー, バッチ種別選択, status_code_convert_handler, data_read_handler, duplicate_process_check_handler, request_path_java_package_mapping, multi_thread_execution_handler, loop_handler, dbless_loop_handler, retry_handler, process_resident_handler, process_stop_handler, database_connection_management_handler, transaction_management_handler, global_error_handler, thread_context_handler, thread_context_clear_handler, ServiceAvailabilityCheckHandler, file_record_writer_dispose_handler, ProcessStop, ハンドラキュー構成, 最小ハンドラ構成, マルチスレッド実行

</details>

## リクエストパスによるアクションとリクエストIDの指定

コマンドライン引数 `-requestPath` で実行するアクションクラスとリクエストIDを指定する。

```properties
# 書式
-requestPath=アクションのクラス名/リクエストID

# 指定例
-requestPath=com.sample.SampleBatchAction/BATCH0001
```

リクエストIDは各バッチプロセスの識別子。同一の業務アクションクラスを複数プロセスで起動する場合の識別子となる。

- `DatabaseRecordReader (データベース読み込み)`
- `FileDataReader (ファイル読み込み)`
- `ValidatableFileDataReader (バリデーション機能付きファイル読み込み)`
- `ResumeDataReader (レジューム機能付き読み込み)`

> **補足**: 標準データリーダで要件を満たせない場合は、`DataReader` インタフェースを実装したクラスをプロジェクトで作成する。

> **重要**: `FileDataReader` と `ValidatableFileDataReader` はデータアクセスに [data_format](../../component/libraries/libraries-data_format.md) を使用している。[data_bind](../../component/libraries/libraries-data_bind.md) を使用する場合は、これらのデータリーダを使用しないこと。

<details>
<summary>keywords</summary>

requestPath, リクエストID, コマンドライン引数, アクションクラス指定, バッチプロセス識別子, DatabaseRecordReader, FileDataReader, ValidatableFileDataReader, ResumeDataReader, DataReader, データリーダ, データベース読み込み, ファイル読み込み, レジューム機能, バリデーション付きファイル読み込み

</details>

## Nablarchバッチアプリケーションの処理の流れ

1. :ref:`main` (Main) がハンドラキューを実行する。
2. `データリーダ(DataReader)` が入力データを読み込み、データレコードを1件ずつ提供する。
3. `ディスパッチハンドラ(DispatchHandler)` が、コマンドライン引数 `-requestPath` で指定するリクエストパスを元に処理すべきアクションクラスを特定し、ハンドラキューの末尾に追加する。
4. アクションクラスは、フォームクラスやエンティティクラスを使用して、データレコード1件ごとの業務ロジックを実行する。
5. アクションクラスは、処理結果を示す `Result` を返却する。
6. 処理対象データがなくなるまで2〜5を繰り返す。
7. `ステータスコード→プロセス終了コード変換ハンドラ(StatusCodeConvertHandler)` が、処理結果のステータスコードをプロセス終了コードに変換し、バッチアプリケーションの処理結果としてプロセス終了コードが返される。

- `BatchAction (汎用的なバッチアクションのテンプレートクラス)`
- `FileBatchAction (ファイル入力のバッチアクションのテンプレートクラス)`
- `NoInputDataBatchAction (入力データを使用しないバッチアクションのテンプレートクラス)`
- `AsyncMessageSendAction (応答不要メッセージ送信用のアクションクラス)`

> **重要**: `FileBatchAction` はデータアクセスに [data_format](../../component/libraries/libraries-data_format.md) を使用している。[data_bind](../../component/libraries/libraries-data_bind.md) を使用する場合は、他のアクションクラスを使用すること。

<details>
<summary>keywords</summary>

DataReader, DispatchHandler, StatusCodeConvertHandler, Result, 処理フロー, ハンドラキュー, プロセス終了コード, ステータスコード変換, BatchAction, FileBatchAction, NoInputDataBatchAction, AsyncMessageSendAction, バッチアクション, ファイル入力バッチ, 入力データなしバッチ, 応答不要メッセージ送信

</details>
