# 目的別API使用方法

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/03_Tips.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/idgenerator/IdGenerator.html)

## Excelファイルから、入力パラメータや戻り値に対する期待値などを取得したい

データタイプ`LIST_MAP=<ID>`を使用してExcelファイルからList<Map<String,String>>形式のデータを取得できる。

- データ2行目: MapのKey
- データ3行目以降: MapのValue

**メソッド**: `TestSupport#getListMap(String sheetName, String id)`, `DbAccessTestSupport#getListMap(String sheetName, String id)`（第1引数: シート名、第2引数: ID）

```java
List<Map<String, String>> parameters = getListMap("testGetName", "parameters");
Map<String, String> param = parameters.get(0);
String empNo = param.get("empNo");
String expected = param.get("expected");
```

Excelシート記述形式（`LIST_MAP=parameters`）:

| empNo | expected |
|---|---|
| 00001 | 山田太郎 |
| 00002 | 鈴木一郎 |

<details>
<summary>keywords</summary>

TestSupport, DbAccessTestSupport, getListMap, LIST_MAP, List-Map形式, Excelデータ取得, テストパラメータ取得

</details>

## 同じテストメソッドをテストデータを変えて実行したい

List-Mapで取得したデータをループしてテストを実行することで、Excelデータを追加するだけでデータバリエーションを増やせる。

```java
List<Map<String, String>> parameters = getListMap("testGetName", "parameters");
for (Map<String, String> param : parameters) {
    String empNo = param.get("empNo");
    String expectedDataId = param.get("expectedDataId");
    SqlResultSet actual = target.selectByPk(empNo);
    assertSqlResultSetEquals("testSelectByPk", expectedDataId, actual);
}
```

> **重要**: 更新系のテストを行う場合、ループ内で`setUpDb`を呼び出すこと。そうしないとテストの成否がデータの順番に依存する。

<details>
<summary>keywords</summary>

getListMap, ループテスト, テストデータバリエーション, setUpDb, パラメータ化テスト

</details>

## 一つのシートに複数テストケースのデータを記載したい

グループIDを付与することで、`EXPECTED_TABLE`と`SETUP_TABLE`の複数テストケースのデータを1シートに混在させることができる。

**サポートデータタイプ**: `EXPECTED_TABLE`, `SETUP_TABLE`

書式: `データタイプ[グループID]=テーブル名`

```java
// グループID "case_001" のデータのみ登録
setUpDb("testUpdate", "case_001");
// グループID "case_001" のデータのみassert
assertTableEquals("データベース更新結果確認", "testUpdate", "case_001");
```

Excel記述例:
```
SETUP_TABLE[case_001]=EMPLOYEE_TABLE
EXPECTED_TABLE[case_001]=EMPLOYEE_TABLE

SETUP_TABLE[case_002]=EMPLOYEE_TABLE
EXPECTED_TABLE[case_002]=EMPLOYEE_TABLE
```

> **注意**: 複数グループIDのデータを記述する際は、グループIDごとにまとめて記述すること。まとめて記述しないとデータ読み込みが途中で終了しテストが正しく実行されない。

<details>
<summary>keywords</summary>

グループID, EXPECTED_TABLE, SETUP_TABLE, setUpDb, assertTableEquals, 複数テストケース, シート管理

</details>

## システム日時を任意の値に固定したい

**クラス**: `nablarch.test.FixedSystemTimeProvider`

コンポーネント設定ファイルの`systemTimeProvider`に`FixedSystemTimeProvider`を指定することで、任意のシステム日時を固定できる。

| プロパティ名 | 設定内容 |
|---|---|
| fixedDate | 固定日時文字列。形式: `yyyyMMddHHmmss`（12桁）または `yyyyMMddHHmmssSSS`（15桁） |

```xml
<component name="systemTimeProvider"
    class="nablarch.test.FixedSystemTimeProvider">
  <property name="fixedDate" value="20100913123456" />
</component>
```

```java
SystemTimeProvider provider = (SystemTimeProvider) SystemRepository.getObject("systemTimeProvider");
Date now = provider.getDate();
```

<details>
<summary>keywords</summary>

FixedSystemTimeProvider, SystemTimeProvider, SystemRepository, fixedDate, システム日時固定, テスト用固定日時

</details>

## 採番をテストしたい

