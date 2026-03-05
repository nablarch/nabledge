# 機能詳細

## バッチアプリケーションの起動方法

* :ref:`Nablarchバッチアプリケーションの起動方法<main-run_application>`

## システムリポジトリの初期化

アプリケーション起動時にシステムリポジトリの設定ファイルパスを指定する。

詳細: :ref:`Nablarchバッチアプリケーションの起動方法<main-run_application>`

## 入力値のチェック

* :ref:`入力値のチェック <validation>`

## データベースアクセス

* :ref:`データベースアクセス <database_management>`

**標準提供のデータリーダ**:
* `DatabaseRecordReader (データベース読み込み)`

## ファイル入出力

* :ref:`ファイル入出力<data_converter>`

**標準提供のデータリーダ**:
* `FileDataReader (ファイル読み込み)`
* `ValidatableFileDataReader (バリデーション機能付きファイル読み込み)`
* `ResumeDataReader (レジューム機能付き読み込み)`

## 排他制御

排他制御は以下の2種類の方法を提供しているが、:ref:`UniversalDaoを推奨する理由 <exclusive_control-deprecated>` に記載がある通り、:ref:`universal_dao` の使用を推奨する。

* :ref:`exclusive_control`
* :ref:`universal_dao`
  * :ref:`悲観的ロック<nablarch_batch_pessimistic_lock>`

## バッチ処理の実行制御

* :ref:`バッチ処理のプロセス終了コード<status_code_convert_handler-rules>`
* :ref:`バッチ処理のエラー処理<nablarch_batch_error_process>`
* :ref:`バッチ処理の並列実行(マルチスレッド化)<multi_thread_execution_handler>`
* :ref:`バッチ処理のコミット間隔の制御 <loop_handler-commit_interval>`
* :ref:`1回のバッチ処理の処理件数制限 <data_read_handler-max_count>` (大量データを処理するバッチ処理を数日に分けて処理させる場合など)

## MOMメッセージ送信

* :ref:`同期応答メッセージ送信<mom_system_messaging-sync_message_send>`
* :ref:`応答不要メッセージ送信<mom_system_messaging-async_message_send>`

## バッチ実行中の状態の保持

* :ref:`nablarch_batch_retention_state`

## 常駐バッチのマルチプロセス化

* :ref:`nablarch_batch_multiple_process`
