# 画面オンライン実行制御基盤

## 概要

## 概要

HTMLベースのUIを持つ標準的なWebアプリケーション向けの実行制御基盤。テンプレートエンジンはJSP（Webコンテナ上で動作）。

HTTPリクエスト・レスポンス処理:
- **ディスパッチ処理**: 各HTTPリクエストに対して処理対象の業務機能を呼び出す
- **レスポンス処理**: 業務機能の結果を元にHTTPレスポンスを構成・送信する

コンテンツパス（業務アクション側で指定する文字列）によるレスポンス処理の振る舞い:
- `servlet://` で開始 → 当該パスに対するサーブレットフォーワード処理
- `file://` または `classpath://` → 当該リソースを取得してレスポンス

<details>
<summary>keywords</summary>

コンテンツパス, servlet://, file://, classpath://, ディスパッチ処理, レスポンス処理, 画面オンライン実行制御基盤, サーブレットフォーワード

</details>

## 業務アクションハンドラの実装

## 業務アクションハンドラの実装

標準的な実装方法: [../handler/HttpMethodBinding](../../component/handlers/handlers-HttpMethodBinding.md) を参照。

特殊ケース:
- レスポンス時にファイルダウンロードを行う場合: [../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload](../../component/libraries/libraries-05_FileDownload.md) を参照
- ファイルアップロードを伴う業務処理を実装する場合: [../02_FunctionDemandSpecifications/02_Fw/01_Web/06_FileUpload](../../component/libraries/libraries-06_FileUpload.md) を参照

<details>
<summary>keywords</summary>

HttpMethodBinding, ファイルダウンロード, ファイルアップロード, 業務アクションハンドラ

</details>

## 標準ハンドラ構成と主要処理フロー

## 標準ハンドラ構成と主要処理フロー

### ハンドラキュー構成

| No. | ハンドラ |
|---|---|
| 1 | NablarchServletContextListener |
| 2 | WebFrontController |
| 3 | ThreadContextClearHandler |
| 4 | GlobalErrorHandler |
| 5 | HttpCharacterEncodingHandler |
| 6 | FileRecordWriterDisposeHandler |
| 7 | SessionConcurrentAccessHandler |
| 8 | HttpResponseHandler |
| 9 | ThreadContextHandler_request |
| 10 | HttpAccessLogHandler |
| 11 | ForwardingHandler |
| 12 | HttpErrorHandler |
| 13 | MultipartHandler |
| 14 | NablarchTagHandler |
| 15 | DbConnectionManagementHandler |
| 16 | TransactionManagementHandler |
| 17 | ServiceAvailabilityCheckHandler |
| 18 | PermissionCheckHandler |
| 19 | ResourceMapping |
| 20 | HttpRequestJavaPackageMapping |
| 21 | HttpMethodBinding |

### 処理フロー一覧

| 区分 | 種別 | 処理フロー名 | 概要 |
|---|---|---|---|
| アプリケーション初期化 | 正常フロー | 正常起動 | アプリケーションデプロイ時に、リポジトリ、ハンドラキュー等の初期化を行う |
| リクエストスレッド内制御 | 正常フロー | 業務処理正常終了 | 業務処理が正常に完了し、処理結果に応じた遷移先画面を表示する |
| リクエストスレッド内制御 | 代替フロー | ユーザエラー | 入力精査処理等でユーザ起因のエラーが発生した場合は、業務トランザクションをロールバックし、エラー時の遷移先画面を表示する |
| リクエストスレッド内制御 | 異常フロー | システムエラー | 業務ロジック内で不具合等によるエラーが発生した場合は、業務トランザクションをロールバックし、障害ログを出力した上で、システムエラー画面に遷移する |
| リクエストスレッド内制御 | 正常フロー | 直接画面遷移 | 業務処理の無い画面の単純表示や静的コンテンツへのアクセスでは、業務アクションを介さずにレスポンスを行う |
| リクエストスレッド内制御 | 代替フロー | 内部フォーワード | 遷移先の画面が業務アクションでの処理を伴う場合は、遷移先JSPパスではなく実行したいリクエストパスを指定する（内部フォーワード処理） |
| リクエストスレッド内制御 | 異常フロー | 認可エラー | リクエストされた機能に対してログインユーザが権限を持っていない場合は、エラー画面に遷移させる |
| リクエストスレッド内制御 | 異常フロー | 開閉局エラー | リクエストされた業務機能が閉局中であった場合は、エラー画面に遷移させる |
| リクエストスレッド内制御 | 代替フロー | アップロードファイル容量超過 | アップロードされたファイルが限界容量を超過した場合は、エラー画面に遷移させる |

### 各フローの詳細

