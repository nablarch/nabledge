# Webアプリケーション基本

## taglibディレクティブの指定方法

JSPでカスタムタグを使用する場合、JSPの先頭でtaglibディレクティブを宣言し、指定したprefixを使ってカスタムタグを使用する。

```jsp
<?xml version="1.0" encoding="UTF-8" ?>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<n:form>
</n:form>
```

> **注意**: ログイン情報など、全ての取引で使用される情報はセッションで保持する。

`n:form`タグの`windowScopePrefixes`属性にプレフィックスを指定する。入力項目の`name`属性に同プレフィックスを付与することで、ウィンドウスコープに入力データが設定される。設定したデータはHTML出力時に`hidden`タグ（暗号化）として出力される。複数プレフィックスはカンマ区切りで指定可能。

**登録画面（W11AC0201.jsp）**:
```jsp
<n:form name="insert" windowScopePrefixes="W11AC02">
    <n:text name="W11AC02.systemAccount.userId" size="15" maxlength="10" />
    <n:text name="W11AC02.systemUser.kanjiName" size="65" maxlength="25" />
    <n:submit cssClass="buttons" type="button" name="confirm" value="確認"
              uri="/action/ss11AC/W11AC02Action/RW11AC0202" />
</n:form>
```

**登録確認画面（W11AC0202.jsp）** - `n:confirmationPage`タグで入力画面のJSPへフォワード:
```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<n:confirmationPage path="./W11AC0201.jsp" />
```

**Actionクラス（登録確認画面フォワード）** - ウィンドウスコープが自動的にデータを引き継ぐため、リクエストへの明示的なデータ設定は不要:
```java
public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
    return new HttpResponse("/ss11AC/W11AC0202.jsp");
}
```

ウィンドウスコープデータはhiddenタグ（暗号化）として出力される:
```html
<input type="hidden" name="nablarch_hidden" value="QkyNL4ld+4izNDC5" />
```

ウィンドウスコープを使用する場合のActionクラス実装ルール:

- **遷移先へのデータ引き継ぎはフレームワークが自動処理** — Actionクラスで入力データをセッションに明示的に設定する処理は不要。セッション方式と異なり、フレームワークが自動的にデータを引き継ぐ。
- **ウィンドウスコープのデータ使用時はバリデーション必須** — リクエストから直接取得したデータはString型のため型変換が必要。バリデーション実行後にフォームのプロパティからデータを取得すると、自動で型変換が行われる。

<details>
<summary>keywords</summary>

taglibディレクティブ, prefix宣言, カスタムタグ, JSP, uri指定, http://tis.co.jp/nablarch, windowScopePrefixes, n:form, n:confirmationPage, ウィンドウスコープ, hidden出力, 画面間データ引継ぎ, nablarch_hidden, Actionクラス実装, データ引き継ぎ, バリデーション, 型変換, フレームワーク自動処理, セッション

</details>

## URIの指定方法

カスタムタグでURIを指定する方法は次の2種類ある。

- 絶対URLによる指定
- コンテキストルートからの相対パスによる指定

実装例では以下のフォルダ構成を想定する。

```
web（コンテキストルート）
 +-img
 |  +-header_bar.jpg
 |  +-sample.jpg
 +-app_header.jsp
 +-sample
    +-sample001.jsp
    +-sample002.jsp
```

windowScopePrefixes属性に指定した複数プレフィックスを使い分けることで、特定データだけを複数画面で引き継ぐことができる。

**遷移フロー**: 一覧照会画面（照会後）→ 更新画面 → 更新確認画面 → 更新完了画面

| 遷移 | 引き継がれるデータ（プレフィックス） |
|---|---|
| 一覧照会 → 更新画面 | 検索条件（11AC_W11AC01）、更新対象プライマリキー（W11AC03） |
| 更新画面 → 更新確認画面 | 検索条件（11AC_W11AC01）、プライマリキー＋更新データ（W11AC03） |
| 更新確認画面 → 更新完了画面 | 検索条件（11AC_W11AC01）のみ |

