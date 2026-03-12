# ユニバーサルDAO

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/BasicDaoContextFactory.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/DeferredEntityList.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/Pagination.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/EntityList.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/dialect/Dialect.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnError.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/transaction/SimpleDbTransactionManager.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/ConnectionFactory.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/TransactionFactory.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.Transaction.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/java/sql/DatabaseMetaData.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/DatabaseMetaDataExtractor.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/dialect/H2Dialect.html)

## 機能概要

Jakarta Persistenceアノテーションを使った簡易的なO/Rマッパー。内部で [database](libraries-database.md) を使用しているため、 [database](libraries-database.md) の設定が必要。

> **補足**: 簡易的なO/Rマッパーであり、すべてのDBアクセスをユニバーサルDAOで実現することを想定していない。実現できない場合は [database](libraries-database.md) を使うこと。主キー以外の条件での更新/削除は [database](libraries-database.md) を使用する必要がある。

> **補足**: 共通項目（登録ユーザ、更新ユーザ等）への値の自動設定機能は提供しない。自動設定が必要な場合は [doma_adaptor](../adapters/adapters-doma_adaptor.md) を適用し、Domaのエンティティリスナー機能を使用すること。どうしてもユニバーサルDAOを使用する場合は、アプリケーションで明示的に共通項目を設定すること。

## SQLを書かなくても単純なCRUDができる

Jakarta PersistenceアノテーションをEntityに付けるだけで以下のCRUD操作が可能（SQL文は実行時に自動構築）:

- 登録/一括登録
- 主キーを指定した更新/一括更新
- 主キーを指定した削除/一括削除
- 主キーを指定した検索

使用できるJakarta Persistenceアノテーションは :ref:`universal_dao_jpa_annotations` を参照。

> **補足**: `@Table` アノテーションでスキーマ指定可能。ただし [database](libraries-database.md) の [database-replace_schema](libraries-database.md) 機能はユニバーサルDAOのCRUD機能では使用不可。環境毎にスキーマを切り替える用途には [database](libraries-database.md) を使うこと。

## 検索結果をBeanにマッピングできる

SQLファイルとSQL IDを指定した検索で、結果をBean（Entity、Form、DTO）にマッピングして取得できる。Beanのプロパティ名とSELECT句の名前が一致する項目をマッピングする。

使用できるデータタイプは :ref:`universal_dao_bean_data_types` を参照。

データサイズの大きいバイナリデータ（例：OracleのBLOB）は、ユニバーサルDAOではデータをすべてメモリに展開しないと登録・更新できない。データベースが提供する機能を使ってファイルなどから直接登録・更新すること。

詳細: [database-binary_column](libraries-database.md)

> **重要**: ここに記載のないデータタイプに対して、検索結果をマッピングできない（実行時例外となる）。

| データタイプ | 備考 |
|---|---|
| `java.lang.String` | |
| `java.lang.Short` | プリミティブ型も可。`null`は`0`として扱う。 |
| `java.lang.Integer` | プリミティブ型も可。`null`は`0`として扱う。 |
| `java.lang.Long` | プリミティブ型も可。`null`は`0`として扱う。 |
| `java.math.BigDecimal` | |
| `java.lang.Boolean` | プリミティブ型も可。`null`は`false`として扱う。ラッパー型（Boolean）はリードメソッド名がgetから始まる必要あり。プリミティブ型はisでも可。 |
| `java.util.Date` | `@Temporal` でDB上のデータ型を指定する必要あり。 |
| `java.sql.Date` | |
| `java.sql.Timestamp` | |
| `java.time.LocalDate` | |
| `java.time.LocalDateTime` | |
| `byte[]` | BLOBなど非常に大きいサイズのデータはヒープ上に展開しないよう注意。大きいバイナリデータはデータベースアクセスを直接使用してStream経由で参照すること。詳細は `database-binary_column` を参照。 |

<details>
<summary>keywords</summary>

