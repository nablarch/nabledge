## HTTPレスポンスハンドラ

**クラス名:** `nablarch.fw.handler.HttpResponseHandler`

-----

-----

### 概要

このハンドラは、後続ハンドラの処理結果となるHTTPレスポンスオブジェクトの内容に沿って、
サーブレットフォーワード処理や、サーバソケットへの出力といったレスポンス処理を行う。

HTTPレスポンスオブジェクトは、あくまで「レスポンス処理を行うために必要な情報を格納したクラス」であり、
これを生成しただけではレスポンス処理は行われない。
HTTPレスポンスオブジェクトの内容に沿って実際にレスポンス処理を行うのはこのハンドラである。

HTTPレスポンスオブジェクトがクライアントに送信するレスポンスボディの内容を指定する方法は大きく2つある。

1つめは、HTTPレスポンスオブジェクトに対して直接レスポンスボディの内容を設定する方法であり、
主に [ファイルダウンロード](../../component/libraries/libraries-05-FileDownload.md) 処理などで使用する。

もう1つは、 [コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) と呼ばれる文字列によってレスポンス内容を指定する方法であり、
通常の業務機能の実装ではこちらを主に使用する。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| HTTPレスポンスハンドラ | nablarch.fw.web.handler.HttpResponseHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容に沿ってレスポンス処理かサーブレットフォーワードのいずれかを行う。 | 既定のエラー画面をレスポンス後、例外を再送出する。ただしサーブレットフォーワード処理中にエラーが発生した場合はログ出力のみを行なう。 |
| リソースマッピングハンドラ | nablarch.fw.web.handler.ResourceMapping | HttpRequest | HttpResponse | リクエストURIを、クラスパス上のリソースパスもしくはサーブレットフォーワードパスにマッピングすることで、業務アクションを実行することなくHTTPレスポンスオブジェクトを作成して返却する。 | - | - |
| 画面オンライン処理業務アクション | nablarch.fw.action.HttpMethodBinding | HttpRequest | HttpResponse | HTTPリクエストの内容をもとに業務処理を実行する | 遷移先画面に表示する内容をリクエストコンテキストに設定した上で、遷移先パスを設定したHTTPレスポンスオブジェクトを返却する。 | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| * [リソースマッピングハンドラ](../../component/handlers/handlers-ResourceMapping.md) * [画面オンライン処理用業務アクションハンドラ](../../component/handlers/handlers-HttpMethodBinding.md) | 本ハンドラは、 [HttpResponse](../../javadoc/nablarch/fw/web/HttpResponse.html) をリターンもしくは送出するこれらのハンドラの上位に 配置する必要がある。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (後続ハンドラへの処理委譲)**

往路では本ハンドラは特段の処理を行なわない。
引数をそのまま後続ハンドラに渡して処理を委譲し、その結果としてHTTPレスポンスオブジェクトを取得する。

**[復路での処理]**

**2. (コンテンツパスの取得)**

HTTPレスポンスオブジェクトに設定された [コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) 文字列を取得する。

**2a. (サーブレットフォーワード処理)**

[コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) が **"forward://"** で開始されていた場合は、
フォーワード名に対するサーブレットフォーワードを実行する。
この場合、クライアントに対するレスポンスの出力処理はフォーワード先のサーブレットで実行される。

フォーワード完了後、HTTPレスポンスオブジェクトをリターンして終了する。

**3. (HTTPレスポンスヘッダー送信)**

HTTPレスポンスに設定されたHTTPヘッダーの内容をクライアントに送信する。
(ボディの内容はChunkedエンコーディングによって送信される。)

**3a. (HTTPリダイレクション)**

[コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) が **"redirect://"** 、 **"http://"** 、 **"https://"**
のいずれかで開始されていた場合は、パス文字列を **Location** ヘッダに設定し、リダイレクトの
HTTPレスポンスを送信する。

なお、 **redirect://** スキームかつ絶対パス指定であった場合は、 **Location** ヘッダに設定するパスに
サーブレットコンテキストルートのパスを補完する。

**4a. (HTTPレスポンスボディ送信: ファイルシステム上のファイルの内容を送信)**

[コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) が **"file://"** で開始されていた場合は、
パスに指定されたファイルの内容をレスポンスボディとして送信する。

**4b. (HTTPレスポンスボディ送信: クラスパス上のリソースの内容を送信)**

