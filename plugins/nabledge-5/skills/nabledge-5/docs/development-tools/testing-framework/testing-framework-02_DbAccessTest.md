# データベースを使用するクラスのテスト

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/02_DbAccessTest.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlPStatement.html)

## 主なクラス, リソース

テストクラスは`DbAccessTestSupport`を継承して作成する。

| 名称 | 役割 | 作成単位 |
|---|---|---|
| テストクラス | テストロジックを実装する。`DbAccessTestSupport`を継承すること。 | テスト対象クラスにつき１つ |
| テストデータ（Excelファイル）| テーブルに格納する準備データや期待する結果など、テストデータを記載する。 | テストクラスにつき１つ |
| テスト対象クラス | テストされるクラス。 | — |
| `DbAccessTestSupport` | 準備データ投入などDB使用テストに必要な機能を提供する。テスト実行前後にDBトランザクションの開始・終了処理を行う（[using_transactions](testing-framework-03_Tips.md)）。 | — |

関係のあるカラムのみ記述することで可読性・保守性が向上し、テーブル定義変更時も無関係カラムであれば影響を受けない。

準備データには実行テストに関係するカラムのみ記述する（PK_1、PK_2、有効期限、削除フラグ）:

```
SETUP_TABLE=SAMPLE_TABLE

| PK_1 | PK_2 | 有効期限 | 削除フラグ |
|---|---|---|---|
| 01 | 0001 | 20101231 | 0 |
| 02 | 0002 | 20110101 | 0 |
```

期待値には`EXPECTED_TABLE`の代わりに`EXPECTED_COMPLETE_TABLE`を使用する:

```
EXPECTED_COMPLETE_TABLE=SAMPLE_TABLE

| PK_1 | PK_2 | 有効期限 | 削除フラグ |
|---|---|---|---|
| 01 | 0001 | 20101231 | 1 |
| 02 | 0002 | 20110101 | 0 |
```

<details>
<summary>keywords</summary>

DbAccessTestSupport, テストクラス作成ルール, データベーステスト, 準備データ投入, テストデータExcelファイル, 関係カラムのみ記載, EXPECTED_COMPLETE_TABLE, SETUP_TABLE, 準備データ, 可読性向上, 期待値

</details>

## 参照系のテスト

参照系テストで使用するAPI:

- `setUpDb(シート名)`: DBに準備データを登録する（引数はシート名）。
- `assertSqlResultSetEquals(シート名, 期待値ID, actual)`: Excelに記載した期待値と実際の`SqlResultSet`が等しいことを確認する（引数は期待値を格納したシート名、期待値のID、実際の値）。

**クラス**: `nablarch.test.core.db.BasicDefaultValues`

コンポーネント設定ファイルで以下の値を設定できる:

| 設定項目名 | 説明 | 設定値 |
|---|---|---|
| charValue | 文字列型のデフォルト値 | 1文字のASCII文字 |
| numberValue | 数値型のデフォルト値 | 0または正の整数 |
| dateValue | 日付型のデフォルト値 | JDBCタイムスタンプエスケープ形式 (yyyy-mm-dd hh:mm:ss.fffffffff) |

<details>
<summary>keywords</summary>

DbAccessTestSupport, setUpDb, assertSqlResultSetEquals, 参照系テスト, SqlResultSet確認, BasicDefaultValues, charValue, numberValue, dateValue, デフォルト値設定, nablarch.test.core.db.BasicDefaultValues

</details>

## 基本的なテスト方法

参照系テストと更新系テストの2種類に対応するAPIが提供される。参照系テストでは`assertSqlResultSetEquals`、更新系テストでは`assertTableEquals`を使用する。