シーケンス採番のテストでは、採番結果が実行タイミングに依存するため、テスト用に採番値を固定する必要がある。

Nablarchテスティングフレームワークでは、採番処理をテスト用の実装に差し替えることで、任意の採番値を返すようにできる。テスト用コンポーネント設定ファイルで、IdGeneratorインタフェースの実装クラスをモック実装に差し替えて使用する。

<details>
<summary>keywords</summary>

採番, シーケンス, IdGenerator, 採番テスト

</details>

## ThreadContextを使用したい

ThreadContextはリクエストスコープの情報（ユーザID、リクエストIDなど）を保持する。テストでThreadContextの値を設定する場合は、テスト用コンポーネント設定でスレッドコンテキスト変数定義を設定するか、テストコード内で直接`ThreadContext.setObject(String key, Object value)`を使用する。

テスト実行後はThreadContextの値がクリアされることを確認すること。

<details>
<summary>keywords</summary>

ThreadContext, スレッドコンテキスト, ThreadContext.setObject, リクエストスコープ

</details>

## TestDataParserを使用したい

TestDataParserはExcelなどのテストデータファイルを解析するクラス。直接インスタンス化して使用することで、テストデータをプログラムから柔軟に読み取れる。

TestDataParserを直接使用する場合は、データファイルのパスとシート名を指定してデータを取得する。通常はDbAccessTestSupportやTestSupportのメソッド経由で間接的に使用する。

<details>
<summary>keywords</summary>

TestDataParser, テストデータ解析, データファイル読み込み

</details>

## JUnitのアノテーションを使用したい

NablarchテスティングフレームワークはJUnitの標準アノテーションと組み合わせて使用できる。

- `@Test`: テストメソッドのマーク（標準JUnit）
- `@Rule` / `@ClassRule`: JUnit Ruleの適用
- `@Before` / `@After`: テスト前後の処理

DbAccessTestSupportなどの基底クラスはJUnit 4の`TestCase`を継承しているため、JUnit 4のアノテーションが使用可能。

<details>
<summary>keywords</summary>

JUnit, @Test, @Rule, @ClassRule, アノテーション

</details>

## トランザクションを使用したい

テストコードからトランザクションを制御する場合は、SimpleDbTransactionManagerなどのトランザクションマネージャを使用する。

DbAccessTestSupportを継承したテストでは、テストフレームワークが自動的にトランザクション管理を行う。各テストメソッド終了後にロールバックされるため、テスト間でデータが干渉しない。

手動でコミットが必要な場合は、トランザクションマネージャを取得してコミット操作を行う。

<details>
<summary>keywords</summary>

トランザクション, transaction, TransactionManager, コミット, ロールバック

</details>

## その他のクラスを使用したい

テスティングフレームワークが提供するその他のユーティリティクラスを使用することで、テスト実装を簡素化できる。

システムリポジトリからコンポーネントを取得する場合は`SystemRepository.getObject(String name)`を使用する。テスト用のコンポーネント設定ファイルをシステムリポジトリにロードした後、各コンポーネントを取得してテストに使用する。

<details>
<summary>keywords</summary>

テストサポートクラス, ユーティリティ, テストヘルパー

</details>

## Excelのデータを使ってBeanのプロパティをアサートしたい

ExcelファイルのデータをBeanのプロパティ検証に使用する場合、`assertProperties`メソッドが利用できる。

ExcelシートにBeanのプロパティ名と期待値を記載し、`assertProperties(String sheetName, String id, Object bean)`を呼び出すことで、Beanの各プロパティ値とExcelの期待値を一括比較できる。

これにより、多数のプロパティを持つBeanのアサーションを簡潔に記述できる。

クラスのプロパティ検証にはExcelファイルのデータと照合する以下のメソッドを使用する。引数: 第1引数=エラー時メッセージ、第2引数=シート名、第3引数=ID、第4引数=検証対象（Object/Object[]/List<?>）。

- `HttpRequestTestSupport#assertObjectPropertyEquals(String message, String sheetName, String id, Object actual)`
- `HttpRequestTestSupport#assertObjectArrayPropertyEquals(String message, String sheetName, String id, Object[] actual)`
- `HttpRequestTestSupport#assertObjectListPropertyEquals(String message, String sheetName, String id, List<?> actual)`

テストデータの記述方法は :ref:`how_to_get_data_from_excel` と同様。2行目がプロパティ名、3行目以降が検証値。

