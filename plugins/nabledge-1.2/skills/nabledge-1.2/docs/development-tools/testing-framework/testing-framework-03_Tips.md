# 目的別API使用方法

## Excelファイルから、入力パラメータや戻り値に対する期待値などを取得したい

`LIST_MAP=<ID>` データタイプを使用して、ExcelファイルのデータをList-Map形式（`List<Map<String, String>>`）で取得できる。データの2行目はMapのKey、3行目以降はMapのValueと解釈される。第1引数にシート名、第2引数にIDを指定する。

**クラス**: `TestSupport`, `DbAccessTestSupport`

**メソッド**:
- `TestSupport#getListMap(String sheetName, String id)`
- `DbAccessTestSupport#getListMap(String sheetName, String id)`

```java
List<Map<String, String>> parameters = getListMap("testGetName", "parameters");
Map<String, String> param = parameters.get(0);
String empNo = param.get("empNo");
String expected = param.get("expected");
EmployeeComponent target = new EmployeeComponent();
String actual = target.getName(empNo);
assertEquals(expected, actual);
```

Excelファイル記述形式:
```
LIST_MAP=parameters

| empNo | expected |
|-------|----------|
| 00001 | 山田太郎 |
| 00002 | 鈴木一郎 |
```

シーケンスオブジェクトによる採番は実行時まで値が確定しないため期待値を事前に設定できない。テスティングフレームワークは設定ファイルの変更のみでシーケンス採番をテーブル採番に切り替える機能を提供する。

テスト手順:
1. 採番用テーブルに準備データをセットアップ
2. 期待値はテーブルに設定した値を元に設定

**本番用設定（OracleSequenceIdGenerator）**:
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

**テスト用設定（FastTableIdGeneratorでテーブル採番に置き換え）**:
```xml
<component name="idGenerator" class="nablarch.common.idgenerator.FastTableIdGenerator">
    <property name="tableName" value="TEST_SBN_TBL"/>
    <property name="idColumnName" value="ID_COL"/>
    <property name="noColumnName" value="NO_COL"/>
    <property name="dbTransactionManager" ref="dbTransactionManager"/>
</component>
```

> **注意**: テーブル採番用の設定値の詳細は [Nablarch採番機能](../../component/libraries/libraries-06_IdGenerator.md) を参照。

**Excelテストデータ記述例**（採番対象ID:1101の場合）:

準備データ（SETUP_TABLE=TEST_SBN_TBL）:
| ID_COL | NO_COL |
|--------|--------|
| 1101 | 100 |

> **注意**: 採番用テーブルに準備データを設定する。準備データでは、テスト範囲内で使用する採番対象のレコードのみを設定する。

期待値（EXPECTED_TABLE=TEST_SBN_TBL）:
| ID_COL | NO_COL |
|--------|--------|
| 1101 | 101 |

期待値（EXPECTED_TABLE=USER_INFO）:
| USER_ID | KANJI_NAME | KANA_NAME |
|---------|------------|-----------|
| 0000000101 | 漢字名 | ｶﾅﾒｲ |

> **注意**: テスト内で1度のみ採番処理が行われる場合、期待値は「準備データの値 + 1」となる。

テストデータの読み込みディレクトリはデフォルトで `test/java` 配下。変更するにはコンポーネント定義ファイルに以下を設定する。

| プロパティ名 | 説明 |
|---|---|
| `nablarch.test.resource-root` | テスト実行時のカレントディレクトリからの相対パス。セミコロン(`;`)区切りで複数指定可 |

単一ディレクトリ設定例:
```
nablarch.test.resource-root=path/to/test-data-dir
```

複数ディレクトリ設定例:
```
nablarch.test.resource-root=test/online;test/batch
```

> **補足**: 設定ファイルを変更せずに一時的に変更したい場合は、VM引数で代替可能: `-Dnablarch.test.resource-root=path/to/test-data-dir`

> **注意**: 複数ディレクトリを指定した場合、同名のテストデータが存在すると最初に発見されたものが読み込まれる。

<details>
<summary>keywords</summary>

TestSupport, DbAccessTestSupport, getListMap, LIST_MAP, List<Map<String, String>>, ExcelデータをList-Map形式で取得, テストデータ取得, シーケンスオブジェクト採番テスト, OracleSequenceIdGenerator, FastTableIdGenerator, テーブル採番, TEST_SBN_TBL, id-generator-top, SETUP_TABLE, EXPECTED_TABLE, tableName, idColumnName, noColumnName, nablarch.test.resource-root, テストデータディレクトリ変更, 複数ディレクトリ指定, VM引数, テストデータ読み込みパス

</details>

## 同じテストメソッドをテストデータを変えて実行したい

