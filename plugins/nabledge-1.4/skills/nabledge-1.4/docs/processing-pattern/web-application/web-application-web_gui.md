# 画面オンライン実行制御基盤

**公式ドキュメント**: [画面オンライン実行制御基盤]()

## 概要

[web_gui](web-application-web_gui.md) はJSPをテンプレートエンジンとして採用したHTMLベースUIを伴うWebアプリケーション向け実行制御基盤。Webコンテナ上での動作を前提とする。

## 主な処理

- **ディスパッチ処理**: 各HTTPリクエストに対して処理対象の業務機能を呼び出す
- **レスポンス処理**: 業務機能の結果を元にHTTPレスポンスを構成・送信する

## コンテンツパス

業務アクション側で指定するレスポンス先文字列。プレフィックスによる動作の違い:

| プレフィックス | 動作 |
|---|---|
| `servlet://` | 当該パスに対するサーブレットフォーワード処理 |
| `file://` または `classpath://` | 当該リソースを取得してその内容をレスポンス |

<details>
<summary>keywords</summary>

ディスパッチ処理, レスポンス処理, コンテンツパス, servlet://, classpath://, file://, 画面オンライン実行制御基盤, Webアプリケーション

</details>

## 業務アクションハンドラの実装

[web_gui](web-application-web_gui.md) における業務アクションハンドラの標準的な実装方法は [../handler/HttpMethodBinding](../../component/handlers/handlers-HttpMethodBinding.md) を参照。

## 関連機能

- **ファイルダウンロード**: [../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload](../../component/libraries/libraries-05_FileDownload.md)
- **ファイルアップロード**: [../02_FunctionDemandSpecifications/02_Fw/01_Web/06_FileUpload](../../component/libraries/libraries-06_FileUpload.md)
- **UserAgent情報取得**: [../02_FunctionDemandSpecifications/02_Fw/01_Web/07_UserAgent](../../component/libraries/libraries-07_UserAgent.md)

<details>
<summary>keywords</summary>

HttpMethodBinding, 業務アクションハンドラ, ファイルダウンロード, ファイルアップロード, UserAgent

</details>

## セクション区切り

なし

<details>
<summary>keywords</summary>

画面オンライン実行制御基盤, ハンドラ構成, Webアプリケーション

</details>

## 標準ハンドラ構成と主要処理フロー

## 処理フロー一覧

| 区分 | 種別 | 処理フロー名 | 概要 |
|---|---|---|---|
| アプリケーション初期化 | 正常フロー | 正常起動 | アプリケーションデプロイ時にリポジトリ、ハンドラキュー等を初期化する |
| リクエストスレッド内制御 | 正常フロー | 業務処理正常終了 | 業務処理が正常に完了し、処理結果に応じた遷移先画面を表示する |
| リクエストスレッド内制御 | 代替フロー | ユーザエラー | 利用者起因のエラー発生時、業務トランザクションをロールバックしエラー時遷移先画面を表示する |
| リクエストスレッド内制御 | 異常フロー | システムエラー | 業務ロジック内エラー発生時、業務トランザクションをロールバックし障害ログを出力してシステムエラー画面に遷移する |
| リクエストスレッド内制御 | 正常フロー | 直接画面遷移 | 業務アクションを介さずに検索画面の初回表示や静的コンテンツへのアクセスに応答する |
| リクエストスレッド内制御 | 代替フロー | 内部フォーワード | 遷移先が業務アクションでの処理を伴う場合、遷移先JSPパスの代わりに実行したいリクエストパスを指定する |
| リクエストスレッド内制御 | 異常フロー | 認可エラー | ログインユーザが権限を持っていない場合エラー画面に遷移する |
| リクエストスレッド内制御 | 異常フロー | 開閉局エラー | リクエストされた業務機能が閉局中の場合エラー画面に遷移する |
| リクエストスレッド内制御 | 代替フロー | アップロードファイル容量超過 | アップロードファイルが限界容量を超過した場合エラー画面に遷移する |

## 標準ハンドラキュー

NablarchServletContextListener, WebFrontController, ThreadContextClearHandler, GlobalErrorHandler, HttpCharacterEncodingHandler, FileRecordWriterDisposeHandler, SessionConcurrentAccessHandler, HttpResponseHandler, ThreadContextHandler_request, HttpAccessLogHandler, ForwardingHandler, HttpErrorHandler, MultipartHandler, NablarchTagHandler, DbConnectionManagementHandler, TransactionManagementHandler, ServiceAvailabilityCheckHandler, PermissionCheckHandler, ResourceMapping, HttpRequestJavaPackageMapping, HttpMethodBinding

## 各処理フローのステップ

### 正常起動

1. NablarchServletContextListener (往路)
2. WebFrontController (往路) — 全リクエストを対象とするサーブレットフィルタとしてデプロイされる

