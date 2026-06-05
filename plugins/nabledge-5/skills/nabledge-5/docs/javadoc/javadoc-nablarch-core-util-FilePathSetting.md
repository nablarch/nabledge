# class FilePathSetting

**パッケージ:** nablarch.core.util

---

```java
public class FilePathSetting
```

ベースパスの論理名と物理パスとの対応を管理するクラス。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### basePathSettings

```java
private Map<String,URL> basePathSettings
```

ベースパスの論理名と物理パスとの対応を収めたMap

---

### fileExtensions

```java
private Map<String,String> fileExtensions
```

ベースパスの論理名とデフォルト拡張子との対応を収めたMap。
ベースパスに対応するデフォルトの拡張子を使用する場合は、 本プロパティの設定を行う。

---

### REPOSITORY_KEY

```java
private static final String REPOSITORY_KEY
```

システムリポジトリ上の登録名

---

### DEFAULT_SETTING

```java
private static final FilePathSetting DEFAULT_SETTING
```

デフォルトのコンバータ設定情報保持クラスのインスタンス。
リポジトリからインスタンスを取得できなかった場合に、デフォルトでこのインスタンスが使用される。

---

## メソッドの詳細

### getInstance

```java
public static FilePathSetting getInstance()
```

このクラスのインスタンスをリポジトリより取得する。
リポジトリにインスタンスが存在しない場合は、デフォルトの設定で生成したこのクラスのインスタンスを返却する。

**戻り値:**
このクラスのインスタンス

---

### getFile

```java
public File getFile(String basePathName, String fileName)
             throws IllegalArgumentException
```

指定されたベースパスの直下に存在するファイルの抽象パスを取得する。
ファイルが存在しない場合は新たにファイルを作成してその抽象パスを返却する。

**パラメータ:**
- `basePathName` - ベースパスの論理名
- `fileName` - 取得するファイル名

**戻り値:**
抽象パス

**例外:**
- `IllegalArgumentException` - 指定されたベースパス論理名に対応する物理パスが
            設定されていない場合

---

### getFileIfExists

```java
public File getFileIfExists(String basePathName, String fileName)
                     throws IllegalArgumentException
```

指定されたベースパスの直下に存在するファイルの抽象パスを取得する。
その抽象パスを返却する。ファイルが存在しない場合はnullを返却する。

**パラメータ:**
- `basePathName` - ベースパスの論理名
- `fileName` - 取得するファイル名

**戻り値:**
抽象パス

**例外:**
- `IllegalArgumentException` - 指定されたベースパス論理名に対応する物理パスが
            設定されていない場合

---

### getFileWithoutCreate

```java
public File getFileWithoutCreate(String basePathName, String fileName)
                          throws IllegalArgumentException
```

指定されたベースパスの直下に存在するファイルの抽象パスを取得する。

**パラメータ:**
- `basePathName` - ベースパスの論理名
- `fileName` - 取得するファイル名

**戻り値:**
抽象パス

**例外:**
- `IllegalArgumentException` - 指定されたベースパス論理名に対応する物理パスが
            設定されていない場合

---

### resolvePath

```java
protected File resolvePath(String basePathName, String fileName, boolean createNew)
                 throws IllegalArgumentException
```

指定されたベースパスの直下に存在するファイルの抽象パスを作成して返却する。

**パラメータ:**
- `basePathName` - ベースパスの論理名
- `fileName` - 取得するファイル名
- `createNew` - 指定したファイルが存在しない場合に新規ファイルを
                      作成するかどうか。（作成する場合はtrue）

**戻り値:**
抽象パス

**例外:**
- `IllegalArgumentException` - 指定されたベースパス論理名に対応する物理パスが
            設定されていない場合

---

### getBasePathUrl

```java
public URL getBasePathUrl(String basePathName)
```

ベースパスのURLを取得する。

**パラメータ:**
- `basePathName` - ベースパスの論理名

