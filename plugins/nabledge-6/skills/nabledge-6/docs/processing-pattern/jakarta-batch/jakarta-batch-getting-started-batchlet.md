# 対象テーブルのデータを削除するバッチの作成(Batchletステップ)

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/getting_started/batchlet/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/batch/api/Batchlet.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/batch/api/AbstractBatchlet.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/inject/Named.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/enterprise/context/Dependent.html)

## バッチの実行方法

JSR-352バッチジョブは `nablarch.fw.batch.ee.Main` をメインクラスとして起動し、ジョブ名を引数として渡す。

```
$mvn exec:java -Dexec.mainClass=nablarch.fw.batch.ee.Main ^
    -Dexec.args=zip-code-truncate-table
```

実行ポイント:
- **メインクラス**: `nablarch.fw.batch.ee.Main` がNablarchのJSR-352バッチ起動クラスである。
- **ジョブ名**: `-Dexec.args` にジョブ定義ファイルの `job` 要素 `id` 属性で指定したジョブ名（例: `zip-code-truncate-table`）を渡す。

<details>
<summary>keywords</summary>

nablarch.fw.batch.ee.Main, メインクラス, ジョブ名指定, exec:java, zip-code-truncate-table, バッチ起動コマンド, JSR-352バッチ実行

</details>

## 対象テーブルのデータを削除する

**Batchletクラスの作成**

**クラス**: `Batchlet`, `AbstractBatchlet`

| インタフェース | 実装内容 |
|---|---|
| `Batchlet` | バッチ処理を実装する。デフォルト実装 `AbstractBatchlet` を継承する。オーバーライドメソッド: `Batchlet#process`, `Batchlet#stop` |

> **補足**: バッチ処理はインタフェース実装に加え、トランザクション制御などの共通処理を提供するリスナーで構成する。[バッチアプリケーションで使用するリスナー](jakarta-batch-architecture.md) 及び [リスナーの指定方法](jakarta-batch-architecture.md) を参照。

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

実装ポイント:
- `AbstractBatchlet` を継承し `process` メソッドで業務処理を実装する。
- **アノテーション**: `Named` と `Dependent` をクラスに付与してCDI管理Beanにする。ジョブ定義でCDI管理名を使用できる（CDI管理Beanとしない場合はFQCNで記述）。
- [データベースアクセス](../../component/libraries/libraries-database.md) を使用してTRUNCATE文を実行する。

**ジョブ定義ファイルの作成**

ジョブ定義ファイルは `/src/main/resources/META-INF/batch-jobs/` 配下に配置する。

```xml
<job id="zip-code-truncate-table" xmlns="https://jakarta.ee/xml/ns/jakartaee" version="2.0">
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

実装ポイント:
- `job` 要素の `id` 属性でジョブ名称を指定する。
- 複数ステップ構成の場合は `step` 要素を複数定義し順次実行する。
- `batchlet` 要素の `ref` 属性にはBatchletクラス名の頭文字を小文字にした名称を指定する。
- `property` 要素でBatchletクラスのプロパティにインジェクトする値を指定する。

<details>
<summary>keywords</summary>

TruncateTableBatchlet, AbstractBatchlet, Batchlet, jakarta.batch.api.Batchlet, @Dependent, @Named, @Inject, @BatchProperty, AppDbConnection, DbConnectionContext, SqlPStatement, Batchletステップ実装, テーブルデータ削除バッチ, CDI管理Bean登録, ジョブ定義ファイル設定, バッチプロパティインジェクション

</details>
