# Action/Componentのクラス単体テスト

**公式ドキュメント**: [Action/Componentのクラス単体テスト](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/01_ClassUnitTest/02_componentUnitTest.html)

## Action/Componentのクラス単体テスト

Action単体テストとComponent単体テストの違いはテストクラス名のみ。

サンプルファイル:
- [テストケース一覧(ユーザ登録_ UserComponent_クラス単体テストケース.xlsx)](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/ユーザ登録_UserComponent_クラス単体テストケース.xlsx)
- [テストクラス(UserComponentTest.java)](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/UserComponentTest.java)
- [テストデータ(UserComponentTest.xlsx)](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/UserComponentTest.xlsx)
- [テスト対象クラス(UserComponent.java)](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/UserComponent.java)

<details>
<summary>keywords</summary>

Action単体テスト, Component単体テスト, クラス単体テスト, テストクラス名, UserComponentTest

</details>

## Action/Component単体テストの書き方

テストケースは以下の4パターンに分類する。パターンに応じてテストクラスとデータの作成方法が異なる。

| パターン | 当てはまる処理の例 |
|---|---|
| 戻り値(データベースの検索結果)を確認しなければならないもの | 検索処理 |
| 戻り値(データベースの検索結果以外)を確認しなければならないもの | 計算、判定処理 |
| 処理終了後のデータベースの状況を確認しなければならないもの | 更新(挿入、削除含む)処理 |
| メッセージIDを確認しなければならないもの | エラー処理 |

<details>
<summary>keywords</summary>

テストケースパターン分類, 検索処理, 更新処理, エラー処理テスト, テストケース分類

</details>

## テストデータの作成

- テストデータ(Excelファイル)はテストソースコードと同じディレクトリに同じファイル名で格納する(拡張子のみ異なる)。
- 全テストデータは同じExcelシートに記載する。
- メッセージデータ・コードマスタ等のDBに格納する静的マスタデータはプロジェクト管理データが事前投入済みの前提であり、個別テストデータとして作成しない。

詳細: [../../06_TestFWGuide/01_Abstract](testing-framework-01_Abstract.md), [../../06_TestFWGuide/02_DbAccessTest](testing-framework-02_DbAccessTest.md)

<details>
<summary>keywords</summary>

テストデータ, Excelファイル配置, 静的マスタデータ, テストシート

</details>

## テストクラスの作成

Component単体テストクラスの作成ルール:
1. パッケージはテスト対象Action/Componentと同じ
2. クラス名は`<Action/Componentクラス名>Test`
3. `nablarch.test.core.db.DbAccessTestSupport`を継承する

```java
package nablarch.sample.management.user;

import nablarch.test.core.db.DbAccessTestSupport;
import org.junit.Test;

public class UserComponentTest extends DbAccessTestSupport {
}
```

詳細: [../../06_TestFWGuide/02_DbAccessTest](testing-framework-02_DbAccessTest.md)

<details>
<summary>keywords</summary>

DbAccessTestSupport, UserComponentTest, テストクラス作成ルール, パッケージ設定

</details>

## 事前準備データの作成処理

