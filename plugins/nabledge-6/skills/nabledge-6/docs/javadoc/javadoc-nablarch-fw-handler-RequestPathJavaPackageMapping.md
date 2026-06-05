# class RequestPathJavaPackageMapping

**パッケージ:** nablarch.fw.handler

**継承階層:**
```
java.lang.Object
  └─ DispatchHandler<Request<?>,Object,RequestPathJavaPackageMapping>
      └─ nablarch.fw.handler.RequestPathJavaPackageMapping
```

---

```java
public class RequestPathJavaPackageMapping
extends DispatchHandler<Request<?>,Object,RequestPathJavaPackageMapping>
```

リクエストパスをJavaパッケージへマッピングすることで動的に委譲先ハンドラを決定するディスパッチハンドラ。
<p/>
マッピング先Javaパッケージは、本ハンドラの basePackage プロパティに設定する。
<p/>
リクエストパスを単一のJavaパッケージにマッピングする場合の設定例を以下に示す。
<table border="1">
<tr bgcolor="#cccccc">
<th>本ハンドラの basePackage プロパティ</th>
<th>リクエストパス</th>
<th>委譲先のハンドラクラス</th>
</tr>
<tr>
<td rowspan=2>nablarch.sample.apps</td>
<td>/admin/AdminApp</td>
<td>nablarch.sample.apps.admin.AdminApp</td>
</tr>
<tr>
<td>/user/UserApp</td>
<td>nablarch.sample.apps.user.UserApp</td>
</tr>
</table>
<p>
委譲先のクラスが存在しない、もしくは、クラスが存在してもハンドラインターフェース {@link nablarch.fw.Handler} を実装していない場合は、
汎用例外 {@link nablarch.fw.Result.NotFound} が送出される。
</p>
<p>
<h3>ベースパスの指定</h3>
マッピング元となるリクエストパスのプレフィックスのことを「ベースパス」と呼ぶ。ベースパスは basePath プロパティ に設定する。
</p>
<p>
ベースパスには、画面オンライン処理におけるコンテキストルートを設定することを想定している。
（※画面オンライン処理では、実際にはハンドラとして{@link HttpRequestJavaPackageMapping}を使用するが、
実際にディスパッチ処理を行なっているのは、{@link nablarch.fw.web.handler.HttpRequestJavaPackageMapping}から処理を委譲される本ハンドラである）<br/>
</p>
<p>
マッピング処理を行う際には、リクエストパス中のベースパス部分の文字列を削除した上で、マッピング先Javaパッケージへとマッピングする。<br/>
以下に、画面オンライン処理でベースパスを指定し、リクエストパスを単一のJavaパッケージにマッピングする場合の設定例を示す。
<table border="1">
<tr bgcolor="#cccccc">
<th>本ハンドラの basePath プロパティ</th>
<th>本ハンドラの basePackage プロパティ</th>
<th>リクエストパス</th>
<th>委譲先のハンドラクラス</th>
</tr>
<tr>
<td rowspan=2>/webapp/sample</td>
<td>nablarch.sample.apps</td>
<td>/webapp/sample/admin/AdminApp</td>
<td>nablarch.sample.apps.admin.AdminApp</td>
</tr>
<tr>
<td>nablarch.sample.apps</td>
<td>/webapp/sample/user/UserApp</td>
<td>nablarch.sample.apps.user.UserApp</td>
</tr>
</table>
<br/>
なお、ベースパスが指定されていて、かつリクエストパスがそのベースパスに合致しない場合は、汎用例外 {@link nablarch.fw.Result.NotFound} が送出される。
</p>
</p>
<p>
<h3>リクエストパスごとのマッピング先Javaパッケージの切り替え</h3>
optionalPackageMappingEntries プロパティに設定を行うことで、リクエストパスごとにマッピング先Javaパッケージを切り替えることができる。
</p>
<p>
optionalPackageMappingEntries プロパティには、リクエストパスのパターン（requestPattern プロパティ）とマッピング先Javaパッケージ（basePackage プロパティ）の組み合わせを設定する。<br/>
optionalPackageMappingEntries プロパティに設定した順番にリクエストパスのパターンとリクエストパスとのマッチングが行われ、
最初にマッチしたマッピング先Javaパッケージが使用される。 マッチするものが存在しない場合、本ハンドラの basePackage プロパティに設定したマッピング先Javaパッケージが使用される。
</p>
<p>
以下に、リクエストパスごとにマッピング先Javaパッケージを切り替える場合の設定例を示す。</br>
<table border="1">
<tr bgcolor="#cccccc">
<th>optionalPackageMappingEntriesの requestPattern プロパティ</th>
<th>optionalPackageMappingEntriesの basePackage プロパティ</th>
<th>リクエストパス</th>
<th>委譲先のハンドラクラス</th>
</tr>
<tr>
<td>/admin//</td>
<td>nablarch.app1</td>
<td>/admin/AdminApp</td>
<td>nablarch.app1.admin.AdminApp</td>
</tr>
<tr>
<td>/user//</td>
<td>nablarch.app2</td>
<td>/user/UserApp</td>
<td>nablarch.app2.user.UserApp</td>
</tr>
</table>
<p/>
リクエストパスのパターンのマッチングは、リクエストパス中のすべてのドット(.)をスラッシュ(/)に置換してから行う。
この仕様は、Nablarch のバッチ処理で過去に使用していたドット区切りのリクエストパス（例： ss01A001.B01AA001Action/B01AA0010）との互換性を保つために存在している。
<p/>
リクエストパスのパターンの記法についての詳細は{@link nablarch.fw.RequestPathMatchingHelper}を参照すること。

