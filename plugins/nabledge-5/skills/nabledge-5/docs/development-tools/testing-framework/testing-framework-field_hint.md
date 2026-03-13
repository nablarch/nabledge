# 入力内容注記表示ウィジェット

**公式ドキュメント**: [入力内容注記表示ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_hint.html)

## コードサンプル

[field_hint](testing-framework-field_hint.md) は入力フォームの各項目の入力内容に関する注記を表示するウィジェット。[field_text](testing-framework-field_text.md) などの各入力フィールドに **hint** 属性を指定する場合とほぼ等価だが、任意のマークアップを含めることができる点が異なる。

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

field_hint, 入力内容注記表示, hintウィジェット, 任意マークアップ, field_text

</details>

## 仕様

入力画面ではボディ部に指定された内容の先頭に既定のマーク **(※ )** を追加して表示する。確認画面では何も表示しない。ローカル動作とサーバ動作の挙動は同じ。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| gridSize | 幅(グリッド数) | 数値 | ○ | ○ | [multicol_mode](testing-framework-multicol_css_framework.md) で使用する |

<details>
<summary>keywords</summary>

gridSize, 入力画面表示, 確認画面非表示, 注記マーク, multicol_mode

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/hint.tag | [field_hint](testing-framework-field_hint.md) の実体となるタグファイル |

<details>
<summary>keywords</summary>

hint.tag, タグファイル, 内部構造, 部品一覧

</details>
