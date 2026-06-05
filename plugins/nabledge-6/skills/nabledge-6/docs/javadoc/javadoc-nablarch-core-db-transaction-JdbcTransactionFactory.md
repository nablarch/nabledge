# class JdbcTransactionFactory

**パッケージ:** nablarch.core.db.transaction

**実装されたインタフェース:**
- TransactionFactory

---

```java
public class JdbcTransactionFactory
implements TransactionFactory
```

{@link nablarch.core.db.transaction.JdbcTransaction}を生成するクラス。

**作成者:** Hisaaki Sioiri  

---

## フィールドの詳細

### isolationLevel

```java
private int isolationLevel
```

アイソレーションレベル

---

### initSqlList

```java
private List<String> initSqlList
```

初期SQL

---

### transactionTimeoutSec

```java
private int transactionTimeoutSec
```

トランザクションタイムアウト秒数

---

## メソッドの詳細

### getTransaction

```java
public Transaction getTransaction(String connectionName)
```

{@link nablarch.core.db.transaction.JdbcTransaction}を生成する。

**パラメータ:**
- `connectionName` - コネクション名

**戻り値:**
トランザクションオブジェクト

---

### setIsolationLevel

```java
public void setIsolationLevel(String isolationLevel)
```

アイソレーションレベルを設定する。<br>
設定できる値は、下記のとおり。<br>
READ_COMMITTED:{@link java.sql.Connection#TRANSACTION_READ_COMMITTED}<br>
READ_UNCOMMITTED:{@link java.sql.Connection#TRANSACTION_READ_UNCOMMITTED}<br>
REPEATABLE_READ:{@link java.sql.Connection#TRANSACTION_REPEATABLE_READ}<br>
SERIALIZABLE:{@link java.sql.Connection#TRANSACTION_SERIALIZABLE}<br>
アイソレーションレベルが設定されない場合は、デフォルトで{@link java.sql.Connection#TRANSACTION_READ_COMMITTED}が使用される。

**パラメータ:**
- `isolationLevel` - アイソレーションレベルを表す文字列。

---

### setInitSqlList

```java
public void setInitSqlList(List<String> initSqlList)
```

初期SQLを設定する。<br>
本メソッドで設定されたSQLは、トランザクション開始時({@link JdbcTransaction#begin()})に実行される。

**パラメータ:**
- `initSqlList` - 初期SQLを保持するListオブジェクト

---

### setTransactionTimeoutSec

```java
public void setTransactionTimeoutSec(int transactionTimeoutSec)
```

トランザクションタイムアウト秒数設定を設定する。
<p/>
設定を省略した場合または、0以下の値を設定した場合はトランザクションタイムアウト機能は無効化される。

**パラメータ:**
- `transactionTimeoutSec` - トランザクションタイムアウト秒数設定

---
