# UseTokenインターセプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web_interceptor/use_token.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/UseToken.html)

## インターセプタクラス名

:ref:`二重サブミット(同一リクエストの二重送信)防止 <tag-double_submission_server_side>` のためのトークンを発行するインターセプタ。

- JSP以外のテンプレートエンジン使用時に使用する
- JSP以外では、テンプレートでトークンをhiddenへ明示的に埋め込む必要がある
- トークンをチェックするため後続アクションに [on_double_submission_interceptor](handlers-on_double_submission.md) を設定する必要がある
- JSP使用時は [tag-form_tag](../libraries/libraries-tag_reference.md) のuseToken属性でトークン生成とhiddenへの埋め込みが行われる

**クラス名**: `nablarch.common.web.token.UseToken`

<details>
<summary>keywords</summary>

nablarch.common.web.token.UseToken, UseToken, 二重サブミット防止, トークン発行, JSP以外のテンプレートエンジン, on_double_submission_interceptor

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

nablarch-fw-web-tag, com.nablarch.framework, モジュール依存関係

</details>

## UseTokenを使用する

`UseToken` アノテーションをアクションのメソッドに設定する。

```java
@UseToken
public HttpResponse confirm(HttpRequest req, ExecutionContext ctx) {
    // 省略
}
```

入力フォームへ明示的にトークンを埋め込む必要がある。

Thymeleafでの実装例:
```xml
<form th:action="@{/path/to/action}" method="post">
  <input type="hidden" name="nablarch_token" th:value="${nablarch_request_token}" />
```

- `name`属性は`"nablarch_token"`を設定し、`value`属性はリクエストスコープのキー`"nablarch_request_token"`から取得した値を設定する
- このname属性とリクエストスコープから値を取得するキーは変更可能（詳細は :ref:`tag-double_submission_server_side` 参照）

<details>
<summary>keywords</summary>

@UseToken, nablarch_token, nablarch_request_token, Thymeleaf, hidden埋め込み, トークン埋め込み, UseToken

</details>
