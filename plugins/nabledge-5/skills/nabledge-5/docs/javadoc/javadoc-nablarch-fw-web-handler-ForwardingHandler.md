# class ForwardingHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class ForwardingHandler
implements HttpRequestHandler
```

内部フォーワード処理を行うHTTPリクエストハンドラクラス。

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest req, ExecutionContext ctx)
```

{@inheritDoc}
この実装では、レスポンスコンテンツパスのスキームが
"forward://" であった場合に内部フォーワード処理を行う。

---

### needsForwarding

```java
private boolean needsForwarding(HttpResponse res)
```

このHTTPレスポンスを処理する際に内部フォーワードが必要か？

**パラメータ:**
- `res` - HTTPレスポンスオブジェクト

**戻り値:**
内部フォーワードが必要な場合はtrue

---

### doForwarding

```java
private HttpResponse doForwarding(HttpResponse res, HttpRequest req, ExecutionContext ctx)
```

内部フォーワードを処理する。
<pre>
コンテンツパスのスキーム値が "forward" であった場合、
指定されたパスをリクエストURIに設定した上で、
リクエストプロセッサ以降の処理を再実行し、その結果を返す。

</pre>

**パラメータ:**
- `res` - HTTPレスポンスオブジェクト
- `req` - HTTPリクエストオブジェクト
- `ctx` - 実行コンテキストオブジェクト

**戻り値:**
フォーワード結果

---
