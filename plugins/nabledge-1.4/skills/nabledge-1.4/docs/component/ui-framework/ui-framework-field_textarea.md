# 複数行テキスト入力項目ウィジェット

## コードサンプル

## コードサンプル

**設計成果物（ローカル動作）**

```jsp
<field:textarea
  title="漢字氏名"
  hint="全角50文字以内で入力してください。"
  required="true"
  maxlength="50">
</field:textarea>
```

**実装成果物（サーバ動作）**

```jsp
<field:textarea
  title="漢字氏名"
  required="true"
  maxlength="50"
  hint="全角50文字以内"
  name="W11AC02.users.kanjiName">
</field:textarea>
```

<details>
<summary>keywords</summary>

field:textarea, テキストエリア, 複数行テキスト入力, JSP, コードサンプル, ローカル動作, サーバ動作

</details>

## 仕様

## 仕様

[field_base](ui-framework-field_base.md) を用いて実装。[field_base](ui-framework-field_base.md) の共通仕様はここでは記述しない。

**ローカル動作時の挙動**
- 入力画面: `sample` に指定した文字列を初期表示するテキストエリアを表示
- 確認画面: `sample` に指定した文字列をラベル表示

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

([field_base](ui-framework-field_base.md) の共通属性は省略)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| id | HTMLのid属性値（省略時はname属性と同じ値） | 文字列 | ○ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| maxlength | 入力文字数の上限 | 文字列 | ○ | ○ | |
| example | 具体的な入力例（placeholderなどの形式で表示） | 文字列 | ○ | ○ | |
| nameAlias | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合に指定 | 文字列 | ○ | × | |
| sample | ローカル動作時にテキストエリアに表示する文字列 | 文字列 | × | ○ | |
| rows | 表示行数 | 数値 | ○ | ○ | デフォルト: `4` |
| dataFrom | 表示するデータの取得元（「表示情報取得元」.「表示項目名」の形式） | 文字列 | × | × | |
| comment | テキストエリアについての備考（設計書の画面項目定義の備考に表示） | 文字列 | × | × | |
| initialValueDesc | 初期表示内容に関する説明（設計書の画面項目定義の備考に表示） | 文字列 | × | × | |

<details>
<summary>keywords</summary>

domain, readonly, disabled, maxlength, rows, sample, nameAlias, cssClass, id, example, dataFrom, comment, initialValueDesc, 属性値一覧, テキストエリア仕様, ローカル動作

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/textarea.tag | [field_textarea](ui-framework-field_textarea.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:textarea>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（チェックボックスに関する定義も含む） |

<details>
<summary>keywords</summary>

textarea.tag, base.tag, nablarch.js, base.less, 内部構造, 部品一覧

</details>
