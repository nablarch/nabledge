# SQL文実行部品の構造とその使用方法

## 

SQL文実行部品: JDBCのAPIをラップする機能と [簡易検索機能](libraries-04_DbAccessSpec.md) を提供するコンポーネント群。`nablarch.core.db.statement` パッケージに主要インタフェース・クラスが含まれる。

> **注意**: フレームワーク内部でテーブルのスキーマ情報から動的にSQL文を組み立てる必要がある場合の実装例。通常、各アプリケーション・プログラマはSQL文を外部ファイル化するためこのような実装は行わない。

```java
AppDbConnection connection = DbConnectionContext.getConnection(transaction.getDbTransactionName());
SqlPStatement statement = connection.prepareStatement(
        "SELECT USER_ID, NAME, TEL, AGE FROM USER_MTR WHERE USER_ID = ?");
statement.setObject(1, "00001");
SqlResultSet resultSet = statement.retrieve();
for (SqlRow row : resultSet) {
    String userId = row.getString("user_id");
    String name = row.getString("name");
    String tel = row.getString("tel");
    String age = row.getString("age");
}
```

<details>
<summary>keywords</summary>

SQL文実行部品, JDBCラッパー, 簡易検索機能, nablarch.core.db.statement, StatementFactory, AppDbConnection, SqlPStatement, SqlResultSet, SqlRow, DbConnectionContext, prepareStatement, SQL文直接指定, データベースアクセス

</details>

## SQL文実行部品の構造とその使用方法

SQL文実行部品のクラス設計図:

![SQL文実行部品クラス設計図](../../../knowledge/component/libraries/assets/libraries-04_Statement/DbAccessSpec_StatementClassDesign.jpg)

主要パッケージ: `nablarch.core.db.statement`、`nablarch.core.db.support`

**クラス**: `nablarch.core.db.statement.BasicStatementFactory`

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
    <property name="sqlStatementExceptionFactory">
        <component class="nablarch.core.db.statement.exception.BasicSqlStatementExceptionFactory">
            <property name="duplicateErrorSqlState" value=""/>
            <property name="duplicateErrorErrCode" value="1"/>
        </component>
    </property>
    <property name="fetchSize" value="500"/>
    <property name="queryTimeout" value="600" />
    <property name="sqlLoader">
        <component class="nablarch.core.db.statement.BasicSqlLoader">
            <property name="fileEncoding" value="utf-8"/>
            <property name="extension" value="sql"/>
        </component>
    </property>
</component>
```

### a) BasicStatementFactory プロパティ

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| sqlStatementExceptionFactory | ○ | | `SqlStatementExceptionFactory` 実装クラスを設定する |
| resultSetConvertor | | | `ResultSetConvertor` 実装クラスを設定する。SELECT結果のカラムデータ変換が不要な場合は省略可 |
| fetchSize | | 10 | プリフェッチサイズ。Statement単位で `SqlPStatement#setFetchSize` で変更可 |
| queryTimeout | | 0（無制限） | クエリータイムアウト秒数。Statement単位で `SqlPStatement#setQueryTimeout` で変更可 |
| sqlLoader | | | `StaticDataLoader<Map<String, String>>` 実装クラスを設定する |

> **注意**: `SqlPStatement#setFetchSize` または `SqlPStatement#setQueryTimeout` で変更した値は変更されたインスタンスでのみ有効。`AppDbConnection#prepareStatement` で新規取得した場合は設定ファイルの値に戻る。これは :ref:`statementReuse<db-dataSourceConnectionFactory-label>` の設定に関わらず同一の振る舞いとなる。

### b) BasicSqlStatementExceptionFactory プロパティ

**クラス**: `nablarch.core.db.statement.exception.BasicSqlStatementExceptionFactory`

以下のどちらか一方を必ず設定すること。

| プロパティ名 | 説明 |
|---|---|
| duplicateErrorSqlState | 一意制約違反を示すSqlState（`SQLException#getSqlState` の返却値） |
| duplicateErrorErrCode | 一意制約違反を示すErrCode（`SQLException#getErrorCode` の返却値） |

### c) BasicSqlLoader プロパティ

**クラス**: `nablarch.core.db.statement.BasicSqlLoader`

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| fileEncoding | JVMデフォルトエンコーディング | SQLファイルのエンコーディング |
| extension | sql | SQLファイルの拡張子 |

`BasicSqlLoader` 以外の実装クラスに差し替える場合の要件:
- `StaticDataLoader` のgeneric型は `Map<String, String>` とすること（例: `implements StaticDataLoader<Map<String, String>>`）
- `getValue` メソッドでSQL読み込み処理を行い、それ以外のメソッドはnullを返すこと
- `getValue` の返却Map: KEY=SQL_ID、VALUE=SQL文

<details>
<summary>keywords</summary>

