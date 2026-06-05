# interface MessageBodyLogTargetMatcher

**パッケージ:** nablarch.fw.jaxrs

---

```java
public interface MessageBodyLogTargetMatcher
```

メッセージボディがログ出力対象であるか判定するためのインタフェース。

---

## メソッドの詳細

### initialize

```java
void initialize(Map<String,String> props)
```

初期化する。

**パラメータ:**
- `props` - 各種ログ出力の設定情報

---

### isTargetRequest

```java
boolean isTargetRequest(HttpRequest request, ExecutionContext context)
```

ログ出力対象のリクエストボディであるか判定する。

**パラメータ:**
- `request` - {@link HttpRequest}
- `context` - {@link ExecutionContext}

**戻り値:**
出力対象であれば {@code true}

---

### isTargetResponse

```java
boolean isTargetResponse(HttpRequest request, HttpResponse response, ExecutionContext context)
```

ログ出力対象のレスポンスボディであるか判定する。

**パラメータ:**
- `request` - {@link HttpRequest}
- `response` - {@link HttpResponse}
- `context` - {@link ExecutionContext}

**戻り値:**
出力対象であれば {@code true}

---
