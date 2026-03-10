# トランザクション管理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/transaction.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/transaction/JdbcTransactionFactory.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/TransactionTimeoutException.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/Transaction.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/TransactionFactory.html)

## 機能概要

データベースやメッセージキューなどトランザクション制御が必要なリソースに対するトランザクション管理機能を提供する。

新たなリソースへのトランザクション制御要件が出た場合は、本機能で定められたインタフェースを実装することで対応できる。詳細は :ref:`transaction_addResource` を参照。

<details>
<summary>keywords</summary>

トランザクション管理, データベーストランザクション, メッセージキュートランザクション, トランザクション制御リソース追加

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-transaction</artifactId>
</dependency>

<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core-transaction, nablarch-core-jdbc, モジュール依存関係

</details>

## データベースに対するトランザクション制御

コンポーネント設定ファイルに `JdbcTransactionFactory` を定義することでデータベースへのトランザクション制御を実現できる。なお、データベースに対する接続設定が行われていることが前提となる。詳細は :ref:`database-connect` を参照。

1SQL単位などの粒度の小さいトランザクションを使用する場合は :ref:`database-new_transaction` を参照すること。

```xml
<component class="nablarch.core.db.transaction.JdbcTransactionFactory">
  <!-- アイソレーションレベル -->
  <property name="isolationLevel" value="READ_COMMITTED" />
  <!-- トランザクションタイムアウト秒数 -->
  <property name="transactionTimeoutSec" value="15" />
</component>
```

> **補足**: JdbcTransactionFactoryを直接使用することは基本的にない。トランザクション制御が必要な場合は :ref:`transaction_management_handler` を使うこと。

<details>
<summary>keywords</summary>

JdbcTransactionFactory, isolationLevel, transactionTimeoutSec, データベーストランザクション制御, データベース接続設定, database-new_transaction, TransactionManagementHandler

</details>

## データベースに対するトランザクションタイムアウトを適用する

`JdbcTransactionFactory` の `transactionTimeoutSec` にタイムアウト秒数を設定することで有効になる。設定値が0以下の場合は無効化される。

> **補足**: バッチアプリケーションなど大量データの一括処理では、トランザクションタイムアウトではなくジョブスケジューラの終了遅延監視でハンドリングすること。個々のトランザクションで遅延が発生しても全体の処理時間が想定内であれば問題ない。

**チェック開始タイミング**: `Transaction#begin()` 呼び出し時にチェックが開始される。複数トランザクションを使用した場合はトランザクションごとにチェックする。

**チェックタイミング**:

- **SQL実行前**: タイムアウト秒数超過時は `TransactionTimeoutException` を送出する。既にタイムアウト超過済みの場合にDBアクセスするとリソースを不必要に消費するため。
- **SQL実行後**: タイムアウト秒数超過時は `TransactionTimeoutException` を送出する。SQL実行中・結果セット変換中にタイムアウト超過する可能性があるため、正常完了時もチェックする。
- **クエリータイムアウト例外発生時**: クエリータイムアウト例外（判定には :ref:`database-dialect` を使用）が発生し、かつトランザクションタイムアウト超過の場合は `TransactionTimeoutException` を送出する。トランザクションタイムアウト残り秒数を `java.sql.Statement#setQueryTimeout` に設定し強制キャンセルする。既存クエリータイムアウト時間より残り秒数が小さい場合のみ上書きする。
  - パターン1: クエリータイムアウト10秒、残り15秒 → クエリータイムアウト10秒で実行。クエリータイムアウト発生時はSQL実行時例外が送出される（TransactionTimeoutExceptionではない）。
  - パターン2: クエリータイムアウト10秒、残り5秒 → クエリータイムアウト5秒で実行。クエリータイムアウト発生時は `TransactionTimeoutException` が送出される。

> **補足**: DBアクセスしないロジックで処理遅延が発生した場合（例: 無限ループ）はトランザクションタイムアウトで検出できない。アプリケーションサーバのタイムアウト機能などを使うこと。

**リセットタイミング**: `Transaction#begin` 呼び出し時にリセットされる。`Transaction#commit` や `Transaction#rollback` ではリセットされないので注意すること。

<details>
<summary>keywords</summary>

JdbcTransactionFactory, TransactionTimeoutException, transactionTimeoutSec, トランザクションタイムアウト, クエリータイムアウト, Statement#setQueryTimeout

</details>

## 拡張例

トランザクション対象のリソースを追加する場合（例: IBM MQを分散トランザクションのトランザクションマネージャとして制御する場合）は以下の手順が必要となる。

1. トランザクション実装の追加
2. トランザクションを生成するためのファクトリ実装の追加
3. :ref:`transaction_management_handler` を使ってトランザクション制御を実現

**1. トランザクション実装の追加**

`Transaction` インタフェースを実装し、リソースへのbegin/commit/rollback処理を実装する。

```java
public class SampleTransaction implements Transaction {
  private final String resourceName;

  // トランザクション制御対象のリソースを識別するためのリソース名を受け取る。
  // トランザクション制御時に、このリソース名からトランザクション制御対象のリソースを取得する必要がある。
  public SampleTransaction(String resourceName) {
    this.resourceName = resourceName;
  }

  @Override
  public void begin() {
    // トランザクション対象リソースに対するトランザクションの開始処理を実装する
  }

  @Override
  public void commit() {
    // トランザクション対象リソースに対するトランザクションの確定処理を実装する
  }

  @Override
  public void rollback() {
    // トランザクション対象リソースに対するトランザクションの破棄処理を実装する
  }
}
```

**2. ファクトリ実装の追加**

`TransactionFactory` を実装したファクトリクラスを作成する。

```java
public class SampleTransactionFactory implements TransactionFactory {
  @Override
  public Transaction getTransaction(String resourceName) {
    return new SampleTransaction(resourceName);
  }
}
```

**3. TransactionManagementHandlerへの設定**

追加したファクトリクラスを :ref:`transaction_management_handler` に設定する。

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory">
    <component class="sample.SampleTransactionFactory" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

Transaction, TransactionFactory, TransactionManagementHandler, トランザクションリソース追加, カスタムトランザクション実装, IBM MQ

</details>
