# データベースアクセス(JDBCラッパー)

## はじめに

JDBCを使用してデータベースに対してSQL文を実行する機能を提供する。

> **推奨**: :ref:`database_management` で説明したように、SQLの実行に関しては :ref:`universal_dao` を使用することを推奨する。なお、:ref:`universal_dao` 内部では、この機能のAPIを使用してデータベースアクセスを行っているため、この機能を使用するための設定は必ず必要になる。

> **重要**: この機能は、JDBC 3.0に依存しているため、使用するJDBCドライバがJDBC 3.0以上を実装している必要がある。

## データベースの方言を意識することなく使用できる

使用するデータベース製品に対応した `Dialect` を設定することで、製品ごとの方言を意識せずにアプリケーションを実装できる。

**Dialect提供メソッド**:
- `supportsIdentity` - identityカラム使用可否判定
- `supportsIdentityWithBatchInsert` - identityカラム+batch insert可否判定
- `supportsSequence` - シーケンス使用可否判定
- `supportsOffset` - offset使用可否判定
- `isDuplicateException` - 一意制約違反判定
- `isTransactionTimeoutError` - トランザクションタイムアウト判定
- `buildSequenceGeneratorSql` - シーケンス値取得SQL生成
- `getResultSetConvertor` - `ResultSetConvertor` 取得
- `convertPaginationSql` - ページング用SQL変換
- `convertCountSql(String)` - 件数取得SQL変換
- `convertCountSql(String, Object, StatementFactory)` - SQLID→件数取得SQL変換
- `getPingSql` - 接続チェックSQL取得

設定方法: :ref:`database-use_dialect` 参照

> **補足**: Dialect未設定時は `DefaultDialect` が使用されるが、全機能が無効化されるため、必ずデータベース製品対応のDialectを設定すること。対応Dialectが存在しない場合は :ref:`database-add_dialect` を参照して新規作成すること。

## SQLはロジックではなくSQLファイルに記述する

SQLはSQLファイルに定義し、原則ロジック内には記述しない。SQLファイルに記述することで、ロジックでSQLの組み立てを行う必要がなく、必ず `PreparedStatement` を使用するため、SQLインジェクションの脆弱性が排除できる。

> **補足**: SQLファイルに定義できない場合は、SQL直接指定APIを使用できるが、安易に使用するとSQLインジェクションの脆弱性が埋め込まれる可能性があるため注意すること。また、SQLインジェクションの脆弱性がないことなど、テストやレビューで担保出来ることが前提となる。

詳細: :ref:`database-use_sql_file` 参照

## Beanのプロパティ値をSQLのバインド変数に埋め込むことができる

Beanのプロパティに設定した値を `PreparedStatement` のINパラメータに自動的にバインドする機能を提供する。この機能を使用することで、`PreparedStatement` の値設定用メソッドを複数回呼び出す必要がなくなり、INパラメータが増減した際のインデクス修正などが不要となる。

詳細: :ref:`database-input_bean` 参照

## like検索を容易に実装できる

like検索に対するescape句の挿入とワイルドカード文字のエスケープ処理を自動で行う機能を提供する。

詳細: :ref:`database-like_condition` 参照

## 実行時のBeanオブジェクトの状態を元にSQL文を動的に構築できる

Beanオブジェクトの状態を元に、実行するSQL文を動的に組み立てる機能を提供する。例えば、条件やin句の動的な構築などが行える。

詳細:
- :ref:`database-use_variable_condition`
- :ref:`database-in_condition`
- :ref:`database-make_order_by`

## SQLのクエリ結果をキャッシュできる

実行したSQLと外部から取得した条件(バインド変数に設定した値)が等価である場合に、データベースにアクセスせずにキャッシュから検索結果を返却する機能を提供する。

詳細: :ref:`database-use_cache` 参照

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-jdbc</artifactId>
</dependency>
```

## データベースに対する接続設定

データベース接続設定は以下の2通りから選択可能:
- `DataSource` を使った接続生成
- アプリケーションサーバに登録されたデータソースを使った接続生成

上記以外の接続方法（OSSコネクションプーリングライブラリなど）を使用する場合は :ref:`database-add_connection_factory` を参照。

**DataSourceからの接続生成**:
```xml
<component class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
  <!-- 設定値の詳細はJavadocを参照 -->
