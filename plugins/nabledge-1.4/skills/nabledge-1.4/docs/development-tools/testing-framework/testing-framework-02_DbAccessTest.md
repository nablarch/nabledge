# データベースを使用するクラスのテスト

## 全体像

![クラス構造図](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_DbAccessTest/class_structure.png)

関係のあるカラムのみを記載することで可読性・保守性が向上する。テーブル定義変更があっても無関係カラムは影響を受けない。

期待値の記述では `EXPECTED_TABLE` の代わりに `EXPECTED_COMPLETE_TABLE` を使用する。

**準備データ例** (SETUP_TABLE=SAMPLE_TABLE):

| PK_1 | PK_2 | 有効期限 | 削除フラグ |
|---|---|---|---|
| 01 | 0001 | 20101231 | 0 |
| 02 | 0002 | 20110101 | 0 |

**期待値例** (EXPECTED_COMPLETE_TABLE=SAMPLE_TABLE):

| PK_1 | PK_2 | 有効期限 | 削除フラグ |
|---|---|---|---|
| 01 | 0001 | 20101231 | 1 |
| 02 | 0002 | 20110101 | 0 |

<details>
<summary>keywords</summary>

クラス構造図, データベーステスト全体像, DbAccessTestSupport, テストクラス構成, SETUP_TABLE, EXPECTED_COMPLETE_TABLE, テストデータ準備, 期待値検証, カラム省略, 可読性, 保守性

</details>

## 主なクラス, リソース

テストクラスは`DbAccessTestSupport`を継承して作成する。

| 名称 | 役割 | 作成単位 |
|---|---|---|
| テストクラス | テストロジックを実装する。`DbAccessTestSupport`を継承すること。 | テスト対象クラスにつき1つ |
| テストデータ（Excelファイル） | 準備データや期待する結果など、テストデータを記載する。 | テストクラスにつき1つ |
| テスト対象クラス | テストされるクラス。 | — |
| `DbAccessTestSupport` | 準備データ投入などDBテストに必要な機能を提供する。テスト実行前後にDBトランザクションの開始・終了処理を行う（[using_transactions](testing-framework-03_Tips.md)）。 | — |

コンポーネント設定ファイルで明示的に指定していない場合のデフォルト値:

| カラム | デフォルト値 |
|---|---|
| 数値型 | 0 |
| 文字列型 | 半角スペース |
| 日付型 | 1970-01-01 00:00:00.0 |

<details>
<summary>keywords</summary>

DbAccessTestSupport, テストクラス継承, テストデータExcel, データベーステスト構成, DbAccessTestSupport継承, デフォルト値, 数値型, 文字列型, 日付型, 省略カラム, 1970-01-01

</details>

## 基本的なテスト方法

参照系テストでは`setUpDb`（準備データ登録）→ テスト対象メソッド実行 → `assertSqlResultSetEquals`（検索結果と期待値の比較）の順で確認する。

**クラス**: `nablarch.test.core.db.BasicDefaultValues`

コンポーネント設定ファイルで以下のデフォルト値を設定できる。

| 設定項目名 | 説明 | 設定値 |
|---|---|---|
| charValue | 文字列型のデフォルト値 | 1文字のASCII文字 |
| numberValue | 数値型のデフォルト値 | 0または正の整数 |
| dateValue | 日付型のデフォルト値 | JDBCタイムスタンプエスケープ形式 (yyyy-mm-dd hh:mm:ss.fffffffff) |

<details>
<summary>keywords</summary>

参照系テスト, setUpDb, assertSqlResultSetEquals, データベース参照確認, 参照系テスト手順, BasicDefaultValues, charValue, numberValue, dateValue, デフォルト値設定, コンポーネント設定

</details>

## シーケンス

![参照系テストのシーケンス](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_DbAccessTest/select_sequence.png)

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

参照系テストシーケンス, select_sequence, テスト実行順序, 参照系, BasicTestDataParser, BasicDefaultValues, testDataParser, デフォルト値XML設定, charValue, dateValue, numberValue

</details>

## テストソースコード実装例

```java
public class DbAccessTestSample extends DbAccessTestSupport {
    @Test
    public void testSelectAll() {
        // 引数: シート名
        setUpDb("testSelectAll");
        EmployeeDbAcess target = new EmployeeDbAccess();
        SqlResultSet actual = target.selectAll();
        // 引数: 期待値シート名, 期待値ID, 実際の値
        assertSqlResultSetEquals("testSelectAll", "expected", actual);
    }
}
```

