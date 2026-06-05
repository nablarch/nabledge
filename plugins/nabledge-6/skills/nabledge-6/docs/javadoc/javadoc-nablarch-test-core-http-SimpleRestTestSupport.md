# class SimpleRestTestSupport

**パッケージ:** nablarch.test.core.http

**継承階層:**
```
java.lang.Object
  └─ TestEventDispatcher
      └─ nablarch.test.core.http.SimpleRestTestSupport
```

---

```java
public class SimpleRestTestSupport
extends TestEventDispatcher
```

RESTfulウェブサービス用のテストサポートクラス

---

## フィールドの詳細

### REST_TEST_CONFIGURATION_KEY

```java
private static final String REST_TEST_CONFIGURATION_KEY
```

RestTestConfigurationのリポジトリキー

---

### HTTP_REQUEST_BUILDER_KEY

```java
private static final String HTTP_REQUEST_BUILDER_KEY
```

RestMockHttpRequestBuilderのリポジトリキー

---

### HTTP_SERVER_FACTORY_KEY

```java
private static final String HTTP_SERVER_FACTORY_KEY
```

HTTPサーバファクトリのリポジトリキー

---

### DEFAULT_PROCESSOR_KEY

```java
private static final String DEFAULT_PROCESSOR_KEY
```

デフォルトプロセッサのリポジトリキー

---

### server

```java
private static HttpServer server
```

内蔵サーバ

---

### handler

```java
private static HttpRequestTestSupportHandler handler
```

テスト用ハンドラ

---

### initialized

```java
private static boolean initialized
```

初期化済みか否か（static）

---

### defaultProcessor

```java
private RequestResponseProcessor defaultProcessor
```

デフォルトのプロセッサ *

---

### NOP_PROCESSOR

```java
private static final RequestResponseProcessor NOP_PROCESSOR
```

リクエスト・レスポンスともに何もしないプロセッサ *

---

### testDescription

```java
public TestDescription testDescription
```

実行中のテストクラスとメソッド名を保持する

---

## メソッドの詳細

### setUp

```java
public void setUp()
```

システムリポジトリから設定を取得しHTTPサーバを起動する。

---

### setupDefaultProcessor

```java
private void setupDefaultProcessor()
```

デフォルト{@link RequestResponseProcessor}を設定する。
SystemRepositoryに登録されていない場合は何もしない{@link RequestResponseProcessor}を設定する。

---

### getHttpRequestBuilder

```java
public RestMockHttpRequestBuilder getHttpRequestBuilder()
```

システムリポジトリから{@link RestMockHttpRequestBuilder}を取得する。

**戻り値:**
取得した{@link RestMockHttpRequestBuilder}

---

### newRequest

```java
public RestMockHttpRequest newRequest(String httpMethod, String uri)
```

任意のHTTPメソッドで{@link RestMockHttpRequest}を生成する。

**パラメータ:**
- `httpMethod` - HTTPメソッド
- `uri` - リクエストURI

**戻り値:**
生成された{@link RestMockHttpRequest}

---

### get

```java
public RestMockHttpRequest get(String uri)
```

GETのHTTPメソッドで{@link RestMockHttpRequest}を生成する。

**パラメータ:**
- `uri` - リクエストURI

**戻り値:**
生成された{@link RestMockHttpRequest}

---

### post

```java
public RestMockHttpRequest post(String uri)
```

POSTのHTTPメソッドで{@link RestMockHttpRequest}を生成する。

**パラメータ:**
- `uri` - リクエストURI

**戻り値:**
生成された{@link RestMockHttpRequest}

---

### put

```java
public RestMockHttpRequest put(String uri)
```

PUTのHTTPメソッドで{@link RestMockHttpRequest}を生成する。

**パラメータ:**
- `uri` - リクエストURI

**戻り値:**
生成された{@link RestMockHttpRequest}

---

### delete

```java
public RestMockHttpRequest delete(String uri)
```

DELETEのHTTPメソッドで{@link RestMockHttpRequest}を生成する。

**パラメータ:**
- `uri` - リクエストURI

**戻り値:**
生成された{@link RestMockHttpRequest}

---

### patch

```java
public RestMockHttpRequest patch(String uri)
```

PATCHのHTTPメソッドで{@link RestMockHttpRequest}を生成する。

**パラメータ:**
- `uri` - リクエストURI

**戻り値:**
生成された{@link RestMockHttpRequest}

---

### sendRequest

```java
public HttpResponse sendRequest(HttpRequest request)
```

テストリクエストを内蔵サーバに渡しレスポンスを返す。

