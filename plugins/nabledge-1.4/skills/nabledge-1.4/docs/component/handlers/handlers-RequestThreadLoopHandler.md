# リクエストスレッド内ループ制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.RequestThreadLoopHandler`

サーバ型プロセスの各リクエストスレッド上でループ制御を行うハンドラ。ループ処理フロー: データリーダによるリクエスト受信 → リクエスト処理実行 → 次リクエスト待機。

捕捉した例外はプロセス正常停止要求や致命的な例外を除き再送出せずにループを継続する。

**関連ハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [MultiThreadExecutionHandler](handlers-MultiThreadExecutionHandler.md) | 本ハンドラが制御する各リクエストスレッドを作成する |
| [ProcessStopHandler](handlers-ProcessStopHandler.md) | データリーダが閉じられるか致命的エラーが発生しない限りループは停止しない。外部からプロセスを正常終了させるには本ハンドラの後続に設定が必要 |

<details>
<summary>keywords</summary>

RequestThreadLoopHandler, nablarch.fw.handler.RequestThreadLoopHandler, MultiThreadExecutionHandler, ProcessStopHandler, リクエストスレッドループ制御, サーバ型プロセス, ループ制御

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(ループ終了判定)** データリーダが開いていることを確認
1a. **(ループ終了)** データリーダが閉じられていた場合はループを終了し直近の処理結果をリターン
2. **(実行コンテキストのコピー)** ループ開始前の実行コンテキストをコピーして1回分のループ用コンテキストを作成

| 属性名 | データ型 | コピーされる内容 |
|---|---|---|
| ハンドラキュー | List<Handler> | ループ開始前のシャローコピー |
| リクエストコンテキスト | Map<String, Object> | 新規Mapを作成 |
| セッションコンテキスト | Map<String, Object> | ループ開始前のMapをそのまま設定 |
| データリーダ | DataReader | ループ開始前のデータリーダをそのまま設定 |
| データリーダファクトリ | DataReaderFactory | ループ開始前のファクトリをそのまま設定 |

3. **(後続ハンドラの実行)** コピーした実行コンテキストで後続ハンドラに委譲

**[復路処理]**

4. **(ループ継続)** 後続ハンドラ正常終了後は1.に戻りループ継続

**[例外処理]**

3a. [ProcessStopHandler](handlers-ProcessStopHandler.md) によるプロセス停止例外が送出された場合はループを中断し `Result.Success` を返却して終了コード0で正常終了

3b. 後続ハンドラで実行時例外/エラーが発生した場合、原則としてログ出力のみ行いループ継続。致命的なエラーのみ例外を再送出しプロセスを停止。

| 捕捉した例外クラス | 障害ログ | ログレベル | 処理結果 | 備考 |
|---|---|---|---|---|
| nablarch.fw.Result.ServiceUnavailable | なし | Trace | ループ継続 | [ServiceAvailabilityCheckHandler](handlers-ServiceAvailabilityCheckHandler.md) から送出。INFOログを出力し、設定された業務閉局時待機時間だけwaitしてループ継続 |
| nablarch.fw.handler.retry.Retryable | なし | なし | 例外を再送出 | DB/MQ接続エラーなど再実行で継続可能なエラー。再送出し上位の [RetryHandler](handlers-RetryHandler.md) で継続判断 |
| java.lang.ThreadDeath | なし | Info | 例外を再送出 | 外部からスレッド停止APIが呼ばれた場合。Infoログを出力し再送出 |
| java.lang.StackOverflowError | あり | Fatal | ループ継続 | アプリケーションロジックの問題の可能性が高いためFatalログを出力し再送出なし |
| java.lang.OutOfMemoryError | あり | Fatal | ループ継続 | Fatalログを出力し再送出なし。ログ出力前に標準エラー出力に最小限のメッセージを出力 |
| java.lang.VirtualMachineError (OOM/SOE除く) | なし | なし | 例外を再送出 | |
| nablarch.fw.launcher.ProcessAbnormalEnd | なし | なし | 例外を再送出 | |
| nablarch.fw.Result.ServiceError | あり | Fatal/Warn | ループ継続 | アプリケーション側から障害ログ出力が要求された場合 |
| nablarch.fw.Result.Error | あり | Fatal | ループ継続 | |
| (上記以外の実行時例外/エラー) | あり | Fatal | ループ継続 | |

<details>
<summary>keywords</summary>

Result.ServiceUnavailable, ServiceAvailabilityCheckHandler, nablarch.fw.handler.retry.Retryable, RetryHandler, ThreadDeath, StackOverflowError, OutOfMemoryError, VirtualMachineError, ProcessAbnormalEnd, Result.ServiceError, Result.Error, Result.Success, DataReader, DataReaderFactory, 例外処理, ループ継続, 実行コンテキストコピー

</details>

## 設定項目・拡張ポイント

| 設定項目 | プロパティ名 | 型 | デフォルト値 | 備考 |
|---|---|---|---|---|
| 業務閉局時待機時間(msec) | serviceUnavailabilityRetryInterval | int | 1000 | 任意 |

**[../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) での標準設定**: エラー応答送信後に速やかにメッセージ待機状態へ移行するため、業務閉局時待機時間を0に設定。

```xml
<component class="nablarch.fw.handler.RequestThreadLoopHandler">
  <property name="serviceUnavailabilityRetryInterval" value="0" />
</component>
```

**[../architectural_pattern/messaging_receive](../../processing-pattern/mom-messaging/mom-messaging-messaging_receive.md) での標準設定**: 業務閉局時はリクエストテーブルをポーリングしつつ待機。ポーリング間隔を調整する場合は明示的に値を設定（デフォルト: 1000msec）。

```xml
<component class="nablarch.fw.handler.RequestThreadLoopHandler">
  <property name="serviceUnavailabilityRetryInterval" value="2000" />
</component>
```

<details>
<summary>keywords</summary>

serviceUnavailabilityRetryInterval, 業務閉局時待機時間, ポーリング間隔, メッセージング設定, 設定項目

</details>