</component>
```

**JNDIデータソースからの接続生成**:
```xml
<component class="nablarch.core.db.connection.BasicDbConnectionFactoryForJndi">
  <!-- 設定値の詳細はJavadocを参照 -->
</component>
```

**クラス**: `BasicDbConnectionFactoryForDataSource`, `BasicDbConnectionFactoryForJndi`

設定値詳細は各クラスのJavadocを参照。

> **補足**: これらのクラスを直接使用することは基本的にない。データベースアクセスには :ref:`database_connection_management_handler` を使用すること。トランザクション管理については :ref:`transaction` を参照。

## データベース製品に対応したダイアレクトを使用する

データベース製品対応Dialectをコンポーネント設定ファイルに設定することで、Dialect機能が有効化される。

> **補足**: Dialect未設定時は `DefaultDialect` が使用されるが、全機能が無効化されるため、必ずデータベース製品対応Dialectを設定すること。対応Dialectが存在しない場合や新バージョンの新機能を使用する場合は :ref:`database-add_dialect` を参照して新規作成すること。

**設定例** (`DataSource` から接続取得):
```xml
<component class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
  <!-- ダイアレクトと関係のないプロパティについては省略 -->
  <!-- ダイアレクトはdialectプロパティに設定 (例: Oracle用Dialect) -->
  <property name="dialect">
    <component class="nablarch.core.db.dialect.OracleDialect" />
  </property>
</component>
```

`BasicDbConnectionFactoryForJndi` の場合も同様に `dialect` プロパティに設定。

## SQLをファイルで管理する

SQLはSQLファイルで管理する (:ref:`database-sql_file` 参照)。SQLファイルを扱うには、コンポーネント設定ファイルへの設定が必要 (詳細: :ref:`database-load_sql`)。

**SQLファイル作成ルール**:
- クラスパス配下に作成
- 1ファイルに複数SQL記述可能だが、SQLIDはファイル内で一意
- SQLID間には空行挿入（スペース存在行は空行とみなさない）
- SQLIDとSQLの間には `=` を挿入
- コメントは `--` で記述（ブロックコメント非サポート）
- SQLは改行やスペース(tab)で整形可能

> **重要**: SQLを複数機能で流用せず、必ず機能毎に作成すること。複数機能で流用すると、意図しない使われ方やSQL変更により思わぬ不具合が発生する。例: 複数機能で使用していたSQL文に `for update` が追加された場合、排他ロック不要な機能でロックが取得され処理遅延の原因となる。

**SQLファイル例**:
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

**SQLロード設定**: `BasicStatementFactory#sqlLoader` に `BasicSqlLoader` を設定する。

デフォルト値:
- ファイルエンコーディング: utf-8
- 拡張子: sql

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

この `BasicStatementFactory` コンポーネントは :ref:`database-connect` で定義したデータベース接続取得コンポーネントに設定する必要がある。

## SQLIDを指定してSQLを実行する

SQLIDを元にSQL実行するには、`DbConnectionContext` から取得したデータベース接続を使用する。`DbConnectionContext` には :ref:`database_connection_management_handler` でデータベース接続を登録する必要がある。

**SQLIDマッピングルール**:
- SQLIDの `#` までがSQLファイル名
- SQLIDの `#` 以降がSQLファイル内のSQLID

**実装例**: SQLID: `jp.co.tis.sample.action.SampleAction#findUser` の場合
- SQLファイル: クラスパス配下の `jp.co.tis.sample.action.SampleAction.sql`
- SQLファイル内のSQLID: `findUser`

```java
// DbConnectionContextからデータベース接続を取得
AppDbConnection connection = DbConnectionContext.getConnection();

// SQLIDを元にステートメント生成
SqlPStatement statement = connection.prepareStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#findUser");

// 条件設定
statement.setLong(1, userId);

// 検索実行
SqlResultSet result = statement.retrieve();
```

