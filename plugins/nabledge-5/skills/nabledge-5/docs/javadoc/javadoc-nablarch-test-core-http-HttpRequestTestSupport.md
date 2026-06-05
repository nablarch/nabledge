# class HttpRequestTestSupport

**パッケージ:** nablarch.test.core.http

**継承階層:**
```
java.lang.Object
  └─ TestEventDispatcher
      └─ nablarch.test.core.http.HttpRequestTestSupport
```

---

```java
public class HttpRequestTestSupport
extends TestEventDispatcher
```

HTTPリクエストテスト用の基底クラス。

**作成者:** hisaaki sioiri  
**作成者:** Masato Inoue  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### HTML_TYPE

```java
private static final Pattern HTML_TYPE
```

HTMLであることを判定する正規表現

---

### fileSeparator

```java
private static final char fileSeparator
```

ファイルセパレータ

---

### server

```java
private static HttpServer server
```

HttpServer

---

### HTTP_TEST_CONFIGURATION

```java
private static final String HTTP_TEST_CONFIGURATION
```

HttpTestConfigurationのリポジトリキー

---

### handler

```java
private static HttpRequestTestSupportHandler handler
```

request processor handler

---

### servletForwardVerifier

```java
private static ServletForwardVerifier servletForwardVerifier
```

フォワード先検証クラス

---

### SKIP_RESOURCE_COPY

```java
private static final String SKIP_RESOURCE_COPY
```

HTMLリソースコピー抑止システムプロパティ

---

### dbSupport

```java
private final DbAccessTestSupport dbSupport
```

データベースアクセス自動テスト用基底クラス

---

### replaceFiles

```java
private final List<File> replaceFiles
```

静的ファイルコピー時に内容を置き換える対象のファイルリスト

---

### initialized

```java
private static boolean initialized
```

初期化完了フラグ。

---

### DUMP_FILE_KEY

```java
private static final String DUMP_FILE_KEY
```

ExecutionContextにダンプファイルを格納する際に使用するキー

---

### testClass

```java
protected final Class<?> testClass
```

---

### preClassName

```java
private String preClassName
```

