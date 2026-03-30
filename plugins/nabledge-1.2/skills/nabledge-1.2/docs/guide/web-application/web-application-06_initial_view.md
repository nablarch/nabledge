# 更新画面初期表示の実装

## 更新画面初期表示の実装

## 更新画面初期表示の実装

### 1)-1 Actionクラスの実装

**a) リクエスト単体テストコードの作成**

**テストクラス作成フォルダ**: `/Nablarch_sample/test/java/nablarch/sample/ss11AC` 配下

**テストクラス**: `W11ACXXActionRequestTest extends BasicHttpRequestTestTemplate`

```java
public class W11ACXXActionRequestTest extends BasicHttpRequestTestTemplate {
    @Override
    protected String getBaseUri() {
        return "/action/ss11AC/W11ACXXAction/";
    }

    @Test
    public void testRW11ACXX01() {
        execute("testRW11ACXX01");
    }
}
```

**b) リクエスト単体テストデータシートの作成**

**ブック名**: `W11ACXXActionRequestTest.xls`、**シート名**: `testRW11ACXX01`

> **警告**: リクエスト単体テストでは、テスト共通データシート（シート名：setUpDb）が必須。不要な場合でもシートを作成すること（シート内は空でよい）。

**c) テスト実施（Actionクラス作成前）**: Actionクラスを作成していない状態でテストを実施し、失敗することを確認する。ステータスコード404で処理がENDしていること。

```none
status_code = [404] content_path = [/PAGE_NOT_FOUND_ERROR.jsp]
```

**d) Actionクラスの新規作成**

**ソース格納フォルダ**: `/Nablarch_sample/main/java/nablarch/sample/ss11AC` 配下

**クラス名**: `W11ACXXAction`、**メソッド名**: `doRW11ACXX01(HttpRequest req, ExecutionContext ctx)`

```java
public HttpResponse doRW11ACXX01(HttpRequest req, ExecutionContext ctx) {
    return new HttpResponse("/ss11AC/W11ACXX01.jsp");
}
```

**e) テスト実施（Actionクラス作成後）**: Actionクラスまで処理が到達していることを確認する。`@@@@ DISPATCHING CLASS @@@@` の次に `**** BEFORE ACTION ****` が出力されていれば到達している。また、JSPファイルが存在しないため `PWC6117: File ... not found` エラーが出力される。

```none
@@@@ DISPATCHING CLASS @@@@ class = [nablarch.sample.ss11AC.W11ACXXAction]
**** BEFORE ACTION ****
ERROR: PWC6117: File "...\ss11AC\W11ACXX01.jsp" not found
```

### 1)-2 JSPの実装

**a) JSPの自動生成**

**JSP作成フォルダ**: `/Nablarch_sample/web/ss11AC` 配下

**JSPファイル名**: `W11ACXX01.jsp`

JSP自動生成ツールを使用して、外部設計で作成した画面HTMLからJSPを自動生成する。

作成手順:
1. 画面HTMLをJSP作成フォルダに移動し、ファイル名をJSPと合わせる（**HTMLファイル名**: `W11ACXX01.html`）
2. JSP自動生成ツールを使用して、画面HTMLからJSPを自動生成する
3. 不要となったHTMLファイルを削除する

**b) JSPの表示確認１**

自動生成されたJSPは、Nablarch提供のカスタムタグの必須属性が出力されている。カスタムタグの必須属性のうち、画面表示に最低限必要なボタンとリンクの `name` 属性と `uri` 属性のみ値を設定する。

リクエスト単体テストを実行し、HTML(JSP)が出力されること、HTTPステータスコード：200が返却されることを確認する。

**HTMLの出力先フォルダ**: `/Nablarch_sample/tmp/html_dump/W11ACXXActionRequestTest` 配下

**c) JSPの修正**

① JSPのメイン領域のカスタムタグを修正する。`<n:text>` / `<n:error>` の `name` 属性を取引IDプレフィックス付き形式（例: `W11ACXX.users.kanjiName`）に修正する。

```none
<n:text name="W11ACXX.users.kanjiName" size="70" maxlength="50" />
<n:error name="W11ACXX.users.kanjiName" />
```

② `<n:form>` タグに `windowScopePrefixes` 属性を設定する。値は取引IDから決定（例: `W11ACXX`）。

```none
<n:form windowScopePrefixes="W11ACXX">
```

③ その他、画面のタイトル、JSPインクルードで共通化された部分を修正する。

**d) JSPの表示確認２**

