# class DomaTransactionNotSupportedConfig

**パッケージ:** nablarch.integration.doma

**実装されたインタフェース:**
- Config

---

```java
public final class DomaTransactionNotSupportedConfig
implements Config
```

Domaを使用してトランザクションを使用せずデータベースアクセスを行うための設定を保持するクラス。
<p>
トランザクションを使用しないため、全てのデータベースアクセス処理が自動コミットされる。
本クラスを適用した{@link org.seasar.doma.Dao}クラスで行うデータベースへの変更は、十分注意すること。

**作成者:** siosio  

---

## フィールドの詳細

### CONFIG

```java
private static final DomaTransactionNotSupportedConfig CONFIG
```

シングルトンインスタンス

---

### dialect

```java
private final Dialect dialect
```

ダイアレクト

---

### dataSource

```java
private final DataSource dataSource
```

データソース

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

### DomaTransactionNotSupportedConfig

```java
private DomaTransactionNotSupportedConfig()
```

DBアクセスを行うための設定を持つインスタンスを生成する。

---

## メソッドの詳細

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

### getJdbcLogger

```java
public JdbcLogger getJdbcLogger()
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
public static DomaTransactionNotSupportedConfig singleton()
```

シングルトンインスタンスを取得する。

**戻り値:**
シングルトンインスタンス

---
