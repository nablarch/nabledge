## 常駐バッチ実行制御基盤

本節で解説する [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) では、一定間隔ごとにバッチ処理を実行する
常駐型プロセスを作成するための制御基盤を提供する。

例えば、オンライン処理で作成されたトランザクションデータを定期的に一括処理するような場合に使用される。

-----

-----

-----

### 基本構造

[常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) の構造は、以下の2つのハンドラがメインスレッド側に追加されている点を除けば
[都度起動バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-single-shot.md) と同じである。

1. [プロセス常駐化ハンドラ](../../component/handlers/handlers-ProcessResidentHandler.md)

このハンドラは、後続のハンドラキューの内容を一定間隔毎に繰り返し実行するハンドラである。
端的にいえば、 [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) とは、このハンドラを組み込むことにより、  [都度起動バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-single-shot.md) による処理を
定期的に実行するように拡張したものである。

1. [プロセス停止制御ハンドラ](../../component/handlers/handlers-ProcessStopHandler.md)

  上述の [プロセス常駐化ハンドラ](../../component/handlers/handlers-ProcessResidentHandler.md) は、特定の例外が送出されない限り、
  後続のハンドラを再実行しつづける。
  そのため、このハンドラを [プロセス常駐化ハンドラ](../../component/handlers/handlers-ProcessResidentHandler.md) の後続に配置し、
  プロセスを外部から正常停止できるようにしておく必要がある。

### 業務アクションハンドラの実装

業務アクションを実装するには、FW側で提供されるテンプレートクラスを継承して作成する。
詳細は、 [バッチ処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-BatchAction.md) を参照すること。

### 標準ハンドラ構成と主要処理フロー

以下は、 [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) の標準ハンドラ構成と、その上で発生しうる主要な処理フローを表したものである。

| 区分 | 種別 | 処理フロー名 | 概要 | 機能 |
|---|---|---|---|---|
| プロセス起動制御 | 正常フロー | 正常起動 | Javaコマンドからプロセスを起動し、 常駐処理を開始する。 | フローを表示 |
|  | 異常フロー | 重複起動エラー | プロセス起動時、既に同一プロセスが 起動していた場合は異常終了する。 | フローを表示 |
| 常駐処理制御 | 正常フロー | 常駐処理正常実行 | 要求管理テーブル上から未処理レコードを 取得し、各レコードに対して業務処理を 実行する。処理完了後、次の実行タイミング まで待機する。 | フローを表示 |
|  | 代替フロー | 処理対象データ待機 | 要求管理テーブル上に未処理レコードが存在 しなかった場合は、処理を行わず、次の実行 タイミングまで待機する。 | フローを表示 |
|  | 代替フロー | 閉局中処理待機 | 常駐バッチのリクエストIDに対する業務機能 が閉局中であった場合は、処理を行わず、 次の実行タイミングまで待機する。 | フローを表示 |
|  | 異常フロー | 常駐処理業務エラー | 処理中に実行時例外が送出された場合は、 障害ログ [1] を出力した上で、次の実行 タイミングまで待機する。 処理が完了していないレコードは、 次回以降の実行タイミングで処理される。 (ただし、エラーが発生したレコードは エラーステータスとなり、 データメンテを行なわない限り再実行の対象 とならない。)  > **Note:** > 実行時例外が繰り返し発生した場合の動作 > は、 異常フロー > を参照。  発生した例外が、リトライ可能例外 の場合には、障害ログではなく ワーニングログを出力し処理を継続する。  なぜなら、リトライ可能例外は障害原因 (DBやMQなどへの接続エラー)が 復旧することで正常に処理を継続 できるため、即障害通知を行う必要が ないためである。 | フローを表示 |
| プロセス停止制御 | 正常フロー | プロセス正常停止 | プロセス管理テーブルの停止フラグを設定する ことで、次回の実行タイミングにて処理を 行わずにプロセスを正常終了させる。 | フローを表示 |
|  | 異常フロー | プロセス異常停止 | 処理中にjava.lang.Errrorが発生した場合は、 その時点で処理を中断し、 障害ログを出力し、常駐プロセスを異常終了 させる。 | フローを表示 |
|  | 異常フロー | 常駐処理強制終了 | 業務処理実行中にエラーが発生し、 常駐処理を継続することができないと判断 した場合は、業務処理にて専用の例外 (ProcessAbnormalEnd) を送出する。 これにより、常駐プロセス自体が異常終了 する。 | フローを表示 |
|  | 異常フロー | エラー発生頻度上限超過 によるプロセス強制停止 | 一定時間内に発生したエラー回数が所定の 上限値を超えた場合は障害ログを出力し、 プロセスを異常終了させる。 | フローを表示 |

