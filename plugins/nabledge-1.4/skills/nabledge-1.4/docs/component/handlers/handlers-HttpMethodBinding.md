# 画面オンライン処理用業務アクションハンドラ

## 

**クラス名**: `nablarch.fw.web.HttpMethodBinding`

[../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) における標準的な業務アクションハンドラ。`Handler`インターフェースの実装不要で、HTTPリクエストの内容に従い動的にビジネスメソッドをディスパッチする。

## リクエストスコープ

3つの変数スコープのうち最も維持期間が短い。各HTTPリクエストごとに作成され、レスポンス処理が完了するまで維持される。単一のリクエスト間で完結し、次画面以降に引き継ぐ必要のないデータを保持する。

画面オンライン処理方式におけるリクエストスコープは `HTTPServletRequest#getAttribute()/setAttribute()` のラッパーである。

**リクエストスコープに保持するデータ**

- 画面に表示するデータオブジェクト（次画面以降に引き継がないもの）
- バリデーションエラー等のメッセージ
- JSP側で表示用に使用するフラグ

<details>
<summary>keywords</summary>

HttpMethodBinding, nablarch.fw.web.HttpMethodBinding, 業務アクションハンドラ, 画面オンライン処理, HTTPメソッドディスパッチ, リクエストスコープ, HTTPServletRequest, 変数スコープ, リクエスト単位のデータ管理, バリデーションエラーメッセージ

</details>

## 概要

[../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) における標準的な業務アクションハンドラの実装方法を提供する。

関連ドキュメント:
- ファイルダウンロードを行う場合: [../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload](../libraries/libraries-05_FileDownload.md)
- ファイルアップロードを伴う場合: [../common_library/file_upload_utility](../libraries/libraries-file_upload_utility.md)

## ウィンドウスコープ

ブラウザのウィンドウ・タブ・フレームごとに作成される。各ウィンドウが閉じられるか、セッションが終了するまで維持される。

ウィンドウ間で同一の値を共有しなければならない一部のデータ（ログインユーザIDやショッピングカート内の商品一覧など）を除き、画面遷移を跨って使用するデータは全てウィンドウスコープ上に保持する。これにより、複数ウィンドウを用いた並行操作やブラウザのヒストリバックによる遷移が可能となる。

**ウィンドウスコープに保持するデータ**

- 画面の入力項目（入力項目復帰が必要なもの）
- 他業務画面からの引き継ぎデータ
- 画面遷移履歴情報
- 楽観ロック用バージョン番号（あるデータに対する複数ユーザからの変更に対して、複数のリクエスト(画面)を跨いだトランザクションを実装する場合に使用する制御情報）

**使用方法**

ウィンドウスコープ変数は hidden属性のinputタグとして各ウィンドウの画面内に維持される。ウィンドウスコープ上の変数は通常のリクエストパラメータと同等に扱われる。ウィンドウスコープ変数を含むリクエストパラメータにアクセスするには validation 機能のAPIを使用する。

リクエストパラメータはフレームワークによって自動的にhiddenタグとして画面に出力される。ウィンドウスコープに変数を追加するには `HttpRequest#setParam()` を使用する。

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

フレームワークが出力したhiddenタグの値は、リクエストURIおよびname属性のハッシュ値とともに暗号化される。暗号化に使用する共通鍵はユーザログイン時に作成してメモリ上に保持され、ログアウトまたはセッションタイムアウト時に廃棄される。

<details>
<summary>keywords</summary>

業務アクションハンドラ概要, ファイルダウンロード, ファイルアップロード, 画面オンライン処理実装, ウィンドウスコープ, HttpRequest, setParam, @Published, 複数ウィンドウ並行操作, 楽観ロック, hiddenタグ暗号化, ヒストリバック

</details>

## 

**ハンドラキュー配置順**:
1. HttpResponseHandler
2. HttpErrorHandler
3. TransactionManagementHandler
4. HttpMethodBinding

**関連するハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 業務アクションが返却/送出したHTTPレスポンスオブジェクトをもとにレスポンス処理を行う |
| [HttpErrorHandler](handlers-HttpErrorHandler.md) | 業務アクションが送出した実行時例外を対応するエラー遷移先のHTTPレスポンスオブジェクトに変換する |
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | 業務アクションが実行時例外を送出することで業務トランザクションをロールバックする |

## セッションスコープ

ログインユーザごとに作成されるスコープで、複数のウィンドウで共有されるデータを保持する。ユーザがログインした時点で作成され、ログアウトまたはセッションタイムアウトが発生するまで維持される。

セッションスコープ上のデータは複数のウィンドウから同時にアクセスされる可能性があるため、適切に同期化しなければならない。

**セッションスコープに保持するデータ**

- ログインユーザに紐づくデータ（ログインユーザID、認証・認可情報）
- ウィンドウ間で同一のデータを参照・更新する必要があるデータ（ショッピングカート内の商品情報など）

**セッションスコープの実装方式**

HTTPSessionオブジェクトを使用する方式とデータベースを使用した独自実装の2通りがある。

