# ラジオボタン入力項目ウィジェット

**公式ドキュメント**: [ラジオボタン入力項目ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_radio.html)

## コードサンプル

バリエーション: Nablarchコード定義をもとにしたラジオボタンリストを表示する場合は [field_code_radio](testing-framework-field_code_radio.md) を使用する。

**設計成果物（ローカル動作）**

```jsp
<field:radio
  title="性別"
  listFormat="sp"
  sample="[男性]|女性">
</field:radio>
```

**実装成果物（サーバ動作）**

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

field:radio, field_code_radio, ラジオボタン入力項目ウィジェット, コードサンプル, JSPウィジェット, ローカル動作, サーバ動作

</details>

## 仕様

**ローカル動作時の挙動**
- 入力画面: `sample` に指定したラベル分のラジオボタンとラベルを `listFormat` 形式で表示（デフォルトは改行区切り）
- 確認画面: `"[]"` で囲われた選択済み項目のラベル一覧を表示

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

（[field_base](testing-framework-field_base.md) の共通属性は省略）

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合に指定する | 文字列 | ○ | × | |
| listName | 選択項目のリストの属性名 | 文字列 | ◎ | × | |
| elementLabelProperty | リスト要素から値を取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementValueProperty | リスト要素からラベルを取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementLabelPattern | ラベルを整形するためのフォーマットパターン | 文字列 | ○ | × | |
| listFormat | リスト表示時に使用するフォーマット | 文字列 | ○ | ○ | デフォルト: `span` |
| sample | ローカル動作時に表示するラジオボタンのラベル | 文字列 | × | ○ | `"|"` 区切りで複数指定。`"[]"` で囲われた項目は選択状態で表示 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式で設定 |
| comment | ラジオボタンについての備考 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |

<details>
<summary>keywords</summary>

listName, elementLabelProperty, elementValueProperty, listFormat, sample, readonly, disabled, cssClass, nameAlias, domain, elementLabelPattern, dataFrom, comment, initialValueDesc, ラジオボタン属性一覧, 入力画面, 確認画面, ローカル動作挙動

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/radio.tag | [field_radio](testing-framework-field_radio.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:radioButtons>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。ラジオボタンに関する定義も含まれる。 |

<details>
<summary>keywords</summary>

radio.tag, base.tag, nablarch.js, base.less, 内部構造, タグライブラリスタブ, 部品一覧

</details>
