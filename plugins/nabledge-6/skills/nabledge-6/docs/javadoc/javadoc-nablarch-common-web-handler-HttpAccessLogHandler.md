# class HttpAccessLogHandler

**パッケージ:** nablarch.common.web.handler

**実装されたインタフェース:**
- Handler<HttpRequest,HttpResponse>

---

```java
public class HttpAccessLogHandler
implements Handler<HttpRequest,HttpResponse>
```

HTTPアクセスログを出力するクラス。
<pre>
ロガー名は"HTTP_ACCESS"を使用し、INFOレベルで出力する。
{@link #handle(HttpRequest, ExecutionContext)}メソッドの引数{@link ExecutionContext}は、
リクエスト情報を取得するために{@link nablarch.fw.web.servlet.ServletExecutionContext}にダウンキャストして使用する。
</pre>

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### EMPTY_OPTIONS

```java
private static final Object[] EMPTY_OPTIONS
```

空のオプション情報

---

## コンストラクタの詳細

### HttpAccessLogHandler

```java
public HttpAccessLogHandler()
```

{@link nablarch.fw.web.handler.HttpAccessLogFormatter}を初期化する。

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest req, ExecutionContext context)
                    throws ClassCastException
```

HTTPアクセスログを出力する。

**パラメータ:**
- `req` - {@link HttpRequest}
- `context` - {@link ExecutionContext}

**戻り値:**
次のハンドラの処理結果

**例外:**
- `ClassCastException` - context の型が {@link ServletExecutionContext} でない場合。

---

### writeBeginLog

```java
protected void writeBeginLog(HttpRequest request, ServletExecutionContext context, HttpAccessLogContext logContext)
```

リクエスト処理開始時のログを出力する。

**パラメータ:**
- `request` - {@link HttpRequest}
- `context` - {@link ExecutionContext}
- `logContext` - {@link HttpAccessLogContext}

---

### writeEndLog

```java
protected void writeEndLog(HttpRequest request, ServletExecutionContext context, HttpAccessLogContext logContext, HttpResponse response)
```

リクエスト処理終了時のログを出力する。

**パラメータ:**
- `request` - {@link HttpRequest}
- `context` - {@link ExecutionContext}
- `logContext` - {@link HttpAccessLogContext}
- `response` - {@link HttpResponse}

---

### getRequestOptions

```java
protected Object[] getRequestOptions(HttpRequest request, ExecutionContext context)
```

リクエスト時のオプション情報を取得する。<br>
デフォルト実装ではnullを返す。

**パラメータ:**
- `request` - {@link HttpRequest}
- `context` - {@link ExecutionContext}

**戻り値:**
オプション情報。指定しない場合はnull

---

### getResponseOptions

```java
protected Object[] getResponseOptions(HttpRequest request, HttpResponse response, ExecutionContext context)
```

レスポンス時のオプション情報を取得する。<br>
デフォルト実装ではnullを返す。

**パラメータ:**
- `request` - {@link HttpRequest}
- `response` - {@link HttpResponse}
- `context` - {@link ExecutionContext}

**戻り値:**
オプション情報。指定しない場合はnull

---
