# リストビルダー入力項目ウィジェット

## コードサンプル

## コードサンプル

**ローカル動作**:
```jsp
<field:listbuilder
    title="認可単位"
    sample="認可単位１|[認可単位２]">
</field:listbuilder>
```

**サーバ動作**:
```jsp
<field:listbuilder
  title="認可単位"
  name="formdata.permissionUnits"
  id="permissionUnit"
  listName="allPermissionUnit"
  elementLabelProperty="permissionUnitName"
  elementValueProperty="permissionUnitId">
</field:listbuilder>
```

<details>
<summary>keywords</summary>

field:listbuilder, リストビルダー JSPタグ, ローカル動作コードサンプル, サーバ動作コードサンプル, sample属性, listName属性, elementLabelProperty, elementValueProperty

</details>

## 仕様

## 仕様

[field_base](ui-framework-field_base.md) を用いて実装。[field_base](ui-framework-field_base.md) の共通仕様はここでは記述しない。

**ローカル動作時の挙動**:
- 入力画面: `sample` に指定した項目を選択候補とするリストビルダーを表示。`"[]"` で囲われた項目は選択済みとして表示される。
- 確認画面: 選択済み項目（`"[]"` で囲われた項目）のラベルの一覧を表示する。

**属性値一覧** [◎必須 ○任意 ×無効]

（[field_base](ui-framework-field_base.md) の共通属性は省略）

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| id | HTMLのid属性値（省略時はname属性と同じ値を使用） | 文字列 | ◎ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合に指定 | 文字列 | ○ | × | |
| listName | 選択項目のリストの属性名 | 文字列 | ◎ | × | |
| size | リスト上に一度に表示する件数 | 数値 | ○ | ○ | デフォルト: `6` |
| elementLabelProperty | リスト要素から値を取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementValueProperty | リスト要素からラベルを取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementLabelPattern | ラベルを整形するためのフォーマットパターン | 文字列 | ○ | × | デフォルト: `$LABEL$` |
| sample | ローカル動作時に表示するリストビルダーの項目ラベル | 文字列 | × | ○ | `"|"` 区切りで複数指定。`"[]"` で囲われた項目は選択状態で表示 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する「表示情報取得元」.「表示項目名」の形式で設定 |
| comment | リストビルダーについての備考 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |

<details>
<summary>keywords</summary>

リストビルダー属性一覧, domain, readonly, disabled, id, cssClass, listName, size, elementLabelProperty, elementValueProperty, elementLabelPattern, comment, initialValueDesc, sample, dataFrom, nameAlias, ローカル動作, 入力画面 確認画面

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

**部品一覧**:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/listbuilder.tag | [field_listbuilder](ui-framework-field_listbuilder.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:select>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。プルダウンに関する定義を含む。 |

<details>
<summary>keywords</summary>

listbuilder.tag, base.tag, nablarch.js, base.less, 内部構造, 部品一覧

</details>
