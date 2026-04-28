## リクエストスレッド内ループ制御ハンドラ

**クラス名:** `nablarch.fw.handler.RequestThreadLoopHandler`

-----

-----

### 概要

リクエストスレッド上のループ制御を行うハンドラ。

本ハンドラは、サーバソケットや受信電文キュー等を監視し、リアルタイム応答を行う
サーバ型プロセスにおいて、各リクエストスレッド上で以下のループ制御を行うハンドラである。:

```
データリーダによるリクエストの受信 → リクエスト処理の実行 → 次のリクエストの待機
```

サーバ型処理では、バッチ処理とは異なり、個々のリクエスト処理は完全に独立しているので、
1つのリクエスト処理がエラーとなっても他のリクエスト処理はそのまま継続しなければならない。
このため、本ハンドラで捕捉した例外は、プロセス正常停止要求や致命的な一部の例外を除き
再送出せずにそのまま処理を継続する。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| マルチスレッド実行制御ハンドラ | nablarch.fw.handler.MultiThreadExecutionHandler | Object | MultiStatus | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 実行コンテキスト上にデータリーダが存在しない場合は、コールバックを行う。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 | 1. 処理開始前 / 2. データリーダ作成 / 3. スレッド異常終了時 / 4. 処理完了時 |
| リクエストスレッド内ループ制御ハンドラ | nablarch.fw.handler.RequestThreadLoopHandler | Object | Object | データリーダが閉じられるまで、後続のハンドラを繰り返し実行する。 | ハンドラキューの内容を復旧しループを継続する。 | プロセス停止か致命的なエラーが発生した場合のみループを停止する。 | - |
| 処理停止制御ハンドラ | nablarch.fw.handler.ProcessStopHandler | Object | Object | リクエストテーブル上の処理停止フラグがオンであった場合は、後続の処理は行なわずにプロセス停止例外(ProcessStop)を送出する。 | - | - | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) | 本ハンドラーは、 [マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md) が作成する 各リクエストスレッド内のループ制御を行う。 |
| [プロセス停止制御ハンドラ](../../component/handlers/handlers-ProcessStopHandler.md) | 本ハンドラを組み込んだハンドラキューは、データリーダが閉じられるか、 致命的なエラーが発生しない限り停止しない。 外部からプロセスを正常終了させる場合は [プロセス停止制御ハンドラ](../../component/handlers/handlers-ProcessStopHandler.md) を後続ハンドラとして組み込む必要がある。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (ループ終了判定)**

データリーダが開いていることを確認する。

**1a.(ループ終了)**

データリーダが閉じられていた場合は、ループを終了し、直近の処理結果をリターンする。

**2. (実行コンテキストのコピー)**

ループ開始前の実行コンテキストをコピーして、1回分のループで使用する実行コンテキストを作成する。
この際、実行コンテキストの各属性は以下のように複製される。

| 属性名 | データ型 | コピーされる内容 |
|---|---|---|
| ハンドラキュー | List<[Handler](../../javadoc/nablarch/fw/Handler.html)> | ループ開始前のハンドラキューのシャローコピーを作成する。 |
| リクエストコンテキスト | Map<String, Object> | 新規のMapを作成する。 |
| セッションコンテキスト | Map<String, Object> | ループ開始前のセッションスコープのMapをそのまま設定する。 |
| データリーダ | [DataReader](../../javadoc/nablarch/fw/DataReader.html) | ループ開始前のデータリーダをそのまま設定する。 |
| データリーダファクトリ | [DataReaderFactory](../../javadoc/nablarch/fw/DataReaderFactory.html) | ループ開始前のファクトリをそのまま設定する。 |

**3. (後続ハンドラの実行)**

コピーした実行コンテキストを用いて、ハンドラキュー上の後続のハンドラに処理を委譲する。

**[復路処理]**

**4. (リクエスト処理正常終了 → ループ継続)**

後続ハンドラが正常終了した場合は、 **1.** に戻りループを継続する。

**[例外処理]**

