# class FileRecordWriterHolder

**パッケージ:** nablarch.common.io

---

```java
public class FileRecordWriterHolder
```

{@link FileRecordWriter}のインスタンスをスレッド毎に管理するクラス。
<p/>
スレッド毎に管理する{@link FileRecordWriter}インスタンスの生成及び取得、クローズ機能を持つ。
<p/>
{@link FileRecordWriterDisposeHandler}をハンドラとして設定する場合、
本クラスがスレッド上で管理するすべての{@link FileRecordWriter}が{@link FileRecordWriterDisposeHandler}により自動的にクローズされるので、
業務アプリケーションで本クラスの{@link #close}メソッドを呼び出す必要はない。
<p/>
{@link #close(String, String)}及び{@link #close(String)}では、{@link ThreadLocal#remove()}の呼び出しを行わない。
スレッド上の値を削除するためには、{@link #closeAll()}の呼び出しが必要となる。

**関連項目:** FileRecordWriter  
**作成者:** Masato Inoue  

---

## フィールドの詳細

### DEFAULT_BUFFER_SIZE

```java
private static final int DEFAULT_BUFFER_SIZE
```

ファイル読み込みの際に使用するバッファのサイズ（デフォルトは8192B）

---

### KEY_SEPARATOR

```java
private static final String KEY_SEPARATOR
```

コンバータを保持するキーとして使用する、ベースパスとファイル名の区切り文字

---

### REPOSITORY_KEY

```java
private static final String REPOSITORY_KEY
```

システムリポジトリ上の登録名

---

### DEFAULT_HOLDER

```java
private static final FileRecordWriterHolder DEFAULT_HOLDER
```

デフォルトのコンバータ設定情報保持クラスのインスタンス。
リポジトリからインスタンスを取得できなかった場合に、デフォルトでこのインスタンスが使用される。

---

### WRITERS

```java
private static final ThreadLocal<Map<String,FileRecordWriter>> WRITERS
```

カレントスレッド上で管理されるファイル毎のファイルレコードライタを格納する。
ファイルレコードライタは{@link InheritableThreadLocal}クラスで管理されるので、親スレッドから子スレッドへインスタンスが引き継がれる。

---

## メソッドの詳細

### getInstance

```java
public static FileRecordWriterHolder getInstance()
```

本クラスのインスタンスを{@link SystemRepository}より取得する。
<p>
{@link SystemRepository}にインスタンスが存在しない場合は、クラスロード時に生成した本クラスのインスタンスを返却する。

**戻り値:**
本クラスのインスタンス

---

### open

```java
public static void open(String dataFileName, String layoutFileName)
```

{@link FilePathSetting}から"output"という論理名で取得したベースパス配下のファイルをオープンする。
<p/>
このとき、フォーマット定義ファイルも{@link FilePathSetting}から"format"という論理名で取得したベースパス配下より読み込む。<br/>
また、バッファサイズには、デフォルトの値(8192B)が使用される。

**パラメータ:**
- `dataFileName` - 書き込むデータファイルのファイル名
- `layoutFileName` - フォーマット定義ファイルのファイル名

---

### open

```java
public static void open(String dataFileName, String layoutFileName, int bufferSize)
```

{@link FilePathSetting}から"output"という論理名で取得したベースパス配下のファイルをオープンする。
<p/>
このとき、フォーマット定義ファイルも{@link FilePathSetting}から"format"という論理名で取得したベースパス配下より読み込む。<br/>
また、引数でデータファイルに書き込む際のバッファサイズを指定する。

**パラメータ:**
- `dataFileName` - 書き込むデータファイルのファイル名
- `layoutFileName` - フォーマット定義ファイルのファイル名
- `bufferSize` - バッファサイズ

---

### open

```java
public static void open(String dataFileBasePathName, String dataFileName, String layoutFileName)
```

{@link FilePathSetting}に設定した論理名(論理ベースパス）配下のファイルをオープンする。
<p/>
このとき、フォーマット定義ファイルは{@link FilePathSetting}から"format"という論理名で取得したベースパス配下より読み込む。<br/>
また、データファイルに書き込む際のバッファサイズはデフォルト値(8192B)が使用される。

**パラメータ:**
- `dataFileBasePathName` - 書き込むデータファイルのベースパスの論理名
- `dataFileName` - 書き込むデータファイルのファイル名
- `layoutFileName` - フォーマット定義ファイルのファイル名

---

### open

```java
public static void open(String dataFileBasePathName, String dataFileName, String layoutFileName, int bufferSize)
```

{@link FilePathSetting}に設定した論理名(論理ベースパス）配下のファイルをオープンする。
<p/>
このとき、フォーマット定義ファイルは{@link FilePathSetting}から"format"という論理名で取得したベースパス配下より読み込む。<br/>
また、引数でデータファイルに書き込む際のバッファサイズを指定する。

**パラメータ:**
- `dataFileBasePathName` - 書き込むデータファイルのベースパスの論理名
- `dataFileName` - 書き込むデータファイルのファイル名
- `layoutFileName` - フォーマット定義ファイルのファイル名
- `bufferSize` - バッファサイズ

---

### init

```java
public static void init()
```

カレントスレッド上で開いたファイルを管理するための初期処理を行う。
<p>
本処理を呼ばなかった場合、子スレッド側で開いたファイルは管理対象とならないため注意すること。

---

### open

```java
public static void open(String dataFileBasePathName, String dataFileName, String layoutFileBasePathName, String layoutFileName)
```

{@link FilePathSetting}に設定した論理名(論理ベースパス）配下のファイルをオープンする。
<p/>
このとき、フォーマット定義ファイルは{@link FilePathSetting}から"format"という論理名で取得したベースパス配下より読み込む。
また、データファイルに書き込む際のバッファサイズはデフォルト値(8192B)が使用される。

**パラメータ:**
- `dataFileBasePathName` - 書き込むデータファイルのベースパスの論理名
- `dataFileName` - 書き込むデータファイルのファイル名
- `layoutFileBasePathName` - フォーマット定義ファイルのベースパス論理名
- `layoutFileName` - フォーマット定義ファイルのファイル名

---

### open

```java
public static void open(String dataFileBasePathName, String dataFileName, String layoutFileBasePathName, String layoutFileName, int bufferSize)
```

{@link FilePathSetting}に設定した論理名(論理ベースパス）配下のファイルをオープンする。
<p>
また、引数でデータファイルに書き込む際のバッファサイズと、{@link FilePathSetting}に設定したフォーマット定義ファイルの論理名を指定する。
</p>

**パラメータ:**
- `dataFileBasePathName` - 書き込むデータファイルのベースパスの論理名
- `dataFileName` - 書き込むデータファイルのファイル名
- `layoutFileBasePathName` - フォーマット定義ファイルのベースパスの論理名
- `layoutFileName` - フォーマット定義ファイルのファイル名
- `bufferSize` - バッファサイズ

**例外:**
- `IllegalArgumentException` - {@code bufferSize}以外の引数がnullまたは空の場合
- `IllegalStateException` - カレントスレッド上の{@link FileRecordWriter}が既にオープンしている場合

---

### write

```java
public static void write(Map<String,?> record, String fileName)
```

{@link FilePathSetting}から"output"という論理名で取得したベースパス配下のデータファイルにレコードを出力する。

**パラメータ:**
- `record` - ファイルに出力するレコード
- `fileName` - 書き込むデータファイルのファイル名

---

### write

```java
public static void write(Map<String,?> record, String basePathName, String fileName)
```

{@link FilePathSetting}に設定した論理名(論理ベースパス）配下のデータファイルにレコードを出力する。

**パラメータ:**
- `record` - ファイルに出力するレコード
- `basePathName` - 書き込むデータファイルのベースパスの論理名
- `fileName` - 書き込むデータファイルのファイル名

---

### write

```java
public static void write(String recordType, Map<String,?> record, String fileName)
```

{@link FilePathSetting}から"output"という論理名で取得したベースパス配下のデータファイルにレコードを出力する。
<p>
また、引数で出力するレコードのレコードタイプを指定する。
</p>

**パラメータ:**
- `recordType` - 出力するレコードのレコードタイプ
- `record` - ファイルに出力するレコード
- `fileName` - 書き込むデータファイルのファイル名

---

### write

```java
public static void write(String recordType, Map<String,?> record, String basePathName, String fileName)
```

引数で指定したデータファイルにレコードを出力する。

**パラメータ:**
- `recordType` - 出力するレコードのレコードタイプ
- `record` - ファイルに出力するレコード
- `basePathName` - 書き込むデータファイルのベースパスの論理名
- `fileName` - 書き込むデータファイルのファイル名

---

### createFileRecordWriter

```java
protected FileRecordWriter createFileRecordWriter(String dataFileBasePathName, String dataFileName, String layoutFileBasePathName, String layoutFileName, int bufferSize)
```

{@link FileRecordWriter}のインスタンスを生成する。

**パラメータ:**
- `dataFileBasePathName` - ベースパスの論理名
- `dataFileName` - 書き込むデータファイルのファイル名
- `layoutFileName` - レイアウトファイル名
- `layoutFileBasePathName` - レイアウトファイルの配置ディレクトリの論理名
- `bufferSize` - ファイル読み込み時のバッファサイズ

**戻り値:**
FileRecordWriterのインスタンス

---

### createKey

```java
protected String createKey(String basePathName, String fileName)
```

スレッドに保持するキーを生成する。

**パラメータ:**
- `basePathName` - ベースパスの論理名
- `fileName` - 書き込むデータファイルのファイル名

**戻り値:**
キー

**例外:**
- `IllegalArgumentException` - {@code basePathName}に"&"が含まれていなかった場合

---

### get

```java
public static FileRecordWriter get(String fileName)
```

{@link FilePathSetting}から"output"という論理名で取得したベースパス配下のファイルに書き出しを行う{@link FileRecordWriter}を取得する。

**パラメータ:**
- `fileName` - 書き込むデータファイルのファイル名

**戻り値:**
{@link FileRecordWriter}

---

### get

```java
public static FileRecordWriter get(String basePathName, String fileName)
```

{@link FilePathSetting}に設定した論理名(論理ベースパス）配下のファイルに書き出しを行う{@link FileRecordWriter}を取得する。

**パラメータ:**
- `basePathName` - 書き込むデータファイルのベースパスの論理名
- `fileName` - 書き込むデータファイルのファイル名

**戻り値:**
{@link FileRecordWriter}

**例外:**
- `IllegalArgumentException` - カレントスレッド上の{@link FileRecordWriter}が閉じている場合

---

### close

```java
public static void close(String fileName)
```

{@link FilePathSetting}から"output"という論理名で取得したベースパス配下のファイルに書き出しを行う{@link FileRecordWriter}をクローズし、
インスタンスをカレントスレッド上から削除する。

**パラメータ:**
- `fileName` - 書き込むデータファイルのファイル名

---

### close

```java
public static void close(String basePathName, String fileName)
```

{@link FilePathSetting}に設定した論理名(論理ベースパス）配下のファイルに書き出しを行う{@link FileRecordWriter}をクローズし、
インスタンスをカレントスレッド上から削除する。

**パラメータ:**
- `basePathName` - 書き込むデータファイルのベースパスの論理名
- `fileName` - 書き込むデータファイルのファイル名

---

### closeAll

```java
public static void closeAll()
```

本クラスがカレントスレッド上で管理している全ての{@link FileRecordWriter}のファイルストリームを
クローズし、また、それら全ての{@link FileRecordWriter}をカレントスレッド上から削除する。

---
