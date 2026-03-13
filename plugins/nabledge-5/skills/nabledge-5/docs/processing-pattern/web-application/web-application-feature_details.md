# 機能詳細

**公式ドキュメント**: [機能詳細](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details.html)

## Nablarchの初期化

Nablarchの初期化には以下の2つの設定が必要:

- [システムリポジトリのロードの為の設定](web-application-nablarch_servlet_context_listener.md)
- [ハンドラキューの設定(構築)](web-application-web_front_controller.md)

<details>
<summary>keywords</summary>

Nablarchの初期化, nablarch_servlet_context_listener, web_front_controller, システムリポジトリ, ハンドラキュー設定

</details>

## 入力値のチェック

- [入力値のチェック](../../component/libraries/libraries-validation.md)
- [エラーメッセージの画面表示](web-application-error_message.md)

<details>
<summary>keywords</summary>

入力値チェック, バリデーション, エラーメッセージ, validation, error_message

</details>

## データベースアクセス

- [データベースアクセス](../../component/libraries/libraries-database_management.md)

<details>
<summary>keywords</summary>

データベースアクセス, database_management

</details>

## 排他制御

[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive_control.md) に記載がある通り、[universal_dao](../../component/libraries/libraries-universal_dao.md) の使用を推奨する。

- [exclusive_control](../../component/libraries/libraries-exclusive_control.md)
- [universal_dao](../../component/libraries/libraries-universal_dao.md)（推奨）
  - :ref:`universal_dao_jpa_optimistic_lock`
  - :ref:`universal_dao_jpa_pessimistic_lock`

<details>
<summary>keywords</summary>

排他制御, UniversalDao, exclusive_control, universal_dao, 楽観ロック, 悲観ロック, universal_dao_jpa_optimistic_lock, universal_dao_jpa_pessimistic_lock

</details>

## ファイルアップロード

- [multipart_handler-read_upload_file](../../component/handlers/handlers-multipart_handler.md)

<details>
<summary>keywords</summary>

ファイルアップロード, マルチパート, multipart_handler, multipart_handler-read_upload_file

</details>

## ファイルダウンロード

[データバインドを推奨する理由](../../component/libraries/libraries-data_converter.md) に記載がある通り、[data_bind](../../component/libraries/libraries-data_bind.md) の使用を推奨する。

- [データバインド機能を使用したファイルダウンロード](../../component/libraries/libraries-data_bind.md)（推奨）
- [汎用データフォーマット機能を使用したファイルダウンロード](../../component/libraries/libraries-data_format.md)

> **重要**: 大量データのダウンロード時には [universal_dao-lazy_load](../../component/libraries/libraries-universal_dao.md) を参照し、データベースの検索結果をヒープ上に展開しないように注意すること。

<details>
<summary>keywords</summary>

ファイルダウンロード, データバインド, data_bind, data_format, 大量データダウンロード, lazy_load, universal_dao-lazy_load

</details>

## URIとアクションクラスのマッピング

[ルーティングアダプタが推奨である理由](../../component/handlers/handlers-http_request_java_package_mapping.md) に記載がある通り、[router_adaptor](../../component/adapters/adapters-router_adaptor.md) の使用を推奨する。

- [router_adaptor](../../component/adapters/adapters-router_adaptor.md)（推奨）
- [http_request_java_package_mapping](../../component/handlers/handlers-http_request_java_package_mapping.md)

<details>
<summary>keywords</summary>

URIマッピング, ルーティング, router_adaptor, http_request_java_package_mapping, アクションクラス

</details>

## 2重サブミット防止

- :ref:`2重サブミット防止 <tag-double_submission>`

JSP以外のテンプレートエンジンを使用している場合は [use_token_interceptor](../../component/handlers/handlers-use_token.md) も参照すること。

<details>
<summary>keywords</summary>

2重サブミット防止, tag-double_submission, use_token_interceptor, テンプレートエンジン

</details>

## 入力データの保持

- :ref:`session_store`

<details>
<summary>keywords</summary>

セッションストア, 入力データ保持, session_store

</details>

## ページネーション

データベースから範囲を指定して検索する方法は [database_management](../../component/libraries/libraries-database_management.md) を参照。

クライアントサイドについては、プロジェクト要件により仕様が異なるため、フレームワークとしては提供していない。

<details>
<summary>keywords</summary>

ページネーション, データベース範囲検索, database_management, クライアントサイド

</details>

## 画面の作成

