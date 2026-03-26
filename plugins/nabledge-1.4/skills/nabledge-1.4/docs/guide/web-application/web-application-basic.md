# Webアプリケーション（基本）

## taglibディレクティブの指定方法

JSPでカスタムタグを使用する場合、taglibディレクティブを指定する。JSPの先頭でprefixを宣言し、そのprefixを用いてカスタムタグを使用する。

```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>

<n:form>
  <%-- フォーム内の処理 --%>
</n:form>
```

ウィンドウスコープは、複数画面で引き継ぐデータ（入力データ、更新対象データのプライマリキーなど）をhiddenタグでクライアント側に保持する変数スコープ。

> **注意**: ログイン情報など、全ての取引で使用される情報はセッションで保持する。

`n:form`タグの`windowScopePrefixes`属性にプレフィックスを指定することでウィンドウスコープを使用できる。入力項目の`name`属性で使用したプレフィックスを指定すると、ウィンドウスコープに入力データが設定される。ウィンドウスコープに設定したデータはHTML出力時にhiddenで出力される（暗号化機能が使用される）。複数のプレフィックスを指定する場合はカンマ（,）で区切る。

**登録画面のJSP例**:
```jsp
<n:form name="insert" windowScopePrefixes="W11AC02">
    <n:text name="W11AC02.systemAccount.userId" size="15" maxlength="10" />
    <n:text name="W11AC02.systemUser.kanjiName" size="65" maxlength="25" />
    <n:submit type="button" name="confirm" value="確認"
              uri="/action/ss11AC/W11AC02Action/RW11AC0202" />
</n:form>
```

**登録確認画面のJSP例**（`n:confirmationPage`タグで入力画面のJSPにフォワード）:
```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<n:confirmationPage path="./W11AC0201.jsp" />
```

hidden出力例（ウィンドウスコープデータは暗号化されてhiddenに出力される）:
```html
<input type="hidden" name="nablarch_hidden" value="QkyNL4ld+4izNDC5" />
```

**Actionクラスの実装例**（登録確認画面へのフォワード。入力データを明示的にリクエストに設定しなくてもウィンドウスコープで自動引き継ぎされる）:
```java
public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
    return new HttpResponse("/ss11AC/W11AC0202.jsp");
}
```

`n:set`タグでJSP上のリクエストスコープ変数に値を設定できる。

- `value`属性: 値を直接設定する場合に使用する
- `name`属性: スコープ上のオブジェクトをキーで参照して値を設定する場合、スコープ上のキーを指定する
- 設定した変数はEL式でパラメータとして渡せる（値の出力ではないためEL式使用可）

```html
<%-- value属性で直接設定 --%>
<n:set var="title" value="ユーザ情報登録" />
<jsp:param name="title" value="${title}"/>

<%-- name属性でスコープ上のオブジェクトを参照して設定 --%>
<n:set var="officeLocation" name="W11AC02.systemUser.officeLocation"/>
```

<details>
<summary>keywords</summary>

taglibディレクティブ, prefix宣言, カスタムタグ, JSP実装, uri=http://tis.co.jp/nablarch, n:form, ウィンドウスコープ, windowScopePrefixes, 複数画面データ引き継ぎ, hiddenタグ暗号化, confirmationPage, n:hidden, ValidationUtil, ValidationContext, 画面遷移スコープ管理, W11AC02Action, HttpResponse, HttpRequest, ExecutionContext, n:setタグ, JSP変数設定, リクエストスコープ変数, value属性, name属性, EL式, 変数参照

</details>

## URIの指定方法

カスタムタグでURIを指定する方法は2種類ある。

### 絶対URLによる指定

httpまたはhttpsから始まるパス。パスがそのままURIとして使用される。

```jsp
<n:a href="http://www.tis.co.jp/">tis</n:a>
```

出力URI: `http://www.tis.co.jp`

### コンテキストルートからの相対パスによる指定

`/`（スラッシュ）から始まるパス。先頭にコンテキストルートのパスが付加されてURIとして使用される。

```jsp
<n:img src="/img/header_bar.jpg" alt="header" />
```

出力URI: `<コンテキストルートのパス>/img/header_bar.jpg`

### HTTPとHTTPSの切り替え

コンテキストルートからの相対パスでプロトコルを切り替える場合、カスタムタグのsecure属性を指定する。httpとhttps用のポート番号とホストを設定する必要がある。

> **注意**: secure属性はhttp→httpsまたはhttps→httpのプロトコル切り替え時のみ指定する。同一プロトコル（http→http、https→https）の場合は指定しない。

```jsp
<%-- secure="true"でhttp→https、secure="false"でhttps→http --%>
<n:img src="/img/sample.jpg" alt="sample" secure="true" />
```

```
# secure="true"の場合
https://localhost:443/img/sample.jpg

# secure="false"の場合
http://localhost:8080/img/sample.jpg
```

