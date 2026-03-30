# ウェブアプリケーション基本機能

## taglibディレクティブの指定方法

JSPでカスタムタグを使用する場合、JSPの先頭でtaglibディレクティブを宣言し、prefixを指定する。指定したprefixを使用してカスタムタグにアクセスする。

```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>

<n:form>
  <%-- フォーム内の処理は省略 --%>
</n:form>
```

ウィンドウスコープは、複数画面で引き継ぐデータをhiddenタグでクライアント側に保持する変数スコープ。入力データや更新対象データのプライマリキーなどに使用する。

> **注意**: ログイン情報など全取引で使用される情報はセッションで保持する。

`<n:form>` の `windowScopePrefixes` 属性にプレフィックスを指定する。入力項目の `name` 属性にそのプレフィックスを持つ値を設定すると、ウィンドウスコープに登録され、HTML出力時に暗号化された `<input type="hidden">` として出力される。複数プレフィックスはカンマ（`,`）区切りで指定する。

Actionクラスではウィンドウスコープのデータをリクエストに明示的に設定する必要はない。

**登録画面 JSP例（W11AC0201.jsp）**:
```jsp
<n:form name="insert" windowScopePrefixes="W11AC02">
    <n:text name="W11AC02.systemAccount.userId" size="15" maxlength="10" />
    <n:text name="W11AC02.systemUser.kanjiName" size="65" maxlength="25" />
    <n:submit cssClass="buttons" type="button" name="confirm" value="確認"
              uri="/action/ss11AC/W11AC02Action/RW11AC0202" />
</n:form>
```

**登録確認画面 JSP例（W11AC0202.jsp）**: `<n:confirmationPage>` タグで登録画面のJSPへフォワードする:
```jsp
<n:confirmationPage path="./W11AC0201.jsp" />
```

**Action実装例（W11AC02Action）**: 確認画面へフォワードするだけでよい（入力データをリクエストに設定する必要はない）:
```java
public class W11AC02Action {
    public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
        return new HttpResponse("/ss11AC/W11AC0202.jsp");
    }
}
```

**HTML出力例**: ウィンドウスコープのデータは暗号化されたhiddenとして出力される:
```html
<input type="hidden" name="nablarch_hidden" value="QkyNL4ld+4izNDC5" />
```

## アクションの実装方法

ウィンドウスコープ使用時のActionクラス実装における注意点:

- **遷移先画面へのデータ引き継ぎ処理をActionクラスで明示的に行わない。** フレームワークが自動的に処理する（セッション方式では明示的な設定が必要だが、ウィンドウスコープ方式では不要）。
- **ウィンドウスコープのデータを使用する場合はバリデーションを実行する。** リクエストから直接取得したデータはString型であり、型変換が必要となることがある。バリデーションを実行し、フォームのプロパティからデータを取得すると、自動で型変換が行われる。

### JSP実装例（更新確認画面→更新完了画面）

更新確認画面:
```jsp
<n:confirmationPage />
<n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
    <n:write name="W11AC03.user.userId"/>
    <n:text name="W11AC03.user.kanjiName" size="65" maxlength="25" />
    <n:submit cssClass="mainBtn" type="button" name="confirm" value="確定" uri="/action/ss11AC/W11AC03Action/RW11AC0304" />
</n:form>
```

更新完了画面:
```jsp
<n:form windowScopePrefixes="11AC_W11AC01">
    <n:submit cssClass="mainBtn" type="submit" name="refer" uri="/action/ss11AC/W11AC01Action/RW11AC0102" value="一覧照会画面へ" />
</n:form>
```

`windowScopePrefixes` に検索条件（`11AC_W11AC01`）と更新情報（`W11AC03`）の両方を指定することで、完了画面でどちらの値も引き継げる。

### Actionクラス実装例

