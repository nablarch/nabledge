# 目的別API使用方法

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/03_Tips.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/idgenerator/IdGenerator.html)

## Excelファイルから、入力パラメータや戻り値に対する期待値などを取得したい

データタイプ`LIST_MAP`を使用して、Excelファイルからデータを`List<Map<String, String>>`形式で取得できる。

**書式**: `LIST_MAP=<シート内で一意になるID（任意の文字列）>`

- データ2行目: MapのKey
- データ3行目以降: MapのValue

**メソッド**:
- `TestSupport#getListMap(String sheetName, String id)`
- `DbAccessTestSupport#getListMap(String sheetName, String id)`

第1引数にシート名、第2引数にIDを指定する。

```java
public class EmployeeComponentTest extends DbAccessTestSupport {
    @Test
    public void testGetName() {
        List<Map<String, String>> parameters = getListMap("testGetName", "parameters");
        Map<String, String>> param = parameters.get(0);
        String empNo = parameter.get("empNo");
        String expected = parameter.get("expected");
        EmployeeComponent target = new EmployeeComponent();
        String actual = target.getName(empNo);
        assertEquals(expected, actual);
    }
}
```

**Excelファイル記述例**:
```
LIST_MAP=parameters

empNo   | expected
--------|----------
00001   | 山田太郎
00002   | 鈴木一郎
```

上記の表で取得可能なオブジェクトは、以下のコードで取得できるListと等価である。

```java
List<Map<String, String>> list = new ArrayList<Map<String, String>>();
Map<String, String> first = new HashMap<String, String>();
first.put("empNo", "00001");
first.put("expected", "山田太郎");
list.add(first);
Map<String, String> second = new HashMap<String, String>();
second.put("empNo", "00002");
map.put("expected", "鈴木一郎");
list.add(second);
```

シーケンスオブジェクトを使用した採番処理を、設定ファイルの変更のみでテーブル採番に置き換える機能を使用して採番テストを行う。

手順:
1. 準備データをテーブルにセットアップする
2. 期待値はテーブルに設定した値を元に設定する

**本番用設定ファイル例:**

```xml
<!-- シーケンスオブジェクトを使用した採番設定 -->
<component name="idGenerator" class="nablarch.common.idgenerator.OracleSequenceIdGenerator">
    <property name="idTable">
        <map>
            <entry key="1101" value="SEQ_1"/> <!-- ID1採番用 -->
            <entry key="1102" value="SEQ_2"/> <!-- ID2採番用 -->
            <entry key="1103" value="SEQ_3"/> <!-- ID3採番用 -->
            <entry key="1104" value="SEQ_4"/> <!-- ID4採番用 -->
        </map>
    </property>
</component>
```

**テスト用設定ファイル（本番設定をテーブル採番設定で上書き）:**

```xml
<!-- シーケンスオブジェクトの採番設定をテーブルを使用した採番設定に置き換える -->
<component name="idGenerator" class="nablarch.common.idgenerator.FastTableIdGenerator">
    <property name="tableName" value="TEST_SBN_TBL"/>
    <property name="idColumnName" value="ID_COL"/>
    <property name="noColumnName" value="NO_COL"/>
    <property name="dbTransactionManager" ref="dbTransactionManager" />
</component>
```

> **補足**: テーブル採番用の設定値の詳細は、`IdGenerator` を参照すること。

**Excel記述例（採番対象ID:1101）:**

準備データ（SETUP_TABLE=TEST_SBN_TBL）:

| ID_COL | NO_COL |
|--------|--------|
| 1101   | 100    |

> **補足**: 採番用テーブルに準備データを設定する。テスト範囲内で使用する採番対象のレコードのみを設定する。

期待値（EXPECTED_TABLE=TEST_SBN_TBL）:

| ID_COL | NO_COL |
|--------|--------|
| 1101   | 101    |

期待値（EXPECTED_TABLE=USER_INFO）:

| USER_ID    | KANJI_NAME | KANA_NAME |
|------------|------------|-----------|
| 0000000101 | 漢字名     | ｶﾅﾒｲ      |

> **補足**: テスト内で1度のみ採番処理が行われる場合、期待値は「準備データの値 + 1」となる。

デフォルトではテストデータは`test/java`配下から読み込まれる。変更する場合、コンポーネント設定ファイルに`nablarch.test.resource-root`を設定する。

| キー | 値 |
|---|---|
| `nablarch.test.resource-root` | テスト実行時のカレントディレクトリからの相対パス。セミコロン(`;`)区切りで複数指定可 |

