# 表示ブロックウィジェット

## 表示ブロックウィジェット

[field_label_block](ui-framework-field_label_block.md) はボディ部に記述したマークアップをフィールドの内容としてそのまま表示するウィジェット。ボディ部に指定された内容をそのまま出力するだけの機能を提供する。ローカル動作とサーバ動作での挙動は同じ。

## 使用例

```jsp
<field:label_block
    title="配送オプション">
    <p>配送オプションの指定はプレミアム会員の方のみ可能です。</p>
</field:label_block>
```

## 属性値一覧

◎ 必須属性、○ 任意属性、× 無効（指定しても効果なし）

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 項目名 | 文字列 | ◎ | ◎ | |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式で設定 |
| comment | ラベル表示についての備考 | 文字列 | × | × | 設計書表示時に画面項目定義の項目定義一覧の「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書表示時に画面項目定義の項目定義一覧の「備考」に表示 |

## 部品一覧

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/label_block.tag | [field_label_block](ui-framework-field_label_block.md) の実体となるタグファイル |

<details>
<summary>keywords</summary>

field:label_block, label_block.tag, 表示ブロックウィジェット, ボディ部マークアップ表示, title属性, JSPタグ, ローカル動作, サーバ動作, dataFrom, comment, initialValueDesc

</details>