リクエスト単体テストを実行し、c) で行った修正によりレイアウトが崩れていないかを確認する。出力されたHTMLをWebブラウザで開き、更新画面であることを確認する。

**HTMLの出力先フォルダ**: `/Nablarch_sample/tmp/html_dump/W11ACXXActionRequestTest` 配下

**e) JSP静的チェックツールの実行**

> **警告**: JSP静的チェックツールでエラーが出る実装はXSSの脆弱性を含む可能性があるため必ず対処すること。アプリケーションの機能制約から回避できない場合は、プロジェクトのアーキテクトに確認すること。

### 2)-1 Componentクラスの実装（検索SQL）

**a) リクエスト単体テストコード修正**: `testRW11ACXX01` メソッドに検索結果のアサートを追加する。`BasicAdvice` クラスを用いてリクエスト単体テストに固有の処理を追加する。

```java
@Test
public void testRW11ACXX01() {
    execute("testRW11ACXX01", new BasicAdvice() {
        @Override
        public void afterExecute(TestCaseInfo testCaseInfo, ExecutionContext context) {
            String message = testCaseInfo.getTestCaseName();
            String sheetName = testCaseInfo.getSheetName();

            // 更新画面に表示する内容をアサートする
            W11ACXXForm actual = context.getRequestScopedVar("W11ACXX");
            assertObjectPropertyEquals(message, sheetName, "expectedUsers", actual.getUsers());
        }
    });
}
```

**b) リクエスト単体テストデータシート修正**

1)-1 で作成した以下のシートに、検索結果のアサート用データを追加する。

**ブック名**: `W11ACXXActionRequestTest.xls`、**シート名**: `testRW11ACXX01`

**c) リクエスト単体テスト実施**

リクエスト単体テストを実行し、失敗することを確認する。この時点では検索処理の実装をしていないため、失敗する。

**d) 検索処理の実装**

**SQLファイル**: `CM311ACXComponent.sql`（格納フォルダ: `/Nablarch_sample/resources/nablarch/sample/ss11AC` 配下）

```sql
SELECT_USER_INFO=
SELECT
    USER_ID,
    KANJI_NAME,
    KANA_NAME
FROM
    USERS
WHERE
    USER_ID = ?
```

**クラス**: `CM311ACXComponent extends DbAccessSupport`（格納フォルダ: `/Nablarch_sample/main/java/nablarch/sample/ss11AC` 配下）

```java
public SqlResultSet selectUsers(String userId) {
    SqlPStatement statement = getSqlPStatement("SELECT_USER_INFO");
    statement.setString(1, userId);
    return statement.retrieve();
}
```

### 2)-2 Actionクラスの実装（検索処理組み込み）

**a) 検索処理の呼び出し実装**

```java
public HttpResponse doRW11ACXX01(HttpRequest req, ExecutionContext ctx) {
    // バリデーション・ユーザID取得
    ValidationContext<W11ACXXForm> formCtx =
        ValidationUtil.validateAndConvertRequest("W11ACXX",
                W11ACXXForm.class, req, "selectUserInfo");
    if (!formCtx.isValid()) {
        throw new ApplicationException(formCtx.getMessages());
    }
    String userId = formCtx.createObject().getOperationTargetUserId();

    // 検索処理呼び出し
    CM311ACXComponent comp = new CM311ACXComponent();
    SqlResultSet userInfo = comp.selectUsers(userId);

    // 更新画面表示内容をリクエストへセット
    W11ACXXForm form = new W11ACXXForm();
    UsersEntity users = new UsersEntity(userInfo.get(0));
    form.setUsers(users);
    ctx.setRequestScopedVar("W11ACXX", form);

    return new HttpResponse("/ss11AC/W11ACXX01.jsp");
}
```

**b) 更新画面の表示確認**

リクエスト単体テストを実行し、出力されたHTMLに更新対象の検索結果が表示されていることを確認する。

<details>
<summary>keywords</summary>

W11ACXXActionRequestTest, BasicHttpRequestTestTemplate, BasicAdvice, TestCaseInfo, W11ACXXAction, HttpResponse, HttpRequest, ExecutionContext, CM311ACXComponent, DbAccessSupport, SqlResultSet, SqlPStatement, W11ACXXForm, UsersEntity, ValidationUtil, ValidationContext, ApplicationException, 更新画面初期表示, リクエスト単体テスト, ウィンドウスコープ, JSP実装, JSP自動生成, 検索処理, windowScopePrefixes, setUpDb, XSS, SELECT_USER_INFO, W11ACXX01.jsp, W11ACXX01.html, html_dump

</details>
