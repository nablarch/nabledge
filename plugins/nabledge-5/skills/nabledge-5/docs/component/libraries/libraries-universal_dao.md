# ユニバーサルDAO

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/BasicDaoContextFactory.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/DeferredEntityList.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/Pagination.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/EntityList.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/javax/persistence/GenerationType.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/javax/persistence/OptimisticLockException.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnError.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/dialect/Dialect.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/transaction/SimpleDbTransactionManager.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/connection/ConnectionFactory.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/TransactionFactory.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.Transaction.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/DatabaseMetaDataExtractor.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/dialect/H2Dialect.html)

## 機能概要

JPA 2.0のアノテーションを使った簡易O/Rマッパーを提供する。内部では [database](libraries-database.md) を使用するため、使用前に [database](libraries-database.md) の設定が必要。

> **補足**: ユニバーサルDAOは簡易O/Rマッパーと位置付けており、実現できない場合は [database](libraries-database.md) を使うこと。例えば、主キー以外の条件を指定した更新/削除は行えないため [database](libraries-database.md) を使用する必要がある。

> **補足**: 共通項目（全テーブルに定義する登録ユーザや更新ユーザ等）への値の自動設定機能は提供しない。自動設定が必要な場合は [doma_adaptor](../adapters/adapters-doma_adaptor.md) を適用し、Domaのエンティティリスナー機能を使用すること。どうしてもユニバーサルDAOを使用する場合は、機能使用前にアプリケーションで明示的に共通項目を設定すること。

## SQLを書かなくても単純なCRUDができる

JPAアノテーションをEntityに付けるだけで以下の単純なCRUDができる（SQLは実行時に構築）:
- 登録/一括登録
- 主キーを指定した更新/一括更新
- 主キーを指定した削除/一括削除
- 主キーを指定した検索

使用できるJPAアノテーションについては :ref:`universal_dao_jpa_annotations` を参照。

> **補足**: `@Table` アノテーションでスキーマを指定できるが、[database](libraries-database.md) の [database-replace_schema](libraries-database.md) 機能はユニバーサルDAOのCRUD機能では使用できない。環境毎にスキーマを切り替える用途には [database](libraries-database.md) を使用すること。

## 検索結果をBeanにマッピングできる

SQLファイルを作成しSQL IDを指定した検索ができる。検索結果をBean（Entity、Form、DTO）にマッピングして取得できる。Beanのプロパティ名とSELECT句の名前が一致する項目をマッピングする。

使用できるデータタイプについては :ref:`universal_dao_bean_data_types` を参照。

ユニバーサルDAOでは大きいバイナリデータ（OracleのBLOBなど）をすべてメモリに展開しないと登録・更新できない制約があるため、データベースが提供する機能を使ってファイルなどから直接登録（更新）すること。

> **重要**: ここに記載のないデータタイプは検索結果をマッピングできない（実行時例外となる）。

検索結果をBeanにマッピングできるデータタイプ:

| データタイプ | 備考 |
|---|---|
| `java.lang.String` | |
| `java.lang.Short` | プリミティブ型も可。プリミティブ型の場合、`null`は`0`として扱う |
| `java.lang.Integer` | プリミティブ型も可。プリミティブ型の場合、`null`は`0`として扱う |
| `java.lang.Long` | プリミティブ型も可。プリミティブ型の場合、`null`は`0`として扱う |
| `java.math.BigDecimal` | |
| `java.lang.Boolean` | プリミティブ型も可。プリミティブ型の場合、`null`は`false`として扱う。ラッパー型（Boolean）はリードメソッドがgetから始まる必要がある。プリミティブ型はisで始まるリードメソッドも可 |
| `java.util.Date` | :ref:`@Temporal <universal_dao_jpa_temporal>` でDB上のデータ型を指定する必要がある |
| `java.sql.Date` | |
| `java.sql.Timestamp` | |
| `byte[]` | 非常に大きいサイズのデータは本機能でヒープ上に展開しないこと。大きいバイナリデータはStream経由で参照すること（[database-binary_column](libraries-database.md) 参照） |

