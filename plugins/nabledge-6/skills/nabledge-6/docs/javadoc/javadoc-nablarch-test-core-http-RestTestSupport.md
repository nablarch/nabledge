# class RestTestSupport

**パッケージ:** nablarch.test.core.http

**継承階層:**
```
java.lang.Object
  └─ SimpleRestTestSupport
      └─ nablarch.test.core.http.RestTestSupport
```

---

```java
public class RestTestSupport
extends SimpleRestTestSupport
```

RESTfulウェブサービス用のテストサポートクラス
DBアクセスを追加した{@link SimpleRestTestSupport}拡張クラス

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### TEST_DATA_PARSER_KEY

```java
public static final String TEST_DATA_PARSER_KEY
```

TestDataParserのリポジトリキー

---

### RESOURCE_ROOT_KEY

```java
private static final String RESOURCE_ROOT_KEY
```

ベースディレクトリを取得するためのリポジトリキー

---

### DEFAULT_RESOURCE_ROOT

```java
private static final String DEFAULT_RESOURCE_ROOT
```

リソース読み込み時のベースディレクトリ

---

### PATH_SEPARATOR

```java
private static final String PATH_SEPARATOR
```

パスセパレータ

---

### SETUP_TABLE_SHEET

```java
private static final String SETUP_TABLE_SHEET
```

テストクラス共通データを定義しているシート名

---

### dbSupport

```java
private final DbAccessTestSupport dbSupport
```

NTFのDBサポート

---

### testDataExists

```java
private boolean testDataExists
```

テストデータのExcelファイルが存在するか否か

---

## コンストラクタの詳細

### RestTestSupport

```java
public RestTestSupport()
```

デフォルトコンストラクタ。
<p>
このコンストラクタでインスタンスを生成し委譲形式で利用した場合、 {@link #setUpDb()} などの
データベース機能を利用するメソッドは使用できない。<br>
データベース機能を利用する場合は、 {@link #RestTestSupport(Class)} を使用すること。
</p>
<p>
このクラスを継承してテストクラスを作成した場合は、デフォルトコンストラクタで初期化していても
データベース機能を利用できる。
</p>

---

### RestTestSupport

```java
public RestTestSupport(Class<?> testClass)
```

テストクラスを指定してインスタンスを生成する。

**パラメータ:**
- `testClass` - テストクラス

---

## メソッドの詳細

### setUpDb

```java
public void setUpDb()
```

システムリポジトリから設定を取得しHTTPサーバを起動する。
テストデータが存在する場合はDBにデータを登録する。
以下2種類のテストデータが対象となる。
<ol>
  <li>テストクラス単位で共通のデータシート:setUpDb</li>
  <li>テストメソッド単位で固有のデータシート：実行中のメソッド名</li>
</ol>

---

### setUpDbIfSheetExists

```java
protected void setUpDbIfSheetExists(String sheetName)
```

DBセットアップを実行する。

**パラメータ:**
- `sheetName` - セットアップ対象データの記載されたシート名

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
Map<String, String [ ]>形式のデータ

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

### assertTableEquals

```java
public void assertTableEquals(String message, String sheetName, String groupId, boolean failIfNoDataFound)
```

{@link nablarch.test.core.db.DbAccessTestSupport#assertTableEquals(String, String, String, boolean)} への委譲メソッド。

**パラメータ:**
- `message` - 比較失敗時のメッセージ
- `sheetName` - 期待値を格納したシート名
- `groupId` - グループID（オプション）
- `failIfNoDataFound` - データが存在しない場合に例外とするかどうか

---

### isExisting

```java
private boolean isExisting(String sheetName)
```

sheetName に合致するリソースが存在するかを判定する。

**パラメータ:**
- `sheetName` - シート名

**戻り値:**
存在する場合true

---

### getPathOf

```java
private String getPathOf(String resourceName)
```

テストデータのパスを取得する。
最初にリソースが見つかったテストデータのパスを返す。

**パラメータ:**
- `resourceName` - リソース名

**戻り値:**
リソースが存在するパス（存在しない場合、null）

---

### getSheet

```java
private Sheet getSheet(String basePath, String sheetName)
```

引数で渡されたパス配下にある実行中のテストクラスと同名のExcelファイルを読み込み
シート名が一致するシートを返す。

**パラメータ:**
- `basePath` - パス
- `sheetName` - シート名

**戻り値:**
読み込んだ{@link Sheet}

---

### getResourceName

```java
private String getResourceName(String sheetName)
```

リソース名を取得する。<br/>

**パラメータ:**
- `sheetName` - シート名

**戻り値:**
リソース名

---

### getTestDataPaths

```java
private List<String> getTestDataPaths()
```

テストデータのパスのリストを取得する。
リソースルートディレクトリに、クラスのパッケージ階層を付与したものをパスとして返却する。
これらのパスがリソースを探索する際の候補となる。
<p>
例えば、リソースルートの設定が["test/online;test/batch"]で、テストクラスがfoo.bar.Buzのとき、
["test/online/foo/bar", "test/batch/foo/bar"]が返却される。
</p>

**戻り値:**
テストデータのパスのリスト

---

### getResourceRootSetting

```java
private String getResourceRootSetting()
```

リソースルートの設定をリポジトリより取得する。<br/>
ルートディレクトリが複数設定されている場合、
{@link #PATH_SEPARATOR}で区切られている。
明示的に設定がされていない場合はデフォルト設定（{@link #DEFAULT_RESOURCE_ROOT}）を返却する。

**戻り値:**
リソースルート設定

---

### packageToPath

```java
private String packageToPath(Class<?> clazz)
```

与えられたクラスのパッケージからパスに変換する。

**パラメータ:**
- `clazz` - クラス

**戻り値:**
パッケージから変換されたパス

---

### getTestDataParser

```java
public final TestDataParser getTestDataParser()
```

テストデータパーサを取得する。

**戻り値:**
テストデータパーサ

---

### getBodyString

```java
public String getBodyString(HttpResponse httpResponse)
```

HTTPレスポンスボディの内容を表す文字列を返す。<br/>
文字列は{@link HttpResponse#getCharset()}で取得したキャラセットでデコードして取得される。

**戻り値:**
ボディの内容を表す文字列を返す

---

### getBodyStream

```java
public InputStream getBodyStream(HttpResponse httpResponse)
```

HTTPレスポンスボディの内容を保持するストリームを取得する。

**戻り値:**
HTTPレスポンスボディの内容を保持するストリーム

---
