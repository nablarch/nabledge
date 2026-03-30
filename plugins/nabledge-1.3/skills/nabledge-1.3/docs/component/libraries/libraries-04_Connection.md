# データベース接続部品の構造

## データベース接続部品の構造

本機能で提供する接続方式については、[db-summary-label](libraries-04_DbAccessSpec.md) を参照すること。

![データベース接続部品クラス図](../../../knowledge/component/libraries/assets/libraries-04_Connection/DbAccessSpec_ConnectionClassDesign.jpg)

### a) SimpleDbTransactionManagerの設定

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| connectionFactory | ○ | `nablarch.core.db.connection.ConnectionFactory` を実装したクラスを設定する |
| transactionFactory | ○ | `nablarch.core.transaction.TransactionFactory` を実装したクラスを設定する |
| dbTransactionName | | データベーストランザクション名。未設定の場合、デフォルトのトランザクション名が自動設定される |

### b) BasicDbConnectionFactoryForDataSourceの設定

**クラス**: `nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource`

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| statementReuse | ○ | Statementをキャッシュするか否か（true/false）。trueの場合、`BasicDbConnection` のインスタンス単位でStatementオブジェクトがキャッシュされる |
| dataSource | ○ | `javax.sql.DataSource` を実装したクラスを設定する。サンプルでは `oracle.jdbc.pool.OracleDataSource` を設定。設定する値は各データベースベンダーのJDBC関連ドキュメントを参照すること |
| statementFactory | ○ | `nablarch.core.statement.StatementFactory` を実装したクラスを設定する。サンプルでは `nablarch.core.db.statement.BasicStatementFactory` を設定（[db-sqlstatement-label](libraries-04_Statement.md) 参照） |
| dbAccessExceptionFactory | ○ | `DbAccessExceptionFactory` を実装したクラスを設定する |

> **注意**: statementReuse=trueは、同一SQLを繰り返し実行するバッチ処理で効果が期待できる。画面処理では同一SQLの繰り返し実行が少なく効果は限定的。

### c) JdbcTransactionFactoryへの設定

**クラス**: `nablarch.core.db.transaction.JdbcTransactionFactory`

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| isolationLevel | | アイソレーションレベル。未設定時はREAD_COMMITTEDが設定される。設定可能値: READ_COMMITTED、READ_UNCOMMITTED、REPEATABLE_READ、SERIALIZABLE |
| initSqlList | | トランザクション開始時に実行するSQL文のリスト。不要な場合は設定不要 |

> **注意**: データベースによって使用できるアイソレーションレベルが限られる。データベースベンダーのマニュアルを参照すること。

### d) BasicDbAccessExceptionFactoryへの設定

**クラス**: `nablarch.core.db.connection.exception.BasicDbAccessExceptionFactory`

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| sql | ○ | データベースへの接続が有効かどうかを問い合わせるSQL文。負荷の少ないSQL文を設定すること（例: Oracleの場合 `select '1' from dual`） |

<details>
<summary>keywords</summary>

データベース接続部品, ConnectionFactory, AppDbConnection, TransactionManagerConnection, DbConnectionContext, クラス図, SimpleDbTransactionManager, BasicDbConnectionFactoryForDataSource, JdbcTransactionFactory, BasicDbAccessExceptionFactory, TransactionFactory, StatementFactory, DbAccessExceptionFactory, BasicDbConnection, DataSource, BasicStatementFactory, OracleDataSource, connectionFactory, transactionFactory, dbTransactionName, statementReuse, dataSource, statementFactory, dbAccessExceptionFactory, isolationLevel, initSqlList, データベース接続設定, トランザクション設定, アイソレーションレベル, Statementキャッシュ, 接続ファクトリ設定

</details>

## 各クラスの責務

**パッケージ**: `nablarch.core.db.connection`

| インタフェース名 | 概要 |
|---|---|
| `ConnectionFactory` | DB接続を生成するインターフェース。接続方式追加や :ref:`実装クラス<db-connectionFactory-sub-label>` で生成されるBasicDbConnectionを差替える場合、本インターフェースの実装クラスを追加する必要がある。 |
| `AppDbConnection` | DB接続を保持するインターフェース。アプリケーションからSQL文実行用オブジェクトを取得する際に使用。 |
| `TransactionManagerConnection` | トランザクション制御インターフェース（AppDbConnectionのサブインターフェース）。[リソース解放機能](libraries-04_DbAccessSpec.md) はこのインターフェースの実装クラスで提供される。 |
| `DbAccessExceptionFactory` | DBアクセス例外に応じたDbAccessExceptionを生成するインターフェース。SQLExceptionのエラーコードなどを元にDbAccessExceptionを生成する。 |

