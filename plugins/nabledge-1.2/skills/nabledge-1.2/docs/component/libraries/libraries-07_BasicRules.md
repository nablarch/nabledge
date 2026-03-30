# 命名ルール

## 命名ルール

フレームワークが規定する名前（CSSクラス名、JavaScript関数名等）には `nablarch_` プレフィックスを使用する。個別アプリケーションでは `nablarch_` から始まる名前を使用してはならない。

対象:
- HTMLの属性値
- CSSのクラス名
- JavaScriptの関数名とグローバル変数名
- ページスコープ、リクエストスコープ、セッションスコープの属性名

<details>
<summary>keywords</summary>

nablarch_プレフィックス, 命名規則, スコープ属性名, CSSクラス名, JavaScript関数名, HTML属性値

</details>

## taglibディレクティブの指定方法

カスタムタグを使用するJSPでは以下のtaglibディレクティブの指定が必須。

```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
```

<details>
<summary>keywords</summary>

taglib, taglibディレクティブ, カスタムタグ, JSP, prefix n, nablarch URI

</details>

## URIの指定方法

カスタムタグのURIを指定する属性は以下のいずれかの方法で指定する。

| 指定方法 | 指定するパス | 説明 |
|---|---|---|
| 絶対URL | http/httpsから始まるパス | 他システム連携などでホストが異なるURIを指定する場合。カスタムタグはパスをそのまま使用。 |
| コンテキストからの相対パス | /（スラッシュ）から始まるパス | アプリケーション内のパスを指定する場合。カスタムタグは先頭にコンテキストパスを付加。 |
| 現在のパスからの相対パス | /から始まらないパス（絶対URLを除く） | アプリケーション内のパスを指定する場合。カスタムタグはパスをそのまま使用。 |

コンテキストからの相対パスを指定した場合、`secure` 属性でhttpsとhttpを切り替えられる。`secure` 属性指定時はカスタムタグの設定（http/httpsのポート番号、ホスト）とコンテキストパスを使ってURIを組み立てる。`secure` 属性を使用する場合はカスタムタグの設定が必要（:ref:`WebView_CustomTagConfig` 参照）。

| 属性 | 説明 |
|---|---|
| secure | URIをhttpsにするか否か。httpsにする場合はtrue、しない場合はfalse。 |

> **注意**: `secure` 属性は遷移先のプロトコルを切り替えるボタンやリンクのみで使用する。遷移先のプロトコルが同じ場合（httpからhttp、httpsからhttps）は `secure` 属性を指定せずに相対パスを指定する。

**使用例**（http用ポート: 8080、https用ポート: 443、ホスト: sample.co.jp）

httpからhttpsに切り替える場合:
```jsp
<n:submit type="button" name="login" value="ログイン" uri="/LoginAction/LOGIN001" secure="true" />
```
組み立てられるURI: `https://sample.co.jp:443/<コンテキストパス>/LoginAction/LOGIN001`

httpsからhttpに切り替える場合:
```jsp
<n:submitLink name="logout" uri="/LogoutAction/LOGOUT01" secure="false">ログアウト</n:submitLink>
```
組み立てられるURI: `http://sample.co.jp:8080/<コンテキストパス>/LogoutAction/LOGOUT01`（http用ポート番号未設定時はポート番号なし）

URIを指定するHTMLタグのコンテキストパス付加とURLリライトに対応するカスタムタグ:
- :ref:`WebView_ATag`（リンク）
- :ref:`WebView_ImgTag`（画像ファイル）
- :ref:`WebView_ScriptTag`（JavaScriptファイル）
- :ref:`WebView_LinkTag`（CSSファイル）

<details>
<summary>keywords</summary>

URI指定, 絶対URL, コンテキスト相対パス, secure属性, https切り替え, コンテキストパス, WebView_SpecifyUri

</details>

## HTMLエスケープと改行、半角スペース変換

### HTMLエスケープ

本フレームワークのカスタムタグでは、原則として出力時にすべてのHTML属性についてHTMLエスケープを行う。

| 変換前 | 変換後 |
|---|---|
| & | &amp; |
| < | &lt; |
| > | &gt; |
| " | &#034; |
| ' | &#039; |

> **警告**: EL式はHTMLエスケープ処理を実施しないため、EL式を使用して値を出力してはならない。値を出力する場合はwriteタグなどカスタムタグを使用すること。ただし、JSTLのforEachタグやカスタムタグ属性にオブジェクトを設定する場合など、直接出力しない箇所ではEL式を使用しても問題ない。

> **警告**: JavaScriptに対するエスケープ処理は未実装のため、scriptタグのボディやonclick属性などJavaScriptを記述する部分に動的な値（入力データなど）を埋め込んではならない。埋め込む場合はプロジェクトの責任でエスケープ処理を実施すること。

### 改行、半角スペース変換

確認画面などに入力データを出力する際は、HTMLエスケープに加えて以下の変換を行う。