**クラス**: `AppDbConnection`, `SqlPStatement` (使用方法はJavadoc参照)

## ストアードプロシージャを実行する

ストアードプロシージャを実行する場合も、基本的にはSQLを実行する場合と同じように実装する。

> **重要**: ストアードプロシージャ実行では :ref:`database-bean` はサポートしない。理由: ストアードプロシージャ使用時、ロジックがJavaとストアードプロシージャに分散し、保守性が著しく低下するため原則使用すべきではない。ただし、既存資産などでどうしても使用が必要なケースがあるため、簡易的なストアードプロシージャ実行APIを提供している。

**実装例**:
```java
// SQLIDを元にストアードプロシージャ実行用ステートメント生成
SqlCStatement statement = connection.prepareCallBySqlId(
    "jp.co.tis.sample.action.SampleAction#execute_sp");

// IN及びOUTパラメータ設定
statement.registerOutParameter(1, Types.CHAR);

// 実行
statement.execute();

// OUTパラメータ取得
String result = statement.getString(1);
```

**クラス**: `SqlCStatement` (詳細な使用方法はJavadoc参照)

## 検索範囲を指定してSQLを実行する

ウェブシステムの一覧検索画面などでは、ページング機能を用いて特定範囲の結果のみを表示することがある。本機能では検索結果の範囲指定機能を提供している。

**実装例**: データベース接続からステートメント生成時に検索対象範囲を指定。この例では11件目から最大10件のレコードを取得。

- 開始位置: 11
- 取得件数: 10

```java
// DbConnectionContextからデータベース接続を取得
AppDbConnection connection = DbConnectionContext.getConnection();

// SQLIDと検索範囲を指定してステートメントオブジェクト生成
SqlPStatement statement = connection.prepareStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#findUser", new SelectOption(11, 10));

// 検索実行
SqlResultSet result = statement.retrieve();
```

> **補足**: 検索範囲指定時、検索用SQLを取得範囲指定SQLに書き換えてから実行する。取得範囲指定SQLは :ref:`database-dialect` により行われる。

## Beanオブジェクトを入力としてSQLを実行する

**INパラメータには名前付きバインド変数を使用**。`:プロパティ名`形式で記述。

> **重要**: INパラメータをJDBC標準の`?`で記述した場合、Beanオブジェクトを入力としたSQLは動作しない。

**SQL例**:
```sql
insert into user (id, name) values (:id, :userName)
```

**実装例**:

**クラス**: `nablarch.core.db.connection.AppDbConnection`, `nablarch.core.db.statement.ParameterizedSqlPStatement`

SQLIDの詳細: :ref:`database-execute_sqlid`

```java
UserEntity entity = new UserEntity();
entity.setId(1);
entity.setUserName("なまえ");

AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#insertUser");
int result = statement.executeUpdateByObject(entity);
```

> **補足**: Beanの代わりに`java.util.Map`実装クラスも指定可能。Mapのキー値と一致するINパラメータに値が設定される。Bean指定時は`BeanUtil`でMapに変換後処理。BeanUtilで対応していない型のプロパティは使用不可。型を増やす場合は:ref:`utility-conversion`参照。

> **補足**: Beanアクセスをプロパティからフィールドに変更可能。propertiesファイルに`nablarch.dbAccess.isFieldAccess=true`を設定。ただし**フィールドアクセスは非推奨**。理由: 他の機能（`BeanUtil`等）はプロパティアクセスで統一されており、フィールドアクセスとの混在は生産性低下と不具合の原因となる。

## 型を変換する

型変換はJDBCドライバに委譲。入出力変数の型はDB型およびJDBCドライバ仕様に応じて定義。

任意の型変換が必要な場合、アプリケーション側で実施:
- Bean入力: プロパティ設定時に型変換。Bean出力: プロパティ取得後に型変換
- Map入力: Map設定時に型変換。Map出力: 値取得後に型変換
- インデックス指定バインド: 設定時に適切な型に変換。`SqlRow`からの取得時は取得後に型変換