<details>
<summary>keywords</summary>

ユニバーサルDAO, O/Rマッパー, JPA, CRUD, Beanマッピング, database-replace_schema, 共通項目自動設定, doma_adaptor, @Table, バイナリデータ, BLOB, 大容量データ登録, メモリ制約, データベース機能直接登録, java.lang.String, java.lang.Short, java.lang.Integer, java.lang.Long, java.math.BigDecimal, java.lang.Boolean, java.util.Date, java.sql.Date, java.sql.Timestamp, byte[], @Temporal, Beanデータタイプ, 検索結果マッピング, nullマッピング

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-dao</artifactId>
</dependency>
```

ユニバーサルDAOでは大きいテキストデータ（OracleのCLOBなど）をすべてメモリに展開しないと登録・更新できない制約があるため、データベースが提供する機能を使ってファイルなどから直接登録（更新）すること。

<details>
<summary>keywords</summary>

nablarch-common-dao, モジュール依存関係, Maven, テキストデータ, CLOB, 大容量データ登録, メモリ制約, データベース機能直接登録

</details>

## ユニバーサルDAOを使うための設定を行う

[database](libraries-database.md) の設定に加えて、`BasicDaoContextFactory` のコンポーネント定義を追加する。コンポーネント名は `daoContextFactory` で設定する。

```xml
<component name="daoContextFactory" class="nablarch.common.dao.BasicDaoContextFactory" />
```

ユニバーサルDAOで現在のトランザクションとは異なるトランザクションを使用する手順:

1. コンポーネント設定ファイルに `SimpleDbTransactionManager` を定義する
2. `SimpleDbTransactionManager` を直接使わず、`UniversalDao.Transaction` を使用してUniversalDAOを実行する

> **重要**: `SimpleDbTransactionManager` は直接使用せず、`UniversalDao.Transaction` を使用すること。

**コンポーネント設定**

| プロパティ名 | 型 | 説明 |
|---|---|---|
| connectionFactory | ConnectionFactory | `ConnectionFactory` 実装クラス。[database-connect](libraries-database.md) 参照 |
| transactionFactory | TransactionFactory | `TransactionFactory` 実装クラス。[transaction-database](libraries-transaction.md) 参照 |
| dbTransactionName | String | トランザクション識別名 |

```xml
<component name="find-persons-transaction"
    class="nablarch.core.db.transaction.SimpleDbTransactionManager">
  <property name="connectionFactory" ref="connectionFactory" />
  <property name="transactionFactory" ref="transactionFactory" />
  <property name="dbTransactionName" value="update-login-failed-count-transaction" />
</component>
```

**実装**: `UniversalDao.Transaction` を継承したクラスを作成し、`execute()` メソッドにUniversalDAOの処理を実装する。`execute()` は自動的に別トランザクションで実行され、正常終了時はコミット、例外・エラー発生時はロールバックされる。

```java
private static final class FindPersonsTransaction extends UniversalDao.Transaction {
    private EntityList<Person> persons;

