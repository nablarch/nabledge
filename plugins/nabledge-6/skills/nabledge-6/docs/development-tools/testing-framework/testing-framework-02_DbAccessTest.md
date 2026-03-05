# データベースを使用するクラスのテスト

## 主なクラス、リソース

データベーステストフレームワークを使用することで、準備データ投入やデータ確認などのデータベース操作を自動化できる。

**クラス構成**

![クラス構成](../../knowledge/development-tools/testing-framework/assets/testing-framework-02_DbAccessTest/class_structure.png)

| 名称 | 役割 | 作成単位 |
|---|---|---|
| テストクラス | テストロジック実装。`DbAccessTestSupport`を継承 | テスト対象クラスごと |
| テストデータ (Excelファイル) | 準備データ・期待値を記載 | テストクラスごと |
| テスト対象クラス | テスト対象 | — |
| `DbAccessTestSupport` | 準備データ投入等の機能提供。トランザクション制御 (:ref:`using_transactions`) | — |

## 基本的なテスト方法

**参照系のテスト**

テスト手順:
1. 準備データ登録
2. テスト対象メソッド起動
3. 検索結果が期待値と一致することを確認

**更新系のテスト**

テスト手順:
1. 準備データ登録
2. テスト対象メソッド起動
3. トランザクションコミット
4. DB値が期待通り更新されたことを確認

> **重要**: Nablarchでは複数トランザクション併用が前提。テスト対象クラス実行後にDB内容を確認する際はトランザクションをコミットすること。コミットしない場合、テスト結果確認が正常に行われない。

> **補足**: 参照系テストではコミット不要。

## シーケンス（参照系）

![参照系テストシーケンス](../../knowledge/development-tools/testing-framework/assets/testing-framework-02_DbAccessTest/select_sequence.png)

**実行フロー**: テストクラス → `setUpDb()` (準備データ登録) → テスト対象メソッド起動 → DB検索 → `assertSqlResultSetEquals()` (期待値比較)

## テストソースコード実装例（参照系）

```java
public class DbAccessTestSample extends DbAccessTestSupport {
    @Test
    public void testSelectAll() {
        setUpDb("testSelectAll");  // 準備データ登録（引数=シート名）
        
        EmployeeDbAccess target = new EmployeeDbAccess();
        SqlResultSet actual = target.selectAll();
        
        assertSqlResultSetEquals("testSelectAll", "expected", actual);  // 期待値比較（シート名, 期待値ID, 実測値）
    }
}
```

**クラス**: `DbAccessTestSupport` (継承必須), `SqlResultSet`, `EmployeeDbAccess`

**メソッド**:
- `setUpDb(String sheetName)`: 準備データ登録
- `assertSqlResultSetEquals(String sheetName, String id, SqlResultSet actual)`: 検索結果の期待値比較

## テストデータ記述例（参照系）

**準備データ形式** (:ref:`how_to_write_setup_table`):

| 行 | 内容 |
|---|---|
| 1行目 | `SETUP_TABLE=<テーブル名>` |
| 2行目 | カラム名 |
| 3行目〜 | レコード |

例:
```
SETUP_TABLE=EMPLOYEE
ID          EMP_NAME     DEPT_CODE
00001       山田太郎     0001
00002       田中一郎     0002
```

**期待値形式**:

| 行 | 内容 |
|---|---|
| 1行目 | `LIST_MAP=<期待値ID>` |
| 2行目 | SELECT文のカラム名または別名 |
| 3行目〜 | 期待する検索結果 |

例:
```
LIST_MAP=expected
ID          EMP_NAME     DEPT_NAME
00001       山田太郎     人事部
00002       田中一郎     総務部
```

## シーケンス（更新系）

![更新系テストシーケンス](../../knowledge/development-tools/testing-framework/assets/testing-framework-02_DbAccessTest/update_sequence.png)

**実行フロー**: テストクラス → `setUpDb()` (準備データ登録) → テスト対象メソッド起動 → `commitTransactions()` → `assertTableEquals()` (DB値の期待値比較)

## テストソースコード実装例（更新系）

