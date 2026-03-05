# Nablarch 6u3 リリースノート

## リリース項目

Nablarch 6u3の変更点（6u2からの差分）。

## アプリケーションフレームワーク

### オブジェクトコード・ソースコード

#### 1. RESTfulウェブサービス: 親クラス・インタフェースでのリソース定義に対応

**モジュール**: `nablarch-fw-jaxrs` 2.2.0, `nablarch-router-adaptor` 2.2.0

OpenAPIインタフェース対応。インタフェース/親クラスの`@Path`・HTTPメソッド定義を継承。

**参照**: 
- https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html
- https://nablarch.github.io/docs/6u3/doc/application_framework/adaptors/router_adaptor.html

#### 2. RESTfulウェブサービス: EntityResponseの型パラメータ追加

**モジュール**: `nablarch-fw-jaxrs` 2.2.0

`EntityResponse<T>`に型パラメータを追加。既存コードは未チェック警告が出るが動作は正常。型を明示することで警告解消。

**影響**: あり(開発)

**参照**: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html

#### 3. BeanUtil: Date and Time APIサポート拡充

**モジュール**: `nablarch-core-beans` 2.3.0

`OffsetDateTime`のサポートを追加。

**参照**: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/libraries/bean_util.html

#### 4. RESTfulウェブサービス: マルチパート用のBodyConverter追加

**モジュール**: `nablarch-fw-jaxrs` 2.2.0

`multipart/form-data`対応の`BodyConverter`を追加。

**参照**: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html

#### 5. BeanUtil: MapからBeanへ移送するメソッドのパフォーマンス改善

**モジュール**: `nablarch-core-beans` 2.3.0

ネストしたオブジェクト数が多い場合の処理速度を改善。

**参照**: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/libraries/bean_util.html

#### 6. 汎用データフォーマット: JSONの読み取りに失敗する問題を修正

**モジュール**: `nablarch-core-dataformat` 2.0.3（起因バージョン: 5u19）

JSON内の値が区切り文字(`:`, `[`, `{`, `,`)のみで、その後にデータが続く場合に読み取り失敗する不具合を修正。

**具体例**:

- **NGになる例**（`:`の後にデータが続く）:
  ```json
  {"key1": ":", "key2": "value2"}
  ```

- **OKになる例**（`:`の後にデータが続かない）:
  ```json
  {"key1": ":"}
  ```

NGになっていた例も、正常に値として解析できるように修正。

**影響**: あり(本番) - 本来解析すべきJSONが解析可能になる。システム影響がある場合は値の確認を行うこと。

**参照**: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/libraries/data_io/data_format.html

#### 7. Bean Validation: BeanValidationStrategyのバリデーション処理をカスタマイズ可能に

**モジュール**: `nablarch-fw-web` 2.3.0

`sortMessages`メソッドをオーバーライド可能に変更（static修飾子を除去）。

**参照**: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/libraries/validation/bean_validation.html

#### 8. 公開API: 公開APIの追加

**モジュール**: `nablarch-common-dao` 2.3.0, `nablarch-common-databind` 2.1.0

解説書で継承を案内しているAPIを公開APIに追加。

### APIドキュメント

#### 9. Nablarchバッチアプリケーション: ResumeDataReaderのJavadoc改善

**モジュール**: `nablarch-fw-batch` 2.0.1

`ResumePointManager`の初期化が必要であることをJavadocに追記。

**参照**: https://nablarch.github.io/docs/6u3/javadoc/nablarch/fw/reader/ResumeDataReader.html

#### 10. サロゲートキーの採番: TableIdGeneratorのJavadoc改善

**モジュール**: `nablarch-common-idgenerator-jdbc` 2.0.1

`FastTableIdGenerator`と`TableIdGenerator`のJavadocに初期化が必要であることを追記。

**参照**: https://nablarch.github.io/docs/6u3/javadoc/nablarch/common/idgenerator/FastTableIdGenerator.html

#### 11. 汎用ユーティリティ: Base64UtilのJavadoc・解説書改善

**モジュール**: `nablarch-core` 2.2.1

RFC4648準拠であることを明記。Java 8以降の標準APIを案内し、後方互換性のための位置付けとした。

**注意**: 現在Base64Utilを使用している個所を標準APIに置換する必要はありません。

**参照**: 
- https://nablarch.github.io/docs/6u3/javadoc/nablarch/core/util/Base64Util.html
- https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/libraries/utility.html

#### 12. 公開API: PublishedアノテーションのJavadoc改善

