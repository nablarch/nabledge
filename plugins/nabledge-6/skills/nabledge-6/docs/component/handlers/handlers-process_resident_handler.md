# プロセス常駐化ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/batch/process_resident_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessResidentHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/RetryableException.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessStopHandler.ProcessStop.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/ServiceUnavailable.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/RetryUtil.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/ProcessAbnormalEnd.html)

## 概要

後続のハンドラキューの内容を一定間隔毎に繰り返し実行するハンドラ。特定のデータソース上の入力データを定期的に監視してバッチ処理を行う、いわゆる常駐起動型のバッチ処理で用いられる。

本ハンドラでは、以下の処理を行う。

- 一定間隔（データの監視間隔）毎に後続ハンドラを呼び出す
- 後続ハンドラで例外発生時に、このハンドラの継続有無などを判断する（詳細は「後続ハンドラで発生した例外の扱い」参照）

<details>
<summary>keywords</summary>

プロセス常駐化ハンドラ, ProcessResidentHandler, 常駐起動型バッチ, 定期監視, データソース監視, 一定間隔繰り返し実行, 後続ハンドラキュー

</details>

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.ProcessResidentHandler`

<details>
<summary>keywords</summary>

ProcessResidentHandler, nablarch.fw.handler.ProcessResidentHandler, プロセス常駐化ハンドラ, 常駐起動型バッチ

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

nablarch-fw-standalone, com.nablarch.framework, モジュール依存関係, Maven

</details>

## 制約

> **重要**: 本ハンドラは [retry_handler](handlers-retry_handler.md) よりも後ろに設定すること。実行時例外を捕捉した場合、`RetryableException` でラップして再送出し、プロセスの継続制御を [retry_handler](handlers-retry_handler.md) に委譲するため。

<details>
<summary>keywords</summary>

ProcessResidentHandler, RetryableException, リトライハンドラ設定順序, retry_handler, 制約, ハンドラ設定順

</details>

## データの監視間隔を設定する

`dataWatchInterval` プロパティにミリ秒で設定する。デフォルト値は1000ミリ秒（1秒）。

```xml
<component name="settingsProcessResidentHandler"
    class="nablarch.fw.handler.ProcessResidentHandler">
  <property name="dataWatchInterval" value="5000" />
</component>
```

<details>
<summary>keywords</summary>

dataWatchInterval, ProcessResidentHandler, データ監視間隔, ミリ秒, デフォルト1000ms

</details>

## プロセス常駐化ハンドラの終了方法

プロセスの正常終了を示す例外が送出された場合、後続ハンドラの呼び出しを止め処理を終了する。

デフォルトの正常終了例外: `ProcessStop` とそのサブクラス（ [process_stop_handler](handlers-process_stop_handler.md) が送出）。

正常終了例外を変更する場合は `normalEndExceptions` プロパティに例外クラスリストを設定する。

> **重要**: 例外リストを設定するとデフォルト設定が上書きされるため、 `ProcessStop` の設定を忘れずに行うこと。

```xml
<component name="settingsProcessResidentHandler"
    class="nablarch.fw.handler.ProcessResidentHandler">
  <property name="normalEndExceptions">
    <list>
      <value>nablarch.fw.handler.ProcessStopHandler$ProcessStop</value>
      <value>sample.CustomProcessStop</value>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

normalEndExceptions, ProcessStop, ProcessStopHandler, プロセス正常終了, process_stop_handler, 常駐ハンドラ終了

</details>

## 後続ハンドラで発生した例外の扱い

後続ハンドラで発生した例外の種類に応じた処理内容:

| 例外の種類 | 処理内容 |
|---|---|
| `ServiceUnavailable` | データ監視間隔分待機後に後続ハンドラを再実行 |
| リトライ可能例外（ `RetryUtil#isRetryable()` が真） | 捕捉した例外をそのまま再送出 |
| プロセス異常終了例外（ `abnormalEndExceptions` プロパティで設定、デフォルトは `ProcessAbnormalEnd` とそのサブクラス） | 捕捉した例外をそのまま再送出 |
| プロセス正常終了例外（ [process_resident_handler-normal_end](#s5) 参照） | 後続ハンドラの戻り値をそのまま返し処理終了 |
| 上記以外 | ログ記録後、 `RetryableException` でラップして再送出 |

<details>
<summary>keywords</summary>

ServiceUnavailable, RetryableException, ProcessAbnormalEnd, abnormalEndExceptions, RetryUtil, 例外ハンドリング, サービス閉塞中, リトライ可能例外, プロセス異常終了

</details>
