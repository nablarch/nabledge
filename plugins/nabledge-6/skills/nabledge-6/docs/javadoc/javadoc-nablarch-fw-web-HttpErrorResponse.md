# class HttpErrorResponse

**パッケージ:** nablarch.fw.web

**継承階層:**
```
java.lang.Object
  └─ RuntimeException
      └─ nablarch.fw.web.HttpErrorResponse
```

---

```java
public class HttpErrorResponse
extends RuntimeException
```

エラーレスポンスを行う際に送出する例外。<br>
エラー時遷移先画面のパス・ステータスコードなど、HttpResponseと同等の情報を指定することができる。
リクエストプロセッサがこのクラスを捕捉した場合、保持しているHttpResponseオブジェクトの内容にしたがって
レスポンス処理が行われる。
注意: 透過的トランザクションハンドラ:nablarch.common.handler.TransactionManagementHandlerを適用している場合、
ユーザエラーをHttpResponseオブジェクトで返却してしまうとロールバックされない。
HttpErrorResponseを送出することで、ユーザエラーを返しつつ、
トランザクションをロールバックすることが可能となる。

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  
**関連項目:** HttpResponse  

---

## フィールドの詳細

### response

```java
private HttpResponse response
```

レスポンス情報

---

## コンストラクタの詳細

### HttpErrorResponse

```java
public HttpErrorResponse()
```

デフォルトコンストラクタ。
<pre>
ステータスコードは400(Bad Request)を使用する。
このコンストラクタの処理は、以下のコードと同等である。
    new HttpErrorResponse(400);
</pre>

---

### HttpErrorResponse

```java
public HttpErrorResponse(Throwable e)
```

元例外を指定するコンストラクタ。
<pre>
ステータスコードは400(Bad Request)を使用する。
このコンストラクタの処理は、以下のコードと同等である。
    new HttpErrorResponse(400, e);
</pre>

**パラメータ:**
- `e` - Throwable

---

### HttpErrorResponse

```java
public HttpErrorResponse(String contentPath)
```

コンテンツのパスを指定するコンストラクタ。
<pre>
ステータスコードは400(Bad Request)を使用する。
このコンストラクタの処理は、以下のコードと同等である。
    new HttpErrorResponse(400, "/error.jsp");
</pre>

**パラメータ:**
- `contentPath` - レスポンスボディに出力するコンテンツのパス

---

### HttpErrorResponse

```java
public HttpErrorResponse(String contentPath, Throwable e)
```

コンテンツのパスと元例外を指定するコンストラクタ。
<pre>
ステータスコードは400(Bad Request)を使用する。
このコンストラクタの処理は、以下のコードと同等である。
    new HttpErrorResponse(400, "/error.jsp", e);
</pre>

**パラメータ:**
- `contentPath` - レスポンスボディに出力するコンテンツのパス
- `e` - Throwable

---

### HttpErrorResponse

```java
public HttpErrorResponse(int statusCode)
```

指定されたステータスコードでエラーレスポンスを返す例外を生成する。

**パラメータ:**
- `statusCode` - ステータスコード

---

### HttpErrorResponse

```java
public HttpErrorResponse(int statusCode, Throwable e)
```

指定されたステータスコードでエラーレスポンスを返す例外を生成する。

**パラメータ:**
- `statusCode` - ステータスコード
- `e` - 元例外

---

### HttpErrorResponse

```java
public HttpErrorResponse(int statusCode, String contentPath)
```

指定されたステータスコード・コンテンツパスでエラーレスポンスを返す例外を生成する。

**パラメータ:**
- `statusCode` - ステータスコード
- `contentPath` - レスポンスボディに出力するコンテンツのパス

---

### HttpErrorResponse

```java
public HttpErrorResponse(int statusCode, String contentPath, Throwable e)
```

指定されたステータスコード・コンテンツパスでエラーレスポンスを返す例外を生成する。

**パラメータ:**
- `statusCode` - ステータスコード
- `contentPath` - レスポンスボディに出力するコンテンツのパス
- `e` - 元例外

---

### HttpErrorResponse

```java
public HttpErrorResponse(HttpResponse response)
```

指定された{@link HttpResponse}を持つ{@code HttpErrorResponse}を生成する。

**パラメータ:**
- `response` - {@link HttpResponse}

---

### HttpErrorResponse

```java
public HttpErrorResponse(HttpResponse response, Throwable e)
```

指定された{@link HttpResponse}と例外を持つ{@code HttpErrorResponse}を生成する。

**パラメータ:**
- `response` - {@link HttpResponse}
- `e` - 元例外

---

## メソッドの詳細

### getResponse

```java
public HttpResponse getResponse()
```

レスポンス情報を取得する。

**戻り値:**
レスポンス情報。

---

### setResponse

```java
public HttpErrorResponse setResponse(HttpResponse response)
```

レスポンス情報を設定する。

**パラメータ:**
- `response` - レスポンス情報

**戻り値:**
このオブジェクト自身

---
