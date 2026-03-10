# Nablarch 6u3 リリースノート

## 6u3 変更一覧

## 6u3 変更一覧（6u2からの変更点）

| No. | 分類 | 種別 | タイトル | 修正バージョン | システム影響 |
|---|---|---|---|---|---|
| 1 | RESTfulウェブサービス | 変更 | 親クラス・インタフェースでのリソース定義に対応 | nablarch-fw-jaxrs 2.2.0, nablarch-router-adaptor 2.2.0 | なし |
| 2 | RESTfulウェブサービス | 変更 | EntityResponseの型パラメータ追加 | nablarch-fw-jaxrs 2.2.0 | あり（開発） |
| 3 | BeanUtil | 変更 | Date and Time APIサポート拡充（OffsetDateTime追加） | nablarch-core-beans 2.3.0 | なし |
| 4 | RESTfulウェブサービス | 変更 | マルチパート用BodyConverter追加 | nablarch-fw-jaxrs 2.2.0 | なし |
| 5 | BeanUtil | 変更 | MapからBeanへ移送するメソッドのパフォーマンス改善 | nablarch-core-beans 2.3.0 | なし |
| 6 | 汎用データフォーマット | 不具合修正 | JSONの読み取りに失敗する問題を修正 | nablarch-core-dataformat 2.0.3 | あり（本番） |
| 7 | Bean Validation | 変更 | BeanValidationStrategyのバリデーション処理カスタマイズ対応 | nablarch-fw-web 2.3.0 | なし |
| 8 | 公開API | 変更 | 公開APIの追加 | nablarch-common-dao 2.3.0, nablarch-common-databind 2.1.0 | なし |
| 9 | Nablarchバッチ | 変更 | ResumeDataReaderのJavadoc改善 | nablarch-fw-batch 2.0.1 | なし |
| 10 | サロゲートキーの採番 | 変更 | TableIdGenerator/FastTableIdGeneratorのJavadoc改善 | nablarch-common-idgenerator-jdbc 2.0.1 | なし |
| 11 | 汎用ユーティリティ | 変更 | Base64UtilのJavadoc・解説書改善 | nablarch-core 2.2.1 | なし |
| 12 | 公開API | 変更 | PublishedアノテーションのJavadoc改善 | nablarch-core 2.2.1 | なし |
| 13 | コンポーネントの初期化 | 変更 | 初期化が必要なコンポーネントへの説明追記（解説書） | nablarch-document 6u3 | なし |
| 14 | RESTfulウェブサービス | 変更 | マルチパートリクエストのサポート（ブランクプロジェクト） | nablarch-single-module-archetype 6u3 | なし |
| 15 | ウェブ/REST | 変更 | Tomcatベースイメージの更新 | nablarch-single-module-archetype 6u3 | なし |
| 16 | 全般 | 変更 | gsp-dba-maven-plugin 5.2.0へ更新（ブランクプロジェクト） | nablarch-single-module-archetype 6u3 | なし |
| 17 | 全般 | 変更 | 使用不許可APIツールのバージョン更新（ブランクプロジェクト） | nablarch-single-module-archetype 6u3 | なし |
| 18 | Jakarta RESTful Web Servicesアダプタ | 変更 | Date and Time APIのサポート | nablarch-jaxrs-adaptor 2.2.0, nablarch-jersey-adaptor 2.2.0, nablarch-resteasy-adaptor 2.2.0, nablarch-jackson-adaptor 2.2.0 | なし |
| 19 | Jakarta RESTful Web Servicesアダプタ | 変更 | マルチパートリクエストのサポート | nablarch-jaxrs-adaptor 2.2.0, nablarch-jersey-adaptor 2.2.0, nablarch-resteasy-adaptor 2.2.0, nablarch-jackson-adaptor 2.2.0 | あり |
| 20 | ウェブアプリケーション(JSP) | 変更 | jQuery 3.7.1・jQuery UI 1.14・Bootstrap 5.3.3へバージョンアップ、Material Design for Bootstrap廃止 | nablarch-example-web 6u3 | なし |
| 21 | RESTfulウェブサービス(Example) | 変更 | マルチパートリクエストのサポート | nablarch-example-rest 6u3 | なし |
| 22 | 全般(Example) | 変更 | gsp-dba-maven-plugin 5.2.0へ更新 | 各example 6u3 | なし |
| 23 | 実装サンプル集 | 変更 | タグファイルのスタイル適用設定修正（ページングCSSが常に適用されるよう修正） | nablarch-biz-sample-all 3.1.0 | なし |
| 24 | Nablarch OpenAPI Generator | 追加 | Nablarch OpenAPI Generatorのリリース | nablarch-openapi-generator 1.0.0 | なし |
| 25 | SQL Executor | 変更 | 解説書の手順と実際のモジュール構成の差異を修正 | sql-executor 1.3.1 | なし |
| 26 | 使用不許可APIチェックツール | 不具合修正 | Java21でjava.lang.Objectのメソッドが許可できない問題を修正 | nablarch-unpublished-api-checker 1.0.1 | なし |