#### 正常起動 (launch)
1. NablarchServletContextListener (inbound)
2. WebFrontController (inbound) — 全リクエストを対象とするサーブレットフィルタとしてデプロイされる

#### 業務処理正常終了 (normalend)
**往路**: WebFrontController → SessionConcurrentAccessHandler → ThreadContextHandler_request → HttpAccessLogHandler → NablarchTagHandler → DbConnectionManagementHandler → TransactionManagementHandler → HttpRequestJavaPackageMapping → HttpMethodBinding

**復路**: HttpMethodBinding → TransactionManagementHandler → DbConnectionManagementHandler → HttpAccessLogHandler → HttpResponseHandler（デフォルトステータスコード: 200）→ SessionConcurrentAccessHandler → WebFrontController

#### ユーザエラー (usererror)
**往路**: WebFrontController → SessionConcurrentAccessHandler → ThreadContextHandler_request → HttpAccessLogHandler → NablarchTagHandler → DbConnectionManagementHandler → TransactionManagementHandler → HttpRequestJavaPackageMapping → HttpMethodBinding

**例外処理**: HttpMethodBinding（業務精査エラー等のユーザエラーが発生した場合、エラー時遷移先を指定したHTTPエラーレスポンスオブジェクトを送出する）→ TransactionManagementHandler（error）→ DbConnectionManagementHandler（error）→ HttpErrorHandler（error）

**復路**: HttpAccessLogHandler → HttpResponseHandler（HttpErrorResponseに指定されたパスを用いてレスポンス。デフォルトステータスコード: 400）→ SessionConcurrentAccessHandler → WebFrontController

#### システムエラー (systemerror)
**往路**: WebFrontController → SessionConcurrentAccessHandler → ThreadContextHandler_request → HttpAccessLogHandler → NablarchTagHandler → DbConnectionManagementHandler → TransactionManagementHandler → HttpRequestJavaPackageMapping → HttpMethodBinding（NullPointerException等の実行時例外が送出された場合）

**例外処理**: TransactionManagementHandler（error）→ DbConnectionManagementHandler（error）→ HttpErrorHandler（error、一般の実行時例外を捕捉した場合は障害ログが出力される）

**復路**: HttpAccessLogHandler → HttpResponseHandler（システムエラー画面に遷移。デフォルトステータスコード: 500）→ SessionConcurrentAccessHandler → WebFrontController

#### 直接画面遷移 (directaccess)
**往路**: WebFrontController → SessionConcurrentAccessHandler → ThreadContextHandler_request → HttpAccessLogHandler → ResourceMapping（"//*.jsp"、"/static/image/*.png" などリクエストパスのパターンによって処理対象を絞る）

**復路**: HttpAccessLogHandler → HttpResponseHandler → SessionConcurrentAccessHandler → WebFrontController

#### 内部フォーワード (forward)
**往路**: WebFrontController → SessionConcurrentAccessHandler → ThreadContextHandler_request → HttpAccessLogHandler → NablarchTagHandler → DbConnectionManagementHandler → TransactionManagementHandler → HttpRequestJavaPackageMapping → HttpMethodBinding

**復路**: HttpMethodBinding（レスポンスオブジェクトのコンテンツパスを "forward://(再実行したいリクエストパス)" のように指定する）→ TransactionManagementHandler → DbConnectionManagementHandler → ForwardingHandler（レスポンス、アクセスログの出力はフォーワード先で行われる）

#### アップロードファイル容量超過 (exceededlimit)
1. WebFrontController (inbound)
2. MultipartHandler（各パートのデータサイズの合計が上限を越えた場合、実行時例外（ステータスコード: 400）を送出する）
3. HttpErrorHandler (error)
4. HttpResponseHandler (outbound)
5. WebFrontController (outbound)

<details>
<summary>keywords</summary>

NablarchServletContextListener, WebFrontController, SessionConcurrentAccessHandler, HttpResponseHandler, HttpErrorHandler, ForwardingHandler, MultipartHandler, NablarchTagHandler, DbConnectionManagementHandler, TransactionManagementHandler, ServiceAvailabilityCheckHandler, PermissionCheckHandler, ResourceMapping, HttpRequestJavaPackageMapping, HttpMethodBinding, ThreadContextHandler_request, HttpAccessLogHandler, ThreadContextClearHandler, GlobalErrorHandler, HttpCharacterEncodingHandler, FileRecordWriterDisposeHandler, 正常起動, 業務処理正常終了, ユーザエラー, システムエラー, 直接画面遷移, 内部フォーワード, 認可エラー, 開閉局エラー, アップロードファイル容量超過, ハンドラキュー構成, 処理フロー

</details>
