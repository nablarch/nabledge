# class FileResponse

**パッケージ:** nablarch.common.web.download

**継承階層:**
```
java.lang.Object
  └─ HttpResponse
      └─ nablarch.common.web.download.FileResponse
```

---

```java
public class FileResponse
extends HttpResponse
```

{@link File}オブジェクトからHTTPレスポンスを生成する{@link HttpResponse}継承クラス。

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### file

```java
private final File file
```

ダウンロードするファイル

---

### deleteOnCleanup

```java
private final boolean deleteOnCleanup
```

リクエスト処理の終了時に自動的にファイルを削除するか否か

---

## コンストラクタの詳細

### FileResponse

```java
public FileResponse(File file)
```

コンストラクタ。
<p/>
本コンストラクタを使用してインスタンスを生成した場合、
リクエスト処理の終了時に自動的にファイルは削除されない。

**パラメータ:**
- `file` - ファイル

---

### FileResponse

```java
public FileResponse(File file, boolean deleteOnCleanup)
```

コンストラクタ。

**パラメータ:**
- `file` - ファイル
- `deleteOnCleanup` - リクエスト処理の終了時に自動的にファイルを削除する場合は{@code true}

---

## メソッドの詳細

### getContentLength

```java
public String getContentLength()
```

---

### isBodyEmpty

```java
public boolean isBodyEmpty()
```

{@inheritDoc}
<p/>
本クラスをインスタンス化する際にはボディを表す{@link File}オブジェクトの指定が必須なため、
本メソッドは必ず{@code false}を返す。

**戻り値:**
必ず{@link false}を返す

---

### getBodyString

```java
public String getBodyString()
```

---

### getBodyStream

```java
public InputStream getBodyStream()
```

---

### toString

```java
public String toString()
```

---

### cleanup

```java
public HttpResponse cleanup()
```

---

### getContentPath

```java
public ResourceLocator getContentPath()
```

{@inheritDoc}
<p/>
本クラスではコンテンツパスを設定できないため、
本メソッドは必ず{@code null}を返す。

**戻り値:**
必ず{@code null}を返す。

---

### setBodyStream

```java
public HttpResponse setBodyStream(InputStream bodyStream)
```

---

### setContentPath

```java
public HttpResponse setContentPath(String path)
```

---

### setContentPath

```java
public HttpResponse setContentPath(ResourceLocator resource)
```

---

### write

```java
public HttpResponse write(CharSequence text)
```

---

### write

```java
public HttpResponse write(byte[] bytes)
```

---

### write

```java
public HttpResponse write(ByteBuffer bytes)
```

---
