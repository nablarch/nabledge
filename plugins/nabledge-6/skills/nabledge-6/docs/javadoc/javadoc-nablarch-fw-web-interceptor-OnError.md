# @interface OnError

**パッケージ:** nablarch.fw.web.interceptor

---

```java
public @interface OnError
```

リクエストハンドラが例外を送出した場合のレスポンスを指定する{@link Interceptor}。
<pre>
次の例では、"ApplicationException"が送出された場合の遷移先を
入力画面(registerForm.jsp)に設定している。

{@code @OnError} (
     type = ApplicationException.class
   , path ="servlet://registerForm.jsp"
 )
 public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
     registerUser(req.getParamMap());
     return new HttpResponse(200, "servlet://registrationCompleted.jsp");
 }

 この処理は、以下のコードによる処理と本質的に同等である。

 public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
     try {
         registerUser(req.getParamMap());
         return new HttpResponse(200, "servlet://registrationCompleted.jsp");
     } catch(ApplicationException ae) {
         throw new HttpErrorResponse(400, "servlet://registerForm.jsp", ae);
     }
 }
</pre>

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  
**関連項目:** OnError.Impl  

---