List-Map取得メソッドでデータをループ処理することで、同一テストメソッドを複数データで実行できる。Excelデータを追加するだけでデータバリエーションを増やせる。

```java
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
```

> **警告**: 更新系のテストを行う場合は、ループ内で`setUpDb`メソッドを呼び出すこと。そうでないと、テストの成否がデータの順番に依存してしまう。

データベースアクセスクラスの自動テストではフレームワークを経由せずテストクラスからテスト対象クラスを直接起動するため、ThreadContextに値が設定されていない。Excelファイルに設定値を記述して以下のメソッドを呼び出すことでThreadContextに値を設定できる。

- `TestSupport#setThreadContextValues(String sheetName, String id)`
- `DbAccessTestSupport#setThreadContextValues(String sheetName, String id)`

> **注意**: 自動設定項目を利用してデータベースに登録・更新する際は、ThreadContextにリクエストIDとユーザIDが設定されている必要がある。テスト対象クラス起動前に設定しておくこと。

**テストソースコード実装例**:
```java
public class DbAccessTestSample extends DbAccessTestSupport {
    @Test
    public void testInsert() {
        setThreadContextValues("testSelect", "threadContext");
        // ...
    }
}
```

**テストデータ記述例**（シート[testInsert]、LIST_MAP=threadContext）:

| USER_ID | REQUEST_ID | LANG |
|---------|------------|------|
| U00001 | RS000001 | ja_JP |

<details>
<summary>keywords</summary>

getListMap, setUpDb, assertSqlResultSetEquals, ループテスト, 同一テストメソッドの複数データ実行, データバリエーション, ThreadContext, setThreadContextValues, DbAccessTestSupport, TestSupport, リクエストID設定, ユーザID設定, LIST_MAP

</details>

## 一つのシートに複数テストケースのデータを記載したい

グループIDを付与することで、複数テストケースのデータを1シートに混在させることができる。

サポートされるデータタイプ: `EXPECTED_TABLE`, `SETUP_TABLE`

書式: `データタイプ[グループID]=テーブル名`

例: `SETUP_TABLE[case_001]=EMPLOYEE_TABLE`, `EXPECTED_TABLE[case_001]=EMPLOYEE_TABLE`

テストクラス側では、グループIDを引数に持つオーバーロードメソッドを使用することで、指定したグループIDのデータのみを処理対象とする。

```java
// DBにデータ登録（グループIDが"case_001"のものだけ登録対象になる）
setUpDb("testUpdate", "case_001");

// 結果確認（グループIDが"case_001"のものだけassert対象になる）
assertTableEquals("データベース更新結果確認", "testUpdate", "case_001");
```

テストソースコードと同じディレクトリのExcelファイルはシート名指定のみで読み込み可能だが、別ディレクトリのファイルを読み込む場合は `TestDataParser` 実装クラスを直接使用する。

**実装例**（"/foo/bar/Baz.xls" の "sheet001" シートから読み込む場合）:
```java
TestDataParser parser = (TestDataParser) SystemRepository.getObject("testDataParser");
List<Map<String, String>> list = parser.getListMap("/foo/bar/Baz.xls", "sheet001", "params");
```

<details>
<summary>keywords</summary>

グループID, SETUP_TABLE, EXPECTED_TABLE, setUpDb, assertTableEquals, 複数テストケース1シート管理, テーブルデータグルーピング, TestDataParser, getListMap, 任意ディレクトリExcel読み込み, SystemRepository

</details>

## システム日時を任意の値に固定したい

`FixedSystemTimeProvider` を使用してコンポーネント定義で `SystemTimeProvider` 実装を差し替えることで、システム日時を任意の固定値に設定できる。

**クラス**: `nablarch.test.FixedSystemTimeProvider`

```xml
<component name="systemTimeProvider"
    class="nablarch.test.FixedSystemTimeProvider">
  <property name="fixedDate" value="20100913123456" />
</component>
```

| プロパティ名 | 説明 |
|---|---|
| fixedDate | 固定する日時。フォーマット: `yyyyMMddHHmmss`（12桁）または `yyyyMMddHHmmssSSS`（15桁） |

```java
SystemTimeProvider provider = (SystemTimeProvider) SystemRepository.getObject("systemTimeProvider");
Date now = provider.getDate();
```

JUnit4のアノテーション（`@Before`, `@After`, `@BeforeClass`, `@AfterClass`）を使用することで、テスト実行前後に共通処理を実行できる。

<details>
<summary>keywords</summary>

FixedSystemTimeProvider, SystemTimeProvider, fixedDate, システム日時固定, テスト用日時設定, @Before, @After, @BeforeClass, @AfterClass, テスト共通処理, JUnit4

