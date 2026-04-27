

![handler_structure_bg.png](../../../knowledge/assets/nablarch-batch-batch-resident/handler_structure_bg.png)

![handler_bg.png](../../../knowledge/assets/nablarch-batch-batch-resident/handler_bg.png)

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

<script>

var nablarch_doc = 'http://192.168.160.126:18080/job/build.fw/ws/javadoc/'
  , jdk_doc      = 'http://docs.oracle.com/javase/1.5.0/docs/api/';

var Api = {

Object: {
  name: 'Object'
, doc: jdk_doc + 'java/lang/Object.html'
},

Integer: {
  name: 'Integer'
, doc: jdk_doc + 'java/lang/Integer.html'
},

Request: {
  name: 'Request'
, doc: nablarch_doc + 'nablarch/fw/Request.html'
},

Result: {
  name: 'Result'
, doc: nablarch_doc + 'nablarch/fw/Result.html'
},

DataRecord: {
  name: 'DataRecord'
, doc: nablarch_doc + 'nablarch/fw/core/dataformat/DataRecord.html'
},

SqlRow: {
  name: 'SqlRow'
, doc: nablarch_doc + 'nablarch/core/db/statement/SqlRow.html'
},

CommandLine: {
  name: 'CommandLine'
, doc: nablarch_doc + 'nablarch/fw/launcher/CommandLine.html'
},

MultiStatus: {
  name: 'MultiStatus'
, doc: nablarch_doc + 'nablarch/fw/Result.MultiStatus.html'
},

ResponseMessage: {
  name: 'ResponseMessage'
, doc: nablarch_doc + 'nablarch/fw/messaging/ResponseMessage.html'
},

RequestMessage: {
  name: 'RequestMessage'
, doc: nablarch_doc + 'nablarch/fw/messaging/RequestMessage.html'
},

HttpRequest: {
  name: 'HttpRequest'
, doc: nablarch_doc + 'nablarch/fw/web/HttpRequest.html'
},

HttpResponse: {
  name: 'HttpResponse'
, doc: nablarch_doc + 'nablarch/fw/web/HttpResponse.html'
},

ServletRequest_ServletResponse: {
  name: 'ServletRequest/Response'
, doc: ''
}

};

var Handler = {

// 汎用
Main: {
  name: "共通起動ランチャ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.CommandLine
  , returns:  Api.Integer
  }
, behavior: {
    inbound:  "Javaコマンドから直接実行することで、DIリポジトリを初期化し、ハンドラキューを構築・実行する。"
  , outbound: "後続ハンドラの処理結果(整数値)を終了コードに指定し、プロセスを停止する。"
  , error:    "Fatalログを出力しプロセスを異常終了させる。"
  }
},

StatusCodeConvertHandler: {
  name: "ステータスコード→プロセス終了コード変換"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.CommandLine
  , returns:  Api.Integer
  }
, behavior: {
    inbound:  "-"
  , outbound: "後続ハンドラの処理結果をもとに、プロセス終了コード(整数値)を決定して返す。"
  , error:    "-"
  }
},

GlobalErrorHandler: {
  name: "グローバルエラーハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Result
  }
, behavior: {
    inbound:  "-"
  , outbound: "-"
  , error:    "全ての実行時例外・エラーを捕捉し、ログ出力を行う"
  }
},

HttpCharacterEncodingHandler: {
  name: "HTTP文字エンコード制御ハンドラ"
, package: "nablarch.fw.web.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "HttpServletRequestおよびHttpServletResponseに対し文字エンコーディングを設定する。"
  , outbound: "-"
  , error:    "-"
  }
},

FileRecordWriterDisposeHandler: {
  name: "出力ファイル開放ハンドラ"
, package: "nablarch.common.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "-"
  , outbound: "業務アクションハンドラで書き込みを行うために開いた全ての出力ファイルを開放する"
  , error:    "-"
  }
},

ThreadContextHandler_main: {
  name: "スレッドコンテキスト変数設定ハンドラ(メインスレッド)"
, package: "nablarch.common.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "起動引数の内容からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。"
  , outbound: "-"
  , error:    "-"
  }
},

ThreadContextHandler_request: {
  name: "スレッドコンテキスト変数設定ハンドラ(リクエストスレッド)"
, package: "nablarch.common.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "前のループで設定されたスレッドコンテキスト変数をクリアするためここで再初期化する。"
  , outbound: "-"
  , error:    "-"
  }
},

ThreadContextClearHandler: {
  name: "スレッドコンテキスト変数削除ハンドラ"
, package: "nablarch.common.handler.threadcontext"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "-"
  , outbound: "ThreadContextHandlerで設定したスレッドローカル上の変数を削除する"
  , error:    "ThreadContextHandlerで設定したスレッドローカル上の変数を削除する"
  }
},

DuplicateProcessCheckHandler: {
  name: "プロセス多重起動防止ハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  'スレッドコンテキスト上のリクエストIDを用いて、'
            + 'リクエスト管理テーブル上の一致するレコードの実行ステータスを参照し、'
            + '実行中であった場合は例外を送出する。'
  , outbound: '実行ステータスを"停止"に戻す。'
  , error:    '実行ステータスを"停止"に戻す。'
 
  }
},

MultiThreadExecutionHandler: {
  name: "マルチスレッド実行制御ハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.MultiStatus 
  }
, behavior: {
    inbound:  "サブスレッドを作成し、後続ハンドラの処理を並行実行する。 "
            + "実行コンテキスト上にデータリーダが存在しない場合は、コールバックを行う。"
  , outbound: "全スレッドの正常終了まで待機する。 "
  , error:    "処理中のスレッドが完了するまで待機し起因例外を再送出する。"
  , callback: "1. 処理開始前
"
            + "2. データリーダ作成
"
            + "3. スレッド異常終了時
"
            + "4. 処理完了時</br/>"
  }
},

