# データベースコネクション名とトランザクション名

本章では、 [トランザクション管理](../../component/libraries/libraries-03-TransactionManager.md) と [データベースアクセス(検索、更新、登録、削除)機能](../../component/libraries/libraries-04-DbAccessSpec.md) で触れた、データベースコネクション名とトランザクション名についての解説を行う。

## データベースコネクション名

データベースコネクション名は、DbConnectionContextに設定するAppDbConnection(以降データベース接続)毎に設定する名前である。
名前を分けて登録するケースは、主に以下の場合である。

* データベースの接続先が異なる場合
* 同一の接続先であるが、異なるトランザクション制御を行う場合。

  (例えば、業務処理内で別トランザクションで処理を行う必要がある場合)

この名前は、スレッド内ではユニークにする必要があり、アプリケーションでDbConnectionContextからデータベース接続を取得する際に使用する名前である。

> **Note:**
> DbConnectionContextには、無名のデータベース接続を１つだけ登録することができる。無名のデータベース接続は、アプリケーションから取得する際にも名前指定なしで取得することができる。
> この無名のデータベース接続は、ビジネスロジックでメインで使用するデータベース接続に使用することを推奨する。
> なぜなら、データベース接続を取得する際に名前を指定する必要がないため、名前の指定間違いによる不具合を防ぐことが出きるからである。

> ※無名の場合であっても、内部的には名前付きでデータベース接続が保持される。この名前は、「TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY」の値となる。

### データベースコネクション名の使用例

```java
//***************************************************************************
// DbConnectionContextへの登録例
// この処理は、フレームワークの責務である。
//***************************************************************************

// 現在実行中のスレッドに、無名のデータベース接続を登録する。
// 内部的にデータベースコネクション名は「TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY」として保持される。
// つまり、DbConnectionContext.setConnection(TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY, connection1)と同義となる。
DbConnectionContext.setConnection(connection1);

//****************************************************************************
// 下記ロジックは、無名のデータベース接続を登録する事と同義である。
DbConnectionContext.setConnection(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, connection1);
DbConnectionContext.setConnection("transaction", connection1);
//****************************************************************************

// 現在実行中のスレッドに、データベースコネクション名：user-schemaでデータベース接続を登録する。
DbConnectionContext.setConnection("user-schema", connection2);

// 同一スレッドで既に登録されている名前で登録を行った場合は、エラーとなる。
DbConnectionContext.setConnection("user-schema", connection3);        // 「user-schema」は既に登録されているのでエラー

//***************************************************************************
// ビジネスロジックでのAppDbConnectionの取得例
//***************************************************************************

// 無名のデータベース接続を取得する。
AppDbConnection connection1 = DbConnectionContext.getConnection();

// データベースコネクション名に「user-schema」を指定してデータベース接続を取得する。
AppDbConnection connection2 = DbConnectionContext.getConnection("user-schema");
```

> **Attention:**
> TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEYの値は、「transaction」となっている。
> この名前(transaction)は、無名のデータベース接続の内部的な名前であるため、「transaction」と無名のデータベースコネクションは同義となる。
> 無名と「transaction」を同時に使用した場合の振る舞いは、下記実装を参照。

> ```java
> // 無名のコネクションは、「transaction」を指定して取得できる。
> DbConnectionContext.setConnection(connection);
> DbConnectionContext.getConnection("transaction");
> 
> // 「transaction」で登録したコネクションは、無名で取得できる。
> DbConnectionContext.setConnection("transaction", connection);
> DbConnectionContext.getConnection();
> 
> // 無名が登録されている場合、「transaction」は登録できない。
> DbConnectionContext.cetConnection(connection1);
> DbConnectionContext.setConnection("transaction", connection);        // 「transaction」は既に登録されているのでエラー
> ```

## トランザクション名

トランザクション名は、TransactionContextに設定するTransaction(以降トランザクション)毎に設定する名前である。
この名前は、スレッド内ではユニークにする必要があり、アプリケーションでTransactionContextからトランザクションを取得する際に使用する名前である。

### トランザクション名の使用例

```java
//***************************************************************************
// TransactionContextへの登録例
// この処理は、フレームワークの責務である。
//***************************************************************************

// 現在実行中のスレッドに、トランザクション名：TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEYでトランザクションを登録する。
TransactionContext.setTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, transaction);

// 現在実行中のスレッドに、トランザクション名：user-schemaでトランザクションを登録する。
TransactionContext.setTransaction("user_schema", transaction2);

// 同一スレッドで既に登録されている名前で登録を行った場合は、エラーとなる。
TransactionContext.setTransaction("user_schema", transaction3);       // 「user_schema」は既に登録されているのでエラー

//***************************************************************************
// トランザクションの取得例
// 基本的にこの処理はフレームワークの責務である。
// アプリケーションで、トランザクションが必要となるケースは、
// 例外発生時(異常終了)であっても処理を確定する必要がある場合である。
//***************************************************************************
// トランザクション名に「TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY」を指定してトランザクションを取得する。
Transaction tran = TransactionContext.getTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY);

// トランザクション名に「user-schema」を指定してトランザクションを取得する。
Transaction tran = TransactionContext.getTransaction("user-schema");
```

### JdbcTransactionを使用した場合のトランザクション名とデータベースコネクション名の関係

本クラスを使用した場合、トランザクション名とデータベースコネクション名は1対1で紐付く仕様となっている。
つまり、JdbcTransactionは、自身のトランザクション名と同一の名前でDbConnectionContextに登録されているデータベース接続を使用して、
トランザクション制御を行う仕様となっている。

#### 実装コードで見るトランザクション制御

```java
// 無名のデータベース接続とトランザクションを登録
DbConnectionContext.setConnection(connection1);
TransactionContext.setTransaction(TransactionContext.DEFAULT_TRANSACTION_CONTEXT_KEY, transaction1);

// user-schemaという名前でデータベース接続とトランザクションを登録
DbConnectionContext.setConnection("user-schema", connection2);
TransactionContext.setTransaction("user-schema", transaction2);

// このコミット処理は、connection1に対して実行される。
// connection2は、このトランザクション制御の影響を一切うけない。
Transaction tran1 = TransactionContext.getTransaction();
tran1.commit();
```
