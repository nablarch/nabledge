# InjectForm インターセプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web_interceptor/InjectForm.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/interceptor/InjectForm.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnError.html)

## インターセプタクラス名

**クラス**: `nablarch.common.web.interceptor.InjectForm`

<details>
<summary>keywords</summary>

nablarch.common.web.interceptor.InjectForm, InjectForm, インターセプタクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

入力値チェックにBeanValidationを使用する場合のみ:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-validation-ee</artifactId>
</dependency>
```

入力値チェックにNablarchValidationを使用する場合のみ:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-validation</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, nablarch-core-validation-ee, nablarch-core-validation, Maven依存関係, モジュール設定

</details>

## InjectFormを使用する

`InjectForm` アノテーションを業務アクションのリクエスト処理メソッドに設定する。

- `prefix` で指定したプレフィックスで始まるリクエストパラメータがバリデーション対象となる。
- バリデーション成功時、`InjectForm#form` で指定したクラスのオブジェクトがリクエストスコープに格納される。
- リクエストスコープの変数名は `InjectForm#name` で指定。未指定時は `"form"` 。
- 業務アクションが実行された場合、必ずリクエストスコープからオブジェクトが取得できる。

入力画面のHTML例:
```html
<!-- バリデーション対象外 -->
<input name="flag" type="hidden" />

<!-- バリデーション対象 -->
<input name="form.userId" type="text" />
<input name="form.password" type="password" />
```

`form` プレフィックスを持つフィールド（`form.userId`、`form.password`）はバリデーション対象となり、プレフィックスを持たないフィールド（`flag`）はバリデーション対象外となる。

業務アクションの例:
```java
@InjectForm(form = UserForm.class, prefix = "form", validate = "register")
@OnError(type = ApplicationException.class, path = "forward://registerForm.jsp")
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
  UserForm form = ctx.getRequestScopedVar("form");
}
```

> **補足**: バリデーションに [bean_validation](../libraries/libraries-bean_validation.md) を使用する場合、バリデーションエラー時にもリクエストスコープからオブジェクトを取得可能となるよう設定できる。詳細は [bean_validation_onerror](../libraries/libraries-bean_validation.md) を参照。

<details>
<summary>keywords</summary>

@InjectForm, InjectForm, InjectForm#form, InjectForm#name, InjectForm#prefix, InjectForm#validate, バリデーション, リクエストスコープ, フォームオブジェクト

</details>

## バリデーションエラー時の遷移先を指定する

バリデーションエラー発生時の遷移先は `OnError` アノテーションで設定する。`InjectForm` を設定した業務アクションのメソッドに対して設定する。

> **警告**: `OnError` が設定されていない場合、バリデーションエラーがシステムエラー扱いとなる。

バリデーションエラー発生時に遷移先画面で表示するデータを取得したい場合は、[on_error-forward](handlers-on_error.md) を参照。

<details>
<summary>keywords</summary>

@OnError, OnError, ApplicationException, バリデーションエラー遷移先, システムエラー

</details>

## Bean Validationのグループを指定する

バリデーションに [bean_validation](../libraries/libraries-bean_validation.md) を使用する場合、`InjectForm#validationGroup` にグループを指定できる。指定したグループに所属するバリデーションルールのみが適用される。

```java
// UserFormクラス内で設定されたバリデーションルールのうち、Createグループに所属するルールのみを使用して検証する。
@InjectForm(form = UserForm.class, prefix = "form", validationGroup = Create.class)
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
  UserForm form = ctx.getRequestScopedVar("form");
}
```

<details>
<summary>keywords</summary>

InjectForm#validationGroup, @InjectForm, Bean Validationグループ, バリデーショングループ

</details>
