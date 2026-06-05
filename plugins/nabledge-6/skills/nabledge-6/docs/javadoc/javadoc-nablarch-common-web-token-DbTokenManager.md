# class DbTokenManager

**パッケージ:** nablarch.common.web.token

**実装されたインタフェース:**
- TokenManager

---

```java
public class DbTokenManager
implements TokenManager
```

DBを使用した{@link TokenManager}実装クラス

---

## フィールドの詳細

### dbManager

```java
private SimpleDbTransactionManager dbManager
```

SimpleDbTransactionManagerのインスタンス。

---

### dbTokenSchema

```java
private DbTokenSchema dbTokenSchema
```

トークンテーブルのスキーマ

---

### insertSql

```java
private String insertSql
```

登録用SQL

---

### deleteSql

```java
private String deleteSql
```

削除用SQL

---

## メソッドの詳細

### setDbManager

```java
public void setDbManager(SimpleDbTransactionManager dbManager)
```

DbManagerのインスタンスをセットする。

**パラメータ:**
- `dbManager` - SimpleDbTransactionManagerのインスタンス

---

### setDbTokenSchema

```java
public void setDbTokenSchema(DbTokenSchema dbTokenSchema)
```

トークンテーブルのスキーマをセットする。

**パラメータ:**
- `dbTokenSchema` - トークンテーブルのスキーマ

---

### initialize

```java
public void initialize()
```

初期化処理を行う。
トークンテーブル登録用、削除用のSQL文を組み立てる。

---

### saveToken

```java
public void saveToken(String serverToken, NablarchHttpServletRequestWrapper request)
```

---

### isValidToken

```java
public boolean isValidToken(String clientToken, ServletExecutionContext context)
```

---
