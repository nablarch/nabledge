# 使用するRDBMSの変更手順

**公式ドキュメント**: [使用するRDBMSの変更手順](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/CustomizeDB.html)

## 前提

Nablarchアーキタイプで生成したプロジェクトは、初期状態では **H2 Database Engine** を使用するように設定されている。

**前提条件**:
- 各アーキタイプから生成した直後のプロジェクトを対象とする
- RDBMSに接続用ユーザとスキーマが作成済みで、ユーザに適切な権限が付与済みであること

> **補足**: 本番環境でJNDIからコネクションを取得する場合、ローカルでコネクションプールを作るときだけ明示的に依存関係に入れる必要があるため、profiles要素内に記載する。JNDIからコネクションを取得する場合、APサーバのクラスローダからJDBCドライバを取得できる。

profiles要素内の`<dependencies>`に使用するデータベースのJDBCドライバ依存関係を記述する。

**H2（デフォルト）**:
```xml
<dependency>
  <groupId>com.h2database</groupId>
  <artifactId>h2</artifactId>
  <version>2.2.220</version>
  <scope>runtime</scope>
</dependency>
```

**Oracle**:
```xml
<dependency>
  <groupId>com.oracle.database.jdbc</groupId>
  <artifactId>ojdbc11</artifactId>
  <version>23.2.0.0</version>
  <scope>runtime</scope>
</dependency>
```

**PostgreSQL**:
```xml
<dependency>
  <groupId>org.postgresql</groupId>
  <artifactId>postgresql</artifactId>
  <version>42.7.2</version>
  <scope>runtime</scope>
</dependency>
```

**DB2**:
```xml
<dependency>
  <groupId>com.ibm.db2</groupId>
  <artifactId>jcc</artifactId>
  <version>11.5.9.0</version>
  <scope>runtime</scope>
</dependency>
```

**SQL Server**:
```xml
<dependency>
  <groupId>com.microsoft.sqlserver</groupId>
  <artifactId>mssql-jdbc</artifactId>
  <version>12.6.1.jre11</version>
  <scope>runtime</scope>
</dependency>
```

<details>
<summary>keywords</summary>

H2 Database Engine, RDBMS設定変更, アーキタイプ生成プロジェクト, データベース接続前提条件, JDBCドライバ設定, profiles要素, JNDI接続, Maven依存関係, データベース切替, com.h2database, com.oracle.database.jdbc, org.postgresql, com.ibm.db2, com.microsoft.sqlserver, h2, ojdbc11, postgresql, jcc, mssql-jdbc

</details>

## Mavenリポジトリへのファイル登録

使用するRDBMSのJDBCドライバについては、以下のいずれかのMavenリポジトリに登録されている必要がある:
- Mavenのセントラルリポジトリ
- プロジェクトのMavenリポジトリ
- ローカルのMavenリポジトリ

Mavenのセントラルリポジトリに公開されていないJDBCドライバについては、ローカルのMavenリポジトリへの登録手順が必要になる。詳細はサブセクション「JDBCドライバの登録」を参照。

本番環境でローカルにコネクションプールを作成するプロジェクトの場合、dependencies要素内のJDBCドライバ依存関係を修正する。デフォルト（H2）の記述例：

```xml
<dependencies>
  <!-- TODO: プロジェクトで使用するDB製品にあわせたJDBCドライバに修正してください。 -->
  <dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <version>2.2.220</version>
    <scope>runtime</scope>
  </dependency>
</dependencies>
```

dependency要素内の各要素は :ref:`customizeDBProfiles` と同じように記述する。

<details>
<summary>keywords</summary>

Mavenリポジトリ, ファイル登録, JDBCドライバ, customizeDBAddFileMavenRepo, JDBCドライバ設定, ローカルコネクションプール, dependencies要素, Maven依存関係, com.h2database

</details>

## JDBCドライバの登録

JDBCドライバは以下のいずれかのMavenリポジトリに登録されている必要がある:
- Mavenのセントラルリポジトリ
- プロジェクトのMavenリポジトリ
- ローカルのMavenリポジトリ

> **重要**: JDBCドライバはCI環境構築までに、プロジェクトのMavenリポジトリへ登録することを強く推奨する。JDBCドライバ入手時はライセンスを確認すること。

