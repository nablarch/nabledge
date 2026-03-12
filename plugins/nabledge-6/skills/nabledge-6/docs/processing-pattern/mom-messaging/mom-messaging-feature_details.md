# 機能詳細

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/mom/feature_details.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/FwHeaderReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/MessageReader.html)

## アプリケーションの起動方法

MOMメッセージングアプリケーションの起動方法については、[アプリケーションの起動方法](../../component/handlers/handlers-main.md) を参照。

<details>
<summary>keywords</summary>

アプリケーション起動, 起動方法, main-run_application

</details>

## システムリポジトリの初期化

システムリポジトリの初期化は、アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで行う。詳細は [アプリケーションの起動方法](../../component/handlers/handlers-main.md) を参照。

<details>
<summary>keywords</summary>

システムリポジトリ初期化, 設定ファイルパス指定, アプリケーション起動時初期化

</details>

## データベースアクセス

MOMメッセージングにおけるデータベースアクセスの詳細については、[データベースアクセス](../../component/libraries/libraries-database_management.md) を参照。

<details>
<summary>keywords</summary>

データベースアクセス, database_management

</details>

## 入力値のチェック

MOMメッセージングにおける入力値のチェックの詳細については、[入力値のチェック](../../component/libraries/libraries-validation.md) を参照。

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, validation

</details>

## 排他制御

排他制御は2種類あるが、[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive_control.md) に記載の通り、[universal_dao](../../component/libraries/libraries-universal_dao.md) の使用を推奨する。

- [exclusive_control](../../component/libraries/libraries-exclusive_control.md)
- [universal_dao](../../component/libraries/libraries-universal_dao.md)
  - :ref:`universal_dao_jpa_pessimistic_lock`

<details>
<summary>keywords</summary>

排他制御, UniversalDao推奨, universal_dao, exclusive_control, 悲観ロック, universal_dao_jpa_pessimistic_lock

</details>

## 実行制御

- [プロセス終了コード](../../component/handlers/handlers-status_code_convert_handler.md)
- [エラー発生時にエラー応答電文を返す](../../component/libraries/libraries-mom_system_messaging.md)
- [メッセージングプロセスを異常終了させる](../db-messaging/db-messaging-error_processing.md) (テーブルをキューとして使ったメッセージングと同じ)
- [処理の並列実行(マルチスレッド化)](../../component/handlers/handlers-multi_thread_execution_handler.md)

<details>
<summary>keywords</summary>

プロセス終了コード, エラー応答電文, メッセージングプロセス異常終了, マルチスレッド並列実行, multi_thread_execution_handler

</details>

## MOMメッセージング

- [mom_system_messaging](../../component/libraries/libraries-mom_system_messaging.md)
- 標準提供のデータリーダ
  - `FwHeaderReader (電文からフレームワーク制御ヘッダの読み込み)`
  - `MessageReader (MQから電文の読み込み)`
- [再送制御](../../component/handlers/handlers-message_resend_handler.md)

<details>
<summary>keywords</summary>

MOMメッセージング, FwHeaderReader, MessageReader, 再送制御, データリーダ, mom_system_messaging

</details>

## 出力するデータの表示形式のフォーマット

データを出力する際に、:ref:`format` を使用することで日付や数値などのデータの表示形式をフォーマットできる。

<details>
<summary>keywords</summary>

データフォーマット, 日付フォーマット, 数値フォーマット, format, 表示形式フォーマット

</details>
