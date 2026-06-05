# class PostResubmitPreventHandler

**パッケージ:** nablarch.fw.web.post

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class PostResubmitPreventHandler
implements HttpRequestHandler
```

POST再送信防止ハンドラ。
<p/>
本ハンドラでは、POSTで受け付けたリクエストに対して、
リダイレクトを使用し、再度リクエストを受け付けることで、
ブラウザの戻るボタンによるPOST再送信を防止する。
<p/>
リダイレクト後のGETリクエストが複数送信された場合には、{@link HttpErrorResponse}を送出する。
HTTPステータスコードには、BadRequestであることを示す{@code 400}を設定し、
遷移先のパスには{@link #setForwardPathMapping(Map)}で設定されたパスマッピングを元に設定する。<br/>
※複数送信されたリクエストのリクエストIDが、マッピング設定のキーから始まっている場合その値を遷移先とする。
リクエストIDが複数のキーから始まっている場合は、最も長いキーに対応する値を遷移先にする。<br/>
以下にマッピング例を示す。
<p/>
{@link #setForwardPathMapping(Map)}に設定された内容が以下表の場合、
リクエストIDがRW4444の場合は、遷移先のパスは/rw4_error.jspとなる。
リクエストIDがRW3333の場合は、遷移先のパスは/rw_error.jspとなる。
<pre>
----------- -----------------------------
キー        パス
----------- -----------------------------
R           /r_error.jsp
R1234       /r1234_error.jsp
RW          /rw_error.jsp
RW4         /rw4_error.jsp
----------- -----------------------------
</pre>
<p/>
ただし、multipartリクエストには未対応。
<p/>
本ハンドラは、{@code NablarchTagHandler}の手前に設定すること。

**作成者:** Kiyohito Itoh  
**非推奨:** アプリケーションで実装したほうが分かりやすく簡単に実装できるため、POST再送信を防止するには業務アクションにてリダイレクトのレスポンスを返すことで実現すること。  

---

## フィールドの詳細

### POST_RESUBMIT_PREVENT_PARAM

```java
public static final String POST_RESUBMIT_PREVENT_PARAM
```

POST再送信防止を指示するパラメータ

---

### POST_REDIRECT_ID_PARAM

```java
private static final String POST_REDIRECT_ID_PARAM
```

POST後にリダイレクトされたリクエストを識別するパラメータ

---

### POST_REQUEST_KEY_PREFIX

```java
private static final String POST_REQUEST_KEY_PREFIX
```

POST時のリクエスト情報をセッションスコープに格納する際に使用するキーのプレフィックス

---

### forwardPathMapping

```java
private Map<String,String> forwardPathMapping
```

リクエストIDと遷移先のパスマッピング

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

{@inheritDoc}
<p/>
処理フローは下記の通り。
<pre>
[1]POST再送信防止が指示されたリクエストであるか否かを判定する。

    POST再送信防止が指示されたリクエストである場合：
        リクエスト情報をセッションスコープに格納し、
        再度同じURIに対してリダイレクトする。

    POST再送信防止が指示されたリクエストでない場合：
        [2]に進む。

[2]POST後にリダイレクトされたリクエストであるか否かを判定する。

    POST後にリダイレクトされたリクエストである場合：
        セッションスコープに格納したリクエスト情報をリクエストに設定後、
        後続のハンドラを呼び出す。

    POST後にリダイレクトされたリクエストでない場合：
        後続のハンドラを呼び出す。
</pre>
各処理の詳細については、各メソッドのJavadocを参照。

---

### getForwardPath

```java
private String getForwardPath(String requestId)
```

遷移先のパスを取得する。

**パラメータ:**
- `requestId` - リクエストID

**戻り値:**
遷移先のパス

---

### isPostRedirect

```java
protected boolean isPostRedirect(HttpRequest request)
```

POST再送信防止が指示されたリクエストであるか否かを判定する。
<p/>
下記の条件をすべて満たす場合のみtrueを返す。
<pre>
・HTTPメソッドがPOSTであること
・POST再送信防止を指示するパラメータ({@link #POST_RESUBMIT_PREVENT_PARAM})が存在すること
</pre>

**パラメータ:**
- `request` - リクエスト

**戻り値:**
POST再送信防止が指示されたリクエストである場合はtrue

---

### createPostRequest

```java
protected PostRequest createPostRequest(HttpRequest request)
```

POST時のリクエスト情報を生成する。
<p/>
リクエスト情報として下記を取得する。
<pre>
・リクエストパラメータ
・マルチパート
</pre>

**パラメータ:**
- `request` - リクエスト

**戻り値:**
POST時のリクエスト情報

---

### generatePostRequestKey

```java
protected String generatePostRequestKey(String executionId)
```

POST時のリクエスト情報をセッションスコープに格納する際に使用するキーを生成する。
キーの形式は下記の通り。
<pre>
    nablarch_post_request_<実行時ID>
</pre>

**パラメータ:**
- `executionId` - 実行時ID

**戻り値:**
POST時のリクエスト情報をセッションスコープに格納する際に使用するキー

---

### generateRedirectPath

```java
protected String generateRedirectPath(HttpRequest request)
```

POST後のリダイレクトに使用するパスを生成する。
<p/>
パスの形式は下記の通り。
<pre>
    redirect://<リクエストURI>?nablarch_post_redirect_id=<実行時ID>
</pre>

**パラメータ:**
- `request` - リクエスト

**戻り値:**
POST後のリダイレクトに使用するパス

---

### isRedirectOnPost

```java
protected boolean isRedirectOnPost(HttpRequest request)
```

POST後にリダイレクトされたリクエストであるか否かを判定する。
<p/>
下記の条件をすべて満たす場合のみtrueを返す。
<pre>
・HTTPメソッドがGETであること
・リダイレクト時に付与したnablarch_post_redirect_idパラメータが存在すること
</pre>

**パラメータ:**
- `request` - リクエスト

**戻り値:**
POST後にリダイレクトされたリクエストである場合はtrue

---

### getPostRequest

```java
protected PostRequest getPostRequest(HttpRequest request, ExecutionContext context)
```

リダイレクト前にセッションスコープに格納したリクエスト情報を取得する。
<p/>
取得できない場合はnullを返す。<br/>
<br/>
POST後にリダイレクトされたリクエストを識別するパラメータ、
およびPOSTリクエストのリクエスト情報は、
ともに保持しているマップから削除する。

**パラメータ:**
- `request` - リクエスト
- `context` - 実行コンテキスト

**戻り値:**
リダイレクト前にセッションスコープに格納したリクエスト情報。取得できない場合はnull

---

### setForwardPathMapping

```java
public void setForwardPathMapping(Map<String,String> forwardPathMapping)
```

リクエストIDと遷移先パスのマッピングを設定する。
<p/>
MapのキーにはリクエストIDを識別する値を、値には遷移先のパスを設定する。

**パラメータ:**
- `forwardPathMapping` - マッピング

---