```xml
<!-- TestDataParser -->
<component name="testDataParser" class="nablarch.test.core.reader.BasicTestDataParser">
  <!-- データベースデフォルト値 -->
  <property name="defaultValues">
    <component class="nablarch.test.core.db.BasicDefaultValues">
      <property name="charValue" value="a"/>
      <property name="dateValue" value="2000-01-01 12:34:56.123456789"/>
      <property name="numberValue" value="1"/>
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

参照系テスト, 更新系テスト, DbAccessTestSupport, データベーステスト種別, BasicDefaultValues, BasicTestDataParser, testDataParser, コンポーネント設定, nablarch.test.core.reader.BasicTestDataParser

</details>

## シーケンス（参照系）

参照系テストの実行シーケンス:

1. `setUpDb(シート名)` でDBに準備データを登録する。
2. テスト対象クラスのメソッドを起動する。
3. 戻り値として受け取った検索結果を `assertSqlResultSetEquals()` で確認する。

![参照系テストのシーケンス](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_DbAccessTest/select_sequence.png)

コンポーネント設定ファイルで明示的に指定していない場合、以下のデフォルト値が使用される:

| カラム型 | デフォルト値 |
|---|---|
| 数値型 | 0 |
| 文字列型 | 半角スペース |
| 日付型 | 1970-01-01 00:00:00.0 |

<details>
<summary>keywords</summary>

参照系テストシーケンス, setUpDb, assertSqlResultSetEquals, テスト実行フロー, デフォルト値, 数値型, 文字列型, 日付型, カラムデフォルト値, default_values_when_column_omitted

</details>

## テストソースコード実装例（参照系）

**クラス**: `DbAccessTestSupport`

```java
public class DbAccessTestSample extends DbAccessTestSupport {

    @Test
    public void testSelectAll() {
        // DBに準備データを登録する（引数はシート名）
        setUpDb("testSelectAll");

        EmployeeDbAccess target = new EmployeeDbAccess();
        SqlResultSet actual = target.selectAll();

        // Excelに記載した期待値と実際の値が等しいことを確認する
        // 引数：期待値を格納したシート名, 期待値のID, 実際の値
        assertSqlResultSetEquals("testSelectAll", "expected", actual);
    }
}
```

## setUpDbメソッドに関する注意点

- Excelファイルに全カラムを記述する必要はない。省略されたカラムにはデフォルト値が設定される。
- 1シート内に複数のテーブルを記述できる。`setUpDb(String sheetName)`実行時、指定シート内の`SETUP_TABLE`全てが登録対象となる。

## assertTableEqualsメソッドに関する注意点

- 期待値で省略されたカラムは比較対象外となる。
- レコードの順番が異なっていても主キーを突合して正しく比較できる（順序を意識してデータを作成する必要はない）。
- 1シート内に複数のテーブルを記述できる。`assertTableEquals(String sheetName)`実行時、指定シート内の`EXPECTED_TABLE`全てが比較対象となる。
- `java.sql.Timestamp`型のフォーマットは`yyyy-mm-dd hh:mm:ss.fffffffff`（fffffffffはナノ秒）。ナノ秒未設定でも`0`として表示される（例: 2010-01-01 12:34:56.0）。Excelに期待値を記載する場合は末尾の`.0`を付与すること。

## assertSqlResultSetEqualsメソッドに関する注意点

- SELECT文で指定された全カラム（別名含む）が比較対象となり、特定カラムを比較対象外にはできない。
- レコードの順序が異なる場合は等価でないとみなす（アサート失敗）。理由: SELECTカラムに主キーが含まれるとは限らない、ORDER BY指定がある場合は順序も厳密に比較する必要があるため。

## クラス単体テストにおける登録・更新系テストの注意点

- 自動設定項目を利用してDBに登録・更新する際は、ThreadContextにリクエストIDとユーザIDが設定されている必要がある。テスト対象クラス起動前に設定すること（:ref:`using_ThreadContext`）。
- デフォルト以外のトランザクションを使用する場合は、本フレームワークにトランザクション制御を行わせる必要がある（[using_transactions](testing-framework-03_Tips.md)）。

## 外部キーが設定されたテーブルへのデータセットアップ

:ref:`master_data_backup`と同じ機能を用いてテーブルの親子関係を判断しデータを削除・登録する。詳細は:ref:`MasterDataRestore-fk_key`を参照。

## Excelファイルに記述できるカラムのデータ型

`SqlPStatement`で対応している型のカラムのみテストデータとして記述できる。OracleのROWIDやPostgreSQLのOIDなどその他のデータ型は記述できない。

<details>
<summary>keywords</summary>

DbAccessTestSupport, setUpDb, assertSqlResultSetEquals, EmployeeDbAccess, SqlResultSet, 参照系テスト実装, assertTableEquals, ThreadContext, 外部キー, Timestamp, SqlPStatement, using_ThreadContext, using_transactions, MasterDataRestore-fk_key

</details>

## テストデータ記述例（参照系）

**SETUP_TABLE（準備データ）の記述形式:**

- 1行目: `SETUP_TABLE=<登録対象のテーブル名>`
- 2行目: そのテーブルのカラム名
- 3行目以降: 登録するレコード（2行目のカラム名と対応）

例:
```
SETUP_TABLE=EMPLOYEE

