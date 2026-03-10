# Jakarta Batchアプリケーションの起動

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/feature_details/run_batch_application.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/Main.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/batch/operations/JobOperator.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/batch/runtime/BatchStatus.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/batch/runtime/context/JobContext.html)

## バッチアプリケーションを起動する

Jakarta Batchに準拠したバッチアプリケーションの場合、バッチの起動はJakarta Batchで規定されたAPIを使用して行う。

**クラス**: `nablarch.fw.batch.ee.Main`

実行引数として対象JOBのXMLファイル名（`.xml`を除いたファイル名）を指定する。ジョブ実行時にパラメータを指定する場合は起動オプションを指定する。起動オプションで指定した値は `JobOperator#start` の `jobParameters` に設定される。

起動オプションは名前に `--` を付加し、名前の次の引数に値を設定する。

```bash
# 「option1=value1」と「option2=value2」の2つのjobParametersが設定される
$ java nablarch.fw.batch.ee.Main jobName --option1 value1 --option2 value2
```

> **補足**: プロジェクト独自で起動クラスを作成する際にも、このMainクラスを参考に実装できる。

<details>
<summary>keywords</summary>

nablarch.fw.batch.ee.Main, JobOperator, バッチアプリケーション起動, ジョブ実行, 起動オプション, jobParameters, JOBのXMLファイル名

</details>

## バッチアプリケーションの終了コード

`nablarch.fw.batch.ee.Main` の終了コード:

- **正常終了（0）**: 終了ステータスが "WARNING" 以外、かつバッチステータスが `BatchStatus.COMPLETED` の場合
- **異常終了（1）**: 終了ステータスが "WARNING" 以外、かつバッチステータスが `BatchStatus.COMPLETED` 以外の場合
- **警告終了（2）**: 終了ステータスが "WARNING" の場合

JOBの終了待ちの間に中断された場合は、異常終了のコードを返す。

警告終了させるには、chunkまたはbatchlet内で `JobContext#setExitStatus(String)` を呼び出し `"WARNING"` を終了ステータスとして設定する。警告終了時はバッチステータスは任意の値を許可するため、例外を送出してバッチステータスが `BatchStatus.COMPLETED` 以外となる場合でも、終了ステータスに "WARNING" を設定していれば警告終了する。

<details>
<summary>keywords</summary>

nablarch.fw.batch.ee.Main, BatchStatus, BatchStatus.COMPLETED, JobContext, JobContext#setExitStatus, setExitStatus, 終了コード, 正常終了, 異常終了, 警告終了, WARNING

</details>

## システムリポジトリを初期化する

:ref:`repository` は、ジョブリスナーに `nablarchJobListenerExecutor` を設定することで初期化できる。

システムリポジトリのルートxmlファイルのファイル名は `batch-boot.xml` とし、クラスパス直下に配置する。ファイル名や配置場所を変更する場合は `nablarchJobListenerExecutor` のパラメータで変更する。

デフォルトの `batch-boot.xml` を使用する場合:

```xml
<job id="sample-job" xmlns="https://jakarta.ee/xml/ns/jakartaee" version="2.0">
  <listeners>
    <listener ref="nablarchJobListenerExecutor" />
  </listeners>
</job>
```

デフォルト以外の設定ファイルを使用する場合（`diConfigFilePath` プロパティで指定）:

```xml
<job id="sample-job" xmlns="https://jakarta.ee/xml/ns/jakartaee" version="2.0">
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

nablarchJobListenerExecutor, batch-boot.xml, diConfigFilePath, システムリポジトリ初期化, ジョブリスナー設定

</details>
