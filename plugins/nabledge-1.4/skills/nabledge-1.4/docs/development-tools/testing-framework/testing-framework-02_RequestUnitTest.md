# リクエスト単体テスト

## 固有の処理を追加する場合

`execute(String sheetName, Advice advice)` でリクエスト送信前後に固有処理を挿入できる。`BasicAdvice`クラスの以下メソッドをオーバーライドする（両方をオーバーライドする必要はない。また、これらのメソッド内のコードが長くなったり、テストメソッド間で共通する処理がある場合は、プライベートメソッドに切り出すこと）:

- `void beforeExecute(TestCaseInfo testCaseInfo, ExecutionContext context)` — 送信前
- `void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context)` — 送信後

```java
execute("testMenus00102Normal", new BasicAdvice() {
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

`TestCaseInfo`の主要メソッド: `getTestCaseName()`（失敗メッセージ用）、`getSheetName()`（シート名）、`getTestCaseNo()`（ケース番号）、`getHttpRequest()`（テスト後のHttpRequest）。

**クラス**: `nablarch.test.core.http.HttpTestConfiguration`

コンポーネント設定ファイルで設定可能な項目:

| 設定項目名 | 説明 | デフォルト値 |
|---|---|---|
| htmlDumpDir | HTMLダンプファイルの出力ディレクトリ | ./tmp/http_dump |
| webBaseDir | Webアプリケーションのルートディレクトリ | ../main/web |
| xmlComponentFile | リクエスト単体テスト実行時に使用するコンポーネント設定ファイル | （なし） |
| userIdSessionKey | ログイン中ユーザIDを格納するセッションキー | user.id |
| exceptionRequestVarKey | ApplicationExceptionが格納されるリクエストスコープのキー | nablarch_application_error |
| dumpFileExtension | ダンプファイルの拡張子 | html |
| httpHeader | HttpRequestにHTTPリクエストヘッダとして格納される値 | Content-Type: application/x-www-form-urlencoded, Accept-Language: ja JP |
| sessionInfo | セッションに格納される値 | （なし） |
| htmlResourcesExtensionList | ダンプディレクトリへコピーされるHTMLリソースの拡張子 | css、jpg、js |
| jsTestResourceDir | javascript自動テスト実行時のリソースコピー先ディレクトリ名 | ../test/web |
| backup | ダンプディレクトリのバックアップOn/Off | true |
| htmlResourcesCharset | CSSファイルの文字コード | UTF-8 |
| checkHtml | HTMLチェックの実施On/Off | true |
| htmlChecker | HTMLチェックを行うオブジェクト（`nablarch.test.tool.htmlcheck.HtmlChecker`インタフェース実装が必要。詳細は :ref:`customize_html_check` を参照） | `nablarch.test.tool.htmlcheck.Html4HtmlChecker`のインスタンス（htmlCheckerConfigの設定ファイルが適用される） |
| htmlCheckerConfig | HTMLチェックツールの設定ファイルパス（htmlCheckerを設定しなかった場合のみ有効） | test/resources/httprequesttest/html-check-config.csv |
| ignoreHtmlResourceDirectory | HTMLリソースのコピー対象外とするディレクトリ名のリスト | （なし） |
| tempDirectory | JSPのコンパイル先ディレクトリ | jettyのデフォルト動作（./work、存在しない場合はTempフォルダ） |
| uploadTmpDirectory | アップロードファイルの一時格納ディレクトリ。テスト時のアップロード対象ファイルはこのディレクトリにコピー後に処理されるため、アクションでファイルを移動した場合でも実態ファイルの移動を防ぐことができる。 | ./tmp |
| dumpVariableItem | HTMLダンプファイル出力時に可変項目（JSESSIONID、二重サブミット防止トークン）を出力するか否か。これらはテスト実行毎に異なる値が設定される。ダンプ結果を毎回同一にしたい場合はfalse（デフォルト）。 | false |

> **注意**: `xmlComponentFile`を設定した場合、リクエスト送信直前に指定されたコンポーネント設定ファイルで初期化が行われる。クラス単体テストとリクエスト単体テストで設定を変える必要がある場合のみ設定する。通常は設定不要。

> **補足**: `ignoreHtmlResourceDirectory`にバージョン管理用ディレクトリ（.svn、.git）を設定するとHTMLリソースコピー時のパフォーマンスが向上する。

コンポーネント設定ファイル記述例（sessionInfoに`commonHeaderLoginUserName`、`commonHeaderLoginDate`を設定した例）:

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="htmlDumpDir" value="./tmp/http_dump"/>
    <property name="webBaseDir" value="../main/web"/>
    <property name="xmlComponentFile" value="http-request-test.xml"/>
    <property name="userIdSessionKey" value="user.id"/>
    <property name="httpHeader">
        <map>
            <entry key="Content-Type" value="application/x-www-form-urlencoded"/>
            <entry key="Accept-Language" value="ja JP"/>
        </map>
    </property>
    <property name="sessionInfo">
        <map>
            <entry key="commonHeaderLoginUserName" value="リクエスト単体テストユーザ"/>
            <entry key="commonHeaderLoginDate" value="20100914" />
        </map>
    </property>
    <property name="htmlResourcesExtensionList">
        <list>
            <value>css</value>
            <value>jpg</value>
            <value>js</value>
        </list>
    </property>
    <property name="backup" value="true" />
    <property name="htmlResourcesCharset" value="UTF-8" />
    <property name="ignoreHtmlResourceDirectory">
        <list>
            <value>.svn</value>
        </list>
    </property>
    <property name="tempDirectory" value="webTemp" />
    <property name="htmlCheckerConfig"
      value="test/resources/httprequesttest/html-check-config.csv" />
</component>
```

