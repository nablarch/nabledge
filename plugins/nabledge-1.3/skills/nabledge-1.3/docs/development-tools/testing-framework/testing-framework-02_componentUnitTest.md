# Componentのクラス単体テスト

## テストケース実行のパターン分け

テストケースは処理の種類によって以下の4パターンに分類される。パターンごとにテストクラスやデータの作成方法が異なる。

| パターン | 当てはまる処理の例 |
|---|---|
| 戻り値（DBの検索結果）を確認しなければならないもの | 検索処理 |
| 戻り値（DB検索結果以外）を確認しなければならないもの | 計算、判定処理 |
| 処理終了後のDBの状況を確認しなければならないもの | 更新（挿入、削除含む）処理 |
| メッセージIDを確認しなければならないもの | エラー処理 |

> **注意**: 「戻り値（DBの検索結果）を確認しなければならないもの」と「戻り値（DB検索結果以外）を確認しなければならないもの」の2パターンについては、ドキュメントに説明が未記載である。これらのパターンに関する実装手順は現時点では参照できない。

<details>
<summary>keywords</summary>

テストケース分類, DBの検索結果確認, DB更新後の確認, メッセージID確認, クラス単体テストパターン, エラー処理テスト

</details>

## テストデータとテストクラスの作成

テストクラス作成ルール: (1) テスト対象Componentと同一パッケージ (2) クラス名は `<Componentクラス名>Test` (3) `nablarch.test.core.db.DbAccessTestSupport` を継承

テストデータ（Excelファイル）はテストソースコードと同じディレクトリに同じ名前（拡張子のみ異なる）で格納する。全テストデータは同じExcelシートに記載する。

> **重要**: メッセージデータやコードマスタなどの、データベースに格納する静的マスタデータは、プロジェクトで管理されたデータがあらかじめ投入されている前提である。これらのデータを個別のテストデータとして作成しないこと。

```java
public class UserComponentTest extends DbAccessTestSupport {
```

<details>
<summary>keywords</summary>

DbAccessTestSupport, テストデータExcelファイル, テストクラス命名規則, Component単体テスト, テストクラス継承, nablarch.test.core.db.DbAccessTestSupport, 静的マスタデータ, メッセージデータ, コードマスタ

</details>

## 事前準備データの作成処理

事前準備処理の主要メソッド:

- `setThreadContextValues(sheetName, "threadContext")`: スレッドコンテキスト（USER_ID、REQUEST_ID等）の設定
- `setUpDb(sheetName)`: 事前データの投入。各テストケースごとに初期化するため、ループ内で呼び出す。

```java
setThreadContextValues(sheetName, "threadContext");
for (int i = 0; i < sysAcctDatas.size(); i++) {
    setUpDb(sheetName); // 各ケースごとに初期化するためループ中で実行
}
```

**採番テーブル（ID_GENERATE）の初期化について**: 挿入処理のテストでは、採番テーブル（ID_GENERATE）を必ず初期化データに含めること。登録時に採番処理が行われるため、採番テーブルを初期化しておかないとテスト実行時の採番結果がわからなくなり、挿入結果の検証ができなくなる。

![事前準備データのExcelシート構成](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/componentUnitTest_Setup.png)

<details>
<summary>keywords</summary>

setThreadContextValues, setUpDb, スレッドコンテキスト設定, 事前データ投入, テストDBセットアップ, ID_GENERATE, 採番テーブル, 採番初期化

</details>

## 処理終了後のデータベースの状況を確認

DB更新処理のクラス単体テストではフレームワークによるトランザクション制御が行われないため、テスト側でコミットが必要。

> **重要**: `commitTransactions()` を呼び出してコミットしないと、テスト結果の確認が正常に行われない。参照系テストではコミット不要。

入力データの読み込みには `getListMap(sheetName, "シートID")` を使用する（[../../06_TestFWGuide/03_Tips](testing-framework-03_Tips.md) の [how_to_get_data_from_excel](testing-framework-03_Tips.md) 参照）。

