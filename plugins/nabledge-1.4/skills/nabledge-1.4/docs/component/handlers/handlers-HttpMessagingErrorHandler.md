

![handler_structure_bg.png](../../../knowledge/assets/handlers-HttpMessagingErrorHandler/handler_structure_bg.png)

![handler_bg.png](../../../knowledge/assets/handlers-HttpMessagingErrorHandler/handler_bg.png)

## HTTPメッセージングエラー制御ハンドラ

**クラス名:** `nablarch.fw.messaging.handler.HttpMessagingErrorHandler`

-----

-----

### 概要

本ハンドラでは、後続ハンドラの処理中に送出された例外を捕捉し、
障害ログを出力した後、HTTPエラーレスポンスオブジェクトを作成して返す。

また、後続ハンドラの処理が正常終了し、その処理結果に遷移先画面か応答内容のどちらもも設定されていない場合は、
既定のエラー画面を遷移先として指定する。

> **Note:**
> 本ハンドラを経由したリクエストに対するレスポンスでは、内部ステータスコードをそのままHTTPステータスコードとして使用する。
> (通常の画面オンライン処理では、エラー画面自体のレスポンスはステータスコード200で行う。)

-----

**ハンドラ処理概要**

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
, package: "nablarch.common.handler.threadcontext"
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
, package: "nablarch.common.handler.threadcontext"
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
, package: "nablarch.fw.web.handler"
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
    argument: Api.Object
  , returns:  Api.Object
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

HttpMessagingRequestParsingHandler: {
  name: "HTTPメッセージングリクエスト変換ハンドラ"
, package: "nablarch.fw.messaging.handler"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.Object
  }
, behavior: {
    inbound:  "HTTPリクエストデータを解析し、後続ハンドラの引数（RequestMessage）のレコードとして設定する。"
  , outbound: ""
  , error:    ""
  }
},