<details>
<summary>keywords</summary>

BasicAdvice, execute, beforeExecute, afterExecute, TestCaseInfo, ExecutionContext, 固有処理挿入, プライベートメソッド, HttpTestConfiguration, HtmlChecker, Html4HtmlChecker, htmlDumpDir, webBaseDir, xmlComponentFile, userIdSessionKey, exceptionRequestVarKey, dumpFileExtension, httpHeader, sessionInfo, htmlResourcesExtensionList, jsTestResourceDir, backup, htmlResourcesCharset, checkHtml, htmlChecker, htmlCheckerConfig, ignoreHtmlResourceDirectory, tempDirectory, uploadTmpDirectory, dumpVariableItem, コンポーネント設定ファイル, リクエスト単体テスト設定, HTMLダンプ設定, セッション設定

</details>

## リクエストスコープに複数種類の検索結果が格納されている場合の例

リクエストスコープに「ユーザグループ」と「ユースケース」のような複数種類の検索結果が格納されている場合、それぞれを個別に `assertSqlResultSetEquals` で検証する:

```java
execute("testMenus00103", new BasicAdvice() {
    @Override
    public void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
        String messgae = testCaseInfo.getTestCaseName();
        String sheetName = testCaseInfo.getSheetName();
        String no = testCaseInfo.getTestCaseNo();

        // グループ検索結果の検証
        SqlResultSet actualGroup = (SqlResultSet) context.getRequestScopedVar("allGroup");
        assertSqlResultSetEquals(message, sheetName, "expectedUgroup" + no, actualGroup);

        // ユースケース検索結果の検証
        SqlResultSet actualUseCase = (SqlResultSet) context.getRequestScopedVar("allUseCase");
        assertSqlResultSetEquals(message, sheetName, "expectedUseCase" + no, actualUseCase);
    }
});
```

> **注意**: Pentium4、Pentinum Dual-Core等の低性能CPUを搭載したPCに有効。それ以降のCPUでは効果は限定的。

リクエスト単体テストの実行速度を向上させるJVMオプション:

- **ヒープサイズ拡張のオーバヘッドを回避**（最大・最小ヒープサイズを同一値に設定）: `-Xms256m -Xmx256m`
- **クラスファイルの検証省略**（実行速度向上）: `-Xverfiy:none`

<details>
<summary>keywords</summary>

assertSqlResultSetEquals, SqlResultSet, 複数検索結果, リクエストスコープ検証, TestCaseInfo, getRequestScopedVar, JVMオプション, リクエスト単体テスト実行速度, ヒープサイズ設定, -Xms256m, -Xmx256m, -Xverfiy:none, クラスファイル検証省略, テスト実行速度向上

</details>

## リクエストスコープに検索結果(SqlResultSet)ではなくFormやエンティティが格納されている場合の例

