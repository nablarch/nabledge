# プルダウン入力項目ウィジェット

**公式ドキュメント**: [プルダウン入力項目ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_pulldown.html)

## コードサンプル

バリエーション: [field_code_pulldown](testing-framework-field_code_pulldown.md) はNablarchコード定義の内容をもとにしたプルダウンリストを表示する場合に使用する。

**設計成果物（ローカル動作）**:
```jsp
<field:pulldown
  title="性別"
  sample="[男性]|女性">
</field:pulldown>
```

**実装成果物（サーバ動作）**:
```jsp
<field:pulldown
  title="性別"
  name="formdata.gender"
  cssClass="gender"
  readonly="false"
  listName="gender"
  elementLabelPattern="$LABEL$"
  elementLabelProperty="name"
  elementValueProperty="id"
  sample="[男性]|女性">
</field:pulldown>
```

<details>
<summary>keywords</summary>

field:pulldown, field_code_pulldown, プルダウンリスト, コードサンプル, ローカル動作, サーバ動作, JSPウィジェット

</details>

## 仕様

[field_base](testing-framework-field_base.md) を用いて実装。共通仕様は [field_base](testing-framework-field_base.md) を参照。

**ローカル動作時の挙動**:
- 入力画面: `sample` に指定した項目を選択候補とするプルダウンリストを表示する
- 確認画面: 選択済み項目（`"[]"` で囲われた項目）のラベルの一覧を表示する

**属性値一覧**（◎=必須 ○=任意 ×=無効）（[field_base](testing-framework-field_base.md) の共通属性は省略）

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| id | HTMLのid属性値（省略時はname属性と同じ値） | 文字列 | ○ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合に指定 | 文字列 | ○ | × | |
| listName | 選択項目のリストの属性名 | 文字列 | ◎ | × | |
| elementLabelProperty | リスト要素から値を取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementValueProperty | リスト要素からラベルを取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementLabelPattern | ラベルを整形するためのフォーマットパターン | 文字列 | ○ | × | デフォルト: `$LABEL$` |
| multiple | xhtmlのmultiple属性 | 真偽値 | ○ | ○ | |
| size | xhtmlのsize属性 | 数値 | ○ | ○ | |
| withNoneOption | リスト先頭に選択なしのオプションを追加するか否か | 真偽値 | ○ | ○ | デフォルト: `false` |
| sample | ローカル動作時に表示するプルダウン項目のラベル | 文字列 | × | ○ | `"|"` 区切りで複数指定。`"[]"` で囲われた項目は選択状態で表示 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式で設定 |
| comment | プルダウンについての備考 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |

<details>
<summary>keywords</summary>

listName, elementLabelProperty, elementValueProperty, elementLabelPattern, withNoneOption, sample, readonly, disabled, domain, id, cssClass, nameAlias, multiple, size, dataFrom, comment, initialValueDesc, プルダウン属性, ローカル動作挙動, field_base

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/pulldown.tag | [field_pulldown](testing-framework-field_pulldown.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:select>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。プルダウンに関する定義もここに含まれる。 |

<details>
<summary>keywords</summary>

pulldown.tag, base.tag, nablarch.js, base.less, 部品一覧, タグライブラリ, 内部構造

</details>
