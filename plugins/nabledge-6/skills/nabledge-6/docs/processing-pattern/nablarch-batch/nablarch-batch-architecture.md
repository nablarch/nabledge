# アーキテクチャ概要

## Nablarchバッチアプリケーションの構成

Nablarchバッチアプリケーションは、DBやファイルのデータレコード1件ごとに処理を繰り返すバッチ処理構築機能を提供する。以下の2種類がある。

**都度起動バッチ**: 日次や月次など定期的にプロセスを起動してバッチ処理を実行する。

**常駐バッチ**: プロセスを起動しておき一定間隔でバッチ処理を実行する。オンライン処理で作成された要求データを定期的に一括処理するような場合に使用する。

> **重要**: 常駐バッチはマルチスレッドで実行した場合、処理が遅いスレッドの終了を他のスレッドが待つことにより、要求データの取り込み遅延が発生する可能性がある。新規開発プロジェクトでは常駐バッチではなく :ref:`db_messaging` を使用することを推奨する。既存プロジェクトでは常駐バッチをこのまま稼働させることはできるが、上記問題が発生する可能性がある場合（既に発生している場合）には、:ref:`db_messaging` への変更を検討すること。

Nablarchバッチアプリケーションは、javaコマンドから直接起動するスタンドアロンアプリケーションとして実行する。

構成要素:
- **:ref:`main` (Main)**: アプリケーションの起点となるメインクラス。javaコマンドから直接起動し、システムリポジトリやログの初期化処理を行い、ハンドラキューを実行する。

## リクエストパスによるアクションとリクエストIDの指定

コマンドライン引数 `-requestPath` で実行するアクションクラスとリクエストIDを指定する。

```properties
# 書式
-requestPath=アクションのクラス名/リクエストID

# 指定例
-requestPath=com.sample.SampleBatchAction/BATCH0001
```

リクエストIDは各バッチプロセスの識別子。同一の業務アクションクラスを複数プロセスで起動する場合の識別子となる。

## Nablarchバッチアプリケーションの処理の流れ

1. :ref:`main` (Main) がハンドラキューを実行する。
2. `データリーダ(DataReader)` が入力データを読み込み、データレコードを1件ずつ提供する。
3. `ディスパッチハンドラ(DispatchHandler)` が、コマンドライン引数 `-requestPath` で指定するリクエストパスを元に処理すべきアクションクラスを特定し、ハンドラキューの末尾に追加する。
4. アクションクラスは、フォームクラスやエンティティクラスを使用して、データレコード1件ごとの業務ロジックを実行する。
5. アクションクラスは、処理結果を示す `Result` を返却する。
6. 処理対象データがなくなるまで2〜5を繰り返す。
7. `ステータスコード→プロセス終了コード変換ハンドラ(StatusCodeConvertHandler)` が、処理結果のステータスコードをプロセス終了コードに変換し、バッチアプリケーションの処理結果としてプロセス終了コードが返される。

## Nablarchバッチアプリケーションで使用するハンドラ

**リクエスト/レスポンス変換**
- :ref:`status_code_convert_handler`
- :ref:`data_read_handler`

**バッチ実行制御**
- :ref:`duplicate_process_check_handler`
- :ref:`request_path_java_package_mapping`
- :ref:`multi_thread_execution_handler`
- :ref:`loop_handler`
- :ref:`dbless_loop_handler`
- :ref:`retry_handler`
- :ref:`process_resident_handler`
- :ref:`process_stop_handler`

**DB関連**
- :ref:`database_connection_management_handler`
- :ref:`transaction_management_handler`

**エラー処理**
- :ref:`global_error_handler`

**その他**
- :ref:`thread_context_handler`
- :ref:`thread_context_clear_handler`
- :ref:`ServiceAvailabilityCheckHandler`
- :ref:`file_record_writer_dispose_handler`

## 都度起動バッチの最小ハンドラ構成（DB接続有り）

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | :ref:`status_code_convert_handler` | メイン | — | ステータスコードをプロセス終了コードに変換する。 | — |
| 2 | :ref:`global_error_handler` | メイン | — | — | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 3 | :ref:`database_connection_management_handler`（初期処理/終了処理用） | メイン | DB接続を取得する。 | DB接続を解放する。 | — |
| 4 | :ref:`transaction_management_handler`（初期処理/終了処理用） | メイン | トランザクションを開始する。 | トランザクションをコミットする。 | トランザクションをロールバックする。 |
| 5 | :ref:`request_path_java_package_mapping` | メイン | コマンドライン引数をもとに呼び出すアクションを決定する。 | — | — |
| 6 | :ref:`multi_thread_execution_handler` | メイン | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 |
| 7 | :ref:`database_connection_management_handler`（業務処理用） | サブ | DB接続を取得する。 | DB接続を解放する。 | — |
| 8 | :ref:`loop_handler` | サブ | 業務トランザクションを開始する。 | コミット間隔毎に業務トランザクションをコミットする。データリーダ上に処理対象データが残っていればループを継続する。 | 業務トランザクションをロールバックする。 |
| 9 | :ref:`data_read_handler` | サブ | データリーダを使用してレコードを1件読み込み、後続ハンドラの引数として渡す。:ref:`実行時ID<log-execution_id>` を採番する。 | — | 読み込んだレコードをログ出力した後、元例外を再送出する。 |

