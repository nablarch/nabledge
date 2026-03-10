# Domaアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/doma_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/Transactional.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/DomaDaoRepository.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/DomaConfig.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/batch/ee/listener/DomaTransactionStepListener.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/batch/ee/listener/DomaTransactionItemWriteListener.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/DomaTransactionNotSupportedConfig.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/ConnectionFactoryFromDomaConnection.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/NablarchJdbcLogger.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/DomaStatementProperties.html)

## モジュール一覧

Doma2を使用したデータベースアクセスを行うためのアダプタ。データベースアクセスにDomaを使用することで以下のメリットが得られる:
- Nablarchと同じように、実行時に動的にSQL文を構築できる
- 2waySQLなので、NablarchのようにSQL文を書き換える必要がなく、SQLツール等でそのまま実行できる
- `Transactional` インターセプタで指定したアクションのみトランザクション管理対象にできるため、不要なトランザクション制御処理を削減でき、パフォーマンスの向上が期待できる

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-doma-adaptor</artifactId>
</dependency>
```

> **補足**: Doma 2.62.0でテスト済み。バージョンを変更する場合はプロジェクト側でテストを行い問題ないことを確認すること。

<details>
<summary>keywords</summary>

nablarch-doma-adaptor, com.nablarch.integration, Domaアダプタ, Maven依存関係, モジュール設定, Doma2, 動的SQL, 2waySQL, Transactional, パフォーマンス向上, トランザクション制御

</details>

## Domaアダプタを使用するための設定を行う

### 依存関係の設定

Maven `maven-compiler-plugin` のannotationProcessorPathsにdoma-processorを設定する。

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <configuration>
                <annotationProcessorPaths>
                    <path>
                        <groupId>org.seasar.doma</groupId>
                        <artifactId>doma-processor</artifactId>
                        <version>2.62.0</version>
                    </path>
                </annotationProcessorPaths>
                <!-- Eclipseを使用する場合は以下の引数を設定すること
                <compilerArgs>
                    <arg>-Adoma.resources.dir=${project.basedir}/src/main/resources</arg>
                </compilerArgs>
                -->
            </configuration>
        </plugin>
    </plugins>
</build>
```

### ダイアレクトとデータソースの設定

コンポーネント設定ファイルの定義ルール:
- ダイアレクトは `org.seasar.doma.jdbc.dialect.Dialect` の実装クラス。コンポーネント名は `domaDialect`
- データソースのコンポーネント名は `dataSource`

H2の設定例:
```xml
<component name="domaDialect" class="org.seasar.doma.jdbc.dialect.H2Dialect" />
<component name="dataSource" class="org.h2.jdbcx.JdbcDataSource">
  <!-- プロパティは省略 -->
</component>
```

<details>
<summary>keywords</summary>

doma-processor, maven-compiler-plugin, domaDialect, dataSource, H2Dialect, org.seasar.doma.jdbc.dialect.Dialect, ダイアレクト設定, データソース設定, 依存関係設定

</details>

## Domaを使用してデータベースにアクセスする

`@Dao` アノテーションを付与したDaoインタフェースを作成する。

業務アクションメソッドに `Transactional` インターセプタを設定してトランザクション管理対象とする。Daoの実装クラスは `DomaDaoRepository#get` でルックアップする。

> **補足**: Domaでは注釈処理によってコンパイル時に自動的にDaoの実装クラスが生成されるため、コーディング時に実装クラスが存在しない。そのため `DomaDaoRepository` を使用してルックアップする。

```java
@Transactional
public HttpResponse create(final HttpRequest request, final ExecutionContext context) {
    final Project project = SessionUtil.delete(context, "project");
    DomaDaoRepository.get(ProjectDao.class).insert(project);
    return new HttpResponse("redirect://complete");
}
```

> **補足**: Doma 2.44.0よりDaoアノテーションのconfig属性が非推奨になったため実装方法を変更している。詳しくは :ref:`migration_doma2.44.0` を参照すること。

<details>
<summary>keywords</summary>

DomaDaoRepository, Transactional, nablarch.integration.doma.Transactional, nablarch.integration.doma.DomaDaoRepository, @Dao, @Transactional, データベースアクセス, トランザクション管理, Daoルックアップ

</details>

## 別トランザクションで実行する

`Transactional` インターセプタのトランザクションとは別の新規トランザクションでDBアクセスしたい場合は、 `DomaConfig#getTransactionManager` で取得した `TransactionManager` を使用する。

