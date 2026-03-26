# ボタン又はリンクによるサブミット

## 

なし

複数ウィンドウを立ち上げたい場合は以下のタグを使用する。新しいウィンドウを開き、そのウィンドウに対してサブミットを行う。

- `popupSubmit`
- `popupButton`
- `popupLink`

新しいウィンドウのスタイルは `popupOption` 属性で指定する。

| 属性 | 説明 |
|---|---|
| popupOption | ポップアップのオプション情報。`window.open` 関数の第3引数（JavaScript）に指定する。 |

オープンしたウィンドウのアクションと元画面のアクションでパラメータ名が異なる場合は、`changeParamName` タグでパラメータ名を変更する。

<details>
<summary>keywords</summary>

ボタン又はリンク, サブミット, カスタムタグ, popupSubmit, popupButton, popupLink, popupOption, changeParamName, 複数ウィンドウ, ポップアップ, パラメータ名変更

</details>

## ボタン又はリンクによるサブミット

name属性（フォーム内で一意）とuri属性を指定する必要がある。uri属性の指定は :ref:`uri_specifing` を参照。

| カスタムタグ | 対応するHTMLタグ |
|---|---|
| submitタグ | inputタグ（type=submit, button, image） |
| buttonタグ | buttonタグ |
| submitLinkタグ | aタグ |
| popupSubmitタグ | inputタグ（type=submit, button, image） |
| popupButtonタグ | buttonタグ |
| popupLinkタグ | aタグ |

「popup」から始まるタグは新しい画面をオープンし、その画面に対してサブミットを行う。

### サブミット先の指定方法

uri属性にコンテキストルートからの相対パスを指定する。

```java
public class W11AC02Action {
    public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {
        return new HttpResponse("/ss11AC/W11AC0201.jsp");
    }
}
```

JSP実装例（W11AC0201.jsp）:

```jsp
<n:form>
  <n:text name="W11AC02.systemAccount.loginId" size="22" maxlength="20" />
  <n:submit cssClass="buttons" type="button" name="confirm" value="確認"
    uri="/action/ss11AC/W11AC02Action/RW11AC0202" />
</n:form>
```

郵便番号から住所を検索する別ウィンドウにサブミットする場合の実装例を示す。

**JSP実装例:**

```jsp
<%-- 郵便番号の入力項目以外は省略 --%>
<tr>
    <th>
        <span class="essential">*</span>郵便番号<span class="instruct">(半角数字)</span>
    </th>
    <td>
        <n:text name="W11AC01.postalCode" size="7" maxlength="9"/>
        <%-- popupButtonタグを指定する。name属性やuri属性の指定は通常のbuttonタグと同じ。 --%>
        <n:popupButton name="searchAddress" uri="/action/ss11AB/W11AB01Action/RW11AB0101">
            検索
            <%-- 郵便番号のパラメータ名を別画面のアクションに合わせて変更する。 --%>
            <n:changeParamName inputName="W11AC01.postalCode" paramName="W11AB01.postalCode" />
            <%-- 別画面のアクションに合わせてパラメータを追加する。 --%>
            <n:param paramName="W11AB01.max" value="10" />
        </n:popupButton>
    </td>
</tr>
```

<details>
<summary>keywords</summary>

submitタグ, buttonタグ, submitLinkタグ, popupSubmitタグ, popupButtonタグ, popupLinkタグ, カスタムタグ, ボタンサブミット, リンクサブミット, uri属性, サブミット先の指定方法, popupButton, changeParamName, 別ウィンドウサブミット, 郵便番号検索, パラメータ名変更, n:param

</details>

## アプリケーションでonclick属性を指定する場合

フレームワークはサブミット処理を行う `nablarch_submit(event, element)` 関数を自動出力する。JSPでonclick属性を指定しない場合は自動でonclick属性として設定される。**JSPでonclick属性を指定した場合は自動設定されない**ため、アプリケーションのJavaScript内で `nablarch_submit` を明示的に呼び出す必要がある。

