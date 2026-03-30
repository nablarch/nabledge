# グローバルエラーハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.GlobalErrorHandler`

ハンドラキュー上のどのハンドラでも捕捉されなかった全ての実行時例外・エラーを捕捉し、運用ログを含むログ出力を行う。致命的な一部の例外を除いて、捕捉した例外を `Result` オブジェクトに変換して返す。

<details>
<summary>keywords</summary>

GlobalErrorHandler, nablarch.fw.handler.GlobalErrorHandler, エラーハンドリング, 例外捕捉, ログ出力, Result

</details>

## ハンドラ処理フロー

**[往路処理]**
1. 何もせず後続のハンドラに処理を委譲し、結果を取得する。

**[復路処理]**
2. 取得した結果をそのままリターンして終了する。

**[例外処理]**
後続ハンドラの処理中に実行時例外もしくはエラーが送出された場合、以下の表に従い例外処理を行う。基本的には発生したエラーをログに出力し、エラーの内容を格納した `Result` オブジェクトをリターンする。プロセスの継続に影響するような致命的なエラーが発生した場合のみ例外を再送出する。

> **注意**: 障害ログとは、運用ログに障害内容とメッセージを出力することを指す。

| 捕捉した例外クラス | 障害ログ出力 | ログレベル | 処理結果 | 備考 |
|---|---|---|---|---|
| `java.lang.ThreadDeath` | なし | Info | 捕捉した例外を再送出 | 外部からスレッド停止APIが呼ばれた場合に発生。通常運用で発生しうるためInfoログを出力し再送出する |
| `java.lang.InternalError` | なし | Fatal | 捕捉した例外を再送出 | VMの内部動作に起因するエラー |
| `java.lang.UnknownError` | なし | Fatal | 捕捉した例外を再送出 | |
| `java.lang.StackOverflowError` | なし | Fatal | `Result.InternalError`を返す | アプリケーションロジックの問題（無限ループ等）の可能性が高いためFatalログを出力し再送出はしない |
| `java.lang.OutOfMemoryError` | なし | Fatal | `Result.InternalError`を返す | リソースを浪費しているスレッドが終了することで復旧する可能性があるためFatalログを出力し再送出はしない。ログ出力前に標準エラー出力に最小限のメッセージを出力する |
| `java.lang.VirtualMachineError`（OutOfMemoryError/StackOverFlowError除く） | なし | Fatal | 捕捉した例外を再送出 | |
| `nablarch.fw.launcher.ProcessAbnormalEnd` | あり | Fatal | 捕捉した例外を再送出 | 駐起動バッチ等でアプリケーション側からプロセス停止を要求する場合に送出される |
| `nablarch.fw.Result.ServiceError` | あり | Fatal/Warn | 捕捉した例外を返す | アプリケーション側から障害ログの出力が要求された場合に送出される |
| `nablarch.fw.Result.Error` | なし | Fatal | 捕捉した例外を返す | |
| 上記以外の実行時例外/エラー | なし | Fatal | `Result.InternalError`を返す | |

<details>
<summary>keywords</summary>

ThreadDeath, InternalError, UnknownError, StackOverflowError, OutOfMemoryError, VirtualMachineError, ProcessAbnormalEnd, nablarch.fw.launcher.ProcessAbnormalEnd, nablarch.fw.Result.ServiceError, nablarch.fw.Result.Error, nablarch.fw.Result.InternalError, 例外処理, 障害ログ, ログレベル, 例外再送出

</details>

## 設定項目・拡張ポイント

本ハンドラの実装内容は基本的に変更不要でそのまま使用可能。プロジェクト固有の要件により例外処理を変更したい場合は、本ハンドラを別実装したものに差し替えること。

```xml
<component class="nablarch.fw.handler.GlobalErrorHandler" />
```

<details>
<summary>keywords</summary>

GlobalErrorHandler, XML設定, コンポーネント設定, カスタマイズ, 例外処理差し替え

</details>