</details>

## 採番テーブルを使用した採番をテストしたい

採番テーブルを使用した採番をテストする場合、採番値を固定するためのテスト用クラスを使用する。

本フレームワークでは、採番テーブルを使用した採番処理をテストするためのサポート機能を提供する。採番値を固定することにより、採番結果を検証する自動テストを実現できる。

`@BeforeClass`, `@AfterClass` 使用時の注意: サブクラスにてスーパークラスと同名・同じアノテーションを付与したメソッドを作成してはならない。同名メソッドに同種アノテーションを付与した場合、スーパークラスのメソッドは起動されなくなる。

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

上記TestSubを実行した場合、「test」のみ表示される（スーパークラスのsetUpBeforeClassは実行されない）。

<details>
<summary>keywords</summary>

how_to_numbering_sequence, 採番, シーケンス, 採番テーブル, 採番テスト, @BeforeClass, @AfterClass, スーパークラス継承, アノテーション上書き, setUpBeforeClass

</details>

## ThreadContextを使用したい

ThreadContextはスレッドローカルなコンテキスト情報（ユーザID、リクエストIDなど）を保持するクラスである。テストクラスでThreadContextを使用する場合は、テスト用の設定を行う必要がある。

Nablarchのテストサポートクラスを継承したテストクラスでは、テストメソッドの実行前後にThreadContextが適切に初期化・クリアされる。

**クラス**: `ThreadContext`

データベースアクセスクラスはトランザクション制御を行わないため、テストクラス側でトランザクション制御が必要。テスティングフレームワークはプロパティファイルにトランザクション名を記載しておくことで、テストメソッド実行前にトランザクション開始・終了後に終了する機構を提供する。これにより個別テストでの明示的なトランザクション開始・終了処理および終了処理漏れがなくなる。

利用手順: テストクラスにて `DbAccessTestSupport` を継承する（スーパークラスの `@Before`、`@After` メソッドが自動的に呼び出される）。

<details>
<summary>keywords</summary>

ThreadContext, using_ThreadContext, スレッドコンテキスト, テスト用ThreadContext設定, DbAccessTestSupport, トランザクション制御, beginTransactions, endTransactions, プロパティファイル

</details>

## TestDataParserを使用したい

TestDataParserは、Excelファイルのテストデータを解析するためのクラスである。通常はテストサポートクラス（`TestSupport`, `DbAccessTestSupport`）経由で使用するが、直接使用することもできる。

**クラス**: `TestDataParser`

フレームワークのスーパークラスを継承できない場合は、スーパークラスをインスタンス化して処理を委譲することで代替できる。

委譲使用時の注意:
- コンストラクタにテストクラス自身の `Class` インスタンスを渡すこと
- 前処理（`@Before`）・後処理（`@After`）は明示的に呼び出すこと

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

<details>
<summary>keywords</summary>

TestDataParser, using_TestDataParser, テストデータパーサー, Excelデータ解析, DbAccessTestSupport, 委譲パターン, 継承なし, beginTransactions, endTransactions, setUpDb, assertSqlResultSetEquals

</details>

## JUnitのアノテーションを使用したい

NablarchのテストフレームワークはJUnitのアノテーション（`@Test`, `@Before`, `@After`, `@Rule` など）と組み合わせて使用できる。

テストサポートクラス（`DbAccessTestSupport` など）を継承しながら、JUnit標準のアノテーションを使用してテストを記述できる。

テスト対象クラスのプロパティの値をExcelファイルに記載したデータと比較検証できる。Excelデータは2行目がプロパティ名、3行目以降が検証値。

以下のメソッドで検証（第1引数: エラーメッセージ、第2引数: シート名、第3引数: ID、第4引数: 検証対象）:
- `HttpRequestTestSupport#assertObjectPropertyEquals(String message, String sheetName, String id, Object actual)`
- `HttpRequestTestSupport#assertObjectArrayPropertyEquals(String message, String sheetName, String id, Object[] actual)`
- `HttpRequestTestSupport#assertObjectListPropertyEquals(String message, String sheetName, String id, List<?> actual)`

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

**Excelファイル記述例**（LIST_MAP=expectedUsers）:

| kanjiName | kanaName | mailAddress |
|-----------|----------|-------------|
| 漢字氏名 | カナシメイ | test@anydomain.com |

<details>
<summary>keywords</summary>

using_junit_annotation, JUnitアノテーション, テストアノテーション, Rule, HttpRequestTestSupport, assertObjectPropertyEquals, assertObjectArrayPropertyEquals, assertObjectListPropertyEquals, プロパティ検証, LIST_MAP, BasicAdvice, TestCaseInfo

</details>

## トランザクションを制御したい

