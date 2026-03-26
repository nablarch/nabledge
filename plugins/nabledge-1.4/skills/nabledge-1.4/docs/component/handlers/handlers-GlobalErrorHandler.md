# グローバルエラーハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.GlobalErrorHandler`

ハンドラキュー上のどのハンドラでも捕捉されなかった全ての実行時例外・エラーを捕捉し、運用ログを含むログ出力を行う。致命的な一部の例外を除いて、捕捉した例外を`Result`オブジェクトに変換して返す。

<details>
<summary>keywords</summary>

GlobalErrorHandler, nablarch.fw.handler.GlobalErrorHandler, グローバルエラーハンドラ, 例外キャッチ, ログ出力, Result変換

</details>

## ハンドラ処理フロー

1. **[往路]** 何もせずに後続ハンドラに処理を委譲し、結果を取得する。
2. **[復路・正常終了]** 取得した結果をそのままリターンして終了する。
3. **[例外処理]** 後続ハンドラの処理中に実行時例外またはエラーが送出された場合、以下の表に従い処理する。基本的に発生したエラーをログに出力し`Result`オブジェクトをリターンする。プロセスの継続に影響するような致命的なエラーのみ再送出する。

| 捕捉した例外クラス | 障害ログ出力[1] | ログレベル | 処理結果 | 備考 |
|---|---|---|---|---|
| java.lang.ThreadDeath | なし | Info | 捕捉した例外を再送出 | 外部からスレッド停止APIが呼ばれた場合に発生。通常運用で発生しうるためInfoレベルで出力し再送出 |
| java.lang.InternalError | なし | Fatal | 捕捉した例外を再送出 | VMの内部動作に起因するエラー |
| java.lang.UnknownError | なし | Fatal | 捕捉した例外を再送出 | |
| java.lang.StackOverflowError | なし | Fatal | Result.InternalErrorを返す | アプリケーションロジックの問題（無限ループ等）の可能性が高いためFatalログを出力し再送出はしない |
| java.lang.OutOfMemoryError | なし | Fatal | Result.InternalErrorを返す | リソースを浪費しているリクエストスレッドが終了することで復旧する可能性があるため再送出しない。ログ出力前に標準エラー出力に最小限のメッセージを出力する |
| java.lang.VirtualMachineError（OutOfMemoryError/StackOverflowError除く） | なし | Fatal | 捕捉した例外を再送出 | |
| nablarch.fw.launcher.ProcessAbnormalEnd | あり | Fatal | 捕捉した例外を再送出 | 駐起動バッチ等でアプリケーション側からプロセス停止を要求する場合に送出される |
| nablarch.fw.Result.ServiceError | あり | Fatal/Warn | 捕捉した例外を返す | アプリケーション側から障害ログの出力が要求された場合に送出される |
| nablarch.fw.Result.Error | なし | Fatal | 捕捉した例外を返す | |
| 上記以外の実行時例外/エラー | なし | Fatal | Result.InternalErrorを返す | |

[1] 運用ログに障害内容とメッセージを出力する。

<details>
<summary>keywords</summary>

ハンドラ処理フロー, ThreadDeath, InternalError, UnknownError, StackOverflowError, OutOfMemoryError, VirtualMachineError, ProcessAbnormalEnd, nablarch.fw.launcher.ProcessAbnormalEnd, nablarch.fw.Result.ServiceError, nablarch.fw.Result.Error, Result.InternalError, 例外制御, 障害ログ, Fatal, 再送出

</details>

## 設定項目・拡張ポイント

本ハンドラは基本的に変更不要でそのまま使用できる。

```xml
<component class="nablarch.fw.handler.GlobalErrorHandler" />
```

プロジェクト固有の要件で例外処理を変更したい場合は、本ハンドラ自体を別実装に差し替えること。

<details>
<summary>keywords</summary>

GlobalErrorHandler, コンポーネント設定, XML設定, 拡張ポイント, 例外処理カスタマイズ

</details>