クラス設計図, DbAccessSpec_StatementClassDesign, SQL文実行部品 クラス構造, nablarch.core.db.statement パッケージ構成, BasicStatementFactory, BasicSqlStatementExceptionFactory, BasicSqlLoader, StaticDataLoader, SqlStatementExceptionFactory, ResultSetConvertor, sqlStatementExceptionFactory, resultSetConvertor, fetchSize, queryTimeout, sqlLoader, duplicateErrorSqlState, duplicateErrorErrCode, fileEncoding, extension, 一意制約違反, プリフェッチサイズ, クエリータイムアウト, SQLファイルロード

</details>

## 各クラスの責務

**パッケージ**: `nablarch.core.db.statement`

| インタフェース名 | 概要 |
|---|---|
| `StatementFactory` | `java.sql.PreparedStatement` のラッパークラス、`java.sql.CallableStatement` のラッパークラス、`ParameterizedSqlPStatement` を生成するインタフェース |
| `SqlStatement` | `SqlPStatement`、`ParameterizedSqlPStatement` の親インタフェース |
| `SqlPStatement` | PreparedStatementのラッパー機能のインタフェース。[簡易検索機能](libraries-04_DbAccessSpec.md) のインタフェースも持つ |
| `ResultSetConvertor` | `java.sql.ResultSet` から値を取得するインタフェース。`ResultSet#getObject` 以外を使用してSELECT結果を取得する必要がある場合は実装クラスを追加すること。主に、データベースのデータタイプに応じてJavaオブジェクトのデータ対応を決め打ちたい場合に使用する |
| `ParameterizedSqlPStatement` | オブジェクトのフィールド値をDBに登録するインタフェース |
| `StatementExceptionFactory` | `SQLException` 発生時に送出するExceptionを生成するインタフェース |

<details>
<summary>keywords</summary>

StatementFactory, SqlStatement, SqlPStatement, ResultSetConvertor, ParameterizedSqlPStatement, StatementExceptionFactory, インタフェース定義

</details>

## nablarch.core.db.statementパッケージ

### a) StatementFactory実装

**クラス**: `nablarch.core.db.statement.BasicStatementFactory`

StatementFactoryの基本実装。`BasicSqlPStatement`（`java.sql.PreparedStatement` ラッパークラス）を生成する。

> **注意**: [SQLインジェクション対策](libraries-04_DbAccessSpec.md) のため、`java.sql.Statement` クラスのラッパー生成機能は提供しない。

### b) SqlPStatement実装

**クラス**: `nablarch.core.db.statement.BasicSqlPStatement`

`SqlPStatement`（`SqlStatement`）および `ParameterizedSqlPStatement` の基本実装クラス。DBベンダー非依存の実装。

> **注意**: ベンダー依存の実装が必要な場合は、`SqlPStatement` および `ParameterizedSqlPStatement` の実装クラスを追加して差し替えること。

### c) StatementExceptionFactory実装

**クラス**: `nablarch.core.db.statement.exception.BasicSqlStatementExceptionFactory`

発生した `SQLException` に応じて以下の例外を生成する:
- 一意制約違反の場合: `DuplicateStatementException` を送出
- 一意制約違反以外の場合: `SqlStatementException` を送出

