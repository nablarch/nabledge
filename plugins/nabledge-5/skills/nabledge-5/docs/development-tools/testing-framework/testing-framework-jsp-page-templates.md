# 業務画面テンプレート

## 概要

[業務画面テンプレート](../../development-tools/testing-framework/testing-framework-jsp-page-templates.md) は、業務画面の内容のうち、業務機能領域を除く部分を
**UI標準** に準拠した形で実装する共通機能である。

本機能を使用することで、以下のコード例のように、最小限の
コード記述により画面を作成することが可能となる。

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

## ファイル構成

### 概要

[業務画面テンプレート](../../development-tools/testing-framework/testing-framework-jsp-page-templates.md) はJSPタグファイルとそれに付随するインクルードJSPファイルの形式で提供される。
業務画面JSPから参照するのはタグファイルの方で、インクルードJSPはタグファイルから読み込まれる。
JSPタグファイルには基本的にページの構造のみを定義し、各共通領域の内容については
それぞれ個別のインクルードJSPを用意してそこに記述する。

JSPタグファイルは **(サーブレットコンテキストルート)/WEB-INF/tags/template/** 配下となり、
インクルードJSPファイルは **(サーブレットコンテキストルート)/WEB-INF/include** 配下に配置する。

インクルードJSPのうち、 **HTMLヘッド部定義JSP** と、 **外部スクリプト定義JSP** については、
外部参照するCSS/JavaScriptの読み込みを制御しており、開発/本番切り替え時に書き換えの対象となるため、
留意が必要である。

以下の表は、 [業務画面テンプレート](../../development-tools/testing-framework/testing-framework-jsp-page-templates.md) に含まれるファイルの一覧である。

### 構成ファイル一覧

| 名称 | 動作環境 [2] |  | パス | 内容 |
|---|---|---|---|---|
| ベースレイアウトファイル | △ | ○ | /WEB-INF/tags/template/ base_layout.tag | UI標準に沿った業務画面の基本構造を実   装するタグファイル。 |
| 業務画面共通テンプレート | △ | ○ | /WEB-INF/tags/template/    * page_template.tag   * subwindow_page_template.tag | 大半の業務画面で使用するテンプレート。  業務画面のレイアウトのうち、業務機能領   域以外の大半の部分を実装する。  **subwindow_page_template.tag** は、  サブウィンドウ用 |
| エラー画面共通テンプレート | △ | ○ | /WEB-INF/tags/template/ errorpage_template.tag | 共通エラー画面を実装するテンプレート。 |
| トップナビゲーション領域JSP | △ | ○ | /WEB-INF/include/   * app_top_nav.jsp   * subwindow_app_top_nav.jsp | 業務画面のトップナビゲーション領域を 実装するJSP。  **subwindow_app_top_nav.jsp** は、   サブウィンドウ用 |
| ヘッダ領域JSP | △ | ○ | /WEB-INF/include/   * app_header.jsp   * subwindow_app_header.jsp | 業務画面のヘッダ領域を実装するJSP。   **subwindow_app_header.jsp** は、   サブウィンドウ用 |
| サイドメニュー領域JSP | △ | ○ | /WEB-INF/include/app_aside.jsp | 業務画面のサイドメニュー領域を実装するJSP。 |
| フッター領域JSP | △ | ○ | /WEB-INF/include/   * app_footer.jsp   * subwindow_app_footer.jsp | 業務画面のフッター領域を実装するJSP。  **subwindow_app_footer.jsp** は、   サブウィンドウ用 |
| HTMLヘッド部定義JSP | △ | ○ | /WEB-INF/include/html_head.jsp | HTMLの<head>タグの内容を定義するJSP。  キャッシュ制御用の<meta>タグや、cssの   読み込みなどを制御している。 |
| 外部スクリプト定義JSP | △ | ○ | /WEB-INF/include/js_include.jsp | HTMLの<script>タグによる外部スクリプト参照を定義するJSP。 |
| ローカル動作用スタブ | ○ | × | /js/jsp/taglib/template.js | ローカル動作時に当該のタグファイルを読み込んでレンダリングするJavaScript。 |

**「サーバ」:**

実働環境にデプロイして使用するかどうか

**「ローカル」:**

ローカル動作時に使用するかどうか

**○ :**

使用する

**△ :**

直接は使用しないがミニファイしたファイルの一部として使用する。

**× :**

使用しない

## 業務画面テンプレートの詳細仕様

### 業務画面ベースレイアウト

UI標準に沿った業務画面の基本構造を実装するタグファイル。

**タグファイルパス**

/WEB-INF/tags/template/base_layout.tag

**属性値一覧**

| 名称 | プロパティ | 内容 | 型 | 必須指定 |
|---|---|---|---|---|
| 画面タイトル | title | 画面のタイトル文字列を設定する。  設定された文字列はウィンドウの   タイトル及びヘッダ領域に表示さ   れる。 | 文字列 | 必須 |
| トップナビゲーション | topNavHtml | トップナビゲーション領域に表示   するJSPを記述する。 | JSP (HTML) | 必須 |
| ヘッダコンテンツ | headerHtml | ヘッダコンテンツ領域に表示する   JSPを記述する。 | JSP (HTML) | 必須 |
| ボディレイアウト | bodyLayoutHtml | ボディ領域に表示するJSPを記述   する。 | JSP (HTML) | 必須 |
| フッターコンテンツ | footerHtml | フッターコンテンツ領域に表示   するJSPを記述する。 | JSP (HTML) | 必須 |
| 画面毎CSS | localCss | 当該画面でのみ使用するCSS定   義を記述する。ここに記述し   たCSSは **<head>** タグ内の   **<style>** タグに出力される。 | JSP (CSS) | 任意 |
| 画面毎JS | localJs | 当該画面でのみ使用する   JavaScriptを記述する。ここ   に記述したJavaScriptは   ページの末端(<body>の終了   タグの直前)に置かれた   **<n:script>** タグに出力   される。 | JSP (JavaScript) | 任意 |
| ページ毎外部スクリプト | localInclude | ページごとにロードする外部   スクリプト定義を記述する。  ここに記述した外部スクリプト   は **localJs**の直前で   ロードされる | JSP (HTML) | 任意 |
| 独立サブウィンドウ名 | remainSubWindow | このウィンドウから開いた   サブウィンドウのうち、この   ウィンドウを画面遷移もしく   は閉じた後も閉じずにそのま   ま残すサブウィンドウ名の   リスト(カンマ区切り)。  デフォルトでは全ての   サブウィンドウを閉じる。 | 文字列 | 任意 |
| タブインデックス順 | tabindexOrder | 出現順序と異なるタブ遷移をする   場合に順序を領域のID属性で指定   する。(ID属性はカンマ区切りで   指定する。) | 文字列 | 任意 |
| クローズイベント定義 | whenToClose | イベント式を定義し、画面を閉じ   る機能を拡張する。 | 文字列 | 任意 |

**インクルードファイル一覧**

| 名称 | パス | 内容 |
|---|---|---|
| HTMLヘッド部 | /WEB-INF/include/html_head.jsp | **<head>** タグに以下の内容を出力する。  * **<meta>** タグ (キャッシュ関連のHTTPヘッダなど) * **<title>** タグ * **<link>** タグ (共通CSSファイルのインクルードなど) |
| JavaScriptファイルロード部 | /WEB-INF/include/js_include.jsp | **<body>** の閉じタグの直前に、JavaScriptファイルの読み込み処理( **<script src>** )を出力する。 |

### 業務画面標準テンプレート

大半の業務画面で使用するテンプレート。
UI標準で定められた業務画面のレイアウトの中で、業務機能領域以外の部分を実装している。

上の **ベースレイアウト** をもとにしており、ボディ部分を
サイドコンテンツとメインコンテンツの2ペインに分割している。

また、共通部分のJSPをインクルードすることで最小限の記述で画面を構築できるように配慮されている。
(必須属性は、画面タイトルとメインコンテンツのみである。)

**タグファイルパス**

/WEB-INF/tags/template/page_template.tag

**属性値一覧**

| 名称 | プロパティ | 内容 | 型 | 必須指定 |
|---|---|---|---|---|
| 画面タイトル | title | 画面のタイトル文字列を設定する。  設定された文字列はウィンドウの   タイトル及びヘッダ領域に表示さ   れる。 | 文字列 | 必須 |
| 確認画面タイトル | confirmationPageTitle | 確認画面のタイトル文字列を設定   する。  設定された文字列はウィンドウの   タイトル及びヘッダ領域に表示さ   れる。 | 文字列 | 任意 |
| メインコンテンツ | contentHtml | メインコンテンツ領域に表示する   JSPを記述する。 | JSP (HTML) | 必須 |
| トップナビゲーション | topNavHtml | トップナビゲーション領域に表示   するJSPを記述する。省略した場   合はインクルードJSP   (/WEB-INF/app_top_nav.jsp)の内   容を出力する。 | JSP (HTML) | 任意 |
| ヘッダコンテンツ | headerHtml | ヘッダコンテンツ領域に表示する   JSPを記述する。省略した場合は   インクルードJSP   (/WEB-INF/app_header.jsp)の内   容を出力する。 | JSP (HTML) | 任意 |
| サイドコンテンツ | asideHtml | サイドコンテンツ領域に表示する   JSPを記述する。省略した場合は   インクルードJSP   (/WEB-INF/app_aside.jsp)の内   容を出力する。 | JSP (HTML) | 任意 |
| フッターコンテンツ | footerHtml | フッターコンテンツ領域に表示する   JSPを記述する。省略した場合は   インクルードJSP   (/WEB-INF/app_footer.jsp)の内   容を出力する。 | JSP (HTML) | 任意 |
| サイドコンテンツを省略 | noMenu | サイドコンテンツ領域を使用しない   場合は"true"を設定することで、   ページ構成がいわゆる1カラム   レイアウトになる。 | 真偽値 | 任意 |
| 画面毎CSS | localCss | 当該画面でのみ使用するCSS定義を   記述する。ここに記述したCSSは    **<head>** タグ内の**<style>**    タグに出力される。 | JSP (CSS) | 任意 |
| 画面毎JS | localJs | 当該画面でのみ使用するJavaScript   を記述する。ここに記述した   JavaScriptはページの末端(<body>   の終了タグの直前)に置かれた   **<n:script>** タグに出力される。 | JSP (JavaScript) | 任意 |
| タブインデックス順 | tabindexOrder | 出現順序と異なるタブ遷移をする場   合に順序を領域のID属性で指定する。  (ID属性はカンマ区切りで指定する。) | 文字列 | 任意 |
| 独立サブウィンドウ名 | remainSubWindow | このウィンドウから開いた   サブウィンドウの内、このウィンドウ   を画面遷移もしくは閉じた後も閉じず   にそのまま残すサブウィンドウ名の   リスト(カンマ区切り)。デフォルトで   は全てのサブウィンドウを閉じる。 | 文字列 | 任意 |
| クローズイベント定義 | whenToClose | イベント式を定義し、画面を閉じる機   能を拡張する。 | 文字列 | 任意 |

**インクルードファイル一覧**

| 名称 | パス | 内容 |
|---|---|---|
| メインナビゲーション | /WEB-INF/include/app_top_nav.jsp | メインナビゲーション領域に、ログインステータスや、 トップレベルリンクなどを表示する。 |
| 業務共通ヘッダ | /WEB-INF/include/app_header.jsp | ヘッダコンテンツ領域にブランドロゴや画面タイトルなどを 表示する。 |
| 業務共通メニュー | /WEB-INF/include/app_aside.jsp | サイドコンテンツ領域に業務メニューなどを表示する。 |
| 業務共通フッター | /WEB-INF/include/app_footer.jsp | フッターコンテンツ領域に著作権表示や プライバシーポリシーへのリンクなどを表示する。 |
| グローバルエラー領域 | /WEB-INF/include/app_error.jsp | グローバルエラーのメッセージを表示する。 |

### エラー画面テンプレート

共通エラー画面で使用するテンプレート。
業務画面JSPとは異なりサイドメニュー等は表示されない。
エラーメッセージのみを表示する簡素な画面構成となる。

**タグファイルパス**

/WEB-INF/tags/template/errorpage_template.tag

**属性値一覧**

| 名称 | プロパティ | 内容 | 型 | 必須指定 |
|---|---|---|---|---|
| 画面タイトル | title | 画面のタイトル文字列を設定する。 設定された文字列はウィンドウのタイトル及び ヘッダ領域に表示される。 | 文字列 | 必須 |
| エラーメッセージ | errorMessageHtml | エラーメッセージのJSP。 | JSP (HTML) | 必須 |

## ローカル動作時の挙動

ローカル動作時でのJSPページテンプレートタグの評価は、 **js/jsp/taglib/template.js** によって行われる。
このスクリプトは、サーバ動作時と同じタグファイルを読み込んでレンダリングを行う。
JSPページテンプレートタグがインクルードしているJSP類も、同様にサーバ動作時と同じものを読み込んでレンダリングする。

ただし、Firefoxブラウザを除き、ローカル環境でのタグファイルの動的読み込み(XHR)が許容されていないため、
タグファイルおよびインクルードJSPファイルは **js/devtool.js** 内にミニファイした状態で提供する。
このため、タグファイルの修正内容をローカル動作で確認するには、ミニファイ操作が必要である。
詳細は [JavaScriptの自動生成](../../development-tools/testing-framework/testing-framework-plugin-build.md#javascriptの自動生成) を参照すること。
