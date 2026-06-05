# class CsrfTokenVerificationHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class CsrfTokenVerificationHandler
implements HttpRequestHandler
```

CSRFトークンの検証を行うハンドラ。

<p>
本ハンドラの処理は次の順番で行われる。
</p>

<ol>
<li>セッションストアからCSRFトークンを取得する</li>
<li>取得できなかった場合はCSRFトークンを生成してセッションストアへ保存する</li>
<li>HTTPリクエストが検証対象かどうかを判定する</li>
<li>検証対象の場合はHTTPリクエストヘッダ、またはHTTPリクエストパラメータからCSRFトークンを取得して検証を行う</li>
<li>検証に失敗した場合はBadRequest(400)のレスポンスを返す</li>
<li>検証に成功した場合は次のハンドラへ処理を移す</li>
</ol>

**作成者:** Uragami Taichi  

---

## フィールドの詳細

### REQUEST_REGENERATE_KEY

```java
public static final String REQUEST_REGENERATE_KEY
```

CSRFトークン再生成の要求を表す値をリクエストスコープに設定する際に使用するキー

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### csrfTokenGenerator

```java
private CsrfTokenGenerator csrfTokenGenerator
```

CSRFトークンの生成を行うインターフェース

---

### verificationTargetMatcher

```java
private VerificationTargetMatcher verificationTargetMatcher
```

HTTPリクエストがCSRFトークンの検証対象となるか判定を行うインターフェース

---

### verificationFailureHandler

```java
private VerificationFailureHandler verificationFailureHandler
```

CSRFトークンの検証失敗時の処理を行うインタフェース

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

---

### isTargetOfVerification

```java
private boolean isTargetOfVerification(HttpRequest request)
```

---

### verifyToken

```java
private boolean verifyToken(String userSentToken, String sessionAssociatedToken)
```

---

### getUserSentToken

```java
private String getUserSentToken(HttpRequest request)
```

---

### getSessionAssociatedToken

```java
private String getSessionAssociatedToken(ExecutionContext context)
```

---

### generateAndSaveToken

```java
private String generateAndSaveToken(ExecutionContext context)
```

---

### setCsrfTokenGenerator

```java
public void setCsrfTokenGenerator(CsrfTokenGenerator csrfTokenGenerator)
```

CSRFトークンの生成を行うインターフェースを設定する。

**パラメータ:**
- `csrfTokenGenerator` - CSRFトークンの生成を行うインターフェース

---

### setVerificationTargetMatcher

```java
public void setVerificationTargetMatcher(VerificationTargetMatcher verificationTargetMatcher)
```

HTTPリクエストがCSRFトークンの検証対象となるか判定を行うインターフェースを設定する。

**パラメータ:**
- `verificationTargetMatcher` - HTTPリクエストがCSRFトークンの検証対象となるか判定を行うインターフェース

---

### setVerificationFailureHandler

```java
public void setVerificationFailureHandler(VerificationFailureHandler verificationFailureHandler)
```

CSRFトークンの検証失敗時の処理を行うインタフェースを設定する。

**パラメータ:**
- `verificationFailureHandler` - CSRFトークンの検証失敗時の処理を行うインタフェース

---