前回{@link #execute(Class, String, nablarch.fw.web.HttpRequest, nablarch.fw.ExecutionContext)}が実行された時のクラス名

---

### HTTP_SERVER_FACTORY_KEY

```java
private static final String HTTP_SERVER_FACTORY_KEY
```

---

### jsTestResourcePath

```java
static String jsTestResourcePath
```

---

### CSS_URL_PATTERN

```java
private static final Pattern CSS_URL_PATTERN
```

CSSのurlパターン。

---

### JS_REPLACED_PATTERN

```java
private static final Map<Pattern,String> JS_REPLACED_PATTERN
```

JSの置き換えパターン

---

### ATTACH

```java
private static final String ATTACH
```

マルチパート指定の記法

---

### ATTACH_CLOSE

```java
private static final String ATTACH_CLOSE
```

マルチパート指定の閉じ括弧

---

## コンストラクタの詳細

### HttpRequestTestSupport

```java
public HttpRequestTestSupport(Class<?> testClass)
```

コンストラクタ。

**パラメータ:**
- `testClass` - テストクラス

---

### HttpRequestTestSupport

```java
protected HttpRequestTestSupport()
```

コンストラクタ<br/>
本メソッドはサブクラスから使用されることを想定している。

---

## メソッドの詳細

### execute

```java
protected HttpResponse execute(String caseName, HttpRequest req, ExecutionContext ctx)
```

自動テスト用HTTPサーバを使用して、リクエスト単体テストを実現する。

**パラメータ:**
- `req` - テスト対象のアクションを呼び出すためのHttpRequest
- `caseName` - テストケース名
- `ctx` - ExecutionContext

**戻り値:**
HttpResponse

---

### initializeIfNotYet

```java
protected void initializeIfNotYet(HttpTestConfiguration config, File dumpDir, String className)
```

初回時のみ初期化を実行する。

**パラメータ:**
- `config` - HttpTestConfiguration
- `dumpDir` - HTMLダンプ先のディレクトリ
- `className` - テストクラス

---

### initialize

```java
private void initialize(HttpTestConfiguration config, File dumpDir, String className)
```

初期化する。

**パラメータ:**
- `config` - HttpTestConfiguration
- `dumpDir` - ダンプディレクトリ
- `className` - クラス名

---

### copyHtmlResources

```java
private void copyHtmlResources(HttpTestConfiguration config, File dumpDir)
```

HTMLリソースをコピーする。

**パラメータ:**
- `config` - HttpTestConfiguration
- `dumpDir` - ダンプディレクトリ

---

### isResourceCopySuppressed

```java
private boolean isResourceCopySuppressed()
```

HTMLリソースのコピーを行うかどうか判定する。
システムプロパティの指定により判定する。

**戻り値:**
判定結果

---

### execute

```java
public HttpResponse execute(Class<?> testClass, String caseName, HttpRequest req, ExecutionContext ctx)
```

自動テスト用HTTPサーバを使用して、リクエスト単体テストを実現する。

**パラメータ:**
- `testClass` - テストクラス
- `req` - テスト対象のアクションを呼び出すためのHttpRequest
- `caseName` - テストケース名
- `ctx` - ExecutionContext

**戻り値:**
HttpResponse

---

### checkHtml

```java
void checkHtml(String dumpFilePath, HttpTestConfiguration config)
```

生成されたHtmlファイルのチェックを行う。<br/>
チェックする内容は下記のとおりである。
<ul>
<li>正しい文法に則って記載されていること。</li>
<li>使用を許可されていないタグ・属性が使用されていないこと。</li>
</ul>

**パラメータ:**
- `dumpFilePath` - チェック対象htmlファイルパス
- `config` - HttpTestConfiguration

---

### createHttpServer

```java
protected HttpServer createHttpServer(HttpTestConfiguration config)
```

HttpServerを生成する。

**パラメータ:**
- `config` - HttpTestConfiguration

**戻り値:**
HTTPサーバ

---

### getTestSupportHandler

```java
public static HttpRequestTestSupportHandler getTestSupportHandler()
```

サポートハンドラを取得する。

**戻り値:**
サポートハンドラ

---

### prepareHandlerQueue

```java
protected void prepareHandlerQueue(List<Handler> handlerQueue)
```

ハンドラキューの準備を行う。

**パラメータ:**
- `handlerQueue` - ハンドラキュー

---

### getWarBasePaths

```java
private List<ResourceLocator> getWarBasePaths(HttpTestConfiguration config)
```

Warベースパスを取得する。

**パラメータ:**
- `config` - HttpTestConfiguration

**戻り値:**
Warベースパス

---

### buildWarDirUri

```java
private ResourceLocator buildWarDirUri(String pathToWarDir)
```

WarディレクトリのURIを組み立てる。

**パラメータ:**
- `pathToWarDir` - Warディレクトリへの相対パス

**戻り値:**
URI

---

### createHttpServer

```java
protected HttpServer createHttpServer()
```

HttpServerのインスタンスを生成する。

**戻り値:**
HttpServerのインスタンス

---

### makeDumpDir

```java
private static File makeDumpDir(String className, HttpTestConfiguration config)
```

ダンプファイルの出力ディレクトリを作成する。<br>

**パラメータ:**
- `className` - クラス名
- `config` - HttpTestConfiguration

**戻り値:**
ダンプディレクトリ

---

### copyHtmlResourceToDumpDir

```java
protected void copyHtmlResourceToDumpDir(HttpTestConfiguration config, File destDir, ResourceLocator warBaseLocator)
```

HTMLリソースをダンプファイルの出力ディレクトリへコピーする。

**パラメータ:**
- `config` - HttpTestConfiguration
- `destDir` - 出力ディレクトリ
- `warBaseLocator` - warベースディレクトリのリソースロケータ

---

### deleteHtmlResourceFile

```java
protected void deleteHtmlResourceFile(File srcDir, File destDir)
```

ダンプディレクトリのHTMLリソースファイルを削除する。

**パラメータ:**
- `srcDir` - HTMLリソースフォルダ
- `destDir` - HTMLリソースのコピーフォルダ

---

### rewriteResourceFile

```java
protected void rewriteResourceFile(HttpTestConfiguration config, File dumpDir, ResourceLocator warBaseLocator)
```

HTMLリソースディレクトリ内のCSSファイルを置換する。

<p>
出力したCSSファイルのタイムスタンプには、出力元CSSファイルのタイムスタンプを設定する。
次回、出力時にはタイムスタンプに変更がない限り、出力は行わない。

**パラメータ:**
- `config` - HttpTestConfiguration
- `dumpDir` - 出力先ディレクトリ
- `warBaseLocator` - warベースのリソースロケータ

---

### rewritePath

```java
protected String rewritePath(String text, String replaceAbsolutePath)
```

静的リソース内のパスを置き換える。

**パラメータ:**
- `text` - 文字列
- `replaceAbsolutePath` - ファイルの絶対パスからwarのルートパスを取り除いたパス。

**戻り値:**
置換後の文字列

---

### getAbsoluteCssUriPrefix

```java
protected String getAbsoluteCssUriPrefix(String uri, String replaceAbsolutePath)
```

URI型の絶対パス参照文字列から、URIのプレフィックスを取得する。

**パラメータ:**
- `uri` - URI型の絶対パス参照文字列
- `replaceAbsolutePath` - HTMLリソースの絶対パスからwarのルートパスを取り除いたパス。

**戻り値:**
URIのプレフックス

---

### getDepth

```java
private int getDepth(String replaceAbsolutePath)
```

warのルートパスからのHTMLリソースの深さを取得する。
深さを判別するための区切り文字は、システムプロパティから取得する。

**パラメータ:**
- `replaceAbsolutePath` - HTMLリソースの絶対パスからwarのルートパスを取り除いたパス。

**戻り値:**
warのルートパスからの深さ

---

### getFileFilter

```java
protected FileFilter getFileFilter(HttpTestConfiguration config)
```

FileFilterを取得する。

**パラメータ:**
- `config` - HttpTestConfiguration

**戻り値:**
FileFilter

---

### setHttpHeader

```java
protected static void setHttpHeader(HttpRequest req, HttpTestConfiguration config)
```

HTTPHeaderを設定する。<br>
すでにHttpRequestに設定されている項目は、設定しない。

**パラメータ:**
- `req` - HTTPHeaderを設定するHttpRequest
- `config` - HttpTestConfiguration

---

### assertForward

```java
public void assertForward(String msg, String expectedUri)
```

フォワード先URIが想定通りであることを表明する。

**パラメータ:**
- `msg` - アサート失敗時のメッセージ
- `expectedUri` - 期待するフォワード先URI

---

### assertStatusCode

```java
protected void assertStatusCode(String message, int expected, HttpResponse response)
```

ステータスコードが想定通りであることを表明する。<br/>

<p>
内蔵サーバから戻り値で返却されたHTTPレスポンスがリダイレクトである場合、
ステータスコードが303または302であることを表明する。
このとき、内蔵サーバから返却されるHTTPレスポンスと比較しないのは、後方互換性を保つためである。
（内蔵サーバは、リダイレクト時のステータスコードに'302 FOUND'を使用する）

<p>
上記以外の場合は、{@link HttpRequestTestSupportHandler#getStatusCode()}
のステータスコードを比較対象とする。

**パラメータ:**
- `message` - アサート失敗時のメッセージ
- `expected` - 期待するステータスコード値
- `response` - HTTPレスポンス

---

### is3XXStatusCode

```java
public boolean is3XXStatusCode(int statusCode)
```

300系の HTTP ステータスコードかどうか判定する

**パラメータ:**
- `statusCode` - 判定対象のHTTPステータスコード

**戻り値:**
300系の HTTP ステータスコードであれば true

---

### assertApplicationMessageId

```java
public void assertApplicationMessageId(String expectedCommaSeparated, ExecutionContext actual)
```

メッセージIDのアサートを行う。<br>

**パラメータ:**
- `expectedCommaSeparated` - 期待するメッセージID（カンマ区切り）
- `actual` - 実行結果(メッセージIDをリクエストスコープにもつExecutionContext)

---

### assertApplicationMessageId

```java
public void assertApplicationMessageId(String msg, String expectedCommaSeparated, ExecutionContext actual)
```

メッセージIDのアサートを行う。<br>

**パラメータ:**
- `msg` - 任意のメッセージ
- `expectedCommaSeparated` - 期待するメッセージID（カンマ区切り）
- `actual` - 実行結果(メッセージIDをリクエストスコープにもつExecutionContext)

---

### splitAndTrim

```java
private String[] splitAndTrim(String commaSeparated)
```

指定された文字列をカンマ(,)で分割し各要素をトリムする。

**パラメータ:**
- `commaSeparated` - カンマ区切り文字列

**戻り値:**
変換した配列（引数がnullまたは空文字列の場合には、サイズ0の配列）

---

### trim

```java
private void trim(String[] array)
```

配列の各要素をトリムする(破壊的メソッド)。

**パラメータ:**
- `array` - 配列

---

### assertApplicationMessageId

```java
public void assertApplicationMessageId(String[] expected, ExecutionContext actual)
```

メッセージIDのアサートを行う。<br>

**パラメータ:**
- `expected` - 期待するメッセージIDの配列
- `actual` - 実行結果(メッセージIDをリクエストスコープにもつExecutionContext)

---

### assertApplicationMessageId

```java
public void assertApplicationMessageId(String msg, String[] expected, ExecutionContext actual)
```

メッセージIDのアサートを行う。<br>

**パラメータ:**
- `msg` - 任意のメッセージ
- `expected` - 期待するメッセージIDの配列
- `actual` - 実行結果(メッセージIDをリクエストスコープにもつExecutionContext)

---

### backupDumpFile

```java
private static void backupDumpFile(HttpTestConfiguration config)
```

ダンプファイルをバックアップする。

**パラメータ:**
- `config` - HttpsConfigurator

---

### deleteBackupFile

```java
private static void deleteBackupFile(File target)
```

delete from backup file.

**パラメータ:**
- `target` - target file

---

### setValidToken

```java
public void setValidToken(HttpRequest request, ExecutionContext context)
```

有効なトークンをリクエストパラメータとセッションスコープに設定する。<br/>
二重サブミットを防止しているアクションのメソッドをテストする場合は、このメソッドを呼び出しトークンを設定する。

**パラメータ:**
- `request` - テスト対象のアクションを呼び出すためのHttpRequest
- `context` - ExecutionContext

---

### setToken

```java
public void setToken(HttpRequest request, ExecutionContext context, boolean valid)
```

トークンをリクエストパラメータとセッションスコープに設定する。<br/>
引数validが真の場合、有効なトークンを設定する。偽の場合はトークンを無効にする。

**パラメータ:**
- `request` - テスト対象のアクションを呼び出すためのHttpRequest
- `context` - ExecutionContext
- `valid` - 有効なトークンを設定するかどうか

---

### createHttpRequest

```java
public HttpRequest createHttpRequest(String requestUri, String httpMethod, Map<String,String[]> params)
```

リクエストパラメータを作成する。

**パラメータ:**
- `requestUri` - リクエストURI
- `httpMethod` - HTTPメソッド
- `params` - パラメータが格納されたMap

**戻り値:**
リクエストパラメータ

---

### createHttpRequest

```java
public HttpRequest createHttpRequest(String requestUri, Map<String,String[]> params)
```

リクエストパラメータを作成する。

**パラメータ:**
- `requestUri` - リクエストURI
- `params` - パラメータが格納されたMap

**戻り値:**
リクエストパラメータ

---

### extractMultipart

```java
private PartInfoHolder extractMultipart(Map<String,String[]> params)
```

マルチパートの抽出を行う。

**パラメータ:**
- `params` - リクエストパラメータのテストデータ

**戻り値:**
抽出されたマルチパート

---

### isAttached

```java
private boolean isAttached(String value)
```

テストデータの値がアップロード用の情報であるかどうか判定する

**パラメータ:**
- `value` - テストデータ

**戻り値:**
{@literal ${attach:ファイル名}}に合致する場合、真

---

### extractFileName

```java
private String extractFileName(String value)
```

ファイル名を抽出する。

**パラメータ:**
- `value` - パラメータの値

**戻り値:**
抽出されたファイル名

---

### createPartInfo

```java
private PartInfo createPartInfo(String name, String fileName)
                        throws IllegalStateException
```

マルチパート情報を作成する。

**パラメータ:**
- `name` - name属性
- `fileName` - ファイル名

**戻り値:**
作成したインスタンス

**例外:**
- `IllegalStateException` - アップロードファイルが存在しない場合

---

### createHttpRequestWithConversion

```java
public HttpRequest createHttpRequestWithConversion(String requestUri, String httpMethod, Map<String,String> commaSeparated, Map<String,String> cookie, Map<String,String> queryParams)
```

---

### appendQueryParamsToUri

```java
private String appendQueryParamsToUri(String uri, Map<String,String> queryParams)
```

クエリパラメータをURIに追加する。

**パラメータ:**
- `uri` - リクエストURI
- `queryParams` - クエリパラメータのマップ

**戻り値:**
クエリパラメータが追加されたURI

---

### encode

```java
private String encode(String rawString)
```

文字列をパーセントエンコーディングする。

**パラメータ:**
- `rawString` - エンコード前文字列

**戻り値:**
エンコード後文字列

---

### createHttpRequestWithConversion

```java
public HttpRequest createHttpRequestWithConversion(String requestUri, Map<String,String> commaSeparated, Map<String,String> cookie)
```

リクエストパラメータを作成する。

**パラメータ:**
- `requestUri` - リクエストURI
- `commaSeparated` - パラメータが格納されたMap
- `cookie` - Cookie情報が格納されたMap

**戻り値:**
リクエストパラメータ

---

### createHttpRequestWithConversion

```java
public HttpRequest createHttpRequestWithConversion(String requestUri, String httpMethod, Map<String,String> commaSeparated, Map<String,String> cookie)
```

リクエストパラメータを作成する。

**パラメータ:**
- `requestUri` - リクエストURI
- `httpMethod` - HTTPメソッド
- `commaSeparated` - パラメータが格納されたMap
- `cookie` - Cookie情報が格納されたMap

**戻り値:**
リクエストパラメータ

---

### createExecutionContext

```java
public ExecutionContext createExecutionContext(String userId)
```

{@link ExecutionContext}を生成する。

**パラメータ:**
- `userId` - セッションスコープに格納するユーザID

**戻り値:**
生成したExecutionContext

---

### getConfig

```java
private HttpTestConfiguration getConfig()
```

リクエスト単体テスト用のコンフィギュレーションを取得する。

**戻り値:**
コンフィギュレーション

---

### getDumpFile

```java
protected File getDumpFile(ExecutionContext ctx)
```

HTTPレスポンスボディが出力されたファイルを取得する。

**パラメータ:**
- `ctx` - ExecutionContext

**戻り値:**
ファイル。HTTPダンプ出力が無効な場合はnull

---

### setDumpFile

```java
protected void setDumpFile(ExecutionContext ctx, File file)
```

HTTPレスポンスボディが出力されたファイルを設定する。

**パラメータ:**
- `ctx` - ExecutionContext
- `file` - ファイル

---

### setUpDb

```java
public void setUpDb(String sheetName)
```

{@link nablarch.test.core.db.DbAccessTestSupport#setUpDb(String)}への委譲メソッド。

**パラメータ:**
- `sheetName` - シート名

---

### setUpDb

```java
public void setUpDb(String sheetName, String groupId)
```

{@link nablarch.test.core.db.DbAccessTestSupport#setUpDb(String, String)}への委譲メソッド。

**パラメータ:**
- `sheetName` - シート名
- `groupId` - グループID

---

### assertSqlResultSetEquals

```java
public void assertSqlResultSetEquals(String message, String sheetName, String id, SqlResultSet actual)
```

{@link nablarch.test.core.db.DbAccessTestSupport#assertSqlResultSetEquals(String, String, String, nablarch.core.db.statement.SqlResultSet)}
への委譲メソッド。

**パラメータ:**
- `message` - 比較失敗時のメッセージ
- `sheetName` - 期待値を格納したシート名
- `id` - シート内のデータを特定するためのID
- `actual` - 実際の値

---

### assertSqlRowEquals

```java
public void assertSqlRowEquals(String message, String sheetName, String id, SqlRow actual)
```

{@link nablarch.test.core.db.DbAccessTestSupport#assertSqlRowEquals(String, String, String, nablarch.core.db.statement.SqlRow)}
への委譲メソッド。

**パラメータ:**
- `message` - 比較失敗時のメッセージ
- `sheetName` - 期待値を格納したシート名
- `id` - シート内のデータを特定するためのID
- `actual` - 実際の値

---

### getListMap

```java
public List<Map<String,String>> getListMap(String sheetName, String id)
```

{@link nablarch.test.core.db.DbAccessTestSupport#getListMap(String, String)}への委譲メソッド。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
List-Map形式のデータ

---

### getListParamMap

```java
public List<Map<String,String[]>> getListParamMap(String sheetName, String id)
```

{@link nablarch.test.core.db.DbAccessTestSupport#getListParamMap(String, String)}への委譲メソッド。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
List-Map<String, String[]>形式のデータ

---

### getParamMap

```java
public Map<String,String[]> getParamMap(String sheetName, String id)
```

{@link nablarch.test.core.db.DbAccessTestSupport#getParamMap(String, String)}への委譲メソッド。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
Map<String,String[]>形式のデータ

---

### assertTableEquals

```java
public void assertTableEquals(String sheetName)
```

{@link nablarch.test.core.db.DbAccessTestSupport#assertTableEquals(String)}への委譲メソッド。

**パラメータ:**
- `sheetName` - 期待値を格納したシート名

---

### assertTableEquals

```java
public void assertTableEquals(String sheetName, String groupId)
```

{@link nablarch.test.core.db.DbAccessTestSupport#assertTableEquals(String, String)}への委譲メソッド。

**パラメータ:**
- `sheetName` - 期待値を格納したシート名
- `groupId` - グループID（オプション）

---

### assertTableEquals

```java
public void assertTableEquals(String message, String sheetName, String groupId)
```

{@link nablarch.test.core.db.DbAccessTestSupport#assertTableEquals(String, String, String)} への委譲メソッド。

**パラメータ:**
- `message` - 比較失敗時のメッセージ
- `groupId` - グループID（オプション）
- `sheetName` - 期待値を格納したシート名

---

### assertEntity

```java
public void assertEntity(String sheetName, String id, Object actual)
```

{@link nablarch.test.core.db.EntityTestSupport#assertGetterMethod(String, String, Object)}への移譲メソッド。

**パラメータ:**
- `sheetName` - シート名
- `id` - ケース表のID(LIST_MAP=testの場合は、testを指定する。)
- `actual` - 実行結果のオブジェクト(Java Beansオブジェクト)

---

### assertObjectPropertyEquals

```java
public void assertObjectPropertyEquals(String message, String sheetName, String id, Object actual)
```

Object に設定されたプロパティをアサートする。 <br />
チェック条件の詳細は {@link nablarch.test.Assertion#assertProperties(java.util.Map, Object)} を参照。

**パラメータ:**
- `message` - メッセージ
- `sheetName` - シート名
- `id` - ケース表のID(LIST_MAP=testの場合は、testを指定する。)
- `actual` - 実際の値

---

### assertObjectArrayPropertyEquals

```java
public void assertObjectArrayPropertyEquals(String message, String sheetName, String id, Object[] actual)
```

Object配列に設定されたプロパティをアサートする。 <br />
チェック条件の詳細は {@link nablarch.test.Assertion#assertProperties(java.util.Map, Object)} を参照。

**パラメータ:**
- `message` - メッセージ
- `sheetName` - シート名
- `id` - ケース表のID(LIST_MAP=testの場合は、testを指定する。)
- `actual` - 実際の値

---

### assertObjectListPropertyEquals

```java
public void assertObjectListPropertyEquals(String message, String sheetName, String id, List<?> actual)
```

Object に設定されたプロパティをアサートする。 <br />
チェック条件の詳細は {@link nablarch.test.Assertion#assertProperties(java.util.Map, Object)} を参照。

**パラメータ:**
- `message` - メッセージ
- `sheetName` - シート名
- `id` - ケース表のID(LIST_MAP=testの場合は、testを指定する。)
- `actual` - 実際の値

---

### resetHttpServer

```java
public static void resetHttpServer()
```

キャッシュした HttpServer をリセットする。

---

### getParamMap

```java
public Map<String,String[]> getParamMap(HttpRequest request)
```

{@link HttpRequest#getParamMap()}を呼び出す。

**パラメータ:**
- `request` - HTTPリクエスト

**戻り値:**
リクエストパラメータのMap

---

### getParam

```java
public String[] getParam(HttpRequest request, String name)
```

{@link HttpRequest#getParam(String)}を呼び出す。

**パラメータ:**
- `request` - HTTPリクエスト
- `name` - パラメータ名

**戻り値:**
リクエストパラメータの値

---
