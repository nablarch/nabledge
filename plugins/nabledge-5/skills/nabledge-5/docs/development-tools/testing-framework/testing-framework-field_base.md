# 入力項目ウィジェット共通テンプレート

**公式ドキュメント**: [入力項目ウィジェット共通テンプレート](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_base.html)

## コードサンプル

[field_base](testing-framework-field_base.md) は [field_text](testing-framework-field_text.md) や [field_checkbox](testing-framework-field_checkbox.md) などの入力項目UI部品の実装で使用するテンプレートであり、業務画面JSPから直接使用することはない。このテンプレートでは以下の内容を実装している。

- 各入力項目のレイアウト（ラベル、入力項目、項目別エラー、補助テキストなどの表示制御）
- 必須項目の表現

<details>
<summary>keywords</summary>

field_base, field_text, field_checkbox, JSPウィジェット実装テンプレート, 業務画面JSP直接利用不可, 入力項目ウィジェット共通テンプレート, 入力項目レイアウト, ラベル表示制御, 項目別エラー表示, 補助テキスト表示, 必須項目表現

</details>

## 仕様

**属性値一覧** (◎ 必須属性 / ○ 任意属性)

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| fieldContent | フィールド入力部タグ | JSPフラグメント | ◎ | ◎ | |
| title | 項目名 | 文字列 | ◎ | ◎ | |
| name | HTMLのname属性値 | 文字列 | ◎ | ○ | |
| required | 必須項目かどうか | 真偽値 | ○ | ○ | デフォルト値: `false` |
| hint | 入力内容や留意点などの補助テキスト | 文字列 | ○ | ○ | |
| fieldClass | 入力フィールドのDIVに付与するcssClass | 文字列 | ○ | ○ | |
| titleSize | タイトル部の幅(グリッド数) | 数値 | ○ | ○ | [multicol_mode](testing-framework-multicol_css_framework.md) で使用 |
| inputSize | 入力部の幅(グリッド数) | 数値 | ○ | ○ | [multicol_mode](testing-framework-multicol_css_framework.md) で使用 |

<details>
<summary>keywords</summary>

fieldContent, title, name, required, hint, fieldClass, titleSize, inputSize, 入力項目属性, フィールドレイアウト, 必須項目制御, マルチカラムモード

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/field/base.tag` | [field_base](testing-framework-field_base.md) |
| `/css/style/nablarch.less` | エラー表示領域のスタイル定義 |

<details>
<summary>keywords</summary>

base.tag, nablarch.less, 内部構造, エラー表示スタイル, 部品一覧

</details>
