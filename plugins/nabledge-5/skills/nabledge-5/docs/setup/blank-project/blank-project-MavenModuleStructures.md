# Mavenアーキタイプの構成

**公式ドキュメント**: [Mavenアーキタイプの構成](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/MavenModuleStructures/index.html)

## 

本章では、Nablarchの提供するMavenアーキタイプの構成と、各ディレクトリ・ファイルの概要を記載する。

バッチアプリケーションのビルド時に `target` 配下に生成されるzipファイルには、バッチアプリケーションの実行可能jarと依存ライブラリが格納されている。そのため、本番環境へのリリース時は以下の手順でバッチを実行できる:

1. zipファイルを任意のディレクトリに解凍する
2. 以下のコマンドでバッチを実行する

```bash
java -jar <実行可能jarファイル名> ^
    -diConfig <コンポーネント設定ファイル> ^
    -requestPath <リクエストパス> ^
    -userId <ユーザID>
```

<details>
<summary>keywords</summary>

Mavenアーキタイプ, Nablarchプロジェクト構成概要, バッチアプリケーション, リリース手順, 実行可能jar, 依存ライブラリ, zip解凍, diConfig, requestPath, userId, コマンド実行

</details>

## 全体構成の概要

アーキタイプのグループIDはすべて `com.nablarch.archetype`。

| アーティファクトID | 説明 |
|---|---|
| nablarch-web-archetype | ウェブアプリケーション実行制御基盤 |
| nablarch-jaxrs-archetype | RESTfulウェブサービス実行制御基盤 |
| nablarch-batch-ee-archetype | JSR352準拠バッチアプリケーションフレームワーク |
| nablarch-batch-archetype | Nablarch独自バッチアプリケーション実行制御基盤 |
| nablarch-batch-dbless-archetype | Nablarch独自バッチ（DB接続なし） |
| nablarch-container-web-archetype | nablarch-web-archetypeのDockerコンテナ版 |
| nablarch-container-jaxrs-archetype | nablarch-jaxrs-archetypeのDockerコンテナ版 |
| nablarch-container-batch-archetype | nablarch-batch-archetypeのDockerコンテナ版 |
| nablarch-container-batch-dbless-archetype | nablarch-batch-dbless-archetypeのDockerコンテナ版 |

`nablarch-web-archetype`（artifactId=`pj-web`）と`nablarch-batch-archetype`（artifactId=`pj-batch`）を使用した場合のパッケージング:

| Mavenプロジェクト名 | パッケージング | 用途 |
|---|---|---|
| pj-web | war | ウェブアプリケーション実行制御基盤。warファイルとしてアプリケーションサーバにデプロイ。 |
| pj-batch | jar | Nablarch独自バッチアプリケーション実行制御基盤 |

