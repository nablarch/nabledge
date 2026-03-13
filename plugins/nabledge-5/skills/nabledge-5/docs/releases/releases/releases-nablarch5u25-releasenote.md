# Nablarch 5u25 リリースノート

**公式ドキュメント**: [1](https://nablarch.github.io/docs/5u25/doc/application_framework/application_framework/handlers/web/secure_handler.html#content-security-policy) [2](https://nablarch.github.io/docs/5u25/doc/application_framework/application_framework/libraries/validation/bean_validation.html) [3](https://nablarch.github.io/docs/5u25/doc/application_framework/application_framework/nablarch/platform.html) [4](https://nablarch.github.io/docs/5u25/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Web.html) [5](https://nablarch.github.io/docs/5u25/doc/application_framework/adaptors/jaxrs_adaptor.html#id2) [6](https://nablarch.github.io/docs/5u25/doc/application_framework/adaptors/micrometer_adaptor.html)

## Nablarch 5u25 変更内容

## Nablarch 5u25 変更内容

5u24からの変更点。

### アプリケーションフレームワーク

| No. | 分類 | 概要 | 修正後バージョン | システムへの影響 |
|---|---|---|---|---|
| 1 | 公開API | 解説書で案内しているAPIで公開APIになっていないものを公開APIとして追加 | nablarch-core 1.7.0, nablarch-core-beans 1.5.0, nablarch-core-jdbc 1.9.0, nablarch-core-message 1.2.0, nablarch-core-transaction 1.2.0, nablarch-fw-jaxrs 1.5.0, nablarch-fw-messaging 1.3.0, nablarch-testing 1.7.0, nablarch-jackson-adaptor 1.1.0, nablarch-lettuce-adaptor 1.1.0, nablarch-micrometer-adaptor 1.3.0, nablarch-router-adaptor 1.3.0 | なし |
| 2 | CSP対応 | CSPのscript-srcにnonceを使用したポリシーを設定可能に。セキュアハンドラでCSP用nonceの生成およびContent-Security-PolicyヘッダやJSP内に埋め込めるようになりました | nablarch-fw-web 1.14.0, nablarch-fw-web-tag 1.4.0 | なし |
| 3 | Bean Validation | バリデーションの明示的な実行方法・バリデーションエラー時に任意の処理を行う方法を解説書に追加 | nablarch-document 5u25 | なし |
| 4 | 稼働環境 | Oracle Database 23cの名称が23aiに変更されたためテスト環境DBを更新。対応DB: Oracle Database 12c/19c/21c/23ai, IBM Db2 10.5/11.5, SQL Server 2017/2019/2022, PostgreSQL 10.0/11.5/12.2/13.2/14.0/15.2/16.2 | nablarch-document 5u25 | なし |
| 5 | 全般（ブランクプロジェクト） | Maven Archetype Pluginのバージョンを3.2.1に更新し警告を解消。ブランクプロジェクト作成用バッチファイルは削除（過去バージョン指定が不要になったため） | nablarch-single-module-archetype 5u25 | なし |

### アダプタ

| No. | 分類 | 概要 | 修正後バージョン | システムへの影響 |
|---|---|---|---|---|
| 6 | JAX-RSアダプタ | テストで使用するJacksonライブラリのバージョンを2.12.7.1に更新 | nablarch-document 5u25 | なし |
| 7 | Micrometerアダプタ | Micrometerライブラリを1.13.0に更新。OTLP（OpenTelemetry Protocol）用のレジストリファクトリを追加し、OTLPをサポートする監視サービスとの連携が可能 | nablarch-micrometer-adaptor 1.3.0 | **あり** |

> **重要**: No.7 Micrometerアダプタ: CloudWatchまたはDatadog連携用ライブラリ（`micrometer-registry-datadog`、`micrometer-registry-cloudwatch2`、`micrometer-registry-statsd`）をpom.xmlの`<dependencies>`に指定している場合、バージョンの整合性が取れなくなり動作しなくなる可能性があります。バージョンアップ手順に従ってこれらのバージョンを1.13.0に更新してください。

### Example

| No. | 分類 | 概要 | 修正後バージョン | システムへの影響 |
|---|---|---|---|---|
| 8 | ウェブアプリケーション | No.2のCSP対応を取り込み、script-srcでnonceを使用する例に変更 | nablarch-example-web 5u25 | なし |

### 参照先

- [CSP対応（セキュアハンドラ）](https://nablarch.github.io/docs/5u25/doc/application_framework/application_framework/handlers/web/secure_handler.html#content-security-policy)
- [Bean Validation](https://nablarch.github.io/docs/5u25/doc/application_framework/application_framework/libraries/validation/bean_validation.html)
- [稼働環境](https://nablarch.github.io/docs/5u25/doc/application_framework/application_framework/nablarch/platform.html)
- [ブランクプロジェクト初期セットアップ（Web）](https://nablarch.github.io/docs/5u25/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Web.html)
- [JAX-RSアダプタ](https://nablarch.github.io/docs/5u25/doc/application_framework/adaptors/jaxrs_adaptor.html#id2)
- [Micrometerアダプタ](https://nablarch.github.io/docs/5u25/doc/application_framework/adaptors/micrometer_adaptor.html)

<details>
<summary>keywords</summary>

Nablarch 5u25 リリースノート, 5u24からの変更点, CSP対応, nonceポリシー, script-src, Bean Validation明示的実行, Micrometerアダプタ, OTLP, Maven Archetype Plugin 3.x, 公開API追加, Oracle Database 23ai, nablarch-fw-web, nablarch-fw-web-tag, nablarch-micrometer-adaptor, nablarch-core, nablarch-core-beans, nablarch-core-jdbc, nablarch-core-message, nablarch-core-transaction, nablarch-fw-jaxrs, nablarch-fw-messaging, nablarch-testing, nablarch-jackson-adaptor, nablarch-lettuce-adaptor, nablarch-router-adaptor, nablarch-example-web, nablarch-single-module-archetype

</details>

## バージョンアップ手順

## バージョンアップ手順

| No. | 適用手順 |
|---|---|
| 1 | pom.xmlの`<dependencyManagement>`セクションに指定されているnablarch-bomのバージョンを`5u25`に書き換える |
| 2 | Micrometerアダプタを利用しており、pom.xmlの`<dependencies>`に以下が指定されている場合、バージョンを`1.13.0`に書き換える: `micrometer-registry-datadog`、`micrometer-registry-cloudwatch2`、`micrometer-registry-statsd` |
| 3 | mavenのビルドを再実行する |

<details>
<summary>keywords</summary>

バージョンアップ手順, 5u25適用手順, nablarch-bom, micrometer-registry-datadog, micrometer-registry-cloudwatch2, micrometer-registry-statsd, pom.xml更新, 5u25移行

</details>