一意制約違反の判定は `SQLException#getSQLState` または `SQLException#getErrorCode` を使用。判定値は [BasicSqlStatementExceptionFactoryの設定](#) を参照。

> **注意**: 一意制約違反以外の例外をアプリケーションでハンドリングする必要がある場合は、`SqlStatementException` を継承したクラスとそのFactoryクラスを追加すること。

### d) 検索結果クラス

**クラス**: `nablarch.core.db.statement.ResultSetIterator`  
`java.sql.ResultSet` のラッパークラス。`SqlRow` で1レコード分のデータを取得するインタフェースを提供。

**クラス**: `nablarch.core.db.statement.SqlResultSet`  
簡易検索結果が格納されるArrayListのサブクラス。JDBC経由のSELECT実行で返却される `java.sql.ResultSet` の結果を全件メモリ上に保持する。

> **警告**: `SqlResultSet` は検索結果を全件メモリ保持するため、大量データ検索時はメモリ不足の原因となる。大量データを検索する場合は `PreparedStatement` ラッパークラスの `executeQuery` を使用し、`ResultSetIterator` で結果を扱うこと。

**クラス**: `nablarch.core.db.statement.SqlRow`  
`java.sql.ResultSet` の1レコード分データを格納するMapインタフェースの実装クラス。`SqlResultSet` の各要素に格納される。

### e) SQL文ロードクラス

**クラス**: `nablarch.core.db.statement.BasicSqlLoader`

クラスパス上の外部ファイルからSQL文を読み込む。[../05_StaticDataCache](libraries-05_StaticDataCache.md) によりSQLファイル単位にKEY:SQL_ID / VALUE:SQL文としてキャッシュ。SQL_IDはSQLファイル内で一意にすること。

SQLファイルの記述ルール:
1. SQL_IDとSQL文の1グループは空行で区切る。SQL文内に空行不可。異なるSQL文の間には必ず空行を入れること。**コメント行は空行とはならない**
2. SQL文の最初の「=」までがSQL_ID
3. コメントは「--」で開始（行コメントのみ、ブロックコメント非サポート）
4. SQL文の途中で改行可。スペース/tabで桁揃え可

```sql
-- SQL_ID:GET_XXXX_INFO
GET_XXXX_INFO =
SELECT
   COL1,
   COL2
FROM
   TEST_TABLE
WHERE
   COL1 = :col1

-- SQL_ID:UPDATE_XXXX
UPDATE_XXXX =
UPDATE
    TEST_TABLE
SET
    COL2 = :col2
WHERE
    COL1 = :col1
```

### f) サポートクラス

**クラス**: `nablarch.core.db.support.DbAccessSupport`

SQL_IDからStatementオブジェクトを生成するクラス。データベースアクセスクラスはこのクラスを継承することで簡易的にStatementオブジェクトを生成可能。

SQLファイル名はDbAccessSupportを継承したDBアクセスクラスの完全修飾名と一致させること:
- DBアクセスクラス: `nablarch.sample.management.user.UserRegisterService`
- SQLファイル: `nablarch/sample/management/user/UserRegisterService.sql`

> **注意**: 継承できない場合（既に他クラスを継承済み等）は直接インスタンス化可。その際はデフォルトコンストラクタでなく `DbAccessSupport(Clazz<?> clazz)` コンストラクタを使用すること。デフォルトコンストラクタ使用時はDbAccessSupportの完全修飾名でSQLファイルを検索する点に注意。

提供インタフェース:
- `SqlPStatement getSqlPStatement(String sqlId)` - SQL_IDからSqlPStatementを生成
- `ParameterizedSqlPStatement getParameterizedSqlStatement(String sqlId)` - SQL_IDからParameterizedSqlPStatementを生成
- `ParameterizedSqlPStatement getParameterizedSqlStatement(String sqlId, Object condition)` - SQL_IDと条件オブジェクトから可変条件SQL用ParameterizedSqlPStatementを生成
- `int countByStatementSql(String sqlId)` - 条件不要のカウントSQL実行
- `int countByParameterizedSql(String sqlId, Object condition)` - 条件オブジェクトによるカウントSQL実行
- `SqlResultSet search(String sqlId, ListSearchInfo condition) throws TooManyResultException` - 件数取得および検索実行

<details>
<summary>keywords</summary>

BasicStatementFactory, BasicSqlPStatement, BasicSqlStatementExceptionFactory, ResultSetIterator, SqlResultSet, SqlRow, BasicSqlLoader, DbAccessSupport, DuplicateStatementException, SqlStatementException, SQL_ID, SQLファイル, 大量データ メモリ不足, 一意制約違反, getSqlPStatement, getParameterizedSqlStatement, countByStatementSql, countByParameterizedSql, search, ListSearchInfo, TooManyResultException, executeQuery, nablarch.core.db.support

</details>

## 簡易検索の場合の処理シーケンス

![簡易検索処理シーケンス図](../../../knowledge/component/libraries/assets/libraries-04_Statement/DbAccessSpec_StatementSequence.jpg)

処理フロー:
1. SQL_IDを元に `SqlPStatement` を取得: `DbAccessSupport#getSqlPStatement` を呼び出す
2. SQL文を実行: `SqlPStatement#retrieve` を呼び出す
3. 簡易検索結果を処理: 返却された `SqlResultSet` から検索結果の値を取得する

> **注意**: `SqlPStatement#setString()` 等を呼び出し、SQL文の実行前に条件を設定すること（シーケンスでは条件設定を省略）。

<details>
<summary>keywords</summary>

DbAccessSupport#getSqlPStatement, SqlPStatement#retrieve, SqlResultSet, 簡易検索 処理フロー, 検索シーケンス, 条件設定 setString

</details>

## 推奨するJavaの実装例(SQL文を外部ファイル化した場合)

SQLファイル名はクラスパス配下にDbAccessSupportを継承したDBアクセスクラスのクラス名（完全修飾名）で作成する。拡張子はデフォルト `.sql`（設定ファイルで変更可）。

DBアクセスクラスのクラス名が `nablarch.sample.user.UserService` の場合、クラスパス配下に `nablarch/sample/user/UserService.sql` を作成する。

SQLファイルの記述ルールは [SQL文のロードクラス](#s4) を参照。

**SQLファイル定義**:

```sql
GET_USER_INFO =
SELECT USER_ID,
       NAME,
       TEL,
       AGE
  FROM USER_MTR
 WHERE USER_ID = ?
```

**Java実装**:

```java
package nablarch.sample.user;

public class UserService extends DbAccessSupport {

    public SqlResultSet getUserInfo(String userId) {
        SqlPStatement statement = getSqlPStatement("GET_USER_INFO");
        statement.setObject(1, "00001");
        return statement.retrieve();
    }
}
```

<details>
<summary>keywords</summary>

DbAccessSupport, getSqlPStatement, UserService, SqlResultSet, SQLファイル外部化, Java実装例, setObject, retrieve, sql-load-class-label

</details>
