# データベースを使用するクラスのテスト

## 主なクラス, リソース

| 名称 | 役割 | 作成単位 |
|---|---|---|
| テストクラス | テストロジックを実装する。`DbAccessTestSupport`を継承すること。 | テスト対象クラスにつき1つ |
| テストデータ（Excelファイル） | 準備データや期待する結果などのテストデータを記載する。 | テストクラスにつき1つ |
| テスト対象クラス | テストされるクラス。 | — |
| **クラス**: `DbAccessTestSupport` | 準備データ投入などDB使用テストに必要な機能を提供する。テスト実行前後にDBトランザクションの開始・終了処理を行う（[using_transactions](testing-framework-03_Tips.md)）。 | — |

準備データ(`SETUP_TABLE`)と期待値には、テストケースに関係するカラムのみ記述する:

- 主キーカラム（レコードを一意に特定するため）
- 更新条件となるカラム（例: 有効期限）
- 更新対象となるカラム（例: 削除フラグ）

テーブル定義変更時も、無関係なカラムは影響を受けない。

> **重要**: 期待値記述時は `EXPECTED_TABLE` の代わりに `EXPECTED_COMPLETE_TABLE` を使用すること。

<details>
<summary>keywords</summary>

DbAccessTestSupport, テストクラス, テストデータ, データベーステスト, クラス構成, SETUP_TABLE, EXPECTED_COMPLETE_TABLE, EXPECTED_TABLE, 関係カラムのみ記述, テーブルカラム省略, 可読性

</details>

## 参照系テストのAPI

参照系テストのAPI:

- `setUpDb(sheetName)`: 指定シートの準備データをDBに登録する
- `assertSqlResultSetEquals(sheetName, expectedId, actual)`: ExcelシートのLIST_MAP=<expectedId>と実際の`SqlResultSet`の内容を比較する

コンポーネント設定ファイルで明示的に指定しない場合のデフォルト値:

| カラム型 | デフォルト値 |
|---|---|
| 数値型 | 0 |
| 文字列型 | 半角スペース |
| 日付型 | 1970-01-01 00:00:00.0 |

<details>
<summary>keywords</summary>

setUpDb, assertSqlResultSetEquals, 参照系テスト, SqlResultSet, LIST_MAP, デフォルト値, 数値型デフォルト, 文字列型デフォルト, 日付型デフォルト, 1970-01-01 00:00:00.0

</details>

## 基本的なテスト方法

テストクラスは`DbAccessTestSupport`を継承して作成する。参照系テスト（コミット不要）と更新系テスト（`commitTransactions()`でコミット後にDB確認）の2種類をサポートする。

**クラス**: `nablarch.test.core.db.BasicDefaultValues`

| 設定項目名 | 説明 | 設定値 |
|---|---|---|
| charValue | 文字列型のデフォルト値 | 1文字のASCII文字 |
| numberValue | 数値型のデフォルト値 | 0または正の整数 |
| dateValue | 日付型のデフォルト値 | JDBCタイムスタンプエスケープ形式 (yyyy-mm-dd hh:mm:ss.fffffffff) |

<details>
<summary>keywords</summary>

DbAccessTestSupport, 参照系テスト, 更新系テスト, commitTransactions, テストクラス継承, BasicDefaultValues, nablarch.test.core.db.BasicDefaultValues, charValue, numberValue, dateValue, デフォルト値設定

</details>

## シーケンス

参照系テストの処理フロー:

1. `setUpDb(sheetName)` でExcelの準備データをDBに登録する
2. テスト対象メソッドを起動する
3. `assertSqlResultSetEquals(sheetName, expectedId, actual)` でExcelの期待値と検索結果を比較する

