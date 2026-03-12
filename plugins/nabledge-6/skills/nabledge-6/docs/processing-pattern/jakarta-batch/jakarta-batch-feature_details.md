# 機能詳細

**公式ドキュメント**: [機能詳細](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/feature_details.html)

## バッチアプリケーションの起動方法

- [Jakarta Batchアプリケーションの起動方法](jakarta-batch-run_batch_application.md)

<details>
<summary>keywords</summary>

Jakarta Batchアプリケーション起動, バッチ起動方法, jsr352_run_batch_application

</details>

## システムリポジトリの初期化

- [Jakarta Batchアプリケーションでシステムリポジトリの初期化](jakarta-batch-run_batch_application.md)

<details>
<summary>keywords</summary>

システムリポジトリ初期化, Jakarta Batchシステムリポジトリ, jsr352_run_batch_init_repository

</details>

## バッチジョブに適用するリスナーの定義方法

- [リスナーの定義方法](jakarta-batch-architecture.md)

<details>
<summary>keywords</summary>

リスナー定義, バッチジョブリスナー, jsr352-listener_definition

</details>

## 入力値のチェック

- [入力値のチェック](../../component/libraries/libraries-validation.md)

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, validation

</details>

## データベースアクセス

- [データベースアクセス](../../component/libraries/libraries-database_management.md)
- [feature_details/database_reader](jakarta-batch-database_reader.md)

<details>
<summary>keywords</summary>

データベースアクセス, database_management, database_reader, DatabaseReader

</details>

## ファイル入出力

- [ファイル入出力](../../component/libraries/libraries-data_converter.md)

<details>
<summary>keywords</summary>

ファイル入出力, data_converter, ファイル読み書き

</details>

## 排他制御

排他制御は2種類の方法を提供しているが、[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive_control.md) に記載がある通り、[universal_dao](../../component/libraries/libraries-universal_dao.md) の使用を推奨する。

- [exclusive_control](../../component/libraries/libraries-exclusive_control.md)
- [universal_dao](../../component/libraries/libraries-universal_dao.md)
  - [悲観的ロック](jakarta-batch-pessimistic_lock.md)

<details>
<summary>keywords</summary>

排他制御, UniversalDao, 悲観的ロック, exclusive_control, universal_dao, ペシミスティックロック

</details>

## ジョブ定義のxmlの作成方法

[Jakarta Batch Specificationを参照(外部サイト、英語)](https://jakarta.ee/specifications/batch/)

<details>
<summary>keywords</summary>

ジョブ定義XML, Jakarta Batch Specification, ジョブXML作成

</details>

## MOMメッセージ送信

- [同期応答メッセージ送信](../../component/libraries/libraries-mom_system_messaging.md)

<details>
<summary>keywords</summary>

MOMメッセージ送信, 同期応答メッセージ送信, mom_system_messaging

</details>

## 運用設計

- [feature_details/operation_policy](jakarta-batch-operation_policy.md)
- [feature_details/progress_log](jakarta-batch-progress_log.md)
- [feature_details/operator_notice_log](jakarta-batch-operator_notice_log.md)

<details>
<summary>keywords</summary>

運用設計, 進捗ログ, オペレーター通知ログ, operation_policy, progress_log, operator_notice_log

</details>