**一覧照会画面JSP** - `n:param`タグで更新対象プライマリキーをサブミット:
```jsp
<n:form>
    <n:text name="11AC_W11AC01.loginId" size="25" maxlength="20" />
    <n:text name="11AC_W11AC01.kanjiName" size="25" maxlength="20" />
    <n:listSearchResult listSearchInfoName="11AC_W11AC01"
                        searchUri="/action/ss11AC/W11AC01Action/RW11AC0102"
                        resultSetName="searchResult" resultSetCss="resultList">
        <jsp:attribute name="bodyRowFragment">
            <td><n:submitLink uri="/action/ss11AC/W11AC03Action/RW11AC0301" name="showUpdate_${count}">
                更新
                <n:param paramName="W11AC03.systemAccount.userId" name="row.userId" />
            </n:submitLink></td>
        </jsp:attribute>
    </n:listSearchResult>
</n:form>
```

**Actionクラス（更新画面への遷移）** - プライマリキーで検索し、Formをリクエストスコープに設定:
```java
public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> userSearchFormContext =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
    String userId = userSearchFormContext.createObject().getSystemAccount().getUserId();
    CM311AC1Component comp = new CM311AC1Component();
    SqlResultSet sysAcct = comp.selectSystemAccount(userId);
    SqlResultSet users = comp.selectUsers(userId);
    SqlResultSet permissionUnit = comp.selectPermissionUnit(userId);
    SqlResultSet ugroup = comp.selectUgroup(userId);
    W11AC03Form form = getWindowScopeObject(sysAcct, users, permissionUnit, ugroup);
    ctx.setRequestScopedVar("W11AC03", form);
    return new HttpResponse("/ss11AC/W11AC0301.jsp");
}
```

**更新画面JSP** - `windowScopePrefixes="11AC_W11AC01,W11AC03"`で一覧照会画面から検索条件とプライマリキーを引き継ぐ:
```jsp
<n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
    <n:write  name="W11AC03.systemAccount.loginId" />
    <n:hidden name="W11AC03.systemAccount.loginId" />
    <n:text name="W11AC03.users.kanjiName" size="52" maxlength="50" />
    <n:submit cssClass="buttons" type="button" name="update" value="確認"
              uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
</n:form>
```

**Actionクラス（更新確認画面へのフォワード）** - ウィンドウスコープが自動的にプライマリキーと更新データを引き継ぐため、明示的なリクエスト設定は不要:
```java
public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> formContext =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
    return new HttpResponse("/ss11AC/W11AC0302.jsp");
}
```

**更新確認画面JSP** - `n:confirmationPage`で入力画面と同じ記述で確認項目出力:
```jsp
<n:confirmationPage />
<n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
    <n:write  name="W11AC03.systemAccount.loginId"/>
    <n:hidden name="W11AC03.systemAccount.loginId" />
    <n:text name="W11AC03.users.kanjiName" size="52" maxlength="50" />
    <n:submit cssClass="buttons" type="button" name="confirm" value="確定"
              uri="/action/ss11AC/W11AC03Action/RW11AC0304" allowDoubleSubmission="false" />
</n:form>
```

**Actionクラス（更新完了画面への遷移）** - `updateUser`グループでバリデーション後、`createObject()`で`W11AC03Form`を生成して更新完了画面へフォワード:
```java
public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> formContext =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
    W11AC03Form form = formContext.createObject();
    return new HttpResponse("/ss11AC/W11AC0303.jsp");
}
```

**更新完了画面JSP** - 検索条件（11AC_W11AC01）のみ引き継ぎ、一覧照会画面へ遷移時に引き継いだ条件で検索実行:
```jsp
<n:form windowScopePrefixes="11AC_W11AC01">
    <n:write name="W11AC03.systemAccount.loginId"/>
    <n:write name="W11AC03.user.kanjiName"/>
    <n:submit cssClass="buttons" type="button" name="search" value="一覧照会画面へ"
              uri="/action/ss11AC/W11AC01Action/RW11AC0102"/>
</n:form>
```

