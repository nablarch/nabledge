# 使用するRDBMSの変更手順

**公式ドキュメント**: [使用するRDBMSの変更手順](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/CustomizeDB.html)

## 

Nablarchのアーキタイプから生成したプロジェクトは、初期状態でH2 Database Engine (H2) を使用するよう設定されている。

## 前提

- 各アーキタイプから生成した直後のプロジェクトを対象とする
- RDBMSに接続するユーザおよびスキーマが作成済みであること
- RDBMS上のユーザに適切な権限が付与済みであること

本番環境でJNDIからコネクションを取得するプロジェクトでは、`pom.xml`のprofiles要素内でJDBCドライバの依存関係を修正する。

> **補足**: JNDIからコネクションを取得するプロジェクトは、ローカルでコネクションプールを作るときだけ明示的に依存関係に入れる必要があるため、profiles要素内に記載する。APサーバのクラスローダからJDBCドライバを取得できるため、通常のdependencies要素には記載不要。

各データベースの設定例（scope: runtime）:

**H2（デフォルト）**:
```xml
<dependency>
  <groupId>com.h2database</groupId>
  <artifactId>h2</artifactId>
  <version>2.1.214</version>
  <scope>runtime</scope>
</dependency>
```

**Oracle**:
```xml
<dependency>
  <groupId>com.oracle.database.jdbc</groupId>
  <artifactId>ojdbc6</artifactId>
  <version>11.2.0.4</version>
  <scope>runtime</scope>
</dependency>
```

**PostgreSQL**:
```xml
<dependency>
  <groupId>org.postgresql</groupId>
  <artifactId>postgresql</artifactId>
  <version>9.4.1207</version>
  <scope>runtime</scope>
</dependency>
```

**DB2**:
```xml
<dependency>
  <groupId>com.ibm</groupId>
  <artifactId>db2jcc4</artifactId>
  <version>10.5.0.7</version>
  <scope>runtime</scope>
</dependency>
```

**SQL Server**:
```xml
<dependency>
  <groupId>com.microsoft.sqlserver</groupId>
  <artifactId>mssql-jdbc</artifactId>
  <version>7.4.1.jre8</version>
  <scope>runtime</scope>
</dependency>
```

<details>
<summary>keywords</summary>

RDBMS変更, H2 Database Engine, 前提条件, アーキタイプ初期設定, データベース設定, JDBCドライバ設定, profiles要素, JNDI, コネクション取得, H2, Oracle, PostgreSQL, DB2, SQLServer, Maven依存関係, runtime scope, com.h2database, com.oracle.database.jdbc, org.postgresql, db2jcc4, mssql-jdbc, ojdbc6

</details>

## JDBCドライバの登録

使用するJDBCドライバは以下のいずれかを満たす必要がある:

- Mavenのセントラルリポジトリに登録されている
- プロジェクトのMavenリポジトリに登録されている
- ローカルのMavenリポジトリに登録されている

> **重要**: JDBCドライバはCI環境構築までに、プロジェクトのMavenリポジトリに登録することを強く推奨する。JDBCドライバ入手時にはライセンスを確認すること。

本番環境でローカルにコネクションプールを作成するプロジェクトでは、`pom.xml`のdependencies要素内でJDBCドライバの依存関係を修正する。

デフォルト設定（H2）:
```xml
<dependency>
  <groupId>com.h2database</groupId>
  <artifactId>h2</artifactId>
  <version>2.1.214</version>
  <scope>runtime</scope>
</dependency>
```

各要素の記述方法は :ref:`customizeDBProfiles` と同様。

<details>
<summary>keywords</summary>

JDBCドライバ登録, Mavenセントラルリポジトリ, ローカルMavenリポジトリ, CI環境, ライセンス確認, JDBCドライバ設定, dependencies要素, ローカルコネクションプール, H2, Maven依存関係, com.h2database

</details>

## H2

H2のJDBCドライバはMavenのセントラルリポジトリに公開されているため、ローカルMavenリポジトリへの登録は不要。

本番環境でJNDIからコネクションを取得するプロジェクトでは、`src/main/resources`のコンポーネント設定ファイルにDialectクラスが定義されている。

| プロジェクト種別 | コンポーネント設定ファイル名 |
|---|---|
| ウェブ | web-component-configuration.xml |
| RESTfulウェブサービス | rest-component-configuration.xml |

変更箇所:
```xml
<component name="dialect" class="nablarch.core.db.dialect.H2Dialect" />
```

利用可能なDialectクラス（使用するデータベースに対応したクラスに修正すること）:

