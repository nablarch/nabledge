# データを導出するバッチの作成(Chunkステップ)

## 動作確認手順

賞与計算バッチの動作確認手順:

1. 登録対象テーブル(賞与テーブル)のデータを削除

   H2のコンソールから下記SQLを実行し、賞与テーブルのデータを削除する。

   ```sql
   TRUNCATE TABLE BONUS;
   ```

2. 賞与計算バッチを実行

   コマンドプロンプトから賞与計算バッチを実行する。

   ```bash
   $cd {nablarch-example-batch-eeシステムリポジトリ}
   $mvn exec:java -Dexec.mainClass=nablarch.fw.batch.ee.Main \
       -Dexec.args=bonus-calculate
   ```

5. バッチ実行後の状態の確認

   H2のコンソールから下記SQLを実行し、賞与情報が登録されたことを確認する。

   ```sql
   SELECT * FROM BONUS;
   ```

## バッチ処理の構成

バッチ処理は、JSR352で規定されたインターフェースの実装に加えて、トランザクション制御などの共通的な処理を提供するリスナーによって構成する。

リスナーの詳細は:ref:`バッチアプリケーションで使用するリスナー<jsr352-listener>`および:ref:`リスナーの指定方法<jsr352-listener>`を参照。

## 入力データソースからデータを読み込む

ChunkステップではItemReader(`ItemReader`)とItemProcessor(`ItemProcessor`)間のデータ連携にフォームを使用する。

**フォームの作成**: ItemReaderとItemProcessor間のデータ連携に使用するフォームクラスを作成する。

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

**ItemReaderの作成**: `AbstractItemReader`を継承し`open`・`readItem`・`close`を実装する。

**アノテーション**: `Named`・`Dependent`をクラスに付与する（:ref:`getting_started_batchlet-cdi`参照）。

実装のポイント:

- `open`メソッドで処理対象データを読み込む
- 大量データを扱う場合は`UniversalDao#defer`で:ref:`遅延ロード<universal_dao-lazy_load>`し、メモリ逼迫を防ぐ
- `readItem`は一行分のデータを返却する。返却オブジェクトは後続の`ItemProcessor`の`processItem`の引数になる

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

SQLファイル（:ref:`universal_dao-sql_file`参照）:

```sql
SELECT_EMPLOYEE=
SELECT
    EMPLOYEE.EMPLOYEE_ID, EMPLOYEE.FULL_NAME, EMPLOYEE.BASIC_SALARY,
    EMPLOYEE.GRADE_CODE, GRADE.BONUS_MAGNIFICATION, GRADE.FIXED_BONUS
FROM EMPLOYEE
INNER JOIN GRADE ON EMPLOYEE.GRADE_CODE = GRADE.GRADE_CODE
```

## 業務ロジックを実行する

**クラス**: `ItemProcessor`を実装し`processItem`を実装する。

- 永続化処理は`ItemWriter`の責務であり、ItemProcessorでは行わない
- `processItem`で一定数のオブジェクトを返却した時点で`ItemWriter`の`writeItems`が実行される

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

    private static Long calculateBonus(EmployeeForm form) {
        if (form.getFixedBonus() == null) {
            return form.getBasicSalary() * form.getBonusMagnification() / 100;
        } else {
            return form.getFixedBonus();
        }
    }
}
```

## 永続化処理を行う

**クラス**: `AbstractItemWriter`（`ItemWriter`）を継承し`writeItems`を実装する。

- `UniversalDao#batchInsert`でエンティティのリストを一括登録する
- `writeItems`実行後にトランザクションがコミットされ、新たなトランザクションが開始される
- `writeItems`実行後、バッチ処理は`readItem`実行から繰り返される

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

## JOB設定ファイルを作成する

ジョブ定義ファイルは`/src/main/resources/META-INF/batch-jobs/`配下に配置する。

- `job`要素の`id`属性でジョブ名称を指定する
- `chunk`要素の`item-count`属性で`writeItems`一回当たりの処理件数を設定する

```xml
<job id="bonus-calculate" xmlns="https://jakarta.ee/xml/ns/jakartaee" version="2.0">
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
