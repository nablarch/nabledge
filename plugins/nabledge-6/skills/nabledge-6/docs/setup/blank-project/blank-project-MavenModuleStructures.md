# Mavenアーキタイプの構成

**公式ドキュメント**: [Mavenアーキタイプの構成](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/MavenModuleStructures/index.html)

## Mavenアーキタイプ一覧

NablarchのMavenアーキタイプ一覧。グループIDはすべて `com.nablarch.archetype`。

| アーティファクトID | 説明 |
|---|---|
| nablarch-web-archetype | ウェブアプリケーション実行制御基盤を使用する場合のアーキタイプ |
| nablarch-jaxrs-archetype | RESTfulウェブサービス実行制御基盤を使用する場合のアーキタイプ |
| nablarch-batch-ee-archetype | Jakarta Batch準拠バッチアプリケーションフレームワークを使用する場合のアーキタイプ |
| nablarch-batch-archetype | Nablarch独自バッチアプリケーション実行制御基盤を使用する場合のアーキタイプ |
| nablarch-batch-dbless-archetype | Nablarch独自バッチアプリケーション実行制御基盤を使用するがDBに接続しない場合のアーキタイプ |
| nablarch-container-web-archetype | `nablarch-web-archetype` のDockerコンテナ版アーキタイプ |
| nablarch-container-jaxrs-archetype | `nablarch-jaxrs-archetype` のDockerコンテナ版アーキタイプ |
| nablarch-container-batch-archetype | `nablarch-batch-archetype` のDockerコンテナ版アーキタイプ |
| nablarch-container-batch-dbless-archetype | `nablarch-batch-dbless-archetype` のDockerコンテナ版アーキタイプ |

<details>
<summary>keywords</summary>

nablarch-web-archetype, nablarch-jaxrs-archetype, nablarch-batch-ee-archetype, nablarch-batch-archetype, nablarch-batch-dbless-archetype, nablarch-container-web-archetype, nablarch-container-jaxrs-archetype, nablarch-container-batch-archetype, nablarch-container-batch-dbless-archetype, com.nablarch.archetype, Mavenアーキタイプ種別

</details>

## 全体構成の概要

nablarch-web-archetypeで `pj-web`（war）、nablarch-batch-archetypeで `pj-batch`（jar）を生成した場合のプロジェクト構成例。

| Mavenプロジェクト名 | パッケージング | 用途 |
|---|---|---|
| pj-web | war | ウェブアプリケーション実行制御基盤を使用するアプリケーション。warファイルとしてアプリケーションサーバにデプロイ。 |
| pj-batch | jar | Nablarch独自のバッチアプリケーション実行制御基盤を使用するアプリケーション。 |