ユニバーサルDAO, O/Rマッパー, CRUD, Beanマッピング, Jakarta Persistence, 共通項目自動設定, doma_adaptor, @Table, BLOBデータ登録, バイナリデータ, 大容量バイナリデータ, Oracle BLOB, database-binary_column, java.lang.String, java.lang.Short, java.lang.Integer, java.lang.Long, java.math.BigDecimal, java.lang.Boolean, java.util.Date, java.sql.Date, java.sql.Timestamp, java.time.LocalDate, java.time.LocalDateTime, byte[], @Temporal, Beanデータタイプ, 検索結果マッピング, UniversalDAO Bean型

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-dao</artifactId>
</dependency>
```

データサイズの大きいテキストデータ（例：OracleのCLOB）は、ユニバーサルDAOではデータをすべてメモリに展開しないと登録・更新できない。データベースが提供する機能を使ってファイルなどから直接登録・更新すること。

詳細: [database-clob_column](libraries-database.md)

<details>
<summary>keywords</summary>

nablarch-common-dao, com.nablarch.framework, Maven依存関係, CLOBデータ登録, テキストデータ, 大容量テキストデータ, Oracle CLOB, database-clob_column

</details>

## ユニバーサルDAOを使うための設定を行う

[database](libraries-database.md) の設定に加えて、 `BasicDaoContextFactory` をコンポーネント定義に追加する。コンポーネント名は `daoContextFactory` で設定すること。

```xml
<component name="daoContextFactory" class="nablarch.common.dao.BasicDaoContextFactory" />
```

> **重要**: 基本的な使い方は `UniversalDao` のJavadocを参照。

現在のトランザクションとは異なるトランザクションでユニバーサルDAOを実行する手順:

1. コンポーネント設定ファイルに `SimpleDbTransactionManager` を定義する
2. `UniversalDao.Transaction` を継承したクラスを作成し、`execute()` メソッドに処理を実装して呼び出す

> **重要**: `SimpleDbTransactionManager` を直接使わず、 `UniversalDao.Transaction` でトランザクション制御を行うこと。

## コンポーネント設定

`connectionFactory` プロパティに `ConnectionFactory` 実装クラスを設定する（詳細は [database-connect](libraries-database.md) 参照）。`transactionFactory` プロパティに `TransactionFactory` 実装クラスを設定する（詳細は [transaction-database](libraries-transaction.md) 参照）。`dbTransactionName` プロパティにはトランザクションを識別するための名前を設定する。

```xml
<component name="find-persons-transaction"
    class="nablarch.core.db.transaction.SimpleDbTransactionManager">
  <!-- connectionFactoryプロパティにConnectionFactory実装クラスを設定する -->
  <property name="connectionFactory" ref="connectionFactory" />
  <!-- transactionFactoryプロパティにTransactionFactory実装クラスを設定する -->
  <property name="transactionFactory" ref="transactionFactory" />
  <!-- トランザクションを識別するための名前を設定する -->
  <property name="dbTransactionName" value="update-login-failed-count-transaction" />
</component>
```

## 実装例

`UniversalDao.Transaction` を継承し `execute()` に処理を実装する。`super()` にコンポーネント定義名またはSimpleDbTransactionManagerオブジェクトを指定する。正常終了でコミット、例外・エラーでロールバック。

```java
private static final class FindPersonsTransaction extends UniversalDao.Transaction {
    private EntityList<Person> persons;

    FindPersonsTransaction() {
        super("find-persons-transaction");
    }

    @Override
    protected void execute() {
        persons = UniversalDao.findAllBySqlFile(Person.class, "FIND_PERSONS");
    }

    public EntityList<Person> getPersons() {
        return persons;
    }
}

// 生成すると別のトランザクションで実行される。
FindPersonsTransaction findPersonsTransaction = new FindPersonsTransaction();