```javascript
// フレームワークが自動出力する関数（@return 常にfalse）
function nablarch_submit(event, element) { ... }
```

JSP実装例（onclick属性指定の場合）:

```jsp
<script language="javascript">
    function popUpConfirmation(event, element) {
      if (window.confirm("登録します。よろしいですか？")) {
        return nablarch_submit(event, element);
      } else {
        return false;
      }
    }
</script>
<n:form>
  <n:submit cssClass="buttons" type="button" name="register" value="登録"
    uri="/action/ss11AC/W11AC02Action/RW11AC0204"
    onclick="return popUpConfirmation(event, this);" />
</n:form>
```

別ウィンドウから元画面に値を設定したい場合はJavaScriptで実現する。JavaScriptは動的な値の埋め込みを防ぐために外部ファイルに記述する。`window.opener` を使用して元画面を参照する。

> **警告**: JavaScriptに対するエスケープ処理はフレームワーク未実装のため、scriptタグのボディやonclick属性など、JavaScriptを記述する部分には動的な値（入力データなど）を埋め込まないこと。

**JavaScript実装例（/js/common.js）:**

```javascript
function setInputValueToOpener(openerInputName, element, prefix, attributeName) {
    if (attributeName == null) {
        attributeName = "name";
    }
    var value = element[attributeName];
    value = value.substring(prefix.length, value.length);
    /* window.openerを使用して元画面を参照する。*/
    var input = window.opener.document.getElementsByName(openerInputName)[0];
    input.value = value;
    window.close();
}
```

**JSP実装例（リンクで選択させる場合）:**

```jsp
<%-- 外部ファイルに記述したJavaScriptを読み込む。n:scriptタグはheadタグ内に記述する。 --%>
<n:script type="text/javascript" src="/js/common.js" />

<%-- name属性にプレフィックス＋郵便番号、onclick属性にJavaScript関数を指定する。 --%>
<n:form>
<c:forEach var="row" items="${resultSet}">
    <div>
        <n:a href="#" name="val_${row.postalCode}"
             onclick="setInputValueToOpener('W11AC01.postalCode', this, 'val_')">
            <n:write name="row.postalCode" />
        </n:a>
    </div>
</c:forEach>
</n:form>
```

**JSP実装例（ボタンで選択させる場合）:**

```jsp
<%-- 外部ファイルに記述したJavaScriptを読み込む。n:scriptタグはheadタグ内に記述する。 --%>
<n:script type="text/javascript" src="/js/common.js" />

<%-- name属性にプレフィックス＋郵便番号、onclick属性にJavaScript関数を指定する。 --%>
<n:form>
<c:forEach var="row" items="${resultSet}">
    <div>
        <n:button uri="#" name="val_${row.postalCode}"
            onclick="setInputValueToOpener('W11AC01.postalCode', this, 'val_')">
            <n:write name="row.postalCode" />
        </n:button>
    </div>
</c:forEach>
</n:form>
```

<details>
<summary>keywords</summary>

onclick属性, nablarch_submit, JavaScript関数, アプリケーション定義関数, setInputValueToOpener, window.opener, 別ウィンドウ 元画面 値設定, JavaScript 外部ファイル, n:a, n:button, n:script, window.close

</details>

## 

なし

DBコミットを伴う画面では二重サブミットを防止する必要がある。クライアント側の対策（リクエストの二重送信防止）とサーバ側の対策（処理済リクエストの受信防止）の両方を実施する必要がある。

<details>
<summary>keywords</summary>

Enterキー, デフォルトボタン, サブミットボタン設定, 二重サブミット防止, リクエストの二重送信防止, 処理済リクエストの受信防止, DBコミット, クライアント側対策, サーバ側対策

</details>

## Enterキー押下時にデフォルトで動作するサブミットボタンを設定する方法

