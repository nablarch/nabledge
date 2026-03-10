# 機能詳細

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/feature_details.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseTableQueueReader.html)

## アプリケーションの起動方法

:ref:`アプリケーションの起動方法<main-run_application>`

<details>
<summary>keywords</summary>

アプリケーション起動, main-run_application, 起動方法

</details>

## システムリポジトリの初期化

アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで初期化する。詳細は :ref:`アプリケーションの起動方法<main-run_application>` を参照。

<details>
<summary>keywords</summary>

システムリポジトリ初期化, 設定ファイルパス指定, アプリケーション起動時初期化

</details>

## データベースアクセス

- :ref:`データベースアクセス <database_management>`
- 標準提供のデータリーダ: `DatabaseTableQueueReader (データベースのテーブルをキューとして扱うリーダ)`

<details>
<summary>keywords</summary>

データベースアクセス, DatabaseTableQueueReader, テーブルキューリーダ, database_management

</details>

## 入力値のチェック

:ref:`入力値のチェック <validation>`

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, validation

</details>

## 排他制御

排他制御は2種類提供されているが、:ref:`UniversalDaoを推奨する理由 <exclusive_control-deprecated>` に記載の通り、:ref:`universal_dao` の使用を推奨する。

- :ref:`exclusive_control`
- :ref:`universal_dao`
  - :ref:`universal_dao_jpa_pessimistic_lock`

<details>
<summary>keywords</summary>

排他制御, UniversalDao推奨, 悲観ロック, universal_dao_jpa_pessimistic_lock, exclusive_control

</details>

## 実行制御

- :ref:`プロセス終了コード<status_code_convert_handler-rules>`
- :ref:`エラー発生データを除外して処理を継続する <db_messaging-exclude_error_data>`
- :ref:`メッセージングプロセスを異常終了させる <db_messaging-process_abnormal_end>`
- :ref:`処理の並列実行(マルチスレッド化)<multi_thread_execution_handler>`

<details>
<summary>keywords</summary>

実行制御, プロセス終了コード, エラーデータ除外, 処理継続, マルチスレッド, 異常終了, error_processing

</details>

## マルチプロセス化

:ref:`db_messaging-multiple_process`

<details>
<summary>keywords</summary>

マルチプロセス, 並列処理, multiple_process, db_messaging-multiple_process

</details>
