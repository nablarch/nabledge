# リストビルダー入力項目ウィジェット

**公式ドキュメント**: [リストビルダー入力項目ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_listbuilder.html)

## コードサンプル

**設計成果物(ローカル動作)**:
```jsp
<field:listbuilder
    title="認可チェック単位"
    sample="認可チェック単位１|[認可チェック単位２]">
</field:listbuilder>
```

**実装成果物(サーバ動作)**:
```jsp
<field:listbuilder
  title="認可チェック単位"
  name="formdata.permissionUnits"
  id="permissionUnit"
  listName="allPermissionUnit"
  elementLabelProperty="permissionUnitName"
  elementValueProperty="permissionUnitId">
</field:listbuilder>
```

<details>
<summary>keywords</summary>

field:listbuilder, リストビルダー, JSPコードサンプル, ローカル動作, サーバ動作, listbuilder

</details>

## 仕様

[field_base](testing-framework-field_base.md) を用いて実装している。[field_base](testing-framework-field_base.md) の共通属性はここでは記述しない。

**ローカル動作時の挙動**:
- 入力画面: `sample` に指定した項目を選択候補とするリストビルダーを表示。`"[]"` で囲われた項目は選択済みとして表示される。
- 確認画面: 選択済み項目（`"[]"` で囲われた項目）のラベル一覧を表示する。

**属性値一覧** (◎ 必須属性 / ○ 任意属性 / × 無効)

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: false |
| disabled | サーバへの入力値送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: false |
| id | HTMLのid属性値（省略時はname属性と同じ値を使用） | 文字列 | ◎ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 複数の入力項目を一つのエラーメッセージでハイライトする場合に指定 | 文字列 | ○ | × | |
| listName | 選択項目のリストの属性名 | 文字列 | ◎ | × | |
| size | リストに一度に表示する件数 | 数値 | ○ | ○ | デフォルト: 6 |
| elementLabelProperty | リスト要素から値を取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementValueProperty | リスト要素からラベルを取得するためのプロパティ名 | 文字列 | ◎ | × | |
| elementLabelPattern | ラベルを整形するためのフォーマットパターン | 文字列 | ○ | × | デフォルト: '$LABEL$' |
| sample | ローカル動作時に表示するリストビルダーの項目ラベル | 文字列 | × | ○ | `\|` 区切りで複数指定。`[]` で囲われた項目は選択状態で表示。 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」形式で設定 |
| comment | リストビルダーについての備考 | 文字列 | × | × | 設計書表示時、画面項目定義の備考列に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書表示時、画面項目定義の備考列に表示 |

<details>
<summary>keywords</summary>

domain, readonly, disabled, id, cssClass, nameAlias, listName, size, elementLabelProperty, elementValueProperty, elementLabelPattern, sample, dataFrom, comment, initialValueDesc, 属性一覧, リストビルダー仕様, ローカル動作, サーバ動作

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/listbuilder.tag | [field_listbuilder](testing-framework-field_listbuilder.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:select>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。プルダウンに関する定義もここに含まれる。 |

<details>
<summary>keywords</summary>

listbuilder.tag, base.tag, nablarch.js, base.less, 部品一覧, 内部構造, 改修

</details>