### 業務処理正常終了

1. WebFrontController (往路)
2. SessionConcurrentAccessHandler (往路)
3. ThreadContextHandler_request (往路)
4. HttpAccessLogHandler (往路)
5. NablarchTagHandler (往路)
6. DbConnectionManagementHandler (往路)
7. TransactionManagementHandler (往路)
8. HttpRequestJavaPackageMapping (往路)
9. HttpMethodBinding (往路)
10. HttpMethodBinding (復路)
11. TransactionManagementHandler (復路)
12. DbConnectionManagementHandler (復路)
13. HttpAccessLogHandler (復路)
14. HttpResponseHandler (復路) — デフォルトステータスコード:200
15. SessionConcurrentAccessHandler (復路)
16. WebFrontController (復路)

### ユーザエラー

1. WebFrontController (往路)
2. SessionConcurrentAccessHandler (往路)
3. ThreadContextHandler_request (往路)
4. HttpAccessLogHandler (往路)
5. NablarchTagHandler (往路)
6. DbConnectionManagementHandler (往路)
7. TransactionManagementHandler (往路)
8. HttpRequestJavaPackageMapping (往路)
9. HttpMethodBinding (往路)
10. HttpMethodBinding (例外) — 業務精査エラー等のユーザエラー発生時、エラー時遷移先を指定したHTTPエラーレスポンスオブジェクトを送出する
11. TransactionManagementHandler (例外)
12. DbConnectionManagementHandler (例外)
13. HttpErrorHandler (例外)
14. HttpAccessLogHandler (復路)
15. HttpResponseHandler (復路) — HttpErrorResponseに指定されたパスを用いてレスポンス処理。デフォルトステータスコード:400
16. SessionConcurrentAccessHandler (復路)
17. WebFrontController (復路)

### システムエラー

1. WebFrontController (往路)
2. SessionConcurrentAccessHandler (往路)
3. ThreadContextHandler_request (往路)
4. HttpAccessLogHandler (往路)
5. NablarchTagHandler (往路)
6. DbConnectionManagementHandler (往路)
7. TransactionManagementHandler (往路)
8. HttpRequestJavaPackageMapping (往路)
9. HttpMethodBinding (往路) — NullPointerException等の実行時例外が送出された場合
10. TransactionManagementHandler (例外)
11. DbConnectionManagementHandler (例外)
12. HttpErrorHandler (例外) — 一般の実行時例外を捕捉した場合は障害ログが出力される
13. HttpAccessLogHandler (復路)
14. HttpResponseHandler (復路) — システムエラー画面に遷移。デフォルトステータスコード:500
15. SessionConcurrentAccessHandler (復路)
16. WebFrontController (復路)

### 直接画面遷移

1. WebFrontController (往路)
2. SessionConcurrentAccessHandler (往路)
3. ThreadContextHandler_request (往路)
4. HttpAccessLogHandler (往路)
5. ResourceMapping (往路) — "//*.jsp"、"/static/image/*.png" などリクエストパスのパターンによって処理対象を絞る
6. HttpAccessLogHandler (復路)
7. HttpResponseHandler (復路)
8. SessionConcurrentAccessHandler (復路)
9. WebFrontController (復路)

### 内部フォーワード

1. WebFrontController (往路)
2. SessionConcurrentAccessHandler (往路)
3. ThreadContextHandler_request (往路)
4. HttpAccessLogHandler (往路)
5. NablarchTagHandler (往路)
6. DbConnectionManagementHandler (往路)
7. TransactionManagementHandler (往路)
8. HttpRequestJavaPackageMapping (往路)
9. HttpMethodBinding (往路)
10. HttpMethodBinding (復路) — レスポンスオブジェクトのコンテンツパスを "forward://(再実行したいリクエストパス)" のように指定する
11. TransactionManagementHandler (復路)
12. DbConnectionManagementHandler (復路)
13. ForwardingHandler (復路) — レスポンス、アクセスログの出力はフォーワード先で行われる

### アップロードファイル容量超過

1. WebFrontController (往路)
2. MultipartHandler (往路) — 各パートのデータサイズの合計が上限を越えた場合、実行時例外(ステータスコード:400)を送出する
3. HttpErrorHandler (例外)
4. HttpResponseHandler (復路)
5. WebFrontController (復路)

<details>
<summary>keywords</summary>

NablarchServletContextListener, WebFrontController, HttpMethodBinding, TransactionManagementHandler, DbConnectionManagementHandler, HttpResponseHandler, MultipartHandler, HttpErrorHandler, ForwardingHandler, ResourceMapping, SessionConcurrentAccessHandler, 標準ハンドラ構成, 処理フロー, ユーザエラー, システムエラー, 内部フォーワード, 直接画面遷移, 認可エラー, 開閉局エラー, アップロードファイル容量超過, 正常起動

</details>
