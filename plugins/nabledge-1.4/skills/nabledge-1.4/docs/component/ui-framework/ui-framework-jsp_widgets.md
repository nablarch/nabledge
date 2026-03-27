# UI部品ウィジェット

## 概要

[jsp_widgets](ui-framework-jsp_widgets.md) はUI標準に準拠したJSPタグファイル（ボタン、検索結果テーブル、各種入力フィールドなどのUI部品）。HTMLより一段上の抽象度で業務画面を定義可能なため、コード量を大幅削減できる。JSPに見た目の記述が含まれないため、画面デザイン変更でも既存の業務画面JSPに影響が発生しない。業務機能設計と画面デザインのワークフローを並行進行できる。

## 使用例（入力フォーム）

```jsp
<n:form windowScopePrefixes="W11AC02,11AC_W11AC01">
<field:block title="ユーザ基本情報">
  <field:text title="ログインID" domain="LOGIN_ID" required="true"
              maxlength="20" hint="半角英数記号20文字以内"
              name="W11AC02.systemAccount.loginId" sample="test01" />
  <field:password title="パスワード" domain="PASSWORD" required="true"
                  maxlength="20" name="W11AC02.newPassword" sample="password" />
  <field:password title="パスワード（確認用）" domain="PASSWORD" required="true"
                  maxlength="20" name="W11AC02.confirmPassword" sample="password" />
  <field:hint>半角英数記号20文字以内</field:hint>
</field:block>
</n:form>
```

## ウィジェットの分類（名前空間）

| 名前空間 | 内容 |
|---|---|
| button | 画面遷移用ボタン。UI標準の標準文言（更新、検索など）・標準サイズのボタンをデフォルト表示 |
| field | 各種入力項目（単行テキスト入力、プルダウン、ラジオボタン、カレンダー日付入力など） |
| link | UI標準の「リンク」に準じたリンク |
| tab | UI標準の「タブ」（JSによるページ内タブ切り替えと通常のリンク・画面遷移によるタブ切り替えの双方対応） |
| table | 検索結果テーブルなど。内部的に`<listSearchResult:xxx>`タグを使用 |
| column | テーブル各行の内容定義（テキスト、詳細リンク、処理対象選択用チェックボックスなど） |
| box | 画面内の構造化（PJポリシーでスタイル調整） |

<details>
<summary>keywords</summary>

JSPタグファイル, ウィジェット, UI標準, 名前空間, button, field, link, tab, table, column, box, 入力フォーム, jsp_widgets

</details>

## 構造

[jsp_widgets](ui-framework-jsp_widgets.md) の本体はウィジェットごとに作成されるJSPタグファイル。必要に応じて [js_framework](ui-framework-js_framework.md) やスタイルファイルが付随する。タグファイルは`(サーブレットコンテキストルート)/WEB-INF/tags/widget/`配下にカテゴリごとのサブフォルダに配置。

## タグファイル実装例（field:calendarの属性）

日付入力機能（`nablarch_DatePicker`）をマーカCSSで利用している。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| title | ○ | | 項目名 |
| name | ○ | | HTMLのname属性値 |
| domain | | | 項目のドメイン型 |
| required | | | 必須項目かどうか |
| readonly | | | 編集可能かどうか |
| disabled | | | サーバへの入力値送信を抑制するかどうか |
| id | | name属性と同値 | HTMLのid属性値 |
| cssClass | | | HTMLのclass属性値 |
| maxlength | | 10文字（format未指定時） | 入力文字数の上限 |
| format | | yyyy/MM/dd | 日付フォーマット |
| locale | | ja | 言語設定 |
| example | | | 具体的な入力例（placeholder形式で表示） |
| hint | | | 入力内容や留意点の補助テキスト |
| nameAlias | | | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合に指定（項目間精査など） |
| sample | | | テスト用のダミー入力値（本番動作では使用されない） |
| titleSize | | | タイトル部の幅（グリッド数）※マルチレイアウトモード用 |
| inputSize | | | 入力部の幅（グリッド数）※マルチレイアウトモード用 |
| dataFrom | | | 表示するデータの取得元（「表示情報取得元」.「表示項目名」の形式で設定する）※設計書用 |
| comment | | | このカレンダーについての備考（画面項目定義の項目定義一覧で、備考欄に表示される）※設計書用 |
| initialValueDesc | | | 初期表示内容に関する説明 ※設計書用 |

<details>
<summary>keywords</summary>

タグファイル, WEB-INF/tags/widget, field:calendar, 日付入力, nablarch_DatePicker, マーカCSS, 属性定義, js_framework, sample, dataFrom, comment, initialValueDesc

</details>

## buttonタグ

