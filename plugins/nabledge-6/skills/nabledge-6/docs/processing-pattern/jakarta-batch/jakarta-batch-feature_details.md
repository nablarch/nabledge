# 機能詳細

## バッチアプリケーションの起動方法

- :ref:`Jakarta Batchアプリケーションの起動方法 <jsr352_run_batch_application>`

## システムリポジトリの初期化

- :ref:`Jakarta Batchアプリケーションでシステムリポジトリの初期化 <jsr352_run_batch_init_repository>`

## バッチジョブに適用するリスナーの定義方法

- :ref:`リスナーの定義方法 <jsr352-listener_definition>`

## 入力値のチェック

- :ref:`入力値のチェック <validation>`

## データベースアクセス

- :ref:`データベースアクセス <database_management>`
- [feature_details/database_reader](jakarta-batch-database_reader.md)

## ファイル入出力

- :ref:`ファイル入出力<data_converter>`

## 排他制御

排他制御は2種類の方法を提供しているが、:ref:`UniversalDaoを推奨する理由 <exclusive_control-deprecated>` に記載がある通り、:ref:`universal_dao` の使用を推奨する。

- :ref:`exclusive_control`
- :ref:`universal_dao`
  - [悲観的ロック](jakarta-batch-pessimistic_lock.md)

## ジョブ定義のxmlの作成方法

[Jakarta Batch Specificationを参照(外部サイト、英語)](https://jakarta.ee/specifications/batch/)

## MOMメッセージ送信

- :ref:`同期応答メッセージ送信<mom_system_messaging-sync_message_send>`

## 運用設計

- [feature_details/operation_policy](jakarta-batch-operation_policy.md)
- [feature_details/progress_log](jakarta-batch-progress_log.md)
- [feature_details/operator_notice_log](jakarta-batch-operator_notice_log.md)
