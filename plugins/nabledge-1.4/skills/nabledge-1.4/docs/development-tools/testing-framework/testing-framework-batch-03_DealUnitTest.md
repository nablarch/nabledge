# 取引単体テストの実施方法（バッチ）

## テストケース分割方針と基本的な記述方法

テストクラス作成ルール: (1) テスト対象取引と同一パッケージ (2) クラス名は`{取引ID}Test` (3) `BatchRequestTestSupport`を継承。

import文: 基本的な1シートテストでは`nablarch.test.core.batch.BatchRequestTestSupport`を使用し、複数シート分割テストでは`nablarch.test.core.messaging.BatchRequestTestSupport`を使用する:

```java
// 基本的な記述方法（1シート）
import nablarch.test.core.batch.BatchRequestTestSupport;

// 複数シート分割の場合
import nablarch.test.core.messaging.BatchRequestTestSupport;
```

テストケース分割方針: 基本は1シート=1テストケース。1シートに複数バッチ実行を記述することで取引単位テストとなる。

## 基本的な記述方法

引数なしの`execute()`でカレントシートの全バッチ行を実行する:

```java
@Test
public void testSuccess() {
    execute();
}
```

testSuccessシートのLIST_MAP=testShotsに複数バッチを列挙:

| no | description | expectedStatusCode | setUpTable | setUpFile | expectedTable | expectedFile | requestPath |
|---|---|---|---|---|---|---|---|
| 1 | ファイル入力 | 100 | default | default | default | | fileInputBatch |
| 2 | ユーザ削除 | 100 | default | | default | | userDeleteBatch |
| 3 | ファイル出力 | 100 | default | | fileInputBatch | default | fileOutputBatch |

## 1テストケースを複数シートに分割する場合

テストデータが大量または1取引に含まれる処理が多い場合は、1ケースを複数シートに分割して記述可能。`execute("シート名")`で特定シートを指定して実行する:

```java
@Test
public void testSuccess() {
    execute("testSuccess_fileInput");
    execute("testSuccess_userDelete");
    execute("testSuccess_fileOutput");
}
```

各シートに LIST_MAP=testShots を定義。使用可能な列: `no`, `description`/`case`, `expectedStatusCode`, `setUpTable`, `setUpFile`, `expectedTable`, `expectedFile`/`outFile`, `requestPath`

<details>
<summary>keywords</summary>

BatchRequestTestSupport, nablarch.test.core.batch.BatchRequestTestSupport, nablarch.test.core.messaging.BatchRequestTestSupport, execute, 取引単体テスト, テストケース分割, 複数シート分割, LIST_MAP, requestPath, バッチリクエストテスト, testShots

</details>

## 非常に簡単なテストケースの場合

テストデータ量が少なく非常に簡単なテストケースの場合は、1シートに全テストケースをまとめて記述可能。

`no`列のプレフィックスでケースをグループ化（例: `1-1`, `1-2`が1つ目のケース、`2-1`, `2-2`が2つ目のケース）:

| no | description | expectedStatusCode | setUpTable | setUpFile | expectedTable | expectedFile | requestPath |
|---|---|---|---|---|---|---|---|
| 1-1 | ファイル入力 | 100 | shot1 | shot1 | | | fileInputBatch |
| 1-2 | ユーザ削除 | 100 | | | shot1 | | userDeleteBatch |
| 2-1 | ファイル入力（0件） | 100 | shot2 | shot2 | | | fileInputBatch |
| 2-2 | ユーザ削除（0件） | 100 | | | shot2 | | userDeleteBatch |

> **注意**: グループIDを利用することで1シートに複数ケースのテストデータを記述できる。詳細は:ref:`tips_groupId`を参照。

<details>
<summary>keywords</summary>

グループID, 複数テストケース, 1シート複数ケース, テストケース集約, tips_groupId, no列プレフィックス

</details>
