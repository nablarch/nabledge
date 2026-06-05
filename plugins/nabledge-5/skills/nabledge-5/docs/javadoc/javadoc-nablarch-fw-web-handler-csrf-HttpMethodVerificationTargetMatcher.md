# class HttpMethodVerificationTargetMatcher

**パッケージ:** nablarch.fw.web.handler.csrf

**実装されたインタフェース:**
- VerificationTargetMatcher

---

```java
public class HttpMethodVerificationTargetMatcher
implements VerificationTargetMatcher
```

HTTPメソッドをもとにしてHTTPリクエストがCSRFトークンの検証対象となるか判定を行うクラス。

<p>
デフォルトでは以下のHTTPメソッドをCSRFトークンの検証対象外とする。
<ul>
    <li>GET</li>
    <li>HEAD</li>
    <li>TRACE</li>
    <li>OPTIONS</li>
</ul>
</p>

**作成者:** Uragami Taichi  

---

## フィールドの詳細

### DEFAULT_ALLOWED_METHODS

```java
private static final Set<String> DEFAULT_ALLOWED_METHODS
```

allowedMethodsのデフォルト値

---

### allowedMethods

```java
private Set<String> allowedMethods
```

CSRFトークンの検証対象外となるHTTPメソッドの集合

---

## メソッドの詳細

### match

```java
public boolean match(HttpRequest request)
```

---

### setAllowedMethods

```java
public void setAllowedMethods(Set<String> allowedMethods)
```

CSRFトークンの検証対象外となるHTTPメソッドの集合を設定する。

**パラメータ:**
- `allowedMethods` - CSRFトークンの検証対象外となるHTTPメソッドの集合

---
