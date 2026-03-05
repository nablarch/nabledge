# ユニバーサルDAO

## ユニバーサルDAOについて

ユニバーサルDAOは、`Jakarta Persistence`のアノテーションを使った簡易的なO/Rマッパー。

**前提条件**: ユニバーサルDAOの内部で:ref:`database`を使用しているため、ユニバーサルDAOを使用するには:ref:`database`の設定が必要。

**位置付けと制約**: ユニバーサルDAOは簡易的なO/Rマッパーと位置付けており、すべてのデータベースアクセスをユニバーサルDAOで実現しようとは考えていない。ユニバーサルDAOで実現できない場合は、素直に:ref:`database`を使用すること。

例えば、ユニバーサルDAOでは、主キー以外の条件を指定した更新/削除は行えないので、:ref:`database`を使用する必要がある。

**共通項目の自動設定について**: ユニバーサルDAOは、共通項目(全てのテーブルに定義する登録ユーザや更新ユーザ等)に対する値の自動設定機能は提供しない。

共通項目に対する値を自動設定したい場合は、:ref:`doma_adaptor`を適用し、Domaのエンティティリスナー機能を使用すれば良い。どうしてもユニバーサルDAOを使用したい場合は、ユニバーサルDAOの機能を使用する前にアプリケーションで明示的に共通項目を設定すること。

## 機能概要

### SQLを書かなくても単純なCRUDができる

Jakarta PersistenceアノテーションをEntityに設定することで、以下のCRUD操作をSQL記述なしで実行可能（SQL文はアノテーションから実行時に自動構築）：

- 登録/一括登録
- 主キーを指定した更新/一括更新
- 主キーを指定した削除/一括削除
- 主キーを指定した検索

Entityに使用できるJakarta Persistenceアノテーションについては、:ref:`universal_dao_jpa_annotations`を参照。

> **補足**: `@Table`アノテーションでスキーマを指定できるが、:ref:`database`の:ref:`database-replace_schema`機能は使用不可。環境毎のスキーマ切り替えには:ref:`database`を使用すること。

### 検索結果をBeanにマッピングできる

SQLファイルによる検索結果をBean（Entity、Form、DTO）にマッピング可能。BeanのプロパティとSELECT句の名前が一致する項目を自動マッピング。

Beanに使用できるデータタイプについては、:ref:`universal_dao_bean_data_types`を参照。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-dao</artifactId>
</dependency>
```

## ユニバーサルDAOを使うための設定を行う

**基本的な使い方**: `UniversalDao`を参照。

:ref:`database`の設定に加えて、`BasicDaoContextFactory`をコンポーネント定義に追加。

```xml
<component name="daoContextFactory" class="nablarch.common.dao.BasicDaoContextFactory" />
```

コンポーネント名は`daoContextFactory`固定。

## 任意のSQL(SQLファイル)で検索する

SQLファイルを作成し、SQL IDを指定して検索。

```java
UniversalDao.findAllBySqlFile(User.class, "FIND_BY_NAME");
```

**SQLファイルパス導出ルール**: BeanのFQCNから導出。`sample.entity.User`の場合、`sample/entity/User.sql`。

**SQL IDに`#`を含める場合**: `SQLファイルパス#SQL ID`と解釈。

```java
UniversalDao.findAllBySqlFile(GoldUser.class, "sample.entity.Member#FIND_BY_NAME");
```

上記は`sample/entity/Member.sql`の`FIND_BY_NAME`を実行。

> **補足**: `#`付き指定は機能単位でSQL集約時に利用可能だが、指定が煩雑になるため基本は`#`なし指定を使用すること。

## テーブルをJOINした検索結果を取得する

複数テーブルをJOINした検索結果を取得する場合、個別検索は非効率。**1回で検索できるSQL**と**JOIN結果をマッピングするBean**を作成すること。

## 検索結果を遅延ロードする

大量データ処理（Web大量ダウンロード、バッチ大量処理など）でメモリ不足を回避するため、遅延ロードを使用。

**使用方法**: `UniversalDao#defer`メソッドを検索前に呼び出し。遅延ロードを使用すると、ユニバーサルDAOとしては1件ずつロードするが、JDBCのフェッチサイズによってメモリの使用量が変わる。フェッチサイズの詳細は、データベースベンダー提供のマニュアルを参照。

内部でサーバサイドカーソルを使用するため、`DeferredEntityList#close`の呼び出しが必須。