> **補足**: 自動生成エンティティは[gsp-dba-maven-plugin](https://github.com/coastland/gsp-dba-maven-plugin)を使用した場合に生成される。使用する場合は [../addin_gsp](blank-project-addin_gsp.md) の設定が必要。

<details>
<summary>keywords</summary>

pj-web, pj-batch, warパッケージング, jarパッケージング, gsp-dba-maven-plugin, プロジェクト全体構成

</details>

## 各構成要素のプロジェクト一覧

各アーキタイプから生成されるMavenプロジェクトの対応表。

| Mavenプロジェクト名 | 生成元のMaven archetype |
|---|---|
| pj-jaxrs | nablarch-jaxrs-archetype |
| pj-batch-dbless | nablarch-batch-dbless-archetype |
| pj-batch-ee | nablarch-batch-ee-archetype |
| pj-container-web | nablarch-container-web-archetype |
| pj-container-jaxrs | nablarch-container-jaxrs-archetype |
| pj-container-batch | nablarch-container-batch-archetype |
| pj-container-batch-dbless | nablarch-container-batch-dbless-archetype |

<details>
<summary>keywords</summary>

pj-jaxrs, pj-batch-dbless, pj-batch-ee, pj-container-web, pj-container-jaxrs, pj-container-batch, pj-container-batch-dbless, アーキタイプ対応表

</details>

## 各構成要素の詳細（nablarch-archetype-parent概要）

nablarch-archetype-parentは、各アーキタイプから作成したプロジェクトの親プロジェクト。利用者が直接書き換えることはない。

主な設定内容:
- 各種Mavenプラグインのバージョン
- 各種ツールが使用するファイルのパス

<details>
<summary>keywords</summary>

nablarch-archetype-parent, 親プロジェクト, Mavenプラグインバージョン, ツールファイルパス設定

</details>

## nablarch-archetype-parentの所在

アーキタイプから生成したプロジェクトを一度でもビルドすると、以下のパスにnablarch-archetype-parentのpom.xmlがキャッシュされる。設定を確認する場合はキャッシュされたpom.xmlを参照。

```
<ホームディレクトリ>/.m2/repository/com/nablarch/archetype/
```

<details>
<summary>keywords</summary>

nablarch-archetype-parent, .m2/repository, pom.xmlキャッシュ, com.nablarch.archetype

</details>

## pj-webプロジェクトの構成

ウェブアプリケーションのwarファイルとしてパッケージングされるプロジェクト。

```
myapp-web
|
|   pom.xml                     … Mavenの設定ファイル
|   README.md
|
+---db                          … 疎通アプリケーション用のDDL及びInsert文（RDBMS別）
|
+---h2
|   +---bin                     … H2起動用ファイル
|   |
|   \---db
|           SAMPLE.mv.db        … H2のデータファイル
|           SAMPLE.mv.db.org    … バックアップ（H2起動不能時にSAMPLE.mv.dbにコピーして使用）
|
+---src
|   +---env                     … 環境別の設定ファイル
|   |
|   +---main
|   |   +---java                … 疎通確認用アプリケーションのクラス
|   |   |
|   |   +---resources           … 開発環境・本番環境で共用する設定ファイル
|   |   |   |
|   |   |   +---entity          … ER図サンプル（gsp-dba-maven-plugin用）
|   |   |   |
|   |   |   \---net             … ルーティングアダプタ用設定ファイル
|   |   |
|   |   \---webapp
|   |       +---images
|   |       |
|   |       \---WEB-INF         … web.xml格納
|   |            |
|   |            +---errorPages … エラー画面サンプル
|   |            |
|   |            \---test       … 疎通確認画面用ファイル
|   |
|   \---test
|       +---java                … 疎通テスト用ユニットテスト
|       |
|       \---resources
|           |
|           +---data            … gsp-dba-maven-plugin用サンプルデータ
|           |
|           \---nablarch        … HTMLチェックツール用データ
|
+---tmp                         … リクエスト単体テスト用（疎通テスト実行時に自動生成）
|
+---tools                       … Mavenと連携するツールの設定ファイル
|
\---work                        … 入出力ファイル用作業ディレクトリ（疎通確認時に自動生成）
```

<details>
<summary>keywords</summary>

pj-web, WEB-INF, web.xml, src/env, src/main/resources, ルーティングアダプタ, HTMLチェックツール, H2, ディレクトリ構成

</details>

## ツールの設定

toolsフォルダ内の主なディレクトリ・ファイル。

| ディレクトリまたはファイル | 説明 |
|---|---|
| nablarch-tools.xml | Jakarta Server Pages静的解析ツールの設定ファイル |
| static-analysis/jspanalysis | Jakarta Server Pages静的解析ツールの設定ファイル格納ディレクトリ |

<details>
<summary>keywords</summary>

nablarch-tools.xml, Jakarta Server Pages静的解析, static-analysis/jspanalysis, JSP静的解析ツール

</details>

## pj-jaxrsプロジェクトの構成

RESTfulウェブサービスアプリケーションのwarファイルとしてパッケージングされるプロジェクト。プロジェクト構成はpj-webと同一。

<details>
<summary>keywords</summary>

pj-jaxrs, RESTfulウェブサービス, JAX-RS, warパッケージング

</details>

## pj-batch-eeプロジェクトの構成

Jakarta Batch準拠バッチアプリケーションのjarファイルとしてパッケージされるプロジェクト。

pj-web/pj-batchに存在しない追加要素:

```
myapp-batch-ee
|   distribution.xml                        … maven-assembly-pluginで使用する設定ファイル
|
+---src
|   +---main
|   |   \---resources
|   |       |   batch-boot.xml              … バッチ起動時に使用する設定ファイル
|   |       |
|   |       \---META-INF
|   |           |   beans.xml               … Jakarta Contexts and Dependency Injectionを有効化するために必要なファイル
|   |           |
|   |           \---batch-jobs
|   |                   sample-batchlet.xml … batchlet方式の疎通確認用ジョブファイル
|   |                   sample-chunk.xml    … chunk方式の疎通確認用ジョブファイル
|
\---testdata                                … ETL機能の入出力ファイル用作業ディレクトリ
```

<details>
<summary>keywords</summary>

pj-batch-ee, Jakarta Batch, batch-boot.xml, beans.xml, batchlet, chunk, distribution.xml, META-INF/batch-jobs, Contexts and Dependency Injection

</details>

## pj-batch-eeの本番環境へのリリース

pj-batch-eeのビルド時に `target` 配下に生成されるzipファイルには、実行可能jarと依存ライブラリが格納される。

リリース手順:
1. zipファイルを任意のディレクトリに解凍する。
2. 以下のコマンドでバッチを実行する。

```bash
java -jar <実行可能jarファイル名> <ジョブ名>
```

<details>
<summary>keywords</summary>

pj-batch-ee, バッチリリース, zipデプロイ, 実行可能jar, ジョブ名指定

</details>

## pj-batchプロジェクトの構成

Nablarchバッチアプリケーションのjarファイルとしてパッケージされるプロジェクト。

pj-webに存在しない追加要素:

```
myapp-batch
|   distribution.xml                        … maven-assembly-pluginで使用する設定ファイル
|
+---src
|   +---main
|   |   +---resources
|   |   |   |   batch-boot.xml          … 都度起動バッチ起動時の設定ファイル
|   |   |   |   mail-sender-boot.xml    … メール送信バッチ起動時の設定ファイル
|   |   |   |   resident-batch-boot.xml … テーブルをキューとして使ったメッセージング起動時の設定ファイル
|   |   |   |
|   |   |   \---entity
|   |   |
|   |   \---scripts                     … バッチ起動用シェルスクリプト（使用は任意）
```

<details>
<summary>keywords</summary>

pj-batch, batch-boot.xml, mail-sender-boot.xml, resident-batch-boot.xml, シェルスクリプト, メール送信バッチ, テーブルキューメッセージング

</details>

## pj-batchの本番環境へのリリース

pj-batchのビルド時に `target` 配下に生成されるzipファイルには、実行可能jarと依存ライブラリが格納される。

リリース手順:
1. zipファイルを任意のディレクトリに解凍する。
2. 以下のコマンドでバッチを実行する。

```bash
java -jar <実行可能jarファイル名> ^
    -diConfig <コンポーネント設定ファイル> ^
    -requestPath <リクエストパス> ^
    -userId <ユーザID>
```

<details>
<summary>keywords</summary>

pj-batch, バッチリリース, -diConfig, -requestPath, -userId, 実行可能jar, コンポーネント設定ファイル

</details>

## pj-batch-dblessプロジェクトの構成

DBに接続しないNablarchバッチアプリケーションのjarファイルとしてパッケージされるプロジェクト。プロジェクト構成は :ref:`pj-batchプロジェクトの構成 <firstStepBatchProjectStructure>` からDB関連のディレクトリ・ファイルを除いたもの。

<details>
<summary>keywords</summary>

pj-batch-dbless, DB接続なし, DBレスバッチ, nablarch-batch-dbless-archetype

</details>

## 本番環境へのリリースについて

バッチアプリケーションのビルド時に `target` 配下に生成されるzipファイルの中には、バッチアプリケーションの実行可能jarと依存ライブラリが格納されている。

本番環境へのリリース時は、以下の手順でバッチを実行できる:

1. zipファイルを任意のディレクトリに解凍する。
2. 以下のコマンドでバッチを実行する。

```bash
java -jar <実行可能jarファイル名> ^
    -diConfig <コンポーネント設定ファイル> ^
    -requestPath <リクエストパス> ^
    -userId <ユーザID>
```

<details>
<summary>keywords</summary>

本番リリース, バッチリリース, zipファイル, 実行可能jar, java -jar, -diConfig, -requestPath, -userId, 依存ライブラリ, target配下

</details>

## pj-container-webプロジェクト

ウェブアプリケーションがデプロイされたTomcatベースのDockerイメージをビルドするプロジェクト。

## プロジェクトの構成

```
myapp-container-web
|
|   pom.xml                     … Mavenの設定ファイル
|   README.md                   … 本プロジェクトの補足説明(読み終わったら削除可)
|
+---db                          … 疎通アプリケーション用のDDL及びInsert文。RDBMS別に格納されている。
|
+---h2
|   +---bin                     … H2の起動に使用するファイルが格納されている。
|   |
|   \---db
|           SAMPLE.h2.db        … H2のデータファイル。
|           SAMPLE.h2.db.org    … H2のデータファイルのバックアップ。H2が起動しなくなった場合に「SAMPLE.h2.db」にコピーして使用する。
|
+---src
|   +---main
|   |   +---java                … 疎通確認用アプリケーションのクラスが格納されている。
|   |   |
|   |   +---resources           … 直下には設定ファイルが格納されている。
|   |   |   |
|   |   |   +---entity          … ER図のサンプル。gsp-dba-maven-pluginを使用する際のサンプルデータ。
|   |   |   |
|   |   |   \---net             … ルーティングアダプタ用設定ファイルが格納されている。
|   |   |
|   |   +---jib                 … コンテナイメージ上に配置するファイルが格納されている。
|   |   |
|   |   \---webapp
|   |       +---images          … 疎通確認用の画像ファイルが格納されている。
|   |       |
|   |       \---WEB-INF         … web.xmlが格納されている。
|   |            |
|   |            +---errorPages … エラー画面のサンプルが格納されている。
|   |            |
|   |            \---test       … 疎通確認画面用のファイルが格納されている。
|   |
|   \---test
|       +---java                … 疎通テスト用のユニットテストが格納されている。
|       |
|       \---resources           … ユニットテスト用の設定ファイルが格納されている。
|           |
|           +---data            … gsp-dba-maven-pluginを使用する際のサンプルデータ。
|           |
|           \---nablarch        … HTMLチェックツール用のデータが格納されている。
|
+---tmp                         … ウェブアプリケーションのリクエスト単体テストで使用されるディレクトリ。疎通テスト実行時に自動生成される。
|
+---tools                       … Mavenと連携させて使用するツールの設定ファイルが格納されている。
|
\---work                        … 開発時に入力・出力ファイルを格納するための作業用ディレクトリ。疎通確認時に自動生成される。
```

## src/main/jib について

`src/main/jib` に配置したディレクトリやファイルは、そのままコンテナ上に配置される。たとえば、`src/main/jib/var/foo.txt` というファイルを配置した状態でコンテナイメージをビルドすると、コンテナ上の `/var/foo.txt` にファイルが配置される。

詳細は [Jibのドキュメント](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin#adding-arbitrary-files-to-the-image) を参照。

ブランクプロジェクトでは、Tomcatのログ出力を全て標準出力にするために、Tomcatの設定ファイルがいくつか `src/main/jib` に配置されている。

<details>
<summary>keywords</summary>

pj-container-web, コンテナWebプロジェクト, Tomcat, Dockerイメージ, src/main/jib, jibディレクトリ, コンテナ配置, 標準出力, Tomcatログ, Jibプラグイン

</details>

## pj-container-jaxrsプロジェクト

RESTfulウェブサービスアプリケーションがデプロイされたTomcatベースのDockerイメージをビルドするプロジェクト。

プロジェクトの構成はコンテナ版Webと同一であるため省略。

<details>
<summary>keywords</summary>

pj-container-jaxrs, RESTfulウェブサービス, JAX-RS, コンテナJAX-RSプロジェクト, Tomcat, Dockerイメージ

</details>

## pj-container-batchプロジェクト

NablarchバッチアプリケーションがデプロイされたLinuxサーバのDockerイメージをビルドするプロジェクト。

## プロジェクトの構成

(ディレクトリ及びファイルの説明は、コンテナ版Webに存在しない要素についてのみ記載)

```
myapp-container-batch
|
|   pom.xml
|   README.md
|
+---db
|
+---h2
|   +---bin
|   |
|   \---db
|           SAMPLE.mv.db
|           SAMPLE.mv.db.org
|
+---src
|   +---main
|   |   +---java
|   |   |
|   |   +---jib
|   |   |
|   |   +---resources
|   |   |   |   batch-boot.xml              … 都度起動バッチ起動時に指定する設定ファイル。
|   |   |   |   mail-sender-boot.xml        … メール送信バッチ起動時に指定する設定ファイル。
|   |   |   |   resident-batch-boot.xml     … テーブルをキューとして使ったメッセージング起動時に指定する設定ファイル。
|   |   |   |
|   |   |   \---entity
|   |   |
|   |   \---scripts                         … バッチ等の起動に使用するためのシェルスクリプトファイル(使用は任意)。
|   |
|   \---test
|       +---java
|       |
|       \---resources
|           |
|           \---data
|
\---work
```

各バッチタイプに応じて起動時に指定する設定ファイルが異なる:

| 設定ファイル | 用途 |
|---|---|
| `batch-boot.xml` | 都度起動バッチ起動時に指定する設定ファイル |
| `mail-sender-boot.xml` | メール送信バッチ起動時に指定する設定ファイル |
| `resident-batch-boot.xml` | テーブルをキューとして使ったメッセージング起動時に指定する設定ファイル |

<details>
<summary>keywords</summary>

pj-container-batch, コンテナバッチプロジェクト, batch-boot.xml, mail-sender-boot.xml, resident-batch-boot.xml, 都度起動バッチ, メール送信バッチ, テーブルキューメッセージング, scripts, シェルスクリプト, Linuxサーバ

</details>

## pj-container-batch-dblessプロジェクト

DBに接続しないNablarchバッチアプリケーションがデプロイされたLinuxサーバのDockerイメージをビルドするプロジェクト。

プロジェクトの構成は `pj-container-batch` プロジェクトの構成からDB関連のディレクトリ及びファイルを除いただけであるため省略。

<details>
<summary>keywords</summary>

pj-container-batch-dbless, DBなしバッチ, DB非接続バッチ, コンテナバッチdbless

</details>

## プロファイル一覧

各Mavenプロジェクトで定義されているプロファイル:

| プロファイル名 | 概要 |
|---|---|
| dev | 開発環境用及びユニットテスト実行用。`src/env/dev/resources` ディレクトリのリソースを使用する。 |
| prod | 本番環境用。`src/env/prod/resources` ディレクトリのリソースを使用する。 |

> **補足**: `pom.xml` 中のdevプロファイルに `activeByDefault` 要素が記述されており、デフォルトでdevプロファイルが使用される。

> **注意**: コンテナ用プロジェクトでは、環境ごとの違いはプロファイルではなくOS環境変数を使って切り替える。コンテナ用プロジェクトにはプロファイルが定義されていない。詳細は :ref:`container_production_config` を参照。

本番環境用WARファイルを作成する場合、`pj-web` モジュール配下で本番環境用プロファイルを指定して実行する:

```bash
mvn package -P prod -DskipTests=true
```

> **補足**: 本番環境用プロファイルではユニットテストの実行に失敗するため、`-DskipTests=true` でスキップを指定する。

<details>
<summary>keywords</summary>

プロファイル, dev, prod, mvn package, activeByDefault, コンテナ環境変数, 本番用WAR, -P prod, -DskipTests

</details>

## ビルドフェーズに追加されているゴール一覧

Mavenのデフォルトビルドフェーズに加えて設定されているゴール:

| ビルドフェーズ | ゴール | 概要 |
|---|---|---|
| initialize | jacoco:prepare-agent | JaCoCoの実行時エージェントを準備する |
| pre-integration-test | jacoco:prepare-agent-integration | 結合試験用にJaCoCoの実行時エージェントを準備する |

設定の詳細は各プロジェクトの `pom.xml` 及び :ref:`about_maven_parent_module` の `pom.xml` を参照。

> **補足**: gsp-dba-maven-pluginの実行はMavenのビルドフェーズに紐づかない。エンティティの自動生成などgsp-dba-maven-pluginのゴールを実行する場合は手動でゴールを実行すること。

<details>
<summary>keywords</summary>

JaCoCo, jacoco:prepare-agent, jacoco:prepare-agent-integration, ビルドフェーズ, gsp-dba-maven-plugin, カバレッジ, initialize, pre-integration-test

</details>

## コンパイルに関する設定

コンパイルに関する設定（Javaバージョン、ファイルエンコーディング、JDBCドライバ等）は、各プロジェクトの `pom.xml` 及び :ref:`about_maven_parent_module` の `pom.xml` を参照。

<details>
<summary>keywords</summary>

コンパイル設定, pom.xml, Javaバージョン, エンコーディング, JDBCドライバ

</details>

## ビルド設定

以下のような場合は、各モジュールの `pom.xml` を変更する:

- モジュール個別で使用する依存ライブラリを追加・変更する。例えば、使用するNablarchのバージョンを変更するために、`nablarch-bom` のバージョンを修正する場合が該当する。
- モジュール個別で使用するMavenプラグインを追加・変更する。

<details>
<summary>keywords</summary>

ビルド設定, pom.xml変更, Mavenプラグイン追加, 依存ライブラリ変更, モジュール個別設定

</details>

## 使用するNablarchのバージョンを変更する場合の例

各モジュールの `pom.xml` でNablarchのバージョンを変更する場合の設定例（Nablarch6u2を使用する場合）:

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>com.nablarch.profile</groupId>
      <artifactId>nablarch-bom</artifactId>
      <!--
      使用するNablarchのバージョンと対応したバージョンを指定する。
      この例は6u2を指定している。
      -->
      <version>6u2</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

<details>
<summary>keywords</summary>

nablarch-bom, Nablarchバージョン変更, dependencyManagement, 6u2, com.nablarch.profile

</details>

## 依存ライブラリ追加の例

`pj-web` モジュールで `nablarch-common-encryption` への依存を追加する場合の例:

```xml
<dependencies>
  <dependency>
    <groupId>com.nablarch.framework</groupId>
    <artifactId>nablarch-common-encryption</artifactId>
  </dependency>
</dependencies>
```

Nablarchのライブラリは `pom.xml` にバージョン番号を指定しなくても良い（`nablarch-bom` のバージョン指定により個々のライブラリのバージョンが決定するため）。

> **警告**: 依存を追加する場合はscopeの設定を適切に行うこと。scopeの設定を怠ると、ユニットテストでのみ使用するはずのモジュールが本番でも使用されるといった問題が起きる可能性がある。

<details>
<summary>keywords</summary>

依存ライブラリ追加, nablarch-common-encryption, scope, Maven依存性, com.nablarch.framework

</details>

## 【参考】プロジェクト分割方針

## 推奨するプロジェクト構成の方針

推奨するプロジェクト構成の方針:

- 作成するアプリケーションが１つの場合（ウェブのみ、バッチのみ等）は、それぞれ単体のプロジェクトで構成する。
- 社内用と社外用で２つのウェブアプリケーションを作成するようなケースでは、無理に１つのMavenプロジェクトにまとめず、個別にMavenプロジェクトを作ること。
- 複数のアプリケーションが存在し、共通化したいライブラリが存在する場合は、共通ライブラリを配置するMavenプロジェクトを作る。
- 実行制御基盤を追加した際は、実行制御基盤毎にMavenプロジェクトを作る。例えば、メッセージング実行制御基盤を使用したアプリケーションを追加する場合は、新しくMavenプロジェクトを作る。
- 必要以上にプロジェクトは分割しない。

> **補足**: プロジェクトを分割する際には、リソースの重複が無い様に注意すること。例えば、[gsp-dba-maven-plugin](https://github.com/coastland/gsp-dba-maven-plugin) で使用するedmファイルを複数のMavenプロジェクトに混在させると、重複したEntityクラスが複数のMavenプロジェクトに存在することになる。

## プロジェクトを過度に分割した場合の問題点

プロジェクトを過度に分割した場合の問題点:

- ビルド及びデプロイの手順が複雑になる。
- 結合テスト以降で、どのモジュールを組み合わせてテストしたか管理が複雑になる。

一般的には、Mavenプロジェクトは少ないほうが開発をスムーズに進めることができる。

<details>
<summary>keywords</summary>

プロジェクト過度分割, ビルド手順複雑化, 結合テスト管理, プロジェクト分割問題点, 推奨プロジェクト構成, 共通ライブラリ, 実行制御基盤, gsp-dba-maven-plugin, edmファイル, プロジェクト分割方針

</details>
