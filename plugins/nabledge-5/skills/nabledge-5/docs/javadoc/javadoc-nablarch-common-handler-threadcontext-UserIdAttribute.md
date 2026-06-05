# class UserIdAttribute

**パッケージ:** nablarch.common.handler.threadcontext

**実装されたインタフェース:**
- ThreadContextAttribute<Object>

---

```java
public class UserIdAttribute
implements ThreadContextAttribute<Object>
```

スレッドコンテキストに保持するユーザID属性。
<pre>
HTTPセッション上に格納されているログインユーザIDを
スレッドコンテキストに格納する。
</pre>

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## フィールドの詳細

### sessionKey

```java
private String sessionKey
```

ログインユーザIDが格納されているHTTPセッション上のキー名

---

### anonymousId

```java
private String anonymousId
```

未ログイン時にスレッドコンテキストに設定されるID

---

## メソッドの詳細

### setSessionKey

```java
public void setSessionKey(String sessionKey)
```

ログインユーザIDが格納されているHTTPセッション上のキー名を設定する。
<pre>
デフォルトでは{@link #getKey()}の値を使用する。
</pre>

**パラメータ:**
- `sessionKey` - HTTPセッション上のキー名

---

### setAnonymousId

```java
public void setAnonymousId(String anonymousId)
```

未ログイン時にスレッドコンテキストに設定されるIDを設定する。
<pre>
明示的にこの値を設定しなかった場合、
未ログイン時にスレッドコンテキスト上のユーザIDは設定されない。
</pre>

**パラメータ:**
- `anonymousId` - 未ログイン時にスレッドコンテキストに設定されるID

---

### getKey

```java
public String getKey()
```

{@inheritDoc}
<pre>
{@link ThreadContext#USER_ID_KEY} を使用する。
</pre>

---

### getValue

```java
public Object getValue(Object req, ExecutionContext ctx)
```

{@inheritDoc}
<pre>
スレッドコンテキストに格納するユーザIDの値は以下のように決定される。
  1. HTTPセッション上のキー{@link #sessionKey} の値を取得する。
     その値がnullでなければスレッドコンテキストに設定する。
  2. HTTPセッション上の値がnullであり、かつ {@link #anonymousId} が
     設定されていれば、その値をスレッドコンテキストに設定する。
  3. 上記以外の場合はnullを設定する。
</pre>

---

### getUserIdSession

```java
protected Object getUserIdSession(ExecutionContext ctx, String skey)
```

セッションからユーザIDを取得する。
デフォルトではHTTPセッションからユーザIDを取得する。
必要に応じてオーバーライドすること。

**パラメータ:**
- `ctx` - 実行コンテキスト
- `skey` - ユーザIDのキー

**戻り値:**
ユーザID

---