// 結果を取得する。
EntityList<Person> persons = findPersonsTransaction.getPersons();
```

<details>
<summary>keywords</summary>

BasicDaoContextFactory, daoContextFactory, コンポーネント定義, 初期設定, SimpleDbTransactionManager, UniversalDao.Transaction, 個別トランザクション, 別トランザクション実行, connectionFactory, transactionFactory, dbTransactionName, ConnectionFactory, TransactionFactory

</details>

## 任意のSQL(SQLファイル)で検索する

任意のSQLで検索する場合は、SQLファイルを作成しSQL IDを指定して検索する。

```java
UniversalDao.findAllBySqlFile(User.class, "FIND_BY_NAME");
```

**SQLファイルパスの導出ルール**: 検索結果をマッピングするBeanのクラスから導出する。`sample.entity.User` の場合、クラスパス配下の `sample/entity/User.sql` となる。

SQL IDに「#」を含めると「SQLファイルのパス#SQL ID」と解釈する:

```java
// sample/entity/Member.sql の FIND_BY_NAME を実行
UniversalDao.findAllBySqlFile(GoldUser.class, "sample.entity.Member#FIND_BY_NAME");
```

> **補足**: 「#」の指定は機能単位（Actionハンドラ単位）にSQLを集約したい場合に使用できるが、指定が煩雑になるため基本は「#」なしの指定を使用すること。

データベースによっては、シノニムを使用している場合や権限の問題で、 `java.sql.DatabaseMetaData` から主キー情報を取得できない場合がある。主キー情報を取得できなくなると、主キーを指定した検索が正しく動作しない。

そのような場合は、 `DatabaseMetaDataExtractor` を継承したクラスを作成して対応する。主キー情報をどのように取得するかはデータベース依存のため、製品のマニュアルを参照すること。

作成したクラスを使用するには、コンポーネント設定ファイルへの登録が必要。コンポーネント名は **`databaseMetaDataExtractor`** で設定すること。

```xml
<!--
sample.dao.CustomDatabaseMetaDataExtractorを作成した場合の設定例
コンポーネント名は"databaseMetaDataExtractor"で設定する。
-->
<component name="databaseMetaDataExtractor" class="sample.dao.CustomDatabaseMetaDataExtractor" />
```

<details>
<summary>keywords</summary>

findAllBySqlFile, SQLファイル, SQL ID, SQLファイルパス導出, 任意SQL検索, DatabaseMetaDataExtractor, java.sql.DatabaseMetaData, シノニム, 主キー情報取得, databaseMetaDataExtractor, 権限問題, 主キー検索

</details>

## テーブルをJOINした検索結果を取得する

複数テーブルをJOINした結果を取得する場合は、JOIN対象データを個別に検索せず、**1回で検索できるSQL** と **JOINした結果をマッピングするBean** を作成すること（個別検索は非効率）。

[ページング](#s8) 処理では、実際の範囲指定レコードの取得処理の前に、件数取得SQLが発行される。件数取得SQLは、デフォルトでは元のSQLを `SELECT COUNT(*) FROM` で包んだSQLとなる。元のSQLが `ORDER BY` 句を含むなど処理負荷が大きいSQLで、負荷軽減のために `ORDER BY` 句を外したい場合などに、使用しているダイアレクトをカスタマイズして件数取得SQLを変更できる。

> **重要**: 件数取得SQLは、元のSQLと同一の検索条件を持つ必要がある。件数取得SQLを用意する場合は、両者の検索条件に差分が発生しないよう注意すること。

件数取得SQLを変更する場合は、プロジェクトで使用しているダイアレクトを継承した上で、 `Dialect#convertCountSql(String, Object, StatementFactory)` の実装を変更する。

## 実装例

以下に `H2Dialect` をカスタマイズする例を示す。元のSQLと件数取得SQLのマッピングをコンポーネントに設定し、件数取得SQLを変更している。プロジェクトごとに適切なマッピングルールを検討すること。

