# 機能詳細

**目次**

* Nablarchの初期化
* 入力値のチェック
* データベースアクセス
* 排他制御
* URIとリソース(アクション)クラスのマッピング
* パスパラメータやクエリーパラメータ
* レスポンスヘッダ
* 国際化対応
* 認証
* 認可チェック
* エラー時に返却するレスポンス
* Webアプリケーションのスケールアウト設計
* CSRF対策
* CORS
* OpenAPIドキュメントからのソースコード生成

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
> RESTfulウェブサービスでは ETag や If-Match を使用した楽観的ロックには対応していない。
> そのため、RESTfulウェブサービスで楽観的ロックを行う際は、リクエストボディに直接バージョン番号を含めること。

> **Important:**
> [排他制御](../../component/libraries/libraries-exclusive-control.md#排他制御) 機能は、クライアント(taglib)との連動が前提であるため、
> RESTfulウェブサービスでは使用できない。

## URIとリソース(アクション)クラスのマッピング

feature_details/resource_signature

* [ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#ルーティングアダプタ)
* [リソースクラスのメソッドのシグネチャ](../../processing-pattern/restful-web-service/restful-web-service-resource-signature.md#リソースクラスのメソッドのシグネチャ)

## パスパラメータやクエリーパラメータ

* [パスパラメータを扱う](../../processing-pattern/restful-web-service/restful-web-service-resource-signature.md#パスパラメータを扱う)
* [クエリーパラメータを扱う](../../processing-pattern/restful-web-service/restful-web-service-resource-signature.md#クエリーパラメータを扱う)

## レスポンスヘッダ

* [リソースクラスのメソッドで個別にレスポンスヘッダを設定する](../../processing-pattern/restful-web-service/restful-web-service-resource-signature.md#レスポンスヘッダを設定する)
* [クライアントに返すレスポンスに共通処理を追加する](../../component/handlers/handlers-jaxrs-response-handler.md#クライアントに返すレスポンスに共通処理を追加する)

## 国際化対応

静的リソースの多言語化対応については以下を参照。

* [メッセージの多言語化](../../component/libraries/libraries-message.md#多言語化対応)
* [コード名称の多言語化](../../component/libraries/libraries-code.md#名称の多言語化対応)

## 認証

認証については、プロジェクト要件により仕様が異なるため、フレークワークとしては提供していない。

## 認可チェック

認可チェックについては、プロジェクト要件により仕様が異なるため、フレークワークとしては提供していない。

## エラー時に返却するレスポンス

* [エラー時のレスポンスにメッセージを設定する](../../component/handlers/handlers-jaxrs-response-handler.md#エラー時のレスポンスにメッセージを設定する)
* [特定のエラーの場合に個別に定義したエラーレスポンスを返却する](../../component/handlers/handlers-jaxrs-response-handler.md#特定のエラーの場合に個別に定義したエラーレスポンスを返却する)

## Webアプリケーションのスケールアウト設計

* [Webアプリケーションをステートレスにする](../../component/libraries/libraries-stateless-web-app.md#webアプリケーションをステートレスにする)

## CSRF対策

* [CSRF対策](../../component/handlers/handlers-csrf-token-verification-handler.md#csrfトークン検証ハンドラ)

## CORS

* [CORS](../../component/handlers/handlers-cors-preflight-request-handler.md#corsプリフライトリクエストハンドラ)

## OpenAPIドキュメントからのソースコード生成

* [Nablarch OpenAPI Generator](../../development-tools/toolbox/toolbox-NablarchOpenApiGenerator.md#nablarch-openapi-generator)
