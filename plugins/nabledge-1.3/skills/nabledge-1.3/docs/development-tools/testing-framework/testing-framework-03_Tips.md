# 目的別API使用方法

## Excelファイルから、入力パラメータや戻り値に対する期待値などを取得したい

## Excelファイルから、入力パラメータや戻り値に対する期待値などを取得したい

データタイプ `LIST_MAP` を使用して、Excelデータを `List<Map<String, String>>` 形式で取得できる。

書式: `LIST_MAP=<シート内で一意になるID>`
- 2行目: MapのKey
- 3行目以降: MapのValue

**メソッド**: `TestSupport#getListMap(String sheetName, String id)`, `DbAccessTestSupport#getListMap(String sheetName, String id)`
- 第1引数: シート名、第2引数: ID

```java
public class EmployeeComponentTest extends DbAccessTestSupport {
    @Test
    public void testGetName() {
        List<Map<String, String>> parameters = getListMap("testGetName", "parameters");
        Map<String, String> param = parameters.get(0);
        String empNo = param.get("empNo");
        String expected = param.get("expected");
        EmployeeComponent target = new EmployeeComponent();
        String actual = target.getName(empNo);
        assertEquals(expected, actual);
    }
}
```

シーケンスオブジェクトを使った採番処理は次の採番値が予測できないため、テスト用設定でテーブル採番（`FastTableIdGenerator`）に置き換えることで期待値を設定できる。

**本番用設定**:
```xml
<component name="idGenerator" class="nablarch.common.idgenerator.OracleSequenceIdGenerator">
    <property name="idTable">
        <map>
            <entry key="1101" value="SEQ_1"/>
            <entry key="1102" value="SEQ_2"/>
            <entry key="1103" value="SEQ_3"/>
            <entry key="1104" value="SEQ_4"/>
        </map>
    </property>
</component>
```

**テスト用設定**（`idGenerator` コンポーネントを上書き）:
```xml
<component name="idGenerator" class="nablarch.common.idgenerator.FastTableIdGenerator">
    <property name="tableName" value="TEST_SBN_TBL"/>
    <property name="idColumnName" value="ID_COL"/>
    <property name="noColumnName" value="NO_COL"/>
    <property name="dbTransactionManager" ref="dbTransactionManager"/>
</component>
```

> **注意**: テーブル採番設定値の詳細は [Nablarch採番機能](../../component/libraries/libraries-06_IdGenerator.md) を参照。

**Excelファイル記述例**（採番対象ID:1101 の場合）:

準備データ（`SETUP_TABLE=TEST_SBN_TBL`）:
| ID_COL | NO_COL |
|--------|--------|
| 1101 | 100 |

> **注意**: 採番用テーブルに準備データを設定する。準備データでは、テスト範囲内で使用する採番対象のレコードのみを設定する。

期待値（採番テーブル `EXPECTED_TABLE=TEST_SBN_TBL`）:
| ID_COL | NO_COL |
|--------|--------|
| 1101 | 101 |

期待値（登録先テーブル `EXPECTED_TABLE=USER_INFO`）:
| USER_ID | KANJI_NAME | KANA_NAME |
|---------|------------|----------|
| 0000000101 | 漢字名 | ｶﾅﾒｲ |

> **注意**: テスト内で1度のみ採番処理が行われる場合、期待値は「準備データの値 + 1」となる。

テストデータの読み込みディレクトリはデフォルトで `test/java` 配下。変更する場合はコンポーネント定義ファイルに以下を設定する。

| キー | 値 |
|---|---|
| `nablarch.test.resource-root` | テスト実行時のカレントディレクトリからの相対パス。セミコロン(;)区切りで複数指定可 |

設定例:
```bash
nablarch.test.resource-root=path/to/test-data-dir
```

複数ディレクトリ指定例:
```text
nablarch.test.resource-root=test/online;test/batch
```

> **注意**: 複数ディレクトリを指定した場合、同名のテストデータが存在すると最初に発見されたものが読み込まれる。

一時的に変更する場合は、設定ファイルを変更せずにVMオプションで指定可能: `-Dnablarch.test.resource-root=path/to/test-data-dir`

<details>
<summary>keywords</summary>

TestSupport, DbAccessTestSupport, getListMap, LIST_MAP, ExcelデータのList-Map形式取得, テストデータ取得, OracleSequenceIdGenerator, FastTableIdGenerator, シーケンスオブジェクト採番, テーブル採番置き換え, TEST_SBN_TBL, idGenerator, tableName, idColumnName, noColumnName, dbTransactionManager, nablarch.test.resource-root, テストデータディレクトリ変更, テストデータ読み込みパス, セミコロン区切り複数指定, VMオプション指定

</details>

## 同じテストメソッドをテストデータを変えて実行したい

## 同じテストメソッドをテストデータを変えて実行したい

`getListMap` でList-Map形式のデータを取得してループさせることで、同一テストメソッドを複数データで実行できる。

