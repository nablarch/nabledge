# 業務画面テンプレート

## 概要

[jsp_page_templates](ui-framework-jsp_page_templates.md) は、業務画面の業務機能領域を除く部分をUI標準に準拠した形で実装する共通機能。最小限のコード記述で画面作成が可能。

```jsp
<?xml version="1.0" encoding="UTF-8" ?>
<%@taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags/template" %>
<%@page language="java"
        contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8" %>

<t:page_template title="新規会員登録">
  <jsp:attribute name="contentHtml">
    <n:form>
    (略)
    </n:form>
  </jsp:attribute>
</t:page_template>
```

<details>
<summary>keywords</summary>

page_template.tag, t:page_template, 業務画面テンプレート, UI標準, JSPタグファイル, 業務機能領域, 最小限コード

</details>

## ファイル構成

なし

<details>
<summary>keywords</summary>

ファイル構成, JSPタグファイル, インクルードJSP, タグファイル配置

</details>

## 概要（ファイル構成）

[jsp_page_templates](ui-framework-jsp_page_templates.md) はJSPタグファイルとインクルードJSPファイルの形式で提供される。業務画面JSPからはタグファイルを参照し、インクルードJSPはタグファイルから読み込まれる。

配置場所:
- JSPタグファイル: `(サーブレットコンテキストルート)/WEB-INF/tags/template/`
- インクルードJSPファイル: `(サーブレットコンテキストルート)/include/`

> **重要**: **HTMLヘッド部定義JSP** と **外部スクリプト定義JSP** は外部参照するCSS/JavaScriptの読み込みを制御しており、開発/本番切り替え時に書き換え対象となる。

<details>
<summary>keywords</summary>

WEB-INF/tags/template, include, HTMLヘッド部定義JSP, 外部スクリプト定義JSP, 開発本番切り替え, ファイル配置場所

</details>

## 構成ファイル一覧

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| ベースレイアウトファイル | △ | ○ | /WEB-INF/tags/template/base_layout.tag | UI標準に沿った業務画面の基本構造を実装するタグファイル |
| 業務画面共通テンプレート | △ | ○ | /WEB-INF/tags/template/page_template.tag, subwindow_page_template.tag | 大半の業務画面で使用するテンプレート。業務機能領域以外のレイアウトを実装。subwindow_page_template.tagはサブウィンドウ用 |
| エラー画面共通テンプレート | △ | ○ | /WEB-INF/tags/template/errorpage_template.tag | 共通エラー画面を実装するテンプレート |
| トップナビゲーション領域JSP | △ | ○ | /include/app_top_nav.jsp, /include/subwindow_app_top_nav.jsp | 業務画面のトップナビゲーション領域を実装。subwindow_app_top_nav.jspはサブウィンドウ用 |
| ヘッダー領域JSP | △ | ○ | /include/app_header.jsp, /include/subwindow_app_header.jsp | 業務画面のヘッダー領域を実装。subwindow_app_header.jspはサブウィンドウ用 |
| サイドメニュー領域JSP | △ | ○ | /include/app_aside.jsp | 業務画面のサイドメニュー領域を実装 |
| フッター領域JSP | △ | ○ | /include/app_footer.jsp, /include/subwindow_app_footer.jsp | 業務画面のフッター領域を実装。subwindow_app_footer.jspはサブウィンドウ用 |
| HTMLヘッド部定義JSP | △ | ○ | /include/html_head.jsp | HTMLの`<head>`タグの内容（キャッシュ制御`<meta>`タグ、CSS読み込みなど）を定義 |
| 外部スクリプト定義JSP | △ | ○ | /include/js_include.jsp | HTMLの`<script>`タグによる外部スクリプト参照を定義 |
| ローカル動作用スタブ | ○ | × | /js/jsp/taglib/template.js | ローカル動作時にタグファイルを読み込んでレンダリングするJavaScript |

