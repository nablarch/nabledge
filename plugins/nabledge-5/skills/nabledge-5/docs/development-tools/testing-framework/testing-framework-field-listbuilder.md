# リストビルダー入力項目ウィジェット

[リストビルダー入力項目ウィジェット](../../development-tools/testing-framework/testing-framework-field-listbuilder.md) は **UI標準 UI部品 リストビルダー**
の内容に準拠したリストビルダーのリストを出力する。

## コードサンプル

**設計成果物(ローカル動作)**

```jsp
<field:listbuilder
    title="認可チェック単位"
    sample="認可チェック単位１|[認可チェック単位２]">
</field:listbuilder>
```

**実装成果物(サーバ動作)**

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

## 仕様

このウィジェットは [入力項目ウィジェット共通テンプレート](../../development-tools/testing-framework/testing-framework-field-base.md) を用いて実装している。
[入力項目ウィジェット共通テンプレート](../../development-tools/testing-framework/testing-framework-field-base.md) が実装する共通仕様についてはここでは記述しない。

**ローカル動作時の挙動**

入力画面では **sample** に指定した項目を選択候補とするリストビルダーを表示する。
**"[]"** で囲われた項目は、既に選択済みの項目として表示される。

確認画面では、選択済み項目(**"[]"** で囲われた項目) のラベルの一覧を表示する。

**属性値一覧**  [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

([入力項目ウィジェット共通テンプレート](../../development-tools/testing-framework/testing-framework-field-base.md) の共通属性は省略)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ |  |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| disabled | サーバに対する入力値の送信を 抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| id | HTMLのid属性値 (省略時はname属性と同じ 値を使用する) | 文字列 | ◎ | ○ |  |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ |  |
| nameAlias | 一つのエラーメッセージに 対して複数の入力項目を ハイライト表示する場合に 指定する。 | 文字列 | ○ | × |  |
| listName | 選択項目のリストの属性名 | 文字列 | ◎ | × |  |
| size | リスト上に一度に表示する件数 | 数値 | ○ | ○ | デフォルトは '6' |
| elementLabelProperty | リスト要素から値を取得する ためのプロパティ名 | 文字列 | ◎ | × |  |
| elementValueProperty | リスト要素からラベルを取得 するためのプロパティ名 | 文字列 | ◎ | × |  |
| elementLabelPattern | ラベルを整形するための フォーマットパターン | 文字列 | ○ | × | デフォルトは'$LABEL$' |
| sample | ローカル動作時に表示する リストビルダーの項目ラベル | 文字列 | × | ○ | **"\|"** 区切りで複数指定する。 **"[]"** で囲われた項目は選択状態 で表示される。 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する、 「表示情報取得元」.「表示項目名」 の形式で設定する。 |
| comment | リストビルダーについての 備考 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/listbuilder.tag | [リストビルダー入力項目ウィジェット](../../development-tools/testing-framework/testing-framework-field-listbuilder.md) |
| /WEB-INF/tags/widget/field/base.tag | [入力項目ウィジェット共通テンプレート](../../development-tools/testing-framework/testing-framework-field-base.md) |
| /js/jsp/taglib/nablarch.js | <n:select> のエミュレーション機能を実装する タグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。  プルダウンに関する定義もここに含まれる。 |