**テストコード例**:

```java
assertObjectPropertyEquals(message, sheetName, "expectedUsers", users);
```

**Excelデータ記述例**（`LIST_MAP=expectedUsers`）:

| kanjiName | kanaName | mailAddress |
|-----------|----------|-------------|
| 漢字氏名 | カナシメイ | test@anydomain.com |

<details>
<summary>keywords</summary>

assertProperties, Beanアサート, プロパティ検証, Excel期待値, assertObjectPropertyEquals, assertObjectArrayPropertyEquals, assertObjectListPropertyEquals, HttpRequestTestSupport

</details>

## テストデータに関するヒント

テストデータ記述に関するヒント:

- **NULL値**: Excelセルを空欄にするとNULLとして扱われる
- **空文字**: 空文字を明示的に指定する場合は特殊な記法を使用する
- **コメント行**: `//`で始まる行はコメントとして無視される
- **型指定**: 1行目（ヘッダ行の次）に型を指定できる（例: `// CHAR(5)`）
- **数値**: 数値データはそのまま記載可能

<details>
<summary>keywords</summary>

テストデータ, NULLデータ, 空文字, コメント行

</details>

## 空行を表現したい

Excelテストデータで空行（改行のみの文字列）を表現する場合、通常の空セルはNULLとして扱われるため区別が必要。

空文字（長さ0の文字列）を表現するには、テスティングフレームワークが定義する特殊な記法（空文字リテラル）を使用する。具体的な記法はフレームワークのバージョンに依存するため、公式ドキュメントを確認すること。

<details>
<summary>keywords</summary>

空行, 空文字, NULL, テストデータ空行

</details>

## マスタデータを変更したい

テスト実行前にマスタデータを投入・変更する場合は、`SETUP_TABLE`データタイプを使用してExcelシートにマスタデータを定義する。

```
SETUP_TABLE=CODE_MASTER
```

システム全体で共有するマスタデータはテストクラスの`setUpClass`相当の処理で投入し、テスト個別のマスタデータは各テストメソッドの`setUpDb`で投入する。

<details>
<summary>keywords</summary>

マスタデータ, SETUP_TABLE, マスタデータ投入, テスト用マスタ

</details>

## テストデータのディレクトリを変更したい

テストデータファイルのデフォルト配置ディレクトリを変更する場合は、コンポーネント設定ファイルでテストサポートクラスの`basePath`プロパティを設定する。

デフォルトではテストクラスと同一パッケージのリソースディレクトリにExcelファイルを配置するが、プロジェクト構成に合わせてディレクトリを変更できる。

:ref:`how_to_change_test_data_dir` を参照。テストデータの配置ディレクトリを変更する方法については、ソースドキュメントの当該セクションを確認すること。

<details>
<summary>keywords</summary>

テストデータディレクトリ, baseDir, データファイルパス, テストリソース, how_to_change_test_data_dir, テストデータ配置場所変更

</details>

## テストデータを変換したい

テストデータの型変換が必要な場合は、TestDataConverterインタフェースを実装したクラスを使用する。

Excelから読み取った文字列データをJavaの特定の型（Date、BigDecimalなど）に変換する際に使用する。カスタムコンバータを実装することで、プロジェクト固有の型変換ルールを適用できる。

<details>
<summary>keywords</summary>

テストデータ変換, データ変換, TestDataConverter, 型変換

</details>

## シーケンスオブジェクトを使った採番のテストをしたい

シーケンスオブジェクト採番は次に採番される値が予測不可なため、テスト用設定ファイルでテーブル採番（`nablarch.common.idgenerator.FastTableIdGenerator`）に置き換えることで期待値を設定できる。

手順:
1. 採番テーブルに準備データをセットアップ
2. 期待値はテーブルに設定した値を元に設定する

**本番用設定（シーケンスオブジェクトを使用した採番設定）**:

```xml
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

**テスト用設定（本番の`idGenerator`コンポーネントをテーブル採番用設定で上書き）**:

```xml
<component name="idGenerator" class="nablarch.common.idgenerator.FastTableIdGenerator">
    <property name="tableName" value="TEST_SBN_TBL"/>
    <property name="idColumnName" value="ID_COL"/>
    <property name="noColumnName" value="NO_COL"/>
    <property name="dbTransactionManager" ref="dbTransactionManager"/>
