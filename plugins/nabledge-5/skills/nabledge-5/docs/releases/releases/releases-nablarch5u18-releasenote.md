# Nablarch 5u18 リリースノート

**公式ドキュメント**: [1](https://fintan.jp/page/252/) [2](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/data_io/data_format.html#id10) [3](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/tag.html#tag-double-submission-server-side-change) [4](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/tag.html#tag-double-submission) [5](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/web/secure_handler.html#id7) [6](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/web/secure_handler.html) [7](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html#rest-feature-details-response-header) [8](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/rest/jaxrs_response_handler.html#jaxrs-response-handler-error-response) [9](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/rest/cors_preflight_request_handler.html) [10](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/common/thread_context_handler.html#thread-context-handler-language-selection) [11](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/common/thread_context_handler.html#thread-context-handler-time-zone-selection) [12](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html#csrf-token-verification-handler-generation-verification) [13](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html) [14](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/web/health_check_endpoint_handler.html) [15](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/repository.html#repository-inject-annotation-component) [16](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/repository.html#repository-dispose-object) [17](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/common/request_handler_entry.html) [18](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/log.html#synchronousfilelogwriter) [19](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/repository.html#repository-factory-injection) [20](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/bean_util.html#id4) [21](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/blank_project/beforeFirstStep.html#id7) [22](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/cloud_native/containerize/index.html) [23](https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/blank_project/FirstStepContainer.html) [24](https://nablarch.github.io/docs/5u18/doc/application_framework/adaptors/slf4j_adaptor.html) [25](https://nablarch.github.io/docs/5u18/doc/application_framework/adaptors/lettuce_adaptor/redisstore_lettuce_adaptor.html) [26](https://nablarch.github.io/docs/5u18/doc/application_framework/adaptors/router_adaptor.html#jax-rspath) [27](https://nablarch.github.io/docs/5u18/doc/application_framework/adaptors/micrometer_adaptor.html) [28](https://nablarch.github.io/docs/5u18/doc/application_framework/adaptors/jaxrs_adaptor.html#resteasyrestful) [29](https://nablarch.github.io/docs/5u18/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/RequestUnitTest_rest.html) [30](https://nablarch.github.io/docs/5u18/doc/development_tools/ui_dev/doc/development_environment/update_bundle_plugin.html)

## Nablarch 5u18 変更点一覧（アプリケーションフレームワーク・アダプタ・UI開発基盤・テスティングフレームワーク・バージョンアップ手順）

## Nablarch 5u18 変更点一覧（5u17からの差分）

### アプリケーションフレームワーク

#### システムへの影響あり

**二重サブミット防止トークンのデフォルトをUUID v4に変更**（nablarch-fw-web 1.8.0）
- トークンのデフォルトが16文字のランダム文字列からUUID v4（36文字）に変更。
- アプリケーションでトークン値を直接使用していて変更前の16文字ランダム文字列の動作に戻したい場合は、トークン生成クラスを`nablarch.common.web.token.RandomTokenGenerator`に変更すること。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/tag.html#tag-double-submission

**セキュアハンドラ: デフォルトでReferrer-Policyヘッダを付与**（nablarch-fw-web 1.8.0）
- デフォルト値: `strict-origin-when-cross-origin`
- Referrer-Policyヘッダを付与せずこれまでのデフォルト動作に戻したい場合は、コンポーネント定義で以下3クラスのレスポンスヘッダのみを設定すること:
  - `nablarch.fw.web.handler.secure.FrameOptionsHeader`
  - `nablarch.fw.web.handler.secure.XssProtectionHeader`
  - `nablarch.fw.web.handler.secure.ContentTypeOptionsHeader`
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/web/secure_handler.html

**セキュアハンドラ: デフォルトでCache-Controlヘッダを付与**（nablarch-fw-web 1.8.0）
- デフォルト値: `no-store`
- Cache-Controlヘッダを付与しない場合は、Referrer-Policyと同様に上記3クラスのレスポンスヘッダをコンポーネント定義で設定すること。

**RESTful: ボディなしレスポンスにContent-Typeを設定しない**（nablarch-fw-jaxrs 1.1.0）
- 従来はボディなしレスポンスに`text/plain;charset=UTF-8`を設定していたが非設定に変更。
- 従来の動作に戻すには`JaxRsResponseHandler`コンポーネント定義で`setContentTypeForResponseWithNoBody`プロパティに`true`を設定すること。

**RESTful: ErrorResponseBuilder処理中例外でステータスコード500返却**（nablarch-fw-jaxrs 1.1.0）
- ErrorResponseBuilderをカスタマイズし処理中に例外が発生した場合はステータスコード500が返るようになった（旧動作: サーブレットコンテナにより200でボディなし）。
- ErrorResponseBuilderの処理中に例外が発生しないよう実装を見直すこと。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/rest/jaxrs_response_handler.html#jaxrs-response-handler-error-response

**言語・タイムゾーンのクッキーにhttpOnly属性を設定**（nablarch-fw-web 1.8.0）
- 言語・タイムゾーンをクッキーで保持する機能を使用し、Servlet API 3以上の場合、クッキーにhttpOnly属性が設定されるようになった。JavaScriptからのアクセスを防止。
- httpOnly属性を設定しない場合は各クラスの`cookieHttpOnly`プロパティに`false`を指定:
  - 言語: `nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie`
  - タイムゾーン: `nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie`
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/common/thread_context_handler.html#thread-context-handler-language-selection

**CSRFトークン検証失敗時にINFOレベルログを出力**（nablarch-fw-web 1.8.0）
- CSRFトークン検証ハンドラを使用しトークンの検証が失敗した場合にINFOレベルでログ出力するようになった。
- ログを出力しない場合は`nablarch.fw.web.handler.csrf.VerificationFailureHandler`インタフェースのデフォルト実装を変更すること。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html

**リクエストハンドラエントリのパターンバリデーション修正（不具合修正）**（nablarch-core 1.5.1、起因バージョン1.0.0）
- 以下3つのケースでパターン判定が誤っていたため修正:
  1. パターン末尾が`/`の場合: 前方一致→完全一致に修正。前方一致を期待している場合は`/*`または`//`に変更すること（`/*`は末尾`/`または拡張子を含むパスにはマッチしない。`//`は前方一致のみで判定）。
  2. パターン末尾が`*`かつ拡張子を含むリクエストパスの場合: マッチしないように修正。拡張子を含むパスにマッチさせたい場合は`//`に変更すること。
  3. パターンの途中に`/*/`を含む場合: マッチするように修正（修正前はマッチしなかったため、このパターンを指定していた場合は設定不備でないか確認すること）。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/common/request_handler_entry.html

#### システムへの影響なし（機能追加・変更）

**汎用データフォーマット: データ出力バッファサイズ設定追加**（nablarch-core-dataformat 1.3.0）
- 1レコード毎の書き込みではなく指定バッファサイズで書き込む設定を追加。大量データ出力時の性能改善が可能。デフォルトは従来通り1レコード毎。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/data_io/data_format.html#id10

**ログ出力: BasicCommitLogger#initializeメソッドをsynchronizedに変更**（nablarch-core-applog 1.1.1）
- `BasicCommitLogger#terminate`メソッドはsynchronizedだったが、`initialize`メソッドはsynchronizedになっていなかった。対称性がないためセキュリティチェック等で指摘を受ける可能性があるため、`initialize`メソッドをsynchronizedに変更した。
- BasicCommitLoggerを使用しバッチをマルチスレッドで動作させた場合でも、initializeメソッドは複数スレッドから呼ばれないため既存システムへの影響はない。

**RESTful: Producesを使用したリソースメソッドでレスポンスヘッダ指定可能**（nablarch-fw-jaxrs 1.1.0）
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html#rest-feature-details-response-header

**RESTful: CORS（Cross-Origin Resource Sharing）対応追加**（nablarch-fw-jaxrs 1.1.0）
- `CorsPreflightRequestHandler`を追加し、`JaxRsResponseHandler`に`CorsResponseFinisher`を加えることでプリフライトリクエスト対応とCORSレスポンスヘッダ付与が可能。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/rest/cors_preflight_request_handler.html

**ヘルスチェックエンドポイントハンドラ追加**（nablarch-fw-web 1.8.0, nablarch-lettuce-adaptor 1.0.0）
- WebアプリケーションおよびRESTfulウェブサービスでヘルスチェックを実現するハンドラ。DBとRedisのヘルスチェックをデフォルトで提供。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/handlers/web/health_check_endpoint_handler.html

**アノテーションによるDIコンテナ管理機能追加**（nablarch-core-repository 1.5.0, nablarch-fw 1.4.0）
- アノテーションを付与したクラスをDIコンテナで管理できる機能を追加。コンストラクタインジェクションが可能となり、テスト時のモック化が容易になる。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/repository.html#repository-inject-annotation-component

**オブジェクトの廃棄処理の仕組み追加**（nablarch-core 1.5.1, nablarch-core-repository 1.5.0, nablarch-fw-web 1.8.0, nablarch-fw-standalone 1.4.0）
- アプリケーション終了時に任意の廃棄処理（DBコネクションプールのクローズなど）を実行できる仕組みを追加。コンテナ化アプリケーションでのリソース管理に対応。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/repository.html#repository-dispose-object

**データリーダ: DataReader#readメソッドのJavadocを変更**（nablarch-core 1.5.1）
- `DataReader#read`メソッドは入力データが存在しない場合にnullを返す仕様。この仕様をJavadocに追記した。

**BeanUtil: List型の型パラメータ使用時に実行時例外を送出**（nablarch-core-beans 1.4.1）
- BeanUtilはList型の型パラメータに対応していない。使用された場合に制約と対応方法を明示するため実行時例外を送出するように変更。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/bean_util.html#id4

**コンテナ用ブランクプロジェクト追加**（nablarch-container-web 5u18, nablarch-container-jaxrs 5u18）
- Dockerコンテナ化のためのブランクプロジェクトを追加。ウェブプロジェクト（nablarch-container-web）とRESTfulウェブサービスプロジェクト（nablarch-container-jaxrs）の2種類を提供。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/cloud_native/containerize/index.html

**ブランクプロジェクト: EclipseでのMavenライフサイクルエラーの対応方法を追記**（nablarch-document 5u18）
- ブランクプロジェクトをEclipseで開くとMavenのライフサイクルに関するエラーが出力されることがある。このエラーが発生した場合はEclipseがプラグインのインストールを提案するので、提案に従いプラグインをインストールすることで解消される旨を追記した。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/blank_project/beforeFirstStep.html#id7

**ブランクプロジェクト: Guava脆弱性対応（CVE-2018-10237）**（nablarch-batch-ee 5u18）
- JSR352に準拠したバッチプロジェクトが依存するモジュールのGuavaに脆弱性（CVE-2018-10237）が検知されたため、脆弱性対応済みのバージョンに変更した。
- Nablarchでは脆弱性が検知された機能を使用していないため、プロジェクトで個別に該当機能を使用していなければ既存プロジェクトへの影響はない。

**全ブランクプロジェクト: Hibernate Validator脆弱性対応（CVE-2017-7536）**（nablarch-web 5u18, nablarch-jaxrs 5u18, nablarch-batch 5u18, nablarch-batch-ee 5u18, nablarch-container-web 5u18, nablarch-container-jaxrs 5u18）
- 全てのブランクプロジェクトが依存するモジュールのHibernate Validatorに脆弱性（CVE-2017-7536）が検知されたため、脆弱性対応済みのバージョンに変更した。
- Nablarchでは脆弱性が検知された機能を使用していないため、プロジェクトで個別に該当機能を使用していなければ既存プロジェクトへの影響はない。

**SynchronousFileLogWriterの使用想定をドキュメントに追記**（nablarch-document 5u18）
- SynchronousFileLogWriterは障害通知ログのように出力頻度が低いログ出力にのみ使用することを想定。アプリケーションログなど頻繁なログ出力には使用しないこと。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/log.html#synchronousfilelogwriter

**システムリポジトリ: ファクトリクラスの入れ子制約を追記**（nablarch-document 5u18）
- ファクトリクラスのプロパティにファクトリクラスを指定する入れ子はシステムリポジトリが対応していない制約と対応方法を追記。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/application_framework/libraries/repository.html#repository-factory-injection

### アダプタ

**E-mail Velocityアダプタ: テンプレートのプレースホルダでList型変数が使用できない不具合修正**（nablarch-mail-sender-velocity-adaptor 1.0.1、起因バージョン5u13）
- テンプレートのプレースホルダにList型の変数を使用すると実行時例外が発生する問題を修正。

**SLF4Jアダプタ追加**（slf4j-nablarch-adaptor 1.0.0）
- SLF4J APIを経由してNablarchのログ出力機能でログ出力するアダプタ。HikariCPなどSLF4Jを使用するOSSのログをNablarchログ出力に集約可能。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/adaptors/slf4j_adaptor.html

**Redisストア（Lettuce）アダプタ追加**（nablarch-lettuce-adaptor 1.0.0, nablarch-core-repository 1.5.0）
- セッションストアの保存先をRedisにするアダプタ。DBストアに対するメリット: セッション情報保存テーブルの事前作成不要、有効期限切れセッション削除バッチ不要。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/adaptors/lettuce_adaptor/redisstore_lettuce_adaptor.html

**ルーティングアダプタ: JAX-RS @Pathアノテーションによるマッピング追加**（nablarch-router-adaptor 1.2.0）
- ActionクラスにJAX-RSの`@Path`アノテーションを付与することでURLマッピングが可能に（従来のXMLによる一元管理に加えて）。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/adaptors/router_adaptor.html#jax-rspath

**Micrometerアダプタ追加**（nablarch-micrometer-adaptor 1.0.0, nablarch-main-default-configuration 1.3.0）
- JVMヒープ使用量、CPU使用率、GC回数などのメトリクスを収集。Datadog、CloudWatchなどの監視サービスに連携可能。
- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/adaptors/micrometer_adaptor.html

**RESTEasy用アダプタからJackson Databind依存を削除**（nablarch-resteasy-adaptor 1.0.6）

> **影響あり**: `nablarch-resteasy-adaptor`をMavenの依存に追加してもJackson Databindの依存が自動で追加されなくなった。RESTEasy環境下でJackson Databindが提供されていない場合は、プロジェクトで使用するJackson DatabindをMavenの依存に追加すること。

- 参照: https://nablarch.github.io/docs/5u18/doc/application_framework/adaptors/jaxrs_adaptor.html#resteasyrestful

### UI開発基盤

**jQueryのバージョンアップ（CVE対応）**（nablarch-plugins-bundle 1.0.5）
- UI開発基盤が依存するモジュールのjQueryに脆弱性（jQuery 3.5.0 Released!）が検知されたため、脆弱性対応済みのバージョンに変更した。
- Nablarchは脆弱性が検知された機能を使用していないため、プロジェクトで個別に該当機能を使用していなければ既存プロジェクトへの影響はない。

### テスティングフレームワーク

**RESTfulウェブサービス向けリクエスト単体テストフレームワーク追加**（nablarch-testing-rest 1.0.0, nablarch-testing-default-configuration 1.2.0）
- RESTfulウェブサービス実行基盤のリクエスト単体テストをサポート。
- 参照: https://nablarch.github.io/docs/5u18/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/RequestUnitTest_rest.html

### バージョンアップ手順

1. `pom.xml`の`<dependencyManagement>`セクションに指定されているnablarch-bomのバージョンを`5u18`に書き換える
2. mavenのビルドを再実行する

<details>
<summary>keywords</summary>

5u18, リリースノート, 二重サブミット防止, Referrer-Policy, Cache-Control, CORS, CSRFトークン, ヘルスチェック, DIコンテナ, アノテーション, Redisストア, Micrometer, SLF4J, ルーティングアダプタ, httpOnly, リクエストハンドラエントリ, コンテナ化, バッファサイズ, RandomTokenGenerator, LanguageAttributeInHttpCookie, TimeZoneAttributeInHttpCookie, VerificationFailureHandler, JaxRsResponseHandler, ErrorResponseBuilder, CorsPreflightRequestHandler, CorsResponseFinisher, FrameOptionsHeader, XssProtectionHeader, ContentTypeOptionsHeader, setContentTypeForResponseWithNoBody, cookieHttpOnly, nablarch-fw-web, nablarch-fw-jaxrs, nablarch-lettuce-adaptor, nablarch-router-adaptor, nablarch-micrometer-adaptor, slf4j-nablarch-adaptor, nablarch-resteasy-adaptor, nablarch-testing-rest, nablarch-core-repository, nablarch-core-dataformat, nablarch-core-beans, nablarch-mail-sender-velocity-adaptor, nablarch-core-applog, nablarch-batch-ee, BasicCommitLogger, DataReader, Guava, CVE-2018-10237, Hibernate Validator, CVE-2017-7536, jQuery, nablarch-plugins-bundle, Eclipse, Mavenライフサイクル, バージョンアップ手順

</details>
