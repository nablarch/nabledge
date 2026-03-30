# SQL文実行部品の構造とその使用方法

## SQL文実行部品の構造とその使用方法

SQL文実行部品の構造とその使用方法。JDBCのAPIをラップしている機能と簡易検索機能で構成される。

![SQL文実行部品クラス設計図](../../../knowledge/component/libraries/assets/libraries-04_Statement/DbAccessSpec_StatementClassDesign.jpg)

> **注意**: この実装はフレームワーク内部でテーブルスキーマ情報から動的にSQL文を組み立てる必要がある場合にのみ使用する。通常、SQLインジェクション対策のためSQL文は外部ファイル化するため、各アプリケーション開発者はこの実装を行わない。

**クラス**: `AppDbConnection`, `SqlPStatement`, `SqlResultSet`, `SqlRow`, `DbConnectionContext`

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

SQL文実行部品, JDBC, クラス図, 簡易検索, StatementFactory, SqlPStatement, PreparedStatement, AppDbConnection, SqlResultSet, SqlRow, DbConnectionContext, SQL文直接指定, プリペアドステートメント, retrieve, setObject

</details>

## 各クラスの責務

`nablarch.core.db.statement`パッケージのインタフェース定義。

| インタフェース名 | 概要 |
|---|---|
| `StatementFactory` | `java.sql.PreparedStatement`のラッパー、`java.sql.CallableStatement`のラッパー、`ParameterizedSqlPStatement`を生成するインタフェース |
| `SqlStatement` | `SqlPStatement`、`ParameterizedSqlPStatement`の親インタフェース |
| `SqlPStatement` | `PreparedStatement`のラッパー機能のインタフェース。[簡易検索機能](libraries-04_DbAccessSpec.md) のインタフェースをもつ |
| `ResultSetConvertor` | `java.sql.ResultSet`から値を取得するインタフェース。`ResultSet#getObject`以外を使用する場合（データベースのデータタイプに応じてJavaオブジェクトのデータ対応を決め打ちたい場合）に実装クラスを追加する |
| `ParameterizedSqlPStatement` | オブジェクトのフィールド値をデータベースに登録するインタフェース |
| `StatementExceptionFactory` | `SQLException`発生時に送出する`Exception`を生成するインタフェース |

**a) StatementFactory設定**

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

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| sqlStatementExceptionFactory | ○ | | `nablarch.core.db.statement.SqlStatementExceptionFactory`を実装したクラスを設定する |
| resultSetConvertor | | | `nablarch.core.db.statement.ResultSetConvertor`を実装したクラスを設定する。SELECT結果のカラムデータを変換する場合に設定する |
| fetchSize | | 10 | プリフェッチサイズ。`SqlPStatement#setFetchSize`でStatement単位での変更も可能 |
| queryTimeout | | 0（無制限） | クエリータイムアウトの秒数。`SqlPStatement#setQueryTimeout`でStatement単位での変更も可能 |
| sqlLoader | | | `nablarch.core.cache.StaticDataLoader`を実装したクラスを設定する（サンプルでは`BasicSqlLoader`を使用） |

> **注意**: `SqlPStatement#setFetchSize`および`SqlPStatement#setQueryTimeout`で変更した値は、そのインスタンスでのみ有効。新たに`AppDbConnection#prepareStatement`を呼び出した場合は設定ファイルの値に戻る（:ref:`statementReuse<db-dataSourceConnectionFactory-label>`の設定に関わらず同一の振る舞い）。

**b) BasicSqlStatementExceptionFactory設定**

**クラス**: `nablarch.core.db.statement.exception.BasicSqlStatementExceptionFactory`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| duplicateErrorSqlState | ※ | | 一意制約違反を示すSqlState（`SQLException#getSqlState`で返却される値） |
| duplicateErrorErrCode | ※ | | 一意制約違反を示すErrCode（`SQLException#getErrorCode`で返却される値） |

※ `duplicateErrorSqlState`または`duplicateErrorErrCode`のどちらか一方を必ず設定すること。

**c) BasicSqlLoader設定**

