# ボタン又はリンクによるサブミット

## ボタン又はリンクによるサブミット

フォームからサブミットを行うカスタムタグ。name属性（フォーム内で一意）とuri属性（:ref:`uri_specifing` 参照）の指定が必須。

| カスタムタグ | 対応するHTMLタグ |
|---|---|
| submitタグ | inputタグ（type=submit, button, image） |
| buttonタグ | buttonタグ |
| submitLinkタグ | aタグ |
| popupSubmitタグ | inputタグ（type=submit, button, image） |
| popupButtonタグ | buttonタグ |
| popupLinkタグ | aタグ |

`popup`で始まるタグは新しい画面をオープンし、その画面にサブミットする。

複数ウィンドウを立ち上げたい場合は以下のタグを使用する。これらのタグは新しいウィンドウをオープンし、そのウィンドウへサブミットする。

- `popupSubmit`
- `popupButton`
- `popupLink`

新しいウィンドウのスタイルは `popupOption` 属性で指定する。

| 属性 | 説明 |
|---|---|
| popupOption | ポップアップのオプション情報。新しいウィンドウを開く際に `window.open` 関数の第3引数(JavaScript)に指定する。 |

元画面と別ウィンドウのアクションでパラメータ名が異なる場合は `changeParamName` タグでパラメータ名を変更する。

<details>
<summary>keywords</summary>

submitタグ, buttonタグ, submitLinkタグ, popupSubmitタグ, popupButtonタグ, popupLinkタグ, ボタンサブミット, リンクサブミット, name属性, uri属性, popupSubmit, popupButton, popupLink, popupOption, changeParamName, 複数ウィンドウ, ポップアップ, 別ウィンドウサブミット

</details>

## サブミット先の指定方法

uri属性にコンテキストルートからの相対パス（`/`から始まる）を指定する。

**Actionクラス実装例**:

```java
public class W11AC02Action {
    public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {
        return new HttpResponse("/ss11AC/W11AC0201.jsp");
    }
    public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) { }
}
```

**JSP実装例（W11AC0201.jsp）**:

```jsp
<n:form>
  <n:text name="W11AC02.systemAccount.loginId" size="22" maxlength="20" />
  <n:submit cssClass="buttons" type="button" name="confirm" value="確認"
      uri="/action/ss11AC/W11AC02Action/RW11AC0202" />
</n:form>
```

郵便番号から住所を検索する別ウィンドウにサブミットする場合の実装例を示す。

`popupButton` タグの `name` 属性や `uri` 属性の指定は、画面内のフォームをサブミットする `button` タグと同じ。

```jsp
<n:popupButton name="searchAddress" uri="/action/ss11AB/W11AB01Action/RW11AB0101">
    検索
    <n:changeParamName inputName="W11AC01.postalCode" paramName="W11AB01.postalCode" />
    <n:param paramName="W11AB01.max" value="10" />
</n:popupButton>
```

<details>
<summary>keywords</summary>

uri属性, コンテキストルート, 相対パス, W11AC02Action, サブミット先URI指定, HttpResponse, popupButton, 別ウィンドウサブミット, changeParamName, JSP実装例, popupButtonタグ, name属性

</details>

## アプリケーションでonclick属性を指定する場合

フレームワークはサブミット処理用JavaScript関数 `nablarch_submit(event, element)` を自動出力する。JSPでonclick属性を指定しない場合は自動でセットされるが、**JSPでonclick属性を指定した場合は自動セットされないため、アプリケーション側で `nablarch_submit` を明示的に呼び出す必要がある**。

**JSP実装例（確認ダイアログ）**:

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
      uri="/action/ss11AC/W11AC02Action/RW11AC0204" onclick="return popUpConfirmation(event, this);" />
</n:form>
```

別ウィンドウから元画面に値を設定したい場合はJavaScriptにより実現する。JavaScriptは動的な値の埋め込みを防ぐために外部ファイルに記述する。

> **警告**: JavaScriptに対するエスケープ処理はフレームワークで未実装のため、scriptタグのボディやonclick属性など、JavaScriptを記述する部分には動的な値（入力データなど）を埋め込まないこと。

`window.opener` を使用して元画面を参照し、値を設定してウィンドウをクローズする。

```javascript
function setInputValueToOpener(openerInputName, element, prefix, attributeName) {
    if (attributeName == null) {
        attributeName = "name";
    }
    var value = element[attributeName];
    value = value.substring(prefix.length, value.length);
    var input = window.opener.document.getElementsByName(openerInputName)[0];
    input.value = value;
    window.close();
}
```

リンクで選択する場合:
```jsp
<n:script type="text/javascript" src="/js/common.js" />
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

