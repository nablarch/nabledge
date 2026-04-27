# 機能詳細

**目次**

* バッチアプリケーションの起動方法
* システムリポジトリの初期化
* 入力値のチェック
* データベースアクセス
* ファイル入出力
* 排他制御
* バッチ処理の実行制御
* MOMメッセージ送信
* バッチ実行中の状態の保持
* 常駐バッチのマルチプロセス化

## バッチアプリケーションの起動方法

* [Nablarchバッチアプリケーションの起動方法](../../component/handlers/handlers-main.md#main-run-application)

## システムリポジトリの初期化

システムリポジトリの初期化は、アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで行う。
詳細は、[Nablarchバッチアプリケーションの起動方法](../../component/handlers/handlers-main.md#main-run-application) を参照。

## 入力値のチェック

* [入力値のチェック](../../component/libraries/libraries-validation.md#validation)

## データベースアクセス

* [データベースアクセス](../../component/libraries/libraries-database-management.md#database-management)
* 標準提供のデータリーダ

  * DatabaseRecordReader (データベース読み込み)

## ファイル入出力

* [ファイル入出力](../../component/libraries/libraries-data-converter.md#data-converter)
* 標準提供のデータリーダ

  * FileDataReader (ファイル読み込み)
  * ValidatableFileDataReader (バリデージョン機能付きファイル読み込み)
  * ResumeDataReader (レジューム機能付き読み込み)

## 排他制御

feature_details/nablarch_batch_pessimistic_lock

排他制御は、以下の2種類の方法を提供しているが、
[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive-control.md#exclusive-control-deprecated) に記載がある通り、
[ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao) の使用を推奨する。

* [排他制御](../../component/libraries/libraries-exclusive-control.md#exclusive-control)
* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao)

  * [悲観的ロック](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-pessimistic-lock.md#nablarch-batch-pessimistic-lock)

## バッチ処理の実行制御

feature_details/nablarch_batch_error_process
feature_details/nablarch_batch_retention_state

* [バッチ処理のプロセス終了コード](../../component/handlers/handlers-status-code-convert-handler.md#status-code-convert-handler-rules)
* [バッチ処理のエラー処理](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-error-process.md#nablarch-batch-error-process)
* [バッチ処理の並列実行(マルチスレッド化)](../../component/handlers/handlers-multi-thread-execution-handler.md#multi-thread-execution-handler)
* [バッチ処理のコミット間隔の制御](../../component/handlers/handlers-loop-handler.md#loop-handler-commit-interval)
* [1回のバッチ処理の処理件数制限](../../component/handlers/handlers-data-read-handler.md#data-read-handler-max-count)
  
   (大量データを処理するバッチ処理を数日に分けて処理させる場合など)

## MOMメッセージ送信

* [同期応答メッセージ送信](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-sync-message-send)
* [応答不要メッセージ送信](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-async-message-send)

## バッチ実行中の状態の保持

feature_details/nablarch_batch_retention_state

* [バッチアプリケーションで実行中の状態を保持する](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-retention-state.md#nablarch-batch-retention-state)

## 常駐バッチのマルチプロセス化

feature_details/nablarch_batch_multiple_process

* [常駐バッチアプリケーションのマルチプロセス化](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-multiple-process.md#nablarch-batch-multiple-process)
