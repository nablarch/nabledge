# 機能詳細

## アプリケーションの起動方法

MOMメッセージングアプリケーションの起動方法については、:ref:`アプリケーションの起動方法<main-run_application>` を参照。

## システムリポジトリの初期化

システムリポジトリの初期化は、アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで行う。詳細は :ref:`アプリケーションの起動方法<main-run_application>` を参照。

## データベースアクセス

MOMメッセージングにおけるデータベースアクセスの詳細については、:ref:`データベースアクセス <database_management>` を参照。

## 入力値のチェック

MOMメッセージングにおける入力値のチェックの詳細については、:ref:`入力値のチェック <validation>` を参照。

## 排他制御

排他制御は2種類あるが、:ref:`UniversalDaoを推奨する理由 <exclusive_control-deprecated>` に記載の通り、:ref:`universal_dao` の使用を推奨する。

- :ref:`exclusive_control`
- :ref:`universal_dao`
  - :ref:`universal_dao_jpa_pessimistic_lock`

## 実行制御

- :ref:`プロセス終了コード<status_code_convert_handler-rules>`
- :ref:`エラー発生時にエラー応答電文を返す<mom_system_messaging-sync_message_receive>`
- :ref:`メッセージングプロセスを異常終了させる <db_messaging-process_abnormal_end>` (テーブルをキューとして使ったメッセージングと同じ)
- :ref:`処理の並列実行(マルチスレッド化)<multi_thread_execution_handler>`

## MOMメッセージング

- :ref:`mom_system_messaging`
- 標準提供のデータリーダ
  - `FwHeaderReader (電文からフレームワーク制御ヘッダの読み込み)`
  - `MessageReader (MQから電文の読み込み)`
- :ref:`再送制御<message_resend_handler>`

## 出力するデータの表示形式のフォーマット

データを出力する際に、:ref:`format` を使用することで日付や数値などのデータの表示形式をフォーマットできる。
