# class EntityTestSupport

**パッケージ:** nablarch.test.core.db

**継承階層:**
```
java.lang.Object
  └─ TestEventDispatcher
      └─ nablarch.test.core.db.EntityTestSupport
```

---

```java
public class EntityTestSupport
extends TestEventDispatcher
```

エンティティ自動テスト用基底クラス。<br/>
エンティティクラスの自動テストを行う場合には、本クラスを継承しテストクラスを作成する。
本クラス以外の基底クラスを継承しなければならない場合は、
本クラスのインスタンスを生成し処理を委譲することで代替可能である。

**作成者:** Tsuyoshi Kawasaki  

---

## フィールドの詳細

### TEST_CASE_ID

```java
private static final String TEST_CASE_ID
```

テストケース表のID(互換性の為）

---

### TEST_SHOTS_ID

```java
private static final String TEST_SHOTS_ID
```

テストケース表のID

---

### PARAMS

```java
private static final String PARAMS
```

エンティティに投入するパラメータ表のID

---

### TEST_TITLE

```java
private static final String TEST_TITLE
```

テストケース番号カラム名

---

### MSG_ID_PREFIX

```java
private static final String MSG_ID_PREFIX
```

期待するメッセージIDのプレフィクス

---

### PROP_NAME_PREFIX

```java
private static final String PROP_NAME_PREFIX
```

プロパティ名のプレフィックス

---

### REQUIRED_COLUMNS_FOR_RELATIONAL_VALIDATION

```java
private static final Set<String> REQUIRED_COLUMNS_FOR_RELATIONAL_VALIDATION
```

必須カラム一覧

---

### GROUP_KEY

```java
private static final String GROUP_KEY
```

BeanValidationのグループのキー

---

### INTERPOLATE_KEY_PREFIX

```java
private static final String INTERPOLATE_KEY_PREFIX
```

Bean Validationのメッセージ補完用属性キーのカラム名

---

### INTERPOLATE_VALUE_PREFIX

```java
private static final String INTERPOLATE_VALUE_PREFIX
```

Bean Validationのメッセージ補完用属性値のカラム名

---

### GET_KEY

```java
private static final String GET_KEY
```

期待値(getterから取得される値)のキー値

---

### NAME_KEY

```java
private static final String NAME_KEY
```

プロパティ名のキー値

---

### SET_KEY

```java
private static final String SET_KEY
```

setter(コンストラクタ)に指定する値のキー値

---

### dbSupport

```java
private final DbAccessTestSupport dbSupport
```

データベースアクセス自動テスト用基底クラス。<br/>
Entityのクラス単体テストに必要な機能のみ委譲する。

---

### strategy

```java
private ValidationTestStrategy strategy
```

テスト用バリデーションストラテジ

---

### PROPERTY_NAME

```java
private static final String PROPERTY_NAME
```

プロパティ名のカラム名

---

### MESSAGE_ID

```java
private static final String MESSAGE_ID
```

メッセージIDのカラム名

---

### INPUT

```java
private static final String INPUT
```

入力パラメータを取得するためのキー

---

### INPUT_1

```java
private static final String INPUT_1
```

入力パラメータを取得するためのキー（ひとつめ）

---

### REQUIRED_COLUMNS_FOR_SINGLE_VALIDATION

```java
private static final Set<String> REQUIRED_COLUMNS_FOR_SINGLE_VALIDATION
```

必須カラム

---

## コンストラクタの詳細

### EntityTestSupport

```java
protected EntityTestSupport()
```

コンストラクタ。<br/>
本クラスを継承する場合に呼び出されることを想定している。

---

### EntityTestSupport

```java
public EntityTestSupport(Class<?> testClass)
```

コンストラクタ。<br/>
本クラスを継承せずに使用する場合に呼び出されることを想定している。

**パラメータ:**
- `testClass` - テストクラス

---

## メソッドの詳細

### testValidateAndConvert

```java
public void testValidateAndConvert(Class<T> entityClass, String sheetName, String validateFor)
```

Nablarch Validationを設定したForm/Entityに対して、バリデーションテストを実行する。

**パラメータ:**
- `entityClass` - バリデーション対象のエンティティのクラス
- `sheetName` - シート名
- `validateFor` - バリデーション対象メソッド名
- `<T>` - バリデーション結果で取得できる型（エンティティ）

---

### testValidateAndConvert

```java
public void testValidateAndConvert(String prefix, Class<T> entityClass, String sheetName, String validateFor)
```

Nablarch Validationを設定したForm/Entityに対して、バリデーションテストを実行する。

**パラメータ:**
- `prefix` - パラメータのMapに入ったキーのプレフィクス
- `entityClass` - バリデーション対象のエンティティのクラス
- `sheetName` - シート名
- `validateFor` - バリデーション対象メソッド名
- `<T>` - バリデーション結果で取得できる型（エンティティ）

---

### testBeanValidation

```java
public void testBeanValidation(Class<T> entityClass, String sheetName)
```

Bean Validationを設定したForm/Entityに対して、バリデーションテストを実行する。

**パラメータ:**
- `entityClass` - バリデーション対象のエンティティのクラス
- `sheetName` - シート名
- `<T>` - バリデーション結果で取得できる型（エンティティ）

---

### testBeanValidation

```java
public void testBeanValidation(String prefix, Class<T> entityClass, String sheetName)
```

Bean Validationを設定したForm/Entityに対して、バリデーションテストを実行する。

**パラメータ:**
- `prefix` - パラメータのMapに入ったキーのプレフィクス
- `entityClass` - バリデーション対象のエンティティのクラス
- `sheetName` - シート名
- `<T>` - バリデーション結果で取得できる型（エンティティ）

---

### testValidateAllParameters

```java
private void testValidateAllParameters(String prefix, Class<T> entityClass, String sheetName, String validateFor)
```

バリデーションテストの共通メソッド。

**パラメータ:**
- `prefix` - パラメータのMapに入ったキーのプレフィクス
- `entityClass` - バリデーション対象のエンティティのクラス
- `sheetName` - シート名
- `validateFor` - バリデーション対象メソッド名
- `<T>` - バリデーション結果で取得できる型（エンティティ）

---

### checkSizeSame

```java
private void checkSizeSame(List<Map<String,String>> testCases, List<Map<String,String[]>> httpParamsList)
```

データ行数が同じであることを確認する。

**パラメータ:**
- `testCases` - テストケース表
- `httpParamsList` - パラメータ表

---

### getTestCasesFromSheet

```java
private List<Map<String,String>> getTestCasesFromSheet(String sheetName)
```

テストケース表を取得する。

**パラメータ:**
- `sheetName` - 取得元シート名

**戻り値:**
テストケース表

---

### checkRequiredColumns

```java
private void checkRequiredColumns(Set<String> required, List<Map<String,String>> actual, String sheetName, String id)
```

必須カラム存在チェックを行う。<br/>
必須カラムが存在しない場合、例外が発生する。

**パラメータ:**
- `required` - 必須カラム名
- `actual` - 実際のカラム
- `sheetName` - シート名（エラー発生時のメッセージ用）
- `id` - ID（エラー発生時のメッセージ用）

---

### assertMessageEquals

```java
private void assertMessageEquals(Map<String,String> aTestCase, ValidationTestContext ctx)
```

メッセージが等しいことを表明する。

**パラメータ:**
- `aTestCase` - テストケース（テストケース表の1行）
- `ctx` - バリデーション結果

---

### createExpectedMessages

```java
private List<Message> createExpectedMessages(Map<String,String> aTestCase)
```

期待値として使用するメッセージを生成する。

**パラメータ:**
- `aTestCase` - テストケース（テストケース表の1行）

**戻り値:**
メッセージ

---

### createMessageOnFailure

```java
private String createMessageOnFailure(Map<String,String> testCase)
```

テスト失敗時のメッセージを作成する。

**パラメータ:**
- `testCase` - テストケース

**戻り値:**
メッセージ

---

### getParamMap

```java
public Map<String,String[]> getParamMap(String sheetName, String id)
```

{@link DbAccessTestSupport#getParamMap(String, String)} への委譲メソッド。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
Map形式のデータ

---

### getListParamMap

```java
public List<Map<String,String[]>> getListParamMap(String sheetName, String id)
```

{@link DbAccessTestSupport#getListParamMap(String, String)} への委譲メソッド。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
List-Map形式のデータ

---

### setUpDb

```java
public void setUpDb(String sheetName)
```

{@link DbAccessTestSupport#setUpDb(String)}への委譲メソッド。

**パラメータ:**
- `sheetName` - シート名

---

### setUpDb

```java
public void setUpDb(String sheetName, String groupId)
```

{@link DbAccessTestSupport#setUpDb(String, String)}への委譲メソッド。

**パラメータ:**
- `sheetName` - シート名
- `groupId` - グループID

---

### getListMap

```java
private List<Map<String,String>> getListMap(String sheetName, String id)
```

{@link DbAccessTestSupport#getListMap(String, String)}への委譲メソッド。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
List-Map形式のデータ

---

### testSetterAndGetter

```java
public void testSetterAndGetter(Class<T> entityClass, String sheetName, String id)
```

setterとgetterのテストを行う。

**パラメータ:**
- `entityClass` - エンティティクラス名
- `sheetName` - シート名
- `id` - ケース表のID(LIST_MAP=testの場合は、testを指定する。)
- `<T>` - エンティティクラスの型

---

### testConstructorAndGetter

```java
public void testConstructorAndGetter(Class<?> entityClass, String sheetName, String id)
```

Constructor and getterのテストを行う。

**パラメータ:**
- `entityClass` - テスト対象のEntityクラス
- `sheetName` - データの記述されたシート名
- `id` - ケース表のID(LIST_MAP=testの場合は、testを指定する。)

---

### getHttpParams

```java
private Map<String,Object> getHttpParams(Class<?> entityClass, String sheetName, String id)
```

httpパラメータマップを生成する。

**パラメータ:**
- `entityClass` - entityクラス。
- `sheetName` - シート名
- `id` - ケース表のID(LIST_MAP=testの場合は、testを指定する。)

**戻り値:**
httpパラメータマップ

---

### assertGetterMethod

```java
public void assertGetterMethod(String sheetName, String id, Object entity)
```

getterのテストを行う。

**パラメータ:**
- `sheetName` - シート名
- `id` - ケース表のID(LIST_MAP=testの場合は、testを指定する。)
- `entity` - entity

---

### createEntityInstance

```java
private static ENTITY createEntityInstance(Class<ENTITY> entityClass, Map<String,Object> params)
```

Entityインスタンスを生成する。<br/>

**パラメータ:**
- `entityClass` - エンティティクラス
- `params` - コンストラクタに指定するパラメータ
- `<ENTITY>` - エンティティクラスの型

**戻り値:**
生成したインスタンス

---

### createEntityInstance

```java
private static ENTITY createEntityInstance(Class<ENTITY> entityClass)
```

デフォルトコンストラクタでEntityインスタンスを生成する。<br/>

**パラメータ:**
- `entityClass` - エンティティクラス
- `<ENTITY>` - エンティティクラスの型

**戻り値:**
生成したインスタンス

---

### toRuntimeException

```java
private static RuntimeException toRuntimeException(Class<?> entityClass, Exception e)
```

Entityインスタンス生成時に発生したチェック例外を非チェック例外に載せ替える。

**パラメータ:**
- `entityClass` - 生成に失敗したEntityクラス
- `e` - 実際に発生した例外

**戻り値:**
引数の例外をネストさせた非チェック例外

---

### cast

```java
private static Object cast(Class<?> clazz, String[] strings, String propertyName)
```

指定された文字列配列を、指定されたクラスに変換する。

**パラメータ:**
- `clazz` - 変換対象のクラスオブジェクト
- `strings` - 変換対象の文字列配列
- `propertyName` - 設定対象プロパティ名

**戻り値:**
変換後のオブジェクト

---

### cast

```java
static Object cast(Class<?> clazz, String[] strings)
            throws Exception
```

指定された文字列配列を、指定されたクラスに変換する。<br/>
<p/>
型変換には、変換対象クラスのvalueOf(String)メソッドの呼び出しによって実現する。
このため、valueOf(String)を持たないクラスへの変換は行えない。
ただし、BigDecimalとStringとjava.util.DateはvalueOf(String)メソッドを定義していないが、
変換対象とする。
java.util.Date型は、yyyy-MM-dd、yyyy-MM-dd hh:mm:ssの2種類の形式のみ変換を行う。
<br/>
変換対象のクラスが配列の場合は、文字列配列の全ての要素を変換し配列として返却する。
<br/>
変換対象のクラスが配列以外の場合は、文字列配列の先頭要素のみを変換し返却する。

**パラメータ:**
- `clazz` - 変換対象のクラスオブジェクト
- `strings` - 変換対象の文字列配列

**戻り値:**
変換後のオブジェクト

**例外:**
- `Exception` - 予期しない例外

---

### parseDateString

```java
private static Date parseDateString(String dateStr)
                     throws IllegalArgumentException
```

日付文字列をjava.util.Date型に変換する。
変換できる形式はyyyy-MM-ddとyyyy-MM-dd HH:mm:ssの2種類である。

**パラメータ:**
- `dateStr` - 日付文字列

**戻り値:**
変換後のDate型オブジェクト

**例外:**
- `IllegalArgumentException` - 日付文字列の形式が不正な場合。

---

### testValidateCharsetAndLength

```java
public void testValidateCharsetAndLength(Class<ENTITY> targetClass, String sheetName, String id)
```

文字種と文字列長のバリデーションテストをする。

**パラメータ:**
- `targetClass` - テスト対象エンティティクラス
- `sheetName` - シート名
- `id` - ID
- `<ENTITY>` - テスト対象エンティティの型

---

### testSingleValidation

```java
public void testSingleValidation(Class<ENTITY> targetClass, String sheetName, String id)
```

単項目のバリデーションテストをする。

**パラメータ:**
- `targetClass` - テスト対象エンティティクラス
- `sheetName` - シート名
- `id` - ID
- `<ENTITY>` - テスト対象エンティティの型

---

### getInputParameter

```java
private String[] getInputParameter(Map<String,String> row)
```

入力パラメータを取得する。

**パラメータ:**
- `row` - 行データ

**戻り値:**
入力パラメータ

---

### getInterpolationMap

```java
private Map<String,Object> getInterpolationMap(String interpolateKeyPrefix, String interpolateValuePrefix, Map<String,String> row)
```

Bean Validationのメッセージ補完用属性のマップを取得する。

**パラメータ:**
- `row` - 行データ

**戻り値:**
メッセージ補完用属性のマップ

---

### getListMapRequired

```java
private List<Map<String,String>> getListMapRequired(String sheetName, String id)
                                            throws IllegalArgumentException
```

必須のList-Mapデータを取得する。<br/>
{@link #getListMap(String, String)}を実行し、
その結果が空の場合は指定したIDに合致するデータが存在しないとみなし、例外を発生させる。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
List-Map形式のデータ

**例外:**
- `IllegalArgumentException` - 指定したIDのデータが存在しない場合

---

### getListParamMapRequired

```java
private List<Map<String,String[]>> getListParamMapRequired(String sheetName, String id)
                                                   throws IllegalArgumentException
```

必須のList-Mapデータを取得する。<br/>
{@link #getListParamMap(String, String)} を実行し、
その結果が空の場合は指定したIDに合致するデータが存在しないとみなし、例外を発生させる。

**パラメータ:**
- `sheetName` - シート名
- `id` - ID

**戻り値:**
List-Map形式のデータ

**例外:**
- `IllegalArgumentException` - 指定したIDのデータが存在しない場合

---

### checkNotEmpty

```java
private void checkNotEmpty(List<?> list, String sheetName, String id)
                   throws IllegalArgumentException
```

テストデータとして取得したListが空でないことを検査する。

**パラメータ:**
- `list` - 取得したList
- `sheetName` - 取得元シート名（エラーメッセージに使用する）
- `id` - 取得元ID（エラーメッセージに使用する）

**例外:**
- `IllegalArgumentException` - Listが空の場合

---

### getStrategy

```java
private ValidationTestStrategy getStrategy()
```

テスト用バリデーションストラテジを取得する。

**戻り値:**
テスト用バリデーションストラテジ

---
