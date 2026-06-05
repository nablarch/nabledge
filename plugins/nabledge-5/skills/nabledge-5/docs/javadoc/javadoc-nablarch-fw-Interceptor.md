# @interface Interceptor

**パッケージ:** nablarch.fw

---

```java
public @interface Interceptor
```

{@link Handler#handle(Object, ExecutionContext)}メソッドに対するインターセプタに付与する
メタアノテーション。
<p/>
インターセプタを作成するには、このメタアノテーションを付与したアノテーションを作成し、
{@link Interceptor}の属性には、インターセプト処理を実装するクラスを指定する。
この実装クラスは、{@link Interceptor.Impl} を継承して作成する。
<p/>
以下は、インターセプタ"@AroundAdvice"の実装例である。

<pre>
{@code @Target}(ElementType.METHOD)
{@code @Retention}(RetentionPolicy.RUNTIME)
{@code @Interceptor}(AroundAdvice.Impl.class)
public {@code @interface} AroundAdvice {
    public static class Impl extends Interceptor.Impl<HttpRequest, HttpResponse, AroundAdvice> {
        public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
            doBeforeAdvice(req, ctx);
            HttpResponse res =  getOriginalHandler().handle(req, ctx);
            doAfterAdvice(req, ctx);
            return res;
        }
        void doBeforeAdvice(HttpRequest req, ExecutionContext ctx) {
            //......
        }
        void doAfterAdvice(HttpRequest req, ExecutionContext ctx) {
            //......
       }
    }
}
</pre>

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---
