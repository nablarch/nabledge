# 命名ルール

## 命名ルール・taglibディレクティブの指定方法

## 命名ルール

フレームワークが予約するプレフィックス「nablarch_」から始まる名前を個別アプリケーションで使用しないこと。

対象:
- HTMLの属性値
- CSSのクラス名
- JavaScriptの関数名とグローバル変数名
- ページスコープ、リクエストスコープ、セッションスコープの属性名

## taglibディレクティブの指定方法

カスタムタグを使用するJSPには以下のtaglibディレクティブが必須。

```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
```

<details>
<summary>keywords</summary>

nablarch_プレフィックス, 命名ルール, taglibディレクティブ, JSPカスタムタグ, スコープ属性名, ネームスペース宣言

</details>

## URIの指定方法

カスタムタグのURI指定属性は以下の方法で指定する。

| 指定方法 | 指定するパス | 説明 |
|---|---|---|
| 絶対URL | http/httpsから始まるパス | 他システム連携などホストが異なるURIに使用。指定パスをそのまま使用。 |
| コンテキストからの相対パス | /（スラッシュ）から始まるパス | アプリケーション内のパスに使用。先頭にコンテキストパスを付加。 |
| 現在のパスからの相対パス | /から始まらないパス（絶対URL除く） | アプリケーション内のパスに使用。指定パスをそのまま使用。 |

コンテキストからの相対パス指定時、`secure`属性でhttps/httpを切り替え可能。`secure`指定時は、カスタムタグの設定値（httpポート番号、httpsポート番号、ホスト）とコンテキストパスを使用してURIを組み立てる。

| 属性 | 説明 |
|---|---|
| secure | URIをhttpsにするか否か。trueでhttps、falseでhttp。 |

> **注意**: secure属性は遷移先のプロトコルを切り替えるボタンやリンクのみで使用すること。遷移先のプロトコルが同じ場合（httpからhttp、httpsからhttps）は、secure属性を指定せず相対パスを使用する。

secure属性を使用するアプリケーションでは :ref:`WebView_CustomTagConfig` のカスタムタグ設定が必要。

httpからhttpsへ切り替える例（httpポート:8080、httpsポート:443、ホスト:sample.co.jp）:
```jsp
<%-- secure属性にtrueを指定する。 --%>
<n:submit type="button" name="login" value="ログイン" uri="/LoginAction/LOGIN001" secure="true" />
```
組み立てられるURI: `https://sample.co.jp:443/<コンテキストパス>/LoginAction/LOGIN001`

httpsからhttpへ切り替える例:
```jsp
<%-- secure属性にfalseを指定する。 --%>
<n:submitLink name="logout" uri="/LogoutAction/LOGOUT01" secure="false">ログアウト</n:submitLink>
```
組み立てられるURI: `http://sample.co.jp:8080/<コンテキストパス>/LogoutAction/LOGOUT01`
（httpポート番号を設定しなかった場合: `http://sample.co.jp/<コンテキストパス>/LogoutAction/LOGOUT01`）

本機能はURIを指定するHTMLタグについてコンテキストパスの付加とURLリライトに対応する以下のカスタムタグを提供する:
- :ref:`WebView_ATag` (リンク)
- :ref:`WebView_ImgTag` (画像ファイル)
- :ref:`WebView_ScriptTag` (JavaScriptファイル)
- :ref:`WebView_LinkTag` (CSSファイル)

<details>
<summary>keywords</summary>

URI指定方法, コンテキストパス, secure属性, https切り替え, 絶対URL, 相対パス, WebView_ATag, WebView_ImgTag, WebView_ScriptTag, WebView_LinkTag

</details>

## HTMLエスケープ

本フレームワークが提供する全カスタムタグは、出力時にすべてのHTML属性をHTMLエスケープする。

| 変換前 | 変換後 |
|---|---|
| & | &amp; |
| < | &lt; |
| > | &gt; |
| " | &#034; |
| ' | &#039; |

> **警告**: EL式はHTMLエスケープを実施しないため、EL式を使用して値を出力しないこと。値を出力する場合は :ref:`Webview_WriteTag` など本機能が提供するカスタムタグを使用する。JSTLのforEachタグやカスタムタグの属性にオブジェクトを設定する場合など直接出力しない箇所ではEL式を使用しても問題ない。

> **警告**: JavaScriptに対するエスケープ処理は未実装のため、scriptタグのボディやonclick属性などJavaScriptを記述する部分に動的な値（入力データなど）を埋め込まないこと。埋め込む場合はプロジェクトの責任でエスケープ処理を実施すること。

<details>
<summary>keywords</summary>

