# リクエストスレッド内ループ制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.RequestThreadLoopHandler`

サーバ型プロセス（サーバソケット・受信電文キュー等の監視）において、各リクエストスレッド上で以下のループ制御を行う:

データリーダによるリクエストの受信 → リクエスト処理の実行 → 次のリクエストの待機

サーバ型処理では個々のリクエスト処理が完全に独立しているため、1つのリクエスト処理がエラーとなっても他のリクエスト処理はそのまま継続しなければならない。本ハンドラで捕捉した例外はプロセス正常停止要求や致命的な一部の例外を除き再送出せずにループを継続する。

**関連ハンドラ**:

| ハンドラ | 説明 |
|---|---|
| MultiThreadExecutionHandler | MultiThreadExecutionHandler が作成する各リクエストスレッド内のループ制御を行う |
| ProcessStopHandler | データリーダが閉じられるか致命的なエラーが発生しない限り停止しない。外部からプロセスを正常終了させる場合は ProcessStopHandler を後続ハンドラとして組み込む必要がある |

<details>
<summary>keywords</summary>

RequestThreadLoopHandler, nablarch.fw.handler.RequestThreadLoopHandler, MultiThreadExecutionHandler, ProcessStopHandler, リクエストスレッド, ループ制御, サーバ型プロセス

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(ループ終了判定)** データリーダが開いていることを確認する。
   - 1a. データリーダが閉じられていた場合は、ループを終了し、直近の処理結果をリターンする。
2. **(実行コンテキストのコピー)** ループ開始前の実行コンテキストをコピーして1回分のループ用コンテキストを作成する。

   | 属性名 | データ型 | コピー内容 |
   |---|---|---|
   | ハンドラキュー | List<Handler> | ループ開始前のハンドラキューのシャローコピー |
   | リクエストコンテキスト | Map<String, Object> | 新規Mapを作成 |
   | セッションコンテキスト | Map<String, Object> | ループ開始前のMapをそのまま設定 |
   | データリーダ | DataReader | ループ開始前のデータリーダをそのまま設定 |
   | データリーダファクトリ | DataReaderFactory | ループ開始前のファクトリをそのまま設定 |

3. **(後続ハンドラの実行)** コピーした実行コンテキストを用いて後続ハンドラに処理を委譲する。

**[復路処理]**

4. **(リクエスト処理正常終了 → ループ継続)** 後続ハンドラが正常終了した場合は、1. に戻りループを継続する。

**[例外処理]**

- 3a. **(プロセス停止コマンドによる正常停止)** ProcessStopHandler によりプロセス停止例外が送出された場合は、ループを中断し `Result.Success` を返却して終了コード0で正常終了させる。
- 3b. **(例外制御)** 後続ハンドラの処理中に実行時例外もしくはエラーが送出された場合でも、ログ出力のみ行い原則としてループを継続させる。ただしプロセスの継続に影響するような致命的なエラーが発生した場合のみ、例外を再送出しプロセスを停止させる。

例外/エラーごとの処理内容:

| 捕捉した例外クラス | 障害ログ出力 | ログレベル | 処理結果 | 備考 |
|---|---|---|---|---|
| `nablarch.fw.Result.ServiceUnavailable` | なし | Trace | ループ継続 | 業務機能が閉局していた場合に `ServiceAvailabilityCheckHandler` から送出される。INFOログを出力し、**業務閉局時待機時間**だけwaitした後でループを継続する。 |
| `nablarch.fw.handler.retry.Retryable` | なし | なし | 捕捉した例外を再送出 | DB/MQの接続エラーなど単純再実行による処理継続が可能なエラー。再送出し上位の `RetryHandler` で継続判断を行う。 |
| `java.lang.ThreadDeath` | なし | Info | 捕捉した例外を再送出 | 外部からスレッド停止APIが呼ばれた場合に発生する。通常運用で発生しうるため再送出する。 |
| `java.lang.StackOverflowError` | あり | Fatal | ループ継続 | アプリケーションロジックの問題（無限ループ等）の可能性が高いためFatalログを出力し再送出はしない。 |
| `java.lang.OutOfMemoryError` | あり | Fatal | ループ継続 | リソースを浪費しているリクエストスレッドが終了することで復旧する可能性があるため再送出はしない。ログ出力前に標準エラー出力に最小限のメッセージを出力する。 |
| `java.lang.VirtualMachineError`（OutOfMemoryError/StackOverFlowError除く） | なし | なし | 捕捉した例外を再送出 | — |
| `nablarch.fw.launcher.ProcessAbnormalEnd` | なし | なし | 捕捉した例外を再送出 | (極めて特殊なケースを除き使用されない。) |
| `nablarch.fw.Result.ServiceError` | あり | Fatal/Warn | ループ継続 | アプリケーション側から障害ログの出力が要求された場合に送出される。 |
| `nablarch.fw.Result.Error` | あり | Fatal | ループ継続 | — |
| （上記以外の実行時例外/エラー） | あり | Fatal | ループ継続 | — |

<details>
<summary>keywords</summary>

nablarch.fw.Result.ServiceUnavailable, nablarch.fw.handler.retry.Retryable, nablarch.fw.launcher.ProcessAbnormalEnd, nablarch.fw.Result.ServiceError, nablarch.fw.Result.Error, java.lang.StackOverflowError, java.lang.OutOfMemoryError, java.lang.ThreadDeath, java.lang.VirtualMachineError, ServiceAvailabilityCheckHandler, RetryHandler, Result.Success, ハンドラ処理フロー, 例外処理, ループ継続, 往路処理, 復路処理, DataReader, DataReaderFactory

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| serviceUnavailabilityRetryInterval | int | | 1000 | 業務閉局時待機時間（msec） |

`messaging_request_reply` では、エラー応答送信後速やかにメッセージ待機状態に移行するため、業務閉塞時の待機時間を0に設定する:

```xml
<component class="nablarch.fw.handler.RequestThreadLoopHandler">
  <property name="serviceUnavailabilityRetryInterval" value="0" />
</component>
```

`messaging_receive` では、業務閉塞時はリクエストテーブルをポーリングしつつ待機する。ポーリング間隔を調整する場合は明示的に値を設定する（デフォルト: 1000msec）:

```xml
<component class="nablarch.fw.handler.RequestThreadLoopHandler">
  <property name="serviceUnavailabilityRetryInterval" value="2000" />
</component>
```

<details>
<summary>keywords</summary>

serviceUnavailabilityRetryInterval, 業務閉局時待機時間, ポーリング間隔

</details>
