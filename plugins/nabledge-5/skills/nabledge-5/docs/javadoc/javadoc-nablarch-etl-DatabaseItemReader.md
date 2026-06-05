# class DatabaseItemReader

**パッケージ:** nablarch.etl

**継承階層:**
```
java.lang.Object
  └─ BaseDatabaseItemReader
      └─ nablarch.etl.DatabaseItemReader
```

---

```java
public class DatabaseItemReader
extends BaseDatabaseItemReader
```

指定されたSELECT文を使ってテーブルから取得したレコードの読み込みを行う{@link AbstractItemReader}の実装クラス。

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

### progressManager

```java
private final ProgressManager progressManager
```

進捗状況を管理するBean

---

### stepConfig

```java
private final DbInputStepConfig stepConfig
```

ETLの設定

---

### reader

```java
private Iterator<?> reader
```

テーブルのデータを格納する変数

---

## コンストラクタの詳細

### DatabaseItemReader

```java
public DatabaseItemReader(JobContext jobContext, StepContext stepContext, ProgressManager progressManager, StepConfig stepConfig)
```

コンストラクタ。

**パラメータ:**
- `jobContext` - {@link JobContext}
- `stepContext` - {@link StepContext}
- `progressManager` - {@link ProgressManager}
- `stepConfig` - ステップ設定

---

## メソッドの詳細

### doOpen

```java
public void doOpen(Serializable checkpoint)
            throws SQLException
```

テーブルにアクセスして指定されたSELECT文を使ってレコードを取得する。

---

### readItem

```java
public Object readItem()
```

---