**モジュール**: `nablarch-core` 2.2.1

オーバーライド可能なメソッドは公開APIであることをJavadocに追記。

**参照**: https://nablarch.github.io/docs/6u3/javadoc/nablarch/core/util/annotation/Published.html

### 解説書

#### 13. コンポーネントの初期化: 初期化が必要なコンポーネントに対する説明の改善

**モジュール**: `nablarch-document` 6u3

初期化が必要なコンポーネント（コード管理、サロゲートキー採番、日付管理、メール送信、サービス提供可否チェック、プロセス停止制御ハンドラ、IBM MQアダプタ）の解説書に初期化設定例を追記。

## ブランクプロジェクト

#### 14. RESTfulウェブサービス: マルチパートリクエストのサポート

**モジュール**: `nablarch-single-module-archetype` 6u3

マルチパートリクエストに対応（No.4, No.19の機能を取り込み）。

#### 15. ウェブアプリケーション/RESTfulウェブサービス: Tomcatベースイメージの更新

**モジュール**: `nablarch-single-module-archetype` 6u3

Apache Tomcat 10.1.33以前の脆弱性対応のため、ベースイメージを`tomcat:10.1.34-jdk17-temurin`に更新。

**参照**: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerWeb.html

#### 16. 全般: gsp-dba-maven-pluginのバージョン更新

**モジュール**: `nablarch-single-module-archetype` 6u3

`gsp-dba-maven-plugin` 5.2.0に更新。

#### 17. 全般: 使用不許可APIツールのバージョン更新

**モジュール**: `nablarch-single-module-archetype` 6u3

`nablarch-unpublished-api-checker` 1.0.1に更新（No.26対応）。

## アダプタ

#### 18. Jakarta RESTful Web Servicesアダプタ: Date and Time APIのサポート

**モジュール**: `nablarch-jaxrs-adaptor` 2.2.0, `nablarch-jersey-adaptor` 2.2.0, `nablarch-resteasy-adaptor` 2.2.0, `nablarch-jackson-adaptor` 2.2.0

Jackson Java 8 Date/timeモジュールを追加してDate and Time APIに対応。

> **注意**: `JaxRsHandlerListFactory`を独自実装している場合、バージョンアップだけでは本機能は使用できません。本機能を使用したい場合は、`nablarch-jersey-adaptor`および`nablarch-resteasy-adaptor`の実装を参考にしてください。

**参照**: https://nablarch.github.io/docs/6u3/doc/application_framework/adaptors/jaxrs_adaptor.html

#### 19. Jakarta RESTful Web Servicesアダプタ: マルチパートリクエストのサポート

**モジュール**: `nablarch-jaxrs-adaptor` 2.2.0, `nablarch-jersey-adaptor` 2.2.0, `nablarch-resteasy-adaptor` 2.2.0, `nablarch-jackson-adaptor` 2.2.0

マルチパート用の`BodyConverter`を追加。

**影響**: あり - 6u2以前からのバージョンアップで使用する場合は設定変更が必要。詳細は「マルチパートリクエストのサポート対応」セクション参照。

**参照**: https://nablarch.github.io/docs/6u3/doc/application_framework/adaptors/jaxrs_adaptor.html

## Example

#### 20. ウェブアプリケーション (JSP): jQuery、Bootstrapのバージョンアップ

**モジュール**: `nablarch-example-web` 6u3

jQuery 3.7.1、jQuery UI 1.14、Bootstrap 5.3.3に更新。Bootstrap 5対応に伴いMaterial Design for Bootstrapを廃止。

**参照**: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/web/index.html

#### 21. RESTfulウェブサービス: マルチパートリクエストのサポート

**モジュール**: `nablarch-example-rest` 6u3

マルチパートリクエストに対応（No.4, No.19の機能を取り込み）。

#### 22. 全般: gsp-dba-maven-pluginのバージョン更新

**モジュール**: 全Exampleプロジェクト

`gsp-dba-maven-plugin` 5.2.0に更新。

対象: `nablarch-example-web`, `nablarch-example-thymeleaf-web`, `nablarch-example-rest`, `nablarch-example-batch`, `nablarch-example-batch-ee`, `nablarch-example-http-messaging`, `nablarch-example-http-messaging-send`, `nablarch-example-db-queue`, `nablarch-example-mom-delayed-receive`, `nablarch-example-mom-delayed-send`, `nablarch-example-mom-sync-receive`, `nablarch-example-mom-sync-send-batch`

## 実装サンプル集

