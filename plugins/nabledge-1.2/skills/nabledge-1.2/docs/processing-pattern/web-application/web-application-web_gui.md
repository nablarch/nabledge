# 画面オンライン実行制御基盤

## 業務アクションハンドラの実装

**前提条件**: HTMLのテンプレートエンジンとしてJSPを採用しているため、**Webコンテナ上での動作を前提とする**。

この実行制御基盤では、HTTPリクエスト・レスポンスに関連した以下の2つの処理を行う:
- **ディスパッチ処理**: 各HTTPリクエストに対して処理対象の業務機能を呼び出す処理
- **レスポンス処理**: 業務機能の結果を元に、HTTPリクエストに対するレスポンスを構成し送信する処理

**コンテンツパス**のプレフィックスによってレスポンス処理が決まる:
- `servlet://` → サーブレットフォワード処理
- `file://` または `classpath://` → リソース取得してレスポンス

業務アクションハンドラの標準実装: [../handler/HttpMethodBinding](../../component/handlers/handlers-HttpMethodBinding.md) を参照。

| ケース | 参照先 |
|---|---|
| ファイルダウンロード | [../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload](../../component/libraries/libraries-05_FileDownload.md) |
| ファイルアップロード | [../02_FunctionDemandSpecifications/02_Fw/01_Web/06_FileUpload](../../component/libraries/libraries-06_FileUpload.md) |

<details>
<summary>keywords</summary>

コンテンツパス, servlet://, file://, classpath://, HttpMethodBinding, ファイルダウンロード, ファイルアップロード, 業務アクションハンドラ, レスポンス処理, ディスパッチ処理, JSP, Webコンテナ

</details>

## 標準ハンドラ構成と主要処理フロー

## 処理フロー一覧

| 区分 | 種別 | 処理フロー名 | 概要 |
|---|---|---|---|
| アプリケーション初期化 | 正常フロー | 正常起動 | アプリデプロイ時にリポジトリ・ハンドラキュー等を初期化 |
| リクエストスレッド内制御 | 正常フロー | 業務処理正常終了 | 業務処理正常完了時に遷移先画面を表示 |
| リクエストスレッド内制御 | 代替フロー | ユーザエラー | ユーザ起因エラー時にトランザクションロールバック・エラー画面表示 (HTTP 400) |
| リクエストスレッド内制御 | 異常フロー | システムエラー | 業務ロジックのエラー時にトランザクションロールバック・障害ログ出力・システムエラー画面表示 (HTTP 500) |
| リクエストスレッド内制御 | 正常フロー | 直接画面遷移 | 業務アクションを介さず直接レスポンス（検索画面初回表示、静的コンテンツ等） |
| リクエストスレッド内制御 | 代替フロー | 内部フォーワード | 遷移先が業務アクション処理を伴う場合、`forward://` コンテンツパスで内部フォーワード |
| リクエストスレッド内制御 | 異常フロー | 認可エラー | ログインユーザに権限がない場合エラー画面に遷移 |
| リクエストスレッド内制御 | 異常フロー | 開閉局エラー | リクエストされた業務機能が閉局中の場合エラー画面に遷移 |
| リクエストスレッド内制御 | 代替フロー | アップロードファイル容量超過 | アップロードファイルが上限容量超過の場合エラー画面に遷移 (HTTP 400) |

## 標準ハンドラ構成

標準ハンドラキュー（登録順）:
1. NablarchServletContextListener
2. WebFrontController
3. ThreadContextClearHandler
4. GlobalErrorHandler
5. HttpCharacterEncodingHandler
6. FileRecordWriterDisposeHandler
7. SessionConcurrentAccessHandler
8. HttpResponseHandler
9. ThreadContextHandler（リクエストスコープ）
10. HttpAccessLogHandler
11. ForwardingHandler
12. HttpErrorHandler
13. MultipartHandler
14. NablarchTagHandler
15. DbConnectionManagementHandler
16. TransactionManagementHandler
17. ServiceAvailabilityCheckHandler
18. PermissionCheckHandler
19. ResourceMapping
20. HttpRequestJavaPackageMapping
21. HttpMethodBinding

## 処理フロー詳細

### 正常起動フロー
1. NablarchServletContextListener（往路）
2. WebFrontController（往路）- 全リクエストを対象とするサーブレットフィルタとしてデプロイされる

### 業務処理正常終了フロー (HTTP 200)
1. WebFrontController（往路）
2. SessionConcurrentAccessHandler（往路）
3. ThreadContextHandler（往路）
4. HttpAccessLogHandler（往路）
5. NablarchTagHandler（往路）
6. DbConnectionManagementHandler（往路）
7. TransactionManagementHandler（往路）
8. HttpRequestJavaPackageMapping（往路）
9. HttpMethodBinding（往路→復路）
10. TransactionManagementHandler（復路）
11. DbConnectionManagementHandler（復路）
12. HttpAccessLogHandler（復路）
13. HttpResponseHandler（復路）- デフォルトステータスコード: 200
14. SessionConcurrentAccessHandler（復路）
15. WebFrontController（復路）

