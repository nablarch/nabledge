# class TestSupport

**パッケージ:** nablarch.test

**継承階層:**
```
java.lang.Object
  └─ TestEventDispatcher
      └─ nablarch.test.TestSupport
```

---

```java
public class TestSupport
extends TestEventDispatcher
```

テストサポートクラス。<br/>
本テスティングフレームワークを利用する際のヘルパーメソッドを提供する。

**作成者:** Tsuyoshi Kawasaki  

---

## フィールドの詳細

### DEFAULT_RESOURCE_ROOT

```java
private static final String DEFAULT_RESOURCE_ROOT
```

リソース読み込み時のベースディレクトリ

---

### RESOURCE_ROOT_KEY

```java
private static final String RESOURCE_ROOT_KEY
```

ベースディレクトリを取得するためのキー

---

### DEFAULT_LOCALE_EXPRESSION_KEY

```java
private static final String DEFAULT_LOCALE_EXPRESSION_KEY
```

ThreadContextに設定するデフォルトのロケール表現を取得するためのキー

---

### LOCALE_EXPRESSION_KEY

```java
private static final String LOCALE_EXPRESSION_KEY
```

ThreadContextに設定するロケール表現を取得するためのキー

---

### PATH_SEPARATOR

```java
private static final String PATH_SEPARATOR
```

パスセパレータ

---

### testClass

```java
private final Class<?> testClass
```

テスト対象クラス

---

## コンストラクタの詳細

### TestSupport

```java
public TestSupport(Class<?> testClass)
```

コンストラクタ

**パラメータ:**
- `testClass` - テスト対象クラス

---

## メソッドの詳細

### setThreadContextValues

```java
public void setThreadContextValues(String sheetName, String id)
```

ThreadContextに値を設定する。<br/>

**パラメータ:**
- `sheetName` - 取得元シート名
- `id` - 取得元ID

---

### setThreadContextValues

```java
public static void setThreadContextValues(Map<String,String> contextValues)
```

ThreadContextに値を設定する。<br/>

**パラメータ:**
- `contextValues` - ThreadContextに設定する値

---

### setLocaleToThreadContext

```java
private static void setLocaleToThreadContext(String localeExpression)
```

スレッドコンテキストにロケールを設定する

**パラメータ:**
- `localeExpression` - ロケールの文字列表現

---

### getParameterMap

```java
public Map<String,String[]> getParameterMap(String sheetName, String id)
```

HTTPリクエストパラメータ作成用のMapを取得する。<br/>

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
Map形式のデータ

---

### getMap

```java
public Map<String,String> getMap(String sheetName, String id)
```

Map形式でデータを取得する。<br/>

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
Map形式のデータ

---

### convert

```java
public static Map<String,String[]> convert(Map<String,String> commaSeparated)
```

Mapに格納されたvalueの型変換を行う。(String -> String[])<br/>
変換元のStringがカンマ区切りになっている場合、カンマを区切り文字として配列に変換する。<br/>

**パラメータ:**
- `commaSeparated` - 変換対象オブジェクト

**戻り値:**
変換後オブジェクト

---

### unescapeAndSplit

```java
static List<String> unescapeAndSplit(String orig)
```

エスケープを解除する。

**パラメータ:**
- `orig` - エスケープされた文字列

**戻り値:**
エスケープ解除された文字列

---

### splitWithComma

```java
static List<String> splitWithComma(String orig)
```

文字列をカンマで分割する。

**パラメータ:**
- `orig` - 分割対象となる文字列

**戻り値:**
分割後の文字列

---

### indexOfComma

```java
private static int indexOfComma(String str)
```

エスケープされていないカンマの位置を返却する。<br/>

**パラメータ:**
- `str` - 調査対象となる文字列

**戻り値:**
カンマの位置

---

### getListMap

```java
public List<Map<String,String>> getListMap(String sheetName, String id)
```

List-Map形式でデータを取得する。<br/>

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

List-Map形式でデータを取得する。<br/>
{@link nablarch.fw.web.HttpRequest}のリクエストパラメータと同じ形式で取得できる。
エンティティのコンストラクタにそのまま渡したい場合に使用する。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
List-Map形式のデータ

---

### getSetupTableData

```java
public List<TableData> getSetupTableData(String sheetName, String groupId)
```

準備用のTableDataを取得する。<br/>

**パラメータ:**
- `sheetName` - 取得元のシート名
- `groupId` - グループID

**戻り値:**
準備用のTableData

---

### getExpectedTableData

```java
public List<TableData> getExpectedTableData(String sheetName, String groupId)
```

期待するTableDataを取得する。

**パラメータ:**
- `sheetName` - 取得元のシート名
- `groupId` - グループID

**戻り値:**
期待するTableData

---

### getPathOf

```java
public String getPathOf(String resourceName)
```

テストデータのパスを取得する。<br/>
最初にリソースが見つかったテストデータのパスを返却する。

**パラメータ:**
- `resourceName` - リソース名

**戻り値:**
テストデータのパス

---

### getPathResourceExisting

```java
String getPathResourceExisting(List<String> candidatePath, String resourceName)
```

リソースが存在するパスを取得する。

**パラメータ:**
- `candidatePath` - 候補となるパス群
- `resourceName` - リソース名

**戻り値:**
リソースが存在するパス（存在しない場合、null）

---

### getTestDataPaths

```java
List<String> getTestDataPaths()
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

### getTestDataPaths

```java
List<String> getTestDataPaths(String[] baseDirs)
```

テストデータのパスを取得する。<br/>

**パラメータ:**
- `baseDirs` - 基点となるディレクトリ

**戻り値:**
テストデータのパス

---

### getResourceRootSetting

```java
static String getResourceRootSetting()
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
static String packageToPath(Class<?> clazz)
```

与えられたクラスのパッケージからパスに変換する。

**パラメータ:**
- `clazz` - クラス

**戻り値:**
パッケージから変換されたパス

---

### getBookName

```java
public String getBookName()
```

ブック名を取得する。

**戻り値:**
ブック名

---

### getResourceName

```java
public String getResourceName(String sheetName)
```

リソース名を取得する。<br/>

**パラメータ:**
- `sheetName` - シート名

**戻り値:**
リソース名

---

### getTestDataParser

```java
public final TestDataParser getTestDataParser()
```

テストデータパーサを取得する。

**戻り値:**
テストデータパーサ

---
