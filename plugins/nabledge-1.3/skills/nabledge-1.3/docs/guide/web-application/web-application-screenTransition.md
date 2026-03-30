# ボタン又はリンクによるサブミット

## ボタン又はリンクによるサブミット

## カスタムタグ一覧

| カスタムタグ | 対応するHTMLタグ |
|---|---|
| submitタグ | inputタグ（type=submit, button, image） |
| buttonタグ | buttonタグ |
| submitLinkタグ | aタグ |
| popupSubmitタグ | inputタグ（type=submit, button, image） |
| popupButtonタグ | buttonタグ |
| popupLinkタグ | aタグ |

`name`属性はフォーム内で一意な名前を指定する。`uri`属性の指定は :ref:`uri_specifing` 参照。`popup`で始まるタグは新しい画面をオープンしてサブミットを行う。

## サブミット先の指定方法

`uri`属性にコンテキストルートからの相対パスを指定する。

**Actionクラス実装例 (W11AC02Action)**:
```java
public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {
    return new HttpResponse("/ss11AC/W11AC0201.jsp");
}
public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) { ... }
```

**JSP実装例 (W11AC0201.jsp)**:
```jsp
<n:form>
  <n:text name="W11AC02.systemAccount.loginId" size="22" maxlength="20" />
  <n:submit cssClass="buttons" type="button" name="confirm" value="確認"
      uri="/action/ss11AC/W11AC02Action/RW11AC0202" />
</n:form>
```

## onclick属性を指定する場合

> **重要**: JSPで`onclick`属性を指定した場合、フレームワークが自動設定する`nablarch_submit(event, element)`関数はonclick属性として出力されない。アプリケーション側で明示的に呼び出す必要がある。

**JSP実装例（確認ダイアログ付きボタン）**:
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
  <n:submit type="button" name="register" value="登録"
        uri="/action/ss11AC/W11AC02Action/RW11AC0204"
        onclick="return popUpConfirmation(event, this);" />
</n:form>
```

複数ウィンドウを立ち上げる場合は以下のタグを使用する。新しいウィンドウをオープンし、オープンしたウィンドウに対してサブミットを行う。

- `popupSubmit`
- `popupButton`
- `popupLink`

| 属性 | 説明 |
|---|---|
| `popupOption` | ポップアップのオプション情報。新しいウィンドウを開く際に `window.open` 関数の第3引数（JavaScript）に指定する。 |

オープンしたウィンドウの処理アクションと元画面のアクションでパラメータ名が異なる場合は、`changeParamName` タグを使用してパラメータ名を変更する。

<details>
<summary>keywords</summary>

submitタグ, buttonタグ, submitLinkタグ, popupSubmitタグ, popupButtonタグ, popupLinkタグ, nablarch_submit, ボタンサブミット, リンクサブミット, onclick属性, サブミット先指定, コンテキストルート相対パス, popupSubmit, popupButton, popupLink, popupOption, changeParamName, 複数ウィンドウ, ポップアップ, パラメータ名変更, 別ウィンドウ

</details>

## Enterキー押下時にデフォルトで動作するサブミットボタンを設定する方法

1つのフォーム内に複数ボタンが配置されている場合、何も設定しない状態ではEnterキー押下時に先頭のボタンがサブミットされる。画面内のボタン配置順によっては、Enterキー押下時にデフォルトで動作させたいボタンを制御したい場合がある。

Enterキー押下時にデフォルトで動作させるボタンは`n:submit`タグで`type="submit"`を指定する。

> **重要**: `n:button`タグは`type="submit"`を指定してもEnterキー押下時にサブミットされない。Enterキーのデフォルト動作を設定するには必ず`n:submit`タグを使用すること。

デフォルトで動作させないボタンには`n:submit`タグの`type="button"`を指定する。

**JSP実装例**:
```jsp
<n:form windowScopePrefixes="systemAccount">
    <n:submit type="button" name="back" value="登録画面へ"
              uri="/action/ss11AC/W11AC02Action/RW11AC0203"/>
    <!-- Enterキー押下時にこの「確定」ボタンが動作する -->
    <n:submit type="submit" name="register" value="確定"
            uri="/action/ss11AC/W11AC02Action/RW11AC0204" />
</n:form>
```

郵便番号から住所を検索する別ウィンドウにサブミットする場合の実装例を示す。

```jsp
<%-- 郵便番号の入力項目以外は省略 --%>
<tr>
    <th>
        <span class="essential">*</span>郵便番号<span class="instruct">(半角数字)</span>
    </th>
    <td>
        <n:text name="W11AC01.postalCode" size="7" maxlength="9"/>
        <%-- popupButtonタグを指定する。
              name属性やuri属性の指定は、画面内のフォームをサブミットするbuttonタグと同じ。 --%>
        <n:popupButton name="searchAddress" uri="/action/ss11AB/W11AB01Action/RW11AB0101">
            検索
            <%-- 郵便番号のパラメータ名"W11AC01.postalCode"を"W11AB01.postalCode"に変更する。
                  別画面を表示するアクションで入力項目を使用する場合は、
                  別画面を表示するアクションに合わせてパラメータ名を変更する。 --%>
            <n:changeParamName inputName="W11AC01.postalCode" paramName="W11AB01.postalCode" />
            <%-- 変更パラメータを追加する。
                  別画面を表示するアクションに合わせてパラメータを追加する。 --%>
            <n:param paramName="W11AB01.max" value="10" />
        </n:popupButton>
    </td>