```bash
nablarch.test.resource-root=path/to/test-data-dir
```

複数ディレクトリ指定例:
```text
nablarch.test.resource-root=test/online;test/batch
```

> **注意**: 複数ディレクトリを指定した場合、同名のテストデータが存在する場合は最初に発見されたテストデータが読み込まれる。

一時的な変更はVMオプションで代替可能: `-Dnablarch.test.resource-root=path/to/test-data-dir`

<details>
<summary>keywords</summary>

TestSupport, DbAccessTestSupport, getListMap, LIST_MAP, Excelデータ取得, List-Map形式, List<Map<String, String>>, ArrayList, HashMap, OracleSequenceIdGenerator, FastTableIdGenerator, IdGenerator, シーケンスオブジェクト採番, テーブル採番, TEST_SBN_TBL, 採番テスト設定置き換え, nablarch.test.resource-root, テストデータディレクトリ変更, 複数ディレクトリ指定, テストリソースパス設定, VMオプション設定

</details>

## 同じテストメソッドをテストデータを変えて実行したい

List-Map形式取得メソッドを使用してテストをループさせることで、同じテストメソッドをテストデータを変えて実行できる。Excelデータを追加するだけでデータバリエーションを増やせる。

```java
public class EmployeeComponentTest extends DbAccessTestSupport {
    @Test
    public void testSelectByPk() {
        setUpDb("testSelectByPk");
        List<Map<String, String>> parameters = getListMap("testGetName", "parameters");
        for (Map<String, String> param : parameters) {
            String empNo = param.get("empNo");
            String expectedDataId = param.get("expectedDataId");
            EmployeeComponent target = new EmployeeComponent();
            SqlResultSet actual = target.selectByPk(empNo);
            assertSqlResultSetEquals("testSelectByPk", expectedDataId, actual);
        }
    }
}
```

> **重要**: 更新系のテストを行う場合は、ループ内で`setUpDb`メソッドを呼び出すこと。そうでないと、テストの成否がデータの順番に依存してしまう。

データベースアクセスクラスの自動テストでは、テストクラスからテスト対象クラスを直接起動するため、ThreadContextに値が設定されていない。以下のメソッドを使用してThreadContextに値を設定する。

- `TestSupport#setThreadContextValues(String sheetName, String id)`
- `DbAccessTestSupport#setThreadContextValues(String sheetName, String id)`

> **補足**: 自動設定項目を使用してデータベースを登録・更新する際は、ThreadContextにリクエストIDとユーザIDが設定されている必要がある。テスト対象クラス起動前に設定すること。

**テストソースコード例:**

```java
setThreadContextValues("testSelect", "threadContext");
```

**Excelデータ例（シート[testInsert]、LIST_MAP=threadContext）:**

| USER_ID | REQUEST_ID | LANG  |
|---------|------------|-------|
| U00001  | RS000001   | ja_JP |

テストデータのExcelデータはデフォルトでは指定エンコーディングでバイト列に変換されるのみ。URLエンコーディング等の定型変換を追加するには、以下のインタフェースを実装してシステムリポジトリに登録する。

**インタフェース**: `nablarch.test.core.file.TestDataConverter`

システムリポジトリ登録:

| キー | 値 |
|---|---|
| `TestDataConverter_<データ種別>` | 実装クラスのクラス名。データ種別はテストデータのfile-typeに指定した値 |

```xml
<component name="TestDataConverter_FormUrlEncoded"
           class="please.change.me.test.core.file.FormUrlEncodedTestDataConverter"/>
```

Excelファイル記述例:
![Excelファイル記述例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-03_Tips/data_convert_example.png)

上記コンバータでURLエンコーディングを行うよう実装した場合、テストフレームワーク内部では以下のデータを記述した場合と同様に扱われる:
![内部処理データ例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-03_Tips/data_convert_internal.png)

<details>
<summary>keywords</summary>

DbAccessTestSupport, setUpDb, getListMap, assertSqlResultSetEquals, SqlResultSet, テストデータループ, データバリエーション, 更新系テスト, ThreadContext, setThreadContextValues, TestSupport, ユーザID設定, リクエストID設定, 自動設定項目, TestDataConverter, nablarch.test.core.file.TestDataConverter, TestDataConverter_<データ種別>, テストデータ変換処理, URLエンコーディング変換, メッセージング処理テスト

</details>

