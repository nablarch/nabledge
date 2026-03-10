# トランザクション制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/transaction_management_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/TransactionManagementHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/TransactionFactory.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/DbConnectionManagementHandler.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/TransactionEventCallback.html)

## ハンドラクラス名

データベースやメッセージキューなどのトランザクションに対応したリソースを使用し、後続処理における透過的トランザクションを実現するハンドラ。

本ハンドラでは、以下の処理を行う:
1. トランザクションの開始
2. トランザクションの終了（コミットやロールバック）
3. トランザクションの終了時のコールバック

**クラス名**: `nablarch.common.handler.TransactionManagementHandler`

<details>
<summary>keywords</summary>

TransactionManagementHandler, nablarch.common.handler.TransactionManagementHandler, トランザクション制御ハンドラ, 透過的トランザクション, ハンドラクラス

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

nablarch-core-transaction, nablarch-core-jdbc, nablarch-core, com.nablarch.framework, Maven依存関係

</details>

## 制約

- :ref:`database_connection_management_handler` より後ろに配置すること。データベースに対するトランザクションを制御する場合、スレッド上にトランザクション管理対象のDB接続が存在している必要があるため。

<details>
<summary>keywords</summary>

DbConnectionManagementHandler, database_connection_management_handler, ハンドラ配置順序, DB接続, 制約

</details>

## トランザクション制御対象を設定する

`transactionFactory` プロパティに `TransactionFactory` 実装クラスを設定し、トランザクション制御対象を取得してスレッド上で管理する。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| transactionFactory | TransactionFactory | | | トランザクション制御対象を取得するファクトリクラス |
| transactionName | String | | transaction | スレッド上でトランザクションを識別する名前 |

- 複数トランザクション使用時は `transactionName` への設定が必須（:ref:`transaction_management_handler-multi_transaction` 参照）

> **補足**: :ref:`database_connection_management_handler` で設定したDBのトランザクションを制御する場合、`DbConnectionManagementHandler#connectionName` に設定した値と同じ値を `transactionName` に設定すること。`connectionName` 未設定時は `transactionName` の設定を省略可。

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
  <property name="transactionName" value="name" />
</component>

<!-- データベーストランザクション制御の場合はJdbcTransactionFactoryを設定する -->
<component name="databaseTransactionFactory"
    class="nablarch.core.db.transaction.JdbcTransactionFactory">
</component>
```

<details>
<summary>keywords</summary>

transactionFactory, transactionName, TransactionFactory, JdbcTransactionFactory, DbConnectionManagementHandler, connectionName, トランザクション設定

</details>

## 特定の例外の場合にトランザクションをコミットさせる

デフォルトでは全てのエラー・例外がロールバック対象。特定の例外発生時にコミットする場合は `transactionCommitExceptions` プロパティに対象例外クラス（FQCN）を設定する。設定した例外クラスのサブクラスもコミット対象となる。

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <!-- コミット対象の例外クラスをFQCNで設定する -->
  <property name="transactionCommitExceptions">
    <list>
      <value>example.TransactionCommitException</value>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

transactionCommitExceptions, 例外時コミット, ロールバック対象外, 例外クラス設定, TransactionManagementHandler

</details>

## トランザクション終了時に任意の処理を実行したい

後続ハンドラの中で `TransactionEventCallback` を実装しているハンドラに対してコールバック処理を行う。複数ハンドラが実装している場合は手前から順次実行。

- ロールバック時はロールバック後にコールバックを実行（新しいトランザクション）。コールバック正常終了でコミット。

> **重要**: 複数ハンドラがコールバック処理を実装していた場合、コールバック中にエラーや例外が発生すると残りのハンドラへのコールバック処理は実行されない。

`TransactionEventCallback` を実装し、以下のメソッドを定義する:
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
    // トランザクションコミット時のコールバック処理
  }

  @Override
  public void transactionAbnormalEnd(Throwable e, Object o, ExecutionContext ctx) {
    // トランザクションロールバック時のコールバック処理
  }
}
```

ハンドラキューの設定（コールバックを実装したハンドラを後続に設定）:
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

TransactionEventCallback, transactionNormalEnd, transactionAbnormalEnd, コールバック処理, トランザクション終了イベント

</details>

## アプリケーションで複数のトランザクションを使用する

複数のトランザクション制御が必要な場合は、`TransactionManagementHandler` をハンドラキューに複数設定し、それぞれ異なる `transactionName` を設定する。

複数DB接続のトランザクション制御設定例:
```xml
<!-- デフォルトのDB接続 -->
<component name="defaultDatabaseHandler"
    class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory" />
</component>

<!-- userAccessLogという名前でDB接続を登録 -->
<component name="userAccessLogDatabaseHandler"
    class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="userAccessLogConnectionFactory" />
  <property name="connectionName" value="userAccessLog" />
</component>

<!-- デフォルトDB接続のトランザクション制御 -->
<component name="defaultTransactionHandler"
    class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
</component>

<!-- userAccessLog DB接続のトランザクション制御 -->
<component name="userAccessLogTransactionHandler"
    class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
  <property name="transactionName" value="userAccessLog" />
</component>
```

ハンドラキュー設定例:
```xml
<list name="handlerQueue">
  <component-ref name="defaultDatabaseHandler" />
  <component-ref name="defaultTransactionHandler" />
  <component-ref name="userAccessLogDatabaseHandler" />
  <component-ref name="userAccessLogTransactionHandler" />
</list>
```

<details>
<summary>keywords</summary>

transactionName, 複数トランザクション, TransactionManagementHandler, DbConnectionManagementHandler, 複数DB接続

</details>
