# gsp-dba-maven-plugin(DBA作業支援ツール)の初期設定方法

**公式ドキュメント**: [gsp-dba-maven-plugin(DBA作業支援ツール)の初期設定方法](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/addin_gsp.html)

## 概要と注意事項

gsp-dba-maven-pluginは、使用開始前にRDBMSにあわせて設定する必要がある。本手順では、アーキタイプから生成したプロジェクトでgsp-dba-maven-pluginを使用するための設定方法を示す。

> **重要**: gsp-dba-maven-pluginは開発フェーズで用いることを想定している。開発者のローカルDBを主ターゲットとしたツールであり、**本番環境での使用は推奨しない**。
>
> ER図からツールによって生成されたDDLをそのまま本番環境に配置して実行するような使い方も想定していない。ツールによって生成されたDDLを流用して本番環境向けのDDLを作成する場合は、DBAの責任でDDLに問題ないかを確認すること。

<details>
<summary>keywords</summary>

gsp-dba-maven-plugin, 開発フェーズ, 本番環境, DBA, DDL, ER図, ローカルDB

</details>

## generate-entityゴールがJava17以降で動くように設定する

generate-entityゴールを実行することによりEntityクラスを自動生成できるが、**Java 17以降で利用するにはJVMオプションを設定する必要がある**。

