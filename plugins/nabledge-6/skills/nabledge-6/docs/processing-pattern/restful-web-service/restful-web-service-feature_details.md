# 機能詳細

## Nablarchの初期化

:ref:`ウェブアプリケーションのNablarchの初期化 <web_feature_details-nablarch_initialization>` を参照。

## 入力値のチェック

- :ref:`入力値のチェック <validation>`

## データベースアクセス

- :ref:`データベースアクセス <database_management>`

## 排他制御

- :ref:`universal_dao`
  - :ref:`universal_dao_jpa_optimistic_lock`
  - :ref:`universal_dao_jpa_pessimistic_lock`

> **重要**: RESTfulウェブサービスでは `ETag` や `If-Match` を使用した楽観的ロックには対応していない。RESTfulウェブサービスで楽観的ロックを行う際は、リクエストボディに直接バージョン番号を含めること。

> **重要**: :ref:`exclusive_control` 機能はクライアント(taglib)との連動が前提であるため、RESTfulウェブサービスでは使用できない。

## URIとリソース(アクション)クラスのマッピング

- :ref:`router_adaptor`
- :ref:`リソースクラスのメソッドのシグネチャ <rest_feature_details-method_signature>`

## パスパラメータやクエリーパラメータ

- :ref:`rest_feature_details-path_param`
- :ref:`rest_feature_details-query_param`

## レスポンスヘッダ

- :ref:`リソースクラスのメソッドで個別にレスポンスヘッダを設定する <rest_feature_details-response_header>`
- :ref:`jaxrs_response_handler-response_finisher`

## 国際化対応

静的リソースの多言語化対応:

- :ref:`メッセージの多言語化 <message-multi_lang>`
- :ref:`コード名称の多言語化 <code-use_multilingualization>`

## 認証

認証については、プロジェクト要件により仕様が異なるため、フレークワークとしては提供していない。

## 認可チェック

認可チェックについては、プロジェクト要件により仕様が異なるため、フレークワークとしては提供していない。

## エラー時に返却するレスポンス

- :ref:`jaxrs_response_handler-error_response_body`
- :ref:`jaxrs_response_handler-individually_error_response`

## Webアプリケーションのスケールアウト設計

- :ref:`stateless_web_app`

## CSRF対策

- :ref:`CSRF対策 <csrf_token_verification_handler>`

## CORS

- :ref:`CORS <cors_preflight_request_handler>`

## OpenAPIドキュメントからのソースコード生成

- :ref:`nablarch_openapi_generator`
