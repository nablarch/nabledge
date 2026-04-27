# 機能詳細

**目次**

* アプリケーションの起動方法
* システムリポジトリの初期化
* データベースアクセス
* 入力値のチェック
* 排他制御
* 実行制御
* MOMメッセージング
* 出力するデータの表示形式のフォーマット

## アプリケーションの起動方法

* [アプリケーションの起動方法](../../component/handlers/handlers-main.md#main-run-application)

## システムリポジトリの初期化

システムリポジトリの初期化は、アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで行う。
詳細は、[アプリケーションの起動方法](../../component/handlers/handlers-main.md#main-run-application) を参照。

## データベースアクセス

* [データベースアクセス](../../component/libraries/libraries-database-management.md#database-management)

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

* [プロセス終了コード](../../component/handlers/handlers-status-code-convert-handler.md#status-code-convert-handler-rules)
* [エラー発生時にエラー応答電文を返す](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-sync-message-receive)
* [メッセージングプロセスを異常終了させる](../../processing-pattern/db-messaging/db-messaging-error-processing.md#db-messaging-process-abnormal-end) (テーブルをキューとして使ったメッセージングと同じ)
* [処理の並列実行(マルチスレッド化)](../../component/handlers/handlers-multi-thread-execution-handler.md#multi-thread-execution-handler)

## MOMメッセージング

* [MOMメッセージング](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging)
* 標準提供のデータリーダ

  * FwHeaderReader (電文からフレームワーク制御ヘッダの読み込み)
  * MessageReader (MQから電文の読み込み)
* [再送制御](../../component/handlers/handlers-message-resend-handler.md#message-resend-handler)

## 出力するデータの表示形式のフォーマット

データを出力する際に、 [フォーマッタ](../../component/libraries/libraries-format.md#format) を使用することで日付や数値などのデータの表示形式をフォーマットできる。
詳細は [フォーマッタ](../../component/libraries/libraries-format.md#format) を参照。