buttonカテゴリの構成ファイル:

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| `<button:xxx>`タグファイル | ○ | ○ | /WEB-INF/tags/widget/button/*.tag | ボタンカテゴリのタグファイル群 |
| `<button:xxx>`スタブ | ○ | × | /js/jsp/taglib/button.js | ローカルレンダリング用スクリプト |

動作環境凡例: ○=使用する、△=ミニファイしたファイルの一部として使用、×=使用しない

<details>
<summary>keywords</summary>

button, ボタン, WEB-INF/tags/widget/button, button.js, ローカルレンダリング, スタブ

</details>

## fieldタグ

fieldカテゴリの構成ファイル:

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| `<field:xxx>`タグファイル | ○ | ○ | /WEB-INF/tags/widget/field/*.tag | 入出力項目カテゴリのタグファイル群 |
| `<field:xxx>`スタブ | ○ | × | /js/jsp/taglib/field.js | ローカルレンダリング用スクリプト |
| カレンダー日付入力機能 | ○ | △ | /js/nablarch/ui/DatePicker.js | カレンダーを用いて日付を入力させるJavaScript UI部品。`<field:calendar>`タグで内部的に使用 |
| リストビルダー機能 | ○ | △ | /js/nablarch/ui/ListBuilder.js | 2つのリストボックス間の要素移動により項目選択を行うJavaScript UI部品。`<field:listbuilder>`タグで内部的に使用 |
| プレースホルダー機能 | ○ | △ | /js/nablarch/ui/Placeholder.js | HTML5のplaceholder属性をサポートしていないブラウザで同等の機能を実現するJavaScript UI部品。テキスト入力タグ全般で使用 |
| 入力不可項目機能 | ○ | △ | /js/nablarch/ui/readonly.js | HTMLのreadonly属性の拡張機能。テキスト入力だけでなくプルダウンやラジオボタンなどの選択項目にも対応。入力項目タグ全般で使用 |

動作環境凡例: ○=使用する、△=ミニファイしたファイルの一部として使用、×=使用しない

<details>
<summary>keywords</summary>

field, 入力項目, DatePicker, ListBuilder, Placeholder, readonly, カレンダー日付入力, WEB-INF/tags/widget/field, field.js

</details>

## linkタグ

linkカテゴリの構成ファイル:

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| `<link:xxx>`タグファイル | ○ | ○ | /WEB-INF/tags/widget/link/*.tag | リンクカテゴリのタグファイル群 |
| `<link:xxx>`スタブ | ○ | × | /js/jsp/taglib/link.js | ローカルレンダリング用スクリプト |

動作環境凡例: ○=使用する、×=使用しない

<details>
<summary>keywords</summary>

link, リンク, WEB-INF/tags/widget/link, link.js

</details>

## tabタグ

tabカテゴリの構成ファイル:

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| `<tab:xxx>`タグファイル | ○ | ○ | /WEB-INF/tags/widget/tab/*.tag | タブカテゴリのタグファイル群 |
| `<tab:xxx>`スタブ | ○ | × | /js/jsp/taglib/tab.js | ローカルレンダリング用スクリプト |
| タブ表示機能 | ○ | △ | /js/nablarch/ui/Tab.js | ページ内タブ機能を実現するJavaScript UI部品。`<tab:content>`で使用 |

動作環境凡例: ○=使用する、△=ミニファイしたファイルの一部として使用、×=使用しない

<details>
<summary>keywords</summary>

tab, タブ, Tab.js, WEB-INF/tags/widget/tab, タブ切り替え, tab:content

</details>

## tableタグ

tableカテゴリの構成ファイル:

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| `<table:xxx>`タグファイル | ○ | ○ | /WEB-INF/tags/widget/table/*.tag | テーブルカテゴリのタグファイル群 |
| `<table:xxx>`スタブ | ○ | × | /js/jsp/taglib/table.js | ローカルレンダリング用スクリプト。ローカル動作で表示するダミーデータのレコード件数などを設定 |
| listSearchResultタグ | ○ | ○ | /WEB-INF/tags/listSearchResult/*.tag | Nablarchフレームワークが提供する検索結果テーブル表示用の共通部品。`<table:xxx>`タグが内部的に使用 |
| listSearchResultスタブ | ○ | × | /js/jsp/taglib/listsearchresult.js | `<listSearchResult:xxx>`タグのローカルレンダリング用スクリプト |
| 階層テーブル表示機能 | ○ | △ | /js/nablarch/ui/TreeList.js | 組織表のような階層構造を持ったテーブルを表示するJavaScript UI部品。`<table:treelist>`で使用 |

動作環境凡例: ○=使用する、△=ミニファイしたファイルの一部として使用、×=使用しない

<details>
<summary>keywords</summary>

table, テーブル, listSearchResult, TreeList, WEB-INF/tags/widget/table, 検索結果テーブル, 階層テーブル, table:treelist

</details>

## columnタグ

columnカテゴリの構成ファイル:

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| `<column:xxx>`タグファイル | ○ | ○ | /WEB-INF/tags/widget/column/*.tag | カラムカテゴリのタグファイル群 |
| `<column:xxx>`スタブ | ○ | ○ | /js/jsp/taglib/column.js | ローカルレンダリング用スクリプト |

動作環境凡例: ○=使用する

<details>
<summary>keywords</summary>

column, カラム, WEB-INF/tags/widget/column, column.js

</details>

## boxタグ

boxカテゴリの構成ファイル:

| 名称 | ローカル | サーバ | パス | 内容 |
|---|---|---|---|---|
| `<box:XXX>`タグファイル | ○ | ○ | /WEB-INF/tags/widget/box/*.tag | ボックスカテゴリのタグファイル群 |
| `<box:XXX>`スタブ | ○ | × | /js/jsp/taglib/box.js | ローカルレンダリング用スクリプト |

動作環境凡例: ○=使用する、×=使用しない

<details>
<summary>keywords</summary>

box, ボックス, WEB-INF/tags/widget/box, box.js

</details>

## ローカル動作時の挙動

ローカル動作時のJSPウィジェットタグの評価は`js/jsp/taglib/`配下にカテゴリ名前空間ごとに用意されたスタブ動作スクリプトによって行われる。スクリプトはカテゴリ内のタグファイルを読み込んでレンダリングする。

<details>
<summary>keywords</summary>

ローカル動作, スタブ, js/jsp/taglib, ローカルレンダリング, スタブ動作スクリプト

</details>