RequestThreadLoopHandler: {
  name: "リクエストスレッド内ループ制御ハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "データリーダが閉じられるまで、後続のハンドラを繰り返し実行する。"
  , outbound: "ハンドラキューの内容を復旧しループを継続する。"
  , error:    "プロセス停止か致命的なエラーが発生した場合のみループを停止する。"
  }
},

DbConnectionManagementHandler_main: {
  name: "データベース接続管理ハンドラ (業務初期処理・終端処理用)"
, package: "nablarch.common.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "業務初期処理・終端処理用ＤＢ接続を取得し、スレッドローカル上に保持する。"
  , outbound: "業務初期処理・終端処理用ＤＢ接続を開放（プールに返却）する。"
  , error:    "業務初期処理・終端処理用ＤＢ接続を開放（プールに返却）する。"
  }
},

DbConnectionManagementHandler: {
  name: "データベース接続管理ハンドラ"
, package: "nablarch.common.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "業務処理用ＤＢ接続を取得し、スレッドローカル上に保持する。"
  , outbound: "業務処理用ＤＢ接続を開放（プールに返却）する。"
  , error:    "業務処理用ＤＢ接続を開放（プールに返却）する。"

  }
},

ProcessStopHandler: {
  name: "処理停止制御ハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "リクエストテーブル上の処理停止フラグがオンであった場合は、後続の処理は行なわずにプロセス停止例外(ProcessStop)を送出する。 "
  , outbound: "-"
  , error:    "-" 
  }
},

MessagingContextHandler: {
  name: "メッセージングコンテキスト管理ハンドラ"
, package: "nablarch.fw.messaging.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "メッセージングコンテキスト(MQ接続)を取得し、スレッドローカルに保持する。"
  , outbound: "メッセージングコンテキストを開放する。（プールに戻す）"
  , error:    "メッセージングコンテキストを開放する。（プールに戻す）" 
  }
},

MessageReplyHandler: {
  name: "電文応答制御ハンドラ"
, package: "nablarch.fw.messaging.handler"
, type: {
    argument: Api.Object
  , returns:  Api.ResponseMessage
  }
, behavior: {
    inbound:  "-"
  , outbound: "後続ハンドラから返される応答電文オブジェクトの内容をもとに電文を作成して送信する。"
  , error:    "エラーオブジェクトの内容をもとに電文を作成して送信する。" 
  }
},

DataReadHandler: {
  name: "データリードハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Result
  }
, behavior: {
    inbound:  "業務アクションハンドラが決定したデータリーダを使用してレコードを1件読み込み、"
            + "後続ハンドラの引数として渡す。また実行時IDを採番する。"
  , outbound: "-"
  , error:    "読み込んだレコードをログ出力した後、元例外を再送出する。" 
  }
},

DataReadHandler_messaging: {
  name: "データリードハンドラ(FW制御ヘッダリーダ/メッセージリーダ利用)"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Result
  }
, behavior: {
    inbound:  "要求電文を受信しFW制御ヘッダ部を解析して要求電文オブジェクト(RequestMessage)を作成し後続のハンドラに渡す。"
            + "また、FW制御ヘッダのrequestId/userIdの値をメッセージコンテキストに設定する。"
  , outbound: "-"
  , error:    "-" 
  }
},

PermissionCheckHandler: {
  name: "認可制御ハンドラ"
, package: "nablarch.fw.common.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "スレッドコンテキスト上の userId/requestId をもとに認可判定を行う。"
            + "認可判定に失敗した場合は例外を送出して終了する。"
            + "成功した場合は、認可情報オブジェクトをスレッドローカルに設定する。"
  , outbound: "-"
  , error:    "-" 
  }
},

    
RequestPathJavaPackageMapping: {
  name: "リクエストディスパッチハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Request
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "引数として渡されたリクエストオブジェクトのリクエストパスから、"
            + "処理対象の業務アクションを決定しハンドラキューに追加する。"
  , outbound: "-"
  , error:    "-" 
  }
},

HttpRequestJavaPackageMapping: {
  name: "HTTPリクエストパスによるディスパッチハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "HTTPリクエストパスをもとに業務アクションを決定しハンドラキューに追加する。"
            + "HTTPメソッドによるメソッド単位のディスパッチを行う。(HttpMethodBinding)"
  , outbound: "-"
  , error:    "-" 
  }
},

ServiceAvailabilityCheckHandler: {
  name: "開閉局制御ハンドラ"
, package: "nablarch.fw.common.handler"
, type: {
    argument: Api.Request
  , returns:  Api.Result
  }
, behavior: {
    inbound:  "リクエストＩＤ単位での開閉局制御を行う"
  , outbound: "-"
  , error:    "-" 
  }
},

TransactionManagementHandler: {
  name: "トランザクション制御ハンドラ"
, package: "nablarch.fw.common.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "業務トランザクションの開始"
  , outbound: "トランザクションをコミットする。"
  , error:    "トランザクションをロールバックする。"
  , callback: "1.コミット完了後
2.ロールバック後
"
  }
},

TransactionManagementHandler_main: {
  name: "トランザクション制御ハンドラ(業務初期処理・終端処理用)"
, package: "nablarch.fw.common.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "業務初期処理・終端処理用トランザクションの開始"
  , outbound: "トランザクションをコミットする。"
  , error:    "トランザクションをロールバックする。"
  , callback: "-"
  }
},

ProcessResidentHandler: {
  name: "プロセス常駐化ハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "データ監視間隔ごとに後続処理を繰り返し実行する。"
  , outbound: "ループを継続する。"
  , error: "ログ出力を行い、実行時例外が送出された場合はリトライ可能例外にラップして送出する。"
         + "エラーが送出された場合はそのまま再送出する。"
  }
},

