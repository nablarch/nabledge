

![handler_structure_bg.png](../../../knowledge/assets/handlers-HttpMethodBinding/handler_structure_bg.png)

![handler_bg.png](../../../knowledge/assets/handlers-HttpMethodBinding/handler_bg.png)

## 画面オンライン処理用業務アクションハンドラ

**クラス名:** `nablarch.fw.web.HttpMethodBinding`

-----

### 概要

本稿では、 [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) における、標準的な業務アクションハンドラの実装方法について述べる。

また、必要に応じて、以下の各項を参照すること。

**レスポンス時にファイル等のダウンロードを行う場合**
* [ファイルダウンロード](../../component/libraries/libraries-05-FileDownload.md)
**ファイルアップロードを伴う業務処理を実装する場合**
* [ファイルアップロード業務処理用ユーティリティ](../../component/libraries/libraries-file-upload-utility.md)

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

<script>
var Context      = 'handler sub_thread data_read'
  , HandlerQueue = [
      "HttpResponseHandler"
    , "HttpErrorHandler"
    , "TransactionManagementHandler"
    , "HttpMethodBinding"
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
| [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) | 業務アクションが返却もしくは送出したHTTPレスポンスオブジェクトをもとに レスポンス処理を行う。 |
| [HTTPエラー制御ハンドラ](../../component/handlers/handlers-HttpErrorHandler.md) | 業務アクションが送出した実行時例外は、ここで捕捉され、 対応するエラー遷移先を表すHTTPレスポンスオブジェクトに変換される。 |
| [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) | 業務アクションが実行時例外を送出することで、業務トランザクションをロールバックする。 |

### 業務アクションハンドラの実装内容

次のコードは、ログイン処理を行う業務アクションハンドラの例である。
以下では、このソースコードに沿って解説する。

```java
public class LoginAction  {

    // ①  ビジネスメソッドのディスパッチ
    public HttpResponse getLoginHtml(HttpRequest request, ExecutionContext context) {
        // ②  ビジネスロジックの実行とHTTPレスポンスオブジェクトの返却
        context.invalidateSession();
        return new HttpResponse("./login.jsp");
    }

    public HttpResponse doLogin(HttpRequest request, ExecutionContext context) {
        try {
            authenticate(request, context);
            return new HttpResponse("forward:///app/MainMenu");

        // ③  例外制御
        } catch(AuthenticationFailedException e) {
            throw new HttpErrorResponse(403, "forward://login.html", e);
        }
    }
}
```

**①  ビジネスメソッドのディスパッチ**
[画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) の業務アクションハンドラでは
[Handler](../../javadoc/nablarch/fw/Handler.html) インターフェースを実装する必要は無く、HTTPリクエストの内容に従い、動的にメソッドが呼び分けられる。

1. メソッドの戻り値の型がHttpResponseかつ、引数を2つもち、
  それぞれの型がHttpRequest、ExecutionContextであること。
2. メソッドの名前が次の文字列に一致する。:

  ```
  (リクエストのHTTPメソッド名 もしくは "do") + (リクエストURIのリソース名)
  ```

ただし、一致判定は以下の条件のもとで行われる。

* メソッド名の大文字小文字は区別しない。
* リクエストURIのリソース名に含まれる"."は無視される。
* 委譲先クラスのメソッド名に含まれる"_"は無視される。

**例**

| HTTPリクエスト | 委譲対象となるメソッドシグニチャの例 |
|---|---|
| GET /app/index.html | HttpResponse getIndexHtml  (HttpRequest, ExecutionContext); HttpResponse getIndexhtml  (HttpRequest, ExecutionContext); HttpResponse get_index_html(HttpRequest, ExecutionContext); HttpResponse do_index_html (HttpRequest, ExecutionContext); HttpResponse doIndexHtml   (HttpRequest, ExecutionContext); |
| POST /app/message | HttpResponse postMessage(HttpRequest, ExecutionContext); HttpResponse doMessage  (HttpRequest, ExecutionContext); HttpResponse do_message (HttpRequest, ExecutionContext); |

これらの条件に該当するメソッドが存在しなかった場合は
ステータスコード404の [HttpErrorResponse](../../javadoc/nablarch/fw/web/HttpErrorResponse.html) が送出される。
**②  ビジネスロジックの実行とHTTPレスポンスオブジェクトの返却**
呼び出された各メソッドでは、おおまかに以下のような処理を行う。

1. ビジネスロジックを実行する。
2. JSP側などの後続処理で参照する情報を、各種スコープに設定する。
3. 遷移先を指定するコンテンツパスが設定された [HttpResponse](../../javadoc/nablarch/fw/web/HttpResponse.html) オブジェクトを返却。

クライアントに送信するレスポンスボディの内容を指定する方法は大きく2つある。

1つめは、 [HttpResponse](../../javadoc/nablarch/fw/web/HttpResponse.html) オブジェクトに直接レスポンスボディの内容を設定する方法であり、
主に [ファイルダウンロード](../../component/libraries/libraries-05-FileDownload.md) 処理で使用する。

もう1つは、 [コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) と呼ばれる文字列によってレスポンス内容を指定する方法であり、
通常の業務機能の実装ではこちらを主に使用する。

**コンテンツパス**

コンテンツパスとは、クライアントにレスポンスする内容を指定するために、 [HttpResponse](../../javadoc/nablarch/fw/web/HttpResponse.html) オブジェクトに設定する文字列であり、
以下のリソースをレスポンスの対象とすることができる。

* サーブレットフォーワードパス
* 内部フォーワードパス
* HTTPリダイレクション
* ファイルシステム上のリソース
* Javaクラスパス上のリソース

**コンテンツパスの書式**

**1. サーブレットフォーワード**
指定されたパスに対するサーブレットフォーワードを行う。
クライアントに対するレスポンス処理はフォーワード先のサーブレットで行われる。
主に、業務処理実行後のJSP画面の表示の際に使用する。

**(書式)**
**servlet://(フォーワードパス)**

* 相対パス指定の場合: 現在のリクエストURIを起点とするパス。
* 絶対パス指定の場合: サーブレットコンテキストを起点とするパス。

```bash
servlet://index.jsp                  # 相対パス指定
servlet:///appContext/jsp/index.jsp  # 絶対パス指定
```

> **Note:**
> サーブレットフォーワードでは、指定されたサーブレットを実行するのみであり、ハンドラキュー上の処理は再実行しない。
> これは、 [Webフロントコントローラ (サーブレットフィルタ)](../../component/handlers/handlers-WebFrontController.md) が全リクエストを対象としたサーブレットフィルタとして実装されており、
> サーブレットフォーワードで再度処理した場合、無限ループしてしまうためである。

> ハンドラキューの内容も含めたフォワード処理が必要な場合は、 [内部フォーワードハンドラ](../../component/handlers/handlers-ForwardingHandler.md) による
> 内部フォーワードを使用すること。
**2. 内部フォーワード**
指定されたリクエストパスを使用して、ハンドラキューの処理を再実行する。
遷移先の画面が単純な画面表示では無く、業務アクションでの処理を伴う場合などに用いられる。

**(書式)**
**forward://(フォーワード先リクエストパス)**

* 相対パス指定の場合: 現在のリクエストURIを起点とするパス。
* 絶対パス指定の場合: サーブレットコンテキスト名を起点とするパス。

```bash
# 現在のリクエストURIが "/app/user/success.html" とすると、以下はどちらも等価な表現となる。
forward://registerForm.html            # 相対パス指定
forward:///app/user/registerForm.html  # 絶対パス指定
```

> **Note:**
> 内部フォーワード処理の詳細は [内部フォーワードハンドラ](../../component/handlers/handlers-ForwardingHandler.md) を参照すること。
**3. HTTPリダイレクション**
クライアントに対して指定されたパスへのリダイレクションを指示するレスポンスを行う。

スキーム名を **redirect://** とした場合はサーブレットコンテキスト配下に対するリダイレクションを行う。
特に、絶対パス指定はサーブレットコンテキストルートからの相対パスとみなされる。

スキーム名を **http://** とした場合は、サーブレットコンテキスト外へのリダイレクションが可能であり、
ホスト名を含めた完全なURLを指定することができる。

**(書式)**
**redirect://(リダイレクト先パス)**

**http(s)://(リダイレクト先URL)**

```bash
redirect://login               # 現在のページからの相対パス
redirect:///UserAction/login   # サーブレットコンテキストを起点とする相対パス
http://www.example.com/login   # 外部サイトのURL
```
**4. ファイルシステム上のリソース**
ファイルシステム上の静的ファイルの内容を出力する。

**(書式)**
**file://(ファイルシステムパス)**

* 相対パス指定の場合: JVMプロセスのワーキングディレクトリが起点とするパス。
* 絶対パス指定の場合: ファイルシステムのルートディレクトリが起点とするパス。

```bash
file://webapps/style/common.css       #相対パス指定
file:///www/docroot/style/common.css  #絶対パス指定
```
**5. Javaコンテキストクラスローダ上のリソース**
コンテキストクラスローダ上のリソースの内容を出力する。

**(書式)**
**classpath://(Javaリソース名)**

Javaリソース名の完全修飾名を"/"区切りで指定する。
相対パスと絶対パスの区別は無くどちらを使用しても同じ結果となる。

```bash
# 以下はどちらも等価な表現となる。
classpath://nablarch/sample/webapp/common.css
classpath:///nablarch/sample/webapp/common.css
```

**③  例外制御**
先に述べたように、HttpErrorResponse 以外の実行時例外が送出された場合、
デフォルトではHTTPステータス500のレスポンスが返る。

それ以外の応答を行うためには、リクエストハンドラ内で明示的に例外を捕捉したうえで
HttpResposeオブジェクトを生成して正常終了させるか、もしくは
HttpErrorResponseでラップして再送出する必要がある。

以下の例では、ユーザ入力値の不正による業務例外(ApplicationException)が発生した場合に
HttpErrorResponseを送出し入力画面へ内部フォーワードしている。

```java
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
    try {
        UserForm form = validateUser(req);
        registerUser(form);
        return new HttpResponse(200, "servlet://registrationCompleted.jsp");

    } catch(ApplicationException ae) {
        throw new HttpErrorResponse(400, "forward://registerForm.html", ae);
    }
}
```

この例外制御は本フレームワークが提供する @OnError アノテーション
を使用することで次のように簡略化することができる。

```java
@OnError(
    type = ApplicationException.class
  , path ="forward://registerForm.html"
)
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
    UserForm form = validateUser(req);
    registerUser(form);
    return new HttpResponse(200, "servlet://registrationCompleted.jsp");
}
```

さらに、複数の @OnError アノテーションを指定したい場合は、本フレームワークが提供する
@OnErrors アノテーションを使用することで次のように簡略化することができる。

```java
// 複数のOnErrorは配列で指定するため、"{}"の記述が必要となる。
@OnErrors({
    @OnError(type = OptimisticLockException.class, path ="forward://searchForm.html"),
    @OnError(type = ApplicationException.class, path ="forward://updatingForm.html")
})
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
    UserForm form = validateUser(req);
    updateUser(form);
    return new HttpResponse(200, "servlet://updatingCompleted.jsp");
}
```

@OnErrors アノテーションは、 @OnError アノテーションの定義順(上から順)に例外を処理する。
たとえば、上記の例では、OptimisticLockExceptionはApplicationExceptionのサブクラスなので、
必ずApplicationExceptionの上に定義しなければ正常に処理が行われない。

```java
// 【誤った実装例】
// 下記の定義順では、OptimisticLockExceptionが送出された場合にも
// ApplicationExceptionに対する例外処理が行われる。
@OnErrors ({
    @OnError (type = ApplicationException.class, path ="servlet://updatingForm.jsp"),
    @OnError (type = OptimisticLockException.class, path ="servlet://searchForm.jsp")
})
```

**インターセプタの実行順**
インターセプタの実行順は、設定ファイルに定義した順となる。
設定ファイルには、 `list` コンポーネントとしてアノテーションのFQCNを実行順に定義する。
`list` コンポーネントの名前は、 `interceptorsOrder` として定義する。

以下の例では、`OnDoubleSubmission` -> `OnErrors` -> `OnError` の順にインターセプタが実行される。
ハンドラメソッドに `OnDoubleSubmission` と `OnError` が定義されている場合は、 `OnDoubleSubmission` -> `OnError` の順にインターセプタが実行される。

```xml
<list name="interceptorsOrder">
  <value>nablarch.common.web.token.OnDoubleSubmission</value>
  <value>nablarch.fw.web.interceptor.OnErrors</value>
  <value>nablarch.fw.web.interceptor.OnError</value>
</list>
```

設定ファイルに未定義のインターセプタが利用された場合には、実行時例外を送出する。

設定ファイル上にインターセプタの実行順を示す `list` コンポーネントが定義されていない場合は、
`Method#getDeclaredAnnotations` が返すリストの逆順でインターセプタを実行する。
`Method#getDeclaredAnnotations` が返すアノテーションリストの順序は保証されていなため、
実行環境(jvmのバージョンなど)によって、インターセプタの実行順が変わる可能性がある点に注意すること。

-----

### 画面オンライン処理における変数スコープの利用

画面オンライン処理方式では、リクエストスコープ、セッションスコープに加えて、
各画面内に自動的に出力されるhidden項目によって実装される *ウィンドウスコープ* が定義されている。

ウィンドウスコープにはウィンドウやタブごとに個別の変数を保持することができる。
ここに業務データを保持することで、ウィンドウ毎に個別の状態を維持することができ、
複数ウィンドウから並行操作を行っても、矛盾なく業務処理を遂行することが可能となる。

各変数スコープの用途と使用方法について解説する。
次の表と模式図は、画面オンライン処理方式における各スコープの特徴と用途をまとめたものである。

| スコープ名称 | 用途 | 作成単位 | 維持期間 |
|---|---|---|---|
| リクエストスコープ | 単一のHTTPリクエスト内でのみ使用するデータ (=画面間で共有する必要の無いデータ)を保持する。 | HTTPリクエストごと | HTTPリクエストの開始から終了まで。 |
| ウィンドウスコープ | 画面間で共有するデータのうち、 ウィンドウ間で共有する必要の無いデータを保持する。 | ブラウザのウィンドウ、 タブ、フレームごと | ウィンドウを開いてから閉じるまで。 もしくはセッションスコープが終了するまで。 |
| セッションスコープ | 画面間で共有するデータのうち、 ウィンドウ間で共有する必要の有るデータを保持する。 | ユーザのログインごと | ユーザログインからログアウトまで。 もしくはセッションタイムアウトまで |

![web_scope.png](../../../knowledge/assets/handlers-HttpMethodBinding/web_scope.png)

以下では画面オンライン処理方式における各スコープの詳細について述べる。

-----

**リクエストスコープ**
3つの変数スコープのうちで最も維持期間が短い。
各HTTPリクエストごとに作成され、レスポンス処理が完了するまで維持される。
単一のリクエスト間で完結し、次画面以降に引き継ぐ必要の無いデータはここに保存する。

画面オンライン処理方式におけるリクエストスコープは基本的にServletAPIの
HTTPServletRequest#getAttribute()/setAttribute()メソッドのラッパーである。

**リクエストスコープに保持するデータ**
* 画面に表示するデータオブジェクト（次画面以降に引き継がないもの）
* バリデーションエラー等のメッセージ
* JSP側で表示用に使用するフラグ

-----

**ウィンドウスコープ**
ウィンドウスコープは、ブラウザのウィンドウ、タブ、フレームごとに作成される。
(以降この節では、これらをまとめて単に"ウィンドウ"と表現する。)
ウィンドウスコープは、各ウィンドウが閉じられるか、セッションが終了するまで維持される。

例えば、ログインユーザIDや、ショッピングカート内の商品一覧などの
ウィンドウ間で同一の値を共有しなければならない一部のデータを除けば、
画面遷移を跨って使用する必要があるデータは、全てウィンドウスコープ上に保持する。

これにより、アプリケーション側で特段の考慮をしなくとも
複数のウィンドウを用いた並行操作や、ブラウザのヒストリバックによる遷移が可能となる。

**ウィンドウスコープに保持するデータ**
* 画面の入力項目(入力項目復帰が必要なもの)
* 他業務画面からの引き継ぎデータ
* 画面遷移履歴情報
* 楽観ロック用バージョン番号 [1]
**使用方法**
ウィンドウスコープ変数は hidden属性のinputタグとして各ウィンドウの画面内に維持される。
従って、ウィンドウスコープ上の変数は通常のリクエストパラメータと同等に扱われる。
ウィンドウスコープ変数を含めたリクエストパラメータにアクセスするには
[入力値のバリデーション](../../component/libraries/libraries-core-library-validation.md#validation) 機能のAPIを使用する。

リクエストパラメータはフレームワークによって自動的にhiddenタグとして画面に出力される。
従って、ウィンドウスコープに変数を追加するには、HttpRequestクラスに定義されているsetParam()メソッドを使用する。

```java
public class HttpRequest extends Request {
    /**
     * リクエストパラメータを設定する。
     */
    @Published
    public HttpRequest setParam(String name, String... params);
}
```
**セキュリティ上の考慮**
フレームワークが出力したhiddenタグの値はフレームワークによって
リクエストURIおよびname属性のハッシュ値とともに暗号化される。
暗号化処理に使用する共通鍵はユーザログイン時に作成しメモリ上に保持される。
この鍵はログアウトもしくはセッションタイムアウトの時点で廃棄されるので、
極めて安全性が高い。

あるデータに対する複数ユーザからの変更に対して、
複数のリクエスト(画面)を跨いだトランザクションを実装する場合に使用する制御情報のこと。

-----

**セッションスコープ**
ログインユーザごとに作成されるスコープであり、
本フレームワークでは複数のウィンドウで共有されるデータを保持する目的で使用する。
ユーザがログインした時点で作成され、ログアウトもしくはセッションタイムアウトが発生するまで維持される。

セッションスコープ上のデータは複数のウィンドウから同時にアクセスされる可能性があり、
適切に同期化しなければならない。

**セッションスコープに保持するデータ**
* ログインユーザに紐づくデータ（ログインユーザID、認証・認可情報）
* ウィンドウ間で同一のデータを参照・更新する必要があるデータ（ショッピングカート内の商品情報など）
**セッションスコープの実装方式**
セッションスコープの実装方式には、HTTPSessionオブジェクトを使用するものと、
データベースを使用した独自実装の2通りの方式が存在する。
この選択は、アプリケーションサーバのスケーリング方式に大きく影響する。

HTTPSessionオブジェクトを使用する場合、同じログインユーザからのリクエストを
セッションスコープが存在するサーバインスタンスに必ず振り分けるようにするか、
(セッションアフィニティ方式)
サーバクラスタ内の全てのサーバインスタンスでセッションスコープを同期する必要がある。
(セッションパーシステント方式)

データベースを使用した独自実装を使用した場合、アプリケーションサーバについては
ほぼ制約無くスケールアップさせることができるが、データベースへの負荷は増加する。

> **Note:**
> データベースを使用したHTTPセッション実装は現時点では提供されていない。
