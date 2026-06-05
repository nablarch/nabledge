# interface TransactionManagerConnection

**パッケージ:** nablarch.core.db.connection

**継承階層:**
```
java.lang.Object
  └─ AppDbConnection
      └─ nablarch.core.db.connection.TransactionManagerConnection
```

---

```java
public interface TransactionManagerConnection
extends AppDbConnection
```

データベースに対するトランザクション制御を行うインタフェース。<br>

**作成者:** Hisaaki Sioiri  
**関連項目:** Connection  

---

## メソッドの詳細

### initialize

```java
void initialize()
```

データベース接続オブジェクトの初期化処理を行う。

---

### commit

```java
void commit()
```

現在のデータベース接続に対してcommitを実行する。

---

### rollback

```java
void rollback()
```

現在のデータベース接続に対してrollbackを実行する。

---

### terminate

```java
void terminate()
```

データベース接続の終了処理を行う。<br>
実装クラスでは、最低限{@link Connection#close()}を呼び出しリソースの開放処理を行う必要がある。

---

### setIsolationLevel

```java
void setIsolationLevel(int level)
```

アイソレーションレベルを設定する。

**パラメータ:**
- `level` - アイソレーションレベル

---

### setJdbcTransactionTimeoutHandler

```java
void setJdbcTransactionTimeoutHandler(JdbcTransactionTimeoutHandler jdbcTransactionTimeoutHandler)
```

トランザクションタイムアウトハンドラを設定する。

**パラメータ:**
- `jdbcTransactionTimeoutHandler` - トランザクションタイムアウトハンドラ

---

### getConnection

```java
Connection getConnection()
```

データベース接続オブジェクトを取得する。

**戻り値:**
データベース接続オブジェクト

---

### getDialect

```java
Dialect getDialect()
```

コネクションの{@link DefaultDialect}を取得する。

**戻り値:**
SQL方言

---

### removeStatement

```java
void removeStatement(SqlStatement statement)
```

保持しているStatementを削除する。

**パラメータ:**
- `statement` - 削除対象のステートメント

---