```java
try (DeferredEntityList<User> users
        = (DeferredEntityList<User>) UniversalDao.defer()
                                        .findAllBySqlFile(User.class, "FIND_BY_NAME")) {
    for (User user : users) {
        // userを使った処理
    }
}
```

> **重要**: RDBMSによってはカーソルオープン中のトランザクション制御でカーソルがクローズされ、エラーになる可能性あり。DBベンダマニュアルに沿ってカーソル挙動を調整するか、:ref:`ページング<universal_dao-paging>`で回避すること。

## 条件を指定して検索する

検索条件を指定した検索が可能。

```java
ProjectSearchForm condition = context.getRequestScopedVar("form");
List<Project> projects = UniversalDao.findAllBySqlFile(
    Project.class, "SEARCH_PROJECT", condition);
```

> **重要**: 検索条件は専用Bean（Entityではなく）を指定。ただし、単一テーブルアクセスの場合はEntityも可。

## 型を変換する

**型マッピング制約**: :ref:`@Temporal<universal_dao_jpa_temporal>`で`java.util.Date`/`java.util.Calendar`の変換方法を指定可能。他の型は任意マッピング不可のため、Entityプロパティ型はDB型及びJDBCドライバ仕様に応じて定義すること。

**SQL種別による変換動作の違い**:

:ref:`自動生成SQL<universal_dao-execute_crud_sql>`の場合
  - DB出力時: :ref:`@Temporal<universal_dao_jpa_temporal>`設定プロパティは@Temporal指定型へ変換。それ以外は:ref:`database`へ委譲。
  - DB取得時: :ref:`@Temporal<universal_dao_jpa_temporal>`設定プロパティは@Temporal指定型から変換。それ以外はEntity情報を元に変換。

:ref:`任意SQL<universal_dao-sql_file>`の場合
  - DB出力時: :ref:`database`へ委譲（Jakarta Persistenceアノテーション情報は未使用）。
  - DB取得時: 自動生成SQLと同様。

> **重要**: DB型とプロパティ型の不一致は実行時エラーまたは暗黙的型変換による性能劣化（index不使用）の原因となる。DB/Java型マッピングはJDBCドライバ仕様に依存するため、ドライバマニュアルを参照。例: DB date型→`Date`、DB数値型→`int`(`Integer`)または`long`(`Long`)。

## ページングを行う

`UniversalDao#per`、`UniversalDao#page`を検索前に呼び出してページングを実行。

```java
EntityList<User> users = UniversalDao.per(3).page(1)
                            .findAllBySqlFile(User.class, "FIND_ALL_USERS");
```

**ページング情報取得**: `Pagination`を`EntityList`から取得。

```java
Pagination pagination = users.getPagination();
```

> **補足**: ページング処理は:ref:`データベースアクセス(JDBCラッパー)の範囲指定検索機能<database-paging>`を使用。件数取得SQLが先に発行されるため、性能劣化時は:ref:`universal_dao-customize_sql_for_counting`を参照してSQLをカスタマイズ。

## サロゲートキーを採番する

**使用アノテーション**: :ref:`@GeneratedValue<universal_dao_jpa_generated_value>`、:ref:`@SequenceGenerator<universal_dao_jpa_sequence_generator>`、:ref:`@TableGenerator<universal_dao_jpa_table_generator>`

`GenerationType`の全ストラテジをサポート。

**GenerationType.AUTO**

```java
@Id
@Column(name = "USER_ID", length = 15)
@GeneratedValue(strategy = GenerationType.AUTO)
public Long getId() { return id; }
```

- `Dialect`を元に採番方法を自動選択（優先順位: IDENTITY→SEQUENCE→TABLE）
- SEQUENCE選択時のシーケンス名: `<テーブル名>_<カラム名>`
- シーケンス名指定は:ref:`@SequenceGenerator<universal_dao_jpa_sequence_generator>`で可能

**GenerationType.IDENTITY**

```java
@Id
@Column(name = "USER_ID", length = 15)
@GeneratedValue(strategy = GenerationType.IDENTITY)
public Long getId() { return id; }
```

**GenerationType.SEQUENCE**

```java
@Id
@Column(name = "USER_ID", length = 15)
@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq")
@SequenceGenerator(name = "seq", sequenceName = "USER_ID_SEQ")
public Long getId() { return id; }
```

