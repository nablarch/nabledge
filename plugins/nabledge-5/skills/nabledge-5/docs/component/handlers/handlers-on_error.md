# OnErrorインターセプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web_interceptor/on_error.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnError.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpErrorResponse.html)

## インターセプタクラス名

**クラス**: `nablarch.fw.web.interceptor.OnError`

<details>
<summary>keywords</summary>

nablarch.fw.web.interceptor.OnError, OnError, インターセプタクラス名

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

nablarch-fw-web, com.nablarch.framework, モジュール依存関係, Maven依存設定

</details>

## OnErrorを使用する

業務アクションでの例外発生時に指定したレスポンスを返却するインターセプタ。[inject_form_interceptor](handlers-InjectForm.md) よりも前に実行されるように設定することで、バリデーションエラーに対するレスポンスも指定可能。

> **補足**: 複数の例外に対するレスポンスを指定したい場合は [on_errors_interceptor](handlers-on_errors.md) を使用すること。

> **重要**: 単一の例外に対して複数のレスポンスは指定できない。複数のレスポンスを指定したい場合は [on_error-multiple](#s4) を参照。

**アノテーション**: `@OnError`

業務アクションのリクエストを処理するメソッドに設定する。

- `type` 属性: `RuntimeException` およびそのサブクラスを指定可能。指定した例外のサブクラスも処理対象となる。
- `path` 属性: エラー時の遷移先パス。

```java
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/project/index.jsp")
public HttpResponse handle(HttpRequest request, ExecutionContext context) {
    // 業務処理は省略
}
```

<details>
<summary>keywords</summary>

@OnError, ApplicationException, 例外処理, エラーレスポンス, バリデーションエラー対応, インターセプタ設定, type属性, path属性, RuntimeException

</details>

## エラー時の遷移先画面に表示するデータを取得する

エラー時の遷移先画面に表示するデータ（プルダウン選択肢など）をDBから取得したい場合は、内部フォワードを使用する。

- `path` 属性に内部フォワード用パス（`forward://メソッド名`）を設定する。
- フォワード先メソッドで初期表示データを取得してリクエストスコープに設定する。

詳細は [forwarding_handler](handlers-forwarding_handler.md) を参照。

```java
/**
 * 入力値のチェックを行う業務アクションのメソッド。
 */
@InjectForm(form = PersonForm.class, prefix = "form")
@OnError(type = ApplicationException.class, path = "forward://initializeRegisterPage")
public HttpResponse confirmForRegister(HttpRequest request, ExecutionContext context) {
  PersonForm form = context.getRequestScopedVar("form");
  return new HttpResponse("/WEB-INF/view/person/confirmForRegister.jsp");
}

/**
 * 登録画面の初期表示データを取得するメソッド。
 */
public HttpResponse initializeRegisterPage(HttpRequest request, ExecutionContext context) {
  // 画面表示データをデータベースなどから取得し、リクエストスコープに設定する
  return new HttpResponse("/WEB-INF/view/person/inputForRegister.jsp");
}
```

<details>
<summary>keywords</summary>

@InjectForm, @OnError, 内部フォワード, エラー画面データ取得, forward://, リクエストスコープ, 初期表示データ

</details>

## 複数のレスポンスを指定する

本インターセプタでは単一の例外に対して複数のレスポンスは指定できない。複数のレスポンスを指定したい場合は、業務アクションのメソッド内で個別に `HttpErrorResponse` を生成する。

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

HttpErrorResponse, nablarch.fw.web.HttpErrorResponse, 複数レスポンス, 例外ハンドリング, ApplicationException

</details>
