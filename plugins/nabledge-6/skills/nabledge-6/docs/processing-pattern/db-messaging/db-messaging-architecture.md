# アーキテクチャ概要

**目次**

* 構成
* リクエストパスによるアクションとリクエストIDの指定
* 処理の流れ
* 使用するハンドラ
* ハンドラの最小構成
* 使用するデータリーダ
* 使用するアクションのテンプレートクラス

データベースをキューとして扱うタイプのメッセージング処理では、
定期的にデータベース上のテーブルを監視し未処理のレコードを順次処理するための機能を提供している。

> **Important:**
> 未処理のレコードの判定は、テーブルのレコード上で表す必要がある。
> このため、処理が終わったレコードの状態を処理済みへ変更する処理が必要となる。

## 構成

Nablarchバッチアプリケーションと同じ構成となる。
詳細は、 [Nablarchバッチアプリケーションの構成](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#nablarch-batch-structure) を参照。

## リクエストパスによるアクションとリクエストIDの指定

データベースをキューとして扱うメッセージング処理では、Nablarchバッチアプリケーションと同じように
コマンドライン引数で実行するアクションとリクエストIDを指定する。

詳細は、 [NablarchバッチアプリケーションのアクションとリクエストIDの指定](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#nablarch-batch-resolve-action) を参照。

## 処理の流れ

Nablarchバッチアプリケーションと同じ処理の流れとなる。詳細は、 [Nablarchバッチアプリケーションの処理の流れ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#nablarch-batch-process-flow) を参照。

## 使用するハンドラ

Nablarchでは、データベースをキューとして扱うメッセージング処理で必要なハンドラを標準で幾つか提供している。
プロジェクトの要件に従い、ハンドラキューを構築すること。(要件によっては、プロジェクトカスタムなハンドラを作成することになる)

各ハンドラの詳細は、リンク先を参照すること。

リクエストやレスポンスの変換を行うハンドラ
* [ステータスコード→プロセス終了コード変換ハンドラ](../../component/handlers/handlers-status-code-convert-handler.md#status-code-convert-handler)
* [データリードハンドラ](../../component/handlers/handlers-data-read-handler.md#data-read-handler)
実行制御を行うハンドラ
* [プロセス多重起動防止ハンドラ](../../component/handlers/handlers-duplicate-process-check-handler.md#duplicate-process-check-handler)
* [リクエストディスパッチハンドラ](../../component/handlers/handlers-request-path-java-package-mapping.md#request-path-java-package-mapping)
* [マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-multi-thread-execution-handler.md#multi-thread-execution-handler)
* [リトライハンドラ](../../component/handlers/handlers-retry-handler.md#retry-handler)
* [プロセス停止制御ハンドラ](../../component/handlers/handlers-process-stop-handler.md#process-stop-handler)
* [リクエストスレッド内ループ制御ハンドラ](../../component/handlers/handlers-request-thread-loop-handler.md#request-thread-loop-handler)
データベースに関連するハンドラ
* [データベース接続管理ハンドラ](../../component/handlers/handlers-database-connection-management-handler.md#database-connection-management-handler)
* [トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#transaction-management-handler)
エラー処理に関するハンドラ
* [グローバルエラーハンドラ](../../component/handlers/handlers-global-error-handler.md#global-error-handler)
その他
* [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler)
* [スレッドコンテキスト変数削除ハンドラ](../../component/handlers/handlers-thread-context-clear-handler.md#thread-context-clear-handler)
* [サービス提供可否チェックハンドラ](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md#serviceavailabilitycheckhandler)
* [出力ファイル開放ハンドラ](../../component/handlers/handlers-file-record-writer-dispose-handler.md#file-record-writer-dispose-handler)

## ハンドラの最小構成

データベースをキューとして扱うメッセージング処理の必要最小限のハンドラキューを以下に示す。
これをベースに、プロジェクト要件に従ってNablarchの標準ハンドラやプロジェクトで作成したカスタムハンドラを追加する。

最小ハンドラ構成

| No. | ハンドラ | スレッド | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|
| 1 | [ステータスコード→プロセス終了コード変換ハンドラ](../../component/handlers/handlers-status-code-convert-handler.md#status-code-convert-handler) | メイン |  | ステータスコードをプロセス終了コードに変換する。 |  |
| 2 | [スレッドコンテキスト変数削除ハンドラ](../../component/handlers/handlers-thread-context-clear-handler.md#thread-context-clear-handler) | メイン |  | [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) でスレッドローカル上に設定した値を全て削除する。 |  |
| 3 | [グローバルエラーハンドラ](../../component/handlers/handlers-global-error-handler.md#global-error-handler) | メイン |  |  | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 4 | [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler) | メイン | コマンドライン引数からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。 |  |  |
| 5 | [リトライハンドラ](../../component/handlers/handlers-retry-handler.md#retry-handler) | メイン |  |  | リトライ可能な実行時例外を捕捉し、かつリトライ上限に達していなければ後続のハンドラを再実行する。 |
| 6 | [データベース接続管理ハンドラ](../../component/handlers/handlers-database-connection-management-handler.md#database-connection-management-handler) (初期処理/終了処理用) | メイン | DB接続を取得する。 | DB接続を解放する。 |  |
| 7 | [トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#transaction-management-handler) (初期処理/終了処理用) | メイン | トランザクションを開始する。 | トランザクションをコミットする。 | トランザクションをロールバックする。 |
| 8 | [リクエストディスパッチハンドラ](../../component/handlers/handlers-request-path-java-package-mapping.md#request-path-java-package-mapping) | メイン | コマンドライン引数をもとに呼び出すアクションを決定する。 |  |  |
| 9 | [マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-multi-thread-execution-handler.md#multi-thread-execution-handler) | メイン | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 |
| 10 | [データベース接続管理ハンドラ](../../component/handlers/handlers-database-connection-management-handler.md#database-connection-management-handler) (業務処理用) | サブ | DB接続を取得する。 | DB接続を解放する。 |  |
| 11 | [リクエストスレッド内ループ制御ハンドラ](../../component/handlers/handlers-request-thread-loop-handler.md#request-thread-loop-handler) | サブ |  | 再度後続のハンドラに処理を委譲する。 | 例外/エラーに応じたログ出力処理と再送出処理を行う。 |
| 12 | [プロセス停止制御ハンドラ](../../component/handlers/handlers-process-stop-handler.md#process-stop-handler) | サブ | リクエストテーブル上の処理停止フラグがオンであった場合は、後続ハンドラの処理は行なわずにプロセス停止例外( ProcessStop )を送出する。 |  |  |
| 13 | [データリードハンドラ](../../component/handlers/handlers-data-read-handler.md#data-read-handler) | サブ | データリーダを使用してレコードを1件読み込み、後続ハンドラの引数として渡す。 また [実行時ID](../../component/libraries/libraries-log.md#log-execution-id) を採番する。 |  | 読み込んだレコードをログ出力した後、元例外を再送出する。 |
| 14 | [トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#transaction-management-handler) (業務処理用) | サブ | トランザクションを開始する。 | トランザクションをコミットする。 | トランザクションをロールバックする。 |

## 使用するデータリーダ

データベースをキューとして扱う場合には、以下のデータリーダを使用する。
バッチ用のDatabaseRecordReader を使用した場合、
繰り返しテーブルを監視できないので注意すること。

* DatabaseTableQueueReader

> **Important:**
> 上記のリーダで要件を満たすことができず、プロジェクトでリーダを作成する場合は以下の点に注意して実装すること。

> * >   対象データがなくなった場合でも、継続して対象データを監視できるようにすること
> * >   マルチススレッド環境下で使われる場合に、同一データを複数のスレッドで処理することがないようにすること

> なお、 DatabaseTableQueueReader は、上記を満たすために以下の実装となっている

> * >   テーブルに未処理のデータが無くなった場合、再度検索用SQLを実行し未処理データを抽出する
> * >   複数スレッドで同一データを処理することがないように、現在処理中のデータの識別子(主キーの値)を保持し、処理されていないデータを読み込んでいる

## 使用するアクションのテンプレートクラス

データベースをキューとして扱う場合は、以下のテンプレートクラスを使用する。

* BatchAction (汎用的なバッチアクション)