テスト実行中のトランザクション制御については、`DbAccessTestSupport` を継承したテストクラスでは、各テストメソッドの実行後に自動的にロールバックされるよう制御される。

これにより、テスト間でデータベース状態が干渉しないようになっている。トランザクション境界を明示的に制御する必要がある場合は、テストサポートクラスが提供するメソッドを使用する。

テストデータに空白、空文字、nullを記述する方法は :ref:`special_notation_in_cell` を参照。

<details>
<summary>keywords</summary>

using_transactions, トランザクション, テスト用トランザクション制御, コミット, ロールバック, special_notation_in_cell, 空白, 空文字, null, テストデータ特殊記法

</details>

## その他のクラスを使用したい

テストフレームワークでは、テスト支援のためのユーティリティクラスが複数提供されている。これらのクラスを使用することで、テストコードの記述を簡略化できる。

主なサポートクラスは `nablarch.test` パッケージ以下に格納されている。

全くの空行は無視されるため、ダブルクォーテーション `""` を使用して空文字列を記述することで空行を表現できる。

> **注意**: 空行を表す場合、全てのセルを `""` で埋める必要はない。行のうちいずれか1セルだけでよい（可読性のため左端のセルに `""` を記載することを推奨）。

**記述例**（SETUP_VARIABLE=/path/to/file.csv、2レコード目が空行）:

| name | address |
|------|---------|
| 山田 | 東京都 |
| "" |  |
| 田中 | 大阪府 |

<details>
<summary>keywords</summary>

using_ohter_class, ユーティリティクラス, テストサポートクラス, 空行, ダブルクォーテーション, 空文字列, 可変長ファイル, SETUP_VARIABLE

</details>

## Excelファイルから取得したデータでプロパティをアサートしたい

JavaBeanのプロパティ値をExcelファイルに記載した期待値と比較してアサートできる。`assertProperties` メソッドを使用することで、ExcelシートのデータとJavaBeanのプロパティを一括で検証できる。

Excelファイルにはプロパティ名と期待値を記載し、テストコードからプロパティ名とBeanオブジェクトを渡してアサートを実行する。

マスタデータを変更してテストを行う方法は [04_MasterDataRestore](testing-framework-04_MasterDataRestore.md) を参照。

<details>
<summary>keywords</summary>

how_to_assert_property_from_excel, assertProperties, プロパティアサート, JavaBean, Excelアサート, マスタデータ変更, 04_MasterDataRestore

</details>

## テストデータに関するTips

テストデータ管理に関するTipsを以下に示す。

- テストデータのExcelファイルは、テストクラスと同じディレクトリに配置するのが基本である
- 1つのExcelファイルに複数テストメソッドのデータを記載できる（シートで分割）
- データタイプのIDは、シート内で一意になるよう命名する
- 大量のテストケースがある場合は、グループIDを活用して1シートにまとめることを検討する

<details>
<summary>keywords</summary>

tips_test_data, テストデータ, Excelテストデータ, テストデータ管理

</details>

## Excelファイルで空行や空値を表現したい

Excelのテストデータで空行や空値（NULL）を表現する方法について説明する。

Excelテストデータで空値を表現する場合は、セルを空欄のままにする。空文字列（長さ0の文字列）とNULLを区別したい場合は、フレームワークが定める特殊な表記方法を使用する。

また、テストデータの区切りとして空行を使用したい場合は、データタイプ行（`LIST_MAP=xxx` など）の直後にデータ行を記述することで区切りを表現できる。

<details>
<summary>keywords</summary>

how_to_express_empty_line, 空行, 空値, NULL, テストデータ空表現

</details>

## マスタデータを変更したい

テスト実行時のマスタデータを変更したい場合は、テスト用のマスタデータをExcelファイルに定義して投入する。

`SETUP_TABLE` データタイプを使用してテスト用マスタデータを定義し、`setUpDb` メソッドで投入することで、テスト実行時のマスタデータを制御できる。テスト終了後はロールバックによりデータが元の状態に戻る。

<details>
<summary>keywords</summary>

how_to_change_master_data, マスタデータ変更, テスト用マスタデータ, MASTER_TABLE

</details>

## テストデータのディレクトリを変更したい

テストデータのExcelファイルが配置されるディレクトリのデフォルトはテストクラスと同じディレクトリであるが、設定により変更できる。

テストデータのディレクトリを変更する場合は、テストサポートクラスが提供する設定方法を使用する。これにより、複数のテストクラスで共通のテストデータを共有したり、テストデータを別ディレクトリで管理したりすることが可能になる。

<details>
<summary>keywords</summary>

how_to_change_test_data_dir, テストデータディレクトリ, baseDir, テストデータパス変更

</details>
