# Nablarch 6u2 リリースノート

## 6u2 変更点（5u25からの移行）

## システムへの影響がある変更

> **重要**: 以下の変更はシステムへの影響があります。移行時に対処が必要です。

**Jakarta EE 10対応・Java 17必須（No.1, 3）**: Jakarta EE 10に対応したアプリケーションサーバで動作させる必要があります。Jakarta EE 10への移行に伴い、パッケージ名や依存関係などを変更する必要があります。また、実行環境のJavaバージョンを17にする必要があります。詳細は[マイグレーションガイド](https://nablarch.github.io/docs/6u2/doc/migration/index.html)を参照。

## アプリケーションフレームワークの変更

| No. | 分類 | 概要 | 修正後バージョン |
|---|---|---|---|
| 1 | 全般 | Jakarta EE 10対応 | ※モジュールバージョン一覧（アプリケーションフレームワーク）参照 |
| 2 | 全般 | Java EEの仕様名等をJakarta EEに変更 | nablarch-common-dao 2.2.0, nablarch-fw-messaging-mom 2.0.1, nablarch-fw-web 2.2.0, nablarch-fw-web-tag 2.1.0 |
| 3 | 稼働環境 | 動作に必要なJavaバージョンを17に変更 | — |
| 4 | 公開API | 公開APIの追加 | nablarch-core 2.2.0, nablarch-core-beans 2.2.0, nablarch-core-jdbc 2.2.0, nablarch-core-message 2.1.0, nablarch-core-transaction 2.1.0, nablarch-fw-jaxrs 2.2.0, nablarch-fw-messaging 2.1.0, nablarch-testing 2.2.0, nablarch-jackson-adaptor 2.1.0, nablarch-lettuce-adaptor 2.2.0, nablarch-micrometer-adaptor 2.1.0, nablarch-router-adaptor 2.1.0 |
| 5 | システム日時 | `SystemTimeUtil`でLocalDateTime型取得に対応 | nablarch-core 2.1.0 |
| 6 | ユニバーサルDAO | エンティティ生成でLocalDateTime/LocalDate型に対応 | nablarch-common-dao 2.1.0 |
| 7 | BeanUtil | Javaレコードに対応（レコードオブジェクトの生成・値コピーが可能） | nablarch-core-beans 2.1.0 |
| 8 | BeanUtil | JSR310アダプタの機能をフレームワーク本体に統合。JSR310アダプタなしでBeanUtilからJSR310使用可。後方互換維持 | nablarch-common-dao 2.2.0, nablarch-core-beans 2.2.0, nablarch-jsr310-adaptor 2.1.0 |
| 9 | Toolbox | 業務画面JSP検証ツール削除（UI開発基盤はNablarch 6で非提供） | nablarch-toolbox 2.1.0 |
| 10 | デフォルト設定 | Jetty一時ディレクトリのデフォルト値を「work」から「target/tmp」に変更（`nablarch.httpTestConfiguration.tempDirectory`プロパティ）。Mavenのcleanで削除されるようtargetディレクトリ配下に変更 | nablarch-default-configration 6u2 |

解説書の変更（No.11-14）:
- Java標準APIのJavadocリンクをJava 17に変更（[解説書トップ](https://nablarch.github.io/docs/6u2/doc/index.html)）
- テスト環境アプリケーションサーバ更新: WebSphere Application Server Liberty 24.0.0.8, Open Liberty 24.0.0.8, Red Hat JBoss EAP 8.0.0, WildFly 33.0.0.Final, Apache Tomcat 10.1.17（[稼働環境](https://nablarch.github.io/docs/6u2/doc/application_framework/application_framework/nablarch/platform.html)）
- AWS分散トレーシング依存ライブラリをJakarta EE対応バージョンに修正: AWS X-Ray SDK 2.15.0, Jersey 3.1.1（[参照](https://nablarch.github.io/docs/6u2/doc/application_framework/cloud_native/distributed_tracing/aws_distributed_tracing.html)）
- ウェブ・RESTfulウェブサービスプロジェクトの疎通確認手順から不要な"compile"実行手順を削除。"compile"は"jetty:run"実行時に合わせて実行されるため、明示的に実行する必要がない（[参照](https://nablarch.github.io/docs/6u2/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Web.html)）

## ブランクプロジェクトの変更

- SpotBugs 4.8.6、FindSecurityBugs 1.13.0に更新
- デフォルトTomcat 10コンテナイメージを`10.1.28-jdk17-temurin`に更新
- Maven Archetype Plugin 3.2.1に更新（警告解消、バッチファイル削除）（[参照](https://nablarch.github.io/docs/6u2/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Web.html)）
- Jacksonを2.17.1に更新（RESTfulウェブサービス）
- Logback 1.5.6、SLF4J 2.0.11に更新（Jakarta Batch）。不要依存（slf4j-nablarch-adaptor, nablarch-jboss-logging-adaptor）削除
- JBeret 2.1.4.Finalに更新（Jakarta Batch）
- Mavenプラグイン各種更新: maven-source-plugin 3.3.1, maven-javadoc-plugin 3.10.0, maven-compiler-plugin 3.13.0, maven-surefire-plugin 3.5.0, jacoco-maven-plugin 0.8.12, jib-maven-plugin 3.4.3, jetty-ee10-maven-plugin 12.0.12 など
- 不要なMavenプラグイン設定削除（maven-failsafe-plugin, maven-dependency-plugin, wagon-webdav-jackrabbit）
- maven-clean-pluginによるwork/jsp削除設定を削除（No.10のJetty一時ディレクトリ変更に伴い不要になったため）

## アダプタの変更

| No. | 分類 | 概要 | 修正後バージョン |
|---|---|---|---|
| 24 | 全般 | Nablarch 6対応（依存関係変更） | ※モジュールバージョン一覧（アダプタ）参照 |
| 25 | SLF4Jアダプタ | SLF4J 2.0以降でも使用できるようSLF4J 2.0.11に更新 | slf4j-nablarch-adaptor 2.1.0 |
| 26 | logアダプタ | SLF4J 2.0以降対応（SLF4J 2.0.11に更新） | nablarch-slf4j-adaptor 2.1.0 |
| 27 | logアダプタ | JBoss Logging 3.6.0.Finalに更新 | nablarch-jboss-logging-adaptor 2.1.0 |
| 28 | Domaアダプタ | Java 17以降サポートのためDoma 2.66.0に更新。Doma 2.44.0より`Daoアノテーションのconfig属性`と`SingletonConfigアノテーション`が非推奨（以前の実装は継続利用可） | nablarch-doma-adaptor 2.1.0 |
| 29 | JAX-RSアダプタ | Jackson 2.17.1に更新 | nablarch-jaxrs-adaptor 2.1.0 |

## Nablarch 6で提供しない機能（削除済み）

以下はNablarch 6では提供しないため解説書から削除されました:
- ETL基盤
- 帳票ライブラリ
- ワークフローライブラリ
- UI開発基盤（業務画面JSP検証ツール含む）

## テスティングフレームワーク

- Nablarch 6で開発したアプリケーションのテストに対応（Jetty 12使用）
- JUnit 5を5.11.0に更新: nablarch-testing-junit5 2.1.0

## Example

| No. | 分類 | 概要 | 修正後バージョン |
|---|---|---|---|
| 30 | 全般 | Nablarch 6を使用するように修正 | ※モジュールバージョン一覧（Example）参照 |
| 31 | RESTfulウェブサービス | Jerseyを3.1.8に、Jacksonを2.17.1に更新 | nablarch-example-rest 6u2 |
| 32 | MOMによるメッセージング | ActiveMQ Artemisを2.37.0に更新。nablarch-example-mom-testing-commonで使用していた非推奨APIを代替APIに変更。対象: nablarch-example-mom-testing-common, nablarch-example-mom-delayed-send, nablarch-example-mom-sync-send-batch, nablarch-example-mom-delayed-receive, nablarch-example-mom-sync-receive | nablarch-example-mom-testing-common 6u2, nablarch-example-mom-delayed-send 6u2, nablarch-example-mom-sync-send-batch 6u2, nablarch-example-mom-delayed-receive 6u2, nablarch-example-mom-sync-receive 6u2 |

## 実装サンプル集

- Nablarch 6対応（nablarch-biz-sample-all 3.0.0）。ソースコードをnablarch-biz-sample-allリポジトリに集約（[参照](https://nablarch.github.io/docs/6u2/doc/examples/index.html)）

## Nablarch開発標準

- Jakarta EE 10対応による修正（Java EEの仕様名等をJakarta EEに変更）: nablarch-development-standards 2.3
- ドメイン定義書サンプルのバリデーション記載をBean Validationに変更（Nablarch Validationから変更）
- JSP自動生成ツール・業務画面JSP検証ツールの記載削除

## 6u2 変更点（6u1からの移行）

## システムへの影響がある変更

> **重要**: 以下の変更はシステムへの影響があります。移行時に対処が必要です。

**Micrometerアダプタ OTLP対応（No.21）**: Micrometerライブラリを1.13.0にバージョンアップ。`micrometer-registry-datadog`、`micrometer-registry-cloudwatch2`、`micrometer-registry-statsd`を依存関係に追加している場合、バージョンの整合性が取れなくなり動作しなくなる可能性があります。バージョンアップ手順に従ってライブラリのバージョンを更新してください（[Micrometerアダプタ解説書](https://nablarch.github.io/docs/6u2/doc/application_framework/adaptors/micrometer_adaptor.html)）。

## アプリケーションフレームワークの変更

| No. | 分類 | 概要 | 修正後バージョン |
|---|---|---|---|
| 1 | 公開API | 公開APIの追加 | nablarch-core 2.2.0, nablarch-core-beans 2.2.0, nablarch-core-jdbc 2.2.0, nablarch-core-message 2.1.0, nablarch-core-transaction 2.1.0, nablarch-fw-jaxrs 2.2.0, nablarch-fw-messaging 2.1.0, nablarch-testing 2.2.0, nablarch-jackson-adaptor 2.1.0, nablarch-lettuce-adaptor 2.2.0, nablarch-micrometer-adaptor 2.1.0, nablarch-router-adaptor 2.1.0 |
| 2 | BeanUtil | JSR310アダプタの機能をフレームワーク本体に統合（後方互換維持） | nablarch-common-dao 2.2.0, nablarch-core-beans 2.2.0, nablarch-jsr310-adaptor 2.1.0 |
| 3 | Toolbox | 業務画面JSP検証ツール削除 | nablarch-toolbox 2.1.0 |
| 4 | CSP対応 | CSPのscript-srcにnonceを使用したポリシーを設定可能に。セキュアハンドラでCSP用nonceを生成でき、Content-Security-PolicyヘッダやJSP内に埋め込み可能（[解説書](https://nablarch.github.io/docs/6u2/doc/application_framework/application_framework/handlers/web/secure_handler.html#content-security-policy)） | nablarch-fw-web 2.2.0, nablarch-fw-web-tag 2.1.0 |
| 5 | デフォルト設定 | Jetty一時ディレクトリのデフォルト値を「work」から「target/tmp」に変更（`nablarch.httpTestConfiguration.tempDirectory`プロパティ）。Mavenのcleanで削除されるようtargetディレクトリ配下に変更（[解説書](https://nablarch.github.io/docs/6u2/doc/application_framework/application_framework/configuration/index.html)） | nablarch-default-configration 6u2 |

解説書の変更（No.6-10）:
- Java標準APIのJavadocリンクをJava 17に変更
- テスト環境アプリケーションサーバ更新: WebSphere Application Server Liberty 24.0.0.8, Open Liberty 24.0.0.8, Red Hat JBoss EAP 8.0.0, WildFly 33.0.0.Final, Apache Tomcat 10.1.17
- テスト環境データベース更新（Oracle Database 23c→23ai名称変更含む）: Oracle Database 12c/19c/21c/23ai, IBM Db2 10.5/11.5, SQL Server 2017/2019/2022, PostgreSQL 10.0/11.5/12.2/13.2/14.0/15.2/16.2
- マイグレーションガイドに6u2のリリース内容を反映（Nablarch 6の正式リリースは6u2から）（[参照](https://nablarch.github.io/docs/6u2/doc/migration/index.html)）
- Bean Validationの使用方法に「バリデーションの明示的な実行」「バリデーションエラー時に任意の処理を行いたい」を追加（[参照](https://nablarch.github.io/docs/6u2/doc/application_framework/application_framework/libraries/validation/bean_validation.html)）

## アダプタの変更

| No. | 分類 | 概要 | 修正後バージョン | システムへの影響 |
|---|---|---|---|---|
| 21 | Micrometerアダプタ | Micrometer 1.13.0に更新、OTLP用レジストリファクトリ追加 | nablarch-micrometer-adaptor 1.3.0 | **あり**（上記参照） |
| 22 | logアダプタ | JBoss Logging 3.6.0.Finalに更新 | nablarch-jboss-logging-adaptor 2.1.0 | なし |
| 23 | Domaアダプタ | Doma 2.66.0に更新。Doma 2.44.0より`Daoアノテーションのconfig属性`と`SingletonConfigアノテーション`が非推奨（以前の実装は継続利用可） | nablarch-doma-adaptor 2.1.0 | なし |
| 24 | JAX-RSアダプタ | Jackson 2.17.1に更新 | nablarch-jaxrs-adaptor 2.1.0 | なし |
| 25 | Micrometerアダプタ解説書 | DataDogの利用手順にサイトの設定案内を追加 | nablarch-micrometer-adaptor 1.3.0 | なし |

## ブランクプロジェクトの変更

- SpotBugs 4.8.6、FindSecurityBugs 1.13.0に更新
- デフォルトTomcat 10コンテナイメージを`10.1.28-jdk17-temurin`に更新
- Maven Archetype Plugin 3.2.1に更新（バッチファイル削除）
- Webアプリケーション: JSTLの除外設定を追加（Jettyプラグイン起動時の警告ログ解消）
- maven-clean-pluginによるwork/jsp削除設定を削除（No.5のJetty一時ディレクトリ変更に伴い不要になったため）
- Jacksonを2.17.1に更新（RESTfulウェブサービス）
- Logback 1.5.6、SLF4J 2.0.11に更新（Jakarta Batch）
- JBeret 2.1.4.Finalに更新（Jakarta Batch）

## テスティングフレームワーク

- Java EEの仕様名等をJakarta EEに変更: nablarch-testing 2.2.0
- Jetty 12を12.0.12に更新、不要なecjライブラリを削除: nablarch-testing 2.2.0, nablarch-testing-jetty12 1.1.0
- JUnit 5を5.11.0に更新: nablarch-testing-junit5 2.1.0

## Example

| No. | 分類 | 概要 | 修正後バージョン |
|---|---|---|---|
| 26 | ウェブアプリケーション | No.4のCSP対応を取り込み、script-srcでnonceを使用する例に変更 | nablarch-example-web 6u2 |
| 27 | RESTfulウェブサービス | Jerseyを3.1.8に、Jacksonを2.17.1に更新 | nablarch-example-rest 6u2 |
| 28 | MOMによるメッセージング | ActiveMQ Artemisを2.37.0に更新。nablarch-example-mom-testing-commonで使用していた非推奨APIを代替APIに変更。対象: nablarch-example-mom-testing-common, nablarch-example-mom-delayed-send, nablarch-example-mom-sync-send-batch, nablarch-example-mom-delayed-receive, nablarch-example-mom-sync-receive | nablarch-example-mom-testing-common 6u2, nablarch-example-mom-delayed-send 6u2, nablarch-example-mom-sync-send-batch 6u2, nablarch-example-mom-delayed-receive 6u2, nablarch-example-mom-sync-receive 6u2 |

## 実装サンプル集

- Nablarch 6対応。ソースコードをnablarch-biz-sample-allリポジトリに集約

## Nablarch開発標準

- Jakarta EE 10対応による修正（Java EEの仕様名等をJakarta EEに変更）: nablarch-development-standards 2.3
- JSP自動生成ツールの記載削除（OSSとして非公開のため）
- ドメイン定義書サンプルのバリデーション記載をBean Validationに変更
- 業務画面JSP検証ツールの記載削除

## バージョンアップ手順

## 5系からバージョンアップする場合

[解説書のNablarch 5から6への移行ガイド](https://nablarch.github.io/docs/6u2/doc/migration/index.html)を参照。

## 6u1からバージョンアップする場合

1. `pom.xml`の`<dependencyManagement>`セクションに指定されている`nablarch-bom`のバージョンを`6u2`に書き換える
2. Micrometerアダプタを利用しており、`pom.xml`の`<dependencies>`に以下が指定されている場合、バージョンを`1.13.0`に書き換える:
   - `micrometer-registry-datadog`
   - `micrometer-registry-cloudwatch2`
   - `micrometer-registry-statsd`
3. Mavenのビルドを再実行する

## モジュールバージョン一覧

6u2に対応するモジュールおよびバージョンの一覧です（内部向けモジュールを除く）。

| 種類 | Group ID | Artifact ID | バージョン |
|---|---|---|---|
| ブランクプロジェクト | com.nablarch.archetype | nablarch-single-module-archetype | 6u2 |
| Example | com.nablarch.example | nablarch-example-web | 6u2 |
| Example | com.nablarch.example | nablarch-example-thymeleaf-web | 6u2 |
| Example | com.nablarch.example | nablarch-example-rest | 6u2 |
| Example | com.nablarch.example | nablarch-example-http-messaging-send | 6u2 |
| Example | com.nablarch.example | nablarch-example-http-messaging | 6u2 |
| Example | com.nablarch.example | nablarch-example-batch-ee | 6u2 |
| Example | com.nablarch.example | nablarch-example-batch | 6u2 |
| Example | com.nablarch.example | nablarch-example-mom-delayed-send | 6u2 |
| Example | com.nablarch.example | nablarch-example-mom-sync-send-batch | 6u2 |
| Example | com.nablarch.example | nablarch-example-mom-delayed-receive | 6u2 |
| Example | com.nablarch.example | nablarch-example-mom-sync-receive | 6u2 |
| Example | com.nablarch.example | nablarch-example-db-queue | 6u2 |
| Example | com.nablarch.example | nablarch-example-mom-testing-common | 6u2 |
| 実装サンプル集 | com.nablarch.applib | nablarch-biz-sample-all | 3.0.0 |
| アプリケーションフレームワーク | com.nablarch.configuration | nablarch-main-default-configuration | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.configuration | nablarch-testing-default-configuration | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-backward-compatibility | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-auth | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-auth-jdbc | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-code | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-code-jdbc | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-dao | 2.2.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-databind | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-date | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-encryption | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-exclusivecontrol | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-exclusivecontrol-jdbc | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-idgenerator | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-idgenerator-jdbc | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-common-jdbc | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-core | 2.2.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-core-applog | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-core-beans | 2.2.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-core-dataformat | 2.0.1 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-core-jdbc | 2.2.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-core-message | 2.1.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-core-repository | 2.0.1 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-core-transaction | 2.1.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-core-validation | 2.0.1 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-core-validation-ee | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-batch | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-batch-ee | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-jaxrs | 2.2.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-messaging | 2.1.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-messaging-http | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-messaging-mom | 2.0.1 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-standalone | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-web | 2.2.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-web-dbstore | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-web-doublesubmit-jdbc | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-web-extension | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-web-hotdeploy | 2.0.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-fw-web-tag | 2.1.0 |
| アプリケーションフレームワーク | com.nablarch.framework | nablarch-mail-sender | 2.0.0 |
| テスティングフレームワーク | com.nablarch.framework | nablarch-testing | 2.2.0 |
| テスティングフレームワーク | com.nablarch.framework | nablarch-testing-jetty12 | 1.1.0 |
| テスティングフレームワーク | com.nablarch.framework | nablarch-testing-rest | 2.0.0 |
| アダプタ | com.nablarch.integration | nablarch-jersey-adaptor | 2.1.0 |
| アダプタ | com.nablarch.integration | nablarch-resteasy-adaptor | 2.1.0 |
| アダプタ | com.nablarch.integration | nablarch-jackson-adaptor | 2.1.0 |
| アダプタ | com.nablarch.integration | nablarch-jboss-logging-adaptor | 2.1.0 |
| アダプタ | com.nablarch.integration | nablarch-router-adaptor | 2.1.0 |
| アダプタ | com.nablarch.integration | nablarch-slf4j-adaptor | 2.1.0 |
| アダプタ | com.nablarch.integration | nablarch-doma-adaptor | 2.1.0 |
| アダプタ | com.nablarch.integration | nablarch-jsr310-adaptor | 2.1.0 |
| アダプタ | com.nablarch.integration | nablarch-mail-sender-freemarker-adaptor | 2.0.0 |
| アダプタ | com.nablarch.integration | nablarch-mail-sender-thymeleaf-adaptor | 2.0.0 |
| アダプタ | com.nablarch.integration | nablarch-mail-sender-velocity-adaptor | 2.0.0 |
| アダプタ | com.nablarch.integration | nablarch-web-thymeleaf-adaptor | 2.0.0 |
| アダプタ | com.nablarch.integration | nablarch-lettuce-adaptor | 2.2.0 |
| アダプタ | com.nablarch.integration | nablarch-micrometer-adaptor | 2.1.0 |
| アダプタ | com.nablarch.integration | slf4j-nablarch-adaptor | 2.1.0 |
| アダプタ | com.nablarch.integration | nablarch-wmq-adaptor | 2.1.0 |
| 開発ツール | com.nablarch.tool | nablarch-toolbox | 2.1.0 |
