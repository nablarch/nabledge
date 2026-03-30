# 取引単体テストの実施方法（バッチ）

## テストクラスの作成とテストケース分割方針

取引単体テストはリクエスト単体テストを連続実行することで取引単位のテストを行う。

**テストクラス作成ルール**:
- パッケージ: テスト対象取引と同一パッケージ
- クラス名: `<取引ID>Test`（例: 取引ID=B21AC01 → `B21AC01Test`）
- `BatchRequestTestSupport`を継承

```java
package nablarch.sample.ss21AC01;
import nablarch.test.core.batch.BatchRequestTestSupport;
public class B21AC01Test extends BatchRequestTestSupport {
```

**テストケース分割方針**: 基本は1シートにつき1テストケース。

- 複雑なテストケース（テストデータが大量 or 1取引に含まれる処理が多い）: 1ケースを複数シートに分割してもよい
- 非常に簡単なテストケース（テストデータ量が少ない）: 1シートに全テストケースをまとめてもよい

<details>
<summary>keywords</summary>

BatchRequestTestSupport, 取引単体テスト, テストクラス作成, テストケース分割方針, バッチテスト, 取引ID

</details>

## 基本的な記述方法

1テストケースを1シートにまとめ、1シート内に複数のバッチ実行を記述することで取引単位のテストとなる。

```java
@Test
public void testSuccess() {
    execute();
}
```

**【testSuccessシート】** `LIST_MAP=testShots`

| no | description | expectedStatusCode | setUpTable | setUpFile | expectedTable | expectedFile | requestPath |
|---|---|---|---|---|---|---|---|
| 1 | ファイル入力 | 100 | default | default | default | | fileInputBatch |
| 2 | ユーザ削除 | 100 | default | | default | | userDeleteBatch |
| 3 | ファイル出力 | 100 | default | | fileInputBatch | default | fileOutputBatch |

<details>
<summary>keywords</summary>

execute, testShots, LIST_MAP, requestPath, expectedStatusCode, setUpTable, setUpFile, expectedTable, expectedFile, 基本的な記述方法, バッチ取引テスト

</details>

## 1テストケースを複数シートに分割する場合

`execute("シート名")` でシートを指定して個別に実行する。

```java
@Test
public void testSuccess() {
    execute("testSuccess_fileInput");   // 入力ファイルをテンポラリテーブルに登録
    execute("testSuccess_userDelete");  // テンポラリテーブルの情報をユーザ関連テーブルを削除
    execute("testSuccess_fileOutput");  // 結果をファイル出力
}
```

各シートは独立して `LIST_MAP=testShots` を定義する。

**【testSuccess_fileInputシート】**

| no | case | expectedStatusCode | setUpTable | setUpFile | requestPath |
|---|---|---|---|---|---|
| 1 | ファイル入力 | 100 | default | default | fileInputBatch |

**【testSuccess_userDeleteシート】**

| no | case | expectedStatusCode | setUpTable | expectedTable | requestPath |
|---|---|---|---|---|---|
| 1 | ユーザ削除 | 100 | default | default | userDeleteBatch |

**【testSuccess_fileOutputシート】**

| no | case | expectedStatusCode | setUpTable | outFile | requestPath |
|---|---|---|---|---|---|
| 1 | ファイル出力 | 100 | default | default | fileOutputBatch |

<details>
<summary>keywords</summary>

execute(シート名), 複数シート分割, testSuccess_fileInput, testSuccess_userDelete, testSuccess_fileOutput, 取引テスト分割, LIST_MAP

</details>

## 1シートに複数ケースを含める場合

グループIDを利用することで1シートに複数ケースのテストデータを記述できる。`no`列に`1-1`、`1-2`のようにグループ番号を付与する。

```java
@Test
public void testSuccess() {
    execute();
}
```

**【testSuccessシート】** `LIST_MAP=testShots`

| no | description | expectedStatusCode | setUpTable | setUpFile | expectedTable | expectedFile | requestPath |
|---|---|---|---|---|---|---|---|
| 1-1 | ファイル入力 | 100 | shot1 | shot1 | | | fileInputBatch |
| 1-2 | ユーザ削除 | 100 | | | shot1 | | userDeleteBatch |
| 2-1 | ファイル入力（0件） | 100 | shot2 | shot2 | | | fileInputBatch |
| 2-2 | ユーザ削除（0件） | 100 | | | shot2 | | userDeleteBatch |

> **注意**: グループIDの詳細は :ref:`tips_groupId` を参照。

<details>
<summary>keywords</summary>

グループID, 複数ケース, tips_groupId, 1シート複数ケース, no列グループ番号

</details>