```java
DomaConfig.singleton()
        .getTransactionManager()
        .requiresNew(() ->
                DomaDaoRepository.get(ProjectDao.class).insert(project);
```

<details>
<summary>keywords</summary>

DomaConfig, TransactionManager, nablarch.integration.doma.DomaConfig, requiresNew, 別トランザクション, トランザクション分離

</details>

## Jakarta Batchに準拠したバッチアプリケーションで使用する

Jakarta Batchに準拠したバッチアプリケーションでDomaを使用するには、以下のリスナーをリスナーリストに定義する:
- `DomaTransactionStepListener`
- `DomaTransactionItemWriteListener`

```xml
<list name="stepListeners">
  <!-- その他のリスナーは省略 -->
  <component class="nablarch.integration.doma.batch.ee.listener.DomaTransactionStepListener" />
</list>

<list name="itemWriteListeners">
  <!-- その他のリスナーは省略 -->
  <component class="nablarch.integration.doma.batch.ee.listener.DomaTransactionItemWriteListener" />
</list>
```

> **重要**: :ref:`Chunkステップ <jsr352-batch_type_chunk>` のItemWriterでバッチ更新（バッチinsert/updateなど）を行う場合、バッチサイズを明示的に指定すること。Chunkステップのitem-countのサイズがバッチサイズになるわけではない。指定しない場合はDomaのデフォルト値が適用されパフォーマンスが向上しない可能性がある。

1000件ごとにバッチinsertする例:
```java
@BatchInsert(batchSize = 1000)
int[] batchInsert(List<Bonus> bonuses);
```

<details>
<summary>keywords</summary>

DomaTransactionStepListener, DomaTransactionItemWriteListener, nablarch.integration.doma.batch.ee.listener.DomaTransactionStepListener, nablarch.integration.doma.batch.ee.listener.DomaTransactionItemWriteListener, @BatchInsert, batchSize, Jakarta Batch, バッチリスナー, バッチ更新

</details>

## Jakarta Batchに準拠したバッチアプリケーションで遅延ロードを行う

Jakarta Batchで大量データの遅延ロードを行う場合は、 `DomaDaoRepository#get(java.lang.Class,java.lang.Class)` を使用し、第2引数に `DomaTransactionNotSupportedConfig` のClassクラスを指定する。

> **重要**: 引数が1つの `DomaDaoRepository#get(java.lang.Class)` を使用した場合は `DomaConfig` が使用されるため、 `DomaTransactionItemWriteListener` によるコミットでストリームがクローズされ、後続のレコードが読み込めなくなる。

Daoインタフェース（検索結果は `Stream` で取得する）:
```java
@Dao
public interface ProjectDao {
    @Select(strategy = SelectType.RETURN)
    Stream<Project> search();
}
```

ItemReaderクラスの実装ポイント:
- `DomaDaoRepository#get(java.lang.Class,java.lang.Class)` の第2引数に `DomaTransactionNotSupportedConfig` を指定する
- openメソッドで検索結果のストリームを取得する
- closeメソッドで必ずストリームを閉じる（リソース解放漏れ防止）

```java
@Dependent
@Named
public class ProjectReader extends AbstractItemReader {
    private Iterator<Project> iterator;
    private Stream<Project> stream;

    @Override
    public void open(Serializable checkpoint) throws Exception {
        final ProjectDao dao = DomaDaoRepository.get(ProjectDao.class, DomaTransactionNotSupportedConfig.class);
        stream = dao.search();
        iterator = stream.iterator();
    }

    @Override
    public Object readItem() {
        if (iterator.hasNext()) {
            return iterator.next();
        } else {
            return null;
        }
    }

    @Override
    public void close() throws Exception {
        stream.close();
    }
}
```

> **補足**: Doma 2.44.0よりDaoアノテーションのconfig属性が非推奨になったため実装方法を変更している。詳しくは :ref:`migration_doma2.44.0` を参照すること。

<details>
<summary>keywords</summary>

DomaTransactionNotSupportedConfig, nablarch.integration.doma.DomaTransactionNotSupportedConfig, AbstractItemReader, @Dependent, @Named, 遅延ロード, 大量データ読み込み, Stream, Jakarta Batch, @Select, SelectType, SelectType.RETURN

</details>

## 複数のデータベースにアクセスする

