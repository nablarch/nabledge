# 取引単体テストの実施方法（バッチ）

**公式ドキュメント**: [取引単体テストの実施方法（バッチ）](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/batch.html)

## テストクラスの作成要件

バッチ取引単体テストのテストクラスは以下の条件を満たすように作成する。

- テストクラスのパッケージはテスト対象取引のパッケージとする。
- `<取引ID>Test` というクラス名でテストクラスを作成する。
- `BatchRequestTestSupport` を継承する。

例：取引IDが `B21AC01` の場合、テストクラスは以下のようになる。

```java
package nablarch.sample.ss21AC01;

import nablarch.test.core.batch.BatchRequestTestSupport;

public class B21AC01Test extends BatchRequestTestSupport {
    // ...
}
```

<details>
<summary>keywords</summary>

バッチ取引単体テスト, テストクラス作成, BatchRequestTestSupport, 取引IDTest, パッケージ設定

</details>

## 基本的な記述方法

基本的には、1テストケースを1シートにまとめて記述する。1シート内に複数のバッチ実行を記述することにより、取引単位のテストとなる。テストメソッドでは引数なしの `execute()` を呼び出す。

```java
@Test
public void testSuccess() {
    execute();
}
```

シート（testSuccessシート）の `LIST_MAP=testShots` テーブルのカラム構成：

| カラム名 | 説明 |
|---|---|
| no | 実行順序番号 |
| description | テストケースの説明 |
| expectedStatusCode | 期待するステータスコード |
| setUpTable | セットアップするテーブル名 |
| setUpFile | セットアップするファイル名 |
| expectedTable | 検証するテーブル名 |
| expectedFile | 検証するファイル名 |
| requestPath | 実行するバッチのリクエストパス |

例（3バッチで構成される取引）：

| no | description | expectedStatusCode | setUpTable | setUpFile | expectedTable | expectedFile | requestPath |
|---|---|---|---|---|---|---|---|
| 1 | ファイル入力 | 100 | default | default | default | | fileInputBatch |
| 2 | ユーザ削除 | 100 | default | | default | | userDeleteBatch |
| 3 | ファイル出力 | 100 | default | | fileInputBatch | default | fileOutputBatch |

<details>
<summary>keywords</summary>

バッチ取引単体テスト, execute, testShots, 1シート1テストケース, BatchRequestTestSupport, requestPath, expectedStatusCode

</details>

## 1テストケースを複数シートに分割する場合

1テストケースを複数シートに分割する場合は、`execute("シート名")` のようにシート名を引数に指定して呼び出す。

```java
@Test
public void testSuccess() {
    // 入力ファイルをテンポラリテーブルに登録
    execute("testSuccess_fileInput");
    // テンポラリテーブルの情報をユーザ関連テーブルを削除
    execute("testSuccess_userDelete");
    // 結果をファイル出力
    execute("testSuccess_fileOutput");
}
```

各シートはそれぞれ独立した `LIST_MAP=testShots` テーブルを持つ。

- `testSuccess_fileInput` シート：`no, case, expectedStatusCode, setUpTable, setUpFile, requestPath` 列
- `testSuccess_userDelete` シート：`no, case, expectedStatusCode, setUpTable, expectedTable, requestPath` 列
- `testSuccess_fileOutput` シート：`no, case, expectedStatusCode, setUpTable, outFile, requestPath` 列

<details>
<summary>keywords</summary>

バッチ取引単体テスト, 複数シート分割, execute シート名, BatchRequestTestSupport, テストケース分割

</details>

## 1シートに複数ケースを含める場合

非常に簡単なテストケースの場合は、1シートに複数のテストケースをまとめて記述できる。`no` 列にグループIDを使用することで、複数ケースのテストデータを1シートに記述する。グループIDは `グループ番号-連番`（例：`1-1`, `1-2`, `2-1`, `2-2`）の形式で指定する。

```java
@Test
public void testSuccess() {
    execute();
}
```

例（2テストケースを1シートで記述する場合）：

| no | description | expectedStatusCode | setUpTable | setUpFile | expectedTable | expectedFile | requestPath |
|---|---|---|---|---|---|---|---|
| 1-1 | ファイル入力 | 100 | shot1 | shot1 | | | fileInputBatch |
| 1-2 | ユーザ削除 | 100 | | | shot1 | | userDeleteBatch |
| 2-1 | ファイル入力（0件） | 100 | shot2 | shot2 | | | fileInputBatch |
| 2-2 | ユーザ削除（0件） | 100 | | | shot2 | | userDeleteBatch |

グループIDの詳細は `tips_groupId` を参照。

<details>
<summary>keywords</summary>

バッチ取引単体テスト, グループID, 1シート複数ケース, testShots, tips_groupId

</details>

## テストケース分割方針 - 複雑なテストケースの場合

1シートにつき1テストケースが基本方針。テストデータが大量、または1取引に含まれる処理が多く、1シートに全データを詰め込むとデータが多くなりすぎて可読性が落ちる場合は、1ケースを複数シートに分割して記述してよい。

<details>
<summary>keywords</summary>

バッチ取引単体テスト, テストケース分割, 複数シート分割, テストデータ可読性, シート分割方針

</details>

## テストケース分割方針 - 非常に簡単なテストケースの場合

1シートにつき1テストケースが基本方針。非常に簡単なテストケースでテストデータ量が少ない場合、1シートに全テストケースをまとめて記述してよい。

<details>
<summary>keywords</summary>

バッチ取引単体テスト, 1シート複数テストケース, テストケース統合, シート分割方針

</details>
