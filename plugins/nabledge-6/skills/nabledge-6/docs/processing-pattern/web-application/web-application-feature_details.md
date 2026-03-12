# 機能詳細

**公式ドキュメント**: [機能詳細](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details.html)

## Nablarchの初期化

Nablarchの初期化には以下の2つの設定が必要:

1. [システムリポジトリのロードの為の設定](web-application-nablarch_servlet_context_listener.md)
2. [ハンドラキューの設定(構築)](web-application-web_front_controller.md)

<details>
<summary>keywords</summary>

nablarch_servlet_context_listener, web_front_controller, Nablarch初期化, システムリポジトリ, ハンドラキュー設定

</details>

## 入力値のチェック

- [入力値のチェック](../../component/libraries/libraries-validation.md)
- [エラーメッセージの画面表示](web-application-error_message.md)

<details>
<summary>keywords</summary>

validation, バリデーション, 入力値チェック, エラーメッセージ

</details>

## データベースアクセス

データベースアクセス: [database_management](../../component/libraries/libraries-database_management.md)

<details>
<summary>keywords</summary>

database_management, データベースアクセス, DB操作

</details>

## 排他制御

排他制御は2種類提供されるが、[universal_dao](../../component/libraries/libraries-universal_dao.md) の使用を推奨する（[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive_control.md) 参照）。

- [exclusive_control](../../component/libraries/libraries-exclusive_control.md)
- [universal_dao](../../component/libraries/libraries-universal_dao.md)（推奨）
  - :ref:`universal_dao_jpa_optimistic_lock`（楽観排他）
  - :ref:`universal_dao_jpa_pessimistic_lock`（悲観排他）

<details>
<summary>keywords</summary>

exclusive_control, universal_dao, universal_dao_jpa_optimistic_lock, universal_dao_jpa_pessimistic_lock, 排他制御, 楽観排他, 悲観排他

</details>

## ファイルアップロード

ファイルアップロードの読み込み: [multipart_handler-read_upload_file](../../component/handlers/handlers-multipart_handler.md)

<details>
<summary>keywords</summary>

multipart_handler-read_upload_file, ファイルアップロード, マルチパート

</details>

## ファイルダウンロード

ファイルダウンロードは2種類提供されるが、[data_bind](../../component/libraries/libraries-data_bind.md) の使用を推奨する（[データバインドを推奨する理由](../../component/libraries/libraries-data_converter.md) 参照）。

- [データバインド機能を使用したファイルダウンロード](../../component/libraries/libraries-data_bind.md)（推奨）
- [汎用データフォーマット機能を使用したファイルダウンロード](../../component/libraries/libraries-data_format.md)

> **警告**: 大量データのダウンロード時は [universal_dao-lazy_load](../../component/libraries/libraries-universal_dao.md) を使用し、データベースの検索結果をヒープ上に展開しないこと。

<details>
<summary>keywords</summary>

data_bind, data_bind-file_download, data_format-file_download, universal_dao-lazy_load, ファイルダウンロード, データバインド, 大量データ

</details>

## URIとアクションクラスのマッピング

URIとアクションクラスのマッピングは2種類提供されるが、[router_adaptor](../../component/adapters/adapters-router_adaptor.md) の使用を推奨する（[ルーティングアダプタが推奨である理由](../../component/handlers/handlers-http_request_java_package_mapping.md) 参照）。

- [router_adaptor](../../component/adapters/adapters-router_adaptor.md)（推奨）
- [http_request_java_package_mapping](../../component/handlers/handlers-http_request_java_package_mapping.md)

<details>
<summary>keywords</summary>

router_adaptor, http_request_java_package_mapping, URIマッピング, アクションクラスマッピング, ルーティング

</details>

## 2重サブミット防止

2重サブミット防止: :ref:`2重サブミット防止 <tag-double_submission>`

JSP以外のテンプレートエンジンを使用する場合は [use_token_interceptor](../../component/handlers/handlers-use_token.md) も参照すること。

<details>
<summary>keywords</summary>

tag-double_submission, use_token_interceptor, 2重サブミット防止, ダブルサブミット

</details>

## 入力データの保持

入力データの保持: :ref:`session_store`

<details>
<summary>keywords</summary>

session_store, セッションストア, 入力データ保持

</details>

## ページネーション

データベースから範囲を指定して検索する方法は [database_management](../../component/libraries/libraries-database_management.md) を参照。

クライアントサイドのページネーションはプロジェクト要件により仕様が異なるため、フレームワークとしては提供していない。

<details>
<summary>keywords</summary>

database_management, ページネーション, 範囲検索, クライアントサイドページング

</details>

