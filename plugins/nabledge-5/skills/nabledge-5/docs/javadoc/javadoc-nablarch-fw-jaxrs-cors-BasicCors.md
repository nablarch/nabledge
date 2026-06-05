# class BasicCors

**パッケージ:** nablarch.fw.jaxrs.cors

**実装されたインタフェース:**
- Cors

---

```java
public class BasicCors
implements Cors
```

{@link Cors}の基本実装クラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

---

### allowOrigins

```java
private List<String> allowOrigins
```

---

### allowMethods

```java
private String allowMethods
```

---

### allowHeaders

```java
private String allowHeaders
```

---

### maxAge

```java
private long maxAge
```

---

### allowCredentials

```java
private boolean allowCredentials
```

---

## メソッドの詳細

### isPreflightRequest

```java
public boolean isPreflightRequest(HttpRequest request, ExecutionContext context)
```

---

### createPreflightResponse

```java
public HttpResponse createPreflightResponse(HttpRequest request, ExecutionContext context)
```

---

### postProcess

```java
public void postProcess(HttpRequest request, HttpResponse response, ExecutionContext context)
```

---

### processOrigin

```java
private void processOrigin(HttpRequest request, HttpResponse response)
```

---

### processCredentials

```java
private void processCredentials(HttpResponse response)
```

---

### joinWithComma

```java
private static String joinWithComma(List<String> collection)
```

---

### setAllowOrigins

```java
public void setAllowOrigins(List<String> allowOrigins)
```

リソースへのアクセスを許可するオリジンを設定する。

**パラメータ:**
- `allowOrigins` - リソースへのアクセスを許可するオリジン

---

### setAllowMethods

```java
public void setAllowMethods(List<String> allowMethods)
```

リソースへのアクセス時に許可するメソッドを設定する。

**パラメータ:**
- `allowMethods` - リソースへのアクセス時に許可するメソッド

---

### setAllowHeaders

```java
public void setAllowHeaders(List<String> allowHeaders)
```

実際のリクエストで使用できるHTTPヘッダを設定する。

**パラメータ:**
- `allowHeaders` - 実際のリクエストで使用できるHTTPヘッダ

---

### setMaxAge

```java
public void setMaxAge(long maxAge)
```

プリフライトリクエストの結果をキャッシュしてよい時間（秒）を設定する。

**パラメータ:**
- `maxAge` - プリフライトリクエストの結果をキャッシュしてよい時間（秒）

---

### setAllowCredentials

```java
public void setAllowCredentials(boolean allowCredentials)
```

実際のリクエストで資格情報を使用してよいか否かを設定する。

**パラメータ:**
- `allowCredentials` - 実際のリクエストで資格情報を使用してよい場合はtrue

---
