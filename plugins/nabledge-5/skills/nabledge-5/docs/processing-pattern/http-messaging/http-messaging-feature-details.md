# 機能詳細

**目次**

* Nablarchの初期化
* 入力値のチェック
* データベースアクセス
* 排他制御
* URIとアクションクラスのマッピング
* 国際化対応
* 認証
* 認可チェック
* エラー時に返却するレスポンス

## Nablarchの初期化

[ウェブアプリケーションのNablarchの初期化](../../processing-pattern/web-application/web-application-feature-details.md#nablarchの初期化) を参照。

## 入力値のチェック

* [入力値のチェック](../../component/libraries/libraries-validation.md#入力値のチェック)

## データベースアクセス

* [データベースアクセス](../../component/libraries/libraries-database-management.md#データベースアクセス)

## 排他制御

* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao)

  * [楽観的ロックを行う](../../component/libraries/libraries-universal-dao.md#楽観的ロックを行う)
  * [悲観的ロックを行う](../../component/libraries/libraries-universal-dao.md#悲観的ロックを行う)

> **Important:**
> [排他制御](../../component/libraries/libraries-exclusive-control.md#排他制御) 機能は、クライアント(taglib)との連動が前提であるため、
> HTTPメッセージングでは使用できない。

## URIとアクションクラスのマッピング

* [HTTPリクエストディスパッチハンドラ](../../component/handlers/handlers-http-request-java-package-mapping.md#httpリクエストディスパッチハンドラ)

> **Tip:**
> HTTPメッセージングでは [ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#ルーティングアダプタ) を使用できない。
> HTTPメッセージングは、[MOMメッセージング](../../component/libraries/libraries-mom-system-messaging.md#momメッセージング) が提供する
> MessagingAction
> でアクションクラスを作成するため、URIに応じてアクションクラスのメソッドを呼び分ける想定がないため。

## 国際化対応

静的リソースの多言語化対応については以下を参照。

* [メッセージの多言語化](../../component/libraries/libraries-message.md#多言語化対応)
* [コード名称の多言語化](../../component/libraries/libraries-code.md#名称の多言語化対応)

## 認証

認証については、プロジェクト要件により仕様が異なるため、フレークワークとしては提供していない。

## 認可チェック

* [ハンドラによる認可チェック](../../component/libraries/libraries-authorization-permission-check.md#ハンドラによる認可チェック)

## エラー時に返却するレスポンス

* [HTTPメッセージングエラー制御ハンドラ](../../component/handlers/handlers-http-messaging-error-handler.md#httpメッセージングエラー制御ハンドラ)