[コンテンツパス](../../component/handlers/handlers-HttpMethodBinding.md#content-path) が **"classpath://"** で開始されていた場合は、
コンテキストクラスローダからパスに指定されたリソースを取得し、その内容をレスポンスボディとして送信する。

**4c. (HTTPレスポンスボディ送信: InputStreamの内容を送信)**

HTTPレスポンスオブジェクトに直接InputStreamが設定されている場合、
もしくは、 `HttpResponse#write()` メソッドによってレスポンス内容を
HTTPレスポンスオブジェクト内にバッファリングしている場合は
その内容をレスポンスボディとして送信する。

**5. (終端処理)**

レスポンス処理で使用した入出力ストリームを全てクローズする。
また、HTTPレスポンスオブジェクト上にレスポンス内容がバッファリングされている場合は削除する。

**6. (正常終了)**

HTTPレスポンスオブジェクトをリターンして終了する。

**[例外処理]**

**1a. (後続ハンドラ実行中のエラー)**

後続ハンドラ実行中に例外が送出された場合は、
既定のエラー画面をレスポンス後、例外を再送出する。
ただしサーブレットフォーワード処理中にエラーが発生した場合はログ出力のみを行なう。

**2a-b. (サーブレットフォーワード先でのエラー)**

フォーワード先のJSPやサーブレットでエラーが発生した場合は、
システムエラー画面をクライアント側に送信して終了する。

**2a-c. (サーブレットフォーワード中のIOエラー)**

サーブレットフォーワード処理中にIOエラーが発生した場合は、
ワーニングレベルのログを出力した上でHTTPレスポンスオブジェクトをリターンして終了する。

**5a. (レスポンス処理中のIOエラー)**

レスポンス処理および、終端処理においてIOエラーが発生した場合は、
ワーニングレベルのログを出力した上で処理を継続する。

**5a. (レスポンス処理中のその他のエラー)**

レスポンス処理および、終端処理において例外が発生した場合は、
システムエラー画面をクライアントに送信し、 **5.** の終端処理を行なったうえで、例外を再送出する。

-----

#### ステータスコードの変換

HTTPレスポンスハンドラは、内部で 404 などのエラー用レスポンスが返された際に、正常レスポンスを表す 200 にステータスコードを変換する。

これは、ブラウザのレスポンスコードによる挙動の差異を発生させないための施策である。

例外的に、転送に用いられる 300 系のレスポンスコードであった場合と、
クライアントからのリクエストヘッダ "X-Requested-With" の値が "XMLHttpRequest" である
場合(つまり AJAX のリクエストの場合) 内部のエラーコードをそのままステータスコードとする。

#### 言語毎のコンテンツパスの切り替え

HTTPレスポンスハンドラは、HTTPリクエストから取得した言語設定をもとに、フォーワード先を動的に切り替える機能をもつ。
ResourcePathRule抽象クラスのサブクラスを使用して言語毎のコンテンツパスを取得することで、
HTTPレスポンスハンドラは言語毎のコンテンツパスの切り替えを行う。

ResourcePathRuleおよび本フレームワークがデフォルトで提供するサブクラスを下記に示す。

| クラス名 | 説明 |
|---|---|
| ResourcePathRule | 言語対応リソースパスのルールを表すクラス。  言語はスレッドコンテキストから取得する。 スレッドコンテキストへの言語設定については、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md#threadcontexthandler) を参照。 スレッドコンテキストから言語を取得できない場合は指定されたリソースパスをそのまま返す。  言語対応のリソースパスが指すファイルが存在する場合のみ言語対応のリソースパスを返す。 ファイルが存在しない、または指定されたリソースパスに拡張子を含まない場合は 指定されたリソースパスをそのまま返す。  サブクラスでは言語対応のリソースパスを作成するメソッドを実装する。 |
| DirectoryBasedResourcePathRule | コンテキストルート直下のディレクトリを言語の切り替えに使用するクラス。  ```bash # /management/user/search.jspを日本語(ja)と英語(en)に対応する場合の配置例 # コンテキストルート直下に言語ごとにディレクトリを作成する。 # ディレクトリ名は言語名とする。 コンテキストルート ├─en │  └─management │      └─user │           search.jsp └─ja     └─management         └─user              search.jsp ``` |
| FilenameBasedResourcePathRule | ファイル名を言語の切り替えに使用するクラス。  ```bash # /management/user/search.jspを日本語(ja)と英語(en)に対応する場合の配置例 # 言語毎にファイルを作成する。 # ファイル名にはサフィックス「"_"＋言語名」を付ける。 コンテキストルート └─management         └─user              search_en.jsp              search_ja.jsp ``` |

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| 言語毎コンテンツパスの対応ルール | contentPathRule | ResourcePathRule | 任意指定(デフォルト=DirectoryBasedResourcePathRule) |
| レスポンスをChunkedエンコーディングで送信するかどうか | forceFlushAfterWritingHeaders | boolean | 任意指定(デフォルト=true) |
| レスポンスの"X-Frame-Options"の設定 | xFrameOptions | String | 任意指定(デフォルト=SAMEORIGIN)  "X-Frame-Options"の設定と、それに対するframe要素やiframe要素上のページ表示制御は以下のようになる。  \| "X-Frame-Options"の設定 \| frame要素やiframe要素上のページ表示を制御 \| \|---\|---\| \| DENY \| すべてのページにおいて表示を禁止 \| \| SAMEORIGIN \| アドレスバーに表示されたドメインと同じページのみ表示を許可 \| \| NONE \| すぺてのページにおいて表示を許可 \| |

**標準設定**

以下は標準設定におけるDI設定の例である。

```xml
<!-- HTTPレスポンスハンドラ -->
<component class="nablarch.fw.web.handler.HttpResponseHandler" />
```

**言語毎のコンテンツパス切り替えを行なう場合の設定**

言語毎に切り替えたいコンテンツは、コンテキストルート直下に言語毎のディレクトリを作成し、
言語毎のディレクトリにデフォルトのコンテンツパスと同じでパスで配置する。
コンテンツパスの例を示す。

```bash
# デフォルトのコンテンツパス
/management/user/search.jsp

# 日本語対応のコンテンツパス
/ja/management/user/search.jsp

# 英語対応のコンテンツパス
/en/management/user/search.jsp
```

リポジトリの設定例を示す。

```xml
<!-- リソースパスルール -->
<component name="resourcePathRule" class="nablarch.fw.web.i18n.DirectoryBasedResourcePathRule" />

<!-- HTTPレスポンスハンドラ -->
<component class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="contentPathRule" ref="resourcePathRule" />
</component>
```

スレッドコンテキストに設定された言語と使用されるコンテンツパスの例を示す。
ここでは上記コンテンツパスの例に記載したファイルが配置されているものとする。

```bash
# HttpResponseオブジェクトに設定されたコンテンツパス
servlet:///management/user/search.jsp

# スレッドコンテキストの言語 -> 使用されるコンテンツパス
ja -> /ja/management/user/search.jsp
en -> /en/management/user/search.jsp
it -> /management/user/search.jsp
```

**HTTPレスポンスをChunkedエンコーディングで送信しない場合の設定**

HTTP通信による通信先の仕様がHTTP1.1に未対応等の理由によりChunkedエンコーディングで送信することができない場合は、
以下のように設定することで対応する。

リポジトリの設定例を示す。

```xml
<!-- HTTPレスポンスハンドラ -->
<component class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="forceFlushAfterWritingHeaders" value="false" />
</component>
```

> **Warning:**
> 上記の設定でChunkedエンコーディングで送信しないように設定した場合でも、APサーバの設定によってChunkedエンコーディングで送信されることがあります。その場合は、APサーバの設定を確認・変更してください。

**クリックジャッキング攻撃への対策の設定**

クリックジャッキング攻撃への対策として、HTTPレスポンスヘッダに"X-Frame-Options"を設定する対策がある。
"X-Frame-Options"はframe要素またはiframe要素でページを表示させることを許可するか否かを指定することができる仕組みである。

セキュリティレベルの高い設定をデフォルトに採用しており、全てのHTTPレスポンスのヘッダに、
"X-Frame-Options"に"SAMEORIGIN"が設定され、アドレスバーに表示されたドメインと同じページのみ
frame要素またはiframe要素を使用したページの表示を許可される。

リポジトリで設定を行うことで、デフォルト値を変更することができる。リポジトリの設定例を示す。

```xml
<!-- HTTPレスポンスハンドラ -->
<component class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="xFrameOptions" value="DENY" />
</component>
```

> **Note:**
> リポジトリの"xFrameOptions"に"NONE"を設定した場合は、"SAMEORIGIN"や"DENY"とは異なり、HTTPレスポンスヘッダに"X-Frame-Options"の項目自体を設定しない。