HttpMessagingResponseBuildingHandler: {
  name: "HTTPメッセージングレスポンス変換ハンドラ"
, package: "nablarch.fw.messaging.handler"
, type: {
    argument: Api.Object
  , returns:  Api.Object
  }
, behavior: {
    inbound:  ""
  , outbound: "返却された応答データを解析し、HTTPレスポンスデータに変換する。"
  , error:    "エラー応答電文の内容を解析し、HTTPエラーレスポンスとして再送出する。"
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
, package: "nablarch.common.web.handler"
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

HttpMessagingErrorHandler: {
  name: "HTTPメッセージングエラー制御ハンドラ"
, package: "nablarch.fw.messaging.handler"
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

PostResubmitPreventHandler: {
  name: "POST再送信防止ハンドラ"
, package: "nablarch.fw.web.post"
, type: {
    argument: Api.HttpRequest
  , returns:  Api.HttpResponse
  }
, behavior: {
    inbound:  "POST再送信防止が指示されたリクエストである場合、リクエスト情報をセッションスコープに格納し、"
            + "再度同じURIに対してリダイレクトする。POST再送信防止が指示されたリクエストでない場合"
            + "POST後にリダイレクトされたリクエストであるか否かを判定し、そうである場合"
            + "セッションスコープに格納したリクエスト情報をリクエストに設定後、後続のハンドラを呼び出す。"
            + "そうでない場合、単に後続のハンドラを呼び出す。"
  , outbound: "-"
  , error:    "-"

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

<script>
var Context      = 'handler sub_thread data_read'
  , HandlerQueue = [
      "HttpResponseHandler"
    , "HttpMessagingErrorHandler"
    ];
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

#handler_structure tr.PostResubmitPreventHandler td.diagram {
  background-position: -50px -5366px;
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

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) | 本ハンドラでは捕捉した例外に対するHTTPレスポンスオブジェクトを作成するものの、 レスポンス処理自体は [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) 側で行われるため、 このハンドラを本ハンドラの上位に配置する必要がある。 |

### ハンドラ処理フロー

**[往路処理]**
**1. (HTTPヘッダの設定と後続ハンドラへの処理委譲)**
HTTPリクエストヘッダ(**X-Requested-With**)を設定することで、後続処理において外部からのAPI呼び出しとして扱うようにする。
(これにより、HTTPレスポンスハンドラが、内部ステータスコードをそのままHTTPステータスコードとして応答する。)

引数をそのまま後続ハンドラに渡して処理を委譲し、その結果としてHTTPレスポンスオブジェクトを取得する。

**[復路処理]**
**2. (レスポンスボディ内容の確認)**
HTTPレスポンスオブジェクトにレスポンスボディとして出力する内容が設定されているかどうかを確認する。
以下の条件のいずれかが満たされていれば、 HTTPレスポンスオブジェクトを返却し、処理を終了する。

1. コンテンツパスが設定されている。
2. `HttpResponse#setInputStream()` により、レスポンスボディとして出力する内容が `InputStream` で与えられている。
3. `HttpResponse#write()` により、レスポンスボディとして出力する内容がHTTPレスポンスオブジェクト内にバッファリングされている。
**2a. (ステータスコード毎のデフォルトページを設定)**
HTTPレスポンスオブジェクトにレスポンスボディとして出力する内容が設定されていなかった場合は、
`HttpResponse#getStatusCode()` の値に合致するデフォルトページへのコンテンツパスを設定してリターンする。
デフォルトページは本ハンドラの設定で任意のコンテンツパスを指定することができる。
設定を行なっていない場合のデフォルトページは次のようになる。

| ステータスコード | コンテンツパス |
|---|---|
| 404 | servlet:///jsp/notFound.jsp |
| 401 | servlet:///jsp/unauthorized.jsp |
| 3.. (300～399のいずれか) | servlet:///jsp/redirecting.jsp |
| 4.. (400～499 ただし 401/404を除く) | servlet:///jsp/userError.jsp |
| 5.. (500～599のいずれか) | servlet:///jsp/systemError.jsp |

**[例外処理]**
**1.a (後続ハンドラ処理中のエラー)**
後続ハンドラ実行中に例外が送出された場合、その型に従って以下のように処理する。
なお、いずれの場合でも、送出された例外をリクエストコンテキストにキー名 **nablarch_error** で設定する。

| 捕捉した例外クラス | ログ出力 | 処理内容 |
|---|---|---|
| nablarch.fw.NoMoreHandlerException | Info | ハンドラキューが空の状態で、後続ハンドラに処理委譲を行なった場合に送出される。 ステータスコード404のデフォルトページを設定したHTTPレスポンスオブジェクトを返却する。 |
| nablarch.fw.web.HttpErrorResponse | なし | エラーレスポンス内容を指定し、エラー終了する際に送出するエラー。 この例外に指定されているHTTPレスポンスオブジェクトを返却する。 |
| nablarch.fw.Result.Error | なし | 例外オブジェクトのステータスコードに対応するデフォルトページを遷移先とする HTTPレスポンスオブジェクトを返却する。  > **Note:** > writeFailureLogPatternプロパティで指定された正規表現にマッチするステータスコードを > もつErrorオブジェクトの場合には、障害ログを出力する。 |
| java.lang.StackOverflowError | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスオブジェクトを返却する。 |
| java.lang.ThreadDeath | なし | 本ハンドラでは何もせずに捕捉した例外を再送出する。 (ログ出力は [グローバルエラーハンドラ](../../component/handlers/handlers-GlobalErrorHandler.md) で行われる。) |
| java.lang.VirtualMachineError (StackOverFlowErrorを除く) | なし | 本ハンドラでは何もせずに捕捉した例外を再送出する。 (ログ出力は [グローバルエラーハンドラ](../../component/handlers/handlers-GlobalErrorHandler.md) で行われる。) |
| (上記以外の実行時例外、エラー) | Fatal | ステータスコード500のデフォルトページを設定したHTTPレスポンスオブジェクトを返却する。 |

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| ステータスコード毎のデフォルト遷移先 | defaultPages | Map<String, String> | 任意指定 (デフォルト設定はハンドラ処理フロー参照) |
| Result.Error発生時の障害通知ログ出力対象のステータスコード | writeFailureLogPattern | String | 任意指定  指定する場合は、正規表現で指定する。 例えば、全てのステータスコードで障害通知ログを 出力する場合には、 *「.*」* と指定する。  設定を省略した場合は、500～599(503(サービス閉塞中) を除く)が、障害通知ログの出力対象となる。 |

**標準設定**
以下は標準設定におけるDI設定の例である。

```xml
<!-- HTTPメッセージングエラー制御ハンドラ -->
<component class="nablarch.fw.messaging.handler.HttpMessagingErrorHandler" />
```
**ステータスコード毎のデフォルト遷移先を設定する場合**
以下のように設定することで、デフォルトの遷移先を変更することができる。
対象となるステータスコードに **"."** を含めることで、ワイルドカード指定することができる。
ただし、1つのステータスコードに対して複数の遷移先がマッチする場合は、
ワイルドカードの使用桁がより少ない遷移先を優先する。

たとえば、以下の例では、ステータスコード404に対応するデフォルト遷移先は、
`"/USER_ERROR.jsp"` ではなく、 `"/NOT_FOUND.jsp"` となる。

```xml
<!-- HTTPメッセージングエラー制御ハンドラ -->
<component class="nablarch.fw.messaging.handler.HttpMessagingErrorHandler">
    <!-- ステータスコード毎のデフォルト遷移先JSPを設定する。-->
    <property name="defaultPages">
        <map>
        <entry key="4.." value="/USER_ERROR.jsp" />
        <entry key="404" value="/NOT_FOUND.jsp" />
        <entry key="5.." value="/ERROR.jsp" />
        <entry key="503" value="/NOT_IN_SERVICE.jsp" />
        </map>
    </property>
</component>
```
**Result.Error発生時に障害通知ログを出力するステータスコード値を変更する場合**
以下のように設定することで、障害通知ログを出力するステータスコード値を変更することができる。

```xml
<!-- HTTPメッセージングエラー制御ハンドラ -->
<component class="nablarch.fw.messaging.handler.HttpMessagingErrorHandler">
    <!-- 500～599のステータスコードは全て障害通知ログを出力する場合 -->
    <property name="writeFailureLogPattern" value="5[0-9][0-9]" />
</component>
```
