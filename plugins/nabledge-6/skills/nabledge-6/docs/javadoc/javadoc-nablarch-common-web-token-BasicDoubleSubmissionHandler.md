# class BasicDoubleSubmissionHandler

**パッケージ:** nablarch.common.web.token

**実装されたインタフェース:**
- DoubleSubmissionHandler

---

```java
public class BasicDoubleSubmissionHandler
implements DoubleSubmissionHandler
```

{@link DoubleSubmissionHandler}の基本実装クラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### path

```java
private String path
```

二重サブミットと判定した場合の遷移先のリソースパス

---

### messageId

```java
private String messageId
```

二重サブミットと判定した場合の遷移先画面に表示するエラーメッセージに使用するメッセージID

---

### statusCode

```java
private int statusCode
```

二重サブミットと判定した場合のレスポンスステータス

---

## メソッドの詳細

### setPath

```java
public void setPath(String path)
```

二重サブミットと判定した場合の遷移先のリソースパスを設定する。<br>
{@link OnDoubleSubmission}アノテーションで個別に指定していない場合は、ここに指定したリソースパスを使用する。

**パラメータ:**
- `path` - 二重サブミットと判定した場合の遷移先のリソースパス

---

### setMessageId

```java
public void setMessageId(String messageId)
```

二重サブミットと判定した場合の遷移先画面に表示するエラーメッセージに使用するメッセージIDを設定する。
{@link OnDoubleSubmission}アノテーションで個別に指定していない場合は、ここに指定したメッセージIDを使用する。

**パラメータ:**
- `messageId` - 二重サブミットと判定した場合の遷移先画面に表示するエラーメッセージに使用するメッセージID

---

### setStatusCode

```java
public void setStatusCode(int statusCode)
```

二重サブミットと判定した場合のレスポンスステータスを設定する。
{@link OnDoubleSubmission}アノテーションで個別に指定していない場合は、ここに指定したレスポンスステータスを使用する。
デフォルトは400。

**パラメータ:**
- `statusCode` - 二重サブミットと判定した場合のレスポンスステータス

---

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context, Handler<HttpRequest,HttpResponse> originalHandler, OnDoubleSubmission annotation)
```

{@inheritDoc}
<pre>
{@link HttpErrorResponse}を生成して返す。

{@link OnDoubleSubmission}アノテーションの属性が指定されている場合は、アノテーションの属性を使用する。
アノテーションの属性が指定されていない場合は、自身に設定されている値を使用する。

メッセージIDが指定されていない場合は、メッセージの取得を行わない。
</pre>

---