LoopHandler: {
  name: "トランザクションループハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "実行中の業務トランザクションがなければ、新規のトランザクションを開始する。"
  , outbound: "コミット間隔毎に業務トランザクションをコミットする。また、データリーダ上に処理対象データが残っていればループを継続する。 "
  , error:    "業務トランザクションをロールバックする。"
  , callback: "1.コミット完了後
2.ロールバック後
"
  }
},

MessageResendHandler: {
  name: "再送電文制御ハンドラ"
, package: "nablarch.fw.messaging.handler"
, type: {
    argument: Api.RequestMessage
  , returns:  Api.ResponseMessage
  }
, behavior: {
    inbound:  "再送要求に対し、以前応答した電文が保存されていれば、その内容をリターンする。(後続ハンドラは実行しない)"
  , outbound: "業務トランザクションが正常終了(コミット)された場合のみ電文を保存する"
  , error:    "-" 
  }
},

RetryHandler: {
  name: "リトライ制御ハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  ""
  , outbound: ""
  , error:    "リトライ可能な実行時例外を捕捉し、かつリトライ上限に達していなければ"
            + "後続のハンドラを再実行する。"
  }
},

NablarchServletContextListener: {
  name: "Nablarchサーブレットコンテキスト初期化リスナ"
, package: "nablarch.fw.web.servlet"
, type: {
    argument: null
  , returns:  null
  }
, behavior: {
    inbound:  "サーブレットコンテキスト初期化時に、リポジトリおよびハンドラキューの初期化処理を行う。"
  , outbound: ""
  , error:    "Fatalログを出力した上で再送出する。(デプロイエラーになる。) "
  }
},

WebFrontController: {
  name: "Webフロントコントローラ (サーブレットフィルタ) "
, package: "nablarch.fw.web.servlet"
, type: {
    argument: Api.ServletRequest_ServletResponse
  , returns:  null
  }
, behavior: {
    inbound:  "HttpServletRequest/HttpServletResponseから"
            + "HTTPリクエストオブジェクトを作成し、ハンドラキューに処理を委譲する。 "
  , outbound: "(Webコンテナ側に制御を戻す。)"
  , error:    "このハンドラでは例外およびエラーの捕捉は行なわず、そのまま送出する。"
  }
},

SessionConcurrentAccessHandler: {
  name: "セッション並行アクセスハンドラ"
, package: "nablarch.fw.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "ハンドラに設定された同期ポリシーを実装したラッパーをセッションスコープに適用し、"
            + "スコープ上の各変数に対する同期アクセス制御を開始する。 "
  , outbound: "同期アクセス制御を停止する。 "
  , error:    "同期アクセス制御を停止する。 "
  }
},

MultipartHandler: {
  name: "マルチパートリクエストハンドラ"
, package: "nablarch.fw.web.upload"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  "HTTPリクエストボディがマルチパート形式であった場合にその内容を解析し、一時ファイルに保存する。"
  , outbound: "アップロードされた一時ファイルを全て削除する。"
  , error:    "アップロードされた一時ファイルを全て削除する。"
  }
},

HttpResponseHandler: {
  name: "HTTPレスポンスハンドラ"
, package: "nablarch.fw.web.handler"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  ""
  , outbound: "HTTPレスポンスの内容に沿って"
            + "レスポンス処理かサーブレットフォーワードのいずれかを行う。"
  , error:    "既定のエラー画面をレスポンス後、例外を再送出する。"
            + "ただしサーブレットフォーワード処理中にエラーが発生した場合はログ出力のみを行なう。 "
  }
},

HttpAccessLogHandler: {
  name: "HTTPアクセスログハンドラ"
, package: "nablarch.fw.web.handler"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  "HTTPリクエストの内容についてログに出力する。 "
  , outbound: "送信するHTTPレスポンスの内容についてログに出力する。 "
  , error:    "送信するHTTPレスポンスの内容についてログに出力する。 "
  }
},

ForwardingHandler: {
  name: "内部フォーワードハンドラ"
, package: "nablarch.fw.web.handler"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  ""
  , outbound: "遷移先に内部フォーワードパスが指定されていた場合、"
            + "HTTPリクエストオブジェクトのリクエストURIを内部フォーワードパスに書き換えた後、"
            + "後続のハンドラを再実行する。 "
  , error:    ""
  }
},

HttpErrorHandler: {
  name: "HTTPエラー制御ハンドラ"
, package: "nablarch.fw.web.handler"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  ""
  , outbound: "HTTPレスポンスの内容が設定されていない場合は、ステータスコードに応じたデフォルトページを遷移先に設定する。"
  , error:    "送出されたエラーに応じた遷移先のHTTPレスポンスオブジェクトを返却する。"
            + "送出されたエラーはリクエストスコープに設定される。"
  }
},

ResourceMapping: {
  name: "リソースマッピングハンドラ"
, package: "nablarch.fw.web.handler"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  "リクエストURIを、クラスパス上のリソースパスもしくは"
            + "サーブレットフォーワードパスにマッピングすることで、"
            + "業務アクションを実行することなくHTTPレスポンスオブジェクトを作成して返却する。  "
  , outbound: ""
  , error:    ""

  }
},

NablarchTagHandler: {
  name: "Nablarchカスタムタグ制御ハンドラ"
, package: "nablarch.common.web.handler"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  "Nablarchカスタムタグの動作に必要な事前処理を実施する。"
  , outbound: ""
  , error:    ""

  }
},

// アクションハンドラ系:

