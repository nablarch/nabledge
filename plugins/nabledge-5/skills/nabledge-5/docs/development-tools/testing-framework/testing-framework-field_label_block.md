# 表示ブロックウィジェット

**公式ドキュメント**: [表示ブロックウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_label_block.html)

## コードサンプル

## コードサンプル

設計成果物（ローカル動作）:

```jsp
<field:block title="配送予定">
  <field:calendar
      title="配送希望日"
      required="true"
      sample="">
  </field:calendar>
  <field:label_block
      title="配送オプション">
      <p>配送オプションの指定はプレミアム会員の方のみ可能です。</p>
  </field:label_block>
</field:block>
```

実装成果物（サーバ動作）:

```jsp
<field:block title="配送設定">
  <field:calendar
      title="配送希望日"
      required="true"
      name="W11AC03.deliveryDate"
      sample="">
  </field:calendar>
  <field:label_block
      title="配送オプション">
      <p>配送オプションの指定はプレミアム会員の方のみ可能です。</p>
  </field:label_block>
</field:block>
```

<details>
<summary>keywords</summary>

field:label_block, 表示ブロックウィジェット, JSPコードサンプル, ローカル動作, サーバ動作

</details>

## 仕様

## 仕様

ボディ部に指定された内容をそのまま出力する。ローカル動作とサーバ動作での挙動は同じ。

属性値一覧（◎ 必須属性 ○ 任意属性 × 無効）:

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 項目名 | 文字列 | ◎ | ◎ | |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する、「表示情報取得元」.「表示項目名」の形式で設定する。 |
| comment | ラベル表示についての備考 | 文字列 | × | × | 設計書の表示時に、画面項目定義の項目定義一覧で、「備考」に表示される。 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に、画面項目定義の項目定義一覧で、「備考」に表示される。 |

<details>
<summary>keywords</summary>

title, dataFrom, comment, initialValueDesc, 属性値一覧, 表示ブロックウィジェット仕様

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

部品一覧:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/label_block.tag | [field_label_block](testing-framework-field_label_block.md) の実体となるタグファイル |

<details>
<summary>keywords</summary>

label_block.tag, タグファイル, 部品一覧, 内部構造

</details>
