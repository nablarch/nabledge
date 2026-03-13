# トランザクション制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/transaction_management_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/TransactionManagementHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/TransactionFactory.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/DbConnectionManagementHandler.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/TransactionEventCallback.html)

## ハンドラクラス名

**クラス名**: `nablarch.common.handler.TransactionManagementHandler`

<details>
<summary>keywords</summary>

TransactionManagementHandler, nablarch.common.handler.TransactionManagementHandler, ハンドラクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-transaction</artifactId>
</dependency>

<!-- データベースに対するトランザクションを制御する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-jdbc</artifactId>
</dependency>

<!-- トランザクション終了時に任意の処理を実行する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core-transaction, nablarch-core-jdbc, nablarch-core, モジュール依存関係, トランザクション制御

</details>

## 制約

- [database_connection_management_handler](handlers-database_connection_management_handler.md) より後ろに配置すること。データベースに対するトランザクションを制御する場合、トランザクション管理対象のDB接続がスレッド上に存在している必要がある。

<details>
<summary>keywords</summary>

database_connection_management_handler, DbConnectionManagementHandler, ハンドラ配置順序, 制約, DB接続ハンドラ

</details>

## トランザクション制御対象を設定する

`transactionFactory` プロパティに `TransactionFactory` 実装クラスを設定してトランザクション制御対象を取得する。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| transactionFactory | TransactionFactory | ○ | | トランザクション制御に使用するファクトリクラス |
| transactionName | String | | `transaction` | スレッド上でトランザクションを識別する名前。[transaction_management_handler-multi_transaction](#s6) の場合は必須 |

> **補足**: [database_connection_management_handler](handlers-database_connection_management_handler.md) で設定したDBのトランザクションを制御する場合、`DbConnectionManagementHandler#connectionName` に設定した値と同じ値を `transactionName` に設定すること。`connectionName` が未設定の場合は `transactionName` の設定を省略できる。

```xml
<!-- トランザクション制御ハンドラ -->
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
  <property name="transactionName" value="name" />
</component>

<!-- データベースに対するトランザクション制御を行う場合には、JdbcTransactionFactoryを設定する -->
<component name="databaseTransactionFactory"
    class="nablarch.core.db.transaction.JdbcTransactionFactory">
  <!-- プロパティの設定は省略 -->
</component>
```

<details>
<summary>keywords</summary>

transactionFactory, transactionName, TransactionFactory, JdbcTransactionFactory, DbConnectionManagementHandler, connectionName, トランザクション設定, 複数トランザクション識別

</details>

## 特定の例外の場合にトランザクションをコミットさせる

デフォルトでは全てのエラー及び例外がロールバック対象。特定の例外をコミット対象にするには `transactionCommitExceptions` プロパティに例外クラスのFQCNを設定する。設定した例外クラスのサブクラスもコミット対象となる。

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionCommitExceptions">
    <list>
      <value>example.TransactionCommitException</value>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

transactionCommitExceptions, 例外時コミット, ロールバック対象, コミット対象例外, 例外クラス設定

</details>

## トランザクション終了時に任意の処理を実行したい

トランザクション終了(コミット/ロールバック)時に、後続ハンドラの中で `TransactionEventCallback` を実装しているハンドラへコールバック処理を実行する。複数のハンドラが実装している場合は手前から順次実行する。

ロールバック時はロールバック後にコールバックを実行する。コールバック処理は新しいトランザクションで実行され、正常終了するとコミットされる。

> **重要**: 複数のハンドラがコールバック処理を実装していた場合で、コールバック処理中にエラーや例外が発生した場合は、残りのハンドラに対するコールバック処理は実行されない。

- `transactionNormalEnd`: トランザクションコミット時のコールバック
- `transactionAbnormalEnd`: トランザクションロールバック時のコールバック

```java
public static class SampleHandler
    implements Handler<Object, Object>, TransactionEventCallback<Object> {

  @Override
  public Object handle(Object o, ExecutionContext context) {
    return context.handleNext(o);
  }

  @Override
  public void transactionNormalEnd(Object o, ExecutionContext ctx) {
    // トランザクションコミット時のコールバック処理を実装する
  }

  @Override
  public void transactionAbnormalEnd(Throwable e, Object o, ExecutionContext ctx) {
    // トランザクションロールバック時のコールバック処理を実装する
  }
}
```

コールバック処理を実装したハンドラはこのハンドラの後続に設定する:

```xml
<list name="handlerQueue">
  <component class="nablarch.common.handler.TransactionManagementHandler">
    <!-- プロパティへの設定は省略 -->
  </component>
  <component class="sample.SampleHandler" />
</list>
```

<details>
<summary>keywords</summary>

TransactionEventCallback, transactionNormalEnd, transactionAbnormalEnd, コールバック処理, ロールバック後コールバック, 新しいトランザクション

</details>

## アプリケーションで複数のトランザクションを使用する

複数のトランザクション制御が必要な場合は、ハンドラキュー上に `TransactionManagementHandler` を複数設定する。各ハンドラに異なる `transactionName` を設定して識別する。

```xml
<!-- デフォルトのデータベース接続 -->
<component name="defaultDatabaseHandler"
    class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory" />
</component>

<!-- userAccessLogという名前でデータベース接続を登録 -->
<component name="userAccessLogDatabaseHandler"
    class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="userAccessLogConnectionFactory" />
  <property name="connectionName" value="userAccessLog" />
</component>

<!-- デフォルトのデータベース接続に対するトランザクション制御 -->
<component name="defaultTransactionHandler"
    class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
</component>

<!-- userAccessLogというデータベース接続に対するトランザクション制御 -->
<component name="userAccessLogTransactionHandler"
    class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
  <property name="transactionName" value="userAccessLog" />
</component>

<!-- ハンドラキュー設定例 -->
<list name="handlerQueue">
  <component-ref name="defaultDatabaseHandler" />
  <component-ref name="defaultTransactionHandler" />
  <component-ref name="userAccessLogDatabaseHandler" />
  <component-ref name="userAccessLogTransactionHandler" />
</list>
```

<details>
<summary>keywords</summary>

複数トランザクション, transactionName, DbConnectionManagementHandler, connectionName, マルチトランザクション, ハンドラキュー複数設定

</details>