```java
public class CustomH2Dialect extends H2Dialect {

    /**
     * 件数取得SQLのマッピング
     */
    private Map<String, String> sqlMap;

    /**
     * 件数取得SQLのマッピング内に{@code sqlId}に対応するSQLIDが存在すれば、
     * それを件数取得SQLとして返却する。
     */
    @Override
    public String convertCountSql(String sqlId, Object params, StatementFactory statementFactory) {
        if (sqlMap.containsKey(sqlId)) {
            return statementFactory.getVariableConditionSqlBySqlId(sqlMap.get(sqlId), params);
        }
        return convertCountSql(statementFactory.getVariableConditionSqlBySqlId(sqlId, params));
    }

    public void setSqlMap(Map<String, String> sqlMap) {
        this.sqlMap = sqlMap;
    }
}
```

カスタマイズしたダイアレクトはコンポーネント設定ファイルで設定する。`sqlMap` プロパティで元のSQLIDと件数取得SQLIDのマッピングを設定する。

```xml
<component name="dialect" class="com.nablarch.example.app.db.dialect.CustomH2Dialect">
  <property name="sqlMap">
    <map>
      <entry key="com.nablarch.example.app.entity.Project#SEARCH_PROJECT"
             value="com.nablarch.example.app.entity.Project#SEARCH_PROJECT_FORCOUNT"/>
    </map>
  </property>
</component>
```

<details>
<summary>keywords</summary>

JOIN, 複数テーブル, 一覧検索, JOINマッピング, 件数取得SQL, SELECT COUNT(*), convertCountSql, Dialect, H2Dialect, ページング, ORDER BY, カスタムダイアレクト, sqlMap, StatementFactory

</details>

## 検索結果を遅延ロードする

大量の検索結果を扱う場合（Webでの大量データダウンロード、バッチでの大量データ処理など）は遅延ロードを使用する。

遅延ロードを使用すると、ユニバーサルDAOとしては1件ずつロードするが、JDBCのフェッチサイズによってメモリの使用量が変わる。フェッチサイズの詳細はデータベースベンダー提供のマニュアルを参照。

遅延ロードは `UniversalDao#defer` メソッドを先に呼び出すことで使用可能。内部でサーバサイドカーソルを使用するため、 `DeferredEntityList#close` の呼び出しが必要。

```java
try (DeferredEntityList<User> users
        = (DeferredEntityList<User>) UniversalDao.defer()
                                        .findAllBySqlFile(User.class, "FIND_BY_NAME")) {
    for (User user : users) {
        // userを使った処理
    }
}
```

