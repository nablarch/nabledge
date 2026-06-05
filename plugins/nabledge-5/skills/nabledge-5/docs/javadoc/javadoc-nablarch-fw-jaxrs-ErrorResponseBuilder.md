# class ErrorResponseBuilder

**パッケージ:** nablarch.fw.jaxrs

---

```java
public class ErrorResponseBuilder
```

JAX-RS用のエラーレスポンスを生成するクラス。

例外の種類に応じて以下のレスポンスを生成する。

<pre>
--------------------------------------------- --------------------
例外クラス                                    ステータスコード
--------------------------------------------- --------------------
ApplicationException                          400
上記以外                                      500
--------------------------------------------- --------------------

</pre>

**作成者:** Hisaaki Shioiri  

---

## メソッドの詳細

### build

```java
public HttpResponse build(HttpRequest request, ExecutionContext context, Throwable throwable)
```

エラーレスポンスを生成する。
<p/>
発生したエラーが、{@link ApplicationException}の場合は、{@code 400}を生成する。
それ以外のエラーの場合には、{@code 500}を生成する。

**パラメータ:**
- `request` - {@link HttpRequest}
- `context` - {@link ExecutionContext}
- `throwable` - 発生したエラーの情報

**戻り値:**
エラーレスポンス

---
