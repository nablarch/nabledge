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

* [アプリケーションの起動方法](../../component/handlers/handlers-main.md#アプリケーションを起動する)

## システムリポジトリの初期化

システムリポジトリの初期化は、アプリケーション起動時にシステムリポジトリの設定ファイルのパスを指定することで行う。
詳細は、[アプリケーションの起動方法](../../component/handlers/handlers-main.md#アプリケーションを起動する) を参照。

## データベースアクセス

* [データベースアクセス](../../component/libraries/libraries-database-management.md#データベースアクセス)

## 入力値のチェック

* [入力値のチェック](../../component/libraries/libraries-validation.md#入力値のチェック)

## 排他制御

排他制御は、以下の2種類の方法を提供しているが、
[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive-control.md#排他制御) に記載がある通り、
[ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao) の使用を推奨する。

* [排他制御](../../component/libraries/libraries-exclusive-control.md#排他制御)
* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao)

  * [悲観的ロックを行う](../../component/libraries/libraries-universal-dao.md#悲観的ロックを行う)

## 実行制御

* [プロセス終了コード](../../component/handlers/handlers-status-code-convert-handler.md#ステータスコードプロセス終了コード変換)
* [エラー発生時にエラー応答電文を返す](../../component/libraries/libraries-mom-system-messaging.md#同期応答でメッセージを受信する同期応答メッセージ受信)
* [メッセージングプロセスを異常終了させる](../../processing-pattern/db-messaging/db-messaging-error-processing.md#プロセスを異常終了させる) (テーブルをキューとして使ったメッセージングと同じ)
* [処理の並列実行(マルチスレッド化)](../../component/handlers/handlers-multi-thread-execution-handler.md#マルチスレッド実行制御ハンドラ)

## MOMメッセージング

* [MOMメッセージング](../../component/libraries/libraries-mom-system-messaging.md#momメッセージング)
* 標準提供のデータリーダ

  * FwHeaderReader (電文からフレームワーク制御ヘッダの読み込み)
  * MessageReader (MQから電文の読み込み)
* [再送制御](../../component/handlers/handlers-message-resend-handler.md#再送電文制御ハンドラ)

## 出力するデータの表示形式のフォーマット

データを出力する際に、 [フォーマッタ](../../component/libraries/libraries-format.md#フォーマッタ) を使用することで日付や数値などのデータの表示形式をフォーマットできる。
詳細は [フォーマッタ](../../component/libraries/libraries-format.md#フォーマッタ) を参照。