- シーケンス名は:ref:`@SequenceGenerator<universal_dao_jpa_sequence_generator>`で指定
- `sequenceName`省略時: `<テーブル名>_<カラム名>`

**GenerationType.TABLE**

```java
@Id
@Column(name = "USER_ID", length = 15)
@GeneratedValue(strategy = GenerationType.TABLE, generator = "table")
@TableGenerator(name = "table", pkColumnValue = "USER_ID")
public Long getId() { return id; }
```

- レコード識別値は:ref:`@TableGenerator<universal_dao_jpa_table_generator>`で指定
- `pkColumnValue`省略時: `<テーブル名>_<カラム名>`

> **補足**: シーケンス/テーブル採番処理は:ref:`generator`を使用。設定値詳細はリンク先参照。

## バッチ実行(一括登録、更新、削除)を行う

大量データ処理でラウンドトリップ回数削減によるパフォーマンス向上を実現。

**メソッド**: `batchInsert`、`batchUpdate`、`batchDelete`

> **重要**: `batchUpdate`は排他制御を行わない。バージョン不一致時、該当レコードは更新されずに処理が正常終了。排他制御が必要な場合は1レコード毎の更新を使用すること。

## 楽観的ロックを行う

:ref:`@Version<universal_dao_jpa_version>`付きEntity更新時に自動で楽観的ロック実行。排他エラー時は`OptimisticLockException`を送出。

> **重要**: :ref:`@Version<universal_dao_jpa_version>`は数値型プロパティのみ指定可（文字列型は不可）。

**排他エラー時の画面遷移**: `OnError`を使用。

```java
@OnError(type = OptimisticLockException.class,
         path = "/WEB-INF/view/common/errorPages/userError.jsp")
public HttpResponse update(HttpRequest request, ExecutionContext context) {
    UniversalDao.update(user);
}
```

> **重要**: :ref:`universal_dao-batch_execute`に記載の通り、`batchUpdate`では楽観的ロックは使用不可。

## 悲観的ロックを行う

ユニバーサルDAOは悲観的ロック機能を提供しない。

DBの行ロック（`SELECT FOR UPDATE`）を使用。行ロックSQLは`UniversalDao#findBySqlFile`で実行。

## 排他制御の考え方

バージョンカラムのテーブル定義は業務観点で決定。排他制御単位ごとに定義し、競合許容可能な最大単位で設定。例: 「ユーザ」単位のロックが許容されるならユーザテーブルにバージョン番号を定義。

> **注意**: ロック単位を大きくすると競合可能性が上昇し、更新失敗（楽観的ロック）や処理遅延（悲観的ロック）を招く。

## データサイズの大きいバイナリデータを登録（更新）する

UniversalDAOはデータを全てメモリに展開するため、大きいバイナリデータ（OracleのBLOBなど）の登録には不適。データベース提供機能を使ってファイルから直接登録すること。

詳細: :ref:`database-binary_column`

## データサイズの大きいテキストデータを登録（更新）する

UniversalDAOはデータを全てメモリに展開するため、大きいテキストデータ（OracleのCLOBなど）の登録には不適。データベース提供機能を使ってファイルから直接登録すること。

詳細: :ref:`database-clob_column`

## 現在のトランザクションとは異なるトランザクションで実行する

別トランザクションでUniversalDAOを実行する方法。:ref:`database` の :ref:`database-new_transaction` と同様の機能をUniversalDAOで実現。

**手順**:

1. コンポーネント設定で `SimpleDbTransactionManager` を定義
2. `UniversalDao.Transaction` を継承して実行

**設定例**:

```xml
<component name="find-persons-transaction"
    class="nablarch.core.db.transaction.SimpleDbTransactionManager">
  <property name="connectionFactory" ref="connectionFactory" />
  <property name="transactionFactory" ref="transactionFactory" />
  <property name="dbTransactionName" value="update-login-failed-count-transaction" />
</component>
```

**プロパティ**:

| プロパティ名 | 型 | 説明 |
|---|---|---|
| connectionFactory | ConnectionFactory | `ConnectionFactory` 実装クラス（詳細: :ref:`database-connect`）|
| transactionFactory | TransactionFactory | `TransactionFactory` 実装クラス（詳細: :ref:`transaction-database`）|
| dbTransactionName | String | トランザクション識別名 |

**実装例**:

`UniversalDao.Transaction` を継承:

```java
private static final class FindPersonsTransaction extends UniversalDao.Transaction {
    private EntityList<Person> persons;

    FindPersonsTransaction() {
        // コンポーネント名またはSimpleDbTransactionManagerオブジェクトを指定
        super("find-persons-transaction");
    }

    // このメソッドが別トランザクションで自動実行される
    // 正常終了→コミット、例外→ロールバック
    @Override
    protected void execute() {
        persons = UniversalDao.findAllBySqlFile(Person.class, "FIND_PERSONS");
    }

    public EntityList<Person> getPersons() {
        return persons;
    }
}
```

呼び出し:

```java
FindPersonsTransaction tx = new FindPersonsTransaction();
EntityList<Person> persons = tx.getPersons();
```

> **重要**: `SimpleDbTransactionManager` を直接使わず、トランザクション制御用の `UniversalDao.Transaction` を使用すること。

## 拡張例

### DatabaseMetaDataから情報を取得できない場合の対応

シノニムや権限の問題で `DatabaseMetaData` から主キー情報を取得できない場合、主キーを指定した検索が動作しなくなる。

**対応方法**: `DatabaseMetaDataExtractor` を継承してカスタムクラスを作成。主キー情報の取得方法はデータベース製品マニュアルを参照。

**設定例**:

```xml
<component name="databaseMetaDataExtractor" class="sample.dao.CustomDatabaseMetaDataExtractor" />
```

> **注意**: コンポーネント名は `databaseMetaDataExtractor` で設定すること。

### ページング処理の件数取得用SQL変更

:ref:`ページング <universal_dao-paging>` 処理では、実際の範囲指定レコード取得の前に件数取得SQLが発行される。デフォルトでは件数取得SQLは元SQLを `SELECT COUNT(*) FROM (...)` で包んだ形式。元SQLが `ORDER BY` 句を含む場合、件数取得時に不要な処理負荷が発生する。

**対応方法**: 使用中のダイアレクトをカスタマイズし、`Dialect#convertCountSql` 実装を変更。

> **重要**: 件数取得SQLは元SQLと同一の検索条件を持つ必要がある。差分が発生しないよう注意。

