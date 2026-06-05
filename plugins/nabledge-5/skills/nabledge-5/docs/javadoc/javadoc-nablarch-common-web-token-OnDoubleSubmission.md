# @interface OnDoubleSubmission

**パッケージ:** nablarch.common.web.token

---

```java
public @interface OnDoubleSubmission
```

二重サブミットを防止する{@link Interceptor}。
<p>
業務アクションハンドラのメソッドに付与することで、二重サブミット(同一リクエストの二重送信)のチェックを行う。
</p>

<p>
本インターセプタを使用するためには、トークン設定が必要である。
トークン設定はトークンの生成とHTMLへの埋め込みがある。
トークンの生成は{@link UseToken}でできる。
HTMLへの埋め込みはリクエストに格納されたトークンをテンプレートエンジンでinput要素を組み立てればよい。
Thymeleafの例を示す。
</p>
<pre>{@code <input type="hidden" name="nablarch_token" th:value="${nablarch_request_token}"/>}</pre>

<p>
JSPを使用している場合はn:formタグでトークンを設定できる。
</p>
<pre>
    {@code <n:form useToken="true">
    <n:submit type="button" value="Submit" uri="/XXXXX" allowDoubleSubmission="false">
    </n:form>}
</pre>
本インターセプタは、業務アクションハンドラに次のように実装する。
<pre>
    {@code @OnDoubleSubmission(path = "XXX.jsp")}
    {@code @OnError(type = ApplicationException.class, path = "forward://XXX.html")
    public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
        // 省略
    }}
</pre>

**作成者:** Kiyohito Itoh  

---
