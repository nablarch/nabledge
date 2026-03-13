# リクエストスレッド内ループ制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/request_thread_loop_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/RequestThreadLoopHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/Retryable.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/ServiceUnavailable.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/ProcessStopHandler/ProcessStop.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/ProcessAbnormalEnd.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/ServiceError.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result/Error.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/RuntimeException.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/ThreadDeath.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/StackOverflowError.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/OutOfMemoryError.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/VirtualMachineError.html)

## ハンドラクラス名

プロセスの停止要求があるまで後続ハンドラを繰り返し実行するハンドラ。メッセージキューやDBテーブルを監視し、未処理データを随時処理するプロセスで使用する。

> **補足**: 個々のリクエスト(データ)は独立して扱われる。1つのリクエスト処理がエラーとなっても他のリクエスト処理はそのまま継続する。捕捉した例外はプロセス正常停止要求や致命的な一部の例外を除き処理を継続する。詳細は [request_thread_loop_handler-error_handling](#s5) 参照。

処理概要:
1. 後続ハンドラを繰り返し実行
2. プロセス停止要求を示す例外発生時に後続ハンドラ実行を停止（詳細は [request_thread_loop_handler-stop](#s4) 参照）
3. 後続ハンドラで発生した例外(エラー)に応じた処理（詳細は [request_thread_loop_handler-error_handling](#s5) 参照）

**クラス名**: `nablarch.fw.handler.RequestThreadLoopHandler`

<details>
<summary>keywords</summary>

RequestThreadLoopHandler, nablarch.fw.handler.RequestThreadLoopHandler, ループ制御ハンドラ, 繰り返し実行, メッセージキュー監視, スタンドアロンバッチ処理

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

nablarch-fw-standalone, モジュール依存関係, Maven

</details>

## 制約

[retry_handler](handlers-retry_handler.md) より後ろに配置すること。このハンドラは処理継続可能な例外の場合に `Retryable` を送出するため、[retry_handler](handlers-retry_handler.md) よりも後ろに設定する必要がある。

<details>
<summary>keywords</summary>

retry_handler, Retryable, nablarch.fw.handler.retry.Retryable, ハンドラ配置順序, 制約

</details>

## サービス閉塞中の待機時間を設定する

後続ハンドラから `ServiceUnavailable` が発生した場合の待機時間を設定できる。待機時間を長くし過ぎると、サービスが開局中に変更されても即処理が開始されない問題があるので要件に合わせて設定すること。省略した場合は1秒待機後に後続ハンドラを再実行する。

```xml
<component class="nablarch.fw.handler.RequestThreadLoopHandler">
  <!-- 待機時間に5秒を設定 -->
  <property name="serviceUnavailabilityRetryInterval" value="5000" />
</component>
```

> **補足**: 後続ハンドラに :ref:`ServiceAvailabilityCheckHandler` を設定しない場合には、本設定値は設定する必要がない（設定しても使われない）。

<details>
<summary>keywords</summary>

serviceUnavailabilityRetryInterval, ServiceUnavailable, nablarch.fw.results.ServiceUnavailable, 待機時間設定, サービス閉塞, ServiceAvailabilityCheckHandler

</details>

## 本ハンドラの停止方法

プロセス停止要求を示す例外が発生するまで繰り返し後続ハンドラに処理を委譲する。メンテナンス等でプロセスを停止する場合は、本ハンドラより後続に [process_stop_handler](handlers-process_stop_handler.md) を設定し外部からプロセスを停止できるようにすること。

<details>
<summary>keywords</summary>

process_stop_handler, ProcessStopHandler, プロセス停止, ハンドラ停止方法

</details>

## 後続ハンドラで発生した例外(エラー)に応じた処理内容

| 例外・エラー | 処理内容 |
|---|---|
| `ServiceUnavailable` | 一定時間待機後に後続ハンドラに再委譲（待機時間設定は [request_thread_loop_handler-interval](#s3) 参照） |
| `ProcessStop` | 本ハンドラの処理を終了 |
| `ProcessAbnormalEnd` | 捕捉した例外を再送出 |
| `ServiceError` | 例外クラスにログ出力を委譲し、`Retryable` を送出 |
| `Result.Error` | FATALレベルのログ出力後、`Retryable` を送出 |
| `RuntimeException` | FATALレベルのログ出力後、`Retryable` を送出 |
| `ThreadDeath` | INFOレベルのログ出力後、ThreadDeathを再送出 |
| `StackOverflowError` | FATALレベルのログ出力後、`Retryable` を送出 |
| `OutOfMemoryError` | 標準エラー出力にメッセージ出力後FATALレベルログ出力（ログ出力時に再度ヒープ不足が発生する可能性があるため、標準エラー出力へのメッセージ出力を先に行う）。ヒープ不足原因オブジェクトへの参照が切れ処理継続可能な場合があるため `Retryable` を送出 |
| `VirtualMachineError` | 発生した例外を再送出 |
| 上記以外のエラー | FATALレベルのログ出力後、`Retryable` を送出 |

<details>
<summary>keywords</summary>

ServiceUnavailable, ProcessStop, ProcessAbnormalEnd, ServiceError, Retryable, OutOfMemoryError, VirtualMachineError, 例外ハンドリング, エラー処理, StackOverflowError, ThreadDeath

</details>
