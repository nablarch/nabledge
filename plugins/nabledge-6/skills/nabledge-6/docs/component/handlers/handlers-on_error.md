# OnErrorインターセプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web_interceptor/on_error.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnError.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpErrorResponse.html)

## インターセプタクラス名

業務アクションでの例外発生時に、指定したレスポンスを返却するインターセプタ。[inject_form_interceptor](handlers-InjectForm.md) と組み合わせる場合、このインターセプタを [inject_form_interceptor](handlers-InjectForm.md) より前に実行されるよう設定することで、バリデーションエラーに対するレスポンスを指定できる。

業務アクションのメソッドに対して `OnError` アノテーションを設定することで有効となる。

> **補足**: 複数の例外に対するレスポンスを指定したい場合は、[on_errors_interceptor](handlers-on_errors.md) を使用すること。

> **重要**: 単一の例外に対して複数のレスポンスは指定できない。複数のレスポンスを指定したい場合は、[on_error-multiple](#s4) を参照。

**クラス**: `nablarch.fw.web.interceptor.OnError`

<details>
<summary>keywords</summary>

OnError, nablarch.fw.web.interceptor.OnError, OnErrorインターセプタ, 例外処理, バリデーションエラー対応, インターセプタ設定

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, com.nablarch.framework, モジュール依存関係, Maven依存性

</details>

## OnErrorを使用する

`OnError` アノテーションを、業務アクションのリクエストを処理するメソッドに設定する。

- `type`属性には `RuntimeException` 及びそのサブクラスを指定できる。
- `type`属性に指定した例外のサブクラスも処理の対象となる。

```java
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/project/index.jsp")
public HttpResponse handle(HttpRequest request, ExecutionContext context) {
    // 業務処理は省略
}
```

<details>
<summary>keywords</summary>

@OnError, ApplicationException, RuntimeException, type属性, path属性, アクションメソッド設定, HTTPレスポンス制御, HttpResponse

</details>

## エラー時の遷移先画面に表示するデータを取得する

エラー時の遷移先画面に表示するデータをDBなどから取得したい場合は、表示データを取得する業務アクションのメソッドに対して内部フォワードを行い、初期表示用のデータをリクエストスコープに設定する。

- `path`属性に内部フォワード用のパス（`forward://メソッド名`）を設定する。

```java
@InjectForm(form = PersonForm.class, prefix = "form")
@OnError(type = ApplicationException.class, path = "forward://initializeRegisterPage")
public HttpResponse confirmForRegister(HttpRequest request, ExecutionContext context) {
  PersonForm form = context.getRequestScopedVar("form");
  return new HttpResponse("/WEB-INF/view/person/confirmForRegister.jsp");
}

public HttpResponse initializeRegisterPage(HttpRequest request, ExecutionContext context) {
  // 画面表示データをデータベースなどから取得し、リクエストスコープに設定する
  return new HttpResponse("/WEB-INF/view/person/inputForRegister.jsp");
}
```

<details>
<summary>keywords</summary>

内部フォワード, forward://, リクエストスコープ, エラー時データ取得, @InjectForm, @OnError, HttpResponse

</details>

## 複数のレスポンスを指定する

単一の例外に対して複数のレスポンスは指定できないため、業務アクションのメソッド内に個別に `HttpErrorResponse` を生成する必要がある。

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context) {
    try {
        // 業務処理は省略
    } catch (ApplicationException e) {
        if (/* 条件式を記述 */) {
            return new HttpErrorResponse("/WEB-INF/view/project/index.jsp");
        } else {
            return new HttpErrorResponse("/WEB-INF/view/error.jsp");
        }
    }
}
```

<details>
<summary>keywords</summary>

HttpErrorResponse, 複数レスポンス, 条件分岐, ApplicationException, nablarch.fw.web.HttpErrorResponse

</details>
