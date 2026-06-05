# class ResourceLocator

**パッケージ:** nablarch.fw.web

---

```java
public final class ResourceLocator
```

各種リソースを識別する為の文字列（リソースロケータ）をパースして格納するクラス。
<p/>
<pre>
リソースロケータとは、本フレームワークにおいて、何らかのリソースを指定する際に用いられる汎用的書式である。
以下のように定義される。
  (スキーム名)://(ディレクトリパス)/(リソース名)

リソースロケータの使用場面例
- HTTPレスポンスの内容を格納したリソースを指定するケース

  // 業務Actionから"jsp/success.jsp" に対してフォーワード
  new HttpResponse("200", "servlet://jsp/success.jsp");

現時点でサポートされるスキームは以下の5つである。

1. 静的ファイル
   ファイルシステム上の静的ファイルの内容を出力する。
   絶対パスもしくは相対パスで指定することが可能である。
    (書式)
        file://(コンテンツファイルへのパス)
    (例)
        file://./webapps/style/common.css    (相対パス)
        file:///www/docroot/style/common.css (絶対パス)

2. Javaコンテキストクラスローダ上のリソース
   コンテキストクラスローダ上のリソースの内容を出力する。
    (書式)
        classpath://(Javaリソース名)
    (例)
        classpath://nablarch/sample/webapp/common.css

  classpath指定は、ファイルシステム上に存在しているファイルのみ指定できる。
  このため、jarなどでアーカイブされたファイルについてはclasspathを指定することは出来ない。
  また、バーチャルファイルシステムを用いてファイルを管理するようなWebアプリケーションサーバの場合、
  ファイルシステム上に存在しているファイルの場合でも、classpathの指定は出来ない。

  このため、classpathではなく静的ファイル(file://)の使用を推奨する。

3. 内部フォーワード
   リクエストプロセッサに対して、指定したリクエストURIでの再処理を要求する。
   HttpRequest・ExecutionContextはそのまま流用される。
    (書式)
        forward://(フォーワード名)
    (例)
        forward://registerForm.html           (現在のURIからの相対パス)
        forward:///app/user/registerForm.html (絶対パス)

4. サーブレットフォーワード
   サーブレットコンテナに対してフォーワードを行う。
   この場合、レスポンスの出力処理自体がフォーワード先のサーブレットに委譲される。
    (書式)
        servlet://(フォーワード名)
    (例)
        servlet://jsp/index.jsp   (現在のページからの相対パス)
        servlet:///jsp/index.jsp  (サーブレットコンテキストを起点とする相対パス)


5. リダイレクト
   この場合は、指定されたパスへのリダイレクションを指示するレスポンスを行う。
    (書式)
        redirect://(リダイレクト先パス)
        http(s)://(リダイレクト先URL)
        redirect:(リダイレクト先の絶対URL)
    (例)
        redirect://login             (現在のページからの相対パス)
        redirect:///UserAction/login (サーブレットコンテキストを起点とする相対パス)
        http://www.example.com/login (外部サイトのURL)
        redirect:myapp://example.com (モバイルアプリのカスタムスキームを持つURL)

このクラスは不変クラスである。
</pre>

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## フィールドの詳細

### LOG

```java
private static final Logger LOG
```

ログ

---

### DEFAULT_SCHEME

```java
private static final String DEFAULT_SCHEME
```

デフォルトスキーム

---

### SCHEMES

```java
public static final String SCHEMES
```

対応するスキーム名

---

### ALLOWED_SCHEMES

```java
private static final Pattern ALLOWED_SCHEMES
```

許可スキームパターン

---

### EXTRACT_SCHEME_PATTERN

```java
private static final Pattern EXTRACT_SCHEME_PATTERN
```

スキームを抽出するための正規表現

---

### EXTRACT_HOSTNAME_PATTERN

```java
private static final Pattern EXTRACT_HOSTNAME_PATTERN
```

ホスト名を抽出するための正規表現

---

### ALLOWED_CHAR

```java
public static final Pattern ALLOWED_CHAR
```

コンテンツパス中のディレクトリとして許容される文字列。
<p/>
<pre>
"/", "~" はNG。
2以上連続する"."もNG。
</pre>

---

### contentPath

```java
private final String contentPath
```

コンテンツのパス

---

### scheme

```java
private final String scheme
```

リソースパスのスキーム名

---

### path

```java
private final String path
```

パス

---

### resourceName

```java
private final String resourceName
```

リソース名

---

### hostname

```java
private final String hostname
```

ホスト名

---

### directory

```java
private final String directory
```

ディレクトリ

---

### redirectWithAbsoluteUri

```java
private final boolean redirectWithAbsoluteUri
```

絶対URIを伴うリダイレクトかどうかを表すフラグ

---

## コンストラクタの詳細

### ResourceLocator

```java
private ResourceLocator(String path)
```

リソースの文字列表現からオブジェクトを生成する。

**パラメータ:**
- `path` - リソースの文字列表現

---

## メソッドの詳細

### valueOf

```java
public static ResourceLocator valueOf(String path)
```

リソースの文字列表現から{@code ResourceLocator}オブジェクトを生成する。
<p/>
{@value SCHEMES}に含まれないスキームを指定した場合、スキームは常に「servlet」となる。

**パラメータ:**
- `path` - リソースの文字列表現

**戻り値:**
生成されたオブジェクト

**例外:**
- `HttpErrorResponse` - リソースパスが無効な書式である場合

---

### isRedirectWithAbsoluteUri

```java
boolean isRedirectWithAbsoluteUri()
```

絶対URIを伴うリダイレクトかどうかを表すフラグを返す。

このメソッドはnablarch-fw-web内部からのみの使用を想定しており、
package privateにしている。

**戻り値:**
絶対URIを伴うリダイレクトかどうかを表すフラグ

---

### isHttpScheme

```java
private boolean isHttpScheme()
```

自身のスキームがhttp(https)スキームかどうかを返す。

**戻り値:**
http(https)の場合は{@code true}

---

### getScheme

```java
public String getScheme()
```

このリソースパスのスキーム名を返す。

**戻り値:**
スキーム名

---

### isRelative

```java
public boolean isRelative()
```

設定されたパスが相対パスかどうか。

**戻り値:**
相対パス表記であれば{@code true}。
         コンテキストクラスローダ上のリソースである場合、常に{@code false}

---

### getResourceName

```java
public String getResourceName()
```

リソース名を返す。

**戻り値:**
リソース名

---

### getPath

```java
public String getPath()
```

パス文字列を返す。

パスにクエリーパラメータやフラグメントがある場合、
これらを含んだ値をパスとして返す。

**戻り値:**
パス文字列

---

### toString

```java
public String toString()
```

{@inheritDoc}
リソースパスの文字列表現そのものを返す。

---

### getRealPath

```java
public String getRealPath()
                   throws UnsupportedOperationException
```

リソースのファイルシステム上での絶対パスを返す。

**戻り値:**
絶対パスを返す。絶対パスが取得できない場合{@code null}を返す

**例外:**
- `UnsupportedOperationException` - 静的ファイルでもクラスローダ上のリソースでもない場合

---

### exists

```java
public boolean exists()
```

このリソースの実体が存在するかどうか判定する。

**戻り値:**
このリソースの実体が存在する場合は{@code true}。
         内部フォーワード/サーブレットフォーワードの場合は常に{@code true}。
         リダイレクトである場合は常に{@code false}

---

### getReader

```java
public Reader getReader()
                 throws FileNotFoundException
```

リソースの内容を読み出すための{@link Reader}を返す。

**戻り値:**
リソースの内容を読み出すためのReader

**例外:**
- `FileNotFoundException` - 静的ファイルでもクラスローダ上のリソースでもない場合か、
                               静的ファイルかクラスローダ上のリソースだが絶対パスを取得できなかった場合

---

### getInputStream

```java
public InputStream getInputStream()
                           throws FileNotFoundException
```

リソースの内容をストリームで読み出すための{@link InputStream}を返す。

**戻り値:**
リソースの内容を読み出すためのInputStream

**例外:**
- `FileNotFoundException` - 静的ファイルでもクラスローダ上のリソースでもない場合か、
                               静的ファイルかクラスローダ上のリソースだが絶対パスを取得できなかった場合

---

### isRedirect

```java
public boolean isRedirect()
```

レスポンスがリダイレクトかどうか判定する。

**戻り値:**
レスポンスがリダイレクトであれば{@code true}

---

### getHostname

```java
public String getHostname()
```

パスのホスト部を返す。

ポート番号が設定されている場合には、ポート番号を含んだ値を返す。

**戻り値:**
パスのホスト部

---

### getDirectory

```java
public String getDirectory()
```

パスからディレクトリを表す部分を返す。

**戻り値:**
パスのディレクトリ部

---

### createResponseForMalformedResourcePath

```java
private static HttpErrorResponse createResponseForMalformedResourcePath(String path)
```

リソースのパスが不正な場合にスローされる例外を生成する。

**パラメータ:**
- `path` - パス

**戻り値:**
生成された例外

---