MessagingAction: {
  name: "同期応答電文処理用業務アクションハンドラ"
, package: "nablarch.fw.action"
, type: {
    argument: Api.RequestMessage
  , returns:  Api.ResponseMessage
  }
, behavior: {
    inbound:  "要求電文の内容をもとに業務処理を実行する。"
  , outbound: "業務処理の結果と要求電文の内容から応答電文の内容を作成して返却する。"
  , error:    "-" 
  , callback: "トランザクションロールバック時にエラー応答電文を作成する。"
  }
},

AsyncMessageReceiveAction: {
  name: "応答不要電文受信処理用アクションハンドラ"
, package: "nablarch.fw.messaging.action"
, type: {
    argument: Api.RequestMessage
  , returns:  Api.Result
  }
, behavior: {
    inbound:  "要求電文内のデータレコードを指定されたテーブルに保存する。"
  , outbound: "正常終了(Result.Success)をリターンする。"
  , error:    "-" 
  }
},

AsyncMessageSendAction: {
  name: "応答不要電文送信処理用アクションハンドラ"
, package: "nablarch.fw.messaging.action"
, type: {
    argument: Api.SqlRow
  , returns:  Api.Result
  }
, behavior: {
    inbound:  "テーブル上の各レコードの内容から送信電文オブジェクトを生成し送信する。"
  , outbound: "正常終了(Result.Success)をリターンする。"
  , error: "-"
  , callback: "<b>コミット完了時:</b> 対象レコードの送信ステータスを'処理済み'に更新する。
" 
            + "<b>ロールバック時:</b> 対象レコードの送信ステータスを'エラー'に更新する。"
  }
},

BatchAction: {
  name: "バッチ処理用業務アクションハンドラ"
, package: "nablarch.fw.action"
, type: {
    argument: Api.SqlRow
  , returns:  Api.Result
  }
, behavior: {
    inbound:  "データリーダが読み込んだ1件分のデータレコードを入力として業務処理を実行する。"
  , outbound: "処理結果オブジェクトを返す。(通常はResult.Successを返す)"
  , error:    ""

  }
},

NoInputDataBatchAction: {
  name: "単発バッチ処理用業務アクションハンドラ"
, package: "nablarch.fw.action"
, type: {
    argument: Api.SqlRow
  , returns:  Api.Result
  }
, behavior: {
    inbound:  "データリーダが読み込んだ1件分のデータレコードを入力として業務処理を実行する。"
  , outbound: "処理結果オブジェクトを返す。(通常はResult.Successを返す)"
  , error:    ""
  , callback: "一度だけダミー読込みを行うデータリーダを作成して返す。"

  }
},

FileBatchAction: {
  name: "ファイル入力バッチ処理用業務アクションハンドラ"
, package: "nablarch.fw.action"
, type: {
    argument: Api.DataRecord
  , returns:  Api.Result
  }
, behavior: {
    inbound:  "設定されたファイル内のデータレコードを入力として業務処理を実行する。"
  , outbound: "処理結果オブジェクトを返す。(通常はResult.Successを返す)"
  , error:    ""

  }
},

HttpMethodBinding: {
  name: "画面オンライン処理業務アクション"
, package: "nablarch.fw.action"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  "HTTPリクエストの内容をもとに業務処理を実行する"
  , outbound: "遷移先画面に表示する内容をリクエストコンテキストに設定した上で、"
            + "遷移先パスを設定したHTTPレスポンスオブジェクトを返却する。 "
  , error:    ""

  }
}, 

HttpRewriteHandler: {
  name: "HTTPリライトハンドラ"
, package: "nablarch.fw.web.handler"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  "HTTPリクエストパスの内容を指定した条件に従って書き換える。"
  , outbound: "HTTPレスポンスのコンテンツパスの内容を、指定した条件に従って書き換える。"
  , error:    ""

  }
},

KeitaiAccessHandler: {
  name: "携帯対応ハンドラ"
, package: "nablarch.fw.web.handler"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  "POSTパラメータ中の'nablarch_uri_override_'で始まる変数名の内容をもとに、リクエストパスの書き換えを行う。"
  , outbound: "リクエストスコープ上のフラグ変数 'nablarch_jsUnsupported' を設定する。"
            + "これにより、各タグライブラリにjavascriptを使用しないページを出力させる。"
  , error:    ""

  }
}

}; // end

</script>

**標準ハンドラ構成** (説明文をクリックすると、その処理のステップレベルでの詳細が表示されます。)

