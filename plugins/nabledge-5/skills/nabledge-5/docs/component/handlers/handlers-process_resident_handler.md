# プロセス常駐化ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/batch/process_resident_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessResidentHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/RetryableException.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessStopHandler.ProcessStop.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/ServiceUnavailable.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/RetryUtil.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/ProcessAbnormalEnd.html)

## ハンドラクラス名

後続のハンドラキューの内容を一定間隔毎に繰り返し実行するハンドラ。特定のデータソース上の入力データを定期的に監視してバッチ処理を行う、いわゆる常駐起動型のバッチ処理で用いられる。

**クラス名**: `nablarch.fw.handler.ProcessResidentHandler`

<details>
<summary>keywords</summary>

ProcessResidentHandler, nablarch.fw.handler.ProcessResidentHandler, プロセス常駐化ハンドラ, 常駐起動型バッチ, 定期監視, データソース監視, 一定間隔繰り返し実行

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-standalone, com.nablarch.framework, モジュール依存関係

</details>

## 制約

> **重要**: 本ハンドラは [retry_handler](handlers-retry_handler.md) よりも後ろに設定すること。実行時例外を捕捉した場合、`RetryableException` でラップして再送出し、プロセスの継続制御を [retry_handler](handlers-retry_handler.md) に委譲するため。

<details>
<summary>keywords</summary>

RetryableException, nablarch.fw.handler.retry.RetryableException, リトライハンドラ配置順, retry_handler, 制約

</details>

## データの監視間隔を設定する

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| dataWatchInterval | int | | 1000 | データの監視間隔（ミリ秒） |

```xml
<component name="settingsProcessResidentHandler"
    class="nablarch.fw.handler.ProcessResidentHandler">
  <!-- データの監視間隔に5秒(5000)を設定 -->
  <property name="dataWatchInterval" value="5000" />
</component>
```

<details>
<summary>keywords</summary>

dataWatchInterval, 監視間隔, ミリ秒, ProcessResidentHandler設定

</details>

## プロセス常駐化ハンドラの終了方法

プロセスの正常終了を示す例外が送出された場合に、後続ハンドラの呼び出しを停止して処理を終了する。

デフォルトでは [process_stop_handler](handlers-process_stop_handler.md) が送出する `ProcessStop`（サブクラス含む）が正常終了例外として扱われる。

正常終了例外を変更する場合は `normalEndExceptions` プロパティに例外クラスのリストを設定する。

> **重要**: 例外リストを設定するとデフォルト設定が上書きされるため、`ProcessStop` の設定を忘れないこと。

```xml
<component name="settingsProcessResidentHandler"
    class="nablarch.fw.handler.ProcessResidentHandler">
  <property name="normalEndExceptions">
    <list>
      <!-- Nablarchデフォルトのプロセス停止を示す例外クラス -->
      <value>nablarch.fw.handler.ProcessStopHandler$ProcessStop</value>
      <!-- プロジェクトカスタムなプロセス停止を示す例外クラス(サブクラスも対象) -->
      <value>sample.CustomProcessStop</value>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

normalEndExceptions, ProcessStop, nablarch.fw.handler.ProcessStopHandler.ProcessStop, process_stop_handler, 正常終了, プロセス停止

</details>

## 後続ハンドラで発生した例外の扱い

後続ハンドラで発生した例外の種類に応じて、処理継続または終了を切り替える。

| 例外の種類 | 処理内容 |
|---|---|
| `ServiceUnavailable` | データ監視間隔分待機後、後続ハンドラを再実行 |
| リトライ可能例外（`RetryUtil#isRetryable()` が真） | 何もせず捕捉した例外を再送出 |
| 異常終了例外（`abnormalEndExceptions` プロパティに設定、デフォルト: `ProcessAbnormalEnd`（サブクラス含む）） | 何もせず捕捉した例外を再送出 |
| 正常終了例外（[process_resident_handler-normal_end](#s4) 参照） | 後続ハンドラの結果オブジェクトを戻り値として処理終了 |
| 上記以外の例外 | 例外情報をログに記録し、`RetryableException` でラップして再送出 |

<details>
<summary>keywords</summary>

ServiceUnavailable, nablarch.fw.results.ServiceUnavailable, RetryableException, ProcessAbnormalEnd, nablarch.fw.launcher.ProcessAbnormalEnd, abnormalEndExceptions, RetryUtil, 例外ハンドリング, プロセス継続制御

</details>
