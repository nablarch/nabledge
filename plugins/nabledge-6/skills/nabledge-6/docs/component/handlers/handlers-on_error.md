# OnErrorインターセプタ

## インターセプタクラス名

業務アクションでの例外発生時に、指定したレスポンスを返却するインターセプタ。:ref:`inject_form_interceptor` と組み合わせる場合、このインターセプタを :ref:`inject_form_interceptor` より前に実行されるよう設定することで、バリデーションエラーに対するレスポンスを指定できる。

業務アクションのメソッドに対して `OnError` アノテーションを設定することで有効となる。

> **補足**: 複数の例外に対するレスポンスを指定したい場合は、:ref:`on_errors_interceptor` を使用すること。

> **重要**: 単一の例外に対して複数のレスポンスは指定できない。複数のレスポンスを指定したい場合は、:ref:`on_error-multiple` を参照。

**クラス**: `nablarch.fw.web.interceptor.OnError`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

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
