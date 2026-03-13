# 業務画面テンプレート

**公式ドキュメント**: [業務画面テンプレート](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/internals/jsp_page_templates.html)

## 概要

業務画面テンプレート（[jsp_page_templates](testing-framework-jsp_page_templates.md)）は、業務画面の業務機能領域を除く部分をUI標準に準拠した形で実装する共通機能。最小限のコード記述で画面を作成可能。

```jsp
<?xml version="1.0" encoding="UTF-8" ?>
<%@taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags/template" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<t:page_template title="新規会員登録">
  <jsp:attribute name="contentHtml">
    <n:form>
    （略）
    </n:form>
  </jsp:attribute>
</t:page_template>
```

<details>
<summary>keywords</summary>

業務画面テンプレート, page_template, t:page_template, UI標準, JSPタグファイル, 業務機能領域

</details>

## ファイル構成

JSPタグファイルとインクルードJSPファイルの形式で提供される。業務画面JSPはタグファイルを参照し、タグファイルがインクルードJSPを読み込む。タグファイルにはページ構造のみ定義し、各共通領域の内容は個別のインクルードJSPに記述する。

- タグファイル配置: `(サーブレットコンテキストルート)/WEB-INF/tags/template/`
- インクルードJSP配置: `(サーブレットコンテキストルート)/WEB-INF/include`

> **重要**: HTMLヘッド部定義JSP（`html_head.jsp`）と外部スクリプト定義JSP（`js_include.jsp`）は外部参照するCSS/JavaScriptの読み込みを制御しており、開発/本番切り替え時に書き換えの対象となる。

<details>
<summary>keywords</summary>

JSPタグファイル, インクルードJSP, WEB-INF/tags/template, WEB-INF/include, html_head.jsp, js_include.jsp, 開発本番切り替え

</details>

## 構成ファイル一覧

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| ベースレイアウトファイル | △ | ○ | /WEB-INF/tags/template/base_layout.tag | UI標準に沿った業務画面の基本構造を実装するタグファイル |
| 業務画面共通テンプレート | △ | ○ | /WEB-INF/tags/template/page_template.tag, subwindow_page_template.tag | 大半の業務画面で使用するテンプレート。業務機能領域以外を実装。subwindow_page_template.tagはサブウィンドウ用 |
| エラー画面共通テンプレート | △ | ○ | /WEB-INF/tags/template/errorpage_template.tag | 共通エラー画面を実装するテンプレート |
| トップナビゲーション領域JSP | △ | ○ | /WEB-INF/include/app_top_nav.jsp, subwindow_app_top_nav.jsp | トップナビゲーション領域を実装。subwindow_app_top_nav.jspはサブウィンドウ用 |
| ヘッダ領域JSP | △ | ○ | /WEB-INF/include/app_header.jsp, subwindow_app_header.jsp | ヘッダ領域を実装。subwindow_app_header.jspはサブウィンドウ用 |
| サイドメニュー領域JSP | △ | ○ | /WEB-INF/include/app_aside.jsp | サイドメニュー領域を実装 |
| フッター領域JSP | △ | ○ | /WEB-INF/include/app_footer.jsp, subwindow_app_footer.jsp | フッター領域を実装。subwindow_app_footer.jspはサブウィンドウ用 |
| HTMLヘッド部定義JSP | △ | ○ | /WEB-INF/include/html_head.jsp | HTMLの`<head>`タグの内容を定義。キャッシュ制御用`<meta>`タグやCSSの読み込みを制御 |
| 外部スクリプト定義JSP | △ | ○ | /WEB-INF/include/js_include.jsp | HTMLの`<script>`タグによる外部スクリプト参照を定義 |
| ローカル動作用スタブ | ○ | × | /js/jsp/taglib/template.js | ローカル動作時にタグファイルを読み込んでレンダリングするJavaScript |

凡例:
- ローカル: ローカル動作時に使用するかどうか
- サーバ: 実働環境にデプロイして使用するかどうか
- ○=使用する
- △=直接は使用しないがミニファイしたファイルの一部として使用
- ×=使用しない

<details>
<summary>keywords</summary>

base_layout.tag, page_template.tag, subwindow_page_template.tag, errorpage_template.tag, app_top_nav.jsp, app_header.jsp, app_aside.jsp, app_footer.jsp, html_head.jsp, js_include.jsp, template.js, 構成ファイル

</details>

## 業務画面ベースレイアウト（base_layout.tag）

**タグファイルパス**: `/WEB-INF/tags/template/base_layout.tag`

UI標準に沿った業務画面の基本構造を実装するタグファイル。

**属性値一覧**

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| title | 文字列 | ○ | 画面のタイトル文字列。ウィンドウのタイトル及びヘッダ領域に表示される |
| topNavHtml | JSP (HTML) | ○ | トップナビゲーション領域に表示するJSP |
| headerHtml | JSP (HTML) | ○ | ヘッダコンテンツ領域に表示するJSP |
| bodyLayoutHtml | JSP (HTML) | ○ | ボディ領域に表示するJSP |
| footerHtml | JSP (HTML) | ○ | フッターコンテンツ領域に表示するJSP |
| localCss | JSP (CSS) | | 当該画面でのみ使用するCSS定義。`<head>`タグ内の`<style>`タグに出力される |
| localJs | JSP (JavaScript) | | 当該画面でのみ使用するJavaScript。`<body>`終了タグ直前の`<n:script>`タグに出力される |
| localInclude | JSP (HTML) | | ページごとにロードする外部スクリプト定義。`localJs`の直前でロードされる |
| remainSubWindow | 文字列 | | 画面遷移/クローズ後も残すサブウィンドウ名のリスト（カンマ区切り）。デフォルトは全サブウィンドウを閉じる |
| tabindexOrder | 文字列 | | 出現順序と異なるタブ遷移をする場合の順序をID属性（カンマ区切り）で指定 |
| whenToClose | 文字列 | | イベント式を定義し、画面を閉じる機能を拡張する |

