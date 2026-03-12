# データベースを使用するクラスのテスト

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/02_DbAccessTest.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/db/statement/SqlPStatement.html)

## 主なクラス, リソース

**クラス**: `DbAccessTestSupport`

| 名称 | 役割 | 作成単位 |
|---|---|---|
| テストクラス | テストロジックを実装する。`DbAccessTestSupport`を継承する | テスト対象クラスにつき1つ |
| テストデータ（Excelファイル） | 準備データや期待値などのテストデータを記載する | テストクラスにつき1つ |
| テスト対象クラス | テストされるクラス | — |
| `DbAccessTestSupport` | 準備データ投入などDB操作機能を提供。テスト実行前後にDBトランザクションの開始・終了処理を行う（[using_transactions](testing-framework-03_Tips.md)） | — |

テストケースに関係のあるカラムのみをExcelに記載することで可読性・保守性が向上する。テーブル定義変更時も、無関係なカラムであれば影響を受けない。

このテストケースに関係のあるカラムは以下のとおり。

- レコードを一意に特定するための主キーカラム（PK_1、PK_2）
- 更新対象レコードを抽出する条件となる「有効期限」カラム
- 更新対象となる「削除フラグ」カラム

期待値の記述には `EXPECTED_TABLE` の代わりに `EXPECTED_COMPLETE_TABLE` を使用する。

**SETUP_TABLE 例** (SAMPLE_TABLE):

| PK_1 | PK_2 | 有効期限 | 削除フラグ |
|---|---|---|---|
| 01 | 0001 | 20101231 | 0 |
| 02 | 0002 | 20110101 | 0 |

**EXPECTED_COMPLETE_TABLE 例** (SAMPLE_TABLE):

| PK_1 | PK_2 | 有効期限 | 削除フラグ |
|---|---|---|---|
| 01 | 0001 | 20101231 | 1 |
| 02 | 0002 | 20110101 | 0 |

<details>
<summary>keywords</summary>

DbAccessTestSupport, テストクラス, テストデータ, Excelファイル, データベーステスト, 準備データ投入, トランザクション制御, SETUP_TABLE, EXPECTED_COMPLETE_TABLE, EXPECTED_TABLE, 関係カラムのみ記述, 可読性向上, 保守性向上

</details>

## 基本的なテスト方法

参照系テスト: `setUpDb(シート名)` でDB準備データを登録し、`assertSqlResultSetEquals(シート名, 期待値ID, actual)` で検索結果を確認する。

更新系テスト: `setUpDb(シート名)` でDB準備データ登録 → テスト対象メソッド実行 → `commitTransactions()` でコミット → `assertTableEquals(シート名, actual)` でDB状態確認。

自動テストフレームワークのコンポーネント設定ファイルにて明示的に指定していない場合、デフォルト値には以下の値が使用される。

| カラム | デフォルト値 |
|---|---|
| 数値型 | 0 |
| 文字列型 | 半角スペース |
| 日付型 | 1970-01-01 00:00:00.0 |

<details>
<summary>keywords</summary>

setUpDb, assertSqlResultSetEquals, commitTransactions, assertTableEquals, 参照系テスト, 更新系テスト, デフォルト値, 数値型, 文字列型, 日付型, 省略カラム, 1970-01-01, 半角スペース

</details>

## 参照系テスト - シーケンス

参照系テストのシーケンス（`select_sequence.png`）:

1. `setUpDb(シート名)` でExcelシートからDB準備データを登録
2. テスト対象メソッドを呼び出し、戻り値（`SqlResultSet`）を取得
3. `assertSqlResultSetEquals(シート名, 期待値ID, actual)` で結果を検証

**クラス**: `nablarch.test.core.db.BasicDefaultValues`

コンポーネント設定ファイルで設定できる項目:

| 設定項目名 | 説明 | 設定値 |
|---|---|---|
| charValue | 文字列型のデフォルト値 | 1文字のASCII文字 |
| numberValue | 数値型のデフォルト値 | 0または正の整数 |
| dateValue | 日付型のデフォルト値 | JDBCタイムスタンプエスケープ形式 (yyyy-mm-dd hh:mm:ss.fffffffff) |

