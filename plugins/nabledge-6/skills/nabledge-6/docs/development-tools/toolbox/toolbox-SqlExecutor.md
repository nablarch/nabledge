# Nablarch SQL Executor

## 概要

Nablarch SQL ExecutorはNablarch特殊構文を含むSQLファイルを対話的に実行するツール。PJにおいて設計者がSQLを設計する際などに使用する。

使用前にPJで使用するDBを設定し、Mavenでビルドする必要がある。

## 想定使用方法

## 想定使用方法

- PJの環境構築担当者がSQL Executorをビルドして配布する。
- 配布したファイルは設計者が使用する。
- ビルド済みのツールはJavaとDBへの接続環境があれば使用可能。

## DB接続方法の選択

以下の2つの接続方法を選択できる:

- **PJ共通DB**: ツール使用者全員が同じDBに接続する
- **ローカルDB**: ツール使用者それぞれがローカルのDBに接続する

## 制約

以下のSQLは実行不可。これらのSQLを実行したい場合はデータベース付属のSQL実行環境などを使用すること:

- WITH句で始まるSQL
- IN句の条件に`,`を含むSQL
- DATETIMEリテラルを条件とした検索

> **補足**: NablarchはDomaのアダプタを提供している（:ref:`doma_adaptor`）。Domaを使用すると、本ツールのような複雑なセットアップ不要で本番環境用SQLをテスト実行できる（動的条件構築でもSQLの書き換え不要）。Domaの使用を検討することを推奨する。[Doma](https://doma.readthedocs.io/en/stable/)

## 配布方法 — 前提条件とソースコード取得

## 前提条件

- FirefoxまたはChromeがインストール済みであること
- Nablarchの開発環境が設定済みであること
- Maven Central RepositoryにJDBCドライバが存在しないRDBMSを使用する場合は、Project Local RepositoryまたはLocal RepositoryにJDBCドライバを登録済みであること（:ref:`customizeDBAddFileMavenRepo` 参照）

## ソースコード取得

[https://github.com/nablarch/sql-executor](https://github.com/nablarch/sql-executor) からcloneする。

## 配布方法 — DB設定変更

## db.configの修正（`src/main/resources/db.config`）

接続URL、ユーザ、パスワードを変更する場合に修正する。

**H2（デフォルト）:**
```text
db.url=jdbc:h2:./h2/db/SAMPLE
db.user=SAMPLE
db.password=SAMPLE
```

**Oracle:**
```text
# jdbc:oracle:thin:@ホスト名:ポート番号:データベースのSID
db.url=jdbc:oracle:thin:@localhost:1521/xe
db.user=sample
db.password=sample
```

**PostgreSQL:**
```text
# jdbc:postgresql://ホスト名:ポート番号/データベース名
db.url=jdbc:postgresql://localhost:5432/postgres
db.user=sample
db.password=sample
```

**DB2:**
```text
# jdbc:db2://ホスト名:ポート番号/データベース名
db.url=jdbc:db2://localhost:50000/SAMPLE
db.user=sample
db.password=sample
```

**SQL Server:**
```text
# jdbc:sqlserver://ホスト名:ポート番号;instanceName=インスタンス名
db.url=jdbc:sqlserver://localhost:1433;instanceName=SQLEXPRESS
db.user=SAMPLE
db.password=SAMPLE
```

## JDBCドライバの変更（`pom.xml`）

`pom.xml`の「使用するRDBMSにあわせて、下記JDBCドライバの dependency を更新してください。」コメント箇所を修正する。

**H2（デフォルト）:**
```xml
<dependency>
  <groupId>com.h2database</groupId>
  <artifactId>h2</artifactId>
  <version>2.2.220</version>
  <scope>runtime</scope>
</dependency>
```

**Oracle:**
```xml
<dependency>
  <groupId>com.oracle.database.jdbc</groupId>
  <artifactId>ojdbc11</artifactId>
  <version>23.2.0.0</version>
  <scope>runtime</scope>
</dependency>
```

**PostgreSQL:**
```xml
<dependency>
  <groupId>org.postgresql</groupId>
  <artifactId>postgresql</artifactId>
  <version>42.7.2</version>
  <scope>runtime</scope>
</dependency>
```

**DB2:**
```xml
<dependency>
  <groupId>com.ibm.db2</groupId>
  <artifactId>jcc</artifactId>
  <version>11.5.9.0</version>
  <scope>runtime</scope>
</dependency>
```

## `src/main/resources/db.xml`の修正

JDBCドライバのクラス名（`dataSource`コンポーネントの`driverClassName`プロパティ）とダイアレクトのクラス名を修正する。

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

| データベース | JDBCドライバのクラス名 | ダイアレクトのクラス名 |
|---|---|---|
| H2 | org.h2.Driver | nablarch.core.db.dialect.H2Dialect |
| Oracle | oracle.jdbc.driver.OracleDriver | nablarch.core.db.dialect.OracleDialect |
| PostgreSQL | org.postgresql.Driver | nablarch.core.db.dialect.PostgreSQLDialect |
| DB2 | com.ibm.db2.jcc.DB2Driver | nablarch.core.db.dialect.DB2Dialect |
| SQL Server | com.microsoft.sqlserver.jdbc.SQLServerDriver | nablarch.core.db.dialect.SqlServerDialect |

## 配布方法 — 起動確認と配布ファイル作成

## 起動確認

```text
mvn compile exec:java
```

ブラウザで `http://localhost:7979/index.html` を表示する。

> **補足**: 初回起動時など起動に時間がかかる場合、ブラウザがタイムアウトすることがある。起動完了後にブラウザをリロードすること。本ツールはInternet Explorerでは正常に動作しない。URLをコピーしFirefoxまたはChromeで開くこと。

## 配布ファイル作成

```text
mvn package
```

`target`直下に作成された`sql-executor-distribution.zip`を配布することで、Git/Mavenの環境なしでツールを使用できる。

## 配布されたツールの使用方法

## 前提条件

- PJで使用されるバージョンのJavaがインストール済みであること
- :ref:`db-settings` で設定したDBに接続可能であること
- FirefoxまたはChromeがインストール済みであること

## 起動方法

`sql-executor-distribution.zip`を解凍し、`sql-executor-distribution/sql-executor/sql-executor.bat`を実行する（ダブルクリックまたはコマンドプロンプトから）。

```bat
sql-executor.bat
```

## 配布時設定以外のDBへの接続

`sql-executor.bat`を編集する。

| 設定項目 | 説明 |
|---|---|
| db.url | データベースURL |
| db.user | 接続ユーザ |
| db.password | パスワード |

例として `db.url=jdbc:h2:./h2/db/SAMPLE`、`db.user=SAMPLE`、`db.password=SAMPLE` へ接続する場合の編集方法を以下に示す（3行目が変更箇所）。

```bat
cd /d %~dp0

start java -Ddb.url=jdbc:h2:./h2/db/SAMPLE -Ddb.user=SAMPLE -Ddb.password=SAMPLE -jar sql-executor.jar （以降略）
cmd /c start http://localhost:7979/index.html
```

実行しても何も出力されずに異常終了する場合は、:ref:`faq` を参照。

## 操作方法

## 基本操作

初回起動時はカレントディレクトリ配下のSQLファイルの一覧を表示するが、存在しない場合は初期画面が表示される。

右下の入力欄にローカルフォルダのパスを指定して **[再検索]** をクリックすると、配下のSQLファイルとステートメント一覧を表示する。

各ステートメント名をクリックすると、その内容と操作用のボタンが表示される。

ステートメント内の埋込み変数は入力フィールドになっており、**[Run]** クリックでステートメントを実行できる。**[Fill]** クリックで前回実行時の入力フィールド内容を復元する。

## SQLExecutorでの記法

### 文字列の記述
文字列を条件として入力する場合は `'` で囲む必要がある。

### 文字列以外の記述
文字列以外は `'` で囲まずに記述する。

### IN句の記述
IN句の条件は `[]` で囲む必要がある。複数項目は `,` で区切る。

`$if` 特殊構文とIN句の条件に同一の変数名を指定している場合は、同一の値を入力する必要がある。

`[]` が付与されていない場合のエラー: `java.lang.IllegalArgumentException: object type in field is invalid. valid object type is Collection or Array.`

> **警告**: `,` をIN句の検索条件として扱うことはできない。

### 日付型の設定
DATE型フィールドへの値設定はSQL92のDATEリテラル形式（例: `1970-12-11`）で記述する。`SYSDATE` キーワードを指定することで現在時刻が設定される。

> **警告**: DATETIMEリテラルを条件とした検索はできない。

## FAQ

## FAQ

**Q1**: 実行時のログを見たいが、どのようにすればログを確認できるか？

**A1**: 実行時に、以下のログファイルが出力される。

- `sql.log` → SQL文の実行時ログ
- `app.log` → 全実行ログ

---

**Q2**: 実行しても何も出力されずに異常終了してしまう場合、どう対処すればよいか？

**A2**: 起動時のDBコネクションエラーなどの一部のエラーは標準エラー出力ではなく、実行ログファイルに出力される。実行ログは、カレントディレクトリ直下に `app.log` という名前で出力されるので、その内容を確認して対処する。

---

**Q3**: `パラメータの指定方法が正しくありません。` というメッセージが表示されるが、対処方法が分からない。

**A3**: 文字列を入力したい場合には文字列を `'` で囲んでいるかを確認する。真偽値、日付型を入力したい場合には、スペルミスや形式のミスがないかを確認して対処する。