> **補足**: 自動生成エンティティは [gsp-dba-maven-plugin](https://github.com/coastland/gsp-dba-maven-plugin/tree/4.x.x-main) を使用した場合に生成される。使用する場合は [../addin_gsp](blank-project-addin_gsp.md) に記載の設定が必要。

**pj-container-web** (`myapp-container-web`): ウェブアプリケーションがデプロイされたTomcatベースのDockerイメージをビルドするプロジェクト。

ディレクトリ構成の主要要素:
- `src/main/jib/` - コンテナイメージ上に配置するファイルを格納
- `src/main/resources/` - 設定ファイル、ルーティングアダプタ設定（`net/`）、ERサンプル（`entity/`）
- `src/main/webapp/WEB-INF/` - `web.xml`、エラー画面サンプル（`errorPages/`）
- `db/` - 疎通アプリ用DDL・Insert文（RDBMS別）
- `h2/bin/` - H2起動ファイル
- `h2/db/SAMPLE.h2.db` - H2データファイル（`SAMPLE.h2.db.org`がバックアップ。H2が起動しなくなった場合は`SAMPLE.h2.db`にコピーして使用）
- `tools/` - Mavenと連携するツールの設定ファイル

**`src/main/jib`について**: 配置したディレクトリやファイルはそのままコンテナ上の同パスに配置される。例: `src/main/jib/var/foo.txt` → コンテナ上の `/var/foo.txt`。詳細は [Jibのドキュメント](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin#adding-arbitrary-files-to-the-image) を参照（外部サイト、英語）。

ブランクプロジェクトでは、TomcatのログをすべてDockerコンテナの標準出力にするためのTomcat設定ファイルが `src/main/jib` に配置されている。

<details>
<summary>keywords</summary>

nablarch-web-archetype, nablarch-jaxrs-archetype, nablarch-batch-ee-archetype, nablarch-batch-archetype, nablarch-batch-dbless-archetype, nablarch-container-web-archetype, nablarch-container-jaxrs-archetype, nablarch-container-batch-archetype, nablarch-container-batch-dbless-archetype, アーキタイプ選択, gsp-dba-maven-plugin, com.nablarch.archetype, pj-container-web, myapp-container-web, src/main/jib, Jib, コンテナイメージ, Tomcat, ディレクトリ構成, SAMPLE.h2.db

</details>

## 各構成要素の詳細

各アーキタイプから作成するプロジェクト名と生成元アーキタイプの対応:

| Mavenプロジェクト名 | 生成元のMaven archetype |
|---|---|
| pj-jaxrs | nablarch-jaxrs-archetype |
| pj-batch-dbless | nablarch-batch-dbless-archetype |
| pj-batch-ee | nablarch-batch-ee-archetype |
| pj-container-web | nablarch-container-web-archetype |
| pj-container-jaxrs | nablarch-container-jaxrs-archetype |
| pj-container-batch | nablarch-container-batch-archetype |
| pj-container-batch-dbless | nablarch-container-batch-dbless-archetype |

pj-container-webプロジェクトのツールの設定はWebと同一のため省略。

<details>
<summary>keywords</summary>

pj-jaxrs, pj-batch-dbless, pj-batch-ee, pj-container-web, pj-container-jaxrs, pj-container-batch, pj-container-batch-dbless, アーキタイプとプロジェクト対応, ツール設定, Webプロジェクト

</details>

## 

nablarch-archetype-parentは利用者が直接書き換えない親プロジェクト。主に以下が設定されている:
- 各種Mavenプラグインのバージョン
- 各種ツールが使用するファイルのパス

pj-container-jaxrsプロジェクト: RESTfulウェブサービスアプリケーションがデプロイされたTomcatベースのDockerイメージをビルドするプロジェクト。プロジェクト構成はコンテナ版Webと同一のため省略。

<details>
<summary>keywords</summary>

nablarch-archetype-parent, 親プロジェクト, Mavenプラグインバージョン, ツールパス設定, pj-container-jaxrs, RESTfulウェブサービス, コンテナ, Docker, Tomcat

</details>

## nablarch-archetype-parentの所在

プロジェクトを一度ビルドすると、以下のパスにnablarch-archetype-parentのpom.xmlがキャッシュされる:

```text
<ホームディレクトリ>/.m2/repository/com/nablarch/archetype/
```

**pj-container-batch** (`myapp-container-batch`): NablarchバッチアプリケーションがデプロイされたLinuxサーバのDockerイメージをビルドするプロジェクト。

コンテナ版Webに存在しない主要要素:
- `src/main/resources/batch-boot.xml` - 都度起動バッチ起動時に指定する設定ファイル
- `src/main/resources/mail-sender-boot.xml` - メール送信バッチ起動時に指定する設定ファイル
- `src/main/resources/resident-batch-boot.xml` - テーブルをキューとして使ったメッセージング起動時に指定する設定ファイル
- `src/main/scripts/` - バッチ等の起動に使用するシェルスクリプトファイル（使用は任意）
- H2データファイルは `SAMPLE.mv.db`（バックアップは `SAMPLE.mv.db.org`）

<details>
<summary>keywords</summary>

nablarch-archetype-parent, pom.xml, Mavenキャッシュ, .m2, ローカルリポジトリ, pj-container-batch, myapp-container-batch, batch-boot.xml, mail-sender-boot.xml, resident-batch-boot.xml, バッチアプリケーション, コンテナ, scripts

</details>

## プロジェクトの構成

pj-webプロジェクト（war形式）のディレクトリ構成:

```text
myapp-web
├── pom.xml
├── README.md
├── db/                           疎通アプリケーション用DDL・Insert文（RDBMS別）
├── h2/
│   ├── bin/                      H2起動ファイル
│   └── db/
│       ├── SAMPLE.mv.db          H2データファイル
│       └── SAMPLE.mv.db.org      バックアップ（H2起動不可時にSAMPLE.mv.dbにコピーして使用）
├── src/
│   ├── env/                      環境別設定ファイル
│   ├── main/
│   │   ├── java/                 疎通確認用アプリケーションクラス
│   │   ├── resources/            開発・本番共用設定ファイル
│   │   │   ├── entity/           ER図サンプル（gsp-dba-maven-plugin用）
│   │   │   └── net/              ルーティングアダプタ用設定ファイル
│   │   └── webapp/
│   │       ├── images/           疎通確認用画像
│   │       └── WEB-INF/
│   │           ├── web.xml       web.xmlが格納されている
│   │           ├── errorPages/   エラー画面サンプル
│   │           └── test/         疎通確認画面用ファイル
│   └── test/
│       ├── java/                 疎通テスト用ユニットテスト
│       └── resources/            ユニットテスト用設定ファイル
│           ├── data/             gsp-dba-maven-plugin用サンプルデータ
│           └── nablarch/         HTMLチェックツール用データ
├── tmp/                          Webアプリリクエスト単体テスト用（疎通テスト実行時に自動生成）
├── tools/                        Mavenと連携するツールの設定ファイル
└── work/                         入出力ファイル用作業ディレクトリ（疎通確認時に自動生成）
```

pj-container-batch-dblessプロジェクト: DBに接続しないNablarchバッチアプリケーションがデプロイされたLinuxサーバのDockerイメージをビルドするプロジェクト。プロジェクト構成は :ref:`pj-container-batchプロジェクトの構成 <firstStepContainerBatchProjectStructure>` からDB関連のディレクトリおよびファイルを除いただけのため省略。

<details>
<summary>keywords</summary>

pj-web, myapp-web, Webアプリケーション, ディレクトリ構成, SAMPLE.mv.db, H2データベース, WEB-INF, web.xml, ルーティングアダプタ, pj-container-batch-dbless, DBなしバッチ, コンテナ, firstStepContainerBatchProjectStructure

</details>

## ツールの設定

toolsフォルダの主なファイル:

| ディレクトリまたはファイル | 説明 |
|---|---|
| nablarch-tools.xml | JSP静的解析ツール実行時の設定ファイル |
| static-analysis/jspanalysis | JSP静的解析ツールの設定ファイル格納ディレクトリ |

**各プロジェクト共通のMavenプロファイル一覧**（コンテナ用プロジェクトを除く）:

| プロファイル名 | 概要 |
|---|---|
| dev | 開発環境用およびユニットテスト実行用。`src/env/dev/resources` ディレクトリのリソースを使用 |
| prod | 本番環境用。`src/env/prod/resources` ディレクトリのリソースを使用 |

> **補足**: `pom.xml` 中のdevプロファイルに `activeByDefault` 要素が記述されており、デフォルトでdevプロファイルが使用される。

> **注意**: コンテナ用プロジェクトでは、環境ごとの違いはプロファイルではなくOS環境変数を使って切り替えるため、プロファイルは定義されていない。詳細は [container_production_config](blank-project-CustomizeDB.md) を参照。

**プロファイルの使い方**: 本番環境用WARファイルを作成する場合は `pj-web` モジュール配下で以下を実行:

```bash
mvn package -P prod -DskipTests=true
```

> **補足**: `mvn package` 実行時はデフォルトでユニットテストも実行されるが、本番環境用プロファイルではユニットテストが失敗するため `-DskipTests=true` でスキップ指定が必要。

<details>
<summary>keywords</summary>

nablarch-tools.xml, JSP静的解析, static-analysis, jspanalysis, tools, Mavenプロファイル, dev, prod, activeByDefault, 本番環境, 開発環境, コンテナプロジェクト, OS環境変数, container_production_config

</details>

## プロジェクトの構成

pj-jaxrsプロジェクト（RESTfulウェブサービスアプリケーション、war形式）のディレクトリ構成はpj-webと同一。

Mavenのデフォルトのビルドフェーズ定義に加えて設定されているゴール:

| ビルドフェーズ | ゴール | 概要 |
|---|---|---|
| initialize | jacoco:prepare-agent | JaCoCoの実行時エージェントを準備する |
| pre-integration-test | jacoco:prepare-agent-integration | 結合試験用にJaCoCoの実行時エージェントを準備する |

> **補足**: gsp-dba-maven-pluginの実行はMavenのビルドフェーズに紐づかないため、エンティティの自動生成などgsp-dba-maven-pluginのゴールを実行する場合は手動で実行すること。

<details>
<summary>keywords</summary>

pj-jaxrs, RESTfulウェブサービス, warファイル, pj-webと同一, JaCoCo, jacoco:prepare-agent, jacoco:prepare-agent-integration, カバレッジ, gsp-dba-maven-plugin, ビルドフェーズ, initialize, pre-integration-test

</details>

## プロジェクトの構成

pj-batch-eeプロジェクト（JSR352準拠バッチ、jar形式）のディレクトリ構成（Web・batchに存在しない要素のみ記載）:

```text
myapp-batch-ee
├── pom.xml
├── README.md
├── distribution.xml                        maven-assembly-plugin設定ファイル
├── db/
├── h2/
│   ├── bin/
│   └── db/
│       ├── SAMPLE.mv.db
│       └── SAMPLE.mv.db.org
├── src/
│   ├── env/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   │       ├── batch-boot.xml              バッチ起動時設定ファイル
│   │       ├── entity/
│   │       └── META-INF/
│   │           ├── beans.xml               CDI有効化に必要なファイル
│   │           ├── batch-jobs/
│   │           │   ├── sample-batchlet.xml batchlet方式疎通確認用ジョブファイル
│   │           │   ├── sample-chunk.xml    chunk方式疎通確認用ジョブファイル
│   │           │   └── sample-etl.xml      ETL機能ジョブファイル
│   │           └── etl-config/
│   │               └── sample-etl.json     ETL機能ジョブ設定ファイル
│   └── test/
│       ├── java/
│       └── resources/
│           └── data/
├── testdata/                               ETL機能の入出力ファイル用作業ディレクトリ（開発時）
└── work/
```

コンパイルに関する設定は、各プロジェクトの `pom.xml` および [about_maven_parent_module](#s3) の `pom.xml` を参照。設定項目: 使用するJavaのバージョン、ファイルエンコーディング、JDBCドライバ。

<details>
<summary>keywords</summary>

pj-batch-ee, myapp-batch-ee, JSR352, distribution.xml, batch-boot.xml, beans.xml, batch-jobs, sample-batchlet.xml, sample-chunk.xml, sample-etl.xml, ETL, CDI, testdata, firstStepBatchEEProjectStructure, Javaバージョン, ファイルエンコーディング, JDBCドライバ, コンパイル設定, pom.xml, about_maven_parent_module

</details>

## 本番環境へのリリースについて

バッチビルド時にtarget配下に生成されるzipには実行可能jarと依存ライブラリが含まれる。

本番リリース手順:
1. zipを任意のディレクトリに解凍
2. 以下のコマンドでバッチを実行:

```bash
java -jar <実行可能jarファイル名> <ジョブ名>
```

ツールの設定は、各プロジェクトおよび [about_maven_parent_module](#s3) の `pom.xml` に記載されている。親プロジェクトに記載されているツールについては :ref:`firstStepBuiltInTools` を参照。

<details>
<summary>keywords</summary>

pj-batch-ee, zipファイル, 実行可能jar, バッチ実行, 本番リリース, JSR352バッチ起動コマンド, ツール設定, pom.xml, 親プロジェクト, gsp-dba-maven-plugin, firstStepBuiltInTools, about_maven_parent_module

</details>

## プロジェクトの構成

pj-batchプロジェクト（Nablarch独自バッチ、jar形式）のディレクトリ構成（Webに存在しない要素のみ記載）:

```text
myapp-batch
├── pom.xml
├── README.md
├── distribution.xml                        maven-assembly-plugin設定ファイル
├── db/
├── h2/
│   ├── bin/
│   └── db/
│       ├── SAMPLE.mv.db
│       └── SAMPLE.mv.db.org
├── src/
│   ├── env/
│   ├── main/
│   │   ├── java/
│   │   ├── resources/
│   │   │   ├── batch-boot.xml            都度起動バッチ起動時の設定ファイル
│   │   │   ├── mail-sender-boot.xml      メール送信バッチ起動時の設定ファイル
│   │   │   ├── resident-batch-boot.xml   テーブルをキューとして使ったメッセージング起動時の設定ファイル
│   │   │   └── entity/
│   │   └── scripts/                      バッチ起動用シェルスクリプト（使用は任意）
│   └── test/
│       ├── java/
│       └── resources/
│           └── data/
└── work/
```

以下のような場合は、各モジュールの `pom.xml` を変更する:
- モジュール個別で使用する依存ライブラリを追加・変更する（例: 使用するNablarchのバージョンを変更するために `nablarch-bom` のバージョンを修正する）
- モジュール個別で使用するMavenプラグインを追加・変更する

<details>
<summary>keywords</summary>

pj-batch, myapp-batch, batch-boot.xml, mail-sender-boot.xml, resident-batch-boot.xml, distribution.xml, scripts, Nablarch独自バッチ, 都度起動, テーブルキュー, firstStepBatchProjectStructure, ビルド設定, pom.xml, 依存ライブラリ, Mavenプラグイン, nablarch-bom, モジュール個別

</details>

## 本番環境へのリリースについて

バッチビルド時にtarget配下に生成されるzipには実行可能jarと依存ライブラリが含まれる。

本番リリース手順:
1. zipを任意のディレクトリに解凍
2. 以下のコマンドでバッチを実行:

```bash
java -jar <実行可能jarファイル名> ^
    -diConfig <コンポーネント設定ファイル> ^
    -requestPath <リクエストパス> ^
    -userId <ユーザID>
```

Nablarchのバージョンを変更する場合は各モジュールの `pom.xml` の `nablarch-bom` バージョンを修正する。Nablarch5u6を使用する場合の例:

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>com.nablarch.profile</groupId>
      <artifactId>nablarch-bom</artifactId>
      <!--
      使用するNablarchのバージョンと対応したバージョンを指定する。
      この例は5u6を指定している。
      -->
      <version>5u6</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

<details>
<summary>keywords</summary>

pj-batch, zipファイル, 実行可能jar, diConfig, requestPath, userId, バッチ起動コマンド, 本番リリース, nablarch-bom, バージョン変更, dependencyManagement, 5u6, com.nablarch.profile, pom.xml

</details>

## プロジェクトの構成

pj-batch-dblessプロジェクト（DB接続なしNablarch独自バッチ、jar形式）のディレクトリ構成は :ref:`pj-batchプロジェクトの構成 <firstStepBatchProjectStructure>` からDB関連ディレクトリ・ファイルを除いたもの。

依存ライブラリを追加する場合は各モジュールの `pom.xml` に追記する。`scope` の設定を適切に行うこと（設定を怠ると、ユニットテストでのみ使用するはずのモジュールが本番でも使用される問題が起きる可能性がある）。

Nablarchライブラリのバージョン番号は通常 `pom.xml` への指定が不要（`nablarch-bom` へのバージョン指定により個々のライブラリのバージョンが決定するため）。

`pj-web` モジュールで `nablarch-common-encryption` を使用する場合の例:

```xml
<dependencies>
  <dependency>
    <groupId>com.nablarch.framework</groupId>
    <artifactId>nablarch-common-encryption</artifactId>
  </dependency>
</dependencies>
```

<details>
<summary>keywords</summary>

pj-batch-dbless, DB接続なし, firstStepDbLessBatchProjectStructure, DB不使用バッチ, 依存ライブラリ追加, scope, nablarch-common-encryption, com.nablarch.framework, pom.xml, バージョン指定不要

</details>

## 【参考】プロジェクト分割方針

なし

<details>
<summary>keywords</summary>

プロジェクト分割方針, 参考, mavenModuleStructuresModuleDivisionPolicy

</details>

## 推奨するプロジェクト構成の方針

**推奨するプロジェクト構成の方針**:
- 作成するアプリケーションが1つの場合（ウェブのみ、バッチのみ等）は、それぞれ単体のプロジェクトで構成する
- 社内用と社外用で2つのウェブアプリを作成するようなケースでは、無理に1つのMavenプロジェクトにまとめず、個別にMavenプロジェクトを作る
- 複数のアプリケーションが存在し共通化したいライブラリがある場合は、共通ライブラリを配置するMavenプロジェクトを作る
- 実行制御基盤を追加した際は、実行制御基盤ごとにMavenプロジェクトを作る（例: メッセージング実行制御基盤を使用するアプリを追加する場合は新しくMavenプロジェクトを作る）
- 必要以上にプロジェクトは分割しない（詳細は :ref:`mavenModuleStructuresProblemsOfExcessivelyDivided` を参照）

> **補足**: プロジェクト分割時はリソースの重複に注意。例えば [gsp-dba-maven-plugin（外部サイト）](https://github.com/coastland/gsp-dba-maven-plugin/tree/4.x.x-main) のedmファイルを複数のMavenプロジェクトに混在させると、重複したEntityクラスが複数プロジェクトに存在することになる。

**過度な分割による問題点**:
- ビルドおよびデプロイの手順が複雑になる
- 結合テスト以降で、どのモジュールを組み合わせてテストしたか管理が複雑になる

一般的には、Mavenプロジェクトは少ないほうが開発をスムーズに進めることができる。

<details>
<summary>keywords</summary>

プロジェクト分割方針, 推奨構成, 過度な分割, 共通ライブラリ, 実行制御基盤, gsp-dba-maven-plugin, edm, mavenModuleStructuresProblemsOfExcessivelyDivided

</details>
