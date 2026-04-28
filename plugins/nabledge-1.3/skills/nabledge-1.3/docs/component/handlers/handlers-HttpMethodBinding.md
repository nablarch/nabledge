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

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| HTTPレスポンスハンドラ | nablarch.fw.web.handler.HttpResponseHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容に沿ってレスポンス処理かサーブレットフォーワードのいずれかを行う。 | 既定のエラー画面をレスポンス後、例外を再送出する。ただしサーブレットフォーワード処理中にエラーが発生した場合はログ出力のみを行なう。 | - |
| HTTPエラー制御ハンドラ | nablarch.fw.web.handler.HttpErrorHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容が設定されていない場合は、ステータスコードに応じたデフォルトページを遷移先に設定する。 | 送出されたエラーに応じた遷移先のHTTPレスポンスオブジェクトを返却する。送出されたエラーはリクエストスコープに設定される。 | - |
| トランザクション制御ハンドラ | nablarch.fw.common.handler.TransactionManagementHandler | Object | Object | 業務トランザクションの開始 | トランザクションをコミットする。 | トランザクションをロールバックする。 | 1.コミット完了後 / 2.ロールバック後 |
| 画面オンライン処理業務アクション | nablarch.fw.action.HttpMethodBinding | HttpRequest | HttpResponse | HTTPリクエストの内容をもとに業務処理を実行する | 遷移先画面に表示する内容をリクエストコンテキストに設定した上で、遷移先パスを設定したHTTPレスポンスオブジェクトを返却する。 | - | - |

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
