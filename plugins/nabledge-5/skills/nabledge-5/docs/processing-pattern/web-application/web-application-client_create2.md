# 登録内容の確認

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/client_create/client_create2.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/interceptor/InjectForm.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnError.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Required.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionUtil.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html)

## 登録確認処理の実装（フォーム・バリデーション・セッション・確認画面）

## 登録確認処理の実装

### ClientFormクラスの作成

**クラス**: `ClientForm`

- フォームクラスには必ずセッタ及びゲッタを作成する
- `@InjectForm` でバリデーションを実行するためにフォームは `Serializable` インタフェースを実装する
- 入力値を受け付けるプロパティは全てString型で宣言する（詳細は [bean_validation-form_property](../../component/libraries/libraries-bean_validation.md) 参照）

```java
package com.nablarch.example.app.web.form;

public class ClientForm implements Serializable {
    private String clientName;
    private String industryCode;
    // getter、setterは省略
}
```

### JSPの設定

- [tag-text_tag](../../component/libraries/libraries-tag_reference.md)、[tag-select_tag](../../component/libraries/libraries-tag_reference.md) の `name` 属性にフォームのプロパティ名を指定する（指定方法は :ref:`tag-access_rule` 参照）
- 入力エラー発生時のCSSクラスを `errorCss` 属性で指定する
- [tag-button_tag](../../component/libraries/libraries-tag_reference.md) の `uri` 属性に確認画面への遷移URIを指定する（指定方法は :ref:`tag-specify_uri` 参照）
- `<n:error>` タグでエラーメッセージ表示領域を追加する

```jsp
<n:text name="form.clientName"
        cssClass="form-control input-text" errorCss="form-control input-error" />
<n:error errorCss="message-error" name="form.clientName" />
<n:select
        listName="industries"
        elementValueProperty="industryCode"
        elementLabelProperty="industryName"
        name="form.industryCode"
        withNoneOption="true"
        cssClass="btn dropdown-toggle"
        errorCss="btn dropdown-toggle input-error" />
<n:error errorCss="message-error" name="form.industryCode" />
<n:button uri="/action/client/confirm" cssClass="btn btn-raised btn-success">登録</n:button>
```

### バリデーションルールの設定

[bean_validation](../../component/libraries/libraries-bean_validation.md) を使用。`nablarch.core.validation.ee` 配下のアノテーションを使用する（`nablarch.core.validation.validator` 配下に同名アノテーションが存在する場合があるため注意）。

```java
@Required
@Domain("clientName")
private String clientName;

@Required(message = "{nablarch.core.validation.ee.Required.select.message}")
@Domain("industryCode")
private String industryCode;
```

- [ドメインバリデーション](../../component/libraries/libraries-bean_validation.md) でプロパティにバリデーションルールを定義する
- プルダウン等、対象項目に適したメッセージを表示するには `Required` の `message` 属性に独自定義のメッセージを指定する（詳細は [message-property_definition](../../component/libraries/libraries-message.md) 参照）

```properties
nablarch.core.validation.ee.Required.select.message=選択してください。
```

### confirmメソッドの実装（バリデーション設定）

**アノテーション**: `@InjectForm`, `@OnError`

```java
@InjectForm(form = ClientForm.class, prefix = "form")
@OnError(type = ApplicationException.class, path = "forward://input")
public HttpResponse confirm(HttpRequest request, ExecutionContext context) {
    ClientForm form = context.getRequestScopedVar("form");
    // ...
}
```

- 業務アクションメソッドに `InjectForm` を付与して [bean_validation](../../component/libraries/libraries-bean_validation.md) を実行する
- `OnError` の `path` 属性でバリデーションエラー時に inputメソッドへ内部フォーワードするよう設定する（登録画面再表示には業種リストの再設定が必要なため）
- バリデーションエラーがない場合、リクエストスコープからバリデーション済みオブジェクトを取得できる

### 登録確認画面の表示処理

:ref:`session_store` に顧客情報を保存して確認画面を表示する。

```java
@InjectForm(form = ClientForm.class, prefix = "form")
@OnError(type = ApplicationException.class, path = "forward://input")
public HttpResponse confirm(HttpRequest request, ExecutionContext context) {
    ClientForm form = context.getRequestScopedVar("form");

    Client client = BeanUtil.createAndCopy(Client.class, form);
    SessionUtil.put(context, "client", client);

    EntityList<Industry> industries = UniversalDao.findAll(Industry.class);
    context.setRequestScopedVar("industries", industries);

    return new HttpResponse("/WEB-INF/view/client/confirm.jsp");
}
```

- :ref:`セッションストア <session_store>` への保存は `SessionUtil` を使用する
- :ref:`セッションストアにフォームは格納しない <session_store-form>` ため、`BeanUtil` でフォームをエンティティに変換してからセッションストアに登録する
- 実装例の詳細は :ref:`create_example` 参照

### 登録確認画面のJSP

[tag-confirmation_page_tag](../../component/libraries/libraries-tag_reference.md) を使用することで、登録画面のJSPを流用して確認画面を作成できる（詳細は :ref:`tag-make_common` 参照）。

```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<n:confirmationPage path="./create.jsp" ></n:confirmationPage>
```

### 登録画面と確認画面の表示制御

- 登録画面のみで表示する項目は [tag-for_input_page_tag](../../component/libraries/libraries-tag_reference.md) の内部に記述する
- 確認画面でのみ表示する項目は [tag-for_confirmation_page_tag](../../component/libraries/libraries-tag_reference.md) の内部に記述する

```jsp
<div class="button-nav">
    <n:forInputPage>
        <n:button uri="/action/client/confirm" cssClass="btn btn-raised btn-success">登録</n:button>
    </n:forInputPage>
    <n:forConfirmationPage>
        <n:button uri="/action/client/back" cssClass="btn btn-raised btn-default">入力へ戻る</n:button>
        <n:button uri="/action/client/create" cssClass="btn btn-raised btn-success">確定</n:button>
    </n:forConfirmationPage>
</div>
```

<details>
<summary>keywords</summary>

ClientForm, ClientAction, HttpResponse, HttpRequest, ExecutionContext, Client, Industry, @InjectForm, @OnError, @Required, @Domain, InjectForm, OnError, SessionUtil, BeanUtil, ApplicationException, UniversalDao, EntityList, Serializable, 登録確認画面, Bean Validation, バリデーション, セッションストア, confirmationPage, forInputPage, forConfirmationPage, ドメインバリデーション

</details>
