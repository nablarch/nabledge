# class JaxRsBodyLogTargetMatcher

**パッケージ:** nablarch.fw.jaxrs

**実装されたインタフェース:**
- MessageBodyLogTargetMatcher

---

```java
public class JaxRsBodyLogTargetMatcher
implements MessageBodyLogTargetMatcher
```

JAX-RSのメッセージボディがログ出力対象であるか判定するクラス。

---

## フィールドの詳細

### TARGET_MEDIA_TYPES

```java
private static final List<String> TARGET_MEDIA_TYPES
```

ログ出力対象のコンテンツタイプ

---

## メソッドの詳細

### initialize

```java
public void initialize(Map<String,String> props)
```

---

### isTargetRequest

```java
public boolean isTargetRequest(HttpRequest request, ExecutionContext context)
```

---

### isTargetResponse

```java
public boolean isTargetResponse(HttpRequest request, HttpResponse response, ExecutionContext context)
```

---

### isTargetContentType

```java
private boolean isTargetContentType(String contentType)
```

ログ出力対象のコンテンツタイプであるか判定する。

**パラメータ:**
- `contentType` - コンテンツタイプ

**戻り値:**
出力対象である場合は {@code true}

---
