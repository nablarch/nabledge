# UseTokenインターセプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web_interceptor/use_token.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/UseToken.html)

## インターセプタクラス名

:ref:`二重サブミット(同一リクエストの二重送信)防止 <tag-double_submission_server_side>` のためのトークンを発行するインターセプタ。主にJSP以外のテンプレートエンジンを採用している場合に使用する。

JSPを使用している場合は [tag-form_tag](../libraries/libraries-tag_reference.md) のuseToken属性でトークン生成とhiddenへの埋め込みが行われる。

トークンをチェックするため、後続のアクションに対して [on_double_submission_interceptor](handlers-on_double_submission.md) を設定する必要がある。

**クラス**: `nablarch.common.web.token.UseToken`

<details>
<summary>keywords</summary>

UseToken, nablarch.common.web.token.UseToken, 二重サブミット防止, トークン発行, JSP以外のテンプレートエンジン, on_double_submission_interceptor

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-tag</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web-tag, com.nablarch.framework, Mavenモジュール

</details>

## UseTokenを使用する

**アノテーション**: `@UseToken`

アクションのメソッドに `@UseToken` アノテーションを設定する。

```java
@UseToken
public HttpResponse confirm(HttpRequest req, ExecutionContext ctx) {
    // 省略
}
```

入力フォームへ明示的にトークンを埋め込む必要がある。Thymeleafでの実装例:

```xml
<form th:action="@{/path/to/action}" method="post">
  <input type="hidden" name="nablarch_token" th:value="${nablarch_request_token}" />
```

`name` 属性は `"nablarch_token"` と設定し、`value` 属性はリクエストスコープのキー `"nablarch_request_token"` から取得した値を設定する必要がある。このname属性とリクエストスコープから値を取得するキーは変更可能。詳しくは :ref:`サーバ側の二重サブミット防止 <tag-double_submission_server_side>` を参照。

<details>
<summary>keywords</summary>

@UseToken, nablarch_token, nablarch_request_token, Thymeleaf, hiddenフィールド, トークン埋め込み, 二重サブミット防止

</details>