## SQL実行時に共通的な値を自動的に設定したい

登録/更新時に毎回設定する値（登録日時、更新日時等）をSQL実行直前に自動設定。プロパティのアノテーションを元に値を自動設定するため、:ref:`database-input_bean`使用時のみ有効。

**コンポーネント設定**:

`BasicStatementFactory#updatePreHookObjectHandlerList`に`AutoPropertyHandler`実装クラスをlist設定。標準実装は`nablarch.core.db.statement.autoproperty`パッケージ配下。

定義した`BasicStatementFactory`コンポーネントは:ref:`database-connect`で定義したデータベース接続取得コンポーネントに設定。

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
  <property name="updatePreHookObjectHandlerList">
    <list>
      <!-- nablarch.core.db.statement.AutoPropertyHandler実装クラスをlistで設定 -->
    </list>
  </property>
</component>
```

**Beanオブジェクト**:

自動設定したいプロパティにアノテーション設定。標準アノテーションは`nablarch.core.db.statement.autoproperty`パッケージ配下。

```java
public class UserEntity {
  private String id;
  
  @CurrentDateTime  // 登録時に自動設定
  private Timestamp createdAt;
  
  @CurrentDateTime  // 登録・更新時に自動設定
  private String updatedAt;
}
```

**SQL**: :ref:`database-input_bean`と同じように作成。

```sql
insert into user (id, createdAt, updatedAt) values (:id, :createdAt, :updatedAt)
```

**実装**: 自動設定項目に値を設定する必要なし。明示的に設定してもSQL実行直前に自動設定機能で上書きされる。

```java
UserEntity entity = new UserEntity();
entity.setId(1);  // createdAt, updatedAtは設定不要

AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#insertUser");
int result = statement.executeUpdateByObject(entity);
```

## like検索を行う

:ref:`database-input_bean`を使用し、SQLにlike検索用条件を記述。

**記述ルール**:
- 前方一致: 名前付きパラメータ末尾に`%` (例: `name like :userName%`)
- 後方一致: 名前付きパラメータ先頭に`%` (例: `name like :%userName`)
- 途中一致: 名前付きパラメータ前後に`%` (例: `name like :%userName%`)

エスケープ文字定義: :ref:`database-def_escape_char`

**SQL例**:
```sql
select * from user where name like :userName%
```

**実装**: :ref:`database-input_bean`と同じようにSQL実行するだけで値の書き換えとエスケープ処理が自動実行。例: `name like 'な%' escape '\\'`

**クラス**: `nablarch.core.db.connection.AppDbConnection`, `nablarch.core.db.statement.ParameterizedSqlPStatement`

SQLIDの詳細: :ref:`database-execute_sqlid`

```java
UserEntity entity = new UserEntity();
entity.setUserName("な");

AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#findUserByName");
int result = statement.retrieve(bean);
```

## like検索時のエスケープ文字及びエスケープ対象文字を定義する

コンポーネント設定ファイルに定義。エスケープ文字は自動的にエスケープ対象となるため、明示的なエスケープ対象文字設定は不要。

**デフォルト値**:
- エスケープ文字: `\`
- エスケープ対象文字: `%`, `_`

**コンポーネント設定例**:

定義した`BasicStatementFactory`コンポーネントは:ref:`database-connect`で定義したデータベース接続取得コンポーネントに設定。

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
  <property name="likeEscapeChar" value="\" />
  <property name="likeEscapeTargetCharList" value="%,％,_,＿" />
</component>
```

## 可変条件を持つSQLを実行する

:ref:`database-input_bean`を使用し、`$if(プロパティ名) {SQL文の条件}`記法で条件記述。

**記述ルール**:

`$if`後のプロパティ名に対応したBeanオブジェクト値により条件が除外される。

**除外条件**:
- 配列や`java.util.Collection`の場合: プロパティ値がnullまたはサイズ0
- 上記以外の型: プロパティ値がnullまたは空文字列（Stringオブジェクトの場合）

