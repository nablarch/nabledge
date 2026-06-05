# class MergeBatchlet

**パッケージ:** nablarch.etl

**継承階層:**
```
java.lang.Object
  └─ AbstractBatchlet
      └─ nablarch.etl.MergeBatchlet
```

---

```java
public class MergeBatchlet
extends AbstractBatchlet
```

入力リソース(SELECT文の結果)を出力テーブルにMERGEする{@link javax.batch.api.Batchlet}実装クラス。

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
private final DbToDbStepConfig stepConfig
```

ETLの設定

---

### rangeUpdateHelper

```java
private final RangeUpdateHelper rangeUpdateHelper
```

範囲更新のヘルパークラス

---

### progressManager

```java
private final ProgressManager progressManager
```

進捗状況を管理するBean

---

## コンストラクタの詳細

### MergeBatchlet

```java
public MergeBatchlet(JobContext jobContext, StepContext stepContext, StepConfig stepConfig, RangeUpdateHelper rangeUpdateHelper, ProgressManager progressManager)
```

コンストラクト。

**パラメータ:**
- `jobContext` - {@link JobContext}
- `stepContext` - {@link StepContext}
- `stepConfig` - ステップの設定
- `rangeUpdateHelper` - 範囲更新のヘルパー
- `progressManager` - 進捗状況を管理するBean

---

## メソッドの詳細

### process

```java
public String process()
               throws Exception
```

一括でのMERGE処理を行う。

**戻り値:**
結果(SUCCESS固定)

**例外:**
- `Exception` - 例外

---

### commit

```java
private static void commit()
```

コミットを行う。

---
