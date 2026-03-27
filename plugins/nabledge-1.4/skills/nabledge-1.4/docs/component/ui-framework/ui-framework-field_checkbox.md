# チェックボックス入力項目ウィジェット

## コードサンプル

[field_checkbox](ui-framework-field_checkbox.md) のバリエーション（用途に応じて使い分ける）:

- [field_code_checkbox](ui-framework-field_code_checkbox.md): Nablarchコード定義の内容をもとにしたチェックボックスリストを表示する場合に使用
- [column_checkbox](ui-framework-column_checkbox.md): 処理対象行を複数選択するためのチェックボックスを各行のカラム中に表示する場合に使用

**設計成果物（ローカル動作）**:
```jsp
<field:checkbox
  title="利用航空会社"
  listFormat="ul"
  sample="[AAA航空]|BBBエアライン|[CCCエアシステム]">
</field:checkbox>
```

**実装成果物（サーバ動作）**:
```jsp
<field:checkbox
  title="利用航空会社"
  name="formdata.company"
  cssClass="company"
  readonly="true"
  listName="companies"
  listFormat="ul"
  elementLabelPattern="$LABEL$"
  elementLabelProperty="name"
  elementValueProperty="id"
  sample="[AAA航空]|BBBエアライン|[CCCエアシステム]">
</field:checkbox>
```

<details>
<summary>keywords</summary>

field:checkbox, チェックボックスウィジェット, field_code_checkbox, column_checkbox, sample属性, listFormat属性, ローカル動作, サーバ動作

</details>

## 仕様

[field_base](ui-framework-field_base.md) の共通仕様を用いて実装。field_baseの共通属性についてはここでは省略。

**ローカル動作時の挙動**:
- 入力画面: `sample` に指定したラベル分のチェックボックスとラベルを表示。各組は `listFormat` 指定の形式で表示（デフォルトでは改行区切り）。
- 確認画面: 選択済み項目（`"[]"` で囲われた項目）のラベル一覧を表示。

**属性値一覧**（field_baseの共通属性は除く。◎=必須 ○=任意 ×=無効）:

| 名称 | タイプ | サーバ | ローカル | デフォルト | 説明 |
|---|---|---|---|---|---|
| domain | 文字列 | ○ | ○ | | 項目のドメイン型 |
| readonly | 真偽値 | ○ | ○ | false | 編集可能かどうか |
| disabled | 真偽値 | ○ | ○ | false | サーバに対する入力値の送信を抑制するかどうか |
| cssClass | 文字列 | ○ | ○ | | HTMLのclass属性値 |
| nameAlias | 文字列 | ○ | × | | 複数の入力項目を一つのエラーメッセージでハイライト表示する場合に指定 |
| listName | 文字列 | ◎ | × | | 選択項目のリストの属性名 |
| elementLabelProperty | 文字列 | ◎ | × | | リスト要素から値を取得するためのプロパティ名 |
| elementValueProperty | 文字列 | ◎ | × | | リスト要素からラベルを取得するためのプロパティ名 |
| elementLabelPattern | 文字列 | ○ | × | | ラベルを整形するためのフォーマットパターン |
| listFormat | 文字列 | ○ | ○ | span | リスト表示時に使用するフォーマット |
| sample | 文字列 | × | ○ | | ローカル動作時に表示するチェックボックスのラベル。`"|"` 区切りで複数指定。`"[]"` で囲われた項目は選択状態で表示。 |
| dataFrom | 文字列 | × | × | | 表示するデータの取得元。「表示情報取得元」.「表示項目名」の形式で設定。 |
| comment | 文字列 | × | × | | 設計書の画面項目定義の備考に表示。 |
| initialValueDesc | 文字列 | × | × | | 設計書の画面項目定義の備考に表示。初期表示内容に関する説明。 |

<details>
<summary>keywords</summary>

listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, sample, readonly, disabled, cssClass, nameAlias, domain, dataFrom, comment, initialValueDesc, チェックボックス属性一覧, ローカル動作時挙動, 確認画面

</details>

## 内部構造・改修時の留意点

**部品一覧**:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/checkbox.tag | [field_checkbox](ui-framework-field_checkbox.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:checkboxes>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。チェックボックスに関する定義を含む。 |

<details>
<summary>keywords</summary>

checkbox.tag, base.tag, nablarch.js, n:checkboxes, base.less, 部品一覧

</details>