**setUpDbメソッド**:
- Excelに全カラムを記述する必要はない。省略カラムにはデフォルト値が設定される
- 1シート内に複数テーブルを記述可能。setUpDb(sheetName)実行時、シート内の全SETUP_TABLEが登録対象

**assertTableEqualsメソッド**:
- 省略カラムは比較対象外
- レコード順序が異なっても主キーを突合して正しく比較できる
- 1シート内に複数テーブルを記述可能。assertTableEquals(sheetName)実行時、シート内の全EXPECTED_TABLEが比較対象
- java.sql.Timestamp型のフォーマットは `yyyy-mm-dd hh:mm:ss.fffffffff`（fffffffffはナノ秒）。ナノ秒未設定でも0として表示される（例: 2010年1月1日12:34:56ジャスト → `2010-01-01 12:34:56.0`）。Excelに期待値を記載する際は末尾の小数点＋ゼロを付与すること

**assertSqlResultSetEqualsメソッド**:
- SELECT文で指定された全カラム（別名含む）が比較対象。特定カラムを比較対象外にすることはできない
- レコード順序が異なる場合はアサート失敗。理由: 主キーが含まれるとは限らない、ORDER BY指定がある場合は順序も厳密に比較する必要がある

**クラス単体テスト（登録・更新系）**:
- 自動設定項目使用時は、ThreadContextにリクエストIDとユーザIDが必要。テスト対象クラス起動前に設定すること（ :ref:`using_ThreadContext` ）
- デフォルト以外のトランザクション使用時は、フレームワークにトランザクション制御を行わせること（ [using_transactions](testing-framework-03_Tips.md) ）

<details>
<summary>keywords</summary>

DbAccessTestSupport, setUpDb, assertSqlResultSetEquals, 参照系テストコード, SqlResultSet, assertTableEquals, Timestamp型フォーマット, ThreadContext, トランザクション制御, using_ThreadContext, using_transactions

</details>

## テストデータ記述例

準備データ形式（Excelシートに記載）:

```
SETUP_TABLE=<テーブル名>
<カラム名行>
<データ行...>
```

期待値形式:

```
LIST_MAP=<シート内で一意になるID>
<カラム名行（SELECT文で指定したカラム名または別名）>
<期待データ行...>
```

例:

```
SETUP_TABLE=EMPLOYEE
ID    EMP_NAME  DEPT_CODE
00001 山田太郎  0001
00002 田中一郎  0002

SETUP_TABLE=DEPT
ID    DEPT_NAME
0001  人事部
0002  総務部

LIST_MAP=expected
ID    EMP_NAME  DEPT_NAME
00001 山田太郎  人事部
00002 田中一郎  総務部
```

<details>
<summary>keywords</summary>

SETUP_TABLE, LIST_MAP, テストデータ形式, 参照系テストデータ, Excelテストデータ

</details>

## 更新系のテスト

> **警告**: Nablarch Application Frameworkでは複数種類のトランザクションを併用するため、テスト対象クラス実行後にDBの内容を確認する際は`commitTransactions()`でトランザクションをコミットしなければならない。コミットしない場合、テスト結果の確認が正常に行われない。

> **注意**: 参照系のテストの場合はコミットを行う必要はない。

更新系テストのAPI呼び出し順: `setUpDb` → テスト対象メソッド実行 → `commitTransactions` → `assertTableEquals`

<details>
<summary>keywords</summary>

commitTransactions, トランザクションコミット, 更新系テスト注意点, 複数トランザクション

</details>

## シーケンス

![更新系テストのシーケンス](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_DbAccessTest/update_sequence.png)

<details>
<summary>keywords</summary>

更新系テストシーケンス, update_sequence, commitTransactions, 更新系

</details>

## テストソースコード実装例

```java
public class DbAccessTestSample extends DbAccsessTestSupport {
    @Test
    public void testDeleteExpired() {
        // 引数: シート名
        setUpDb("testDeleteExpired");
        EmployeeDbAcess target = new EmployeeDbAccess();
        SqlResultSet actual = target.deleteExpired();
        commitTransactions();  // 更新系テストはコミット必須
        // 引数: 期待値シート名, 実際の値
        assertTableEquals("testDeleteExpired", actual);
    }
}
```

<details>
<summary>keywords</summary>

commitTransactions, assertTableEquals, 更新系テストコード, DbAccessTestSupport, SqlResultSet