</component>
```

> **補足**: テーブル採番用の設定値の詳細は、`IdGenerator` を参照すること。

**Excelファイル記述例（採番対象ID:1101）**:

準備データ（`SETUP_TABLE=TEST_SBN_TBL`）:

| ID_COL | NO_COL |
|--------|--------|
| 1101 | 100 |

> **補足**: 採番用テーブルには、テスト範囲内で使用する採番対象のレコードのみを設定する。

期待値（`EXPECTED_TABLE=TEST_SBN_TBL`）:

| ID_COL | NO_COL |
|--------|--------|
| 1101 | 101 |

期待値（`EXPECTED_TABLE=USER_INFO`、採番した値が登録されるテーブル）:

| USER_ID | KANJI_NAME | KANA_NAME |
|------------|------------|----------|
| 0000000101 | 漢字名 | ｶﾅﾒｲ |

> **補足**: 本記述例では、テスト内で1度のみ採番処理が行われていることを想定している。このため、期待値は「準備データの値 + 1」となっている。

<details>
<summary>keywords</summary>

OracleSequenceIdGenerator, FastTableIdGenerator, シーケンスオブジェクト採番, テーブル採番, 採番テスト, idGenerator, IdGenerator

</details>

## ThreadContextにユーザID、リクエストIDなどを設定したい

データベースアクセスクラスの自動テストでは、フレームワークを経由せず直接起動するためThreadContextに値が設定されていない。ExcelファイルにLIST_MAPでデータを記述し、以下のメソッドを呼び出すことでThreadContextに値を設定できる。

- `TestSupport#setThreadContextValues(String sheetName, String id)`
- `DbAccessTestSupport#setThreadContextValues(String sheetName, String id)`

> **補足**: 自動設定項目を使用してDBを登録・更新する際は、ThreadContextにリクエストIDとユーザIDが必要。テスト対象クラス起動前にこれらの値をThreadContextに設定すること。

**テストコード例**:

```java
setThreadContextValues("testSelect", "threadContext");
```

**Excelデータ記述例**（シート[testInsert]、`LIST_MAP=threadContext`）:

| USER_ID | REQUEST_ID | LANG |
|---------|------------|------|
| U00001 | RS000001 | ja_JP |

<details>
<summary>keywords</summary>

ThreadContext, setThreadContextValues, DbAccessTestSupport, TestSupport, ユーザID設定, リクエストID設定, 自動設定項目

</details>

## 任意のディレクトリのExcelファイルを読み込みたい

テストソースコードと同じディレクトリに存在するExcelファイルであれば、シート名を指定するだけで読み込み可能である。別のディレクトリに存在するファイルを読み込みたい場合は、`TestDataParser`実装クラスを直接使用することで取得できる。

```java
TestDataParser parser = (TestDataParser) SystemRepository.getObject("testDataParser");
List<Map<String, String>> list = parser.getListMap("/foo/bar/Baz.xlsx", "sheet001", "params");
```

<details>
<summary>keywords</summary>

TestDataParser, getListMap, Excelファイル読み込み, 別ディレクトリ, SystemRepository

</details>

## テスト実行前後に共通処理を行いたい

JUnit4の`@Before`、`@After`、`@BeforeClass`、`@AfterClass`アノテーションを使用することで、テスト実行前後に共通処理を実行できる。

<details>
<summary>keywords</summary>

@Before, @After, @BeforeClass, @AfterClass, テスト前後共通処理, JUnit4

</details>

## @BeforeClass, @AfterClass使用時の注意点

サブクラスにてスーパークラスと同名・同アノテーション（`@BeforeClass`/`@AfterClass`）のメソッドを作成しないこと。同名メソッドに同種のアノテーションを付与した場合、スーパークラスのメソッドは起動されなくなる。

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

上記TestSubを実行した場合、「test」と表示される。

<details>
<summary>keywords</summary>

@BeforeClass, @AfterClass, スーパークラス継承, メソッドオーバーライド, アノテーション注意点

</details>

## デフォルト以外のトランザクションを使用したい

`DbAccessTestSupport`を継承することで、スーパークラスの`@Before`/`@After`メソッドが自動的に呼び出され、テストメソッド実行前後のトランザクション開始/終了が自動化される。プロパティファイルにトランザクション名を記載することで、テスティングフレームワークがトランザクション制御を行う。これにより、個別テストでの明示的なトランザクション開始や、終了処理漏れがなくなる。