`windowScopePrefixes`属性に複数のプレフィックスを指定して使い分けることで、特定のデータだけを複数画面で引き継ぐことができる。

**遷移例**: 一覧照会画面（照会後）→更新画面→更新確認画面→更新完了画面

| 画面 | windowScopePrefixes | 引き継ぐデータ |
|---|---|---|
| 一覧照会画面 | `11AC_W11AC01` | 検索条件 |
| 更新画面 | `11AC_W11AC01,W11AC03` | 検索条件 + プライマリキー・更新データ |
| 更新確認画面 | `11AC_W11AC01,W11AC03` | 検索条件 + プライマリキー・更新データ |
| 更新完了画面 | `11AC_W11AC01` | 検索条件のみ（一覧照会画面へ戻るため） |

**一覧照会画面のJSP例**（`n:param`タグでプライマリキーをサブミット）:

> **設計上の注意**: ページング時の検索条件は前回検索時の条件を使用する。ウィンドウスコープを使用して前回検索時の条件を維持するため、検索条件フォームと検索結果一覧フォームを別々に分けて実装する。これが一覧照会画面で複数の`n:form`タグが必要な理由である。

```jsp
<n:form windowScopePrefixes="11AC_W11AC01">
    <n:text name="11AC_W11AC01.loginId" size="25" maxlength="20" />
    <n:text name="11AC_W11AC01.kanjiName" size="25" maxlength="20" />
</n:form>

<n:form windowScopePrefixes="11AC_W11AC01">
    <n:submitLink uri="/action/ss11AC/W11AC03Action/RW11AC0301" name="showUpdate_${count}">
        更新
        <n:param paramName="W11AC03.systemAccount.userId" name="row.userId" />
    </n:submitLink>
</n:form>
```

**Actionクラスの実装例**（一覧照会画面→更新画面: `doRW11AC0301`）:
```java
public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
    // プライマリキーの精査
    ValidationContext<W11AC03Form> userSearchFormContext =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
    // プライマリキーの取得
    String userId = userSearchFormContext.createObject().getSystemAccount().getUserId();

    // プライマリキーで検索を行い、更新対象のデータを取得
    CM311AC1Component comp = new CM311AC1Component();
    SqlResultSet sysAcct = comp.selectSystemAccount(userId);
    SqlResultSet users = comp.selectUsers(userId);
    SqlResultSet permissionUnit = comp.selectPermissionUnit(userId);
    SqlResultSet ugroup = comp.selectUgroup(userId);

    // 検索結果からFormを生成し、"W11AC03"という名前でリクエストスコープに設定して更新画面へ遷移
    W11AC03Form form = getWindowScopeObject(sysAcct, users, permissionUnit, ugroup);
    ctx.setRequestScopedVar("W11AC03", form);
    return new HttpResponse("/ss11AC/W11AC0301.jsp");
}
```

> **ポイント**: 更新画面への初回遷移時、更新対象データはリクエストスコープに明示的にセットする（`ctx.setRequestScopedVar`）。以降の画面遷移ではウィンドウスコープが自動的にデータを引き継ぐ。

**更新画面のJSP例**（表示のみ項目は`n:hidden`でサブミット）:
```jsp
<n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
    <n:write  name="W11AC03.systemAccount.loginId" />
    <n:hidden name="W11AC03.systemAccount.loginId" />
    <n:text name="W11AC03.users.kanjiName" size="52" maxlength="50" />
    <n:submit type="button" name="update" value="確認" uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
</n:form>
```

**Actionクラスの実装例**（更新画面→更新確認画面: `doRW11AC0302`）:
```java
public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
    // 更新画面で入力したデータに対するバリデーション
    ValidationContext<W11AC03Form> formContext =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
    // 更新対象のプライマリキーと更新データ（ともにプレフィックスがW11AC03）は、
    // ウィンドウスコープにより自動的に更新確認画面へ引き継がれる。明示的にリクエストにデータを設定する必要は無い。
    return new HttpResponse("/ss11AC/W11AC0302.jsp");
}
```

**更新確認画面のJSP例**（`n:confirmationPage`で入力画面と同じ記述で確認項目出力）:
```jsp
<n:confirmationPage />
<n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
    <n:write  name="W11AC03.systemAccount.loginId"/>
    <n:hidden name="W11AC03.systemAccount.loginId" />
    <n:text name="W11AC03.users.kanjiName" size="52" maxlength="50" />
    <n:submit type="button" name="confirm" value="確定"
              uri="/action/ss11AC/W11AC03Action/RW11AC0304" allowDoubleSubmission="false" />
</n:form>
```

**更新完了画面のJSP例**（検索条件のみを引き継ぐ）:
```jsp
<n:form windowScopePrefixes="11AC_W11AC01">
    <n:write name="W11AC03.systemAccount.loginId"/>
    <n:write name="W11AC03.user.kanjiName"/>
    <n:submit type="button" name="search" value="一覧照会画面へ"
              uri="/action/ss11AC/W11AC01Action/RW11AC0102"/>
</n:form>
```

