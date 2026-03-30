# データベース接続部品の構造

## インタフェース定義

**パッケージ**: `nablarch.core.db.connection`

| インタフェース名 | 概要 |
|---|---|
| `ConnectionFactory` | データベース接続を生成するインターフェース。接続方式を追加する場合や、実装クラスで生成される`BasicDbConnection`を入れ替える場合には、本インタフェースの実装クラスを追加する必要がある。 |
| `AppDbConnection` | データベース接続を保持するインタフェース。アプリケーションはSQL文実行用オブジェクトの取得に使用する。 |
| `TransactionManagerConnection` | トランザクション制御インタフェース（`AppDbConnection`のサブインタフェース）。リソース解放機能は本インタフェースの実装クラスで提供される。 |

<details>
<summary>keywords</summary>

ConnectionFactory, AppDbConnection, TransactionManagerConnection, データベース接続, インタフェース定義, nablarch.core.db.connection

</details>

## クラス定義

### ConnectionFactoryの実装クラス（nablarch.core.db.connection）

| クラス名 | 概要 |
|---|---|
| `ConnectionFactorySupport` | `ConnectionFactory`インタフェースの実装クラスをサポートするクラス。サブクラスで必要な共通設定を保持するのみ。 |
| `BasicDbConnectionFactoryForJndi` | JNDI経由でWebアプリケーションサーバ等からデータベース接続（`java.sql.Connection`）を取得し、`BasicDbConnection`を生成するクラス。設定方法は [database-connection-config-from-jndi-label](#) 参照。 |
| `BasicDbConnectionFactoryForDataSource` | `javax.sql.DataSource`からデータベース接続（`java.sql.Connection`）を取得し、`BasicDbConnection`を生成するクラス。設定方法は [db-connection-config-label](#) 参照。 |

### TransactionManagerConnectionの実装クラス（nablarch.core.db.connection）

| クラス名 | 概要 |
|---|---|
| `BasicDbConnection` | `TransactionManagerConnection`（`AppDbConnection`）の基本実装クラス。データベースベンダー非依存の実装。各プロジェクトでDBベンダー依存の実装が必要な場合は、`TransactionManagerConnection`の実装クラスを新たに追加して本クラスから差し替えること。 |

### その他のクラス（nablarch.core.db.transaction）

| クラス名 | 概要 |
|---|---|
| `SimpleDbTransactionManager` | 簡易的にトランザクション制御を行うクラス。トランザクション開始で`AppDbConnection`が生成され、`DbConnectionContext`に設定される。 |
| `SimpleDbTransactionExecutor` | `SimpleDbTransactionManager`を使用してSQL文を実行するための抽象クラス。本クラス経由でSQL文を実行することで、全機能で統一的な例外処理を提供できる。 |

### DbConnectionContext（nablarch.core.db.connection）

`AppDbConnection`をThreadLocalで保持するクラス。保持する`AppDbConnection`には任意の名前（データベースコネクション名）を付加できる。詳細は [04_TransactionConnectionName](libraries-04_TransactionConnectionName.md) 参照。

> **警告**: `AppDbConnection`はThreadLocalで管理されるため、アプリケーションのスレッドと同一スレッドで設定する必要がある。マルチスレッド環境では各スレッドに対して個別に`AppDbConnection`を設定すること。

<details>
<summary>keywords</summary>

ConnectionFactorySupport, BasicDbConnectionFactoryForJndi, BasicDbConnectionFactoryForDataSource, BasicDbConnection, SimpleDbTransactionManager, SimpleDbTransactionExecutor, DbConnectionContext, nablarch.core.db.transaction, ThreadLocal, データベース接続クラス, トランザクション制御

</details>

## SimpleDbTransactionExecutorを使用したSQL実行例

> **注意**: `SimpleDbTransactionExecutor`は、既に開始されている業務トランザクション以外のトランザクションでSQL文を実行する場合に使用する。主に認証機能や開閉局チェック機能など、ビジネスロジックとは独立したトランザクションが必要なコンポーネントで使用する。アプリケーションプログラマが`SimpleDbTransactionManager`や`SimpleDbTransactionExecutor`を直接参照する実装を行うことは通常ない。

```java
// リポジトリからSimpleDbTransactionManagerを取得
SimpleDbTransactionManager transactionManager =
    (SimpleDbTransactionManager) SystemRepository.getObject("transactionManager");

// SimpleDbTransactionExecutorを継承してexecuteメソッドを実装し、doTransactionを呼び出す
SqlResultSet resultSet = new SimpleDbTransactionExecutor<SqlResultSet>(transactionManager) {
    @Override
    public SqlResultSet execute(AppDbConnection connection) {
        SqlPStatement prepared = connection.prepareStatement(query);
        prepared.setString(1, requestId);
        prepared.setString(2, requestTableServiceAvailableOkStatus);
        return prepared.retrieve();
    }
}.doTransaction();
```

<details>
<summary>keywords</summary>

SimpleDbTransactionExecutor, SimpleDbTransactionManager, AppDbConnection, SqlResultSet, SqlPStatement, SystemRepository, doTransaction, execute, SQL実行, 独立トランザクション, 認証機能

</details>

## DataSourceを使用したデータベース接続設定

DataSourceからデータベース接続を取得する場合の設定例。JNDI経由の場合は [database-connection-config-from-jndi-label](#) 参照。

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

### SimpleDbTransactionManagerの設定

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| connectionFactory | ○ | `nablarch.core.db.connection.ConnectionFactory`の実装クラスを設定する |
| transactionFactory | ○ | `nablarch.core.transaction.TransactionFactory`の実装クラスを設定する |
| dbTransactionName | | データベーストランザクション名を任意の値で設定する。未設定の場合はデフォルト値が自動設定される |

### BasicDbConnectionFactoryForDataSourceの設定

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| statementReuse | ○ | Statementをキャッシュするか否かを`true`/`false`で設定する |
| dataSource | ○ | `javax.sql.DataSource`の実装クラスを設定する |
| statementFactory | ○ | `nablarch.core.statement.StatementFactory`の実装クラスを設定する |

> **注意**: `statementReuse=true`の場合、同一SQLの2回目以降はキャッシュされた`Statement`オブジェクトが使用される。同一SQLを繰り返し実行するバッチ処理では効果的。画面処理では同一SQLを繰り返し実行することが少ないため、本機能のメリットは小さい。

### JdbcTransactionFactoryの設定

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| isolationLevel | | READ_COMMITTED | アイソレーションレベル。設定可能値: `READ_COMMITTED`, `READ_UNCOMMITTED`, `REPEATABLE_READ`, `SERIALIZABLE` |
| initSqlList | | | トランザクション開始時に実行するSQL文をlist形式で設定する |

> **注意**: データベースによって使用できるアイソレーションレベルが異なる。各DBベンダーのマニュアルを参照して適切なレベルを設定すること。

<details>
<summary>keywords</summary>

BasicDbConnectionFactoryForDataSource, BasicStatementFactory, BasicSqlStatementExceptionFactory, SimpleDbTransactionManager, JdbcTransactionFactory, statementReuse, dataSource, statementFactory, connectionFactory, transactionFactory, dbTransactionName, isolationLevel, initSqlList, DataSource設定, アイソレーションレベル

</details>

## JNDIを使用したデータベース接続設定

JNDI経由でデータベース接続を取得する場合の設定例。JNDI非関連の設定は [db-connection-config-label](#) 参照。

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
    <property name="statementReuse" value="true"/>
</component>
```

### BasicDbConnectionFactoryForJndiの設定

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| statementReuse | ○ | :ref:`BasicDbConnectionFactoryForDataSourceの設定<db-dataSourceConnectionFactory-label>` の同一項目参照 |
| statementFactory | ○ | :ref:`BasicDbConnectionFactoryForDataSourceの設定<db-dataSourceConnectionFactory-label>` の同一項目参照 |
| jndiProperties | | JNDI経由でDataSourceを取得するための環境設定。WebサーバがあるかJNDIプロパティファイルが存在する場合は省略可。設定例はWebLogicサーバ上にDataSourceが登録されている場合を想定。 |
| jndiResourceName | ○ | JNDIリソース名。WebLogicの場合は管理コンソールのDataSource登録時に「JNDI Name」に入力した値を設定する |

<details>
<summary>keywords</summary>

BasicDbConnectionFactoryForJndi, BasicStatementFactory, BasicSqlStatementExceptionFactory, jndiProperties, jndiResourceName, statementReuse, statementFactory, JNDI設定, WebLogic, データソース取得

</details>
