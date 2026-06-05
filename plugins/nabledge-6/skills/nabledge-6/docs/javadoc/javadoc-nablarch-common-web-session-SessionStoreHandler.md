# class SessionStoreHandler

**パッケージ:** nablarch.common.web.session

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class SessionStoreHandler
implements Handler<Object,Object>
```

ストアを選択できるセッション保存機能のためのハンドラ。

**作成者:** kawasima  
**作成者:** tajima  

---

## フィールドの詳細

### sessionManager

```java
private SessionManager sessionManager
```

セッションマネージャ

---

### cookieName

```java
private String cookieName
```

クッキーの名称。

---

### cookiePath

```java
private String cookiePath
```

クッキーのpath属性。

---

### cookieDomain

```java
private String cookieDomain
```

クッキーのdomain属性。

---

### cookieSecure

```java
private boolean cookieSecure
```

クッキーにsecure属性を指定するかどうか。

---

### IS_INVALIDATED_KEY

```java
public static final String IS_INVALIDATED_KEY
```

セッションがinvalidateされたことを示すフラグを
リクエストスコープに設定する際に使用するキー

---

### expiration

```java
private Expiration expiration
```

有効期限

---

## メソッドの詳細

### isInvalidated

```java
private boolean isInvalidated(ExecutionContext ctx)
```

セッションがinvalidateされたかを取得する。

**パラメータ:**
- `ctx` - コンテキスト

**戻り値:**
セッションがinvalidateされた場合はtrue

---

### handleLoadFailed

```java
protected HttpResponse handleLoadFailed(Object data, ExecutionContext context, RuntimeException e)
```

セッションのロード時に発生した{@link RuntimeException}を処理する。
<p/>
次の例外が発生した場合は、クライアントによる改竄の可能性があるため、
ステータスコード400のエラーレスポンスを返却する。
<pre>
・{@link HiddenStoreLoadFailedException}
</pre>
それ以外は、指定された例外をそのまま再送出する。

**パラメータ:**
- `data` - 入力データ
- `context` - 実行コンテキスト
- `e` - {@link RuntimeException}

**戻り値:**
レスポンスオブジェクト

---

### handle

```java
public Object handle(Object data, ExecutionContext context)
```

---

### invalidateHttpSession

```java
private static void invalidateHttpSession(ServletExecutionContext context)
```

HttpSessionを無効化する。

**パラメータ:**
- `context` - Servlet実行コンテキスト

---

### writeId

```java
protected void writeId(Session session, ServletExecutionContext context)
```

セッションIDを書き出す。

**パラメータ:**
- `session` - セッション
- `context` - 実行コンテキスト

---

### setSessionTrackingCookie

```java
protected void setSessionTrackingCookie(Session session, HttpServletResponse response)
```

セッションIDを保持するためのクッキーをレスポンスのSet-Cookieヘッダに追加する。

**パラメータ:**
- `session` - セッション
- `response` - サーブレットレスポンス

---

### readId

```java
protected String readId(ServletExecutionContext context, long current)
```

クッキーからセッションIDを読み出す。

**パラメータ:**
- `context` - 実行コンテキスト

**戻り値:**
セッションID

---

### getSessionId

```java
private String getSessionId(ServletExecutionContext context)
```

セッションIDを取得する。

**パラメータ:**
- `context` - 実行コンテキスト

**戻り値:**
セッションID

---

### setSessionManager

```java
public void setSessionManager(SessionManager sessionManager)
```

セッションマネージャを設定する。

**パラメータ:**
- `sessionManager` - セッションマネージャ

---

### setCookieName

```java
public void setCookieName(String cookieName)
```

セッションIDを保持するクッキーの名称を設定する。
デフォルトは "NABLARCH_SID"

**パラメータ:**
- `cookieName` - クッキー名

---

### setCookiePath

```java
public void setCookiePath(String cookiePath)
```

セッションIDを保持するクッキーのpath属性を設定する。
デフォルトではホスト配下の全てのパスを送信対象とする。

**パラメータ:**
- `cookiePath` - クッキーパス

---

### setCookieDomain

```java
public void setCookieDomain(String cookieDomain)
```

セッションIDを保持するクッキーのdomain属性を設定する。
デフォルトでは未指定。
この場合、当該のクッキーは発行元ホストのみに送信される。

**パラメータ:**
- `cookieDomain` - クッキードメイン

---

### setCookieSecure

```java
public void setCookieSecure(boolean cookieSecure)
```

セッショントラッキングIDを保持するクッキーにsecure属性を指定するかどうかを設定する。
trueに設定した場合、当該のクッキーはSSL接続されたリクエストでのみ送信される。
デフォルトはfalse。

**パラメータ:**
- `cookieSecure` - セキュア属性を付けたいならばtrue

---

### setExpiration

```java
public void setExpiration(Expiration expiration)
```

有効期限を設定する。

**パラメータ:**
- `expiration` - 有効期限

---
