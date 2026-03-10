# 機能詳細

## アプリケーションの起動方法

:ref:`アプリケーションの起動方法<main-run_application>`

## システムリポジトリの初期化

アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで初期化する。詳細は :ref:`アプリケーションの起動方法<main-run_application>` を参照。

## データベースアクセス

- :ref:`データベースアクセス <database_management>`
- 標準提供のデータリーダ: `DatabaseTableQueueReader (データベースのテーブルをキューとして扱うリーダ)`

## 入力値のチェック

:ref:`入力値のチェック <validation>`

## 排他制御

排他制御は2種類提供されているが、:ref:`UniversalDaoを推奨する理由 <exclusive_control-deprecated>` に記載の通り、:ref:`universal_dao` の使用を推奨する。

- :ref:`exclusive_control`
- :ref:`universal_dao`
  - :ref:`universal_dao_jpa_pessimistic_lock`

## 実行制御

- :ref:`プロセス終了コード<status_code_convert_handler-rules>`
- :ref:`エラー発生データを除外して処理を継続する <db_messaging-exclude_error_data>`
- :ref:`メッセージングプロセスを異常終了させる <db_messaging-process_abnormal_end>`
- :ref:`処理の並列実行(マルチスレッド化)<multi_thread_execution_handler>`

## マルチプロセス化

:ref:`db_messaging-multiple_process`