### システム影響ありの変更詳細

**No.2 EntityResponseの型パラメータ追加（開発への影響）**

`EntityResponse`に型パラメータを追加。既存コードで型未指定の場合、コンパイル時に以下の警告が出力される:
`[INFO] (該当クラス)の操作は、未チェックまたは安全ではありません。`

> **重要**: 動作への影響はないが、`EntityResponse`を使用している箇所で明示的に型を指定すると警告は解消される。

参照: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html

**No.6 JSONの読み取りに失敗する問題を修正（本番への影響）**

起因バージョン: nablarch-core-dataformat 1.3.1（5u19相当）

JSON値（`""` で囲われた項目）がJSON構文の区切り文字（`:`, `[`, `{`, `,`）のみで、かつその後にデータが続く場合、値と区切り文字の区別ができず解析が失敗していた問題を修正。

例（修正前はNG、修正後はOK）: `{"key1": ":", "key2": "value2"}`

> **重要**: このようなJSONを読み込めるようになることでシステム影響がある場合は、値の確認をして受け入れないようにするなどの修正を行うこと。

参照: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/libraries/data_io/data_format.html

**No.19 マルチパートリクエストのサポート（設定変更が必要）**

> **重要**: 6u2以前からのバージョンアップで本機能を使用する場合は、設定変更が必要。詳細はマルチパートリクエストのサポート対応セクションを参照。

参照: https://nablarch.github.io/docs/6u3/doc/application_framework/adaptors/jaxrs_adaptor.html

### その他の注意事項

**No.1 親クラス・インタフェースでのリソース定義の継承条件**

以下の条件をすべて満たす場合にアクションクラスがインタフェース/親クラスのリソース定義を引き継ぐ:
1. アクションクラスが親クラスを継承またはインタフェースを実装している
2. 親クラスまたはインタフェースに`@Path`アノテーションが注釈されている
3. 親クラスまたはインタフェースにHTTPメソッドが定義されている

参照: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html, https://nablarch.github.io/docs/6u3/doc/application_framework/adaptors/router_adaptor.html

**No.13 初期化が必要なコンポーネントへの説明追記**

初期化が必要であるにも関わらず解説書への記載がなかったコンポーネントに対して、初期化が必要な旨や設定例を追記。対象コンポーネントは以下の通り:

- Nablarchが提供するライブラリ: コード管理、サロゲートキーの採番、日付管理、メール送信、サービス提供可否チェック
- Nablarchの提供する標準ハンドラ: プロセス停止制御ハンドラ
- アダプタ: IBM MQアダプタ

**No.18 Jakarta RESTful Web ServicesアダプタのDate and Time APIサポート**

> **重要**: `JaxRsHandlerListFactory`を独自に実装している場合、バージョンアップだけでは本機能は使用できない。`nablarch-jersey-adaptor`および`nablarch-resteasy-adaptor`の実装を参考にすること。

参照: https://nablarch.github.io/docs/6u3/doc/application_framework/adaptors/jaxrs_adaptor.html

**No.20 jQuery・Bootstrapバージョンアップ及びMaterial Design for Bootstrap廃止**

Bootstrapのバージョンアップ（Bootstrap 5.3.3）に伴って、Material Design for Bootstrap（MDB）の使用を廃止し、画面デザインを調整。

参照: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/web/index.html

**No.11 Base64Utilの位置づけ**

