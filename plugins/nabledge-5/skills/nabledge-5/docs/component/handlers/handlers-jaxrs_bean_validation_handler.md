# JAX-RS BeanValidationハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/rest/jaxrs_bean_validation_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/ApplicationException.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/validation/Valid.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/javax/validation/groups/ConvertGroup.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/javax/validation/groups/Default.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.jaxrs.JaxRsBeanValidationHandler`

<details>
<summary>keywords</summary>

JaxRsBeanValidationHandler, nablarch.fw.jaxrs.JaxRsBeanValidationHandler, ハンドラクラス名, JAX-RS BeanValidationハンドラ

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-jaxrs</artifactId>
</dependency>

<!-- Bean Validationのモジュール -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-validation-ee</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-jaxrs, nablarch-core-validation-ee, Maven依存, モジュール, BeanValidation

</details>

## 制約

[body_convert_handler](handlers-body_convert_handler.md) よりも後ろに設定すること。本ハンドラは [body_convert_handler](handlers-body_convert_handler.md) がリクエストボディから変換したForm(Bean)に対してバリデーションを行うため。

<details>
<summary>keywords</summary>

body_convert_handler, ハンドラ順序, 制約, 設定順序

</details>

## リソース(アクション)で受け取るForm(Bean)に対してバリデーションを実行する

リソース(アクション)のメソッドで受け取るForm(Bean)に対してバリデーションを実行するには、そのメソッドに `Valid` アノテーションを設定する。

バリデーションエラーが発生した場合、後続ハンドラへ処理は委譲されず `ApplicationException` が送出される。

```java
// Personオブジェクトに対してバリデーションを実行したいので、
// Validアノテーションを設定する。
@POST
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public HttpResponse save(Person person) {
    UniversalDao.insert(person);
    return new HttpResponse();
}
```

<details>
<summary>keywords</summary>

@Valid, Valid, ApplicationException, BeanValidation実行, フォームバリデーション, リソースメソッド, バリデーションエラー

</details>

## Bean Validationのグループを指定する

`Valid` アノテーションを設定したメソッドに `ConvertGroup` アノテーションを設定することで、Bean Validationのグループを指定できる。

`from` と `to` の指定が必須:
- `from`: `Default.class` 固定（`@Valid` アノテーション設定時、バリデーションは `Default` グループとして実行されるため）
- `to`: 使用するBean Validationのグループを指定

```java
// Personクラス内で設定されたバリデーションルールのうち、
// Createグループに所属するルールのみを使用して検証する。
@POST
@Consumes(MediaType.APPLICATION_JSON)
@Valid
@ConvertGroup(from = Default.class, to = Create.class)
public HttpResponse save(Person person) {
    UniversalDao.insert(person);
    return new HttpResponse();
}
```

<details>
<summary>keywords</summary>

@ConvertGroup, ConvertGroup, Default, BeanValidationグループ, グループ指定, from, to

</details>
