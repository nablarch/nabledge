# class HttpSessionManagedExpiration

**パッケージ:** nablarch.common.web.session

**実装されたインタフェース:**
- Expiration

---

```java
public class HttpSessionManagedExpiration
implements Expiration
```

HttpSessionを使用した{@link Expiration}実装クラス。

---

## フィールドの詳細

### EXPIRATION_DATE_KEY

```java
private static final String EXPIRATION_DATE_KEY
```

セッションの有効期限を格納するHttpSessionの名前

---

## メソッドの詳細

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