リクエストスコープにSqlResultSetの代わりにエンティティやFormが格納されている場合、`assertEntity` でアサートする。期待値の書式は :ref:`entityUnitTest_SetterGetterCase` と同様（setterの欄は不要）:

```java
execute("testUsers00302Normal", new BasicAdvice() {
    @Override
    public void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
        String sheetName = testCaseInfo.getSheetName();
        // システムアカウントを比較
        String expectedSystemAccountId = "systemAccount" + testCaseInfo.getTestCaseNo();
        Object actualSystemAccount = context.getRequestScopedVar("systemAccount");
        assertEntity(sheetName, expectedSystemAccountId, actualSystemAccount);

        // ユーザを比較
        String expectedUsersId = "users" + testCaseInfo.getTestCaseNo();
        Object actualUsers = context.getRequestScopedVar("users");
        assertEntity(sheetName, expectedUsersId, actualUsers);
    }
});
```

> **注意**: リクエストスコープにFormが格納されている場合、別のFormを設定したプロパティでなければEntityと同様にテストできる。別のFormを設定したプロパティの場合は、そのFormを取得してEntityと同様にテストする（例: `Object actualSystemAccount = actualForm.getSystemAccount(); assertEntity(...)`）。

JavaSE5のJDKで開発している場合、テスト実行時のみJavaSE6のJREを使用することにより実行速度（特に起動速度）が向上する。

> **注意**: 事前にJavaSE6のJDKまたはJREをインストールし、Eclipseに「インストール済みのJRE」として登録しておく必要がある。

<details>
<summary>keywords</summary>

assertEntity, Form, エンティティ, entityUnitTest_SetterGetterCase, getRequestScopedVar, リクエストスコープ検証, 代替JRE, JavaSE5, JavaSE6, テスト実行速度向上, 起動速度

</details>

## リクエストスコープにSqlResultSetではなくSqlRowが格納されている場合の例

リクエストスコープに検索結果一覧(SqlResultSet)ではなく検索結果1件分(SqlRow)が格納されている場合、`assertSqlRowEquals` で検証する:

```java
execute("testUsers00302Normal", new BasicAdvice() {
    @Override
    public void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
        String message = testCaseInfo.getTestCaseName();
        String sheetName = testCaseInfo.getSheetName();
        String no = testCaseInfo.getTestCaseNo();

        SqlRow actual = (SqlRow) context.getRequestScopedVar("user");
        assertSqlRowEquals(message, sheetName, "expectedUser" + no, actual);
    }
});
```

