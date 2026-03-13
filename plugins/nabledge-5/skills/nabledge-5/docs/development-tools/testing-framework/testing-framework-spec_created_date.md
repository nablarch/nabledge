# 設計書作成日付情報ウィジェット

**公式ドキュメント**: [設計書作成日付情報ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/spec_created_date.html)

## コードサンプル

[spec_created_date](testing-framework-spec_created_date.md) は当該画面の作成日付を記述するタグ。設計書ビューのヘッダ部分の「作成」欄に表示される。

> **補足**: この部品はJSPのサーバ表示の内容には一切影響しない。実装工程以降も削除する必要はない。

```jsp
<spec:author>TIS 田嶋 岩魚</spec:author>
<spec:updated_by>TIS 名部 楽太郎</spec:updated_by>
<spec:created_date>2014/01/04</spec:created_date>
<spec:updated_date>2014/01/08</spec:updated_date>
```

<details>
<summary>keywords</summary>

spec:created_date, 設計書作成日付ウィジェット, 設計書ビュー, JSPタグ, 作成日付

</details>

## 仕様

本タグに属性値は定義されていない。ボディ部に設定された文字列を設計書ビューの作成欄にそのまま表示する。

<details>
<summary>keywords</summary>

設計書ビュー表示, ボディ部, 属性値なし, 作成欄

</details>

## 内部構造・改修時の留意点

サーバ表示で動作するタグファイル(created_date.tag)はJSPコンパイルを通すためだけの空ファイル。設計書ビューはSpecSheetTemplate.xlsxとSpecSheetInterpreter.jsで構成される。

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/created_date.tag | [spec_created_date](testing-framework-spec_created_date.md) のタグファイル |
| /js/jsp/taglib/spec.js | ローカル表示用スタブ |
| /js/devtool/SpecSheetView.js | 設計書ビューJavaScriptUI部品 |
| /js/devtool/SpecSheetInterpreter.js | 設計書ビュー表示内容制御スクリプト |
| /tools/specsheet_template/SpecSheetTemplate.xlsx | 設計書ビューテンプレートファイル |
| /tools/specsheet_template/SpecSheetTemplate.files | 設計書ビューテンプレートファイル（上記ファイルをHTML形式で保存したもの） |

<details>
<summary>keywords</summary>

SpecSheetTemplate.xlsx, SpecSheetInterpreter.js, SpecSheetView.js, created_date.tag, 部品一覧

</details>
