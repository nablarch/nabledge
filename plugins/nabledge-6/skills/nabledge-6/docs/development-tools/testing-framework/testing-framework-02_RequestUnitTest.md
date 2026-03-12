# リクエスト単体テスト（ウェブアプリケーション）

**公式ドキュメント**: [リクエスト単体テスト（ウェブアプリケーション）](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/02_RequestUnitTest.html)

## 前提事項

内蔵サーバを使用してHTMLダンプを出力するというリクエスト単体テストは、**１リクエスト１画面遷移のシンクライアント型ウェブアプリケーション**を対象としている。

Ajaxやリッチクライアントを利用したアプリケーションの場合、**HTMLダンプによるレイアウト確認は使用できない**。

> **補足**: ViewテクノロジにはJSPを使用しているが、サーブレットコンテナ上で画面全体をレンダリングする方式であれば、JSP以外のViewテクノロジでもHTMLダンプの出力が可能である。

**クラス**: `nablarch.test.core.http.HttpTestConfiguration`

| プロパティ名 | 説明 | デフォルト値 |
|---|---|---|
| htmlDumpDir | HTMLダンプファイルの出力ディレクトリ | ./tmp/html_dump |
| webBaseDir | ウェブアプリのルートディレクトリ | ../main/web |
| xmlComponentFile | テスト実行時のコンポーネント設定ファイル | （なし） |
| userIdSessionKey | ログイン中ユーザIDのセッションキー | user.id |
| exceptionRequestVarKey | `ApplicationException`が格納されるリクエストスコープキー | nablarch_application_error |
| dumpFileExtension | ダンプファイル拡張子 | html |
| httpHeader | HTTPリクエストヘッダ | Content-Type: application/x-www-form-urlencoded, Accept-Language: ja JP |
| sessionInfo | セッションに格納される値 | （なし） |
| htmlResourcesExtensionList | ダンプディレクトリへコピーするHTMLリソース拡張子 | css, jpg, js |
| jsTestResourceDir | JavaScriptテストリソースのコピー先ディレクトリ | ../test/web |
| backup | ダンプディレクトリバックアップOn/Off | true |
| htmlResourcesCharset | CSSファイルの文字コード | UTF-8 |
| checkHtml | HTMLチェックOn/Off | true |
| htmlChecker | HTMLチェックオブジェクト（`nablarch.test.tool.htmlcheck.HtmlChecker`実装必須）。詳細は :ref:`customize_html_check` 参照 | `nablarch.test.tool.htmlcheck.Html4HtmlChecker` |
| htmlCheckerConfig | HTMLチェックツール設定ファイルパス（`htmlChecker`未設定時のみ有効） | test/resources/httprequesttest/html-check-config.csv |
| ignoreHtmlResourceDirectory | HTMLリソースのコピー対象外ディレクトリ名リスト | （なし） |
| tempDirectory | JSPのコンパイル先ディレクトリ | Jettyデフォルト（`./work`、存在しない場合はTempフォルダ） |
| uploadTmpDirectory | アップロードファイルの一時格納ディレクトリ。テスト時に準備したアップロード対象ファイルは本ディレクトリにコピー後に処理されるため、アクションでファイルを移動した場合でも本ディレクトリ配下のファイルが移動されるだけであり、元のテストファイルが移動されることを防ぐことができる。 | ./tmp |
| dumpVariableItem | HTMLダンプでJSESSIONID・2重サブミット防止トークンの可変項目（2種類）を出力するか | false |

**webBaseDir**: PJ共通webモジュールがある場合、カンマ区切りで複数ディレクトリを設定可能（例: `value="/path/to/web-a/,/path/to/web-common"`）。先頭から順にリソースが探索される。

**xmlComponentFile**: 通常設定不要。クラス単体テストとリクエスト単体テストで設定が異なる場合のみ設定。リクエスト送信直前に指定ファイルで初期化される。

> **補足**: `ignoreHtmlResourceDirectory` にVCS管理ディレクトリ（`.svn`、`.git`）を設定するとHTMLリソースコピー時のパフォーマンスが向上する。

