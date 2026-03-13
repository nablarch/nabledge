# gsp-dba-maven-plugin(DBA作業支援ツール)の初期設定方法

**公式ドキュメント**: [gsp-dba-maven-plugin(DBA作業支援ツール)の初期設定方法](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/addin_gsp.html)

## pom.xmlファイルの修正

> **前提**: アーキタイプから生成後、CustomizeDB の手順を実施した各種プロジェクトを対象とする。

> **重要**: gsp-dba-maven-pluginは開発フェーズで用いることを想定。本番環境での使用は推奨しない。ERから生成したDDLをそのまま本番環境に配置して実行することも想定していない。本番環境向けDDLを作成する場合はDBAが確認すること。

> **補足**: H2 Database Engineを使用する場合、以下の設定は不要。[confirm_gsp](#s2) のみ実行すること。

pom.xmlのpropertiesタグ内の以下のプロパティを修正する。

| プロパティ名 | 説明 |
|---|---|
| nablarch.db.jdbcDriver | JDBCドライバのクラス名 |
| nablarch.db.url | データベースの接続URL |
| nablarch.db.adminUser | 管理者ユーザ名 |
| nablarch.db.adminPassword | 管理者ユーザのパスワード |
| nablarch.db.user | データベースアクセスユーザ名 |
| nablarch.db.password | データベースアクセスユーザのパスワード |
| nablarch.db.schema | 接続するスキーマ名 |

**Oracle**:
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

**PostgreSQL**:
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

**DB2**:
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

**SQLServer**:
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

build要素内: gsp-dba-maven-pluginに対する依存関係をH2 JDBCドライバから使用するRDBMSに変更する（:ref:`customizeDB_pom_dependencies` 参照）。PostgreSQLの例:

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

nablarch.db.jdbcDriver, nablarch.db.url, nablarch.db.adminUser, nablarch.db.adminPassword, nablarch.db.user, nablarch.db.password, nablarch.db.schema, gsp-dba-maven-plugin設定, JDBC接続設定, Oracle設定, PostgreSQL設定, DB2設定, SQLServer設定, pom.xml設定, H2データベース, CustomizeDB, アーキタイプ, 前提条件

</details>

## data-model.edm  (src/main/resources/entity)の準備

src/main/resources/entity以下にRDBMS毎のedmファイルが存在する。使用するRDBMSに対応するファイルを`data-model.edm`にリネームする。

## 動作確認

> **重要**: DBのデータが削除されるため、必要であれば現在DBに格納されているデータを退避しておくこと。

1. DDL生成からダンプファイル作成まで実行:
```bash
mvn -P gsp clean generate-resources
```
実行されるゴール: `generate-ddl`、`execute-ddl`、`load-data`、`export-schema`。成功すると`gsp-target/output/`ディレクトリにダンプファイルを格納したjarファイルが生成される。

> **補足**: 実行に失敗する場合は、RDBMS固有の制限事項に抵触していないか確認する。RDBMS固有の制限事項については、gsp-dba-maven-plugin の「ゴール共通のパラメータ」を参照。

2. ダンプファイルをローカルリポジトリへインストール:
```bash
mvn -P gsp install:install-file
```

3. ダンプファイルをインポート:
```bash
mvn -P gsp gsp-dba:import-schema
```

## データモデリングツールについての補足

ブランクプロジェクトは[SI Object Browser ER(外部サイト)](https://products.sint.co.jp/ober)でdata-model.edmを作成することを前提としている。data-model.edmが使われるのはDDLの生成時のみであるため、任意の方法でDDLを生成・実行してDBを構築すれば、DDL生成/実行以外の機能はSI Object Browser ER以外のモデリングツールでも使用可能。

SI Object Browser ER以外のモデリングツールを使用する場合は、generate-ddlとexecute-ddlのゴールが実行されないようpom.xmlを修正する:

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

修正後、コマンド実行前に任意の方法でDBを構築し、以下のコマンドを実行する（Entityクラスの生成、テストデータの登録、ダンプファイルの作成が行われる）:

```bash
mvn -P gsp clean generate-resources
```

> **補足**: DDL生成機能を使用しない場合は、DDL実行機能の使用も推奨しない。

<details>
<summary>keywords</summary>

data-model.edm, edmファイル, 動作確認, mvn gsp, generate-resources, import-schema, install-file, SI Object Browser ER, DDL生成, ダンプファイル, generate-ddl, execute-ddl, gsp-dba-maven-plugin動作確認, RDBMS固有の制限事項, ゴール共通のパラメータ

</details>
