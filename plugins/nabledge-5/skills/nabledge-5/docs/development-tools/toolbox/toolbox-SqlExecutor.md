# Nablarch SQL Executor

**公式ドキュメント**: [Nablarch SQL Executor](https://nablarch.github.io/docs/LATEST/doc/development_tools/toolbox/SqlExecutor/SqlExecutor.html)

## 概要

Nablarch特殊構文を含むSQLファイルを対話的に実行するツール。PJにおいて設計者がSQLを設計する際などに使用する。PJで使用するDBを設定してビルドして使う必要がある。

## 基本的な操作方法

初回起動時はカレントディレクトリ配下のSQLファイルの一覧を表示する。SQLファイルが存在しない場合は初期画面が表示される。

右下の入力欄にローカルフォルダのパスを指定して **[再検索]** をクリックすると、配下のSQLファイルとステートメント一覧が表示される。

各ステートメント名をクリックすると内容と操作ボタンが表示される。埋込み変数は入力フィールドになっており、**[Run]** で実行、**[Fill]** で前回入力値を復元できる。

## SQLExecutorでの記法

| 入力値の種類 | 書式 |
|---|---|
| 文字列 | `'` で囲む（例: `'value'`） |
| 文字列以外（数値・真偽値等） | `'` で囲まない |
| IN句の条件 | `[]` で囲み、複数項目は `,` で区切る |
| 日付型(DATE) | SQL92 DATEリテラル書式（例: `1970-12-11`）または `SYSDATE`（現在時刻） |

> **警告**: 本ツールにおいて `,` をIN句の検索条件として扱うことはできない。

> **警告**: DATETIMEリテラルを条件とした検索はできない。

`$if` 特殊構文とIN句の条件に同一の変数名を指定している場合は、同一の値を入力する必要がある。

IN句の条件に `[]` が付与されていない場合、以下のエラーが出力される:
`java.lang.IllegalArgumentException: object type in field is invalid. valid object type is Collection or Array.`

## FAQ

**Q1: 実行時ログの確認方法**
- `sql.log` → SQL文の実行時ログ
- `app.log` → 全実行ログ

**Q2: 異常終了時の対処（何も出力されない場合）**

起動時のDBコネクションエラーなどは標準エラー出力ではなく `app.log`（カレントディレクトリ直下）に出力される。`app.log` の内容を確認して対処する。

**Q3: 「パラメータの指定方法が正しくありません」の対処**
- 文字列を入力する場合は `'` で囲んでいるか確認する
- 真偽値・日付型を入力する場合はスペルミスや形式ミスがないか確認する

<details>
<summary>keywords</summary>

SQL Executor, Nablarch特殊構文, SQLファイル実行, 対話的実行, 開発ツール, Nablarch SQL Executor, 設計者, SQL実行, SQLExecutor操作, IN句, 日付型, パラメータ入力, $if特殊構文, DATEリテラル, SYSDATE, app.log, sql.log, IllegalArgumentException, エラー対処, 再検索, Fill, Run, 初回起動

</details>

## 想定使用方法

## 想定使用方法

PJの環境構築担当者がSQL Executorをビルドして配布し、配布したファイルを設計者が使用する。ビルド済みのツールはJavaとDBへの接続環境があれば使用可能。

## DB接続方法

以下2つの方法から選択可能:
- PJ共通のDBに全員が接続する
- 各ユーザがローカルのDBに接続する

## 制約

以下のSQLは実行不可。使用する場合はDBに付属のSQL実行環境を使うこと:
- WITH句で始まるSQL
- IN句の条件に`,`を含むSQL
- DATETIMEリテラルを条件とした検索

> **補足**: Nablarchでは2-way SQL向け[Doma](https://doma.readthedocs.io/en/stable/)の [アダプタ](../../component/adapters/adapters-doma_adaptor.md) を提供。Domaを使用すると複雑なセットアップ不要で本番環境用SQLをテスト実行可能（動的条件でもSQLを書き換えずに実行可能）。このため、Domaの使用を検討することを推奨。

<details>
<summary>keywords</summary>

制約, WITH句, IN句, DATETIMEリテラル, DB接続方法, Domaアダプタ, doma_adaptor, 共通DB, ローカルDB, 配布モデル

</details>

## 配布方法

## 前提条件

- Firefox または Chrome がインストール済みであること
- Nablarchの開発環境が設定済みであること
- Maven Central RepositoryにJDBCドライバが存在しないRDBMSを使用する場合は、Project Local RepositoryまたはLocal RepositoryにJDBCドライバを登録済みであること（:ref:`customizeDBAddFileMavenRepo` 参照）

## ソースコード取得

[https://github.com/nablarch/sql-executor](https://github.com/nablarch/sql-executor) をclone。

## DB設定変更

### src/main/resources/db.config

接続URL、ユーザ、パスワードを設定:

**H2（デフォルト）**:
```
db.url=jdbc:h2:./h2/db/SAMPLE
db.user=SAMPLE
db.password=SAMPLE
```

**Oracle**:
```
db.url=jdbc:oracle:thin:@localhost:1521/xe
db.user=sample
db.password=sample
```

**PostgreSQL**:
```
db.url=jdbc:postgresql://localhost:5432/postgres
db.user=sample
db.password=sample
```

**DB2**:
```
db.url=jdbc:db2://localhost:50000/SAMPLE
db.user=sample
db.password=sample
```

**SQL Server**:
```
db.url=jdbc:sqlserver://localhost:1433;instanceName=SQLEXPRESS
db.user=SAMPLE
db.password=SAMPLE
```

### pom.xml（JDBCドライバ依存）

使用するRDBMSに合わせてJDBCドライバの依存を更新:

**H2（デフォルト）**:
```xml
<dependency>
  <groupId>com.h2database</groupId>
  <artifactId>h2</artifactId>
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

### src/main/resources/db.xml

driverClassNameとダイアレクトのクラス名を設定:

```xml
<component name="dataSource" class="org.apache.commons.dbcp.BasicDataSource">
  <property name="driverClassName" value="org.h2.Driver" />
</component>

<component name="connectionFactory"
    class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
  <property name="dialect">
    <component class="nablarch.core.db.dialect.H2Dialect"/>
  </property>
</component>
```

DB/JDBCドライバ/ダイアレクト対応表:

| データベース | JDBCドライバのクラス名 | ダイアレクトのクラス名 |
|---|---|---|
| H2 | org.h2.Driver | nablarch.core.db.dialect.H2Dialect |
| Oracle | oracle.jdbc.driver.OracleDriver | nablarch.core.db.dialect.OracleDialect |
| PostgreSQL | org.postgresql.Driver | nablarch.core.db.dialect.PostgreSQLDialect |
| DB2 | com.ibm.db2.jcc.DB2Driver | nablarch.core.db.dialect.DB2Dialect |
| SQL Server | com.microsoft.sqlserver.jdbc.SQLServerDriver | nablarch.core.db.dialect.SqlServerDialect |

## 起動確認

```
mvn compile exec:java
```

ブラウザで http://localhost:7979/index.html を表示。

> **補足**: 初回起動時は時間がかかりブラウザがタイムアウトすることがある。起動完了後にブラウザをリロードすること。

> **警告**: Internet Explorerは非対応。Internet Explorerが起動した場合はURLをコピーしてFirefoxまたはChromeのアドレス欄に貼り付けること。

## 配布ファイル作成

```
mvn package
```

target直下に作成された `sql-executor-distribution.zip` を配布することで、Git・Mavenの環境なしでツールを使用可能。

<details>
<summary>keywords</summary>

db.config, db.xml, pom.xml, JDBCドライバ, BasicDataSource, BasicDbConnectionFactoryForDataSource, H2Dialect, OracleDialect, PostgreSQLDialect, DB2Dialect, SqlServerDialect, customizeDBAddFileMavenRepo, mvn compile exec:java, mvn package, sql-executor-distribution.zip, driverClassName

</details>

## 配布されたツールの使用方法

## 前提条件

- PJで使用されるバージョンのJavaがインストール済みであること
- [db-settings](#s3) で設定したDBに接続可能であること
- Firefox または Chrome がインストール済みであること

## 起動方法

`sql-executor-distribution.zip` を解凍し、`sql-executor-distribution/sql-executor/sql-executor.bat` を実行（ダブルクリックまたはコマンドプロンプトから）:

```bat
sql-executor.bat
```

## 配布時に設定済みのDB以外に接続する場合

`sql-executor.bat` を編集する。設定項目:

| 設定項目 | 説明 |
|---|---|
| db.url | データベースURL |
| db.user | 接続ユーザ |
| db.password | パスワード |

例（`db.url=jdbc:h2:./h2/db/SAMPLE`、`db.user=SAMPLE`、`db.password=SAMPLE` に接続）:

```bat
start java -Ddb.url=jdbc:h2:./h2/db/SAMPLE -Ddb.user=SAMPLE -Ddb.password=SAMPLE -jar sql-executor.jar （以降略）
```

実行しても何も出力されずに異常終了する場合は、[faq](#) を参照。

<details>
<summary>keywords</summary>

sql-executor.bat, 配布ファイル起動, DB接続設定変更, db.url, db.user, db.password, faq

</details>
