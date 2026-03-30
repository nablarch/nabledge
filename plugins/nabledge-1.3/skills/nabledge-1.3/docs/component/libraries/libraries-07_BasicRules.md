# 命名ルール

## 命名ルール

個別アプリケーションでは `nablarch_` で始まる名前を使用禁止。対象スコープ：

- HTMLの属性値
- CSSのクラス名
- JavaScriptの関数名とグローバル変数名
- ページスコープ、リクエストスコープ、セッションスコープの属性名

<details>
<summary>keywords</summary>

命名規則, nablarch_プレフィックス, CSSクラス名制限, JavaScript名前制限, スコープ属性名制限

</details>

## taglibディレクティブの指定方法

カスタムタグを使用するJSPではtaglibディレクティブの指定が必須。

```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
```

<details>
<summary>keywords</summary>

taglibディレクティブ, JSPカスタムタグ設定, タグプレフィックス, カスタムタグ導入

</details>

## URIの指定方法

カスタムタグのURIを指定する属性の指定方法：

| 指定方法 | 指定するパス | 説明 |
|---|---|---|
| 絶対URL | http/httpsから始まるパス | 他システム連携など異なるホストのURIに使用。パスをそのまま使用する。 |
| コンテキストからの相対パス | `/`から始まるパス | アプリ内パスに使用。先頭にコンテキストパスを付加する。 |
| 現在のパスからの相対パス | `/`から始まらないパス（絶対URL除く） | アプリ内パスに使用。パスをそのまま使用する。 |

コンテキストからの相対パス指定時は `secure` 属性でhttps/httpを切り替え可能。`secure="true"` でhttps、`false` でhttp。カスタムタグの設定（http用ポート番号、https用ポート番号、ホスト）とコンテキストパスからURIを組み立てる。`secure` 属性を使用するにはカスタムタグの設定が必要。設定は :ref:`WebView_CustomTagConfig` を参照。

> **注意**: `secure` 属性は遷移先のプロトコルが変わるボタンやリンクでのみ使用する。同一プロトコル間の遷移では `secure` を指定せず相対パスを使用すること。

`secure` 属性使用例（http→https切替）：
```jsp
<%-- secure属性にtrueを指定する。 --%>
<n:submit type="button" name="login" value="ログイン" uri="/LoginAction/LOGIN001" secure="true" />
```
組み立てられるURI: `https://sample.co.jp:443/<コンテキストパス>/LoginAction/LOGIN001`

`secure` 属性使用例（https→http切替）：
```jsp
<%-- secure属性にfalseを指定する。 --%>
<n:submitLink name="logout" uri="/LogoutAction/LOGOUT01" secure="false">ログアウト</n:submitLink>
```
組み立てられるURI: `http://sample.co.jp:8080/<コンテキストパス>/LogoutAction/LOGOUT01`（http用ポート番号未設定の場合はポート番号が出力されない）

コンテキストパスの付加とURLリライトに対応するカスタムタグ：
- :ref:`WebView_ATag`（リンク）
- :ref:`WebView_ImgTag`（画像ファイル）
- :ref:`WebView_ScriptTag`（JavaScriptファイル）
- :ref:`WebView_LinkTag`（CSSファイル）

<details>
<summary>keywords</summary>

URI指定方法, コンテキストパス, secure属性, httpshttp切替, 絶対URL, 相対パス

</details>

## HTMLエスケープ

本フレームワークの全カスタムタグは、出力時にHTMLの全属性についてHTMLエスケープを実施する（原則）。

| 変換前 | 変換後 |
|---|---|
| & | &amp; |
| < | &lt; |
| > | &gt; |
| " | &#034; |
| ' | &#039; |

> **警告**: EL式はHTMLエスケープを実施しないため、EL式で値を出力しないこと。値の出力には `write` タグなど本機能のカスタムタグを使用する。JSTLのforEachタグやカスタムタグの属性にオブジェクトを設定するなど直接出力しない箇所ではEL式を使用しても問題ない。

> **警告**: JavaScriptに対するエスケープ処理は未実装。scriptタグのボディやonclick属性などJavaScriptを記述する部分に動的な値（入力データ等）を埋め込まないこと。埋め込む場合はプロジェクトの責任でエスケープ処理を実施すること。

<details>
<summary>keywords</summary>

HTMLエスケープ, セキュリティ, XSS防止, EL式制限, JavaScriptエスケープ未実装

</details>

## 改行、半角スペース変換

確認画面などで入力データを出力する際、HTMLエスケープに加えて改行と半角スペースを変換する：