**制約**:
- 使用箇所はwhere句のみ
- `$if`内に`$if`を使用不可

> **重要**: この機能はユーザ入力内容により検索条件が変わる場合（検索画面等）に使用。条件だけが異なる複数SQLの共通化には使用しない。安易な共通化はSQL変更時の不具合原因となるため、必ずSQLを複数定義すること。

**SQL例**: `user_name`と`user_kbn`条件が可変。

```sql
select user_id, user_name, user_kbn
from user
where
  $if (userName) {user_name like :userName%}
  and $if (userKbn) {user_kbn in ('1', '2')}
  and birthday = :birthday
```

**実装例**: `userName`プロパティのみ値設定時、`user_kbn`条件は実行時に除外。

```java
UserEntity entity = new UserEntity();
entity.setUserName("なまえ");

AppDbConnection connection = DbConnectionContext.getConnection();
// 2番目の引数に条件を持つBeanオブジェクト指定。このBeanの状態を元に可変条件組み立て
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#insertUser", entity);
SqlResultSet result = statement.retrieve(entity);
```

## in句の条件数が可変となるSQLを実行する

in句の条件数を可変にする場合、名前付きパラメータの末尾に`[]`を付加する。対応するBeanプロパティの型は配列または`Collection`（サブタイプ含む）。

> **重要**: in句の条件値がnullまたはサイズ0になる可能性がある場合、必ず`$if`で可変条件として定義すること。可変条件としない場合、プロパティ値がnullのとき条件が`in (null)`となり検索結果が不正になる。in句は条件式を空にできないため、サイズ0配列やnullの場合は`in (null)`とする仕様。

> **注意**: プロパティ値は`BeanUtil`でMapに変換される。BeanUtilでサポートされていない型でプロパティを宣言した場合、in句に条件を設定できない。型のサポート追加方法は:ref:`utility-conversion-add-rule`を参照。

**SQL例（user_kbnのin条件を動的構築、$ifと併用でnull/サイズ0時は条件除外）:**
```sql
select user_id, user_name, user_kbn
from user
where $if (userKbn) {user_kbn in (:userKbn[])}
```

**実装例:**
```java
UserSearchCondition condition = new UserSearchCondition();
condition.setUserKbn(Arrays.asList("1", "3"));
AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#searchUser", condition);
SqlResultSet result = statement.retrieve(condition);
```

## order byのソート項目を実行時に動的に切り替えてSQLを実行する

order byのソート項目を可変にする場合、`$sort`を使用する。

**構文:**
```
$sort(プロパティ名) {(ケース1)(ケース2)...(ケースn)}
```

**プロパティ名**: BeanオブジェクトのソートIDを保持するプロパティ名

**ケース**: order by句の切り替え候補。ソートIDとorder by句文字列（ケース本体）を記述。デフォルトケースはソートID`"default"`を指定。

**記述ルール:**
- 各ケースはソートIDとケース本体を半角丸括弧で囲む
- ソートIDとケース本体は半角スペースで区切る
- ソートIDに半角スペース使用不可、ケース本体は使用可
- 括弧開き後の最初の文字列がソートID、以降括弧閉じまでがケース本体
- ソートIDとケース本体はトリミングされる

**SQL例:**
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

**実装例（sortId="name_asc"の場合、order by user_name ascとなる）:**
```java
UserSearchCondition condition = new UserSearchCondition();
condition.setUserName("なまえ");
condition.setSortId("name_asc");
AppDbConnection connection = DbConnectionContext.getConnection();
ParameterizedSqlPStatement statement = connection.prepareParameterizedSqlStatementBySqlId(
    "jp.co.tis.sample.action.SampleAction#searchUser", condition);
SqlResultSet result = statement.retrieve(condition);
```

## バイナリ型のカラムにアクセスする

**バイナリ型の値を取得する:**

`byte[]`で取得: `SqlRow`の`getBytes()`を使用。

```java
SqlResultSet rows = statement.retrieve();
SqlRow row = rows.get(0);
byte[] encryptedPassword = row.getBytes("password");
```

