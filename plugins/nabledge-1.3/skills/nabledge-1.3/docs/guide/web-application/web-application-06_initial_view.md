# 登録画面初期表示の実装

## Actionクラスの実装

**テストクラス作成**:

| 項目 | 値 |
|---|---|
| 格納フォルダ | `test/java/nablarch/sample/ss11AC` |
| テストクラス名 | `W11AC02ActionRequestTest` |
| 親クラス | `BasicHttpRequestTestTemplate` |

**URI形式**: `/action/{パッケージ名}/{アクションクラス名}/{メソッド名からdoを除いた文字列}`
- `nablarch.sample.` までを無視し、以降の `.` を `/` に置換
- `nablarch.sample.ss11AC.W11AC02Action` のベースURI: `/action/ss11AC/W11AC02Action/`

テストは `AbstractHttpRequestTestTemplate#execute(String)` にシート名を指定して実行する。

```java
public class W11AC02ActionRequestTest extends BasicHttpRequestTestTemplate {
    @Override
    protected String getBaseUri() {
        return "/action/ss11AC/W11AC02Action/";
    }

    @Test
    public void testRW11AC0201() {
        execute("testRW11AC0201");
    }
}
```

**テストデータシート**: `W11AC02ActionRequestTest.xlsx` / シート名: `testRW11AC0201` （ :ref:`リクエスト単体テストデータシートの書き方<request_test_testcases>` ）

検証内容:
- 登録画面の初期表示に必要なパラメータがリクエストに格納されていること
- 表示するJSPが登録画面のものであること
- レスポンスのステータスが `OK` であること

> **警告**: リクエスト単体テストでは、テスト共通データシート（シート名：setUpDb）が必須。データのセットアップが不要な場合でもシートを作成すること（シート内は空でよい）。

Actionクラスが未作成の場合、ステータスコード404でENDすることを確認する。

**Actionクラス作成**:

| 項目 | 値 |
|---|---|
| 格納フォルダ | `main/java/nablarch/sample/ss11AC` |
| クラス名 | `W11AC02Action` |
| メソッド名 | `doRW11AC0201`（「do」＋リクエストID `RW11AC0201`） |

**クラス**: `W11AC02Action` extends `DbAccessSupport`

```java
public class W11AC02Action extends DbAccessSupport {
    public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {
        return new HttpResponse("/ss11AC/W11AC0201.jsp");
    }
}
```

Actionクラス作成後のテスト確認:
- ログに `@@@@ DISPATCHING CLASS @@@@` の次に `BEFORE ACTION` が出力されていればActionまで到達
- この時点ではJSPが存在しないため `ERROR: PWC6117: File ... not found` エラーが出る

> **注意**: テストを繰り返しながらActionクラスを徐々に完成させる。

<details>
<summary>keywords</summary>

W11AC02ActionRequestTest, BasicHttpRequestTestTemplate, W11AC02Action, DbAccessSupport, AbstractHttpRequestTestTemplate, HttpResponse, HttpRequest, ExecutionContext, doRW11AC0201, リクエスト単体テスト, Actionクラス実装, ベースURI設定, setUpDb, テストクラス作成

</details>

## JSPの実装

**JSPファイルの配置**:
- コピー元: `main/web/W11AC0201.jsp`
- コピー先: `main/web/ss11AC/W11AC0201.jsp`

JSP修正内容:
1. `n:form` タグで囲み、ウィンドウスコーププレフィックスを指定する
2. 入力項目・表示項目のname属性を設定する
3. ボタン項目・リンク項目のuri属性を設定する

**① n:formタグ**: 業務領域（`<jsp:attribute name="contentHtml">`）の内側全体を `n:form` で囲み、`windowScopePrefixes="W11AC02"` を設定する（取引ID W11AC02 からプレフィックスを決定）。

```jsp
<n:form windowScopePrefixes="W11AC02">
```

**② name属性のルール**:
- 形式: `"ウィンドウスコーププレフィックス"."フォーム内のプロパティ名"`
- エンティティを保持する場合: `"ウィンドウスコーププレフィックス"."エンティティのプロパティ名"."エンティティ内のプロパティ名"`
- 例: `W11AC02.user.kanjiName`（漢字氏名フィールド）

**③ uri属性の形式**: `/{ベースURI}/{リクエストID}`

**JSP実装例**:

```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/template" %>
<%@ taglib prefix="field" tagdir="/WEB-INF/tags/widget/field" %>
<%@ taglib prefix="button" tagdir="/WEB-INF/tags/widget/button" %>

<t:page_template title="ユーザ情報登録" confirmationPageTitle="ユーザ情報登録確認">
  <jsp:attribute name="contentHtml">
    <n:form windowScopePrefixes="W11AC02">
      <field:block title="ユーザ情報">
        <field:text title="漢字氏名"
                    name="W11AC02.user.kanjiName"
                    hint="全角50文字以内で入力してください。"
                    required="true" maxlength="50">
        </field:text>
        <field:text title="カナ氏名"
                    name="W11AC02.user.kanaName"
                    hint="全角カタカナ50文字以内で入力してください。"
                    required="true" maxlength="50">
        </field:text>
      </field:block>
      <button:block>
        <n:forInputPage>
          <button:check uri="/action/ss11AC/W11AC02Action/RW11AC0202" dummyUri="W11AC0202.jsp"/>
        </n:forInputPage>
        <n:forConfirmationPage>
          <button:cancel uri="/action/ss11AC/W11AC02Action/RW11AC0203" dummyUri="W11AC0201.jsp"/>
          <button:confirm uri="/action/ss11AC/W11AC02Action/RW11AC0204" dummyUri="W11AC0203.jsp"/>
        </n:forConfirmationPage>
      </button:block>
    </n:form>
  </jsp:attribute>
</t:page_template>
```

**④ テスト確認**: リクエスト単体テストを実行し、HTMLが出力され、HTTPステータスコード200が返却されることを確認する。出力されたHTMLをWebブラウザで開き、登録画面であることを確認する。

HTMLの出力先フォルダ: `tmp/html_dump/W11AC02ActionRequestTest` 配下

**JSP静的チェックツール**: [jsp_static_analysis_tool](../../development-tools/java-static-analysis/java-static-analysis-01_JspStaticAnalysis.md) を実行し、チェックエラーがないことを確認する。

| Antビルドファイル | 実行するターゲット |
|---|---|
| `tool/jspanalysis/jsp-analysis-build.xml` | `JSP解析(HTMLレポート出力)` |

> **警告**: 静的チェックエラーがある実装はXSSの脆弱性を含む可能性があるため、必ず対処すること。機能制約等でどうしても回避できない場合は、プロジェクトのアーキテクトに確認すること。

<details>
<summary>keywords</summary>

n:form, windowScopePrefixes, field:text, field:block, t:page_template, button:check, button:cancel, button:confirm, n:forInputPage, n:forConfirmationPage, JSP実装, name属性設定, ウィンドウスコーププレフィックス, JSP静的チェック, jsp_static_analysis_tool

</details>
