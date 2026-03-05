# 目的別API使用方法

## 概要

目的別のAPIの使用方法を説明する。

* :ref:`how_to_get_data_from_excel`
* :ref:`how_to_run_the_same_test`
* :ref:`tips_groupId`
* :ref:`how_to_fix_date`
* :ref:`how_to_numbering_sequence`
* :ref:`using_ThreadContext`
* :ref:`using_TestDataParser`
* :ref:`using_junit_annotation`
* :ref:`using_transactions`
* :ref:`using_ohter_class`
* :ref:`how_to_assert_property_from_excel`
* :ref:`tips_test_data`
* :ref:`how_to_express_empty_line`
* :ref:`how_to_change_master_data`
* :ref:`how_to_change_test_data_dir`
* :ref:`how_to_convert_test_data`

## Excelファイルから、入力パラメータや戻り値に対する期待値などを取得したい

テスト実行時の引数や戻り値の期待値をExcelに記載し、`List<Map<String, String>>`形式で取得できる。

**Excel書式**:
```
LIST_MAP=<シート内で一意になるID>
```

2行目がMapのキー、3行目以降がMapの値と解釈される。

**API**:
- `TestSupport#getListMap(String sheetName, String id)`
- `DbAccessTestSupport#getListMap(String sheetName, String id)`

第1引数: シート名、第2引数: ID

**実装例**:
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

**Excel例**:
```
LIST_MAP=parameters

| empNo | expected |
|-------|----------|
| 00001 | 山田太郎 |
| 00002 | 鈴木一郎 |
```

取得されるListオブジェクトの構造:
```java
List<Map<String, String>> list = new ArrayList<Map<String, String>>();
Map<String, String> first = new HashMap<String, String>();
first.put("empNo","00001");
first.put("expected", "山田太郎");
list.add(first);
Map<String, String> second = new HashMap<String, String>();
second.put("empNo","00002");
map.put("expected", "鈴木一郎");
list.add(second);
```

## 同じテストメソッドをテストデータを変えて実行したい

List-Map取得メソッドでテストをループ実行することで、Excelデータを追加するだけでテストバリエーションを増やせる。

**実装例**:
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

**Excel例**:
```
// ループさせるデータ
LIST_MAP=parameters

| empNo | expectedDataId |
|-------|----------------|
| 00001 | expected01     |
| 00002 | expected02     |

// 準備データ
SETUP_TABLE=EMPLOYEE

| NO    | NAME     |
|-------|----------|
| 00001 | 山田太郎 |
| 00002 | 鈴木一郎 |

// 期待値データ1
LIST_MAP=expected01

| NO    | NAME     |
|-------|----------|
| 00001 | 山田太郎 |

// 期待値データ2
LIST_MAP=expected02

| NO    | NAME     |
|-------|----------|
| 00001 | 山田太郎 |
```

> **重要**: 更新系テストではループ内で`setUpDb`を呼び出すこと。そうしないとテスト成否がデータ順序に依存する。

## 一つのシートに複数テストケースのデータを記載したい

グループIDを付与することで複数テストケースのデータを1シートに混在させられる。

**対応データタイプ**:
- `EXPECTED_TABLE`
- `SETUP_TABLE`

**書式**:
```
データタイプ[グループID]=テーブル名
```

オーバーロードメソッドにグループIDを渡すことで、指定グループのデータのみを処理できる。

**実装例**:
```java
// グループ"case_001"のデータのみ登録
setUpDb("testUpdate", "case_001");

// グループ"case_001"のデータのみアサート
assertTableEquals("データベース更新結果確認", "testUpdate", "case_001");
```

**Excel例**:
```
// ケース001: 従業員の所属を変更する
SETUP_TABLE[case_001]=EMPLOYEE_TABLE

| ID    | EMP_NAME | DEPT_CODE |
|-------|----------|-----------|  
| 00001 | 山田太郎 | 0001      |
| 00002 | 田中一郎 | 0002      |

EXPECTED_TABLE[case_001]=EMPLOYEE_TABLE

| ID    | EMP_NAME | DEPT_CODE |
|-------|----------|-----------|  
| 00001 | 山田太郎 | 0001      |
| 00002 | 田中一郎 | 0010      | // 更新

// ケース002: 従業員の氏名を変更する
SETUP_TABLE[case_002]=EMPLOYEE_TABLE

| ID    | EMP_NAME | DEPT_CODE |
|-------|----------|-----------|  
| 00001 | 山田太郎 | 0001      |
| 00002 | 田中一郎 | 0002      |

EXPECTED_TABLE[case_002]=EMPLOYEE_TABLE

| ID    | EMP_NAME | DEPT_CODE |
|-------|----------|-----------|  
| 00001 | 佐藤太郎 | 0001      | // 更新
| 00002 | 田中一郎 | 0002      |
```

> **重要**: グループIDのデータは :ref:`auto-test-framework_multi-datatype` のようにグループごとにまとめて記述すること。まとめないとデータ読み込みが途中で終了しテストが正しく実行されない。