#### 23. 検索結果の一覧表示: タグファイルのスタイル適用設定修正

**モジュール**: `nablarch-biz-sample-all` 3.1.0

ページング現在ページ番号へのスタイル適用が正しく動作するように修正。

**参照**: https://nablarch.github.io/docs/6u3/doc/biz_samples/03/index.html

## Nablarch開発標準

#### 24. Nablarch OpenAPI Generator: リリース

**モジュール**: `nablarch-openapi-generator` 1.0.0

OpenAPIドキュメントからアプリケーションコードを生成するツールをリリース。

**参照**: https://nablarch.github.io/docs/6u3/doc/development_tools/toolbox/NablarchOpenApiGenerator/NablarchOpenApiGenerator.html

#### 25. SQL Executor: 解説書の手順と実際のモジュールの構成差異を修正

**モジュール**: `sql-executor` 1.3.1

設定ファイルの不足および解説書との乖離を修正。解説書通りに実行できるように改善。

**参照**: https://nablarch.github.io/docs/6u3/doc/development_tools/toolbox/SqlExecutor/SqlExecutor.html

#### 26. 使用不許可APIチェックツール: Java 21でjava.lang.Objectのメソッドが許可できない場合がある問題に対応

**モジュール**: `nablarch-unpublished-api-checker` 1.0.1（起因バージョン: 1.0.0）

Java 21でバイトコード変更により、インタフェースから`java.lang.Object`のメソッド呼び出しが設定ファイルで許可されない不具合を修正。

**参照**: https://nablarch.github.io/docs/LATEST/doc/development_tools/java_static_analysis/index.html#id6

## バージョンアップ手順

Nablarch 6u3へのバージョンアップ手順。

1. `pom.xml`の`<dependencyManagement>`セクションに指定されている`nablarch-bom`のバージョンを`6u3`に変更
2. Mavenビルドを再実行

## マルチパートリクエストのサポート対応

Jakarta RESTful Web Servicesアダプタでマルチパートリクエストを扱うための設定変更手順。

## 適用対象

以下の条件をすべて満たすシステムが対象：

- Nablarch 6u2以前からのバージョンアップ
- `JerseyJaxRsHandlerListFactory`または`ResteasyJaxRsHandlerListFactory`を使用
- マルチパートリクエストを扱いたい

> **補足**: RESTfulウェブサービスのブランクプロジェクトは、デフォルトで`JerseyJaxRsHandlerListFactory`を使用。

## 変更内容の概要

Nablarch 6u3でマルチパートリクエストを扱えるようにするため、以下の対応が必要：

1. コンポーネント定義ファイルへのファイルパス設定・ファイルアップロード機能設定の追加
2. ハンドラキューへのマルチパートリクエストハンドラの追加
3. ファイルアップロード用の一時ディレクトリやアップロードサイズの上限などのプロパティの設定

## 変更手順

### 1. コンポーネント定義ファイルへの設定追加

`src/main/resources/rest-component-configuration.xml`に以下を追加：

```xml
<!-- ファイルパス設定 -->
<import file="nablarch/webui/filepath-for-webui.xml" />

<!-- ファイルアップロード機能設定 -->
<import file="nablarch/webui/multipart.xml" />
```

### 2. ハンドラキューへのマルチパートリクエストハンドラ追加

`src/main/resources/rest-component-configuration.xml`のハンドラキュー(`webFrontController`)に以下を追加：

```xml
<component-ref name="multipartHandler"/>
```

追加位置はセッション変数保存ハンドラおよびCSRFトークン検証ハンドラの制約事項を確認して決定すること：
- https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/handlers/web/SessionStoreHandler.html#session-store-handler-constraint
- https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html#id4

環境ごとにハンドラキューを上書きしている場合は、そちらにも反映すること。

### 3. プロパティ設定

以下のプロパティを定義：

**`src/main/resources/common.properties`:**
```
nablarch.uploadSettings.contentLengthLimit
```

**`src/env/[環境別]/resources/env.properties`:**
```
nablarch.filePathSetting.basePathSettings.format
nablarch.filePathSetting.basePathSettings.output
nablarch.uploadSettings.autoCleaning
nablarch.filePathSetting.basePathSettings.uploadFileTmpDir
```

設定詳細はマルチパートリクエストハンドラのドキュメントを参照：
- https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/handlers/web/multipart_handler.html

> **補足**: `nablarch.filePathSetting.basePathSettings.format`は汎用データフォーマットのフォーマット定義ファイル用。汎用データフォーマットを使用しない場合はダミー値でよい。
