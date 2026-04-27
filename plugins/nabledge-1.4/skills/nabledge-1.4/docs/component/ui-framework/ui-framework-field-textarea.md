# 複数行テキスト入力項目ウィジェット

[複数行テキスト入力項目ウィジェット](../../component/ui-framework/ui-framework-field-textarea.md) は **UI標準 UI部品 複数行テキスト入力**
の内容に準拠したテキストエリアを出力する。

## コードサンプル

**設計成果物(ローカル動作)**

```jsp
<field:textarea
  title="漢字氏名"
  hint="全角50文字以内で入力してください。"
  required="true"
  maxlength="50">
</field:textarea>
```

**実装成果物(サーバ動作)**

```jsp
<field:textarea
  title="漢字氏名"
  required="true"
  maxlength="50"
  hint="全角50文字以内"
  name="W11AC02.users.kanjiName">
</field:textarea>
```

## 仕様

このウィジェットは [入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) を用いて実装している。
[入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) が実装する共通仕様についてはここでは記述しない。

**ローカル動作時の挙動**
入力画面では **sample** に指定した文字列を初期表示するテキストエリアを表示する。

確認画面では、 **sample** に指定した文字列をラベル表示する。

**属性値一覧**  [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

([入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) の共通属性は省略)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ |  |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| disabled | サーバに対する入力値の送信を 抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| id | HTMLのid属性値 (省略時はname属性と同じ 値を使用する) | 文字列 | ○ | ○ |  |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ |  |
| maxlength | 入力文字数の上限 | 文字列 | ○ | ○ |  |
| example | 具体的な入力例を表すテキスト (placeholderなどの形式で 表示する) | 文字列 | ○ | ○ |  |
| nameAlias | 一つのエラーメッセージに 対して複数の入力項目を ハイライト表示する場合に 指定する。 | 文字列 | ○ | × |  |
| sample | ローカル動作時にテキスト エリアに表示する文字列 | 文字列 | × | ○ |  |
| rows | 表示行数 | 数値 | ○ | ○ | デフォルトは '4' |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する、 「表示情報取得元」.「表示項目名」 の形式で設定する。 |
| comment | テキストエリアについての備考 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/textarea.tag | [複数行テキスト入力項目ウィジェット](../../component/ui-framework/ui-framework-field-textarea.md) |
| /WEB-INF/tags/widget/field/base.tag | [入力項目ウィジェット共通テンプレート](../../component/ui-framework/ui-framework-field-base.md) |
| /js/jsp/taglib/nablarch.js | <n:textarea> のエミュレーション機能を実装する タグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。 チェックボックスに関する定義もここに含まれる。 |
