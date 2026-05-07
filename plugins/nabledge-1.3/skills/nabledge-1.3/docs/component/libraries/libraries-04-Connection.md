# データベース接続部品の構造

本章では、データベース接続部分についての解説を行う。

本機能で提供する接続方式については、 [概要](../../component/libraries/libraries-04-DbAccessSpec.md#概要) を参照すること。

## クラス図

![DbAccessSpec_ConnectionClassDesign.jpg](../../../knowledge/assets/libraries-04-Connection/DbAccessSpec_ConnectionClassDesign.jpg)

### 各クラスの責務

#### インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| nablarch.core.db.connectionパッケージ |  |
| ConnectionFactory | データベース接続を生成するインターフェース。  データベース接続方式を追加する場合や、 [実装クラス](../../component/libraries/libraries-04-Connection.md#クラス定義) で生成されるBasicDbConnectionを入れ替える場合には、 本インタフェースの実装クラスを追加する必要がある。 |
| AppDbConnection | データベース接続を保持したインタフェース。  アプリケーションでは、本インタフェースを使用して、SQL文実行用オブジェクトを取得する。 |
| TransactionManagerConnection | トランザクション制御を行うインタフェース(AppDbConnectionのサブインタフェース)。  本機能の特徴である [リソース解放機能](../../component/libraries/libraries-04-DbAccessSpec.md#頻繁に使用するデータベースリソースの自動解放機能) は、本インタフェースの実装クラスで提供される。 |
| DbAccessExceptionFactory | データベースへのアクセス例外に応じたDbAccessExceptionを生成するインタフェース。  データベースアクセス時に発生したSQLExceptionの内容（エラーコードなど）を元に、 DbAccessExceptionを生成する。 |

#### クラス定義

a) nablarch.core.db.connection.ConnectionFactoryの実装クラス

| クラス名 | 概要 |
|---|---|
| nablarch.core.db.connectionパッケージ |  |
| ConnectionFactorySupport | ConnectionFactoryインタフェースを実装したクラスをサポートするクラス。  本クラスの実装は、サブクラスで必要となる共通設定を保持するのみである。 |
| BasicDbConnectionFactoryForJndi | JNDI経由でWebアプリケーションサーバ等からデータベース接続(java.sql.Connection)を取得し、 BasicDbConnectionを生成するクラス。  JNDI経由でデータベース接続を取得するための情報は、 [リポジトリ](../../component/libraries/libraries-02-Repository.md) を使用して本クラスに設定をする必要がある。 設定ファイルの記述方法は、 [設定ファイル例(JNDIを使用してデータベース接続を行う場合)](../../component/libraries/libraries-04-Connection.md#設定ファイル例jndiを使用してデータベース接続を行う場合) を参照すること。 |
| BasicDbConnectionFactoryForDataSource | javax.sql.DataSourceからデータベース接続(java.sql.Connection)を取得し、 BasicDbConnectionを生成するクラス。  javax.sql.DataSourceは、 [リポジトリ](../../component/libraries/libraries-02-Repository.md) を使用して本クラスに設定をする必要がある。 設定ファイルの記述方法は、 [設定ファイル例(DataSourceを使用してデータベース接続を行う場合)](../../component/libraries/libraries-04-Connection.md#設定ファイル例datasourceを使用してデータベース接続を行う場合) を参照すること。 |

b) nablarch.core.db.connection.TransactionManagerConnectionの実装クラス

| クラス名 | 概要 |
|---|---|
| nablarch.core.db.connectionパッケージ |  |
| BasicDbConnection | TransactionManagerConnection(AppDbConnection)の基本実装クラス。  > **Note:** > 本クラスは、データベースベンダー非依存の実装となっている。  > 各プロジェクトにおいて、データベースベンダーに依存するような実装が出てきた場合には、 > TransactionManagerConnectionの実装クラスを新たに追加し、本クラスから差し替えて使用すること。 |

c) DbAccessExceptionFactory関連クラス

| クラス名 | 概要 |
|---|---|
| nablarch.core.db.connection.exceptionパッケージ |  |
| BasicDbAccessExceptionFactory | DbAccessExceptionFactoryの基本実装クラス。  データベースアクセス例外がデータベースとの接続が切断したことを示す例外の場合、 DbConnectionExceptionを送出する。 これ以外の例外の場合には、DbAccessExceptionを送出する。  > **Note:** > データベースとの接続が切断されたか否かは、本クラスに設定されたSQL文を実行して確認する。 > SQL文の実行に失敗した場合には、データベースとの接続が切れていると判断し、 > DbConnectionExceptionを送出する。 > SQL文の実行に成功した場合には、データベースとの接続が切れていないと判断し、 > DbAccessExceptionを送出する。  > 本クラスに設定されたSQL文が実行不可能(構文エラーやオブジェクトが存在しない場合)な > 場合には、必ずSQL文の実行に失敗しDbConnectionExceptionが送出されるので注意すること。 |
| DbAccessException | データベース接続時に発生する例外クラス。  データベース接続時に発生したSQLExceptionの内容により、本クラスのサブクラスが 例外として送出される場合がある。 |
| DbConnectionException | データベース接続が切断された場合に発生する例外クラス。  本クラスは、DbAccessExceptionのサブクラス。 |

d) その他のクラス

| クラス名 | 概要 |
|---|---|
| nablarch.core.db.transactionパッケージ |  |
| SimpleDbTransactionManager | 簡易的にトランザクション制御を行うクラス。  本クラスを使用して、トランザクションを開始するとAppDbConnectionが生成され、DbConnectionContextに設定される。 |
| SimpleDbTransactionExecutor | SimpleDbTransactionManagerを使用してSQL文を実行するための抽象クラス。  本クラス経由でSQL文を実行することにより、全ての機能で統一的な例外処理を提供することが出来る。 |
| nablarch.core.db.connectionパッケージ |  |
| DbConnectionContext | AppDbConnectionをThreadLocalで保持するクラス。  保持するAppDbConnectionには、任意の名前(データベースコネクション名)を付加することができる。  データベースコネクション名の詳細は、下記ドキュメントを参照  04_TransactionConnectionName  > **Attention:** > ThreadLocalでAppDbConnectionが管理されるため、アプリケーションのスレッドと同一のスレッドでAppDbConnectionを設定する必要がある。 > マルチスレッド環境では、各スレッドに対してAppDbConnectionを設定する必要があるため、注意が必要である。 |

## トランザクション制御、データベースアクセスの使用例

### 処理シーケンス

![DbAccessSpec_ConnectionSequence.jpg](../../../knowledge/assets/libraries-04-Connection/DbAccessSpec_ConnectionSequence.jpg)

### Javaの実装例

```java
// ******** 注意 ********
// SimpleDbTransactionManagerは、フレームワーク専用のトランザクション制御クラスである。
// このため、アプリケーションプログラマがSimpleDbTransactionManagerや、
// SimpleDbTransactionExecutorを参照する下記のような実装を行うことはない。

// リポジトリからSimpleDbTransactionManagerを取得する。
// （SimpleDbTransactionManagerは、setterインジェクションでインジェクションを行うか本サンプルのようにリポジトリから取得する。)
SimpleDbTransactionManager transactionManager = (SimpleDbTransactionManager) SystemRepository.getObject("transactionManager");

// SimpleDbTransactionExecutorを継承し、executeメソッドを実装する。
// executeメソッドでは、パラメータのデータベース接続を使用してSQL文を実行する。
SqlResultSet resultSet = new SimpleDbTransactionExecutor<SqlResultSet>(
        transactionManager) {
    @Override
    public SqlResultSet execute(AppDbConnection connection) {
        SqlPStatement prepared = connection.prepareStatement(query);
        int parameterIndex = 1;
        prepared.setString(parameterIndex++, requestId);
        prepared.setString(parameterIndex,
                requestTableServiceAvailableOkStatus);
        return prepared.retrieve();
    }
// SimpleDbTransactionExecutorを実装したクラスのdoTransactionを実行する。
// これにより、上記で説明したexecuteメソッドがコールバックされSQL文を簡易的に実行することが可能となる。
}.doTransaction();
```

> **Attention:**
> SimpleDbTransactionExecutorを使用してSQL文を実行するのは、既に開始されている業務トランザクション以外のトランザクションを使用してSQL文を実行する場合である。
> 主に、Webアプリケーションの認証機能や開閉局チェック機能のように、ビジネスロジックとは異なる独立したトランザクションが必要となるコンポーネントで使用する。

## 設定ファイル例(DataSourceを使用してデータベース接続を行う場合)

本設定ファイルは、 DataSourceからデータベース接続を取得する場合の 設定例となっている。
JNDI経由でデータベース接続を取得する場合 は、 [設定ファイル例(JNDIを使用してデータベース接続を行う場合)](../../component/libraries/libraries-04-Connection.md#設定ファイル例jndiを使用してデータベース接続を行う場合) を参照すること。

```xml
<!-- SimpleDbTransactionManagerの設定 -->
<component name="transactionManager" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
    <!-- ConnectionFactoryを実装したクラスの設定 -->
    <property name="connectionFactory">

        <!-- DataSourceからConnectionを取得するBasicDbConnectionFactoryForDataSourceを設定 -->
        <component class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
            <property name="statementReuse" value="true"/>

            <!-- DataSourceには、Oracleのデータソースを設定 -->
            <property name="dataSource">
                <component class="oracle.jdbc.pool.OracleDataSource">
                    <property name="user" value="ssd"/>
                    <property name="password" value="ssd"/>
                    <property name="URL"
                              value="jdbc:oracle:thin:ssd/ssd@localhost:1521/xe"/>
                </component>
            </property>

            <!-- statementFactoryを実装したクラスの設定 -->
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

            <!-- DbAccessExceptionFactoryを実装したクラスの設定 -->
            <property name="dbAccessExceptionFactory">
                <component name="dbAccessExceptionFactory" class="nablarch.core.db.connection.exception.BasicDbAccessExceptionFactory">
                    <property name="sql" value="select * from dual" />
                </component>
            </property>

        </component>
    </property>

    <!-- TransactionFactoryを実装したクラスの設定 -->
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

### 設定内容詳細

a) SimpleDbTransactionManagerの設定

| property名 | 設定内容 |
|---|---|
| connectionFactory(必須) | nablarch.core.db.connection.ConnectionFactoryを実装したクラスの設定を行う。  本サンプルでは、「nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource」を設定している。 |
| transactionFactory(必須) | nablarch.core.transaction.TransactionFactoryを実装したクラスの設定を行う。  本サンプルでは、「nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource」を設定している。 |
| dbTransactionName | データベーストランザクション名を任意の値で設定する。  設定を行わない場合、デフォルトのデータベーストランザクション名が本プロパティに自動的に設定される。 |

b) nablarch.core.db.connection.BasicDbConnectionFactoryForDataSourceの設定

| property名 | 設定内容 |
|---|---|
| statementReuse(必須) | Statementをキャッシュするか否かの設定を、trueまたはfalseで設定する。  trueを設定すると、BasicDbConnectionのインスタンス単位でStatementオブジェクトがキャッシュされる。  > **Note:** > キャッシュを有効にした場合は、同一のSQLを複数回実行した場合、 > 2回目以降はキャッシュされたStatementオブジェクトが使用される。 > このため、複数回同一のSQL文を実行した場合はオブジェクトの生成コストを削減でき性能改善が期待できる。 > 特に1処理で同一のSQL文を多数実行する可能性のあるバッチ処理(バッチ処理では、大量データを繰り返し実行するので、 > 同一のSQL文を複数回実行する。)では効果が期待できる。  > 逆に、画面処理では1処理で同一のSQL文を繰り返し実行する事が少く、 > キャッシュが有効に使用されない可能性が高いため、本機能を使用するメリットはあまりない。 |
| dataSource(必須) | javax.sql.DataSourceを実装したクラスを設定する。  本サンプルでは、「oracle.jdbc.pool.OracleDataSource」を設定し、OracleDataSourceのproperyに必要な情報を設定している。  > **Note:** > 本propertyに設定する値は、各データベースベンダーのJDBC関連ドキュメントを参照し設定すること。 |
| statementFactory(必須) | nablarch.core.statement.StatementFactoryを実装したクラスを設定する。  本サンプルでは、「nablarch.core.db.statement.BasicStatementFactory」を設定している。  > **Note:** > statementFactoryの設定は、後述の [SQL文実行部品の構造とその使用方法](../../component/libraries/libraries-04-Statement.md#sql文実行部品の構造とその使用方法) を参照 |
| dbAccessExceptionFactory(必須) | データベースへのアクセス例外が発生した際に本クラスが送出する例外を生成するクラスを設定する。  設定できるクラスは、DbAccessExceptionFactoryを実装したクラスである。 |

c) nablarch.core.db.transaction.JdbcTransactionFactoryへの設定

| property名 | 設定内容 |
|---|---|
| isolationLevel | アイソレーションレベルを設定する。  設定可能なアイソレーションレベル  * READ_COMMITTED(java.sql.Connection#TRANSACTION_READ_COMMITTED) * READ_UNCOMMITTED(java.sql.Connection#TRANSACTION_READ_UNCOMMITTED) * REPEATABLE_READ(java.sql.Connection#TRANSACTION_REPEATABLE_READ) * SERIALIZABLE(java.sql.Connection#TRANSACTION_SERIALIZABLE)  本設定を記述しない場合は、デフォルトでREAD_COMMITTEDが設定される。  > **Note:** > データベースによっては、使用できるアイソレーションレベルが限られている。 > データベースベンダーのマニュアルを参照し、適切なアイソレーションレベルを設定すること。 |
| initSqlList | トランザクション開始時に実行したいSQL文をlist形式で設定する。  SQL文を実行する必要がない場合には、設定は不要である。 |

d) nablarch.core.db.connection.exception.BasicDbAccessExceptionFactoryへの設定

| property名 | 設定内容 |
|---|---|
| sql(必須) | データベースへの接続が有効かどうかを問い合わせるためのSQL文を設定する。  本プロパティに設定するSQL文は、データベースへの負荷が少ないSQL文を設定すること。 例えば、Oracleの場合には、 **dual表** へアクセスするSQL文（以下SQL文）を設定すると良い。  ```sql select '1' from dual ``` |

## 設定ファイル例(JNDIを使用してデータベース接続を行う場合)

本設定例は、JNDI経由でデータベース接続を取得する際に必要となる箇所のみを記載している。
JNDIに関連のない設定については、 [設定ファイル例(DataSourceを使用してデータベース接続を行う場合)](../../component/libraries/libraries-04-Connection.md#設定ファイル例datasourceを使用してデータベース接続を行う場合) を参照し、必要な設定を行うこと。

```xml
<component class="nablarch.core.db.connection.BasicDbConnectionFactoryForJndi">

    <!-- jndiPropertiesの設定 -->
    <property name="jndiProperties">
        <map>
            <entry key="java.naming.factory.initial" value="weblogic.jndi.WLInitialContextFactory"/>
            <entry key="java.naming.provider.url" value="t3://localhost:7001"/>
        </map>
    </property>
    <!-- jndiリソース名 -->
    <property name="jndiResourceName" value="NablarchDataSource"/>

    <!-- statementFactoryを実装したクラスの設定 -->
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

    <!-- DbAccessExceptionFactoryを実装したクラスの設定 -->
    <property name="dbAccessExceptionFactory">
        <component name="dbAccessExceptionFactory" class="nablarch.core.db.connection.exception.BasicDbAccessExceptionFactory">
            <property name="sql" value="select * from dual" />
        </component>
    </property>
</component>
```

### 設定内容詳細

| property名 | 設定内容 |
|---|---|
| statementReuse(必須) | [BasicDbConnectionFactoryForDataSourceへの設定](../../component/libraries/libraries-04-Connection.md#設定内容詳細) の同一項目を参照すること。 |
| statementFactory(必須) | [BasicDbConnectionFactoryForDataSourceへの設定](../../component/libraries/libraries-04-Connection.md#設定内容詳細) の同一項目を参照すること。 |
| dbAccessExceptionFactory(必須) | [BasicDbConnectionFactoryForDataSourceへの設定](../../component/libraries/libraries-04-Connection.md#設定内容詳細) の同一項目を参照すること。 |
| jndiProperties | JNDI経由でDataSourceを取得するための、環境設定を行う。 Webサーバ上で稼働する場合や、クラスパス配下に「jndi.properties」を配置している場合には、本設定値は省略して良い。  > **Note:** > 設定に関する詳細は、Webサーバのベンダーマニュアルなどを参照すること。  > 本設定例は、WebLogicサーバ上にDataSourceが登録されていることを想定した設定例となっている。 |
| jndiResourceName(必須) | JNDIリソース名を設定する。  > **Note:** > 設定に関する詳細は、Webサーバのベンダーマニュアルなどを参照すること。  > 例えば、WebLogicサーバの場合は、管理コンソールからDataSourceを登録する際に「JNDI Name」に入力した値を設定する。 |