| 変換前 | 変換後 |
|---|---|
| 改行コード（\n、\r、\r\n） | `<br />` |
| 半角スペース | `&nbsp;` |

<details>
<summary>keywords</summary>

改行変換, 半角スペース変換, br変換, nbsp変換, 確認画面出力

</details>

## HTMLエスケープせずに値を出力する方法

業務アクションなどで設定された値をページ上に出力する場合は :ref:`Webview_WriteTag` を使用する。HTMLエスケープを行わず、変数内のHTMLタグを直接出力したい場合のみ、以下のカスタムタグを使用する：

**:ref:`WebView_PrettyPrintTag`**

変数中の装飾系HTMLタグ（`<b>`、`<del>` 等）をエスケープせずに出力する。使用可能なHTMLタグと属性は :ref:`WebView_CustomTagConfig` で設定可能。

デフォルトで使用可能なタグ: `b big blockquote br caption center dd del dl dt em font h1 h2 h3 hr i ins li ol p small strong sub sup table td th tr u ul`

デフォルトで使用可能な属性: `color size border colspan rowspan bgcolor`

> **警告**: 出力変数の内容が不特定のユーザによって任意に設定できる場合、脆弱性の要因となる可能性がある。`<script>` タグや `onclick` 属性を使用可能に設定した場合、クロスサイトスクリプティング（XSS）脆弱性の直接要因となる。

**:ref:`WebView_RawWriteTag`**

変数中の文字列をエスケープせずそのまま出力する。

> **警告**: 出力変数の内容が不特定のユーザによって任意に設定できる場合、クロスサイトスクリプティング（XSS）脆弱性の直接の要因となる。JSPチェックツールでは使用禁止タグとして分類されており、使用箇所はエラーとして検出される。

<details>
<summary>keywords</summary>

XSS脆弱性, PrettyPrintTag, RawWriteTag, HTML非エスケープ出力, JSPチェックツール禁止タグ, WriteTag, 出力タグ使い分け

</details>

## 言語毎のリソースパスの切り替え

言語設定をもとにリソースパスを動的に切り替える機能を持つタグ：

- :ref:`WebView_ATag`
- :ref:`WebView_ImgTag`
- :ref:`WebView_ScriptTag`
- :ref:`WebView_LinkTag`
- :ref:`WebView_ConfirmationPageTag`
- :ref:`WebView_IncludeTag`

`include` タグは動的なJSPインクルードの言語別リソースパス切り替えに対応。:ref:`WebView_IncludeParamTag` でインクルード時の追加パラメータを指定する。

```jsp
<%-- path属性にインクルード先のパスを指定する。 --%>
<n:include path="/app_header.jsp">
    <%-- paramName属性にパラメータ名、value属性に値を指定する。
         スコープ上に設定された値を使用する場合はname属性を指定する。
         name属性とvalue属性のどちらか一方を指定する。 --%>
    <n:includeParam paramName="title" value="ユーザ情報詳細" />
</n:include>
```

`ResourcePathRule` 抽象クラスのサブクラスを使用して言語毎のリソースパスを取得する。カスタムタグは :ref:`WebView_CustomTagConfig` に指定されたサブクラスを使用。本フレームワークのデフォルトサブクラスは [言語毎のコンテンツパスの切り替え](../handlers/handlers-HttpResponseHandler.md) を参照。

<details>
<summary>keywords</summary>

多言語対応, リソースパス切り替え, includeタグ, ResourcePathRule, 言語設定, includeParam

</details>

## 静的コンテンツのクライアント側でのキャッシュについて

静的コンテンツのURIにGETパラメータでバージョンを付加し、コンテンツ置き換え時にクライアント側のキャッシュを強制破棄する機能。設定ファイル（configファイル）で `static_content_version` キーにバージョンを設定する。設定がない場合は本機能が無効化される。

```bash
static_content_version=1.0
```

対応する属性：
- :ref:`WebView_ImgTag` の `src` 属性
- :ref:`WebView_ScriptTag` の `src` 属性
- :ref:`WebView_LinkTag` の `href` 属性
- :ref:`WebView_SubmitTag` の `src` 属性
- :ref:`WebView_PopupSubmitTag` の `src` 属性
- :ref:`WebView_DownloadSubmitTag` の `src` 属性

<details>
<summary>keywords</summary>

ブラウザキャッシュ, 静的コンテンツバージョン管理, キャッシュバスティング, static_content_version, GETパラメータ

</details>
