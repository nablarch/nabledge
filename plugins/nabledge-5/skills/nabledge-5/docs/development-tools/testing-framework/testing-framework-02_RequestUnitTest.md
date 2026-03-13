# リクエスト単体テスト（ウェブアプリケーション）

**公式ドキュメント**: [リクエスト単体テスト（ウェブアプリケーション）](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/02_RequestUnitTest.html)

## 主なクラス・リソース

リクエスト単体テスト（ウェブアプリケーション）で使用する主なクラスとリソース:

| 名称 | 役割 | 作成単位 |
|------|------|----------|
| テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき１つ |
| テストデータ（Excelファイル） | 準備データ、期待結果、HTTPパラメータなどを記載する | テストクラスにつき１つ |
| テスト対象クラス(Action) | テスト対象のクラス（Action以降の業務ロジックを実装する各クラスを含む） | 取引につき1クラス |
| DbAccessTestSupport | 準備データ投入などデータベースを使用するテストに必要な機能を提供する | － |
| HttpServer | 内蔵サーバ。サーブレットコンテナとして動作し、HTTPレスポンスをファイル出力する機能を持つ | － |
| HttpRequestTestSupport | 内蔵サーバの起動やリクエスト単体テストで必要となる各種アサートを提供する | － |
| AbstractHttpReqestTestSupport / BasicHttpReqestTestSupport | リクエスト単体テストをテンプレート化するクラス。テストソース、テストデータを定型化する | － |
| TestCaseInfo | データシートに定義されたテストケース情報を格納するクラス | － |

上記のクラス群は、内蔵サーバも含め全て同一のJVM上で動作する。このため、リクエストやセッション等のサーバ側のオブジェクトを加工できる。

**クラス**: `nablarch.test.core.http.HttpTestConfiguration`

`HttpTestConfiguration` のコンポーネント設定ファイル設定項目一覧:

| プロパティ名 | デフォルト値 | 説明 |
|---|---|---|
| htmlDumpDir | ./tmp/html_dump | HTMLダンプファイルの出力ディレクトリ |
| webBaseDir | ../main/web | ウェブアプリのルートディレクトリ。PJ共通webモジュールがある場合はカンマ区切りで複数指定可（先頭から順に探索） |
| xmlComponentFile | （なし） | リクエスト単体テスト実行時のコンポーネント設定ファイル。通常は設定不要。クラス単体テストとリクエスト単体テストで設定を変える必要がある場合のみ設定する |
| userIdSessionKey | user.id | ログイン中ユーザIDを格納するセッションキー |
| exceptionRequestVarKey | nablarch_application_error | ApplicationExceptionが格納されるリクエストスコープのキー |
| dumpFileExtension | html | ダンプファイルの拡張子 |
| httpHeader | Content-Type: application/x-www-form-urlencoded, Accept-Language: ja JP | HttpRequestにHTTPリクエストヘッダとして格納される値 |
| sessionInfo | （なし） | セッションに格納される値 |
| htmlResourcesExtensionList | css, jpg, js | ダンプディレクトリへコピーされるHTMLリソースの拡張子 |
| jsTestResourceDir | ../test/web | JavaScriptの自動テスト実行時に使用するリソースのコピー先ディレクトリ |
| backup | true | ダンプディレクトリのバックアップOn/Off |
| htmlResourcesCharset | UTF-8 | CSSファイルの文字コード |
| checkHtml | true | HTMLチェックの実施On/Off |
| htmlChecker | `nablarch.test.tool.htmlcheck.Html4HtmlChecker` | HTMLチェックを行うオブジェクト。`nablarch.test.tool.htmlcheck.HtmlChecker` インターフェースを実装する必要がある。詳細は :ref:`customize_html_check` を参照 |
| htmlCheckerConfig | test/resources/httprequesttest/html-check-config.csv | HTMLチェックツールの設定ファイルパス。`htmlChecker` を設定しない場合のみ有効 |
| ignoreHtmlResourceDirectory | （なし） | HTMLリソースコピー対象外とするディレクトリ名のリスト |
| tempDirectory | jettyのデフォルト動作に依存（デフォルトは `./work`、存在しない場合はTempフォルダ） | JSPのコンパイル先ディレクトリ |
| uploadTmpDirectory | ./tmp | アップロードファイルの一時格納ディレクトリ。テスト時のアップロード対象ファイルはここにコピーされてから処理されるため、アクションでファイルを移動しても実態の移動を防ぐ |
| dumpVariableItem | false | HTMLダンプ出力時に可変項目（JSESSIONID、2重サブミット防止トークン）を出力するか否か。false=毎回同じダンプ結果（前回実行結果との差異確認に使用）、true=可変項目をそのまま出力 |