> **重要**: `byte[]`で取得するとカラム内容が全てヒープに展開される。大量データでヒープ圧迫→システムダウンの原因となる。大量データは`Blob`オブジェクトを使用し、ストリーム経由で順次読み込むこと。

```java
SqlResultSet rows = select.retrieve();
Blob pdf = (Blob) rows.get(0).get("PDF");
try (InputStream input = pdf.getBinaryStream()) {
  // InputStreamから順次読み込み（一括読み込みはヒープ展開されるので注意）
}
```

**バイナリ型の値を登録・更新する:**

小サイズ: `SqlPStatement#setBytes`

```java
SqlPStatement statement = getSqlPStatement("UPDATE_PASSWORD");
statement.setBytes(1, new byte[] {0x30, 0x31, 0x32});
int updateCount = statement.executeUpdate();
```

大サイズ: `SqlPStatement#setBinaryStream`で`InputStream`から直接送信。

```java
final Path pdf = Paths.get("input.pdf");
try (InputStream input = Files.newInputStream(pdf)) {
    statement.setBinaryStream(1, input, (int) Files.size(pdf));
}
```

## 桁数の大きい文字列型のカラム(例えばCLOB)にアクセスする

**CLOB型の値を取得する:**

`String`で取得: `SqlRow`の`getString()`を使用。

```java
SqlResultSet rows = statement.retrieve();
SqlRow row = rows.get(0);
String mailBody = row.getString("mailBody");
```

> **重要**: `String`で取得するとカラム内容が全てヒープに展開される。大量データでヒープ圧迫→システムダウンの原因となる。大量データは`Clob`オブジェクトを使用し、ストリーム経由で順次読み込むこと。

```java
SqlResultSet rows = select.retrieve();
Clob mailBody = (Clob) rows.get(0).get("mailBody");
try (Reader reader = mailBody.getCharacterStream()) {
  // Readerから順次読み込み（ヒープ上に全保持するとヒープ圧迫するので注意）
}
```

**CLOB型に値を登録・更新する:**

小サイズ: `SqlPStatement#setString`

```java
statement.setString(1, "値");
statement.executeUpdate();
```

大サイズ: `SqlPStatement#setCharacterStream`で`Reader`経由で送信。

```java
Path path = Paths.get(filePath);
try (Reader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
  statement.setCharacterStream(1, reader, (int) Files.size(path));
}
```

## データベースアクセス時に発生する例外の種類

データベースアクセス時の例外は4種類。全て非チェック例外のため`SQLException`のように`try-catch`で捕捉する必要はない。

**1. データベースアクセスエラー時の例外:**
`DbAccessException`が送出される。

**2. データベース接続エラー時の例外:**
`DbConnectionException`が送出される。:ref:`retry_handler`により処理される（:ref:`retry_handler`未適用の場合は実行時例外として扱われる）。接続エラー判定には:ref:`database-dialect`が使用される。

**3. SQL実行時の例外:**
`SqlStatementException`が送出される。

**4. 一意制約違反の例外:**
`DuplicateStatementException`が送出される。ハンドリング方法は:ref:`database-duplicated_error`を参照。一意制約違反判定には:ref:`database-dialect`が使用される。

> **補足**: 例外をより細かく分けたい場合は:ref:`database-change_exception`を参照。

## 一意制約違反をハンドリングして処理を行う

一意制約違反をハンドリングする場合、`DuplicateStatementException`を`try-catch`で捕捉して処理する。一意制約違反判定には:ref:`database-dialect`が使用される。

> **重要**: DB製品によってはSQL実行時の例外発生後、ロールバックまで一切のSQLを受け付けないものがあるので注意。そのような製品では他の手段を検討すること。例: 登録処理で一意制約違反発生時に更新したい場合、例外ハンドリングではなく`merge`文を使用すれば回避できる。

## 処理が長いトランザクションはエラーとして処理を中断させる

トランザクション管理で実現する。詳細は:ref:`transaction-timeout`を参照。

## 現在のトランザクションとは異なるトランザクションでSQLを実行する