| データベース | Dialectクラス |
|---|---|
| Oracle | nablarch.core.db.dialect.OracleDialect |
| PostgreSQL | nablarch.core.db.dialect.PostgreSQLDialect |
| DB2 | nablarch.core.db.dialect.DB2Dialect |
| SQL Server | nablarch.core.db.dialect.SqlServerDialect |

<details>
<summary>keywords</summary>

H2, JDBCドライバ, セントラルリポジトリ登録不要, Dialectクラス, コンポーネント設定ファイル, JNDI, OracleDialect, PostgreSQLDialect, DB2Dialect, SqlServerDialect, H2Dialect, web-component-configuration.xml, rest-component-configuration.xml, nablarch.core.db.dialect

</details>

## Oracle

OracleのJDBCドライバはMavenのセントラルリポジトリに公開されているため、ローカルMavenリポジトリへの登録は不要。

本番環境でローカルにコネクションプールを作成するプロジェクトでは、`src/main/resources/data-source.xml`にDialectクラスが記述されている。使用するデータベースに対応したDialectクラスに修正する。

使用するDialectクラスは :ref:`customizeDBWebComponentConfiguration` と同一。

<details>
<summary>keywords</summary>

Oracle, JDBCドライバ, セントラルリポジトリ登録不要, Dialectクラス, data-source.xml, ローカルコネクションプール, データベース設定

</details>

## PostgreSQL

PostgreSQLのJDBCドライバはMavenのセントラルリポジトリに公開されているため、ローカルMavenリポジトリへの登録は不要。

`src/test/resources/unit-test.xml`にテスティングフレームワークが使用するデータベースの設定が記述されている。デフォルトは汎用のDB設定。Oracleを使用する場合は以下のコメントアウトを修正する。

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

PostgreSQL, JDBCドライバ, セントラルリポジトリ登録不要, unit-test.xml, テスティングフレームワーク, GenericJdbcDbInfo, Oracle設定, test-db-info-oracle.xml, nablarch.test.core.db.GenericJdbcDbInfo, dbInfo, テスト用DB設定

</details>

## DB2

DB2のJDBCドライバはMavenのセントラルリポジトリに公開されていないため、ローカルMavenリポジトリへの登録が必要。

