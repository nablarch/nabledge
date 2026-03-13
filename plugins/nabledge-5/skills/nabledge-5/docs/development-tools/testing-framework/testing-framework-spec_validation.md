# 項目間・セマンティック精査仕様定義ウィジェット

**公式ドキュメント**: [項目間・セマンティック精査仕様定義ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/spec_validation.html)

## コードサンプル

`spec:validation` タグの使用例:

**基本例（日付大小関係精査）:**
```jsp
<spec:validation
  name="日付大小関係精査"
  target="利用開始日, 利用終了日"
  condition="対象項目が両方入力されている場合、利用開始日≦利用終了日であること。"
  messageId="M000000013">
</spec:validation>
```

**埋め込み変数を使用する場合（messageParam指定）:**
```jsp
<spec:validation
  name="未来日精査"
  target="利用開始日, 利用終了日"
  condition="対象項目が未来日でないこと。(現在の業務日付≧利用開始日、利用終了日であること)"
  messageId="M000000014"
  messageParam="変数:業務日付">
</spec:validation>
```

<details>
<summary>keywords</summary>

spec:validation, 項目間精査, セマンティック精査, JSPタグ使用例, messageParam, messageId, 埋め込み変数

</details>

## 仕様

`spec:validation` は項目間精査およびセマンティック精査（DBデータとの突合やビジネスロジック上の精査）を記述するためのウィジェット。単項目精査仕様については、各入力項目のドメイン定義に準じて実施されるため、ここに記述する必要はない。

ローカル動作時: JSPプレビュー表示には影響しないが、設計書ビューの「項目精査」欄に反映される。

**属性値一覧** (◎ 必須 / ○ 任意 / × 無効)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| name | 精査処理名称 | 文字列 | × | ○ | |
| target | 対象項目名 | 文字列 | × | ○ | |
| condition | 精査成功条件 | 文字列 | × | ○ | |
| messageId | エラーメッセージID | 文字列 | × | ○ | `/js/devtool/resource/メッセージ定義.js` に合致するメッセージが存在しない場合は設定された値をそのまま赤字で表示する |
| messageParam | エラーメッセージ内で使用する埋込みパラメータの内容 | 文字列 | × | ○ | |

<details>
<summary>keywords</summary>

spec:validation属性, name, target, condition, messageId, messageParam, 設計書ビュー, 項目精査欄, ローカル動作, 単項目精査, ドメイン定義, 記述不要

</details>

## 内部構造・改修時の留意点

サーバ表示用タグファイル (`validation.tag`) はJSPコンパイルを通すためだけのダミーファイル（中身なし）。

設計書ビューは `SpecSheetTemplate.xlsx`（テンプレートファイル）と `SpecSheetInterpreter.js`（表示内容制御スクリプト）で構成される。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/validation.tag | spec_validation のタグファイル |
| /js/jsp/taglib/spec.js | ローカル表示用スタブ |
| /js/devtool/SpecSheetView.js | 設計書ビューJavaScriptUI部品 |
| /js/devtool/SpecSheetInterpreter.js | 設計書ビュー表示内容制御スクリプト |
| /tools/specsheet_template/SpecSheetTemplate.xlsx | 設計書ビューテンプレートファイル |
| /tools/specsheet_template/SpecSheetTemplate.files | 設計書ビューテンプレートファイル（上記ファイルをHTML形式で保存したもの） |

<details>
<summary>keywords</summary>

validation.tag, SpecSheetTemplate.xlsx, SpecSheetTemplate.files, SpecSheetInterpreter.js, SpecSheetView.js, spec.js, 設計書ビュー, 部品一覧, ダミーファイル, ローカル表示用スタブ

</details>