本番環境でJNDIからコネクションを取得するプロジェクトの場合、`src/main/resources`のコンポーネント設定ファイルのDialectクラスを使用するデータベースに合わせて変更する。

| プロジェクト種別 | コンポーネント設定ファイル名 |
|---|---|
| ウェブ | web-component-configuration.xml |
| RESTfulウェブサービス | rest-component-configuration.xml |

デフォルト（H2）設定：
```xml
<!-- ダイアレクト設定 -->
<!-- 使用するDBに合わせてダイアレクトを設定すること -->
<component name="dialect" class="nablarch.core.db.dialect.H2Dialect" />
```

| データベース | Dialectクラス |
|---|---|
| Oracle | nablarch.core.db.dialect.OracleDialect |
| PostgreSQL | nablarch.core.db.dialect.PostgreSQLDialect |
| DB2 | nablarch.core.db.dialect.DB2Dialect |
| SQL Server | nablarch.core.db.dialect.SqlServerDialect |

<details>
<summary>keywords</summary>

JDBCドライバ登録, Mavenリポジトリ, CI環境, ライセンス確認, Dialectクラス設定, コンポーネント設定ファイル, JNDI接続, データベース方言, nablarch.core.db.dialect.OracleDialect, nablarch.core.db.dialect.PostgreSQLDialect, nablarch.core.db.dialect.DB2Dialect, nablarch.core.db.dialect.SqlServerDialect, nablarch.core.db.dialect.H2Dialect, web-component-configuration.xml, rest-component-configuration.xml

</details>

## H2

H2のJDBCドライバはMavenのセントラルリポジトリに公開されているため、ローカルのMavenリポジトリへの登録は不要。

本番環境でローカルにコネクションプールを作成するプロジェクトの場合、`data-source.xml`（`src/main/resources/`）にDialectクラスが記述されている。使用するデータベースに対応したDialectクラスに修正する。

使用するDialectクラスは :ref:`customizeDBWebComponentConfiguration` と同一である。

<details>
<summary>keywords</summary>

H2, JDBCドライバ, Mavenセントラルリポジトリ, 登録不要, Dialectクラス設定, data-source.xml, ローカルコネクションプール, データベース方言

</details>

## Oracle

OracleのJDBCドライバはMavenのセントラルリポジトリに公開されているため、ローカルのMavenリポジトリへの登録は不要。

`src/test/resources/unit-test.xml`にテスティングフレームワークが使用するデータベースの設定が記述されている。デフォルトは汎用のDB設定。Oracleを使用する場合は記述を修正する。

```xml
<!-- TODO: 使用するDBに合せて設定してください。 -->
<!-- Oracle用の設定 -->
<!--
  <import file="nablarch/test/test-db-info-oracle.xml"/>
-->
<!-- 汎用のDB設定 -->
<component name="dbInfo" class="nablarch.test.core.db.GenericJdbcDbInfo">
  <property name="dataSource" ref="dataSource"/>
  <property name="schema" value="${nablarch.db.schema}"/>
</component>
```

<details>
<summary>keywords</summary>

Oracle, JDBCドライバ, Mavenセントラルリポジトリ, 登録不要, テスト設定, ユニットテスト, データベース設定, Oracle設定, nablarch.test.core.db.GenericJdbcDbInfo, test-db-info-oracle.xml

</details>

## PostgreSQL

PostgreSQLのJDBCドライバはMavenのセントラルリポジトリに公開されているため、ローカルのMavenリポジトリへの登録は不要。

各プロジェクトの`db/ddl/`ディレクトリにRDBMS別のDDLが用意されている。このDDLを実行してNablarchが使用するテーブルを作成する。

> **補足**: DB2の場合、`create.sql`の先頭に接続先データベースと使用スキーマが記述されているので書き換えてからDDLを実行する。実行は「DB2 コマンド・ウィンドウ」で行う。
> ```
> db2 -tvf "C:\develop\myapp-web\db\ddl\db2\create.sql"
> ```

> **補足**: gsp-dba-maven-plugin使用時は以下のコマンドでテーブルを作成できる（別途設定が必要。設定は [addin_gsp](blank-project-addin_gsp.md) 参照）。
> ```bash
> mvn -P gsp clean generate-resources
> ```

