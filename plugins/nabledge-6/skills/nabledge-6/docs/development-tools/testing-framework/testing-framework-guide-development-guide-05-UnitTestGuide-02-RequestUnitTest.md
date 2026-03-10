# リクエスト単体テストの実施方法

## （導入部）

なし

## テストクラスの書き方

テストクラス作成ルール: (1) テスト対象Actionと同一パッケージ (2) クラス名は`{Actionクラス名}RequestTest` (3) `nablarch.test.core.http.BasicHttpRequestTestTemplate`を継承（プロジェクト側の拡張Template実装がある場合はその限りではない）

> **補足**: `BasicHttpRequestTestTemplate`はリクエスト単体テストの各種メソッドを提供し、`DbAccessTestSupport`の機能も兼ね備える。データベース設定などはクラス単体テストと同じように実行できる。

## （区切り）

なし

## テストメソッド分割

テストメソッド分割ルール:
1. リクエストID毎（Actionのメソッド毎）に正常系・異常系テストメソッドを作成
2. 異常系がない場合（メニューからの単純な画面遷移など）は正常系のみ作成
3. 画面表示検証は正常系または異常系テストメソッドに含める
4. 同一シートでの条件分岐が煩雑になる場合は画面表示検証用テストメソッドを別途作成
5. 1つのテストデータシートに多くのテストケースを詰め込み可読性が下がる場合はシートを分割する

**メソッド分割例（正常系・異常系・画面表示検証用で分割した場合）**:

| リクエストID | Actionメソッド名 | 正常系シート名 | 異常系シート名 | 画面表示検証用シート名 |
|---|---|---|---|---|
| USERS00101 | doUsers00101 | testUsers00101Normal | testUsers00101Abnormal | testUsers00101View |

## （区切り）

なし

## テストデータの書き方

テストデータはテストソースコードと同一ディレクトリに同名（拡張子のみ異なる）のExcelファイルで管理する。詳細は:ref:`how_to_write_excel`参照。

## テストクラスで共通のデータベース初期値

Excelファイルに**setUpDb**という名前のシートを用意し、共通のデータベース初期値を記載する。自動テストフレームワークによりテストメソッド実行時に投入される。

![setUpDbシート例](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/setupdb.png)

## テストケース一覧

LIST_MAPデータタイプ、ID=**testShots**で1テストメソッド分のケース表を記載する。

![testShotsシート例](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/testShots.png)

| カラム名 | 必須 | 説明 |
|---|---|---|
| no | ○ | テストケース番号（1からの連番） |
| description | ○ | テストケース説明。HTMLダンプファイル名に使用されるため、(1) OSで規定されたファイル名に使用不可の文字の使用、または (2) OSで規定されるファイル名長の上限超過の場合にIOExceptionが発生する。ファイル名として許可された内容のみ使用可（例：改行コードを含めると実行時にエラーが発生する） |
| context | ○ | リクエスト送信時のユーザ情報。:ref:`request_test_user_info`参照 |
| cookie | | Cookie情報。:ref:`request_test_cookie_info`参照 |
| queryParams | | クエリパラメータ情報。:ref:`request_test_queryparams_info`参照 |
| isValidToken | | トークンを設定する場合はtrue。:ref:`サーバ側の二重サブミット防止 <tag-double_submission_server_side>`参照 |
| setUpTable | | テストケース実行前に投入するデータの:ref:`グループID<tips_groupId>` |
| expectedStatusCode | ○ | 期待するHTTPステータスコード |
| expectedMessageId | | 期待するメッセージID（複数はカンマ区切り）。空欄にした場合、実際にメッセージが出力されるとテスト失敗 |
| expectedSearch | | 期待する検索結果のLIST_MAPデータタイプのID。リクエストスコープのキーは**searchResult** |
| expectedTable | | 期待するDBテーブルの:ref:`グループID<tips_groupId>` |
| forwardUri | | 期待するフォワード先URI。空欄の場合はJSPフォワードなしとしてアサート。システムエラー画面のデフォルトは`/jsp/systemError.jsp` |
| expectedContentLength | | コンテンツレングスヘッダ期待値（ファイルダウンロードテスト用） |
| expectedContentType | | コンテンツタイプヘッダ期待値（ファイルダウンロードテスト用） |
| expectedContentFileName | | コンテンツディスポジションヘッダのファイル名期待値（ファイルダウンロードテスト用） |
| expectedMessage | | メッセージ同期送信の期待要求電文の:ref:`グループID<tips_groupId>` |
| responseMessage | | メッセージ同期送信の返却応答電文の:ref:`グループID<tips_groupId>` |
| expectedMessageByClient | | HTTPメッセージ同期送信の期待要求電文の:ref:`グループID<tips_groupId>` |
| responseMessageByClient | | HTTPメッセージ同期送信の返却応答電文の:ref:`グループID<tips_groupId>` |

