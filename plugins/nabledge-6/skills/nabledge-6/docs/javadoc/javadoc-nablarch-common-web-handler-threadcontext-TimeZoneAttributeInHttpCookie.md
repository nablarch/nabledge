# class TimeZoneAttributeInHttpCookie

**パッケージ:** nablarch.common.web.handler.threadcontext

**継承階層:**
```
java.lang.Object
  └─ TimeZoneAttributeInHttpSupport
      └─ nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpCookie
```

---

```java
public class TimeZoneAttributeInHttpCookie
extends TimeZoneAttributeInHttpSupport
```

クッキーを使用してタイムゾーンの保持を行うクラス。

クッキーのhttpOnly属性はアプリケーションで使用しているServlet APIがサポートしている場合のみ設定する。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### cookieSupport

```java
private final CookieSupport cookieSupport
```

クッキー処理のサポート

---

## メソッドの詳細

### setCookieName

```java
public void setCookieName(String cookieName)
```

タイムゾーンを保持するクッキーの名前を設定する。

**パラメータ:**
- `cookieName` - タイムゾーンを保持するクッキーの名前

---

### setCookiePath

```java
public void setCookiePath(String cookiePath)
```

タイムゾーンを保持するクッキーが送信されるURIのパス階層を設定する。

**パラメータ:**
- `cookiePath` - タイムゾーンを保持するクッキーが送信されるURIのパス階層

---

### setCookieDomain

```java
public void setCookieDomain(String cookieDomain)
```

タイムゾーンを保持するクッキーが送信されるドメイン階層を設定する。

**パラメータ:**
- `cookieDomain` - タイムゾーンを保持するクッキーが送信されるドメイン階層

---

### setCookieMaxAge

```java
public void setCookieMaxAge(Integer cookieMaxAge)
```

タイムゾーンを保持するクッキーの最長存続期間(秒単位)を設定する。

**パラメータ:**
- `cookieMaxAge` - タイムゾーンを保持するクッキーの最長存続期間(秒単位)

---

### setCookieSecure

```java
public void setCookieSecure(boolean secure)
```

タイムゾーンを保持するクッキーのsecure属性を設定する。
（デフォルトではsecure属性を設定しない）

**パラメータ:**
- `secure` - secure属性を設定するか否か（真の場合、secure属性を設定する）

---

### setCookieHttpOnly

```java
public void setCookieHttpOnly(boolean httpOnly)
```

保持するクッキーのhttpOnly属性有無を指定する。
（デフォルトではサポートしていればhttpOnly属性を設定する）

**パラメータ:**
- `httpOnly` - httpOnly属性を設定するか否か（真の場合、httpOnly属性を設定する）

---

### keepTimeZone

```java
protected void keepTimeZone(HttpRequest req, ServletExecutionContext ctx, String timeZone)
```

---

### getKeepingTimeZone

```java
protected String getKeepingTimeZone(HttpRequest req, ServletExecutionContext ctx)
```

---
