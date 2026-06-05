# class ReferrerPolicyHeader

**パッケージ:** nablarch.fw.web.handler.secure

**実装されたインタフェース:**
- SecureResponseHeader

---

```java
public class ReferrerPolicyHeader
implements SecureResponseHeader
```

Referrer-Policyレスポンスヘッダを設定するクラス。
<p>
デフォルトは"strict-origin-when-cross-origin"。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### VALUES

```java
private static final Set<String> VALUES
```

Referrer-Policyレスポンスヘッダに指定できる値

---

### value

```java
private String value
```

Referrer-Policyレスポンスヘッダに指定する値

---

## メソッドの詳細

### setValue

```java
public void setValue(String value)
```

Referrer-Policyレスポンスヘッダに指定する値を設定する。

**パラメータ:**
- `value` - Referrer-Policyレスポンスヘッダに指定する値

---

### getName

```java
public String getName()
```

---

### getValue

```java
public String getValue()
```

---

### isOutput

```java
public boolean isOutput(HttpResponse response, ServletExecutionContext context)
```

---