<details>
<summary>keywords</summary>

DbAccessTestSupport, トランザクション制御, beginTransactions, endTransactions, トランザクション自動制御

</details>

## 本フレームワークのクラスを継承せずに使用したい

フレームワークのスーパークラスを継承できない場合、スーパークラスをインスタンス化して処理を委譲することで代替できる。

- コンストラクタにテストクラス自身の`Class`インスタンス（`getClass()`）を渡す必要がある
- `@Before`/`@After`メソッドは明示的に呼び出す必要がある（`beginTransactions()`/`endTransactions()`）

```java
public class SampleTest extends AnotherSuperClass {

    private DbAccessTestSupport dbSupport
          = new DbAccessTestSupport(getClass());

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

DbAccessTestSupport, 委譲, beginTransactions, endTransactions, フレームワーク非継承, getClass

</details>

## テストデータに空白、空文字、改行やnullを記述したい

:ref:`special_notation_in_cell` を参照。

<details>
<summary>keywords</summary>

special_notation_in_cell, 空白, 空文字, 改行, null, テストデータ特殊文字

</details>

## テストデータに空行を記述したい

全くの空行は無視されるため、:ref:`special_notation_in_cell` のダブルクォーテーション記法（`""`）で空文字列を記述することで空行を表現できる。

> **補足**: 行のうち1セルだけ `""` にすれば良い。可読性のため左端のセルへの記載を推奨する。

**記述例**（2レコード目が空行、`SETUP_VARIABLE=/path/to/file.csv`）:

| name | address |
|------|---------|
| 山田 | 東京都 |
| "" | |
| 田中 | 大阪府 |

<details>
<summary>keywords</summary>

空行, テストデータ, ダブルクォーテーション, special_notation_in_cell, 可変長ファイル, SETUP_VARIABLE

</details>

## マスタデータを変更してテストを行いたい

[04_MasterDataRestore](testing-framework-04_MasterDataRestore.md) を参照。

<details>
<summary>keywords</summary>

マスタデータ, 04_MasterDataRestore, マスタデータ変更テスト

</details>

## テストデータ読み込みディレクトリを変更したい

テストデータはデフォルトで `test/java` 配下から読み込まれる。コンポーネント設定ファイルに以下のキーを追加することで変更できる。

| キー | 値 |
|---|---|
| nablarch.test.resource-root | テスト実行時のカレントディレクトリからの相対パス。セミコロン(;)区切りで複数指定可 |

```bash
nablarch.test.resource-root=path/to/test-data-dir
```

複数ディレクトリ指定例:

```text
nablarch.test.resource-root=test/online;test/batch
```

- 一時的な変更はVM引数で代替可能: `-Dnablarch.test.resource-root=path/to/test-data-dir`
- 複数ディレクトリで同名テストデータが存在する場合、最初に発見されたテストデータが読み込まれる

<details>
<summary>keywords</summary>

nablarch.test.resource-root, テストデータディレクトリ変更, 複数ディレクトリ指定, セミコロン区切り, VM引数指定

</details>

## メッセージング処理でテストデータに対し定型的な変換処理を追加したい

**インタフェース**: `nablarch.test.core.file.TestDataConverter`

上記インタフェースを実装しシステムリポジトリに登録することで、URLエンコーディング等の定型変換処理を追加できる。

| キー | 値 |
|---|---|
| TestDataConverter_<データ種別> | TestDataConverterを実装したクラスのクラス名。データ種別はテストデータのfile-typeに指定した値 |

```xml
<component name="TestDataConverter_FormUrlEncoded"
           class="please.change.me.test.core.file.FormUrlEncodedTestDataConverter"/>
```

![URLエンコーディング変換前のExcelファイル記述例](../../knowledge/development-tools/testing-framework/assets/testing-framework-03_Tips/data_convert_example.png)

![URLエンコーディング変換後（テストフレームワーク内部での扱い）](../../knowledge/development-tools/testing-framework/assets/testing-framework-03_Tips/data_convert_internal.png)

<details>
<summary>keywords</summary>

nablarch.test.core.file.TestDataConverter, TestDataConverter_<データ種別>, URLエンコーディング変換, テストデータ変換処理, file-type, FormUrlEncodedTestDataConverter

</details>