HTMLエスケープ, エスケープ変換, EL式, カスタムタグ出力, JavaScriptエスケープ未実装, XSS対策

</details>

## 改行、半角スペース変換

確認画面などに入力データを出力する際は、HTMLエスケープに加えて改行と半角スペースの変換を行う。

| 変換前 | 変換後 |
|---|---|
| 改行コード（\n、\r、\r\n） | `<br />` |
| 半角スペース | `&nbsp;` |

<details>
<summary>keywords</summary>

改行変換, 半角スペース変換, 確認画面, 入力データ出力, br変換, nbsp

</details>

## HTMLエスケープせずに値を出力する方法

:ref:`Webview_WriteTag` で通常は値を出力するが、HTMLエスケープを行わずHTMLタグを直接出力したい場合は以下のタグを使用する。

**:ref:`WebView_PrettyPrintTag`**

変数中の装飾系HTMLタグ（`<b>`、`<del>` など）をエスケープせずに出力するカスタムタグ。使用可能タグと属性は :ref:`WebView_CustomTagConfig` で任意に設定可能。

デフォルトで使用可能なタグ: `b big blockquote br caption center dd del dl dt em font h1 h2 h3 hr i ins li ol p small strong sub sup table td th tr u ul`

デフォルトで使用可能な属性: `color size border colspan rowspan bgcolor`

> **警告**: 出力する変数の内容が不特定のユーザによって任意に設定できる場合、脆弱性の原因となりうる。使用可能タグ・属性の設定には十分注意すること。例えば `<script>` タグや `onclick` 属性を許可するとXSS脆弱性の直接原因となる。

**:ref:`WebView_RawWriteTag`**

変数中の文字列をエスケープせずそのまま出力するカスタムタグ。

> **警告**: 出力する変数の内容が不特定のユーザによって任意に設定できる場合、XSS脆弱性の直接原因となる。本タグの使用には十分な考慮が必要。なお、JSPチェックツールでは本タグを使用禁止タグとして分類しており、使用箇所はエラーとして検出される。

<details>
<summary>keywords</summary>

HTMLエスケープなし出力, WebView_PrettyPrintTag, WebView_RawWriteTag, XSS脆弱性, 装飾タグ出力, JSPチェックツール

</details>

## 言語毎のリソースパスの切り替え・静的コンテンツのキャッシュ

## 言語毎のリソースパスの切り替え

リソースパスを扱うカスタムタグは、言語設定をもとにリソースパスを動的に切り替える機能を持つ。対応タグ:
- :ref:`WebView_ATag`
- :ref:`WebView_ImgTag`
- :ref:`WebView_ScriptTag`
- :ref:`WebView_LinkTag`
- :ref:`WebView_ConfirmationPageTag`
- :ref:`WebView_IncludeTag`

includeタグの動的JSPインクルード例（:ref:`WebView_IncludeParamTag` でパラメータ指定）:
```jsp
<n:include path="/app_header.jsp">
    <n:includeParam paramName="title" value="ユーザ情報詳細" />
</n:include>
```

カスタムタグは :ref:`WebView_CustomTagConfig` に設定されたResourcePathRuleサブクラスを使用して言語切り替えを行う。ResourcePathRuleおよびデフォルト提供サブクラスの詳細は [言語毎のコンテンツパスの切り替え](../handlers/handlers-HttpResponseHandler.md) を参照。

## 静的コンテンツのクライアント側キャッシュ

静的コンテンツのURIにGETパラメータでバージョンを付加し、コンテンツ置き換え時にクライアント側キャッシュを強制破棄する機能。設定ファイル（configファイル）にバージョンが設定されていない場合は本機能は無効化される。

設定キー:

| キー | 値 |
|---|---|
| static_content_version | 静的コンテンツのバージョン |

設定例:
```
static_content_version=1.0
```

バージョン付加の対応属性:
- :ref:`WebView_ImgTag` のsrc属性
- :ref:`WebView_ScriptTag` のsrc属性
- :ref:`WebView_LinkTag` のhref属性
- :ref:`WebView_SubmitTag` のsrc属性
- :ref:`WebView_PopupSubmitTag` のsrc属性
- :ref:`WebView_DownloadSubmitTag` のsrc属性

<details>
<summary>keywords</summary>

リソースパス切り替え, 多言語対応, ResourcePathRule, 静的コンテンツキャッシュ, static_content_version, WebView_IncludeTag, WebView_ConfirmationPageTag, WebView_IncludeParamTag, WebView_ATag, WebView_ImgTag, WebView_ScriptTag, WebView_LinkTag, WebView_SubmitTag, WebView_PopupSubmitTag, WebView_DownloadSubmitTag

</details>
