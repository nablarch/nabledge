# 項目間・セマンティック精査仕様定義ウィジェット

## 概要

`spec:validation` は、当該画面から送信するリクエストに対してサーバ側で実施する**項目間精査**および各種**セマンティック精査**（DB上のデータとの突合や、ビジネスロジック上の精査）を記述するためのウィジェットである。

**単項目精査仕様**については、各入力項目のドメイン定義に準じて実施されるため、このウィジェットに記述する必要はない。

<details>
<summary>keywords</summary>

spec:validation, 項目間精査, セマンティック精査, DB突合, ビジネスロジック精査, 単項目精査, ドメイン定義

</details>

## コードサンプル

**基本例**

```jsp
<spec:validation
  name="日付大小関係精査"
  target="利用開始日, 利用終了日"
  condition="対象項目が両方入力されている場合、利用開始日≦利用終了日であること。"
  messageId="M000000013">
</spec:validation>
```

**メッセージに埋め込み変数がある場合**

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

spec:validation, messageParam, 埋め込み変数

</details>

## 仕様

ローカル動作時の挙動: JSPプレビュー表示には影響しないが、設計書ビューの「項目精査」欄に反映される。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| name | 精査処理名称 | 文字列 | × | ○ | |
| target | 対象項目名 | 文字列 | × | ○ | |
| condition | 精査成功条件 | 文字列 | × | ○ | |
| messageId | エラーメッセージID | 文字列 | × | ○ | `/js/devtool/resource/メッセージ定義.js` に合致するメッセージが存在しない場合は設定された値をそのまま赤字で表示する |
| messageParam | エラーメッセージ内で使用する埋込みパラメータの内容 | 文字列 | × | ○ | |

<details>
<summary>keywords</summary>

spec:validation属性, name, target, condition, messageId, messageParam, 設計書ビュー, 項目精査欄

</details>

## 内部構造・改修時の留意点

サーバ表示で動作するタグファイル(`validation.tag`)はJSPコンパイルを通すためだけのダミーファイル（中身なし）。

設計書ビューはテンプレートファイル `SpecSheetTemplate.xlsx` と表示内容制御スクリプト `SpecSheetInterpreter.js` で構成される。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/spec/validation.tag | `spec:validation` のタグファイル |
| /js/jsp/taglib/spec.js | ローカル表示用スタブ |
| /js/devtool/SpecSheetView.js | 設計書ビューJavaScriptUI部品 |
| /js/devtool/SpecSheetInterpreter.js | 設計書ビュー表示内容制御スクリプト |
| /tools/specsheet_template/SpecSheetTemplate.xlsx | 設計書ビューテンプレートファイル |
| /tools/specsheet_template/SpecSheetTemplate.files | 設計書ビューテンプレートファイル（HTML形式保存版） |

<details>
<summary>keywords</summary>

validation.tag, SpecSheetTemplate.xlsx, SpecSheetInterpreter.js, SpecSheetView.js, 設計書ビュー構成

</details>
