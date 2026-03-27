# 入力項目ウィジェット共通テンプレート

## 概要とコードサンプル

[field_base](ui-framework-field_base.md) は [field_text](ui-framework-field_text.md) や [field_checkbox](ui-framework-field_checkbox.md) などの入力項目UI部品の実装で使用するテンプレートである。このテンプレートでは以下の内容を実装している。

- 各入力項目のレイアウト(ラベル、入力項目、項目別エラー、補助テキストなどの表示制御)
- 必須項目の表現

[field_base](ui-framework-field_base.md) は [../internals/jsp_widgets](ui-framework-jsp_widgets.md) の実装に用いるテンプレートであり、業務画面JSPから直接使用することはない。

<details>
<summary>keywords</summary>

field_base, field_text, field_checkbox, 入力項目UI部品, テンプレート, 各入力項目のレイアウト, ラベル, 入力項目, 項目別エラー, 補助テキスト, 表示制御, 必須項目の表現, jsp_widgets, 業務画面JSPから直接使用不可, テンプレート用途

</details>

## 仕様

**属性値一覧** [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| fieldContent | フィールド入力部タグ | JSPフラグメント | ◎ | ◎ | |
| title | 項目名 | 文字列 | ◎ | ◎ | |
| name | HTMLのname属性値 | 文字列 | ◎ | ○ | |
| required | 必須項目かどうか | 真偽値 | ○ | ○ | デフォルト値は `false` |
| hint | 入力内容や留意点などの補助テキスト | 文字列 | ○ | ○ | |
| fieldClass | 入力フィールドのDIVに付与するcssClass | 文字列 | ○ | ○ | |
| titleSize | タイトル部の幅(グリッド数) | 数値 | ○ | ○ | [multicol_mode](ui-framework-multicol_css_framework.md) で使用する |
| inputSize | 入力部の幅(グリッド数) | 数値 | ○ | ○ | [multicol_mode](ui-framework-multicol_css_framework.md) で使用する |

<details>
<summary>keywords</summary>

fieldContent, title, name, required, hint, fieldClass, titleSize, inputSize, 属性値一覧, 必須属性, 任意属性, multicol_mode, 入力項目ウィジェット属性

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /css/style/nablarch.less | エラー表示領域のスタイル定義 |

<details>
<summary>keywords</summary>

base.tag, nablarch.less, エラー表示領域, CSSスタイル定義, 内部構造, 部品一覧

</details>
