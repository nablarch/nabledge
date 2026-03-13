# Domaアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/doma_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/Transactional.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/DomaConfig.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/DomaDaoRepository.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/batch/ee/listener/DomaTransactionStepListener.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/batch/ee/listener/DomaTransactionItemWriteListener.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/DomaTransactionNotSupportedConfig.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/ConnectionFactoryFromDomaConnection.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/NablarchJdbcLogger.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/doma/DomaStatementProperties.html)

## モジュール一覧

Doma2を使用したデータベースアクセスを行うためのアダプタ。`Transactional` インターセプタで指定したアクションのみトランザクション管理対象にでき、不要なトランザクション制御処理を削減してパフォーマンス向上が期待できる。

メリット:
- Nablarchと同様に実行時に動的SQL文構築可能
- 2waySQLなのでSQLツールでそのまま実行可能

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-doma-adaptor</artifactId>
</dependency>
```

> **補足**: Domaバージョン2.16.0でテスト済み。バージョン変更時はプロジェクト側でテストを行うこと。

<details>
<summary>keywords</summary>

nablarch-doma-adaptor, Doma2, DomaAdapter, Transactional, データベースアクセス, トランザクション管理, 2waySQL

</details>

## Domaアダプタを使用するための設定を行う

RDBMSに合わせてDomaのダイアレクトとデータソースをコンポーネント設定ファイルに定義する。

- ダイアレクトは `org.seasar.doma.jdbc.dialect.Dialect` の実装クラスを指定
- ダイアレクトのコンポーネント名は `domaDialect`
- データソースのコンポーネント名は `dataSource`

H2使用時の設定例:
```xml
<component name="domaDialect" class="org.seasar.doma.jdbc.dialect.H2Dialect" />
<component name="dataSource" class="org.h2.jdbcx.JdbcDataSource">
  <!-- プロパティは省略 -->
</component>
```

<details>
<summary>keywords</summary>

domaDialect, dataSource, H2Dialect, Dialect, コンポーネント設定, データソース設定

</details>

## Domaを使用してデータベースにアクセスする

**Daoインタフェースの作成**:
- `@Dao` のconfig属性には `DomaConfig` を指定

```java
@Dao(config = DomaConfig.class)
public interface ProjectDao {
    // 省略
}
```

**データベースアクセス処理の実装**:
- 業務アクションメソッドに `Transactional` インターセプタを設定してトランザクション管理対象にする
- `DomaDaoRepository#get` でDaoの実装クラスをルックアップする

> **補足**: Domaは注釈処理によりコンパイル時にDao実装クラスを自動生成するため、コーディング時には実装クラスが存在しない。DomaDaoRepositoryがDao実装クラスのルックアップ機能を提供する。

```java
@Transactional
public HttpResponse create(final HttpRequest request, final ExecutionContext context) {
    final Project project = SessionUtil.delete(context, "project");
    DomaDaoRepository.get(ProjectDao.class).insert(project);
    return new HttpResponse("redirect://complete");
}
```

<details>
<summary>keywords</summary>

DomaConfig, DomaDaoRepository, Transactional, @Dao, Daoインタフェース, DomaDaoRepository#get, データベースアクセス実装

</details>

## 別トランザクションで実行する

`Transactional` インターセプタで開始されたトランザクションとは別のトランザクションを使用する場合は、`DomaConfig#getTransactionManager` で取得した `TransactionManager` を使用して制御する。

```java
DomaConfig.singleton()
        .getTransactionManager()
        .requiresNew(() ->
                DomaDaoRepository.get(ProjectDao.class).insert(project);
```

<details>
<summary>keywords</summary>

DomaConfig, getTransactionManager, TransactionManager, requiresNew, 別トランザクション

</details>

## JSR352に準拠したバッチアプリケーションで使用する

JSR352準拠のバッチアプリケーションでDomaを使用するため、以下のリスナーをリスナーリストに定義する:
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

> **重要**: [Chunkステップ](../../processing-pattern/jakarta-batch/jakarta-batch-architecture.md) のItemWriterでバッチ更新（バッチinsert/updateなど）する場合、バッチサイズを明示的に指定すること。Chunkステップのitem-countのサイズがバッチサイズになるわけではない。未指定の場合はDomaのデフォルト値が適用され、バッチ更新のパフォーマンスが向上しない可能性がある。

