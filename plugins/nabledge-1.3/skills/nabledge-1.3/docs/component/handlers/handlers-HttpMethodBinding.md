# 画面オンライン処理用業務アクションハンドラ

## クラス概要

**クラス名**: `nablarch.fw.web.HttpMethodBinding`

画面オンライン処理における標準的な業務アクションハンドラ。`Handler` インターフェースの実装不要で、HTTPリクエストの内容に従い動的にメソッドを呼び分ける。

**リクエストスコープ**

3つの変数スコープのうちで最も維持期間が短い。各HTTPリクエストごとに作成され、レスポンス処理が完了するまで維持される。次画面以降に引き継ぐ必要のないデータはここに保存する。

画面オンライン処理方式では `HTTPServletRequest#getAttribute()` / `HTTPServletRequest#setAttribute()` メソッドのラッパーとして実装されている。

**保持するデータ**:
- 画面に表示するデータオブジェクト（次画面以降に引き継がないもの）
- バリデーションエラー等のメッセージ
- JSP側で表示用に使用するフラグ

<details>
<summary>keywords</summary>

HttpMethodBinding, nablarch.fw.web.HttpMethodBinding, 業務アクションハンドラ, 画面オンライン処理, リクエストスコープ, HTTPServletRequest, getAttribute, setAttribute, 変数スコープ, バリデーションエラーメッセージ, リクエスト単位のデータ保持

</details>

## 概要

ファイルダウンロード実装時の参照先: [../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload](../libraries/libraries-05_FileDownload.md)

ファイルアップロードを伴う業務処理実装時の参照先: [../common_library/file_upload_utility](../libraries/libraries-file_upload_utility.md)

**ウィンドウスコープ**

ブラウザのウィンドウ、タブ、フレームごとに作成される。各ウィンドウが閉じられるか、セッションが終了するまで維持される。

ウィンドウ間で同一の値を共有しなければならない一部のデータを除き、画面遷移を跨って使用するデータは全てウィンドウスコープで保持する。これにより、アプリケーション側で特段の考慮をしなくとも複数ウィンドウを用いた並行操作や、ブラウザのヒストリバックによる遷移が可能となる。

**保持するデータ**:
- 画面の入力項目（入力項目復帰が必要なもの）
- 他業務画面からの引き継ぎデータ
- 画面遷移履歴情報
- 楽観ロック用バージョン番号（あるデータに対する複数ユーザからの変更に対して、複数のリクエスト(画面)を跨いだトランザクションを実装する場合に使用する制御情報）

**使用方法**:

ウィンドウスコープ変数はhidden属性のinputタグとして各ウィンドウの画面内に維持される。通常のリクエストパラメータと同等に扱われる。

- パラメータへのアクセス: [validation](../libraries/libraries-validation-core_library.md) 機能のAPIを使用
- 変数の追加: `HttpRequest#setParam()` を使用

```java
public class HttpRequest extends Request {
    @Published
    public HttpRequest setParam(String name, String... params);
}
```

**セキュリティ**:

フレームワークが出力したhiddenタグの値は、リクエストURIおよびname属性のハッシュ値とともに暗号化される。暗号化処理に使用する共通鍵はユーザログイン時に作成しメモリ上に保持される。ログアウトまたはセッションタイムアウト時に廃棄される。

<details>
<summary>keywords</summary>

業務アクションハンドラ実装, ファイルダウンロード, ファイルアップロード, web_gui, ウィンドウスコープ, HttpRequest, setParam, hiddenタグ, 暗号化, 複数ウィンドウ並行操作, ヒストリバック, 楽観ロック, ウィンドウ間データ共有, @Published

</details>

## ハンドラ処理概要・関連するハンドラ

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 業務アクションが返却・送出したHTTPレスポンスをもとにレスポンス処理を行う |
| [HttpErrorHandler](handlers-HttpErrorHandler.md) | 業務アクションが送出した実行時例外を捕捉し、対応するHTTPレスポンスオブジェクトに変換する |
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | 業務アクションが実行時例外を送出することで、業務トランザクションをロールバックする |

**セッションスコープ**

ログインユーザごとに作成されるスコープ。複数のウィンドウで共有されるデータを保持する目的で使用する。ログインした時点で作成され、ログアウトまたはセッションタイムアウトが発生するまで維持される。

> **重要**: セッションスコープ上のデータは複数のウィンドウから同時にアクセスされる可能性があり、適切に同期化しなければならない。

