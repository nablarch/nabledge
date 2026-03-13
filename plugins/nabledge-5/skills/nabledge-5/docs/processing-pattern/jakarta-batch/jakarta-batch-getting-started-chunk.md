# データを導出するバッチの作成(Chunkステップ)

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/getting_started/chunk/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/api/chunk/ItemReader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/api/chunk/AbstractItemReader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/javax/inject/Named.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/javax/enterprise/context/Dependent.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/api/chunk/ItemProcessor.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/api/chunk/ItemWriter.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/api/chunk/AbstractItemWriter.html)

## 入力データソースからデータを読み込む

## フォームの作成

ItemReaderとItemProcessorとのデータ連携にはフォームを使用する。

```java
public class EmployeeForm {

    //一部のみ抜粋

    /** 社員ID */
    private Long employeeId;

    public Long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Long employeeId) {
        this.employeeId = employeeId;
    }
}
```

## ItemReaderの作成

`AbstractItemReader` を継承して実装する。**アノテーション**: `@Named`, `@Dependent` をクラスに付与する。

実装するメソッド:

| メソッド | 責務 |
|---|---|
| `open` | 処理対象データの読み込み |
| `readItem` | 一行分のデータを返却（nullを返すと処理終了） |
| `close` | リソースのクローズ |

```java
@Dependent
@Named
public class EmployeeSearchReader extends AbstractItemReader {
    private DeferredEntityList<EmployeeForm> list;
    private Iterator<EmployeeForm> iterator;

    @Override
    public void open(Serializable checkpoint) throws Exception {
        list = (DeferredEntityList<EmployeeForm>) UniversalDao.defer()
                .findAllBySqlFile(EmployeeForm.class, "SELECT_EMPLOYEE");
        iterator = list.iterator();
    }

    @Override
    public Object readItem() {
        if (iterator.hasNext()) {
            return iterator.next();
        }
        return null;
    }

    @Override
    public void close() throws Exception {
        list.close();
    }
}
```

SQLファイル例 (EmployeeForm.sql):

```sql
SELECT_EMPLOYEE=
SELECT
    EMPLOYEE.EMPLOYEE_ID, EMPLOYEE.FULL_NAME, EMPLOYEE.BASIC_SALARY,
    EMPLOYEE.GRADE_CODE, GRADE.BONUS_MAGNIFICATION, GRADE.FIXED_BONUS
FROM EMPLOYEE
INNER JOIN GRADE ON EMPLOYEE.GRADE_CODE = GRADE.GRADE_CODE
```

- 大量データの場合は `UniversalDao#defer` で [遅延ロード](../../component/libraries/libraries-universal_dao.md) する（メモリ逼迫防止）
- `readItem` で返却したオブジェクトが後続の `ItemProcessor` の `processItem` の引数になる

<details>
<summary>keywords</summary>

AbstractItemReader, ItemReader, DeferredEntityList, UniversalDao, @Named, @Dependent, ItemReader実装, 遅延ロード, 大量データ読み込み, フォーム, Chunkステップ入力, open, readItem, close, EmployeeSearchReader, EmployeeForm

</details>

## 業務ロジックを実行する

`ItemProcessor` を実装して業務ロジックを実行する。永続化処理は `ItemWriter` の責務のため、ItemProcessorでは実施しない。

実装するメソッド:

| メソッド | 責務 |
|---|---|
| `processItem` | 一行分のデータに対する業務処理 |

```java
@Dependent
@Named
public class BonusCalculateProcessor implements ItemProcessor {
    @Override
    public Object processItem(Object item) {
        EmployeeForm form = (EmployeeForm) item;
        Bonus bonus = new Bonus();
        bonus.setEmployeeId(form.getEmployeeId());
        bonus.setPayments(calculateBonus(form));
        return bonus;
    }
}
```

- `processItem` で一定数（`item-count` 属性で設定）のエンティティを返却した時点で、後続の `ItemWriter` の `writeItems` が実行される

<details>
<summary>keywords</summary>

ItemProcessor, 業務ロジック実装, Chunkステップ処理, processItem, BonusCalculateProcessor, @Named, @Dependent, Bonus, EmployeeForm

</details>

## 永続化処理を行う

`ItemWriter` を実装してデータを永続化する。

実装するメソッド:

| メソッド | 責務 |
|---|---|
| `writeItems` | データの永続化 |

```java
@Dependent
@Named
public class BonusWriter extends AbstractItemWriter {
    @Override
    public void writeItems(List<Object> items) {
        UniversalDao.batchInsert(items);
    }
}
```

- `UniversalDao#batchInsert` でエンティティリストを一括登録する
- `writeItems` 実行後にトランザクションがコミットされ、新たなトランザクションが開始される
- `writeItems` 実行後、バッチ処理は `readItem` から繰り返される

<details>
<summary>keywords</summary>

ItemWriter, AbstractItemWriter, UniversalDao, batchInsert, 一括登録, トランザクションコミット, 永続化処理, writeItems, BonusWriter, @Named, @Dependent

</details>

## JOB設定ファイルを作成する

ジョブ定義XMLファイルを `/src/main/resources/META-INF/batch-jobs/` に配置する。

- `job` 要素の `id` 属性でジョブ名称を指定する
- `chunk` 要素の `item-count` 属性で `writeItems` 一回当たりの処理件数を設定する

```xml
<job id="bonus-calculate" xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="1.0">
  <listeners>
    <listener ref="nablarchJobListenerExecutor" />
  </listeners>
  <step id="step1">
    <listeners>
      <listener ref="nablarchStepListenerExecutor" />
      <listener ref="nablarchItemWriteListenerExecutor" />
    </listeners>
    <chunk item-count="1000">
      <reader ref="employeeSearchReader" />
      <processor ref="bonusCalculateProcessor" />
      <writer ref="bonusWriter" />
    </chunk>
  </step>
</job>
```

<details>
<summary>keywords</summary>

ジョブ定義XML, batch-jobs, item-count, META-INF/batch-jobs, chunk要素, nablarchJobListenerExecutor, nablarchStepListenerExecutor, nablarchItemWriteListenerExecutor, ジョブ名称

</details>
