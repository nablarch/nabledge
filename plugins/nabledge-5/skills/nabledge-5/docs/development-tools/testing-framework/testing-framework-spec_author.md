# 設計書作成者情報ウィジェット

**公式ドキュメント**: [設計書作成者情報ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/spec_author.html)

## コードサンプル

> **補足**: この部品はJSPのサーバ表示の内容には一切影響しない。実装工程以降も削除する必要はない。

```jsp
<spec:author>TIS 田嶋 岩魚</spec:author>
<spec:updated_by>TIS 名部 楽太郎</spec:updated_by>
<spec:created_date>2014/01/04</spec:created_date>
<spec:updated_date>2014/01/08</spec:updated_date>
```

<details>
<summary>keywords</summary>

spec:author, spec:updated_by, spec:created_date, spec:updated_date, 設計書作成者情報ウィジェット, JSPサーバ表示非影響

</details>

## 仕様

属性値は定義されていない。ボディ部に設定された文字列を設計書ビューの作成者欄にそのまま表示する。

<details>
<summary>keywords</summary>

spec:author 仕様, 属性値なし, 設計書ビュー作成者欄表示

</details>

## 内部構造・改修時の留意点

サーバ表示用タグファイル（`author.tag`）はJSPコンパイルを通すためだけの空ファイル。設計書ビューは `SpecSheetTemplate.xlsx` と `SpecSheetInterpreter.js` によって構成される。

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/spec/author.tag` | [spec_author](testing-framework-spec_author.md) のタグファイル |
| `/js/jsp/taglib/spec.js` | ローカル表示用スタブ |
| `/js/devtool/SpecSheetView.js` | 設計書ビューJavaScriptUI部品 |
| `/js/devtool/SpecSheetInterpreter.js` | 設計書ビュー表示内容制御スクリプト |
| `/tools/specsheet_template/SpecSheetTemplate.xlsx` | 設計書ビューテンプレートファイル |
| `/tools/specsheet_template/SpecSheetTemplate.files` | 設計書ビューテンプレートファイル（HTML形式で保存したもの） |

<details>
<summary>keywords</summary>

author.tag, SpecSheetTemplate.xlsx, SpecSheetInterpreter.js, SpecSheetView.js, 設計書ビュー内部構造, spec.js

</details>
