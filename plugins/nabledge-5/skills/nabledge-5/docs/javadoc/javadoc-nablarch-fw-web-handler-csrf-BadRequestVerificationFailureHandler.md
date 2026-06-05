# class BadRequestVerificationFailureHandler

**パッケージ:** nablarch.fw.web.handler.csrf

**実装されたインタフェース:**
- VerificationFailureHandler

---

```java
public class BadRequestVerificationFailureHandler
implements VerificationFailureHandler
```

CSRFトークンの検証失敗時にBadRequest(400)のレスポンスを返すクラス。

INFOレベルで検証失敗時のログを出力する。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### LOGGER

```java
private static Logger LOGGER
```

ロガー

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context, String userSentToken, String sessionAssociatedToken)
```

---
