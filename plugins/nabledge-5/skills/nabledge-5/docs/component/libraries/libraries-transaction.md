# トランザクション管理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/transaction.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/transaction/JdbcTransactionFactory.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/Transaction.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/TransactionTimeoutException.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/transaction/TransactionFactory.html)

## 機能概要

データベース・メッセージキュー等のトランザクション制御が必要なリソースに対するトランザクション管理ができる。

- データベースのトランザクション制御: [transaction-database](#)、[transaction-timeout](#) を参照
- 新たなリソースへのトランザクション制御は `Transaction` インタフェースを実装することで追加可能。詳細: :ref:`transaction_addResource`

<details>
<summary>keywords</summary>

JdbcTransactionFactory, Transaction, TransactionFactory, トランザクション管理, データベーストランザクション, メッセージキュートランザクション

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

## 使用方法 - データベースに対するトランザクション制御

`JdbcTransactionFactory` をコンポーネント設定ファイルに定義する（データベース接続設定が前提）。1SQL単位などの粒度の小さいトランザクションを使用する場合は [database-new_transaction](libraries-database.md) を参照すること。

```xml
<component class="nablarch.core.db.transaction.JdbcTransactionFactory">
  <property name="isolationLevel" value="READ_COMMITTED" />
  <property name="transactionTimeoutSec" value="15" />
</component>
```

> **補足**: このクラスを直接使用することは基本的にない。トランザクション制御が必要な場合は [transaction_management_handler](../handlers/handlers-transaction_management_handler.md) を使うこと。

<details>
<summary>keywords</summary>

JdbcTransactionFactory, isolationLevel, transactionTimeoutSec, transaction_management_handler, database-new_transaction, トランザクション制御, コンポーネント設定

</details>

## 使用方法 - データベースに対するトランザクションタイムアウトを適用する

`JdbcTransactionFactory` の `transactionTimeoutSec` プロパティで設定する。0以下の値を設定した場合は無効化される。

> **補足**: バッチアプリケーションでは個々のトランザクションのタイムアウトより、ジョブスケジューラの終了遅延監視でハンドリングすること。個々のトランザクションで遅延が起きても処理全体が想定時間内であれば問題ないため。

**チェック開始タイミング**: `Transaction#begin()` 時に開始。複数トランザクションを使用する場合はトランザクションごとにチェックを行う。

**チェックタイミング**:
- **SQL実行前**: タイムアウト超過時に `TransactionTimeoutException` を送出（不要なDBアクセスを防ぐため）
- **SQL実行後**: タイムアウト超過時に `TransactionTimeoutException` を送出（SQL実行中・結果セット変換中に超過する可能性があるため）
- **クエリータイムアウト例外発生時**: クエリータイムアウト例外発生かつタイムアウト超過の場合に `TransactionTimeoutException` を送出。クエリータイムアウト判定は [database-dialect](libraries-database.md) を使用。

**クエリータイムアウトのハンドリング**: トランザクションタイムアウトの残り秒数を `java.sql.Statement#setQueryTimeout` に設定する。設定済みのクエリータイムアウト時間がある場合は、残り秒数がそれより小さい場合のみ上書きする。

- パターン1: 設定済みクエリータイムアウト10秒、残り15秒 → クエリータイムアウト10秒で実行。クエリータイムアウト発生時は TransactionTimeoutException とならずSQL実行時例外が送出される
- パターン2: 設定済みクエリータイムアウト10秒、残り5秒 → クエリータイムアウト5秒で実行。クエリータイムアウト発生時は `TransactionTimeoutException` が送出される

> **補足**: DBにアクセスしないロジックで処理遅延（例: 無限ループ）が発生した場合はトランザクションタイムアウトを検出できない。この場合はアプリケーションサーバのタイムアウト機能を使うこと。

**タイムアウト時間のリセットタイミング**: `Transaction#begin` 呼び出し時にリセット。`Transaction#commit` や `Transaction#rollback` ではリセットされない点に注意。

<details>
<summary>keywords</summary>

JdbcTransactionFactory, Transaction, TransactionTimeoutException, transactionTimeoutSec, トランザクションタイムアウト, クエリータイムアウト, setQueryTimeout, database-dialect

</details>

## 拡張例

### トランザクション対象のリソースを追加する

新たなリソース（例: IBM MQを分散トランザクションのトランザクションマネージャとして使用する場合）を追加する手順:

1. `Transaction` インタフェースを実装したトランザクションクラスを作成（リソース名を受け取り、begin/commit/rollbackを実装する）
2. `TransactionFactory` インタフェースを実装したファクトリクラスを作成
3. [transaction_management_handler](../handlers/handlers-transaction_management_handler.md) にファクトリクラスを設定

**トランザクション実装例**:
```java
public class SampleTransaction implements Transaction {
  private final String resourceName;

  public SampleTransaction(String resourceName) {
    this.resourceName = resourceName;
  }

  @Override
  public void begin() { /* トランザクション開始処理 */ }

  @Override
  public void commit() { /* トランザクション確定処理 */ }

  @Override
  public void rollback() { /* トランザクション破棄処理 */ }
}
```

**ファクトリ実装例**:
```java
public class SampleTransactionFactory implements TransactionFactory {
  @Override
  public Transaction getTransaction(String resourceName) {
    return new SampleTransaction(resourceName);
  }
}
```

**ハンドラ設定例**:
```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory">
    <component class="sample.SampleTransactionFactory" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

Transaction, TransactionFactory, TransactionManagementHandler, transactionFactory, トランザクションリソース追加, カスタムトランザクション実装

</details>
