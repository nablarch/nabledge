# 機能詳細

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/nablarch_batch/feature_details.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/DatabaseRecordReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/FileDataReader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ValidatableFileDataReader.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ResumeDataReader.html)

## バッチアプリケーションの起動方法

- [Nablarchバッチアプリケーションの起動方法](../../component/handlers/handlers-main.md)

<details>
<summary>keywords</summary>

バッチアプリケーション起動, Nablarchバッチ起動方法, アプリケーション実行

</details>

## システムリポジトリの初期化

システムリポジトリの初期化は、アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで行う。

<details>
<summary>keywords</summary>

システムリポジトリ初期化, 設定ファイルパス指定, アプリケーション起動時初期化

</details>

## 入力値のチェック

- [入力値のチェック](../../component/libraries/libraries-validation.md)

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, validation

</details>

## データベースアクセス

[データベースアクセス](../../component/libraries/libraries-database_management.md)

標準提供のデータリーダ:
- `DatabaseRecordReader (データベース読み込み)`

<details>
<summary>keywords</summary>

データベースアクセス, DatabaseRecordReader, データリーダ, データベース読み込み

</details>

## ファイル入出力

[ファイル入出力](../../component/libraries/libraries-data_converter.md)

標準提供のデータリーダ:
- `FileDataReader (ファイル読み込み)`
- `ValidatableFileDataReader (バリデージョン機能付きファイル読み込み)`
- `ResumeDataReader (レジューム機能付き読み込み)`

<details>
<summary>keywords</summary>

ファイル入出力, FileDataReader, ValidatableFileDataReader, ResumeDataReader, ファイル読み込み, レジューム機能

</details>

## 排他制御

排他制御は2種類の方法を提供するが、[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive_control.md) に記載の通り、[universal_dao](../../component/libraries/libraries-universal_dao.md) の使用を推奨する。

- [exclusive_control](../../component/libraries/libraries-exclusive_control.md)
- [universal_dao](../../component/libraries/libraries-universal_dao.md)
  - [悲観的ロック](nablarch-batch-nablarch_batch_pessimistic_lock.md)

<details>
<summary>keywords</summary>

排他制御, UniversalDao推奨, 悲観的ロック, exclusive_control非推奨, pessimistic lock

</details>

## バッチ処理の実行制御

- [バッチ処理のプロセス終了コード](../../component/handlers/handlers-status_code_convert_handler.md)
- [バッチ処理のエラー処理](nablarch-batch-nablarch_batch_error_process.md)
- [バッチ処理の並列実行(マルチスレッド化)](../../component/handlers/handlers-multi_thread_execution_handler.md)
- [バッチ処理のコミット間隔の制御](../../component/handlers/handlers-loop_handler.md)
- [1回のバッチ処理の処理件数制限](../../component/handlers/handlers-data_read_handler.md) (大量データを処理するバッチ処理を数日に分けて処理させる場合など)

<details>
<summary>keywords</summary>

バッチ実行制御, プロセス終了コード, エラー処理, マルチスレッド並列実行, コミット間隔, 処理件数制限

</details>

## MOMメッセージ送信

- [同期応答メッセージ送信](../../component/libraries/libraries-mom_system_messaging.md)
- [応答不要メッセージ送信](../../component/libraries/libraries-mom_system_messaging.md)

<details>
<summary>keywords</summary>

MOMメッセージ送信, 同期応答メッセージ送信, 応答不要メッセージ送信, メッセージング

</details>

## バッチ実行中の状態の保持

- [nablarch_batch_retention_state](nablarch-batch-nablarch_batch_retention_state.md)

<details>
<summary>keywords</summary>

バッチ状態保持, バッチ実行中状態, nablarch_batch_retention_state

</details>

## 常駐バッチのマルチプロセス化

- [nablarch_batch_multiple_process](nablarch-batch-nablarch_batch_multiple_process.md)

<details>
<summary>keywords</summary>

常駐バッチ, マルチプロセス, nablarch_batch_multiple_process

</details>
