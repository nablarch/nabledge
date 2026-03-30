# データベースコネクション名とトランザクション名

## データベースコネクション名

`DbConnectionContext` に設定する `AppDbConnection`（データベース接続）ごとに設定する名前。スレッド内でユニークにする必要がある。

**名前を分けて登録するケース:**
- データベースの接続先が異なる場合
- 同一接続先で異なるトランザクション制御が必要な場合（例: 業務処理内で別トランザクションが必要な場合）

> **注意**: 無名のデータベース接続は1つだけ登録可能。ビジネスロジックのメインDB接続には無名を推奨（名前指定間違いによる不具合を防げる）。内部的には `TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY`（値は `"transaction"`）として保持される。

> **警告**: `TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY` の値は `"transaction"`。無名と `"transaction"` は同義。無名が登録されている状態で `"transaction"` の登録を試みるとエラー。同一スレッドで既に登録されている名前で再登録するとエラー。

**使用例:**

```java
// 無名のデータベース接続を登録（内部的にDEFAULT_TRANSACTION_CONTEXT_KEY="transaction"として保持）
DbConnectionContext.setConnection(connection1);
// 上記と同義
DbConnectionContext.setConnection(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, connection1);
DbConnectionContext.setConnection("transaction", connection1);

// "user-schema" という名前でデータベース接続を登録
DbConnectionContext.setConnection("user-schema", connection2);

// 同一スレッドで既に登録されている名前で登録するとエラー
DbConnectionContext.setConnection("user-schema", connection3); // エラー

// 無名のデータベース接続を取得
AppDbConnection connection1 = DbConnectionContext.getConnection();

// "user-schema" でデータベース接続を取得
AppDbConnection connection2 = DbConnectionContext.getConnection("user-schema");
```

無名と `"transaction"` の関係:

```java
// 無名で登録したコネクションは "transaction" でも取得可能
DbConnectionContext.setConnection(connection);
DbConnectionContext.getConnection("transaction");

// "transaction" で登録したコネクションは無名でも取得可能
DbConnectionContext.setConnection("transaction", connection);
DbConnectionContext.getConnection();

// 無名が登録済みの場合、"transaction" での登録はエラー
DbConnectionContext.setConnection(connection1);
DbConnectionContext.setConnection("transaction", connection); // エラー
```

<details>
<summary>keywords</summary>

DbConnectionContext, AppDbConnection, TransactionContext, DEFAULT_TRANSACTION_CONTEXT_KEY, データベースコネクション名, データベース接続管理, 無名コネクション, コネクション登録

</details>

## トランザクション名

`TransactionContext` に設定する `Transaction` ごとに設定する名前。スレッド内でユニークにする必要がある。

**使用例:**

```java
// DEFAULT_TRANSACTION_CONTEXT_KEY でトランザクションを登録
TransactionContext.setTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, transaction);

// "user_schema" でトランザクションを登録
TransactionContext.setTransaction("user_schema", transaction2);

// 同一スレッドで既に登録されている名前で登録するとエラー
TransactionContext.setTransaction("user_schema", transaction3); // エラー

// トランザクションの取得
// 基本的にこの処理はフレームワークの責務である。
// アプリケーションでトランザクションが必要となるケースは、
// 例外発生時（異常終了）であっても処理を確定する必要がある場合である。
Transaction tran = TransactionContext.getTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY);
Transaction tran = TransactionContext.getTransaction("user-schema");
```

<details>
<summary>keywords</summary>

TransactionContext, Transaction, トランザクション名, トランザクション登録, トランザクション取得

</details>

## JdbcTransactionにおけるトランザクション名とデータベースコネクション名の関係

`JdbcTransaction` を使用した場合、トランザクション名とデータベースコネクション名は1対1で紐付く。`JdbcTransaction` は自身のトランザクション名と同一の名前で `DbConnectionContext` に登録されているデータベース接続を使用してトランザクション制御を行う。

**実装コードで見るトランザクション制御:**

```java
// 無名のデータベース接続とトランザクションを登録
DbConnectionContext.setConnection(connection1);
TransactionContext.setTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, transaction1);

// "user-schema" でデータベース接続とトランザクションを登録
DbConnectionContext.setConnection("user-schema", connection2);
TransactionContext.setTransaction("user-schema", transaction2);

// このコミットは connection1 に対して実行。connection2 はこのトランザクション制御の影響を受けない。
Transaction tran1 = TransactionContext.getTransaction();
tran1.commit();
```

<details>
<summary>keywords</summary>

JdbcTransaction, トランザクション名, データベースコネクション名, 1対1, トランザクション制御, DbConnectionContext, TransactionContext

</details>