凡例: ○=使用する、△=直接使用しないがミニファイ後のファイルの一部として使用、×=使用しない

<details>
<summary>keywords</summary>

base_layout.tag, page_template.tag, subwindow_page_template.tag, errorpage_template.tag, app_top_nav.jsp, app_header.jsp, app_aside.jsp, app_footer.jsp, html_head.jsp, js_include.jsp, template.js, ローカル動作, サーバ動作

</details>

## 業務画面テンプレートの詳細仕様

なし

<details>
<summary>keywords</summary>

詳細仕様, タグファイル, 業務画面テンプレート, base_layout.tag, page_template.tag, errorpage_template.tag

</details>

## 業務画面ベースレイアウト

UI標準に沿った業務画面の基本構造を実装するタグファイル。

**タグファイルパス**: `/WEB-INF/tags/template/base_layout.tag`

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| title | 文字列 | ○ | 画面のタイトル文字列。ウィンドウタイトルおよびヘッダ領域に表示 |
| topNavHtml | JSP (HTML) | ○ | トップナビゲーション領域に表示するJSP |
| headerHtml | JSP (HTML) | ○ | ヘッダコンテンツ領域に表示するJSP |
| bodyLayoutHtml | JSP (HTML) | ○ | ボディ領域に表示するJSP |
| footerHtml | JSP (HTML) | ○ | フッターコンテンツ領域に表示するJSP |
| localCss | JSP (CSS) | | 当該画面でのみ使用するCSS定義。`<head>`タグ内の`<style>`タグに出力 |
| localJs | JSP (JavaScript) | | 当該画面でのみ使用するJavaScript。ページ末端（`<body>`閉じタグ直前）の`<n:script>`タグに出力 |
| localInclude | JSP (HTML) | | ページごとにロードする外部スクリプト定義。localJsの直前でロード |
| remainSubWindow | 文字列 | | 画面遷移・クローズ後も残すサブウィンドウ名のリスト（カンマ区切り）。デフォルトでは全サブウィンドウを閉じる |
| tabindexOrder | 文字列 | | 出現順序と異なるタブ遷移の順序をID属性（カンマ区切り）で指定 |
| whenToClose | 文字列 | | イベント式を定義し、画面を閉じる機能を拡張 |

**インクルードファイル**

| 名称 | パス | 内容 |
|---|---|---|
| HTMLヘッド部 | /include/html_head.jsp | `<head>`タグに`<meta>`タグ（キャッシュ関連）、`<title>`タグ、`<link>`タグ（共通CSS）を出力 |
| JavaScriptファイルロード部 | /include/js_include.jsp | `<body>`の閉じタグ直前にJavaScriptファイルの読み込み（`<script src>`）を出力 |

<details>
<summary>keywords</summary>

base_layout.tag, title, topNavHtml, headerHtml, bodyLayoutHtml, footerHtml, localCss, localJs, localInclude, remainSubWindow, tabindexOrder, whenToClose, ベースレイアウト

</details>

## 業務画面標準テンプレート

大半の業務画面で使用するテンプレート。UI標準で定められた業務画面のレイアウトのうち業務機能領域以外の部分を実装。ベースレイアウトをもとにボディ部分をサイドコンテンツとメインコンテンツの2ペインに分割。**必須属性は画面タイトル（title）とメインコンテンツ（contentHtml）のみ。**