- JSPを使用する場合
  - :ref:`JSPのtaglibを使用した画面開発 <tag>`
  - [jsp_session](web-application-jsp_session.md)
- JSP以外のテンプレートエンジンを使用する場合
  - [Thymeleafを使用した画面開発](../../component/adapters/adapters-web_thymeleaf_adaptor.md)
  - [view_freemarker](web-application-freemarker.md)
  - [view_other](web-application-other.md)

<details>
<summary>keywords</summary>

画面作成, JSP, taglib, Thymeleaf, FreeMarker, テンプレートエンジン, view_freemarker, view_other, web_thymeleaf_adaptor, jsp_session

</details>

## 国際化対応

静的リソースの多言語化対応:

- [メッセージの多言語化](../../component/libraries/libraries-message.md)
- [コード名称の多言語化](../../component/libraries/libraries-code.md)

画面表示する文言の言語切り替え方法（2種類）:

- :ref:`メッセージタグでの国際化対応 <tag-write_message>`
- [言語ごとにリソースのパスを切り替える](../../component/libraries/libraries-tag.md)

> **警告**: :ref:`メッセージタグでの国際化対応 <tag-write_message>` を使用した場合、画面レイアウトが崩れる可能性がある。レイアウト崩れを許容できる場合のみ使用すること。

<details>
<summary>keywords</summary>

国際化, 多言語化, message-multi_lang, code-use_multilingualization, tag-write_message, レイアウト崩れ, 言語切り替え

</details>

## 認証

認証はプロジェクト要件により仕様が異なるため、フレームワークとしては提供していない。[authentication](../../guide/biz-samples/biz-samples-01.md) を参考にプロジェクト要件に合わせて実装すること。

認証情報の保持: :ref:`session_store-authentication_data`

<details>
<summary>keywords</summary>

認証, authentication, session_store-authentication_data, 認証情報保持

</details>

## 認可チェック

- :ref:`permission_check`

<details>
<summary>keywords</summary>

認可, 権限チェック, permission_check

</details>

## ステータスコード

- [ステータスコードの使い分け(外部サイト)](https://qiita.com/kawasima/items/e48180041ace99842779)

<details>
<summary>keywords</summary>

ステータスコード, HTTPステータス, ステータスコードの使い分け

</details>

## エラー時の画面遷移とステータスコード

- :ref:`ステータスコードに対応したデフォルトの遷移先ページを設定する <HttpErrorHandler_DefaultPage>`
- [ハンドラで例外クラスに対応したエラーページに遷移させる](web-application-forward_error_page.md)
- アクションでエラー時の遷移先を指定する
  - 例外クラスに対応した遷移先を定義する（[on_error_interceptor](../../component/handlers/handlers-on_error.md)、[on_errors_interceptor](../../component/handlers/handlers-on_errors.md)）
  - [1つの例外に対して複数の遷移先を定義する](web-application-forward_error_page.md)
- [ステータスコードの使い分け(外部サイト)](https://qiita.com/kawasima/items/e48180041ace99842779)

<details>
<summary>keywords</summary>

エラー遷移, HttpErrorHandler_DefaultPage, forward_error_page, on_error_interceptor, on_errors_interceptor, エラーページ, 例外クラス

</details>

## MOMメッセージ送信

- [同期応答メッセージ送信](../../component/libraries/libraries-mom_system_messaging.md)

<details>
<summary>keywords</summary>

MOMメッセージ, mom_system_messaging-sync_message_send, 同期応答メッセージ送信

</details>

## Webアプリケーションのスケールアウト設計

- :ref:`stateless_web_app`

<details>
<summary>keywords</summary>

スケールアウト, stateless_web_app, ステートレス設計

</details>

## CSRF対策

- [CSRF対策](../../component/handlers/handlers-csrf_token_verification_handler.md)

<details>
<summary>keywords</summary>

CSRF対策, csrf_token_verification_handler, セキュリティ, CSRFトークン

</details>

## ウェブアプリケーションとRESTfulウェブサービスの併用

- [委譲するWebフロントコントローラの名前を変更する](web-application-web_front_controller.md)

<details>
<summary>keywords</summary>

RESTful併用, Webフロントコントローラ, change_web_front_controller_name, コントローラ名変更

</details>

## Content Security Policy(CSP)対応

- [Content Security Policy(CSP)対応](../../component/handlers/handlers-secure_handler.md)

<details>
<summary>keywords</summary>

CSP, Content Security Policy, content_security_policy, セキュリティポリシー

</details>