<details>
<summary>keywords</summary>

URIの指定, 絶対URL, コンテキストルートからの相対パス, secure属性, プロトコル切り替え, HTTPS切り替え, n:img, n:a, ウィンドウスコープ, windowScopePrefixes, 複数画面遷移, n:param, n:submitLink, ValidationUtil, ValidationContext, SqlResultSet, CM311AC1Component, getWindowScopeObject, setRequestScopedVar, 一覧照会画面, 更新画面, 更新確認画面, 更新完了画面, W11AC03Form, W11AC03Action, HttpResponse, HttpRequest, ExecutionContext

</details>

## JSPとActionクラスの間でデータを受け渡す方法

JSPとActionクラスの間でデータを受け渡す場合、カスタムタグのname属性に以下の形式で値を指定する。この指定方法により、データがどのスコープまたはパラメータに設定されているかを意識せずに使用できる。

### Map型/フォームのプロパティを受け渡す場合

```
<リクエストスコープ上に設定したオブジェクトの変数名>.<プロパティ名>
```

**Actionクラス（JSPへデータを渡す）**:
```java
ctx.setRequestScopedVar("W11AC03", userInfo.get(0));
return new HttpResponse("/ss11AC/W11AC0301.jsp");
```

**JSP（name属性の指定例）**:
```jsp
<n:text name="W11AC03.kanjiName" />
<n:submit cssClass="mainBtn" type="button" name="confirm" value="確認"
    uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
```

**Actionクラス（JSPからデータを受け取る）**:
```java
ValidationContext<W11AC03Form> formCtx =
    ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
formCtx.abortIfInvalid();
W11AC03Form form = formCtx.createObject();
```

### List型/配列の要素のプロパティを受け渡す場合

```
<リクエストスコープ上に設定したオブジェクトの変数名>[index].<プロパティ名>
```

**Actionクラス（JSPへデータを渡す）**:
```java
SqlResultSet emailAddressList = component.selecemailAddressList(condition);

UserEmailAddressEntity[] emailAddressArray = new UserEmailAddressEntity[emailAddressList.size()];
for (int i = 0; i < emailAddressList.size(); i++) {
    emailAddressArray[i].setEmailAddress(emailAddressList.get(i).getString("emailAddress"));
}

W11AC03Form form = new W11AC03Form();
form.setUserEmailAddressArraySize(emailAddressArray.length);
form.setUserEmailAddressArray(emailAddressArray);
ctx.setRequestScopedVar("W11AC03", form);
```

**JSP（インデックスを使用した配列要素の指定例）**:
```jsp
<c:forEach begin="0" end="${W11AC03.userEmailAddressArraySize}" var="index">
  <n:text name="W11AC03.userEmailAddressArray[${index}].emailAddress" />
</c:forEach>
<%-- フォームのプロパティが任意長配列の場合、入力画面で配列長をサブミットする必要がある --%>
<n:hidden name="W11AC03.userEmailAddressArraySize" />
```

**Actionクラス（JSPからデータを受け取る）**:
```java
ValidationContext<W11AC03Form> formCtx =
    ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
formCtx.abortIfInvalid();
W11AC03Form form = formCtx.createObject();
```

ウィンドウスコープを使用する場合、以下のことに注意してActionクラスを実装すること。

- **遷移先へのデータ引き継ぎ処理をActionクラスで明示的に行わない**: ウィンドウスコープ方式ではフレームワークが自動的に入力データを引き継ぐ。セッションを使う方式と異なり、Actionクラスで入力データをセッションに明示的に設定する必要はない。
- **バリデーションを必ず行う**: Actionクラスでウィンドウスコープのデータを使用する場合はバリデーションを実施すること。バリデーション実行後にフォームのプロパティとしてデータを取得することで、String型からの自動型変換が行われる。

**Actionクラスの実装例**（更新確認画面→更新完了画面: `doRW11AC0304`。検索条件の処理を記述しなくても更新完了画面に自動引き継ぎされる）:
```java
public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
    // 検索条件(11AC_W11AC01)の処理を記述しなくても更新完了画面に引き継がれる

    // 更新情報のバリデーション
    ValidationContext<W11AC03Form> formCtx =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");

    formCtx.abortIfInvalid();

    // 自動で型変換された更新情報がプロパティに設定されている
    W11AC03Form form = formCtx.createObject();

    // 以下、W11AC03Formインスタンスを使用した更新処理
}
```

<details>
<summary>keywords</summary>

name属性, データ受け渡し, リクエストスコープ, Map型, List型, 配列index, JSPとActionクラス, 任意長配列, setRequestScopedVar, ValidationUtil, validateAndConvertRequest, ValidationContext, n:text, n:hidden, ウィンドウスコープ, Actionクラス実装, 型変換, データ引き継ぎ, abortIfInvalid, createObject, W11AC03Form, W11AC03Action, HttpResponse, HttpRequest, ExecutionContext

</details>