| 変換前 | 変換後 |
|---|---|
| 改行コード（\\n、\\r、\\r\\n） | `<br />` |
| 半角スペース | &nbsp; |

### HTMLエスケープせずに値を出力する方法

業務アクションなどで設定された値をページ上に出力する場合は :ref:`Webview_WriteTag` を使用するが、HTMLエスケープを行わず変数内のHTMLタグを直接出力したい場合は以下のタグを使用する。

- :ref:`WebView_PrettyPrintTag`: 変数中の装飾系HTMLタグをエスケープせずに出力するカスタムタグ。使用可能なHTMLタグ・属性は :ref:`WebView_CustomTagConfig` で設定可能。

  デフォルト使用可能タグ: `b big blockquote br caption center dd del dl dt em font h1 h2 h3 hr i ins li ol p small strong sub sup table td th tr u ul`

  デフォルト使用可能属性: `color size border colspan rowspan bgcolor`

  > **警告**: 出力する変数が不特定のユーザによって任意に設定できるものであった場合、脆弱性の要因となる。使用可能タグ・属性の選択に十分留意すること。例えば `<script>` タグや `onclick` 属性を使用可能とした場合、XSS脆弱性の直接要因となる。

- :ref:`WebView_RawWriteTag`: 変数中の文字列をエスケープせずそのまま出力するカスタムタグ。

  > **警告**: 出力する変数が不特定のユーザによって任意に設定できるものであった場合、XSS脆弱性の直接の要因となる。別添のJSPチェックツールでは本タグを使用禁止タグとして分類しており、使用箇所はエラーとして検出される。

<details>
<summary>keywords</summary>

HTMLエスケープ, EL式, XSS, PrettyPrintTag, RawWriteTag, 改行変換, 半角スペース変換, output_without_html_escape, Webview_WriteTag

</details>

## 言語毎のリソースパスの切り替え

リソースパスを扱うタグは、言語設定をもとにリソースパスを動的に切り替える機能を持つ。以下のタグが対応している。

- :ref:`WebView_ATag`
- :ref:`WebView_ImgTag`
- :ref:`WebView_ScriptTag`
- :ref:`WebView_LinkTag`
- :ref:`WebView_ConfirmationPageTag`
- :ref:`WebView_IncludeTag`

`includeタグ` は動的なJSPインクルードを言語毎のリソースパス切り替えに対応させるために提供される。:ref:`WebView_IncludeParamTag` を使用してインクルード時に追加するパラメータを指定する。

`n:includeParam` タグの属性:
- `paramName`: パラメータ名を指定する。
- `value`: 値を直接指定する。
- `name`: スコープ上に設定された値を使用する場合に指定する。

> **注意**: `name` 属性と `value` 属性はどちらか一方を指定する（排他）。

```jsp
<%-- path属性にインクルード先のパスを指定する。 --%>
<n:include path="/app_header.jsp">
    <%-- paramName属性にパラメータ名、value属性に値を指定する。
         スコープ上に設定された値を使用する場合はname属性を指定する。
         name属性とvalue属性のどちらか一方を指定する。 --%>
    <n:includeParam paramName="title" value="ユーザ情報詳細" />
</n:include>
```

`ResourcePathRule` 抽象クラスのサブクラスを使用して言語毎のリソースパスを取得する。`ResourcePathRule` およびデフォルトで提供されるサブクラスについては [言語毎のコンテンツパスの切り替え](../handlers/handlers-HttpResponseHandler.md) を参照。

カスタムタグは :ref:`WebView_CustomTagConfig` に指定された `ResourcePathRule` サブクラスを使用する。設定については :ref:`WebView_CustomTagConfig` を参照。

<details>
<summary>keywords</summary>

ResourcePathRule, 言語切り替え, リソースパス, 多言語対応, includeタグ, WebView_LangResourcePath, includeParam, name属性, value属性

</details>

## 静的コンテンツのキャッシュ制御

クライアント側でキャッシュを有効化している場合、サーバ上の静的コンテンツを置き換えても古いコンテンツが表示される場合がある。本機能では静的コンテンツのURIにGETパラメータでバージョンを付加し、コンテンツ置き換え時にクライアント側キャッシュを強制破棄する。

GETパラメータに付加するバージョンは設定ファイル（configファイル）に設定する。設定がない場合は本機能は無効化される。

| キー | 値 |
|---|---|
| static_content_version | 静的コンテンツのバージョン |

```bash
static_content_version=1.0
```

対応する属性:
- :ref:`WebView_ImgTag` のsrc属性
- :ref:`WebView_ScriptTag` のsrc属性
- :ref:`WebView_LinkTag` のhref属性
- :ref:`WebView_SubmitTag` のsrc属性
- :ref:`WebView_PopupSubmitTag` のsrc属性
- :ref:`WebView_DownloadSubmitTag` のsrc属性

<details>
<summary>keywords</summary>

静的コンテンツ, キャッシュ, static_content_version, キャッシュ破棄, GETパラメータ, StaticResourceReload

</details>
