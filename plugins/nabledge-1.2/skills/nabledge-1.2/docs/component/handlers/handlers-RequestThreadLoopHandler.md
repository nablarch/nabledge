# リクエストスレッド内ループ制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.RequestThreadLoopHandler`

サーバ型プロセスの各リクエストスレッド上でループ制御を行うハンドラ。ループ処理: データリーダによるリクエスト受信 → リクエスト処理実行 → 次のリクエスト待機。

サーバ型処理では個々のリクエスト処理は完全に独立しているため、1つのリクエスト処理がエラーとなっても他のリクエスト処理は継続する。捕捉した例外はプロセス正常停止要求や致命的な例外を除き再送出せず処理を継続する。

> **注意**: [ProcessResidentHandler](handlers-ProcessResidentHandler.md) はメインスレッド上でのループ制御、本ハンドラは各サブスレッド上でのループ制御を行う。例外制御ポリシーなどの面で挙動が大きく異なるため共用不可。

**関連するハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) | [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) が作成する各リクエストスレッド内のループ制御を行う |
| [ProcessStopHandler](handlers-ProcessStopHandler.md) | 本ハンドラを組み込んだハンドラキューはデータリーダが閉じられるか致命的なエラーが発生しない限り停止しない。外部からプロセスを正常終了させる場合は後続ハンドラとして [ProcessStopHandler](handlers-ProcessStopHandler.md) を組み込む必要がある |

<details>
<summary>keywords</summary>

RequestThreadLoopHandler, nablarch.fw.handler.RequestThreadLoopHandler, ProcessResidentHandler, MultiThreadExecutionHandler, ProcessStopHandler, リクエストスレッドループ制御, サーバ型プロセス, ループ制御ハンドラ

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(ループ終了判定)** データリーダが開いていることを確認する。
2. **(ループ終了)** データリーダが閉じられていた場合、ループを終了し直近の処理結果をリターンする。
3. **(実行コンテキストのコピー)** ループ開始前の実行コンテキストをコピーして1回分のループ用コンテキストを作成する。

| 属性名 | データ型 | コピーされる内容 |
|---|---|---|
| ハンドラキュー | List\<Handler\> | ループ開始前のシャローコピー |
| リクエストコンテキスト | Map\<String, Object\> | 新規のMapを作成 |
| セッションコンテキスト | Map\<String, Object\> | ループ開始前のMapをそのまま設定 |
| データリーダ | DataReader | ループ開始前のものをそのまま設定 |
| データリーダファクトリ | DataReaderFactory | ループ開始前のものをそのまま設定 |

4. **(後続ハンドラの実行)** コピーしたコンテキストで後続ハンドラに処理委譲。

**[復路処理]**

5. **(リクエスト処理正常終了 → ループ継続)** 後続ハンドラが正常終了した場合は1に戻りループを継続。

**[例外処理]**

**(プロセス停止コマンド投入による正常停止)** [ProcessStopHandler](handlers-ProcessStopHandler.md) によりプロセス停止例外が送出された場合は、ループを中断し `Result.Success` を返却して終了コード0で正常終了させる。

**(例外制御)** 後続ハンドラの処理中に実行時例外もしくはエラーが送出された場合でも、ログ出力のみ行い原則としてループは継続させる。ただし、プロセスの継続に影響するような致命的なエラーが発生した場合のみ例外を再送出しプロセスを停止させる。

| 捕捉した例外クラス | 障害ログ出力 | ログレベル | 処理結果 | 備考 |
|---|---|---|---|---|
| nablarch.fw.Result.ServiceUnavailable | なし | Trace | ループ継続 | 業務機能が閉局していた場合に [ServiceAvailabilityCheckHandler](handlers-ServiceAvailabilityCheckHandler.md) から送出される。INFOログを出力し、**業務閉局時待機時間** だけwaitした後でループを継続 |
| nablarch.fw.handler.retry.Retryable | なし | なし | 例外を再送出 | DB/MQの接続エラーなど単純再実行による処理継続が可能なエラー。上位の [RetryHandler](handlers-RetryHandler.md) で継続判断 |
| java.lang.ThreadDeath | なし | Info | 例外を再送出 | 外部からスレッド停止APIが呼ばれた場合に発生。通常運用で発生しうるためInfoレベルでログ出力し再送出 |
| java.lang.StackOverflowError | あり | Fatal | ループ継続 | アプリケーションロジックの問題（無限ループ等）の可能性が高いのでFatalログを出力し再送出しない |
| java.lang.OutOfMemoryError | あり | Fatal | ループ継続 | リソースを浪費しているリクエストスレッドが終了することで復旧の可能性あり。Fatalログを出力し再送出しない。ログ出力失敗の可能性があるためログ出力前に標準エラー出力に最小限のメッセージを出力 |
| java.lang.VirtualMachineError (OutOfMemoryError/StackOverFlowError除く) | なし | なし | 例外を再送出 | |
| nablarch.fw.launcher.ProcessAbnormalEnd | なし | なし | 例外を再送出 | 極めて特殊なケースを除き使用されない |
| nablarch.fw.Result.ServiceError | あり | Fatal/Warn | ループ継続 | アプリケーション側から障害ログの出力が要求された場合に送出 |
| nablarch.fw.Result.Error | あり | Fatal | ループ継続 | |
| (上記以外の実行時例外/エラー) | あり | Fatal | ループ継続 | |

<details>
<summary>keywords</summary>

Result.ServiceUnavailable, Retryable, ThreadDeath, StackOverflowError, OutOfMemoryError, VirtualMachineError, ProcessAbnormalEnd, Result.ServiceError, Result.Error, Result.Success, ServiceAvailabilityCheckHandler, RetryHandler, DataReader, DataReaderFactory, 例外処理, ループ継続, ハンドラ処理フロー, ProcessStopHandler, プロセス停止

</details>

## 設定項目・拡張ポイント

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| 業務閉局時待機時間(単位:msec) | serviceUnavailabilityRetryInterval | int | 任意（デフォルト=1000） |

[../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) では、エラー応答送信後速やかにメッセージ待機状態に移行するため業務閉塞時の待機時間を0に設定する。

```xml
<component class="nablarch.fw.handler.RequestThreadLoopHandler">
  <property name="serviceUnavailabilityRetryInterval" value="0" />
</component>
```

[../architectural_pattern/messaging_receive](../../processing-pattern/mom-messaging/mom-messaging-messaging_receive.md) では、業務閉塞時は要求電文のGET処理を行わず、業務が開局されるまで各リクエストスレッドでリクエストテーブルをポーリングしつつ待機する。ポーリング間隔を調整する場合は明示的に設定する（デフォルト: 1000msec）。

```xml
<component class="nablarch.fw.handler.RequestThreadLoopHandler">
  <property name="serviceUnavailabilityRetryInterval" value="2000" />
</component>
```

<details>
<summary>keywords</summary>

serviceUnavailabilityRetryInterval, 業務閉局時待機時間, 設定項目, ポーリング間隔, messaging_request_reply, messaging_receive

</details>
