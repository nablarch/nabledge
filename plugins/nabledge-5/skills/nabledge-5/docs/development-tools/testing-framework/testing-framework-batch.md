# 各種期待値

**公式ドキュメント**: [各種期待値](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/batch.html)

## 可変長ファイル（CSVファイル）の準備

可変長ファイル（CSV）の準備は固定長とほぼ同様。**固定長との違い**: フィールド長を記載しない。

データタイプ: `SETUP_VARIABLE=ファイルパス`

テーブル構成例（`SETUP_VARIABLE=work/members.csv`）:

| ディレクティブ | 値 |
|---|---|
| text-encoding | Windows-31J |
| record-separator | CRLF |

レコード種別ごとに、フィールド名行・型行・データ行を定義する（フィールド長の列は不要）。

> **補足**: フィールド区切り文字を変更する場合は、ディレクティブで明示的に指定する。タブ区切り（TSV）にする場合: `field-separator=\t`

<details>
<summary>keywords</summary>

SETUP_VARIABLE, 可変長ファイル準備, CSVファイル定義, フィールド区切り文字, field-separator, TSVファイル

</details>

## 空のファイルを定義する方法

空ファイル（0バイトファイル）を準備データや期待値として定義するには、ディレクティブ行のみ記述しレコードの定義を省略する。

```
SETUP_VARIABLE=work/members.csv

text-encoding  | Windows-31J
record-separator | CRLF
//空ファイル
```

レコード行を一切記述しないことで空ファイルとして扱われる。

<details>
<summary>keywords</summary>

空ファイル, 0バイトファイル, 空ファイル定義, SETUP_VARIABLE, レコード省略

</details>

## 期待するデータベースの状態

:ref:`オンライン<request_test_expected_tables>` と同様に、期待するデータベースの状態をテストケース一覧とIDでリンクさせる。

<details>
<summary>keywords</summary>

期待値DB, expectedTable, テストケース一覧, グループID, データベース結果検証

</details>

## 期待する固定長ファイル

テスト対象バッチが出力する固定長ファイルをアサートする場合、データタイプを `EXPECTED_FIXED` に変更する（準備データは `SETUP_FIXED`）。

その他の記述方法は固定長ファイルの準備と同様。

<details>
<summary>keywords</summary>

EXPECTED_FIXED, 固定長ファイル期待値, ファイルアサート

</details>

## 期待する可変長ファイル

テスト対象バッチが出力する可変長ファイルをアサートする場合、データタイプを `EXPECTED_VARIABLE` に変更する（準備データは `SETUP_VARIABLE`）。

その他の記述方法は可変長ファイルの準備と同様。

<details>
<summary>keywords</summary>

EXPECTED_VARIABLE, 可変長ファイル期待値, CSVアサート

</details>

## テストメソッドの書き方

**クラス**: `BatchRequestTestSupport` を継承する。

テストシートに対応するメソッドを作成し、スーパクラスの以下いずれかのメソッドを呼び出す:

- `void execute()` — 引数なし。テストメソッド名をシート名として使用（通常はこちら）
- `void execute(String sheetName)` — テストデータのシート名を明示指定

```java
@Test
public void testResigster() {
    execute();   // execute("testRegisterUser") と等価
}
```

<details>
<summary>keywords</summary>

BatchRequestTestSupport, execute, テストメソッド作成, スーパクラス継承, シート名指定

</details>

## テスト起動方法

クラス単体テストと同様。通常のJUnitテストと同じように実行する。

<details>
<summary>keywords</summary>

JUnit実行, バッチリクエスト単体テスト起動, クラス単体テスト

</details>

## テスト結果検証

## データベースの結果検証

テストケース一覧の `expectedTable` 欄にグループIDを記載することで、そのグループIDのテストデータで実際のDB状態を確認できる。

## ファイルの結果検証

テストケース一覧の `expectedFile` 欄にグループIDを記載する。記述形式:

| ファイル種別 | グループIDなし | グループIDあり |
|---|---|---|
| 固定長ファイル | `EXPECTED_FIXED=比較対象ファイルのパス` | `EXPECTED_FIXED[グループID]=比較対象ファイルのパス` |
| 可変長ファイル | `EXPECTED_VARIABLE=比較対象ファイルのパス` | `EXPECTED_VARIABLE[グループID]=比較対象ファイルのパス` |

## ログの結果検証

テストケース一覧の `expectedLog` 欄にグループIDを記載する。`LIST_MAP=expectedLogMessages` で以下のカラムを定義する:

| カラム名 | 内容 |
|---|---|
| logLevel | 期待するログのログレベル |
| message**N** | 期待するログに含まれる文言（N は1以上の整数。**連続する値であること**。例: message1, message2, message3） |

条件はすべて **AND** 条件。以下の場合は期待通りと見なされない:
- 期待する文言はログ出力されているが、ログレベルが期待通りでない
- ログレベルは合致しているが、期待する文言でログ出力されていないものが1つでもある

> **重要**: `expectedLog` 欄にグループIDを記載した場合は、必ず期待するメッセージを1行以上設定すること。期待するメッセージが0行の場合、または記載されたグループIDに紐付く `LIST_MAP` 要素が存在しない場合、フレームワークは期待値の準備が不足していると判断し例外を送出する。

<details>
<summary>keywords</summary>

expectedTable, expectedFile, expectedLog, ログ結果検証, ファイル結果検証, グループID, EXPECTED_FIXED, EXPECTED_VARIABLE, logLevel, messageN, LIST_MAP

</details>
