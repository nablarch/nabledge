# class HttpResponseHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- Handler<HttpRequest,HttpResponse>

---

```java
public class HttpResponseHandler
implements Handler<HttpRequest,HttpResponse>
```

ServletAPIを通じてHTTPレスポンス処理を行うハンドラ。

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  
**作成者:** Masato Inoue  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### USER_AGENT

```java
protected static final String USER_AGENT
```

User-Agentヘッダ。

---

### usesFlush

```java
private boolean usesFlush
```

レスポンスヘッダ設定時にFlushするかどうか

---

### convertMode

```java
private HttpResponseUtil.StatusConvertMode convertMode
```

HTTPレスポンスコードの変換モード。

---

### downloadFileNameEncoderFactory

```java
private DownloadFileNameEncoderFactory downloadFileNameEncoderFactory
```

ダウンロードファイル名のエンコーダを取得するクラス。

---

### BUFFER_SIZE

```java
private static final int BUFFER_SIZE
```

ストリームに出力する際のバッファサイズ。

---

### customResponseWriter

```java
private CustomResponseWriter customResponseWriter
```

HTTPレスポンス出力クラス

---

### contentPathRule

```java
private ResourcePathRule contentPathRule
```

言語対応コンテンツパスのルール

---

### fatalErrorMessage

```java
private final String fatalErrorMessage
```

どうしようも無いときのエラーレスポンスで送信する内容。

---

## メソッドの詳細

### setForceFlushAfterWritingHeaders

```java
public void setForceFlushAfterWritingHeaders(boolean usesFlush)
```

HTTPヘッダーをwriteした直後にFlushするかどうかの設定
デフォルト値はtrueである。

**パラメータ:**
- `usesFlush` - Flushの有無

---

### setDownloadFileNameEncoderFactory

```java
public HttpResponseHandler setDownloadFileNameEncoderFactory(DownloadFileNameEncoderFactory factory)
```

ダウンロードファイル名のエンコーダを取得するクラスを設定する

**パラメータ:**
- `factory` - ダウンロードファイル名のエンコーダを取得するクラス

**戻り値:**
このオブジェクト自体。

---

### setConvertMode

```java
public void setConvertMode(String convertMode)
```

