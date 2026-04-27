# OnErrorsインターセプタ

**目次**

* インターセプタクラス名
* モジュール一覧
* OnErrorsを使用する

業務アクションでの例外発生時に、指定したレスポンスを返却するインターセプタ。
複数の例外に対してレスポンスを指定できる。

このインターセプタは、業務アクションのメソッドに対して、 OnErrors を設定することで有効となる。

## インターセプタクラス名

* nablarch.fw.web.interceptor.OnErrors

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## OnErrorsを使用する

OnErrors アノテーションを、
業務アクションのリクエストを処理するメソッドに対して設定する。

それぞれの例外に対するレスポンスの指定は、 OnError を使用して行う。

業務アクションのメソッド内で以下の例外を送出する場合の実装例を示す。

* ApplicationException (業務エラー)
* AuthenticationException (認証エラー)
* UserLockedException (アカウントロックエラー。 AuthenticationException のサブクラス)

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

> **Important:**
> OnError の定義順に例外を処理するため、
> 継承関係にある例外を定義する場合は、必ずサブクラスの例外から先に定義すること。
