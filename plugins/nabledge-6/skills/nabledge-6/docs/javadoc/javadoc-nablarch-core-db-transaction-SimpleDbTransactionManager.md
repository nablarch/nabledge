# class SimpleDbTransactionManager

**パッケージ:** nablarch.core.db.transaction

---

```java
public class SimpleDbTransactionManager
```

データベースへのトランザクション制御を行うクラス。<br>

**作成者:** Hisaaki Sioiri  
**関連項目:** nablarch.core.db.connection.ConnectionFactory  
**関連項目:** nablarch.core.transaction.TransactionFactory  
**関連項目:** nablarch.core.ThreadContext  
**関連項目:** nablarch.core.db.connection.DbConnectionContext  

---

## フィールドの詳細

### connectionFactory

```java
private ConnectionFactory connectionFactory
```

コネクションファクトリ

---

### transactionFactory

```java
private TransactionFactory transactionFactory
```

トランザクションファクトリ

---

### dbTransactionName

```java
private String dbTransactionName
```

トランザクション名

---

## メソッドの詳細

### beginTransaction

```java
public void beginTransaction()
```

トランザクションを開始する。<br>

---

### commitTransaction

```java
public void commitTransaction()
```

トランザクションをコミットする。<br>

---

### rollbackTransaction

```java
public void rollbackTransaction()
```

トランザクションをロールバックする。<br>

---

### endTransaction

```java
public void endTransaction()
```

トランザクションを終了し、リソースを解放する。。<br>

---

### setConnectionFactory

```java
public void setConnectionFactory(ConnectionFactory connectionFactory)
```

デフォルトのコネクションファクトリクラスを設定する。

**パラメータ:**
- `connectionFactory` - ConnectionFactory

---

### setTransactionFactory

```java
public void setTransactionFactory(TransactionFactory transactionFactory)
```

デフォルトのトランザクションファクトリクラスを設定する。

**パラメータ:**
- `transactionFactory` - TransactionFactory

---

### setDbTransactionName

```java
public void setDbTransactionName(String dbTransactionName)
```

トランザクション名を設定する。<br>
トランザクション名が設定されない場合は、デフォルトでnablarch.core.transaction.TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEYを使用する。

**パラメータ:**
- `dbTransactionName` - トランザクション名

---

### getDbTransactionName

```java
public String getDbTransactionName()
```

トランザクション名を取得する。

**戻り値:**
トランザクション名

---