更新確認画面→更新完了画面のウィンドウスコープ引き継ぎ実装例。

**JSP実装例（更新確認画面）**:

```jsp
<n:confirmationPage />
<n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
    <n:write name="W11AC03.user.userId"/>
    <n:text name="W11AC03.user.kanjiName" size="65" maxlength="25" />
    <n:submit cssClass="mainBtn" type="button" name="confirm" value="確定" uri="/action/ss11AC/W11AC03Action/RW11AC0304" />
</n:form>
```

- `<n:confirmationPage />`: 入力画面（更新画面）と同じ記述で確認項目を出力可能
- `windowScopePrefixes="11AC_W11AC01,W11AC03"`: 検索条件（11AC_W11AC01）と更新情報（W11AC03）の両方を完了画面に引き継ぐ

**JSP実装例（更新完了画面）**:

```jsp
<n:form windowScopePrefixes="11AC_W11AC01">
    <n:submit cssClass="mainBtn" type="submit" name="refer" uri="/action/ss11AC/W11AC01Action/RW11AC0102" value="一覧照会画面へ" />
</n:form>
```

**Actionクラス実装例**:

```java
public class W11AC03Action {
  public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> formCtx =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
    if (!formContext.isValid()) {
        throw new ApplicationException(formContext.getMessages());
    }
    W11AC03Form form = formCtx.createObject();
  }
}
```

- `ValidationUtil.validateAndConvertRequest`: リクエストのバリデーションと型変換を一括処理
- `formCtx.createObject()`: 型変換済みのプロパティが設定されたフォームインスタンスを生成
- 検索条件（11AC_W11AC01）の処理をActionクラスに記述しなくても、フレームワークが完了画面に自動で引き継ぐ

<details>
<summary>keywords</summary>

URI指定方法, 絶対URL, コンテキストルート相対パス, n:a, n:img, windowScopePrefixes, 複数画面遷移, ウィンドウスコープ, n:param, n:submitLink, n:listSearchResult, ValidationUtil, 検索条件引継ぎ, ValidationContext, W11AC03Form, CM311AC1Component, SqlResultSet, W11AC03Action, confirmationPage, n:form, validateAndConvertRequest, createObject, ApplicationException, 更新確認画面, 更新完了画面, HttpResponse, HttpRequest, ExecutionContext, n:write, n:text, n:submit

</details>

## 絶対URLによる指定

http又はhttpsから始まるパスが**絶対URL**である。この指定方法では、パスがそのままURIとして使用される。

```jsp
<%-- URIの指定以外は省略 --%>
<n:a href="http://www.tis.co.jp/">tis</n:a>
```

上の実装で指定されるURIは以下になる。

```
http://www.tis.co.jp
```

`<n:set>` タグを使用してJSP上のリクエストスコープに変数を設定する方法。

```html
<%-- 値を直接設定 --%>
<n:set var="title" value="ユーザ情報登録" />
<jsp:include page="/html_header.jsp">
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<%-- スコープ上のオブジェクトを参照して設定 --%>
<n:set var="officeLocation" name="W11AC02.systemUser.officeLocation"/>
<c:if test="${officeLocation == ''}">
</c:if>
```

- `var` 属性: 変数名
- `value` 属性: 値を直接設定する場合に使用
- `name` 属性: スコープ上のオブジェクトを参照して値を設定する場合に使用（スコープ上のキーを指定）
- 変数参照時はEL式（`${title}`）を使用可能
- `<c:if>`: 変数の値に応じた条件分岐に使用

<details>
<summary>keywords</summary>

絶対URL, http, https, n:a, URI指定, n:set, 変数設定, リクエストスコープ, value属性, name属性, EL式, c:if

</details>

## コンテキストルートからの相対パスによる指定

/（スラッシュ）から始まるパスが**コンテキストルートからの相対パス**である。この指定方法では、先頭にコンテキストルートのパスが付加されてURIとして使用される。

```jsp
<%-- URIの指定以外は省略 --%>
<n:img src="/img/header_bar.jpg" alt="header" />
```

