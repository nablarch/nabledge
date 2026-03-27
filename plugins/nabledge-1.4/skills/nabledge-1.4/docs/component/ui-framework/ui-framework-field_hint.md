# 入力内容注記表示ウィジェット

## 概要

field_hint は、入力フォームの各項目の入力内容に関する注記を表示するウィジェットである。field_text などの各入力フィールドに **hint** 属性を指定する場合とほぼ等価であるが、**field_hint では任意のマークアップを含めることができる**点が異なる。

<details>
<summary>keywords</summary>

field_hint, 任意マークアップ, hint属性との違い, field_text hint属性, 入力内容注記表示ウィジェット

</details>

## コードサンプル

**JSPコードサンプル** (サーバ動作):

```jsp
<field:password title="パスワード"
                domain="パスワード"
                required="true"
                maxlength="20"
                name="W11AC02.newPassword"
                sample="password">
</field:password>
<field:password title="パスワード（確認用）"
                domain="パスワード"
                required="true"
                maxlength="20"
                name="W11AC02.confirmPassword"
                sample="password">
</field:password>
<field:hint>半角英数記号20文字以内</field:hint>
```

<details>
<summary>keywords</summary>

field:hint, field:password, 入力内容注記表示, JSPコードサンプル, 注記ウィジェット使用例

</details>

## 仕様

入力画面では、ボディ部に指定された内容の先頭に **(※ )** を付加して表示する。確認画面では何も表示しない。ローカル動作とサーバ動作の挙動は同じ。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| プロパティ名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| gridSize | 幅(グリッド数) | 数値 | ○ | ○ | [multicol_mode](ui-framework-multicol_css_framework.md)\で使用する |

<details>
<summary>keywords</summary>

gridSize, 入力内容注記, 確認画面非表示, multicol_mode, 属性値一覧

</details>

## 内部構造・改修時の留意点

**部品一覧**:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/hint.tag | [field_hint](ui-framework-field_hint.md) の実体となるタグファイル |

<details>
<summary>keywords</summary>

hint.tag, タグファイル, 部品構成, /WEB-INF/tags/widget/field/hint.tag

</details>
