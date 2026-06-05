# class DeleteInsertBatchlet

**パッケージ:** nablarch.etl

**継承階層:**
```
java.lang.Object
  └─ AbstractBatchlet
      └─ nablarch.etl.DeleteInsertBatchlet
```

---

```java
public class DeleteInsertBatchlet
extends AbstractBatchlet
```

テーブル間のデータ転送を行う{@link javax.batch.api.Batchlet}実装クラス。
<p/>
移送先テーブルのデータをクリーニング後に、移送元のデータを一括で移送先のテーブルに転送（登録）する。

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

### rangeUpdateHelper

```java
private final RangeUpdateHelper rangeUpdateHelper
```

範囲更新のヘルパークラス

---

### stepConfig

```java
private final StepConfig stepConfig
```

ETLの設定

---

### progressManager

```java
private final ProgressManager progressManager
```

進捗状況を管理するBean

---

## コンストラクタの詳細

### DeleteInsertBatchlet

```java
public DeleteInsertBatchlet(JobContext jobContext, StepContext stepContext, RangeUpdateHelper rangeUpdateHelper, StepConfig stepConfig, ProgressManager progressManager)
```

コンストラクタ。

**パラメータ:**
- `jobContext` - {@link JobContext}
- `stepContext` - {@link StepContext}
- `rangeUpdateHelper` - {@link RangeUpdateHelper}
- `stepConfig` - ステップ設定
- `progressManager` - {@link ProgressManager}

---

## メソッドの詳細

### process

```java
public String process()
               throws Exception
```

一括登録処理を行う。

**戻り値:**
結果(SUCCESS固定)

**例外:**
- `Exception` - 例外

---

### verify

```java
private void verify(DbToDbStepConfig config)
```

設定値の検証を行う。

**パラメータ:**
- `config` - 設定

---

### cleaning

```java
private void cleaning(AppDbConnection connection, DbToDbStepConfig config)
```

テーブルのクリーニング処理を行う。

**パラメータ:**
- `connection` - データベース接続
- `config` - 設定

---

### insert

```java
private void insert(AppDbConnection connection, DbToDbStepConfig config)
```

テーブルへの登録処理を行う。

**パラメータ:**
- `connection` - データベース接続
- `config` - 設定

---

### commit

```java
private static void commit()
```

コミットを行う。

---

### loggingCleaning

```java
private void loggingCleaning(String tableName, int deleteCount)
```

クリーニングのログを出力する。

**パラメータ:**
- `tableName` - クリーンしたテーブル名
- `deleteCount` - 削除した件数

---
