# interface VerificationFailureHandler

**パッケージ:** nablarch.fw.web.handler.csrf

---

```java
public interface VerificationFailureHandler
```

CSRFトークンの検証失敗時の処理を行うインタフェース。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### handle

```java
HttpResponse handle(HttpRequest request, ExecutionContext context, String userSentToken, String sessionAssociatedToken)
```

CSRFトークンの検証失敗時の処理を行う。

**パラメータ:**
- `request` - HTTPリクエスト
- `context` - 実行コンテキスト
- `userSentToken` - ユーザーが送信したトークン
- `sessionAssociatedToken` - セッションに格納されたトークン

**戻り値:**
HTTPレスポンス

---
