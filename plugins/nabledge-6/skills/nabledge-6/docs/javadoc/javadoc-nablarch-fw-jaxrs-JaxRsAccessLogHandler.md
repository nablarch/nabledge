# class JaxRsAccessLogHandler

**パッケージ:** nablarch.fw.jaxrs

**実装されたインタフェース:**
- Handler<HttpRequest,HttpResponse>

---

```java
public class JaxRsAccessLogHandler
implements Handler<HttpRequest,HttpResponse>
```

RESTfulウェブサービスのアクセスログを出力するハンドラ。

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### EMPTY_OPTIONS

```java
private static final Object[] EMPTY_OPTIONS
```

空のオプション情報

---

### logFormatter

```java
private final JaxRsAccessLogFormatter logFormatter
```

ログフォーマッター

---

## コンストラクタの詳細

### JaxRsAccessLogHandler

```java
public JaxRsAccessLogHandler()
```

コンストラクタ。

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

HTTPアクセスログを出力する。

**パラメータ:**
- `request` - {@link HttpRequest}
- `context` - {@link ExecutionContext}

**戻り値:**
次のハンドラの処理結果

**例外:**
- `ClassCastException` - context の型が {@link ServletExecutionContext} でない場合。

---

### createLogFormatter

```java
protected JaxRsAccessLogFormatter createLogFormatter(Map<String,String> props)
```

使用する {@link JaxRsAccessLogFormatter} を生成します。

**戻り値:**
{@link JaxRsAccessLogFormatter}

---

### writeBeginLog

```java
protected void writeBeginLog(JaxRsAccessLogContext logContext)
```

リクエスト処理開始時のログを出力する。

**パラメータ:**
- `logContext` - {@link JaxRsAccessLogContext}

---

### writeEndLog

```java
protected void writeEndLog(JaxRsAccessLogContext logContext)
```

リクエスト処理終了時のログを出力する。

**パラメータ:**
- `logContext` - {@link JaxRsAccessLogContext}

---

### getRequestOptions

```java
protected Object[] getRequestOptions(HttpRequest request, ExecutionContext context)
```

リクエスト処理開始時のログ出力で使用するオプション情報を取得する。

**パラメータ:**
- `request` - {@link HttpRequest}
- `context` - {@link ExecutionContext}

**戻り値:**
オプション情報。空の場合は {@code null}を返す。

---

### getResponseOptions

```java
protected Object[] getResponseOptions(HttpRequest request, HttpResponse response, ExecutionContext context)
```

リクエスト処理終了時のログ出力で使用するオプション情報を取得する。

**パラメータ:**
- `request` - {@link HttpRequest}
- `response` - {@link HttpResponse}
- `context` - {@link ExecutionContext}

**戻り値:**
オプション情報。空の場合は {@code null}を返す。

---
