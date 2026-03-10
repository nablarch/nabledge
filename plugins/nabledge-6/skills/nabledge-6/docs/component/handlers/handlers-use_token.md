# UseTokenインターセプタ

## インターセプタクラス名

:ref:`二重サブミット(同一リクエストの二重送信)防止 <tag-double_submission_server_side>` のためのトークンを発行するインターセプタ。主にJSP以外のテンプレートエンジンを採用している場合に使用する。

JSPを使用している場合は :ref:`tag-form_tag` のuseToken属性でトークン生成とhiddenへの埋め込みが行われる。

トークンをチェックするため、後続のアクションに対して :ref:`on_double_submission_interceptor` を設定する必要がある。

**クラス**: `nablarch.common.web.token.UseToken`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-tag</artifactId>
</dependency>
```

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
