# class SecureHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class SecureHandler
implements HttpRequestHandler
```

Webアプリケーションのセキュリティに関する処理やヘッダ設定を行うハンドラ。
<p>
レスポンスヘッダに設定する値は、{@link #setSecureResponseHeaderList(List)}に設定された、値から取得する。
特定条件の場合に出力を抑制する場合は、{@link SecureResponseHeader#isOutput(HttpResponse, ServletExecutionContext)}で、{@code false}を返すこと。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### CSP_NONCE_KEY

```java
public static final String CSP_NONCE_KEY
```

CSP nonce生成の要求を表す値をリクエストスコープに設定する際に使用するキー

---

### secureResponseHeaderList

```java
private List<? extends SecureResponseHeader> secureResponseHeaderList
```

セキュリティ関連のレスポンスヘッダを構築するオブジェクト

---

### generateCspNonce

```java
private boolean generateCspNonce
```

nonceを自動生成するかどうか

---

### random

```java
private final SecureRandom random
```

nonceの生成用の乱数ジェネレータ

---

## メソッドの詳細

### isGenerateCspNonce

```java
public boolean isGenerateCspNonce()
```

nonceを自動生成するかどうか。

**戻り値:**
trueの場合は、自動生成する

---

### setGenerateCspNonce

```java
public void setGenerateCspNonce(boolean generateCspNonce)
```

nonceを自動生成するかどうかの設定。
デフォルト値はfalseである。

**パラメータ:**
- `generateCspNonce` - nonceを自動生成するかどうか

---

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

---

### setSecureResponseHeaderList

```java
public void setSecureResponseHeaderList(List<? extends SecureResponseHeader> secureResponseHeaderList)
```

セキュリティ関連のヘッダ情報を生成する{@link SecureResponseHeader}を設定する。

**パラメータ:**
- `secureResponseHeaderList` - {@code SecureResponseHeader}のリスト

---
