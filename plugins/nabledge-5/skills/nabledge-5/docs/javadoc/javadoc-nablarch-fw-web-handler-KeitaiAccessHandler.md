# class KeitaiAccessHandler

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- Handler<HttpRequest,HttpResponse>

---

```java
public class KeitaiAccessHandler
implements Handler<HttpRequest,HttpResponse>
```

携帯端末からのアクセスに対して、以下の処理を行うハンドラ。

<pre>
- 遷移先のJSPページで、javascriptを使用しないページを出力させる
  フラグ(nablarch_jsUnsupported)をリクエストスコープ変数に設定する。

- リクエストパラメータ中に"nablarch_uri_override_"で始まる名前のパラメータが
  存在した場合、パラメータ名中の残りの文字列でリクエストパスを置換する。
</pre>

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### rewriteHandler

```java
private final HttpRewriteHandler rewriteHandler
```

HTTPリクエスト・レスポンスの書き換えを行うハンドラ

---

### requestPathRewriteRule

```java
private final HttpRequestRewriteRule requestPathRewriteRule
```

HTTPリクエスト中のリクエストパスに対する書き換えルール

---

### JS_UNSUPPORTED_FLAG_NAME

```java
public static final String JS_UNSUPPORTED_FLAG_NAME
```

javascriptを使用できない端末を想定した挙動に変更する際に使用する
リクエストスコープ上のフラグ変数の名称

---

### URI_OVERRIDE_PRAM_PREFIX

```java
public static final String URI_OVERRIDE_PRAM_PREFIX
```

javascriptが利用できない場合に、遷移先URIおよび、submit_button パラメータの
値を保持するリクエストパラメータの接頭辞

---

## コンストラクタの詳細

### KeitaiAccessHandler

```java
public KeitaiAccessHandler()
```

デフォルトコンストラクタ

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

{@inheritDoc}
 本ハンドラに対する設定に従い、 {@link HttpRewriteHandler} による
 リクエストパスとコンテンツパスに対する書き換え処理を行う。

---