ボタンで選択する場合:
```jsp
<n:script type="text/javascript" src="/js/common.js" />
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

onclick属性, nablarch_submit, JavaScript関数, 自動出力, popUpConfirmation, setInputValueToOpener, window.opener, 別ウィンドウ値設定, JavaScript外部ファイル, ウィンドウクローズ, n:script

</details>

## Enterキー押下時にデフォルトで動作するサブミットボタンを設定する方法

1つのフォーム内に複数ボタンがある場合、デフォルトではEnterキー押下で先頭ボタンがサブミットされる。

Enterキーのデフォルト動作を制御するには `n:submit` タグを使用する:
- デフォルトで動作させたいボタン: `type="submit"` を指定
- デフォルトで動作させないボタン: `type="button"` を指定

> **重要**: `n:button`タグは `type="submit"` を指定してもEnterキー押下時にサブミットされない。Enterキーのデフォルト動作には `n:submit` タグを使用すること。

**JSP実装例**:

```jsp
<n:form windowScopePrefixes="systemAccount">
    <n:submit type="button" name="back" value="登録画面へ"
              uri="/action/ss11AC/W11AC02Action/RW11AC0203"/>
    <%-- このformでEnterキー押下時、「確定」ボタンが動作する --%>
    <n:submit type="submit" name="register" value="確定"
            uri="/action/ss11AC/W11AC02Action/RW11AC0204" />
</n:form>
```

データベースへのコミットを伴う画面では二重サブミットを防止する必要がある。クライアント側（リクエストの二重送信防止）とサーバ側（処理済リクエストの受信防止）の両方の対策が必要。

<details>
<summary>keywords</summary>

n:submitタグ, n:buttonタグ, Enterキーデフォルトボタン, type属性, 複数ボタン制御, 二重サブミット防止, リクエストの二重送信防止, 処理済リクエストの受信防止, クライアント側対策, サーバ側対策

</details>

## 一覧照会画面から詳細画面へ遷移する場合

1つのフォームの複数ボタン・リンクから異なるパラメータを送信したい場合（一覧から詳細への遷移など）、`paramタグ`を使用する。

paramタグの送信データ指定属性:

| 属性名 | 指定方法 |
|---|---|
| value | データを直接指定 |
| name | リクエストスコープやウィンドウスコープ上のオブジェクトを参照して指定 |

パラメータ名は `paramName` 属性で指定する。

**Actionクラス実装例**:

```java
public class W11AC01Action {
    public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
        ValidationContext<W11AC01SearchForm> formCtx =
            ValidationUtil.validateAndConvertRequest("11AC_W11AC01", W11AC01SearchForm.class, req, "search");
        if (!formCtx.isValid()) {
            throw new ApplicationException(formCtx.getMessages());
        }
        W11AC01SearchForm searchCondition = formCtx.createObject();
        CM311AC1Component component = new CM311AC1Component();
        SqlResultSet searchResult = component.selectByCondition(searchCondition);
        ctx.setRequestScopedVar("searchResult", searchResult);
        return new HttpResponse("/ss11AC/W11AC0101.jsp");
    }
}
```

**JSP実装例（W11AC0101.jsp）**:

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

HTML出力では `nablarch_hidden` inputに `nablarch_hidden_submit_<name属性>` プレフィックスでリンク毎の変更パラメータが出力される。選択されたリンクの変更パラメータはフレームワークのハンドラによりリクエストに設定される。

U0002リンクをクリックした場合のリクエストパラメータ:

```
11AC_W11AC01.loginId=U0002
```

入力画面と確認画面が1対1に対応する場合、表示のためのJSPファイルを共通化できる。

<details>
<summary>keywords</summary>

paramタグ, submitLinkタグ, paramName属性, nablarch_hidden, 一覧照会, 詳細画面遷移, 異なるパラメータ送信, ApplicationException, ValidationContext, SqlResultSet, CM311AC1Component, W11AC01SearchForm, 入力画面共通化, 確認画面共通化, JSPファイル共通化, カスタムタグ, 入力確認画面

</details>

## ブラウザのキャッシュ防止

ブラウザの戻るボタンが押されても前の画面を表示できないようにするには、`noCacheタグ` を使用する。

<details>
<summary>keywords</summary>

noCacheタグ, ブラウザキャッシュ防止, ブラウザの戻るボタン, 履歴バック防止

</details>