```java
public class W11AC03Action {
  public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
    // 検索条件(11AC_W11AC01)を明示的に処理しなくても、更新完了画面に引き継がれる

    // 更新情報のバリデーション
    ValidationContext<W11AC03Form> formCtx =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");

    // バリデーションエラーがあれば例外を返す
    formCtx.abortIfInvalid();

    // 自動で型変換された更新情報がプロパティに設定されたインスタンスを生成
    W11AC03Form form = formCtx.createObject();
  }
}
```

<details>
<summary>keywords</summary>

taglibディレクティブ, カスタムタグ, prefix宣言, JSP, uri="http://tis.co.jp/nablarch", windowScopePrefixes, n:form, n:confirmationPage, ウィンドウスコープ, 複数画面データ引き継ぎ, hiddenタグ暗号化, nablarch_hidden, W11AC02Action, W11AC03Action, ValidationContext, ValidationUtil, validateAndConvertRequest, データ引き継ぎ, バリデーション, 型変換, HttpResponse, HttpRequest, ExecutionContext, W11AC03Form

</details>

## URIの指定方法 - 絶対URLによる指定

カスタムタグでURIを絶対URLで指定する場合、`http`または`https`から始まるパスを使用する。この指定方法では、パスがそのままURIとして使用される。

```jsp
<%-- URIの指定以外は省略 --%>
<n:a href="http://www.tis.co.jp/">tis</n:a>
```

上の実装で指定されるURIは以下になる。

```
http://www.tis.co.jp
```

`windowScopePrefixes` 属性に複数のプレフィックスを指定して使い分けることで、特定のデータだけを特定の画面に引き継ぐことができる。

**遷移例**: 一覧照会画面（照会後）→ 更新画面 → 更新確認画面 → 更新完了画面

ページング時の検索条件を維持するため、検索条件フォームと検索結果一覧フォームを別のフォームに分ける。

**一覧照会画面 JSP例**: 検索条件フォーム（`windowScopePrefixes="11AC_W11AC01"`）と検索結果一覧フォームに分け、`<n:param>` タグで更新対象のプライマリキーを更新画面にサブミットする:
```jsp
<n:form windowScopePrefixes="11AC_W11AC01">
    <n:text name="11AC_W11AC01.loginId" size="25" maxlength="20" />
    <n:text name="11AC_W11AC01.kanjiName" size="25" maxlength="20" />
</n:form>

<n:form windowScopePrefixes="11AC_W11AC01">
    <nbs:listSearchResult listSearchInfoName="11AC_W11AC01"
                          searchUri="/action/ss11AC/W11AC01Action/RW11AC0102" ...>
        <n:submitLink uri="/action/ss11AC/W11AC03Action/RW11AC0301" name="showUpdate_${count}">
            更新
            <n:param paramName="W11AC03.systemAccount.userId" name="row.userId" />
        </n:submitLink>
    </nbs:listSearchResult>
</n:form>
```

**更新画面遷移 Action例**: プライマリキーでデータを検索し、FormをリクエストスコープにセットしてJSPへ遷移する:
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

**更新画面 JSP例**: `windowScopePrefixes="11AC_W11AC01,W11AC03"` で一覧照会画面から検索条件とプライマリキーを引き継ぎ、更新確認画面にも引き継ぐ。ログインIDは更新不可のため `<n:hidden>` でサブミット:
```jsp
<n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
    <n:write  name="W11AC03.systemAccount.loginId" />
    <n:hidden name="W11AC03.systemAccount.loginId" />
    <n:text name="W11AC03.users.kanjiName" size="52" maxlength="50" />
    <n:submit cssClass="buttons" type="button" name="update" value="確認"
              uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
</n:form>
```

**更新確認画面遷移 Action例**: 更新対象のプライマリキーと更新データ（プレフィックス `W11AC03`）はウィンドウスコープにより自動的に引き継がれる。明示的なリクエストへのデータ設定は不要:
```java
public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> formContext =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
    return new HttpResponse("/ss11AC/W11AC0302.jsp");
}
```

**更新確認画面 JSP例**: `<n:confirmationPage />` タグで入力画面（更新画面）と同じ記述で確認項目を出力できる。`windowScopePrefixes="11AC_W11AC01,W11AC03"` で引き継ぐが、更新完了画面には `11AC_W11AC01`（検索条件）のみ引き継ぐ:
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