設定方法は[generate-entity(外部サイト)](https://github.com/coastland/gsp-dba-maven-plugin/blob/main/README.md#generate-entity)を参照して設定する。

<details>
<summary>keywords</summary>

generate-entity, Java 17, JVMオプション, Entityクラス自動生成, Java17以降

</details>

## pom.xmlファイルの修正

> **対象プロジェクト**: この手順は、アーキタイプから生成後、CustomizeDBの手順を実施した各種プロジェクトを対象とする。

> **補足**: gsp-dba-maven-pluginはデフォルトでH2 Database Engineを使うように設定されている。H2を使用する場合は、以下のファイル修正は不要。

## properties要素内

pom.xmlの`<properties>`内の以下のプロパティを修正する。

| プロパティ名 | 説明 |
|---|---|
| nablarch.db.jdbcDriver | JDBCドライバのクラス名 |
| nablarch.db.url | データベースの接続URL |
| nablarch.db.adminUser | 管理者ユーザ名 |
| nablarch.db.adminPassword | 管理者ユーザのパスワード |
| nablarch.db.user | データベースアクセスユーザ名 |
| nablarch.db.password | データベースアクセスユーザのパスワード |
| nablarch.db.schema | 接続するスキーマ名 |

**Oracle:**

```xml
<nablarch.db.jdbcDriver>oracle.jdbc.driver.OracleDriver</nablarch.db.jdbcDriver>
<!-- jdbc:oracle:thin:@ホスト名:ポート番号:データベースのSID -->
<nablarch.db.url>jdbc:oracle:thin:@localhost:1521/xe</nablarch.db.url>
<nablarch.db.adminUser>SAMPLE</nablarch.db.adminUser>
<nablarch.db.adminPassword>SAMPLE</nablarch.db.adminPassword>
<nablarch.db.user>sample</nablarch.db.user>
<nablarch.db.password>sample</nablarch.db.password>
<nablarch.db.schema>sample</nablarch.db.schema>
```

**PostgreSQL:**

```xml
<nablarch.db.jdbcDriver>org.postgresql.Driver</nablarch.db.jdbcDriver>
<!-- jdbc:postgresql://ホスト名:ポート番号/データベース名 -->
<nablarch.db.url>jdbc:postgresql://localhost:5432/postgres</nablarch.db.url>
<nablarch.db.adminUser>SAMPLE</nablarch.db.adminUser>
<nablarch.db.adminPassword>SAMPLE</nablarch.db.adminPassword>
<nablarch.db.user>sample</nablarch.db.user>
<nablarch.db.password>sample</nablarch.db.password>
<nablarch.db.schema>sample</nablarch.db.schema>
```

**DB2:**

```xml
<nablarch.db.jdbcDriver>com.ibm.db2.jcc.DB2Driver</nablarch.db.jdbcDriver>
<!-- jdbc:db2://ホスト名:ポート番号/データベース名 -->
<nablarch.db.url>jdbc:db2://localhost:50000/SAMPLE</nablarch.db.url>
<nablarch.db.adminUser>SAMPLE</nablarch.db.adminUser>
<nablarch.db.adminPassword>SAMPLE</nablarch.db.adminPassword>
<nablarch.db.user>sample</nablarch.db.user>
<nablarch.db.password>sample</nablarch.db.password>
<nablarch.db.schema>sample</nablarch.db.schema>
```

**SQLServer:**

```xml
<nablarch.db.jdbcDriver>com.microsoft.sqlserver.jdbc.SQLServerDriver</nablarch.db.jdbcDriver>
<!-- jdbc:sqlserver://ホスト名:ポート番号;instanceName=インスタンス名 -->
<nablarch.db.url>jdbc:sqlserver://localhost:1433;instanceName=SQLEXPRESS</nablarch.db.url>
<nablarch.db.adminUser>SAMPLE</nablarch.db.adminUser>
<nablarch.db.adminPassword>SAMPLE</nablarch.db.adminPassword>
<nablarch.db.user>sample</nablarch.db.user>
<nablarch.db.password>sample</nablarch.db.password>
<nablarch.db.schema>sample</nablarch.db.schema>
```

## build要素内

gsp-dba-maven-pluginの依存関係をH2 JDBCドライバから使用するRDBMSのものに変更する。PostgreSQL使用時の例:

```xml
<build>
  <plugins>
    <plugin>
      <groupId>jp.co.tis.gsp</groupId>
      <artifactId>gsp-dba-maven-plugin</artifactId>
      <dependencies>
        <dependency>
          <groupId>org.postgresql</groupId>
          <artifactId>postgresql</artifactId>
          <!-- バージョンは適切な値に書き換えてください。 -->
          <version>42.1.4</version>
        </dependency>
      </dependencies>
    </plugin>
  </plugins>
</build>
```

<details>
<summary>keywords</summary>

nablarch.db.jdbcDriver, nablarch.db.url, nablarch.db.adminUser, nablarch.db.adminPassword, nablarch.db.user, nablarch.db.password, nablarch.db.schema, gsp-dba-maven-plugin, JDBC設定, RDBMS接続設定, データベース接続設定, Maven POM設定, JDBCドライバ依存関係, oracle.jdbc.driver.OracleDriver, org.postgresql.Driver, com.ibm.db2.jcc.DB2Driver, com.microsoft.sqlserver.jdbc.SQLServerDriver

</details>

## data-model.edm (src/main/resources/entity)の準備

`src/main/resources/entity`以下にRDBMS毎のedmファイルが存在するため、使用するRDBMSに対応するファイルを`data-model.edm`にリネームする。

<details>
<summary>keywords</summary>

data-model.edm, EDMファイル設定, RDBMS別エンティティモデル, エンティティモデルリネーム, src/main/resources/entity

</details>

## 動作確認

> **重要**: DBのデータが削除されるため、必要であれば現在DBに格納されているデータを退避しておくこと。

**1. 以下のコマンドを実行して、DDLの生成からダンプファイル作成までを行う。**

```bash
mvn -P gsp clean generate-resources
```

以下のゴールが実行されるように、各アーキタイプから生成したプロジェクトのpom.xmlに記述されている。

- `generate-ddl`
- `execute-ddl`
- `generate-entity`
- `load-data`
- `export-schema`

成功すると`gsp-target/output/`ディレクトリにダンプファイルを含むjarファイルが生成される。

> **ヒント**: 実行に失敗する場合は、RDBMS固有の制限事項に抵触していないか確認する。RDBMS固有の制限事項については、[https://github.com/coastland/gsp-dba-maven-plugin (外部サイト)](https://github.com/coastland/gsp-dba-maven-plugin)の「ゴール共通のパラメータ」を参照。

**2. 以下のコマンドを実行して、ダンプファイルをローカルリポジトリへインストールする。**

```bash
mvn -P gsp install:install-file
```

**3. 以下のコマンドを実行して、ダンプファイルをインポートする。**

```bash
mvn -P gsp gsp-dba:import-schema
```

<details>
<summary>keywords</summary>

mvn -P gsp clean generate-resources, mvn -P gsp install:install-file, mvn -P gsp gsp-dba:import-schema, generate-ddl, execute-ddl, load-data, export-schema, gsp-target/output, 動作確認, ダンプファイル, スキーマインポート, ゴール共通のパラメータ, RDBMS固有の制限事項

</details>

## データモデリングツールについての補足

ブランクプロジェクトはSI Object Browser ERというモデリングツールを使用してデータモデル(data-model.edm)を作成することを前提としている。ただし、`data-model.edm`が使われるのはDDLの生成時だけである。そのため、任意の方法でDDLを生成・実行してデータベースを構築すれば、DDLの生成/実行以外の機能(generate-entity、load-data、export-schema)はSI Object Browser ER以外のモデリングツールを使用した場合でも実行可能である。

SI Object Browser ER以外のモデリングツールを使用する場合は、以下のように`generate-ddl`・`execute-ddl`のゴールが実行されないようpom.xmlを修正する。

```xml
<build>
  <plugins>
    <plugin>
      <groupId>jp.co.tis.gsp</groupId>
      <artifactId>gsp-dba-maven-plugin</artifactId>
        <executions>
          <execution>
            <id>default-cli</id>
            <phase>generate-resources</phase>
            <goals>
              <!-- <goal>generate-ddl</goal> この行を削除する -->
              <!-- <goal>execute-ddl</goal> この行を削除する -->
              <goal>generate-entity</goal>
              <goal>load-data</goal>
              <goal>export-schema</goal>
            </goals>
          </execution>
        </executions>
    </plugin>
  </plugins>
</build>
```

修正後に以下のコマンドを実行することでEntityクラスの生成、テストデータの登録、ダンプファイルの作成が行われる。なお、コマンド実行前に任意の方法でデータベースを構築する必要がある。

```bash
mvn -P gsp clean generate-resources
```

> **ヒント**: gsp-dba-maven-pluginはDDL生成機能を使用しない場合は、DDL実行機能の使用も推奨しない。

<details>
<summary>keywords</summary>

SI Object Browser ER, data-model.edm, generate-ddl, execute-ddl, モデリングツール, DDL生成スキップ, pom.xml修正

</details>
