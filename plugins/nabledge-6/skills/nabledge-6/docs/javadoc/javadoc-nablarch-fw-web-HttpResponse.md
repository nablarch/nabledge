# class HttpResponse

**パッケージ:** nablarch.fw.web

**実装されたインタフェース:**
- Result

---

```java
public class HttpResponse
implements Result
```

HTTPレスポンスメッセージを生成する際に必要な情報を格納したクラス。
<p/>
HTTPクライアントに対するレスポンス処理をフレームワークが行うために必要な
以下の情報を保持する。
<ul>
    <li>レスポンスステータスコード</li>
    <li>レスポンスヘッダ</li>
    <li>レスポンスボディ</li>
</ul>
レスポンスボディの内容は、以下のいずれかの方式によって保持する。
<ol>
    <li>内容をこのオブジェクトに直接保持する方式(バッファ方式)</li>
    <li>ボディに書き込むコンテンツファイルのパスのみを指定する方式(コンテンツパス方式)</li>
</ol>
{@link #setContentPath(String)} の値を設定することで後者の方式がとられるようになる。<br/>
メモリ消費の観点や、コンテンツファイル管理の容易さから、
通常はコンテンツパスによる方式を使用すべきである。

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  
**作成者:** Masato Inoue  

---

## フィールドの詳細

### LS

```java
public static final String LS
```

HTTP行終端文字(CRLF)

---

### ASCII

```java
private static final Charset ASCII
```

アスキーエンコーディング

---

### UTF_8

```java
private static final Charset UTF_8
```

UTF-8エンコーディング

---

### CHARSET_ATTR_IN_CONTENT_PATH

```java
private static final Pattern CHARSET_ATTR_IN_CONTENT_PATH
```

Content-Typeヘッダのcharsetが設定されたパターン

---

### wasBytes

```java
private boolean wasBytes
```

HTTPメッセージをbyte配列から作成したかどうか

---

### status

```java
private Status status
```

HTTPレスポンスステータス

---

### httpVersion

```java
private String httpVersion
```

HTTPプロトコルバージョン

---

### HTTP_VERSION_SYNTAX

```java
private static final Pattern HTTP_VERSION_SYNTAX
```

HTTPバージョンの書式

---

### headers

```java
private Map<String,String> headers
```

HTTPレスポンスヘッダを格納するMap

---

### charset

```java
private Charset charset
```

文字エンコーディング

---

### CONTENT_DISPOSITION

```java
protected static final String CONTENT_DISPOSITION
```

Content-Dispositionヘッダ。

---

### cookies

```java
private final List<Cookie> cookies
```

Cookie文字列を格納する{@link List}

---

### MAGIC

```java
static final MimetypesFileTypeMap MAGIC
```

ファイル識別子からコンテンツタイプを判定する。

---

### body

```java
private final ResponseBody body
```

HTTPレスポンスのボディ内容を格納するオブジェクト。

---

### HTTP_HEADER_SYNTAX

```java
private static final Pattern HTTP_HEADER_SYNTAX
```

HTTPヘッダの書式

---

### HTTP_STATUS_CODE_SYNTAX

```java
private static final Pattern HTTP_STATUS_CODE_SYNTAX
```

HTTPステータスコードの書式

---

## コンストラクタの詳細

### HttpResponse

```java
public HttpResponse()
```

{@code HttpResponse}オブジェクトを生成する。
<p/>
以下のHTTPレスポンスメッセージに相当する{@code HttpResponse}オブジェクトを生成する。
<pre>
    HTTP/1.1 200 OK
    Content-Type: text/plain;charset=UTF-8
</pre>

---

### HttpResponse

```java
public HttpResponse(int statusCode)
```

指定されたステータスコードの{@code HttpResponse}オブジェクトを生成する。
<p/>
このメソッドの処理は以下のソースコードと等価である。
<code><pre>
    new HttpResponse().setStatusCode(statusCode);
</pre></code>

**パラメータ:**
- `statusCode` - HTTPステータスコード

---

### HttpResponse

```java
public HttpResponse(int statusCode, String contentPath)
```

指定されたHTTPステータスコードとコンテンツパスの{@code HttpResponse}オブジェクトを生成する。
<p/>
このメソッドの処理は以下のソースコードと等価である。
<code><pre>
    new HttpResponse().setStatusCode(statusCode)
                      .setContentPath(contentPath);
</pre></code>

**パラメータ:**
- `statusCode` - HTTPステータスコード
- `contentPath` - コンテンツパス

---

### HttpResponse

```java
public HttpResponse(String contentPath)
```

指定されたコンテンツパスの{@code HttpResponse}オブジェクトを生成する。
<p/>
このメソッドの処理は以下のソースコードと等価である。
<code><pre>
    new HttpResponse().setStatusCode(200)
                      .setContentPath(contentPath);
</pre></code>

**パラメータ:**
- `contentPath` - コンテンツパス

---

## メソッドの詳細

### parse

```java
public static HttpResponse parse(String message)
```

HTTPレスポンスメッセージの内容から{@code HttpResponse}オブジェクトを生成する。

**パラメータ:**
- `message` - HTTPレスポンスメッセージ

**戻り値:**
HTTPレスポンスメッセージの内容に対応した{@code HttpResponse}オブジェクト

---

### parse

```java
public static HttpResponse parse(byte[] message)
```

HTTPレスポンスメッセージの内容から{@code HttpResponse}オブジェクトを生成する。

**パラメータ:**
- `message` - HTTPレスポンスメッセージ

**戻り値:**
HTTPレスポンスメッセージの内容に対応した{@code HttpResponse}オブジェクト

---

### getStatusCode

```java
public int getStatusCode()
```

HTTPレスポンスのステータスコードの値を返す。
<p/>
HTTPレスポンスがリダイレクトである場合は{@code 302}を返す。

**戻り値:**
HTTPステータスコード

---

### isRedirectStatusCode

```java
private boolean isRedirectStatusCode()
```

{@link #status}がリダイレクトを示すステータスコードかどうか。

**戻り値:**
リダイレクトを示すステータスコード(301, 302, 303, 307)の場合はtrue

---

### setStatusCode

```java
public HttpResponse setStatusCode(int code)
```

HTTPレスポンスのステータスコードを設定する。
<p/>
デフォルトのステータスコードは{@code 200}である。

**パラメータ:**
- `code` - HTTPステータスコード

**戻り値:**
本オブジェクト

**例外:**
- `IllegalArgumentException` - 指定されたステータスコードが無効な場合

---

### getReasonPhrase

```java
public String getReasonPhrase()
```

HTTPレスポンスのステータスフレーズを返す。

**戻り値:**
ステータスフレーズ

---

### getMessage

```java
public String getMessage()
```

処理結果に対する詳細情報を返す。
<p/>
返される詳細情報は以下の通りである。
<pre>
  (ステータスコード): (ステータスフレーズ)
</pre>

---

### getHttpVersion

```java
public String getHttpVersion()
```

HTTPバージョンを表す文字列を返す。

**戻り値:**
HTTPバージョン名

---

### setHttpVersion

```java
public HttpResponse setHttpVersion(String httpVersion)
```

HTTPバージョンを設定する。
<p/>
デフォルト値は "HTTP/1.1" である。

**パラメータ:**
- `httpVersion` - HTTPバージョン名

**戻り値:**
本オブジェクト

**例外:**
- `IllegalArgumentException` - HTTPバージョンの書式が無効な場合

---

### getHeaderMap

```java
public Map<String,String> getHeaderMap()
```

HTTPレスポンスヘッダを格納するMapを返す。
<p/>
このMapに対する変更はレスポンスヘッダの内容に直接反映される。

**戻り値:**
HTTPレスポンスヘッダを格納するMap

---

### getHeader

```java
public String getHeader(String headerName)
```

HTTPレスポンスヘッダの値を返す。

**パラメータ:**
- `headerName` - ヘッダー名

**戻り値:**
ヘッダーの値

---

### setHeader

```java
public void setHeader(String headerName, String value)
```

HTTPレスポンスヘッダの値を設定する。

**パラメータ:**
- `headerName` - ヘッダー名
- `value` - ヘッダーの値

---

### getContentType

```java
public String getContentType()
```

Content-Typeの値を取得する。
<p/>
Content-Typeが設定されている場合は、以下のソースコードと等価である。
<code><pre>
  this.headers().get("Content-Type")
</pre></code>
<p/>

Content-Typeが設定されていない場合は、以下の処理を行う。<br />
・{@link WebConfig#getAddDefaultContentTypeForNoBodyResponse()} がtrueの場合、
またはボディが存在する場合に"text/plain;charset=UTF-8"を設定する。<br />

**戻り値:**
Contents-Typeの値

---

### needsDefaultContentType

```java
private boolean needsDefaultContentType()
```

Content-Type設定されていない場合に、デフォルトのContent-Typeを付与するべきか否かを判定する。

**戻り値:**
デフォルトのContent-Typeを付与すべき時はtrue。

---

### getCharset

```java
public Charset getCharset()
```

Content-Typeに指定された文字エンコーディングを取得する。

**戻り値:**
文字エンコーディング

---

### setContentType

```java
public HttpResponse setContentType(String contentType)
```

Content-Typeを設定する。
<p/>
Content-Typeのデフォルト値は、"text/plain;charset=UTF-8" である。<br/>
ボディに書き込む内容をコンテンツパスで指定する場合、
Content-Typeはコンテンツパスの拡張子から自動的に決定される為、
このメソッドを明示的に使用する必要は無い。

**パラメータ:**
- `contentType` - Content-Typeの値

**戻り値:**
本オブジェクト

---

### getLocation

```java
public String getLocation()
```

Locationの値を取得する。
<p/>
このメソッドの処理は以下のソースコードと等価である。
<code><pre>
  this.headers().get("Location")
</pre></code>

**戻り値:**
Locationの値

---

### setLocation

```java
public HttpResponse setLocation(String location)
```

Locationの値を設定する。
<p/>
リダイレクト時のHTTPクライアントの遷移先URIを設定する。<br/>
デフォルトでは設定されない。

**パラメータ:**
- `location` - 遷移先URI

**戻り値:**
本オブジェクト

---

### setContentDisposition

```java
public HttpResponse setContentDisposition(String fileName)
```

Content-Dispositionの値を設定する。
<p/>
Content-Typeが明示的に設定されていない場合、
設定されたファイル名の拡張子に応じたContent-Typeを自動的に設定する。<br/>
本メソッドではattachment属性を指定するため、ダウンロード時にダイアログが必ず表示される。

**パラメータ:**
- `fileName` - ファイル名

**戻り値:**
本オブジェクト

---

### setContentDisposition

```java
public HttpResponse setContentDisposition(String fileName, boolean inline)
```

Content-Dispositionの値を設定する。
<p/>
Content-Typeが明示的に設定されていない場合、
設定されたファイル名の拡張子に応じたContent-Typeを自動的に設定する。<br/>
{@code inline}に{@code true}を指定した場合、ダウンロードされたファイルは
クライアントアプリで自動的に開かれる。<br/>
ただし、実際にそのような挙動となるかどうかは、クライアントの設定
およびOSのセキュリティ設定に依存する。

**パラメータ:**
- `fileName` - ファイル名
- `inline` - インライン表示する場合は{@code true}

**戻り値:**
本オブジェクト

---

### getContentDisposition

```java
public String getContentDisposition()
```

Content-Dispositionの値を取得する。

**戻り値:**
Content-Dispositionの値

---

### getTransferEncoding

```java
public String getTransferEncoding()
```

Transfer-Encodingの値を取得する。
<p/>
このメソッドの処理は以下のソースコードと等価である。
<pre>
  this.headers().get("Transfer-Encoding")
</pre>

**戻り値:**
Transfer-Encodingの値

---

### setTransferEncoding

```java
public HttpResponse setTransferEncoding(String encoding)
```

Transfer-Encodingの値を設定する。
<p/>
このヘッダの値が"chunked"であった場合、
コンテンツボディはchunked-encodingに従って読み書きされる。<br/>
デフォルトではこのヘッダは設定されない。

**パラメータ:**
- `encoding` - Transfer-Encodingの値

**戻り値:**
本オブジェクト

---

### getCookie

```java
public HttpCookie getCookie()
```

サーバ側から送信されたクッキー情報のうち先頭のクッキーをを取得する。

**戻り値:**
サーバ側から送信されたクッキー情報のうち先頭のクッキー。クッキーが存在しない場合は<code>null</code>

---

### getCookieList

```java
public List<Cookie> getCookieList()
```

サーバ側から送信されたクッキー情報のリストを取得する。

**戻り値:**
クッキー情報のリスト

---

### getHttpCookies

```java
public List<HttpCookie> getHttpCookies()
```

サーバ側から送信されたクッキーのリストを{@link HttpCookie}として取得する。
{@link HttpCookie}は同じ属性を持つ複数のクッキーを保持する仕様であるため、
クッキーの属性が各々異なることを考慮し、リストとして返却する。

**戻り値:**
クッキー ({@link HttpCookie})のリスト

---

### setCookie

```java
public HttpResponse setCookie(HttpCookie cookie)
```

サーバ側から送信されたクッキー情報を設定する。

**パラメータ:**
- `cookie` - クッキー情報オブジェクト

**戻り値:**
本オブジェクト

---

### addCookie

```java
public HttpResponse addCookie(HttpCookie cookie)
```

サーバ側から送信されたクッキー情報を設定する。

**パラメータ:**
- `cookie` - クッキー情報オブジェクト

**戻り値:**
本オブジェクト

---

### setContentPath

```java
public HttpResponse setContentPath(String path)
```

コンテンツパスを設定する。
<p/>
本処理は{@link #setContentPath(ResourceLocator)}に委譲する。

**パラメータ:**
- `path` - コンテンツパス

**戻り値:**
本オブジェクト

---

### setContentPath

```java
public HttpResponse setContentPath(ResourceLocator resource)
```

コンテンツパスを設定する。
<p/>
指定した{@link ResourceLocator}オブジェクトが{@code null}でない場合は、
リソース名からContent-Typeを自動的に設定した後、コンテンツパスを設定する。<br/>
{@code ResourceLocator}オブジェクトが{@code null}の場合は、コンテンツパスのみ設定する。

**パラメータ:**
- `resource` - コンテンツパス

**戻り値:**
本オブジェクト

---

### getContentPath

```java
public ResourceLocator getContentPath()
```

コンテンツパスを取得する。
<p/>
HTTPレスポンスボディに書き込むコンテンツパスを取得する。

**戻り値:**
コンテンツパス

---

### getContentLength

```java
public String getContentLength()
```

Content-Lengthの値を取得する。
<p/>
HTTPレスポンスボディの内容がこのオブジェクト自体に保持されている場合に限り、
そのバイト数を返す。<br/>
それ以外は{@code null}を返す。

**戻り値:**
Content-Lengthの値

---

### cleanup

```java
public HttpResponse cleanup()
```

リソースを開放する。

**戻り値:**
本オブジェクト

---

### isBodyEmpty

```java
public boolean isBodyEmpty()
```

HTTPレスポンスボディの内容が設定されていなければ{@code true}を返す。

**戻り値:**
ボディの内容が設定されていなければ{@code true}

---

### getBodyString

```java
public String getBodyString()
```

HTTPレスポンスボディの内容を表す文字列を返す。

**戻り値:**
ボディの内容を表す文字列を返す

---

### getBodyStream

```java
public InputStream getBodyStream()
```

HTTPレスポンスボディの内容を保持するストリームを取得する。

**戻り値:**
HTTPレスポンスボディの内容を保持するストリーム

---

### setBodyStream

```java
public HttpResponse setBodyStream(InputStream bodyStream)
```

HTTPレスポンスボディの内容を保持するストリームを設定する。

**パラメータ:**
- `bodyStream` - HTTPレスポンスボディの内容を保持するストリーム

**戻り値:**
本オブジェクト

---

### write

```java
public HttpResponse write(CharSequence text)
                   throws HttpErrorResponse
```

HTTPレスポンスボディに文字列を書き込む。
<p/>
このメソッドで書き込まれたデータは、本オブジェクトが保持する
バッファに保持され、クライアントソケットに対する書き込みは一切発生しない。
(このライタに対するflush()は単に無視される。)<br/>
実際にソケットに対するレスポンス処理が行われるのは、
{@link nablarch.fw.web.handler.HttpResponseHandler}にレスポンスオブジェクトが戻された後である。
また、このオブジェクトにコンテンツパスが設定されている場合、
このライタに書き込まれた内容は単に無視される。

**パラメータ:**
- `text` - 書き込む文字列

**戻り値:**
本オブジェクト

**例外:**
- `HttpErrorResponse` - バッファの上限を越えてデータが書き込まれた場合

---

### write

```java
public HttpResponse write(byte[] bytes)
                   throws HttpErrorResponse
```

HTTPレスポンスボディにバイト配列を書き込む。
<p/>
このメソッドで書き込まれたデータは、本オブジェクトが保持する
バッファに保持され、クライアントソケットに対する書き込みは一切発生しない。
(このライタに対するflush()は単に無視される。)<br/>
実際にソケットに対するレスポンス処理が行われるのは、
{@link nablarch.fw.web.handler.HttpResponseHandler}にレスポンスオブジェクトが戻された後である。
また、このオブジェクトにコンテンツパスが設定されている場合、
このライタに書き込まれた内容は単に無視される。

**パラメータ:**
- `bytes` - 書き込むバイト配列

**戻り値:**
本オブジェクト

**例外:**
- `HttpErrorResponse` - バッファの上限を越えてデータが書き込まれた場合

---

### write

```java
public HttpResponse write(ByteBuffer bytes)
                   throws HttpErrorResponse
```

HTTPレスポンスボディにバイト配列を書き込む。
<p/>
このメソッドで書き込まれたデータは、本オブジェクトが保持する
バッファに保持され、クライアントソケットに対する書き込みは一切発生しない。
(このライタに対するflush()は単に無視される。)<br/>
実際にソケットに対するレスポンス処理が行われるのは、
{@link nablarch.fw.web.handler.HttpResponseHandler}にレスポンスオブジェクトが戻された後である。
また、このオブジェクトにコンテンツパスが設定されている場合、
このライタに書き込まれた内容は単に無視される。

**パラメータ:**
- `bytes` - 書き込むバイト列を格納したバッファ

**戻り値:**
本オブジェクト

**例外:**
- `HttpErrorResponse` - バッファの上限を越えてデータが書き込まれた場合

---

### toString

```java
public String toString()
```

オブジェクトの内容と等価なHTTPレスポンスメッセージを返す。

---

### parseMessage

```java
private void parseMessage(Reader source)
```

HTTPレスポンスメッセージを読み込んでHttpResponseオブジェクトを生成する。

**パラメータ:**
- `source` - HTTPレスポンスメッセージ

---

### scanResponseBody

```java
private void scanResponseBody(Scanner message)
```

HTTPレスポンスボディの内容を読み込む。

**パラメータ:**
- `message` - HTTPレスポンスメッセージ

---

### getBytes

```java
private byte[] getBytes(CharSequence chars, Charset charset)
```

文字シーケンスをバイト配列に変換し、取得する。

**パラメータ:**
- `chars` - 文字シーケンス
- `charset` - 文字シーケンスの文字コード

**戻り値:**
文字シーケンスを変換したバイト配列

---

### scanChunkedBody

```java
private void scanChunkedBody(Scanner message)
```

"chunked" Transfer-Encodingによる
HTTPレスポンスボディの内容を読み込む。

**パラメータ:**
- `message` - HTTPレスポンスメッセージ

---

### scanHttpResponseHeader

```java
private void scanHttpResponseHeader(String header)
```

HTTPレスポンスヘッダの内容を読み込む。

**パラメータ:**
- `header` - HTTPレスポンスメッセージ

---

### scanHttpVersion

```java
private void scanHttpVersion(Scanner scanner)
```

HTTPバージョンを読み込む。

**パラメータ:**
- `scanner` - HTTPレスポンスメッセージ

---

### scanHttpStatus

```java
private void scanHttpStatus(Scanner scanner)
```

HTTPレスポンスステータスを読み込む。

**パラメータ:**
- `scanner` - HTTPレスポンスメッセージ

---

### parseError

```java
private void parseError(Object obj)
```

パース処理中のエラーを送出する。

**パラメータ:**
- `obj` - エラー情報オブジェクト

---

### isSuccess

```java
public boolean isSuccess()
```

処理が正常終了したかどうかを返す。
<p/>
HTTPステータスコードが400未満であれば正常終了とみなす。

---