事前準備データの例(UserComponent#registerUser):

- **スレッドコンテキスト**[^1]: USER_ID(USERID0001)、REQUEST_ID(USERS00301)
- **テーブル初期化**: SYSTEM_ACCOUNT(3件)、USERS(0件)、UGROUP_SYSTEM_ACCOUNT(0件)、SYSTEM_ACCOUNT_AUTHORITY(0件)
- **マスタデータ投入**: ID_GENERATE(採番テーブル) — 採番結果を確定させるため初期化が必須(未初期化だと挿入結果の検証不可)

[^1]: スレッドコンテキストとは、ユーザID、リクエストID、使用言語のような、一連の処理を実行するときに、コールスタックの複数のメソッドにおいて共通的に必要なデータを格納するオブジェクト。

```java
setThreadContextValues(sheetName, "threadContext"); // スレッドコンテキストの設定
// ...各テストケースのループ内で実行:
setUpDb(sheetName); // 事前データ投入(ループ中で実行し各ケースごとに初期化)
```

![事前準備データ](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/componentUnitTest_Setup.png)

<details>
<summary>keywords</summary>

setThreadContextValues, setUpDb, スレッドコンテキスト, 事前データ投入, ID_GENERATE

</details>

## 処理終了後のデータベースの状況を確認しなければならないもの

テストデータ(入力値)は複数エンティティリストをExcelから読み込む。同一行インデックスのデータが1テストケース分。

配列プロパティ(例: SystemAccountEntityのuseCaseId)の準備手順:
1. エンティティのuseCaseIdフィールドから参照IDを取得
2. その参照IDをキーに別表データを取得
3. 配列を作成してエンティティプロパティに設定

```java
List<Map<String, String>> sysAcctDatas = getListMap(sheetName, "sysAcctEntity");
// ループ内:
String id = sysAcctDatas.get(i).get("useCaseId");   // 参照IDを取得
useCaseData = getListMap(sheetName, id);              // 別表データを取得
String[] useCaseId = new String[useCaseData.size()];
for (int j = 0; j < useCaseData.size(); j++) {
    useCaseId[j] = useCaseData.get(j).get("useCaseId");
}
work.put("useCase", useCaseId);
sysAcct = new SystemAccountEntity(work);

// UsersEntity、UgroupSystemAccountEntityも同様に準備
users = new UsersEntity(work);
grpSysAcct = new UgroupSystemAccountEntity(work);

target.registerUser(sysAcct, users, grpSysAcct);
commitTransactions();  // 全トランザクションをコミット
```

> **重要**: クラス単体テストではフレームワークのトランザクション制御が行われない。処理終了後のDB状態を確認する場合は`commitTransactions()`を呼び出してコミットする。コミットしない場合、テスト結果の確認が正常に行われない(参照系テストはコミット不要)。

想定結果にはアプリケーション設定項目だけでなく自動設定項目([database-common_bean](../../component/libraries/libraries-database.md))も含める。検証は`assertTableEquals`メソッドを使用する。

複数の想定結果への対応はグループID(:ref:`tips_groupId`)を用いる:

```java
String expectedGroupId = getListMap(sheetName, "expected").get(i).get("caseNo");
assertTableEquals(expectedGroupId, sheetName, expectedGroupId);
```

case1の想定結果例(registerUser実行後のDB状態):

| テーブル名 | 想定 |
|---|---|
| SYSTEM_ACCOUNT | 初期3件+1レコード追加。計4レコード。 |
| USERS | 1レコード追加。(0件に初期化し、テスト対象処理で1レコード追加) |
| UGROUP_SYSTEM_ACCOUNT | 1レコード追加。(0件に初期化し、テスト対象処理で1レコード追加) |
| SYSTEM_ACCOUNT_AUTHORITY | 変化なし(新規追加なし)。 |

![入力データ例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/componentUnitTest_inputData.png)
![想定結果データ例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/componentUnitTest_expectedDataNormal.png)

<details>
<summary>keywords</summary>

commitTransactions, assertTableEquals, トランザクションコミット, DB状態検証, getListMap, database-common_bean, SystemAccountEntity, UsersEntity, UgroupSystemAccountEntity

</details>

## メッセージIDを確認しなければならないもの

異常系テストデータは正常系と同じExcelシートに混載する。異常系データのIDは正常系IDの末尾に`Err`を付加する。

ここで確認すべき内容は、ユニークキー制約違反による例外の発生である。テストコードでは、目的の例外をキャッチし、メッセージIDを比較することで検証する。

> **重要**: キャッチする例外は発生を想定する具体的な例外クラスとし、`RuntimeException`などの上位クラスは使用しないこと。上位クラスでキャッチするとメッセージIDが正しくても例外クラスが違うバグを検出できなくなる。

```java
try {
    target.registerUser(sysAcct, users, grpSysAcct);
    fail();  // 例外が発生しなかったらテスト失敗
} catch (ApplicationException ae) {  // 発生するはずの具体的な例外をキャッチ
    assertEquals(expected.get(i).get("messageId"), ae.getMessages().get(0).getMessageId());
}
```

![異常系想定結果データ例](../../../knowledge/development-tools/testing-framework/assets/testing-framework-02_componentUnitTest/componentUnitTest_expectedDataAbnormal.png)

<details>
<summary>keywords</summary>

ApplicationException, メッセージID, 異常系テスト, 例外クラス指定, getMessageId

</details>
