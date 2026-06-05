# class HttpRewriteHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- Handler<HttpRequest,HttpResponse>

---

```java
public class HttpRewriteHandler
implements Handler<HttpRequest,HttpResponse>
```

HTTPリクエスト中のリクエストパス、および、
HTTPレスポンス中のコンテンツパスに対する書き換え処理を行うハンドラ。

このハンドラでは、往路処理で{@link HttpRequest}中のリクエストパスの置換を行う。
もし、リクエストパスの置換が行われた場合は、
復路処理で{@link HttpResponse}中のコンテンツパスの置換を行う。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### requestPathRewriteRules

```java
private final List<HttpRequestRewriteRule> requestPathRewriteRules
```

リクエストパスリライト定義

---

### contentPathRewriteRules

```java
private final List<ContentPathRewriteRule> contentPathRewriteRules
```

コンテンツパスリライト定義

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

{@inheritDoc}
このハンドラでは、往路処理で{@link HttpRequest}中のリクエストパスの置換を行う。
もし、リクエストパスの置換が行われた場合は、
復路処理で{@link HttpResponse}中のコンテンツパスの置換を行う。

---

### rewriteRequestPath

```java
private String rewriteRequestPath(HttpRequest request, ExecutionContext context)
```

このハンドラに設定された書き換えルールに従って、
HTTPリクエスト中のリクエストパスの書き換え処理を行う。

**パラメータ:**
- `request` - HTTPリクエストオブジェクト
- `context` - 実行コンテキスト

**戻り値:**
リライト処理が行われた場合はtrue

---

### rewriteContentPath

```java
private String rewriteContentPath(HttpResponse response, ExecutionContext context)
```

このハンドラに設定された書き換えルールに従って、
HTTPレスポンス中のコンテンツパスに対する書き換え処理を行う。

**パラメータ:**
- `response` - HTTPリクエストオブジェクト
- `context` - 実行コンテキスト

**戻り値:**
リライト後コンテンツパス

---

### setRequestPathRewriteRules

```java
public HttpRewriteHandler setRequestPathRewriteRules(List<HttpRequestRewriteRule> rules)
```

リクエストパスの置換ルールを設定する。

以前の設定はクリアされる。

**パラメータ:**
- `rules` - リクエストパスの置換ルール

**戻り値:**
このオブジェクト自体。

---

### addRequestPathRewriteRule

```java
public HttpRewriteHandler addRequestPathRewriteRule(HttpRequestRewriteRule rule)
```

リクエストパスの置換ルールを設定する。

**パラメータ:**
- `rule` - リクエストパスの置換ルール

**戻り値:**
このオブジェクト自体

---

### setContentPathRewriteRules

```java
public HttpRewriteHandler setContentPathRewriteRules(List<ContentPathRewriteRule> rules)
```

コンテンツパスの置換ルールを設定する。

以前の設定はクリアされる。

**パラメータ:**
- `rules` - リクエストパスの置換ルール

**戻り値:**
このオブジェクト自体。

---

### addContentPathRewriteRule

```java
public HttpRewriteHandler addContentPathRewriteRule(ContentPathRewriteRule rule)
```

コンテンツパスの置換ルールを設定する。

**パラメータ:**
- `rule` - コンテンツパスの置換ルール

**戻り値:**
このオブジェクト自体

---
