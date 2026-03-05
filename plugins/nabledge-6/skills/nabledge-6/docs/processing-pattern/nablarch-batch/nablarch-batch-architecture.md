# アーキテクチャ概要

## Nablarchバッチアプリケーションの構成

NablarchバッチアプリケーションはDBやファイルのデータレコード1件ごとに処理を繰り返し実行する機能を提供。

**バッチタイプ**:

**都度起動バッチ**:
日次や月次など、定期的にプロセスを起動してバッチ処理を実行

**常駐バッチ**:
プロセスを起動しておき、一定間隔でバッチ処理を実行。オンライン処理で作成された要求データを定期的に一括処理する場合などに使用

> **重要**: 常駐バッチはマルチスレッド実行時、処理が遅いスレッドの終了を他スレッドが待つため要求データ取り込み遅延が発生する可能性がある。新規開発では常駐バッチではなく :ref:`db_messaging` を推奨。既存プロジェクトでも遅延の可能性がある場合は :ref:`db_messaging` への変更を検討すること。

**アプリケーション構成**:

Nablarchバッチアプリケーションはjavaコマンドから直接起動するスタンドアロンアプリケーション。

**構成要素**:
- **:ref:`main` (Main)**: 起点となるメインクラス。javaコマンドから起動し、システムリポジトリとログを初期化後、ハンドラキューを実行

## リクエストパスによるアクションとリクエストIDの指定

コマンドライン引数`-requestPath`でアクションとリクエストIDを指定する。

**書式**:
```properties
-requestPath=アクションのクラス名/リクエストID
```

**例**:
```properties
-requestPath=com.sample.SampleBatchAction/BATCH0001
```

リクエストIDは各バッチプロセスの識別子。同一の業務アクションクラスを実行するプロセスを複数起動する場合、このリクエストIDで識別する。

## Nablarchバッチアプリケーションの処理の流れ

入力データ読み込みから処理結果返却までの流れ:

1. :ref:`共通起動ランチャ(Main) <main>` がハンドラキュー(handler queue)を実行
2. `データリーダ(DataReader)` が入力データを読み込み、データレコードを1件ずつ提供
3. ハンドラキューの `ディスパッチハンドラ(DispatchHandler)` がコマンドライン引数(-requestPath)のリクエストパスから処理すべきアクションクラス(action class)を特定し、ハンドラキューの末尾に追加
4. アクションクラス(action class)は、フォームクラス(form class)やエンティティクラス(entity class)を使用してデータレコード1件ごとの業務ロジック(business logic)を実行
5. アクションクラス(action class)は処理結果を示す `Result` を返却
6. 処理対象データがなくなるまで2～5を繰り返す
7. ハンドラキューの `ステータスコード→プロセス終了コード変換ハンドラ(StatusCodeConvertHandler)` が処理結果のステータスコードをプロセス終了コードに変換し、プロセス終了コードを返却

## Nablarchバッチアプリケーションで使用するハンドラ

プロジェクト要件に応じてハンドラキューを構築する。標準ハンドラで要件を満たせない場合はカスタムハンドラを作成する。

**ハンドラ分類**:

リクエスト・レスポンス変換:
- :ref:`status_code_convert_handler`
- :ref:`data_read_handler`

バッチ実行制御:
- :ref:`duplicate_process_check_handler`
- :ref:`request_path_java_package_mapping`
- :ref:`multi_thread_execution_handler`
- :ref:`loop_handler`
- :ref:`dbless_loop_handler`
- :ref:`retry_handler`
- :ref:`process_resident_handler`
- :ref:`process_stop_handler`

データベース:
- :ref:`database_connection_management_handler`
- :ref:`transaction_management_handler`

エラー処理:
- :ref:`global_error_handler`

その他:
- :ref:`thread_context_handler`
- :ref:`thread_context_clear_handler`
- :ref:`ServiceAvailabilityCheckHandler`
- :ref:`file_record_writer_dispose_handler`

### 都度起動バッチの最小ハンドラ構成

プロジェクト要件に応じてNablarch標準ハンドラ・カスタムハンドラを追加する。

**DB接続有り**:

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | :ref:`status_code_convert_handler` | メイン | — | ステータスコードをプロセス終了コードに変換 | — |
| 2 | :ref:`global_error_handler` | メイン | — | — | 実行時例外・エラーをログ出力 |
| 3 | :ref:`database_connection_management_handler` (初期処理/終了処理用) | メイン | DB接続取得 | DB接続解放 | — |
| 4 | :ref:`transaction_management_handler` (初期処理/終了処理用) | メイン | トランザクション開始 | トランザクションコミット | トランザクションロールバック |
| 5 | :ref:`request_path_java_package_mapping` | メイン | コマンドライン引数からアクション決定 | — | — |
| 6 | :ref:`multi_thread_execution_handler` | メイン | サブスレッド作成・後続ハンドラ並行実行 | 全スレッド正常終了まで待機 | 処理中スレッド完了待機・起因例外再送出 |
| 7 | :ref:`database_connection_management_handler` (業務処理用) | サブ | DB接続取得 | DB接続解放 | — |
| 8 | :ref:`loop_handler` | サブ | 業務トランザクション開始 | コミット間隔ごとに業務トランザクションコミット・データリーダに処理対象データが残っていればループ継続 | 業務トランザクションロールバック |
| 9 | :ref:`data_read_handler` | サブ | データリーダでレコード1件読み込み・後続ハンドラに渡す・:ref:`実行時ID<log-execution_id>`を採番 | — | 読み込みレコードをログ出力後、元例外再送出 |

