# interface Cors

**パッケージ:** nablarch.fw.jaxrs.cors

---

```java
public interface Cors
```

CORSの処理を行うインタフェース。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### isPreflightRequest

```java
boolean isPreflightRequest(HttpRequest request, ExecutionContext context)
```

リクエストがプリフライトリクエストであるか否かを判定する。

**パラメータ:**
- `request` - リクエスト
- `context` - コンテキスト

**戻り値:**
リクエストがプリフライトリクエストの場合はtrue

---

### createPreflightResponse

```java
HttpResponse createPreflightResponse(HttpRequest request, ExecutionContext context)
```

プリフライトリクエストに対するレスポンスを作成する。

**パラメータ:**
- `request` - リクエスト
- `context` - コンテキスト

**戻り値:**
プリフライトリクエストに対するレスポンス

---

### postProcess

```java
void postProcess(HttpRequest request, HttpResponse response, ExecutionContext context)
```

プリフライトリクエスト後の実際のリクエストのレスポンスに対する処理を行う。

**パラメータ:**
- `request` - リクエスト
- `context` - コンテキスト
- `response` - レスポンス

---
