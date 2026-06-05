# @interface InjectForm

**パッケージ:** nablarch.common.web.interceptor

---

```java
public @interface InjectForm
```

フォームをリクエストスコープに設定する{@link Interceptor}。
<p>
本インターセプタでは次の２つの機能を提供する。
<ul>
  <li>
    <a href="#processDetail">バリデーションや初期化処理を行ったフォームをリクエストスコープに設定する</a>
  </li>
  <li>
    <a href="#validationStrategy">指定されたバリデーションエンジンでバリデーションを行う</a>
  </li>
</ul>

<h3 id="processDetail">バリデーションや初期化処理を行ったフォームをリクエストスコープに設定する</h3>
本インターセプタは業務アクションハンドラに次のように実装する。<br>
<pre>
    {@code @InjectForm(form = UserForm.class, prefix = "form", validate = "register")}
    {@code @OnError(type = ApplicationException.class, path = "forward://registerForm.html")
    public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {

        UserForm form = ctx.getRequestScopedVar("form");

        // 以下、省略
    }}
</pre>
上記のような{@code @InjectForm}アノテーションが指定されたメソッドは、
メソッド実行前に以下の処理順でフォームが生成され、リクエストスコープに設定される。
<ol>
  <li>
    指定のvalidationStrategyに従って、バリデーションを実行し、フォームを生成する。
    <ul>
      <li>
        バリデーションエラーが発生した場合は{@link nablarch.core.message.ApplicationException}を送出する。
      </li>
    </ul>
  </li>
  <li>
    {@link InjectForm#initialize}属性が指定されていれば、初期化処理を実行する。
  </li>
  <ol>
    <li>
      デフォルトコンストラクタでフォームを生成する。
    </li>
    <li>
      指定の初期化メソッドを実行する。
    </li>
    <li>
      バリデーションを実行して生成したフォームから初期化したフォームへ値をコピーする。
    </li>
  </ol>
  <li>
    生成したフォームを{@link InjectForm#name}属性の名前でリクエストスコープに設定する。
  </li>
</ol>

<h3 id="validationStrategy">指定されたバリデーションエンジンでバリデーションを行う</h3>
validationStrategyという名前でコンポーネントを定義することでバリデーションエンジンを指定できる。<br>
<pre>
    {@code //指定例 (Bean Validation)
    <component name="validationStrategy"
               class="nablarch.core.validation.ee.BeanValidationStrategy" />}
</pre>
デフォルトでは{@link NablarchValidationStrategy}が使用される。
</p>

**作成者:** kawasima  
**作成者:** Kiyohito Itoh  

---
