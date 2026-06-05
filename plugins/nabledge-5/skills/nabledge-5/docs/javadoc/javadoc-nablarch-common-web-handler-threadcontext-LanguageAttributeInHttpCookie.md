# class LanguageAttributeInHttpCookie

**パッケージ:** nablarch.common.web.handler.threadcontext

**継承階層:**
```
java.lang.Object
  └─ LanguageAttributeInHttpSupport
      └─ nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpCookie
```

---

```java
public class LanguageAttributeInHttpCookie
extends LanguageAttributeInHttpSupport
```

クッキーを使用して言語の保持を行うクラス。

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

言語を保持するクッキーの名前を設定する。

**パラメータ:**
- `cookieName` - 言語を保持するクッキーの名前

---

### setCookiePath

```java
public void setCookiePath(String cookiePath)
```

言語を保持するクッキーが送信されるURIのパス階層を設定する。

**パラメータ:**
- `cookiePath` - 言語を保持するクッキーが送信されるURIのパス階層

---

### setCookieDomain

```java
public void setCookieDomain(String cookieDomain)
```

言語を保持するクッキーが送信されるドメイン階層を設定する。

**パラメータ:**
- `cookieDomain` - 言語を保持するクッキーが送信されるドメイン階層

---

### setCookieMaxAge

```java
public void setCookieMaxAge(Integer cookieMaxAge)
```

言語を保持するクッキーの最長存続期間(秒単位)を設定する。

**パラメータ:**
- `cookieMaxAge` - 言語を保持するクッキーの最長存続期間(秒単位)

---

### setCookieSecure

```java
public void setCookieSecure(boolean secure)
```

言語を保持するクッキーのsecure属性有無を指定する。
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

### keepLanguage

```java
protected void keepLanguage(HttpRequest req, ServletExecutionContext ctx, String language)
```

---

### getKeepingLanguage

```java
protected String getKeepingLanguage(HttpRequest req, ServletExecutionContext ctx)
```

---