リクエスト単体テスト実行時に以下のシステムプロパティを指定すると、[HTMLダンプ出力](#) 時にHTMLリソースのコピーを抑止できる。

`-Dnablarch.test.skip-resource-copy=true`

CSSや画像ファイルなど静的なHTMLリソースを頻繁に編集しない場合に設定することで、テスト実行の度にHTMLリソースをコピーする処理をスキップできる。

> **警告**: このシステムプロパティを指定した場合、HTMLリソースのコピーが行われないため、CSSなどのHTMLリソースを編集しても [HTMLダンプ出力](#) に反映されない。

> **注意**: HTMLリソースディレクトリが存在しない場合は、システムプロパティの設定有無に関わらずHTMLリソースのコピーが実行される。

<details>
<summary>keywords</summary>

assertSqlRowEquals, SqlRow, getRequestScopedVar, リクエストスコープ検証, HTMLリソースコピー抑止, nablarch.test.skip-resource-copy, -Dnablarch.test.skip-resource-copy=true, HTMLリソース, HTMLダンプ出力, システムプロパティ

</details>

## リクエストパラメータの値を検証したい場合

ウィンドウスコープの値をリセットするために、テスト対象機能にてリクエストパラメータを書き換える場合がある。テスト対象実行後のリクエストパラメータが期待通りであることを検証するには、`testCaseInfo.getHttpRequest()` でテスト後のHttpRequestを取得する:

```java
execute("testUsers00302Normal", new BasicAdvice() {
    @Override
    public void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
        HttpRequest request = testCaseInfo.getHttpRequest();
        // リクエストパラメータがリセットされていること
        assertEquals("", request.getParam("resetparameter"));
    }
});
```

<details>
<summary>keywords</summary>

HttpRequest, getParam, リクエストパラメータ検証, ウィンドウスコープ, getHttpRequest

</details>

## その他の場合

SqlResultSetやSqlRow等のよく使用されるオブジェクト以外の場合は、期待値を読み込む処理を自分で記述する。以下の手順で検証する:

1. テストデータをExcelファイルから取得
2. リクエストスコープ等から実際の値を取得
3. 自動テストフレームワークまたはJUnitのAPIを用いて結果検証

```java
execute("testUsers00303Normal", new BasicAdvice() {
    @Override
    public void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
        // 期待値をExcelファイルから取得
        List<Map<String, String>> expected = getListMap("doRW25AA0303NormalEnd", "result_1");
        // テスト実行後のリクエストスコープから実際の値を取得
        List<Map<String, String>> actual = context.getRequestScopedVar("pageData");
        // 結果検証
        assertListMapEquals(expected, actual);
    }
});
```

テストデータの取得方法: [how_to_get_data_from_excel](testing-framework-03_Tips.md) 参照。

<details>
<summary>keywords</summary>

assertListMapEquals, getListMap, how_to_get_data_from_excel, リクエストスコープ検証, 期待値取得

</details>

## ダウンロードファイルのテスト

:ref:`batch_request_test` と同じ方法でExcelにファイルの期待値を記載してテストする。

**期待するファイルの定義例**: ファイルパスにはダンプファイルを指定する。ダウンロード処理の場合、ダウンロードされたファイルがダンプされ、以下の命名規則でダンプファイルが出力される。ダンプ出力先ディレクトリの詳細は [html_dump_dir](testing-framework-02_RequestUnitTest-02_RequestUnitTest.md) 参照。

```
ダンプファイルの命名規則：
  Excelファイルのシート名＋"_"＋テストケース名＋"_"＋ダウンロードされたファイル名
```

**テストメソッドの実装例**: `FileSupport.assertFile(msgOnFail, testCaseName)` でアサートを行う:
```java
private FileSupport fileSupport = new FileSupport(getClass());

@Test
public void testRW11AC0104Download() {
    execute("testRW11AC0104Download", new BasicAdvice() {
        @Override
        public void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
            fileSupport.assertFile("ダウンロードしたユーザ一覧照会結果のCSVファイルのアサートに失敗しました。", "testRW11AC0104Download");
        }
    });
}

<details>
<summary>keywords</summary>

FileSupport, assertFile, ダウンロードファイルテスト, ダンプファイル命名規則, batch_request_test

</details>

## テスト起動方法

通常のJUnitテストと同じように実行する。クラス単体テストと同様の起動方法であり、IDEやビルドツール（Maven/Gradle）から特別な設定なしで実行できる。

<details>
<summary>keywords</summary>

JUnit, テスト実行, テスト起動

</details>

## テスト結果確認（目視）

テスト実行時、1リクエスト毎にHTMLダンプファイルが出力される。ブラウザで開き目視確認を行う。

> **注意**: リクエスト単体テストで生成されたHTMLファイルは自動テストフレームワーク（[../../08_TestTools/03_HtmlCheckTool/index](../toolbox/toolbox-03-HtmlCheckTool.md)）にて自動チェックされる。HTMLファイル内に構文エラー等の違反があった場合は違反内容に応じた例外が発生し、そのテストケースは失敗となる。

**HTMLダンプ出力結果**:
テスト用プロジェクトのルートディレクトリ配下の `tmp/html_dump` ディレクトリにHTMLダンプファイルが出力される。詳細は [dump-dir-label](#) 参照。

ダンプファイル名にはテストケース一覧（testShots）のdescription欄の記述が使用される。

<details>
<summary>keywords</summary>

HTMLダンプ, html_dump, HtmlCheckTool, ダンプファイル命名規則, テスト結果確認, dump-dir-label

</details>

## リクエスト単体テストクラス作成時の注意点

**ThreadContextへの値設定は不要**

リクエスト単体テストではWeb FrameworkのハンドラがThreadContextへの値設定を行うため、テストクラスからThreadContextへの値設定は不要。ユーザID設定方法については :ref:`request_test_user_info` 参照。

**テストクラスでのトランザクション制御は不要**

リクエスト単体テストではトランザクション制御はハンドラで行われるため、テストクラス内で明示的にトランザクションコミットを行う必要はない（クラス単体テストとの違い）。

<details>
<summary>keywords</summary>

ThreadContext, トランザクション制御, テストクラス注意点, ハンドラ

</details>