**dumpVariableItem**: JSSESSIONIDと2重サブミット防止トークンはテスト実行毎に異なる値となる。HTMLダンプを毎回同じ結果にしたい場合はfalse（デフォルト）に設定。可変項目をそのまま出力する場合はtrueに設定。

コンポーネント設定ファイル記述例（sessionInfoにログインユーザ名・日時を設定する場合）:

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
    <property name="htmlCheckerConfig" value="test/resources/httprequesttest/html-check-config.csv" />
</component>
```

<details>
<summary>keywords</summary>

シンクライアント, 1リクエスト1画面遷移, Ajax, リッチクライアント, HTMLダンプ, レイアウト確認, 内蔵サーバ, 制約, 対象アプリケーション, HttpTestConfiguration, nablarch.test.core.http.HttpTestConfiguration, Html4HtmlChecker, nablarch.test.tool.htmlcheck.Html4HtmlChecker, HtmlChecker, nablarch.test.tool.htmlcheck.HtmlChecker, ApplicationException, htmlDumpDir, webBaseDir, xmlComponentFile, userIdSessionKey, exceptionRequestVarKey, dumpFileExtension, httpHeader, sessionInfo, htmlResourcesExtensionList, jsTestResourceDir, backup, htmlResourcesCharset, checkHtml, htmlChecker, htmlCheckerConfig, ignoreHtmlResourceDirectory, tempDirectory, uploadTmpDirectory, dumpVariableItem, コンポーネント設定, HTTPテスト設定, HTMLダンプ設定, セッション設定, リクエスト単体テスト設定

</details>

## 構造（BasicHttpRequestTestTemplate / AbstractHttpRequestTestTemplate / TestCaseInfo）

リクエスト単体テストを構成する主なクラスとリソース：

| 名称 | 役割 | 作成単位 |
|------|------|----------|
| テストクラス | テストロジックを実装する | テスト対象クラス(Action)につき１つ作成 |
| テストデータ（Excelファイル） | 準備データ・期待結果・HTTPパラメータなどを記載する | テストクラスにつき１つ作成 |
| テスト対象クラス(Action) | テスト対象のクラス（Action以降の業務ロジックを含む） | 取引につき1クラス作成 |
| DbAccessTestSupport | 準備データ投入などデータベースを使用するテストに必要な機能を提供する | － |
| **HttpServer** | **内蔵サーバ。サーブレットコンテナとして動作し、HTTPレスポンスをファイル出力する機能を持つ。** | － |
| HttpRequestTestSupport | 内蔵サーバの起動やリクエスト単体テストで必要となる各種アサートを提供する | － |
| AbstractHttpRequestTestTemplate / BasicHttpRequestTestTemplate | リクエスト単体テストをテンプレート化するクラス。テストソース・テストデータを定型化する | － |
| TestCaseInfo | データシートに定義されたテストケース情報を格納するクラス | － |

> **重要**: 上記のクラス群は、**内蔵サーバも含め全て同一のJVM上で動作する**。このため、リクエストやセッション等のサーバ側のオブジェクトを加工できる。

---

**BasicHttpRequestTestTemplate**

各テストクラスのスーパクラス。本クラスを使用することで、リクエスト単体テストのテストソース・テストデータを定型化でき、テストソース記述量を大きく削減できる。

**AbstractHttpRequestTestTemplate**

アプリケーションプログラマが直接使用することはない。テストデータの書き方を変えたい場合など、**自動テストフレームワークを拡張する際**に用いる。

**TestCaseInfo**

データシートに定義されたテストケース情報を格納するクラス。テストデータの書き方を変えたい場合は、本クラス及び`AbstractHttpRequestTestTemplate`を継承する。

> **補足**: Pentium4、Pentinum Dual-Core等の処理性能が低いCPUを搭載したPCでのリクエスト単体テスト実行速度改善に効果がある。これら以降のCPU搭載マシンでは効果が薄いため、無理に設定する必要はない。

最大・最小ヒープサイズを同一値にすることでヒープサイズ拡張のオーバーヘッドを回避できる:

`-Xms256m -Xmx256m`

クラスファイルの検証を省略することで実行速度が向上する:

`-Xverfiy:none`

Eclipseでの設定方法:

1. メニューバーより「実行」→「実行構成」を選択する。
2. 「実行構成」ウィンドウの「引数」タブをクリックし、「VM引数」欄に前述のオプションを指定する。

デフォルトのVM引数設定（実行構成変更不要の場合）:

1. メニューバーより「ウィンドウ」→「設定」を選択する。
2. 「インストール済みのJRE」から使用するJREを選択し、「編集」ボタンを押下する。
3. 「VM引数」欄に前述のオプションを指定する。

<details>
<summary>keywords</summary>

BasicHttpRequestTestTemplate, AbstractHttpRequestTestTemplate, TestCaseInfo, HttpServer, HttpRequestTestSupport, DbAccessTestSupport, スーパクラス, テストデータ書き方変更, フレームワーク拡張, テストケース情報, データシート, 継承, 同一JVM, サーブレットコンテナ, 内蔵サーバ, 作成単位, テスト対象クラス, JVMオプション, ヒープサイズ設定, 実行速度改善, クラス検証省略, Eclipse VM引数, -Xms, -Xmx, -Xverify, VM引数指定

</details>

## データベース関連機能

データベース機能は`DbAccessTestSupport`クラスに委譲して実現している。

以下のメソッドはリクエスト単体テストでは不要のため、意図的に委譲されていない：

- `public void beginTransactions()`
- `public void commitTransactions()`
- `public void endTransactions()`
- `public void setThreadContextValues(String sheetName, String id)`

リクエスト単体実行時に以下のシステムプロパティを指定すると、[dump-dir-label](#s7) 出力時にHTMLリソースコピーを抑止できる:

`-Dnablarch.test.skip-resource-copy=true`

CSSや画像ファイルなど静的なHTMLリソースを頻繁に編集しない場合に設定してもよい。

> **重要**: このシステムプロパティを指定した場合、HTMLリソースのコピーが行われなくなるため、CSSなどのHTMLリソースを編集しても [dump-dir-label](#s7) の出力に反映されない。

> **補足**: HTMLリソースディレクトリが存在しない場合は、システムプロパティの設定有無に関わらずHTMLリソースのコピーが実行される。

Eclipseでの設定方法:

1. メニューバーより「実行」→「実行構成」を選択する。
2. 「実行構成」ウィンドウの「引数」タブをクリックし、「VM引数」欄に前述のオプションを指定する。

<details>
<summary>keywords</summary>

DbAccessTestSupport, HttpRequestTestSupport, beginTransactions, commitTransactions, endTransactions, setThreadContextValues, データベース委譲, 委譲されないメソッド, リクエスト単体テスト, HTMLリソースコピー抑止, skip-resource-copy, nablarch.test.skip-resource-copy, システムプロパティ, 実行速度改善, HTMLダンプ, 静的リソースコピー

</details>

## 事前準備補助機能

`HttpRequestTestSupport`は内蔵サーバへのリクエスト送信に必要なオブジェクトを簡単に作成するメソッドを提供する。

**HttpRequest生成**:
```java
HttpRequest createHttpRequest(String requestUri, Map<String, String[]> params)
```
リクエストURIとリクエストパラメータを受け取り`HttpRequest`インスタンスを生成し、HTTPメソッドをPOSTに設定して返却する。URI・パラメータ以外のデータを設定したい場合は、取得したインスタンスに対して追加設定すること。

**ExecutionContext生成**:
```java
ExecutionContext createExecutionContext(String userId)
```
指定したユーザIDはセッションに格納され、そのユーザIDでログインしている状態となる。

**トークン発行**（2重サブミット防止を施しているURIへのテスト時に必要）:

テスト実行前にトークンを発行しセッションに設定しておく必要がある。

```java
void setValidToken(HttpRequest request, ExecutionContext context)
```
トークンの発行とセッションへの格納を行う。

```java
void setToken(HttpRequest request, ExecutionContext context, boolean valid)
```
第3引数がtrue: `setValidToken`と同動作。false: セッションからトークン情報が除去される。これを使用することで、テストクラスにトークン設定の分岐処理を書かずに済む。

テストデータ上でトークン設定を制御する典型的なパターン：
```java
// 【説明】テストデータから取得したものとする。
String isTokenValid;

