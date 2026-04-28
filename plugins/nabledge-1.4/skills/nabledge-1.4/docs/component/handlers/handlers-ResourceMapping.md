## リソースマッピングハンドラ

**クラス名:** `nablarch.fw.web.handler.ResourceMapping`

-----

-----

### 概要

業務アクションの処理を経由せずに、直接レスポンスとして返却するリソースを決定するハンドラ。

このハンドラは、主にログイン画面のようにビジネスロジックを介さずに表示するJSPや、
javascriptや画像のような静的リソースのレスポンスを行なう場合に使用する。

レスポンスされるリソースは、事前に定義されたリクエストパスと
[コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) とのマッピング定義を元に決定される。

マッピング先のリソースは、以下のいずれかを指定することができる。

1. サーブレット/JSPフォーワード (**servlet://** スキーム) **[デフォルト]**
2. 内部フォーワードの実行結果 (**forward://** スキーム)
3. コンテキストクラスローダ上のリソース (**classpath://** スキーム)

なお、セキュリティ上の配慮から、ファイルシステム上のローカルファイル(**file://** スキーム)を
マッピング先に指定することはできない。また、スキームの指定を省略した場合は **servlet://** スキームが指定されたものと
みなされる。

> **Note:**
> 通常のサーブレットアプリケーションでは、直接アクセス不可能なリソースは **/WEB-INF/** 配下に配置するのが
> 一般的であるが、本フレームワークでは、JSP、画像などのリソースは全てサーブレットコンテキスト配下に
> 直接配置することを推奨している。

> この場合、デフォルトでは全てのリソースに対する直接アクセスは拒否され、
> 業務アクションのレスポンスもしくは、本ハンドラのマッピング定義の対象となるリソースのみアクセス可能となる。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| HTTPレスポンスハンドラ | nablarch.fw.web.handler.HttpResponseHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容に沿ってレスポンス処理かサーブレットフォーワードのいずれかを行う。 | 既定のエラー画面をレスポンス後、例外を再送出する。ただしサーブレットフォーワード処理中にエラーが発生した場合はログ出力のみを行なう。 |
| 内部フォーワードハンドラ | nablarch.fw.web.handler.ForwardingHandler | HttpRequest | HttpResponse | - | 遷移先に内部フォーワードパスが指定されていた場合、HTTPリクエストオブジェクトのリクエストURIを内部フォーワードパスに書き換えた後、後続のハンドラを再実行する。 | - |
| リソースマッピングハンドラ | nablarch.fw.web.handler.ResourceMapping | HttpRequest | HttpResponse | リクエストURIを、クラスパス上のリソースパスもしくはサーブレットフォーワードパスにマッピングすることで、業務アクションを実行することなくHTTPレスポンスオブジェクトを作成して返却する。 | - | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) | 本ハンドラが返却したHTTPレスポンスオブジェクト中の [コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) の内容に 基づいてレスポンス処理を行う。 |
| [内部フォーワードハンドラ](../../component/handlers/handlers-ForwardingHandler.md) | [コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) が **forward://** で開始されている場合に内部フォーワード 処理を行う。 |
| [リクエストハンドラエントリ](../../component/handlers/handlers-RequestHandlerEntry.md) | 本ハンドラによるマッピング対象となるリクエストを限定するために、 必ず、 [リクエストハンドラエントリ](../../component/handlers/handlers-RequestHandlerEntry.md) と組み合わせて使用する。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (マッピング対象リクエスト判定)**

本ハンドラに設定された **マッピング元ベースURI** が、リクエストパス(サーブレットコンテキストからの相対パス)に対して
前方一致するかどうかを判定する。

**1a. (マッピング対象外のリクエスト)**

**1.** でパスが一致しなかった場合、当該リクエストは本ハンドラによるマッピングの対象外と判断し、
ステータスコード **404** のレスポンスをリターンし、終了する。

**2.(マッピング先コンテンツパスの算出)**

リクエストパス中の **1.** で前方一致した部分文字列を、本ハンドラに設定された **マッピング先ベースコンテンツパス** に置換し、
**マッピング先コンテンツパス** とする。
なお、 **マッピング先ベースコンテンツパス** にスキームが明示されていない場合は、 **servlet://** を補完する。

**3. (マッピング先コンテンツパス実在チェック)**

**マッピング先コンテンツパス** のスキームが **classpath://** であった場合は当該のパス上にリソースが実在するかどうかを
チェックし、もし存在しなければ、ステータスコード **404** のレスポンスをリターンし、終了する。

**4. (HTTPレスポンスの返却)**

ステータスコード **200** のHTTPレスポンスを作成し、 **2.** で算出した [コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) を設定した上でリターンする。

**[復路処理]**

(本ハンドラは後続のハンドラに対する処理委譲を行なわない。)

**[例外処理]**

(本ハンドラは後続のハンドラに対する処理委譲を行なわない。)

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| マッピング元ベースURI | baseUri | String | **必須指定**  リクエストURIの置換対象となる部分文字列(前方一致)を指定する。 |
| マッピング先ベースコンテンツパス | basePath | String | **必須指定**  リクエストURI中のマッピング元ベースURIを置換する文字列 ([コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path))を指定する。 スキームの指定を省略した場合は、 **servlet://** が指定されたものとみなされる。 |

**画像ファイルに対するマッピングの設定例**

次の例では、リクエストパス **/img/** 配下の画像ファイルに対するリクエストを、
サーブレットコンテキスト配下のパス **/resources/img/** を参照するようにマッピングしている。

```xml
<!-- 静的リソースに対するマッピング -->
<!-- スタイルシート -->
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/img//*.png"/>
  <property name="handler">
    <component class="nablarch.fw.web.handler.ResourceMapping">
      <!-- マッピング元ベースURI -->
      <property name="baseUri" value="/img/"/>
      <!-- マッピング先ベースコンテンツパス -->
      <property name="basePath" value="servlet:///resources/img/"/>
    </component>
  </property>
</component>
```

このマッピングにより、HTTPリクエストと、それに対するレスポンスの [コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) との対応は以下のようになる。
(サーブレットコンテキストパスが **/webapp/** であった場合。)

| HTTPリクエストライン | コンテンツパス |
|---|---|
| GET /webapp/img/logo.png | servlet:///resource/img/logo.png |
| GET /webapp/img/page1/figure01.png | servlet:///resource/img/page1/figure01.png |

**直接表示可能なJSP画面**

次の例では、リソース名の末尾が **-public.jsp** となっている場合に、当該ページに対する直接アクセスを可能としている。

```xml
<!-- 静的リソースに対するマッピング -->
<!-- スタイルシート -->
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/jsp//*-public.jsp"/>
  <property name="handler">
    <component class="nablarch.fw.web.handler.ResourceMapping">
      <!-- マッピング元ベースURI -->
      <property name="baseUri" value="/"/>
      <!-- マッピング先ベースコンテンツパス -->
      <property name="basePath" value="servlet:///"/>
    </component>
  </property>
</component>
```

このマッピングにより、HTTPリクエストと、それに対するレスポンスの [コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) との対応は以下のようになる。
(サーブレットコンテキストパスが **/webapp/** であった場合。)

| HTTPリクエストライン | コンテンツパス |
|---|---|
| GET /webapp/jsp/login-public.jsp | servlet:///jsp/login-public.jsp |
| GET /webapp/jsp/welcome.jsp | (404エラー) |