<script>
var Context      = 'batch resident'
  , HandlerQueue = [
      "Main"
    , "StatusCodeConvertHandler"
    , "ThreadContextClearHandler"
    , "GlobalErrorHandler"
    , "ThreadContextHandler_main"
    , "DuplicateProcessCheckHandler"
    , "RetryHandler"
    , "ProcessResidentHandler"
    , "ProcessStopHandler"
    , "ServiceAvailabilityCheckHandler"
    , "FileRecordWriterDisposeHandler"
    , "DbConnectionManagementHandler_main"
    , "TransactionManagementHandler_main"
    , "RequestPathJavaPackageMapping"
    , "MultiThreadExecutionHandler"
    , "DbConnectionManagementHandler"
    , "LoopHandler"
    , "DataReadHandler"
    , "BatchAction"
    ]
  , Flow = {

      // 正常起動
      launch: [
        ["Main",                          "inbound"]
      , ["ThreadContextHandler_main",     "inbound"]
      , ["ProcessResidentHandler",        "inbound", "以降、常駐処理を開始する。監視間隔ごとに後続の"
                                                   + "ハンドラキューの処理が繰り返し実行される。"]
      ],

      // 重複起動エラー
      duplaunch: [
        ["Main",                         "inbound"]
      , ["ThreadContextHandler_main",    "inbound",  "起動引数-requestPathからこのバッチのリクエストIDを決定する。"]
      , ["DuplicateProcessCheckHandler", "inbound",  "起動停止時の終了コードはこのハンドラに設定する。"]
      , ["GlobalErrorHandler",           "error",    "ここで障害ログが出力される。"]
      , ["Main",                         "outbound"]
      ],

      // 常駐処理正常実行
      normalend: [
        ["ProcessResidentHandler",             "inbound", "常駐処理の起点"]
      , ["DbConnectionManagementHandler_main", "inbound"]
      , ["TransactionManagementHandler_main",  "inbound"]
      , ["RequestPathJavaPackageMapping",      "inbound"]
      , ["MultiThreadExecutionHandler",        "inbound", "処理開始前及びデータリーダ作成時に業務アクションへのコールバックを行う。"]
      , ["BatchAction",                        "callback", "以下のイベントでコールバックされる。
"
                                                        +  "1. 処理開始前、2. データリーダ作成、3. 業務コミット後 、4. 全件終了後"]
      , ["DbConnectionManagementHandler",      "inbound"]
      , ["LoopHandler",                        "inbound"]
      , ["DataReadHandler",                    "inbound"]
      , ["BatchAction",                        "inbound"]
      , ["BatchAction",                        "outbound"]
      , ["LoopHandler",                        "outbound", "コミット時に業務アクションへのコールバックを行う。"
                                                         + "また⑨ で取得した結果セットが空になるまでここでループする。"]
      , ["BatchAction",                        "callback"]
      , ["DbConnectionManagementHandler",      "outbound"]
      , ["MultiThreadExecutionHandler",        "outbound", "正常終了後に業務アクションへのコールバックを行う。"]
      , ["BatchAction",                        "callback"]
      , ["TransactionManagementHandler_main",  "outbound"]
      , ["DbConnectionManagementHandler_main", "outbound"]
      , ["ProcessResidentHandler",             "outbound"]
      ],

      // 処理対象データ待機
      waitdata: [
        ["ProcessResidentHandler",             "inbound", "常駐処理の起点"]
      , ["DbConnectionManagementHandler_main", "inbound"]
      , ["TransactionManagementHandler_main",  "inbound"]
      , ["RequestPathJavaPackageMapping",      "inbound"]
      , ["MultiThreadExecutionHandler",        "inbound", "処理開始前及びデータリーダ作成時に業務アクションへのコールバックを行う。"]
      , ["DbConnectionManagementHandler",      "inbound"]
      , ["LoopHandler",                        "inbound", "要求管理テーブル上の処理対象データが0件であった場合は、後続処理は行わず、"
                                                        + "DataReader.NoMoreRecord をリターンする。"]
      , ["DbConnectionManagementHandler",      "outbound"]
      , ["MultiThreadExecutionHandler",        "outbound"]
      , ["TransactionManagementHandler_main",  "outbound"]
      , ["DbConnectionManagementHandler_main", "outbound"]
      , ["ProcessResidentHandler",             "outbound", "→① へ"]
      ],

      // 閉局中処理待機
      notonservice: [
        ["ProcessResidentHandler",             "inbound", "常駐処理の起点"]
      , ["ServiceAvailabilityCheckHandler",    "inbound", "サービス閉局例外を送出する。"]
      , ["ProcessResidentHandler",             "error",   "サービス閉局例外を捕捉した場合、INFOログを出力しループを継続する。→ ① へ"]
      ],

      // 常駐処理業務エラー
      errorend: [
        ["ProcessResidentHandler",             "inbound", "常駐処理の起点"]
      , ["DbConnectionManagementHandler_main", "inbound"]
      , ["TransactionManagementHandler_main",  "inbound"]
      , ["RequestPathJavaPackageMapping",      "inbound"]
      , ["MultiThreadExecutionHandler",        "inbound", "処理開始前及びデータリーダ作成時に業務アクションへのコールバックを行う。"]
      , ["BatchAction",                        "callback", "以下のイベントでコールバックされる。
"
                                                        +  "1. 処理開始前、2. データリーダ作成、3. エラー終了後、4. 全件終了後"]
      , ["DbConnectionManagementHandler",      "inbound"]
      , ["LoopHandler",                        "inbound"]
      , ["DataReadHandler",                    "inbound"]
      , ["BatchAction",                        "inbound"]
      , ["BatchAction",                        "error",    "業務処理をエラー終了させる場合は、実行時例外を送出する。"
                                                         + "これにより、トランザクションがロールバックされ、障害ログが出力される。"]
      , ["LoopHandler",                        "error",    "複数件コミットを使用している場合は、未コミットの処理についてもロールバックされる。"
                                                         + "また業務アクションをコールバックする。"]
      , ["BatchAction",                        "callback"]
      , ["DbConnectionManagementHandler",      "error"]
      , ["MultiThreadExecutionHandler",        "error", "異常終了後に業務アクションへのコールバックを行う。"]
      , ["BatchAction",                        "callback"]
      , ["TransactionManagementHandler_main",  "error"]
      , ["DbConnectionManagementHandler_main", "error"]
      , ["ProcessResidentHandler",             "error"]
      , ["RetryHandler",                       "error", "→① へ"]
      ],

      // プロセス正常停止
      termination: [
        ["ProcessResidentHandler",             "inbound", "常駐処理の起点"]
      , ["ProcessStopHandler",                 "inbound", "リクエストIDはバッチの起動引数'-requestPath'の値から決定される値"]
      , ["ProcessResidentHandler",             "error",   "ここでプロセス停止要求(ProcessStop)を捕捉すると、INFOログを出力後、"
                                                        + "処理結果オブジェクトをリターンする。(ステータスコード:200)"]
      , ["StatusCodeConvertHandler",      "outbound", "ステータスコード:200 → 終了コード:0"]
      , ["Main",                          "outbound", "正常終了"]
      ],

      // 常駐処理正常実行
      forcestop: [
       ["BatchAction",                         "inbound",    "常駐プロセス自体を終了させる場合は、ProcessAbnormalEnd 例外を送出する。"
                                                         + "これにより、実行中の処理だけで無く、プロセス全体がエラー終了させる。"]
      , ["LoopHandler",                        "error",    "複数件コミットを使用している場合は、未コミットの処理についてもロールバックされる。"
                                                         + "また業務アクションをコールバックする。"]
      , ["BatchAction",                        "callback"]
      , ["DbConnectionManagementHandler",      "error"]
      , ["MultiThreadExecutionHandler",        "error", "異常終了後に業務アクションへのコールバックを行う。"]
      , ["BatchAction",                        "callback"]
      , ["TransactionManagementHandler_main",  "error"]
      , ["DbConnectionManagementHandler_main", "error"]
      , ["ProcessResidentHandler",             "error", "ProcessAbnormalEndはそのまま再送出する。(ループは中断)"]
      , ["GlobalErrorHandler",                 "error", "ProcessAbnormalEndを捕捉した場合、障害ログを出力し、例外を処理結果オブジェクト"
                                                       +"としてリターンする。"]
      , ["StatusCodeConvertHandler",      "outbound"]
      , ["Main",                          "outbound", "異常終了"]
      ],

      // プロセス異常終了
      abort: [
        ["BatchAction",                        "inbound",    "処理中に java.lang.Error のサブクラスが送出されたとする。"]
      , ["LoopHandler",                        "error",    "複数件コミットを使用している場合は、未コミットの処理についてもロールバックされる。"
                                                         + "また業務アクションをコールバックする。"]
      , ["BatchAction",                        "callback"]
      , ["DbConnectionManagementHandler",      "error"]
      , ["MultiThreadExecutionHandler",        "error", "異常終了後に業務アクションへのコールバックを行う。"]
      , ["BatchAction",                        "callback"]
      , ["TransactionManagementHandler_main",  "error"]
      , ["DbConnectionManagementHandler_main", "error"]
      , ["ProcessResidentHandler",             "error", "発生したエラーをそのまま再送出する。(ループは中断)"]
      , ["GlobalErrorHandler",                 "error", "障害ログを出力し、異常終了を表す処理結果オブジェクトをリターンする。"]
      , ["StatusCodeConvertHandler",           "outbound"]
      , ["Main",                               "outbound", "異常終了"]
      ],

      // 常駐処理業務エラー
      retryerror: [
        ["ProcessResidentHandler",             "inbound", "常駐処理の起点"]
      , ["DbConnectionManagementHandler_main", "inbound"]
      , ["TransactionManagementHandler_main",  "inbound"]
      , ["RequestPathJavaPackageMapping",      "inbound"]
      , ["MultiThreadExecutionHandler",        "inbound", "処理開始前及びデータリーダ作成時に業務アクションへのコールバックを行う。"]
      , ["BatchAction",                        "callback", "以下のイベントでコールバックされる。
"
                                                        +  "1. 処理開始前、2. データリーダ作成、3. エラー終了後、4. 全件終了後"]
      , ["DbConnectionManagementHandler",      "inbound"]
      , ["LoopHandler",                        "inbound"]
      , ["DataReadHandler",                    "inbound"]
      , ["BatchAction",                        "inbound"]
      , ["BatchAction",                        "error",    "業務処理をエラー終了させる場合は、実行時例外を送出する。"
                                                         + "これにより、トランザクションがロールバックされ、障害ログが出力される。"]
      , ["LoopHandler",                        "error",    "複数件コミットを使用している場合は、未コミットの処理についてもロールバックされる。"
                                                         + "また業務アクションをコールバックする。"]
      , ["BatchAction",                        "callback"]
      , ["DbConnectionManagementHandler",      "error"]
      , ["MultiThreadExecutionHandler",        "error", "異常終了後に業務アクションへのコールバックを行う。"]
      , ["BatchAction",                        "callback"]
      , ["TransactionManagementHandler_main",  "error"]
      , ["DbConnectionManagementHandler_main", "error"]
      , ["ProcessResidentHandler",             "error"]
      , ["RetryHandler",                       "error", "リトライ頻度が上限に達した場合はProcessAbnormalEndを送出。"]
      , ["GlobalErrorHandler",                 "error", "障害ログを出力し、異常終了を表す処理結果オブジェクトをリターンする。"]
      , ["StatusCodeConvertHandler",           "outbound"]
      , ["Main",                               "outbound", "異常終了"]
      ]
    };