## 画面の作成

**JSPを使用する場合:**
- :ref:`JSPのtaglibを使用した画面開発 <tag>`
- [jsp_session](web-application-jsp_session.md)

**JSP以外のテンプレートエンジンを使用する場合:**
- [Thymeleafを使用した画面開発](../../component/adapters/adapters-web_thymeleaf_adaptor.md)
- [view_other](web-application-other.md)

<details>
<summary>keywords</summary>

tag, jsp_session, web_thymeleaf_adaptor, view_other, JSP, Thymeleaf, 画面開発, テンプレートエンジン

</details>

## 国際化対応

**静的リソースの多言語化:**
- [メッセージの多言語化](../../component/libraries/libraries-message.md)
- [コード名称の多言語化](../../component/libraries/libraries-code.md)

**言語切り替えの2通りの方法:**
- :ref:`メッセージタグでの国際化対応 <tag-write_message>`
- [言語ごとにリソースのパスを切り替える](../../component/libraries/libraries-tag.md)

> **警告**: :ref:`メッセージタグでの国際化対応 <tag-write_message>` を使用した場合、画面レイアウトが崩れる可能性がある。レイアウト崩れを許容できる場合のみ使用すること。

<details>
<summary>keywords</summary>

message-multi_lang, code-use_multilingualization, tag-write_message, tag_change_resource_path_of_lang, 国際化, 多言語化, 言語切り替え

</details>

## 認証

認証はプロジェクト要件により仕様が異なるため、フレームワークとしては提供していない。プロジェクト要件に合わせてPJで実装すること。

認証情報の保持: :ref:`session_store-authentication_data`

<details>
<summary>keywords</summary>

session_store-authentication_data, 認証, 認証情報

</details>

## 認可チェック

認可チェック: :ref:`permission_check`

<details>
<summary>keywords</summary>

permission_check, 認可チェック, 権限チェック

</details>

## ステータスコード

[ステータスコードの使い分け(外部サイト)](https://qiita.com/kawasima/items/e48180041ace99842779)

<details>
<summary>keywords</summary>

ステータスコード, HTTPステータスコード

</details>

## エラー時の画面遷移とステータスコード

エラー時の画面遷移とステータスコードの設定方法:

1. :ref:`ステータスコードに対応したデフォルトの遷移先ページを設定する <HttpErrorHandler_DefaultPage>`
2. [ハンドラで例外クラスに対応したエラーページに遷移させる](web-application-forward_error_page.md)
3. アクションでエラー時の遷移先を指定する:
   - 例外クラスに対応した遷移先を定義する（[on_error_interceptor](../../component/handlers/handlers-on_error.md)、[on_errors_interceptor](../../component/handlers/handlers-on_errors.md)）
   - [1つの例外に対して複数の遷移先を定義する](web-application-forward_error_page.md)

[ステータスコードの使い分け(外部サイト)](https://qiita.com/kawasima/items/e48180041ace99842779)

<details>
<summary>keywords</summary>

HttpErrorHandler_DefaultPage, forward_error_page-handler, on_error_interceptor, on_errors_interceptor, forward_error_page-try_catch, エラーページ遷移, エラーハンドリング

</details>

## MOMメッセージ送信

MOMメッセージ送信: [同期応答メッセージ送信](../../component/libraries/libraries-mom_system_messaging.md)

<details>
<summary>keywords</summary>

mom_system_messaging-sync_message_send, MOMメッセージ, 同期応答メッセージ送信

</details>

## Webアプリケーションのスケールアウト設計

Webアプリケーションのスケールアウト設計: :ref:`stateless_web_app`

<details>
<summary>keywords</summary>

stateless_web_app, スケールアウト, ステートレス, 水平スケール

</details>

## CSRF対策

CSRF対策: [CSRF対策](../../component/handlers/handlers-csrf_token_verification_handler.md)

<details>
<summary>keywords</summary>

csrf_token_verification_handler, CSRF対策, CSRFトークン, クロスサイトリクエストフォージェリ

</details>

## ウェブアプリケーションとRESTfulウェブサービスの併用

ウェブアプリケーションとRESTfulウェブサービスを併用する場合: [委譲するWebフロントコントローラの名前を変更する](web-application-web_front_controller.md)

<details>
<summary>keywords</summary>

change_web_front_controller_name, Webフロントコントローラ, RESTfulウェブサービス併用

</details>

## Content Security Policy(CSP)対応

Content Security Policy(CSP)対応: [Content Security Policy(CSP)対応](../../component/handlers/handlers-secure_handler.md)

<details>
<summary>keywords</summary>

content_security_policy, CSP, Content Security Policy

</details>
