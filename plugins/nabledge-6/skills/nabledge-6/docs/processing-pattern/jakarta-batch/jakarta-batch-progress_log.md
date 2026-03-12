# 進捗状況のログ出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/feature_details/progress_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/progress/ProgressManager.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/batch/runtime/context/StepContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/batch/api/chunk/ItemWriter.html)

## 進捗ログで出力される内容

進捗ログで出力される内容:
- ジョブの開始と終了ログ
- ステップの開始と終了ログ
- 処理対象の件数ログ（処理対象の件数はアプリケーション側で求める必要がある）
- ステップの進捗状況ログ
  - 開始後からのTPS（処理対象件数および処理済み件数から算出）
  - 最新のTPS（前回TPS算出時の経過時間と処理した件数から算出）
  - 未処理件数
  - 終了予測時間（未処理件数とTPSから算出）

```bash
INFO progress start job. job name: [test-job]
INFO progress start step. job name: [test-job] step name: [test-step]
INFO progress job name: [test-job] step name: [test-step] input count: [25]
INFO progress job name: [test-job] step name: [test-step] total tps: [250.00] current tps: [250.00] estimated end time: [2017/02/13 04:02:25.656] remaining count: [15]
INFO progress job name: [test-job] step name: [test-step] total tps: [384.62] current tps: [519.32] estimated end time: [2017/02/13 04:02:25.668] remaining count: [5]
INFO progress job name: [test-job] step name: [test-step] total tps: [409.84] current tps: [450.00] estimated end time: [2017/02/13 04:02:25.677] remaining count: [0]
INFO progress finish step. job name: [test-job] step name: [test-step] step status: [null]
INFO progress finish job. job name: [test-job]
```

<details>
<summary>keywords</summary>

ProgressManager, TPS, 進捗ログ, ジョブ開始終了ログ, ステップ進捗状況, 終了予測時間, 未処理件数, 処理済み件数

</details>

## 進捗ログを専用のログファイルに出力するための設定を追加する

進捗ログはログカテゴリ名 `progress` として出力される。このカテゴリ名を使用して専用ファイルへの出力が可能。

[log](../../component/libraries/libraries-log.md) を使用した場合の `log.properties` 設定例:

```properties
# progress log file
writer.progressLog.className=nablarch.core.log.basic.FileLogWriter
writer.progressLog.filePath=./log/progress.log
writer.progressLog.encoding=UTF-8
writer.progressLog.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.progressLog.formatter.format=$date$ -$logLevel$- $message$

# logger list
availableLoggersNamesOrder=SQL,MON,PROGRESS,ROO

# progress logger setting
loggers.PROGRESS.nameRegex=progress
loggers.PROGRESS.level=INFO
loggers.PROGRESS.writerNames=progressLog
```

[log_adaptor](../../component/adapters/adapters-log_adaptor.md) を使用している場合は、アダプタに対応したログライブラリのマニュアルを参照して設定すること。

<details>
<summary>keywords</summary>

FileLogWriter, BasicLogFormatter, progress, log.properties, 専用ログファイル, availableLoggersNamesOrder, loggers.PROGRESS

</details>

## Batchletステップで進捗ログを出力する

Batchletは基本的にタスク指向処理のため進捗ログが必要なケースは少ない。ループを伴う処理が必要な場合は以下の実装パターンを使用する。

実装ポイント:
1. `process` メソッドの先頭で `inputCount` に処理対象件数を設定する
2. ループ処理内で一定間隔ごとに `outputProgressInfo` を呼び出す

> **重要**: TPSの算出の起点となる時間は、`inputCount` が呼び出されたタイミング。`setInputCount` 呼び出し後にDBからのデータ抽出等の重い処理を行うと、TPSが実際より小さい値となる。

```java
@Named
@Dependent
public class ProgressBatchlet extends AbstractBatchlet {

    private final ProgressManager progressManager;
    private static final int PROGRESS_LOG_INTERVAL = 1000;

    @Inject
    public ProgressBatchlet(ProgressManager progressManager) {
      this.progressManager = progressManager;
    }

    @Override
    public String process() throws Exception {
      progressManager.setInputCount(10000);
      long processedCount = 0;
      while (処理対象が存在している間) {
          processedCount++;
          if (processedCount % PROGRESS_LOG_INTERVAL == 0) {
            progressManager.outputProgressInfo(processedCount);
          }
      }
      return "SUCCESS";
    }
}
```

<details>
<summary>keywords</summary>

ProgressManager, AbstractBatchlet, ProgressBatchlet, setInputCount, outputProgressInfo, Batchletステップ進捗ログ, PROGRESS_LOG_INTERVAL, @Named, @Dependent, @Inject

</details>

## Chunkステップで進捗ログを出力する

## ItemReader

`ProgressManager` をコンストラクタインジェクションでインジェクションし、`open` メソッドで `inputCount` に処理対象件数を設定する。

> **重要**: TPSの算出の起点となる時間は、`inputCount` が呼び出されたタイミング。`setInputCount` 呼び出し後に重い処理を行うと、TPSが実際より小さい値となる。

```java
@Named
@Dependent
public class ProgressReader extends AbstractItemReader {

  private final ProgressManager progressManager;

  @Inject
  public ProgressReader(ProgressManager progressManager) {
      this.progressManager = progressManager;
  }

  @Override
  public void open(Serializable checkpoint) throws Exception {
    progressManager.setInputCount(10000);
  }

  @Override
  public Object readItem() throws Exception {
    // 省略
  }
}
```

## ジョブ定義ファイル

step配下のリスナーリストに進捗ログを出力するリスナー（名前は `progressLogListener` 固定）を設定する。

```xml
<job id="batchlet-progress-test" xmlns="https://jakarta.ee/xml/ns/jakartaee" version="2.0">
  <listeners>
    <listener ref="nablarchJobListenerExecutor" />
  </listeners>

  <step id="step">
    <listeners>
      <listener ref="nablarchStepListenerExecutor" />
      <listener ref="nablarchItemWriteListenerExecutor" />
      <listener ref="progressLogListener" />
    </listeners>
    <chunk item-count="1000">
      <reader ref="progressReader" />
      <writer ref="progressWriter" />
    </chunk>
  </step>
</job>
```

> **重要**: [ItemReader](#s4) で処理対象件数を設定せずに [進捗ログ出力リスナー](#s4) を設定した場合、設定不備として例外を送出し異常終了する。進捗ログが不要な場合は [進捗ログ出力リスナー](#s4) の設定を必ず削除すること。

> **重要**: ChunkステップでRetrying Exceptionsを設定した場合、リスナーによる進捗ログが正しく機能しなくなる。これは `metrics` の読み込み済み件数が実態とずれることに起因する。RetryingExceptionsを使用してリトライ処理を行う場合は、`ItemWriter` の実装クラスで処理済み件数を計算し、`outputProgressInfo` を使用して進捗ログを出力すること。

<details>
<summary>keywords</summary>

ProgressManager, AbstractItemReader, ProgressReader, progressLogListener, ItemWriter, Chunkステップ進捗ログ, RetryingExceptions, setInputCount, outputProgressInfo, @Inject, @Named, @Dependent, StepContext

</details>
