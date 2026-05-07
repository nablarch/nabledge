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

* [Nablarchバッチアプリケーションの起動方法](../../component/handlers/handlers-main.md#アプリケーションを起動する)

## システムリポジトリの初期化

システムリポジトリの初期化は、アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで行う。
詳細は、[Nablarchバッチアプリケーションの起動方法](../../component/handlers/handlers-main.md#アプリケーションを起動する) を参照。

## 入力値のチェック

* [入力値のチェック](../../component/libraries/libraries-validation.md#入力値のチェック)

## データベースアクセス

* [データベースアクセス](../../component/libraries/libraries-database-management.md#データベースアクセス)
* 標準提供のデータリーダ

  * DatabaseRecordReader (データベース読み込み)

## ファイル入出力

* [ファイル入出力](../../component/libraries/libraries-data-converter.md#様々なフォーマットのデータへのアクセス)
* 標準提供のデータリーダ

  * FileDataReader (ファイル読み込み)
  * ValidatableFileDataReader (バリデージョン機能付きファイル読み込み)
  * ResumeDataReader (レジューム機能付き読み込み)

## 排他制御

* [Nablarchバッチアプリケーションの悲観的ロック](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-pessimistic-lock.md)

排他制御は、以下の2種類の方法を提供しているが、
[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive-control.md#排他制御) に記載がある通り、
[ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao) の使用を推奨する。

* [排他制御](../../component/libraries/libraries-exclusive-control.md#排他制御)
* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao)

  * [悲観的ロック](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-pessimistic-lock.md#nablarchバッチアプリケーションの悲観的ロック)

## バッチ処理の実行制御

* [Nablarchバッチアプリケーションのエラー処理](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-error-process.md)
* [バッチアプリケーションで実行中の状態を保持する](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-retention-state.md)

* [バッチ処理のプロセス終了コード](../../component/handlers/handlers-status-code-convert-handler.md#ステータスコードプロセス終了コード変換)
* [バッチ処理のエラー処理](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-error-process.md#nablarchバッチアプリケーションのエラー処理)
* [バッチ処理の並列実行(マルチスレッド化)](../../component/handlers/handlers-multi-thread-execution-handler.md#マルチスレッド実行制御ハンドラ)
* [バッチ処理のコミット間隔の制御](../../component/handlers/handlers-loop-handler.md#コミット間隔を指定する)
* [1回のバッチ処理の処理件数制限](../../component/handlers/handlers-data-read-handler.md#最大処理件数の設定)
  
   (大量データを処理するバッチ処理を数日に分けて処理させる場合など)

## MOMメッセージ送信

* [同期応答メッセージ送信](../../component/libraries/libraries-mom-system-messaging.md#同期応答でメッセージを送信する同期応答メッセージ送信)
* [応答不要メッセージ送信](../../component/libraries/libraries-mom-system-messaging.md#応答不要でメッセージを送信する応答不要メッセージ送信)

## バッチ実行中の状態の保持

* [バッチアプリケーションで実行中の状態を保持する](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-retention-state.md)

* [バッチアプリケーションで実行中の状態を保持する](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-retention-state.md#バッチアプリケーションで実行中の状態を保持する)

## 常駐バッチのマルチプロセス化

* [常駐バッチアプリケーションのマルチプロセス化](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-multiple-process.md)

* [常駐バッチアプリケーションのマルチプロセス化](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-multiple-process.md#常駐バッチアプリケーションのマルチプロセス化)
