# class TableCleaningBatchlet

**パッケージ:** nablarch.etl

**継承階層:**
```
java.lang.Object
  └─ AbstractBatchlet
      └─ nablarch.etl.TableCleaningBatchlet
```

---

```java
public class TableCleaningBatchlet
extends AbstractBatchlet
```

テーブルのデータをクリーニング(truncate)する{@link javax.batch.api.Batchlet}実装クラス。
<p/>
{@link TruncateStepConfig}で指定されたEntityクラスに対応するテーブルのデータをクリーニング(truncate)する。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### stepConfig

```java
private final TruncateStepConfig stepConfig
```

ETLの設定

---

## コンストラクタの詳細

### TableCleaningBatchlet

```java
public TableCleaningBatchlet(StepConfig stepConfig)
```

コンストラクタ。

**パラメータ:**
- `stepConfig` - ステップの設定

---

## メソッドの詳細

### process

```java
public String process()
               throws Exception
```

{@inheritDoc}
<p/>
本処理では、TRUNCATEのSQL文を構築する際にステートメントを発行しているが、
RDBMS製品によっては、TRUNCATE文の発行はトランザクション内の最初のステートメントである必要があるため、
TRUNCATEのSQL文の構築後に明示的にトランザクションをロールバックしている。
<p/>
そのため、もしステップリスナ等で事前にデータベースへの更新等を行っている場合、
その処理は取り消されるため注意すること。

---