## 都度起動バッチの最小ハンドラ構成（DB接続無し）

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | :ref:`status_code_convert_handler` | メイン | — | ステータスコードをプロセス終了コードに変換する。 | — |
| 2 | :ref:`global_error_handler` | メイン | — | — | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 3 | :ref:`request_path_java_package_mapping` | メイン | コマンドライン引数をもとに呼び出すアクションを決定する。 | — | — |
| 4 | :ref:`multi_thread_execution_handler` | メイン | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 |
| 5 | :ref:`dbless_loop_handler` | サブ | — | データリーダ上に処理対象データが残っていればループを継続する。 | — |
| 6 | :ref:`data_read_handler` | サブ | データリーダを使用してレコードを1件読み込み、後続ハンドラの引数として渡す。:ref:`実行時ID<log-execution_id>` を採番する。 | — | 読み込んだレコードをログ出力した後、元例外を再送出する。 |

## 常駐バッチの最小ハンドラ構成

都度起動バッチに以下のハンドラをメインスレッド側に追加した構成:
- :ref:`thread_context_handler`（:ref:`process_stop_handler` のために必要）
- :ref:`thread_context_clear_handler`
- :ref:`retry_handler`
- :ref:`process_resident_handler`
- :ref:`process_stop_handler`

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | :ref:`status_code_convert_handler` | メイン | — | ステータスコードをプロセス終了コードに変換する。 | — |
| 2 | :ref:`thread_context_clear_handler` | メイン | — | :ref:`thread_context_handler` でスレッドローカル上に設定した値を全て削除する。 | — |
| 3 | :ref:`global_error_handler` | メイン | — | — | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 4 | :ref:`thread_context_handler` | メイン | コマンドライン引数からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。 | — | — |
| 5 | :ref:`retry_handler` | メイン | — | — | リトライ可能な実行時例外を捕捉し、かつリトライ上限に達していなければ後続のハンドラを再実行する。 |
| 6 | :ref:`process_resident_handler` | メイン | データ監視間隔ごとに後続のハンドラを繰り返し実行する。 | ループを継続する。 | ログ出力を行い、実行時例外が送出された場合はリトライ可能例外にラップして送出する。エラーが送出された場合はそのまま再送出する。 |
| 7 | :ref:`process_stop_handler` | メイン | リクエストテーブル上の処理停止フラグがオンであった場合は、後続ハンドラの処理は行なわずにプロセス停止例外（`ProcessStop`）を送出する。 | — | — |
| 8 | :ref:`database_connection_management_handler`（初期処理/終了処理用） | メイン | DB接続を取得する。 | DB接続を解放する。 | — |
| 9 | :ref:`transaction_management_handler`（初期処理/終了処理用） | メイン | トランザクションを開始する。 | トランザクションをコミットする。 | トランザクションをロールバックする。 |
| 10 | :ref:`request_path_java_package_mapping` | メイン | コマンドライン引数をもとに呼び出すアクションを決定する。 | — | — |
| 11 | :ref:`multi_thread_execution_handler` | メイン | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 |
| 12 | :ref:`database_connection_management_handler`（業務処理用） | サブ | DB接続を取得する。 | DB接続を解放する。 | — |
| 13 | :ref:`loop_handler` | サブ | 業務トランザクションを開始する。 | コミット間隔毎に業務トランザクションをコミットする。データリーダ上に処理対象データが残っていればループを継続する。 | 業務トランザクションをロールバックする。 |
| 14 | :ref:`data_read_handler` | サブ | データリーダを使用してレコードを1件読み込み、後続ハンドラの引数として渡す。:ref:`実行時ID<log-execution_id>` を採番する。 | — | 読み込んだレコードをログ出力した後、元例外を再送出する。 |

## Nablarchバッチアプリケーションで使用するデータリーダ

- `DatabaseRecordReader (データベース読み込み)`
- `FileDataReader (ファイル読み込み)`
- `ValidatableFileDataReader (バリデーション機能付きファイル読み込み)`
- `ResumeDataReader (レジューム機能付き読み込み)`

> **補足**: 標準データリーダで要件を満たせない場合は、`DataReader` インタフェースを実装したクラスをプロジェクトで作成する。

> **重要**: `FileDataReader` と `ValidatableFileDataReader` はデータアクセスに :ref:`data_format` を使用している。:ref:`data_bind` を使用する場合は、これらのデータリーダを使用しないこと。

## Nablarchバッチアプリケーションで使用するアクション

- `BatchAction (汎用的なバッチアクションのテンプレートクラス)`
- `FileBatchAction (ファイル入力のバッチアクションのテンプレートクラス)`
- `NoInputDataBatchAction (入力データを使用しないバッチアクションのテンプレートクラス)`
- `AsyncMessageSendAction (応答不要メッセージ送信用のアクションクラス)`

> **重要**: `FileBatchAction` はデータアクセスに :ref:`data_format` を使用している。:ref:`data_bind` を使用する場合は、他のアクションクラスを使用すること。
