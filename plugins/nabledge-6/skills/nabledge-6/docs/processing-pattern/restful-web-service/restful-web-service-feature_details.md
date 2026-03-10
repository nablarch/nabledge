# 機能詳細

**公式ドキュメント**: [機能詳細](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/feature_details.html)

## Nablarchの初期化

:ref:`ウェブアプリケーションのNablarchの初期化 <web_feature_details-nablarch_initialization>` を参照。

<details>
<summary>keywords</summary>

Nablarch初期化, ウェブアプリケーション初期化, web_feature_details-nablarch_initialization

</details>

## 入力値のチェック

- :ref:`入力値のチェック <validation>`

<details>
<summary>keywords</summary>

バリデーション, 入力値チェック, validation, rest-request_validation

</details>

## データベースアクセス

- :ref:`データベースアクセス <database_management>`

<details>
<summary>keywords</summary>

データベースアクセス, database_management

</details>

## 排他制御

- :ref:`universal_dao`
  - :ref:`universal_dao_jpa_optimistic_lock`
  - :ref:`universal_dao_jpa_pessimistic_lock`

> **重要**: RESTfulウェブサービスでは `ETag` や `If-Match` を使用した楽観的ロックには対応していない。RESTfulウェブサービスで楽観的ロックを行う際は、リクエストボディに直接バージョン番号を含めること。

> **重要**: :ref:`exclusive_control` 機能はクライアント(taglib)との連動が前提であるため、RESTfulウェブサービスでは使用できない。

<details>
<summary>keywords</summary>

排他制御, 楽観的ロック, 悲観的ロック, universal_dao, exclusive_control, universal_dao_jpa_optimistic_lock, universal_dao_jpa_pessimistic_lock, ETag, If-Match, バージョン番号

</details>

## URIとリソース(アクション)クラスのマッピング

- :ref:`router_adaptor`
- :ref:`リソースクラスのメソッドのシグネチャ <rest_feature_details-method_signature>`

<details>
<summary>keywords</summary>

URIマッピング, リソースクラス, router_adaptor, メソッドシグネチャ, resource_signature, rest-action_mapping

</details>

## パスパラメータやクエリーパラメータ

- :ref:`rest_feature_details-path_param`
- :ref:`rest_feature_details-query_param`

<details>
<summary>keywords</summary>

パスパラメータ, クエリーパラメータ, rest_feature_details-path_param, rest_feature_details-query_param, rest-path_query_param

</details>

## レスポンスヘッダ

- :ref:`リソースクラスのメソッドで個別にレスポンスヘッダを設定する <rest_feature_details-response_header>`
- :ref:`jaxrs_response_handler-response_finisher`

<details>
<summary>keywords</summary>

レスポンスヘッダ設定, jaxrs_response_handler, jaxrs_response_handler-response_finisher, rest_feature_details-response_header

</details>

## 国際化対応

静的リソースの多言語化対応:

- :ref:`メッセージの多言語化 <message-multi_lang>`
- :ref:`コード名称の多言語化 <code-use_multilingualization>`

<details>
<summary>keywords</summary>

国際化, 多言語化, メッセージ多言語化, コード名称多言語化, message-multi_lang, code-use_multilingualization

</details>

## 認証

認証については、プロジェクト要件により仕様が異なるため、フレークワークとしては提供していない。

<details>
<summary>keywords</summary>

認証, フレームワーク未提供, プロジェクト要件

</details>

## 認可チェック

認可チェックについては、プロジェクト要件により仕様が異なるため、フレークワークとしては提供していない。

<details>
<summary>keywords</summary>

認可, 認可チェック, フレームワーク未提供, プロジェクト要件

</details>

## エラー時に返却するレスポンス

- :ref:`jaxrs_response_handler-error_response_body`
- :ref:`jaxrs_response_handler-individually_error_response`

<details>
<summary>keywords</summary>

エラーレスポンス, jaxrs_response_handler, jaxrs_response_handler-error_response_body, jaxrs_response_handler-individually_error_response, エラーレスポンスボディ, 個別エラーレスポンス

</details>

## Webアプリケーションのスケールアウト設計

- :ref:`stateless_web_app`

<details>
<summary>keywords</summary>

スケールアウト, ステートレス, stateless_web_app

</details>

## CSRF対策

- :ref:`CSRF対策 <csrf_token_verification_handler>`

<details>
<summary>keywords</summary>

CSRF, CSRF対策, csrf_token_verification_handler

</details>

## CORS

- :ref:`CORS <cors_preflight_request_handler>`

<details>
<summary>keywords</summary>

CORS, プリフライトリクエスト, cors_preflight_request_handler

</details>

## OpenAPIドキュメントからのソースコード生成

- :ref:`nablarch_openapi_generator`

<details>
<summary>keywords</summary>

OpenAPI, ソースコード生成, nablarch_openapi_generator, OpenAPIドキュメント

</details>