**更新完了画面遷移 Action例**: 更新データをバリデーションし、`formContext.createObject()` でFormを生成して更新処理を行い、更新完了画面（`W11AC0303.jsp`）へ遷移する:
```java
public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> formContext =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
    W11AC03Form form = formContext.createObject();
    return new HttpResponse("/ss11AC/W11AC0303.jsp");
}
```

**更新完了画面 JSP例**: 更新確認画面から検索条件（`11AC_W11AC01`）のみ引き継ぎ、一覧照会画面への遷移時に以前の検索条件で検索を行う:
```jsp
<n:form windowScopePrefixes="11AC_W11AC01">
    <n:write name="W11AC03.systemAccount.loginId"/>
    <n:write name="W11AC03.user.kanjiName"/>
    <n:submit cssClass="buttons" type="button" name="search" value="一覧照会画面へ"
              uri="/action/ss11AC/W11AC01Action/RW11AC0102"/>
</n:form>
```

## JSP上で変数に値を設定する方法

`n:set` タグを使用してJSP上でリクエストスコープの変数に値を設定できる。

- **`value` 属性**: 値を直接設定する場合に使用する。
- **`name` 属性**: スコープ上のオブジェクトを参照して値を設定する場合に、スコープ上のキーを指定する。

### JSP実装例

```html
<!-- value属性で値を直接設定 -->
<n:set var="title" value="ユーザ情報登録" />
<jsp:include page="/html_header.jsp">
    <!-- EL式でパラメータ指定（値の出力でないためEL式使用可） -->
    <jsp:param name="title" value="${title}"/>
</jsp:include>

<!-- name属性でスコープ上のオブジェクトを参照して設定 -->
<n:set var="officeLocation" name="W11AC02.systemUser.officeLocation"/>
<c:if test="${officeLocation == ''}">
    <%-- W11AC02.systemUser.officeLocationの値が空文字の場合の処理 --%>
</c:if>
```

<details>
<summary>keywords</summary>

絶対URL, http, https, n:a, URIの指定方法, windowScopePrefixes, n:param, n:confirmationPage, ウィンドウスコープ複数プレフィックス, 検索条件引き継ぎ, ページング検索条件維持, 複数画面遷移, allowDoubleSubmission, n:submitLink, ValidationUtil, W11AC03Action, W11AC03Form, ValidationContext, SqlResultSet, CM311AC1Component, n:set, var, JSP変数設定, value属性, name属性, リクエストスコープ, スコープ上のオブジェクト参照

</details>

## URIの指定方法 - コンテキストルートからの相対パスによる指定

カスタムタグでURIをコンテキストルートからの相対パスで指定する場合、`/`（スラッシュ）から始まるパスを使用する。この指定方法では、先頭にコンテキストルートのパスが付加されてURIとして使用される。

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

コンテキストルートからの相対パス, スラッシュ, n:img, URIの指定方法

</details>

## URIの指定方法 - HTTPとHTTPSの切り替え

コンテキストルートからの相対パスでURIを指定しながらプロトコルを切り替える場合、カスタムタグの`secure`属性を指定する。また、http用・https用のポート番号とホストの設定が必要。

> **注意**: `secure`属性は http→https または https→http のプロトコル切り替え時のみ指定する。プロトコルを切り替えない（http→http または https→https）場合は指定しない。

```jsp
<%-- secure="true"でhttp→https、secure="false"でhttps→http --%>
<n:img src="/img/sample.jpg" alt="sample" secure="true" />
```

出力URI例（ホスト：localhost、http用ポート：8080、https用ポート：443の場合）：
- `secure="true"` → `https://localhost:443/img/sample.jpg`
- `secure="false"` → `http://localhost:8080/img/sample.jpg`

<details>
<summary>keywords</summary>

secure属性, HTTPSへの切り替え, プロトコル切り替え, n:img, URIの指定方法

