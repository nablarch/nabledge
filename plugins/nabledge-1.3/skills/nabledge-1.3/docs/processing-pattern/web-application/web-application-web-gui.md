## 画面オンライン実行制御基盤

[画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) では、HTMLをベースとしたUIを伴う標準的なWebアプリケーションを実装するための実行制御基盤を提供する。
HTMLのテンプレートエンジンとしてJSPを採用しているため、Webコンテナ上での動作を前提とする。

この実行制御基盤では、HTTPリクエスト・レスポンスに関連した以下の処理を行う。

* 各HTTPリクエストに対して処理対象の業務機能を呼び出す処理。(ディスパッチ処理)
* 業務機能の結果を元に、HTTPリクエストに対するレスポンスを構成し送信する処理。(レスポンス処理)

レスポンス処理は、 [コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#業務アクションハンドラの実装内容) と呼ばれる業務アクション側で指定する文字列に従って行われる。
コンテンツパスが **servlet://** で開始される場合は、当該パスに対するサーブレットフォーワード処理を行なう。
**file://** もしくは **classpath://** の場合は、当該リソースを取得し、その内容をレスポンスする。

-----

-----

### 業務アクションハンドラの実装

[画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) における業務アクションハンドラの標準的な実装方法については、 [画面オンライン処理用業務アクションハンドラ](../../component/handlers/handlers-HttpMethodBinding.md) を参照すること。
また、必要に応じて、以下の各項を参照すること。

**レスポンス時にファイル等のダウンロードを行う場合**

* [ファイルダウンロード](../../component/libraries/libraries-05-FileDownload.md)

**ファイルアップロードを伴う業務処理を実装する場合**

* [ファイルアップロード](../../component/libraries/libraries-06-FileUpload.md)

### 標準ハンドラ構成と主要処理フロー

以下は、 [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) における主要な処理フローと標準ハンドラ構成である。

| 区分 | 種別 | 処理フロー名 | 概要 | 機能 |
|---|---|---|---|---|
| アプリケーション初期化 | 正常フロー | 正常起動 | アプリケーションデプロイ時に、 リポジトリ、ハンドラキュー等の初期化を 行う。 | フローを表示 |
| リクエストスレッド内 制御 | 正常フロー | 業務処理正常終了 | 業務処理が正常に完了し、 処理結果に応じた遷移先画面を表示する。 | フローを表示 |
|  | 代替フロー | ユーザエラー | 入力精査処理等で、利用者起因と思われる エラーが発生した場合は、 業務トランザクションをロールバックし、 エラー時の遷移先画面を表示する。 | フローを表示 |
|  | 異常フロー | システムエラー | 業務ロジック内で不具合等による エラーが発生した場合は、 業務トランザクションをロールバックし、 障害ログを出力した上で、 システムエラー画面に遷移する。 | フローを表示 |
|  | 正常フロー | 直接画面遷移 | 検索画面の初回表示のように、業務処理の無い 画面の単純表示や、静的なコンテンツへの アクセスでは、業務アクションを介さずに レスポンスを行う。 | フローを表示 |
|  | 代替フロー | 内部フォーワード | 遷移先の画面が単純な画面表示では無く、 業務アクションでの処理を伴う場合は、 遷移先JSPパスを指定するかわりに、 実行したいリクエストパスを指定する。 (内部フォーワード処理) | フローを表示 |
|  | 異常フロー | 認可エラー | リクエストされた機能に対して、 ログインユーザが権限を持っていなかった 場合は、エラー画面に遷移させる。 | フローを表示 |
|  | 異常フロー | 開閉局エラー | リクエストされた業務機能 が閉局中であった場合は、 エラー画面に遷移させる。 | フローを表示 |
|  | 代替フロー | アップロードファイル 容量超過 | アップロードされたファイルが 限界容量を超過した場合は、エラー画面に 遷移させる。 | フローを表示 |

**標準ハンドラ構成** (説明文をクリックすると、その処理のステップレベルでの詳細が表示されます。)

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| Nablarchサーブレットコンテキスト初期化リスナ | nablarch.fw.web.servlet.NablarchServletContextListener | - | - | サーブレットコンテキスト初期化時に、リポジトリおよびハンドラキューの初期化処理を行う。 | - | Fatalログを出力した上で再送出する。(デプロイエラーになる。) | - |
| Webフロントコントローラ (サーブレットフィルタ) | nablarch.fw.web.servlet.WebFrontController | ServletRequest/Response | - | HttpServletRequest/HttpServletResponseからHTTPリクエストオブジェクトを作成し、ハンドラキューに処理を委譲する。 | (Webコンテナ側に制御を戻す。) | このハンドラでは例外およびエラーの捕捉は行なわず、そのまま送出する。 | - |
| スレッドコンテキスト変数削除ハンドラ | nablarch.common.handler.threadcontext.ThreadContextClearHandler | Object | Object | - | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | ThreadContextHandlerで設定したスレッドローカル上の変数を削除する | - |
| グローバルエラーハンドラ | nablarch.fw.handler.GlobalErrorHandler | Object | Result | - | - | 全ての実行時例外・エラーを捕捉し、ログ出力を行う | - |
| HTTP文字エンコード制御ハンドラ | nablarch.fw.web.handler.HttpCharacterEncodingHandler | Object | Object | HttpServletRequestおよびHttpServletResponseに対し文字エンコーディングを設定する。 | - | - | - |
| 出力ファイル開放ハンドラ | nablarch.common.handler.FileRecordWriterDisposeHandler | Object | Object | - | 業務アクションハンドラで書き込みを行うために開いた全ての出力ファイルを開放する | - | - |
| セッション並行アクセスハンドラ | nablarch.fw.handler.SessionConcurrentAccessHandler | Object | Object | ハンドラに設定された同期ポリシーを実装したラッパーをセッションスコープに適用し、スコープ上の各変数に対する同期アクセス制御を開始する。 | 同期アクセス制御を停止する。 | 同期アクセス制御を停止する。 | - |
| HTTPレスポンスハンドラ | nablarch.fw.web.handler.HttpResponseHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容に沿ってレスポンス処理かサーブレットフォーワードのいずれかを行う。 | 既定のエラー画面をレスポンス後、例外を再送出する。ただしサーブレットフォーワード処理中にエラーが発生した場合はログ出力のみを行なう。 | - |
| スレッドコンテキスト変数設定ハンドラ(リクエストスレッド) | nablarch.common.handler.ThreadContextHandler_request | Object | Object | 前のループで設定されたスレッドコンテキスト変数をクリアするためここで再初期化する。 | - | - | - |
| HTTPアクセスログハンドラ | nablarch.fw.web.handler.HttpAccessLogHandler | HttpRequest | HttpResponse | HTTPリクエストの内容についてログに出力する。 | 送信するHTTPレスポンスの内容についてログに出力する。 | 送信するHTTPレスポンスの内容についてログに出力する。 | - |
| 内部フォーワードハンドラ | nablarch.fw.web.handler.ForwardingHandler | HttpRequest | HttpResponse | - | 遷移先に内部フォーワードパスが指定されていた場合、HTTPリクエストオブジェクトのリクエストURIを内部フォーワードパスに書き換えた後、後続のハンドラを再実行する。 | - | - |
| HTTPエラー制御ハンドラ | nablarch.fw.web.handler.HttpErrorHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容が設定されていない場合は、ステータスコードに応じたデフォルトページを遷移先に設定する。 | 送出されたエラーに応じた遷移先のHTTPレスポンスオブジェクトを返却する。送出されたエラーはリクエストスコープに設定される。 | - |
| マルチパートリクエストハンドラ | nablarch.fw.web.upload.MultipartHandler | HttpRequest | HttpResponse | HTTPリクエストボディがマルチパート形式であった場合にその内容を解析し、一時ファイルに保存する。 | アップロードされた一時ファイルを全て削除する。 | アップロードされた一時ファイルを全て削除する。 | - |
| Nablarchカスタムタグ制御ハンドラ | nablarch.common.web.handler.NablarchTagHandler | HttpRequest | HttpResponse | Nablarchカスタムタグの動作に必要な事前処理を実施する。 | - | - | - |
| データベース接続管理ハンドラ | nablarch.common.handler.DbConnectionManagementHandler | Object | Object | 業務処理用ＤＢ接続を取得し、スレッドローカル上に保持する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | - |
| トランザクション制御ハンドラ | nablarch.fw.common.handler.TransactionManagementHandler | Object | Object | 業務トランザクションの開始 | トランザクションをコミットする。 | トランザクションをロールバックする。 | 1.コミット完了後 / 2.ロールバック後 |
| 開閉局制御ハンドラ | nablarch.fw.common.handler.ServiceAvailabilityCheckHandler | Request | Result | リクエストＩＤ単位での開閉局制御を行う | - | - | - |
| 認可制御ハンドラ | nablarch.fw.common.handler.PermissionCheckHandler | Object | Object | スレッドコンテキスト上の userId/requestId をもとに認可判定を行う。認可判定に失敗した場合は例外を送出して終了する。成功した場合は、認可情報オブジェクトをスレッドローカルに設定する。 | - | - | - |
| リソースマッピングハンドラ | nablarch.fw.web.handler.ResourceMapping | HttpRequest | HttpResponse | リクエストURIを、クラスパス上のリソースパスもしくはサーブレットフォーワードパスにマッピングすることで、業務アクションを実行することなくHTTPレスポンスオブジェクトを作成して返却する。 | - | - | - |
| HTTPリクエストパスによるディスパッチハンドラ | nablarch.fw.handler.HttpRequestJavaPackageMapping | HttpRequest | Object | HTTPリクエストパスをもとに業務アクションを決定しハンドラキューに追加する。HTTPメソッドによるメソッド単位のディスパッチを行う。(HttpMethodBinding) | - | - | - |
| 画面オンライン処理業務アクション | nablarch.fw.action.HttpMethodBinding | HttpRequest | HttpResponse | HTTPリクエストの内容をもとに業務処理を実行する | 遷移先画面に表示する内容をリクエストコンテキストに設定した上で、遷移先パスを設定したHTTPレスポンスオブジェクトを返却する。 | - | - |

../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload
../02_FunctionDemandSpecifications/02_Fw/01_Web/06_FileUpload