**実装例** (`H2Dialect` をカスタマイズ):

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

    public void setSqlMap(Map<String, String> sqlMap){
        this.sqlMap = sqlMap;
    }
}
```

**設定例**:

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

## Entityに使用できるJakarta Persistenceアノテーション

Entityに使用できるJakarta Persistenceアノテーション一覧。

> **重要**: ここに記載のないアノテーション及び属性は機能しない。

**アノテーション設定場所**:

- デフォルト: getter
- フィールド: :ref:`@Access <universal_dao_jpa_access>` で明示的に指定した場合のみ

> **注意**: フィールドにアノテーションを設定する場合でも、UniversalDaoは値の取得・設定をプロパティ経由で行うため、getterとsetterは必須。フィールド名とプロパティ名（get〇〇, set〇〇の〇〇部分）を必ず同じにすること。

> **補足**: Lombokのようなボイラープレートコード生成ライブラリを使用する場合、アノテーションをフィールドに設定することでgetterを自分で作成する必要がなくなり、ライブラリの利点をより活かせる。

**クラスに設定するアノテーション**:

- :ref:`@Entity <universal_dao_jpa_entity>`
- :ref:`@Table <universal_dao_jpa_table>`
- :ref:`@Access <universal_dao_jpa_access>`

**getterまたはフィールドに設定するアノテーション**:

- :ref:`@Column <universal_dao_jpa_column>`
- :ref:`@Id <universal_dao_jpa_id>`
- :ref:`@Version <universal_dao_jpa_version>`
- :ref:`@Temporal <universal_dao_jpa_temporal>`
- :ref:`@GeneratedValue <universal_dao_jpa_generated_value>`
- :ref:`@SequenceGenerator <universal_dao_jpa_sequence_generator>`
- :ref:`@TableGenerator <universal_dao_jpa_table_generator>`

---

### jakarta.persistence.Entity

データベーステーブルに対応するEntityクラスに設定。クラス名からテーブル名を導出（パスカルケース→スネークケース大文字変換）。

**導出例**:

```
Book → BOOK
BookAuthor → BOOK_AUTHOR
```

> **補足**: クラス名から導出できない場合は :ref:`@Table <universal_dao_jpa_table>` で明示指定。

### jakarta.persistence.Table

テーブル名を明示指定。

**属性**:

- `name`: テーブル名
- `schema`: スキーマ名（例: `schema="work"`, テーブル名 `users_work` → アクセス先 `work.users_work`）

### jakarta.persistence.Access

アノテーション設定場所を指定。フィールドに明示的に指定した場合のみ、フィールドのアノテーションを参照。

### jakarta.persistence.Column

カラム名を明示指定。`name` 属性に値を設定。

> **補足**: 未設定の場合はプロパティ名から導出（:ref:`@Entity <universal_dao_jpa_entity>` と同じルール）。

### jakarta.persistence.Id

主キーを指定。複合主キーの場合は複数のgetterまたはフィールドに設定。

### jakarta.persistence.Version

排他制御用バージョンカラムを指定。数値型のプロパティのみ指定可能（文字列型は不可）。

更新処理時にバージョンカラムが条件に自動追加され楽観ロックが行われる。

> **補足**: Entity内に1つだけ指定可能。

### jakarta.persistence.Temporal

`java.util.Date` / `java.util.Calendar` 型の値をデータベースにマッピングする方法を指定。`value` 属性で指定したデータベース型に変換して登録。

### jakarta.persistence.GeneratedValue

自動採番を使用することを示す。

**属性**:

- `strategy`: 採番方法
  - `AUTO` を指定した場合の選択ルール:
    1. `generator` 属性に対応するGenerator設定がある場合、そのGeneratorを使用
    2. `generator` 未設定または対応設定がない場合、データベースの `Dialect` から採番方法を選択（優先順位: IDENTITY → SEQUENCE → TABLE）
- `generator`: 任意の名前

> **補足**: :ref:`@GeneratedValue <universal_dao_jpa_generated_value>` からシーケンス名やテーブル採番識別値を取得できない場合、テーブル名と採番カラム名から導出。例: テーブル名 `USER`, カラム名 `ID` → `USER_ID`

### jakarta.persistence.SequenceGenerator

シーケンス採番を使用。

**属性**:

- `name`: :ref:`@GeneratedValue <universal_dao_jpa_generated_value>` の `generator` 属性と同じ値
- `sequenceName`: データベース上のシーケンスオブジェクト名

> **補足**: シーケンス採番は採番機能を使用。:ref:`採番用の設定 <generator_dao_setting>` が別途必要。

### jakarta.persistence.TableGenerator

テーブル採番を使用。

**属性**:

- `name`: :ref:`@GeneratedValue <universal_dao_jpa_generated_value>` の `generator` 属性と同じ値
- `pkColumnValue`: 採番テーブルのレコード識別値

> **補足**: テーブル採番は採番機能を使用。:ref:`採番用の設定 <generator_dao_setting>` が別途必要。

## Beanに使用できるデータタイプ

> **重要**: ここに記載のないデータタイプに対して、検索結果をマッピングできない(実行時例外となる)。

## サポートされるデータタイプ

- **`java.lang.String`**

- **`java.lang.Short`**: プリミティブ型も指定可能。プリミティブ型の場合、`null`は`0`として扱う。

- **`java.lang.Integer`**: プリミティブ型も指定可能。プリミティブ型の場合、`null`は`0`として扱う。

- **`java.lang.Long`**: プリミティブ型も指定可能。プリミティブ型の場合、`null`は`0`として扱う。

- **`java.math.BigDecimal`**

- **`java.lang.Boolean`**: プリミティブ型も指定可能。プリミティブ型の場合、`null`は`false`として扱う。ラッパー型(Boolean)の場合はリードメソッド名は`get`から開始される必要がある。プリミティブ型の場合はリードメソッド名が`is`で開始されていても良い。

- **`java.util.Date`**: Jakarta Persistenceの :ref:`@Temporal <universal_dao_jpa_temporal>` でデータベース上のデータ型を指定する必要がある。

- **`java.sql.Date`**

- **`java.sql.Timestamp`**

- **`java.time.LocalDate`**

- **`java.time.LocalDateTime`**

- **`byte[]`**: BLOBなどのように非常に大きいサイズのデータ型の値は、本機能を用いてデータをヒープ上に展開しないように注意すること。非常に大きいサイズのバイナリデータを扱う場合には、データベースアクセスを直接使用し、Stream経由でデータを参照すること。詳細は :ref:`database-binary_column` を参照。