## 一つのシートに複数テストケースのデータを記載したい

グループIDを付与することで、複数テストケースのデータを1つのシートに混在させることができる。

**サポートされるデータタイプ**: `EXPECTED_TABLE`, `SETUP_TABLE`

**書式**: `データタイプ[グループID]=テーブル名`

例（2種類のテストケース`case_001`、`case_002`を混在させる場合）:
```
SETUP_TABLE[case_001]=EMPLOYEE_TABLE
EXPECTED_TABLE[case_001]=EMPLOYEE_TABLE

SETUP_TABLE[case_002]=EMPLOYEE_TABLE
EXPECTED_TABLE[case_002]=EMPLOYEE_TABLE
```

```java
// DBにデータ登録（グループIDが"case_001"のものだけ登録対象になる）
setUpDb("testUpdate", "case_001");

// 結果確認（グループIDが"case_001"のものだけassert対象になる）
assertTableEquals("データベース更新結果確認", "testUpdate", "case_001");
```

> **注意**: 複数のグループIDのデータを記述する際は、グループIDごとにまとめて記述すること。グループIDごとにまとめずに記述すると、データの読み込みが途中で終了しテストが正しく実行されない。

テストソースコードと異なるディレクトリのExcelファイルを読み込む場合は、`TestDataParser` 実装クラスを直接使用する。

```java
TestDataParser parser = (TestDataParser) SystemRepository.getObject("testDataParser");
List<Map<String, String>> list = parser.getListMap("/foo/bar/Baz.xlsx", "sheet001", "params");
```

<details>
<summary>keywords</summary>

EXPECTED_TABLE, SETUP_TABLE, setUpDb, assertTableEquals, グループID, 複数テストケース, シート管理, TestDataParser, getListMap, SystemRepository, Excelファイル読み込み, 任意ディレクトリ

</details>

## システム日時を任意の値に固定したい

`FixedSystemTimeProvider`を使用して、システム日時を任意の固定値に設定できる。コンポーネント設定ファイルで`SystemTimeProvider`インタフェースの実装クラスを`FixedSystemTimeProvider`に差し替えることで実現する。

```xml
<component name="systemTimeProvider"
    class="nablarch.test.FixedSystemTimeProvider">
  <property name="fixedDate" value="20100913123456" />
</component>
```

| プロパティ名 | 設定内容 |
|---|---|
| fixedDate | 固定したい日時を次のフォーマットのいずれかで指定する。`yyyyMMddHHmmss`（12桁）または `yyyyMMddHHmmssSSS`（15桁） |

```java
SystemTimeProvider provider = (SystemTimeProvider) SystemRepository.getObject("systemTimeProvider");
Date now = provider.getDate();
```

JUnit4のアノテーション（`@Before`, `@After`, `@BeforeClass`, `@AfterClass`）を使用して、テスト実行前後に共通処理を実行できる。

<details>
<summary>keywords</summary>

FixedSystemTimeProvider, SystemTimeProvider, SystemRepository, fixedDate, システム日時固定, nablarch.test.FixedSystemTimeProvider, yyyyMMddHHmmss, @Before, @After, @BeforeClass, @AfterClass, テスト前後共通処理

</details>

## @BeforeClass, @AfterClass使用時の注意点

`@BeforeClass`/`@AfterClass` 使用時の注意: サブクラスでスーパークラスと同名かつ同アノテーションのメソッドを定義すると、スーパークラスのメソッドは呼び出されなくなる。

```java
public class TestSuper {
    @BeforeClass
    public static void setUpBeforeClass() {
        System.out.println("super");   // 表示されない
    }
}

public class TestSub extends TestSuper {
    @BeforeClass
    public static void setUpBeforeClass() {
        // スーパークラスのメソッドを上書き
    }
    @Test
    public void test() {
        System.out.println("test");
    }
}
```

TestSubを実行した場合、「test」のみ表示される。

<details>
<summary>keywords</summary>

@BeforeClass, @AfterClass, サブクラス同名メソッド, スーパークラス呼び出し抑止, 継承注意

</details>

## デフォルト以外のトランザクションを使用したい

`DbAccessTestSupport` を継承することで、スーパークラスの `@Before`/`@After` メソッドが自動的に呼び出される。テストメソッド実行前にトランザクション開始、実行後にトランザクション終了が自動制御されるため、個別テストでのトランザクション開始処理の記述とトランザクション終了処理漏れが不要になる。

