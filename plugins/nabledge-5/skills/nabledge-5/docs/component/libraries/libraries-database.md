# データベースアクセス(JDBCラッパー)

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/database.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/dialect/Dialect.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/ResultSetConvertor.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/BasicDbConnectionFactoryForDataSource.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/BasicDbConnectionFactoryForJndi.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/ConnectionFactorySupport.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/dialect/DefaultDialect.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/BasicStatementFactory.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/BasicSqlLoader.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/DbConnectionContext.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/AppDbConnection.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlPStatement.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlCStatement.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/ParameterizedSqlPStatement.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlRow.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/AutoPropertyHandler.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/DbAccessException.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/exception/DbConnectionException.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/exception/SqlStatementException.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/exception/DuplicateStatementException.html) [22](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/transaction/SimpleDbTransactionManager.html) [23](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/transaction/SimpleDbTransactionExecutor.html) [24](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/ConnectionFactory.html) [25](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/TransactionFactory.html) [26](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/cache/InMemoryResultSetCache.html) [27](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/cache/expirable/BasicExpirationSetting.html) [28](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/cache/statement/CacheableStatementFactory.html) [29](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/TransactionManagerConnection.html) [30](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/sqlloader/SchemaReplacer.html) [31](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/DbAccessExceptionFactory.html) [32](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlStatementExceptionFactory.html)

## 機能概要

JDBC経由でDBに対してSQL文を実行する機能。

> **補足**: SQLの実行には [universal_dao](libraries-universal_dao.md) の使用を推奨する。本機能のAPIは [universal_dao](libraries-universal_dao.md) 内部で使用されるため、本機能の設定は必ず必要。

> **重要**: JDBC 3.0に依存。使用するJDBCドライバはJDBC 3.0以上の実装が必要。

## データベース方言 (Dialect)

**クラス**: `nablarch.core.db.dialect.Dialect`

DB製品対応の`Dialect`を設定することで、製品ごとの方言を意識せずに実装できる。提供メソッド:

- `supportsIdentity()` — identityカラムを使えるか否か
- `supportsIdentityWithBatchInsert()` — identityカラムを持つテーブルへのbatch insertが可能か否か
- `supportsSequence()` — シーケンスオブジェクトを使えるか否か
- `supportsOffset()` — 検索クエリーの範囲指定でoffsetを使えるか否か
- `isDuplicateException(SQLException)` — 一意制約違反のSQLExceptionか判定
- `isTransactionTimeoutError(SQLException)` — トランザクションタイムアウト対象のSQLExceptionか判定
- `buildSequenceGeneratorSql(String)` — シーケンスから次の値を取得するSQL文生成
- `getResultSetConvertor()` — ResultSetから値を取得する`ResultSetConvertor`を返す
- `convertPaginationSql(String, SelectOption)` — 検索クエリーをページング用SQLに変換
- `convertCountSql(String)` — 検索クエリーを件数取得SQLに変換
- `convertCountSql(String, Object, StatementFactory)` — SQLIDを件数取得SQLに変換
- `getPingSql()` — ConnectionのpingチェックSQLを返す

