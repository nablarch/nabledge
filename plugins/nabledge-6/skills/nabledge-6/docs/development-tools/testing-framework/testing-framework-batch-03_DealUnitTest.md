# 取引単体テストの実施方法（バッチ）

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/batch.html) [2](https://github.com/nablarch/nablarch-testing/blob/main/src/main/java/nablarch/test/core/file/BasicDataTypeMapping.java) [3](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/batch.html)

## テストクラスの作成要件

バッチ処理の取引単体テストは、自動テストフレームワークを使用してリクエスト単体テストを連続実行することにより、取引単位でのテストを行う。

テストクラスは以下の条件を満たすように作成する。

- テストクラスのパッケージはテスト対象取引のパッケージとする。
- `<取引ID>Test` というクラス名でテストクラスを作成する。
- `BatchRequestTestSupport` を継承する。

例: テスト対象取引の取引IDが `B21AC01` の場合

```java
package nablarch.sample.ss21AC01

import nablarch.test.core.batch.BatchRequestTestSupport;

public class B21AC01Test extends BatchRequestTestSupport {
```

<details>
<summary>keywords</summary>

BatchRequestTestSupport, 取引単体テスト, テストクラス命名規則, 取引ID, バッチ取引テスト

</details>

## テストケース分割方針

基本的には、**1シートにつき1テストケース**とする。以下、例外事項を示す。

**複雑なテストケースの場合**: テストデータが大量であったり、1取引に含まれる処理が多い場合に、1つのシートに全てのテストデータを詰め込むとシート内にデータが多くなり過ぎて、テストデータの可読性が落ちる場合がある。このような場合は、1ケースを複数シートに分割して記述してもよい。

**非常に簡単なテストケースの場合**: 非常に簡単なテストケースで、テストデータ量が少ない場合、1シートに全テストケースを含めてもよい。

<details>
<summary>keywords</summary>

1シート1テストケース, テストケース分割, 複雑なテストケース, シンプルテストケース

</details>

## 基本的な記述方法

基本的には、1テストケースを1シートにまとめて記述する。1シート内に複数のバッチ実行を記述することにより、取引単位のテストとなる。

以下の例では、3つのバッチ（ファイル入力バッチ、ユーザ削除バッチ、ファイル出力バッチ）で構成される取引を処理している。

```java
/** 正常終了するケース */
@Test
public void testSuccess() {
    execute();
}
```

**【testSuccessシート】**

`LIST_MAP=testShots` で以下の列を定義する。

| no | description | expectedStatusCode | setUpTable | setUpFile | expectedTable | expectedFile | requestPath |
|----|-------------|-------------------|------------|-----------|---------------|--------------|-------------|
| 1 | ファイル入力 | 100 | default | default | default | | fileInputBatch |
| 2 | ユーザ削除 | 100 | default | | default | | userDeleteBatch |
| 3 | ファイル出力 | 100 | default | | fileInputBatch | default | fileOutputBatch |

<details>
<summary>keywords</summary>

execute(), testShots, expectedStatusCode, requestPath, setUpTable, setUpFile, expectedTable, expectedFile, LIST_MAP

</details>

## 1テストケースを複数シートに分割する場合

1テストケースを複数シートに分割する場合、`execute("シート名")` でシート名を指定して実行する。

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

各シートは独立した `LIST_MAP=testShots` テーブルを持つ。例:

**【testSuccess_fileInputシート】**: no, case, expectedStatusCode, setUpTable, setUpFile, requestPath

**【testSuccess_userDeleteシート】**: no, case, expectedStatusCode, setUpTable, expectedTable, requestPath

**【testSuccess_fileOutputシート】**: no, case, expectedStatusCode, setUpTable, outFile, requestPath

<details>
<summary>keywords</summary>

execute(シート名), シート分割, testSuccess_fileInput, testSuccess_userDelete, testSuccess_fileOutput

</details>

## 1シートに複数ケースを含める場合

非常に簡単なテストケースの場合は、複数ケースを1シートにまとめてもよい。グループIDを使用することで1シートに複数ケースのテストデータを記述できる。

```java
/** 正常終了するケース */
@Test
public void testSuccess() {
    execute();
}
```

**【testSuccessシート】** — noの形式は「グループID-連番」(例: 1-1, 1-2, 2-1, 2-2)

| no | description | expectedStatusCode | setUpTable | setUpFile | expectedTable | expectedFile | requestPath |
|-----|-------------|-------------------|------------|-----------|---------------|--------------|-------------|
| 1-1 | ファイル入力 | 100 | shot1 | shot1 | | | fileInputBatch |
| 1-2 | ユーザ削除 | 100 | | | shot1 | | userDeleteBatch |
| 2-1 | ファイル入力（0件） | 100 | shot2 | shot2 | | | fileInputBatch |
| 2-2 | ユーザ削除（0件） | 100 | | | shot2 | | userDeleteBatch |

グループIDの詳細は `tips_groupId` を参照。

<details>
<summary>keywords</summary>

グループID, 1シート複数ケース, tips_groupId, グループID連番, 1-1 1-2 2-1 2-2

</details>