</details>

## JSPとActionクラスの間でデータを受け渡す方法 - Map型/フォームのプロパティ

JSPとActionクラスの間でデータを受け渡す場合、以下の方法でname属性を指定すればよい。この指定法により、データがどのスコープ又はパラメータに設定されているかを意識せずに使用できる。

Map型またはフォームのプロパティを受け渡す場合、カスタムタグのname属性に次の形式で値を指定する。

```
<リクエストスコープ上に設定したオブジェクトの変数名>.<プロパティ名>
```

Actionクラスでリクエストスコープにデータを設定：

```java
public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> formCtx =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
    W11AC03Form form = formCtx.createObject();
    CM311AC1Component component = new CM311AC1Component();
    SqlResultSet userInfo = component.selectUsers(form);
    ctx.setRequestScopedVar("W11AC03", userInfo.get(0));
    return new HttpResponse("/ss11AC/W11AC0301.jsp");
}
```

JSPでname属性に`<変数名>.<プロパティ名>`形式で指定：

```jsp
<n:form>
  <n:text name="W11AC03.kanjiName" />
  <n:submit type="button" name="confirm" value="確認" uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
</n:form>
```

受け取り側ActionクラスでのバリデーションにはPrefix（"W11AC03"）を使用：

```java
public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> formCtx =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
    formCtx.abortIfInvalid();
    W11AC03Form form = formCtx.createObject();
}
```

<details>
<summary>keywords</summary>

JSPとActionクラス間のデータ受け渡し, Map型プロパティ, name属性, リクエストスコープ, ValidationUtil, ValidationContext, SqlResultSet, HttpResponse, CM311AC1Component, W11AC03Form, ExecutionContext, HttpRequest

</details>

## JSPとActionクラスの間でデータを受け渡す方法 - List型/配列の要素のプロパティ

JSPとActionクラスの間でList型または配列の要素のプロパティを受け渡す場合、カスタムタグのname属性に次の形式で値を指定する。

```
<リクエストスコープ上に設定したオブジェクトの変数名>[index].<プロパティ名>
```

Actionクラスでリクエストスコープにデータを設定：

```java
public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> formCtx =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
    W11AC03Form condition = formCtx.createObject();
    CM311AC1Component component = new CM311AC1Component();
    SqlResultSet emailAddressList = component.selecemailAddressList(condition);
    UserEmailAddressEntity[] emailAddressArray = new UserEmailAddressEntity[emailAddressList.size()];
    for (int i = 0; i < emailAddressList.size(); i++) {
        emailAddressArray[i].setEmailAddress(emailAddressList.get(i).getString("emailAddress"));
    }
    W11AC03Form form = new W11AC03Form();
    form.setUserEmailAddressArraySize(emailAddressArray.length);
    form.setUserEmailAddressArray(emailAddressArray);
    ctx.setRequestScopedVar("W11AC03", form);
    return new HttpResponse("/ss11AC/W11AC0301.jsp");
}
```

JSPでインデックス付きname属性で指定：

```jsp
<n:form>
  <c:forEach begin="0" end="${W11AC03.userEmailAddressArraySize}" var="index">
    <n:text name="W11AC03.userEmailAddressArray[${index}].emailAddress" />
  </c:forEach>
  <%-- フォームのプロパティが任意長配列の場合、配列長をサブミットする必要がある --%>
  <n:hidden name="W11AC03.userEmailAddressArraySize" />
  <n:submit type="button" name="update" value="確認" uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
</n:form>
```

受け取り側Actionクラスでのバリデーション：

```java
public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> formCtx =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
    formCtx.abortIfInvalid();
    W11AC03Form form = formCtx.createObject();
}
```

<details>
<summary>keywords</summary>

JSPとActionクラス間のデータ受け渡し, 配列プロパティ, List型, インデックス, name属性, ValidationUtil, ValidationContext, SqlResultSet, HttpResponse, UserEmailAddressEntity, CM311AC1Component, W11AC03Form, ExecutionContext, HttpRequest

</details>
