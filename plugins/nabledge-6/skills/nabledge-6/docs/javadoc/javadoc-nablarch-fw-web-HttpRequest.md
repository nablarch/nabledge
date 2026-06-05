# class HttpRequest

**パッケージ:** nablarch.fw.web

**実装されたインタフェース:**
- Request<String[]>
- Validatable<String[]>

---

```java
public abstract class HttpRequest
implements Request<String[]>, Validatable<String[]>
```

HTTP/1.1(RFC2616)におけるリクエストメッセージのパーサ及び
その結果を格納するデータオブジェクト。

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## フィールドの詳細

### DEFAULT_USER_AGENT_PARSER

```java
private static final UserAgentParser DEFAULT_USER_AGENT_PARSER
```

デフォルトの{@link UserAgentParser}実装クラス

---

### requestUri

```java
private String requestUri
```

HTTPリクエストURI

---

### multipart

```java
private Map<String,List<PartInfo>> multipart
```

マルチパート

---

## メソッドの詳細

### getMethod

```java
public abstract String getMethod()
```

HTTPリクエストメソッド名を返す。

**戻り値:**
リクエストメソッド名

---

### getRequestUri

```java
public String getRequestUri()
```

HTTPリクエストURIを返す。

**戻り値:**
リクエストURI

---

### setRequestUri

```java
public HttpRequest setRequestUri(String requestUri)
```

HTTPリクエストURIを設定する。

**パラメータ:**
- `requestUri` - リクエストURI

**戻り値:**
本オブジェクト

---

### getRequestPath

```java
public String getRequestPath()
```

HTTPリクエストURIのパス部分(クエリストリングを除いた部分)を返す。

**戻り値:**
HTTPリクエストURIのパス部分

---

### setRequestPath

```java
public HttpRequest setRequestPath(String requestPath)
```

リクエストパスを設定する。
<p/>
この実装では、リクエストURI中のリクエストパスを書き換える。

**パラメータ:**
- `requestPath` - リクエストパス

**戻り値:**
本オブジェクト

---

### getHttpVersion

```java
public abstract String getHttpVersion()
```

HTTPバージョン名を返す。

**戻り値:**
HTTPバージョン名

---

### getParamMap

```java
public abstract Map<String,String[]> getParamMap()
```

リクエストパラメータのMapを返す。
<pre>
HTTPリクエストメッセージ中の以下のパラメータを格納したMapを返す。
  1. リクエストURI中のクエリパラメータ
  2. メッセージボディ内のPOSTパラメータ
パラメータ名は重複する可能性があるので、値の型はString[]で定義されている。
</pre>

**戻り値:**
リクエストパラメータのMap

---

### getParam

```java
public abstract String[] getParam(String name)
```

リクエストパラメータを取得する。

**パラメータ:**
- `name` - パラメータ名

**戻り値:**
パラメータの値

---

### setParam

```java
public abstract HttpRequest setParam(String name, String params)
```

リクエストパラメータを設定する。

**パラメータ:**
- `name` - パラメータ名
- `params` - パラメータの値

**戻り値:**
本オブジェクト

---

### setParamMap

```java
public abstract HttpRequest setParamMap(Map<String,String[]> params)
```

リクエストパラメータを設定する。

**パラメータ:**
- `params` - リクエストパラメータのMap

**戻り値:**
本オブジェクト

---

### getHeaderMap

```java
public abstract Map<String,String> getHeaderMap()
```

HTTPリクエストヘッダを格納したMapを取得する。

**戻り値:**
HTTPリクエストヘッダのMap

---

### getHeader

```java
public abstract String getHeader(String headerName)
```

HTTPリクエストヘッダの値を返す。

**パラメータ:**
- `headerName` - リクエストヘッダ名

**戻り値:**
HTTPリクエストヘッダの値

---

### getHost

```java
public String getHost()
```

HTTPリクエストのホストヘッダを取得する。

**戻り値:**
ホストヘッダ

---

### getCookie

```java
public abstract HttpCookie getCookie()
```

本リクエストで送信されるクッキー情報を取得する。

**戻り値:**
クッキー情報オブジェクト

---

### getPart

```java
public List<PartInfo> getPart(String name)
```

マルチパートの一部を取得する。
<p/>
引数で指定した名称に合致するパートが存在しない場合、空のリストが返却される。

**パラメータ:**
- `name` - 名称(inputタグのname属性)

**戻り値:**
マルチパート

---

### setMultipart

```java
public void setMultipart(Map<String,List<PartInfo>> multipart)
```

マルチパートを設定する。

**パラメータ:**
- `multipart` - マルチパート

---

### getMultipart

```java
public Map<String,List<PartInfo>> getMultipart()
```

本HTTPリクエストの全マルチパートを取得する。
<p/>
戻り値のMapの構造を以下に示す。
<dl>
<dt>キー</dt>
<dl>名称(inputタグのname属性)</dl>
<dt>値</dt>
<dl>キーのname属性でアップロードされたマルチパート</dl>
</dl>

**戻り値:**
全マルチパート

---

### getUserAgent

```java
public UA getUserAgent()
```

UserAgent情報を取得する。
<p/>
HTTPヘッダ("User-Agent")よりUser-Agent文字列を取得し、
{@link SystemRepository}に設定された{@link UserAgentParser}(コンポーネント名"userAgentParser")で解析を行う。
<br/>
パーサーが取得できない場合は、
全ての項目にデフォルト値が設定された{@link UserAgent}オブジェクトが返却される。

**パラメータ:**
- `<UA>` - userAgentの型

**戻り値:**
UserAgentオブジェクト

---

### getUserAgentParser

```java
private UserAgentParser getUserAgentParser()
```

{@link UserAgentParser}実装クラスのインスタンスを取得する。

**戻り値:**
{@link UserAgentParser}実装クラスのインスタンス

---
