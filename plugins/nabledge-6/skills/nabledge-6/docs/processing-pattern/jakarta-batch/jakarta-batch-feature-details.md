# 機能詳細

**目次**

* バッチアプリケーションの起動方法
* システムリポジトリの初期化
* バッチジョブに適用するリスナーの定義方法
* 入力値のチェック
* データベースアクセス
* ファイル入出力
* 排他制御
* ジョブ定義のxmlの作成方法
* MOMメッセージ送信
* 運用設計

## バッチアプリケーションの起動方法

feature_details/run_batch_application

* [Jakarta Batchアプリケーションの起動方法](../../processing-pattern/jakarta-batch/jakarta-batch-run-batch-application.md#jsr352-run-batch-application)

## システムリポジトリの初期化

* [Jakarta Batchアプリケーションでシステムリポジトリの初期化](../../processing-pattern/jakarta-batch/jakarta-batch-run-batch-application.md#jsr352-run-batch-init-repository)

## バッチジョブに適用するリスナーの定義方法

* [リスナーの定義方法](../../processing-pattern/jakarta-batch/jakarta-batch-architecture.md#jsr352-listener-definition)

## 入力値のチェック

* [入力値のチェック](../../component/libraries/libraries-validation.md#validation)

## データベースアクセス

feature_details/database_reader

* [データベースアクセス](../../component/libraries/libraries-database-management.md#database-management)
* [データベースを入力とするChunkステップ](../../processing-pattern/jakarta-batch/jakarta-batch-database-reader.md)

## ファイル入出力

* [ファイル入出力](../../component/libraries/libraries-data-converter.md#data-converter)

## 排他制御

feature_details/pessimistic_lock

排他制御は、以下の2種類の方法を提供しているが、
[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive-control.md#exclusive-control-deprecated) に記載がある通り、
[ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao) の使用を推奨する。

* [排他制御](../../component/libraries/libraries-exclusive-control.md#exclusive-control)
* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao)

  * [悲観的ロック](../../processing-pattern/jakarta-batch/jakarta-batch-pessimistic-lock.md)

## ジョブ定義のxmlの作成方法

* [Jakarta Batch Specificationを参照(外部サイト、英語)](https://jakarta.ee/specifications/batch/)

## MOMメッセージ送信

* [同期応答メッセージ送信](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-sync-message-send)

## 運用設計

feature_details/operation_policy
feature_details/progress_log
feature_details/operator_notice_log

* [運用方針](../../processing-pattern/jakarta-batch/jakarta-batch-operation-policy.md)
* [進捗状況のログ出力](../../processing-pattern/jakarta-batch/jakarta-batch-progress-log.md)
* [運用担当者向けのログ出力](../../processing-pattern/jakarta-batch/jakarta-batch-operator-notice-log.md)