**3a. (プロセス停止コマンド投入による正常停止)**

[プロセス停止制御ハンドラ](../../component/handlers/handlers-ProcessStopHandler.md) によりプロセス停止例外が送出された場合は、ループを中断し [Result.Success](../../javadoc/nablarch/fw/Result.Success.html) を返却して
終了コード0で正常終了させる。

**3b. (例外制御)**

後続ハンドラの処理中に実行時例外もしくはエラーが送出された場合でも、
ログ出力のみ行い、原則としてループは継続させる。
ただし、プロセスの継続に影響するような致命的なエラーが発生した場合のみ、例外を再送出し
プロセスを停止させる。

捕捉した例外/エラーの型ごとの処理内容の詳細は以下のとおり。

| 捕捉した例外クラス | 障害ログ出力 | ログレベル | 処理結果 | 備考 |
|---|---|---|---|---|
| nablarch.fw.Result.ServiceUnavailable | なし | Trace | ループ継続 | 業務機能が閉局していた場合に [開閉局制御ハンドラ](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md) から送出される。 INFOログを出力し、 本ハンドラに設定された **業務閉局時待機時間** だけwait した後でループを継続する。 |
| nablarch.fw.handler.retry.Retryable | なし | なし | 捕捉した例外 を再送出 | DB/MQの接続エラーなどの単純再実行による処理継続が可能な エラーが生じた場合に送出される。 再送出し上位の [リトライ制御ハンドラ](../../component/handlers/handlers-RetryHandler.md) で継続判断を行う。 |
| java.lang.ThreadDeath | なし | Info | 捕捉した例外 を再送出 | 外部からスレッド停止APIが呼ばれた場合に発生する。 通常運用で発生しうるため、Infoレベルのログを出力し、 再送出する。 |
| java.lang.StackOverflowError | あり | Fatal | ループ継続 | アプリケーションロジックの問題(無限ループ等)である 可能性が高いのでFatalログを出力し、再送出はしない。 |
| java.lang.OutOfMemoryError | あり | Fatal | ループ継続 | リソースを浪費しているリクエストスレッドが終了することで 復旧する可能性があるため、Fatalログを出力し再送出はしない。 なお、ログ出力の際には失敗する可能性があるので、 ログ出力前に標準エラー出力に最小限のメッセージを出力する。 |
| java.lang.VirtualMachineError | なし | なし | 捕捉した例外 を再送出 | (OutOfMemoryError/StackOverFlowErrorを除く) |
| nablarch.fw.launcher.ProcessAbnormalEnd | なし | なし | 捕捉した例外 を再送出 | (極めて特殊なケースを除き使用されない。) |
| nablarch.fw.Result.ServiceError | あり | Fatal/Warn | ループ継続 | アプリケーション側から障害ログの出力が要求された場合に 送出される。 |
| nablarch.fw.Result.Error | あり | Fatal | ループ継続 |  |
| (上記以外の実行時例外/エラー) | あり | Fatal | ループ継続 |  |

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| 業務閉局時待機時間(単位:msec) | serviceUnavailabilityRetryInterval | int | 任意指定 (デフォルト=1000) |

**標準設定**

[同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) では、
エラー応答送信後、速やかにメッセージ待機状態に移行するため、
業務閉塞時の待機時間を0に設定する。

```xml
<component class="nablarch.fw.handler.RequestThreadLoopHandler">
  <property name="serviceUnavailabilityRetryInterval" value="0" />
</component>
```

一方、 [応答不要メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-receive.md) では、
業務閉塞時は要求電文のGET処理は行なわず、業務が開局されるまで各リクエストスレッド上で、
リクエストテーブルをポーリングしつつ待機する。
このポーリング間隔を調整する場合は明示的に値を設定する。
(デフォルトでは1000msecずつ待機する。)

```xml
<component class="nablarch.fw.handler.RequestThreadLoopHandler">
  <property name="serviceUnavailabilityRetryInterval" value="2000" />
</component>
```
