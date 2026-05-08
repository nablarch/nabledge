## グローバルエラーハンドラ

**クラス名:** `nablarch.fw.handler.GlobalErrorHandler`

-----

-----

### 概要

[グローバルエラーハンドラ](../../component/handlers/handlers-GlobalErrorHandler.md) は、ハンドラキュー上のどのハンドラでも捕捉されなかった
全ての実行時例外・エラーを捕捉し、運用ログを含むログ出力を行なう。

このハンドラでは、致命的な一部の例外を除いて、捕捉した例外を
処理結果オブジェクト([Result](../../javadoc/nablarch/fw/Result.html) )に変換して返す。

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| グローバルエラーハンドラ | nablarch.fw.handler.GlobalErrorHandler | Object | Result | - | - | 全ての実行時例外・エラーを捕捉し、ログ出力を行う |

### ハンドラ処理フロー

**[往路処理]**

**1. (後続ハンドラへの処理委譲)**

往路では何もせずに後続のハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

**2. (正常終了)**

**1.** で取得した結果をそのままリターンし終了する。

**[例外処理]**

**2a. (例外制御)**

後続ハンドラの処理中に実行時例外もしくはエラーが送出された場合は以下の表に従い例外処理を行う。
基本的には発生したエラーをログに出力し、エラーの内容を格納した [Result](../../javadoc/nablarch/fw/Result.html) オブジェクトをリターンする。
ただし、プロセスの継続に影響するような致命的なエラーが発生した場合のみ例外を再送出する。

| 捕捉した例外クラス | 障害ログ出力 [1] | ログレベル | 処理結果 | 備考 |
|---|---|---|---|---|
| java.lang.ThreadDeath | なし | Info | 捕捉した例外 を再送出 | 外部からスレッド停止APIが呼ばれた場合に発生する。 通常運用で発生しうるため、Infoレベルのログを出力し、 再送出する。 |
| java.lang.InternalError | なし | Fatal | 捕捉した例外 を再送出 | VMの内部動作に起因するエラーが発生した場合に送出される。 |
| java.lang.UnknownError | なし | Fatal | 捕捉した例外 を再送出 |  |
| java.lang.StackOverflowError | なし | Fatal | Result. InternalError を返す。 | アプリケーションロジックの問題(無限ループ等)である 可能性が高いのでFatalログを出力し、再送出はしない。 |
| java.lang.OutOfMemoryError | なし | Fatal | Result. InternalError を返す。 | リソースを浪費しているリクエストスレッドが終了することで 復旧する可能性があるため、Fatalログを出力し再送出はしない。 なお、ログ出力の際には失敗する可能性があるので、 ログ出力前に標準エラー出力に最小限のメッセージを出力する。 |
| java.lang.VirtualMachineError (OutOfMemoryError /StackOverFlowErrorを除く) | なし | Fatal | 捕捉した例外 を再送出 |  |
| nablarch.fw.launcher.ProcessAbnormalEnd | あり | Fatal | 捕捉した例外 を再送出 | 駐起動バッチ等で、アプリケーション側からプロセス停止を 要求する場合に送出される。 |
| nablarch.fw.Result.ServiceError | あり | Fatal/Warn | 捕捉した例外 を返す。 | アプリケーション側から障害ログの出力が要求された場合に 送出される。 |
| nablarch.fw.Result.Error | なし | Fatal | 捕捉した例外 を返す。 |  |
| (上記以外の実行時例外/エラー) | なし | Fatal | Result. InternalError を返す。 |  |

運用ログに障害内容とメッセージを出力する。

### 設定項目・拡張ポイント

本ハンドラの実装内容は基本的に変更不要なものであり、そのまま使用することができる。
以下は設定ファイルの記述例である。

```xml
<component class="nablarch.fw.handler.GlobalErrorHandler" />
```

プロジェクト固有の要件により、例外処理を変更したい場合は、本ハンドラ自体を別実装したものに差し替えること。