複数データベースにアクセスする場合は、新しくConfigクラスを作成して使用する。

コンポーネント設定ファイル（別DBのダイアレクトとデータソースを定義）:
```xml
<component name="customDomaDialect" class="org.seasar.doma.jdbc.dialect.OracleDialect" />
<component name="customDataSource" class="oracle.jdbc.pool.OracleDataSource">
  <!-- プロパティは省略 -->
</component>
```

Configクラスの実装ルール:
- Domaの `Config` インターフェースを実装すること
- publicで引数なしのコンストラクタを持つこと

```java
public final class CustomConfig implements Config {
    public CustomConfig() {
        dialect = SystemRepository.get("customDomaDialect");
        localTransactionDataSource =
                new LocalTransactionDataSource(SystemRepository.get("customDataSource"));
        localTransaction = localTransactionDataSource.getLocalTransaction(getJdbcLogger());
        localTransactionManager = new LocalTransactionManager(localTransaction);
    }
    // その他のフィールド、メソッドはDomaConfigを参考に実装すること
}
```

業務アクションでの使用: `DomaDaoRepository#get(java.lang.Class,java.lang.Class)` の第2引数に作成したConfigクラスを指定する:
```java
public HttpResponse create(final HttpRequest request, final ExecutionContext context) {
    final Project project = SessionUtil.delete(context, "project");
    CustomConfig.singleton()
            .getTransactionManager()
            .requiresNew(() ->
                    DomaDaoRepository.get(ProjectDao.class, CustomConfig.class).insert(project));
    return new HttpResponse("redirect://complete");
}
```

> **補足**: Doma 2.44.0よりSingletonConfigアノテーションの付与およびDaoアノテーションのconfig属性が非推奨になったため実装方法を変更している。詳しくは :ref:`migration_doma2.44.0` を参照すること。

<details>
<summary>keywords</summary>

CustomConfig, Config, DomaDaoRepository, nablarch.integration.doma.DomaDaoRepository, 複数データベース, マルチDB, Configクラス, OracleDialect, LocalTransactionDataSource, LocalTransactionManager, SystemRepository, SingletonConfig

</details>

## DomaとNablarchのデータベースアクセスを併用する

DomaとNablarchのデータベースアクセスを併用する場合（例: :ref:`メール送信ライブラリ <mail>` の利用）、NablarchのDBアクセスをDomaと同じトランザクション（DB接続）配下で実行できる。

コンポーネント設定ファイルに `ConnectionFactoryFromDomaConnection` を定義する。コンポーネント名は `connectionFactoryFromDoma` とすること。Jakarta Batchで使用する場合は、Domaのトランザクション制御リスナーに `connectionFactoryFromDoma` を設定する。

```xml
<!-- コンポーネント名は connectionFactoryFromDoma とする -->
<component name="connectionFactoryFromDoma"
    class="nablarch.integration.doma.ConnectionFactoryFromDomaConnection">
  <!-- プロパティに対する設定は省略 -->
</component>

<!-- Jakarta Batchの場合はリスナーに connectionFactoryFromDoma を設定する -->
<component class="nablarch.integration.doma.batch.ee.listener.DomaTransactionItemWriteListener">
  <property name="connectionFactory" ref="connectionFactoryFromDoma" />
</component>

<component class="nablarch.integration.doma.batch.ee.listener.DomaTransactionStepListener">
  <property name="connectionFactory" ref="connectionFactoryFromDoma" />
</component>
```

<details>
<summary>keywords</summary>

ConnectionFactoryFromDomaConnection, nablarch.integration.doma.ConnectionFactoryFromDomaConnection, connectionFactoryFromDoma, DomaとNablarch併用, トランザクション共有

</details>

## ロガーを切り替える

デフォルトでは `NablarchJdbcLogger` （NablarchロガーによるJdbcLogger実装）が使用される。他のロガーに差し替える場合はコンポーネント定義ファイルに設定する。

定義ルール:
- ロガーは `org.seasar.doma.jdbc.JdbcLogger` の実装クラスとすること
- コンポーネント名は `domaJdbcLogger` とすること

`org.seasar.doma.jdbc.UtilLoggingJdbcLogger` を使用する場合:
```xml
<component name="domaJdbcLogger" class="org.seasar.doma.jdbc.UtilLoggingJdbcLogger" />
```

<details>
<summary>keywords</summary>