### ユーザエラーフロー (HTTP 400)
1. WebFrontController（往路）
2. SessionConcurrentAccessHandler（往路）
3. ThreadContextHandler（往路）
4. HttpAccessLogHandler（往路）
5. NablarchTagHandler（往路）
6. DbConnectionManagementHandler（往路）
7. TransactionManagementHandler（往路）
8. HttpRequestJavaPackageMapping（往路）
9. HttpMethodBinding（往路）→ エラー: 業務精査エラー等のユーザエラーが発生した場合はエラー時遷移先を指定したHTTPエラーレスポンスオブジェクトを送出する
10. TransactionManagementHandler（例外処理）
11. DbConnectionManagementHandler（例外処理）
12. HttpErrorHandler（例外処理）
13. HttpAccessLogHandler（復路）
14. HttpResponseHandler（復路）- HttpErrorResponseに指定されたパスを用いてレスポンス処理 (デフォルトステータスコード: 400)
15. SessionConcurrentAccessHandler（復路）
16. WebFrontController（復路）

### システムエラーフロー (HTTP 500)
1. WebFrontController（往路）
2. SessionConcurrentAccessHandler（往路）
3. ThreadContextHandler（往路）
4. HttpAccessLogHandler（往路）
5. NablarchTagHandler（往路）
6. DbConnectionManagementHandler（往路）
7. TransactionManagementHandler（往路）
8. HttpRequestJavaPackageMapping（往路）
9. HttpMethodBinding（往路）→ エラー: NullPointerException等の実行時例外が送出される
10. TransactionManagementHandler（例外処理）
11. DbConnectionManagementHandler（例外処理）
12. HttpErrorHandler（例外処理）- 一般の実行時例外を捕捉した場合は障害ログが出力される
13. HttpAccessLogHandler（復路）
14. HttpResponseHandler（復路）- システムエラー画面に遷移 (デフォルトステータスコード: 500)
15. SessionConcurrentAccessHandler（復路）
16. WebFrontController（復路）

### 直接画面遷移フロー
1. WebFrontController（往路）
2. SessionConcurrentAccessHandler（往路）
3. ThreadContextHandler（往路）
4. HttpAccessLogHandler（往路）
5. ResourceMapping（往路）- `"//*.jsp"` `"/static/image/*.png"` などリクエストパスのパターンによって処理対象を絞る
6. HttpAccessLogHandler（復路）
7. HttpResponseHandler（復路）
8. SessionConcurrentAccessHandler（復路）
9. WebFrontController（復路）

### 内部フォーワードフロー
1. WebFrontController（往路）
2. SessionConcurrentAccessHandler（往路）
3. ThreadContextHandler（往路）
4. HttpAccessLogHandler（往路）
5. NablarchTagHandler（往路）
6. DbConnectionManagementHandler（往路）
7. TransactionManagementHandler（往路）
8. HttpRequestJavaPackageMapping（往路）
9. HttpMethodBinding（往路→復路）- レスポンスオブジェクトのコンテンツパスを `forward://(再実行したいリクエストパス)` のように指定する
10. TransactionManagementHandler（復路）
11. DbConnectionManagementHandler（復路）
12. ForwardingHandler（復路）- レスポンス・アクセスログの出力はフォーワード先で行われる

### アップロードファイル容量超過フロー
1. WebFrontController（往路）
2. MultipartHandler（往路）→ エラー: 各パートのデータサイズの合計が上限を越えた場合、実行時例外(ステータスコード: 400)を送出する
3. HttpErrorHandler（例外処理）
4. HttpResponseHandler（復路）
5. WebFrontController（復路）

<details>
<summary>keywords</summary>

NablarchServletContextListener, WebFrontController, ThreadContextClearHandler, GlobalErrorHandler, HttpCharacterEncodingHandler, FileRecordWriterDisposeHandler, SessionConcurrentAccessHandler, ThreadContextHandler, HttpAccessLogHandler, NablarchTagHandler, DbConnectionManagementHandler, TransactionManagementHandler, HttpRequestJavaPackageMapping, HttpMethodBinding, HttpResponseHandler, HttpErrorHandler, HttpErrorResponse, ForwardingHandler, MultipartHandler, ResourceMapping, ServiceAvailabilityCheckHandler, PermissionCheckHandler, NullPointerException, ハンドラキュー, 処理フロー, システムエラー, ユーザエラー, 内部フォーワード, 直接画面遷移, 認可エラー, 開閉局エラー, アップロードファイル容量超過

</details>