```java
setUpDb("testSelectByPk");
List<Map<String, String>> parameters = getListMap("testGetName", "parameters");
for (Map<String, String> param : parameters) {
    String empNo = param.get("empNo");
    String expectedDataId = param.get("expectedDataId");
    SqlResultSet actual = target.selectByPk(empNo);
    assertSqlResultSetEquals("testSelectByPk", expectedDataId, actual);
}
```

> **警告**: 更新系のテストを行う場合は、ループ内で `setUpDb` メソッドを呼び出すこと。そうでないと、テストの成否がデータの順番に依存してしまう。

なし

<details>
<summary>keywords</summary>

getListMap, setUpDb, assertSqlResultSetEquals, SqlResultSet, LIST_MAP, テストデータのループ実行, データバリエーション, ThreadContext設定, using_ThreadContext

</details>

## 一つのシートに複数テストケースのデータを記載したい

## 一つのシートに複数テストケースのデータを記載したい

グループIDを付与することで、複数テストケースのデータを一つのシートに混在させることができる。

サポートされるデータタイプ: `EXPECTED_TABLE`, `SETUP_TABLE`

書式: `データタイプ[グループID]=テーブル名`

**メソッド**:
- `setUpDb("testUpdate", "case_001")` — グループIDが `case_001` のデータのみを登録対象にする
- `assertTableEquals("データベース更新結果確認", "testUpdate", "case_001")` — グループIDが `case_001` のデータのみをassert対象にする

Excel記述例:
```
SETUP_TABLE[case_001]=EMPLOYEE_TABLE
EXPECTED_TABLE[case_001]=EMPLOYEE_TABLE
SETUP_TABLE[case_002]=EMPLOYEE_TABLE
EXPECTED_TABLE[case_002]=EMPLOYEE_TABLE
```

フレームワークを経由せずテストクラスからテスト対象クラスを直接起動する場合、ThreadContextには値が設定されていない。Excelファイルに設定値を記述して以下のメソッドを呼び出すことでThreadContextに値を設定できる。

- `TestSupport#setThreadContextValues(String sheetName, String id)`
- `DbAccessTestSupport#setThreadContextValues(String sheetName, String id)`

> **注意**: 自動設定項目を利用してDBに登録・更新する場合は、ThreadContextにリクエストIDとユーザIDが設定されている必要がある。テスト対象クラス起動前に設定すること。

**実装例**:
```java
setThreadContextValues("testSelect", "threadContext");
```

**テストデータ記述例**（`LIST_MAP=threadContext`）:

| USER_ID | REQUEST_ID | LANG |
|---------|------------|------|
| U00001 | RS000001 | ja_JP |

<details>
<summary>keywords</summary>

setUpDb, assertTableEquals, EXPECTED_TABLE, SETUP_TABLE, グループID, 複数テストケース同一シート, ThreadContext, setThreadContextValues, TestSupport, DbAccessTestSupport, ユーザID設定, リクエストID設定

</details>

## システム日時を任意の値に固定したい

## システム日時を任意の値に固定したい

`FixedSystemTimeProvider` クラスをコンポーネント定義ファイルで `systemTimeProvider` として設定することで、`SystemTimeProvider` の実装クラスを差し替えてシステム日時を固定値にできる。

```xml
<component name="systemTimeProvider"
    class="nablarch.test.FixedSystemTimeProvider">
  <property name="fixedDate" value="20100913123456" />
</component>
```

| プロパティ名 | 設定内容 |
|---|---|
| fixedDate | 固定したい日時。フォーマット: `yyyyMMddHHmmss` (12桁) または `yyyyMMddHHmmssSSS` (15桁) |

固定されたシステム日時は以下のように取得できる。

```java
SystemTimeProvider provider = (SystemTimeProvider) SystemRepository.getObject("systemTimeProvider");
Date now = provider.getDate();
```

なし

<details>
<summary>keywords</summary>

FixedSystemTimeProvider, SystemTimeProvider, fixedDate, SystemRepository, getObject, getDate, システム日時固定, テスト用日付設定, TestDataParser, 任意ディレクトリExcel読み込み

</details>

## 任意のディレクトリのExcelファイルを読み込みたい

テストソースコードと同じディレクトリのExcelファイルはシート名を指定するだけで読み込めるが、別のディレクトリのExcelファイルを読み込む場合は、`TestDataParser`実装クラスを直接使用する（`SystemRepository.getObject("testDataParser")`で取得）。

```java
TestDataParser parser = (TestDataParser) SystemRepository.getObject("testDataParser");
List<Map<String, String>> list = parser.getListMap("/foo/bar/Baz.xls", "sheet001", "params");
```

<details>
<summary>keywords</summary>

TestDataParser, getListMap, Excelファイル読み込み, 任意ディレクトリ, SystemRepository

</details>

## 

なし

<details>
<summary>keywords</summary>

JUnit4アノテーション, テスト共通処理

</details>

## テスト実行前後に共通処理を行いたい。

JUnit4のアノテーション（`@Before`, `@After`, `@BeforeClass`, `@AfterClass`）を使用してテスト実行前後に共通処理を実行できる。`@BeforeClass`・`@AfterClass`使用時の注意点は「@BeforeClass, @AfterClass使用時の注意点」を参照。