HTTPリクエストパラメータはこの表ではなく別の表（requestParams）に記載する。:ref:`request_test_req_params`参照。

## ユーザ情報

LIST_MAPデータタイプでリクエストID・ユーザ・HTTPメソッドを記載する。HTTPメソッドは任意項目で省略時はPOSTが設定される。複数のユーザ情報を使い分けることで、権限やHTTPメソッドで処理が異なる機能をテストできる。

![ユーザ情報（権限別）](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/testcase-user.png)

![ユーザ情報（HTTPメソッド別）](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/testcase-user2.png)

## Cookie情報

LIST_MAPデータタイプで記載する。任意項目のため不要なケースでは記載不要。Cookieが不要なケースは値を空白にする。

![Cookie情報例](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/requestCookie.png)

## クエリパラメータ情報

LIST_MAPデータタイプで記載する。任意項目のため不要なケースでは記載不要。クエリパラメータが不要なケースは値を空白にする。

![クエリパラメータ情報例](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/queryParams.png)

## リクエストパラメータ

各テストケースで送信するHTTPパラメータをLIST_MAPデータタイプ、ID=**requestParams**で記載する。

- :ref:`http_dump_tool`を使用してリクエストパラメータのデータを作成する（初期画面表示以外）
- テストケース一覧と行単位で対応付け（テストケース先頭行→requestParams先頭行の順）
- :ref:`marker_column`としてテストケース番号を記載する

> **重要**: リクエストパラメータが存在しない場合（初期画面表示など）でも、LIST_MAP=requestParamsの列定義は必須。テストケース数分のデータ行を定義する（[no]列のみの行でも可）。

![requestParamsとテストケース一覧の対応例](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/testcase_and_request.png)

![パラメータなしの場合（[no]列のみの例）](assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/dummy_request_param.png)

## ひとつのキーに対して複数の値を設定する場合

HTTPリクエストパラメータの1キーに複数値を設定する場合、**値をカンマ区切りで記述**する。

例: キー`foo`に`one`と`two`を設定 → セル値は`one,two`

エスケープルール:
- 値にカンマそのものを含める場合: `\`でエスケープ（`\,`）
- 値に`\`そのものを含める場合: `\\`とエスケープ

例: `\1,000`という値を表す場合 → セルに`\\1\,000`と記述する

## 各種期待値

検索結果・データベースの内容をテストケース一覧とIDで紐付けして比較する。

## 期待する検索結果

期待する検索結果をLIST_MAPデータタイプで記載し、テストケース一覧とIDでリンクさせる。

![期待する検索結果の設定例](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/expected_search_result.png)

## 期待するデータベースの状態

更新系のテストケースでは期待するデータベースの状態をテストケース一覧とリンクさせて確認する。

![期待するデータベース状態の設定例](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/expected_table.png)

## （末尾）

なし

## テストメソッドの書き方（スーパクラス）

**クラス**: `BasicHttpRequestTestTemplate`（継承必須）

**スーパクラスの実行フロー**: このクラスでは、準備したテストデータを元に以下の手順でリクエスト単体テストを実行する:

1. データシートからテストケースリスト（`testShots` LIST_MAP）を取得
2. 取得したテストケース分、以下を繰り返し実行:
   - データベース初期化
   - ExecutionContext、HTTPリクエストを生成
   - 業務テストコード用拡張ポイント呼出（`beforeExecuteRequest` メソッド）
   - トークンが必要な場合、トークンを設定
   - テスト対象のリクエスト実行
   - 実行結果の検証（HTTPステータスコードおよびメッセージID、HTTPレスポンス値（リクエストスコープ値）、検索結果、テーブル更新結果）
   - 業務テストコード用拡張ポイント呼出（`afterExecuteRequest` メソッド）

**必須オーバーライドメソッド**: `getBaseUri()` — URIの共通部分を返す

```java
public class UserSearchActionRequestTest extends BasicHttpRequestTestTemplate {
    @Override
    protected String getBaseUri() {
        return "/action/management/user/UserSearchAction/";
    }
}
```

## テストメソッド作成とスーパクラスメソッド呼び出し

**テストメソッドの作成**: 準備したテストシートに対応する `@Test` メソッドを作成する。

```java
@Test
public void testMenus00101() {
}
```

**スーパクラスメソッドの呼び出し**: テストメソッド内でスーパクラスの以下のいずれかを呼び出す:

- `void execute()` — 通常の場合に使用
- `void execute(Advice advice)` — シート固有の準備処理・結果確認処理が必要な場合に使用

```java
@Test
public void testUsers00101Normal() {
    execute();
}
```

固有の処理を挿し込む場合は `execute(Advice advice)` を使用する。詳細は「固有の処理を追加する場合」を参照。

## ダウンロードファイルのテスト

ダウンロードファイルをテストする場合は、:ref:`batch_request_test` と同じ方法でExcelファイルに期待値を記載する。`FileSupport#assertFile()` でアサートを行う。