</script>

<style>

#handler_structure {
  border-collapse: separate;
  width:100%;
  margin:0 0 30px -1px;

}

#handler_structure thead {
  font-size: 12px;
  color: white;
  background-color: #444444;
  border-left: 1px solid #EEEEEE;
  line-height: 100%;
}

#handler_structure ol, #handler_structure ul {
  padding: 0 0 0 15px;
  margin: 0;
}

#handler_structure tbody tr {
  height: 130px;
}

#handler_structure td {
  font-size: 10px;
  line-height: 110%;
  padding: 2px;
  border-left:  1px solid #EEEEEE;
  background-repeat: repeat-x;
  background-position: 0 7px;
}

#handler_structure td.first_column {
  padding-left: 18px;
  background-repeat: no-repeat;
  background-position: -10px -184px;
}

#handler_structure td.last_column {
  padding-right: 18px;
  background-repeat: no-repeat;
  background-position: -291px -184px;
  border-left:  0   solid;
  border-right: 1px solid #EEEEEE;
}

#handler_structure td.spacer {
  height: 80px;
  background: white;
}

#handler_structure td.handler_name .name {
  font-size: 12px;
  font-weight: bold;
  width: 150px;
}

#handler_structure td.handler_name {
  border: 0 solid;
  line-height: 1.5em;
}

