# class HttpRequestJavaPackageMapping

**パッケージ:** nablarch.fw.web.handler

**実装されたインタフェース:**
- HttpRequestHandler

---

```java
public class HttpRequestJavaPackageMapping
implements HttpRequestHandler
```

このハンドラは、画面オンライン処理におけるリクエストパス中の部分文字列(ベースURI)を
Javaパッケージ階層にマッピングすることで、動的に委譲先ハンドラを決定するディスパッチ処理を行う。
本ハンドラの実装は基本的に {@link RequestPathJavaPackageMapping} のラッパーであり
その機能は以下の2点を除けば全く同じものである。
<pre>
1. ディスパッチ対象のクラスが確定した時点で、HTTPアクセスログにその内容を出力する。
2. ベースパスを設定する際にURLの書式バリデーションを行うアクセサ {@link #setBaseUri(String) }を追加。
</pre>

機能の詳細については、 {@link RequestPathJavaPackageMapping} を参照すること。

**関連項目:** RequestPathJavaPackageMapping  
**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## フィールドの詳細

### mapping

```java
private final Mapping mapping
```

ディスパッチャの実体

---

## コンストラクタの詳細

### HttpRequestJavaPackageMapping

```java
public HttpRequestJavaPackageMapping()
```

コンストラクタ

---

### HttpRequestJavaPackageMapping

```java
public HttpRequestJavaPackageMapping(String baseUri, String basePackage)
```

コンストラクタ

**パラメータ:**
- `baseUri` - マップ元リクエストURI
- `basePackage` - マップ先Javaパッケージ

---

## メソッドの詳細

### handle

```java
public HttpResponse handle(HttpRequest request, ExecutionContext context)
```

{@inheritDoc}
URI中の部分文字列をJavaパッケージへマッピングすることで動的に
委譲先のハンドラを決定し、処理を委譲する。
また、委譲先のクラスがハンドラインターフェースを実装していない場合でも、
{@link nablarch.fw.web.HttpMethodBinding} により処理を委譲する。

---

### setBasePath

```java
public HttpRequestJavaPackageMapping setBasePath(String basePath)
```

ベースパスを設定する。

**パラメータ:**
- `basePath` - ベースパス

**戻り値:**
このオブジェクト自体

---

### setBaseUri

```java
public HttpRequestJavaPackageMapping setBaseUri(String baseUri)
```

ベースURIを設定する。({@link #setBasePath(String)}のシノニム)

**パラメータ:**
- `baseUri` - ベースURI

**戻り値:**
このオブジェクト自体

---

### setBasePackage

```java
public HttpRequestJavaPackageMapping setBasePackage(String basePackage)
```

ベースパッケージを設定する。

**パラメータ:**
- `basePackage` - ベースパッケージ

**戻り値:**
このオブジェクト自体

---

### setOptionalPackageMappingEntries

```java
public HttpRequestJavaPackageMapping setOptionalPackageMappingEntries(List<JavaPackageMappingEntry> optionalPackageMappingEntries)
```

RequestHandlerEntryでURIに合致したマッピング先Javaパッケージを上書きする場合に使用する、JavaPackageMappingEntryのリストを設定する。

**パラメータ:**
- `optionalPackageMappingEntries` - RequestHandlerEntryでURIに合致したマッピング先Javaパッケージを上書きする場合に使用する、JavaPackageMappingEntryのリスト

**戻り値:**
このオブジェクト自体

---