**保持するデータ**:
- ログインユーザに紐づくデータ（ログインユーザID、認証・認可情報）
- ウィンドウ間で同一のデータを参照・更新する必要があるデータ（ショッピングカート内の商品情報など）

**セッションスコープの実装方式**:

| 方式 | 概要 |
|---|---|
| HTTPSessionオブジェクト（セッションアフィニティ） | 同じログインユーザからのリクエストをセッションスコープが存在するサーバインスタンスに必ず振り分ける |
| HTTPSessionオブジェクト（セッションパーシステント） | サーバクラスタ内の全てのサーバインスタンスでセッションスコープを同期する必要がある |
| データベースを使用した独自実装 | セッション情報をDBに保存する。アプリケーションサーバはほぼ制約なくスケールアップ可能だがDB負荷が増加する |

> **注意**: データベースを使用したHTTPセッション実装は現時点では提供されていない。

<details>
<summary>keywords</summary>

HttpResponseHandler, HttpErrorHandler, TransactionManagementHandler, ハンドラキュー, 関連ハンドラ, セッションスコープ, HTTPSession, セッションアフィニティ, セッションパーシステント, 同期化, ログインユーザ, 認証・認可, スケーリング

</details>

## 業務アクションハンドラの実装内容

業務アクションハンドラでは `Handler` インターフェースを実装する必要はなく、HTTPリクエストの内容に従い動的にメソッドが呼び分けられる。

**メソッドディスパッチ条件**

1. 戻り値の型が `HttpResponse`、引数が `HttpRequest` と `ExecutionContext` の2つであること
2. メソッド名が `(HTTPメソッド名 または "do") + (リクエストURIのリソース名)` に一致すること

大文字小文字は区別しない。リクエストURIの "." とメソッド名の "_" は無視される。

| HTTPリクエスト | ディスパッチ対象メソッドの例 |
|---|---|
| GET /app/index.html | `getIndexHtml(HttpRequest, ExecutionContext)`, `getIndexhtml(...)`, `get_index_html(...)`, `do_index_html(...)`, `doIndexHtml(...)` |
| POST /app/message | `postMessage(HttpRequest, ExecutionContext)`, `doMessage(...)`, `do_message(...)` |

該当メソッドが存在しない場合、ステータスコード404の `HttpErrorResponse` が送出される。

**ビジネスロジックの実行とHTTPレスポンスオブジェクトの返却**

各メソッドでの処理:
1. ビジネスロジックを実行する
2. 後続処理（JSP等）で参照する情報を各種スコープに設定する
3. 遷移先を指定するコンテンツパスが設定された `HttpResponse` オブジェクトを返却する

