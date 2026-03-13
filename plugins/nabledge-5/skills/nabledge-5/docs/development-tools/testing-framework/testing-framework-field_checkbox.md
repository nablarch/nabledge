# チェックボックス入力項目ウィジェット

**公式ドキュメント**: [チェックボックス入力項目ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_checkbox.html)

## コードサンプル

チェックボックスのリストを出力するウィジェット。

**バリエーション（用途に応じて使い分けること）**:
- [field_code_checkbox](testing-framework-field_code_checkbox.md): Nablarchコード定義をもとにしたチェックボックスリストを表示する場合
- [column_checkbox](testing-framework-column_checkbox.md): 処理対象行を複数選択するためのチェックボックスを各行のカラム中に表示する場合

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

field_checkbox, field_code_checkbox, column_checkbox, チェックボックス入力, バリエーション選択, ローカル動作, listFormat, sample, サンプルコード

</details>

## 仕様

[field_base](testing-framework-field_base.md) の共通仕様を継承する。共通属性は [field_base](testing-framework-field_base.md) を参照。

**ローカル動作時の挙動**:
- 入力画面: `sample` に指定したラベル分のチェックボックスとラベルを `listFormat` の形式で表示（デフォルトは改行区切り）
- 確認画面: `"[]"` で囲われた項目（選択済み）のラベル一覧を表示

**属性値一覧** (◎必須 ○任意 ×無効)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 複数入力項目を一つのエラーメッセージでハイライト表示する場合に指定 | 文字列 | ○ | × | |
| listName | 選択項目のリストの属性名 | 文字列 | ◎ | × | |
| elementLabelProperty | リスト要素から値を取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementValueProperty | リスト要素からラベルを取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementLabelPattern | ラベルを整形するフォーマットパターン | 文字列 | ○ | × | |
| listFormat | リスト表示フォーマット | 文字列 | ○ | ○ | デフォルト: `span` |
| sample | ローカル動作時のチェックボックスラベル | 文字列 | × | ○ | `"\|"` 区切りで複数指定。`"[]"` で囲うと選択状態で表示 |
| dataFrom | 表示データ取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」形式で設定 |
| comment | チェックボックスについての備考 | 文字列 | × | × | 画面項目定義の「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 画面項目定義の「備考」に表示 |

<details>
<summary>keywords</summary>

listName, elementLabelProperty, elementValueProperty, elementLabelPattern, listFormat, sample, domain, readonly, disabled, cssClass, nameAlias, dataFrom, comment, initialValueDesc, 属性一覧, チェックボックス仕様, 確認画面表示

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/checkbox.tag | [field_checkbox](testing-framework-field_checkbox.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:checkboxes>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。チェックボックスに関する定義も含まれる |

<details>
<summary>keywords</summary>

checkbox.tag, base.tag, nablarch.js, base.less, 部品一覧, 内部構造, タグライブラリスタブ

</details>
