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

* [JSR352バッチアプリケーションの起動](../../processing-pattern/jakarta-batch/jakarta-batch-run-batch-application.md)

* [JSR352バッチアプリケーションの起動方法](../../processing-pattern/jakarta-batch/jakarta-batch-run-batch-application.md#バッチアプリケーションを起動する)

## システムリポジトリの初期化

* [JSR352バッチアプリケーションでシステムリポジトリの初期化](../../processing-pattern/jakarta-batch/jakarta-batch-run-batch-application.md#システムリポジトリを初期化する)

## バッチジョブに適用するリスナーの定義方法

* [リスナーの定義方法](../../processing-pattern/jakarta-batch/jakarta-batch-architecture.md#リスナーの指定方法)

## 入力値のチェック

* [入力値のチェック](../../component/libraries/libraries-validation.md#入力値のチェック)

## データベースアクセス

* [データベースを入力とするChunkステップ](../../processing-pattern/jakarta-batch/jakarta-batch-database-reader.md)

* [データベースアクセス](../../component/libraries/libraries-database-management.md#データベースアクセス)
* [データベースを入力とするChunkステップ](../../processing-pattern/jakarta-batch/jakarta-batch-database-reader.md)

## ファイル入出力

* [ファイル入出力](../../component/libraries/libraries-data-converter.md#様々なフォーマットのデータへのアクセス)

## 排他制御

* [JSR352に準拠したバッチアプリケーションの悲観的ロック](../../processing-pattern/jakarta-batch/jakarta-batch-pessimistic-lock.md)

排他制御は、以下の2種類の方法を提供しているが、
[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive-control.md#排他制御) に記載がある通り、
[ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao) の使用を推奨する。

* [排他制御](../../component/libraries/libraries-exclusive-control.md#排他制御)
* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao)

  * [悲観的ロック](../../processing-pattern/jakarta-batch/jakarta-batch-pessimistic-lock.md)

## ジョブ定義のxmlの作成方法

* [JSR352 Specificationを参照(外部サイト、英語)](https://jcp.org/en/jsr/detail?id=352)

## MOMメッセージ送信

* [同期応答メッセージ送信](../../component/libraries/libraries-mom-system-messaging.md#同期応答でメッセージを送信する同期応答メッセージ送信)

## 運用設計

* [運用方針](../../processing-pattern/jakarta-batch/jakarta-batch-operation-policy.md)
* [進捗状況のログ出力](../../processing-pattern/jakarta-batch/jakarta-batch-progress-log.md)
* [運用担当者向けのログ出力](../../processing-pattern/jakarta-batch/jakarta-batch-operator-notice-log.md)

* [運用方針](../../processing-pattern/jakarta-batch/jakarta-batch-operation-policy.md)
* [進捗状況のログ出力](../../processing-pattern/jakarta-batch/jakarta-batch-progress-log.md)
* [運用担当者向けのログ出力](../../processing-pattern/jakarta-batch/jakarta-batch-operator-notice-log.md)
