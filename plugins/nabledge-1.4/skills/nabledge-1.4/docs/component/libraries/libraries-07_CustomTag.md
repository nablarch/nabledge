# JSPカスタムタグライブラリの使用方法

## ユーザ登録機能の画面遷移

![ユーザ登録機能の画面遷移](../../../knowledge/component/libraries/assets/libraries-07_CustomTag/WebView_SampleUI.jpg)

> **重要**: USERS00302の画面遷移はDBへのコミットを伴うリクエストのため、二重サブミットを防止する必要がある。

<details>
<summary>keywords</summary>

ユーザ登録機能, 画面遷移, 二重サブミット防止, USERS00302, WebView_SampleUI

</details>

## ディスパッチャの設定

ディスパッチャ設定（[../../../handler/HttpRequestJavaPackageMapping](../handlers/handlers-HttpRequestJavaPackageMapping.md) 参照）:

```xml
<component name="packageMapping" class="nablarch.fw.web.handler.HttpRequestJavaPackageMapping">
    <property name="baseUri" value="/action/"/>
    <property name="basePackage" value="nablarch.sample"/>
</component>
```

URI → メソッドのマッピング規則（UserActionの例）:
- URI: `<コンテキストパス>/action/management/user/UserAction/<リクエストID>`
- メソッド: `nablarch.sample.management.user.UserAction#do<リクエストID>(HttpRequest req, ExecutionContext ctx)`

URI → メソッドのマッピング規則（MenuActionの例）:
- URI: `<コンテキストパス>/action/MenuAction/<リクエストID>`
- メソッド: `nablarch.sample.MenuAction#do<リクエストID>(HttpRequest req, ExecutionContext ctx)`

<details>
<summary>keywords</summary>

HttpRequestJavaPackageMapping, ディスパッチャ設定, URIマッピング, UserAction, MenuAction, baseUri, basePackage, nablarch.sample

</details>

## アクションのシグネチャ

```java
package nablarch.sample.management.user;

public class UserAction {
    public HttpResponse doUSERS00201(HttpRequest req, ExecutionContext ctx) { /* ユーザ登録画面の初期表示 */ }
    public HttpResponse doUSERS00202(HttpRequest req, ExecutionContext ctx) { /* ユーザ登録画面の確認ボタン */ }
    public HttpResponse doUSERS00301(HttpRequest req, ExecutionContext ctx) { /* ユーザ登録確認画面の戻るボタン */ }
    public HttpResponse doUSERS00302(HttpRequest req, ExecutionContext ctx) { /* ユーザ登録確認画面の登録ボタン */ }
}

package nablarch.sample;

public class MenuAction {
    public HttpResponse doMENUS00101(HttpRequest req, ExecutionContext ctx) { /* メニュー画面の初期表示 */ }
}
```

<details>
<summary>keywords</summary>

UserAction, MenuAction, HttpRequest, ExecutionContext, HttpResponse, アクションシグネチャ, doUSERS00201, doUSERS00202, doUSERS00301, doUSERS00302, doMENUS00101

</details>

## カスタムタグ全体に関わる仕様

> **重要**: カスタムタグを使用する場合は、Webフロントコントローラのハンドラ設定が必須。設定方法は :ref:`WebView_NablarchTagHandler` を参照。

全カスタムタグ共通仕様: [./07_BasicRules](libraries-07_BasicRules.md)

<details>
<summary>keywords</summary>

WebView_NablarchTagHandler, Webフロントコントローラ, ハンドラ設定, カスタムタグ共通仕様, 07_BasicRules

</details>

## カスタムタグごとの仕様

## 入力に関するカスタムタグ

以下の機能を提供:
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

以下の機能を提供:
- ボタン又はリンクによるフォームのサブミット
- JavaScriptを使用した二重サブミット防止
- トークンを使用した二重サブミット防止
- ブラウザのキャッシュ防止

詳細: [./07_SubmitTag](libraries-07_SubmitTag.md)

## アプリケーション開発を容易にするカスタムタグ

業務アプリケーションで頻出する処理の実装をサポート。詳細: [./07_FacilitateTag](libraries-07_FacilitateTag.md)

## その他のカスタムタグ

詳細: [./07_OtherTag](libraries-07_OtherTag.md)

<details>
<summary>keywords</summary>

入力カスタムタグ, 表示カスタムタグ, サブミット制御タグ, 二重サブミット防止, トークン, 07_FormTag, 07_FormTagList, 07_DisplayTag, 07_SubmitTag, 07_FacilitateTag, 07_OtherTag, code_tag, web_view_format

</details>
