# 入力項目ウィジェット共通テンプレート

[入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) は [単行テキスト入力項目ウィジェット](../../component/ui-framework/ui-framework-field-text.md) や [チェックボックス入力項目ウィジェット](../../component/ui-framework/ui-framework-field-checkbox.md)
などの入力項目UI部品に実装の実装で使用するテンプレートである。
このテンプレートでは以下の内容を実装している。

* 各入力項目のレイアウト(ラベル、入力項目、項目別エラー、補助テキストなどの表示制御)
* 必須項目の表現

## コードサンプル

[入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) は [UI部品ウィジェット](../../component/ui-framework/ui-framework-jsp-widgets.md) の実装に用いるテンプレートなので、
業務画面JSPから直接使用することはない。

## 仕様

**属性値一覧**  [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| fieldContent | フィールド入力部タグ | JSPフラグメント | ◎ | ◎ |  |
| title | 項目名 | 文字列 | ◎ | ◎ |  |
| name | HTMLのname属性値 | 文字列 | ◎ | ○ |  |
| required | 必須項目かどうか | 真偽値 | ○ | ○ | デフォルト値は 'false' |
| hint | 入力内容や留意点などの 補助テキスト | 文字列 | ○ | ○ |  |
| fieldClass | 入力フィールドのDIVに付与する cssClass | 文字列 | ○ | ○ |  |
| titleSize | タイトル部の幅(グリッド数) | 数値 | ○ | ○ | [マルチレイアウト用CSSフレームワーク](../../component/ui-framework/ui-framework-multicol-css-framework.md#マルチレイアウト用cssフレームワーク) で使用する |
| inputSize | 入力部の幅(グリッド数) | 数値 | ○ | ○ | [マルチレイアウト用CSSフレームワーク](../../component/ui-framework/ui-framework-multicol-css-framework.md#マルチレイアウト用cssフレームワーク) で使用する |

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/base.tag | [入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) |
| /css/style/nablarch.less | エラー表示領域のスタイル定義がここに含まれる。 |