```xml
<!-- TestDataParser -->
<component name="testDataParser" class="nablarch.test.core.reader.BasicTestDataParser">
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

参照系テスト, setUpDb, assertSqlResultSetEquals, シーケンス, BasicTestDataParser, nablarch.test.core.reader.BasicTestDataParser, testDataParser, defaultValues, デフォルト値コンポーネント設定

</details>

## テストソースコード実装例

```java
public class DbAccessTestSample extends DbAccessTestSupport {
    @Test
    public void testSelectAll() {
        setUpDb("testSelectAll"); // シート名で準備データを登録
        EmployeeDbAcess target = new EmployeeDbAccess();
        SqlResultSet actual = target.selectAll();
        // assertSqlResultSetEquals(シート名, 期待値ID, 実際の値)
        assertSqlResultSetEquals("testSelectAll", "expected", actual);
    }
}
```

**setUpDbメソッドに関する注意点**

- 全カラムを記述する必要はない。省略されたカラムにはデフォルト値が設定される。
- 1シート内に複数テーブルを記述できる。`setUpDb(String sheetName)` 実行時、指定シート内のデータタイプ `SETUP_TABLE` がすべて登録対象となる。

**assertTableEqualsメソッドに関する注意点**

- 省略されたカラムは比較対象外。
- 主キーを突合してレコードを比較するため、レコード順序が異なっていても正しく比較できる。
- 1シート内に複数テーブルを記述できる。`assertTableEquals(String sheetName)` 実行時、指定シート内のデータタイプ `EXPECTED_TABLE` がすべて比較される。
- `java.sql.Timestamp` 型フォーマットは `yyyy-mm-dd hh:mm:ss.fffffffff`（fffffffffはナノ秒）。ナノ秒が未設定の場合でも `0` が付与される（例: `2010-01-01 12:34:56.0`）。Excelシートの期待値には末尾の小数点＋ゼロを付与すること。

**assertSqlResultSetEqualsメソッドに関する注意点**

- SELECT文で指定された全カラム（別名含む）が比較対象。特定カラムを比較対象外にすることはできない。
- レコード順序が異なる場合はアサート失敗。これは以下の理由による:
  - SELECTで指定されたカラムに主キーが含まれているとは限らないため（主キー突合による順序無視ができない）。
  - SELECT実行時はORDER BY指定がなされる場合がほとんどであり、順序についても厳密に比較する必要があるため。

**クラス単体テストにおける登録・更新系テストの注意点**

- 自動設定項目を使用するDB登録・更新時、`ThreadContext` にリクエストIDとユーザIDの設定が必要。（using_ThreadContext セクション参照）
- デフォルト以外のトランザクションを使用する場合、本フレームワークにトランザクション制御を行わせる必要がある。（using_transactions セクション参照）

<details>
<summary>keywords</summary>

DbAccessTestSupport, setUpDb, assertSqlResultSetEquals, SqlResultSet, selectAll, assertTableEquals, ThreadContext, java.sql.Timestamp, トランザクション制御, レコード順序, 自動設定項目

</details>

## テストデータ記述例

**SETUP_TABLE（準備データ）**:

- 1行目: `SETUP_TABLE=<テーブル名>`
- 2行目: カラム名
- 3行目〜: 登録レコード

**LIST_MAP（期待値）**:

- 1行目: `LIST_MAP=<シート内で一意な期待値ID（任意文字列）>`
- 2行目: SELECT文のカラム名または別名
- 3行目〜: 検索結果

<details>
<summary>keywords</summary>

SETUP_TABLE, LIST_MAP, 準備データ, 期待値, 参照系テスト, Excelフォーマット

</details>

## シーケンス

更新系テストの処理フロー:

1. `setUpDb(sheetName)` でExcelの準備データをDBに登録する
2. テスト対象メソッドを起動する
3. `commitTransactions()` でトランザクションをコミットする
4. `assertTableEquals(sheetName, actual)` でDBの更新結果を確認する

<details>
<summary>keywords</summary>

更新系テスト, commitTransactions, assertTableEquals, シーケンス

</details>

## 更新系テストのトランザクション注意事項

> **警告**: Nablarch Application Frameworkでは複数種類のトランザクションを併用するため、テスト対象クラス実行後にDBの内容を確認する際にはトランザクションをコミットしなければならない。コミットしない場合、テスト結果の確認が正常に行われない。

> **注意**: 参照系のテストの場合はコミットを行う必要はない。

<details>
<summary>keywords</summary>

commitTransactions, 更新系テスト, トランザクション, コミット, 警告

</details>

## テストソースコード実装例

```java
public class DbAccessTestSample extends DbAccsessTestSupport {
    @Test
    public void testDeleteExpired() {
        setUpDb("testDeleteExpired");
        EmployeeDbAcess target = new EmployeeDbAccess();
        SqlResultSet actual = target.deleteExpired(); // 期限切れデータを削除
        // トランザクションをコミット
        commitTransactions();
        assertTableEquals("testDeleteExpired", actual);
    }
}
```

<details>
<summary>keywords</summary>

DbAccessTestSupport, setUpDb, commitTransactions, assertTableEquals, deleteExpired

</details>

## テストデータ記述例

**SETUP_TABLE（準備データ）**:

- 1行目: `SETUP_TABLE=<テーブル名>`
- 2行目: カラム名
- 3行目〜: 登録レコード

**EXPECTED_TABLE（期待値）**:

- 1行目: `EXPECTED_TABLE=<確認対象テーブル名>`
- 2行目: 確認対象カラム名（型コメント例: `// CHAR(5)`, `// VARCHAR(64)`, `// BOOLEAN`）
- 3行目〜: 期待する値