**タグファイルパス**: `/WEB-INF/tags/template/page_template.tag`

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| title | 文字列 | ○ | 画面のタイトル文字列。ウィンドウタイトルおよびヘッダ領域に表示 |
| confirmationPageTitle | 文字列 | | 確認画面のタイトル文字列。ウィンドウタイトルおよびヘッダ領域に表示 |
| contentHtml | JSP (HTML) | ○ | メインコンテンツ領域に表示するJSP |
| topNavHtml | JSP (HTML) | | トップナビゲーション領域に表示するJSP。省略時は/WEB-INF/app_top_nav.jspの内容を出力 |
| headerHtml | JSP (HTML) | | ヘッダコンテンツ領域に表示するJSP。省略時は/WEB-INF/app_header.jspの内容を出力 |
| asideHtml | JSP (HTML) | | サイドコンテンツ領域に表示するJSP。省略時は/WEB-INF/app_aside.jspの内容を出力 |
| footerHtml | JSP (HTML) | | フッターコンテンツ領域に表示するJSP。省略時は/WEB-INF/app_footer.jspの内容を出力 |
| noMenu | 真偽値 | | "true"を設定するとサイドコンテンツ領域を使用しない1カラムレイアウトになる |
| localCss | JSP (CSS) | | 当該画面でのみ使用するCSS定義。`<head>`タグ内の`<style>`タグに出力 |
| localJs | JSP (JavaScript) | | 当該画面でのみ使用するJavaScript。ページ末端（`<body>`閉じタグ直前）の`<n:script>`タグに出力 |
| tabindexOrder | 文字列 | | 出現順序と異なるタブ遷移の順序をID属性（カンマ区切り）で指定 |
| remainSubWindow | 文字列 | | 画面遷移・クローズ後も残すサブウィンドウ名のリスト（カンマ区切り）。デフォルトでは全サブウィンドウを閉じる |
| whenToClose | 文字列 | | イベント式を定義し、画面を閉じる機能を拡張 |

**インクルードファイル**

| 名称 | パス | 内容 |
|---|---|---|
| メインナビゲーション | /include/app_top_nav.jsp | トップナビゲーション領域にログインステータスやトップレベルリンクなどを表示 |
| 業務共通ヘッダ | /include/app_header.jsp | ヘッダコンテンツ領域にブランドロゴや画面タイトルなどを表示 |
| 業務共通メニュー | /include/app_aside.jsp | サイドコンテンツ領域に業務メニューなどを表示 |
| 業務共通フッター | /include/app_footer.jsp | フッターコンテンツ領域に著作権表示やプライバシーポリシーへのリンクなどを表示 |
| グローバルエラー領域 | /include/app_error.jsp | グローバルエラーのメッセージを表示 |

<details>
<summary>keywords</summary>

page_template.tag, title, confirmationPageTitle, contentHtml, topNavHtml, headerHtml, asideHtml, footerHtml, noMenu, localCss, localJs, tabindexOrder, remainSubWindow, whenToClose, 2ペインレイアウト, サイドコンテンツ, メインコンテンツ

</details>

## エラー画面テンプレート

共通エラー画面で使用するテンプレート。業務画面JSPとは異なりサイドメニュー等は表示されない。エラーメッセージのみを表示する簡素な画面構成。

**タグファイルパス**: `/WEB-INF/tags/template/errorpage_template.tag`

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| title | 文字列 | ○ | 画面のタイトル文字列。ウィンドウタイトルおよびヘッダ領域に表示 |
| errorMessageHtml | JSP (HTML) | ○ | エラーメッセージのJSP |

<details>
<summary>keywords</summary>

errorpage_template.tag, title, errorMessageHtml, エラー画面テンプレート, 共通エラー画面

</details>

## ローカル動作時の挙動

ローカル動作時のJSPページテンプレートタグの評価は `js/jsp/taglib/template.js` によって行われる。サーバ動作時と同じタグファイル・インクルードJSPを読み込んでレンダリングする。

> **重要**: Firefoxブラウザを除き、ローカル環境でのタグファイルの動的読み込み（XHR）が許容されていない。タグファイルおよびインクルードJSPファイルは `js/devtool.js` 内にミニファイした状態で提供されるため、タグファイルの修正内容をローカル動作で確認するにはミニファイ操作が必要。詳細は [generate_javascript](ui-framework-plugin_build.md) を参照。

<details>
<summary>keywords</summary>

template.js, devtool.js, generate_javascript, ローカル動作, ミニファイ, XHR, タグファイル動的読み込み

</details>
