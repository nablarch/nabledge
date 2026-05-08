# ハンドラリファレンス

## 汎用のハンドラ

* [データリードハンドラ](../../component/handlers/handlers-DataReadHandler.md)
* [グローバルエラーハンドラ](../../component/handlers/handlers-GlobalErrorHandler.md)
* [出力ファイル開放ハンドラ](../../component/handlers/handlers-FileRecordWriterDisposeHandler.md)
* [リクエストディスパッチハンドラ](../../component/handlers/handlers-RequestPathJavaPackageMapping.md)
* [リクエストハンドラエントリ](../../component/handlers/handlers-RequestHandlerEntry.md)
* [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md)
* [スレッドコンテキスト変数削除ハンドラ](../../component/handlers/handlers-ThreadContextClearHandler.md)
* [データベース接続管理ハンドラ](../../component/handlers/handlers-DbConnectionManagementHandler.md)
* [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md)
* [認可制御ハンドラ](../../component/handlers/handlers-PermissionCheckHandler.md)
* [開閉局制御ハンドラ](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md)
* [セッション並行アクセスハンドラ](../../component/handlers/handlers-SessionConcurrentAccessHandler.md)
* [リトライ制御ハンドラ](../../component/handlers/handlers-RetryHandler.md)

## 画面オンライン処理用ハンドラ

* [Nablarchサーブレットコンテキスト初期化リスナ](../../component/handlers/handlers-NablarchServletContextListener.md)
* [Webフロントコントローラ (サーブレットフィルタ)](../../component/handlers/handlers-WebFrontController.md)
* [HTTP文字エンコード制御ハンドラ](../../component/handlers/handlers-HttpCharacterEncodingHandler.md)
* [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md)
* [HTTPエラー制御ハンドラ](../../component/handlers/handlers-HttpErrorHandler.md)
* [内部フォーワードハンドラ](../../component/handlers/handlers-ForwardingHandler.md)
* [リソースマッピングハンドラ](../../component/handlers/handlers-ResourceMapping.md)
* [Nablarchカスタムタグ制御ハンドラ](../../component/handlers/handlers-NablarchTagHandler.md)
* [HTTPアクセスログハンドラ](../../component/handlers/handlers-HttpAccessLogHandler.md)
* [マルチパートリクエストハンドラ](../../component/handlers/handlers-MultipartHandler.md)
* [HTTPリクエストディスパッチハンドラ](../../component/handlers/handlers-HttpRequestJavaPackageMapping.md)
* [HTTPリライトハンドラ](../../component/handlers/handlers-HttpRewriteHandler.md)
* [携帯端末アクセスハンドラ](../../component/handlers/handlers-KeitaiAccessHandler.md)
* [POST再送信防止ハンドラ](../../component/handlers/handlers-PostResubmitPreventHandler.md)

## バッチ処理用ハンドラ

* [共通起動ランチャ](../../component/handlers/handlers-Main.md)
* [ステータスコード→プロセス終了コード変換ハンドラ](../../component/handlers/handlers-StatusCodeConvertHandler.md)
* [プロセス停止制御ハンドラ](../../component/handlers/handlers-ProcessStopHandler.md)
* [プロセス多重起動防止ハンドラ](../../component/handlers/handlers-DuplicateProcessCheckHandler.md)
* [プロセス常駐化ハンドラ](../../component/handlers/handlers-ProcessResidentHandler.md)
* [トランザクションループ制御ハンドラ](../../component/handlers/handlers-LoopHandler.md)
* [マルチスレッド実行制御ハンドラ](../../component/handlers/handlers-MultiThreadExecutionHandler.md)

## メッセージング処理用ハンドラ

* [メッセージングコンテキスト管理ハンドラ](../../component/handlers/handlers-MessagingContextHandler.md)
* [再送電文制御ハンドラ](../../component/handlers/handlers-MessageResendHandler.md)
* [電文応答制御ハンドラ](../../component/handlers/handlers-MessageReplyHandler.md)
* [リクエストスレッド内ループ制御ハンドラ](../../component/handlers/handlers-RequestThreadLoopHandler.md)
* [HTTPメッセージングエラー制御ハンドラ](../../component/handlers/handlers-HttpMessagingErrorHandler.md)
* [HTTPメッセージングリクエスト変換ハンドラ](../../component/handlers/handlers-HttpMessagingRequestParsingHandler.md)
* [HTTPメッセージングレスポンス変換ハンドラ](../../component/handlers/handlers-HttpMessagingResponseBuildingHandler.md)

## 業務アクションハンドラ

* [画面オンライン処理用業務アクションハンドラ](../../component/handlers/handlers-HttpMethodBinding.md)
* [バッチ処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-BatchAction.md)
* [ファイル入力のバッチ業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-FileBatchAction.md)
* [入力データを使用しないバッチ処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-NoInputDataBatchAction.md)
* [同期応答電文送信処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-MessagingAction.md)
* [応答不要電文受信処理用アクションハンドラ](../../component/handlers/handlers-AsyncMessageReceiveAction.md)
* [応答不要電文送信処理用アクションハンドラ](../../component/handlers/handlers-AsyncMessageSendAction.md)