HTTPレスポンスコードの変換モードを設定する。<br>
<p>
HTTPレスポンスコードの変換モードは以下のいずれかである。
<ul>
<li>CONVERT_ONLY_400_TO_200</li>
<li>CONVERT_ALL_TO_200</li>
</ul>
デフォルトは、CONVERT_ONLY_400_TO_200である。
</p>
<p>
設定した値は、{@link HttpResponseUtil#chooseResponseStatusCode(HttpResponse, ServletExecutionContext)}で使用される。<br>
変換の仕様については、{@link HttpResponseUtil#chooseResponseStatusCode(HttpResponse, ServletExecutionContext)}を参照。
</p>

**パラメータ:**
- `convertMode` - HTTPレスポンスコードの変換モード。

---

### setCustomResponseWriter

```java
public void setCustomResponseWriter(CustomResponseWriter customResponseWriter)
```

HTTPレスポンス出力クラスを設定する。
このプロパティを設定することで、任意のレスポンス出力処理を実行できる。
設定されていない場合はサーブレットフォワード(JSP)によるレスポンス出力が実行される。

**パラメータ:**
- `customResponseWriter` - HTTPレスポンス出力クラス

---

### handle

```java
public HttpResponse handle(HttpRequest req, ExecutionContext ctx)
                    throws ClassCastException
```

{@inheritDoc}
<p>
この実装では、後続ハンドラの処理結果(HttpResponse)の内容をもとに、
クライアントに対するレスポンス処理を行う。
</p>

**例外:**
- `ClassCastException` - 引数 ctx の実際の型が ServletExecutionContext でない場合。

---

### handleServletScheme

```java
private void handleServletScheme(HttpResponse res, ServletExecutionContext context)
                         throws ServletException, IOException
```

{@link HttpResponse}のschemeが"servlet"の場合の処理を行う。

{@link CustomResponseWriter}が、このレスポンスを処理対象と判断した場合、
{@link CustomResponseWriter}に処理を移譲する。
そうでない場合、サーブレットフォワードを行う。

**パラメータ:**
- `res` - HTTPレスポンス
- `context` - 実行コンテキスト

**例外:**
- `ServletException` - Servlet API使用時に発生した例外
- `IOException` - 入出力例外(ソケットI/Oエラー等)

---

### isClientDisconnected

```java
private boolean isClientDisconnected(ServletException e)
```

サーブレット例外がクライアントの接続断に起因する例外であるかを判定する。
<p>
本実装は、WebLogic 11g のJSP処理中にクライアントの接続断が起きた際に発生する
SocketException を原因とする例外の場合、trueを返す。
</p>

**パラメータ:**
- `e` - サーブレット例外

**戻り値:**
サーブレット例外がクライアントの接続断に起因する例外である場合はtrue

---

### writeResponse

```java
public void writeResponse(HttpResponse res, ServletExecutionContext ctx)
```

HTTPレスポンスオブジェクトの内容をもとに、
クライアントにレスポンスを返す。

**パラメータ:**
- `res` - HTTPレスポンスオブジェクト
- `ctx` - 実行コンテキスト

---

### isErrorResponse

```java
protected boolean isErrorResponse(HttpResponse res)
```

レスポンスがエラーか否かを判定する。
<p>
ステータスコードが400以上であればtrue、
それ以外であればfalseを返す。
</p>

**パラメータ:**
- `res` - HTTPレスポンス

**戻り値:**
判定結果

---

### isServletScheme

```java
private boolean isServletScheme(HttpResponse res)
```

{@link HttpResponse}のschemeが"servlet"であるか判定する。

**パラメータ:**
- `res` - 判定対象のHTTPレスポンスオブジェクト

**戻り値:**
"servlet"である場合、真

---

### doesRedirect

```java
private boolean doesRedirect(HttpResponse res)
```

このリクエストのレスポンスでリダイレクトを要求する場合かどうかを返す。

**パラメータ:**
- `res` - HTTPレスポンスオブジェクト

**戻り値:**
リダイレクトを要求を行う場合はtrue

---

### doServletForward

```java
private void doServletForward(String pathToForward, ServletExecutionContext ctx)
                      throws ServletException, IOException
```

サーブレットフォーワード処理を行う。

**パラメータ:**
- `pathToForward` - フォワード先のパス
- `ctx` - 実行コンテキスト

**例外:**
- `ServletException` - フォーワード先においてエラーが発生した場合。
- `IOException` - レスポンス処理中でのIOエラー

---

### exportSessionStore

```java
private void exportSessionStore(ServletExecutionContext ctx)
```

セッションストアの内容をリクエストスコープに移送する。
同名のキーがリクエストスコープに存在する場合は、その項目は移送されない。

**パラメータ:**
- `ctx` - {@link ServletExecutionContext}

---

### isSessionExportRequired

```java
private boolean isSessionExportRequired(String pathToForward)
```

フォワード先のパスが、セッションを移送すべきパスかどうか判定する。
指定されたpathが"."を含む場合、真と判定する。

**パラメータ:**
- `pathToForward` - フォワード先のパス

**戻り値:**
移送すべき場合、真

---

### doRedirect

```java
private void doRedirect(HttpResponse res, ServletExecutionContext ctx)
                throws IOException
```

リダイレクト処理を行う。
リダイレクト先のURLをURLリライトし、コンテナに処理を委譲する。

**パラメータ:**
- `res` - HTTPレスポンスオブジェクト
- `ctx` - 実行コンテキスト

**例外:**
- `IOException` - リダイレクト処理中のIOエラー

---

### getPathForLanguage

```java
private String getPathForLanguage(HttpResponse res, ServletExecutionContext ctx)
```

言語対応のコンテンツパスを取得する。
<p/>
自身の{@link #contentPathRule}プロパティに指定された{@link ResourcePathRule}に処理を委譲する。

**パラメータ:**
- `res` - HTTPレスポンスオブジェクト
- `ctx` - 実行コンテキスト

**戻り値:**
言語対応のコンテンツパス

---

### setContentPathRule

```java
public void setContentPathRule(ResourcePathRule contentPathRule)
```

言語対応コンテンツパスのルールを設定する。

**パラメータ:**
- `contentPathRule` - 言語対応コンテンツパスのルール

---

### writeHeaders

```java
private void writeHeaders(HttpResponse res, ServletExecutionContext ctx)
                  throws IOException
```

HTTPステータス・HTTPヘッダの内容をクライアントに送信する。

**パラメータ:**
- `res` - HTTPレスポンスオブジェクト
- `ctx` - 実行コンテキストオブジェクト

**例外:**
- `IOException` - ソケットI/Oにおけるエラー

---

### setStatusCode

```java
protected static void setStatusCode(HttpResponse res, ServletExecutionContext ctx)
```

クライアントに送信するステータスコードを設定する。

**パラメータ:**
- `res` - HTTPレスポンスオブジェクト
- `ctx` - 実行コンテキスト

---

### setHeaders

```java
private void setHeaders(HttpResponse res, ServletExecutionContext ctx)
```

サーブレットレスポンスにヘッダを設定する。

**パラメータ:**
- `res` - HTTPレスポンスオブジェクト
- `ctx` - 実行コンテキストオブジェクト

---

### replaceContentDisposition

```java
private String replaceContentDisposition(String dispositionValue, HttpServletRequest nativeReq)
```

Content-Dispositionに設定されたファイル名を、エンコーダを用いて変換する。

**パラメータ:**
- `dispositionValue` - Content-Dispositionヘッダの値
- `nativeReq` - サーブレットリクエスト

**戻り値:**
ファイル名がエンコードされたContent-Disposition

---

### writeBody

```java
public static void writeBody(InputStream in, HttpServletResponse nativeRes)
               throws IOException
```

メッセージボディの内容をクライアントに送信する。

**パラメータ:**
- `in` - 入力ストリームの内容
- `nativeRes` - サーブレットレスポンス

**例外:**
- `IOException` - ソケットI/Oにおけるエラー

---

### getFatalErrorResponse

```java
private HttpResponse getFatalErrorResponse()
```

どうしようも無いときのエラーレスポンスを作成する。

**戻り値:**
エラーレスポンス

---