> **補足**: `ignoreHtmlResourceDirectory` にバージョン管理用ディレクトリ（`.svn` や `.git`）を設定するとHTMLリソースコピー時のパフォーマンスが向上する。

コンポーネント設定ファイル記述例（デフォルト値に加え、`sessionInfo` に以下の値を設定する）:

| キー | 値 | 説明 |
|---|---|---|
| commonHeaderLoginUserName | "リクエスト単体テストユーザ" | 共通ヘッダ領域に表示するログインユーザ名 |
| commonHeaderLoginDate | "20100914" | 共通ヘッダ領域に表示するログイン日時 |

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="htmlDumpDir" value="./tmp/html_dump"/>
    <property name="webBaseDir" value="../main/web"/>
    <property name="xmlComponentFile" value="http-request-test.xml"/>
    <property name="userIdSessionKey" value="user.id"/>
    <property name="httpHeader">
        <map>
            <entry key="Content-Type" value="application/x-www-form-urlencoded"/>
            <entry key="Accept-Language" value="ja JP"/>
        </map>
    </property>
    <property name="sessionInfo">
        <map>
            <entry key="commonHeaderLoginUserName" value="リクエスト単体テストユーザ"/>
            <entry key="commonHeaderLoginDate" value="20100914" />
        </map>
    </property>
    <property name="htmlResourcesExtensionList">
        <list>
            <value>css</value>
            <value>jpg</value>
            <value>js</value>
        </list>
    </property>
    <property name="backup" value="true" />
    <property name="htmlResourcesCharset" value="UTF-8" />
    <property name="ignoreHtmlResourceDirectory">
        <list>
            <value>.svn</value>
        </list>
    </property>
    <property name="tempDirectory" value="webTemp" />
    <property name="htmlCheckerConfig"
      value="test/resources/httprequesttest/html-check-config.csv" />
