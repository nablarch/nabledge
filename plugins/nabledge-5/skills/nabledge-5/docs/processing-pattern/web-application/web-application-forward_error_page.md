# エラー時の遷移先の指定方法

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/forward_error_page.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/NoDataException.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/persistence/OptimisticLockException.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/ApplicationException.html)

## ハンドラで共通の振る舞いを定義する

システム全体で共通のエラーページに遷移させる場合、個別のアクションメソッドへのアノテーション指定（[on_error_interceptor](../../component/handlers/handlers-on_error.md)、[on_errors_interceptor](../../component/handlers/handlers-on_errors.md)）ではなく、エラー時の遷移先を制御するハンドラを追加することを推奨する。理由：個別指定では漏れや指定ミスが生じやすく、全機能の検証コストが非常に高くなるため。

実装例（`NoDataException` → 404、`OptimisticLockException` → 400）:

```java
public class ExampleErrorForwardHandler implements Handler<Object, Object> {

    @Override
    public Object handle(Object data, ExecutionContext context) {
        try {
            return context.handleNext(data);
        } catch (NoDataException e) {
            throw new HttpErrorResponse(
                404, "/WEB-INF/view/common/errorPages/pageNotFoundError.jsp", e);
        } catch (OptimisticLockException e) {
            throw new HttpErrorResponse(
                400, "/WEB-INF/view/common/errorPages/optimisticLockError.jsp", e);
        }
    }
}
```

<details>
<summary>keywords</summary>

ExampleErrorForwardHandler, NoDataException, OptimisticLockException, HttpErrorResponse, Handler, ExecutionContext, エラーハンドラ, エラーページ遷移, 共通エラー処理, ハンドラ設定

</details>

## 1つの例外クラスに対して複数の遷移先がある場合の実装方法

[on_error_interceptor](../../component/handlers/handlers-on_error.md) では1つの例外クラスに対して1つの遷移先しか指定できない。`ApplicationException` が発生した箇所によって遷移先を切り替えたい場合は、アクションメソッド内で `try-catch` を使い、`HttpErrorResponse` に遷移先を指定してスローする。

```java
@InjectForm(form = ClientSearchForm.class, prefix = "form")
@OnError(type = ApplicationException.class, path = "forward://new")
public HttpResponse list(HttpRequest request, ExecutionContext context) {
    // 省略
    try {
        service.save(entity);
    } catch (ApplicationException e) {
        // saveで発生したApplicationExceptionは他の箇所と異なる画面に遷移
        throw new HttpErrorResponse("forward://index", e);
    }
    return new HttpResponse("/WEB-INF/view/client/complete.jsp");
}
```

<details>
<summary>keywords</summary>

ApplicationException, HttpErrorResponse, HttpResponse, HttpRequest, ExecutionContext, ClientSearchForm, @InjectForm, @OnError, 複数遷移先, try-catch, on_error_interceptor制限, 例外処理

</details>
