# class HttpMessagingErrorHandler

**パッケージ:** nablarch.fw.messaging.handler

**継承階層:**
```
java.lang.Object
  └─ HttpErrorHandler
      └─ nablarch.fw.messaging.handler.HttpMessagingErrorHandler
```

---

```java
public class HttpMessagingErrorHandler
extends HttpErrorHandler
```

HTTPメッセージングサービスにおけるエラー制御を透過的に実装するハンドラー。

このハンドラーでは、後続の各ハンドラーで発生した実行時例外およびおよびエラーを捕捉し、
その内容に基づいてログ出力を行ったのち、HttpErrorResponseオブジェクトとしてリターンする。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest req, ExecutionContext ctx)
```

---

### handleError

```java
protected HttpResponse handleError(Throwable e, HttpRequest req, ExecutionContext ctx)
```

発生した例外に応じたログ出力処理を行う。

**パラメータ:**
- `e` - 発生した例外
- `req` - HTTPリクエスト
- `ctx` - 実行時コンテキスト

**戻り値:**
HTTPレスポンス

---