<details>
<summary>keywords</summary>

setUpDb, assertSqlResultSetEquals, 参照系テスト, テスト実行順序, BasicDefaultValues, charValue, numberValue, dateValue, デフォルト値変更, コンポーネント設定

</details>

## 参照系テスト - テストソースコード実装例

```java
public class DbAccessTestSample extends DbAccessTestSupport {
    @Test
    public void testSelectAll() {
        setUpDb("testSelectAll");  // 引数はシート名
        EmployeeDbAcess target = new EmployeeDbAccess();
        SqlResultSet actual = target.selectAll();
        // 引数: 期待値を格納したシート名, 期待値のID, 実際の値
        assertSqlResultSetEquals("testSelectAll", "expected", actual);
    }
}
```

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

DbAccessTestSupport, setUpDb, assertSqlResultSetEquals, SqlResultSet, 参照系テスト実装, BasicTestDataParser, BasicDefaultValues, testDataParser, XML設定例, defaultValues

</details>

## 参照系テスト - テストデータ記述例

準備データ（`SETUP_TABLE`形式）:
- 1行目: `SETUP_TABLE=<登録対象テーブル名>`
- 2行目: カラム名
- 3行目以降: 登録レコード

```
SETUP_TABLE=EMPLOYEE
ID    | EMP_NAME | DEPT_CODE
00001 | 山田太郎 | 0001
00002 | 田中一郎 | 0002
```

期待値（`LIST_MAP`形式）:
- 1行目: `LIST_MAP=<シート内で一意の期待値ID>`
- 2行目: SELECT文で指定したカラム名または別名
- 3行目以降: 検索結果

```
LIST_MAP=expected
ID    | EMP_NAME | DEPT_NAME
00001 | 山田太郎 | 人事部
00002 | 田中一郎 | 総務部
```

## setUpDbメソッドの注意点

- Excelに全カラムを記述する必要はない。省略されたカラムにはデフォルト値が設定される。
- 1シート内に複数テーブルを記述できる。`setUpDb(String sheetName)` 実行時、指定シート内のデータタイプ `SETUP_TABLE` 全てが登録対象となる。

## assertTableEqualsメソッドの注意点

- 期待値で省略されたカラムは比較対象外。
- 主キーで突合するため、レコード順序が異なっていても正しく比較できる。
- 1シート内に複数テーブル記述可能。`assertTableEquals(String sheetName)` 実行時、指定シート内のデータタイプ `EXPECTED_TABLE` 全てが比較される。
- `java.sql.Timestamp` 型のフォーマットは `yyyy-mm-dd hh:mm:ss.fffffffff`（fffffffffはナノ秒）。ナノ秒未設定でも `0` として表示される（例: `2010-01-01 12:34:56.0`）。Excelに期待値を記載する場合は末尾に `.0` を付与すること。

## assertSqlResultSetEqualsメソッドの注意点

- SELECT文で指定した全カラムが比較対象。特定カラムのみを比較対象外にすることはできない。
- レコード順序が異なる場合はアサート失敗。（理由: SELECTカラムに主キーが含まれるとは限らないため、また ORDER BY 指定がなされる場合が多く順序も厳密に比較する必要があるため）

## 登録・更新系テストの注意点

- 自動設定項目を利用してDBに登録・更新する際は、ThreadContextにリクエストIDとユーザIDが設定されている必要がある。テスト対象クラス起動前に設定すること。（:ref:`using_ThreadContext`）
- デフォルト以外のトランザクションを使用する場合は、本フレームワークにトランザクション制御を行わせる必要がある。（[using_transactions](testing-framework-03_Tips.md)）

## 外部キーテーブルへのデータセットアップ

:ref:`master_data_backup` と同じ機能を用いてテーブルの親子関係を判断しデータを削除・登録する。詳細は :ref:`MasterDataRestore-fk_key` を参照。

## Excelカラムのデータ型

