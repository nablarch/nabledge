# class ContentTypeOptionsHeader

**パッケージ:** nablarch.fw.web.handler.secure

**実装されたインタフェース:**
- SecureResponseHeader

---

```java
public class ContentTypeOptionsHeader
implements SecureResponseHeader
```

X-Content-Type-Optionsレスポンスヘッダを設定するクラス。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### option

```java
private String option
```

ヘッダに出力する値

---

## メソッドの詳細

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

常に出力する。

---

### setOption

```java
public void setOption(String option)
```

X-Content-Type-Optionsレスポンスヘッダに出力する値を設定する。

**パラメータ:**
- `option` - X-Content-Type-Optionsレスポンスヘッダに出力する値

---