</tr>
```

<details>
<summary>keywords</summary>

n:submitタグ, n:buttonタグ, type=submit, type=button, Enterキーデフォルトボタン, フォーム複数ボタン, windowScopePrefixes, 先頭ボタン, デフォルト動作制御, popupButton, changeParamName, 別ウィンドウサブミット, 郵便番号検索, n:param, JSP実装例

</details>

## 一覧照会画面から詳細画面へ遷移する場合

1つのフォーム内の複数ボタン/リンクから異なるパラメータを送信する場合は`param`タグを使用する。

| 属性名 | 指定方法 |
|---|---|
| value | データを直接指定 |
| name | リクエストスコープやウィンドウスコープ上のオブジェクトを参照して指定 |

`paramName`属性でリクエスト送信時に使用するパラメータ名を指定する。

**Actionクラス実装例 (W11AC01Action)**:
```java
public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC01SearchForm> formCtx =
        ValidationUtil.validateAndConvertRequest("11AC_W11AC01", W11AC01SearchForm.class, req, "search");
    formCtx.abortIfInvalid();
    SqlResultSet searchResult = component.selectByCondition(searchCondition);
    ctx.setRequestScopedVar("searchResult", searchResult);
    return new HttpResponse("/ss11AC/W11AC0101.jsp");
}
```

**JSP実装例 (W11AC0101.jsp)**:
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

**HTML出力例**:
```html
<form name="nablarch_form1">
  <table>
      <tr>
        <a name="showDetail_0" href="/action/ss11AC/W11AC01Action/RW11AC0103"
           onclick="return window.nablarch_submit(event, this);">U0001</a>
      </tr>
      <tr>
        <a name="showDetail_1" href="/action/ss11AC/W11AC01Action/RW11AC0103"
           onclick="return window.nablarch_submit(event, this);">U0002</a>
      </tr>
      <tr>
        <a name="showDetail_2" href="/action/ss11AC/W11AC01Action/RW11AC0103"
           onclick="return window.nablarch_submit(event, this);">U0003</a>
      </tr>
  </table>
  <input type="hidden" name="nablarch_hidden"
         value="nablarch_hidden_submit_showDetail_0=11AC_W11AC01.loginId\=U0001|
                nablarch_hidden_submit_showDetail_1=11AC_W11AC01.loginId\=U0002|
                nablarch_hidden_submit_showDetail_2=11AC_W11AC01.loginId\=U0003" />
</form>
```

> **重要（nablarch_hiddenの仕組み）**: フォームには`nablarch_hidden`という隠しフィールドが自動生成される。`nablarch_hidden_submit_<name属性>`というプレフィックスを付けてリンク毎の変更パラメータが出力される。選択されたリンクの変更パラメータはフレームワークのハンドラによりリクエストに設定される。

U0002リンクをクリックした場合のリクエストパラメータ: `11AC_W11AC01.loginId=U0002`

別ウィンドウから元画面に値を設定したい場合はJavaScriptにより実現する。動的な値（入力データなど）の埋め込みを防ぐために外部ファイルに記述する。

**JavaScriptの実装例**（`/js/common.js` に配置）:

`setInputValueToOpener` 関数の使用上の制約:
- **単一入力項目のみサポート**: 本関数は単一入力項目への値設定のみサポートしており、複数項目への同時設定はできない。
- **name属性の一意性が前提**: 指定されたname属性が親ウィンドウ内で重複していないことを前提に処理する。

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

> **警告**: JavaScriptに対するエスケープ処理はフレームワークで未実装のため、scriptタグのボディやonclick属性などJavaScriptを記述する部分には、動的な値（入力データなど）を埋め込まないこと。

**JSPの実装例（郵便番号の検索結果をリンクで選択させる場合）**:

```jsp
<%-- 外部ファイルに記述したJavaScriptを読み込む。n:scriptタグはhtmlのheadタグ内に記述する。 --%>
<n:script type="text/javascript" src="/js/common.js" />

<%-- リクエストスコープに"resultSet"という名前で郵便番号の検索結果が設定されているものとする。
      name属性にプレフィックス＋郵便番号、onclick属性にJavaScript関数を指定する。--%>
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

**JSPの実装例（郵便番号の検索結果をボタンで選択させる場合）**:

```jsp
<%-- 外部ファイルに記述したJavaScriptを読み込む。n:scriptタグはhtmlのheadタグ内に記述する。 --%>
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

paramタグ, n:submitLink, n:param, paramName, nablarch_hidden, 一覧照会詳細遷移, 異なるパラメータ送信, W11AC01Action, ValidationUtil, setInputValueToOpener, window.opener, 別ウィンドウ値設定, JavaScript外部ファイル, n:a, n:button, JSP実装例, 郵便番号検索結果

</details>

## 二重サブミットの防止

データベースへのコミットを伴う画面では二重サブミットを防止する必要がある。

防止方法は以下の2種類を組み合わせて実施する:
- クライアント側での対策（リクエストの二重送信防止）
- サーバ側での対策（処理済リクエストの受信防止）

<details>
<summary>keywords</summary>

二重サブミット防止, リクエストの二重送信防止, 処理済リクエストの受信防止, howto_prevent_double_submission, DBコミット

</details>

## 入力画面と確認画面の共通化をサポートするカスタムタグ

入力画面と確認画面が1対1に対応する場合、表示用のJSPファイルを共通化できる。

<details>
<summary>keywords</summary>

入力画面, 確認画面, 共通化, カスタムタグ, JSPファイル共通化, common_page_support

</details>

## ブラウザのキャッシュ防止

ブラウザの戻るボタンが押されても前の画面を表示できないようにするには、`noCache` タグを使用する。

<details>
<summary>keywords</summary>

ブラウザのキャッシュ防止, noCacheタグ, noCache, 戻るボタン, 履歴戻り防止, howto_prevent_history_back

</details>