**配列型プロパティの間接参照パターン**: エンティティのプロパティが配列型の場合（例: `SystemAccountEntity` の `useCaseId` プロパティ）、Excelのテストデータ行には値そのものではなく、同シート内の別の表を指すキーIDを記載する。テストコードでは、そのキーIDを取得し、`getListMap` でさらにデータを取得して配列を作成し、コンストラクタに渡す。

```java
// システムアカウントエンティティの準備（useCaseIdは配列型プロパティ）
String id = sysAcctDatas.get(i).get("useCaseId"); // 別表を指すキーIDを取得
useCaseData = getListMap(sheetName, id);           // キーIDで配列データを取得
String[] useCaseId = new String[useCaseData.size()];
for (int j = 0; j < useCaseData.size(); j++) {
    useCaseId[j] = useCaseData.get(j).get("useCaseId");
}
work.put("useCase", useCaseId);
sysAcct = new SystemAccountEntity(work);

// ユーザエンティティの準備
work.clear();
for (Entry<String, String> e : usersDatas.get(i).entrySet()) {
    work.put(e.getKey(), e.getValue());
}
users = new UsersEntity(work);

// グループシステムアカウントエンティティの準備
work.clear();
for (Entry<String, String> e : grpSysAcctDatas.get(i).entrySet()) {
    work.put(e.getKey(), e.getValue());
}
grpSysAcct = new UgroupSystemAccountEntity(work);

// 実行とコミット
target.registerUser(sysAcct, users, grpSysAcct);
commitTransactions();

// 検証
String expectedGroupId = getListMap(sheetName, "expected").get(i).get("caseNo");
assertTableEquals(expectedGroupId, sheetName, expectedGroupId);
```

想定結果の検証には `assertTableEquals(groupId, sheetName, groupId)` を使用する。アプリケーション設定項目だけでなく自動設定項目（[insert_auto_setting_item](../../guide/web-application/web-application-07_insert.md) 参照）も想定結果に含めること。

グループIDで複数の想定結果を管理する（`caseNo` をグループIDとして `assertTableEquals` に渡す）。

![入力データのExcelシート構成](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/componentUnitTest_inputData.png)

![想定結果（正常系）のExcelシート構成](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/componentUnitTest_expectedDataNormal.png)

<details>
<summary>keywords</summary>

commitTransactions, assertTableEquals, getListMap, DB更新確認, トランザクションコミット, テスト結果検証, insert_auto_setting_item, SystemAccountEntity, UsersEntity, UgroupSystemAccountEntity, 配列プロパティ, 間接参照, useCaseId

</details>

## メッセージIDを確認しなければならないもの

メッセージID確認テストでは、目的の例外をキャッチしてメッセージIDを比較する。

**異常系データのID命名規則**: 同じExcelシート内に正常系と異常系のデータを混載する場合、異常系データのIDには正常系IDの末尾に `"Err"` を付加する命名規則を用いる（例: 正常系IDが `"registerUser"` なら異常系IDは `"registerUserErr"`）。

> **警告**: キャッチする例外は発生を想定する例外クラスを指定すること。`RuntimeException` などの上位クラスを使うと例外種別の誤りを検出できなくなる。

```java
try {
    target.registerUser(sysAcct, users, grpSysAcct);
    fail();
} catch (ApplicationException ae) {
    assertEquals(expected.get(i).get("messageId"), ae.getMessages().get(0).getMessageId());
}
```

![想定結果（異常系）のExcelシート構成](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/componentUnitTest_expectedDataAbnormal.png)

<details>
<summary>keywords</summary>

ApplicationException, メッセージID確認, 例外キャッチ, エラー処理テスト, getMessageId, getMessages, Errサフィックス, 異常系データID命名規則, 正常系異常系混載

</details>
