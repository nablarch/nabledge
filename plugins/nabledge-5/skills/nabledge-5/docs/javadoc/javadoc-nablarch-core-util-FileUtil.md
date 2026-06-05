# class FileUtil

**パッケージ:** nablarch.core.util

---

```java
public final class FileUtil
```

ファイルの取り扱いに関するユーティリティクラス。

**作成者:** Koichi Asano  
**作成者:** Masato Inoue  

---

## フィールドの詳細

### ALNUM_CHAR_PATTERN

```java
private static Pattern ALNUM_CHAR_PATTERN
```

---

## コンストラクタの詳細

### FileUtil

```java
private FileUtil()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### closeQuietly

```java
public static void closeQuietly(Closeable closeables)
```

リソースを解放する。
<p/>
例外が発生した場合は何もせず、次のリソース解放を行う。

**パラメータ:**
- `closeables` - リソース解放を行うクラス

---

### getResource

```java
public static InputStream getResource(String url)
                        throws IllegalArgumentException
```

リソースを取得する。
<p/>
ファイルパスまたはクラスパス上のリソースを取得する。<br/>
引数に指定するURLのフォーマットは下記の通り。
<pre>
    &lt;スキーム名&gt;:&lt;リソースのパス&gt;
</pre>
URLの指定例を下記に示す。
<code><pre>
//ファイルパスの場合
FileUtil.getResource("file:/var/log/log.properties");

//クラスパスの場合
FileUtil.getResource("classpath:nablarch/core/log/log.properties");
</pre></code>

**パラメータ:**
- `url` - URL

**戻り値:**
リソースのストリーム

**例外:**
- `IllegalArgumentException` - リソースを取得できなかった場合
- `java.io.FileNotFoundException` - リソースファイルが見つからなかった場合

---

### getResourceURL

```java
public static URL getResourceURL(String url)
```

URLを取得する。
<p/>
ファイルパスまたはクラスパス上のURLを取得する。<br/>
引数に指定するURLのフォーマットは下記の通り。
<pre>
    {@literal <スキーム名>:<リソースのパス>}
</pre>
URLの指定例を下記に示す。
<code><pre>
//ファイルパスの場合
FileUtil.getResourceURL("file:/var/log/log.properties");

//クラスパスの場合
FileUtil.getResourceURL("classpath:nablarch/core/log/log.properties");
</pre></code>

**パラメータ:**
- `url` - URL文字列

**戻り値:**
リソースのURL

**例外:**
- `IllegalArgumentException` - URLが{@code null}または不正だった場合

---

### getClasspathResource

```java
public static InputStream getClasspathResource(String path)
                                 throws IllegalArgumentException
```

クラスパス上のリソースを取得する。
<p/>
以下に例を示す。
<code><pre>
FileUtil.getClasspathResource("nablarch/core/log/log.properties");
</pre></code>

**パラメータ:**
- `path` - クラスパス

**戻り値:**
リソースのストリーム

**例外:**
- `IllegalArgumentException` - クラスパス及びクラスパスから取得するURLが{@code null}または、リソースが見つからない場合

---

### getClasspathResourceURL

```java
public static URL getClasspathResourceURL(String path)
```

クラスパス上のURLを取得する。
<p/>
以下に例を示す。
<code><pre>
FileUtil.getClasspathResource("nablarch/core/log/log.properties");
</pre></code>

**パラメータ:**
- `path` - リソースのパス

**戻り値:**
リソースのURL

**例外:**
- `IllegalArgumentException` - クラスパスが{@code null}だった場合

---

### listFiles

```java
public static File[] listFiles(String dir, String name)
```

ディレクトリ配下のファイルおよびディレクトリを検索し、名前で昇順ソートした結果の配列を返す。
<p/>
ファイル名にはワイルドカード("*")を指定できる。<br/>
ディレクトリは、絶対パスまたは相対パスで指定する。<br/>
ディレクトリが{@code null}だった場合、引数のファイル名を元に構築したFileオブジェクトを持つ要素が１つの配列が返される。<br/>

**パラメータ:**
- `dir` - ディレクトリ(null指定の場合、指定なし)
- `name` - ファイル名

**戻り値:**
検索結果の配列

**例外:**
- `NullPointerException` - ファイル名が{@code null}だった場合

---

### deleteFile

```java
public static boolean deleteFile(File file)
```

ファイルを削除する。

**パラメータ:**
- `file` - 削除するファイル

**戻り値:**
ファイルが削除に成功した場合は{@code true}、失敗した場合は{@code false}を返却する。ファイルが存在しない場合は{@code true}を返却する。

**例外:**
- `IllegalArgumentException` - 削除するファイルが{@code null}だった場合

---

### extractSuffix

```java
public static String extractSuffix(String fileName)
```

ファイル名から拡張子を抽出する。
<p/>
以下の仕様に当てはまる場合は、空文字列を返す。
<ol>
    <li>ファイル名の先頭がドット</li>
    <li>ファイル名の末尾がドット</li>
    <li>拡張子にドットがない</li>
    <li>拡張子が英数字以外</li>
</ol>

**パラメータ:**
- `fileName` - ファイル名

**戻り値:**
拡張子

**例外:**
- `IllegalArgumentException` - ファイル名が{@code null}だった場合

---

### move

```java
public static void move(File src, File dest)
```

ファイルを移動する。
<p/>
移動先に同名のファイルが存在していた場合、上書きする。

**パラメータ:**
- `src` - 移動元ファイル
- `dest` - 移動先ファイル

**例外:**
- `IllegalArgumentException` - 移動元ファイルまたは移動先ファイルが{@code null}の場合
- `RuntimeException` - コピー元のファイルが削除できなかった場合

---

### copy

```java
public static void copy(File src, File dest)
```

ファイルをコピーする。
<p/>
コピー先に同名のファイルが存在していた場合、上書きする。

**パラメータ:**
- `src` - コピー元ファイル
- `dest` - コピー先ファイル

**例外:**
- `IllegalArgumentException` - コピー元ファイルまたはコピー先ファイルが{@code null}の場合
- `RuntimeException` - コピーに失敗した場合

---

### copy

```java
private static void copy(InputStream src, OutputStream dest)
          throws IOException
```

ストリームのコピーを行う。

**パラメータ:**
- `src` - コピー元入力ストリーム
- `dest` - コピー先出力ストリーム

**例外:**
- `IOException` - 入出力例外

---
