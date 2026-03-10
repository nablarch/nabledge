# 機能詳細

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/mom/feature_details.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/FwHeaderReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/reader/MessageReader.html)

## アプリケーションの起動方法

MOMメッセージングアプリケーションの起動方法については、:ref:`アプリケーションの起動方法<main-run_application>` を参照。

<details>
<summary>keywords</summary>

アプリケーション起動, 起動方法, main-run_application

</details>

## システムリポジトリの初期化

システムリポジトリの初期化は、アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで行う。詳細は :ref:`アプリケーションの起動方法<main-run_application>` を参照。

<details>
<summary>keywords</summary>

システムリポジトリ初期化, 設定ファイルパス指定, アプリケーション起動時初期化

</details>

## データベースアクセス

MOMメッセージングにおけるデータベースアクセスの詳細については、:ref:`データベースアクセス <database_management>` を参照。

<details>
<summary>keywords</summary>

データベースアクセス, database_management

</details>

## 入力値のチェック

MOMメッセージングにおける入力値のチェックの詳細については、:ref:`入力値のチェック <validation>` を参照。

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, validation

</details>

## 排他制御

排他制御は2種類あるが、:ref:`UniversalDaoを推奨する理由 <exclusive_control-deprecated>` に記載の通り、:ref:`universal_dao` の使用を推奨する。

- :ref:`exclusive_control`
- :ref:`universal_dao`
  - :ref:`universal_dao_jpa_pessimistic_lock`

<details>
<summary>keywords</summary>

排他制御, UniversalDao推奨, universal_dao, exclusive_control, 悲観ロック, universal_dao_jpa_pessimistic_lock

</details>

## 実行制御

- :ref:`プロセス終了コード<status_code_convert_handler-rules>`
- :ref:`エラー発生時にエラー応答電文を返す<mom_system_messaging-sync_message_receive>`
- :ref:`メッセージングプロセスを異常終了させる <db_messaging-process_abnormal_end>` (テーブルをキューとして使ったメッセージングと同じ)
- :ref:`処理の並列実行(マルチスレッド化)<multi_thread_execution_handler>`

<details>
<summary>keywords</summary>

プロセス終了コード, エラー応答電文, メッセージングプロセス異常終了, マルチスレッド並列実行, multi_thread_execution_handler

</details>

## MOMメッセージング

- :ref:`mom_system_messaging`
- 標準提供のデータリーダ
  - `FwHeaderReader (電文からフレームワーク制御ヘッダの読み込み)`
  - `MessageReader (MQから電文の読み込み)`
- :ref:`再送制御<message_resend_handler>`

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