レスポンスボディの指定方法:
- `HttpResponse` に直接設定: 主に [../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload](../libraries/libraries-05_FileDownload.md) で使用
- [コンテンツパス](#s4): 通常の業務機能で主に使用

<details>
<summary>keywords</summary>

HttpResponse, HttpRequest, ExecutionContext, HttpErrorResponse, ビジネスメソッドのディスパッチ, メソッドディスパッチ, HTTPメソッド, リソース名

</details>

## コンテンツパス

コンテンツパスとは、`HttpResponse` オブジェクトに設定するレスポンス内容指定文字列。

**1. サーブレットフォーワード** (`servlet://パス`)

指定パスへのサーブレットフォーワードを行う。クライアントへのレスポンスはフォーワード先で行われる。JSP画面表示に主に使用。相対パスは現在のリクエストURIを起点、絶対パスはサーブレットコンテキストを起点。

> **注意**: サーブレットフォーワードはハンドラキューの処理を再実行しない（[WebFrontController](handlers-WebFrontController.md) がサーブレットフィルタとして実装されているため、再実行すると無限ループになる）。ハンドラキューを含めたフォワードには [ForwardingHandler](handlers-ForwardingHandler.md) の内部フォーワードを使用すること。

**2. 内部フォーワード** (`forward://パス`)

指定リクエストパスでハンドラキューの処理を再実行する。遷移先が業務アクションの処理を伴う場合に使用。相対パスは現在のリクエストURIを起点、絶対パスはサーブレットコンテキスト名を起点。詳細は [ForwardingHandler](handlers-ForwardingHandler.md) を参照。

**3. HTTPリダイレクション**

- `redirect://パス`: サーブレットコンテキスト配下へのリダイレクション。絶対パスはコンテキストルートからの相対パスとみなされる。
- `http(s)://URL`: サーブレットコンテキスト外へのリダイレクション。ホスト名を含む完全URLを指定できる。

**4. ファイルシステム上のリソース** (`file://パス`)

ファイルシステム上の静的ファイルを出力する。相対パスはJVMのワーキングディレクトリが起点、絶対パスはファイルシステムルートが起点。

**5. Javaコンテキストクラスローダ上のリソース** (`classpath://リソース名`)

コンテキストクラスローダ上のリソースを出力する。Javaリソース名の完全修飾名を "/" 区切りで指定する。相対パスと絶対パスの区別はなく、どちらを使用しても同じ結果となる。

<details>
<summary>keywords</summary>

コンテンツパス, サーブレットフォーワード, 内部フォーワード, HTTPリダイレクション, ForwardingHandler, WebFrontController, servlet://, forward://, redirect://, file://, classpath://

</details>

## 例外制御・インターセプタの実行順

`HttpErrorResponse` 以外の実行時例外が送出された場合、デフォルトでHTTPステータス500のレスポンスが返る。別のレスポンスをするには、明示的に例外を捕捉して `HttpResponse` を返却するか、`HttpErrorResponse` でラップして再送出すること。

**@OnError アノテーション**

例外発生時の遷移先を宣言的に指定できる。

```java
@OnError(
    type = ApplicationException.class,
    path = "forward://registerForm.html"
)
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) { ... }
```

**@OnErrors アノテーション**

複数の `@OnError` を `{}` で配列指定する。定義順（上から順）に例外を処理する。

> **重要**: サブクラスの例外（例: `OptimisticLockException`）は、スーパークラスの例外（例: `ApplicationException`）よりも**上に**定義すること。逆順に定義するとスーパークラスの処理が先に適用される。

**インターセプタの実行順**

設定ファイルに `interceptorsOrder` という名前の `list` コンポーネントとしてアノテーションのFQCNを実行順に定義する。

```xml
<list name="interceptorsOrder">
  <value>nablarch.common.web.token.OnDoubleSubmission</value>
  <value>nablarch.fw.web.interceptor.OnErrors</value>
  <value>nablarch.fw.web.interceptor.OnError</value>
</list>
```

設定ファイルに未定義のインターセプタが使用された場合、実行時例外が送出される。

`interceptorsOrder` リストが定義されていない場合、`Method#getDeclaredAnnotations` が返すリストの逆順でインターセプタが実行される。このリストの順序はJVM保証外のため、実行環境（JVMバージョン等）によってインターセプタの実行順が変わる可能性がある。

<details>
<summary>keywords</summary>

HttpErrorResponse, ApplicationException, OptimisticLockException, @OnError, @OnErrors, interceptorsOrder, OnDoubleSubmission, インターセプタ実行順, nablarch.fw.web.interceptor.OnError, nablarch.fw.web.interceptor.OnErrors, nablarch.common.web.token.OnDoubleSubmission

</details>

## 画面オンライン処理における変数スコープの利用

リクエストスコープ・セッションスコープに加えて、hidden項目によって実装される **ウィンドウスコープ** が定義されている。ウィンドウスコープはウィンドウ/タブごとに個別の変数を保持し、複数ウィンドウからの並行操作でも矛盾なく業務処理を遂行できる。

| スコープ名称 | 用途 | 作成単位 | 維持期間 |
|---|---|---|---|
| リクエストスコープ | 単一HTTPリクエスト内でのみ使用するデータ（画面間共有不要） | HTTPリクエストごと | リクエスト開始〜終了 |
| ウィンドウスコープ | 画面間共有だがウィンドウ間共有不要なデータ | ブラウザのウィンドウ/タブ/フレームごと | ウィンドウを開いてから閉じるまで、またはセッション終了まで |
| セッションスコープ | 画面間共有かつウィンドウ間共有も必要なデータ | ユーザのログインごと | ログイン〜ログアウト、またはセッションタイムアウトまで |

![変数スコープの概念図](../../../knowledge/component/handlers/assets/handlers-HttpMethodBinding/web_scope.png)

<details>
<summary>keywords</summary>

リクエストスコープ, ウィンドウスコープ, セッションスコープ, 変数スコープ, hidden項目, 複数ウィンドウ

</details>