| ID    | EMP_NAME | DEPT_CODE |
|-------|----------|----------|
| 00001 | 山田太郎  | 0001     |
| 00002 | 田中一郎  | 0002     |
```

**LIST_MAP（期待値）の記述形式:**

- 1行目: `LIST_MAP=<シート内で一意になる期待値のID（任意の文字列）>`
- 2行目: SELECT文で指定したカラム名または別名
- 3行目以降: 検索結果（2行目のカラム名と対応）

例:
```
LIST_MAP=expected

| ID    | EMP_NAME | DEPT_NAME |
|-------|----------|-----------|
| 00001 | 山田太郎  | 人事部   |
| 00002 | 田中一郎  | 総務部   |
```

<details>
<summary>keywords</summary>

SETUP_TABLE, LIST_MAP, 準備データ記述形式, 期待値記述形式, Excelテストデータ形式

</details>

## シーケンス（更新系）

更新系テストの実行シーケンス:

1. `setUpDb(シート名)` でDBに準備データを登録する。
2. テスト対象クラスのメソッドを起動する。
3. `commitTransactions()` でトランザクションをコミットする。
4. `assertTableEquals()` でDBの値が期待通り更新されていることを確認する。

![更新系テストのシーケンス](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_DbAccessTest/update_sequence.png)

<details>
<summary>keywords</summary>

更新系テストシーケンス, commitTransactions, assertTableEquals, テスト実行フロー

</details>

## テストソースコード実装例（更新系）

**クラス**: `DbAccessTestSupport`

```java
public class DbAccessTestSample extends DbAccsessTestSupport {

    @Test
    public void testDeleteExpired() {
        // DBに準備データを登録する（引数はシート名）
        setUpDb("testDeleteExpired");

        EmployeeDbAccess target = new EmployeeDbAccess();
        SqlResultSet actual = target.deleteExpired();

        // トランザクションをコミット
        commitTransactions();

        // 引数：期待値を格納したシート名, 実際の値
        assertTableEquals("testDeleteExpired", actual);
    }
}
```

<details>
<summary>keywords</summary>

DbAccessTestSupport, setUpDb, commitTransactions, assertTableEquals, EmployeeDbAccess, SqlResultSet, 更新系テスト実装

</details>

## テストデータ記述例（更新系）

**SETUP_TABLE（準備データ）の記述形式:**

- 1行目: `SETUP_TABLE=<登録対象のテーブル名>`
- 2行目: そのテーブルのカラム名
- 3行目以降: 登録するレコード

例:
```
SETUP_TABLE=EMPLOYEE

| ID    | EMP_NAME | EXPIRED |
|-------|----------|---------|
| 00001 | 山田太郎  | TRUE   |
| 00002 | 田中一郎  | FALSE  |
```

**EXPECTED_TABLE（期待値）の記述形式:**

- 1行目: `EXPECTED_TABLE=<確認対象のテーブル名>`
- 2行目: 確認対象テーブルのカラム名（コメント行でデータ型を記述可能）
- 3行目以降: 期待する値

例:
```
EXPECTED_TABLE=EMPLOYEE

