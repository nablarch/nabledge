# 機能詳細

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/feature_details.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseRecordReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/FileDataReader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ValidatableFileDataReader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ResumeDataReader.html)

## バッチアプリケーションの起動方法

[Nablarchバッチアプリケーションの起動方法](../../component/handlers/handlers-main.md)

<details>
<summary>keywords</summary>

バッチアプリケーション起動, main-run_application, 起動方法, Nablarchバッチ起動

</details>

## システムリポジトリの初期化

システムリポジトリの初期化は、アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで行う。詳細は [Nablarchバッチアプリケーションの起動方法](../../component/handlers/handlers-main.md) を参照。

<details>
<summary>keywords</summary>

システムリポジトリ初期化, 設定ファイルパス, アプリケーション起動時初期化, main-run_application

</details>

## 入力値のチェック

[入力値のチェック](../../component/libraries/libraries-validation.md)

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, validation, 入力検証

</details>

## データベースアクセス

[データベースアクセス](../../component/libraries/libraries-database_management.md)

**標準提供データリーダ**:
- `DatabaseRecordReader (データベース読み込み)`

<details>
<summary>keywords</summary>

DatabaseRecordReader, データベース読み込み, データリーダ, database_management, データベースアクセス

</details>

## ファイル入出力

[ファイル入出力](../../component/libraries/libraries-data_converter.md)

**標準提供データリーダ**:
- `FileDataReader (ファイル読み込み)`
- `ValidatableFileDataReader (バリデーション機能付きファイル読み込み)`
- `ResumeDataReader (レジューム機能付き読み込み)`

<details>
<summary>keywords</summary>

FileDataReader, ValidatableFileDataReader, ResumeDataReader, ファイル読み込み, レジューム機能, バリデーション付きファイル読み込み, data_converter

</details>

## 排他制御

> **重要**: [exclusive_control](../../component/libraries/libraries-exclusive_control.md) は非推奨。[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive_control.md) に記載がある通り、[universal_dao](../../component/libraries/libraries-universal_dao.md) の使用を推奨する。

排他制御の実装方法:
- [exclusive_control](../../component/libraries/libraries-exclusive_control.md)（非推奨）
- [universal_dao](../../component/libraries/libraries-universal_dao.md)（推奨）
  - [悲観的ロック](nablarch-batch-nablarch_batch_pessimistic_lock.md)

<details>
<summary>keywords</summary>

排他制御, universal_dao, exclusive_control, 悲観的ロック, nablarch_batch_pessimistic_lock, UniversalDao推奨, exclusive_control-deprecated

</details>

## バッチ処理の実行制御

- [バッチ処理のプロセス終了コード](../../component/handlers/handlers-status_code_convert_handler.md)
- [バッチ処理のエラー処理](nablarch-batch-nablarch_batch_error_process.md)
- [バッチ処理の並列実行(マルチスレッド化)](../../component/handlers/handlers-multi_thread_execution_handler.md)
- [バッチ処理のコミット間隔の制御](../../component/handlers/handlers-loop_handler.md)
- [1回のバッチ処理の処理件数制限](../../component/handlers/handlers-data_read_handler.md)（大量データを数日に分けて処理する場合など）

<details>
<summary>keywords</summary>

プロセス終了コード, エラー処理, マルチスレッド, コミット間隔, 処理件数制限, 並列実行, nablarch_batch_error_process, status_code_convert_handler, loop_handler, data_read_handler

</details>

## MOMメッセージ送信

- [同期応答メッセージ送信](../../component/libraries/libraries-mom_system_messaging.md)
- [応答不要メッセージ送信](../../component/libraries/libraries-mom_system_messaging.md)

<details>
<summary>keywords</summary>

MOMメッセージ送信, 同期応答メッセージ送信, 応答不要メッセージ送信, mom_system_messaging

</details>

## バッチ実行中の状態の保持

バッチ実行中に状態を保持する方法については、[nablarch_batch_retention_state](nablarch-batch-nablarch_batch_retention_state.md) を参照。

<details>
<summary>keywords</summary>

状態保持, nablarch_batch_retention_state, バッチ実行中状態, 常駐バッチ状態

</details>

## 常駐バッチのマルチプロセス化

常駐バッチをマルチプロセス化する方法については、[nablarch_batch_multiple_process](nablarch-batch-nablarch_batch_multiple_process.md) を参照。

<details>
<summary>keywords</summary>

常駐バッチ, マルチプロセス, nablarch_batch_multiple_process, 複数プロセス

</details>