<details>
<summary>keywords</summary>

@Before, @After, @BeforeClass, @AfterClass, JUnit4, テスト共通処理

</details>

## @BeforeClass, @AfterClass使用時の注意点

> **警告**: サブクラスにて、スーパークラスと同名かつ同じアノテーションを付与したメソッドを作成しないこと。同名メソッドに同種アノテーションを付与した場合、スーパークラスのメソッドは起動されなくなる。

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

上記の`TestSub`を実行した場合、「test」と表示される（「super」は表示されない）。

<details>
<summary>keywords</summary>

@BeforeClass, @AfterClass, サブクラス上書き, スーパークラスメソッド非起動, 同名メソッド

</details>

## 

なし

<details>
<summary>keywords</summary>

トランザクション制御, using_transactions

</details>

## デフォルト以外のトランザクションを使用したい

プロパティファイルにトランザクション名を記載することで、テスティングフレームワークがテストメソッド実行前後のトランザクション制御を自動化する。テストクラスで`DbAccessTestSupport`を継承することでこの機能が有効になる（スーパークラスの`@Before`・`@After`メソッドが自動呼び出され、開始・終了を担う）。個別のテストで明示的なトランザクション開始が不要になり、終了漏れもなくなる。

<details>
<summary>keywords</summary>

DbAccessTestSupport, トランザクション自動制御, プロパティファイル, トランザクション名

</details>

## 

なし

<details>
<summary>keywords</summary>

継承なし使用, using_ohter_class

</details>

## 本フレームワークのクラスを継承せずに使用したい

別のクラスを継承する必要があり、フレームワークのスーパークラスを継承できない場合、スーパークラスをインスタンス化して処理を委譲する。

委譲時の要件:
- コンストラクタにテストクラス自身の`Class`インスタンス（`getClass()`）を渡す
- `@Before`（前処理）・`@After`（後処理）メソッドは明示的に呼び出す必要がある

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

DbAccessTestSupport, 委譲パターン, beginTransactions, endTransactions, setUpDb, assertSqlResultSetEquals

</details>

## 

なし

<details>
<summary>keywords</summary>

プロパティ検証, how_to_assert_property_from_excel

</details>

## クラスのプロパティを検証したい

テスト対象クラスのプロパティをExcelファイルのデータと比較して検証する。データ記述は [how_to_get_data_from_excel](#) と同様（2行目: プロパティ名、3行目以降: 検証値）。

`HttpRequestTestSupport`の検証メソッド:
- `assertObjectPropertyEquals(String message, String sheetName, String id, Object actual)` — 単一オブジェクト
- `assertObjectArrayPropertyEquals(String message, String sheetName, String id, Object[] actual)` — オブジェクト配列
- `assertObjectListPropertyEquals(String message, String sheetName, String id, List<?> actual)` — オブジェクトリスト

**実装例**:
```java
assertObjectPropertyEquals(message, sheetName, "expectedUsers", users);
```

**Excelファイル記述例**（`LIST_MAP=expectedUsers`）:

| kanjiName | kanaName | mailAddress |
|-----------|----------|-------------|
| 漢字氏名 | カナシメイ | test@anydomain.com |

<details>
<summary>keywords</summary>

HttpRequestTestSupport, assertObjectPropertyEquals, assertObjectArrayPropertyEquals, assertObjectListPropertyEquals, プロパティ検証

</details>

## 

なし

<details>
<summary>keywords</summary>

特殊値記述, tips_test_data

</details>

## テストデータに空白、空文字やnullを記述したい

`空白`、`空文字`（`""`）、`null` の記述方法については :ref:`special_notation_in_cell` を参照。

<details>
<summary>keywords</summary>

特殊値, 空文字, null, 空白, special_notation_in_cell

</details>

## 

なし

<details>
<summary>keywords</summary>

空行記述, how_to_express_empty_line

</details>

## テストデータに空行を記述したい

全くの空行は無視されるため、可変長ファイル等でテストデータに空行を含める場合は :ref:`special_notation_in_cell` の `""` を使用して空行を表す。行のうちいずれか1セルに `""` を記載すれば十分（全セル埋める必要はない）。可読性のため左端セルに `""` を記載することを推奨。

**記述例**（2レコード目が空行）:

| name | address |
|------|---------|
| 山田 | 東京都 |
| "" | |
| 田中 | 大阪府 |

<details>
<summary>keywords</summary>

空行, テストデータ, SETUP_VARIABLE, ダブルクォーテーション, 可変長ファイル

</details>

## 

なし

<details>
<summary>keywords</summary>

マスタデータ変更, how_to_change_master_data

</details>

## マスタデータを変更してテストを行いたい

マスタデータを変更してテストを行う方法については [04_MasterDataRestore](testing-framework-04_MasterDataRestore.md) を参照。

<details>
<summary>keywords</summary>

マスタデータ変更, 04_MasterDataRestore

</details>

## 

なし

<details>
<summary>keywords</summary>

テストデータディレクトリ変更, how_to_change_test_data_dir

</details>