    FindPersonsTransaction() {
        // コンポーネント定義の名前またはSimpleDbTransactionManagerオブジェクトを指定
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

// 呼び出し
FindPersonsTransaction findPersonsTransaction = new FindPersonsTransaction();
EntityList<Person> persons = findPersonsTransaction.getPersons();
```

<details>
<summary>keywords</summary>

BasicDaoContextFactory, daoContextFactory, コンポーネント定義, 設定, SimpleDbTransactionManager, UniversalDao.Transaction, 個別トランザクション, トランザクション切り替え, connectionFactory, transactionFactory, dbTransactionName, ConnectionFactory, TransactionFactory

</details>

## 任意のSQL(SQLファイル)で検索する

SQLファイルを作成しSQL IDを指定して検索する。

```java
UniversalDao.findAllBySqlFile(User.class, "FIND_BY_NAME");
```

SQLファイルは検索結果をマッピングするBeanから導出する。`User.class` が `sample.entity.User` の場合、SQLファイルのパスはクラスパス配下の `sample/entity/User.sql` となる。

SQL IDに `#` が含まれると「SQLファイルのパス#SQL ID」と解釈する。以下の例ではSQLファイルのパスが `sample/entity/Member.sql`、SQL IDが `FIND_BY_NAME` となる。

```java
UniversalDao.findAllBySqlFile(GoldUser.class, "sample.entity.Member#FIND_BY_NAME");
```

> **補足**: `#` を含む指定は機能単位（Actionハンドラ単位）にSQLを集約したい場合に使用できる。ただし指定が煩雑になるデメリットがあるため、基本は `#` を付けない指定を使用すること。

## DatabaseMetaDataから情報を取得できない場合の対応

データベースのシノニム使用や権限問題で `DatabaseMetaData` から主キー情報を取得できない場合、主キー指定の検索が正しく動作しない。この場合、`DatabaseMetaDataExtractor` を継承したクラスを作成して対応する（主キー情報取得方法はDB依存のため製品マニュアル参照）。

コンポーネント名 `databaseMetaDataExtractor` で設定する:

```xml
<component name="databaseMetaDataExtractor" class="sample.dao.CustomDatabaseMetaDataExtractor" />
```

## ページング処理の件数取得用SQLを変更する

[ページング](#s8) では件数取得SQLがデフォルトで元のSQLを `SELECT COUNT(*) FROM` で包んだSQLとなる。`ORDER BY` 句を含む高負荷SQLで負荷軽減したい場合は、使用しているダイアレクトを継承して `Dialect#convertCountSql(String, Object, StatementFactory)` の実装を変更する。

> **重要**: 件数取得SQLは元のSQLと同一の検索条件を持つ必要がある。両者の検索条件に差分が生じないよう注意すること。

`H2Dialect` をカスタマイズする例（元のSQLと件数取得SQLのマッピングをコンポーネントに設定）:

```java
public class CustomH2Dialect extends H2Dialect {
    private Map<String, String> sqlMap;

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

> **補足**: プロジェクトごとに適切なマッピングルールを検討すること。

<details>
<summary>keywords</summary>

findAllBySqlFile, SQLファイル, SQL ID, 任意SQL検索, パス導出, #指定, DatabaseMetaDataExtractor, 主キー情報取得, シノニム, Dialect, H2Dialect, convertCountSql, ページング件数取得SQLカスタマイズ, databaseMetaDataExtractor, StatementFactory

</details>

## テーブルをJOINした検索結果を取得する

複数テーブルをJOINした結果を取得する場合は、JOIN対象のデータを個別に検索するのは非効率なため、**1回で検索できるSQL** と **JOINした結果をマッピングするBean** を作成すること。

> **重要**: 記載のないアノテーション・属性を使用しても機能しない。フィールドにアノテーションを設定する場合は `@Access` で明示的に指定した場合のみフィールドのアノテーションを参照する。UniversalDaoでは値の取得・設定はプロパティ（getter/setter）を通して行われるため、getter/setterは必ず作成すること。フィールド名とプロパティ名（get〇〇/set〇〇の〇〇部分）は必ず同じにすること。

**クラスに設定するアノテーション**

| アノテーション | 説明 |
|---|---|
| `@Entity` (`javax.persistence.Entity`) | テーブルに対応するEntityクラスに設定。クラス名（パスカルケース）をスネークケース（全大文字）に変換してテーブル名を導出（例: `BookAuthor` → `BOOK_AUTHOR`）。テーブル名を明示したい場合は `@Table` を使用 |
| `@Table` (`javax.persistence.Table`) | テーブル名を明示指定。`name` 属性でテーブル名、`schema` 属性でスキーマ名を修飾子として指定（例: schema=work、テーブル名=users_work → `work.users_work` にアクセス） |
| `@Access` (`javax.persistence.Access`) | アノテーション設定場所を指定。明示的にフィールドに指定した場合のみフィールドのアノテーションを参照 |

**getter/フィールドに設定するアノテーション**

| アノテーション | 説明 |
|---|---|
| `@Column` (`javax.persistence.Column`) | カラム名を明示指定。`name` 属性でカラム名を設定。未設定の場合はプロパティ名から `@Entity` と同じルールで導出 |
| `@Id` (`javax.persistence.Id`) | 主キーに設定。複合主キーの場合は複数のgetter/フィールドに設定 |
| `@Version` (`javax.persistence.Version`) | 排他制御のバージョンカラムに設定。**数値型のプロパティのみ指定可能**（文字列型では正しく動作しない）。更新時にバージョンカラムが条件に自動追加され楽観ロックが行われる。Entity内に1つだけ指定可能 |
| `@Temporal` (`javax.persistence.Temporal`) | `java.util.Date`/`java.util.Calendar` 型をDBにマッピングする方法を指定。`value` 属性でDB型を指定し変換 |
| `@GeneratedValue` (`javax.persistence.GeneratedValue`) | 自動採番を示す。`strategy` 属性で採番方法を設定。AUTO選択ルール: (1) `generator` 属性に対応するGenerator設定があればそれを使用、(2) 未設定・対応なしの場合はDialectの優先順位（IDENTITY→SEQUENCE→TABLE）で選択。シーケンス名等が取得できない場合はテーブル名とカラム名から導出（例: テーブル`USER`・カラム`ID` → `USER_ID`） |
| `@SequenceGenerator` (`javax.persistence.SequenceGenerator`) | シーケンス採番設定。`name` 属性に `@GeneratedValue` の `generator` 値、`sequenceName` 属性にDBのシーケンスオブジェクト名を設定。[採番用の設定](libraries-generator.md) が別途必要 |
| `@TableGenerator` (`javax.persistence.TableGenerator`) | テーブル採番設定。`name` 属性に `@GeneratedValue` の `generator` 値、`pkColumnValue` 属性に採番テーブルのレコード識別値を設定。[採番用の設定](libraries-generator.md) が別途必要 |

> **補足**: Lombokなどのボイラープレート生成ライブラリ使用時は、アノテーションをフィールドに設定することでgetterを自分で作成する必要がなくなる。

<details>
<summary>keywords</summary>

JOIN, テーブル結合, 複数テーブル, 検索結果マッピング, @Entity, @Table, @Access, @Column, @Id, @Version, @Temporal, @GeneratedValue, @SequenceGenerator, @TableGenerator, javax.persistence, JPAアノテーション

</details>

## 検索結果を遅延ロードする

大量の検索結果を扱う処理（大量データのWebダウンロード、バッチ処理等）では、すべての結果をメモリに展開できないため遅延ロードを使用する。

`UniversalDao#defer` メソッドを先に呼び出すだけで使用できる。内部でサーバサイドカーソルを使用しているため、`DeferredEntityList#close` メソッドを呼び出す必要がある。

```java
try (DeferredEntityList<User> users
        = (DeferredEntityList<User>) UniversalDao.defer()
                                        .findAllBySqlFile(User.class, "FIND_BY_NAME")) {
    for (User user : users) {
        // userを使った処理
    }
}
```

> **補足**: 遅延ロードを使用すると、ユニバーサルDAOとしては1件ずつロードするが、JDBCのフェッチサイズによってメモリの使用量が変わる。フェッチサイズの詳細はデータベースベンダー提供のマニュアルを参照すること。

> **重要**: 使用するRDBMSによっては、カーソルオープン中にトランザクション制御が行われるとカーソルがクローズされる。遅延ロードを使用した大量データ処理中にトランザクション制御を行った場合、クローズ済みのカーソルを参照しエラーとなる可能性がある。DBベンダのマニュアルに沿ってカーソルの挙動を調整するか、[ページング](#s8) などで回避すること。

<details>
<summary>keywords</summary>

defer, DeferredEntityList, 遅延ロード, 大量データ, サーバサイドカーソル, UniversalDao, JDBCフェッチサイズ, フェッチサイズ, メモリ使用量

</details>

## 条件を指定して検索する

条件を指定した検索では、`findAllBySqlFile` に検索条件のBeanを渡す。

```java
ProjectSearchForm condition = context.getRequestScopedVar("form");
List<Project> projects = UniversalDao.findAllBySqlFile(
    Project.class, "SEARCH_PROJECT", condition);
```

> **重要**: 検索条件はEntityではなく、検索条件を持つ専用のBeanを指定すること。ただし、1つのテーブルのみへのアクセスの場合はEntityを指定しても良い。

<details>
<summary>keywords</summary>

findAllBySqlFile, 検索条件, 条件指定検索, 専用Bean

</details>

## 型を変換する

:ref:`@Temporal <universal_dao_jpa_temporal>` を使用して `java.util.Date` および `java.util.Calendar` 型の値をデータベースにマッピングする方法を指定できる。他の型については任意のマッピングは不可能なため、Entityのプロパティはデータベースの型およびJDBCドライバの仕様に応じて定義すること。

**自動生成SQLを実行する場合の型変換**:
- データベースへの出力時: `@Temporal` が設定されているプロパティは `@Temporal` に指定された型へ変換。それ以外は [database](libraries-database.md) に処理を委譲。
- データベースから取得時: `@Temporal` が設定されているプロパティは `@Temporal` に指定された型から変換。それ以外はEntityの情報を元に変換。

**任意のSQLで検索する場合の型変換**:
- データベースへの出力時: [database](libraries-database.md) に処理を委譲して変換。
- データベースから取得時: 自動生成SQLを実行する場合と同様の処理。

> **重要**: データベースの型とプロパティの型が不一致の場合、実行時に型変換エラーが発生する場合がある。またSQL実行時に暗黙的型変換が行われ、性能劣化（indexが使用されないことに起因する）となる可能性がある。データベースとJavaのデータタイプのマッピングはJDBCドライバのマニュアルを参照。例えば、DBがdate型の場合はプロパティの型は `java.sql.Date`、数値型（integer/bigint/number等）の場合は `int`（`java.lang.Integer`）や `long`（`java.lang.Long`）となる。

<details>
<summary>keywords</summary>

@Temporal, 型変換, java.util.Date, java.util.Calendar, 暗黙的型変換, 性能劣化, universal_dao_jpa_temporal, java.sql.Date, java.lang.Integer, java.lang.Long

</details>

## ページングを行う

`UniversalDao#per` メソッドと `UniversalDao#page` メソッドを先に呼び出すだけでページングを使用できる。

```java
EntityList<User> users = UniversalDao.per(3).page(1)
                            .findAllBySqlFile(User.class, "FIND_ALL_USERS");
Pagination pagination = users.getPagination();
```

ページング画面表示に必要な検索結果件数等の情報は `Pagination` が保持しており、`EntityList` から取得できる。

> **補足**: ページング用の検索処理は [database-paging](libraries-database.md) を使用して行う。

> **補足**: ページングでは実際の範囲指定レコードの取得処理の前に件数取得SQLが発行される。件数取得SQLに起因して性能劣化が発生した場合は、必要に応じて [universal_dao-customize_sql_for_counting](#) を参考にして件数取得SQLを変更すること。

<details>
<summary>keywords</summary>

per, page, Pagination, EntityList, ページング, 件数取得SQL, UniversalDao

</details>

## サロゲートキーを採番する

サロゲートキーを採番する場合は以下のアノテーションを使用する:
- :ref:`@GeneratedValue <universal_dao_jpa_generated_value>`
- :ref:`@SequenceGenerator <universal_dao_jpa_sequence_generator>`
- :ref:`@TableGenerator <universal_dao_jpa_table_generator>`

`GenerationType` のすべてのストラテジをサポートしている。

**GenerationType.AUTO**: `Dialect` を元に採番方法を選択（IDENTITY→SEQUENCE→TABLEの優先順）。SEQUENCEが選択された場合のデフォルトシーケンス名は `<テーブル名>_<採番するカラム名>`。シーケンス名を指定したい場合は :ref:`@SequenceGenerator <universal_dao_jpa_sequence_generator>` を使用。

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

**GenerationType.SEQUENCE**: シーケンスオブジェクトの名前は :ref:`@SequenceGenerator <universal_dao_jpa_sequence_generator>` で指定。`sequenceName` 属性省略時は `<テーブル名>_<採番するカラム名>`。

```java
@Id
@Column(name = "USER_ID", length = 15)
@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq")
@SequenceGenerator(name = "seq", sequenceName = "USER_ID_SEQ")
public Long getId() { return id; }
```

**GenerationType.TABLE**: レコードを識別する値は :ref:`@TableGenerator <universal_dao_jpa_table_generator>` で指定。`pkColumnValue` 属性省略時は `<テーブル名>_<採番するカラム名>`。

```java
@Id
@Column(name = "USER_ID", length = 15)
@GeneratedValue(strategy = GenerationType.TABLE, generator = "table")
@TableGenerator(name = "table", pkColumnValue = "USER_ID")
public Long getId() { return id; }
```

> **補足**: シーケンス及びテーブルを使用したサロゲートキーの採番処理は [generator](libraries-generator.md) を使用して行う。設定値（テーブルを使用した場合のテーブル名やカラム名等）はリンク先を参照。

<details>
<summary>keywords</summary>

@GeneratedValue, @SequenceGenerator, @TableGenerator, GenerationType, サロゲートキー採番, Dialect, generator

</details>

## バッチ実行(一括登録、更新、削除)を行う

大量データの一括登録・更新・削除時にバッチ実行を使用することで、アプリケーションサーバとDBサーバ間のラウンドトリップ回数を削減しパフォーマンスを向上できる。

使用するメソッド:
- `batchInsert`
- `batchUpdate`
- `batchDelete`

> **重要**: `batchUpdate` を使用した一括更新処理では排他制御処理を行わない。更新対象のEntityとデータベースのバージョンが不一致だった場合、そのレコードの更新は行われずに処理が正常終了する。排他制御が必要な更新処理では、一括更新ではなく1レコード毎の更新処理を使用すること。

<details>
<summary>keywords</summary>

batchInsert, batchUpdate, batchDelete, バッチ実行, 一括登録, 排他制御なし

</details>

## 楽観的ロックを行う

:ref:`@Version <universal_dao_jpa_version>` が付いているEntityを更新した場合、自動で楽観的ロックを行う。楽観的ロックで排他エラーが発生した場合は `OptimisticLockException` を送出する。

> **重要**: :ref:`@Version <universal_dao_jpa_version>` は数値型のプロパティのみに指定できる。文字列型のプロパティには正しく動作しない。

排他エラー時の画面遷移は `OnError` を使用する。

```java
@OnError(type = OptimisticLockException.class,
         path = "/WEB-INF/view/common/errorPages/userError.jsp")
public HttpResponse update(HttpRequest request, ExecutionContext context) {
    UniversalDao.update(user);
}
```

> **重要**: 一括更新処理（`batchUpdate`）では楽観的ロックは使用できない（[universal_dao-batch_execute](#s10) 参照）。

<details>
<summary>keywords</summary>

@Version, OptimisticLockException, 楽観的ロック, OnError, 排他制御, 数値型

</details>

## 悲観的ロックを行う

ユニバーサルDAOでは悲観的ロックの機能を特に提供していない。

悲観的ロックはデータベースの行ロック（select for update）を使用することで行う。行ロックを記載したSQLは `UniversalDao#findBySqlFile` メソッドを使って実行する。

<details>
<summary>keywords</summary>

findBySqlFile, 悲観的ロック, select for update, 行ロック

</details>

## 排他制御の考え方

バージョンカラムをどのテーブルに定義するかは業務的な観点により決める必要がある。

バージョン番号を持つテーブルは、排他制御を行う単位ごとに定義し、競合が許容される最大の単位で定義する。例えば「ユーザ」という大きな単位でロックすることが業務的に許容されるならば、ユーザテーブルにバージョン番号を定義する。

> **注意**: 単位を大きくすると競合する可能性が高くなり、更新失敗（楽観的ロックの場合）や処理遅延（悲観的ロックの場合）を招く。

<details>
<summary>keywords</summary>

バージョンカラム, 排他制御, 競合, バージョン番号, テーブル設計

</details>
