# データベースコネクション名とトランザクション名

## 

[../03_TransactionManager](libraries-03_TransactionManager.md) と [../04_DbAccessSpec](libraries-04_DbAccessSpec.md) で言及されたデータベースコネクション名とトランザクション名の仕様。

<details>
<summary>keywords</summary>

データベースコネクション名, トランザクション名, DbConnectionContext, TransactionContext, コネクション名とトランザクション名の概要

</details>

## データベースコネクション名

`DbConnectionContext` に登録する `AppDbConnection`（DB接続）ごとに設定する名前。スレッド内でユニークである必要がある。

**名前を分けて登録するケース:**
- DBの接続先が異なる場合
- 同一接続先で異なるトランザクション制御を行う場合（例：業務処理内で別トランザクション処理が必要な場合）

> **注意**: `DbConnectionContext` には無名のDB接続を1つだけ登録可能。無名のDB接続はビジネスロジックのメインDB接続への使用を推奨（名前指定不要のため、名前指定ミスによる不具合を防げる）。内部的には `TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY`（値：`"transaction"`）という名前で保持される。

```java
// 無名登録（内部名: TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY）
DbConnectionContext.setConnection(connection1);
// 以下2つは上記と同義:
// DbConnectionContext.setConnection(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, connection1);
// DbConnectionContext.setConnection("transaction", connection1);

// 名前付き登録
DbConnectionContext.setConnection("user-schema", connection2);
// 同一名での再登録はエラー
// DbConnectionContext.setConnection("user-schema", connection3); // エラー

// 無名取得
AppDbConnection connection1 = DbConnectionContext.getConnection();
// 名前付き取得
AppDbConnection connection2 = DbConnectionContext.getConnection("user-schema");
```

> **警告**: `TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY` の値は `"transaction"`。この名前（`"transaction"`）と無名コネクションは同義であるため、以下の振る舞いに注意:
> - 無名で登録したコネクションは `"transaction"` 指定で取得可能
> - `"transaction"` で登録したコネクションは無名で取得可能
> - 無名が登録済みの状態で `"transaction"` を追加登録しようとするとエラー（既に登録済みのため）

<details>
<summary>keywords</summary>

DbConnectionContext, AppDbConnection, TransactionContext, DEFAULT_TRANSACTION_CONTEXT_KEY, データベースコネクション名, 無名コネクション, 名前付きDB接続登録, setConnection, getConnection

</details>

## トランザクション名

`TransactionContext` に登録する `Transaction`（トランザクション）ごとに設定する名前。スレッド内でユニークである必要がある。

トランザクションの取得は基本的にフレームワークの責務。アプリケーションがトランザクションを直接取得するのは、例外発生時（異常終了）であっても処理を確定する必要がある場合。

```java
// 登録（フレームワークの責務）
TransactionContext.setTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, transaction);
TransactionContext.setTransaction("user_schema", transaction2);
// 同一名での再登録はエラー
// TransactionContext.setTransaction("user_schema", transaction3); // エラー

// 取得
Transaction tran = TransactionContext.getTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY);
Transaction tran = TransactionContext.getTransaction("user-schema");
```

<details>
<summary>keywords</summary>

TransactionContext, Transaction, トランザクション名, setTransaction, getTransaction, DEFAULT_TRANSACTION_CONTEXT_KEY, トランザクション登録, トランザクション取得

</details>

## JdbcTransactionを使用した場合のトランザクション名とデータベースコネクション名の関係

`JdbcTransaction` 使用時、トランザクション名とデータベースコネクション名は **1対1** で紐付く仕様。`JdbcTransaction` は自身のトランザクション名と同一名で `DbConnectionContext` に登録されているDB接続を使用してトランザクション制御を行う。

<details>
<summary>keywords</summary>

JdbcTransaction, DbConnectionContext, TransactionContext, トランザクション名とコネクション名の1対1関係, JdbcTransactionのトランザクション制御仕様

</details>

## 実装コードで見るトランザクション制御

```java
// 無名DB接続とデフォルトトランザクションを登録
DbConnectionContext.setConnection(connection1);
TransactionContext.setTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, transaction1);

// "user-schema" でDB接続とトランザクションを登録
DbConnectionContext.setConnection("user-schema", connection2);
TransactionContext.setTransaction("user-schema", transaction2);

// このコミットはconnection1に対して実行される
// connection2はこのトランザクション制御の影響を一切受けない
Transaction tran1 = TransactionContext.getTransaction();
tran1.commit();
```

<details>
<summary>keywords</summary>

DbConnectionContext, TransactionContext, Transaction, commit, DEFAULT_TRANSACTION_CONTEXT_KEY, トランザクションコミット, トランザクション制御実装例, user-schema

</details>