**クラス**: `nablarch.core.db.statement.BasicSqlLoader`（`nablarch.core.cache.StaticDataLoader<Map<String, String>>`を実装）

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| fileEncoding | | JVMデフォルト | SQLファイルのエンコーディング |
| extension | | sql | SQLファイルの拡張子 |

`BasicSqlLoader`以外の実装クラスに差し替える場合の仕様:
- `StaticDataLoader`のgenerics型は`Map<String, String>`とすること（例: `implements StaticDataLoader<Map<String, String>>`）
- `getValue`メソッドでSQLの読み込み処理を行い、その他のメソッドはnullを返す実装とすること
- `getValue`が返すMapのKEY=SQL_ID、VALUE=SQL文

<details>
<summary>keywords</summary>

StatementFactory, SqlStatement, SqlPStatement, ResultSetConvertor, ParameterizedSqlPStatement, StatementExceptionFactory, インタフェース定義, BasicStatementFactory, BasicSqlStatementExceptionFactory, BasicSqlLoader, StaticDataLoader, SqlStatementExceptionFactory, sqlStatementExceptionFactory, resultSetConvertor, fetchSize, queryTimeout, sqlLoader, duplicateErrorSqlState, duplicateErrorErrCode, fileEncoding, extension, StatementFactory設定, 一意制約違反, SQLファイル読み込み, setFetchSize, setQueryTimeout

</details>

## nablarch.core.db.statementパッケージ

### a) StatementFactory実装クラス

**クラス**: `nablarch.core.db.statement.BasicStatementFactory`

`StatementFactory`の基本実装。`BasicSqlPStatement`（`java.sql.PreparedStatement`ラッパー）を生成する。

> **注意**: `java.sql.Statement`クラスのラッパークラスの生成機能は提供しない（[SQLインジェクション対策](libraries-04_DbAccessSpec.md)参照）。

### b) SqlPStatement実装クラス

**クラス**: `nablarch.core.db.statement.BasicSqlPStatement`

`SqlPStatement`（`SqlStatement`）、`ParameterizedSqlPStatement`の基本実装クラス。データベースベンダー非依存の実装。ベンダー依存の実装が必要な場合は`SqlPStatement`および`ParameterizedSqlPStatement`の実装クラスを追加して差し替えること。

### c) StatementExceptionFactory実装クラス

**クラス**: `nablarch.core.db.statement.exception.BasicSqlStatementExceptionFactory`

