# ラジオボタン入力項目ウィジェット

## コードサンプル

[field_radio](ui-framework-field_radio.md) はUI標準 UI部品 ラジオボタンの内容に準拠したラジオボタンリストを出力するウィジェット。

**バリエーション:**
- [field_code_radio](ui-framework-field_code_radio.md) — Nablarchコード定義をもとにしたラジオボタンリストを表示する場合に使用

**設計成果物 (ローカル動作)**:
```jsp
<field:radio
  title="性別"
  listFormat="sp"
  sample="[男性]|女性">
</field:radio>
```

**実装成果物 (サーバ動作)**:
```jsp
<field:radio
  title="性別"
  name="formdata.gender"
  cssClass="gender"
  readonly="false"
  listName="gender"
  listFormat="sp"
  elementLabelPattern="$LABEL$"
  elementLabelProperty="name"
  elementValueProperty="id"
  sample="[男性]|女性">
</field:radio>
```

<details>
<summary>keywords</summary>

field_radio, field_code_radio, ラジオボタン入力ウィジェット, JSPタグ, ローカル動作, listFormat, sample

</details>

## 仕様

[field_base](ui-framework-field_base.md) の共通仕様を継承（共通属性はここでは省略）。

**ローカル動作時の挙動:**
- 入力画面: `sample` に指定したラベル分のラジオボタンを `listFormat` の形式で表示（デフォルトは改行区切り）
- 確認画面: `"[]"` で囲われた選択済み項目のラベルを表示

**属性値一覧** (◎必須 ○任意 ×無効)

| 名称 | 内容 | 型 | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| disabled | サーバへの入力値送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 複数の入力項目を一つのエラーメッセージでハイライトする場合に指定 | 文字列 | ○ | × | |
| listName | 選択項目のリストの属性名 | 文字列 | ◎ | × | |
| elementLabelProperty | リスト要素から値を取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementValueProperty | リスト要素からラベルを取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementLabelPattern | ラベルを整形するフォーマットパターン | 文字列 | ○ | × | |
| listFormat | リスト表示時のフォーマット | 文字列 | ○ | ○ | デフォルト: `span` |
| sample | ローカル動作時に表示するラジオボタンのラベル | 文字列 | × | ○ | `"|"` 区切りで複数指定。`"[]"` で囲われた項目は選択状態で表示 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式で設定 |
| comment | ラジオボタンについての備考 | 文字列 | × | × | 設計書の画面項目定義の備考欄に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義の備考欄に表示 |

<details>
<summary>keywords</summary>

listName, elementLabelProperty, elementValueProperty, listFormat, sample, readonly, disabled, domain, cssClass, nameAlias, elementLabelPattern, dataFrom, comment, initialValueDesc, ラジオボタン属性一覧, field_base, 確認画面表示

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/radio.tag | [field_radio](ui-framework-field_radio.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:radioButtons>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（ラジオボタンに関する定義を含む） |

<details>
<summary>keywords</summary>

radio.tag, base.tag, nablarch.js, base.less, 内部構造, n:radioButtons

</details>
