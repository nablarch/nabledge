# トランザクションループ制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/batch/loop_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/LoopHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/TransactionFactory.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/DbConnectionManagementHandler.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/TransactionEventCallback.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.LoopHandler`

データリーダ上に処理対象のデータが存在する間、後続ハンドラの処理を繰り返し実行する。実行中はトランザクションを制御し、一定の繰り返し回数ごとにトランザクションをコミットする。コミット間隔を大きくすることで、バッチ処理のスループットを向上させることができる。

以下のトランザクション制御を行う:
- トランザクションの開始
- トランザクションの終了（コミットやロールバック）
- トランザクションの終了時のコールバック

<details>
<summary>keywords</summary>

LoopHandler, nablarch.fw.handler.LoopHandler, トランザクションループ制御ハンドラ, ハンドラクラス名, データリーダ, 繰り返し実行, トランザクション制御, コミット間隔

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>

<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-transaction</artifactId>
</dependency>

<!-- データベースに対するトランザクションを制御する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-standalone, nablarch-core-transaction, nablarch-core-jdbc, モジュール, 依存関係

</details>

## 制約

[database_connection_management_handler](handlers-database_connection_management_handler.md) より後ろに配置すること。DBトランザクション制御を行う場合、スレッド上にトランザクション管理対象のDB接続が必要。

<details>
<summary>keywords</summary>

database_connection_management_handler, 制約, 設定順序, DB接続, スレッド上のDB接続

</details>

## トランザクション制御対象を設定する

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| transactionFactory | TransactionFactory | | | トランザクション制御対象を取得するファクトリクラス（TransactionFactory実装クラス） |
| transactionName | String | | transaction | スレッド上でトランザクションを識別する名前 |

> **補足**: [database_connection_management_handler](handlers-database_connection_management_handler.md) で設定したDBのトランザクションを制御する場合、`transactionName` には `DbConnectionManagementHandler#connectionName` と同じ値を設定すること。`connectionName` が未設定の場合、`transactionName` の設定は省略可。

```xml
<component class="nablarch.fw.handler.LoopHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
  <property name="transactionName" value="name" />
</component>

<component name="databaseTransactionFactory"
    class="nablarch.core.db.transaction.JdbcTransactionFactory">
</component>
```

<details>
<summary>keywords</summary>

transactionFactory, transactionName, TransactionFactory, JdbcTransactionFactory, DbConnectionManagementHandler, connectionName, トランザクション制御対象設定

</details>

## コミット間隔を指定する

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| commitInterval | int | | | コミット間隔（件数）。大きくするほどスループット向上。 |

```xml
<component class="nablarch.fw.handler.LoopHandler">
  <property name="commitInterval" value="1000" />
</component>
```

<details>
<summary>keywords</summary>

commitInterval, コミット間隔, スループット, バッチ処理スループット

</details>

## トランザクション終了時に任意の処理を実行したい

後続ハンドラが `TransactionEventCallback` を実装している場合、ハンドラ処理後にコールバックが実行される。複数ハンドラが実装している場合、より手前に設定されたハンドラから順に実行される。

- **正常終了時**: 後続ハンドラと同一トランザクションで実行。次のコミットタイミングで一括コミット。
- **例外・エラー発生時**: ロールバック後、新しいトランザクションでコールバックを実行。正常終了でコミット。

> **重要**: 複数ハンドラがコールバックを実装している場合、コールバック処理中に例外・エラーが発生すると、残りのハンドラへのコールバックは実行されない。

```java
public static class SampleHandler
    implements Handler<Object, Object>, TransactionEventCallback<Object> {

  @Override
  public Object handle(Object o, ExecutionContext context) {
    return context.handleNext(o);
  }

  @Override
  public void transactionNormalEnd(Object o, ExecutionContext ctx) {
    // 後続ハンドラ正常終了時のコールバック処理
  }

  @Override
  public void transactionAbnormalEnd(Throwable e, Object o, ExecutionContext ctx) {
    // トランザクションロールバック時のコールバック処理
  }
}
```

```xml
<list name="handlerQueue">
  <component class="nablarch.fw.handler.LoopHandler" />
  <component class="sample.SampleHandler" />
</list>
```

<details>
<summary>keywords</summary>

TransactionEventCallback, transactionNormalEnd, transactionAbnormalEnd, コールバック処理, ロールバック後コールバック, トランザクション終了コールバック

</details>
