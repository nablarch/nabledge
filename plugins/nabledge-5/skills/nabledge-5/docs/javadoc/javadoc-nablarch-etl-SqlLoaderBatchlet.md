# class SqlLoaderBatchlet

**パッケージ:** nablarch.etl

**継承階層:**
```
java.lang.Object
  └─ AbstractBatchlet
      └─ nablarch.etl.SqlLoaderBatchlet
```

---

```java
public class SqlLoaderBatchlet
extends AbstractBatchlet
```

SQL*Loaderを用いてCSVファイルのデータをワークテーブルに登録する{@link javax.batch.api.Batchlet}の実装クラス。

**作成者:** Naoki Yamamoto  

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

### sqlLoaderControlFileBasePath

```java
private final File sqlLoaderControlFileBasePath
```

SQLLoaderに使用するコントロールファイルのベースパス

---

### sqlLoaderOutputFileBasePath

```java
private final File sqlLoaderOutputFileBasePath
```

SQLLoaderが出力するファイルのベースパス

---

## コンストラクタの詳細

### SqlLoaderBatchlet

```java
public SqlLoaderBatchlet(JobContext jobContext, StepContext stepContext, StepConfig stepConfig, File inputFileBasePath, File sqlLoaderControlFileBasePath, File sqlLoaderOutputFileBasePath)
```

コンストラクタ。

**パラメータ:**
- `jobContext` - JobContext
- `stepContext` - StepContext
- `stepConfig` - ステップの設定
- `inputFileBasePath` - 入力ファイルのあるディレクトリ
- `sqlLoaderControlFileBasePath` - SQL*Loaderのコントロールファイルが置かれたディレクトリ
- `sqlLoaderOutputFileBasePath` - SQL*Loaderが出力するファイルを置くディレクトリ

---

## メソッドの詳細

### process

```java
public String process()
               throws Exception
```

SQL*Loaderを実行してCSVファイルのデータをワークテーブルに一括登録する。

**戻り値:**
実行結果

**例外:**
- `Exception` - 例外

---
