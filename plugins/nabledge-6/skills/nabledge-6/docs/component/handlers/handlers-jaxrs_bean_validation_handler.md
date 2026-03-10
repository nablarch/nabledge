# Jakarta RESTful Web Servcies Bean Validationハンドラ

## ハンドラクラス名

> **補足**: Nablarch5までは「JAX-RS BeanValidationハンドラ」という名称だった。名称のみ変更され、機能的な差はない。

リソース(アクション)クラスが受け取るForm(Bean)に対して :ref:`bean_validation` を実行するハンドラ。バリデーションエラー発生時は後続ハンドラへ処理を委譲せず、`ApplicationException` を送出する。

**クラス名**: `nablarch.fw.jaxrs.JaxRsBeanValidationHandler`

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

## 制約

:ref:`body_convert_handler` よりも後ろに設定すること。このハンドラは :ref:`body_convert_handler` がリクエストボディから変換したForm(Bean)に対してバリデーションを行うため。

## リソース(アクション)で受け取るForm(Bean)に対してバリデーションを実行する

バリデーション対象のForm(Bean)を受け取るメソッドに `Valid` アノテーションを設定する。

```java
@POST
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public HttpResponse save(Person person) {
    UniversalDao.insert(person);
    return new HttpResponse();
}
```

## Bean Validationのグループを指定する

`Valid` アノテーションを設定したメソッドに `ConvertGroup` アノテーションを設定することで、Bean Validationのグループを指定できる。`ConvertGroup` の `from` 属性と `to` 属性の指定は必須。

- `from` 属性: `Default.class` 固定（`Valid` アノテーション設定時はDefaultグループとして実行されるため）
- `to` 属性: 使用するBean Validationグループを指定する

```java
@POST
@Consumes(MediaType.APPLICATION_JSON)
@Valid
@ConvertGroup(from = Default.class, to = Create.class)
public HttpResponse save(Person person) {
    UniversalDao.insert(person);
    return new HttpResponse();
}
```