上の実装で指定されるURIは以下になる。

```
<コンテキストルートのパス>/img/header_bar.jpg
```

<details>
<summary>keywords</summary>

コンテキストルート, 相対パス, スラッシュ, n:img, URI指定

</details>

## HTTPとHTTPSの切り替え

コンテキストルートからの相対パスでURIを指定しながらプロトコルを**切り替える**場合、カスタムタグのsecure属性を指定する。secure属性使用時はhttp用・https用のポート番号とホストの設定が必要。

> **注意**: secure属性はhttp→httpsまたはhttps→httpのプロトコル切り替え時のみ指定する。切り替えない（http→http、https→https）場合は指定しない。

```jsp
<%-- secure="true": http→https、secure="false": https→http --%>
<n:img src="/img/sample.jpg" alt="sample" secure="true" />
```

出力例（ホスト名:localhost、http:8080、https:443 の設定時）:

```
# secure="true"の場合
https://localhost:443/img/sample.jpg
# secure="false"の場合
http://localhost:8080/img/sample.jpg
```

<details>
<summary>keywords</summary>

secure属性, HTTPSプロトコル切り替え, http→https, https→http, ポート番号, n:img

</details>

## JSPとActionクラスの間でデータを受け渡す方法

JSPとActionクラスの間でデータを受け渡す場合、カスタムタグのname属性を使用する。この指定法により、データがどのスコープまたはパラメータに設定されているかを意識せずに使用できる。

受け渡し方法は次の2種類ある。

- Map型/フォームのプロパティを受け渡す場合
- List型/配列の要素のプロパティを受け渡す場合

<details>
<summary>keywords</summary>

name属性, データ受け渡し, リクエストスコープ, JSP, Actionクラス

</details>

## Map型/フォームのプロパティを受け渡す場合

JSPとActionクラスの間でMap型またはフォームのプロパティを受け渡す場合、カスタムタグのname属性に次の形式で値を指定する。

```
<リクエストスコープ上に設定したオブジェクトの変数名>.<プロパティ名>
```

```java
// Action: リクエストスコープに設定
ctx.setRequestScopedVar("W11AC03", userInfo.get(0));
```

```jsp
<n:text name="W11AC03.kanjiName" />
<n:submit cssClass="mainBtn" type="button" name="confirm" value="確認" uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
```

```java
// 受信Action: バリデーション
ValidationContext<W11AC03Form> formCtx =
    ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
if (!formCtx.isValid()) {
    throw new ApplicationException(formCtx.getMessages());
}
W11AC03Form form = formCtx.createObject();
```

<details>
<summary>keywords</summary>

Map型, フォームプロパティ, name属性, リクエストスコープ, ValidationUtil, validateAndConvertRequest, ValidationContext, ApplicationException, setRequestScopedVar

</details>

## List型/配列の要素のプロパティを受け渡す場合

JSPとActionクラスの間でList型または配列の要素のプロパティを受け渡す場合、カスタムタグのname属性に次の形式で値を指定する。

```
<リクエストスコープ上に設定したオブジェクトの変数名>[index].<プロパティ名>
```

```jsp
<c:forEach begin="0" end="${W11AC03.userEmailAddressArraySize}" var="index">
  <n:text name="W11AC03.userEmailAddressArray[${index}].emailAddress" />
</c:forEach>
<%-- 任意長配列の場合は配列長もサブミットが必要 --%>
<n:hidden name="W11AC03.userEmailAddressArraySize" />
```

```java
// 受信Action: バリデーション
ValidationContext<W11AC03Form> formCtx =
    ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
if (!formCtx.isValid()) {
    throw new ApplicationException(formCtx.getMessages());
}
W11AC03Form form = formCtx.createObject();
```

> **重要**: フォームのプロパティが任意長配列の場合、入力画面で配列長をサブミットする必要がある。

<details>
<summary>keywords</summary>

List型, 配列, index, name属性, c:forEach, n:hidden, 任意長配列, ValidationUtil, ValidationContext, ApplicationException

</details>