```java
public class DbAccessTestSample extends DbAccessTestSupport {
    @Test
    public void testDeleteExpired() {
        setUpDb("testDeleteExpired");  // 準備データ登録
        
        EmployeeDbAccess target = new EmployeeDbAccess();
        target.deleteExpired();  // 更新処理実行
        
        commitTransactions();  // コミット（更新系では必須）
        
        assertTableEquals("testDeleteExpired");  // DB値の期待値比較
    }
}
```

**メソッド**:
- `commitTransactions()`: トランザクションコミット（更新系テストでは必須）
- `assertTableEquals(String sheetName)`: DB内容の期待値比較

## テストデータ記述例（更新系）

**準備データ形式**: 参照系と同じ (`SETUP_TABLE=<テーブル名>`)

**期待値形式** (更新系):

| 行 | 内容 |
|---|---|
| 1行目 | `EXPECTED_TABLE=<テーブル名>` |
| 2行目 | カラム名 |
| 3行目〜 | 期待するDB値 |

例:
```
EXPECTED_TABLE=EMPLOYEE
ID          EMP_NAME      EXPIRED
// CHAR(5)  VARCHAR(64)   BOOLEAN
00002       田中一郎      FALSE
```

注: 2行目にデータ型をコメント記載可 (例: `// CHAR(5)`)

## データベーステストデータの省略記述方法

**カラム省略記述**

関係のないカラムは省略可能。省略カラムには :ref:`default_values_when_column_omitted` が設定される。テストデータの可読性・保守性が向上。特に更新系テスト（多カラム中1カラムのみ更新）で有効。

> **重要**: 以下の場合はカラム省略不可:
> - 検索結果の期待値: 検索対象カラム全てを記述必須
> - 登録系テスト: 新規登録レコードの全カラムを確認必須

**準備データでのカラム省略**

省略カラムにはデフォルト値が設定される。ただし **主キーは省略不可**。

**期待値でのカラム省略**

- `EXPECTED_TABLE`: 省略カラムは比較対象外
- `EXPECTED_COMPLETE_TABLE`: 省略カラムにはデフォルト値が格納されているものとして比較（更新系で「無関係カラムが未更新」を確認する場合に使用）

## テストケース例

**テストケース**: 有効期限を過ぎたレコードの削除フラグを1に更新 (テスト日付: 2011/01/01)

**テーブル構造** (SAMPLE_TABLE):

| カラム名 | 説明 |
|---|---|
| PK1, PK2 | 主キー |
| COL_A〜COL_D | テスト対象機能では未使用 |
| 有効期限 | 処理対象判定（有効期限を過ぎたデータが処理対象） |
| 削除フラグ | 更新対象（有効期限切れ → 1） |

## 省略せずに全カラムを記載した場合（悪い例）

**悪い例（全カラム記載）**

問題点:
- 無関係カラム (COL_A〜D) の記載により可読性が低下
- テーブル定義変更時、無関係カラムも修正が必要

準備データ・期待値ともに全8カラム (PK_1, PK_2, COL_A, COL_B, COL_C, COL_D, 有効期限, 削除フラグ) を記載。テスト対象は削除フラグのみだが、無関係なCOL_A〜Dも全て記述する必要がある。

## 関係のあるカラムのみを記載した場合（良い例）

関係のあるカラムのみを記載することで可読性、保守性が向上する。テーブル定義変更時も無関係なカラムは影響を受けない。

このテストケースに関係のあるカラム:
- 主キー (PK_1, PK_2)
- 有効期限（更新対象レコード抽出条件）
- 削除フラグ（更新対象）

**準備データ例**

SETUP_TABLE=SAMPLE_TABLE

| PK_1 | PK_2 | 有効期限 | 削除フラグ |
|------|------|----------|------------|
| 01   | 0001 | 20101231 | 0          |
| 02   | 0002 | 20110101 | 0          |

**期待値例**

`EXPECTED_TABLE`の代わりに`EXPECTED_COMPLETE_TABLE`を使用する。

EXPECTED_COMPLETE_TABLE=SAMPLE_TABLE

| PK_1 | PK_2 | 有効期限 | 削除フラグ |
|------|------|----------|------------|
| 01   | 0001 | 20101231 | 1          |
| 02   | 0002 | 20110101 | 0          |

## デフォルト値

