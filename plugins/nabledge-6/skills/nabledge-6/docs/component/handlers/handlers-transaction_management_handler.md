# トランザクション制御ハンドラ

## 概要

データベースやメッセージキューなどのトランザクションに対応したリソースを使用し、後続処理における透過的トランザクションを実現するハンドラ。

**本ハンドラで行う処理**:

* トランザクションの開始
* トランザクションの終了(コミットやロールバック)
* トランザクションの終了時のコールバック

トランザクション機能の詳細は、:ref:`transaction` を参照。

## ハンドラクラス名

**クラス**: `TransactionManagementHandler`

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

## 制約

:ref:`database_connection_management_handler` より後ろに配置すること。データベーストランザクション制御時、トランザクション管理対象のDB接続がスレッド上に存在する必要があるため。

## トランザクション制御対象を設定する

`transactionFactory` プロパティに設定した `TransactionFactory` 実装クラスを使用してトランザクション制御対象を取得し、スレッド上で管理する。

**トランザクション識別名**: デフォルトは `transaction`。任意の名前を使う場合は `transactionName` プロパティに設定。:ref:`複数のトランザクションを使用する場合<transaction_management_handler-multi_transaction>` は設定が必須。

> **補足**: :ref:`database_connection_management_handler` で設定したデータベースに対するトランザクションを制御する場合、`DbConnectionManagementHandler#connectionName` と同じ値を `transactionName` に設定すること。`DbConnectionManagementHandler#connectionName` に値を設定していない場合は省略可。

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
  <property name="transactionName" value="name" />
</component>

<component name="databaseTransactionFactory"
    class="nablarch.core.db.transaction.JdbcTransactionFactory">
  <!-- プロパティの設定は省略 -->
</component>
```

## 特定の例外の場合にトランザクションをコミットさせる

**デフォルト動作**: 全エラー・例外がロールバック対象。

**特定例外でコミットする場合**: `transactionCommitExceptions` プロパティにコミット対象の例外クラスを設定。設定した例外クラスのサブクラスもコミット対象となる。

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionCommitExceptions">
    <list>
      <value>example.TransactionCommitException</value>
    </list>
  </property>
</component>
```

## トランザクション終了時に任意の処理を実行したい

**コールバック処理**: トランザクション終了（コミット・ロールバック）時にコールバック処理を実行する。

**コールバック対象**: 後続ハンドラで `TransactionEventCallback` を実装しているもの。複数ある場合は手前から順次実行。

**ロールバック時の動作**: ロールバック後にコールバック処理を実行。コールバック処理は新しいトランザクションで実行され、正常終了するとコミットされる。

> **重要**: 複数ハンドラがコールバック処理を実装している場合、コールバック処理中にエラー・例外が発生すると残りのハンドラに対するコールバック処理は実行されない。

**実装手順**:

1. **コールバック処理を行うハンドラの作成**: `TransactionEventCallback` を実装。`transactionNormalEnd` にコミット時、`transactionAbnormalEnd` にロールバック時のコールバック処理を実装。

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

2. **ハンドラキュー構築**: トランザクション制御ハンドラの後続にコールバック処理を実装したハンドラを設定。

```xml
<list name="handlerQueue">
  <component class="nablarch.common.handler.TransactionManagementHandler">
    <!-- プロパティへの設定は省略 -->
  </component>
  <component class="sample.SampleHandler" />
</list>
```

## アプリケーションで複数のトランザクションを使用する

**複数トランザクション制御**: このハンドラをハンドラキュー上に複数設定することで対応する。

**設定例（複数のDB接続に対するトランザクション制御）**:

```xml
<!-- デフォルトのデータベース接続を設定 -->
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

<!-- デフォルトのデータベース接続に対するトランザクション制御の設定 -->
<component name="defaultTransactionHandler"
    class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
</component>

<!-- userAccessLogというデータベース接続に対するトランザクション制御の設定 -->
<component name="userAccessLogTransactionHandler"
    class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
  <property name="transactionName" value="userAccessLog" />
</component>
```

**ハンドラキュー設定例**:

```xml
<list name="handlerQueue">
  <!-- デフォルトのデータベースに対する接続とトランザクション制御 -->
  <component-ref name="defaultDatabaseHandler" />
  <component-ref name="defaultTransactionHandler" />

  <!-- userAccessLogのデータベースに対する接続とトランザクション制御 -->
  <component-ref name="userAccessLogDatabaseHandler" />
  <component-ref name="userAccessLogTransactionHandler" />
</list>
```
