# InjectForm インターセプタ

**目次**

* インターセプタクラス名
* モジュール一覧
* InjectFormを使用する
* バリデーションエラー時の遷移先を指定する
* Bean Validationのグループを指定する

入力値に対するバリデーションを行い、生成したフォームオブジェクトをリクエストスコープに設定するインターセプタ。

このインターセプタは、業務アクションのメソッドに対して、 InjectForm を設定することで有効となる。

## インターセプタクラス名

* nablarch.common.web.interceptor.InjectForm

## モジュール一覧

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

## InjectFormを使用する

InjectForm アノテーションを、業務アクションのリクエストを処理するメソッドに対して設定する。

以下に実装例を示す。

入力画面のhtml例

```html
<!-- バリデーション対象外-->
<input name="flag" type="hidden" />

<!-- バリデーション対象 -->
<input name="form.userId" type="text" />
<input name="form.password" type="password" />
```

業務アクションの例

この例では、画面から送信された `form` から始まるリクエストパラメータに対してバリデーションが実行される。
バリデーションでエラーが発生しなかった場合は、リクエストスコープに InjectForm#form で指定したクラスのオブジェクトが格納される。

リクエストスコープにバリデーション済みのフォームを格納する際に使用する変数名は、 InjectForm#name に指定する。
指定しなかった場合は、 `form` という変数名でフォームが格納される。

業務アクションが実行された場合には、必ずリクエストスコープからオブジェクトが取得できる。

```java
@InjectForm(form = UserForm.class, prefix = "form", validate = "register")
@OnError(type = ApplicationException.class, path = "forward://registerForm.jsp")
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {

  // リクエストスコープからバリデーション済みのフォームを取得する。
  UserForm form = ctx.getRequestScopedVar("form");

  // formを元に業務処理を行う。
}
```

> **Tip:**
> バリデーションに [Bean Validation](../../component/libraries/libraries-bean-validation.md#bean-validation) を使用する場合、バリデーションエラー時にもリクエストスコープから
> オブジェクトを取得可能となるよう設定ができる。詳細は『 [バリデーションエラー時にもリクエストパラメータをリクエストスコープから取得したい](../../component/libraries/libraries-bean-validation.md#bean-validation-onerror) 』を参照。

## バリデーションエラー時の遷移先を指定する

バリデーションエラー発生時の遷移先画面は、 OnError アノテーションを使用して設定する。

OnError アノテーションは、InjectForm を設定した業務アクションのメソッドに対して設定する。
OnError が設定されていない場合、バリデーションエラーがシステムエラー扱いとなるため注意すること。

バリデーションエラー発生時に、遷移先画面で表示するデータを取得したい場合は、[エラー時の遷移先画面に表示するデータを取得する](../../component/handlers/handlers-on-error.md#on-error-forward) を参照。

## Bean Validationのグループを指定する

バリデーションに [Bean Validation](../../component/libraries/libraries-bean-validation.md#bean-validation) を使用する場合は、 InjectForm#validationGroup にグループを指定することができる。

以下に実装例を示す。

```java
// UserFormクラス内で設定されたバリデーションルールのうち、Createグループに所属するルールのみを使用して検証する。
@InjectForm(form = UserForm.class, prefix = "form", validationGroup = Create.class)
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {

  // リクエストスコープからバリデーション済みのフォームを取得する。
  UserForm form = ctx.getRequestScopedVar("form");

  // formを元に業務処理を行う。
}
```
