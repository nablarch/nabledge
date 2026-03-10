# OnErrorsインターセプタ

## インターセプタクラス名

業務アクションでの例外発生時に、指定したレスポンスを返却するインターセプタ。複数の例外に対してレスポンスを指定できる。

業務アクションのメソッドに `OnErrors` アノテーションを設定することで有効となる。

**クラス**: `nablarch.fw.web.interceptor.OnErrors`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## OnErrorsを使用する

`OnErrors` アノテーションをリクエスト処理メソッドに設定する。各例外に対するレスポンスは `OnError` で指定する。

**アノテーション**: `@OnErrors`, `@OnError`

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

> **重要**: `OnError` の定義順に例外を処理するため、継承関係にある例外を定義する場合は、必ずサブクラスの例外から先に定義すること。
