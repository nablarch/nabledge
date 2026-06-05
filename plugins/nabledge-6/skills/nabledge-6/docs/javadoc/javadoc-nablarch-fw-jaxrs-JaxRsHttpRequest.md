# class JaxRsHttpRequest

**パッケージ:** nablarch.fw.jaxrs

**継承階層:**
```
java.lang.Object
  └─ HttpRequest
      └─ nablarch.fw.jaxrs.JaxRsHttpRequest
```

---

```java
public class JaxRsHttpRequest
extends HttpRequest
```

JAX-RS用の{@link HttpRequest}クラス。
<p/>
{@link JaxRsHttpRequest#getParamMap()}、{@link JaxRsHttpRequest#getParam(String)} を公開APIとし、それ以外のメソッドは保持するHttpRequestに委譲している。

---

## フィールドの詳細

### request

```java
private final HttpRequest request
```

---

## コンストラクタの詳細

### JaxRsHttpRequest

```java
public JaxRsHttpRequest(HttpRequest request)
```

---

## メソッドの詳細

### getParamMap

```java
public Map<String,String[]> getParamMap()
```

---

### getParam

```java
public String[] getParam(String name)
```

---

### getPathParam

```java
public String getPathParam(String name)
```

HTTPリクエストからパスパラメータを取得する。

**パラメータ:**
- `name` - パラメータ名

**戻り値:**
パラメータの値

---

### getMethod

```java
public String getMethod()
```

---

### getRequestUri

```java
public String getRequestUri()
```

---

### setRequestUri

```java
public HttpRequest setRequestUri(String requestUri)
```

---

### getRequestPath

```java
public String getRequestPath()
```

---

### setRequestPath

```java
public HttpRequest setRequestPath(String requestPath)
```

---

### getHttpVersion

```java
public String getHttpVersion()
```

---

### setParam

```java
public HttpRequest setParam(String name, String params)
```

---

### setParamMap

```java
public HttpRequest setParamMap(Map<String,String[]> params)
```

---

### getHeaderMap

```java
public Map<String,String> getHeaderMap()
```

---

### getHeader

```java
public String getHeader(String headerName)
```

---

### getHost

```java
public String getHost()
```

---

### getCookie

```java
public HttpCookie getCookie()
```

---

### getPart

```java
public List<PartInfo> getPart(String name)
```

---

### setMultipart

```java
public void setMultipart(Map<String,List<PartInfo>> multipart)
```

---

### getMultipart

```java
public Map<String,List<PartInfo>> getMultipart()
```

---

### getUserAgent

```java
public UA getUserAgent()
```

---
