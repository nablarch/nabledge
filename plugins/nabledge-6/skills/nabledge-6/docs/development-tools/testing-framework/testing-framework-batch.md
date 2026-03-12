# リクエスト単体テストの実施方法(バッチ)

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/batch.html) [2](https://github.com/nablarch/nablarch-testing/blob/main/src/main/java/nablarch/test/core/file/BasicDataTypeMapping.java) [3](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/batch.html)

## 可変長ファイル（CSVファイル）の準備

可変長ファイル（CSVファイル）の準備は固定長とほぼ同様。**固定長との違い**: フィールド長を記載しない。

テストシートでの定義例:

`SETUP_VARIABLE=work/members.csv`

| 区分 | フィールド1 | フィールド2 | フィールド3 |
|---|---|---|---|
| text-encoding | Windows-31J | | |
| record-separator | CRLF | | |
| ヘッダ | レコード区分 | | |
| | 半角数字 | | |
| | 0 | | |
| データ | レコード区分 | 会員番号 | 入会日 |
| | 半角数字 | 半角数字 | 半角数字 |
| | 1 | 0000000001 | 20100101 |
| | 1 | 0000000002 | 20100102 |
| トレーラ | レコード区分 | レコード件数 | |
| | 半角数字 | 数値 | |
| | 8 | 2 | |
| エンド | レコード区分 | | |
| | 半角数字 | | |
| | 9 | | |

> **補足**: フィールド区切り文字を変更する場合、ディレクティブで明示的に指定する。例：タブ区切り（TSV）にする場合: `field-separator=\t`

<details>
<summary>keywords</summary>

SETUP_VARIABLE, 可変長ファイル準備, CSVファイル, フィールド区切り文字, field-separator

</details>

## 空のファイルを定義する方法

空のファイル（0バイト）を定義するには、ディレクティブ行を定義しレコードの定義を省略する。

`SETUP_VARIABLE=work/members.csv`

| | |
|---|---|
| text-encoding | Windows-31J |
| record-separator | CRLF |
| //空ファイル | |

<details>
<summary>keywords</summary>

空ファイル定義, 0バイトファイル, SETUP_VARIABLE, ディレクティブ

</details>

## 期待するデータベースの状態

:ref:`オンライン<request_test_expected_tables>` と同様に、期待するデータベースの状態をテストケース一覧とリンクさせる。テストケース一覧の `expectedTable` 欄にグループIDを記載することで、そのグループIDのテストデータで実際のDB状態を確認できる。

<details>
<summary>keywords</summary>

期待するデータベース状態, expectedTable, テストケース一覧, request_test_expected_tables

</details>

## 期待する固定長ファイル

テスト対象バッチが出力する固定長ファイルをアサートする。準備データのデータタイプ `SETUP_FIXED` に対し、期待値では `EXPECTED_FIXED` を使用する。その他の記述方法は`固定長ファイルの準備`_と同様。

<details>
<summary>keywords</summary>

EXPECTED_FIXED, SETUP_FIXED, 期待する固定長ファイル, ファイルアサート

</details>

## 期待する可変長ファイル

テスト対象バッチが出力する可変長ファイルをアサートする。準備データのデータタイプ `SETUP_VARIABLE` に対し、期待値では `EXPECTED_VARIABLE` を使用する。その他の記述方法は`可変長ファイル（CSVファイル）の準備`_と同様。

<details>
<summary>keywords</summary>

EXPECTED_VARIABLE, SETUP_VARIABLE, 期待する可変長ファイル, ファイルアサート

</details>

## テストメソッドの書き方

**クラス**: `BatchRequestTestSupport` を継承する。

テストメソッド内でスーパクラスの以下のいずれかのメソッドを呼び出す:
- `void execute()` - 引数なし（テストデータのシート名にテストメソッド名を指定したのと同じ動作）
- `void execute(String sheetName)` - テストデータのシート名を明示指定

通常は `execute()` を使用する。引数なしの場合、テストデータのシート名にテストメソッド名を指定したのと同じ動作となる。

```java
@Test
public void testResigster() {
    execute();   // execute("testRegisterUser") と等価
}
```

<details>
<summary>keywords</summary>

BatchRequestTestSupport, execute, テストメソッド作成, スーパクラス, シート名指定

</details>

## テスト起動方法

クラス単体テストと同様。通常のJUnitテストと同じように実行する。

<details>
<summary>keywords</summary>

テスト起動, JUnit実行, クラス単体テスト

</details>

## テスト結果検証

### データベースの結果検証

テストケース一覧の `expectedTable` 欄にグループIDを記載することで、そのグループIDのテストデータで実際のDB状態を確認できる。

### ファイルの結果検証

テストケース一覧の `expectedFile` 欄にグループIDを記載することで確認できる。

| ファイル種別 | グループID指定なし | グループID指定あり |
|---|---|---|
| 固定長ファイル | `EXPECTED_FIXED=比較対象ファイルのパス` | `EXPECTED_FIXED[グループID]=比較対象ファイルのパス` |
| 可変長ファイル | `EXPECTED_VARIABLE=比較対象ファイルのパス` | `EXPECTED_VARIABLE[グループID]=比較対象ファイルのパス` |

### ログの結果検証

テストケース一覧の `expectedLog` 欄にグループIDを記載することで確認できる。

`LIST_MAP=expectedLogMessages` に以下のカラムを定義:

| カラム名 | 内容 |
|---|---|
| logLevel | 期待するログのログレベル |
| message**N**（Nは1以上の整数） | 期待するログに含まれる文言（複数指定可、連続した値であること） |

> **補足**: logLevel と全messageN の条件は**AND**条件。logLevelが不一致の場合、または期待する文言が1つでもログ出力されていない場合、期待ログとは見なされない。

具体例（２種類のログ出力を期待する場合）:

`LIST_MAP=expectedLogMessages`

| logLevel | message1 | message2 | message3 |
|---|---|---|---|
| INFO | NB11AA0101 | 処理を開始します。 | 会員ID=[0001] |
| FATAL | NB11AA0109 | エラーが発生しました。 | |

messageカラムは空でも可（FATALの例ではmessage3が空）。

> **重要**: `expectedLog` 欄にグループIDを記載した場合、必ず期待するメッセージを1行以上設定すること。メッセージが0行の場合、またはグループIDに紐付くLIST_MAP要素が存在しない場合、フレームワークは例外を送出する。

<details>
<summary>keywords</summary>

expectedTable, expectedFile, expectedLog, EXPECTED_FIXED, EXPECTED_VARIABLE, ログ結果検証, ファイル結果検証, データベース結果検証, logLevel, messageN, LIST_MAP, expectedLogMessages

</details>
