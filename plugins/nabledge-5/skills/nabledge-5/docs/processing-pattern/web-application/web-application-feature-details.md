# 機能詳細

**目次**

* Nablarchの初期化
* 入力値のチェック
* データベースアクセス
* 排他制御
* ファイルアップロード
* ファイルダウンロード
* URIとアクションクラスのマッピング
* 2重サブミット防止
* 入力データの保持
* ページネーション
* 画面の作成
* 国際化対応
* 認証
* 認可チェック
* ステータスコード
* エラー時の画面遷移とステータスコード
* MOMメッセージ送信
* Webアプリケーションのスケールアウト設計
* CSRF対策
* ウェブアプリケーションとRESTfulウェブサービスの併用
* Content Security Policy(CSP)対応

## Nablarchの初期化

feature_details/nablarch_servlet_context_listener
feature_details/web_front_controller

Nablarchの初期化を行うためには、 [システムリポジトリのロードの為の設定](../../processing-pattern/web-application/web-application-nablarch-servlet-context-listener.md#nablarch-servlet-context-listener)
及び [ハンドラキューの設定(構築)](../../processing-pattern/web-application/web-application-web-front-controller.md#web-front-controller) が必要となる。

## 入力値のチェック

feature_details/error_message

* [入力値のチェック](../../component/libraries/libraries-validation.md#validation)
* [エラーメッセージの画面表示](../../processing-pattern/web-application/web-application-error-message.md)

## データベースアクセス

* [データベースアクセス](../../component/libraries/libraries-database-management.md#database-management)

## 排他制御

排他制御は、以下の2種類の方法を提供しているが、
[UniversalDaoを推奨する理由](../../component/libraries/libraries-exclusive-control.md#exclusive-control-deprecated) に記載がある通り、
[ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao) の使用を推奨する。

* [排他制御](../../component/libraries/libraries-exclusive-control.md#exclusive-control)
* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao)

  * [楽観的ロックを行う](../../component/libraries/libraries-universal-dao.md#universal-dao-jpa-optimistic-lock)
  * [悲観的ロックを行う](../../component/libraries/libraries-universal-dao.md#universal-dao-jpa-pessimistic-lock)

## ファイルアップロード

* [アップロードしたファイルを読み込む](../../component/handlers/handlers-multipart-handler.md#multipart-handler-read-upload-file)

## ファイルダウンロード

ファイルダウンロードは、以下の2種類の方法を提供しているが、
[データバインドを推奨する理由](../../component/libraries/libraries-data-converter.md#data-converter-data-bind-recommend) に記載がある通り、
[データバインド](../../component/libraries/libraries-data-bind.md#data-bind) の使用を推奨する。

* [データバインド機能を使用したファイルダウンロード](../../component/libraries/libraries-data-bind.md#data-bind-file-download)
* [汎用データフォーマット機能を使用したファイルダウンロード](../../component/libraries/libraries-data-format.md#data-format-file-download)

大量データのダウンロード時には、 [検索結果を遅延ロードする](../../component/libraries/libraries-universal-dao.md#universal-dao-lazy-load) を参照し、
データベースの検索結果をヒープ上に展開しないように注意すること。

## URIとアクションクラスのマッピング

以下の2種類の方法を提供しているが、
[ルーティングアダプタが推奨である理由](../../component/handlers/handlers-http-request-java-package-mapping.md#http-request-java-package-mapping-router-adaptor) に記載がある通り、 [ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#router-adaptor) の使用を推奨する。

* [ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#router-adaptor)
* [HTTPリクエストディスパッチハンドラ](../../component/handlers/handlers-http-request-java-package-mapping.md#http-request-java-package-mapping)

## 2重サブミット防止

* [2重サブミット防止](../../component/libraries/libraries-tag.md#tag-double-submission)

また、JSP以外のテンプレートエンジンを使用している場合は [UseTokenインターセプタ](../../component/handlers/handlers-use-token.md#use-token-interceptor) も参照すること。

## 入力データの保持

* [セッションストア](../../component/libraries/libraries-session-store.md#session-store)

## ページネーション

データベースから範囲を指定して検索する方法は、 [データベースアクセス](../../component/libraries/libraries-database-management.md#database-management) を参照。

クライアントサイドについては、プロジェクト要件により仕様が異なるため、フレークワークとしては提供していない。

## 画面の作成

feature_details/jsp_session
feature_details/view/freemarker
feature_details/view/other

* JSPを使用する場合

  * [JSPのtaglibを使用した画面開発](../../component/libraries/libraries-tag.md#tag)
  * [JSPで自動的にHTTPセッションを作成しないようにする方法](../../processing-pattern/web-application/web-application-jsp-session.md#jsp-session)
* JSP以外のテンプレートエンジンを使用する場合

  * [Thymeleafを使用した画面開発](../../component/adapters/adapters-web-thymeleaf-adaptor.md#web-thymeleaf-adaptor)
  * [FreeMarkerを使用した画面開発](../../processing-pattern/web-application/web-application-freemarker.md#view-freemarker)
  * [その他のテンプレートエンジンを使用した画面開発](../../processing-pattern/web-application/web-application-other.md#view-other)

## 国際化対応

静的リソースの多言語化対応については以下を参照。

* [メッセージの多言語化](../../component/libraries/libraries-message.md#message-multi-lang)
* [コード名称の多言語化](../../component/libraries/libraries-code.md#code-use-multilingualization)

画面表示する文言の言語を切り替えるには、以下の2通りの方法を提供しているが、
[メッセージタグでの国際化対応](../../component/libraries/libraries-tag.md#tag-write-message) を使用した場合、
画面レイアウトが崩れる可能性がある。
そのため、レイアウト崩れを許容できる場合のみ、 [メッセージタグでの国際化対応](../../component/libraries/libraries-tag.md#tag-write-message) を使用すること。

* [メッセージタグでの国際化対応](../../component/libraries/libraries-tag.md#tag-write-message)
* [言語ごとにリソースのパスを切り替える](../../component/libraries/libraries-tag.md#tag-change-resource-path-of-lang)

## 認証

認証については、プロジェクト要件により仕様が異なるため、フレークワークとしては提供していない。
[データベースを用いたパスワード認証機能サンプル](../../guide/biz-samples/biz-samples-01.md#authentication) を参考に、プロジェクト要件に合わせてPJで実装する。

認証情報の保持については、以下を参照。

* [認証情報を保持する](../../component/libraries/libraries-session-store.md#session-store-authentication-data)

## 認可チェック

* [ハンドラによる認可チェック](../../component/libraries/libraries-authorization-permission-check.md#permission-check)

## ステータスコード

* [ステータスコードの使い分け(外部サイト)](https://qiita.com/kawasima/items/e48180041ace99842779)

## エラー時の画面遷移とステータスコード

feature_details/forward_error_page

* [ステータスコードに対応したデフォルトの遷移先ページを設定する](../../component/handlers/handlers-HttpErrorHandler.md#httperrorhandler-defaultpage)
* [ハンドラで例外クラスに対応したエラーページに遷移させる](../../processing-pattern/web-application/web-application-forward-error-page.md#forward-error-page-handler)
* アクションでエラー時の遷移先を指定する

  * 例外クラスに対応した遷移先を定義する ([OnErrorインターセプタ](../../component/handlers/handlers-on-error.md#on-error-interceptor) 、 [OnErrorsインターセプタ](../../component/handlers/handlers-on-errors.md#on-errors-interceptor))
  * [1つの例外に対して複数の遷移先を定義する](../../processing-pattern/web-application/web-application-forward-error-page.md#forward-error-page-try-catch)
* [ステータスコードの使い分け(外部サイト)](https://qiita.com/kawasima/items/e48180041ace99842779)

## MOMメッセージ送信

* [同期応答メッセージ送信](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-sync-message-send)

## Webアプリケーションのスケールアウト設計

* [Webアプリケーションをステートレスにする](../../component/libraries/libraries-stateless-web-app.md#stateless-web-app)

## CSRF対策

* [CSRF対策](../../component/handlers/handlers-csrf-token-verification-handler.md#csrf-token-verification-handler)

## ウェブアプリケーションとRESTfulウェブサービスの併用

* [委譲するWebフロントコントローラの名前を変更する](../../processing-pattern/web-application/web-application-web-front-controller.md#change-web-front-controller-name)

## Content Security Policy(CSP)対応

* [Content Security Policy(CSP)対応](../../component/handlers/handlers-secure-handler.md#content-security-policy)
