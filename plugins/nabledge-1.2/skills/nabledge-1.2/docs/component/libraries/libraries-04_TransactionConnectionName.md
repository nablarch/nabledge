# データベースコネクション名とトランザクション名

## データベースコネクション名

`DbConnectionContext` に設定する `AppDbConnection`（データベース接続）ごとに設定する名前。スレッド内でユニーク必須。`DbConnectionContext` からDB接続を取得する際に使用する。

**名前を分けて登録するケース:**
- 接続先が異なる場合
- 同一接続先で異なるトランザクション制御が必要な場合（例: 業務処理内で別トランザクション）

> **注意**: `DbConnectionContext` には無名のDB接続を1つだけ登録可能。無名のDB接続はビジネスロジックのメインDB接続に推奨（名前指定が不要のため、指定間違いによる不具合を防止）。無名でも内部的には `TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY`（値: `"transaction"`）で保持される。

> **警告**: `TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY` の値は `"transaction"`。無名のDB接続と `"transaction"` は同義。無名で登録したコネクションは `"transaction"` 指定で取得可能、逆も同様。無名が登録済みの場合に `"transaction"` で登録しようとするとエラーになる（同名登録はエラー）。

**使用例:**

```java
// 無名のDB接続を登録（内部的に "transaction" キーで保持）
DbConnectionContext.setConnection(connection1);
// 上記は下記いずれとも同義
DbConnectionContext.setConnection(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, connection1);
DbConnectionContext.setConnection("transaction", connection1);

// "user-schema" という名前でDB接続を登録
DbConnectionContext.setConnection("user-schema", connection2);

// 同一スレッドで既登録の名前で登録するとエラー
DbConnectionContext.setConnection("user-schema", connection3); // エラー

// 無名のDB接続を取得
AppDbConnection connection1 = DbConnectionContext.getConnection();
// 名前指定で取得
AppDbConnection connection2 = DbConnectionContext.getConnection("user-schema");
```

<details>
<summary>keywords</summary>

DbConnectionContext, AppDbConnection, TransactionContext, DEFAULT_TRANSACTION_CONTEXT_KEY, setConnection, getConnection, データベースコネクション名, データベース接続管理, 無名コネクション

</details>

## トランザクション名

`TransactionContext` に設定する `Transaction`（トランザクション）ごとに設定する名前。スレッド内でユニーク必須。`TransactionContext` からトランザクションを取得する際に使用する。

**JdbcTransaction使用時:** トランザクション名とデータベースコネクション名は1対1で紐付く。`JdbcTransaction` は自身のトランザクション名と同名で `DbConnectionContext` に登録されているDB接続を使用してトランザクション制御を行う。

**使用例:**

```java
// トランザクションの登録（フレームワークの責務）
TransactionContext.setTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, transaction);
TransactionContext.setTransaction("user_schema", transaction2);
// 同一スレッドで既登録の名前で登録するとエラー
TransactionContext.setTransaction("user_schema", transaction3); // エラー

// トランザクションの取得
// 基本的にフレームワークの責務だが、アプリケーションでトランザクションが必要となるケースは、
// 例外発生時（異常終了）であっても処理を確定する必要がある場合である。
Transaction tran = TransactionContext.getTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY);
Transaction tran2 = TransactionContext.getTransaction("user-schema");
```

<details>
<summary>keywords</summary>

TransactionContext, Transaction, JdbcTransaction, setTransaction, getTransaction, トランザクション名, トランザクション制御, データベースコネクション名との1対1対応

</details>

## 実装コードで見るトランザクション制御

`JdbcTransaction` 使用時のトランザクション名とDB接続名の1対1対応を示す実装例。同名で登録されたDB接続とトランザクションが紐付き、commit操作は対応するDB接続にのみ影響する。

```java
// 無名のDB接続とトランザクションを登録
DbConnectionContext.setConnection(connection1);
TransactionContext.setTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, transaction1);

// "user-schema" という名前でDB接続とトランザクションを登録
DbConnectionContext.setConnection("user-schema", connection2);
TransactionContext.setTransaction("user-schema", transaction2);

// このcommit処理は connection1 に対してのみ実行される（connection2 は影響なし）
Transaction tran1 = TransactionContext.getTransaction();
tran1.commit();
```

<details>
<summary>keywords</summary>

JdbcTransaction, トランザクション制御, commit, DbConnectionContext, TransactionContext, 1対1対応, user-schema, DEFAULT_TRANSACTION_CONTEXT_KEY

</details>
