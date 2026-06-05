# class DbManagedExpiration

**パッケージ:** nablarch.common.web.session

**実装されたインタフェース:**
- Expiration
- Initializable

---

```java
public class DbManagedExpiration
implements Expiration, Initializable
```

DBを使用した{@link Expiration}実装クラス。

**作成者:** Goro Kumano  

---

## フィールドの詳細

### dbManager

```java
private SimpleDbTransactionManager dbManager
```

SimpleDbTransactionManagerのインスタンス

---

### userSessionSchema

```java
private UserSessionSchema userSessionSchema
```

ユーザセッションテーブルのスキーマ

---

### selectUserSessionSql

```java
private String selectUserSessionSql
```

有効期限を取得するSQL

---

### insertUserSessionSql

```java
private String insertUserSessionSql
```

有効期限を追加するSQL

---

### updateUserSessionSql

```java
private String updateUserSessionSql
```

有効期限を更新するSQL

---

### countUserSessionSql

```java
private String countUserSessionSql
```

有効期限の件数を取得するSQL

---

### COUNT

```java
private static final String COUNT
```

有効期限の件数エイリアス *

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

### setUserSessionSchema

```java
public void setUserSessionSchema(UserSessionSchema userSessionSchema)
```

ユーザセッションテーブルのスキーマをセットする。

**パラメータ:**
- `userSessionSchema` - ユーザセッションテーブルのスキーマ

---

### isExpired

```java
public boolean isExpired(String sessionId, long currentDateTime, ExecutionContext context)
```

---

### saveExpirationDateTime

```java
public void saveExpirationDateTime(String sessionId, long expirationDateTime, ExecutionContext context)
```

---

### isDeterminable

```java
public boolean isDeterminable(String sessionId, ExecutionContext context)
```

---

### updateSessionExpiration

```java
private int updateSessionExpiration(String sessionId, long expirationDateTime, AppDbConnection connection)
```

有効期限を更新する。

**パラメータ:**
- `sessionId` - セッションID
- `expirationDateTime` - 有効期限
- `connection` - {@link AppDbConnection}

**戻り値:**
更新件数

---

### insertSessionExpiration

```java
private void insertSessionExpiration(String sessionId, long expirationDateTime, AppDbConnection connection)
```

有効期限を挿入する。

**パラメータ:**
- `sessionId` - セッションID
- `expirationDateTime` - 有効期限
- `connection` - {@link AppDbConnection}

---

### initialize

```java
public void initialize()
```

---
