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

> **重要**: :ref:`exclusive_control` 機能はクライアント（taglib）との連動が前提であるため、HTTPメッセージングでは使用できない。

## URIとアクションクラスのマッピング

- :ref:`http_request_java_package_mapping`

> **補足**: HTTPメッセージングでは :ref:`router_adaptor` を使用できない。HTTPメッセージングは :ref:`mom_system_messaging` が提供する `MessagingAction` でアクションクラスを作成するため、URIに応じてアクションクラスのメソッドを呼び分ける想定がない。

## 国際化対応

- :ref:`メッセージの多言語化 <message-multi_lang>`
- :ref:`コード名称の多言語化 <code-use_multilingualization>`

## 認証

認証はプロジェクト要件により仕様が異なるため、フレームワークとしては提供していない。

## 認可チェック

- :ref:`permission_check`

## エラー時に返却するレスポンス

- :ref:`http_messaging_error_handler`