**関連項目:** Request#getRequestPath()  
**関連項目:** nablarch.fw.RequestPathMatchingHelper  
**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### MAPPING_RULE

```java
private static final Pattern MAPPING_RULE
```

ベースパス <-> Javaパッケージのマッピングを表す正規表現

---

### basePath

```java
private String basePath
```

マッピング元ベースパス

---

### basePackage

```java
private String basePackage
```

マッピング先Javaパッケージ

---

### optionalPackageMappingEntries

```java
private List<JavaPackageMappingEntry> optionalPackageMappingEntries
```

RequestHandlerEntryでURIに合致したマッピング先Javaパッケージを上書きする場合に使用する、JavaPackageMappingEntryのリスト

---

### classNameSuffix

```java
private String classNameSuffix
```

移譲対象クラス名の接尾辞

---

### classNamePrefix

```java
private String classNamePrefix
```

委譲対象クラス名の接頭辞

---

## コンストラクタの詳細

### RequestPathJavaPackageMapping

```java
public RequestPathJavaPackageMapping()
```

デフォルトコンストラクタ。
<p/>
このメソッドの処理は次のコードと同等である。
<pre>
  new RequestPathJavaPackageMapping("", "");
</pre>

---

### RequestPathJavaPackageMapping

```java
public RequestPathJavaPackageMapping(String basePath, String basePackage)
```

リクエストパスが、basePathで始まるリクエストを、basePackageで指定された
Javaパッケージ配下のリクエストハンドラに委譲するディスパッチャを作成する。

**パラメータ:**
- `basePath` - マッピング元ベースURI
- `basePackage` - マッピング先Javaパッケージ

---

## メソッドの詳細

### getHandlerClass

```java
protected Class<?> getHandlerClass(Request<?> req, ExecutionContext ctx)
                         throws ClassNotFoundException
```

{@inheritDoc}
このクラスの実装では、ベースパスとベースパッケージの設定をもとに算出した完全修飾名に一致するリクエストハンドラに対して処理を委譲する。
正確な仕様は以下の通り。
<p/>
委譲先のクラス(完全修飾名)の決定は以下の規則に従う。
<pre>
  1. basePackage の ”.” を ”/” に置換する。
  2. リクエストパスの先頭から basePath と一致する部分を basePackage
     に置換する。
  3. 2.の結果文字列を”/”で分割する。
     分割後の各トークンの内、英大文字で始まっているものを委譲先の
     クラス名とし、それ以前の各トークンをパッケージ名とみなす。
  4. コンテキストクラスパス上に上記のパッケージ及びクラスが実際に
     存在していれば、そのクラスを委譲対象とする。
</pre>
以下の場合、共通例外{@link nablarch.fw.Result.NotFound}を送出する。
<pre>
  - ベースパス外からのアクセスであった場合。
  - 委譲先のクラスが決定できない、決定できても存在しない場合。
  - 委譲先のクラスがHandlerインターフェースを実装していない場合。
</pre>

---

### getBasePackage

```java
protected String getBasePackage(Request<?> req, ExecutionContext ctx)
```

マッピング先Javaパッケージを取得する。
<p/>
optionalPackageMappingEntries プロパティに設定した順番にリクエストパスのパターンとリクエストパスとのマッチングが行われ、 最初にマッチしたJavaパッケージが使用される。 <br/>
マッチするものが存在しない場合、またはoptionalPackageMappingEntries プロパティ自体が設定されていない場合、本ハンドラのbasePackage プロパティに設定したJavaパッケージが使用される。

**パラメータ:**
- `req` - 入力データ
- `ctx` - 実行コンテキスト

**戻り値:**
マッピング先Javaパッケージ

---

### setBasePath

```java
public RequestPathJavaPackageMapping setBasePath(String basePath)
```

マッピング元ベースパスを設定する。

**パラメータ:**
- `basePath` - マッピング元ベースパス

**戻り値:**
JavaPackageMapping

---

### setBasePackage

```java
public RequestPathJavaPackageMapping setBasePackage(String basePackage)
```

マッピング先Javaパッケージを設定する。

**パラメータ:**
- `basePackage` - マッピング先Javaパッケージ

**戻り値:**
JavaPackageMapping

---

### setOptionalPackageMappingEntries

```java
public RequestPathJavaPackageMapping setOptionalPackageMappingEntries(List<JavaPackageMappingEntry> optionalPackageMappingEntries)
```

RequestHandlerEntryでリクエストパスに合致したマッピング先Javaパッケージを上書きする場合に使用する、JavaPackageMappingEntryのリストを設定する。

**パラメータ:**
- `optionalPackageMappingEntries` - JavaPackageMappingEntryのリスト

**戻り値:**
このオブジェクト自体

---

### setClassNamePrefix

```java
public RequestPathJavaPackageMapping setClassNamePrefix(String prefix)
```

委譲対象クラス名の接頭辞となる文字列を設定する。

**パラメータ:**
- `prefix` - 委譲対象クラス名の接頭辞となる文字列

**戻り値:**
このオブジェクト自体

---

### setClassNameSuffix

```java
public RequestPathJavaPackageMapping setClassNameSuffix(String suffix)
```

委譲対象クラス名の接尾辞となる文字列を設定する。

**パラメータ:**
- `suffix` - 委譲対象クラス名の接尾辞となる文字列

**戻り値:**
このオブジェクト自体

---