</details>

## テストデータ記述例

準備データ形式:

```
SETUP_TABLE=<テーブル名>
<カラム名行>
<データ行...>
```

期待値形式:

```
EXPECTED_TABLE=<テーブル名>
<カラム名行>（コメント行でデータ型を記載可能: `// CHAR(5)`）
<期待値行...>
```

例:

```
SETUP_TABLE=EMPLOYEE
ID    EMP_NAME  EXPIRED
00001 山田太郎  TRUE
00002 田中一郎  FALSE

EXPECTED_TABLE=EMPLOYEE
ID          EMP_NAME    EXPIRED
// CHAR(5)  VARCHAR(64) BOOLEAN
00002       田中一郎    FALSE
```

<details>
<summary>keywords</summary>

EXPECTED_TABLE, SETUP_TABLE, 更新系テストデータ, テストデータ形式, データ型コメント

</details>

## データベーステストデータの省略記述方法

テストに関係のないカラムについては記述を省略できる。省略したカラムには :ref:`default_values_when_column_omitted` が設定される。この機能を利用することにより、テストデータの可読性が向上し、テーブル定義が変更された場合でも関係のないカラムであればテストデータ修正作業が不要になる。

この機能は特に更新系テストケースに有効である。多くのカラムのうち1カラムだけが更新される場合、不要なカラムを記述する必要がなくなる。

> **警告**: DBの**検索結果**の期待値を記述する際は、検索対象カラム全てを記述しなければならない（レコードの主キーだけを確認する、というような確認方法は不可）。また、**登録系**テストの場合も、新規登録レコードの全カラムを確認する必要があるため、カラムを省略できない。

**準備データのカラム省略**: 省略カラムには :ref:`default_values_when_column_omitted` が設定される。**主キーカラムは省略不可**。

**DB期待値のカラム省略**:
- `EXPECTED_TABLE`: 省略カラムは比較対象外
- `EXPECTED_COMPLETE_TABLE`: 省略カラムに :ref:`デフォルト値<default_values_when_column_omitted>` が格納されているものとして比較（無関係なカラムが更新されていないことを確認したい場合に使用）

<details>
<summary>keywords</summary>

EXPECTED_TABLE, EXPECTED_COMPLETE_TABLE, カラム省略, default_values_when_column_omitted, テストデータ省略, 主キー省略不可

</details>

## テストケース例

テストケース: **「有効期限」を過ぎたレコードは「削除フラグ」が1に更新されること**（テスト実施時の日付: 2011/01/01）

SAMPLE_TABLEのカラム構成:

| カラム名 | 説明 |
|---|---|
| PK1 | 主キー |
| PK2 | 主キー |
| COL_A | テスト対象の機能では使用しないカラム |
| COL_B | テスト対象の機能では使用しないカラム |
| COL_C | テスト対象の機能では使用しないカラム |
| COL_D | テスト対象の機能では使用しないカラム |
| 有効期限 | 有効期限を過ぎたデータが処理対象 |
| 削除フラグ | 有効期限を過ぎたレコードの値を'1'に変更 |

<details>
<summary>keywords</summary>

有効期限, 削除フラグ, SAMPLE_TABLE, テストケース, カラム省略具体例

</details>

## 省略せずに全カラムを記載した場合（悪い例）

全カラムを記載した場合は可読性が低下し、テーブル定義変更時に無関係なカラムも修正が必要になる（悪い例）。

準備データ（全カラム記載の悪い例）:

```
SETUP_TABLE=SAMPLE_TABLE
PK_1 PK_2 COL_A COL_B COL_C COL_D 有効期限 削除フラグ
01   0001 1a    1b    1c    1d    20101231  0
02   0002 2a    2b    2c    2d    20110101  0
```

期待値（全カラム記載の悪い例）:

```
EXPECTED_TABLE=SAMPLE_TABLE
PK_1 PK_2 COL_A COL_B COL_C COL_D 有効期限 削除フラグ
01   0001 1a    1b    1c    1d    20101231  1
02   0002 2a    2b    2c    2d    20110101  0
```

> **注意**: COL_A〜COL_Dは本テストケースに無関係である。全カラム記載により可読性が低下し、テーブル定義変更時に無関係カラムも修正が必要になる。

<details>
<summary>keywords</summary>

SETUP_TABLE, EXPECTED_TABLE, 全カラム記載, 可読性, 保守性, 悪い例

</details>