- **HTTPSession方式**: 同じログインユーザからのリクエストをセッションスコープが存在するサーバインスタンスに振り分ける（セッションアフィニティ方式）か、クラスタ内全サーバインスタンスでセッションスコープを同期する（セッションパーシステント方式）必要がある。
- **DB独自実装方式**: アプリケーションサーバをほぼ制約なくスケールアップできるが、データベースへの負荷が増加する。

> **注意**: データベースを使用したHTTPセッション実装は現時点では提供されていない。

<details>
<summary>keywords</summary>

HttpResponseHandler, HttpErrorHandler, TransactionManagementHandler, ハンドラキュー, ハンドラ処理概要, 関連するハンドラ, セッションスコープ, セッション同期, セッションアフィニティ, セッションパーシステント, ログインユーザデータ, HTTPSession

</details>

## 業務アクションハンドラの実装内容

業務アクションハンドラでは`Handler`インターフェースの実装不要で、HTTPリクエストの内容に従い動的にメソッドがディスパッチされる。

```java
public class LoginAction {
    public HttpResponse getLoginHtml(HttpRequest request, ExecutionContext context) {
        context.invalidateSession();
        return new HttpResponse("./login.jsp");
    }

    public HttpResponse doLogin(HttpRequest request, ExecutionContext context) {
        try {
            authenticate(request, context);
            return new HttpResponse("forward:///app/MainMenu");
        } catch(AuthenticationFailedException e) {
            throw new HttpErrorResponse(403, "forward://login.html", e);
        }
    }
}
```

**① ビジネスメソッドのディスパッチ条件**:
1. 戻り値の型が`HttpResponse`、引数が`HttpRequest`と`ExecutionContext`の2つであること
2. メソッド名が `(HTTPメソッド名 もしくは "do") + (リクエストURIのリソース名)` に一致すること

一致判定条件:
- メソッド名の大文字小文字は区別しない
- リクエストURIのリソース名に含まれる "." は無視される
- 委譲先クラスのメソッド名に含まれる "_" は無視される

| HTTPリクエスト | 委譲対象となるメソッドシグニチャ例 |
|---|---|
| GET /app/index.html | `HttpResponse getIndexHtml(HttpRequest, ExecutionContext)`, `HttpResponse getIndexhtml(HttpRequest, ExecutionContext)`, `HttpResponse get_index_html(HttpRequest, ExecutionContext)`, `HttpResponse do_index_html(HttpRequest, ExecutionContext)`, `HttpResponse doIndexHtml(HttpRequest, ExecutionContext)` |
| POST /app/message | `HttpResponse postMessage(HttpRequest, ExecutionContext)`, `HttpResponse doMessage(HttpRequest, ExecutionContext)`, `HttpResponse do_message(HttpRequest, ExecutionContext)` |

条件に該当するメソッドが存在しない場合、ステータスコード404の`HttpErrorResponse`が送出される。

<details>
<summary>keywords</summary>

HttpResponse, HttpRequest, ExecutionContext, HttpErrorResponse, AuthenticationFailedException, メソッドディスパッチ, ビジネスメソッド命名規則, URIリソース名, ディスパッチ条件

</details>

## 

**② ビジネスロジックの実行とHTTPレスポンスオブジェクトの返却**

各メソッドの処理:
1. ビジネスロジックを実行する
2. 後続処理で参照する情報を各種スコープに設定する
3. 遷移先を指定するコンテンツパスが設定された`HttpResponse`オブジェクトを返却する