| ID          | EMP_NAME    | EXPIRED |
|-------------|-------------|----------|
| // CHAR(5)  | VARCHAR(64) | BOOLEAN  |
| 00002       | 田中一郎     | FALSE   |
```

<details>
<summary>keywords</summary>

SETUP_TABLE, EXPECTED_TABLE, 準備データ記述形式, 期待値記述形式, 更新系テストデータ

</details>

## 更新系のテスト

> **重要**: Nablarch Application Frameworkでは複数種類のトランザクションを併用することが前提となっている。テスト対象クラス実行後にDBの内容を確認する際は、必ず`commitTransactions()`でトランザクションをコミットしなければならない。コミットしない場合、テスト結果の確認が正常に行われない。

> **補足**: 参照系のテストの場合はコミットを行う必要はない。

更新系テストで使用するAPI:

- `setUpDb(シート名)`: DBに準備データを登録する。
- `commitTransactions()`: トランザクションをコミットする（更新系テストで必須）。
- `assertTableEquals(シート名, actual)`: Excelに記載した期待値と実際のテーブル内容が等しいことを確認する。

<details>
<summary>keywords</summary>

commitTransactions, トランザクションコミット必須, 更新系テスト, assertTableEquals, DbAccessTestSupport

</details>

## データベーステストデータの省略記述方法

DBテストデータ記述時にテストに関係のないカラムは省略できる。省略されたカラムには:ref:`default_values_when_column_omitted`が設定される。この機能を使用することにより、テストデータの可読性が向上する。また、テーブル定義が変更された場合でも、関係無いカラムであればテストデータ修正作業は発生しなくなる為、保守性が向上する。この機能は特に更新系テストケースに有効である（多くのカラムのうち１カラムだけが更新される場合、不要なカラムを記述する必要がなくなる）。

> **重要**:
> - **検索結果の期待値**を記述する際は、検索対象カラム全てを記述しなければならない（主キーのみ確認するような方法は不可）。
> - **登録系**テストの場合も、新規に登録されたレコードの全カラムを確認する必要があるので、カラムを省略できない。

**DBに準備データのカラムを省略する場合:**

省略されたカラムには:ref:`default_values_when_column_omitted`が設定されているものとして扱われる。ただし**主キーカラムは省略不可**。

**DB期待値のカラムを省略する場合:**

| データタイプ | 省略カラムの扱い |
|---|---|
| `EXPECTED_TABLE` | 省略されたカラムは比較対象外となる |
| `EXPECTED_COMPLETE_TABLE` | 省略されたカラムは:ref:`デフォルト値<default_values_when_column_omitted>`が格納されているものとして比較される |

更新系テストで「無関係なカラムが更新されていないことを確認する」場合は`EXPECTED_COMPLETE_TABLE`を使用する。

<details>
<summary>keywords</summary>

EXPECTED_TABLE, EXPECTED_COMPLETE_TABLE, カラム省略, デフォルト値, 主キー省略不可, default_values_when_column_omitted

</details>

## テストケース例

テストケース例: **「有効期限を過ぎたレコードは削除フラグが1に更新されること」** ※本テスト実施時の日付は2011/01/01とする。

使用するテーブル（SAMPLE_TABLE）:

| カラム名 | 説明 |
|---|---|
| PK1 | 主キー |
| PK2 | 主キー |
| COL_A | テスト対象の機能では使用しないカラム |
| COL_B | テスト対象の機能では使用しないカラム |
| COL_C | テスト対象の機能では使用しないカラム |
| COL_D | テスト対象の機能では使用しないカラム |
| 有効期限 | 有効期限を過ぎたデータが処理対象となる |
| 削除フラグ | 有効期限を過ぎたレコードの値を'1'に変更する |

<details>
<summary>keywords</summary>

SAMPLE_TABLE, 有効期限, 削除フラグ, テストケース定義, 更新系テスト例

</details>

## 省略せずに全カラムを記載した場合（悪い例）

全カラムが記載されており可読性に劣る（COL_A〜COL_Dは本テストケースに無関係）。またテーブル定義に変更があった場合、無関係なカラムであっても修正しなければならない。

**準備データ（SETUP_TABLE=SAMPLE_TABLE）:**

| PK_1 | PK_2 | COL_A | COL_B | COL_C | COL_D | 有効期限 | 削除フラグ |
|---|---|---|---|---|---|---|---|
| 01 | 0001 | 1a | 1b | 1c | 1d | 20101231 | 0 |
| 02 | 0002 | 2a | 2b | 2c | 2d | 20110101 | 0 |

**期待値（EXPECTED_TABLE=SAMPLE_TABLE）:**

| PK_1 | PK_2 | COL_A | COL_B | COL_C | COL_D | 有効期限 | 削除フラグ |
|---|---|---|---|---|---|---|---|
| 01 | 0001 | 1a | 1b | 1c | 1d | 20101231 | 1 |
| 02 | 0002 | 2a | 2b | 2c | 2d | 20110101 | 0 |

<details>
<summary>keywords</summary>

SETUP_TABLE, EXPECTED_TABLE, 全カラム記述, テストデータ可読性, カラム省略のメリット

</details>