**ダンプファイル命名規則**: `{Excelシート名}_{テストケース名}_{ダウンロードされたファイル名}`

ダウンロード処理の場合、ダウンロードされたファイルがダンプされる。ダンプ出力結果が格納されるディレクトリの詳細は :ref:`html_dump_dir` を参照。

```java
private FileSupport fileSupport = new FileSupport(getClass());

@Test
public void testRW11AC0104Download() {
    execute(new BasicAdvice() {
        @Override
        public void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
            String msgOnFail = "ダウンロードしたユーザ一覧照会結果のCSVファイルのアサートに失敗しました。";
            fileSupport.assertFile(msgOnFail, "testRW11AC0104Download");
        }
    });
}
```

## 固有の処理を追加する場合

`execute(Advice advice)` を使用してリクエスト送信前後に固有の処理を挿し込む。`BasicAdvice` の `beforeExecute`/`afterExecute` をオーバーライドする。

> **補足**: 両方のメソッドをオーバーライドする必要はない。必要なものだけオーバーライドすること。処理が長い場合やテストメソッド間で共通する処理はプライベートメソッドに切り出すこと。

```java
execute(new BasicAdvice() {
    @Override
    public void beforeExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
        // 準備処理
    }
    @Override
    public void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
        // 結果確認処理
    }
});
```

**TestCaseInfo から取得できる値**:
- `getTestCaseName()`: 比較失敗時のメッセージ
- `getSheetName()`: シート名
- `getTestCaseNo()`: テストケース番号
- `getHttpRequest()`: テスト実行後の HttpRequest

**リクエストスコープ値の検証API**:
- `assertSqlResultSetEquals(message, sheetName, expectedId, actual)`: SqlResultSet の検証
- `assertSqlRowEquals(message, sheetName, expectedId, actual)`: SqlRow（1件）の検証
- `assertEntity(sheetName, expectedId, actual)`: エンティティ/Formの検証。期待値の書式は :ref:`entityUnitTest_SetterGetterCase` と同様（setterの欄は不要）
- `assertListMapEquals(expected, actual)`: `List<Map<String, String>>` の検証

Excelからデータを取得する場合: `getListMap(sheetName, dataId)` で `List<Map<String, String>>` を取得。詳細: :ref:`how_to_get_data_from_excel`

FormにSqlResultSet/SqlRow以外が格納されている場合は `assertEntity()` を使用する。FormプロパティのFormを検証する場合は、そのFormを取得して `assertEntity()` で検証する。

リクエストパラメータを検証する場合（:ref:`tag-window_scope` の値リセット確認など）は `testCaseInfo.getHttpRequest()` でテスト後の HttpRequest を取得して検証する。

## テスト起動方法

通常のJUnitテストと同じように実行する（クラス単体テストと同様）。

## テスト結果確認（目視）

１リクエスト毎にHTMLダンプファイルが出力される。ファイルをブラウザで開いて目視確認する。

> **補足**: 自動テストフレームワークが [../../08_TestTools/03_HtmlCheckTool/index](testing-framework-guide-development-guide-08-TestTools-03-HtmlCheckTool.md) を用いてHTMLファイルを自動チェックする。HTMLファイル内に違反があった場合は違反内容に応じた例外が発生し、テストケースが失敗となる。

**HTMLダンプ出力先**: プロジェクトのルートディレクトリ配下の `tmp/html_dump/` ディレクトリ。詳細: :ref:`dump-dir-label`

**ダンプファイル名**: `testShots` の `description` 欄の記述が使用される。

![HTMLダンプ出力ディレクトリ](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest/htmlDumpDir.png)

## リクエスト単体テストクラス作成時の注意点

## ThreadContextへの値設定は不要

リクエスト単体テストではWeb Frameworkハンドラが作用するため、ThreadContextへの値設定はハンドラで実施される。テストクラスからThreadContextへの値を設定する必要はない。

ユーザID設定方法については :ref:`request_test_user_info` を参照。

## テストクラスでのトランザクション制御は不要

クラス単体テストでは、Web Frameworkのハンドラが作用しない為、テストクラス内で明示的にトランザクションコミットを行っていた。リクエスト単体テストではトランザクション制御はハンドラで行われるため、テストクラス内で明示的にトランザクションコミットを行う必要はない。
