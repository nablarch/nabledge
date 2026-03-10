# データベースアクセス(JDBCラッパー)

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/database.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/dialect/Dialect.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/ResultSetConvertor.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/dialect/DefaultDialect.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/dialect/OracleDialect.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/BasicDbConnectionFactoryForDataSource.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/BasicDbConnectionFactoryForJndi.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/ConnectionFactorySupport.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/BasicStatementFactory.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/BasicSqlLoader.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/DbConnectionContext.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/AppDbConnection.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlPStatement.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlCStatement.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/StatementFactory.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SelectOption.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/java/sql/PreparedStatement.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/java/sql/ResultSet.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/java/sql/SQLException.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/java/sql/Connection.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/javax/sql/DataSource.html) [22](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/ParameterizedSqlPStatement.html) [23](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [24](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/AutoPropertyHandler.html) [25](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlRow.html) [26](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Collection.html) [27](https://nablarch.github.io/docs/LATEST/javadoc/java/sql/Blob.html) [28](https://nablarch.github.io/docs/LATEST/javadoc/java/io/InputStream.html) [29](https://nablarch.github.io/docs/LATEST/javadoc/java/sql/Clob.html) [30](https://nablarch.github.io/docs/LATEST/javadoc/java/io/Reader.html) [31](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/DbAccessException.html) [32](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/exception/DbConnectionException.html) [33](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/exception/SqlStatementException.html) [34](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/exception/DuplicateStatementException.html) [35](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/transaction/SimpleDbTransactionManager.html) [36](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/transaction/SimpleDbTransactionExecutor.html) [37](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/cache/InMemoryResultSetCache.html) [38](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/cache/expirable/BasicExpirationSetting.html) [39](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/cache/statement/CacheableStatementFactory.html) [40](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/cache/ResultSetCache.html) [41](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/TransactionManagerConnection.html) [42](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/sqlloader/SchemaReplacer.html) [43](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/DbAccessExceptionFactory.html) [44](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlStatementExceptionFactory.html)

## 機能概要

> **補足**: SQLの実行には :ref:`universal_dao` を推奨。ただし :ref:`universal_dao` 内部でこの機能のAPIを使用するため、この機能の設定は必須。

> **重要**: JDBC 3.0に依存。使用するJDBCドライバはJDBC 3.0以上を実装している必要がある。

### データベースの方言を意識することなく使用できる

使用するデータベース製品に対応した `Dialect` を設定することで、製品ごとの方言を意識せずにアプリケーションを実装できる。

`Dialect` が提供するメソッド:

- `supportsIdentity()`: identityカラムを使えるか否か
- `supportsIdentityWithBatchInsert()`: identity(自動採番)カラムを持つテーブルへのbatch insertが行えるか否か
- `supportsSequence()`: シーケンスオブジェクトを使えるか否か
- `supportsOffset()`: 検索クエリーの範囲指定でoffset（またはoffsetと同等の機能）を使えるか否か
- `isDuplicateException(java.sql.SQLException)`: 一意制約違反を表す `SQLException` か否かを判定
- `isTransactionTimeoutError(java.sql.SQLException)`: トランザクションタイムアウト対象の `SQLException` か否かを判定
- `buildSequenceGeneratorSql(java.lang.String)`: シーケンスオブジェクトから次の値を取得するSQL文を生成
- `getResultSetConvertor()`: `ResultSet` から値を取得する `ResultSetConvertor` を返す
- `convertPaginationSql(java.lang.String,nablarch.core.db.statement.SelectOption)`: 検索クエリーを範囲指定（ページング用）SQLに変換
- `convertCountSql(java.lang.String)`: 検索クエリーを件数取得SQLに変換
- `convertCountSql(java.lang.String,java.lang.Object,nablarch.core.db.statement.StatementFactory)`: SQLIDを件数取得SQLに変換
- `getPingSql()`: `Connection` がDBに接続されているかチェックするSQLを返す

### SQLはロジックではなくSQLファイルに記述する

SQLはSQLファイルに定義し、原則ロジック内には記述しない。必ず `PreparedStatement` を使用するため、SQLインジェクションの脆弱性が排除できる。

> **補足**: どうしてもSQLファイルに定義できない場合は、SQLを直接指定して実行するAPIも提供している。ただし、安易に使用するとSQLインジェクションの脆弱性が埋め込まれる可能性があるため注意すること。SQLインジェクションの脆弱性がないことをテストやレビューで担保することが前提となる。

### BeanのプロパティをSQLのバインド変数に埋め込む

Beanのプロパティに設定した値を `PreparedStatement` のINパラメータに自動的にバインドする。`PreparedStatement`の値設定用メソッドを複数回呼び出す必要がなくなり、INパラメータが増減した際のインデクス修正なども不要となる。

### like検索の自動エスケープ

like検索に対するescape句の挿入とワイルドカード文字のエスケープ処理を自動で行う。

### SQL文の動的構築

Beanオブジェクトの状態を元に、実行するSQL文を動的に組み立てる。条件やin句の動的な構築が行える。

### SQLクエリ結果のキャッシュ

実行したSQLと外部から取得した条件（バインド変数に設定した値）が等価である場合に、DBにアクセスせずキャッシュから検索結果を返す。

<details>
<summary>keywords</summary>

Dialect, nablarch.core.db.dialect.Dialect, ResultSetConvertor, nablarch.core.db.statement.ResultSetConvertor, StatementFactory, nablarch.core.db.statement.StatementFactory, SelectOption, nablarch.core.db.statement.SelectOption, SQLException, PreparedStatement, データベース方言, SQLファイル管理, Beanバインド, like検索エスケープ, SQL動的構築, SQLキャッシュ

</details>

## モジュール一覧

**モジュール**:

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core-jdbc, com.nablarch.framework, Mavenモジュール, JDBC依存関係

</details>

## データベースに対する接続設定

データベース接続設定は以下の2通りから選択:

1. `DataSource` を使ったデータベース接続: **クラス**: `nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource`
2. アプリケーションサーバのデータソース(JNDI)を使ったデータベース接続: **クラス**: `nablarch.core.db.connection.BasicDbConnectionFactoryForJndi`

```xml
<!-- DataSourceからの接続 -->
<component class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
  <!-- 設定値の詳細はJavadocを参照すること -->
</component>

<!-- JNDIからの接続 -->
<component class="nablarch.core.db.connection.BasicDbConnectionFactoryForJndi">
  <!-- 設定値の詳細はJavadocを参照すること -->
</component>
```

上記以外の接続方法を使用したい場合（例: OSSのコネクションプーリングライブラリ）は :ref:`database-add_connection_factory` を参照し実装を追加すること。

> **補足**: 上記クラスを直接使用することは基本的にない。データベースアクセスを必要とする場合には :ref:`database_connection_management_handler` を使用すること。データベースを使用する場合はトランザクション管理も必要。トランザクション管理については :ref:`transaction` を参照。

<details>
<summary>keywords</summary>

BasicDbConnectionFactoryForDataSource, nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource, BasicDbConnectionFactoryForJndi, nablarch.core.db.connection.BasicDbConnectionFactoryForJndi, DataSource, javax.sql.DataSource, データベース接続設定, JNDI, コネクション設定

</details>

## データベース製品に対応したダイアレクトを使用する

データベース製品に対応したダイアレクトをコンポーネント設定ファイルに設定することで、ダイアレクト機能が有効になる。

> **補足**: 設定しなかった場合は `DefaultDialect` が使用される。`DefaultDialect`は原則全ての機能が無効化されるため、必ずデータベース製品に対応したダイアレクトを設定すること。使用するDBに対応するダイアレクトが存在しない場合や新機能を使いたい場合は :ref:`database-add_dialect` を参照し新しいダイアレクトを作成すること。

`BasicDbConnectionFactoryForDataSource` および `BasicDbConnectionFactoryForJndi` ともに `dialect` プロパティにダイアレクトを設定する。

設定例（Oracleデータベースの場合）:

```xml
<component class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
  <property name="dialect">
    <component class="nablarch.core.db.dialect.OracleDialect" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

DefaultDialect, nablarch.core.db.dialect.DefaultDialect, OracleDialect, nablarch.core.db.dialect.OracleDialect, ダイアレクト設定, データベース方言設定, dialect

</details>

## SQLをファイルで管理する

SQLファイルの作成ルール:

- クラスパス配下に作成する
- 1つのSQLファイルに複数のSQLを記述できるが、SQLIDはファイル内で一意とする
- SQLIDとSQLIDとの間には空行を挿入する（スペースが存在する行は空行とはみなさない）
- SQLIDとSQLとの間には `=` を入れる
- コメントは `--` で記述する（ブロックコメントはサポートしない）
- SQLは改行やスペース(tab)などで整形してもよい

> **重要**: SQLを複数機能で流用せずに、必ず機能毎に作成すること。複数機能で流用した場合、意図しない使われ方やSQLの変更により思わぬ不具合が発生する。例: 複数機能で使用していたSQL文に排他ロック用の `for update` が追加された場合、排他ロックが不要な機能でもロックが取得され処理遅延の原因となる。

SQLファイル例:

```sql
-- ＸＸＸＸＸ取得SQL
-- SQL_ID:GET_XXXX_INFO
GET_XXXX_INFO =
select
   col1,
   col2
from
   test_table
where
   col1 = :col1


-- ＸＸＸＸＸ更新SQL
-- SQL_ID:UPDATE_XXXX
update_xxxx =
update
    test_table
set
    col2 = :col2
where
    col1 = :col1
```

### SQLファイルからSQLをロードするための設定

`BasicStatementFactory` の `sqlLoader` プロパティに `BasicSqlLoader` を設定する。省略した場合のデフォルト値: ファイルエンコーディング=`utf-8`、拡張子=`sql`。

ここで定義した `BasicStatementFactory` コンポーネントは、 :ref:`database-connect` で定義したデータベース接続取得コンポーネントに設定する必要がある。

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
  <property name="sqlLoader">
    <component class="nablarch.core.db.statement.BasicSqlLoader">
      <property name="fileEncoding" value="utf-8"/>
      <property name="extension" value="sql"/>
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

BasicStatementFactory, nablarch.core.db.statement.BasicStatementFactory, BasicSqlLoader, nablarch.core.db.statement.BasicSqlLoader, SQLID, SQLファイル, SQLロード設定, fileEncoding, extension, sqlLoader

</details>

## SQLIDを指定してSQLを実行する

`DbConnectionContext` から取得したデータベース接続を使用してSQLを実行する。 :ref:`database_connection_management_handler` でデータベース接続を登録する必要がある。

SQLIDと実行SQLのマッピングルール:

- SQLIDの `#` までがSQLファイル名（クラスパス配下）
- SQLIDの `#` 以降がSQLファイル内のSQLID

例: SQLIDが `jp.co.tis.sample.action.SampleAction#findUser` の場合、SQLファイルは `jp.co.tis.sample.action.SampleAction.sql`、SQLファイル内のSQLIDは `findUser`。

```java
// DbConnectionContextからデータベース接続を取得する。
AppDbConnection connection = DbConnectionContext.getConnection();

// SQLIDを元にステートメントを生成する。
SqlPStatement statement = connection.prepareStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#findUser");

// 条件を設定する。
statement.setLong(1, userId);

// 検索処理を実行する。
SqlResultSet result = statement.retrieve();
```

<details>
<summary>keywords</summary>

DbConnectionContext, nablarch.core.db.connection.DbConnectionContext, AppDbConnection, nablarch.core.db.connection.AppDbConnection, SqlPStatement, nablarch.core.db.statement.SqlPStatement, SqlResultSet, SQLID指定, SQL実行, prepareStatementBySqlId

</details>

## ストアードプロシージャを実行する

ストアードプロシージャの実行も基本的にはSQLを実行する場合と同じように実装する。

> **重要**: ストアードプロシージャの実行では :ref:`database-bean` はサポートしない。ストアードプロシージャを使用した場合、ロジックがJavaとストアードプロシージャに分散してしまい保守性を著しく低下させるため、原則使用すべきではない。

```java
// SQLIDを元にストアードプロシージャ実行用のステートメントを生成する。
SqlCStatement statement = connection.prepareCallBySqlId(
    "jp.co.tis.sample.action.SampleAction#execute_sp");

// IN及びOUTパラメータを設定する。
statement.registerOutParameter(1, Types.CHAR);

// 実行する。
statement.execute();

// OUTパラメータを取得する。
String result = statement.getString(1);
```

<details>
<summary>keywords</summary>

SqlCStatement, nablarch.core.db.statement.SqlCStatement, Types, java.sql.Types, ストアードプロシージャ, OUTパラメータ, prepareCallBySqlId, registerOutParameter

</details>

## 検索範囲を指定してSQLを実行する

検索結果の範囲を指定して実行する。

```java
// DbConnectionContextからデータベース接続を取得する
AppDbConnection connection = DbConnectionContext.getConnection();

// SQLIDと検索範囲を指定してステートメントオブジェクトを生成する。
// この例では開始位置=11、取得件数=10（11件目から最大10件のレコードを取得）。
SqlPStatement statement = connection.prepareStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#findUser", new SelectOption(11, 10));

// 検索処理を実行する
SqlResultSet result = statement.retrieve();
```

> **補足**: 検索範囲が指定された場合、検索用のSQLを取得範囲指定のSQLに書き換えてから実行する。取得範囲指定のSQLへの書き換えは :ref:`database-dialect` により行われる。

<details>
<summary>keywords</summary>

SelectOption, nablarch.core.db.statement.SelectOption, AppDbConnection, SqlPStatement, SqlResultSet, ページング, 検索範囲指定, prepareStatementBySqlId

</details>

## Beanオブジェクトを入力としてSQLを実行する

Beanオブジェクトを入力としてSQLを実行する場合、INパラメータには名前付きバインド変数を使用する。名前付きパラメータは`:`に続けてBeanのプロパティ名を記述する（例: `:id`、`:userName`）。

> **重要**: INパラメータをJDBC標準の`?`で記述した場合、Beanオブジェクトを入力としたSQLの実行は動作しない。

**クラス**: `AppDbConnection`, `ParameterizedSqlPStatement`

**SQL例**:
```sql
insert into user (id, name) values (:id, :userName)
```

**実装例**:
```java
UserEntity entity = new UserEntity();
entity.setId(1);
entity.setUserName("なまえ");
AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#insertUser");
int result = statement.executeUpdateByObject(entity);
```

> **補足**: Beanの代わりに`Map`の実装クラスも指定できる。Mapのキー値と一致するINパラメータに値が設定される。Beanを指定した場合は`BeanUtil`でMapに変換後に処理される。BeanUtilで対応していない型がBeanプロパティに存在した場合、そのプロパティはこの機能で使用できない。型を増やす場合は:ref:`utility-conversion`を参照。

> **補足**: Beanへのアクセス方法をフィールドアクセスに変更できるが推奨しない。変更する場合はpropertiesファイルに`nablarch.dbAccess.isFieldAccess=true`を設定する。推奨しない理由: フレームワークの他機能（`BeanUtil`など）はプロパティアクセスで統一されており、フィールドアクセスに変更するとプログラマがアクセス方法の使い分けを意識する必要が生じ、生産性低下や不具合の原因となる。

<details>
<summary>keywords</summary>

AppDbConnection, ParameterizedSqlPStatement, BeanUtil, DbConnectionContext, Beanオブジェクト入力, 名前付きバインド変数, MapによるSQL入力, フィールドアクセス設定, executeUpdateByObject

</details>

## 型を変換する

データベースアクセス（JDBCラッパー）は、データベースとの入出力に使用する変数の型変換をJDBCドライバに委譲する。入出力変数の型はデータベースの型および使用するJDBCドライバの仕様に応じて定義する必要がある。

任意の型変換が必要な場合はアプリケーション側で型変換する:
- 入力にBeanを使用する場合: Beanのプロパティに値を設定する際に型変換する
- 出力にBeanを使用する場合: プロパティから値を取り出した後に型変換する
- 入力にMapを使用する場合: Mapに値を設定する際に型変換する
- 出力にMapを使用する場合: Mapから値を取り出した後に型変換する
- インデックスを指定してバインド変数を設定する際: バインド変数に設定するオブジェクトを適切な型に変換する。`SqlRow`から値を取得する際は取得後に型変換する。

<details>
<summary>keywords</summary>

SqlRow, 型変換, JDBCドライバ型変換, データベース入出力型変換

</details>

## SQL実行時に共通的な値を自動的に設定したい

この機能は:ref:`database-input_bean`を使用した場合のみ有効。プロパティに設定されたアノテーションを元に、SQL実行直前に値を自動設定する。値を明示的に設定しても、SQL実行直前に自動設定機能により上書きされる。

**コンポーネント設定**: `BasicStatementFactory`の`updatePreHookObjectHandlerList`プロパティに`AutoPropertyHandler`実装クラスをlistで設定する。標準実装クラスは`nablarch.core.db.statement.autoproperty`パッケージに配置されている。定義した`BasicStatementFactory`コンポーネントは:ref:`database-connect`で定義したデータベース接続コンポーネントに設定すること。

```xml
<component name="statementFactory"
    class="nablarch.core.db.statement.BasicStatementFactory">
  <property name="updatePreHookObjectHandlerList">
    <list>
      <!-- nablarch.core.db.statement.AutoPropertyHandler実装クラスをlistで設定する-->
    </list>
  </property>
</component>
```

**Beanオブジェクト**: 自動設定したいプロパティにアノテーションを設定する。標準アノテーションは`nablarch.core.db.statement.autoproperty`パッケージに配置されている。

```java
public class UserEntity {
  private String id;

  @CurrentDateTime
  private Timestamp createdAt; // 登録時に自動設定

  @CurrentDateTime
  private String updatedAt;    // 登録・更新時に自動設定
}
```

**SQL例**:
```sql
insert into user (id, createdAt, updatedAt) values (:id, :createdAt, :updatedAt)
```

**実装例**: 自動設定項目（`createdAt`、`updatedAt`）にはBeanへの値設定が不要。

```java
UserEntity entity = new UserEntity();
entity.setId(1);
AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#insertUser");
int result = statement.executeUpdateByObject(entity);
```

<details>
<summary>keywords</summary>

AppDbConnection, ParameterizedSqlPStatement, AutoPropertyHandler, BasicStatementFactory, DbConnectionContext, CurrentDateTime, updatePreHookObjectHandlerList, 自動値設定, 登録日時自動設定, 更新日時自動設定

</details>

## like検索を行う

:ref:`database-input_bean`を使用し、SQLに以下のルールでlike条件を記述する。

- 前方一致: 名前付きパラメータの末尾に`%`を記述。例: `name like :userName%`
- 後方一致: 名前付きパラメータの先頭に`%`を記述。例: `name like :%userName`
- 途中一致: 名前付きパラメータの前後に`%`を記述。例: `name like :%userName%`

like検索時のエスケープ文字・エスケープ対象文字の定義は:ref:`database-def_escape_char`を参照。

SQLを実行するだけで、like条件用の値の書き換えおよびエスケープ処理が自動的に行われる。

**SQL例**:
```sql
select * from user where name like :userName%
```

**実装例**: `userName`に「な」を設定した場合、実際の条件は`name like 'な%' escape '\\'`となる。

```java
UserEntity entity = new UserEntity();
entity.setUserName("な");
AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#findUserByName");
int result = statement.retrieve(bean);
```

<details>
<summary>keywords</summary>

AppDbConnection, ParameterizedSqlPStatement, DbConnectionContext, like検索, 前方一致, 後方一致, 途中一致, あいまい検索, エスケープ自動処理

</details>

## like検索時のエスケープ文字及びエスケープ対象文字を定義する

エスケープ文字およびエスケープ対象文字はコンポーネント設定ファイルで定義する。エスケープ文字は自動的にエスケープ対象となるため、明示的にエスケープ対象文字に設定する必要はない。

設定省略時のデフォルト値:
- エスケープ文字: `\`
- エスケープ対象文字: `%`、`_`

定義した`BasicStatementFactory`コンポーネントは:ref:`database-connect`で定義したデータベース接続コンポーネントに設定すること。

**コンポーネント設定例**（エスケープ文字`\`、エスケープ対象`%`、`％`、`_`、`＿`）:

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
  <property name="likeEscapeChar" value="\" />
  <property name="likeEscapeTargetCharList" value="%,％,_,＿" />
</component>
```

<details>
<summary>keywords</summary>

BasicStatementFactory, likeEscapeChar, likeEscapeTargetCharList, エスケープ文字定義, like検索エスケープ設定

</details>

## 可変条件を持つSQLを実行する

:ref:`database-input_bean`を使用し、`$if(プロパティ名) {SQL文の条件}`の記法で可変条件を記述する。

プロパティ値が以下の場合に条件が除外される:
- 配列または`java.util.Collection`の場合: プロパティ値がnullまたはサイズ0
- 上記以外の型の場合: プロパティ値がnullまたは空文字列（Stringの場合）

**制約**:
- 使用できる箇所はwhere句のみ
- `$if`内に`$if`を使用できない

> **重要**: この機能はユーザ入力によって検索条件が変わる場合に使うものであり、条件だけが異なる複数のSQLを共通化するために使用するものではない。安易に共通化した場合、SQL変更時に思わぬ不具合を埋め込む原因となるため、条件が異なるSQLは複数定義すること。

**SQL例**:
```sql
select user_id, user_name, user_kbn
from user
where
  $if (userName) {user_name like :userName%}
  and $if (userKbn) {user_kbn in ('1', '2')}
  and birthday = :birthday
```

**実装例**: `userName`プロパティのみに値が設定されているため、`user_kbn`条件は除外される。

```java
UserEntity entity = new UserEntity();
entity.setUserName("なまえ");
AppDbConnection connection = DbConnectionContext.getConnection();
// 2番めの引数にBeanを指定することで可変条件の組み立てが行われる
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#insertUser", entity);
SqlResultSet result = statement.retrieve(entity);
```

<details>
<summary>keywords</summary>

AppDbConnection, DbConnectionContext, $if構文, 可変条件SQL, 動的WHERE句, 検索条件動的組み立て, ParameterizedSqlPStatement, SqlResultSet

</details>

## in句の条件数が可変となるSQLを実行する

:ref:`database-input_bean` を使用し、名前付きパラメータの末尾に `[]` を付加することでin句の条件数が可変なSQLを実行できる。

**in句の記述ルール**:
- 名前付きパラメータの末尾に `[]` を付加する
- Beanプロパティの型は配列か `java.util.Collection` (サブタイプ含む)

> **補足**: in句の条件プロパティ値がnullやサイズ0の場合は必ず可変条件として定義すること。可変条件でない場合にnullになると `xxxx in (null)` となり、検索結果が正しく取れない可能性がある。in句はカッコを空にできないため、サイズ0の配列やnullが指定された場合は `in (null)` となる。

**SQL例**（`$if`と併用のため`userKbn`がnullやサイズ0の場合は条件から除外される）:
```sql
select
  user_id,
  user_name,
  user_kbn
from
  user
where
  $if (userKbn) {user_kbn in (:userKbn[])}
```

**Java実装例**（`userKbn`に`"1"`, `"3"`を設定した場合、`user_kbn in (?, ?)`が実行される）:
```java
UserSearchCondition condition = new UserSearchCondition();
condition.setUserKbn(Arrays.asList("1", "3"));

AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#searchUser", condition);
SqlResultSet result = statement.retrieve(condition);
```

> **注意**: `BeanUtil` でサポートされていない型でプロパティを宣言した場合、in句に条件を設定できない。型を追加する方法は :ref:`utility-conversion-add-rule` を参照。

<details>
<summary>keywords</summary>

ParameterizedSqlPStatement, BeanUtil, java.util.Collection, in句, 可変条件, 動的SQL, 配列, userKbn[]

</details>

## order byのソート項目を実行時に動的に切り替えてSQLを実行する

:ref:`database-input_bean` を使用し、`$sort`構文でorder by句のソート項目を動的に切り替える。

**$sort構文**:
```text
$sort(プロパティ名) {(ケース1)(ケース2)・・・(ケースn)}
```

- `プロパティ名`: BeanオブジェクトでソートIDを保持するプロパティ名
- 各ケースは半角丸括弧で囲み、ソートIDとケース本体を半角スペースで区切る
- ソートIDに半角スペースは使用不可、ケース本体には半角スペースを使用可
- どの候補にも一致しない場合のデフォルトケースにはソートIDに `"default"` を指定する
- 括弧開き以降で最初に登場する文字列をソートID、ソートID以降で括弧閉じまでをケース本体とし、それぞれトリミングされる

**SQL例**:
```sql
select
  user_id,
  user_name
from
  user
where
  user_name = :userName
$sort(sortId) {
  (user_id_asc  user_id asc)
  (user_id_desc user_id desc)
  (name_asc     user_name asc)
  (name_desc    user_name desc)
  (default      user_id)
}
```

**Java実装例**（`sortId`に`"name_asc"`を設定した場合、`order by user_name asc`となる）:
```java
UserSearchCondition condition = new UserSearchCondition();
condition.setUserName("なまえ");
condition.setSortId("name_asc");

AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#searchUser", condition);
SqlResultSet result = statement.retrieve(condition);
```

<details>
<summary>keywords</summary>

ParameterizedSqlPStatement, $sort, order by, 動的ソート, ソートID, sortId

</details>

## バイナリ型のカラムにアクセスする

**バイナリ型の値を取得する**:
`SqlRow` から `byte[]` として取得する。

```java
byte[] encryptedPassword = row.getBytes("password");
```

> **重要**: 上記実装ではカラム内容が全てヒープに展開される。非常に大きいデータを読み込んだ場合はヒープ領域を圧迫しシステムダウンなどの障害の原因となる。大量データを読み込む場合は `Blob` オブジェクトを使用してストリームで処理すること。
>
> ```java
> Blob pdf = (Blob) rows.get(0).get("PDF");
> try (InputStream input = pdf.getBinaryStream()) {
>     // InputStreamからデータを順次読み込み処理を行う
> }
> ```

**バイナリ型の値を登録・更新する**:
- サイズが小さい場合: `SqlPStatement#setBytes` を使用
  ```java
  statement.setBytes(1, new byte[] {0x30, 0x31, 0x32});
  statement.executeUpdate();
  ```
- サイズが大きい場合: `SqlPStatement#setBinaryStream` を使用して `InputStream` から直接データベースに送信
  ```java
  final Path pdf = Paths.get("input.pdf");
  try (InputStream input = Files.newInputStream(pdf)) {
      statement.setBinaryStream(1, input, (int) Files.size(pdf));
  }
  ```

<details>
<summary>keywords</summary>

SqlRow, Blob, InputStream, SqlPStatement, バイナリ型, BLOB, setBinaryStream, setBytes, getBytes

</details>

## 桁数の大きい文字列型のカラム(例えばCLOB)にアクセスする

**CLOB型の値を取得する**:
`SqlRow` から文字列型として取得する。

```java
String mailBody = row.getString("mailBody");
```

> **重要**: 上記実装ではカラム内容が全てヒープに展開される。非常に大きいデータを読み込んだ場合はヒープ領域を圧迫しシステムダウンなどの障害の原因となる。大量データを読み込む場合は `Clob` オブジェクトを使用してストリームで処理すること。
>
> ```java
> Clob mailBody = (Clob) rows.get(0).get("mailBody");
> try (Reader reader = mailBody.getCharacterStream()) {
>     // Readerからデータを順次読み込む（読み込んだデータを全てヒープ上に保持しないこと）
> }
> ```

**CLOB型に値を登録・更新する**:
- サイズが小さい場合: `SqlPStatement#setString` を使用
  ```java
  statement.setString(1, "値");
  statement.executeUpdate();
  ```
- サイズが大きい場合: `SqlPStatement#setCharacterStream` を使用して `Reader` 経由でデータベースに送信
  ```java
  Path path = Paths.get(filePath);
  try (Reader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
      statement.setCharacterStream(1, reader, (int) Files.size(path));
  }
  ```

<details>
<summary>keywords</summary>

SqlRow, Clob, Reader, SqlPStatement, CLOB, 大容量文字列, setCharacterStream, setString, getString

</details>

## データベースアクセス時に発生する例外の種類

データベースアクセス時の例外は全て非チェック例外のため、`SQLException` のように `try-catch` で補足する必要はない。

| 例外クラス | 発生条件 | 備考 |
|---|---|---|
| `DbAccessException` | データベースアクセスエラー全般 | |
| `DbConnectionException` | データベース接続エラー | :ref:`retry_handler` により処理される。ハンドラ未適用時は実行時例外として扱われる。接続エラー判定に :ref:`ダイアレクト <database-dialect>` を使用。 |
| `SqlStatementException` | SQL実行失敗 | |
| `DuplicateStatementException` | SQL実行時の一意制約違反 | ハンドリング方法は :ref:`database-duplicated_error` 参照。一意制約違反判定に :ref:`ダイアレクト <database-dialect>` を使用。 |

> **補足**: データベースアクセスエラー発生時の例外を変更したい場合（より細かく分けたい場合）などは、:ref:`database-change_exception` を参照すること。

<details>
<summary>keywords</summary>

DbAccessException, DbConnectionException, SqlStatementException, DuplicateStatementException, SQLException, 非チェック例外, 接続エラー, 一意制約違反, database-change_exception, 例外カスタマイズ

</details>

## 一意制約違反をハンドリングして処理を行う

`DuplicateStatementException` を `try-catch` で補足して処理する。一意制約違反の判定には :ref:`ダイアレクト <database-dialect>` が使用される。

> **重要**: データベース製品によってはSQL実行時に例外が発生した場合、ロールバックを行うまで一切のSQLを受け付けないものがある。このような製品では他の手段で代用できないか検討すること。例えば、登録処理で一意制約違反が発生した場合に更新処理をしたい場合は、例外ハンドリングを行うのではなく `merge` 文を使用することでこの問題を回避できる。

<details>
<summary>keywords</summary>

DuplicateStatementException, 一意制約違反, try-catch, merge文, ロールバック

</details>

## 処理が長いトランザクションはエラーとして処理を中断させる

処理が長いトランザクションのエラー処理はトランザクション管理にて実現する。詳細は :ref:`transaction-timeout` を参照。

<details>
<summary>keywords</summary>

トランザクションタイムアウト, 長時間トランザクション, タイムアウト, エラー中断

</details>

## 現在のトランザクションとは異なるトランザクションでSQLを実行する

個別のトランザクションを使用してデータベースアクセスするには、`SimpleDbTransactionManager` を使用する（例: 業務処理が失敗した場合でも必ずデータベースへの変更を確定したい場合）。

**手順**:
1. コンポーネント設定ファイルに `SimpleDbTransactionManager` を定義する
2. `SimpleDbTransactionManager` をシステムリポジトリから取得するか、またはDIで直接注入して使用する。`SimpleDbTransactionExecutor` を使用してSQLを実行すること（`SimpleDbTransactionManager` を直接使わないこと）

| プロパティ名 | 型 | 説明 |
|---|---|---|
| connectionFactory | ConnectionFactory | 詳細は :ref:`database-connect` 参照 |
| transactionFactory | TransactionFactory | 詳細は :ref:`transaction-database` 参照 |
| dbTransactionName | String | トランザクションを識別するための名前 |

**コンポーネント設定例**:
```xml
<component name="update-login-failed-count-transaction" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
  <property name="connectionFactory" ref="connectionFactory" />
  <property name="transactionFactory" ref="transactionFactory" />
  <property name="dbTransactionName" value="update-login-failed-count-transaction" />
</component>
```

**Java実装例**（システムリポジトリから取得する場合）:
```java
SimpleDbTransactionManager dbTransactionManager =
    SystemRepository.get("update-login-failed-count-transaction");

SqlResultSet resultSet = new SimpleDbTransactionExecutor<SqlResultSet>(dbTransactionManager) {
  @Override
  public SqlResultSet execute(AppDbConnection connection) {
    SqlPStatement statement = connection.prepareStatementBySqlId(
        "jp.co.tis.sample.action.SampleAction#findUser");
    statement.setLong(1, userId);
    return statement.retrieve();
  }
}.doTransaction();
```

<details>
<summary>keywords</summary>

SimpleDbTransactionManager, SimpleDbTransactionExecutor, ConnectionFactory, TransactionFactory, SystemRepository, 個別トランザクション, 新規トランザクション, トランザクション分離

</details>

## 検索結果をキャッシュする

更新時間が決まっているデータや、頻繁にアクセスされるが必ず最新のデータを返す必要がない場合に、検索結果をキャッシュしてDB負荷を軽減できる。

**制約**:

- **LOB型**: LOB(BLOB/CLOB)カラムを取得するとLOBロケータが取得される。LOBロケータの有効期間はRDBMS依存で、通常 `ResultSet` や `Connection` クローズ時にアクセス不可になる。このためキャッシュにBLOB/CLOBは含められない。
- **冗長化**: デフォルトのキャッシュコンポーネントはJVMヒープにキャッシュを保持するため、冗長化構成では各APサーバが独自のキャッシュを持つ。ラウンドロビンのロードバランサを使用する場合、リクエストごとに異なる結果が返る可能性がある。

> **重要**: この機能は参照系DBアクセスの省略によるシステム負荷軽減が目的であり、SQLの高速化を目的として使用してはならない。SQL高速化にはSQLチューニングを実施すること。

> **重要**: DB値の更新を監視してキャッシュを最新化する機能はない。常に最新データを表示する必要がある機能では使用しないこと。

**コンポーネント設定手順**:

1. クエリ結果キャッシュコンポーネントの定義
2. SQLID毎のキャッシュ有効期限設定
3. キャッシュ可能なSQL実行コンポーネントの定義

**クラス**: `InMemoryResultSetCache`

| プロパティ名 | 説明 |
|---|---|
| cacheSize | キャッシュサイズ |
| systemTimeProvider | システム時刻プロバイダ |

```xml
<component name="resultSetCache" class="nablarch.core.db.cache.InMemoryResultSetCache">
  <property name="cacheSize" value="100"/>
  <property name="systemTimeProvider" ref="systemTimeProvider"/>
</component>
```

**クラス**: `BasicExpirationSetting`

SQLID毎にキャッシュ有効期限を設定する。有効期限単位: `ms`（ミリ秒）, `sec`（秒）, `min`（分）, `h`（時）

```xml
<component name="expirationSetting"
    class="nablarch.core.cache.expirable.BasicExpirationSetting">
  <property name="expiration">
    <map>
      <entry key="please.change.me.tutorial.ss11AA.W11AA01Action#SELECT" value="100ms"/>
      <entry key="please.change.me.tutorial.ss11AA.W11AA02Action#SELECT" value="30sec"/>
    </map>
  </property>
</component>
```

**クラス**: `CacheableStatementFactory`（`BasicStatementFactory` を継承）

`expirationSetting` プロパティと `resultSetCache` プロパティを設定し、:ref:`database-connect` で定義したDB接続コンポーネントに設定すること。

```xml
<component name="cacheableStatementFactory"
           class="nablarch.core.db.cache.CacheableStatementFactory">
  <property name="expirationSetting" ref="expirationSetting"/>
  <property name="resultSetCache" ref="resultSetCache"/>
</component>
```

SQLを使ったDBアクセスの実装はキャッシュ有無によって変わらない（:ref:`database-execute_sqlid`、:ref:`database-input_bean` を参照）。

<details>
<summary>keywords</summary>

InMemoryResultSetCache, BasicExpirationSetting, CacheableStatementFactory, BasicStatementFactory, ResultSetCache, 検索結果キャッシュ, キャッシュ有効期限, SQLID毎キャッシュ, LOB型制約, 冗長化キャッシュ, cacheSize, systemTimeProvider, expiration

</details>

## `java.sql.Connection` を使って処理を行う

`DbConnectionContext` から取得した `TransactionManagerConnection` から `java.sql.Connection` を取得できる。

```java
TransactionManagerConnection managerConnection = DbConnectionContext.getTransactionManagerConnection();
Connection connection = managerConnection.getConnection();
return connection.getMetaData();
```

> **重要**: `java.sql.Connection` を使用した場合、チェック例外 `java.sql.SQLException` をハンドリングする必要がある。実装を誤ると障害が検知されない、または障害時の調査ができない問題が発生する。どうしても `java.sql.Connection` を使わないと満たせない要件がない限り、この機能は使用しないこと。

<details>
<summary>keywords</summary>

DbConnectionContext, TransactionManagerConnection, java.sql.Connection, java.sql.SQLException, JDBCネイティブ接続, DatabaseMetaData

</details>

## SQL文中のスキーマを環境毎に切り替える

環境によって参照スキーマ名が異なる場合、SQL文にスキーマ名を明示的に記述できない（例: 本番では `A_SCHEMA`、テストでは `B_SCHEMA`）。そのような場合にSQL文中のスキーマを環境毎に切り替える機能を使用する。

SQL文にプレースホルダー `#SCHEMA#`（固定文字列）を記載する:

```sql
SELECT * FROM #SCHEMA#.TABLE1
```

`BasicSqlLoader` に `SchemaReplacer` を設定してプレースホルダーを置き換える。`BasicStatementFactory` の `sqlLoader` プロパティに設定する:

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
  <property name="sqlLoader">
    <component name="sqlLoader" class="nablarch.core.db.statement.BasicSqlLoader">
      <property name="sqlLoaderCallback">
        <list>
          <component class="nablarch.core.db.statement.sqlloader.SchemaReplacer">
            <property name="schemaName" value="${nablarch.schemaReplacer.schemaName}"/>
          </component>
        </list>
      </property>
    </component>
  </property>
</component>
```

`SchemaReplacer` の `schemaName` プロパティで置換値を設定する。環境依存値（例: `nablarch.schemaReplacer.schemaName`）を使って環境毎に切り替える（:ref:`how_to_switch_env_values` 参照）。

> **補足**: スキーマ置き換えは単純な文字列置換処理であり、スキーマの存在チェックや置き換え後SQLの妥当性チェックは行われない（SQL実行時にエラーとなる）。

<details>
<summary>keywords</summary>

BasicSqlLoader, SchemaReplacer, BasicStatementFactory, #SCHEMA#, スキーマ切替, 環境依存値, スキーマプレースホルダー, schemaName, sqlLoaderCallback, sqlLoader

</details>

## 拡張例

## データベースへの接続法を追加する

OSSのコネクションプールライブラリを使用する場合などに接続方法を追加できる。

1. `ConnectionFactorySupport` を継承し、DB接続を生成するクラスを作成する。
2. 作成したクラスをコンポーネント設定ファイルに設定する（:ref:`database-connect` 参照）。

## ダイアレクトを追加する

使用するDB製品に対応したダイアレクトがない場合や、特定機能の使用可否を切り替えたい場合にダイアレクトを追加する。

1. `DefaultDialect` を継承し、DB製品に対応したダイアレクトを作成する。
2. 作成したダイアレクトをコンポーネント設定ファイルに設定する（:ref:`database-use_dialect` 参照）。

## データベースアクセス時の例外クラスを切り替える

デッドロックエラーの例外クラスを変更したい場合などに例外クラスを切り替えられる。

1. `DbAccessExceptionFactory` の実装クラスを作成する（DB接続取得時・トランザクション制御時の `DbAccessException` を変更する場合）。
2. `SqlStatementExceptionFactory` の実装クラスを作成する（SQL実行時の `SqlStatementException` を変更する場合）。
3. 作成したクラスをコンポーネント設定ファイルに定義する。

`DbAccessExceptionFactory` 実装クラスは :ref:`database-connect` で定義したDB接続コンポーネントに設定する:

```xml
<component class="sample.SampleDbAccessExceptionFactory" />
```

`SqlStatementExceptionFactory` 実装クラスは `BasicStatementFactory` に設定する（`BasicStatementFactory` は :ref:`database-connect` で定義したDB接続コンポーネントに設定すること）:

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
  <property name="sqlStatementExceptionFactory">
    <component class="sample.SampleStatementExceptionFactory" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

ConnectionFactorySupport, DefaultDialect, DbAccessExceptionFactory, SqlStatementExceptionFactory, DbAccessException, SqlStatementException, BasicStatementFactory, 接続方法追加, ダイアレクト追加, 例外クラス切替, sqlStatementExceptionFactory

</details>