入手先: [IBM DB2 JDBC Driver Versions and Downloads](https://www.ibm.com/support/pages/db2-jdbc-driver-versions-and-downloads)

ローカルMavenリポジトリへの登録コマンド例:

```bash
mvn install:install-file -DgroupId=com.ibm -DartifactId=db2jcc4 -Dversion=10.5.0.7 -Dpackaging=jar -Dfile=db2jcc4.jar
```

各プロジェクトの`db/ddl/`ディレクトリにRDBMS別DDLを用意している。このDDLを実行してNablarchが使用するテーブルを作成する。

> **補足**: DB2の場合、`create.sql`の先頭に接続先データベースと使用スキーマが記述されているため、書き換えてからDDLを実行する。DB2 コマンド・ウィンドウで実行:
> ```text
> db2 -tvf "C:\develop\myapp-web\db\ddl\db2\create.sql"
> ```

> **補足**: gsp-dba-maven-plugin使用時は以下のコマンドでテーブルが作成される（別途設定が必要。[addin_gsp](blank-project-addin_gsp.md) を参照）:
> ```bash
> mvn -P gsp clean generate-resources
> ```

<details>
<summary>keywords</summary>

DB2, JDBCドライバ, db2jcc4, com.ibm, mvn install:install-file, ローカルリポジトリ登録必要, テーブル作成, DDL, db/ddl/, gsp-dba-maven-plugin, mvn generate-resources, create.sql

</details>

## SQLServer

SQLServerのJDBCドライバはMavenのセントラルリポジトリに公開されているため、ローカルMavenリポジトリへの登録は不要。

各プロジェクトの`db/data/`ディレクトリにデータのInsert文を用意している。このInsert文を実行してNablarchが使用するデータをInsertする。

> **補足**: DB2の場合、`data.sql`の先頭に接続先データベースと使用スキーマを記述してからSQLを実行する。
> 
> 記述例:
> ```text
> CONNECT TO SAMPLE2;
> SET SCHEMA sample;
> ```
> 
> DB2 コマンド・ウィンドウで実行:
> ```text
> db2 -tvf "C:\develop\myapp-web\db\data\data.sql"
> ```

<details>
<summary>keywords</summary>

SQLServer, SQL Server, JDBCドライバ, セントラルリポジトリ登録不要, データ投入, Insert文, db/data/, DB2, data.sql

</details>

## 

なし

<details>
<summary>keywords</summary>

ファイル修正, RDBMS変更, propertiesファイル, pom.xml

</details>

## propertiesファイルの修正

`env.properties`の修正対象プロパティ:

| プロパティ名 | 説明 |
|---|---|
| nablarch.connectionFactory.jndiResourceName | JNDIでDataSourceを取得する際のリソース名（JNDIコネクション取得環境のpropertiesファイルに設定） |
| nablarch.db.jdbcDriver | JDBCドライバのクラス名（ローカルコネクションプール作成環境のpropertiesファイルに設定） |
| nablarch.db.url | データベースの接続URL（ローカルコネクションプール作成環境のpropertiesファイルに設定） |
| nablarch.db.user | データベースアクセスユーザ名（ローカルコネクションプール作成環境のpropertiesファイルに設定） |
| nablarch.db.password | データベースアクセスユーザのパスワード（ローカルコネクションプール作成環境のpropertiesファイルに設定） |
| nablarch.db.schema | 接続するスキーマ名（Nablarchのテスティングフレームワークで使用） |

JNDIからコネクションを取得する環境のpropertiesファイル（初期状態）:

| プロジェクト種別 | ファイル |
|---|---|
| ウェブ、RESTfulウェブサービス | src/env/prod/resources/env.properties |
| JSR352に準拠したバッチ、Nablarchバッチ、コンテナ版各種 | なし |

ローカルにコネクションプールを作成する環境のpropertiesファイル（初期状態）:

| プロジェクト種別 | ファイル |
|---|---|
| ウェブ、RESTfulウェブサービス | src/env/dev/resources/env.properties |
| JSR352に準拠したバッチ、Nablarchバッチ | src/env/dev/resources/env.properties、src/env/prod/resources/env.properties |
| コンテナ版ウェブ、コンテナ版RESTfulウェブサービス、コンテナ版Nablarchバッチ | src/main/resources/env.properties（[container_production_config](#s14) 参照） |

> **重要**: DBによってはユーザ名・パスワード・スキーマ名の大文字小文字を区別する。DBに設定した通りにpropertiesファイルに設定すること。

<details>
<summary>keywords</summary>

env.properties, nablarch.db.jdbcDriver, nablarch.db.url, nablarch.db.user, nablarch.db.password, nablarch.db.schema, nablarch.connectionFactory.jndiResourceName, JNDI, コネクションプール, 大文字小文字区別

</details>

## H2の設定例(デフォルト)

```text
nablarch.db.jdbcDriver=org.h2.Driver
nablarch.db.url=jdbc:h2:./h2/db/SAMPLE
nablarch.db.user=SAMPLE
nablarch.db.password=SAMPLE
nablarch.db.schema=PUBLIC
```

<details>
<summary>keywords</summary>

H2, org.h2.Driver, jdbc:h2, env.properties, H2設定例

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

Oracle, oracle.jdbc.driver.OracleDriver, jdbc:oracle:thin, env.properties, Oracle設定例

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

PostgreSQL, org.postgresql.Driver, jdbc:postgresql, env.properties, PostgreSQL設定例

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

DB2, com.ibm.db2.jcc.DB2Driver, jdbc:db2, env.properties, DB2設定例

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

SQLServer, SQL Server, com.microsoft.sqlserver.jdbc.SQLServerDriver, jdbc:sqlserver, env.properties, SQL Server設定例

</details>

## コンテナの本番環境設定

コンテナ用プロジェクトではプロファイルによる環境設定の切り替えは行わない。代わりにOS環境変数を使って`env.properties`に宣言した設定値を上書きする。

- OS環境変数を設定していない環境では`src/main/resources/env.properties`の設定がそのまま使用される
- 本番等のコンテナ環境ではOS環境変数で`nablarch.db.url`などの環境依存値を適切に上書きする必要がある

OS環境変数で設定を上書きする方法: [repository-overwrite_environment_configuration_by_os_env_var](../../component/libraries/libraries-repository.md)

<details>
<summary>keywords</summary>

コンテナ, OS環境変数, env.properties, 本番環境, プロファイル切り替え不使用, repository-overwrite_environment_configuration_by_os_env_var

</details>

## 

なし

<details>
<summary>keywords</summary>

pom.xml, RDBMS変更設定

</details>

## pom.xmlファイルの修正

なし

<details>
<summary>keywords</summary>

pom.xml, JDBCドライバ依存関係, RDBMS設定

</details>
