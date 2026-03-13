# UI部品ウィジェット

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/internals/jsp_widgets.html) [2](https://nablarch.github.io/docs/LATEST/doc/_static/ui_dev/yuidoc/classes/nablarch.ui.DatePicker.html)

## 概要

[jsp_widgets](testing-framework-jsp_widgets.md) はUI部品（ボタン・入力フィールド・テーブルなど）をUI標準に準拠した形で実装したJSPタグファイル。HTMLより高い抽象度で業務画面を定義できるため記述コード量を大幅削減可能。JSPに見た目の記述が含まれないため、画面デザイン変更が入っても業務画面JSPへの影響が発生しない。業務機能設計と画面デザインのワークフローを並行で進める際のリスクを最小化できる。

## ウィジェット使用例

```jsp
<n:form windowScopePrefixes="W11AC02,11AC_W11AC01">
  <field:block title="ユーザ基本情報">
    <field:text title="ログインID" domain="LOGIN_ID" required="true" maxlength="20"
                hint="半角英数記号20文字以内" name="W11AC02.systemAccount.loginId" sample="test01"/>
    <field:password title="パスワード" domain="PASSWORD" required="true" maxlength="20"
                    name="W11AC02.newPassword" sample="password"/>
    <field:password title="パスワード（確認用）" domain="PASSWORD" required="true" maxlength="20"
                    name="W11AC02.confirmPassword" sample="password"/>
    <field:hint>半角英数記号20文字以内</field:hint>
  </field:block>
</n:form>
```

## 名前空間分類

| 名前空間 | 内容 |
|---|---|
| button | 画面遷移用ボタン。UI標準の標準文言・サイズに沿ったボタンをデフォルト表示 |
| field | 入出力項目（単行テキスト、プルダウン、ラジオボタン、カレンダー日付入力など） |
| link | UI標準「リンク」に準じたリンク |
| tab | UI標準「タブ」。ページ内タブ切り替え（JavaScript）と画面遷移によるタブ切り替えの双方を実現 |
| table | 検索結果テーブルなど各種テーブル。内部で `<listSearchResult:xxx>` タグを使用 |
| column | テーブルの各行内容（テキスト、詳細リンク、チェックボックスなど）を定義 |
| box | 画面内を構造化するウィジェット群 |

<details>
<summary>keywords</summary>

JSPウィジェット, UI部品, UI標準, JSPタグファイル, 名前空間, button, field, link, tab, table, column, box, ウィジェット分類, field:hint, field:block

</details>

## 構造

[jsp_widgets](testing-framework-jsp_widgets.md) の本体はウィジェットごとに作成されるJSPタグファイル。必要に応じて [js_framework](testing-framework-js_framework.md) やスタイルファイルが付随する。

## field:calendarタグファイル主要属性

[../reference_jsp_widgets/field_calendar](testing-framework-field_calendar.md) は [nablarch_DatePicker](https://nablarch.github.io/docs/LATEST/doc/_static/ui_dev/yuidoc/classes/nablarch.ui.DatePicker.html) をマーカCSSで使用する。

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| title | ○ | | 項目名 |
| name | ○ | | HTMLのname属性値 |
| domain | | | 項目のドメイン型 |
| required | | | 必須項目かどうか |
| readonly | | | 編集可能かどうか |
| disabled | | | サーバへの入力値送信を抑制するかどうか |
| id | | name属性と同じ | HTMLのid属性値 |
| maxlength | | 10 | 入力文字数の上限（format指定時はformatに依存） |
| format | | yyyy/MM/dd | 日付フォーマット |
| locale | | ja | 言語設定 |
| example | | | 入力例テキスト（placeholder等で表示） |
| hint | | | 入力内容や留意点の補助テキスト |
| nameAlias | | | 複数入力項目をハイライト表示する場合に指定（項目間精査など） |
| sample | | | テスト用のダミー入力値（**本番動作では使用されない**） |
| cssClass | | | HTMLのclass属性値 |
| dataFrom | | | 【設計書用】表示するデータの取得元。「表示情報取得元」.「表示項目名」の形式で設定する |
| comment | | | 【設計書用】画面項目定義の項目定義一覧で備考欄に表示される備考テキスト |
| initialValueDesc | | | 【設計書用】初期表示内容に関する説明 |
| titleSize | | | 【マルチレイアウト用】タイトル部の幅（グリッド数）※マルチレイアウトモードの場合に使用する |
| inputSize | | | 【マルチレイアウト用】入力部の幅（グリッド数）※マルチレイアウトモードの場合に使用する |

## カレンダーボタンの動作制約

カレンダーボタンは `<n:forInputPage>` ブロック内にラップされているため、**入力ページでのみレンダリングされる**。参照画面・出力画面ではカレンダーボタンは表示されない。

disabled/readonlyが真の場合、カレンダーボタンに `disabled="disabled"` 属性を付加する。

<details>
<summary>keywords</summary>

JSPタグファイル構造, field:calendar, タグファイル実装例, マーカCSS, nablarch_DatePicker, sample属性, dateFormat, locale, dataFrom, comment, initialValueDesc, titleSize, inputSize, 設計書用属性, マルチレイアウト, n:forInputPage, カレンダーボタン, 入力ページ

</details>

## buttonタグ

| 構成要素 | ローカル | サーバ | パス |
|---|---|---|---|
| `<button:xxx>` タグファイル | ○ | ○ | `/WEB-INF/tags/widget/button/*.tag` |
| `<button:xxx>` スタブ | ○ | × | `/js/jsp/taglib/button.js` |

- タグファイル: ボタンカテゴリのJSPタグファイル群
- スタブ: ローカル動作時にタグファイルを読み込んでローカルレンダリングを行うスクリプト（サーバ環境では使用しない）

<details>
<summary>keywords</summary>

button:xxx, ボタンウィジェット, /WEB-INF/tags/widget/button, button.js, ローカルレンダリング

</details>

## fieldタグ

| 構成要素 | ローカル | サーバ | パス | 備考 |
|---|---|---|---|---|
| `<field:xxx>` タグファイル | ○ | ○ | `/WEB-INF/tags/widget/field/*.tag` | |
| `<field:xxx>` スタブ | ○ | × | `/js/jsp/taglib/field.js` | |
| カレンダー日付入力機能 | ○ | △ | `/js/nablarch/ui/DatePicker.js` | `<field:calendar>` で内部使用 |
| リストビルダー機能 | ○ | △ | `/js/nablarch/ui/ListBuilder.js` | `<field:listbuilder>` で内部使用 |
| プレースホルダー機能 | ○ | △ | `/js/nablarch/ui/Placeholder.js` | テキスト入力タグ全般で使用 |
| 入力不可項目機能 | ○ | △ | `/js/nablarch/ui/readonly.js` | `<field:pulldown>` など入力項目タグ全般で使用 |

△ = 直接は使用しないがミニファイしたファイルの一部として使用する。

<details>
<summary>keywords</summary>

field:xxx, 入出力項目ウィジェット, DatePicker.js, ListBuilder.js, Placeholder.js, readonly.js, /WEB-INF/tags/widget/field, field.js

</details>

## linkタグ

| 構成要素 | ローカル | サーバ | パス |
|---|---|---|---|
| `<link:xxx>` タグファイル | ○ | ○ | `/WEB-INF/tags/widget/link/*.tag` |
| `<link:xxx>` スタブ | ○ | × | `/js/jsp/taglib/link.js` |

- タグファイル: リンクカテゴリのJSPタグファイル群
- スタブ: ローカル動作時にタグファイルを読み込んでローカルレンダリングを行うスクリプト（サーバ環境では使用しない）

<details>
<summary>keywords</summary>

link:xxx, リンクウィジェット, /WEB-INF/tags/widget/link, link.js

</details>

## tabタグ

| 構成要素 | ローカル | サーバ | パス | 備考 |
|---|---|---|---|---|
| `<tab:xxx>` タグファイル | ○ | ○ | `/WEB-INF/tags/widget/tab/*.tag` | |
| `<tab:xxx>` スタブ | ○ | × | `/js/jsp/taglib/tab.js` | |
| タブ表示機能 | ○ | △ | `/js/nablarch/ui/Tab.js` | `<tab:content>` で使用 |

△ = 直接は使用しないがミニファイしたファイルの一部として使用する。

<details>
<summary>keywords</summary>

tab:xxx, タブウィジェット, Tab.js, /WEB-INF/tags/widget/tab, tab.js, tab:content

</details>

## tableタグ

| 構成要素 | ローカル | サーバ | パス | 備考 |
|---|---|---|---|---|
| `<table:xxx>` タグファイル | ○ | ○ | `/WEB-INF/tags/widget/table/*.tag` | |
| `<table:xxx>` スタブ | ○ | × | `/js/jsp/taglib/table.js` | ローカル動作で表示するダミーデータのレコード件数などを設定 |
| listSearchResultタグ | ○ | ○ | `/WEB-INF/tags/listSearchResult/*.tag` | `<table:xxx>` が内部使用するNablarchフレームワーク提供の検索結果テーブル表示用共通部品 |
| listSearchResultスタブ | ○ | × | `/js/jsp/taglib/listsearchresult.js` | |
| 階層テーブル表示機能 | ○ | △ | `/js/nablarch/ui/TreeList.js` | `<table:treelist>` で使用 |

△ = 直接は使用しないがミニファイしたファイルの一部として使用する。

<details>
<summary>keywords</summary>

table:xxx, テーブルウィジェット, listSearchResult, TreeList.js, /WEB-INF/tags/widget/table, table.js, listsearchresult.js, table:treelist

</details>

## columnタグ

| 構成要素 | ローカル | サーバ | パス |
|---|---|---|---|
| `<column:xxx>` タグファイル | ○ | ○ | `/WEB-INF/tags/widget/column/*.tag` |
| `<column:xxx>` スタブ | ○ | ○ | `/js/jsp/taglib/column.js` |

columnカテゴリのスタブはローカル・サーバ両環境で使用される（他カテゴリのスタブはローカルのみ）。

<details>
<summary>keywords</summary>

column:xxx, カラムウィジェット, /WEB-INF/tags/widget/column, column.js

</details>

## boxタグ

| 構成要素 | ローカル | サーバ | パス |
|---|---|---|---|
| `<box:XXX>` タグファイル | ○ | ○ | `/WEB-INF/tags/widget/box/*.tag` |
| `<box:XXX>` スタブ | ○ | × | `/js/jsp/taglib/box.js` |

- タグファイル: ボックスカテゴリのJSPタグファイル群
- スタブ: ローカル動作時にタグファイルを読み込んでローカルレンダリングに使用するファイル（サーバ環境では使用しない）

<details>
<summary>keywords</summary>

box:XXX, ボックスウィジェット, /WEB-INF/tags/widget/box, box.js

</details>

## ローカル動作時の挙動

ローカル動作時のJSPウィジェットタグの評価は `/js/jsp/taglib/` 配下にカテゴリの名前空間ごとに用意されたスタブ動作スクリプトによって行われる。スクリプトはカテゴリ内の当該タグファイルを読み込んでその内容をレンダリングする。

<details>
<summary>keywords</summary>

ローカル動作, スタブ動作スクリプト, /js/jsp/taglib/, ローカルレンダリング, JSPウィジェットタグ評価

</details>