#handler_structure td.handler_name .fqn {
  margin: 8px 0 0 0;
  cursor: pointer;
}

#handler_structure td.inbound,
#handler_structure td.outbound,
#handler_structure td.error,
#handler_structure td.callback {
  cursor: pointer;
}

#handler_structure td.diagram {
  width: 210px;
  background-repeat: no-repeat;
  background-position: -50px -579px;
}

#handler_structure tr.Main td.diagram {
  background-position: -50px -184px;
}

#handler_structure tr.sub_thread td.diagram {
  background-position: -50px -1340px;
}

#handler_structure tr.main_to_sub_thread td.diagram {
  background-position: -50px -980px;
}

#handler_structure tr.MultiThreadExecutionHandler td.diagram {
  background-position: -50px -773px;
}

#handler_structure tr.StatusCodeConvertHandler td.diagram {
  background-position: -50px -397px;
}

#handler_structure tr.RequestThreadLoopHandler td.diagram {
  background-position: -50px -1138px;
}

#handler_structure tr.MessageReplyHandler td.diagram {
  background-position: -50px -1532px;
}

#handler_structure tr.DataReadHandler.data_read td.diagram {
  background-position: -50px -2592px;
}

#handler_structure tr.DataReadHandler_messaging.data_read td.diagram {
  background-position: -50px -1728px;
}

#handler_structure tr.data_read td.diagram {
  background-position: -50px -1941px;
}

#handler_structure tr.MessageResendHandler td.diagram {
  background-position: -50px -2149px;
}

#handler_structure tr.MessagingAction td.diagram {
  background-position: -50px -2361px;
}

#handler_structure tr.AsyncMessageReceiveAction td.diagram {
  background-position: -50px -2805px;
}

#handler_structure tr.AsyncMessageSendAction td.diagram {
  background-position: -50px -2805px;
}

#handler_structure tr.BatchAction td.diagram {
  background-position: -50px -2805px;
}

#handler_structure tr.NoInputDataBatchAction td.diagram {
  background-position: -50px -2805px;
}

#handler_structure tr.LoopHandler td.diagram {
  background-position: -50px -1138px;
}

#handler_structure tr.ProcessResidentHandler td.diagram {
  background-position: -50px -3158px;
}

#handler_structure tr.NablarchServletContextListener td.diagram {
  background-position: -50px -3420px;
}

#handler_structure tr.NablarchServletContextListener td.diagram {
  background-position: -50px -3451px;
}

#handler_structure tr.servlet_request_thread td.diagram {
  background-position: -50px -3600px;
}

#handler_structure tr.WebFrontController td.diagram {
  background-position: -50px -3723px;
}

#handler_structure tr.HttpResponseHandler td.diagram {
  background-position: -50px -4173px;
}

#handler_structure tr.ForwardingHandler td.diagram {
  background-position: -50px -3944px;
}

#handler_structure tr.RetryHandler td.diagram {
  background-position: -50px -4808px;
}

#handler_structure tr.RetryHandler.main_thread td.diagram {
  background-position: -50px -5079px;
}

#handler_structure tr.ResourceMapping td.diagram {
  background-position: -50px -4388px;
}

#handler_structure tr.HttpMethodBinding td.diagram {
  background-position: -50px -4615px;
}

 #handler_structure .diagram .mark_l
,#handler_structure .diagram .mark_r {
  color: red;
  font-weight: bold;
  font-size:18px;
}

#handler_structure .diagram .mark_r {
  text-align: right;
}

#handler_structure .diagram .mark_l {
  text-align: left;
}

#handler_structure .dim,
#handler_structure .dim a {
  color: #DDD;
}

#handler_structure .step {
  color: red;
  margin-top: 3px;
}

#handler_structure .step.num {
  font-size: 15px;
  font-weight: bold;
}

#handler_structure .diagram .retType {
  position: relative;
  top: -40px;
  float: right;
  font-weight: bold;
  text-align: right;
}

#handler_structure .diagram .argType {
  position: relative;
  float: left;
  top: -40px;
  font-weight: bold;
}

#handler_structure tr.main_thread td.diagram {
}

#handler_structure tr.first_row td.diagram {
  height: 100px;
  background-position: -50px -1px;
}

#view_options {
  margin:  0;
  padding: 0;
}

#view_options li {
  list-style-type: none;
  display: inline;
}

#view_options label {
  text-decoration: underline;
  cursor: pointer;
}

#view_options input {
  cursor: pointer;
}

#handler_structure .tx_box {
   border: 4px solid #aae;
   background-position: 0 3px;
}

#handler_structure .tx_t {
   border-top: 4px solid #aae;
   background-position: 0 3px;
}

#handler_structure .tx_b {
   border-bottom: 4px solid #aae;
}
#handler_structure .tx_l {
   border-left: 4px solid #aae;
}

#handler_structure .tx_r {
   border-right: 4px solid #aae;
}

#handler_structure .scope_box {
   border: 4px solid #aea;
   background-position: 0 3px;
}

#handler_structure .scope_t {
   border-top: 4px solid #aea;
   background-position: 0 3px;
}

#handler_structure .scope_b {
   border-bottom: 4px solid #aea;
}
#handler_structure .scope_l {
   border-left: 4px solid #aea;
}

.scope_r {
   border-right: 4px solid #aea;
}

</style>

