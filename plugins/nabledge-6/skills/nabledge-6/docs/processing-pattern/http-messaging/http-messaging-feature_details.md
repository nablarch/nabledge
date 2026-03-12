# 機能詳細

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/http_messaging/feature_details.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/MessagingAction.html)

## Nablarchの初期化

[ウェブアプリケーションのNablarchの初期化](../web-application/web-application-feature_details.md) を参照。

<details>
<summary>keywords</summary>

Nablarch初期化, ウェブアプリケーション初期化, web_feature_details-nablarch_initialization

</details>

## 入力値のチェック

- [入力値のチェック](../../component/libraries/libraries-validation.md)

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, validation

</details>

## データベースアクセス

- [データベースアクセス](../../component/libraries/libraries-database_management.md)

<details>
<summary>keywords</summary>

データベースアクセス, database_management

</details>

## 排他制御

- [universal_dao](../../component/libraries/libraries-universal_dao.md)
  - :ref:`universal_dao_jpa_optimistic_lock`
  - :ref:`universal_dao_jpa_pessimistic_lock`

> **重要**: [exclusive_control](../../component/libraries/libraries-exclusive_control.md) 機能はクライアント（taglib）との連動が前提であるため、HTTPメッセージングでは使用できない。

<details>
<summary>keywords</summary>

排他制御, 楽観的排他制御, 悲観的排他制御, UniversalDao, universal_dao_jpa_optimistic_lock, universal_dao_jpa_pessimistic_lock, exclusive_control使用不可

</details>

## URIとアクションクラスのマッピング

- [http_request_java_package_mapping](../../component/handlers/handlers-http_request_java_package_mapping.md)

> **補足**: HTTPメッセージングでは [router_adaptor](../../component/adapters/adapters-router_adaptor.md) を使用できない。HTTPメッセージングは [mom_system_messaging](../../component/libraries/libraries-mom_system_messaging.md) が提供する `MessagingAction` でアクションクラスを作成するため、URIに応じてアクションクラスのメソッドを呼び分ける想定がない。

<details>
<summary>keywords</summary>

URIマッピング, アクションクラス, MessagingAction, mom_system_messaging, router_adaptor使用不可, http_request_java_package_mapping

</details>

## 国際化対応

- [メッセージの多言語化](../../component/libraries/libraries-message.md)
- [コード名称の多言語化](../../component/libraries/libraries-code.md)

<details>
<summary>keywords</summary>

国際化, 多言語化, メッセージ多言語化, コード名称多言語化

</details>

## 認証

認証はプロジェクト要件により仕様が異なるため、フレームワークとしては提供していない。

<details>
<summary>keywords</summary>

認証, フレームワーク未提供, プロジェクト要件

</details>

## 認可チェック

- :ref:`permission_check`

<details>
<summary>keywords</summary>

認可チェック, permission_check, パーミッションチェック

</details>

## エラー時に返却するレスポンス

- [http_messaging_error_handler](../../component/handlers/handlers-http_messaging_error_handler.md)

<details>
<summary>keywords</summary>

エラーレスポンス, http_messaging_error_handler, エラーハンドラ

</details>