**戻り値:**
URL

---

### getBaseDirectory

```java
public File getBaseDirectory(String basePathName)
```

ベースディレクトリを取得する。

**パラメータ:**
- `basePathName` - ベースパスの論理名

**戻り値:**
ベースディレクトリ

---

### getFileNameJoinExtension

```java
protected String getFileNameJoinExtension(String basePathName, String fileName)
```

ベースパスの論理名に対応する拡張子が存在する場合、ファイル名と拡張子を結合した文字列を返却する。
対応する拡張子が存在しない場合は、引数のファイル名をそのまま返却する。

**パラメータ:**
- `basePathName` - ベースパスの論理名
- `fileName` - ファイル名

**戻り値:**
ファイル名と拡張子を結合した文字列

---

### setBasePathSettings

```java
public FilePathSetting setBasePathSettings(Map<String,String> basePathSettings)
```

ベースパスの論理名と物理パスとの対応を収めたMapを設定する。

**パラメータ:**
- `basePathSettings` - ベースパスの論理名と物理パス（URLで指定）との対応を収めたMap

**戻り値:**
このクラス自体のインスタンス

---

### addBasePathSetting

```java
public FilePathSetting addBasePathSetting(String basePathName, String path)
```

ベースパスの設定を追加する。
<p/>
ベースパスにはディレクトリのみ指定できる。ディレクトリでない場合、例外をスローする。
<p/>
ベースパスはURLで指定すること。URLを使用して、ファイルシステムとクラスパス上のリソースを指定することができる。<br/>
URLのフォーマットは下記の通りである。
<pre>
    &lt;スキーム名&gt;:&lt;リソースのパス&gt;

    スキーム名:
        ファイルパスの場合 "file"
        クラスパスの場合 "classpath"
</pre>
URLの指定例を下記に示す。<br>
<pre>
    ファイルパスの場合
        "file:./main/format"

    クラスパスの場合
        "classpath:web/format"
</pre>
ベースパスにクラスパスを指定する場合、そのパスにはディレクトリが存在している必要がある。ディレクトリが存在しない場合は、例外をスローする。
<p/>
ベースパスにファイルパスを指定する場合、そのパスにディレクトリが存在していなければ、本メソッド内でディレクトリを作成する。

**パラメータ:**
- `basePathName` - ベースパスの論理名
- `path` - ベースパス（URLで指定）

**戻り値:**
このクラス自体のインスタンス

---

### getAddBasePathExceptionMessage

```java
private static String getAddBasePathExceptionMessage(String basePathName, String path)
```

ベースパスを追加する際に発生する例外メッセージの共通部を取得する。

**パラメータ:**
- `basePathName` - ベースパスの論理名
- `path` - ベースパス

**戻り値:**
ベースパスが不正な場合の例外メッセージの共通部

---

### addFileExtensions

```java
public FilePathSetting addFileExtensions(String name, String extension)
```

ベースパスの論理名に対応する拡張子を追加する。

**パラメータ:**
- `name` - ベースパスの論理名
- `extension` - ベースパスの論理名に対応する拡張子

**戻り値:**
このクラス自体のインスタンス

---

### getBasePathSettings

```java
public Map<String,URL> getBasePathSettings()
```

ベースパスの論理名と物理パスとの対応を収めたMapを取得する。

**戻り値:**
ベースパスの論理名と物理パスとの対応を収めたMap

---

### getFileExtensions

```java
public Map<String,String> getFileExtensions()
```

ベースパスの論理名と拡張子との対応を収めたMapを取得する。

**戻り値:**
ベースパスの論理名とデフォルト拡張子との対応を収めたMap

---

### setFileExtensions

```java
public void setFileExtensions(Map<String,String> fileExtensions)
```

ベースパスの論理名と拡張子との対応を収めたMapを設定する。

**パラメータ:**
- `fileExtensions` - ベースパスの論理名とデフォルト拡張子との対応を収めたMap

---
