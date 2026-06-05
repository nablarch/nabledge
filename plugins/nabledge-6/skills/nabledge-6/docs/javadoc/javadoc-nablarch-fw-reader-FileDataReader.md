# class FileDataReader

**パッケージ:** nablarch.fw.reader

**実装されたインタフェース:**
- DataReader<DataRecord>

---

```java
public class FileDataReader
implements DataReader<DataRecord>
```

ファイルデータを１レコードづつ読み込み、
読み込んだフィールドの内容を{@link DataRecord}にマッピングして返却するデータリーダ。
<p/>
実際のレコード読み込み処理は、{@link FileRecordReader}に委譲する。
<p/>
このクラスを使用するにあたって設定が必須となるプロパティの実装例を下記に示す。
<pre>{@code
    FileDataReader reader = new FileDataReader()
        //フォーマット定義ファイルのベースパス論理名とフォーマット定義ファイル名(拡張子無し)を設定する。
        .setLayoutFile("format", "formatFile")
        //データファイルベースパス論理名とデータファイル名(拡張子無し)を設定する。
        .setDataFile("input", "dataFile");
}</pre>

このクラスは読み込み対象のファイルやフォーマット定義ファイルが存在しない場合には例外を送出する。
読み込み対象のファイルが空(0バイト)の場合は、例外の送出は行わない。

**作成者:** Masato Inoue  

---

## フィールドの詳細

### fileReader

```java
private FileRecordReader fileReader
```

ファイルからの読み込みを行うリーダ

---

### layoutFileName

```java
private String layoutFileName
```

フォーマット定義ファイル名

---

### dataFileName

```java
private String dataFileName
```

データファイル名

---

### bufferSize

```java
private int bufferSize
```

ファイル読み込みの際に使用するバッファのサイズ（デフォルトは8192B）

---

### layoutFileBasePathName

```java
private String layoutFileBasePathName
```

フォーマット定義ファイルのベースパス論理名

---

### dataFileBasePathName

```java
private String dataFileBasePathName
```

データファイルのベースパス論理名

---

## コンストラクタの詳細

### FileDataReader

```java
public FileDataReader()
```

{@code FileDataReader}オブジェクトを生成する。

---

## メソッドの詳細

### read

```java
public synchronized DataRecord read(ExecutionContext ctx)
```

データファイルを1レコードづつ読み込む。
<p/>
読み込んだ際のレコード番号を実行コンテキストに格納する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
1レコード分のデータレコード（読み込むデータがなかった場合は{@code null}）

---

### hasNext

```java
public synchronized boolean hasNext(ExecutionContext ctx)
```

次に読み込むデータが存在するかどうかを返却する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
読み込むデータが存在する場合は {@code true}

---

### close

```java
public synchronized void close(ExecutionContext ctx)
```

指定されたデータファイルに対するストリームを閉じ、ファイルハンドラを開放する。
<p/>
このリーダを閉じる前に、読み込んだファイルの最終レコードのレコード番号を実行コンテキストに設定する。
<p/>
このリーダが既に閉じられている場合は何もしない。

---

### setLayoutFile

```java
public FileDataReader setLayoutFile(String layoutFile)
```

拡張子を除いた、フォーマット定義ファイルのファイル名を設定する。
<p/>
"format"という論理名のベースパス配下に存在する当該ファイルがフォーマット定義ファイルとして使用される。

**パラメータ:**
- `layoutFile` - フォーマット定義ファイル名

**戻り値:**
このオブジェクト自体

---

### setLayoutFile

```java
public FileDataReader setLayoutFile(String basePathName, String fileName)
```

フォーマット定義ファイルのベースパス論理名および拡張子を除いたファイル名を設定する。
<p/>
設定した論理名のペースパス配下に存在する当該ファイルがフォーマット定義ファイルとして使用される。

**パラメータ:**
- `basePathName` - ベースパス論理名
- `fileName` - フォーマット定義ファイル名

**戻り値:**
このオブジェクト自体

---

### setDataFile

```java
public FileDataReader setDataFile(String fileName)
```

データファイルのファイル名を設定する。
<p/>
"input"という論理名のベースパス配下に存在する当該ファイルがデータファイルとして使用される。

**パラメータ:**
- `fileName` - データファイル名

**戻り値:**
このオブジェクト自体

---

### setDataFile

```java
public FileDataReader setDataFile(String basePathName, String fileName)
```

データファイルのベースパス論理名およびファイル名を設定する。
<p/>
設定したベースパス配下に存在する当該のファイルがデータファイルとして使用される。

**パラメータ:**
- `basePathName` - ベースパス論理名
- `fileName` - データファイル名

**戻り値:**
このオブジェクト自体

---

### setBufferSize

```java
public FileDataReader setBufferSize(int bufferSize)
```

レコード読み込み時に使用するバッファのサイズを設定する。
<p/>
デフォルトでは8KBのバッファを使用する。

**パラメータ:**
- `bufferSize` - レコード読み込み時に使用するバッファのサイズ

**戻り値:**
このオブジェクト自体

---

### createFileRecordReader

```java
protected FileRecordReader createFileRecordReader()
```

{@code FileRecordReader}オブジェクトを生成する。

**戻り値:**
FileRecordReaderオブジェクト

**例外:**
- `IllegalStateException` - 必須であるプロパティが設定されていない場合

---

### getFileReader

```java
protected synchronized FileRecordReader getFileReader()
```

{@code FileRecordReader}オブジェクトを取得する。

**戻り値:**
FileRecordReaderオブジェクト（FileRecordReaderオブジェクトが生成されていない場合は{@code null}）

---

### setFileReader

```java
protected synchronized void setFileReader(FileRecordReader fileReader)
```

{@code FileRecordReader}オブジェクトを設定する。

**パラメータ:**
- `fileReader` - {@code FileRecordReader}オブジェクト

---
