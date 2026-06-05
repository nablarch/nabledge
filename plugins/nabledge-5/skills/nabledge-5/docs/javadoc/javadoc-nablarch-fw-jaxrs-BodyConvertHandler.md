# class BodyConvertHandler

**パッケージ:** nablarch.fw.jaxrs

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class BodyConvertHandler
implements HttpRequestHandler
```

{@link BodyConverter}によるリクエスト/レスポンスの変換を行うハンドラ。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### bodyConverters

```java
private List<BodyConverter> bodyConverters
```

{@link BodyConverter}

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

---

### copy

```java
private void copy(EntityResponse from, HttpResponse to)
```

{@link EntityResponse}からコンバートされた{@link HttpResponse}にコピーする。
<p>
レスポンスヘッダとステータスコードをコピーする。
レスポンスヘッダは上書きしない。
ステータスコードは指定された場合のみコピーする。

**パラメータ:**
- `from` - {@link EntityResponse}
- `to` - コンバートされた{@link HttpResponse}

---

### findConverter

```java
private BodyConverter findConverter(String mediaType)
```

メディアタイプを変換するための{@link BodyConverter}を取得する。
<p>
変換対象の{@link BodyConverter}が存在しない場合は、{@link Status#UNSUPPORTED_MEDIA_TYPE}を持つ{@link HttpErrorResponse}を送出する。

**パラメータ:**
- `mediaType` - メディアタイプ

**戻り値:**
{@link BodyConverter}

---

### cast

```java
private HttpResponse cast(Object response)
```

レスポンスのキャストを行う。
<p/>
レスポンスが{@code null}でなく、{@link HttpResponse}にキャストできない場合は、
{@link IllegalStateException}をスローする。

**パラメータ:**
- `response` - レスポンス

**戻り値:**
{@link HttpResponse}

---

### supportsMediaType

```java
protected boolean supportsMediaType(String contentType, String consumesMediaType)
```

HTTPヘッダーのContent-Typeに指定されたメディアタイプをサポートしているかを判定する。
<p>
以下の場合のみサポートしていると判定する。
<pre>
・Content-Typeが指定され、かつメディアタイプと一致する場合。（GET以外の場合を想定）
・Content-Typeが未指定で、かつメディアタイプも未指定の場合。（GETの場合を想定）
</pre>

**パラメータ:**
- `contentType` - リクエストされたContent-Type
- `consumesMediaType` - {@link javax.ws.rs.Consumes}アノテーションに指定されたメディアタイプ

**戻り値:**
サポートしている場合は<code>true</code>

---

### setBodyConverters

```java
public void setBodyConverters(List<BodyConverter> bodyConverters)
```

{@link BodyConverter}のリストを設定する。
<p>
既に設定されていた{@link BodyConverter}のリストは破棄される。

**パラメータ:**
- `bodyConverters` - {@link BodyConverter}

---

### addBodyConverter

```java
public void addBodyConverter(BodyConverter bodyConverter)
```

{@link BodyConverter}を追加する。

**パラメータ:**
- `bodyConverter` - 追加する{@link BodyConverter}

---
