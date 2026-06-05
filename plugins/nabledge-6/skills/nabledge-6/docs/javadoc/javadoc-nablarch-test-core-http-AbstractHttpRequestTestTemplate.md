# class AbstractHttpRequestTestTemplate

**パッケージ:** nablarch.test.core.http

**継承階層:**
```
java.lang.Object
  └─ HttpRequestTestSupport
      └─ nablarch.test.core.http.AbstractHttpRequestTestTemplate
```

---

```java
public abstract class AbstractHttpRequestTestTemplate
extends HttpRequestTestSupport
```

リクエスト単体テストをテンプレート化するクラス。<br/>
本クラスを使用することで、リクエスト単体テストのテストソース、テストデータを 定型化することができる。
<p/>
<pre>
指定されたテストシートに定義されたテストを実行する.<br/>
実行順序は以下のとおり。
1. データシートからテストケースリスト(testCases LISTMAP）を取得
2. 取得したテストケース分、以下を繰り返し実行
   1) データベース初期化
   2) ExecutionContext、HTTPリクエストを生成
   3) 業務テストコード用拡張ポイント呼出(beforeExecuteRequestメソッド）
   4) Tokenが必要な場合、Tokenを設定
   5) テスト対象のリクエスト実行
   6) 実行結果の検証
     ・HTTPステータスコード および メッセージID
     ・HTTPレスポンス値(リクエストスコープ値)
     ・検索結果
     ・テーブル更新結果
     ・フォワード先URI
     ・メッセージ同期送信で送信されたメッセージ
   7) 業務テストコード用拡張ポイント呼出(afterExecuteRequestメソッド）

※セッションスコープは原則利用しないため検証しない。
　必要な場合afterExecuteRequestメソッドを拡張して検証すること。
</pre>
<p/>
テンプレートの拡張が可能となるよう、{@link TestCaseInfo}の型を総称化している。 {@link TestCaseInfo}
のサブクラスを作成し、本クラスのサブクラスでその型を指定することで、テンプレートを拡張できる。 以下に例を示す。 <code>
<pre>
public abstract class SpecialHttpRequestTestTemplate extends AbstractHttpRequestTestTemplate<SpecialTestCaseInfo> {
</pre>
</code>

**param:** テストケース情報の型  
**作成者:** Tsuyoshi Kawasaki  

---

## フィールドの詳細

### SETUP_TABLE_SHEET

```java
private static final String SETUP_TABLE_SHEET
```

テストクラス共通データを定義しているシート名

---

### TEST_SHOTS_LIST_MAP

```java
private static final String TEST_SHOTS_LIST_MAP
```

テストショットのLIST_MAP定義名

---

### TEST_CASES_LIST_MAP

```java
private static final String TEST_CASES_LIST_MAP
```

テストケースのLIST_MAP定義名（互換性維持の為）

---

### REQUEST_PARAMS_LIST_MAP

```java
private static final String REQUEST_PARAMS_LIST_MAP
```

リクエストパラメータのLIST_MAP定義名

---

### EXPECTED_RESPONSE_LIST_MAP

```java
private static final String EXPECTED_RESPONSE_LIST_MAP
```

レスポンス期待値を定義しているLIST_MAP定義名

---

### ASSERT_SKIP_EXPECTED_COLUMNS

```java
private static final List<String> ASSERT_SKIP_EXPECTED_COLUMNS
```

Assert対象から除外するカラム

---

### listMapCache

```java
private final Map<String,List<Map<String,String>>> listMapCache
```

LIST_MAPキャッシュ

---

### nopAdvice

```java
private final Advice<INF> nopAdvice
```

何も行わない{@link Advice}実装。

---

### fileSupport

```java
private final FileSupport fileSupport
```

ファイルサポート（ファイルアップロード用に使用する）

---

## コンストラクタの詳細

### AbstractHttpRequestTestTemplate

```java
protected AbstractHttpRequestTestTemplate()
```

コンストラクタ。

---

### AbstractHttpRequestTestTemplate

```java
public AbstractHttpRequestTestTemplate(Class<?> testClass)
```

コンストラクタ。

**パラメータ:**
- `testClass` - テストクラス

---

## メソッドの詳細

### execute

```java
public void execute()
```

テストを実行する。<br/>
実行前後に特別な処理が不要な場合は、このメソッドを使用する。

---

### execute

```java
public void execute(String sheetName)
```

テストを実行する。<br/>
実行前後に特別な処理が不要な場合は、このメソッドを使用する。

**パラメータ:**
- `sheetName` - テスト対象のシート名

---

### execute

```java
public void execute(boolean shouldSetUpDb)
```

テストを実行する。
データベースのセットアップ要否を指定できる。

**パラメータ:**
- `shouldSetUpDb` - データベースのセットアップ要否

---

### execute

```java
public void execute(String sheetName, boolean shouldSetUpDb)
```

テストを実行する。
データベースのセットアップ要否を指定できる。

**パラメータ:**
- `sheetName` - シート名
- `shouldSetUpDb` - データベースのセットアップ要否

---

### execute

```java
public void execute(Advice<INF> advice)
```

テストを実行する。
テスト前後に特別な準備処理や結果確認処理が必要な場合はこのメソッドを使用する。

**パラメータ:**
- `advice` - 実行前後の処理を実装した{@link Advice}

---

### execute

```java
public void execute(String sheetName, Advice<INF> advice)
```

テストを実行する。
テスト前後に特別な準備処理や結果確認処理が必要な場合はこのメソッドを使用する。

**パラメータ:**
- `sheetName` - テスト対象シート名
- `advice` - 実行前後の処理を実装した{@link Advice}

---

### execute

```java
public void execute(Advice<INF> advice, boolean shouldSetUpDb)
```

テストを実行する。

**パラメータ:**
- `advice` - コールバック
- `shouldSetUpDb` - データベースのセットアップ要否

---

### execute

```java
public void execute(String sheetName, Advice<INF> advice, boolean shouldSetUpDb)
```

テストを実行する。

**パラメータ:**
- `sheetName` - シート名
- `advice` - コールバック
- `shouldSetUpDb` - データベースのセットアップ要否

---

### getTestCases

```java
private List<Map<String,String>> getTestCases(String sheetName)
```

テストケース一覧を取得する。<br/>
テストケース一覧は必須である為、取得できない場合は例外が発生する。

**パラメータ:**
- `sheetName` - 取得先のシート名

**戻り値:**
テストケース一覧

---

### executeTestCase

```java
protected void executeTestCase(String sheetName, Map<String,String> testCaseParams, Advice<INF> advice)
```

テストケースを実行する。

**パラメータ:**
- `sheetName` - シート名
- `testCaseParams` - テストケースパラメータ
- `advice` - 実行前後の処理を実装した{@link Advice}

---

### clearPreviousTestData

```java
protected void clearPreviousTestData(INF testCaseInfo)
```

テストで使用するデータのキャッシュをクリアする

**パラメータ:**
- `testCaseInfo` - テストケース情報

---

### setUp

```java
protected void setUp(INF testCaseInfo, Map<String,String> testCaseParams)
```

準備を行う。

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `testCaseParams` - テストケースパラメータ

---

### setUpDbForTestCase

```java
protected void setUpDbForTestCase(INF testCaseInfo)
```

テストケース毎のデータベースセットアップを行う。

**パラメータ:**
- `testCaseInfo` - テストケース情報

---

### setUpMessage

```java
protected void setUpMessage(INF testCaseInfo, Map<String,String> testCaseParams)
```

メッセージ同期送信のリクエスト単体テストを実行するための準備を行う

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `testCaseParams` - テストケースパラメータ

---

### createTestCaseInfo

```java
protected INF createTestCaseInfo(String sheetName, Map<String,String> testCaseParams)
```

テストケース情報を作成する。

**パラメータ:**
- `sheetName` - シート名
- `testCaseParams` - テストケースパラメータ

**戻り値:**
作成したテストケース情報

---

### createTestCaseInfo

```java
protected INF createTestCaseInfo(String sheetName, Map<String,String> testCaseParams, List<Map<String,String>> contexts, List<Map<String,String>> requests, List<Map<String,String>> expectedResponses, List<Map<String,String>> cookie, List<Map<String,String>> queryParams)
```

テストケース情報を作成する。

**パラメータ:**
- `sheetName` - シート名
- `testCaseParams` - テストケースパラメータ
- `contexts` - コンテキスト全件
- `requests` - リクエスト全件
- `expectedResponses` - 期待するレスポンス全件
- `cookie` - 本テストで使用するクッキー情報
- `queryParams` - 本テストで使用するクエリパラメータ情報

**戻り値:**
作成したテストケース情報

---

### createTestCaseInfo

```java
protected INF createTestCaseInfo(String sheetName, Map<String,String> testCaseParams, List<Map<String,String>> contexts, List<Map<String,String>> requests, List<Map<String,String>> expectedResponses, List<Map<String,String>> cookie)
```

テストケース情報を作成する。

**パラメータ:**
- `sheetName` - シート名
- `testCaseParams` - テストケースパラメータ
- `contexts` - コンテキスト全件
- `requests` - リクエスト全件
- `expectedResponses` - 期待するレスポンス全件
- `cookie` - 本テストで使用するクッキー情報

**戻り値:**
作成したテストケース情報

---

### createExecutionContext

```java
protected ExecutionContext createExecutionContext(INF testCaseInfo)
```

ExecutionContextを生成する。

**パラメータ:**
- `testCaseInfo` - テスト情報

**戻り値:**
ExecutionContextインスタンス

---

### createHttpRequest

```java
protected HttpRequest createHttpRequest(INF testCaseInfo)
```

HTTPRequestパラメータを生成する。

**パラメータ:**
- `testCaseInfo` - テスト情報

**戻り値:**
HttpRequestインスタンス

---

### assertAll

```java
protected void assertAll(INF testCaseInfo, Map<String,String> testCaseParams, ExecutionContext context, HttpResponse response)
```

全アサートを実行する。<br/>
以下の項目についてアサートを実施する。
<ul>
<li>HTTPステータスコードおよびメッセージID</li>
<li>リクエストスコープの値検証</li>
<li>検索結果の検証</li>
<li>テーブル更新結果の検証</li>
<li>フォワード先URI</li>
<li>メッセージ同期送信で送信されたメッセージ</li>
</ul>

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `testCaseParams` - テストケースパラメータ
- `context` - ExecutionContextインスタンス
- `response` - HttpResponseインスタンス

---

### assertResponse

```java
protected void assertResponse(INF testCaseInfo, HttpResponse response)
```

HTTPレスポンスオブジェクトの内容をアサートする。

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `response` - レスポンスオブジェクト

---

### assertContentLength

```java
protected void assertContentLength(INF testCaseInfo, ExecutionContext context)
```

コンテンツレングス・ヘッダの値をアサートする。

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `context` - ExecutionContext

---

### assertContentType

```java
protected void assertContentType(INF testCaseInfo, HttpResponse response)
```

コンテンツタイプ・ヘッダの値をアサートする。

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `response` - HTTPレスポンス

---

### assertContentFileName

```java
protected void assertContentFileName(INF testCaseInfo, HttpResponse response, ExecutionContext context)
```

コンテンツディスポジション・ヘッダに指定されたファイル名をアサートする。
<p/>
コンテンツタイプがHTMLの場合はアサートしない。

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `response` - HTTPレスポンス
- `context` - ExecutionContext

---

### assertForwardUri

```java
protected void assertForwardUri(INF testCaseInfo)
```

フォワード先URIをアサートする。

**パラメータ:**
- `testCaseInfo` - テストケース情報

---

### getValue

```java
private String getValue(Map<String,String> row, String columnName)
```

LIST_MAPから取得したレコードから、指定したカラム名に対応する値を取得する<br/>

**パラメータ:**
- `row` - 行レコード(LIST_MAPの各要素）
- `columnName` - カラム名

**戻り値:**
指定したカラム名に対応する値

---

### getCachedListMap

```java
protected List<Map<String,String>> getCachedListMap(String sheetName, String listMapName)
```

キャッシュからLIST_MAPを取得する。<br/>
キャッシュにない場合は、データシートから取得しメモリ上にキャッシュする。

**パラメータ:**
- `sheetName` - データシート名
- `listMapName` - LIST_MAP名

**戻り値:**
LIST_MAP

---

### assertApplicationMessageId

```java
private void assertApplicationMessageId(INF testCaseInfo, ExecutionContext context)
```

メッセージIDの検証を行う。

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `context` - ExecutionContextインスタンス

---

### assertRequestScopeVar

```java
private void assertRequestScopeVar(INF testCaseInfo, ExecutionContext context)
```

リクエストスコープの値と期待値を比較検証する。

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `context` - ExecutionContextインスタンス

---

### assertSqlResultSet

```java
private void assertSqlResultSet(INF testCaseInfo, ExecutionContext context)
```

検索結果(SQLResultSet)を期待値と比較検証する<br/>
検索結果をリクエスト格納する際のキーは、"searchResult"をデフォルトとしているので
キー名を変更したい場合は、getSearchResultKey()メソッドを各テストケースで オーバライドすること（暫定対応）。

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `context` - ExecutionContextインスタンス

---

### assertTable

```java
private void assertTable(INF testCaseInfo)
```

テーブル内容を期待値と比較検証する<br/>

**パラメータ:**
- `testCaseInfo` - テストケース情報

---

### getBaseUri

```java
protected abstract String getBaseUri()
```

ベースURIを返却する。

**戻り値:**
ベースURI

---

### beforeExecuteRequest

```java
protected void beforeExecuteRequest(INF testCaseInfo, ExecutionContext context, Advice<INF> advice)
```

各業務テストコードの拡張ポイント<br/>
テスト対象リクエストの実行前に呼び出される。<br/>

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `context` - ExecutionContextインスタンス
- `advice` - 実行前後の処理を実装した{@link Advice}

---

### afterExecuteRequest

```java
protected void afterExecuteRequest(INF testCaseInfo, ExecutionContext context, Advice<INF> advice)
```

各業務テストコードの拡張ポイント<br/>
テスト対象リクエストの実行後に呼び出される。処理が不要であれば空実装でかまわない。<br/>

**パラメータ:**
- `testCaseInfo` - テストケース情報
- `context` - ExecutionContextインスタンス
- `advice` - 実行前後の処理を実装した{@link Advice}

---