レスポンスボディの指定方法は2種類:
- `HttpResponse`オブジェクトに直接設定: 主に [../02_FunctionDemandSpecifications/02_Fw/01_Web/05_FileDownload](../libraries/libraries-05_FileDownload.md) で使用
- [コンテンツパス](#s4) 文字列で指定: 通常の業務機能で主に使用

**コンテンツパスの書式**

| 種別 | 書式 | 説明 |
|---|---|---|
| サーブレットフォーワード | `servlet://(パス)` | 指定パスへのサーブレットフォーワード。ハンドラキュー上の処理を再実行しない |
| 内部フォーワード | `forward://(パス)` | 指定パスを使いハンドラキューの処理を再実行する |
| HTTPリダイレクション | `redirect://(パス)` または `http(s)://(URL)` | クライアントにリダイレクションを指示。`redirect://`はサーブレットコンテキスト配下、`http://`は外部URL指定可能 |
| ファイルシステムリソース | `file://(パス)` | ファイルシステム上の静的ファイルを出力する |
| クラスパスリソース | `classpath://(パス)` | コンテキストクラスローダ上のリソースを出力する。相対パスと絶対パスの区別はなく同じ結果となる |

> **注意**: `servlet://`(サーブレットフォーワード)は指定サーブレットを実行するのみで、ハンドラキュー上の処理を再実行しない。[WebFrontController](handlers-WebFrontController.md) がサーブレットフィルタとして実装されているため、再実行すると無限ループになる。ハンドラキュー含めたフォワードが必要な場合は[ForwardingHandler](handlers-ForwardingHandler.md)による`forward://`(内部フォーワード)を使用すること。

パス指定例:
```bash
servlet://index.jsp                  # サーブレットフォーワード（相対パス）
servlet:///appContext/jsp/index.jsp  # サーブレットフォーワード（絶対パス）
forward://registerForm.html            # 内部フォーワード（相対パス）
forward:///app/user/registerForm.html  # 内部フォーワード（絶対パス）
redirect://login                       # HTTPリダイレクション（相対パス）
redirect:///UserAction/login           # HTTPリダイレクション（絶対パス）
http://www.example.com/login           # 外部サイトへのリダイレクション
file://webapps/style/common.css        # ファイルシステム（相対パス）
file:///www/docroot/style/common.css   # ファイルシステム（絶対パス）
classpath://nablarch/sample/webapp/common.css   # クラスパス（相対・絶対は等価）
```

<details>
<summary>keywords</summary>

コンテンツパス, サーブレットフォーワード, 内部フォーワード, HTTPリダイレクション, ForwardingHandler, WebFrontController, servlet://, forward://, redirect://, file://, classpath://

</details>

## 

**③ 例外制御**

`HttpErrorResponse`以外の実行時例外が送出された場合、デフォルトでHTTPステータス500のレスポンスが返る。それ以外の応答を行うには、以下のいずれかの方法を使用する:

1. **正常終了させる**: リクエストハンドラ内で明示的に例外を捕捉したうえで`HttpResponse`オブジェクトを生成して正常終了させる
2. **再送出する**: `HttpErrorResponse`でラップして再送出する

また、`@OnError`アノテーションを使うことで方法2を簡略化できる。

```java
// HttpErrorResponseを使う場合（方法2）
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

**アノテーション**: `@OnError`, `@OnErrors`

`@OnError`による簡略化:
```java
@OnError(
    type = ApplicationException.class,
    path = "forward://registerForm.html"
)
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) {
    UserForm form = validateUser(req);
    registerUser(form);
    return new HttpResponse(200, "servlet://registrationCompleted.jsp");
}
```

`@OnErrors`で複数例外を指定する場合、**定義順（上から順）に処理されるためサブクラスを先に定義すること**:
```java
// 正しい定義順: OptimisticLockException（サブクラス）をApplicationExceptionより先に定義
@OnErrors({
    @OnError(type = OptimisticLockException.class, path = "forward://searchForm.html"),
    @OnError(type = ApplicationException.class, path = "forward://updatingForm.html")
})
public HttpResponse handle(HttpRequest req, ExecutionContext ctx) { ... }
```

> **重要**: `@OnErrors`は定義順（上から順）に例外を処理する。`OptimisticLockException`は`ApplicationException`のサブクラスなので、必ず`ApplicationException`より上に定義すること。逆の順で定義すると`OptimisticLockException`送出時にも`ApplicationException`の処理が行われる。

**インターセプタの実行順** (:ref:`interceptors-order`)

設定ファイルの`interceptorsOrder`リストコンポーネントにFQCNを実行順に定義する:
```xml
<list name="interceptorsOrder">
  <value>nablarch.common.web.token.OnDoubleSubmission</value>
  <value>nablarch.fw.web.interceptor.OnErrors</value>
  <value>nablarch.fw.web.interceptor.OnError</value>
</list>
```

- 設定ファイルに未定義のインターセプタが利用された場合、実行時例外を送出する
- `interceptorsOrder`が未定義の場合は`Method#getDeclaredAnnotations`の逆順で実行されるが、アノテーションリストの順序はJVM保証がないためJVMバージョン等により実行順が変わる可能性がある

<details>
<summary>keywords</summary>

@OnError, @OnErrors, HttpErrorResponse, ApplicationException, OptimisticLockException, 例外制御, インターセプタ実行順, interceptorsOrder, OnDoubleSubmission

</details>

## 画面オンライン処理における変数スコープの利用

画面オンライン処理では、リクエストスコープ・セッションスコープに加えて、各画面内に自動的に出力されるhidden項目で実装される**ウィンドウスコープ**が定義されている。ウィンドウスコープはウィンドウ・タブごとに個別の変数を保持するため、複数ウィンドウからの並行操作でも矛盾なく業務処理を遂行できる。

| スコープ名称 | 用途 | 作成単位 | 維持期間 |
|---|---|---|---|
| リクエストスコープ | 単一のHTTPリクエスト内でのみ使用するデータ（画面間で共有不要なデータ）を保持 | HTTPリクエストごと | HTTPリクエストの開始から終了まで |
| ウィンドウスコープ | 画面間で共有するデータのうち、ウィンドウ間で共有不要なデータを保持 | ブラウザのウィンドウ・タブ・フレームごと | ウィンドウを開いてから閉じるまで（またはセッションスコープ終了まで） |
| セッションスコープ | 画面間で共有するデータのうち、ウィンドウ間で共有が必要なデータを保持 | ユーザのログインごと | ユーザログインからログアウトまで（またはセッションタイムアウトまで） |

![スコープ概念図](../../../knowledge/component/handlers/assets/handlers-HttpMethodBinding/web_scope.png)

<details>
<summary>keywords</summary>

リクエストスコープ, セッションスコープ, ウィンドウスコープ, 変数スコープ, hidden項目, スコープ使い分け

</details>
