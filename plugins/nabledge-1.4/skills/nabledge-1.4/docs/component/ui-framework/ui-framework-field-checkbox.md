# チェックボックス入力項目ウィジェット

[チェックボックス入力項目ウィジェット](../../component/ui-framework/ui-framework-field-checkbox.md) は **UI標準 UI部品 チェックボックス**
の内容に準拠したチェックボックスのリストを出力する。

本部品には以下のバリエーションがあり、必要に応じて使い分けること。

* [コード値チェックボックス入力項目ウィジェット](../../component/ui-framework/ui-framework-field-code-checkbox.md)
  Nablarchコード定義の内容をもとにしたチェックボックスのリストを表示する場合に使用する。
* [テーブル複数行選択用チェックボックスカラムウィジェット](../../component/ui-framework/ui-framework-column-checkbox.md)
  処理対象行を複数選択するためのチェックボックスを各行のカラム中に表示する場合に使用する。

## コードサンプル

**設計成果物(ローカル動作)**

```jsp
<field:checkbox
  title="利用航空会社"
  listFormat="ul"
  sample="[AAA航空]|BBBエアライン|[CCCエアシステム]">
</field:checkbox>
```

**実装成果物(サーバ動作)**

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

## 仕様

このウィジェットは [入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) を用いて実装している。
[入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) が実装する共通仕様についてはここでは記述しない。

**ローカル動作時の挙動**

入力画面では **sample** に指定したラベル分だけチェックボックスとラベルを表示する。
各チェックボックスとラベルの組は、listFormatに指定された形式で表示される。
(デフォルトでは改行区切り)

確認画面では、選択済み項目(**"[]"** で囲われた項目) のラベルの一覧を表示する。

**属性値一覧**  [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

([入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) の共通属性は省略)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ |  |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| disabled | サーバに対する入力値の送信を 抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ |  |
| nameAlias | 一つのエラーメッセージに 対して複数の入力項目を ハイライト表示する場合に 指定する。 | 文字列 | ○ | × |  |
| listName | 選択項目のリストの属性名 | 文字列 | ◎ | × |  |
| elementLabelProperty | リスト要素から値を取得する ためのプロパティ名 | 文字列 | ◎ | × |  |
| elementValueProperty | リスト要素からラベルを取得 するためのプロパティ名 | 文字列 | ◎ | × |  |
| elementLabelPattern | ラベルを整形するための フォーマットパターン | 文字列 | ○ | × |  |
| listFormat | リスト表示時に使用する フォーマット | 文字列 | ○ | ○ | デフォルト値は 'span' |
| sample | ローカル動作時に表示する チェックボックスのラベル | 文字列 | × | ○ | **"\|"** 区切りで複数指定する。 **"[]"** で囲われた項目は選択状態 で表示される。 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する、 「表示情報取得元」.「表示項目名」 の形式で設定する。 |
| comment | チェックボックスについての備考 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/checkbox.tag | [チェックボックス入力項目ウィジェット](../../component/ui-framework/ui-framework-field-checkbox.md) |
| /WEB-INF/tags/widget/field/base.tag | [入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) |
| /js/jsp/taglib/nablarch.js | <n:checkboxes> のエミュレーション機能を実装する タグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。 チェックボックスに関する定義もここに含まれる。 |
