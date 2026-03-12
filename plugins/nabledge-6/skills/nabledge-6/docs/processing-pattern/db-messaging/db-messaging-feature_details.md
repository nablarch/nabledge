# 機能詳細

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/db/feature_details.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseTableQueueReader.html)

## アプリケーションの起動方法

[アプリケーションの起動方法](../../component/handlers/handlers-main.md)

<details>
<summary>keywords</summary>

アプリケーション起動, main-run_application, 起動方法

</details>

## システムリポジトリの初期化

アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで初期化する。詳細は [アプリケーションの起動方法](../../component/handlers/handlers-main.md) を参照。

<details>
<summary>keywords</summary>

システムリポジトリ初期化, 設定ファイルパス指定, アプリケーション起動時初期化

</details>

## データベースアクセス

- [データベースアクセス](../../component/libraries/libraries-database_management.md)
- 標準提供のデータリーダ: `DatabaseTableQueueReader (データベースのテーブルをキューとして扱うリーダ)`

<details>
<summary>keywords</summary>

データベースアクセス, DatabaseTableQueueReader, テーブルキューリーダ, database_management

</details>

## 入力値のチェック

[入力値のチェック](../../component/libraries/libraries-validation.md)

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, validation

</details>

## 排他制御

排他制御は2種類提供されているが、[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive_control.md) に記載の通り、[universal_dao](../../component/libraries/libraries-universal_dao.md) の使用を推奨する。

- [exclusive_control](../../component/libraries/libraries-exclusive_control.md)
- [universal_dao](../../component/libraries/libraries-universal_dao.md)
  - :ref:`universal_dao_jpa_pessimistic_lock`

<details>
<summary>keywords</summary>

排他制御, UniversalDao推奨, 悲観ロック, universal_dao_jpa_pessimistic_lock, exclusive_control

</details>

## 実行制御

- [プロセス終了コード](../../component/handlers/handlers-status_code_convert_handler.md)
- [エラー発生データを除外して処理を継続する](db-messaging-error_processing.md)
- [メッセージングプロセスを異常終了させる](db-messaging-error_processing.md)
- [処理の並列実行(マルチスレッド化)](../../component/handlers/handlers-multi_thread_execution_handler.md)

<details>
<summary>keywords</summary>

実行制御, プロセス終了コード, エラーデータ除外, 処理継続, マルチスレッド, 異常終了, error_processing

</details>

## マルチプロセス化

[db_messaging-multiple_process](db-messaging-multiple_process.md)

<details>
<summary>keywords</summary>

マルチプロセス, 並列処理, multiple_process, db_messaging-multiple_process

</details>
