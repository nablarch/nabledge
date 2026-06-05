# class MultipartHandler

**パッケージ:** nablarch.fw.web.upload

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class MultipartHandler
implements HttpRequestHandler
```

マルチパートを解析するハンドラ。<br/>
<p/>
<p>
本ハンドラは、サーブレットの入力ストリーム
（{@link jakarta.servlet.http.HttpServletRequest#getInputStream()}）から
リクエストのメッセージボディを読み込み、マルチパートの解析を行う。
HTTPリクエストがマルチパートでない場合（Content-Typeがmultipart/form-dataでない場合）、
何もせずに後続のハンドラに処理を委譲する。
</p>
<p>
解析結果は、{@link HttpRequest}に格納される。
アップロードファイルに関する情報は{@link HttpRequest#getPart(String)}で取得できる。
アップロードファイル以外のパラメータはHTTPリクエストパラメータに格納されるので、通常のように
{@link HttpRequest#getParamMap()}等で取得できる。
</p>
<p>
マルチパートの解析前はリクエストパラメータにアクセス出来ないため、
リクエストパラメータを扱う以下のハンドラは本ハンドラの後続に配置する必要がある。
<ul>
    <li>{@link nablarch.common.web.session.SessionStoreHandler}</li>
    <li>{@link nablarch.common.web.handler.NablarchTagHandler}</li>
</ul>
</p>
<p>
実際の解析処理は{@link MultipartParser}に委譲され、マルチパートの解析およびアップロードファイルの一時保存が行われる。
デフォルト設定では、一時ファイルは本ハンドラの処理終了時点（すなわちHTTPリクエストの処理終了時点）で削除される。
</p>
<p>
アップロードに関する各種設定は{@link UploadSettings}から取得する。
</p>

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### settings

```java
private UploadSettings settings
```

各種設定値

---

### COMPLETED_FLG_KEY

```java
private static final String COMPLETED_FLG_KEY
```

マルチパート処理状態を格納するキー値

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## メソッドの詳細

### setUploadSettings

```java
public void setUploadSettings(UploadSettings settings)
```

マルチパート用の各種設定値を設定する。

**パラメータ:**
- `settings` - 各種設定値

---

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

{@inheritDoc}

**パラメータ:**
- `request` - {@link HttpRequestWrapper}でなければならない。

---

### createParser

```java
MultipartParser createParser(HttpRequestWrapper wrapper, UploadSettings settings)
```

{@link MultipartParser}インスタンスを生成する。

**パラメータ:**
- `wrapper` - {@link HttpRequestWrapper}
- `settings` - {@link UploadSettings}

**戻り値:**
インスタンス

---

### cast

```java
private HttpRequestWrapper cast(HttpRequest request)
                        throws UnsupportedOperationException
```

{@link HttpRequest}を{@link HttpRequestWrapper}にキャストする。

**パラメータ:**
- `request` - キャスト対象のHttpRequest

**戻り値:**
キャスト後のインスタンス

**例外:**
- `UnsupportedOperationException` - キャストに失敗した場合。

---

### isParseCompleted

```java
private boolean isParseCompleted(ExecutionContext context)
```

マルチパートの解析処理が終了しているか否か。

**パラメータ:**
- `context` - 実行コンテキスト

**戻り値:**
解析が終了している場合は {@code true}

---

### cleanup

```java
private void cleanup(PartInfoHolder parts)
```

一時保存されたアップロードファイルを削除する。

**パラメータ:**
- `parts` - パート情報

---
