# interface DoubleSubmissionHandler

**パッケージ:** nablarch.common.web.token

---

```java
public interface DoubleSubmissionHandler
```

OnDoubleSubmissionアノテーションに対する処理を行うインタフェース。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### handle

```java
HttpResponse handle(HttpRequest request, ExecutionContext context, Handler<HttpRequest,HttpResponse> httpRequestHandler, OnDoubleSubmission annotation)
```

OnDoubleSubmissionアノテーションに対する処理を行う。

**パラメータ:**
- `request` - HTTPリクエストオブジェクト
- `context` - サーバサイド実行コンテキストオブジェクト
- `httpRequestHandler` - 処理対象のリクエストハンドラ
- `annotation` - 処理対象のOnDoubleSubmission

**戻り値:**
HTTPレスポンスオブジェクト

---
