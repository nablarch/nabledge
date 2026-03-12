# 登録内容の確認

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/client_create/client_create2.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/interceptor/InjectForm.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnError.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Required.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionUtil.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html)

## 登録確認処理の実装

## フォームクラス

**クラス**: `ClientForm`

- フォームクラスには必ずセッタ及びゲッタを作成する
- `@InjectForm` を使用したバリデーション実行のため、フォームは `Serializable` インタフェースを実装する
- 入力値プロパティは全てString型で宣言する（[bean_validation-form_property](../../component/libraries/libraries-bean_validation.md) 参照）

```java
public class ClientForm implements Serializable {
    private String clientName;
    private String industryCode;
    // getter、setterは省略
}
```

## 登録画面JSPの修正

登録画面JSP（`/src/main/webapp/WEB-INF/view/client/create.jsp`）に以下の修正を行う：

- [tag-text_tag](../../component/libraries/libraries-tag_reference.md) の `name` 属性に顧客名プロパティ名を指定する（:ref:`tag-access_rule` 参照）
- [tag-select_tag](../../component/libraries/libraries-tag_reference.md) の `name` 属性に業種コードプロパティ名を指定する
- 各タグに `errorCss` 属性を追加して入力エラー時のCSSクラスを設定する
- [tag-button_tag](../../component/libraries/libraries-tag_reference.md) の `uri` 属性に確認画面へのURIを指定する（:ref:`tag-specify_uri` 参照）
- `n:error` タグで入力エラー時のエラーメッセージ表示領域を追加する

```jsp
<n:form>
    <div class="row m-3">
        <label class="col-md-2 col-form-label fs-5">顧客名</label>
        <div class="col-md-10 form-group">
            <n:text name="form.clientName"
                    cssClass="form-control form-control-lg" errorCss="input-error" />
                    <n:error errorCss="message-error mt-2" name="form.clientName" />
        </div>
    </div>
    <div class="row m-3">
        <label class="col-md-2 col-form-label fs-5">業種</label>
        <div class="col-md-10 form-group">
            <n:select
                    listName="industries"
                    elementValueProperty="industryCode"
                    elementLabelProperty="industryName"
                    name="form.industryCode"
                    withNoneOption="true"
                    cssClass="form-select form-select-lg"
                    errorCss="input-error" />
            <n:error errorCss="message-error mt-2" name="form.industryCode" />
        </div>
    </div>
    <div class="button-nav">
        <n:button
                uri="/action/client/confirm"
                cssClass="btn btn-lg btn-success">登録</n:button>
    </div>
</n:form>
```

## バリデーションルールの設定

**アノテーション**: `@Required`, `@Domain`

- [bean_validation](../../component/libraries/libraries-bean_validation.md) には `nablarch.core.validation.ee` 配下のアノテーションを使用する（`nablarch.core.validation.validator` 配下の同名アノテーションと混同しないこと）
- [ドメインバリデーション](../../component/libraries/libraries-bean_validation.md) でプロパティにバリデーションルールを定義する
- プルダウン等に適したメッセージは `Required` の `message` 属性で独自定義する

```java
@Required
@Domain("clientName")
private String clientName;

@Required(message = "{nablarch.core.validation.ee.Required.select.message}")
@Domain("industryCode")
private String industryCode;
```

プルダウン向けのメッセージは `messages.properties` に追加する：

```properties
# プルダウンに適した入力必須メッセージを追加する
nablarch.core.validation.ee.Required.select.message=選択してください。
```

メッセージ定義の詳細は [message-property_definition](../../component/libraries/libraries-message.md) を参照。

## confirmメソッドとバリデーション設定

**アノテーション**: `@InjectForm`, `@OnError`

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

- 業務アクションメソッドに `InjectForm` を付与して [bean_validation](../../component/libraries/libraries-bean_validation.md) を実行する
- `OnError` の `path` 属性でバリデーションエラー時のフォワード先を指定する（確認画面遷移前に業種リスト設定が必要なため、inputメソッドへ内部フォワードする）
- バリデーション通過後はリクエストスコープから `context.getRequestScopedVar("form")` でバリデーション済みオブジェクトを取得できる
- 登録画面の表示処理時と同様、業種情報をデータベースから取得してリクエストスコープに設定する
- :ref:`セッションストア <session_store>` への保存には `SessionUtil` を使用する
- :ref:`セッションストアにフォームは格納しない <session_store-form>` ため、`BeanUtil` でフォームをエンティティに変換してから格納する
- :ref:`セッションストア <session_store>` を使用する際の詳しい実装例は :ref:`create_example` を参照

## 確認画面JSP

**ファイル**: `/src/main/webapp/WEB-INF/view/client/confirm.jsp`

[tag-confirmation_page_tag](../../component/libraries/libraries-tag_reference.md) を使用することで登録画面のJSPを流用して確認画面を作成できる（:ref:`tag-make_common` 参照）。

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<n:confirmationPage path="./create.jsp" ></n:confirmationPage>
```

## 登録画面・確認画面の表示切り替え

- 登録画面のみで表示する項目は [tag-for_input_page_tag](../../component/libraries/libraries-tag_reference.md) の内部に記述する
- 確認画面のみで表示する項目は [tag-for_confirmation_page_tag](../../component/libraries/libraries-tag_reference.md) の内部に記述する

```jsp
<n:forInputPage>
    <n:button uri="/action/client/confirm">登録</n:button>
</n:forInputPage>
<n:forConfirmationPage>
    <n:button uri="/action/client/back">入力へ戻る</n:button>
    <n:button uri="/action/client/create">確定</n:button>
</n:forConfirmationPage>
```

## 動作確認

**バリデーションエラーが発生しないケース**

1. 顧客登録画面を表示する
2. 顧客名に全角文字列、業種に任意の値を選択して確認ボタンを押下する
3. 登録確認画面が表示され、入力した顧客名・業種がラベルで表示されることを確認する

**バリデーションエラーが発生するケース**

1. 顧客登録画面を表示する
2. 顧客名に半角文字列、業種を未選択にして確認ボタンを押下する
3. 登録画面が再度表示され、エラーメッセージが表示されることを確認する

<details>
<summary>keywords</summary>

ClientForm, ClientAction, BeanUtil, SessionUtil, UniversalDao, EntityList, Client, Industry, HttpResponse, HttpRequest, ExecutionContext, @InjectForm, @OnError, @Required, @Domain, ApplicationException, Serializable, フォームクラス作成, バリデーション設定, セッションストア保存, 登録確認画面, 確認画面JSP, 入力画面確認画面切り替え

</details>