<table id='handler_structure' cellspacing='0'>
<thead>
  <tr>
  <th class='handler_name' colspan='2'>ハンドラ</th>
  <th class='behavior'>模式図</th>
  <th class='behavior'>往路処理</th>
  <th class='behavior'>復路処理</th>
  <th class='behavior'>例外処理</th>
  <th class='behavior'>コールバックイベント</th>
  <th class='last_column'></th>
  </tr>
</thead>

<tbody>

<tr class='first_row'>
  <td colspan='2' class='spacer'></td>
  <td class='behavior diagram'></td>
  <td colspan='5' class='spacer'></td>
</tr>

<tr id='handler_template'>
  <td class='first_column'></td>

  <td class='handler_name'>
    <div class='name'><!--ハンドラ名称--></div>
    <div class='fqn'><a href='#'><!--ハンドラクラス完全修飾名--></a></div>
  </td>

  <td class='behavior diagram'>
    <!--模式図-->
    <span class='argType'></span>
    <span class='retType'></span>
 </td>

  <td class='behavior inbound'>
    <!--往路処理内容-->
  </td>

  <td class='behavior outbound'>
    <!--復路処理内容-->
  </td>

  <td class='behavior error'>
    <!--エラー処理内容-->
  </td>

  <td class='behavior callback'>-</td>
  <td class='last_column'></td>
</tr>

<tr class='main_to_sub_thread'>
  <td colspan='2' class='spacer'></td>
  <td class='behavior diagram'></td>
  <td colspan='5' class='spacer'></td>
</tr>

</tbody>

<tfoot>

</tfoot>
</table>

<script>
(function($) {
    var threadType   = 'main_thread'
      , dataRead     = ''
      , $table       = $('#handler_structure tbody')
      , $first_row   = $('tr.first_row')
      , $template    = $('#handler_template')
      , $main_to_sub = $('tr.main_to_sub_thread');

    $table.find('tr').remove();

    function renderHandlerStructure() {
        var queue = HandlerQueue;
        if (Context.indexOf('messaging') != -1 || Context.indexOf('batch') != -1) {
            $first_row.addClass(Context).appendTo($table);
        }
        for (var i=0, len=queue.length; i<len; i++) {
            var handlerClass = queue[i];
            render(handlerClass);
        }
        $('tr.MultiThreadExecutionHandler').after($main_to_sub);
        $('tr.NablarchServletContextListener').each(function() {
            $main_to_sub.addClass("servlet_request_thread");
            $(this).after($main_to_sub);
         });
    }

    function render(handlerClass) {
        var $node   = $template.clone()
          , handler = Handler[handlerClass]
          , link    = '#';

        if (handlerClass == 'MultiThreadExecutionHandler'
        ||  handlerClass == 'NablarchServletContextListener') {
            threadType = 'sub_thread';
        }
        $node.attr({'id': handlerClass});

        if (handlerClass.split('_')[0] == 'DataReadHandler'
        || Context.indexOf('web') != -1) {
            dataRead = 'data_read';
        }

        $node.addClass([handlerClass, Context, threadType, dataRead].join(' '));

        link = '../handler/' + handlerClass.split('_')[0] + '.html';

        $node.find('.name').text(handler.name);
        $node.find('.fqn')
             .html('<a hr'+'ef = ' + link + '>'
                                + handler.package + '
 .'
                                + handlerClass.split('_')[0]
                                + '</a>');
        $node.find('.inbound')
             .click(function(){document.location = link + '#inbound'})
             .text(handler.behavior.inbound);
        $node.find('.outbound')
             .click(function(){document.location = link + '#outbound'})
             .text(handler.behavior.outbound);
        $node.find('.error')
             .click(function(){document.location = link + '#error'})
             .text(handler.behavior.error);
        $node.find('.callback')
             .click(function(){document.location = link + '#callback'})
             .html(handler.behavior.callback);

        if (handler.type.returns) {
            $node.find('.retType')
                 .html('[結果型]
<a hr'+'ef="' + handler.type.returns.doc + '">'
                      + handler.type.returns.name
                      + '</a>');
        }
        if (handler.type.argument) {
            $node.find('.argType')
                 .html('[入力型]
<a hr'+'ef="' + handler.type.argument.doc + '">'
                     + handler.type.argument.name
                     + '</a>');
        }
        $node.appendTo($table);
    }

    renderHandlerStructure();

    $('#flow-table').click(function(event){
        var flowName = event.target.parentNode.id;
        if (flowName.length > 0) {
            renderFlow(flowName);
        }
    });

    function renderFlow(flowName) {
        var flow = Flow[flowName]
           ,stepNum = ['①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧', '⑨', '⑩'
                      ,'⑪', '⑫', '⑬', '⑭', '⑮', '⑯', '⑰', '⑱', '⑲', '⑳', '(21)', '(22)', '(23)'];

        $table.find('.step').remove();
        $table.find('.dim').removeClass('dim');

        $table.find('td').addClass('dim');
        for (var i=0, len=flow.length; i<len; i++) {
            render.apply(null, flow[i]);
        }
        function render(handlerName, phase, comment) {
            var $step = null;
            $table.find('tr.' + handlerName)
                  .find(' td.' + phase + ', td.handler_name')
                  .removeClass('dim');
            $step = $table.find('tr.' + handlerName + ' td.' + phase);
            $step.html(
                '<span class="step num">' + stepNum[i] + '</span>'
              + $step.html()
              + (comment ? '<div class="step">※ ' + comment + '</div>' : '')
            );
        }
    }

    var bg1_path = 'url(' + $('img.bg1').attr('src') + ')';
    var bg2_path = 'url(' + $('img.bg2').attr('src') + ')';
    $('#handler_structure td:not(.spacer)').css('background-image', bg2_path);
    $('#handler_structure td.diagram, td.first_column, td.last_column').css('background-image', bg1_path);

})(jQuery);
</script>
