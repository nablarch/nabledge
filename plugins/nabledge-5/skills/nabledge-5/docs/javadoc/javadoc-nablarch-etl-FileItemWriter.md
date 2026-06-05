# class FileItemWriter

**パッケージ:** nablarch.etl

**継承階層:**
```
java.lang.Object
  └─ AbstractItemWriter
      └─ nablarch.etl.FileItemWriter
```

---

```java
public class FileItemWriter
extends AbstractItemWriter
```

ファイルにデータを書き込む{@link javax.batch.api.chunk.ItemWriter}の実装クラス。

**作成者:** Kumiko Omi  

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
private final StepConfig stepConfig
```

ETLの設定

---

### outputFileBasePath

```java
private final File outputFileBasePath
```

出力ファイルのベースパス

---

### mapper

```java
private ObjectMapper<Object> mapper
```

Javaオブジェクトからデータに変換を行うマッパー

---

## コンストラクタの詳細

### FileItemWriter

```java
public FileItemWriter(JobContext jobContext, StepContext stepContext, StepConfig stepConfig, File outputFileBasePath)
```

コンストラクタ。

**パラメータ:**
- `jobContext` - {@link JobContext}
- `stepContext` - {@link StepContext}
- `stepConfig` - ステップの設定
- `outputFileBasePath` - 出力先ディレクトリ

---

## メソッドの詳細

### open

```java
public void open(Serializable checkpoint)
          throws Exception
```

---

### writeItems

```java
public void writeItems(List<Object> items)
                throws IOException
```

---

### close

```java
public void close()
           throws Exception
```

---