設定方法: [database-use_dialect](#s3)

## SQLファイル管理

SQLはSQLファイルに定義し、原則ロジック内には記述しない。必ずPreparedStatementを使用するためSQLインジェクションの脆弱性を排除できる。

> **補足**: SQLファイルに定義できない場合はSQL直接指定APIも提供。ただし安易に使用するとSQLインジェクションの脆弱性が埋め込まれる可能性があるため、テストやレビューで脆弱性がないことを担保することが前提。

詳細: [database-use_sql_file](#s4)

## BeanバインドとLike検索・動的SQL・キャッシュ

- **Beanバインド**: Beanプロパティ値を`java.sql.PreparedStatement`のINパラメータに自動バインド。INパラメータが増減した際のインデクス修正が不要。詳細: [database-input_bean](#s8)
- **like検索**: escape句の挿入とワイルドカード文字のエスケープ処理を自動実行。詳細: [database-like_condition](#)
- **動的SQL**: Beanオブジェクトの状態を元に条件やin句を動的に構築。詳細: [database-use_variable_condition](#), [database-in_condition](#), [database-make_order_by](#)
- **クエリキャッシュ**: 同一SQL・同一バインド変数の場合にDBアクセスせずキャッシュから返却。詳細: [database-use_cache](#)

Beanオブジェクトを入力としてSQLを実行する場合、SQLのINパラメータには名前付きバインド変数（`:`に続けてBeanのプロパティ名）を使用する。

> **重要**: INパラメータをJDBC標準の`?`で記述した場合、Beanオブジェクトを入力としたSQL実行は動作しない。

**クラス**: `AppDbConnection`, `ParameterizedSqlPStatement`

SQL例:
```sql
insert into user
  (id, name)
  values (:id, :userName)
```

実装例:
```java
UserEntity entity = new UserEntity();
entity.setId(1);
entity.setUserName("なまえ");

AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#insertUser");
int result = statement.executeUpdateByObject(entity);
```

> **補足**: Beanの代わりに`Map`の実装クラスも指定可能。Mapのキー値と一致するINパラメータにMapの値が設定される。Beanを指定した場合は`BeanUtil`でMap変換後に処理される。BeanUtilが対応していない型のプロパティはこの機能で使用不可。対応型を追加するには[utility-conversion](libraries-bean_util.md)を参照。

> **補足**: フィールドアクセスへの変更はpropertiesファイルに`nablarch.dbAccess.isFieldAccess=true`を設定する。ただし推奨しない。理由: 本フレームワークの他機能（`BeanUtil`等）はプロパティアクセスで統一されており、データベース機能のみフィールドアクセスにすると、開発者がフィールドアクセスとプロパティアクセスの両方を意識する必要が生じ、生産性低下や不具合の原因となる。

in句の条件数が可変となるSQLを実行するには、[database-input_bean](#s8) を使用し、名前付きパラメータの末尾に `[]` を付加する。対応するBeanのプロパティの型は配列か `Collection` (サブタイプ含む) である必要がある。

> **補足**: in句の条件となるプロパティ値がnullやサイズ0の場合には、必ず可変条件として定義すること。可変条件にしなかった場合でプロパティ値がnullだと、条件が `xxxx in (null)` となり検索結果が正しく取得できない可能性がある。in句は条件式を空にできないため、サイズ0の配列やnullが指定された場合は `in (null)` とする仕様。

**SQL例**（`$if` と併用: `userKbn` がnullまたはサイズ0の場合は条件から除外）:
```sql
select user_id, user_name, user_kbn
from user
where
  $if (userKbn) {user_kbn in (:userKbn[])}
```

**Java実装例**（2要素でin句: `userKbn in (?, ?)`）:
```java
UserSearchCondition condition = new UserSearchCondition();
condition.setUserKbn(Arrays.asList("1", "3"));

AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#searchUser", condition);
SqlResultSet result = statement.retrieve(condition);
```

> **注意**: Beanのプロパティ値は `BeanUtil` を使ってMapに変換してから使用するため、`BeanUtil` でサポートされていない型でプロパティが宣言されていた場合、in句に条件を設定できない。型の追加方法は [utility-conversion-add-rule](libraries-bean_util.md) を参照。

検索結果のキャッシュ機能。参照系DBアクセスを省略してシステム負荷を軽減する目的で使用する。

**有効なユースケース**:
- 売り上げランキングのように結果が厳密に最新でなく大量に参照されるデータ
- データ更新タイミングが夜間のみで日中は更新されないデータ

> **重要**: この機能はDBアクセス省略によるシステム負荷軽減が目的。SQLの高速化目的には使用しないこと。SQLチューニングを実施すること。

> **重要**: DBの値更新を監視してキャッシュを最新化しない。常に最新データを表示する必要がある機能では使用しないこと。

**制約**:
- LOB型（BLOB/CLOB）カラム取得時はLOBロケータが取得される。LOBロケータの有効期間はRDBMS依存で、通常 `ResultSet` や `Connection` のクローズ時に失効する。キャッシュにBLOB/CLOB型を含められない。
- 冗長化構成ではJVMヒープ上にキャッシュが保持されアプリごとに独立。ラウンドロビンLBでリクエスト毎に異なる結果が返る可能性がある。

**コンポーネント設定（3ステップ）**:

1. `InMemoryResultSetCache` を定義:

```xml
<component name="resultSetCache" class="nablarch.core.db.cache.InMemoryResultSetCache">
  <property name="cacheSize" value="100"/>
  <property name="systemTimeProvider" ref="systemTimeProvider"/>
</component>
```

2. `BasicExpirationSetting` でSQLID毎の有効期限を設定（単位: `ms`, `sec`, `min`, `h`）:

```xml
<component name="expirationSetting" class="nablarch.core.cache.expirable.BasicExpirationSetting">
  <property name="expiration">
    <map>
      <entry key="SQLID1" value="100ms"/>
      <entry key="SQLID2" value="30sec"/>
    </map>
  </property>
</component>
```

3. `CacheableStatementFactory` を定義し、 [database-connect](#s3) のDB接続コンポーネントに設定。`BasicStatementFactory` を継承するため基本設定は同じ。`expirationSetting` と `resultSetCache` プロパティに上記コンポーネントを設定すること:

```xml
<component name="cacheableStatementFactory" class="nablarch.core.db.cache.CacheableStatementFactory">
  <property name="expirationSetting" ref="expirationSetting"/>
  <property name="resultSetCache" ref="resultSetCache"/>
</component>
```

**実装例**: SQLを使ったデータベースアクセスは、キャッシュ有無によって変わることはない。 [database-execute_sqlid](#s5) や [database-input_bean](#s8) と同じように実装すれば良い。

<details>
<summary>keywords</summary>

Dialect, nablarch.core.db.dialect.Dialect, ResultSetConvertor, supportsIdentity, supportsSequence, isDuplicateException, convertPaginationSql, getPingSql, データベース方言, SQLインジェクション対策, SQLファイル管理, Beanバインド, like検索, 動的SQL構築, クエリキャッシュ, AppDbConnection, ParameterizedSqlPStatement, BeanUtil, DbConnectionContext, executeUpdateByObject, prepareParameterizedSqlStatementBySqlId, 名前付きバインド変数, Beanオブジェクト入力, Map入力, フィールドアクセス, nablarch.dbAccess.isFieldAccess, in句可変条件, 配列パラメータ, Collectionパラメータ, []記法, $if条件, InMemoryResultSetCache, BasicExpirationSetting, CacheableStatementFactory, BasicStatementFactory, 検索結果キャッシュ, LOB型制約, SQLID有効期限設定, cacheSize, expiration

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-jdbc</artifactId>
</dependency>
```

データベースアクセス(JDBCラッパー)の型変換はJDBCドライバに委譲される。入出力変数の型はデータベースの型および使用するJDBCドライバの仕様に従って定義すること。

任意の型変換が必要な場合は、アプリケーション側で型変換を行う：

- Bean入力の場合: Beanプロパティへの値設定時（入力）またはプロパティから値取得後（出力）に型変換
- Map入力の場合: Mapへの値設定時（入力）または値取得後（出力）に型変換
- インデックス指定でバインド変数を設定する場合: バインド変数に設定するオブジェクトを適切な型に変換。`SqlRow`から値取得後に型変換

order by句のソート項目を実行時に動的に切り替えるには、[database-input_bean](#s8) を使用し、order by句の代わりに `$sort` を使用する。

**記法**:
```
$sort(プロパティ名) {(ケース1)(ケース2)・・・(ケースn)}
```

- 各ケースはソートIDとケース本体を半角丸括弧で囲む
- ソートIDとケース本体は半角スペースで区切る
- ソートIDには半角スペース使用不可、ケース本体は半角スペース使用可
- デフォルトのケースにはソートIDに `default` を指定する
- ソートIDおよびケース本体はトリミングされる

**SQL例**:
```sql
select user_id, user_name
from user
where user_name = :userName
$sort(sortId) {
  (user_id_asc  user_id asc)
  (user_id_desc user_id desc)
  (name_asc     user_name asc)
  (name_desc    user_name desc)
  (default      user_id)
}
```

**Java実装例**（`sortId` に `name_asc` を設定 → `order by user_name asc`）:
```java
UserSearchCondition condition = new UserSearchCondition();
condition.setUserName("なまえ");
condition.setSortId("name_asc");

AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#searchUser", condition);
SqlResultSet result = statement.retrieve(condition);
```

`DbConnectionContext` から `TransactionManagerConnection` を取得し、`getConnection()` で `Connection` を取得できる。例えば、 `DatabaseMetaData` を使用したい場合がこれに該当する。

> **重要**: `Connection` 使用時はチェック例外 `SQLException` のハンドリングが必要。実装を誤ると障害検知不能・調査不能になる。どうしても必要な要件がない限り使用しないこと。

```java
TransactionManagerConnection managerConnection = DbConnectionContext.getTransactionManagerConnection();
Connection connection = managerConnection.getConnection();
return connection.getMetaData();
```

<details>
<summary>keywords</summary>

nablarch-core-jdbc, com.nablarch.framework, モジュール依存関係, SqlRow, 型変換, JDBCドライバ, 型マッピング, バインド変数型, ParameterizedSqlPStatement, $sort, order by動的切り替え, ソートID, 可変order by句, DbConnectionContext, TransactionManagerConnection, java.sql.Connection, java.sql.SQLException, JDBCネイティブ接続, getConnection, java.sql.DatabaseMetaData

</details>

## データベースに対する接続設定

接続設定は以下の2通りから選択:

- `javax.sql.DataSource`を使った接続: **クラス** `nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource`
- アプリケーションサーバのデータソース(JNDI)を使った接続: **クラス** `nablarch.core.db.connection.BasicDbConnectionFactoryForJndi`

上記以外の接続方法（OSSのコネクションプーリングライブラリなど）は [database-add_connection_factory](#) を参照。

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

> **補足**: 上記クラスを直接使用することは基本的にない。データベースアクセスを必要とする場合は [database_connection_management_handler](../handlers/handlers-database_connection_management_handler.md) を使用すること。データベースを使用する場合はトランザクション管理も必要。詳細: [transaction](libraries-transaction.md)

データ登録・更新時に毎回設定する値（登録日時・更新日時など）をSQL実行直前に自動設定する機能。[database-input_bean](#s8)を使用した場合のみ有効。

**クラス**: `BasicStatementFactory`, `AutoPropertyHandler`

標準実装クラスは`nablarch.core.db.statement.autoproperty`パッケージ配下に配置されている。

`BasicStatementFactory#updatePreHookObjectHandlerList`に`AutoPropertyHandler`実装クラスをlistで設定する。ここで定義した`BasicStatementFactory`コンポーネントは[database-connect](#s3)で定義したデータベース接続コンポーネントに設定すること。

```xml
<component name="statementFactory"
    class="nablarch.core.db.statement.BasicStatementFactory">
  <property name="updatePreHookObjectHandlerList">
    <list>
      <!-- AutoPropertyHandler実装クラスをlistで設定する-->
    </list>
  </property>
</component>
```

Beanのプロパティに自動設定対象アノテーションを設定する（標準アノテーションは`nablarch.core.db.statement.autoproperty`パッケージ配下）:

```java
public class UserEntity {
  private String id;

  @CurrentDateTime
  private Timestamp createdAt;  // 登録時に自動設定

  @CurrentDateTime
  private String updatedAt;     // 登録・更新時に自動設定
}
```

SQL例（[database-input_bean](#s8)と同じように作成する。自動設定項目（`:createdAt`、`:updatedAt`）もSQL中に記述すること）:

```sql
insert into user (
  id,
  createdAt,
  updatedAt
) values (
  :id,
  :createdAt,
  :updatedAt
)
```

自動設定項目はロジックで値を設定不要。値を明示的に設定しても、SQL実行直前に自動設定機能により上書きされる。

```java
UserEntity entity = new UserEntity();
entity.setId(1);  // 自動設定項目（createdAt, updatedAt）は設定不要

AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#insertUser");
int result = statement.executeUpdateByObject(entity);
```

バイナリ型（BLOB等）カラムへのアクセス方法。

**バイナリ型の値を取得する**:
`SqlRow` から `byte[]` として取得する。

```java
SqlResultSet rows = statement.retrieve();
byte[] encryptedPassword = rows.get(0).getBytes("password");
```

> **重要**: 上記実装の場合、カラムの内容が全てJavaのヒープ上に展開される。非常に大きいサイズのデータを読み込んだ場合、ヒープ領域を圧迫しシステムダウン等の障害の原因となる。大量データを読み込む場合は `Blob` オブジェクトを使用してヒープを大量に消費しないようにすること。
> ```java
> Blob pdf = (Blob) rows.get(0).get("PDF");
> try (InputStream input = pdf.getBinaryStream()) {
>     // InputStreamからデータを順次読み込む（一括読み込みは全てヒープに展開されるので注意）
> }
> ```

**バイナリ型の値を登録・更新する**:
- サイズが小さい場合: `SqlPStatement#setBytes` を使用する
```java
statement.setBytes(1, new byte[] {0x30, 0x31, 0x32});
int updateCount = statement.executeUpdate();
```

- サイズが大きい場合: `SqlPStatement#setBinaryStream` を使用し、`InputStream` から直接データベースに送信する
```java
final Path pdf = Paths.get("input.pdf");
try (InputStream input = Files.newInputStream(pdf)) {
    statement.setBinaryStream(1, input, (int) Files.size(pdf));
}
```

SQL文中にプレースホルダー `#SCHEMA#`（固定文字列）を記載し、環境毎にスキーマを切り替える機能。

```sql
SELECT * FROM #SCHEMA#.TABLE1
```

`BasicSqlLoader` に `SchemaReplacer` を設定し、`schemaName` プロパティに置換値（環境依存値）を指定する。

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

環境依存値の切り替え方法: [how_to_switch_env_values](../../setup/setting-guide/setting-guide-ManagingEnvironmentalConfiguration.md) 参照。

> **補足**: スキーマ置き換えは単純な文字列置換。スキーマの存在確認やSQL妥当性チェックは行われない（実行時エラーとなる）。

<details>
<summary>keywords</summary>

BasicDbConnectionFactoryForDataSource, BasicDbConnectionFactoryForJndi, nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource, nablarch.core.db.connection.BasicDbConnectionFactoryForJndi, データベース接続設定, DataSource接続, JNDI接続, BasicStatementFactory, AutoPropertyHandler, @CurrentDateTime, updatePreHookObjectHandlerList, 共通値自動設定, 登録日時自動設定, 更新日時自動設定, SqlRow, SqlPStatement, setBytes, setBinaryStream, バイナリ型カラム, BLOBアクセス, Blob, InputStream, BasicSqlLoader, SchemaReplacer, schemaName, スキーマ切り替え, #SCHEMA#プレースホルダー, how_to_switch_env_values

</details>

## データベース製品に対応したダイアレクトを使用する

コンポーネント設定ファイルにDB製品対応のダイアレクトを設定することでダイアレクト機能が有効になる。

> **補足**: 設定しなかった場合は `nablarch.core.db.dialect.DefaultDialect` が使用される。`DefaultDialect`は原則全ての機能が無効化されるため、必ずDB製品に対応したダイアレクトを設定すること。使用するDB製品に対応するダイアレクトが存在しない場合や新機能を使いたい場合は [database-add_dialect](#) を参照して新しいダイアレクトを作成すること。

`dialect`プロパティにダイアレクトを設定する（`BasicDbConnectionFactoryForDataSource`も`BasicDbConnectionFactoryForJndi`も同様）:

```xml
<component class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
  <property name="dialect">
    <component class="nablarch.core.db.dialect.OracleDialect" />
  </property>
</component>
```

like検索は[database-input_bean](#s8)を使用し、以下のルールでSQLを記述する：

| 一致種別 | SQL記述例 |
|---|---|
| 前方一致 | `name like :userName%` |
| 後方一致 | `name like :%userName` |
| 途中一致 | `name like :%userName%` |

値の書き換えとエスケープ処理は自動で行われる。エスケープ文字とエスケープ対象文字の定義は[database-def_escape_char](#)を参照。

**クラス**: `AppDbConnection`, `ParameterizedSqlPStatement`

SQL例:
```sql
select *
  from user
 where name like :userName%
```

実装例（前方一致の場合、`name like 'な%' escape '\'`が実行される）:
```java
UserEntity entity = new UserEntity();
entity.setUserName("な");

AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#findUserByName");
int result = statement.retrieve(bean);
```

CLOBのような大きいサイズの文字列型カラムへのアクセス方法。

**CLOB型の値を取得する**:
`検索結果オブジェクト` から文字列型として取得する。

```java
SqlResultSet rows = statement.retrieve();
String mailBody = rows.get(0).getString("mailBody");
```

> **重要**: 上記実装の場合、カラムの内容が全てJavaのヒープ上に展開される。非常に大きいサイズのデータを読み込んだ場合、ヒープ領域を圧迫し障害の原因となる。大量データを読み込む場合は `Clob` オブジェクトを使用してヒープを大量に消費しないようにすること。
> ```java
> Clob mailBody = (Clob) rows.get(0).get("mailBody");
> try (Reader reader = mailBody.getCharacterStream()) {
>     // Readerからデータを順次読み込む（読み込んだデータを全てヒープ上に保持した場合はヒープを圧迫するので注意）
> }
> ```

**CLOB型に値を登録・更新する**:
- サイズが小さい場合: `SqlPStatement#setString` を使用する
```java
statement.setString(1, "値");
statement.executeUpdate();
```

- サイズが大きい場合: `SqlPStatement#setCharacterStream` を使用し、`Reader` 経由でデータベースに送信する
```java
Path path = Paths.get(filePath);
try (Reader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
    statement.setCharacterStream(1, reader, (int) Files.size(path));
}
```

**接続方法の追加** ([database-add_connection_factory](#)):
1. `ConnectionFactorySupport` を継承してDB接続生成クラスを作成
2. 作成クラスをコンポーネント設定ファイルに設定（ [database-connect](#s3) 参照）

**ダイアレクトの追加** ([database-add_dialect](#)):
1. `DefaultDialect` を継承してDB製品対応ダイアレクトを作成
2. 作成ダイアレクトをコンポーネント設定ファイルに設定（ [database-use_dialect](#s3) 参照）

**例外クラスの切り替え** ([database-change_exception](#)):
1. `DbAccessExceptionFactory` 実装クラスを作成（DB接続取得時・トランザクション制御時の `DbAccessException` を変更）
2. `SqlStatementExceptionFactory` 実装クラスを作成（SQL実行時の `SqlStatementException` を変更）
3. `DbAccessExceptionFactory` 実装は [database-connect](#s3) のDB接続コンポーネントに設定:

```xml
<component class="sample.SampleDbAccessExceptionFactory" />
```

`SqlStatementExceptionFactory` 実装は `BasicStatementFactory` に設定:

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
  <property name="sqlStatementExceptionFactory">
    <component class="sample.SampleStatementExceptionFactory" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

DefaultDialect, OracleDialect, nablarch.core.db.dialect.DefaultDialect, dialect, ダイアレクト設定, 方言設定, ConnectionFactorySupport, AppDbConnection, ParameterizedSqlPStatement, like検索, 前方一致, 後方一致, 途中一致, エスケープ処理自動, SqlRow, SqlPStatement, setString, setCharacterStream, CLOBアクセス, 大きい文字列型カラム, Clob, Reader, DbAccessExceptionFactory, SqlStatementExceptionFactory, BasicStatementFactory, DbAccessException, SqlStatementException, 接続方法追加, ダイアレクト追加, 例外クラス切り替え

</details>

## SQLをファイルで管理する

SQLファイルの作成ルール:

- クラスパス配下に作成する
- 1つのSQLファイルに複数のSQL記述可能。SQLIDはファイル内で一意とする
- SQLIDとSQLIDとの間には空行を挿入する（スペースが存在する行は空行とはみなさない）
- SQLIDとSQLとの間には`=`を入れる
- コメントは`--`で記述する（ブロックコメントはサポートしない）
- SQLは改行やスペース(tab)などで整形可能

> **重要**: SQLを複数機能で流用せず、かならず機能ごとに作成すること。流用した場合、意図しない使われ方やSQL変更により思わぬ不具合が発生する（例: `for update`が追加された場合、排他ロックが不要な機能でもロックが取得され処理遅延の原因となる）。

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

## SQLファイルからSQLをロードするための設定

**クラス**: `nablarch.core.db.statement.BasicStatementFactory`, `nablarch.core.db.statement.BasicSqlLoader`

`BasicStatementFactory`の`sqlLoader`プロパティに`BasicSqlLoader`を設定する。省略時のデフォルト値:

- `fileEncoding`: `utf-8`
- `extension`: `sql`

ここで定義した`BasicStatementFactory`コンポーネントは、[database-connect](#s3) で定義したデータベース接続コンポーネントに設定する必要がある。

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

エスケープ文字及びエスケープ対象文字はコンポーネント設定ファイルで定義する。エスケープ文字自体は自動的にエスケープ対象となるため、エスケープ対象文字に明示的に追加不要。

デフォルト値：
- エスケープ文字: `\`
- エスケープ対象文字: `%`、`_`

**クラス**: `BasicStatementFactory`

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| likeEscapeChar | | `\` | エスケープ文字 |
| likeEscapeTargetCharList | | `%,_` | エスケープ対象文字（カンマ区切り） |

ここで定義した`BasicStatementFactory`コンポーネントは、[database-connect](#s3)で定義したデータベース接続コンポーネントに設定すること。

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
  <!-- エスケープ文字の定義 -->
  <property name="likeEscapeChar" value="\" />
  <!-- エスケープ対象文字の定義（カンマ区切り） -->
  <property name="likeEscapeTargetCharList" value="%,％,_,＿" />
</component>
```

データベースアクセス時の例外は全て非チェック例外であり、`SQLException` のように `try-catch` で補足する必要はない。

| 例外クラス | 発生条件 | 備考 |
|---|---|---|
| `DbAccessException` | データベースアクセスエラー全般 | |
| `DbConnectionException` | データベース接続エラー | [retry_handler](../handlers/handlers-retry_handler.md) により処理される。未適用の場合は実行時例外として扱われる。接続エラーの判定には [ダイアレクト](#s1) を使用 |
| `SqlStatementException` | SQL実行失敗 | |
| `DuplicateStatementException` | 一意制約違反 | 一意制約違反の判定には [ダイアレクト](#s1) を使用。ハンドリング方法は [database-duplicated_error](#) を参照 |

> **補足**: データベースアクセスエラー発生時の例外を変更したい場合は [database-change_exception](#) を参照すること。

<details>
<summary>keywords</summary>

BasicStatementFactory, BasicSqlLoader, nablarch.core.db.statement.BasicStatementFactory, nablarch.core.db.statement.BasicSqlLoader, sqlLoader, fileEncoding, extension, SQLファイル, SQLID, likeEscapeChar, likeEscapeTargetCharList, エスケープ文字定義, like検索設定, DbAccessException, DbConnectionException, SqlStatementException, DuplicateStatementException, データベースアクセス例外, 非チェック例外

</details>

## SQLIDを指定してSQLを実行する

**クラス**: `nablarch.core.db.connection.DbConnectionContext`, `nablarch.core.db.connection.AppDbConnection`, `nablarch.core.db.statement.SqlPStatement`

[database_connection_management_handler](../handlers/handlers-database_connection_management_handler.md) で`DbConnectionContext`にデータベース接続を登録する必要がある。

SQLIDマッピングルール:
- SQLIDの`#`までがSQLファイル名（クラスパス配下）
- SQLIDの`#`以降がSQLファイル内のSQLID

例: `jp.co.tis.sample.action.SampleAction#findUser` → ファイル: `jp.co.tis.sample.action.SampleAction.sql`、SQLID: `findUser`

```java
AppDbConnection connection = DbConnectionContext.getConnection();
SqlPStatement statement = connection.prepareStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#findUser");
statement.setLong(1, userId);
SqlResultSet result = statement.retrieve();
```

可変条件を持つSQLの実行は[database-input_bean](#s8)を使用し、`$if`構文で条件を記述する。

**$if構文**: `$if(プロパティ名) {SQL文の条件}`

プロパティ値が以下の場合に条件が除外される：
- 配列・`java.util.Collection`の場合: nullまたはサイズ0
- その他の型の場合: nullまたは空文字列（String型の場合）

**制約**:
- 使用できる箇所はWHERE句のみ
- `$if`内に`$if`を使用不可

> **重要**: この機能はウェブアプリケーションの検索画面のようにユーザの入力によって検索条件が変わる場合に使用するもの。条件だけが異なる複数のSQLを共通化するために使用しない。安易に共通化するとSQL変更時に予期しない不具合を埋め込む原因となるため、必ずSQLを複数定義すること。

SQL例（`userName`と`userKbn`が可変）:
```sql
select
  user_id,
  user_name,
  user_kbn
from
  user
where
  $if (userName) {user_name like :userName%}
  and $if (userKbn) {user_kbn in ('1', '2')}
  and birthday = :birthday
```

実装例（`userName`のみ設定した場合、`userKbn`条件は除外される）:
```java
UserEntity entity = new UserEntity();
entity.setUserName("なまえ");

AppDbConnection connection = DbConnectionContext.getConnection();
// 2番目の引数にBeanオブジェクトを指定してSQLの可変条件を組み立てる
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#insertUser", entity);
SqlResultSet result = statement.retrieve(entity);
```

一意制約違反時に処理を行う場合は、`DuplicateStatementException` を `try-catch` で補足する。一意制約違反の判定には [ダイアレクト](#s1) が使用される。

> **重要**: データベース製品によっては、SQL実行時に例外が発生した場合にロールバックを行うまで一切のSQLを受け付けないものがある。このような製品では例外ハンドリングの代わりに他の手段（例: `merge` 文）で代用できないか検討すること。例えば、登録処理で一意制約違反が発生した場合に更新処理をしたい場合は、例外ハンドリングではなく `merge` 文を使用することでこの問題を回避できる。

<details>
<summary>keywords</summary>

DbConnectionContext, AppDbConnection, SqlPStatement, SqlResultSet, nablarch.core.db.connection.DbConnectionContext, prepareStatementBySqlId, retrieve, SQLID, SQL実行, $if構文, 可変条件, ParameterizedSqlPStatement, 動的SQL, WHERE句可変, 検索条件切り替え, DuplicateStatementException, 一意制約違反ハンドリング, merge文, try-catch

</details>

## ストアードプロシージャを実行する

**クラス**: `nablarch.core.db.statement.SqlCStatement`

> **重要**: ストアードプロシージャの実行では [database-bean](#s1) はサポートしない。ロジックがJavaとストアードプロシージャに分散して保守性を著しく低下させるため、原則使用すべきではない。ただし、既存の資産などでどうしてもストアードプロシージャを使用しなければならないケースが想定されるため、本機能では非常に簡易的ではあるがストアードプロシージャを実行するためのAPIを提供している。

```java
SqlCStatement statement = connection.prepareCallBySqlId(
    "jp.co.tis.sample.action.SampleAction#execute_sp");
statement.registerOutParameter(1, Types.CHAR);
statement.execute();
String result = statement.getString(1);
```

処理が長いトランザクションのタイムアウト制御はトランザクション管理にて実現する。詳細は [transaction-timeout](libraries-transaction.md) を参照。

<details>
<summary>keywords</summary>

SqlCStatement, nablarch.core.db.statement.SqlCStatement, prepareCallBySqlId, registerOutParameter, ストアードプロシージャ, トランザクションタイムアウト, 長時間トランザクション中断, transaction-timeout

</details>

## 検索範囲を指定してSQLを実行する

**クラス**: `nablarch.core.db.statement.SqlPStatement`

ページング用に検索結果の範囲を指定できる。以下の例では開始位置11・取得件数10を指定（11件目から最大10件取得）:

```java
AppDbConnection connection = DbConnectionContext.getConnection();
SqlPStatement statement = connection.prepareStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#findUser", new SelectOption(11, 10));
SqlResultSet result = statement.retrieve();
```

> **補足**: 検索範囲が指定された場合、検索用SQLを取得範囲指定のSQLに書き換えてから実行する。取得範囲指定のSQLへの書き換えは [ダイアレクト](#s1) により行われる。

現在のトランザクション（データベース接続管理ハンドラ及びトランザクション制御ハンドラで開始したもの）とは異なる個別トランザクションを使用してデータベースアクセスする。例えば、業務処理が失敗した場合でも必ずDBへの変更を確定したい場合などに使用する。

**手順**:
1. コンポーネント設定ファイルに `SimpleDbTransactionManager` を定義する
2. `SimpleDbTransactionManager` をシステムリポジトリから取得し、`SimpleDbTransactionExecutor` を使ってSQLを実行する（システムリポジトリから取得するのではなく、`SimpleDbTransactionManager` を直接設定して使用してもよい）

**コンポーネント設定例**:
```xml
<component name="update-login-failed-count-transaction"
           class="nablarch.core.db.transaction.SimpleDbTransactionManager">
  <property name="connectionFactory" ref="connectionFactory" />
  <property name="transactionFactory" ref="transactionFactory" />
  <property name="dbTransactionName" value="update-login-failed-count-transaction" />
</component>
```

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| connectionFactory | `ConnectionFactory` | ○ | ConnectionFactory実装クラス。詳細は [database-connect](#s3) を参照 |
| transactionFactory | `TransactionFactory` | ○ | TransactionFactory実装クラス。詳細は [transaction-database](libraries-transaction.md) を参照 |
| dbTransactionName | String | | トランザクションを識別するための名前 |

**Java実装例**（`SystemRepository` から取得し `SimpleDbTransactionExecutor` を使用してトランザクション制御）:
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

AppDbConnection, DbConnectionContext, SqlPStatement, SqlResultSet, SelectOption, prepareStatementBySqlId, ページング, 検索範囲指定, offset, SimpleDbTransactionManager, SimpleDbTransactionExecutor, ConnectionFactory, TransactionFactory, 個別トランザクション, 独立トランザクション, SystemRepository, dbTransactionName

</details>