1000件ごとにバッチinsertする実装例:
```java
@BatchInsert(batchSize = 1000)
int[] batchInsert(List<Bonus> bonuses);
```

<details>
<summary>keywords</summary>

DomaTransactionStepListener, DomaTransactionItemWriteListener, stepListeners, itemWriteListeners, @BatchInsert, batchSize, JSR352, バッチ更新

</details>

## JSR352に準拠したバッチアプリケーションで遅延ロードを行う

大量データの遅延ロードを行う場合は、Daoアノテーションのconfig属性に `DomaTransactionNotSupportedConfig` を指定する。

> **重要**: config属性に `DomaConfig` を使用すると、`DomaTransactionItemWriteListener` によるトランザクションコミットでストリームがクローズされ、後続のレコードが読み込めなくなる。

**Daoインタフェース**（config属性に `DomaTransactionNotSupportedConfig` を指定、検索結果は `Stream` で取得）:
```java
@Dao(config = DomaTransactionNotSupportedConfig.class)
public interface ProjectDao {
    @Select(strategy = SelectType.RETURN)
    Stream<Project> search();
}
```

**ItemReaderクラス**（openメソッドでストリーム取得、closeメソッドで必ずストリームを閉じること）:
```java
@Dependent
@Named
public class ProjectReader extends AbstractItemReader {
    private Iterator<Project> iterator;
    private Stream<Project> stream;

    @Override
    public void open(Serializable checkpoint) throws Exception {
        final ProjectDao dao = DomaDaoRepository.get(ProjectDao.class);
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

<details>
<summary>keywords</summary>

DomaTransactionNotSupportedConfig, 遅延ロード, Stream, AbstractItemReader, 大量データ読み込み, DomaTransactionItemWriteListener, @Select, SelectType, @Dependent, @Named

</details>

## ETLで使用する

ETL使用時にプロジェクトで追加したステップでDomaを使用する場合は、ジョブ名およびステップ名を指定したリスナーリストを定義する。

ジョブ定義ファイル:
```xml
<job id="sampleJob" xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="1.0">
  <step id="sampleStep">
    <listeners>
      <listener ref="nablarchStepListenerExecutor" />
      <listener ref="nablarchItemWriteListenerExecutor" />
    </listeners>
    <chunk>
      <reader ref="sampleItemReader" />
      <writer ref="sampleItemWriter" />
    </chunk>
  </step>
</job>
```

コンポーネント設定ファイル（リスト名は `{ジョブ名}.{ステップ名}.stepListeners` / `{ジョブ名}.{ステップ名}.itemWriteListeners`）:
```xml
<list name="sampleJob.sampleStep.stepListeners">
  <!-- その他のリスナーは省略 -->
  <component
      class="nablarch.integration.doma.batch.ee.listener.DomaTransactionStepListener" />
</list>

<list name="sampleJob.sampleStep.itemWriteListeners">
  <!-- その他のリスナーは省略 -->
  <component
      class="nablarch.integration.doma.batch.ee.listener.DomaTransactionItemWriteListener" />
</list>
```

<details>
<summary>keywords</summary>

ETL, stepListeners, itemWriteListeners, ジョブ定義, DomaTransactionStepListener, DomaTransactionItemWriteListener, ジョブ名, ステップ名

</details>

## 複数のデータベースにアクセスする

複数のデータベースにアクセスする場合は、新しいConfigクラスを作成し、別DBへのアクセスはそのConfigクラスを使用する。

コンポーネント設定ファイル:
```xml
<component name="customDomaDialect" class="org.seasar.doma.jdbc.dialect.OracleDialect" />
<component name="customDataSource" class="oracle.jdbc.pool.OracleDataSource">
  <!-- プロパティは省略 -->
