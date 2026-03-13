# 設計書更新者情報ウィジェット

**公式ドキュメント**: [設計書更新者情報ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/spec_updated_by.html)

## コードサンプル

[spec_updated_date](testing-framework-spec_updated_date.md) は当該画面の更新者情報を記述するタグ。本タグの内容は、設計書ビューのヘッダ部分の「変更」欄に表示される。

> **補足**: この部品はJSPのサーバ表示の内容には一切影響しない。実装工程以降も削除する必要はない。

```jsp
<spec:author>TIS 田嶋 岩魚</spec:author>
<spec:updated_by>TIS 名部 楽太郎</spec:updated_by>
<spec:created_date>2014/01/04</spec:created_date>
<spec:updated_date>2014/01/08</spec:updated_date>
```

<details>
<summary>keywords</summary>

spec:updated_by, 設計書更新者情報ウィジェット, 設計書ビュー, JSPタグ, 変更欄

</details>

## 仕様

属性値は定義されていない。ボディ部に設定された文字列を設計書ビューの変更欄にそのまま表示する。

<details>
<summary>keywords</summary>

設計書更新者情報, 変更欄表示, 属性値なし, ボディ部テキスト表示

</details>

## 内部構造・改修時の留意点

サーバ表示用タグファイル(`updated_by.tag`)はJSPコンパイルを通すためだけの空ファイル。設計書ビューは`SpecSheetTemplate.xlsx`と`SpecSheetInterpreter.js`で構成される。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/updated_by.tag | [spec_updated_by](testing-framework-spec_updated_by.md) のタグファイル |
| /js/jsp/taglib/spec.js | ローカル表示用スタブ |
| /js/devtool/SpecSheetView.js | 設計書ビューJavaScriptUI部品 |
| /js/devtool/SpecSheetInterpreter.js | 設計書ビュー表示内容制御スクリプト |
| /tools/specsheet_template/SpecSheetTemplate.xlsx | 設計書ビューテンプレートファイル |
| /tools/specsheet_template/SpecSheetTemplate.files | 設計書ビューテンプレートファイル（上記ファイルをHTML形式で保存したもの） |

<details>
<summary>keywords</summary>

updated_by.tag, SpecSheetTemplate.xlsx, SpecSheetInterpreter.js, SpecSheetView.js, 設計書ビュー内部構造, タグファイル, 空ファイル, spec.js, SpecSheetTemplate.files

</details>
