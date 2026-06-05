# class RestMockHttpRequest

**パッケージ:** nablarch.fw.web

**継承階層:**
```
java.lang.Object
  └─ MockHttpRequest
      └─ nablarch.fw.web.RestMockHttpRequest
```

---

```java
public class RestMockHttpRequest
extends MockHttpRequest
```

RESTfulウェブサービステスト用の{@link HttpRequest}モッククラス。

---

## フィールドの詳細

### LS

```java
private static final String LS
```

改行文字

---

### bodyConverters

```java
private final Collection<? extends RestTestBodyConverter> bodyConverters
```

bodyを書き出すために利用可能な{@link RestTestBodyConverter}

---

### defaultContentType

```java
private final String defaultContentType
```

デフォルトContent-Type

---

### body

```java
private Object body
```

リクエストボディ

---

### CONTENT_TYPE_KEY

```java
private static final String CONTENT_TYPE_KEY
```

Content-Typeヘッダーのキー

---

### CONTENT_LENGTH_KEY

```java
private static final String CONTENT_LENGTH_KEY
```

Content-Lengthヘッダーのキー

---

## コンストラクタの詳細

### RestMockHttpRequest

```java
public RestMockHttpRequest(Collection<? extends RestTestBodyConverter> bodyConverters, String defaultContentType)
```

引数で渡された{@link RestTestBodyConverter}の{@link Collection}とデフォルトContent-Typeを持つオブジェクトを生成する。

**パラメータ:**
- `bodyConverters` - 利用可能な{@link RestTestBodyConverter}
- `defaultContentType` - デフォルトContent-Type

---

## メソッドの詳細

### getBody

```java
public Object getBody()
```

ボディを取得する。

**戻り値:**
リクエストボディ

---

### setBody

```java
public RestMockHttpRequest setBody(Object body)
```

リクエストボディを設定する。

**パラメータ:**
- `body` - リクエストボディに設定するオブジェクト

**戻り値:**
{@link RestMockHttpRequest}自身

---

### getMediaType

```java
private RestTestBodyConverter.MediaType getMediaType()
```

Content-TypeヘッダーからMIMEタイプを取得する。

**戻り値:**
MIMEタイプ

---

### setContentType

```java
public RestMockHttpRequest setContentType(String contentType)
```

Content-Typeを設定する。

**パラメータ:**
- `contentType` - Content-Typeに設定する値

**戻り値:**
{@link RestMockHttpRequest}自身

---

### setMethod

```java
public RestMockHttpRequest setMethod(String method)
```

---

### setHeaderMap

```java
public RestMockHttpRequest setHeaderMap(Map<String,String> headers)
```

---

### setHeader

```java
public RestMockHttpRequest setHeader(String headerName, String value)
```

HTTPリクエストヘッダの値を設定する。

**パラメータ:**
- `headerName` - リクエストヘッダ名
- `value` - リクエストヘッダに設定する値

**戻り値:**
このオブジェクト自体

---

### setRequestUri

```java
public RestMockHttpRequest setRequestUri(String requestPath)
```

---

### setParam

```java
public RestMockHttpRequest setParam(String name, String params)
```

---

### setParamMap

```java
public RestMockHttpRequest setParamMap(Map<String,String[]> params)
```

---

### setCookie

```java
public RestMockHttpRequest setCookie(HttpCookie cookie)
```

---

### setHttpVersion

```java
public RestMockHttpRequest setHttpVersion(String httpVersion)
```

---

### setHost

```java
public RestMockHttpRequest setHost(String host)
```

---

### setRequestPath

```java
public RestMockHttpRequest setRequestPath(String requestPath)
```

---

### toString

```java
public String toString()
```

---

### setContentLength

```java
private void setContentLength(Map<String,String> headers, String bodyStr)
```

引数で渡されたヘッダーMapに Content-Length をセットする。
誤った Content-Length が設定されていた場合は例外を送出する。

**パラメータ:**
- `headers` - ヘッダー
- `bodyStr` - リクエストボディ

---

### concatParams

```java
private String concatParams(Map<String,String[]> paramMap)
```

リクエストパラメータのMapを"key=value(&key=value...)"の形式で結合する。

**パラメータ:**
- `paramMap` - リクエストパラメータ

**戻り値:**
結合されたリクエストパラメータ

---

### urlEncode

```java
private String urlEncode(String uri)
```

リクエストURIをURLエンコードする。

**パラメータ:**
- `uri` - リクエストURI

**戻り値:**
URLエンコードされたリクエストURI

---

### convertBody

```java
private String convertBody()
```

リクエストボディを{@link String}に変換する。

**戻り値:**
リクエストボディの文字列

---

### findBodyConverter

```java
private RestTestBodyConverter findBodyConverter(RestTestBodyConverter.MediaType mediaType)
```

MIMEタイプに合った{@link RestTestBodyConverter}を見つける。

**戻り値:**
見つかった{@link HttpBodyWriter}

---
