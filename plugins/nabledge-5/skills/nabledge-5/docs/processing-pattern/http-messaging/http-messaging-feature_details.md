# 機能詳細

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/http_messaging/feature_details.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/MessagingAction.html)

## Nablarchの初期化

[ウェブアプリケーションのNablarchの初期化](../web-application/web-application-feature_details.md) を参照。

<details>
<summary>keywords</summary>

Nablarchの初期化, 初期化設定, ウェブアプリケーション初期化, web_feature_details-nablarch_initialization

</details>

## 入力値のチェック

* [入力値のチェック](../../component/libraries/libraries-validation.md)

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, validation, 入力値検証

</details>

## データベースアクセス

* [データベースアクセス](../../component/libraries/libraries-database_management.md)

<details>
<summary>keywords</summary>

データベースアクセス, DB操作, database_management, データベース管理

</details>

## 排他制御

* [universal_dao](../../component/libraries/libraries-universal_dao.md)
  * :ref:`universal_dao_jpa_optimistic_lock`
  * :ref:`universal_dao_jpa_pessimistic_lock`

> **重要**: [exclusive_control](../../component/libraries/libraries-exclusive_control.md) 機能は、クライアント(taglib)との連動が前提であるため、HTTPメッセージングでは使用できない。

<details>
<summary>keywords</summary>

排他制御, 楽観ロック, 悲観ロック, UniversalDao, exclusive_control, universal_dao_jpa_optimistic_lock, universal_dao_jpa_pessimistic_lock

</details>

## URIとアクションクラスのマッピング

* [http_request_java_package_mapping](../../component/handlers/handlers-http_request_java_package_mapping.md)

> **補足**: HTTPメッセージングでは [router_adaptor](../../component/adapters/adapters-router_adaptor.md) を使用できない。HTTPメッセージングは、[mom_system_messaging](../../component/libraries/libraries-mom_system_messaging.md) が提供する `MessagingAction` でアクションクラスを作成するため、URIに応じてアクションクラスのメソッドを呼び分ける想定がないため。

<details>
<summary>keywords</summary>

URIマッピング, アクションクラス, MessagingAction, router_adaptor, http_request_java_package_mapping, mom_system_messaging

</details>

## 国際化対応

* [メッセージの多言語化](../../component/libraries/libraries-message.md)
* [コード名称の多言語化](../../component/libraries/libraries-code.md)

<details>
<summary>keywords</summary>

国際化, 多言語化, メッセージ多言語化, コード名称多言語化, message-multi_lang, code-use_multilingualization

</details>

## 認証

認証はプロジェクト要件により仕様が異なるため、フレームワークとしては提供していない。

<details>
<summary>keywords</summary>

認証, Authentication, フレームワーク非提供, プロジェクト要件

</details>

## 認可チェック

* :ref:`permission_check`

<details>
<summary>keywords</summary>

認可チェック, permission_check, 権限チェック, アクセス制御

</details>

## エラー時に返却するレスポンス

* [http_messaging_error_handler](../../component/handlers/handlers-http_messaging_error_handler.md)

<details>
<summary>keywords</summary>

エラーレスポンス, エラーハンドリング, http_messaging_error_handler, エラー応答

</details>
