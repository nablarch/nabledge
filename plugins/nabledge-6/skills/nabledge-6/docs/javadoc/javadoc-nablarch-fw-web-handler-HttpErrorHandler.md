# class HttpErrorHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class HttpErrorHandler
implements HttpRequestHandler
```

共通エラーハンドラー。
<pre>
HttpResponse/HttpErrorResponse のHTTPエラーコードに対応した
エラー画面に遷移させる。
また、実行時例外を捕捉し、システムエラー画面に遷移させる。
</pre>

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### writeFailureLogPattern

```java
protected Pattern writeFailureLogPattern
```

---

### DOCROOT

```java
private static final String DOCROOT
```

デフォルトページのドキュメントルート

---

### defaultPages

```java
private final Map<String,ResourceLocator> defaultPages
```

既定のデフォルトページ

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest req, ExecutionContext ctx)
```

{@inheritDoc}

---

### setDefaultPage

```java
public HttpErrorHandler setDefaultPage(String statusCode, String contentPath)
```

レスポンスステータスコードごとのデフォルトページを設定する。

HttpResponseオブジェクトのボディ内容(contentPath/contentBody)が設定されていない場合、
ここでステータスコード毎に設定したデフォルトページがボディとしてレスポンスされる。
設定は後から設定した内容ほど優先される。
ステータスコードには1桁分のワイルドカードとして "." を使用することができる。

設定例::
<pre>
  // デフォルトページ定義
  setDefaultPage("303", "file:///www/docroot/redirecting.html");
  setDefaultPage("4..", "servlet://jsp/errors/userError.jsp");
  setDefaultPage("5..", "servlet://jsp/errors/systemError.jsp");
</pre>

デフォルトページの設定を行わない場合、
web.xmlに定義されているエラーページに遷移する。

**パラメータ:**
- `statusCode` - ステータスコードのパターン
- `contentPath` - デフォルトページのコンテンツパス

**戻り値:**
このオブジェクト自体

---

### setDefaultPages

```java
public HttpErrorHandler setDefaultPages(Map<String,String> defaultPages)
```

レスポンスステータスコードごとのデフォルトページを設定する。

**パラメータ:**
- `defaultPages` - デフォルトページ設定

**戻り値:**
このオブジェクト自体

---

### getDefaultPageFor

```java
public ResourceLocator getDefaultPageFor(int statusCode)
```

指定されたステータスコードに対するデフォルトページのコンテンツパスを返す。

**パラメータ:**
- `statusCode` - ステータスコード

**戻り値:**
デフォルト画面のコンテンツパス

---

### matchingScore

```java
private int matchingScore(String aStr, String bStr)
```

一致文字数を計数する。

**パラメータ:**
- `aStr` - 基準文字列
- `bStr` - 比較対象文字列

**戻り値:**
一致する文字数

---

### setWriteFailureLogPattern

```java
public void setWriteFailureLogPattern(String writeFailureLogPattern)
```

{@link #handle(nablarch.fw.web.HttpRequest, nablarch.fw.ExecutionContext)}で、{@link Result.Error}を補足した際に、
障害通知ログを出力する必要のあるステータスコードを正規表現で設定する。

ここで設定した正規表現が、{@link nablarch.fw.Result.Error#getStatusCode()}にマッチした場合のみ、
障害通知ログが出力され障害として検知される。
なお、本設定を省略した場合のデフォルト動作では、{@code 5([1-9][0-9]|0[012456789])}に一致するステータスコードが障害通知ログの出力対象となる。

**パラメータ:**
- `writeFailureLogPattern` - 障害通知対象のステータスコードを表す正規表現

---
