# 設計書作成日付情報ウィジェット

## コードサンプル

[spec_created_date](ui-framework-spec_created_date.md) は当該画面の作成日付を記述するタグ。設計書ビューのヘッダー部分の「作成」欄に表示される。

> **注意**: JSPのサーバ表示の内容には一切影響しない。実装工程以降も削除不要。

```jsp
<spec:author>TIS 田嶋 岩魚</spec:author>
<spec:updated_by>TIS 名部 楽太郎</spec:updated_by>
<spec:created_date>2014/01/04</spec:created_date>
<spec:updated_date>2014/01/08</spec:updated_date>
```

<details>
<summary>keywords</summary>

spec:created_date, 設計書作成日付, 設計書ビュー, 作成欄, JSPサーバ表示非影響

</details>

## 仕様

属性値の定義なし。ボディ部に設定された文字列を設計書ビューの作成欄にそのまま表示する。

<details>
<summary>keywords</summary>

spec:created_date, 属性値なし, 設計書ビュー作成欄表示

</details>

## 内部構造・改修時の留意点

サーバ表示で動作するタグファイル（created_date.tag）はJSPコンパイル通過のためだけの空ファイル。

設計書ビューはSpecSheetTemplate.xlsxとSpecSheetInterpreter.jsで構成される。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/created_date.tag | [spec_created_date](ui-framework-spec_created_date.md) のタグファイル |
| /js/jsp/taglib/spec.js | ローカル表示用スタブ |
| /js/devtool/SpecSheetView.js | 設計書ビューJavaScriptUI部品 |
| /js/devtool/SpecSheetInterpreter.js | 設計書ビュー表示内容制御スクリプト |
| /tools/specsheet_template/SpecSheetTemplate.xlsx | 設計書ビューテンプレートファイル |
| /tools/specsheet_template/SpecSheetTemplate.files | 設計書ビューテンプレートファイル（HTML形式保存版） |

<details>
<summary>keywords</summary>

created_date.tag, SpecSheetTemplate.xlsx, SpecSheetInterpreter.js, SpecSheetView.js, 設計書ビュー構成部品

</details>
