# グローバルエラーハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.GlobalErrorHandler`

ハンドラキュー上のどのハンドラでも捕捉されなかった全ての実行時例外・エラーを捕捉し、運用ログを含むログ出力を行なう。致命的な一部の例外を除いて、捕捉した例外を`Result`オブジェクトに変換して返す。

<details>
<summary>keywords</summary>

GlobalErrorHandler, nablarch.fw.handler.GlobalErrorHandler, グローバルエラーハンドラ, 例外捕捉, ログ出力, Result

</details>

## ハンドラ処理フロー

**処理フロー**

1. **往路**: 後続ハンドラに処理を委譲し、結果を取得する
2. **復路（正常終了）**: 取得した結果をそのままリターンする
3. **例外処理**: 後続ハンドラの処理中に実行時例外もしくはエラーが送出された場合、以下の表に従い処理を行う

| 捕捉した例外クラス | 障害ログ出力 | ログレベル | 処理結果 | 備考 |
|---|---|---|---|---|
| `java.lang.ThreadDeath` | なし | Info | 再送出 | 外部からスレッド停止APIが呼ばれた場合に発生。通常運用で発生しうる |
| `java.lang.InternalError` | なし | Fatal | 再送出 | VMの内部動作に起因するエラー |
| `java.lang.UnknownError` | なし | Fatal | 再送出 | |
| `java.lang.StackOverflowError` | なし | Fatal | `Result.InternalError`を返す | アプリケーションロジックの問題（無限ループ等）の可能性が高い |
| `java.lang.OutOfMemoryError` | なし | Fatal | `Result.InternalError`を返す | リソースを浪費しているスレッドが終了することで復旧する可能性あり。ログ出力前に標準エラー出力に最小限のメッセージを出力する |
| `java.lang.VirtualMachineError`（OOM/StackOverflow除く） | なし | Fatal | 再送出 | |
| `nablarch.fw.launcher.ProcessAbnormalEnd` | あり | Fatal | 再送出 | 駐起動バッチ等でアプリケーション側からプロセス停止を要求する場合に送出 |
| `nablarch.fw.Result.ServiceError` | あり | Fatal/Warn | 捕捉した例外を返す | アプリケーション側から障害ログの出力が要求された場合に送出 |
| `nablarch.fw.Result.Error` | なし | Fatal | 捕捉した例外を返す | |
| 上記以外の実行時例外/エラー | なし | Fatal | `Result.InternalError`を返す | |

障害ログには障害内容とメッセージを出力する。

<details>
<summary>keywords</summary>

ThreadDeath, InternalError, UnknownError, StackOverflowError, OutOfMemoryError, VirtualMachineError, ProcessAbnormalEnd, nablarch.fw.launcher.ProcessAbnormalEnd, nablarch.fw.Result.ServiceError, nablarch.fw.Result.Error, Result.InternalError, 例外処理フロー, 障害ログ, 致命的エラー, 再送出

</details>

## 設定項目・拡張ポイント

本ハンドラは設定変更不要でそのまま使用できる。

```xml
<component class="nablarch.fw.handler.GlobalErrorHandler" />
```

プロジェクト固有の例外処理が必要な場合は、本ハンドラ自体を別実装に差し替えること。

<details>
<summary>keywords</summary>

GlobalErrorHandler, XML設定, コンポーネント設定, ハンドラ差し替え, 例外処理カスタマイズ

</details>
