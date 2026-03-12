# エラー時の遷移先の指定方法

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/forward_error_page.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/NoDataException.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/persistence/OptimisticLockException.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/ApplicationException.html)

## ハンドラで共通の振る舞いを定義する

システム全体で共通のエラーページに遷移させる場合、個別のアクションメソッドに [on_error_interceptor](../../component/handlers/handlers-on_error.md) や [on_errors_interceptor](../../component/handlers/handlers-on_errors.md) を設定すると設定漏れや遷移先の指定ミスが発生しやすい。このような場合は個別のアクションに遷移先を指定するのではなく、エラー時の遷移先を制御するハンドラを追加して対応すること。

例: `NoDataException` と `OptimisticLockException` が発生した場合に専用エラー画面へ遷移させるハンドラ実装:

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

ExampleErrorForwardHandler, HttpErrorResponse, NoDataException, OptimisticLockException, on_error_interceptor, on_errors_interceptor, エラーページ共通化, ハンドラによるエラー遷移制御, システム全体エラー画面統一, 例外ハンドリング

</details>

## 1つの例外クラスに対して複数の遷移先がある場合の実装方法

[on_error_interceptor](../../component/handlers/handlers-on_error.md) は例外クラスに対して1つの遷移先しか指定できないため、`ApplicationException` が発生箇所によって遷移先を切り替えたい場合は、アクションメソッド内で `try-catch` を使って例外を捕捉し `HttpErrorResponse` で遷移先を指定すること。

```java
@InjectForm(form = ClientSearchForm.class, prefix = "form")
@OnError(type = ApplicationException.class, path = "forward://new")
public HttpResponse list(HttpRequest request, ExecutionContext context) {
  // ...
  try {
    service.save(entity);
  } catch (ApplicationException e) {
    // saveで発生した例外は他の箇所とは異なる画面に遷移させる
    throw new HttpErrorResponse("forward://index", e);
  }
  return new HttpResponse("/WEB-INF/view/client/complete.jsp");
}
```

<details>
<summary>keywords</summary>

ApplicationException, HttpErrorResponse, @InjectForm, @OnError, on_error_interceptor, 業務例外, 複数遷移先, try-catch, 遷移先切り替え, forward

</details>
