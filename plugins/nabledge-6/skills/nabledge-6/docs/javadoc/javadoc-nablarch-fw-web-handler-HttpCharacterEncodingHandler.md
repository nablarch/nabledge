# class HttpCharacterEncodingHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class HttpCharacterEncodingHandler
implements Handler<Object,Object>
```

HTTP エンコーディング制御ハンドラ。

<pre>
#setDefaultEncoding(String) に指定されたエンコーディングを HttpServletRequest/HttpServletResponse に対して設定する。
明示的に設定しない場合は"UTF-8"を使用する。
</pre>

**作成者:** Toru Nagashima  

---

## フィールドの詳細

### defaultEncoding

```java
private Charset defaultEncoding
```

デフォルトエンコーディング

---

### appendResponseCharacterEncoding

```java
private boolean appendResponseCharacterEncoding
```

レスポンスのContent-Typeに「;charset=xx」を付加するかのフラグ(false:付加しない)

---

## コンストラクタの詳細

### HttpCharacterEncodingHandler

```java
public HttpCharacterEncodingHandler()
```

デフォルトコンストラクタ。

---

## メソッドの詳細

### setDefaultEncoding

```java
public void setDefaultEncoding(String name)
```

デフォルトエンコーディングを設定する。<br />

**パラメータ:**
- `name` - エンコーディング名

---

### setDefaultEncodingCharset

```java
public void setDefaultEncodingCharset(Charset encoding)
```

デフォルトエンコーディングを設定する。<br />

**パラメータ:**
- `encoding` - エンコーディング

---

### getDefaultEncoding

```java
public Charset getDefaultEncoding()
```

デフォルトエンコーディングを取得する。<br />

**戻り値:**
エンコーディング

---

### setAppendResponseCharacterEncoding

```java
public void setAppendResponseCharacterEncoding(boolean appendResponseCharacterEncoding)
```

レスポンスのContent-Typeに「;charset=xx」を付加するかのフラグを設定する。<br />

**パラメータ:**
- `appendResponseCharacterEncoding` - フラグ

---

### handle

```java
public Object handle(Object data, ExecutionContext context)
```

エンコーディングを設定する。<br />

本ハンドラは以下の手順で処理を行う。
<ol>
<li>{@link #resolveRequestEncoding(HttpServletRequest)} で解決したエンコーディングを HttpServletRequest に設定する。</li>
<li>{@link #resolveResponseEncoding(HttpServletRequest)} で解決したエンコーディングを HttpServletResponse に設定する。</li>
<li>後続のハンドラに処理を委譲する。</li>
</ol>

**パラメータ:**
- `data` - 入力データ
- `context` - 実行コンテキスト

**戻り値:**
処理結果データ

---

### resolveRequestEncoding

```java
protected Charset resolveRequestEncoding(HttpServletRequest request)
```

リクエストのエンコーディングを解決する。<br />
<pre>
本ハンドラでは設定されているデフォルトエンコーディングを返却する。
URI 等のリクエスト情報によってエンコーディングを切り替える必要がある場合は、
本メソッドを拡張し、エンコーディングを解決する処理を実装すること。

ただし、本メソッド内ではリクエストパラメータの取得を行ってはならない。
リクエストパラメータの取得を行ってしまうと、エンコーディングの指定が行えなくなってしまうので、
文字化けの原因となる。
</pre>

**パラメータ:**
- `request` - リクエスト

**戻り値:**
リクエストのエンコーディング

---

### resolveResponseEncoding

```java
protected Charset resolveResponseEncoding(HttpServletRequest request)
```

レスポンスのエンコーディングを解決する。<br />
<pre>
本ハンドラでは設定されているデフォルトエンコーディングを返却する。
URI 等のリクエスト情報によってエンコーディングを切り替える必要がある場合は、
本メソッドを拡張し、エンコーディングを解決する処理を実装すること。

ただし、本メソッド内ではリクエストパラメータの取得を行ってはならない。
リクエストパラメータの取得を行ってしまうと、エンコーディングの指定が行えなくなってしまうので、
文字化けの原因となる。
</pre>

**パラメータ:**
- `request` - リクエスト

**戻り値:**
レスポンスのエンコーディング

---