`Base64Util`はRFC4648の「4. Base 64 Encoding」に準拠している。Java8以降の標準APIで代替可能であり、後方互換のために存在する。現在`Base64Util`を使用している箇所を標準APIに置換する必要はない。

参照: https://nablarch.github.io/docs/6u3/javadoc/nablarch/core/util/Base64Util.html, https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/libraries/utility.html

**No.15 Tomcatベースイメージの更新**

10.1.33以前のApache Tomcatに脆弱性が検出されたため、ブランクプロジェクトのデフォルトのTomcatベースイメージを`tomcat:10.1.34-jdk17-temurin`に更新。

参照: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerWeb.html

**No.26 使用不許可APIチェックツールのJava21対応**

Java21でバイトコードが変わったことにより、インタフェースから`java.lang.Object`のメソッドを呼んでいる場合に設定ファイルで許可指定しても許可されない不具合を修正（`nablarch-unpublished-api-checker 1.0.1`、起因: 1.0.0）。

参照: https://nablarch.github.io/docs/LATEST/doc/development_tools/java_static_analysis/index.html#id6

**No.7 BeanValidationStrategyのカスタマイズ対応**

`sortMessages`メソッドをオーバーライド可能にするためstatic修飾子を除去。

参照: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/libraries/validation/bean_validation.html

**No.24 Nablarch OpenAPI Generator**

OpenAPIドキュメントからアプリケーションのコード生成をサポートするツール`nablarch-openapi-generator 1.0.0`をリリース。

参照: https://nablarch.github.io/docs/6u3/doc/development_tools/toolbox/NablarchOpenApiGenerator/NablarchOpenApiGenerator.html

## バージョンアップ手順

## バージョンアップ手順

1. `pom.xml`の`<dependencyManagement>`セクションに指定されている`nablarch-bom`のバージョンを`6u3`に書き換える
2. Mavenのビルドを再実行する

## マルチパートリクエストのサポート対応（6u2からの移行手順）

## マルチパートリクエストのサポート対応（6u2からの移行手順）

### 対象システム

以下の条件をすべて満たすシステムが対象:
- Nablarch 6u2以前からのバージョンアップであること
- Jakarta RESTful Web ServicesアダプタのJerseyJaxRsHandlerListFactoryまたはResteasyJaxRsHandlerListFactoryを使用していること（RESTfulウェブサービスのブランクプロジェクトはデフォルトでJerseyJaxRsHandlerListFactoryを使用）
- Nablarchの標準機能を使用してRESTfulウェブサービスでマルチパートリクエストを扱いたい

### 変更手順

**1. コンポーネント定義ファイルへのファイルパス設定・ファイルアップロード機能設定の追加**

`src/main/resources/rest-component-configuration.xml`に以下を追加:

```xml
<!-- ファイルパス設置 -->
<import file="nablarch/webui/filepath-for-webui.xml" />

<!-- ファイルアップロード機能設定 -->
<import file="nablarch/webui/multipart.xml" />
```

**2. ハンドラキューへのマルチパートリクエストハンドラの追加**

`src/main/resources/rest-component-configuration.xml`のハンドラキュー（webFrontController）に以下を追加:

```xml
<component-ref name="multipartHandler"/>
```

> **重要**: 追加位置は、セッション変数保存ハンドラおよびCSRFトークン検証ハンドラの制約事項を確認して決定すること:
> - https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/handlers/web/SessionStoreHandler.html#session-store-handler-constraint
> - https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html#id4
>
> 環境ごとにハンドラキューを上書きしている場合は、そちらのハンドラキュー定義にも反映すること。

**3. ファイルアップロード用プロパティの設定**

`src/main/resources/common.properties`に追加:
- `nablarch.uploadSettings.contentLengthLimit`

`src/env/[環境別]/resources/env.properties`に追加:
- `nablarch.filePathSetting.basePathSettings.format`
- `nablarch.filePathSetting.basePathSettings.output`
- `nablarch.uploadSettings.autoCleaning`
- `nablarch.filePathSetting.basePathSettings.uploadFileTmpDir`

> **注意**: `nablarch.filePathSetting.basePathSettings.format`は汎用データフォーマットのフォーマット定義ファイル用のパス設定。汎用データフォーマットを使用しない場合はダミー値でよい。

設定内容の詳細: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/handlers/web/multipart_handler.html
