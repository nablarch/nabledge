# class DatabaseItemWriter

**パッケージ:** nablarch.etl

**継承階層:**
```
java.lang.Object
  └─ AbstractItemWriter
      └─ nablarch.etl.DatabaseItemWriter
```

---

```java
public class DatabaseItemWriter
extends AbstractItemWriter
```

データベースのテーブルに対してデータを書き込む{@link javax.batch.api.chunk.ItemWriter}実装クラス。
<p/>
{@link UniversalDao#insert(Object)}を使用して、Entityオブジェクトの内容をデータベースに登録する。

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
private final StepConfig stepConfig
```

ETLの設定

---

## コンストラクタの詳細

### DatabaseItemWriter

```java
public DatabaseItemWriter(JobContext jobContext, StepContext stepContext, StepConfig stepConfig)
```

コンストラクタ。

**パラメータ:**
- `jobContext` - {@link JobContext}
- `stepContext` - {@link StepContext}
- `stepConfig` - ステップの設定

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
                throws Exception
```

---

### loggingStartChunk

```java
private void loggingStartChunk(String tableName)
```

進捗ログを出力する。

**パラメータ:**
- `tableName` - 登録先テーブル名

---

### getStepConfigClassName

```java
private String getStepConfigClassName()
```

{@link StepConfig}のクラス名を返す。
<p>
{@link StepConfig}が{@code null}の場合は、文字列の{@code null}を返す。

**戻り値:**
StepConfigのクラス名

---