// 【説明】"true"の場合はトークンが設定される。
setToken(req, ctx, Boolean.parseBoolean(isTokenValid));
```
このようにテストデータの文字列値（"true"/"false"）からトークン設定を制御することで、テストクラス側に条件分岐を書かずに済む。

<details>
<summary>keywords</summary>

HttpRequestTestSupport, HttpRequest, ExecutionContext, createHttpRequest, createExecutionContext, setValidToken, setToken, トークン発行, 2重サブミット防止, リクエスト生成

</details>

## 実行

`HttpRequestTestSupport`にある下記のメソッドを呼び出すことで、内蔵サーバが起動されリクエストが送信される。

```java
HttpResponse execute(String caseName, HttpRequest req, ExecutionContext ctx)
```

引数には以下の値を引き渡す：

- `caseName` — テストケース説明。HTMLダンプ出力時のファイル名に使用される。
- `req` — `HttpRequest`インスタンス
- `ctx` — `ExecutionContext`インスタンス

戻り値は`HttpResponse`。

<details>
<summary>keywords</summary>

HttpRequestTestSupport, execute, HttpResponse, HttpRequest, ExecutionContext, caseName, テストケース説明, HTMLダンプファイル名, 内蔵サーバ起動, リクエスト送信

</details>

## システムリポジトリの初期化

`execute`メソッド内部でシステムリポジトリの再初期化を行う。これによりクラス単体テストとリクエスト単体テストで設定を分けずに連続実行できる。

処理の流れ:
1. 現在のシステムリポジトリの状態をバックアップ
2. テスト対象のウェブアプリケーションのコンポーネント設定ファイルを用いてシステムリポジトリを再初期化
3. `execute`メソッド終了時に、バックアップしたシステムリポジトリを復元

テスト対象のウェブアプリケーションに関する設定については、`:ref:howToConfigureRequestUnitTestEnv` を参照。

<details>
<summary>keywords</summary>

HttpRequestTestSupport, HttpResponse, execute, システムリポジトリ再初期化, コンポーネント設定ファイル, バックアップ復元, テスト連続実行

</details>

## メッセージ

アプリケーション例外に格納されたメッセージが想定通りかを確認するメソッド：

```java
void assertApplicationMessageId(String expectedCommaSeparated, ExecutionContext actual)
```

- 第1引数: 期待するメッセージID（複数ある場合はカンマ区切り）
- 第2引数: ExecutionContext

例外が発生しなかった場合やアプリケーション例外以外の例外が発生した場合は、アサート失敗となる。

> **補足**: メッセージIDの比較はIDをソートした状態で行うため、テストデータ記載時に順序を気にする必要はない。

<details>
<summary>keywords</summary>

assertApplicationMessageId, HttpRequestTestSupport, ExecutionContext, アプリケーション例外, メッセージID検証, アサート

</details>

## HTMLダンプ出力ディレクトリ

テスト実行時にテスト用プロジェクトのルートディレクトリに`tmp/html_dump`ディレクトリが作成される。テストクラス毎に同名のディレクトリが作成され、テストケース説明と同名のHTMLダンプファイルが出力される。

HTMLリソース（スタイルシート、画像など）も同ディレクトリに出力されるため、このディレクトリを保存することでどの環境でも同じようにHTMLを参照できる。

`html_dump`ディレクトリが既に存在する場合は、`html_dump_bk`という名前でバックアップされる。

![HTMLダンプ出力ディレクトリ構造](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_RequestUnitTest/htmlDumpDir.png)

<details>
<summary>keywords</summary>

html_dump, html_dump_bk, HTMLダンプ, テスト出力ディレクトリ, バックアップ, tmp/html_dump

</details>