**パラメータ:**
- `request` - テストリクエスト

**戻り値:**
内蔵サーバのレスポンス

---

### sendRequest

```java
public HttpResponse sendRequest(HttpRequest request, RequestResponseProcessor processor)
```

テストリクエストを内蔵サーバに渡しレスポンスを返す。

**パラメータ:**
- `request` - テストリクエスト
- `processor` - リクエスト・レスポンスに追加処理を実行するプロセッサー

**戻り値:**
内蔵サーバのレスポンス

---

### sendRequestWithContext

```java
public HttpResponse sendRequestWithContext(HttpRequest request, ExecutionContext context)
```

{@link ExecutionContext}を設定しテストリクエストを内蔵サーバに渡しレスポンスを返す。
{@link ExecutionContext}の設定は{@link HttpRequestTestSupportHandler}を利用する。

**パラメータ:**
- `request` - テストリクエスト
- `context` - 実行コンテキスト

**戻り値:**
内蔵サーバのレスポンス

---

### sendRequestWithContext

```java
public HttpResponse sendRequestWithContext(HttpRequest request, ExecutionContext context, RequestResponseProcessor processor)
```

{@link ExecutionContext}を設定しテストリクエストを内蔵サーバに渡しレスポンスを返す。
{@link ExecutionContext}の設定は{@link HttpRequestTestSupportHandler}を利用する。

**パラメータ:**
- `request` - テストリクエスト
- `context` - 実行コンテキスト
- `processor` - リクエスト・レスポンスに追加処理を実行するプロセッサー

**戻り値:**
内蔵サーバのレスポンス

---

### initializeIfNotYet

```java
private static void initializeIfNotYet(RestTestConfiguration config)
```

初回の場合、内臓サーバを起動する。

**パラメータ:**
- `config` - 設定定義

---

### resetHttpServer

```java
public static void resetHttpServer()
```

キャッシュした HttpServer をリセットする。

---

### createHttpServer

```java
private static void createHttpServer(RestTestConfiguration config)
```

HttpServerを生成する。

**パラメータ:**
- `config` - 設定定義

---

### getWarBasePaths

```java
private static List<ResourceLocator> getWarBasePaths(RestTestConfiguration config)
```

Warベースパスを取得する。

**パラメータ:**
- `config` - 設定定義

**戻り値:**
Warベースパス

---

### createHttpServer

```java
private static HttpServer createHttpServer()
```

HttpServerのインスタンスを生成する。

**戻り値:**
HttpServerのインスタンス

---

### assertStatusCode

```java
public void assertStatusCode(String message, HttpResponse.Status expected, HttpResponse response)
```

ステータスコードが想定通りであることを表明する。

**パラメータ:**
- `message` - アサート失敗時のメッセージ
- `expected` - 期待するステータス
- `response` - HTTPレスポンス

---

### assertStatusCode

```java
public void assertStatusCode(String message, int expected, HttpResponse response)
```

ステータスコードが想定通りであることを表明する。

**パラメータ:**
- `message` - アサート失敗時のメッセージ
- `expected` - 期待するステータスコード値
- `response` - HTTPレスポンス

---

### readTextResource

```java
protected String readTextResource(String fileName)
```

テストクラスと同じパッケージにあるファイルを読み込み文字列を返す。

**パラメータ:**
- `fileName` - 読み込むファイル名

**戻り値:**
ファイル内容の文字列

---

### readTextResource

```java
public String readTextResource(Class<?> testClass, String fileName)
```

指定したテストクラスと同じパッケージにあるファイルを読み込み文字列を返す。

**パラメータ:**
- `testClass` - テストクラス
- `fileName` - 読み込むファイル名

**戻り値:**
ファイル内容の文字列

---

### getUrl

```java
private URL getUrl(Class<?> testClass, String fileName)
```

ファイルのURLを取得する。

**パラメータ:**
- `testClass` - テストクラス
- `fileName` - 対象のファイル名

**戻り値:**
ファイルのURL

---

### read

```java
protected String read(File file)
            throws IOException
```

ファイルを読み込みStringを返す。

**パラメータ:**
- `file` - 読み込むファイル

**戻り値:**
ファイル内容の文字列

**例外:**
- `IOException` - 読み込み失敗時の例外

---

### createNoComponentMessage

```java
protected static String createNoComponentMessage(String componentKey)
```

コンポーネントが見つからない場合のエラーメッセージを組み立てる。

**パラメータ:**
- `componentKey` - コンポーネントのキー

**戻り値:**
エラーメッセージ

---