**インクルードファイル一覧**

| 名称 | パス | 内容 |
|---|---|---|
| HTMLヘッド部 | /WEB-INF/include/html_head.jsp | `<head>`タグに`<meta>`タグ（キャッシュ関連）、`<title>`タグ、`<link>`タグ（共通CSS）を出力 |
| JavaScriptファイルロード部 | /WEB-INF/include/js_include.jsp | `<body>`閉じタグ直前に`<script src>`を出力 |

<details>
<summary>keywords</summary>

base_layout.tag, title, topNavHtml, headerHtml, bodyLayoutHtml, footerHtml, localCss, localJs, localInclude, remainSubWindow, tabindexOrder, whenToClose, 業務画面ベースレイアウト

</details>

## 業務画面標準テンプレート（page_template.tag）

**タグファイルパス**: `/WEB-INF/tags/template/page_template.tag`

大半の業務画面で使用するテンプレート。ベースレイアウトをもとにボディ部分をサイドコンテンツとメインコンテンツの2ペインに分割。必須属性は`title`と`contentHtml`のみ。

**属性値一覧**

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| title | 文字列 | ○ | 画面のタイトル文字列。ウィンドウのタイトル及びヘッダ領域に表示される |
| confirmationPageTitle | 文字列 | | 確認画面のタイトル文字列 |
| contentHtml | JSP (HTML) | ○ | メインコンテンツ領域に表示するJSP |
| topNavHtml | JSP (HTML) | | トップナビゲーション領域に表示するJSP。省略時は`/WEB-INF/app_top_nav.jsp`の内容を出力 |
| headerHtml | JSP (HTML) | | ヘッダコンテンツ領域に表示するJSP。省略時は`/WEB-INF/app_header.jsp`の内容を出力 |
| asideHtml | JSP (HTML) | | サイドコンテンツ領域に表示するJSP。省略時は`/WEB-INF/app_aside.jsp`の内容を出力 |
| footerHtml | JSP (HTML) | | フッターコンテンツ領域に表示するJSP。省略時は`/WEB-INF/app_footer.jsp`の内容を出力 |
| noMenu | 真偽値 | | `"true"`を設定するとサイドコンテンツ領域を省略し1カラムレイアウトになる |
| localCss | JSP (CSS) | | 当該画面でのみ使用するCSS定義。`<head>`タグ内の`<style>`タグに出力される |
| localJs | JSP (JavaScript) | | 当該画面でのみ使用するJavaScript。`<body>`終了タグ直前の`<n:script>`タグに出力される |
| tabindexOrder | 文字列 | | 出現順序と異なるタブ遷移をする場合の順序をID属性（カンマ区切り）で指定 |
| remainSubWindow | 文字列 | | 画面遷移/クローズ後も残すサブウィンドウ名のリスト（カンマ区切り）。デフォルトは全サブウィンドウを閉じる |
| whenToClose | 文字列 | | イベント式を定義し、画面を閉じる機能を拡張する |

**インクルードファイル一覧**

| 名称 | パス | 内容 |
|---|---|---|
| メインナビゲーション | /WEB-INF/include/app_top_nav.jsp | ログインステータスやトップレベルリンクなどを表示 |
| 業務共通ヘッダ | /WEB-INF/include/app_header.jsp | ブランドロゴや画面タイトルなどを表示 |
| 業務共通メニュー | /WEB-INF/include/app_aside.jsp | 業務メニューなどを表示 |
| 業務共通フッター | /WEB-INF/include/app_footer.jsp | 著作権表示やプライバシーポリシーへのリンクなどを表示 |
| グローバルエラー領域 | /WEB-INF/include/app_error.jsp | グローバルエラーのメッセージを表示 |

<details>
<summary>keywords</summary>

page_template.tag, title, confirmationPageTitle, contentHtml, topNavHtml, headerHtml, asideHtml, footerHtml, noMenu, localCss, localJs, tabindexOrder, remainSubWindow, whenToClose, 業務画面標準テンプレート, 2ペイン

</details>

## エラー画面テンプレート（errorpage_template.tag）

**タグファイルパス**: `/WEB-INF/tags/template/errorpage_template.tag`

共通エラー画面で使用するテンプレート。業務画面JSPとは異なりサイドメニュー等は表示されない。エラーメッセージのみを表示する簡素な画面構成。

**属性値一覧**

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| title | 文字列 | ○ | 画面のタイトル文字列。ウィンドウのタイトル及びヘッダ領域に表示される |
| errorMessageHtml | JSP (HTML) | ○ | エラーメッセージのJSP |

<details>
<summary>keywords</summary>

errorpage_template.tag, title, errorMessageHtml, エラー画面テンプレート

</details>

## ローカル動作時の挙動

ローカル動作時のJSPページテンプレートタグの評価は`js/jsp/taglib/template.js`によって行われる。サーバ動作時と同じタグファイルを読み込んでレンダリングする。インクルードしているJSP類も同様にサーバ動作時と同じものを読み込む。

> **重要**: Firefoxを除き、ローカル環境でのタグファイルの動的読み込み（XHR）が許容されていないため、タグファイルおよびインクルードJSPファイルは`js/devtool.js`内にミニファイした状態で提供する。タグファイルの修正内容をローカル動作で確認するには、ミニファイ操作が必要。詳細は[generate_javascript](testing-framework-plugin_build.md)を参照。

<details>
<summary>keywords</summary>

template.js, devtool.js, ローカル動作, ミニファイ, XHR, generate_javascript

</details>
