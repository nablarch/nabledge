# class HttpSessionTokenManager

**パッケージ:** nablarch.common.web.token

**実装されたインタフェース:**
- TokenManager

---

```java
public class HttpSessionTokenManager
implements TokenManager
```

HttpSessionを使った{@link TokenManager}実装クラス。

**作成者:** Tsuyoshi Kawasaki  

---

## メソッドの詳細

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

### initialize

```java
public void initialize()
```

---
