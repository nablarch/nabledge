# 取引単体テストの実施方法（バッチ）

## テストクラスの作成とテストケース分割方針

テストクラス作成ルール: (1) パッケージはテスト対象取引と同一 (2) クラス名は `<取引ID>Test` (3) `BatchRequestTestSupport` を継承

**クラス**: `nablarch.test.core.batch.BatchRequestTestSupport`

```java
package nablarch.sample.ss21AC01;
import nablarch.test.core.batch.BatchRequestTestSupport;
public class B21AC01Test extends BatchRequestTestSupport {
```

テストケース分割方針: 原則1シート1テストケース。

| ケース | 対応方法 |
|---|---|
| テストデータが大量または処理が多い | 1ケースを複数シートに分割可 |
| 非常に簡単でデータ量が少ない | 1シートに複数ケースを含めてもよい |

<details>
<summary>keywords</summary>

BatchRequestTestSupport, 取引単体テスト, テストクラス作成, テストケース分割方針, 取引ID, バッチテスト

</details>

## 基本的な記述方法

1テストケース1シート。1シート内に複数のバッチ実行を記述して取引単位テストを実施。

```java
@Test
public void testSuccess() {
    execute();
}
```

testSuccessシート (LIST_MAP=testShots):

| no | description | expectedStatusCode | setUpTable | setUpFile | expectedTable | expectedFile | requestPath |
|---|---|---|---|---|---|---|---|
| 1 | ファイル入力 | 100 | default | default | default | | fileInputBatch |
| 2 | ユーザ削除 | 100 | default | | default | | userDeleteBatch |
| 3 | ファイル出力 | 100 | default | | fileInputBatch | default | fileOutputBatch |

<details>
<summary>keywords</summary>

execute, testShots, LIST_MAP, 基本的な記述方法, requestPath, expectedStatusCode, 取引単位テスト, setUpTable, setUpFile, expectedTable, expectedFile

</details>

## 1テストケースを複数シートに分割する場合

`execute("シート名")` でシートを指定し、1テストケースを複数シートに分割できる。

```java
@Test
public void testSuccess() {
    execute("testSuccess_fileInput");
    execute("testSuccess_userDelete");
    execute("testSuccess_fileOutput");
}
```

各シートの列構成例:

testSuccess_fileInputシート (LIST_MAP=testShots):

| no | case | expectedStatusCode | setUpTable | setUpFile | requestPath |
|---|---|---|---|---|---|
| 1 | ファイル入力 | 100 | default | default | fileInputBatch |

testSuccess_userDeleteシート (LIST_MAP=testShots):

| no | case | expectedStatusCode | setUpTable | expectedTable | requestPath |
|---|---|---|---|---|---|
| 1 | ユーザ削除 | 100 | default | default | userDeleteBatch |

testSuccess_fileOutputシート (LIST_MAP=testShots):

| no | case | expectedStatusCode | setUpTable | outFile | requestPath |
|---|---|---|---|---|---|
| 1 | ファイル出力 | 100 | default | default | fileOutputBatch |

<details>
<summary>keywords</summary>

execute シート名指定, 複数シート分割, testSuccess_fileInput, testSuccess_userDelete, testSuccess_fileOutput, outFile

</details>

## 1シートに複数ケースを含める場合

グループIDを使い1シートに複数ケースを記述できる (no列に `1-1`, `1-2`, `2-1` 形式)。

```java
@Test
public void testSuccess() {
    execute();
}
```

testSuccessシート (LIST_MAP=testShots):

| no | description | expectedStatusCode | setUpTable | setUpFile | expectedTable | expectedFile | requestPath |
|---|---|---|---|---|---|---|---|
| 1-1 | ファイル入力 | 100 | shot1 | shot1 | | | fileInputBatch |
| 1-2 | ユーザ削除 | 100 | | | shot1 | | userDeleteBatch |
| 2-1 | ファイル入力（0件） | 100 | shot2 | shot2 | | | fileInputBatch |
| 2-2 | ユーザ削除（0件） | 100 | | | shot2 | | userDeleteBatch |

> **注意**: グループIDを利用することで1シートに複数ケースのテストデータを記述できる。詳細は :ref:`tips_groupId` を参照。

<details>
<summary>keywords</summary>

グループID, tips_groupId, 複数ケース1シート, グループIDを使った複数ケース, no列グループ, expectedFile

</details>
