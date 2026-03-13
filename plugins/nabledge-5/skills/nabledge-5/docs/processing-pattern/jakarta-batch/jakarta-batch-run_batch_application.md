# JSR352バッチアプリケーションの起動

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/feature_details/run_batch_application.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/Main.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/operations/JobOperator.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/runtime/BatchStatus.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/runtime/context/JobContext.html)

## バッチアプリケーションを起動する

## バッチアプリケーションを起動する

JSR352準拠バッチアプリケーションの起動はJSR352で規定されたAPIを使用する。

**クラス**: `nablarch.fw.batch.ee.Main`

実行引数: 対象JOBのXMLファイル名（`.xml`を除いたファイル名）を指定する。

ジョブ実行時にパラメータを指定する場合は起動オプション（`--名前 値`形式）で指定する。指定した値は `JobOperator#start` のjobParametersに設定される。

```bash
# option1=value1 と option2=value2 の2つのjobParametersが設定される
java nablarch.fw.batch.ee.Main jobName --option1 value1 --option2 value2
```

> **補足**: プロジェクト独自の起動クラス作成時には `Main` を参考に実装できる。

<details>
<summary>keywords</summary>

nablarch.fw.batch.ee.Main, JSR352, バッチアプリケーション起動, ジョブ実行, 起動オプション, jobParameters, JobOperator

</details>

## バッチアプリケーションの終了コード

## バッチアプリケーションの終了コード

`Main` の終了コード:

| 終了種別 | コード | 条件 |
|---|---|---|
| 正常終了 | 0 | 終了ステータスが"WARNING"以外、かつバッチステータスが `BatchStatus.COMPLETED` |
| 異常終了 | 1 | 終了ステータスが"WARNING"以外、かつバッチステータスが `BatchStatus.COMPLETED` 以外 |
| 警告終了 | 2 | 終了ステータスが"WARNING" |

JOB終了待ちの間に中断された場合は異常終了コード（1）を返す。

警告終了させる方法: chunkまたはbatchlet内で `JobContext#setExitStatus(String)` を呼び出し `"WARNING"` を終了ステータスとして設定する。警告終了時はバッチステータスが `BatchStatus.COMPLETED` 以外（例外送出）の場合でも、終了ステータスに`"WARNING"`を設定していれば警告終了となる。

<details>
<summary>keywords</summary>

BatchStatus, JobContext, 終了コード, 警告終了, 異常終了, exitStatus, WARNING, BatchStatus.COMPLETED, JobContext#setExitStatus

</details>

## システムリポジトリを初期化する

## システムリポジトリを初期化する

[repository](../../component/libraries/libraries-repository.md) はジョブリスナーに `nablarchJobListenerExecutor` を設定することで初期化できる。

- システムリポジトリのルートXMLファイル名: `batch-boot.xml`（クラスパス直下に配置）
- ファイル名・配置場所を変更する場合: `nablarchJobListenerExecutor` のパラメータ `diConfigFilePath` で指定する

デフォルトの `batch-boot.xml` を使用する場合:
```xml
<job id="sample-job" xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="1.0">
  <listeners>
    <listener ref="nablarchJobListenerExecutor" />
  </listeners>
</job>
```

デフォルト以外の設定ファイルを使用する場合:
```xml
<job id="sample-job" xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="1.0">
  <listeners>
    <listener ref="nablarchJobListenerExecutor">
      <properties>
        <property name="diConfigFilePath" value="sample_project/batch-boot.xml" />
      </properties>
    </listener>
  </listeners>
</job>
```

<details>
<summary>keywords</summary>

nablarchJobListenerExecutor, batch-boot.xml, システムリポジトリ初期化, ジョブリスナー, diConfigFilePath

</details>
