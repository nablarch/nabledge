# InjectForm インターセプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web_interceptor/InjectForm.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/interceptor/InjectForm.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnError.html)

## インターセプタクラス名

**クラス**: `nablarch.common.web.interceptor.InjectForm`

<details>
<summary>keywords</summary>

InjectForm, nablarch.common.web.interceptor.InjectForm, インターセプタクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>

<!-- 入力値チェックにBeanValidationを使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-validation-ee</artifactId>
</dependency>

<!-- 入力値チェックにNablarchValidationを使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-validation</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, nablarch-core-validation-ee, nablarch-core-validation, BeanValidation, NablarchValidation, モジュール依存関係

</details>

## InjectFormを使用する

業務アクションのリクエスト処理メソッドに `InjectForm` アノテーションを設定することで有効になる。

- `prefix` で指定したプレフィックスから始まるリクエストパラメータに対してバリデーションが実行される
- バリデーション成功時、リクエストスコープに `InjectForm#form` で指定したクラスのオブジェクトが格納される
- リクエストスコープの変数名は `InjectForm#name` で指定。未指定の場合は `form` となる
- 業務アクションが実行された場合には、必ずリクエストスコープからオブジェクトが取得できる

**入力画面のhtml例**:

```html
<!-- バリデーション対象外 -->
<input name="flag" type="hidden" />

<!-- バリデーション対象 -->
<input name="form.userId" type="text" />
<input name="form.password" type="password" />
```

**業務アクションの例**:

```java
@InjectForm(form = UserForm.class, prefix = "form", validate = "register")
@OnError(type = ApplicationException.class, path = "forward://registerForm.jsp")
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
  UserForm form = ctx.getRequestScopedVar("form");
  // formを元に業務処理を行う。
}
```

> **補足**: :ref:`bean_validation` を使用する場合、バリデーションエラー時にもリクエストスコープからオブジェクトを取得可能となるよう設定できる。詳細は :ref:`bean_validation_onerror` を参照。

<details>
<summary>keywords</summary>

@InjectForm, @OnError, InjectForm#form, InjectForm#name, InjectForm#prefix, UserForm, バリデーション, リクエストスコープ, フォームオブジェクト, 入力値チェック, ApplicationException, バリデーション対象外, プレフィックス, form.userId, form.password, validate

</details>

## バリデーションエラー時の遷移先を指定する

バリデーションエラー発生時の遷移先は `OnError` アノテーションで指定する。`InjectForm` を設定した業務アクションのメソッドに対して設定する。

> **重要**: `OnError` が設定されていない場合、バリデーションエラーがシステムエラー扱いとなる。

バリデーションエラー発生時に遷移先画面で表示するデータを取得したい場合は、:ref:`on_error-forward` を参照。

<details>
<summary>keywords</summary>

@OnError, OnError, nablarch.fw.web.interceptor.OnError, ApplicationException, バリデーションエラー, 遷移先, システムエラー

</details>

## Bean Validationのグループを指定する

:ref:`bean_validation` を使用する場合、`InjectForm#validationGroup` にグループを指定できる。

```java
// UserFormクラス内で設定されたバリデーションルールのうち、Createグループに所属するルールのみを使用して検証する。
@InjectForm(form = UserForm.class, prefix = "form", validationGroup = Create.class)
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
  UserForm form = ctx.getRequestScopedVar("form");
}
```

<details>
<summary>keywords</summary>

@InjectForm, InjectForm#validationGroup, nablarch.common.web.interceptor.InjectForm, Bean Validationグループ, validationGroup, バリデーショングループ指定

</details>
