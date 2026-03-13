# 進捗状況のログ出力

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/feature_details/progress_log.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/progress/ProgressManager.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/runtime/context/StepContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/api/chunk/ItemWriter.html)

## 進捗ログで出力される内容

進捗ログに出力される内容:

- ジョブの開始と終了ログ
- ステップの開始と終了ログ
- 処理対象の件数ログ（アプリケーション側で設定が必要）
- ステップの進捗状況ログ:
  - 開始後からのTPS（処理対象件数と処理済み件数から算出）
  - 最新のTPS（前回算出時からの経過時間と処理件数から算出）
  - 未処理件数
  - 終了予測時間（未処理件数とTPSから算出）

出力例:

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

ProgressManager, 進捗ログ, TPS算出, 終了予測時間, 未処理件数, ジョブ進捗状況

</details>

## 進捗ログを専用のログファイルに出力するための設定を追加する

進捗ログのログカテゴリ名は `progress`。このカテゴリ名を使用して専用ファイルへ出力できる。

[log_adaptor](../../component/adapters/adapters-log_adaptor.md) を使用している場合は、アダプタに対応したログライブラリのマニュアルを参照して設定する。

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

<details>
<summary>keywords</summary>

progress, log.properties, 専用ログファイル, progressカテゴリ, ログ設定, FileLogWriter, BasicLogFormatter

</details>

## Batchletステップで進捗ログを出力する

ポイント:
- `process` メソッドの先頭で処理対象件数（DBのcount結果やファイルのレコード数等）を取得し、`inputCount` に設定する。
- ループ処理内で一定間隔ごとに `outputProgressInfo` を呼び出す。

> **重要**: TPSの算出起点となる時間は `inputCount` 呼び出しタイミング。`setInputCount` 呼び出し後に重い処理（DB検索等）を行うとTPSが実際より小さい値になる。

Batchletはタスク指向処理のため進捗ログを必要とするケースは少ない。ループを伴う処理を行う場合に使用する。

実装例:

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

ProgressManager, AbstractBatchlet, setInputCount, outputProgressInfo, Batchletステップ進捗ログ, TPS算出起点

</details>

## Chunkステップで進捗ログを出力する

## ItemReader

ポイント:
- コンストラクタインジェクションを使用して `ProgressManager` をインジェクションする。
- `open` メソッドにて処理対象件数（DBのcount結果やファイルのレコード数等）を取得し、`inputCount` に設定する。

> **重要**: TPSの算出起点となる時間は `inputCount` 呼び出しタイミング。`setInputCount` 呼び出し後に重い処理（DB検索等）を行うとTPSが実際より小さい値になる。

実装例（ItemReader）:

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

## ジョブ定義ファイル（Chunkステップ）

`step` 配下のリスナーリストに進捗ログ出力リスナー（名前は `progressLogListener` 固定）を設定する。

```xml
<job id="batchlet-progress-test" xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="1.0">
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

> **重要**: [ItemReader](#s4) で処理対象件数を設定せずに [進捗ログ出力リスナー](#s4) を設定した場合は、設定不備として例外を送出し処理を異常終了させる。進捗ログが不要な場合は必ず [進捗ログ出力リスナー](#s4) の設定を削除すること。

> **重要**: ChunkステップでRetrying Exceptionsを設定した場合、リスナーによる進捗ログ出力が正しく機能しなくなる。これは、リスナーが処理済み件数として使用している `metrics` の読み込み済み件数が実態とずれることに起因する。Retrying Exceptionsを使用する場合は、`ItemWriter` 実装クラスにて処理済み件数を計算し、`outputProgressInfo` を使用して進捗ログを出力すること。

<details>
<summary>keywords</summary>

ProgressManager, AbstractItemReader, ItemWriter, progressLogListener, Chunkステップ進捗ログ, RetryingExceptions制約, ItemReader設定, StepContext

</details>