> **重要**: 使用するRDBMSによっては、カーソルオープン中にトランザクション制御が行われるとカーソルがクローズされる。遅延ロード中にトランザクション制御を行うとクローズ済みカーソルを参照しエラーとなる可能性がある。DBベンダーのマニュアルに沿ってカーソルの挙動を調整するか、 [ページング](#s8) などで回避すること。

> **重要**: ここに記載のないアノテーション及び属性を使用しても機能しない。

フィールドにアノテーションを設定する場合の制約:
- `@Access` で明示的にフィールド指定した場合のみフィールドのアノテーションを参照する
- UniversalDaoでは値の取得・設定はプロパティ経由のため、getterとsetterは必ず作成すること
- フィールド名とプロパティ名（get○○/set○○の○○部分）を必ず同じにすること

> **補足**: LombokなどのBoilerplate生成ライブラリを使う場合、フィールドにアノテーションを設定することでgetterの自作が不要になる。

## クラスに設定するアノテーション

**アノテーション**: `@Entity` (`jakarta.persistence.Entity`)

テーブルに対応したEntityクラスに設定。クラス名（パスカルケース）をスネークケース（全て大文字）に変換したものがテーブル名（`Book` → `BOOK`、`BookAuthor` → `BOOK_AUTHOR`）。テーブル名を導出できない場合は `@Table` で明示指定すること。

**アノテーション**: `@Table` (`jakarta.persistence.Table`)

- `name` 属性: テーブル名を明示指定
- `schema` 属性: スキーマ名を修飾子として指定（例: `schema="work"`、テーブル名 `users_work` → `work.users_work` にアクセス）

**アノテーション**: `@Access` (`jakarta.persistence.Access`)

明示的にフィールド指定した場合のみフィールドのアノテーションを参照する。

## getterまたはフィールドに設定するアノテーション

**アノテーション**: `@Column` (`jakarta.persistence.Column`)

- `name` 属性: カラム名を明示指定。未設定時はプロパティ名から `@Entity` と同様の変換（パスカルケース→スネークケース大文字）でカラム名を導出

**アノテーション**: `@Id` (`jakarta.persistence.Id`)

主キーに設定。複合主キーの場合は複数のgetter/フィールドに設定。

**アノテーション**: `@Version` (`jakarta.persistence.Version`)

楽観ロック用バージョンカラムに設定。数値型のプロパティのみ指定可（文字列型では正しく動作しない）。更新処理時にバージョンカラムが条件に自動追加され楽観ロックが実行される。Entity内に1つのみ指定可。

**アノテーション**: `@Temporal` (`jakarta.persistence.Temporal`)

`java.util.Date` および `java.util.Calendar` 型をDBにマッピングする方法を指定。`value` 属性に指定されたDB型にJavaオブジェクトを変換してDBに登録。

**アノテーション**: `@GeneratedValue` (`jakarta.persistence.GeneratedValue`)

自動採番値を登録。`strategy` 属性に採番方法を設定する。`AUTO` の採番方法選択ルール:
1. `generator` 属性に対応するGenerator設定がある場合、そのGeneratorを使用
2. `generator` 未設定または対応Generator設定なしの場合、データベース機能に設定された `Dialect` を元にIDENTITY→SEQUENCE→TABLEの順で選択

`generator` 属性に任意の名前を設定する。シーケンスオブジェクト名やテーブル採番レコード識別値を取得できない場合、テーブル名と採番カラム名から導出（例: テーブル `USER`、カラム `ID` → `USER_ID`）。

**アノテーション**: `@SequenceGenerator` (`jakarta.persistence.SequenceGenerator`)

シーケンス採番を使用する場合に設定。
- `name` 属性: `@GeneratedValue` の `generator` 属性と同じ値を設定
- `sequenceName` 属性: DBに作成されているシーケンスオブジェクト名を設定
- 別途 [採番用の設定](libraries-generator.md) が必要

**アノテーション**: `@TableGenerator` (`jakarta.persistence.TableGenerator`)

テーブル採番を使用する場合に設定。
- `name` 属性: `@GeneratedValue` の `generator` 属性と同じ値を設定
- `pkColumnValue` 属性: 採番テーブルのレコードを識別するための値を設定
- 別途 [採番用の設定](libraries-generator.md) が必要

<details>
<summary>keywords</summary>

DeferredEntityList, UniversalDao.defer, 遅延ロード, 大量データ, サーバサイドカーソル, フェッチサイズ, @Entity, @Table, @Access, @Column, @Id, @Version, @Temporal, @GeneratedValue, @SequenceGenerator, @TableGenerator, 楽観ロック, 自動採番, シーケンス採番, テーブル採番, sequenceName, pkColumnValue, generator, strategy, Dialect

</details>

## 条件を指定して検索する

検索条件を指定してSQLファイルで検索できる。

```java
ProjectSearchForm condition = context.getRequestScopedVar("form");
List<Project> projects = UniversalDao.findAllBySqlFile(
    Project.class, "SEARCH_PROJECT", condition);
```

> **重要**: 検索条件はEntityではなく検索条件を持つ専用のBeanを指定すること。ただし1つのテーブルのみへのアクセスの場合はEntityを指定しても良い。

<details>
<summary>keywords</summary>

findAllBySqlFile, 検索条件, 条件検索, 専用Bean

</details>

## 型を変換する

:ref:`@Temporal <universal_dao_jpa_temporal>` を使用して `java.util.Date` および `java.util.Calendar` 型の値をDBにマッピングする方法を指定できる。他の型は任意マッピング不可のため、DBの型とJDBCドライバの仕様に応じてEntityプロパティの型を定義すること。

**自動生成SQLを実行する場合の型変換**:

- DBへの出力時: `@Temporal` 設定プロパティは指定された型へ変換。それ以外は [database](libraries-database.md) に委譲。
- DBからの取得時: `@Temporal` 設定プロパティは指定された型から変換。それ以外はEntityの情報を元に変換。

**任意のSQLで検索する場合の型変換**:

- DBへの出力時: [database](libraries-database.md) に処理を委譲。
- DBからの取得時: 自動生成SQLの場合と同様の処理。

> **重要**: DBの型とプロパティの型が不一致の場合、実行時に型変換エラーが発生する場合がある。また暗黙的型変換によるインデックス未使用で性能劣化が発生する可能性がある。DBとJavaのデータタイプのマッピングはJDBCドライバのマニュアルを参照すること（例: DBがdate型の場合プロパティ型は `java.sql.Date`、数値型(integer/bigint/number)の場合は `int`/`long`）。

<details>
<summary>keywords</summary>

@Temporal, java.util.Date, java.util.Calendar, 型変換, java.sql.Date, 暗黙的型変換, universal_dao_jpa_temporal

</details>

## ページングを行う

`UniversalDao#per` メソッドと `UniversalDao#page` メソッドを先に呼び出すことでページングが使用可能。

```java
EntityList<User> users = UniversalDao.per(3).page(1)
                            .findAllBySqlFile(User.class, "FIND_ALL_USERS");
```

ページング表示に必要な件数情報は `Pagination` が保持。 `EntityList` から取得可能:

```java
Pagination pagination = users.getPagination();
```

> **補足**: ページング用の検索処理は [データベースアクセス(JDBCラッパー)の範囲指定検索機能](libraries-database.md) を使用する。

> **補足**: 実際の範囲指定レコード取得の前に件数取得SQLが発行される。件数取得SQLによる性能劣化が発生した場合は [universal_dao-customize_sql_for_counting](#) を参照して件数取得SQLを変更すること。

<details>
<summary>keywords</summary>

UniversalDao.per, UniversalDao.page, Pagination, EntityList, ページング, 件数取得SQL

</details>

## サロゲートキーを採番する

サロゲートキー採番には以下のアノテーションを使用する:
- :ref:`@GeneratedValue <universal_dao_jpa_generated_value>`
- :ref:`@SequenceGenerator <universal_dao_jpa_sequence_generator>`
- :ref:`@TableGenerator <universal_dao_jpa_table_generator>`

`jakarta.persistence.GenerationType` のすべてのストラテジをサポート。

**GenerationType.AUTO**: `Dialect` の設定を元に採番方法を選択。優先順位: IDENTITY→SEQUENCE→TABLE。SEQUENCEが選択された場合、シーケンスオブジェクト名は `<テーブル名>_<採番するカラム名>` となる。シーケンスオブジェクト名を指定したい場合は :ref:`@SequenceGenerator <universal_dao_jpa_sequence_generator>` で指定。

```java
@Id
@Column(name = "USER_ID", length = 15)
@GeneratedValue(strategy = GenerationType.AUTO)
public Long getId() { return id; }
```

**GenerationType.IDENTITY**:

```java
@Id
@Column(name = "USER_ID", length = 15)
@GeneratedValue(strategy = GenerationType.IDENTITY)
public Long getId() { return id; }
```

**GenerationType.SEQUENCE**: シーケンスオブジェクト名は :ref:`@SequenceGenerator <universal_dao_jpa_sequence_generator>` で指定。`sequenceName` 属性を省略した場合は `<テーブル名>_<採番するカラム名>` となる。

```java
@Id
@Column(name = "USER_ID", length = 15)
@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq")
@SequenceGenerator(name = "seq", sequenceName = "USER_ID_SEQ")
public Long getId() { return id; }
```

**GenerationType.TABLE**: レコードを識別する値は :ref:`@TableGenerator <universal_dao_jpa_table_generator>` で指定。`pkColumnValue` 属性を省略した場合は `<テーブル名>_<採番するカラム名>` となる。

```java
@Id
@Column(name = "USER_ID", length = 15)
@GeneratedValue(strategy = GenerationType.TABLE, generator = "table")
@TableGenerator(name = "table", pkColumnValue = "USER_ID")
public Long getId() { return id; }
```

> **補足**: シーケンス及びテーブルを使用したサロゲートキーの採番処理は [generator](libraries-generator.md) を使用する。設定値（テーブル名やカラム名など）はリンク先を参照。

<details>
<summary>keywords</summary>

@GeneratedValue, @SequenceGenerator, @TableGenerator, GenerationType, Dialect, サロゲートキー, シーケンス採番

</details>

## バッチ実行(一括登録、更新、削除)を行う

大量データの一括登録・更新・削除にバッチ実行が使用可能。アプリケーションサーバとDBサーバ間のラウンドトリップ回数を削減しパフォーマンス向上が期待できる。

使用するメソッド:
- `batchInsert`
- `batchUpdate`
- `batchDelete`

> **重要**: `batchUpdate` による一括更新では排他制御を行わない。更新対象EntityとDBのバージョンが不一致でも、そのレコードの更新は行われずに正常終了する。排他制御が必要な更新処理では、一括更新ではなく1レコード毎の更新処理を使用すること。

<details>
<summary>keywords</summary>

batchInsert, batchUpdate, batchDelete, 一括登録, 一括更新, 一括削除

</details>

## 楽観的ロックを行う

:ref:`@Version <universal_dao_jpa_version>` が付いているEntityを更新すると自動で楽観的ロックを行う。排他エラー発生時は `jakarta.persistence.OptimisticLockException` を送出する。

> **重要**: :ref:`@Version <universal_dao_jpa_version>` は数値型のプロパティのみに指定可能。文字列型では正しく動作しない。

排他エラー時の画面遷移は `OnError` を使用:

```java
@OnError(type = OptimisticLockException.class,
         path = "/WEB-INF/view/common/errorPages/userError.jsp")
public HttpResponse update(HttpRequest request, ExecutionContext context) {
    UniversalDao.update(user);
}
```

> **重要**: [universal_dao-batch_execute](#s10) に記載の通り、一括更新処理（`batchUpdate`）では楽観的ロックは使用できない。

<details>
<summary>keywords</summary>

@Version, OptimisticLockException, OnError, 楽観的ロック, 排他制御

</details>

## 悲観的ロックを行う

ユニバーサルDAOでは悲観的ロックの機能を特に提供していない。

悲観的ロックはDBの行ロック（`SELECT FOR UPDATE`）を使用する。行ロックのSQLは `UniversalDao#findBySqlFile` メソッドを使って実行する。

<details>
<summary>keywords</summary>

findBySqlFile, SELECT FOR UPDATE, 悲観的ロック, 行ロック

</details>

## 排他制御の考え方

バージョンカラムをどのテーブルに定義するかは業務的な観点で決める必要がある。

バージョン番号を持つテーブルは排他制御の単位ごとに定義し、競合が許容される最大の単位で定義する。例えば「ユーザ」単位でのロックが業務的に許容されるならユーザテーブルにバージョン番号を定義する。単位を大きくすると競合の可能性が高くなり、更新失敗（楽観的ロックの場合）や処理遅延（悲観的ロックの場合）を招く点に注意すること。

<details>
<summary>keywords</summary>

バージョンカラム, 排他制御, ロック単位, 競合, 楽観的ロック, 悲観的ロック

</details>