1つのフォーム内に複数ボタンがある場合、デフォルトでEnterキー押下時に先頭のボタンがサブミットされる。

- Enterキー押下時にデフォルトで動作させたいボタン: `n:submit` の `type="submit"` を指定
- デフォルトで動作させないボタン: `n:submit` の `type="button"` を指定

> **注意**: `n:button` タグは `type="submit"` を指定してもEnterキー押下時にサブミットされない。

JSP実装例:

```jsp
<n:form windowScopePrefixes="systemAccount">
    <n:submit type="button" name="back" value="登録画面へ"
              uri="/action/ss11AC/W11AC02Action/RW11AC0203"/>
    <n:submit type="submit" name="register" value="確定"
            uri="/action/ss11AC/W11AC02Action/RW11AC0204" />
</n:form>
```

入力画面と確認画面が1対1に対応する場合、表示用のJSPファイルを共通化できる。

<details>
<summary>keywords</summary>

Enterキー, デフォルトサブミットボタン, n:submitタグ, n:buttonタグ, type=submit, type=button, 複数ボタン, 入力画面と確認画面の共通化, JSPファイル共通化, カスタムタグ, 確認画面

</details>

## 

なし

ブラウザの戻るボタンが押されても前の画面を表示できないようにするには、`noCacheタグ` を使用する。

<details>
<summary>keywords</summary>

一覧照会画面, 詳細画面, 画面遷移, noCacheタグ, ブラウザキャッシュ防止, 戻るボタン, ブラウザの戻るボタン, 履歴バック防止

</details>

## 一覧照会画面から詳細画面へ遷移する場合

1つのフォームの複数ボタンやリンクから異なるパラメータを送信する場合は `paramタグ` を使用する。リクエスト送信時に使用するパラメータ名は `paramName属性` で指定する。送信データを指定する属性は指定方法によって以下の2つがある。

| 属性名 | 指定方法 |
|---|---|
| value | データを直接指定 |
| name | リクエストスコープやウィンドウスコープ上のオブジェクトを参照して指定 |

Action実装例:

```java
public class W11AC01Action {
    public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
        ValidationContext<W11AC01SearchForm> formCtx =
            ValidationUtil.validateAndConvertRequest("11AC_W11AC01", W11AC01SearchForm.class, req, "search");
        formCtx.abortIfInvalid();
        W11AC01SearchForm searchCondition = formCtx.createObject();
        CM311AC1Component component = new CM311AC1Component();
        SqlResultSet searchResult = component.selectByCondition(searchCondition);
        ctx.setRequestScopedVar("searchResult", searchResult);
        return new HttpResponse("/ss11AC/W11AC0101.jsp");
    }
}
```

JSP実装例（W11AC0101.jsp）:

```jsp
<n:form>
  <table>
    <c:forEach var="row" items="${searchResult}" varStatus="status">
    <tr>
      <n:submitLink uri="/action/ss11AC/W11AC01Action/RW11AC0103" name="showDetail_${status.index}">
        <n:write name="row.loginId"/>
        <n:param paramName="11AC_W11AC01.loginId" name="row.loginId" />
      </n:submitLink>
    </tr>
    </c:forEach>
  </table>
</n:form>
```

HTML出力: `nablarch_hidden_submit_<name属性>` プレフィックスでリンク毎の変更パラメータが隠しフィールドに出力される。選択されたリンクの変更パラメータはフレームワークのハンドラによりリクエストに設定される（例: U0002リンク選択時 → `11AC_W11AC01.loginId=U0002`）。

<details>
<summary>keywords</summary>

paramタグ, paramName, value, name, 一覧照会画面, 詳細画面遷移, submitLinkタグ, 異なるパラメータ送信, nablarch_hidden, ValidationContext, ValidationUtil

</details>

## 

なし

<details>
<summary>keywords</summary>

マルチウィンドウ, ポップアップ, 新規ウィンドウ

</details>
