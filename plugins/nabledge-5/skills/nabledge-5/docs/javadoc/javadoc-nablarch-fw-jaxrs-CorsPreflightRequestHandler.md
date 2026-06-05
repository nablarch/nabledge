# class CorsPreflightRequestHandler

**パッケージ:** nablarch.fw.jaxrs

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class CorsPreflightRequestHandler
implements HttpRequestHandler
```

CORSのプリフライトリクエストを処理するハンドラ。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### cors

```java
private Cors cors
```

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

---

### setCors

```java
public void setCors(Cors cors)
```

CORSの処理を行うインタフェースを設定する。

**パラメータ:**
- `cors` - CORSの処理を行うインタフェース

---
