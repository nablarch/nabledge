# 設計書更新日付情報ウィジェット

**公式ドキュメント**: [設計書更新日付情報ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/spec_updated_date.html)

## 設計書更新日付情報ウィジェット

[spec_updated_date](testing-framework-spec_updated_date.md) は画面の更新日付情報を記述するタグ。設計書ビューのヘッダ「変更」欄に表示される。

> **補足**: JSPのサーバ表示には一切影響しない。実装工程以降も削除不要。

**属性**: なし。ボディ部に設定した文字列を設計書ビューの変更欄にそのまま表示する。

**使用例**:
```jsp
<spec:author>TIS 田嶋 岩魚</spec:author>
<spec:updated_by>TIS 名部 楽太郎</spec:updated_by>
<spec:created_date>2014/01/04</spec:created_date>
<spec:updated_date>2014/01/08</spec:updated_date>
```

**部品一覧**:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/updated_date.tag | タグファイル（JSPコンパイル通過用の空ファイル） |
| /js/jsp/taglib/spec.js | ローカル表示用スタブ |
| /js/devtool/SpecSheetView.js | 設計書ビューJavaScriptUI部品 |
| /js/devtool/SpecSheetInterpreter.js | 設計書ビュー表示内容制御スクリプト |
| /tools/specsheet_template/SpecSheetTemplate.xlsx | 設計書ビューテンプレートファイル |
| /tools/specsheet_template/SpecSheetTemplate.files | 設計書ビューテンプレートファイル（HTML形式） |

<details>
<summary>keywords</summary>

spec:updated_date, 設計書更新日付, 設計書ビュー, updated_date.tag, SpecSheetView.js, SpecSheetInterpreter.js, SpecSheetTemplate.xlsx

</details>