個別トランザクションを使用する方法。業務処理失敗時でもDB変更を確定したい場合に使用。

**手順:**

1. コンポーネント設定ファイルに`SimpleDbTransactionManager`を定義
2. システムリポジトリから取得し、新たなトランザクションでSQLを実行（設定して使用してもよい）

> **注意**: `SimpleDbTransactionManager`を直接使うのではなく、`SimpleDbTransactionExecutor`を使用すること。

**コンポーネント設定ファイル:**

```xml
<component name="update-login-failed-count-transaction" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
  <property name="connectionFactory" ref="connectionFactory" />
  <property name="transactionFactory" ref="transactionFactory" />
  <property name="dbTransactionName" value="update-login-failed-count-transaction" />
</component>
```

**プロパティ:**
- `connectionFactory`: `ConnectionFactory`実装クラス（詳細は:ref:`database-connect`）
- `transactionFactory`: `TransactionFactory`実装クラス（詳細は:ref:`transaction-database`）
- `dbTransactionName`: トランザクションを識別する名前

**実装例:**

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

## 検索結果をキャッシュする

検索結果をキャッシュして、更新頻度が低いデータや最新性が厳密でないデータへのDB負荷を軽減できる。

**適用例**:
- 売上ランキングのように厳密な最新性が不要で大量参照されるデータ
- 夜間のみ更新され日中は更新されないデータ

**制約**:

LOB型（BLOB/CLOB）について:
- LOB列を取得すると実データではなくLOBロケータが取得される
- LOBロケータの有効期間はRDBMS実装に依存し、通常は `ResultSet` や `Connection` のクローズ時に無効化される
- ResultSet/Connectionより生存期間が長いキャッシュにはBLOB/CLOB型を含められない

アプリケーション冗長化について:
- デフォルトの `InMemoryResultSetCache` はJVMヒープにキャッシュを保持
- 冗長化構成では各アプリケーションごとにキャッシュされる
- キャッシュタイミングが異なると各アプリで異なるキャッシュを保持する可能性がある
- ラウンドロビンロードバランシングでは、リクエストごとに異なるサーバにアクセスし、結果が異なる可能性があるため注意

> **重要**: この機能は参照系DBアクセスの省略によるシステム負荷軽減が目的。SQL高速化目的では使用せず、SQLチューニングを実施すること。

> **重要**: DB値の更新監視やキャッシュ自動更新は行わない。常に最新データが必要な機能では使用しないこと。

**設定手順**:

1. クエリ結果キャッシュコンポーネントの定義
2. SQLID毎のキャッシュ設定
3. キャッシュ可能SQL実行コンポーネントの定義

**1. クエリ結果キャッシュコンポーネント**

**クラス**: `InMemoryResultSetCache`

```xml
<component name="resultSetCache" class="nablarch.core.db.cache.InMemoryResultSetCache">
  <property name="cacheSize" value="100"/>
  <property name="systemTimeProvider" ref="systemTimeProvider"/>
</component>
```

**2. SQLID毎のキャッシュ設定**

**クラス**: `BasicExpirationSetting`

有効期限単位: `ms`(ミリ秒), `sec`(秒), `min`(分), `h`(時)

```xml
<component name="expirationSetting" class="nablarch.core.cache.expirable.BasicExpirationSetting">
  <property name="expiration">
    <map>
      <entry key="please.change.me.tutorial.ss11AA.W11AA01Action#SELECT" value="100ms"/>
      <entry key="please.change.me.tutorial.ss11AA.W11AA02Action#SELECT" value="30sec"/>
    </map>
  </property>
</component>
```

**3. キャッシュ可能SQL実行コンポーネント**

**クラス**: `CacheableStatementFactory`

`BasicStatementFactory` を継承しており、基本設定値は同じ。

プロパティ:
- `expirationSetting`: 上記のBasicExpirationSettingコンポーネント
- `resultSetCache`: 上記のInMemoryResultSetCacheコンポーネント

このコンポーネントは :ref:`database-connect` で定義したDB接続取得コンポーネントに設定すること。

