# OnErrorsインターセプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web_interceptor/on_errors.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnErrors.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnError.html)

## インターセプタクラス名

業務アクションでの例外発生時に指定したレスポンスを返却するインターセプタ。複数の例外に対してレスポンスを指定できる。

**クラス**: `nablarch.fw.web.interceptor.OnErrors`

<details>
<summary>keywords</summary>

OnErrors, nablarch.fw.web.interceptor.OnErrors, インターセプタ, 例外レスポンス返却

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

nablarch-fw-web, com.nablarch.framework, モジュール依存関係

</details>

## OnErrorsを使用する

業務アクションのリクエストを処理するメソッドに `@OnErrors` アノテーションを設定する。各例外に対するレスポンスの指定は `@OnError` を使用する。

業務アクションのメソッド内で以下の例外を送出する場合の実装例を示す。

- `ApplicationException` (業務エラー)
- `AuthenticationException` (認証エラー)
- `UserLockedException` (アカウントロックエラー。`AuthenticationException` のサブクラス)

```java
@OnErrors({
        @OnError(type = UserLockedException.class, path = "/WEB-INF/view/login/locked.jsp"),
        @OnError(type = AuthenticationException.class, path = "/WEB-INF/view/login/index.jsp"),
        @OnError(type = ApplicationException.class, path = "/WEB-INF/view/login/index.jsp")
})
public HttpResponse handle(HttpRequest request, ExecutionContext context) {
    // 業務処理は省略
}
```

> **重要**: `@OnError` の定義順に例外を処理するため、継承関係にある例外を定義する場合は、必ずサブクラスの例外から先に定義すること。

<details>
<summary>keywords</summary>

@OnErrors, @OnError, UserLockedException, AuthenticationException, ApplicationException, 例外ハンドリング, エラーレスポンス設定, サブクラス優先定義

</details>