プロパティファイルにトランザクション名を記載しておくことで、この機構が有効になる。

<details>
<summary>keywords</summary>

DbAccessTestSupport, トランザクション自動制御, beginTransactions, endTransactions, トランザクション管理

</details>

## 本フレームワークのクラスを継承せずに使用したい

フレームワークのスーパークラスを継承できない場合、スーパークラスをインスタンス化して処理を委譲する。

- コンストラクタにテストクラス自身の `Class` インスタンスを渡す
- `@Before` メソッドで `dbSupport.beginTransactions()` を明示的に呼び出す
- `@After` メソッドで `dbSupport.endTransactions()` を明示的に呼び出す

```java
public class SampleTest extends AnotherSuperClass {
    private DbAccessTestSupport dbSupport = new DbAccessTestSupport(getClass());

    @Before
    public void setUp() {
        dbSupport.beginTransactions();
    }

    @After
    public void tearDown() {
        dbSupport.endTransactions();
    }

    @Test
    public void test() {
        dbSupport.setUpDb("test");
        dbSupport.assertSqlResultSetEquals("test", "id", actual);
    }
}
```

<details>
<summary>keywords</summary>

DbAccessTestSupport, 委譲, beginTransactions, endTransactions, フレームワーク非継承, インスタンス化

</details>

## クラスのプロパティを検証したい

テスト対象クラスのプロパティ値を検証するメソッド（第1引数: エラー時メッセージ、第2引数: シート名、第3引数: ID、第4引数: 検証対象）:

- `HttpRequestTestSupport#assertObjectPropertyEquals(String message, String sheetName, String id, Object actual)`
- `HttpRequestTestSupport#assertObjectArrayPropertyEquals(String message, String sheetName, String id, Object[] actual)`
- `HttpRequestTestSupport#assertObjectListPropertyEquals(String message, String sheetName, String id, List<?> actual)`

テストデータの記述方法は [how_to_get_data_from_excel](#) と同様。2行目がプロパティ名、3行目以降が検証値。

**テストソースコード例:**

```java
public class UserUpdateActionRequestTest extends HttpRequestTestSupport {

    @Test
    public void testRW11AC0301Normal() {
        execute("testRW11AC0301Normal", new BasicAdvice() {
            @Override
            public void afterExecute(TestCaseInfo testCaseInfo,
                    ExecutionContext context) {
                String message = testCaseInfo.getTestCaseName();
                String sheetName = testCaseInfo.getSheetName();

                UserForm form = (UserForm) context.getRequestScopedVar("user_form");
                UsersEntity users = form.getUsers();

                // users のプロパティ kanjiName,kanaName,mailAddress を検証
                assertObjectPropertyEquals(message, sheetName, "expectedUsers", users);
            }
        });
    }
}
```

**Excelデータ例（LIST_MAP=expectedUsers）:**

| kanjiName | kanaName   | mailAddress         |
|-----------|------------|---------------------|
| 漢字氏名  | カナシメイ | test@anydomain.com  |

<details>
<summary>keywords</summary>

HttpRequestTestSupport, assertObjectPropertyEquals, assertObjectArrayPropertyEquals, assertObjectListPropertyEquals, プロパティ検証, BasicAdvice, afterExecute, getRequestScopedVar

</details>

## テストデータに空白、空文字、改行やnullを記述したい

:ref:`special_notation_in_cell` を参照。

<details>
<summary>keywords</summary>

special_notation_in_cell, 空白テストデータ, null記述, 改行テストデータ, 特殊文字記述

</details>

## テストデータに空行を記述したい

全くの空行は無視されるため、ダブルクォーテーション `""` を使用して空文字列を記述することで空行を表す。

> **補足**: 空行を表す場合、行のうちいずれか1セルだけに `""` を記述すれば良い。可読性のため、左端のセルへの記載を推奨する。

**例（2レコード目が空行、SETUP_VARIABLE=/path/to/file.csv）:**

| name | address |
|------|---------|
| 山田 | 東京都  |
| ""   |         |
| 田中 | 大阪府  |

<details>
<summary>keywords</summary>

空行テストデータ, ダブルクォーテーション, 空文字列, 可変長ファイル, SETUP_VARIABLE

</details>

## マスタデータを変更してテストを行いたい

[04_MasterDataRestore](testing-framework-04_MasterDataRestore.md) を参照。

<details>
<summary>keywords</summary>

マスタデータ変更テスト, 04_MasterDataRestore, マスタデータリストア

</details>
