# カレンダー日付入力ウィジェット

**公式ドキュメント**: [カレンダー日付入力ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_calendar.html)

## コードサンプル

## コードサンプル

**設計成果物(ローカル動作)**

```jsp
<field:calendar
    title="日付"
    name="date1"
    required="true"
    hint="(入力例 ： 2012/05/12)"
    sample="2013/09/30">
</field:calendar>
```

**実装成果物(サーバ動作)**

```jsp
<field:calendar
    title="日付"
    name="W99ZZ64.date1"
    required="true"
    hint="(入力例 ： 2012/05/12)"
    sample="2013/09/30">
</field:calendar>
```

<details>
<summary>keywords</summary>

field:calendar, JSPウィジェット, カレンダー日付入力, ローカル動作, サーバ動作, title属性, name属性, required属性, hint属性, sample属性

</details>

## 仕様

## 仕様

[field_base](testing-framework-field_base.md) を用いて実装。共通仕様は [field_base](testing-framework-field_base.md) を参照。

**ローカル動作時の挙動**:
- 入力画面: `sample` に指定した値をテキストボックスの初期表示値として表示する
- 確認画面: `sample` に指定した値をラベルとして表示する

**属性値一覧** (◎ 必須属性 ○ 任意属性 × 無効)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのid属性 | 文字列 | ○ | ○ | 省略時はname属性と同じ値。ローカル動作においてもid属性かname属性のいずれかは必須。 |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| example | 具体的な入力例(placeholderなどの形式で表示) | 文字列 | ○ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合に指定 | 文字列 | ○ | × | |
| format | 日付のフォーマット | 文字列 | ○ | ○ | デフォルトは 'yyyy/MM/dd' |
| locale | 言語設定 | 文字列 | ○ | ○ | デフォルトは 'ja' |
| sample | ローカル動作時に表示する日付 | 文字列 | × | ○ | |
| maxlength | 入力文字数の上限 | 数値 | ○ | ○ | formatが未指定の場合は "10" |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式で設定 |
| comment | カレンダーについての備考 | 文字列 | × | × | 設計書の画面項目定義の備考に表示される |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義の備考に表示される |

<details>
<summary>keywords</summary>

field_calendar, field_base, id, domain, format, locale, sample, maxlength, readonly, disabled, example, cssClass, nameAlias, dataFrom, comment, initialValueDesc, 日付フォーマット, 属性値一覧, ローカル動作挙動, カレンダー日付入力ウィジェット属性

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/calendar.tag | [field_calendar](testing-framework-field_calendar.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:text>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。カレンダーに関する定義もここに含まれる。 |

<details>
<summary>keywords</summary>

calendar.tag, base.tag, nablarch.js, base.less, 部品一覧, タグライブラリスタブJS

</details>
