# リクエストスレッド内ループ制御ハンドラ

## ハンドラクラス名

プロセスの停止要求があるまで後続ハンドラを繰り返し実行するハンドラ。メッセージキューやDBテーブルを監視し未処理データを随時処理するプロセスで使用する。

**クラス名**: `nablarch.fw.handler.RequestThreadLoopHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

## 制約

:ref:`retry_handler` より後ろに配置すること。このハンドラは処理継続可能な例外の場合に `リトライ可能例外(Retryable)` を送出するため、:ref:`retry_handler` よりも後ろに設定する必要がある。

## サービス閉塞中の待機時間を設定する

後続ハンドラから `ServiceUnavailable` が発生した場合の待機時間を `serviceUnavailabilityRetryInterval` プロパティで設定する。省略時は1秒待機後に後続ハンドラを再実行する。

> **警告**: 待機時間を長くしすぎると、サービスが開局に変更されても即処理が開始されない問題がある。要件にあわせて値を設定すること。

```xml
<component class="nablarch.fw.handler.RequestThreadLoopHandler">
  <!-- 待機時間に5秒を設定 -->
  <property name="serviceUnavailabilityRetryInterval" value="5000" />
</component>
```

> **補足**: 後続ハンドラに :ref:`ServiceAvailabilityCheckHandler` を設定しない場合は本設定値不要（設定しても使われない）。

## 本ハンドラの停止方法

プロセス停止要求を示す例外が発生するまで繰り返し後続ハンドラに処理を委譲する。メンテナンスなどでプロセスを停止する場合は、本ハンドラより後続に :ref:`process_stop_handler` を設定し、外部からプロセスを停止できるようにする必要がある。

## 後続ハンドラで発生した例外(エラー)に応じた処理内容

> **補足**: メッセージキューやDBテーブルを監視するプロセスでは各リクエストは独立して扱われる。1つのリクエスト処理がエラーとなっても他のリクエスト処理は継続しなければならないため、プロセス正常停止要求や致命的な一部の例外を除き処理を継続する。

| 例外/エラー | 処理内容 |
|---|---|
| `ServiceUnavailable` | 一定時間待機後に後続ハンドラに再委譲（待機時間設定は :ref:`request_thread_loop_handler-interval` 参照） |
| `ProcessStop` | 本ハンドラの処理を終了 |
| `ProcessAbnormalEnd` | 捕捉した例外を再送出 |
| `ServiceError` | 例外クラスにログ出力処理を委譲し、`Retryable` を送出 |
| `Result.Error` | `FATAL` レベルのログを出力し、`Retryable` を送出 |
| `RuntimeException` | `FATAL` レベルのログを出力し、`Retryable` を送出 |
| `ThreadDeath` | `INFO` レベルのログを出力し、ThreadDeathを再送出 |
| `StackOverflowError` | `FATAL` レベルのログを出力し、`Retryable` を送出 |
| `OutOfMemoryError` | 標準エラー出力にヒープ不足発生メッセージを出力後、`FATAL` レベルのログを出力し、`Retryable` を送出。**標準エラー出力を先に行う理由**: ログ出力時に再度ヒープ不足が発生する可能性があるため、標準エラー出力にメッセージ出力後にログを出力する。ヒープ不足の原因オブジェクトへの参照が切れ処理継続可能な場合があるため Retryable を送出する |
| `VirtualMachineError` | 発生した例外を再送出 |
| 上記以外のエラー | `FATAL` レベルのログを出力し、`Retryable` を送出 |
