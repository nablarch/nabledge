# class RequestResponseCookieManager

**パッケージ:** nablarch.test.core.http

**実装されたインタフェース:**
- RequestResponseProcessor

---

```java
public class RequestResponseCookieManager
implements RequestResponseProcessor
```

Cookieを引き継ぐためのプロセッサ。
レスポンス内の{@link HttpCookie}より指定されたCookieの値を取得し、
リクエストのCookieとして付加する。

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

---

### cookieValue

```java
private String cookieValue
```

---

### cookieName

```java
private String cookieName
```

---

## メソッドの詳細

### processRequest

```java
public HttpRequest processRequest(HttpRequest request)
```

---

### processResponse

```java
public HttpResponse processResponse(HttpRequest request, HttpResponse response)
```

---

### reset

```java
public void reset()
```

---

### setCookieName

```java
public void setCookieName(String cookieName)
```

Cookieの名前を設定する。

**パラメータ:**
- `cookieName` - Cookie名

---

### logDebug

```java
private void logDebug(String message)
```

---