<details>
<summary>keywords</summary>

SETUP_TABLE, EXPECTED_TABLE, 準備データ, 期待値, 更新系テスト, Excelフォーマット

</details>

## データベーステストデータの省略記述方法

テストデータ記述で無関係なカラムを省略できる。省略されたカラムには:ref:`default_values_when_column_omitted`が設定される。

**省略ルール**:
- 主キーカラムは省略不可
- DB検索結果（`LIST_MAP`）の期待値は全カラム記述必須
- 登録系テストの新規レコード期待値も全カラム記述必須

**EXPECTED_TABLE vs EXPECTED_COMPLETE_TABLE**:
- `EXPECTED_TABLE`: 省略カラムは比較対象外
- `EXPECTED_COMPLETE_TABLE`: 省略カラムには:ref:`デフォルト値<default_values_when_column_omitted>`が設定されているものとして比較する。更新系テストで「無関係なカラムが更新されていないこと」も確認する場合に使用する。

<details>
<summary>keywords</summary>

EXPECTED_TABLE, EXPECTED_COMPLETE_TABLE, カラム省略, デフォルト値, 主キー省略不可, default_values_when_column_omitted

</details>

## テストケース例

テストケース例: 「有効期限を過ぎたレコードは削除フラグが1に更新されること」（テスト実施日: 2011/01/01）

使用テーブル（SAMPLE_TABLE）のカラム構成:

| カラム名 | 説明 |
|---|---|
| PK1, PK2 | 主キー |
| COL_A〜COL_D | テスト対象機能では使用しないカラム |
| 有効期限 | 有効期限を過ぎたデータが処理対象 |
| 削除フラグ | 有効期限を過ぎたレコードの値を'1'に変更 |

<details>
<summary>keywords</summary>

SAMPLE_TABLE, 削除フラグ, 有効期限, テストケース

</details>

## 省略せずに全カラムを記載した場合（悪い例）

全カラムを記載した場合（テスト対象と無関係なCOL_A〜COL_Dも記述）は可読性に劣る。テーブル定義変更時に無関係なカラムでも修正が必要になる。

**準備データ（SETUP_TABLE=SAMPLE_TABLE）**:

| PK_1 | PK_2 | COL_A | COL_B | COL_C | COL_D | 有効期限 | 削除フラグ |
|---|---|---|---|---|---|---|---|
| 01 | 0001 | 1a | 1b | 1c | 1d | 20101231 | 0 |
| 02 | 0002 | 2a | 2b | 2c | 2d | 20110101 | 0 |

**期待値（EXPECTED_TABLE=SAMPLE_TABLE）**:

| PK_1 | PK_2 | COL_A | COL_B | COL_C | COL_D | 有効期限 | 削除フラグ |
|---|---|---|---|---|---|---|---|
| 01 | 0001 | 1a | 1b | 1c | 1d | 20101231 | 1 |
| 02 | 0002 | 2a | 2b | 2c | 2d | 20110101 | 0 |

<details>
<summary>keywords</summary>

SETUP_TABLE, EXPECTED_TABLE, 全カラム記載, 悪い例, 可読性, カラム省略

</details>
