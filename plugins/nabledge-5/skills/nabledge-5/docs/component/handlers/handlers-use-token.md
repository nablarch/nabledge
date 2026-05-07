# UseTokenインターセプタ

**目次**

* インターセプタクラス名
* モジュール一覧
* UseTokenを使用する

[二重サブミット(同一リクエストの二重送信)防止](../../component/libraries/libraries-tag.md#tag-double-submission-server-side) のためのトークンを発行するインターセプタ。

このインターセプタが使用されることを想定しているのは、主にJSP以外のテンプレートエンジンを採用している場合である。

JSP以外のテンプレートエンジンでは、このインターセプタの使用に加えてテンプレートでトークンを明示的にhiddenへ埋め込む必要がある。
トークンの埋め込み方は後述する。
なお、JSPを使用している場合は [formタグ](../../component/libraries/libraries-tag-reference.md#tag-form-tag) のuseToken属性でトークン生成とhiddenへの埋め込みが行われる。

トークンをチェックするため後続のアクションに対して
[OnDoubleSubmissionインターセプタ](../../component/handlers/handlers-on-double-submission.md#on-double-submission-interceptor)
を設定する必要がある。

## インターセプタクラス名

* nablarch.common.web.token.UseToken

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-tag</artifactId>
</dependency>
```

## UseTokenを使用する

UseToken アノテーションを、
アクションのメソッドに対して設定する。

```java
@UseToken
public HttpResponse confirm(HttpRequest req, ExecutionContext ctx) {
    // 省略
}
```

また、入力フォームへ明示的にトークンを埋め込む必要がある。

Thymeleafでの実装例

```xml
<form th:action="@{/path/to/action}" method="post">
  <input type="hidden" name="nablarch_token" th:value="${nablarch_request_token}" />
```

この例のようにname属性は"nablarch_token"と設定して、value属性はリクエストスコープから"nablarch_request_token"というキーで取得した値を設定する必要がある。
このname属性とリクエストスコープから値を取得するキーは変更できる。
詳しくは [サーバ側の二重サブミット防止](../../component/libraries/libraries-tag.md#tag-double-submission-server-side) を参照すること。
