# トランザクションループ制御ハンドラ

## 概要

データリーダ上に処理対象のデータが存在する間、後続ハンドラの処理を繰り返し実行する。実行中はトランザクションを制御し、一定の繰り返し回数ごとにトランザクションをコミットする。コミット間隔を大きくすることで、バッチ処理のスループットを向上させることができる。

このハンドラが制御するトランザクション処理:
- トランザクションの開始
- トランザクションの終了（コミットやロールバック）
- トランザクションの終了時のコールバック

## ハンドラクラス名

**クラス**: `nablarch.fw.handler.LoopHandler`

データリーダ上に処理対象データが存在する間、後続ハンドラの処理を繰り返し実行し、トランザクション制御を行うハンドラ。スタンドアロンバッチ処理で使用する。

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

## 制約

- :ref:`database_connection_management_handler` より後ろに設定すること。DBトランザクション制御時、スレッド上にトランザクション管理対象のDB接続が存在している必要がある。

## トランザクション制御対象を設定する

`transactionFactory` プロパティに `TransactionFactory` 実装クラスを設定してトランザクション制御対象を取得、スレッド上で管理する。

トランザクション識別名のデフォルトは `transaction`。変更する場合は `transactionName` プロパティに設定する。

> **補足**: :ref:`database_connection_management_handler` で設定したDBに対してトランザクション制御する場合、`DbConnectionManagementHandler#connectionName` に設定した値と同じ値を `transactionName` プロパティに設定すること。`connectionName` が未設定の場合は `transactionName` の設定も省略可。

```xml
<component class="nablarch.fw.handler.LoopHandler">
  <property name="transactionFactory" ref="databaseTransactionFactory" />
  <property name="transactionName" value="name" />
</component>

<component name="databaseTransactionFactory"
    class="nablarch.core.db.transaction.JdbcTransactionFactory">
  <!-- プロパティの設定は省略 -->
</component>
```

## コミット間隔を指定する

`commitInterval` プロパティでコミット間隔（件数）を設定する。間隔を大きくするとバッチ処理のスループットが向上する。

```xml
<component class="nablarch.fw.handler.LoopHandler">
  <property name="commitInterval" value="1000" />
</component>
```

## トランザクション終了時に任意の処理を実行したい

後続ハンドラが `TransactionEventCallback` を実装している場合、このハンドラは後続ハンドラの処理実行後にコールバック処理を行う。

**コールバックの動作**:
- 後続ハンドラ正常終了時: 同一トランザクションで実行、次回コミットタイミングで一括コミット
- 後続ハンドラで例外/エラー発生時: ロールバック後、新しいトランザクションで実行。正常終了するとコミット
- 複数ハンドラが `TransactionEventCallback` を実装している場合: より手前のハンドラから順次コールバックを実行

> **重要**: コールバック処理中にエラーや例外が発生した場合、残りのハンドラに対するコールバック処理は実行されない。

`transactionNormalEnd` にコミット時のコールバック処理、`transactionAbnormalEnd` にロールバック時のコールバック処理を実装する。

```java
public static class SampleHandler
    implements Handler<Object, Object>, TransactionEventCallback<Object> {

  @Override
  public Object handle(Object o, ExecutionContext context) {
    return context.handleNext(o);
  }

  @Override
  public void transactionNormalEnd(Object o, ExecutionContext ctx) {
    // 後続ハンドラが正常終了した場合のコールバック処理を実装する
  }

  @Override
  public void transactionAbnormalEnd(Throwable e, Object o, ExecutionContext ctx) {
    // トランザクションロールバック時のコールバック処理を実装する
  }
}
```

```xml
<list name="handlerQueue">
  <component class="nablarch.fw.handler.LoopHandler" />
  <component class="sample.SampleHandler" />
</list>
```