JNDI経由でデータベース接続を取得する際の設定例。JNDI関連以外の設定は [db-connection-config-label](#s5) を参照。

**クラス**: `nablarch.core.db.connection.BasicDbConnectionFactoryForJndi`

```xml
<component class="nablarch.core.db.connection.BasicDbConnectionFactoryForJndi">
    <property name="jndiProperties">
        <map>
            <entry key="java.naming.factory.initial" value="weblogic.jndi.WLInitialContextFactory"/>
            <entry key="java.naming.provider.url" value="t3://localhost:7001"/>
        </map>
    </property>
    <property name="jndiResourceName" value="NablarchDataSource"/>
    <property name="statementFactory">
        <component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
            <property name="fetchSize" value="500"/>
            <property name="queryTimeout" value="600" />
            <property name="sqlStatementExceptionFactory">
                <component class="nablarch.core.db.statement.exception.BasicSqlStatementExceptionFactory">
                    <property name="duplicateErrorSqlState" value=""/>
                    <property name="duplicateErrorErrCode" value="1"/>
                </component>
            </property>
        </component>
    </property>
    <property name="statementReuse" value="true"/>
    <property name="dbAccessExceptionFactory">
        <component name="dbAccessExceptionFactory" class="nablarch.core.db.connection.exception.BasicDbAccessExceptionFactory">
            <property name="sql" value="select * from dual" />
        </component>
    </property>
</component>
```

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| statementReuse | ○ | :ref:`BasicDbConnectionFactoryForDataSourceへの設定<db-dataSourceConnectionFactory-label>` の同一項目を参照 |
| statementFactory | ○ | :ref:`BasicDbConnectionFactoryForDataSourceへの設定<db-dataSourceConnectionFactory-label>` の同一項目を参照 |
| dbAccessExceptionFactory | ○ | :ref:`BasicDbConnectionFactoryForDataSourceへの設定<db-dataSourceConnectionFactory-label>` の同一項目を参照 |
| jndiProperties | | JNDI経由でDataSourceを取得するための環境設定。Webサーバ上で稼働または `jndi.properties` をクラスパス配下に配置している場合は省略可。設定詳細はWebサーバのベンダーマニュアルを参照すること |
| jndiResourceName | ○ | JNDIリソース名。設定詳細はWebサーバのベンダーマニュアルを参照すること（例: WebLogicサーバの場合は、管理コンソールからDataSourceを登録する際に「JNDI Name」に入力した値を設定する） |

<details>
<summary>keywords</summary>

ConnectionFactory, AppDbConnection, TransactionManagerConnection, DbAccessExceptionFactory, データベース接続インターフェース, トランザクション制御, リソース解放, BasicDbConnectionFactoryForJndi, BasicStatementFactory, BasicSqlStatementExceptionFactory, BasicDbAccessExceptionFactory, WLInitialContextFactory, jndiProperties, jndiResourceName, statementReuse, statementFactory, dbAccessExceptionFactory, sqlStatementExceptionFactory, fetchSize, queryTimeout, duplicateErrorSqlState, duplicateErrorErrCode, JNDI接続設定, DataSource取得, WebLogic設定, データベース接続

</details>

## nablarch.core.db.connectionパッケージ

**a) ConnectionFactory実装クラス** (`nablarch.core.db.connection`パッケージ)

| クラス名 | 概要 |
|---|---|
| `ConnectionFactorySupport` | ConnectionFactoryの実装クラスをサポートするクラス。サブクラスで必要な共通設定を保持するのみ。 |
| `BasicDbConnectionFactoryForJndi` | JNDI経由でWebアプリケーションサーバ等からDB接続を取得しBasicDbConnectionを生成するクラス。設定方法は [database-connection-config-from-jndi-label](#) を参照。 |
| `BasicDbConnectionFactoryForDataSource` | `javax.sql.DataSource` からDB接続を取得しBasicDbConnectionを生成するクラス。設定方法は [db-connection-config-label](#s5) を参照。 |

**b) TransactionManagerConnection実装クラス** (`nablarch.core.db.connection`パッケージ)

**クラス**: `BasicDbConnection`
TransactionManagerConnection（AppDbConnection）の基本実装クラス。DBベンダー非依存の実装。ベンダー依存実装が必要な場合はTransactionManagerConnectionの実装クラスを新規追加して差替えること。

**c) DbAccessExceptionFactory関連クラス** (`nablarch.core.db.connection.exception`パッケージ)

| クラス名 | 概要 |
|---|---|
| `BasicDbAccessExceptionFactory` | DbAccessExceptionFactoryの基本実装。設定されたSQL文を実行して接続切断を判定し、実行失敗時はDbConnectionException、成功時はDbAccessExceptionを送出する。 |
| `DbAccessException` | DBアクセス時例外クラス。SQLExceptionの内容によりサブクラスが送出される場合がある。 |
| `DbConnectionException` | DB接続切断時例外クラス。DbAccessExceptionのサブクラス。 |

> **注意**: BasicDbAccessExceptionFactoryに設定したSQL文が実行不可（構文エラー・オブジェクト不存在）な場合、必ずSQL実行に失敗しDbConnectionExceptionが送出される。

**d) その他のクラス** (`nablarch.core.db.transaction`パッケージ)

| クラス名 | 概要 |
|---|---|
| `SimpleDbTransactionManager` | 簡易トランザクション制御クラス。トランザクション開始時にAppDbConnectionが生成されDbConnectionContextに設定される。 |
| `SimpleDbTransactionExecutor` | SimpleDbTransactionManagerを使用してSQL文を実行するための抽象クラス。全機能で統一的な例外処理を提供。 |