</component>
```

Configクラス（`@SingletonConfig` 付与、`Config` を実装）:
```java
@SingletonConfig
public final class CustomConfig implements Config {
    private CustomConfig() {
        dialect = SystemRepository.get("customDomaDialect");
        localTransactionDataSource =
                new LocalTransactionDataSource(SystemRepository.get("customDataSource"));
        localTransaction = localTransactionDataSource.getLocalTransaction(getJdbcLogger());
        localTransactionManager = new LocalTransactionManager(localTransaction);
    }
    // その他のフィールド、メソッドはDomaConfigを参考に実装
}
```

Daoインタフェースのconfig属性に `CustomConfig` を指定:
```java
@Dao(config = CustomConfig.class)
public interface ProjectDao {
    // 省略
}
```

業務アクションでCustomConfigのTransactionManagerを使用:
```java
CustomConfig.singleton()
        .getTransactionManager()
        .requiresNew(() ->
                DomaDaoRepository.get(ProjectDao.class).insert(project);
```

<details>
<summary>keywords</summary>

CustomConfig, SingletonConfig, Config, 複数データベース, OracleDialect, SystemRepository, LocalTransactionDataSource, LocalTransactionManager

</details>

## DomaとNablarchのデータベースアクセスを併用する

データベースアクセスにDomaを採用した場合でも、NablarchのDBアクセス処理をDomaと同じトランザクション（DB接続）で実行したいケースがある。例えば、[メール送信ライブラリ](../libraries/libraries-mail.md) を使用する場合が該当する（:ref:`メール送信要求 <mail-request>` で [database](../libraries/libraries-database.md) を使用しているため）。

この問題を解決するには、`ConnectionFactoryFromDomaConnection` をコンポーネント定義ファイルに定義し、コンポーネント名を `connectionFactoryFromDoma` にする。JSR352用のDomaトランザクション制御リスナーに `ConnectionFactoryFromDomaConnection` を設定することで、NablarchのDBアクセスが自動的にDomaのトランザクション配下で実行される。

```xml
<!-- コンポーネント名は connectionFactoryFromDoma とする -->
<component name="connectionFactoryFromDoma"
    class="nablarch.integration.doma.ConnectionFactoryFromDomaConnection">
  <!-- プロパティに対する設定は省略 -->
</component>

<!-- JSR352バッチアプリケーションで使用する場合 -->
<component class="nablarch.integration.doma.batch.ee.listener.DomaTransactionItemWriteListener">
  <property name="connectionFactory" ref="connectionFactoryFromDoma" />
</component>

<component class="nablarch.integration.doma.batch.ee.listener.DomaTransactionStepListener">
  <property name="connectionFactory" ref="connectionFactoryFromDoma" />
</component>
```

<details>
<summary>keywords</summary>

ConnectionFactoryFromDomaConnection, connectionFactoryFromDoma, connectionFactory, Nablarchデータベースアクセス, 併用, DomaTransactionItemWriteListener, DomaTransactionStepListener

</details>

## ロガーを切り替える

本アダプタのデフォルトロガーは `NablarchJdbcLogger`（Nablarchのロガーを使用するDomaのJDBCロガー実装）。別のロガーに切り替える場合はコンポーネント定義ファイルに設定する。

- ロガーは `org.seasar.doma.jdbc.JdbcLogger` の実装クラスを指定
- コンポーネント名は `domaJdbcLogger`

`org.seasar.doma.jdbc.UtilLoggingJdbcLogger` を使用する場合:
```xml
<component name="domaJdbcLogger" class="org.seasar.doma.jdbc.UtilLoggingJdbcLogger" />
```

<details>
<summary>keywords</summary>

NablarchJdbcLogger, domaJdbcLogger, JdbcLogger, UtilLoggingJdbcLogger, ロガー設定

</details>

## java.sql.Statementに関する設定を行う

`java.sql.Statement` に関する項目（フェッチサイズ、クエリタイムアウト等）をプロジェクト全体に設定するには、`DomaStatementProperties` をコンポーネント設定ファイルに設定する。コンポーネント名は `domaStatementProperties`。

設定可能な項目: 最大行数の制限値、フェッチサイズ、クエリタイムアウト（秒）、バッチサイズ

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

DomaStatementProperties, domaStatementProperties, maxRows, fetchSize, queryTimeout, batchSize, フェッチサイズ, クエリタイムアウト

</details>