コンポーネント設定ファイルで明示的に指定しない場合のデフォルト値:

| カラム型 | デフォルト値          |
|----------|-----------------------|
| 数値型   | 0                     |
| 文字列型 | 半角スペース          |
| 日付型   | 1970-01-01 00:00:00.0 |

## デフォルト値の変更方法

## 設定項目一覧

**クラス**: `nablarch.test.core.db.BasicDefaultValues`

設定可能な値:

| 設定項目名  | 説明                   | 設定値                                                           |
|-------------|------------------------|------------------------------------------------------------------|
| charValue   | 文字列型のデフォルト値 | 1文字のASCII文字                                                 |
| numberValue | 数値型のデフォルト値   | 0または正の整数                                                  |
| dateValue   | 日付型のデフォルト値   | JDBCタイムスタンプエスケープ形式 (yyyy-mm-dd hh:mm:ss.fffffffff) |

## コンポーネント設定ファイルの記述例

設定例:

| 設定項目名  | 設定値                        |
|-------------|-------------------------------|
| charValue   | a                             |
| numberValue | 1                             |
| dateValue   | 2000-01-01 12:34:56.123456789 |

```xml
<component name="testDataParser" class="nablarch.test.core.reader.BasicTestDataParser">
  <property name="defaultValues">
    <component class="nablarch.test.core.db.BasicDefaultValues">
      <property name="charValue" value="a"/>
      <property name="dateValue" value="2000-01-01 12:34:56.123456789"/>
      <property name="numberValue" value="1"/>
    </property>
  </property>
</component>
```

## 

このセクションには内容がありません。おそらく文書構造上の区切りまたはパーサーのアーティファクトです。

## 注意点

## setUpDbメソッドに関する注意点

- Excelファイルに全カラムを記述する必要はない。省略されたカラムにはデフォルト値が設定される
- 1シート内に複数テーブルを記述可能。`setUpDb(String sheetName)`実行時、指定シート内のデータタイプ`SETUP_TABLE`すべてが登録対象となる

## assertTableEqualsメソッドに関する注意点

- 期待値の記述で省略されたカラムは比較対象外
- レコード順序が異なっていても主キーで突合して正しく比較できる。レコード順序を意識した期待データ作成は不要
- 1シート内に複数テーブルを記述可能。`assertTableEquals(String sheetName)`実行時、指定シート内のデータタイプ`EXPECTED_TABLE`すべてが比較される
- `java.sql.Timestamp`型のフォーマットは`yyyy-mm-dd hh:mm:ss.fffffffff`。ナノ秒が設定されていない場合でも0ナノ秒として表示される（例: `2010-01-01 12:34:56.0`）。Excelシートに期待値を記載する際は末尾の小数点+ゼロを付与すること

## assertSqlResultSetEqualsメソッドに関する注意点

- SELECT文で指定されたすべてのカラム名（別名）が比較対象。特定カラムを比較対象外にすることはできない
- レコードの順序が異なる場合は等価でないとみなす（アサート失敗）。理由:
  - SELECTで指定されたカラムに主キーが含まれているとは限らない
  - SELECT実行時はORDER BY指定がなされる場合がほとんどであり、順序についても厳密に比較する必要がある

## クラス単体テストにおける登録・更新系テストの注意点

- 自動設定項目を利用してDB登録・更新する際は、ThreadContextにリクエストIDとユーザIDが設定されている必要がある。テスト対象クラス起動前に設定すること（:ref:`using_ThreadContext`参照）
- デフォルト以外のトランザクションを使用する場合は、本フレームワークにトランザクション制御を行わせる必要がある（:ref:`using_transactions`参照）

## 外部キーが設定されたテーブルにデータをセットアップしたい

:ref:`master_data_backup`と同じ機能を用いて、テーブルの親子関係を判断しデータを削除及び登録する。詳細は:ref:`MasterDataRestore-fk_key`を参照。

## Excelファイルに記述できるカラムのデータ型に関する注意点

Excelファイルには、`SqlPStatement`で対応している型のカラムのみテストデータとして記述できる。

それ以外のデータ型（例: OracleのROWID、PostgreSQLのOID）のカラムはテストデータとして記述できない点に注意。