`nablarch.core.db.connection`パッケージ:

**クラス**: `DbConnectionContext`
AppDbConnectionをThreadLocalで保持するクラス。任意の名前（データベースコネクション名）を付加できる。詳細は [04_TransactionConnectionName](libraries-04_TransactionConnectionName.md) を参照。

> **注意**: ThreadLocalでAppDbConnectionが管理されるため、アプリケーションスレッドと同一スレッドでAppDbConnectionを設定する必要がある。マルチスレッド環境では各スレッドに対してAppDbConnectionを設定すること。

<details>
<summary>keywords</summary>

BasicDbConnectionFactoryForJndi, BasicDbConnectionFactoryForDataSource, ConnectionFactorySupport, BasicDbConnection, BasicDbAccessExceptionFactory, DbAccessException, DbConnectionException, SimpleDbTransactionManager, SimpleDbTransactionExecutor, DbConnectionContext, データベース接続実装クラス, ThreadLocal

</details>

## 処理シーケンス

![処理シーケンス図](../../../knowledge/component/libraries/assets/libraries-04_Connection/DbAccessSpec_ConnectionSequence.jpg)

<details>
<summary>keywords</summary>

処理シーケンス, データベース接続処理フロー, SimpleDbTransactionManager, トランザクション制御フロー

</details>

## Javaの実装例

> **注意**: SimpleDbTransactionExecutorを使用するのは、既に開始されている業務トランザクション以外のトランザクションを使用してSQL文を実行する場合。主にWebアプリケーションの認証機能や開閉局チェック機能のような、ビジネスロジックとは異なる独立したトランザクションが必要なコンポーネントで使用する。

```java
// ******** 注意 ********
// SimpleDbTransactionManagerは、フレームワーク専用のトランザクション制御クラスである。
// このため、アプリケーションプログラマがSimpleDbTransactionManagerや、
// SimpleDbTransactionExecutorを参照する下記のような実装を行うことはない。

// リポジトリからSimpleDbTransactionManagerを取得
SimpleDbTransactionManager transactionManager =
    (SimpleDbTransactionManager) SystemRepository.getObject("transactionManager");

// SimpleDbTransactionExecutorを継承しexecuteメソッドを実装
SqlResultSet resultSet = new SimpleDbTransactionExecutor<SqlResultSet>(transactionManager) {
    @Override
    public SqlResultSet execute(AppDbConnection connection) {
        SqlPStatement prepared = connection.prepareStatement(query);
        int parameterIndex = 1;
        prepared.setString(parameterIndex++, requestId);
        prepared.setString(parameterIndex, requestTableServiceAvailableOkStatus);
        return prepared.retrieve();
    }
// SimpleDbTransactionExecutorを実装したクラスのdoTransactionを実行する。
// これにより、上記で説明したexecuteメソッドがコールバックされSQL文を簡易的に実行することが可能となる。
}.doTransaction();
```

DataSourceを使用する設定例 ([db-connection-config-label](#s5)):

```xml
<component name="transactionManager" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
    <property name="connectionFactory">
        <component class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
            <property name="statementReuse" value="true"/>
            <property name="dataSource">
                <component class="oracle.jdbc.pool.OracleDataSource">
                    <property name="user" value="ssd"/>
                    <property name="password" value="ssd"/>
                    <property name="URL" value="jdbc:oracle:thin:ssd/ssd@localhost:1521/xe"/>
                </component>
            </property>
            <property name="statementFactory">
                <component name="statementFactory"
                           class="nablarch.core.db.statement.BasicStatementFactory">
                    <property name="fetchSize" value="500"/>
                    <property name="queryTimeout" value="600" />
                    <property name="sqlStatementExceptionFactory">
                        <component class="nablarch.core.db.statement.exception.BasicSqlStatementExceptionFactory">
                            <property name="duplicateErrorSqlState" value=""/>
                            <property name="duplicateErrorErrCode" value="1"/>
                        </component>
                    </property>
                </component>
            </property>
            <property name="dbAccessExceptionFactory">
                <component name="dbAccessExceptionFactory"
                           class="nablarch.core.db.connection.exception.BasicDbAccessExceptionFactory">
                    <property name="sql" value="select * from dual" />
                </component>
            </property>
        </component>
    </property>
    <property name="transactionFactory">
        <component class="nablarch.core.db.transaction.JdbcTransactionFactory">
            <property name="isolationLevel" value="READ_COMMITTED"/>
            <property name="initSqlList">
                <list>
                    <value>ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'yyyy-mm-dd hh24:mi:ss.ff'</value>
                </list>
            </property>
        </component>
    </property>
    <property name="dbTransactionName" value="generator-transaction"/>
</component>
```

<details>
<summary>keywords</summary>

SimpleDbTransactionExecutor, SimpleDbTransactionManager, BasicDbConnectionFactoryForDataSource, BasicStatementFactory, BasicDbAccessExceptionFactory, BasicSqlStatementExceptionFactory, JdbcTransactionFactory, SqlPStatement, SqlResultSet, DataSource設定, Java実装例, XML設定例, doTransaction

</details>
