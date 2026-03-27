# カレンダー日付入力ウィジェット

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

field:calendar, カレンダー日付入力, JSPタグ, 設計成果物, 実装成果物, ローカル動作, サーバ動作

</details>

## 仕様

共通仕様は [field_base](ui-framework-field_base.md) に記述されており、ここでは記述しない。

**ローカル動作時の挙動**: `sample` に指定した値を入力画面ではテキストボックスの初期表示値として、確認画面ではラベルとして表示する。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | htmlのid属性 | 文字列 | ○ | ○ | 省略時はname属性と同じ値。ローカル動作においてもidかnameのいずれかは必須。 |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは 'false' |
| example | 具体的な入力例を表すテキスト（placeholderなどの形式で表示する） | 文字列 | ○ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合に指定する | 文字列 | ○ | × | |
| format | 日付のフォーマット | 文字列 | ○ | ○ | デフォルトは 'yyyy/MM/dd' |
| locale | 言語設定 | 文字列 | ○ | ○ | デフォルトは 'ja' |
| sample | ローカル動作時に表示する日付 | 文字列 | × | ○ | |
| maxlength | 入力文字数の上限 | 数値 | ○ | ○ | formatが未指定の場合は "10" |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式で設定する |
| comment | カレンダーについての備考 | 文字列 | × | × | 設計書の表示時に、画面項目定義の項目定義一覧で「備考」に表示される |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に、画面項目定義の項目定義一覧で「備考」に表示される |

<details>
<summary>keywords</summary>

field:calendar属性, id, format, locale, sample, maxlength, domain, readonly, disabled, example, cssClass, nameAlias, dataFrom, comment, initialValueDesc, 日付フォーマット, ローカル動作, 属性値一覧

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/calendar.tag | [field_calendar](ui-framework-field_calendar.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | カレンダー日付入力ウィジェットが使用する `<n:text>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。カレンダーに関する定義もここに含まれる。 |

<details>
<summary>keywords</summary>

calendar.tag, base.tag, nablarch.js, base.less, タグライブラリスタブ, 部品一覧, カレンダーウィジェット構成

</details>