NablarchJdbcLogger, UtilLoggingJdbcLogger, nablarch.integration.doma.NablarchJdbcLogger, domaJdbcLogger, JdbcLogger, ロガー切り替え, JDBCログ

</details>

## java.sql.Statementに関する設定を行う

**クラス**: `nablarch.integration.doma.DomaStatementProperties`

`java.sql.Statement` に関する項目（最大行数の制限値、フェッチサイズ、クエリタイムアウト（秒）、バッチサイズ）をプロジェクト全体に設定する場合、コンポーネント設定ファイルに `DomaStatementProperties` を設定する。

> **補足**: コンポーネント名は `domaStatementProperties` とすること

```xml
<component class="nablarch.integration.doma.DomaStatementProperties" name="domaStatementProperties">
  <!-- 最大行数の制限値を1000行に設定する -->
  <property name="maxRows" value="1000" />
  <!-- フェッチサイズを200行に設定する -->
  <property name="fetchSize" value="200" />
  <!-- クエリタイムアウトを30秒に設定する -->
  <property name="queryTimeout" value="30" />
  <!-- バッチサイズを400に設定する -->
  <property name="batchSize" value="400" />
</component>
```

<details>
<summary>keywords</summary>

DomaStatementProperties, domaStatementProperties, maxRows, fetchSize, queryTimeout, batchSize, java.sql.Statement設定, フェッチサイズ設定, クエリタイムアウト設定, バッチサイズ設定, 最大行数制限

</details>

## Doma 2.44.0までの実装方法から移行する