一意制約違反の場合は`DuplicateStatementException`を、それ以外は`SqlStatementException`を送出する。判定は`SQLException#getSQLState`または`SQLException#getErrorCode`を元に行う（[設定](#)参照）。

> **注意**: 一意制約違反以外の例外をアプリケーションでハンドリングする場合は、`SqlStatementException`を継承したクラスとそのFactoryクラスを追加すること。

### d) 検索結果クラス

| クラス名 | 概要 |
|---|---|
| `ResultSetIterator` | `java.sql.ResultSet`のラッパー。1レコード分のデータを`SqlRow`で取得するインタフェースを提供する |
| `SqlResultSet` | 簡易検索結果を格納する`ArrayList`のサブクラス。SELECT結果をすべてメモリ上に保持する |
| `SqlRow` | `ResultSet`の1レコード分データを格納する`Map`実装クラス。`SqlResultSet`の各要素として格納される |

> **警告**: `SqlResultSet`は検索結果を全件メモリ上に保持するため、大量データ検索時はメモリ不足の原因となる。大量データ検索時は`PreparedStatement`ラッパーの`executeQuery`と`ResultSetIterator`を使用すること。

### e) SQL文のロードクラス

**クラス**: `nablarch.core.db.statement.BasicSqlLoader`

クラスパス上の外部ファイルからSQL文を読み込む。読み込んだSQL文は[../05_StaticDataCache](libraries-05_StaticDataCache.md)によりSQLファイル単位にキャッシュされる（KEY: `SQL_ID`、VALUE: SQL文）。`SQL_ID`はSQLファイル内で一意とする必要がある。

SQLファイル記述ルール:
1. `SQL_ID`とSQL文の1グループは空行で区切る（SQL文中に空行不可、異なるSQL文間には必ず空行を入れる）
2. SQL文の最初の「`=`」までが`SQL_ID`
3. コメントは「`--`」で開始（行コメントのみ、ブロックコメント不可）
4. SQL文の途中改行・スペース/tabによる桁揃え可能

```sql
-- ＸＸＸＸＸ取得SQL
-- SQL_ID:GET_XXXX_INFO
GET_XXXX_INFO =
SELECT
   COL1,
   COL2
FROM
   TEST_TABLE
WHERE
   COL1 = :col1


-- ＸＸＸＸＸ更新SQL
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

`SQL_ID`から`Statement`オブジェクトを生成するサポートクラス。継承してDBアクセスクラスを実装する。

SQLファイル名ルール: 継承クラスの完全修飾名と一致させる。

例: クラス`nablarch.sample.management.user.UserRegisterService` → SQLファイル`nablarch/sample/management/user/UserRegisterService.sql`

> **注意**: 継承できない場合は`DbAccessSupport`を直接インスタンス化する。その際は`DbAccessSupport(Clazz<?> clazz)`コンストラクタを使用すること。デフォルトコンストラクタ使用時は`DbAccessSupport`クラスの完全修飾名でSQLファイルを検索するため注意。

提供メソッド:

| メソッド | 説明 |
|---|---|
| `getSqlPStatement(String sqlId)` | SQL_IDを元に`SqlPStatement`を生成する |
| `getParameterizedSqlStatement(String sqlId)` | SQL_IDを元に`ParameterizedSqlPStatement`を生成する |
| `getParameterizedSqlStatement(String sqlId, Object condition)` | SQL_IDと条件オブジェクトを元に可変条件SQL文を構築して`ParameterizedSqlPStatement`を生成する |
| `countByStatementSql(String sqlId)` | 条件不要のSQL文で件数取得を実行する |
| `countByParameterizedSql(String sqlId, Object condition)` | SQL_IDと条件オブジェクトを元に件数取得を実行する |
| `search(String sqlId, ListSearchInfo condition) throws TooManyResultException` | 件数取得+検索を実行する（:ref:`WebView_ListSearchResult`参照） |

<details>
<summary>keywords</summary>

BasicStatementFactory, BasicSqlPStatement, BasicSqlStatementExceptionFactory, ResultSetIterator, SqlResultSet, SqlRow, BasicSqlLoader, DbAccessSupport, DuplicateStatementException, SqlStatementException, SQL_ID, SQLファイル, クラス定義, TooManyResultException, ListSearchInfo, getParameterizedSqlStatement, countByStatementSql, countByParameterizedSql, search

</details>

## 簡易検索の場合の処理シーケンス

簡易検索の処理シーケンス:

![簡易検索処理シーケンス図](../../../knowledge/component/libraries/assets/libraries-04_Statement/DbAccessSpec_StatementSequence.jpg)

1. `DbAccessSupport#getSqlPStatement(sqlId)`を呼び出し、`SQL_ID`を元に`SqlPStatement`を取得する。
2. `SqlPStatement#setString()`等を呼び出してSQL文の実行前に条件を設定する。
3. `SqlPStatement#retrieve()`を呼び出し、SQL文を実行する。
4. 返却された`SqlResultSet`から検索結果の値を取得する。

<details>
<summary>keywords</summary>

getSqlPStatement, SqlPStatement, retrieve, SqlResultSet, 簡易検索, 処理シーケンス, DbAccessSupport

</details>

## 推奨するJavaの実装例(SQL文を外部ファイル化した場合)

`DbAccessSupport`を継承したDBアクセスクラスのクラス名（完全修飾名）でSQLファイルを作成する。拡張子はデフォルト`.sql`（設定で変更可）。SQL文の記述ルールは[SQL文のロードクラス](#s3)を参照。

クラス名`nablarch.sample.user.UserService` → SQLファイル`nablarch/sample/user/UserService.sql`

```sql
GET_USER_INFO =
SELECT USER_ID,
       NAME,
       TEL,
       AGE
  FROM USER_MTR
 WHERE USER_ID = ?
```

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

DbAccessSupport, UserService, getSqlPStatement, SqlResultSet, SQLファイル外部化, SQL_ID, setObject, 実装例

</details>
