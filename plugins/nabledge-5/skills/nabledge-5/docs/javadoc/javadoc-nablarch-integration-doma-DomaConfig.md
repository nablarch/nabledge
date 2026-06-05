# class DomaConfig

**パッケージ:** nablarch.integration.doma

**実装されたインタフェース:**
- Config

---

```java
public final class DomaConfig
implements Config
```

Domaを使用してデータベースアクセスを行うための設定を保持するクラス。

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### CONFIG

```java
private static final DomaConfig CONFIG
```

シングルトンインスタンス

---

### dialect

```java
private final Dialect dialect
```

ダイアレクト

---

### localTransactionDataSource

```java
private final LocalTransactionDataSource localTransactionDataSource
```

ローカルトランザクションデータソース

---

### localTransactionManager

```java
private final LocalTransactionManager localTransactionManager
```

ローカルトランザクションマネージャ

---

### localTransaction

```java
private final LocalTransaction localTransaction
```

ローカルトランザクション

---

### jdbcLogger

```java
private final JdbcLogger jdbcLogger
```

ロガー

---

### domaStatementProperties

```java
private final DomaStatementProperties domaStatementProperties
```

DomaProperties

---

## コンストラクタの詳細

### DomaConfig

```java
private DomaConfig()
```

DBアクセスを行うための設定を持つインスタンスを生成する。

---

## メソッドの詳細

### getJdbcLogger

```java
public JdbcLogger getJdbcLogger()
```

---

### getDialect

```java
public Dialect getDialect()
```

---

### getDataSource

```java
public DataSource getDataSource()
```

---

### getTransactionManager

```java
public TransactionManager getTransactionManager()
```

---

### getNaming

```java
public Naming getNaming()
```

---

### getMaxRows

```java
public int getMaxRows()
```

---

### getFetchSize

```java
public int getFetchSize()
```

---

### getQueryTimeout

```java
public int getQueryTimeout()
```

---

### getBatchSize

```java
public int getBatchSize()
```

---

### singleton

```java
public static DomaConfig singleton()
```

シングルトンインスタンスを取得する。

**戻り値:**
シングルトンインスタンス

---

### getLocalTransaction

```java
public LocalTransaction getLocalTransaction()
```

ローカルトランザクションを取得する。

**戻り値:**
ローカルトランザクション

---
