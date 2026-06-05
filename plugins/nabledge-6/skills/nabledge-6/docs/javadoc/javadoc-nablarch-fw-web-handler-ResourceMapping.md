# class ResourceMapping

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class ResourceMapping
implements HttpRequestHandler
```

リクエストURIに応じて、リソースファイルに対するマッピングを行うリクエストハンドラ。
<pre>
画像等の静的ファイルへのリクエストやフォーワードを介さないJSP画面へのアクセスは、
通常、Webサーバ・アプリケーションサーバでレスポンスを行う為、フレームワーク側で制御することができない。
このリクエストハンドラを経由させることで、これらのアクセスについても
認可を始めとする共通処理の制御下におくことができる。
マッピング先のパスには、{@link HttpResponse#setContentPath(String)}の書式に従って、
以下の3種類のいずれかを指定することができる。
  1. コンテキストクラスローダ上のリソース
  2. サーブレットフォーワード（JSPを含む)
  3. 内部フォーワードの実行結果
ただし、ファイルシステム上のローカルファイル(file://スキーム)は使用できない。

次の例では、特定のベースURI(/webapp/resource/)下の画像ファイルに対するリクエストを、
サーブレットコンテキスト上のリソース(/WEB-INF/resource/)を参照するようにマッピングしている。
こうすることで、これらのファイルをフレームワークの認証・認可の制御下に置くことができる。
  new StaticResource("/admin/resource/", "servlet:///WEB-INF/resource/");
HTTPリクエストと、それに対するレスポンスのコンテンツパスとの対応は以下のようになる。
===========================================================================
 HTTPリクエストライン                コンテンツパス [コンテンツタイプ]
===========================================================================
GET /admin/resource/style.css  ->  servlet:///WEB-INF/resource/style.css 
                                   [text/css]
-------------------------------    --------------------------------------
GET /admin/resource/js/init.js ->  servlet:///WEB-INF/resource/js/init.js
                                   [application/javascript]
===========================================================================
</pre>

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  
**関連項目:** HttpResponse#setContentPath(String)  

---

## フィールドの詳細

### baseUri

```java
private String baseUri
```

マッピング元ベースURI

---

### scheme

```java
private String scheme
```

マッピング先リソーススキーム

---

### basePath

```java
private String basePath
```

マッピング先ベースパス

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## コンストラクタの詳細

### ResourceMapping

```java
public ResourceMapping(String baseUri, String basePath)
```

特定のbaseUri配下へのリクエストを静的ファイルにマッピングする
リクエストハンドラを生成する。

**パラメータ:**
- `baseUri` - マッピング元ベースURI
- `basePath` - マッピング先リソースパス

---

### ResourceMapping

```java
public ResourceMapping()
```

デフォルトコンストラクタ。

---

## メソッドの詳細

### setBaseUri

```java
public ResourceMapping setBaseUri(String baseUri)
```

マッピング元ベースURIを設定する。

**パラメータ:**
- `baseUri` - マッピング元ベースURI

**戻り値:**
このオブジェクト自体

---

### setBasePath

```java
public ResourceMapping setBasePath(String basePath)
```

マッピング先リソースパスを設定する。

**パラメータ:**
- `basePath` - マッピング先リソースパス

**戻り値:**
このオブジェクト自体

---

### handle

```java
public HttpResponse handle(HttpRequest req, ExecutionContext ctx)
```

{@inheritDoc}
<pre>
このクラスの実装では以下の処理を行う。
  1. リクエストURI中のbaseUri以下の部分を取得する。
  2. docRootに1.の結果を連結した文字列をコンテンツタイプとする。
  3. リクエストURIの拡張子からコンテンツタイプを判定する。
  4. HttpResponseを生成し、2,3の結果をそれに設定する。
  5. 4の結果を返す。
</pre>

---