**DB接続無し**:

DB未接続の場合、DB接続関連ハンドラとトランザクション制御が不要。

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | :ref:`status_code_convert_handler` | メイン | — | ステータスコードをプロセス終了コードに変換 | — |
| 2 | :ref:`global_error_handler` | メイン | — | — | 実行時例外・エラーをログ出力 |
| 3 | :ref:`request_path_java_package_mapping` | メイン | コマンドライン引数からアクション決定 | — | — |
| 4 | :ref:`multi_thread_execution_handler` | メイン | サブスレッド作成・後続ハンドラ並行実行 | 全スレッド正常終了まで待機 | 処理中スレッド完了待機・起因例外再送出 |
| 5 | :ref:`dbless_loop_handler` | サブ | — | データリーダに処理対象データが残っていればループ継続 | — |
| 6 | :ref:`data_read_handler` | サブ | データリーダでレコード1件読み込み・後続ハンドラに渡す・:ref:`実行時ID<log-execution_id>`を採番 | — | 読み込みレコードをログ出力後、元例外再送出 |

### 常駐バッチの最小ハンドラ構成

プロジェクト要件に応じてNablarch標準ハンドラ・カスタムハンドラを追加する。

都度起動バッチとの差分: メインスレッドに以下が追加:
- :ref:`thread_context_handler` (:ref:`process_stop_handler`のために必要)
- :ref:`thread_context_clear_handler`
- :ref:`retry_handler`
- :ref:`process_resident_handler`
- :ref:`process_stop_handler`

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | :ref:`status_code_convert_handler` | メイン | — | ステータスコードをプロセス終了コードに変換 | — |
| 2 | :ref:`thread_context_clear_handler` | メイン | — | :ref:`thread_context_handler`でスレッドローカルに設定した値を全削除 | — |
| 3 | :ref:`global_error_handler` | メイン | — | — | 実行時例外・エラーをログ出力 |
| 4 | :ref:`thread_context_handler` | メイン | コマンドライン引数からリクエストID・ユーザID等のスレッドコンテキスト変数初期化 | — | — |
| 5 | :ref:`retry_handler` | メイン | — | — | リトライ可能な実行時例外を捕捉・リトライ上限未達なら後続ハンドラ再実行 |
| 6 | :ref:`process_resident_handler` | メイン | データ監視間隔ごとに後続ハンドラ繰り返し実行 | ループ継続 | ログ出力・実行時例外はリトライ可能例外にラップして送出・エラーはそのまま再送出 |
| 7 | :ref:`process_stop_handler` | メイン | リクエストテーブルの処理停止フラグがオンなら後続ハンドラ実行せず`ProcessStop`例外送出 | — | — |
| 8 | :ref:`database_connection_management_handler` (初期処理/終了処理用) | メイン | DB接続取得 | DB接続解放 | — |
| 9 | :ref:`transaction_management_handler` (初期処理/終了処理用) | メイン | トランザクション開始 | トランザクションコミット | トランザクションロールバック |
| 10 | :ref:`request_path_java_package_mapping` | メイン | コマンドライン引数からアクション決定 | — | — |
| 11 | :ref:`multi_thread_execution_handler` | メイン | サブスレッド作成・後続ハンドラ並行実行 | 全スレッド正常終了まで待機 | 処理中スレッド完了待機・起因例外再送出 |
| 12 | :ref:`database_connection_management_handler` (業務処理用) | サブ | DB接続取得 | DB接続解放 | — |
| 13 | :ref:`loop_handler` | サブ | 業務トランザクション開始 | コミット間隔ごとに業務トランザクションコミット・データリーダに処理対象データが残っていればループ継続 | 業務トランザクションロールバック |
| 14 | :ref:`data_read_handler` | サブ | データリーダでレコード1件読み込み・後続ハンドラに渡す・:ref:`実行時ID<log-execution_id>`を採番 | — | 読み込みレコードをログ出力後、元例外再送出 |

## Nablarchバッチアプリケーションで使用するデータリーダ

**標準データリーダ**:
- `DatabaseRecordReader` (DB読み込み)
- `FileDataReader` (ファイル読み込み)
- `ValidatableFileDataReader` (バリデーション機能付きファイル読み込み)
- `ResumeDataReader` (レジューム機能付き読み込み)

> **補足**: 標準データリーダで要件を満たせない場合、`DataReader`インタフェースを実装したカスタムクラスを作成する。

> **重要**: `FileDataReader`と`ValidatableFileDataReader`は:ref:`data_format`を使用する。:ref:`data_bind`を使用する場合はこれらのデータリーダを使用しないこと。

## Nablarchバッチアプリケーションで使用するアクション

**標準アクションクラス**:
- `BatchAction` (汎用バッチアクションテンプレート)
- `FileBatchAction` (ファイル入力バッチアクションテンプレート)
- `NoInputDataBatchAction` (入力データ不要バッチアクションテンプレート)
- `AsyncMessageSendAction` (応答不要メッセージ送信)

> **重要**: `FileBatchAction`は:ref:`data_format`を使用する。:ref:`data_bind`を使用する場合は他のアクションクラスを使用すること。