<details>
<summary>keywords</summary>

PostgreSQL, JDBCドライバ, Mavenセントラルリポジトリ, 登録不要, テーブル作成, DDL実行, DB2設定, gsp-dba-maven-plugin, db/ddl/

</details>

## DB2

DB2のJDBCドライバはMavenのセントラルリポジトリに公開されていないため、ローカルのMavenリポジトリへの登録が必要。

入手先: [IBM DB2 JDBC Driver Versions and Downloads](https://www.ibm.com/support/pages/db2-jdbc-driver-versions-and-downloads)

ローカルMavenリポジトリへの登録コマンド例:
```bash
mvn install:install-file -DgroupId=com.ibm -DartifactId=db2jcc4 -Dversion=10.5.0.7 -Dpackaging=jar -Dfile=db2jcc4.jar
```

各プロジェクトの`db/data/`ディレクトリにInsert文が用意されている。このInsert文を実行してNablarchが使用するデータをInsertする。

> **補足**: DB2の場合、`data.sql`の先頭に接続先データベースと使用スキーマを記述してからSQLを実行する。
> ```
> CONNECT TO SAMPLE2;
> SET SCHEMA sample;
> ```
> 実行は「DB2 コマンド・ウィンドウ」で行う。
> ```
> db2 -tvf "C:\develop\myapp-web\db\data\data.sql"
> ```

<details>
<summary>keywords</summary>

DB2, JDBCドライバ, db2jcc4, ローカルMavenリポジトリ登録, mvn install:install-file, データ投入, Insert文, DB2設定, 初期データ, db/data/

</details>

## SQLServer

SQL ServerのJDBCドライバはMavenのセントラルリポジトリに公開されているため、ローカルのMavenリポジトリへの登録は不要。

<details>
<summary>keywords</summary>

SQL Server, JDBCドライバ, Mavenセントラルリポジトリ, 登録不要

</details>

## ファイル修正

使用するRDBMSに合わせてpropertiesファイルおよびpom.xmlを修正するセクション。サブセクション「propertiesファイルの修正」「pom.xmlファイルの修正」を参照。

<details>
<summary>keywords</summary>

ファイル修正, RDBMS設定, env.properties, pom.xml, customizeDBNotExistPjRepo

</details>

## propertiesファイルの修正

`env.properties` に設定するプロパティ:

| プロパティ名 | 説明 |
|---|---|
| nablarch.connectionFactory.jndiResourceName | JNDIでDataSourceを取得する際のリソース名 |
| nablarch.db.jdbcDriver | JDBCドライバのクラス名 |
| nablarch.db.url | データベースの接続URL |
| nablarch.db.user | データベースアクセスユーザ名 |
| nablarch.db.password | データベースアクセスユーザのパスワード |
| nablarch.db.schema | 接続するスキーマ名（Nablarchテスティングフレームワーク用） |

**JNDIからコネクションを取得する環境のpropertiesファイル**（`nablarch.connectionFactory.jndiResourceName` を設定）:

| プロジェクト種別 | ファイル |
|---|---|
| ウェブ、RESTfulウェブサービス | `src/env/prod/resources/env.properties` |
| Jakarta Batchに準拠したバッチ、Nablarchバッチ、コンテナ版各種 | なし |

**ローカルにコネクションプールを作成する環境のpropertiesファイル**（`nablarch.db.jdbcDriver` 等を設定）:

| プロジェクト種別 | ファイル |
|---|---|
| ウェブ、RESTfulウェブサービス | `src/env/dev/resources/env.properties` |
| Jakarta Batchに準拠したバッチ、Nablarchバッチ | `src/env/dev/resources/env.properties`、`src/env/prod/resources/env.properties` |
| コンテナ版ウェブ、コンテナ版RESTfulウェブサービス、コンテナ版Nablarchバッチ | `src/main/resources/env.properties` |

> **重要**: DBによってはユーザ名、パスワード、スキーマの大文字小文字を区別する。DBに設定した通りに `env.properties` にも設定すること。

<details>
<summary>keywords</summary>

env.properties, nablarch.db.jdbcDriver, nablarch.db.url, nablarch.db.user, nablarch.db.password, nablarch.db.schema, nablarch.connectionFactory.jndiResourceName, JNDI, コネクションプール, 大文字小文字区別

</details>

## H2の設定例（デフォルト）

```text
nablarch.db.jdbcDriver=org.h2.Driver
nablarch.db.url=jdbc:h2:./h2/db/SAMPLE
nablarch.db.user=SAMPLE
nablarch.db.password=SAMPLE
nablarch.db.schema=PUBLIC
```

<details>
<summary>keywords</summary>

H2設定例, org.h2.Driver, nablarch.db.jdbcDriver, jdbc:h2

</details>

## Oracleの設定例

```text
nablarch.db.jdbcDriver=oracle.jdbc.driver.OracleDriver
# jdbc:oracle:thin:@ホスト名:ポート番号:データベースのSID
nablarch.db.url=jdbc:oracle:thin:@localhost:1521/xe
nablarch.db.user=sample
nablarch.db.password=sample
nablarch.db.schema=sample
```

<details>
<summary>keywords</summary>

Oracle設定例, oracle.jdbc.driver.OracleDriver, jdbc:oracle:thin, nablarch.db.url

</details>

## PostgreSQLの設定例

```text
nablarch.db.jdbcDriver=org.postgresql.Driver
# jdbc:postgresql://ホスト名:ポート番号/データベース名
nablarch.db.url=jdbc:postgresql://localhost:5432/postgres
nablarch.db.user=sample
nablarch.db.password=sample
nablarch.db.schema=sample
```

<details>
<summary>keywords</summary>

PostgreSQL設定例, org.postgresql.Driver, jdbc:postgresql, nablarch.db.url

</details>

## DB2の設定例

```text
nablarch.db.jdbcDriver=com.ibm.db2.jcc.DB2Driver
# jdbc:db2://ホスト名:ポート番号/データベース名
nablarch.db.url=jdbc:db2://localhost:50000/SAMPLE
nablarch.db.user=sample
nablarch.db.password=sample
nablarch.db.schema=sample
```

<details>
<summary>keywords</summary>

DB2設定例, com.ibm.db2.jcc.DB2Driver, jdbc:db2, nablarch.db.url

</details>

## SQL Serverの設定例

```text
nablarch.db.jdbcDriver=com.microsoft.sqlserver.jdbc.SQLServerDriver
# jdbc:sqlserver://ホスト名:ポート番号;instanceName=インスタンス名
nablarch.db.url=jdbc:sqlserver://localhost:1433;instanceName=SQLEXPRESS
nablarch.db.user=SAMPLE
nablarch.db.password=SAMPLE
nablarch.db.schema=SAMPLE
```

<details>
<summary>keywords</summary>

SQL Server設定例, com.microsoft.sqlserver.jdbc.SQLServerDriver, jdbc:sqlserver, instanceName

</details>

## コンテナの本番環境設定

コンテナ用プロジェクトでは、プロファイルによる環境設定の切り替えは行わない。代わりに、アプリケーションを動かす環境のOS環境変数を使って `env.properties` に宣言した設定値を上書きする。

- OS環境変数未設定の環境では `src/main/resources/env.properties` の設定がそのまま使用される
- 本番等のコンテナ環境では、OS環境変数を使って `nablarch.db.url` 等の環境依存値を適切に上書きする必要がある

OS環境変数による設定上書き方法: `repository-overwrite_environment_configuration_by_os_env_var` を参照。

プロファイルではなくOS環境変数で設定を切り替えるようにしている理由については、[The Twelve-Factor App の III. 設定](https://12factor.net/ja/config)（外部サイト）を参照。

<details>
<summary>keywords</summary>

コンテナ設定, OS環境変数, env.properties上書き, プロファイル切り替え不使用, Twelve-Factor App, container_production_config

</details>

## pom.xmlファイルの修正

pom.xmlの依存関係を修正してRDBMS対応を行うセクション（`customizeDB_pom_dependencies`）。ソースドキュメントでは `customizeDBProfiles` アンカーが定義されており、他のドキュメントから参照される。

<details>
<summary>keywords</summary>

pom.xml, Maven依存関係, JDBCドライバ依存設定, customizeDBProfiles, customizeDB_pom_dependencies

</details>
