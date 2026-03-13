# 機能詳細

**公式ドキュメント**: [機能詳細](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/feature_details.html)

## Nablarchの初期化

## Nablarchの初期化

[ウェブアプリケーションのNablarchの初期化](../web-application/web-application-feature_details.md) を参照。

<details>
<summary>keywords</summary>

Nablarch初期化, RESTfulウェブサービス初期化, web_feature_details-nablarch_initialization

</details>

## 入力値のチェック

## 入力値のチェック

- [入力値のチェック](../../component/libraries/libraries-validation.md)

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, validation

</details>

## データベースアクセス

## データベースアクセス

- [データベースアクセス](../../component/libraries/libraries-database_management.md)

<details>
<summary>keywords</summary>

データベースアクセス, database_management

</details>

## 排他制御

## 排他制御

- [universal_dao](../../component/libraries/libraries-universal_dao.md)
  - :ref:`universal_dao_jpa_optimistic_lock`
  - :ref:`universal_dao_jpa_pessimistic_lock`

> **重要**: RESTfulウェブサービスでは `ETag` や `If-Match` を使用した楽観的ロックには対応していない。RESTfulウェブサービスで楽観的ロックを行う際は、リクエストボディに直接バージョン番号を含めること。

> **重要**: [exclusive_control](../../component/libraries/libraries-exclusive_control.md) 機能は、クライアント(taglib)との連動が前提であるため、RESTfulウェブサービスでは使用できない。

<details>
<summary>keywords</summary>

排他制御, 楽観的ロック, 悲観的ロック, ETag, If-Match, universal_dao, exclusive_control, バージョン番号, UniversalDao

</details>

## URIとリソース(アクション)クラスのマッピング

## URIとリソース(アクション)クラスのマッピング

- [router_adaptor](../../component/adapters/adapters-router_adaptor.md)
- [リソースクラスのメソッドのシグネチャ](restful-web-service-resource_signature.md)

<details>
<summary>keywords</summary>

URIマッピング, リソースクラス, アクションクラス, router_adaptor, resource_signature, メソッドシグネチャ, rest_feature_details-method_signature

</details>

## パスパラメータやクエリーパラメータ

## パスパラメータやクエリーパラメータ

- [rest_feature_details-path_param](restful-web-service-resource_signature.md)
- [rest_feature_details-query_param](restful-web-service-resource_signature.md)

<details>
<summary>keywords</summary>

パスパラメータ, クエリーパラメータ, rest_feature_details-path_param, rest_feature_details-query_param

</details>

## レスポンスヘッダ

## レスポンスヘッダ

- [リソースクラスのメソッドで個別にレスポンスヘッダを設定する](restful-web-service-resource_signature.md)
- [jaxrs_response_handler-response_finisher](../../component/handlers/handlers-jaxrs_response_handler.md)

<details>
<summary>keywords</summary>

レスポンスヘッダ設定, rest_feature_details-response_header, jaxrs_response_handler-response_finisher

</details>

## 国際化対応

## 国際化対応

静的リソースの多言語化対応:

- [メッセージの多言語化](../../component/libraries/libraries-message.md)
- [コード名称の多言語化](../../component/libraries/libraries-code.md)

<details>
<summary>keywords</summary>

国際化, 多言語化, メッセージ多言語化, コード名称多言語化, message-multi_lang, code-use_multilingualization

</details>

## 認証

## 認証

認証はプロジェクト要件により仕様が異なるため、フレームワークとしては提供していない。

<details>
<summary>keywords</summary>

認証, フレームワーク非提供, プロジェクト要件, RESTful認証

</details>

## 認可チェック

## 認可チェック

認可チェックはプロジェクト要件により仕様が異なるため、フレームワークとしては提供していない。

<details>
<summary>keywords</summary>

認可チェック, フレームワーク非提供, プロジェクト要件, RESTful認可

</details>

## エラー時に返却するレスポンス

## エラー時に返却するレスポンス

- [jaxrs_response_handler-error_response_body](../../component/handlers/handlers-jaxrs_response_handler.md)
- [jaxrs_response_handler-individually_error_response](../../component/handlers/handlers-jaxrs_response_handler.md)

<details>
<summary>keywords</summary>

エラーレスポンス, jaxrs_response_handler, error_response_body, individually_error_response

</details>

## Webアプリケーションのスケールアウト設計

## Webアプリケーションのスケールアウト設計

- :ref:`stateless_web_app`

<details>
<summary>keywords</summary>

スケールアウト, ステートレス, stateless_web_app, スケールアウト設計

</details>

## CSRF対策

## CSRF対策

- [CSRF対策](../../component/handlers/handlers-csrf_token_verification_handler.md)

<details>
<summary>keywords</summary>

CSRF対策, csrf_token_verification_handler, クロスサイトリクエストフォージェリ

</details>

## CORS

## CORS

- [CORS](../../component/handlers/handlers-cors_preflight_request_handler.md)

<details>
<summary>keywords</summary>

CORS, cors_preflight_request_handler, プリフライトリクエスト, クロスオリジン

</details>