`SqlPStatement` で対応している型のカラムのみ記述可能。それ以外のデータ型（例: OracleのROWID、PostgreSQLのOIDなど）は記述不可。

<details>
<summary>keywords</summary>

SETUP_TABLE, LIST_MAP, テストデータ形式, Excelシート, 準備データ記述, setUpDb, assertTableEquals, assertSqlResultSetEquals, ThreadContext, SqlPStatement, 外部キー, Timestamp型フォーマット, java.sql.Timestamp, 登録更新テスト

</details>

## 更新系テスト - シーケンス

更新系テストのシーケンス（`update_sequence.png`）:

1. `setUpDb(シート名)` でDB準備データを登録
2. テスト対象メソッドを呼び出す
3. `commitTransactions()` でトランザクションをコミット
4. `assertTableEquals(シート名, actual)` でDB更新結果を検証

> **重要**: Nablarch Application Frameworkでは複数種類のトランザクションを併用する前提のため、テスト対象クラス実行後にDB内容を確認する際は `commitTransactions()` を必ず呼び出すこと。コミットしない場合、テスト結果確認が正常に行われない。

> **補足**: 参照系テストではコミット不要。

<details>
<summary>keywords</summary>

commitTransactions, assertTableEquals, 更新系テスト, トランザクションコミット, DB更新確認

</details>

## 更新系テスト - テストソースコード実装例

```java
public class DbAccessTestSample extends DbAccsessTestSupport {
    @Test
    public void testDeleteExpired() {
        setUpDb("testDeleteExpired");  // 引数はシート名
        EmployeeDbAcess target = new EmployeeDbAccess();
        SqlResultSet actual = target.deleteExpired();
        commitTransactions();  // トランザクションをコミット
        // 引数: 期待値を格納したシート名, 実際の値
        assertTableEquals("testDeleteExpired", actual);
    }
}
```

<details>
<summary>keywords</summary>

DbAccessTestSupport, setUpDb, commitTransactions, assertTableEquals, 更新系テスト実装

</details>

## 更新系テスト - テストデータ記述例

準備データ（`SETUP_TABLE`形式）:
- 1行目: `SETUP_TABLE=<テーブル名>`
- 2行目: カラム名
- 3行目以降: レコード

```
SETUP_TABLE=EMPLOYEE
ID    | EMP_NAME | EXPIRED
00001 | 山田太郎 | TRUE
00002 | 田中一郎 | FALSE
```

期待値（`EXPECTED_TABLE`形式）:
- 1行目: `EXPECTED_TABLE=<確認対象テーブル名>`
- 2行目: カラム名
- 3行目以降: 期待値（コメント行 `// データ型` でデータ型指定可。コメント行はカラム名行と データ行の間に置く）

```
EXPECTED_TABLE=EMPLOYEE
ID    | EMP_NAME   | EXPIRED
// CHAR(5)  VARCHAR(64)   BOOLEAN
00002 | 田中一郎 | FALSE
```

<details>
<summary>keywords</summary>

SETUP_TABLE, EXPECTED_TABLE, テストデータ形式, 更新系テスト, 期待値記述

</details>

## データベーステストデータの省略記述方法

準備データ・期待値の記述で、テストに無関係なカラムは省略可能。省略されたカラムには :ref:`default_values_when_column_omitted` が設定される。

この機能により以下のメリットが得られる:
- **可読性向上**: テストデータの可読性が向上する
- **保守性向上**: テーブル定義が変更された場合でも、関係無いカラムであればテストデータ修正作業が発生しなくなる
- **更新系テストに特に有効**: 多くのカラムのうち1カラムだけが更新される場合、不要なカラムを記述する必要がなくなる

> **重要**: DB**検索結果**の期待値は検索対象カラム全てを記述必須（主キーのみ確認は不可）。**登録系**テストでも新規登録レコードの全カラム確認が必要でカラム省略不可。