## システム日時を任意の値に固定したい

システム日付を含むテストで、日によって結果が変わる問題を解決するため、システム日時を固定値に設定できる。

`SystemTimeProvider`の実装を`FixedSystemTimeProvider`に差し替えることで、任意のシステム日時を返せる。

**設定例**:
```xml
<component name="systemTimeProvider"
    class="nablarch.test.FixedSystemTimeProvider">
  <property name="fixedDate" value="20100913123456" />
</component>
```

**プロパティ**:

| プロパティ名 | 設定内容 |
|-------------|----------|
| fixedDate | 指定したい日時。フォーマット: `yyyyMMddHHmmss` (12桁) または `yyyyMMddHHmmssSSS` (15桁) |

**使用例**:
```java
SystemTimeProvider provider = (SystemTimeProvider) SystemRepository.getObject("systemTimeProvider");
Date now = provider.getDate();
```

## シーケンスオブジェクトを使った採番のテストをしたい

シーケンスオブジェクトを使用した採番処理では次の採番値が予測不可能で期待値を設定できない。テストでは設定ファイルの変更のみでシーケンス採番をテーブル採番に置き換えることで検証可能にする。

手順: (1) 準備データをテーブルにセットアップ (2) 期待値はテーブル設定値を元に設定

**本番環境設定例（シーケンスオブジェクト使用）**:
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

**テスト環境設定（テーブル採番に置換）**:
```xml
<component name="idGenerator" class="nablarch.common.idgenerator.FastTableIdGenerator">
    <property name="tableName" value="TEST_SBN_TBL"/>
    <property name="idColumnName" value="ID_COL"/>
    <property name="noColumnName" value="NO_COL"/>
    <property name="dbTransactionManager" ref="dbTransactionManager" />
</component>
```

> **補足**: 設定値の詳細は `IdGenerator` を参照

**Excelテストデータ記述例**:

準備データ（`SETUP_TABLE=TEST_SBN_TBL`）:
| ID_COL | NO_COL |
|--------|--------|
| 1101   | 100    |

> **補足**: テスト範囲内で使用する採番対象のレコードのみ設定

期待値（`EXPECTED_TABLE=TEST_SBN_TBL`）:
| ID_COL | NO_COL |
|--------|--------|
| 1101   | 101    |

期待値（`EXPECTED_TABLE=USER_INFO`）:
| USER_ID    | KANJI_NAME | KANA_NAME |
|------------|------------|-----------||
| 0000000101 | 漢字名     | ｶﾅﾒｲ      |

> **補足**: この例ではテスト内で1度のみ採番を想定。期待値は「準備データの値 + 1」

## ThreadContextにユーザID、リクエストIDなどを設定したい

Nablarch Application Frameworkでは通常ThreadContextにユーザID・リクエストIDが設定済みだが、データベースアクセスクラスの単体テストではフレームワークを経由しないため未設定となる。

**設定メソッド**:
- `TestSupport#setThreadContextValues(String sheetName, String id)`
- `DbAccessTestSupport#setThreadContextValues(String sheetName, String id)`

Excelファイルにデータを記述し、上記メソッドを呼び出すことでThreadContextに値を設定できる。

> **重要**: 自動設定項目を使用したDB登録・更新では、ThreadContextにリクエストIDとユーザIDの設定が必須。テスト対象クラス起動前に設定すること。

**テストコード実装例**:
```java
public class DbAccessTestSample extends DbAccessTestSupport {
    @Test
    public void testInsert() {
        setThreadContextValues("testSelect", "threadContext");
        // ...
    }
}
```

**Excelデータ記述例** (`LIST_MAP=threadContext`):
| USER_ID | REQUEST_ID | LANG  |
|---------|------------|-------|
| U00001  | RS000001   | ja_JP |

## 任意のディレクトリのExcelファイルを読み込みたい

テストソースコードと同じディレクトリのExcelファイルはシート名指定のみで読み込み可能。別ディレクトリのファイルを読み込む場合は、TestDataParser実装クラスを直接使用する。

**実装例**:
```java
TestDataParser parser = (TestDataParser) SystemRepository.getObject("testDataParser");
List<Map<String, String>> list = parser.getListMap("/foo/bar/Baz.xlsx", "sheet001", "params");
```

## テスト実行前後に共通処理を行いたい

JUnit4のアノテーション（`@Before`, `@After`, `@BeforeClass`, `@AfterClass`）を使用してテスト実行前後の共通処理を実行できる。

## @BeforeClass, @AfterClass使用時の注意点

**注意**: サブクラスでスーパークラスと同名・同アノテーションのメソッドを作成しないこと。同名メソッドに同種アノテーションを付与すると、スーパークラスのメソッドは起動されない。

**誤った実装例**:
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

上記TestSubを実行すると「test」のみ表示される（スーパークラスのメソッドは実行されない）。

## デフォルト以外のトランザクションを使用したい

データベースアクセスクラスの単体テストでは、通常データベースアクセスクラス自身はトランザクション制御を行わないため、テストクラス側で制御が必要。

