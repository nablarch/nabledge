# JSPカスタムタグライブラリの使用方法

## 解説に使用する実装例の説明

本機能では、画面作成のイメージを具体的に理解できるように、ユーザ登録機能の実装例を使用して解説を行う。
以降の解説では、特に断りがない限り、ここで説明した設定とアクションに基づいて実装例を示す。

### ユーザ登録機能の画面遷移

ユーザ登録機能の画面遷移を下記に示す。
下図では、画面遷移を示す線上に、画面のイベントに対応するリクエストIDを示している。
USERS00302の画面遷移(赤枠)は、データベースへのコミットを伴うリクエストになるため、二重サブミットを防止する。

![WebView_SampleUI.jpg](../../../knowledge/assets/libraries-07-CustomTag/WebView_SampleUI.jpg)

### ディスパッチャの設定

URIとアクションを対応付けるディスパッチャの設定を下記に示す。
ディスパッチャについては、 [HTTPリクエストディスパッチハンドラ](../../component/handlers/handlers-HttpRequestJavaPackageMapping.md) を参照。

```xml
<component name="packageMapping" class="nablarch.fw.web.handler.HttpRequestJavaPackageMapping">
    <property name="baseUri" value="/action/"/>
    <property name="basePackage" value="nablarch.sample"/>
</component>
```

上記ディスパッチャの設定により、下記URIとアクションのメソッドが対応する。
ここでは、UserActionクラスとMenuActionクラスの例を示す。

```bash
# URI(baseUri＋basePackageを除いたクラス名＋リクエストID)
<コンテキストパス>/action/management/user/UserAction/<リクエストID>

# メソッド
nablarch.sample.management.user.UserAction#do<リクエストID>(HttpRequest req, ExecutionContext ctx)
```

```bash
# URI(baseUri＋basePackageを除いたクラス名＋リクエストID)
<コンテキストパス>/action/MenuAction/<リクエストID>

# メソッド
nablarch.sample.MenuAction#do<リクエストID>(HttpRequest req, ExecutionContext ctx)
```

### アクションのシグネチャ

ディスパッチャの設定を踏まえて、リクエストIDに対応するUserActionクラスとMenuActionクラスのシグネチャを下記に示す。

```java
package nablarch.sample.management.user;

public class UserAction {
    public HttpResponse doUSERS00201(HttpRequest req, ExecutionContext ctx) {
        /* ユーザ登録画面の初期表示 */
    }
    public HttpResponse doUSERS00202(HttpRequest req, ExecutionContext ctx) {
        /* ユーザ登録画面の確認ボタン */
    }
    public HttpResponse doUSERS00301(HttpRequest req, ExecutionContext ctx) {
        /* ユーザ登録確認画面の戻るボタン */
    }
    public HttpResponse doUSERS00302(HttpRequest req, ExecutionContext ctx) {
        /* ユーザ登録確認画面の登録ボタン */
    }
}

package nablarch.sample;

public class MenuAction {
    public HttpResponse doMENUS00101(HttpRequest req, ExecutionContext ctx) {
        /* メニュー画面の初期表示 */
    }
}
```

以降では、ここで示したユーザ登録機能の実装例から適宜抜粋して解説を行う。

## カスタムタグ全体に関わる仕様

全カスタムタグに関係する仕様について説明する。

また、カスタムタグを使用する場合は、Webフロントコントローラのハンドラの設定が必須となる。
ハンドラの設定方法については、 [NablarchTagHandlerの設定](../../component/libraries/libraries-07-HowToSettingCustomTag.md#nablarchtaghandlerの設定) を参照。

./07_BasicRules

## カスタムタグごとの仕様

各カスタムタグの仕様について説明する。

カスタムタグの一覧については、 [タグリファレンス](../../component/libraries/libraries-07-TagReference.md#タグリファレンス) を参照。

### 入力に関するカスタムタグ

入力に関するカスタムタグは、下記の機能を提供する。

* 入力データを保持する。
* 入力データを復元する。
* 入力項目を確認画面用に出力する。
* 値をフォーマットして出力する。
* 値を変数に設定する。

各機能の詳細については下記を参照。
値をフォーマットして出力する機能については、 [値のフォーマット出力](../../component/libraries/libraries-07-DisplayTag.md#値のフォーマット出力) を参照。

./07_FormTag

本機能が提供するカスタムタグの詳細については、下記を参照。

./07_FormTagList

> **Note:**
> コードの入力に関するカスタムタグについては、 [コード値の表示](../../component/libraries/libraries-07-DisplayTag.md#コード値の表示) を参照。

### 表示に関するカスタムタグ

表示をサポートするカスタムタグを提供する。

詳細については下記を参照。

./07_DisplayTag

### フォームのサブミット制御に関するカスタムタグ

フォームのサブミット制御に関するカスタムタグは、下記の機能を提供する。

* ボタン又はリンクによるフォームのサブミットをサポートする。
* JavaScriptを使用して二重サブミットを防止する。
* トークンを使用して二重サブミットを防止する。
* ブラウザのキャッシュを防止する。

各機能の詳細については下記を参照。

./07_SubmitTag

### アプリケーション開発を容易にするカスタムタグ

業務アプリケーションで頻出する処理の実装をサポートするカスタムタグを提供する。

詳細については下記を参照。

./07_FacilitateTag

### その他のカスタムタグ

上記以外にNAFが提供するカスタムタグについて説明する。

./07_OtherTag