[Doma 2.44.0](https://github.com/domaframework/doma/releases/tag/2.44.0)より、Daoアノテーションのconfig属性およびSingletonConfigアノテーションが非推奨となった。NablarchでもAPIを追加し、案内していた内容から実装方法を変更している。引き続き動作するが、Domaの変更に合わせて実装方法を移行することを推奨する。

なお、Doma 2.44.0以前に案内していた実装方法でも引き続き同じ動作を行う。

<details>
<summary>keywords</summary>

Doma移行, config属性 非推奨, SingletonConfig非推奨, SingletonConfig, Doma 2.44.0, DaoアノテーションのconfigAttribute, DomaTransactionNotSupportedConfig, DomaDaoRepository, CustomConfig

</details>

## 移行パターン1: DomaConfigを使った基本的な実装からの移行

Daoアノテーションのconfig属性に `DomaConfig` を使用した実装は、config属性を削除することで移行できる。

**移行前:**

```java
// Daoの定義
@Dao(config = DomaConfig.class)  /* config属性を指定 */
public interface ProjectDao {
    // 省略
}

// Daoを使用する実装例
@Transactional
public HttpResponse create(final HttpRequest request, final ExecutionContext context) {
    final Project project = SessionUtil.delete(context, "project");

    DomaDaoRepository.get(ProjectDao.class).insert(project);

    return new HttpResponse("redirect://complete");
}
```

**移行後:**

```java
// Daoの定義
@Dao  /* config属性の指定を削除 */
public interface ProjectDao {
    // 省略
}

// Daoを使用する実装例
@Transactional
public HttpResponse create(final HttpRequest request, final ExecutionContext context) {
    final Project project = SessionUtil.delete(context, "project");

    DomaDaoRepository.get(ProjectDao.class).insert(project);  /* 変更なし */

    return new HttpResponse("redirect://complete");
}
```

Daoアノテーションのconfig属性を指定しないDaoを使用して `DomaDaoRepository#get` を使ってDaoの実装クラスを取得した場合、`DomaConfig` を使用してDaoの実装クラスが構築される。

<details>
<summary>keywords</summary>

DomaConfig 移行, Dao config属性削除, DomaDaoRepository#get, DomaDaoRepository, @Dao config属性, @Transactional

</details>

## 移行パターン2: DomaTransactionNotSupportedConfigを使用した遅延ロードからの移行

Jakarta Batchに準拠したバッチアプリケーションで遅延ロードに対応するため `DomaTransactionNotSupportedConfig` を使用した実装は、config属性を削除し `DomaDaoRepository#get` の第2引数に `DomaTransactionNotSupportedConfig.class` を指定することで移行できる。

**移行前:**

```java
// Daoの定義
@Dao(config = DomaTransactionNotSupportedConfig.class)  /* config属性を指定 */
public interface ProjectDao {

    @Select(strategy = SelectType.RETURN)
    Stream<Project> search();
}

// Daoを使用する実装例
@Dependent
@Named
public class ProjectReader extends AbstractItemReader {

    private Iterator<Project> iterator;
    private Stream<Project> stream;

    @Override
    public void open(Serializable checkpoint) throws Exception {
        /* DomaDaoRepository#getにはDaoのインターフェースのみを指定 */
        final ProjectDao dao = DomaDaoRepository.get(ProjectDao.class);
        stream = dao.search();
        iterator = stream.iterator();
    }

    // 省略
}
```

**移行後:**

```java
// Daoの定義
@Dao  /* config属性の指定を削除 */
public interface ProjectDao {

    @Select(strategy = SelectType.RETURN)
    Stream<Project> search();
}

// Daoを使用する実装例
@Dependent
@Named
public class ProjectReader extends AbstractItemReader {

    private Iterator<Project> iterator;
    private Stream<Project> stream;

    @Override
    public void open(Serializable checkpoint) throws Exception {
        /* DomaDaoRepository#getの第2引数にDomaTransactionNotSupportedConfig.classを指定 */
        final ProjectDao dao = DomaDaoRepository.get(ProjectDao.class, DomaTransactionNotSupportedConfig.class);
        stream = dao.search();
        iterator = stream.iterator();
    }

    // 省略
}
```

Daoアノテーションにconfig属性を指定しないDaoを使用して `DomaDaoRepository#get(java.lang.Class, java.lang.Class)` を呼び出した場合、第2引数に指定したConfigを使用してDaoの実装クラスが構築される。

<details>
<summary>keywords</summary>

DomaTransactionNotSupportedConfig 移行, 遅延ロード 移行, Jakarta Batch 遅延ロード, DomaDaoRepository#get 第2引数, DomaDaoRepository.get(Class, Class), @Select, @Dependent, @Named, AbstractItemReader

</details>

## 移行パターン3: 独自Configクラスを作成している場合の移行

複数のデータベースにアクセスする等の理由で独自にConfigクラスを作成している場合、`@SingletonConfig` アノテーションを削除してpublicな引数なしコンストラクタに変更し、`DomaDaoRepository#get` の第2引数にConfigクラスを渡すことで移行できる。

**移行前:**

```java
// Configクラスの定義
@SingletonConfig  /* SingletonConfigアノテーションを付与 */
public final class CustomConfig implements Config {

    private CustomConfig() {  /* コンストラクタはprivate */
        // 省略
    }

    // 省略
}

// Daoの定義
@Dao(config = CustomConfig.class)  /* config属性に作成したConfigクラスを指定 */
public interface ProjectDao {
    // 省略
}

// Daoを使用する実装例
public HttpResponse create(final HttpRequest request, final ExecutionContext context) {
    final Project project = SessionUtil.delete(context, "project");

    CustomConfig.singleton()
            .getTransactionManager()
            .requiresNew(() ->
                    /* DomaDaoRepository#getにはDaoのインターフェースのみを指定 */
                    DomaDaoRepository.get(ProjectDao.class);

    return new HttpResponse("redirect://complete");
}
```

**移行後:**

```java
// Configクラスの定義
/* SingletonConfigアノテーションを削除 */
public final class CustomConfig implements Config {

    public CustomConfig() {  /* publicな引数なしのコンストラクタに変更 */
        // 省略
    }

    // 省略
}

// Daoの定義
@Dao  /* config属性の指定を削除 */
public interface ProjectDao {
    // 省略
}

// Daoを使用する実装例
public HttpResponse create(final HttpRequest request, final ExecutionContext context) {
    final Project project = SessionUtil.delete(context, "project");

    CustomConfig.singleton()
            .getTransactionManager()
            .requiresNew(() ->
                    /* DomaDaoRepository#getの第2引数に作成したConfigのClassクラスを指定 */
                    DomaDaoRepository.get(ProjectDao.class, CustomConfig.class);

    return new HttpResponse("redirect://complete");
}
```

Daoアノテーションにconfig属性を指定しないDaoを使用して `DomaDaoRepository#get(java.lang.Class, java.lang.Class)` を呼び出した場合、第2引数に指定したConfigを使用してDaoの実装クラスが構築される。

<details>
<summary>keywords</summary>

独自Config 移行, CustomConfig 移行, SingletonConfig削除, SingletonConfig アノテーション, DomaDaoRepository.get(Class, Class), 複数データベース Config移行

</details>
