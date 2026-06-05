# @interface OnErrors

**パッケージ:** nablarch.fw.web.interceptor

---

```java
public @interface OnErrors
```

リクエストハンドラが例外を送出した場合のレスポンスを指定する{@link Interceptor}。
<pre>
この{@link Interceptor}は、複数例外に対してレスポンスを指定したい場合に使用する。

次の例では、"ApplicationException"が送出された場合の遷移先を入力画面(inputForm.jsp)、
"OptimisticLockException"が送出された場合の遷移先を業務トップ画面(topForm.jsp)、に設定している。

{@code @OnErrors} ({
     {@code @OnError} (type = OptimisticLockException.class, path ="servlet://topForm.jsp"),
     {@code @OnError} (type = ApplicationException.class, path ="servlet://inputForm.jsp")
})
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
    updateUser(req.getParamMap());
    return new HttpResponse(200, "servlet://updatingCompleted.jsp");
}

この処理は、以下のコードによる処理と本質的に同等である。

public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
    try {
        updateUser(req.getParamMap());
        return new HttpResponse(200, "servlet://updatingCompleted.jsp");
    } catch(OptimisticLockException ole) {
        throw new HttpErrorResponse(400, "servlet://topForm.jsp", ole);
    } catch(ApplicationException ae) {
        throw new HttpErrorResponse(400, "servlet://inputForm.jsp", ae);
    }
}

OnErrorsアノテーションは、OnErrorアノテーションの定義順(上から順)に例外を処理する。
たとえば、上記の例では、OptimisticLockExceptionはApplicationExceptionのサブクラスなので、
必ずApplicationExceptionの上に定義しなければ正常に処理が行われない。
</pre>

**作成者:** Kiyohito Itoh  

---
