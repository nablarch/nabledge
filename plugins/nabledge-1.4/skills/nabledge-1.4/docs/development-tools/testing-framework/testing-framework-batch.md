# 各種期待値

## 可変長ファイル（CSVファイル）の準備

## 可変長ファイル（CSVファイル）の準備

固定長との違い: フィールド長を記載しない。`SETUP_VARIABLE=ファイルパス` で可変長ファイル（CSV）を定義する。

テストシートでの定義例（`SETUP_VARIABLE=work/members.csv`）:

| ディレクティブ | 値 |
|---|---|
| text-encoding | Windows-31J |
| record-separator | CRLF |

レコード定義: ヘッダ・データ・トレーラ・エンドの各レコード種別を行単位で定義する。各行は「フィールド名行（型定義）」と「値行」をセットで記述する。固定長と異なりフィールド長の列は不要。

> **注意**: フィールド区切り文字を変更する場合はディレクティブで明示的に指定する。タブ区切り（TSVファイル）にする場合: `field-separator=\t`

<details>
<summary>keywords</summary>

SETUP_VARIABLE, 可変長ファイル, CSVファイル, フィールド区切り文字, field-separator, TSVファイル, 可変長ファイル定義, text-encoding, record-separator

</details>

## 空のファイルを定義する方法

## 空のファイルを定義する方法

準備データや期待値として空ファイル（0バイトファイル）を定義する方法: テストシート上でディレクティブ行を定義し、レコードの定義を省略する。

空ファイル定義例（`SETUP_VARIABLE=work/members.csv`）:

```
text-encoding  | Windows-31J
record-separator | CRLF
//空ファイル
```

ディレクティブ行（`text-encoding`、`record-separator` 等）を定義したうえでレコード定義を省略することで、0バイトファイルとして定義される。

<details>
<summary>keywords</summary>

空ファイル, 0バイトファイル, SETUP_VARIABLE, ディレクティブ, 空ファイル定義

</details>

## 期待するデータベースの状態

## 期待するデータベースの状態

:ref:`オンライン<request_test_expected_tables>` と同様に、期待するデータベースの状態をテストケース一覧とリンクさせる。

<details>
<summary>keywords</summary>

期待値, データベース, expectedTable, テストケース一覧, DB期待値

</details>

## 期待する固定長ファイル

## 期待する固定長ファイル

テスト対象バッチが出力する固定長ファイルをアサートする。

- データタイプ: `EXPECTED_FIXED`（準備データの `SETUP_FIXED` の代わりに使用）
- その他の記述方法は固定長ファイルの準備と同様。

<details>
<summary>keywords</summary>

EXPECTED_FIXED, 固定長ファイル, 期待値, ファイルアサート, 期待ファイル

</details>

## 期待する可変長ファイル

## 期待する可変長ファイル

テスト対象バッチが出力する可変長ファイルをアサートする。

- データタイプ: `EXPECTED_VARIABLE`（準備データの `SETUP_VARIABLE` の代わりに使用）
- その他の記述方法は可変長ファイルの準備と同様。

<details>
<summary>keywords</summary>

EXPECTED_VARIABLE, 可変長ファイル, 期待値, ファイルアサート, 期待ファイル

</details>

## 

なし

<details>
<summary>keywords</summary>

セクション区切り

</details>

## テストメソッドの書き方

## テストメソッドの書き方

### スーパクラス

**クラス**: `BatchRequestTestSupport` を継承する。このクラスが準備したテストデータを元にリクエスト単体テストを実行する。

### テストメソッド作成

準備したテストシートに対応するメソッドを `@Test` アノテーションを付与して作成する。

```java
@Test
public void testRegisterUser() {
}
```

### スーパクラスのメソッド呼び出し

テストメソッド内でスーパクラスの以下いずれかを呼び出す:

- `void execute()` — 引数なし: テストメソッド名をシート名として使用（通常はこちらを使用）
- `void execute(String sheetName)` — テストデータのシート名を明示指定

引数なしの `execute()` は `execute(テストメソッド名)` と等価。

```java
@Test
public void testResigster() {
    execute();   // execute("testRegisterUser") と等価
}
```

<details>
<summary>keywords</summary>

BatchRequestTestSupport, execute, テストメソッド, スーパクラス, JUnit, バッチテストメソッド, @Test

</details>

## 

なし

<details>
<summary>keywords</summary>

セクション区切り

</details>

## テスト起動方法

## テスト起動方法

通常のJUnitテストと同じように実行する。クラス単体テストの起動方法と同様。

<details>
<summary>keywords</summary>

JUnit, テスト実行, バッチリクエスト単体テスト, テスト起動

</details>

## 

なし

<details>
<summary>keywords</summary>

セクション区切り

</details>

## テスト結果検証

## テスト結果検証

### データベースの結果検証

テストケース一覧の `expectedTable` 欄にグループIDを記載することで、そのグループIDのテストデータで実際のDB状態を確認する。

### ファイルの結果検証

テストケース一覧の `expectedFile` 欄にグループIDを記載することで、そのグループIDのテストデータで実際のファイル出力結果を確認する。

| ファイル種別 | グループID指定なし | グループID指定あり |
|---|---|---|
| 固定長ファイル | `EXPECTED_FIXED=比較対象ファイルのパス` | `EXPECTED_FIXED[グループID]=比較対象ファイルのパス` |
| 可変長ファイル | `EXPECTED_VARIABLE=比較対象ファイルのパス` | `EXPECTED_VARIABLE[グループID]=比較対象ファイルのパス` |

### ログの結果検証

テストケース一覧の `expectedLog` 欄にグループIDを記載することで、そのグループIDのテストデータで実際のログ出力結果を確認する。

`LIST_MAP=expectedLogMessages` に以下のカラムで期待値を記載する:

| カラム名 | 内容 |
|---|---|
| logLevel | 期待するログのログレベル |
| message**N** | 期待するログに含まれる文言（Nは1以上の整数、複数指定可、連続する値であること） |

> **注意**: 全条件はAND条件。(1) 期待文言がログ出力されていてもログレベルが期待通りでない場合、(2) ログレベルが合致していても期待文言が1つでも出力されていない場合、は期待するログが出力されたとは見なされない。

> **警告**: `expectedLog` 欄にグループIDを記載した場合は必ず期待メッセージを1行以上設定すること。期待メッセージが0行の場合、またはグループIDに紐付くLIST_MAP要素が存在しない場合、フレームワークは例外を送出する。

<details>
<summary>keywords</summary>

expectedTable, expectedFile, expectedLog, EXPECTED_FIXED, EXPECTED_VARIABLE, logLevel, グループID, ログ検証, 結果検証, LIST_MAP

</details>
