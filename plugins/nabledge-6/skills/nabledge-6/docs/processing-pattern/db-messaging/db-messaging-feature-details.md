# 機能詳細

**目次**

* アプリケーションの起動方法
* システムリポジトリの初期化
* データベースアクセス
* 入力値のチェック
* 排他制御
* 実行制御
* マルチプロセス化

## アプリケーションの起動方法

* [アプリケーションの起動方法](../../component/handlers/handlers-main.md#main-run-application)

## システムリポジトリの初期化

システムリポジトリの初期化は、アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで行う。
詳細は、[アプリケーションの起動方法](../../component/handlers/handlers-main.md#main-run-application) を参照。

## データベースアクセス

* [データベースアクセス](../../component/libraries/libraries-database-management.md#database-management)
* 標準提供のデータリーダ

  * DatabaseTableQueueReader (データベースのテーブルをキューとして扱うリーダ)

## 入力値のチェック

* [入力値のチェック](../../component/libraries/libraries-validation.md#validation)

## 排他制御

排他制御は、以下の2種類の方法を提供しているが、
[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive-control.md#exclusive-control-deprecated) に記載がある通り、
[ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao) の使用を推奨する。

* [排他制御](../../component/libraries/libraries-exclusive-control.md#exclusive-control)
* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao)

  * [悲観的ロックを行う](../../component/libraries/libraries-universal-dao.md#universal-dao-jpa-pessimistic-lock)

## 実行制御

feature_details/error_processing

* [プロセス終了コード](../../component/handlers/handlers-status-code-convert-handler.md#status-code-convert-handler-rules)
* [エラー発生データを除外して処理を継続する](../../processing-pattern/db-messaging/db-messaging-error-processing.md#db-messaging-exclude-error-data)
* [メッセージングプロセスを異常終了させる](../../processing-pattern/db-messaging/db-messaging-error-processing.md#db-messaging-process-abnormal-end)
* [処理の並列実行(マルチスレッド化)](../../component/handlers/handlers-multi-thread-execution-handler.md#multi-thread-execution-handler)

## マルチプロセス化

feature_details/multiple_process

* [マルチプロセス化](../../processing-pattern/db-messaging/db-messaging-multiple-process.md#db-messaging-multiple-process)
