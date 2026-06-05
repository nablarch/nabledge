# class TimeZoneAttributeInHttpSession

**パッケージ:** nablarch.common.web.handler.threadcontext

**継承階層:**
```
java.lang.Object
  └─ TimeZoneAttributeInHttpSupport
      └─ nablarch.common.web.handler.threadcontext.TimeZoneAttributeInHttpSession
```

---

```java
public class TimeZoneAttributeInHttpSession
extends TimeZoneAttributeInHttpSupport
```

HTTPセッションを使用してタイムゾーンの保持を行うクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### sessionKey

```java
private String sessionKey
```

タイムゾーンが格納されるセッション上のキー名

---

## メソッドの詳細

### setSessionKey

```java
public void setSessionKey(String sessionKey)
```

タイムゾーンが格納されるセッション上のキー名を設定する。

**パラメータ:**
- `sessionKey` - タイムゾーンが格納されるセッション上のキー名

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

### getSessionKey

```java
protected String getSessionKey()
```

タイムゾーンが格納されるセッション上のキー名を取得する。
<p/>
{@link #sessionKey}プロパティが設定されていない場合は、
nablarch.common.handler.threadcontext.TimeZoneAttribute#getKey()の値を使用する。

**戻り値:**
タイムゾーンが格納されるセッション上のキー名

---
