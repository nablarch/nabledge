# @interface UseToken

**パッケージ:** nablarch.common.web.token

---

```java
public @interface UseToken
```

二重サブミットを防止するために使用されるトークンを生成する{@link Interceptor}。

<p>
本インターセプタで生成されたトークンは{@link OnDoubleSubmission}インターセプタでチェックされる。
例えば、入力画面→確認画面→登録処理＆完了画面という画面構成の場合、
確認画面を開くアクションでトークンを生成して登録処理のアクションでトークンのチェックを行うようにする。
</p>

<p>
次にコード例を示す。
</p>

<pre>
{@code @UseToken}
public HttpResponse confirm(HttpRequest req, ExecutionContext ctx) {
    // 省略
}

{@code @OnDoubleSubmission(path = "xxx.jsp")}
public HttpResponse executeAndComplete(HttpRequest req, ExecutionContext ctx) {
    // 省略
}
</pre>

<p>
なお、ビューにJSPを使用している場合はn:formカスタムタグのuseToken属性をtrueにすることで、
本インターセプタを適用しなくてもトークンを生成できる。
</p>

**作成者:** Taichi Uragami  

---