**標準ハンドラ構成** (説明文をクリックすると、その処理のステップレベルでの詳細が表示されます。)

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| 共通起動ランチャ | nablarch.fw.handler.Main | CommandLine | Integer | Javaコマンドから直接実行することで、DIリポジトリを初期化し、ハンドラキューを構築・実行する。 | 後続ハンドラの処理結果(整数値)を終了コードに指定し、プロセスを停止する。 | Fatalログを出力しプロセスを異常終了させる。 | - |
| ステータスコード→プロセス終了コード変換 | nablarch.fw.handler.StatusCodeConvertHandler | CommandLine | Integer | - | 後続ハンドラの処理結果をもとに、プロセス終了コード(整数値)を決定して返す。 | - | - |
| スレッドコンテキスト変数削除ハンドラ | nablarch.common.handler.threadcontext.ThreadContextClearHandler | Object | Object | - | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | - |
| グローバルエラーハンドラ | nablarch.fw.handler.GlobalErrorHandler | Object | Result | - | - | 全ての実行時例外・エラーを捕捉し、ログ出力を行う | - |
| スレッドコンテキスト変数設定ハンドラ(メインスレッド) | nablarch.common.handler.ThreadContextHandler_main | Object | Object | 起動引数の内容からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。 | - | - | - |
| プロセス多重起動防止ハンドラ | nablarch.fw.handler.DuplicateProcessCheckHandler | Object | Object | スレッドコンテキスト上のリクエストIDを用いて、リクエスト管理テーブル上の一致するレコードの実行ステータスを参照し、実行中であった場合は例外を送出する。 | - | - | - |
| リトライ制御ハンドラ | nablarch.fw.handler.RetryHandler | Object | Object | - | - | リトライ可能な実行時例外を捕捉し、かつリトライ上限に達していなければ後続のハンドラを再実行する。 | - |
| プロセス常駐化ハンドラ | nablarch.fw.handler.ProcessResidentHandler | Object | Object | データ監視間隔ごとに後続処理を繰り返し実行する。 | ループを継続する。 | ログ出力を行い、実行時例外が送出された場合はリトライ可能例外にラップして送出する。エラーが送出された場合はそのまま再送出する。 | - |
| 処理停止制御ハンドラ | nablarch.fw.handler.ProcessStopHandler | Object | Object | リクエストテーブル上の処理停止フラグがオンであった場合は、後続の処理は行なわずにプロセス停止例外(ProcessStop)を送出する。 | - | - | - |
| 開閉局制御ハンドラ | nablarch.fw.common.handler.ServiceAvailabilityCheckHandler | Request | Result | リクエストＩＤ単位での開閉局制御を行う | - | - | - |
| 出力ファイル開放ハンドラ | nablarch.common.handler.FileRecordWriterDisposeHandler | Object | Object | - | 業務アクションハンドラで書き込みを行うために開いた全ての出力ファイルを開放する | - | - |
| データベース接続管理ハンドラ (業務初期処理・終端処理用) | nablarch.common.handler.DbConnectionManagementHandler_main | Object | Object | 業務初期処理・終端処理用ＤＢ接続を取得し、スレッドローカル上に保持する。 | 業務初期処理・終端処理用ＤＢ接続を開放（プールに返却）する。 | 業務初期処理・終端処理用ＤＢ接続を開放（プールに返却）する。 | - |
| トランザクション制御ハンドラ(業務初期処理・終端処理用) | nablarch.fw.common.handler.TransactionManagementHandler_main | Object | Object | 業務初期処理・終端処理用トランザクションの開始 | トランザクションをコミットする。 | トランザクションをロールバックする。 | - |
| リクエストディスパッチハンドラ | nablarch.fw.handler.RequestPathJavaPackageMapping | Request | Object | 引数として渡されたリクエストオブジェクトのリクエストパスから、処理対象の業務アクションを決定しハンドラキューに追加する。 | - | - | - |
| マルチスレッド実行制御ハンドラ | nablarch.fw.handler.MultiThreadExecutionHandler | Object | MultiStatus | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 実行コンテキスト上にデータリーダが存在しない場合は、コールバックを行う。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 | 1. 処理開始前 / 2. データリーダ作成 / 3. スレッド異常終了時 / 4. 処理完了時 |
| データベース接続管理ハンドラ | nablarch.common.handler.DbConnectionManagementHandler | Object | Object | 業務処理用ＤＢ接続を取得し、スレッドローカル上に保持する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | - |
| トランザクションループハンドラ | nablarch.fw.handler.LoopHandler | Object | Object | 実行中の業務トランザクションがなければ、新規のトランザクションを開始する。 | コミット間隔毎に業務トランザクションをコミットする。また、データリーダ上に処理対象データが残っていればループを継続する。 | 業務トランザクションをロールバックする。 | 1.コミット完了後 / 2.ロールバック後 |
| データリードハンドラ | nablarch.fw.handler.DataReadHandler | Object | Result | 業務アクションハンドラが決定したデータリーダを使用してレコードを1件読み込み、後続ハンドラの引数として渡す。また実行時IDを採番する。 | - | 読み込んだレコードをログ出力した後、元例外を再送出する。 | - |
| バッチ処理用業務アクションハンドラ | nablarch.fw.action.BatchAction | SqlRow | Result | データリーダが読み込んだ1件分のデータレコードを入力として業務処理を実行する。 | 処理結果オブジェクトを返す。(通常はResult.Successを返す) | - | - |
