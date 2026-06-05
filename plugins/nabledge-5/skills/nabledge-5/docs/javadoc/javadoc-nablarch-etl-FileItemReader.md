# class FileItemReader

**パッケージ:** nablarch.etl

**継承階層:**
```
java.lang.Object
  └─ AbstractItemReader
      └─ nablarch.etl.FileItemReader
```

---

```java
public class FileItemReader
extends AbstractItemReader
```

入力ファイルからJavaオブジェクトへ変換を行う{@link javax.batch.api.chunk.ItemReader}実装クラス。
<p/>
本実装ではチェックポイントはサポートしない。このため、restart時にはファイルの先頭から処理を再開する。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### jobContext

```java
private final JobContext jobContext
```

{@link JobContext}

---

### stepContext

```java
private final StepContext stepContext
```

{@link StepContext}

---

### stepConfig

```java
private final FileToDbStepConfig stepConfig
```

ETLの設定

---

### inputFileBasePath

```java
private final File inputFileBasePath
```

入力ファイルのベースパス

---

### progressManager

```java
private final ProgressManager progressManager
```

進捗状況を管理するBean

---

### reader

```java
private ObjectMapper<?> reader
```

データからJavaオブジェクトに変換を行うマッパー

---

## コンストラクタの詳細

### FileItemReader

```java
public FileItemReader(JobContext jobContext, StepContext stepContext, StepConfig stepConfig, File inputFileBasePath, ProgressManager progressManager)
```

コンストラクタ。

**パラメータ:**
- `jobContext` - {@link JobContext}
- `stepContext` - {@link StepContext}
- `stepConfig` - ステップの設定
- `inputFileBasePath` - 入力ファイルの配置ディレクトリ
- `progressManager` - 進捗状況を管理するBean

---

## メソッドの詳細

### open

```java
public void open(Serializable checkpoint)
          throws Exception
```

入力ファイルを開き、{@link ObjectMapper}を生成する。

---

### getNumberOfRecordInInputFile

```java
private long getNumberOfRecordInInputFile(InputStream inputStream)
```

入力ファイルのレコード数を返す。

**パラメータ:**
- `inputStream` - 入力ストリーム

**戻り値:**
レコード数

---

### createFileInputStream

```java
private InputStream createFileInputStream(File inputFilePath)
```

入力ファイルのストリームを生成する。

**パラメータ:**
- `inputFilePath` - 入力ファイルパス

**戻り値:**
入力ストリーム

---

### readItem

```java
public Object readItem()
                throws Exception
```

---

### close

```java
public void close()
           throws Exception
```

---
