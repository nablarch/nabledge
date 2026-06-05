# class JaxRsResponseHandler

**パッケージ:** nablarch.fw.jaxrs

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class JaxRsResponseHandler
implements HttpRequestHandler
```

JAX-RS用のレスポンスを返却するハンドラ。
<p/>
このハンドラでは、後続のハンドラから戻された{@link HttpResponse}の内容を、クライアントへのレスポンスとして書き込む。
後続のハンドラで例外が発生した場合には、{@link ErrorResponseBuilder}を使用してエラー用のレスポンスを作成し、クライアントへのレスポンスとして書き込む。
<p/>
後続のハンドラ及び{@link ErrorResponseBuilder}で{@link HttpResponse}を生成する際には、レスポンスヘッダーも含めて設定する必要がある。
このハンドラでは、レスポンスヘッダーを自動的に設定するようなことはしない。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### BUFFER_SIZE

```java
private static final int BUFFER_SIZE
```

ストリームに出力する際のバッファサイズ。

---

### errorResponseBuilder

```java
private ErrorResponseBuilder errorResponseBuilder
```

エラーレスポンスビルダー

---

### errorLogWriter

```java
private JaxRsErrorLogWriter errorLogWriter
```

エラー情報を出力するライター

---

### responseFinishers

```java
private List<ResponseFinisher> responseFinishers
```

レスポンスフィニッシャー

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

---

### finishResponse

```java
protected void finishResponse(HttpRequest request, HttpResponse response, ExecutionContext context)
```

レスポンスを仕上げる。

**パラメータ:**
- `request` - リクエスト
- `response` - レスポンス
- `context` - コンテキスト

---

### writeResponse

```java
protected void writeResponse(HttpResponse response, ServletExecutionContext context)
```

レスポンスを書き込む。

**パラメータ:**
- `response` - {@link HttpResponse}
- `context` - {@link ServletExecutionContext}

---

### writeHeaders

```java
protected void writeHeaders(HttpResponse response, HttpServletResponse nativeResponse)
```

レスポンスヘッダーを書き込む。
<p/>
{@link HttpResponse}内のヘッダー情報を、{@link HttpServletResponse}に対して書き込む。

**パラメータ:**
- `response` - {@link HttpResponse}
- `nativeResponse` - {@link HttpServletResponse}

---

### writeBody

```java
protected static void writeBody(InputStream in, HttpServletResponse nativeRes)
               throws IOException
```

メッセージボディの内容をクライアントに送信する。

**パラメータ:**
- `in` - 入力ストリームの内容
- `nativeRes` - サーブレットレスポンス

**例外:**
- `IOException` - ソケットI/Oにおけるエラー

---

### setErrorResponseBuilder

```java
public void setErrorResponseBuilder(ErrorResponseBuilder errorResponseBuilder)
```

エラーレスポンスビルダーを設定する。
<p/>
デフォルト実装である{@link ErrorResponseBuilder}を差し替えたい場合に拡張クラスを設定する。

**パラメータ:**
- `errorResponseBuilder` - エラーレスポンスビルダー

---

### setErrorLogWriter

```java
public void setErrorLogWriter(JaxRsErrorLogWriter errorLogWriter)
```

エラーログライターを設定する。
<p/>
デフォルト実装である{@link JaxRsErrorLogWriter}を差し替えたい場合に拡張クラスを設定する。

**パラメータ:**
- `errorLogWriter` - エラーログライター

---

### setResponseFinishers

```java
public void setResponseFinishers(List<ResponseFinisher> responseFinishers)
```

レスポンスフィニッシャーを設定する。

**パラメータ:**
- `responseFinishers` - レスポンスフィニッシャー

---
