# 対象テーブルのデータを削除するバッチの作成(Batchletステップ)

Exampleアプリケーションを元に、 batchletステップ で対象テーブルのデータを削除するバッチを解説する。

作成する機能の説明
1. 現在のDBの状態の確認

  H2のコンソールから下記SQLを実行する。

  ```sql
  SELECT * FROM ZIP_CODE_DATA;
  SELECT * FROM ZIP_CODE_DATA_WORK;
  ```

  データが登録されていない場合は 2の手順を実施する。
2. (データが登録されていない場合)住所登録バッチを実行

コマンドプロンプトから下記コマンドを実行する。

```bash
$cd {nablarch-example-batch-eeシステムリポジトリ}
$mvn exec:java -Dexec.mainClass=nablarch.fw.batch.ee.Main ^
    -Dexec.args=etl-zip-code-csv-to-db-chunk
```

H2のコンソールから下記SQLを実行してデータが登録されたことを確認する。

```sql
SELECT * FROM ZIP_CODE_DATA;
SELECT * FROM ZIP_CODE_DATA_WORK;
```

1. 住所テーブル削除バッチを実行

コマンドプロンプトから下記コマンドを実行する。

```bash
$cd {nablarch-example-batch-eeシステムリポジトリ}
$mvn exec:java -Dexec.mainClass=nablarch.fw.batch.ee.Main ^
    -Dexec.args=zip-code-truncate-table
```

1. 対象テーブルのデータが削除されていることを確認

  H2のコンソールから下記SQLを実行し、データが削除されていることを確認する。

  ```sql
  SELECT * FROM ZIP_CODE_DATA;
  SELECT * FROM ZIP_CODE_DATA_WORK;
  ```

## 対象テーブルのデータを削除する

住所情報を削除するバッチの実装方法を説明する。

処理フローについては、 [Batchletステップのバッチの処理フロー](../../processing-pattern/jakarta-batch/jakarta-batch-architecture.md#jsr352-batch-flow-batchlet) を参照。
責務配置については [Batchletステップの責務配置](../../processing-pattern/jakarta-batch/jakarta-batch-application-design.md#jsr352-batchlet-design) を参照。

1. [Batchletの作成](../../processing-pattern/jakarta-batch/jakarta-batch-getting-started-batchlet.md#getting-started-batchlet-create)
2. [JOB設定ファイルの作成](../../processing-pattern/jakarta-batch/jakarta-batch-getting-started-batchlet.md#getting-started-batchlet-job)

Batchletの作成
住所情報を削除するバッチのBatchletクラスを作成する。

実装すべきインタフェースとその責務
Batchletクラスに以下のインタフェースを実装してバッチ処理を作成する。オーバーライドしたメソッドは、Batch Runtimeによって適切なタイミングで呼び出される。

| インタフェース | 実装 |
|---|---|
| Batchlet | バッチ処理を実装する。  デフォルト実装を提供する AbstractBatchlet を継承する。  * Batchlet#process * Batchlet#stop |

> **Tip:**
> バッチ処理は、上記のインタフェースの実装に加えて、トランザクション制御などの共通的な処理を提供するリスナーによって構成する。
> リスナーの詳細は [バッチアプリケーションで使用するリスナー](../../processing-pattern/jakarta-batch/jakarta-batch-architecture.md#jsr352-listener) 及び [リスナーの指定方法](../../processing-pattern/jakarta-batch/jakarta-batch-architecture.md#jsr352-listener-definition) を参照。

TruncateTableBatchlet.java
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

この実装のポイント
* AbstractBatchlet を継承し、 process メソッドで業務処理を行う。

* Named と Dependent をクラスに付与する。 
  
  Named及びDependentアノテーションを設定することで、Batchlet実装クラスをCDIの管理Beanにできる。
  これにより、ジョブ定義に指定するBatchletクラス名をCDIの管理名で記述出来るようになる。 
  
  (CDI管理Beanとしなかった場合は、完全修飾名(FQCN)で記述する)
* [データベースアクセス](../../component/libraries/libraries-database.md#database) を使用してTRUNCATE文を実行する。

ジョブ定義ファイルの作成
ジョブの実行設定を定義したファイルを作成する。

zip-code-truncate-table.xml
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
この実装のポイント
* ジョブ定義ファイルは、/src/main/resources/META-INF/batch-jobs/ 配下に配置する。
* job 要素 の id 属性で、ジョブ名称を指定する。
* 複数ステップで構成されるバッチジョブの場合は、 step 要素を複数定義し、処理を順次実行する。
* batchlet 要素の ref 属性には、Batchletクラス名の頭文字を小文字にした名称を指定する。
* property 要素で、Batchletクラスのプロパティにインジェクトする値を指定する。
* 設定ファイルの詳細な記述方法は [JSR352 Specification(外部サイト、英語)](https://jcp.org/en/jsr/detail?id=352) を参照
