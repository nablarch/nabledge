# class RequestIdAttribute

**パッケージ:** nablarch.common.handler.threadcontext

**実装されたインタフェース:**
- ThreadContextAttribute<Request<?>>

---

```java
public class RequestIdAttribute
implements ThreadContextAttribute<Request<?>>
```

スレッドコンテキストに保持するリクエストID属性。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### getKey

```java
public String getKey()
```

{@inheritDoc}
<pre>
{@link nablarch.core.ThreadContext#REQUEST_ID_KEY} を使用する。
</pre>

---

### getValue

```java
public Object getValue(Request<?> req, ExecutionContext ctx)
```

{@inheritDoc}
<pre>
このクラスではHTTPリクエストURI中からリクエストIDに相当する部分を抜き出して返却する。
</pre>

---
