# 設計書更新日付情報ウィジェット

## コードサンプル

[spec_updated_date](ui-framework-spec_updated_date.md) は当該画面の更新日付情報を記述するタグ。本タグの内容は設計書ビューのヘッダー部分の「変更」欄に表示される。

> **注意**: この部品はJSPのサーバ表示の内容には一切影響しない。実装工程以降も削除する必要はない。

```jsp
<spec:author>TIS 田嶋 岩魚</spec:author>
<spec:updated_by>TIS 名部 楽太郎</spec:updated_by>
<spec:created_date>2014/01/04</spec:created_date>
<spec:updated_date>2014/01/08</spec:updated_date>
```

<details>
<summary>keywords</summary>

spec:updated_date, 設計書更新日付情報, 設計書ビュー, 更新日付タグ, JSPサーバ表示非影響

</details>

## 仕様

本タグに属性値は定義されていない。ボディ部に設定された文字列を設計書ビューの変更欄にそのまま表示する。

<details>
<summary>keywords</summary>

属性値なし, 設計書ビュー変更欄表示, ボディ部文字列, updated_dateタグ仕様

</details>

## 内部構造・改修時の留意点

サーバ表示で動作するタグファイル(`updated_date.tag`)はJSPコンパイルを通すためだけの空ファイル。

設計書ビューはテンプレートファイル`SpecSheetTemplate.xlsx`と各項目の表示内容を制御する`SpecSheetInterpreter.js`によって構成される。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/updated_date.tag | [spec_updated_date](ui-framework-spec_updated_date.md) のタグファイル |
| /js/jsp/taglib/spec.js | ローカル表示用スタブ |
| /js/devtool/SpecSheetView.js | 設計書ビューJavaScriptUI部品 |
| /js/devtool/SpecSheetInterpreter.js | 設計書ビュー表示内容制御スクリプト |
| /tools/specsheet_template/SpecSheetTemplate.xlsx | 設計書ビューテンプレートファイル |
| /tools/specsheet_template/SpecSheetTemplate.files | 設計書ビューテンプレートファイル(HTML形式保存版) |

<details>
<summary>keywords</summary>

updated_date.tag, SpecSheetTemplate.xlsx, SpecSheetTemplate.files, SpecSheetInterpreter.js, SpecSheetView.js, 設計書ビュー構成, 部品一覧

</details>
