# class FormUrlEncodedConverter

**パッケージ:** nablarch.fw.jaxrs

**継承階層:**
```
java.lang.Object
  └─ BodyConverterSupport
      └─ nablarch.fw.jaxrs.FormUrlEncodedConverter
```

---

```java
public class FormUrlEncodedConverter
extends BodyConverterSupport
```

"application/x-www-form-urlencoded"に対するリクエスト/レスポンスの変換を行うクラス。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### convertRequest

```java
protected Object convertRequest(HttpRequest request, ExecutionContext context)
```

---

### convertResponse

```java
protected HttpResponse convertResponse(Object response, ExecutionContext context)
```

---

### encode

```java
private String encode(String str, Charset encoding)
```

指定された文字列に対してURLエンコードを行う。

**パラメータ:**
- `str` - 文字列
- `encoding` - エンコーディング

**戻り値:**
URLエンコード後の文字列

---

### castResponse

```java
private MultivaluedMap<String,String> castResponse(Object response, JaxRsContext context)
```

レスポンスオブジェクトを{@link MultivaluedMap}にキャストする。
<p>
キャストできない場合は{@link IllegalStateException}をスローする。

**パラメータ:**
- `response` - レスポンスオブジェクト
- `context` - {@link JaxRsContext}

**戻り値:**
キャスト後のオブジェクト

---

### isConvertible

```java
public boolean isConvertible(String mediaType)
```

---
