# 対象テーブルのデータを削除するバッチの作成(Batchletステップ)

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/getting_started/batchlet/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/api/Batchlet.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/api/AbstractBatchlet.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/javax/inject/Named.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/javax/enterprise/context/Dependent.html)

## 対象テーブルのデータを削除する

## 対象テーブルのデータを削除する

**インタフェースと実装**

| インタフェース | 実装 |
|---|---|
| `Batchlet` | バッチ処理を実装する。`AbstractBatchlet` を継承し `process`/`stop` をオーバーライドする |

> **補足**: バッチ処理はリスナーによって構成する。[jsr352-listener](jakarta-batch-architecture.md) および [jsr352-listener_definition](jakarta-batch-architecture.md) を参照。

**Batchlet実装クラス**

```java
@Dependent
@Named
public class TruncateTableBatchlet extends AbstractBatchlet {

    @Inject
    @BatchProperty
    private String tableName;

    @Override
    public String process() {

        final AppDbConnection conn = DbConnectionContext.getConnection();
        final SqlPStatement statement
            = conn.prepareStatement("TRUNCATE TABLE " + tableName);
        statement.executeUpdate();

        return "SUCCESS";
    }
}
```

- `AbstractBatchlet` を継承し `process` メソッドで業務処理を実装する
- `Named` と `Dependent` をクラスに付与してCDI管理Beanにする。これによりジョブ定義のBatchlet `ref` 属性にCDI管理名（クラス名の頭文字を小文字にした名称）で記述できる（付与しない場合はFQCNで記述する）
- [database](../../component/libraries/libraries-database.md) を使用してDB操作を実行する

**ジョブ定義ファイル**

```xml
<job id="zip-code-truncate-table" xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="1.0">
  <listeners>
    <listener ref="nablarchJobListenerExecutor" />
  </listeners>

  <step id="step1" next="step2">
    <listeners>
      <listener ref="nablarchStepListenerExecutor" />
    </listeners>
    <batchlet ref="truncateTableBatchlet">
      <properties>
        <property name="tableName" value="ZIP_CODE_DATA" />
      </properties>
    </batchlet>
  </step>
  <step id="step2">
    <listeners>
      <listener ref="nablarchStepListenerExecutor" />
    </listeners>
    <batchlet ref="truncateTableBatchlet">
      <properties>
        <property name="tableName" value="ZIP_CODE_DATA_WORK" />
      </properties>
    </batchlet>
  </step>
</job>
```

- ジョブ定義ファイルは `/src/main/resources/META-INF/batch-jobs/` 配下に配置する
- `job` 要素の `id` 属性でジョブ名称を指定する
- `batchlet` 要素の `ref` 属性にはBatchletクラス名の頭文字を小文字にした名称を指定する
- `property` 要素でBatchletクラスのプロパティにインジェクションする値を指定する
- 複数ステップで構成する場合は `step` 要素を複数定義し順次実行する

<details>
<summary>keywords</summary>

Batchlet, AbstractBatchlet, TruncateTableBatchlet, @Named, @Dependent, @BatchProperty, @Inject, AppDbConnection, DbConnectionContext, SqlPStatement, Batchletステップ実装, CDI管理Bean, ジョブ定義ファイル, バッチプロパティインジェクション

</details>
