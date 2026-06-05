# interface DataRecordFormatter

**パッケージ:** nablarch.core.dataformat

**継承階層:**
```
java.lang.Object
  └─ Closeable
      └─ nablarch.core.dataformat.DataRecordFormatter
```

---

```java
public interface DataRecordFormatter
extends Closeable
```

データファイルとJavaオブジェクトのシリアライズ／デシリアライズを行うクラスが実装するインタフェース。

**作成者:** Iwauo Tajima  

---

## メソッドの詳細

### readRecord

```java
DataRecord readRecord()
                      throws IOException, InvalidDataFormatException
```

入力ストリームから1レコード分のデータを読み込み、データレコードを返却する。
入力ストリームが既に終端に達していた場合は{@code null}を返却する。

**戻り値:**
データレコード

**例外:**
- `IOException` - 入力ストリームの読み込みに失敗した場合
- `InvalidDataFormatException` - 読み込んだデータがフォーマット定義に違反している場合

---

### writeRecord

```java
void writeRecord(Map<String,?> record)
                 throws IOException, InvalidDataFormatException
```

出力ストリームに1レコード分の内容を書き込む。
<p/>
出力時に使用するデータレイアウト（レコードタイプ）は、{@link Map}の内容をもとに自動的に判定される。
<p/>
引数が{@link DataRecord}型かつレコードタイプが指定されている場合、
フォーマット定義ファイルのレコードタイプ識別フィールド定義よりも、指定されたレコードタイプを優先して書き込みを行う。

**パラメータ:**
- `record` - 出力するレコードの内容を格納したMap

**例外:**
- `IOException` - 出力ストリームの書き込みに失敗した場合
- `InvalidDataFormatException` - 書き込むデータの内容がフォーマット定義に違反している場合

---

### writeRecord

```java
void writeRecord(String recordType, Map<String,?> record)
                 throws IOException, InvalidDataFormatException
```

指定したデータレイアウト（レコードタイプ）で、出力ストリームに1レコード分の内容を書き込む。

**パラメータ:**
- `recordType` - レコードタイプ
- `record` - 出力するレコードの内容を格納したMap

**例外:**
- `IOException` - 出力ストリームの書き込みに失敗した場合
- `InvalidDataFormatException` - 書き込むデータの内容がフォーマット定義に違反している場合

---

### initialize

```java
DataRecordFormatter initialize()
```

初期化処理を行う。

**戻り値:**
本クラスのインスタンス

---

### setInputStream

```java
DataRecordFormatter setInputStream(InputStream stream)
```

入力ストリームを設定する。

**パラメータ:**
- `stream` - 入力ストリーム

**戻り値:**
本クラスのインスタンス

---

### close

```java
void close()
```

内部的に保持している各種リソースを開放する。

---

### setDefinition

```java
DataRecordFormatter setDefinition(LayoutDefinition definition)
```

フォーマット定義ファイルの情報を保持するクラスを設定する。

**パラメータ:**
- `definition` - フォーマット定義ファイルの定義情報

**戻り値:**
本クラスのインスタンス

---

### setOutputStream

```java
DataRecordFormatter setOutputStream(OutputStream stream)
```

出力ストリームを設定する。

**パラメータ:**
- `stream` - 出力ストリーム

**戻り値:**
本クラスのインスタンス

---

### hasNext

```java
boolean hasNext()
                throws IOException
```

次に読み込む行の有無を判定する。

**戻り値:**
次に読み込む行がある場合{@code true}

**例外:**
- `IOException` - 入力ストリームの読み込みに失敗した場合

---

### getRecordNumber

```java
int getRecordNumber()
```

読み込みまたは書き込み中のレコードのレコード番号を返却する。

**戻り値:**
レコード番号

---