テスティングフレームワークはトランザクション自動制御機構を提供。プロパティファイルにトランザクション名を記載すれば、テストメソッド実行前後に自動的にトランザクション開始・終了を行う。これにより明示的なトランザクション開始が不要となり、終了処理漏れも防止できる。

**利用手順**: テストクラスで`DbAccessTestSupport`を継承する（スーパークラスの`@Before`、`@After`メソッドが自動呼び出しされる）。

## 本フレームワークのクラスを継承せずに使用したい

別クラスを継承する必要があり本フレームワークのスーパークラスを継承できない場合、スーパークラスをインスタンス化して処理を委譲することで代替可能。

**委譲使用時の制約**:
- コンストラクタにテストクラス自身のClassインスタンスを渡す
- `@Before`メソッド、`@After`メソッドは明示的に呼び出す

**実装例**:
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
        // ...
        dbSupport.assertSqlResultSetEquals("test", "id", actual);
    }
}
```

## クラスのプロパティを検証したい

テスト対象クラスのプロパティをExcelファイル記述データと比較検証できる。

Excelデータ形式: 2行目がプロパティ名、3行目以降が検証値。

**検証メソッド**:
- `HttpRequestTestSupport#assertObjectPropertyEquals(String message, String sheetName, String id, Object actual)`
- `HttpRequestTestSupport#assertObjectArrayPropertyEquals(String message, String sheetName, String id, Object[] actual)`
- `HttpRequestTestSupport#assertObjectListPropertyEquals(String message, String sheetName, String id, List<?> actual)`

引数: (1) エラーメッセージ (2) シート名 (3) ID (4) 検証対象（オブジェクト/配列/リスト）

**実装例**:
```java
public class UserUpdateActionRequestTest extends HttpRequestTestSupport {
    @Test
    public void testRW11AC0301Normal() {
        execute("testRW11AC0301Normal", new BasicAdvice() {
            @Override
            public void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
                String message = testCaseInfo.getTestCaseName();
                String sheetName = testCaseInfo.getSheetName();
                UserForm form = (UserForm) context.getRequestScopedVar("user_form");
                UsersEntity users = form.getUsers();
                assertObjectPropertyEquals(message, sheetName, "expectedUsers", users);
            }
        });
    }
}
```

**Excelデータ記述例** (`LIST_MAP=expectedUsers`):
| kanjiName | kanaName     | mailAddress            |
|-----------|--------------|------------------------|
| 漢字氏名  | カナシメイ   | test@anydomain.com     |

## テストデータに空白、空文字、改行やnullを記述したい

:ref:`special_notation_in_cell` を参照。

## テストデータに空行を記述したい

可変長ファイルを扱う場合等でテストデータに空行を含めたい場合がある。全くの空行は無視されるため、:ref:`special_notation_in_cell` のダブルクォーテーションを使用して `""` と記述することで空行を表す。

**記述例** (`SETUP_VARIABLE=/path/to/file.csv`):
| name | address |
|------|---------||
| 山田 | 東京都  |
| ""   |         |
| 田中 | 大阪府  |

2レコード目が空行となる。

> **補足**: 空行を表す場合、全セルを `""` で埋める必要はない。行のうちいずれか1セルのみでよい。可読性のため左端セルへの記載を推奨。

## マスタデータを変更してテストを行いたい

:doc:`04_MasterDataRestore` を参照。

## テストデータ読み込みディレクトリを変更したい

**デフォルト**: テストデータは`test/java`配下から読み込み。

**設定変更**: コンポーネント設定ファイルに以下を追加:

| プロパティ名 | 説明 |
|---|---|
| nablarch.test.resource-root | カレントディレクトリからの相対パス。セミコロン(;)区切りで複数指定可 |

**例**:
```
nablarch.test.resource-root=path/to/test-data-dir
```

**複数指定**:
```
nablarch.test.resource-root=test/online;test/batch
```

> **注意**: 複数指定時、同名ファイルは最初に発見されたものを使用。

> **補足**: VM引数で一時変更可能: `-Dnablarch.test.resource-root=path/to/test-data-dir`

## メッセージング処理でテストデータに対し定型的な変換処理を追加したい

**デフォルト**: テストデータは指定エンコーディングでバイト列変換のみ。

**カスタム変換追加**: `TestDataConverter`実装をシステムリポジトリ登録。

**インタフェース**: `nablarch.test.core.file.TestDataConverter`

**システムリポジトリ登録**:

| キー | 値 |
|---|---|
| TestDataConverter_<データ種別> | 実装クラス名。データ種別はfile-type指定値 |

**設定例**:
```xml
<component name="TestDataConverter_FormUrlEncoded" 
           class="please.change.me.test.core.file.FormUrlEncodedTestDataConverter"/>
```

![Excel記述例](../../knowledge/development-tools/testing-framework/assets/testing-framework-03_Tips/data_convert_example.png)

コンバータ実装により内部的に以下と同等:

![内部表現](../../knowledge/development-tools/testing-framework/assets/testing-framework-03_Tips/data_convert_internal.png)