```xml
<component name="cacheableStatementFactory" class="nablarch.core.db.cache.statement.CacheableStatementFactory">
  <property name="expirationSetting" ref="expirationSetting"/>
  <property name="resultSetCache" ref="resultSetCache"/>
</component>
```

**実装**: キャッシュ有無でDBアクセスコードは変わらない。:ref:`database-execute_sqlid` や :ref:`database-input_bean` と同様に実装する。

## java.sql.Connectionを使って処理を行う

JDBCネイティブなDB接続 (`Connection`) を使う場合、`DbConnectionContext` から取得した `TransactionManagerConnection` 経由で取得する。

**用途例**: `DatabaseMetaData` の使用

> **重要**: `Connection` 使用時は `SQLException` のハンドリングが必要。例外制御を誤ると障害が検知されない、調査できないなどの問題が発生する。この機能を使わないと満たせない要件がない限り使用しないこと。

```java
TransactionManagerConnection managerConnection = DbConnectionContext.getTransactionManagerConnection();
Connection connection = managerConnection.getConnection();
return connection.getMetaData();
```

## SQL文中のスキーマを環境毎に切り替える

環境によって参照スキーマが異なる場合、SQL文中の `#SCHEMA#` プレースホルダーを環境ごとに置き換えられる。

**ユースケース**:

| 環境 | TABLE1のスキーマ |
|---|---|
| 本番環境 | A_SCHEMA |
| テスト環境 | B_SCHEMA |

このような場合、SQL文にスキーマ名を直接記述できない。

**SQL記述例**:

```sql
-- #SCHEMA#プレースホルダーを使用
SELECT * FROM #SCHEMA#.TABLE1
```

> **注意**: プレースホルダー文字列 `#SCHEMA#` は固定であり、カスタマイズできない。

**設定**:

`BasicSqlLoader` に `SchemaReplacer` を設定する。

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

`schemaName` プロパティに置換後の値を設定する。上記例では環境依存値 `nablarch.schemaReplacer.schemaName` に設定している（切替方法は :ref:`how_to_switch_env_values` を参照）。

> **補足**: スキーマ置換は単純な文字列置換。スキーマ存在チェックやSQL妥当性チェックは行わない（SQL実行時にエラーとなる）。

## 拡張例

**データベース接続方法の追加**

OSSコネクションプールライブラリなど、接続方法を追加する場合:

1. `ConnectionFactorySupport` を継承してDB接続生成クラスを作成
2. 作成したクラスをコンポーネント設定ファイルに設定（:ref:`database-connect` 参照）

**ダイアレクトの追加**

使用するDB製品に対応したダイアレクトがない場合、特定機能の使用可否を切り替えたい場合:

1. `DefaultDialect` を継承してDB製品対応ダイアレクトを作成
2. 作成したダイアレクトをコンポーネント設定ファイルに設定（:ref:`database-use_dialect` 参照）

**DBアクセス例外クラスの切り替え**

デッドロックエラーの例外クラス変更など、例外クラスを切り替える場合:

1. `DbAccessExceptionFactory` の実装クラスを作成
2. `SqlStatementExceptionFactory` の実装クラスを作成
3. 作成したクラスをコンポーネント設定ファイルに定義

**詳細手順**:

**DbAccessExceptionFactoryの実装**

DB接続取得時およびトランザクション制御時（commit/rollback）に発生させる `DbAccessException` を変更する場合、このインタフェースを実装する。

設定: :ref:`database-connect` で定義したDB接続取得コンポーネントに設定

```xml
<component class="sample.SampleDbAccessExceptionFactory" />
```

**SqlStatementExceptionFactoryの実装**

SQL実行時に発生させる `SqlStatementException` を変更する場合、このインタフェースを実装する。

設定: `BasicStatementFactory` に設定（BasicStatementFactoryは :ref:`database-connect` で定義したDB接続取得コンポーネントに設定）

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
  <property name="sqlStatementExceptionFactory">
    <component class="sample.SampleStatementExceptionFactory" />
  </property>
</component>
```
