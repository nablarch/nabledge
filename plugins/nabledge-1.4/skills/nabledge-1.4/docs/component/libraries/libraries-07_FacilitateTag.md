# 入力画面と確認画面の共通化をサポートするカスタムタグ

## 

入力画面と確認画面が1対1に対応する場合、共通化により確認画面JSPの作成工数を削減できる。マスタメンテナンス画面など、複雑な操作が要求されない画面を大量に、短期間で作成する場合は、この機能が活躍する。

実装の共通化は入力画面のJSPで行い、確認画面のJSPは入力画面のJSPにフォワードのみ行う。アクションは入力・確認それぞれ別JSPにフォワードしておくことで、仕様変更時のアクションへの影響を抑えられる。

確認画面のJSPは :ref:`WebView_ConfirmationPageTag` を使用してフォワードを行う。入力・確認画面のJSPは同じ場所に配置することが多いため、相対パスで指定できる。

```jsp
<%-- USER003.jspは入力画面のJSPとする。 --%>
<n:confirmationPage path="./USER003.jsp" />
```

<details>
<summary>keywords</summary>

WebView_ConfirmationPageTag, n:confirmationPage, 入力画面と確認画面の共通化, 確認画面JSP作成工数削減, confirmationPage相対パス指定

</details>

## 入力画面と確認画面の表示切り替え

入力画面と確認画面の表示切り替えには以下のタグを使用する。

| カスタムタグ | 説明 |
|---|---|
| :ref:`WebView_ForInputPageTag` | 入力画面のみボディを評価する |
| :ref:`WebView_ForConfirmationPageTag` | 確認画面のみボディを評価する |

<details>
<summary>keywords</summary>

WebView_ForInputPageTag, WebView_ForConfirmationPageTag, n:forInputPage, n:forConfirmationPage, 入力画面と確認画面の表示切り替え

</details>

## 

**パスワードの使用例**

入力画面では確認用の入力項目を2つ表示し、確認画面では一方だけ出力する。

![パスワード入力画面](../../../knowledge/component/libraries/assets/libraries-07_FacilitateTag/WebView_PasswordInput.jpg)

```jsp
<n:password name="systemAccount.newPassword" size="22" maxlength="20" />
<n:forInputPage>
  <br/>
  <n:password name="systemAccount.confirmPassword" size="22" maxlength="20" /><span class="dinstruct">(確認用)</span>
</n:forInputPage>
```

**携帯電話番号の使用例**

携帯電話番号は全て入力するかしないかの2択であり、確認画面では入力されていない場合にハイフンを表示させないように制御する。

![携帯電話番号入力画面](../../../knowledge/component/libraries/assets/libraries-07_FacilitateTag/WebView_MobileInput.jpg)

```jsp
<n:forInputPage>
    <n:text name="users.mobilePhoneNumberAreaCode" size="5" maxlength="3" />&nbsp;-&nbsp;
    <n:text name="users.mobilePhoneNumberCityCode" size="6" maxlength="4" />&nbsp;-&nbsp;
    <n:text name="users.mobilePhoneNumberSbscrCode" size="6" maxlength="4" />
</n:forInputPage>
<n:forConfirmationPage>
  <c:if test="${users.mobilePhoneNumberAreaCode != ''}">
    <n:text name="users.mobilePhoneNumberAreaCode" size="5" maxlength="3" />&nbsp;-&nbsp;
    <n:text name="users.mobilePhoneNumberCityCode" size="6" maxlength="4" />&nbsp;-&nbsp;
    <n:text name="users.mobilePhoneNumberSbscrCode" size="6" maxlength="4" />
  </c:if>
</n:forConfirmationPage>
```

**ボタンの使用例**

入力画面は確認ボタン、確認画面は登録画面へ戻るボタンと確定ボタンを表示する。

```jsp
<n:forInputPage> 
  <n:submit cssClass="buttons" type="button" name="confirm" value="確認" uri="/action/ss11AC/W11AC02Action/RW11AC0202"/> 
</n:forInputPage>
<n:forConfirmationPage> 
  <n:submit cssClass="buttons" type="button" name="back" value="登録画面へ" uri="/action/ss11AC/W11AC02Action/RW11AC0203"/>
  <n:submit cssClass="buttons" type="button" name="register" value="確定" uri="/action/ss11AC/W11AC02Action/RW11AC0204" allowDoubleSubmission="false"/>
</n:forConfirmationPage>
```

> **重要**: 上記タグで対応できない場合は入力画面と確認画面の差異が多く、この機能の使用に適していない可能性がある。その場合は無理に1つのJSPで作成しようとせずに、入力画面と確認画面のJSPを分けて開発すること。

<details>
<summary>keywords</summary>

n:forInputPage, n:forConfirmationPage, n:password, n:text, n:submit, allowDoubleSubmission, パスワード入力確認, 携帯電話番号入力, ボタン表示切り替え

</details>

## 確認画面での入力項目の表示

:ref:`WebView_ConfirmationPageTag` を使用した画面では、確認画面の場合にすべての入力項目のカスタムタグが確認用の出力を行う。そのため、全画面共通ヘッダに検索フォームを配置している場合、その検索フォームも確認用として出力される。

:ref:`WebView_IgnoreConfirmationTag` のボディに配置された入力項目のカスタムタグは常に入力項目として出力される。これにより画面内の一部分を常に入力項目として表示できる。

```jsp
<%-- ignoreConfirmationタグで囲まれた範囲のみ、常に入力項目として表示される。 --%>
<n:ignoreConfirmation>
<n:form>
  <n:text name="searchWords" />
  <n:submit type="button" uri="./CUSTOM00207" name="CUSTOM00207_submit" value="検索" />
</n:form>
</n:ignoreConfirmation>
```

<details>
<summary>keywords</summary>

WebView_IgnoreConfirmationTag, n:ignoreConfirmation, n:form, 共通ヘッダ検索フォーム, 確認画面での入力項目表示, ignoreConfirmation

</details>