</component>
```

<details>
<summary>keywords</summary>

HttpServer, HttpRequestTestSupport, AbstractHttpReqestTestSupport, BasicHttpReqestTestSupport, TestCaseInfo, DbAccessTestSupport, 内蔵サーバ, テストクラス, テストデータ, 主なクラス, 同一JVM, HttpTestConfiguration, Html4HtmlChecker, HtmlChecker, htmlDumpDir, webBaseDir, xmlComponentFile, userIdSessionKey, exceptionRequestVarKey, dumpFileExtension, httpHeader, sessionInfo, htmlResourcesExtensionList, jsTestResourceDir, backup, htmlResourcesCharset, checkHtml, htmlChecker, htmlCheckerConfig, ignoreHtmlResourceDirectory, tempDirectory, uploadTmpDirectory, dumpVariableItem, コンポーネント設定, HTTPリクエストテスト設定, HTMLダンプ, HTMLチェック

</details>

## 前提事項

内蔵サーバを使用してHTMLダンプを出力するリクエスト単体テストは、**１リクエスト１画面遷移のシンクライアント型ウェブアプリケーション**を対象としている。

Ajaxやリッチクライアントを利用したアプリケーションの場合、HTMLダンプによるレイアウト確認は使用できない。

> **補足**: 本書ではViewテクノロジにJSPを用いているが、サーブレットコンテナ上で画面全体をレンダリングする方式であれば、JSP以外のViewテクノロジでもHTMLダンプの出力が可能である。

> **補足**: 処理性能が低いCPU（Pentium4、Pentium Dual-Core等）を搭載したPCで効果がある。これら以降のCPUでは効果的ではないので無理に設定する必要はない。

以下のJVMオプションを指定することでリクエスト単体テストの実行速度が向上する:

- `-Xms256m -Xmx256m`: 最大ヒープサイズと最小ヒープサイズを同一の値にすることで、ヒープサイズ拡張のオーバヘッドを回避できる
- `-Xverfiy:none`: クラスファイルの検証を省略することで実行速度が向上する

Eclipse設定: メニューバー「実行」→「実行構成」→「引数」タブ→「VM引数」欄にオプションを指定する。またはメニューバー「ウィンドウ」→「設定」→「インストール済みのJRE」から使用するJREを選択し「編集」→「VM引数」欄に指定することでデフォルトのVM引数として設定できる。

<details>
<summary>keywords</summary>

シンクライアント, １リクエスト１画面遷移, Ajax, リッチクライアント, HTMLダンプ制約, 前提事項, JSP以外, Viewテクノロジ, JVMオプション, ヒープサイズ, -Xms, -Xmx, -Xverfiy:none, 実行速度向上, リクエスト単体テスト高速化, VM引数

</details>

## BasicHttpRequestTestTemplate

`BasicHttpRequestTestTemplate` は各テストクラスのスーパクラス。本クラスを使用することで、リクエスト単体テストのテストソース、テストデータを定型化でき、テストソース記述量を大きく削減できる。

具体的な使用方法は `[../05_UnitTestGuide/02_RequestUnitTest/index](testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest.md)` を参照。

`AbstractHttpRequestTestTemplate` はアプリケーションプログラマが直接使用することはない。テストデータの書き方を変えたい場合など、自動テストフレームワークを拡張する際に用いる。

`TestCaseInfo` はデータシートに定義されたテストケース情報を格納するクラス。テストデータの書き方を変えたい場合は、本クラス及び `AbstractHttpRequestTestTemplate` の両方を継承する。

JavaSE5のJDKで開発している場合、テスト実行時のみJavaSE6のJREを使用することにより、実行速度、特に起動速度が向上する。

Eclipse設定: メニューバー「実行」→「実行構成」→「JRE」タブ→「代替JRE」にJavaSE6のJREを選択する。

> **補足**: 設定する場合は、事前にJavaSE6のJDKまたはJREをインストールし、Eclipseに「インストール済みのJRE」として登録しておく必要がある。

<details>
<summary>keywords</summary>

BasicHttpRequestTestTemplate, AbstractHttpRequestTestTemplate, TestCaseInfo, スーパクラス, テストソース定型化, テストソース記述量削減, 構造, フレームワーク拡張, 継承, 代替JRE, JavaSE6, 起動速度向上, リクエスト単体テスト高速化, JRE設定, JavaSE5

</details>

## データベース関連機能

DB関連機能は `DbAccessTestSupport` クラスに委譲して実現。ただし以下のメソッドはリクエスト単体テストでは不要なため、意図的に委譲していない：

- `public void beginTransactions()`
- `public void commitTransactions()`
- `public void endTransactions()`
- `public void setThreadContextValues(String sheetName, String id)`

詳細は [02_DbAccessTest](testing-framework-02_DbAccessTest.md) を参照。

リクエスト単体実行時に以下のシステムプロパティを指定すると、 [HTMLダンプ出力](#s7) 時にHTMLリソースのコピーを抑止できる。

`-Dnablarch.test.skip-resource-copy=true`

CSSや画像ファイルなど静的なHTMLリソースを頻繁に編集しない場合に設定する。

> **重要**: このシステムプロパティを指定した場合、HTMLリソースのコピーが行われなくなるため、CSSなどのHTMLリソースを編集しても [HTMLダンプ出力](#s7) に反映されない。

> **補足**: HTMLリソースディレクトリが存在しない場合は、システムプロパティの設定有無に関わらずHTMLリソースのコピーが実行される。

Eclipse設定: メニューバー「実行」→「実行構成」→「引数」タブ→「VM引数」欄に前述のオプションを指定する。

<details>
<summary>keywords</summary>

DbAccessTestSupport, HttpRequestTestSupport, beginTransactions, commitTransactions, endTransactions, setThreadContextValues, データベース関連機能, 委譲除外メソッド, HTMLリソースコピー, skip-resource-copy, nablarch.test.skip-resource-copy, システムプロパティ, HTMLダンプ, CSSコピー抑止

</details>

## 事前準備補助機能

`HttpRequestTestSupport` は内蔵サーバへのリクエスト送信に必要な `HttpRequest` と `ExecutionContext` インスタンスを作成するメソッドを提供する。

**HttpRequest生成**:

```java
HttpRequest createHttpRequest(String requestUri, Map<String, String[]> params)
```

リクエストURIとリクエストパラメータから `HttpRequest` インスタンスを生成し、HTTPメソッドをPOSTに設定して返却する。URI・パラメータ以外のデータは戻り値のインスタンスに設定する。

**ExecutionContext生成**:

```java
ExecutionContext createExecutionContext(String userId)
```

引数のユーザIDはセッションに格納され、そのユーザIDでログインしている状態になる。

**トークン発行** (2重サブミット防止URIのテスト用):

```java
void setValidToken(HttpRequest request, ExecutionContext context)
void setToken(HttpRequest request, ExecutionContext context, boolean valid)
```

- `setValidToken`: トークンを発行してセッションに設定する。
- `setToken`: 第3引数が `true` の場合は `setValidToken` と同じ動作。`false` の場合はセッションからトークン情報を除去する。テストデータから取得した文字列 `"true"/"false"` を `Boolean.parseBoolean()` に渡すことで、テストクラス側の分岐処理を省略できる。

<details>
<summary>keywords</summary>

HttpRequestTestSupport, createHttpRequest, createExecutionContext, setValidToken, setToken, トークン発行, 2重サブミット防止, 事前準備補助機能

</details>

## 実行・システムリポジトリの初期化

`HttpRequestTestSupport` にある下記のメソッドを呼び出すことで、内蔵サーバが起動されリクエストが送信される。

```java
HttpResponse execute(String caseName, HttpRequest req, ExecutionContext ctx)
```

引数:
- `caseName`: テストケース説明（HTMLダンプ出力時のファイル名に使用される）
- `req`: HttpRequest
- `ctx`: ExecutionContext

**システムリポジトリの初期化**: `execute` メソッド内部でシステムリポジトリの再初期化を行う。これによりクラス単体テストとリクエスト単体テストで設定を分けずに連続実行できる。

処理順序:
1. 現在のシステムリポジトリの状態をバックアップ
2. テスト対象ウェブアプリケーションのコンポーネント設定ファイルでシステムリポジトリを再初期化
3. `execute` メソッド終了時にバックアップしたシステムリポジトリを復元

テスト対象ウェブアプリケーションの設定は :ref:`howToConfigureRequestUnitTestEnv` を参照。

<details>
<summary>keywords</summary>

execute, HttpResponse, caseName, HttpRequestTestSupport, システムリポジトリ初期化, コンポーネント設定ファイル, クラス単体テストとリクエスト単体テストの連続実行, 内蔵サーバ起動, テストケース説明

</details>

## メッセージ

アプリケーション例外に格納されたメッセージの検証メソッド:

```java
void assertApplicationMessageId(String expectedCommaSeparated, ExecutionContext actual)
```

- 第1引数: 期待するメッセージID（複数の場合はカンマ区切り）
- 第2引数: ExecutionContext

例外が発生しなかった場合、またはアプリケーション例外以外の例外が発生した場合はアサート失敗となる。

> **補足**: メッセージIDの比較はIDをソートした状態で行うため、テストデータの記載順は問わない。

<details>
<summary>keywords</summary>

assertApplicationMessageId, HttpRequestTestSupport, メッセージID検証, アプリケーション例外, ExecutionContext

</details>

## HTMLダンプ出力ディレクトリ

テスト実行時、プロジェクトルートディレクトリに `tmp/html_dump` ディレクトリが作成される。配下にテストクラス名と同名のディレクトリが作成され、テストケース説明と同名のHTMLダンプファイルが出力される。HTMLが参照するリソース（スタイルシート、画像等）もこのディレクトリに出力される。このディレクトリを保存することで、どの環境でもHTMLを同じように参照できる。

- `html_dump` ディレクトリが既に存在する場合は `html_dump_bk` という名前でバックアップされる。

ディレクトリ構造:
```
tmp/html_dump/
  {テストクラス名}/
    {テストケース説明}.html
```

<details>
<summary>keywords</summary>

HTMLダンプ, tmp/html_dump, html_dump_bk, テストHTML出力, HTMLダンプ出力ディレクトリ, ポータビリティ, 環境非依存

</details>