省略制約:
- **準備データ**: 主キーカラムは省略不可。その他は省略可（省略値は :ref:`default_values_when_column_omitted`）
- **DB期待値 (`EXPECTED_TABLE`)**: 省略カラムは比較対象外
- **DB期待値 (`EXPECTED_COMPLETE_TABLE`)**: 省略カラムは :ref:`デフォルト値<default_values_when_column_omitted>` が格納されているものとして比較。「無関係なカラムが更新されていないこと」を確認する更新系テストに使用する

<details>
<summary>keywords</summary>

EXPECTED_TABLE, EXPECTED_COMPLETE_TABLE, カラム省略, default_values_when_column_omitted, テストデータ保守性, テストデータ可読性, 更新系テスト, 主キー省略不可

</details>

## テストケース例

テストケース: 「有効期限」を過ぎたレコードは「削除フラグ」が1に更新されること（テスト実施日: 2011/01/01）。

使用テーブル（SAMPLE_TABLE）:

| カラム名 | 説明 |
|---|---|
| PK1 | 主キー |
| PK2 | 主キー |
| COL_A | テスト対象機能では使用しないカラム |
| COL_B | テスト対象機能では使用しないカラム |
| COL_C | テスト対象機能では使用しないカラム |
| COL_D | テスト対象機能では使用しないカラム |
| 有効期限 | 有効期限を過ぎたデータが処理対象 |
| 削除フラグ | 有効期限超過レコードの値を'1'に変更 |

<details>
<summary>keywords</summary>

SAMPLE_TABLE, 有効期限, 削除フラグ, カラム省略例, 更新系テスト具体例

</details>

## 省略せずに全カラムを記載した場合（悪い例）

全カラムを省略せずに記載した場合（悪い例）: COL_A〜COL_Dはテストに無関係だが全て記載されており可読性に劣る。テーブル定義変更時に無関係なカラムも修正が必要になる。

準備データ（悪い例）:
```
SETUP_TABLE=SAMPLE_TABLE
PK_1 | PK_2 | COL_A | COL_B | COL_C | COL_D | 有効期限  | 削除フラグ
01   | 0001 | 1a    | 1b    | 1c    | 1d    | 20101231 | 0
02   | 0002 | 2a    | 2b    | 2c    | 2d    | 20110101 | 0
```

期待値（悪い例）:
```
EXPECTED_TABLE=SAMPLE_TABLE
PK_1 | PK_2 | COL_A | COL_B | COL_C | COL_D | 有効期限  | 削除フラグ
01   | 0001 | 1a    | 1b    | 1c    | 1d    | 20101231 | 1
02   | 0002 | 2a    | 2b    | 2c    | 2d    | 20110101 | 0
```

<details>
<summary>keywords</summary>

SETUP_TABLE, EXPECTED_TABLE, 全カラム記載, 可読性低下, テストデータ悪い例

</details>

## 関係のあるカラムのみを記載した場合（良い例）

関係のあるカラムのみを記載した場合（良い例）: テストに無関係なCOL_A〜COL_Dを省略することで可読性が向上し、テーブル定義変更の影響も受けにくくなる。

準備データ（良い例）: 主キー（PK_1, PK_2）とテスト対象カラム（有効期限, 削除フラグ）のみ記載する。テストに無関係なCOL_A〜COL_Dは省略する。省略されたカラムには :ref:`default_values_when_column_omitted` が設定されているものとして扱われる。

期待値（良い例）: `EXPECTED_COMPLETE_TABLE` を使用し、関係のあるカラム（PK_1, PK_2, 有効期限, 削除フラグ）のみ記載する。省略したCOL_A〜COL_Dは :ref:`デフォルト値<default_values_when_column_omitted>` と比較され、更新されていないことを確認できる。`EXPECTED_TABLE` を使用した場合は省略カラムが比較対象外となるのに対し、`EXPECTED_COMPLETE_TABLE` を使用することで省略カラムも含めて確認できる。

<details>
<summary>keywords</summary>

SETUP_TABLE, EXPECTED_COMPLETE_TABLE, カラム省略, 良い例, テストデータ可読性, 更新系テスト

</details>
