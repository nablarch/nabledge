# class LanguageAttributeInHttpSession

**パッケージ:** nablarch.common.web.handler.threadcontext

**継承階層:**
```
java.lang.Object
  └─ LanguageAttributeInHttpSupport
      └─ nablarch.common.web.handler.threadcontext.LanguageAttributeInHttpSession
```

---

```java
public class LanguageAttributeInHttpSession
extends LanguageAttributeInHttpSupport
```

HTTPセッションを使用して言語の保持を行うクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### sessionKey

```java
private String sessionKey
```

言語が格納されるセッション上のキー名

---

## メソッドの詳細

### setSessionKey

```java
public void setSessionKey(String sessionKey)
```

言語が格納されるセッション上のキー名を設定する。

**パラメータ:**
- `sessionKey` - 言語が格納されるセッション上のキー名

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

### getSessionKey

```java
protected String getSessionKey()
```

言語が格納されるセッション上のキー名を取得する。
<p/>
{@link #sessionKey}プロパティが設定されていない場合は、
nablarch.common.handler.threadcontext.LanguageAttribute#getKey()の値を使用する。

**戻り値:**
言語が格納されるセッション上のキー名

---
