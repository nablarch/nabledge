# JSPカスタムタグライブラリの使用方法

## 解説に使用する実装例の説明

USERS00302（登録ボタン）はDBコミットを伴うため、二重サブミットを防止する。

![ユーザ登録機能の画面遷移](../../../knowledge/component/libraries/assets/libraries-07_CustomTag/WebView_SampleUI.jpg)

**ディスパッチャの設定** ([../../../handler/HttpRequestJavaPackageMapping](../handlers/handlers-HttpRequestJavaPackageMapping.md)):

```xml
<component name="packageMapping" class="nablarch.fw.web.handler.HttpRequestJavaPackageMapping">
    <property name="baseUri" value="/action/"/>
    <property name="basePackage" value="nablarch.sample"/>
</component>
```

URI-メソッド対応規則（UserActionクラスとMenuActionクラスの例）：

UserActionの例（サブパッケージ `management/user/` あり）：
- URI: `<コンテキストパス>/action/management/user/UserAction/<リクエストID>`
- メソッド: `nablarch.sample.management.user.UserAction#do<リクエストID>(HttpRequest req, ExecutionContext ctx)`

MenuActionの例（basePackage直下、サブパッケージなし）：
- URI: `<コンテキストパス>/action/MenuAction/<リクエストID>`
- メソッド: `nablarch.sample.MenuAction#do<リクエストID>(HttpRequest req, ExecutionContext ctx)`

**アクションのシグネチャ例**:

```java
public class UserAction {
    public HttpResponse doUSERS00201(HttpRequest req, ExecutionContext ctx) { /* 初期表示 */ }
    public HttpResponse doUSERS00202(HttpRequest req, ExecutionContext ctx) { /* 確認ボタン */ }
    public HttpResponse doUSERS00301(HttpRequest req, ExecutionContext ctx) { /* 戻るボタン */ }
    public HttpResponse doUSERS00302(HttpRequest req, ExecutionContext ctx) { /* 登録ボタン */ }
}

public class MenuAction {
    public HttpResponse doMENUS00101(HttpRequest req, ExecutionContext ctx) { /* メニュー初期表示 */ }
}
```

<details>
<summary>keywords</summary>

HttpRequestJavaPackageMapping, UserAction, MenuAction, HttpResponse, HttpRequest, ExecutionContext, ディスパッチャ設定, URI-アクション対応, 二重サブミット防止, アクションシグネチャ

</details>

## カスタムタグ全体に関わる仕様

> **重要**: カスタムタグを使用する場合、Webフロントコントローラのハンドラの設定が必須。ハンドラの設定方法については :ref:`WebView_NablarchTagHandler` を参照。

全カスタムタグの基本仕様: [./07_BasicRules](libraries-07_BasicRules.md)

<details>
<summary>keywords</summary>

WebView_NablarchTagHandler, Webフロントコントローラ, ハンドラ設定必須, カスタムタグ基本仕様, 07_BasicRules

</details>

## カスタムタグごとの仕様

## 入力に関するカスタムタグ

提供機能：
- 入力データを保持する
- 入力データを復元する
- 入力項目を確認画面用に出力する
- 値をフォーマットして出力する（[web_view_format](libraries-07_DisplayTag.md) 参照）
- 値を変数に設定する

詳細: [./07_FormTag](libraries-07_FormTag.md)、タグ一覧: [./07_FormTagList](libraries-07_FormTagList.md)

> **注意**: コードの入力に関するカスタムタグは :ref:`code_tag` を参照。

## 表示に関するカスタムタグ

表示をサポートするカスタムタグ。詳細: [./07_DisplayTag](libraries-07_DisplayTag.md)

## フォームのサブミット制御に関するカスタムタグ

提供機能：
- ボタン又はリンクによるフォームのサブミットをサポート
- JavaScriptを使用して二重サブミットを防止
- トークンを使用して二重サブミットを防止
- ブラウザのキャッシュを防止

詳細: [./07_SubmitTag](libraries-07_SubmitTag.md)

## アプリケーション開発を容易にするカスタムタグ

業務アプリケーションで頻出する処理の実装をサポート。詳細: [./07_FacilitateTag](libraries-07_FacilitateTag.md)

## その他のカスタムタグ

詳細: [./07_OtherTag](libraries-07_OtherTag.md)

<details>
<summary>keywords</summary>

入力カスタムタグ, フォームサブミット制御, 二重サブミット防止, トークン, JavaScript, ブラウザキャッシュ防止, code_tag, 07_FormTag, 07_FormTagList, 07_SubmitTag, 07_DisplayTag, 07_FacilitateTag, 07_OtherTag, web_view_format

</details>
