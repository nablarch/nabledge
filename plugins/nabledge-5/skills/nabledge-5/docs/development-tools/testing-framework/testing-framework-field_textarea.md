# 複数行テキスト入力項目ウィジェット

**公式ドキュメント**: [複数行テキスト入力項目ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_textarea.html)

## コードサンプル

**設計成果物（ローカル動作）**:
```jsp
<field:textarea
  title="漢字氏名"
  hint="全角50文字以内で入力してください。"
  required="true"
  maxlength="50">
</field:textarea>
```

**実装成果物（サーバ動作）**:
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

field:textarea, テキストエリア, JSPウィジェット, コードサンプル, ローカル動作, サーバ動作

</details>

## 仕様

ローカル動作時: 入力画面では `sample` に指定した文字列を初期表示するテキストエリアを表示。確認画面では `sample` に指定した文字列をラベル表示する。

**属性値一覧**（[field_base](testing-framework-field_base.md) の共通属性は省略。◎=必須, ○=任意, ×=無効）

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: 'false' |
| disabled | 入力値の送信抑制 | 真偽値 | ○ | ○ | デフォルト: 'false' |
| id | HTMLのid属性値（省略時はname属性と同じ値） | 文字列 | ○ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| maxlength | 入力文字数の上限 | 文字列 | ○ | ○ | |
| example | 具体的な入力例（placeholder形式で表示） | 文字列 | ○ | ○ | |
| nameAlias | 複数入力項目のハイライト表示用 | 文字列 | ○ | × | |
| sample | ローカル動作時にテキストエリアに表示する文字列 | 文字列 | × | ○ | |
| rows | 表示行数 | 数値 | ○ | ○ | デフォルト: '4' |
| dataFrom | 表示データの取得元（「表示情報取得元」.「表示項目名」形式） | 文字列 | × | × | |
| comment | 備考（設計書の項目定義一覧「備考」列に表示） | 文字列 | × | × | |
| initialValueDesc | 初期表示内容の説明（設計書の項目定義一覧「備考」列に表示） | 文字列 | × | × | |

<details>
<summary>keywords</summary>

domain, readonly, disabled, id, cssClass, maxlength, example, nameAlias, sample, rows, dataFrom, comment, initialValueDesc, テキストエリア属性, ローカル動作, field_base

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/textarea.tag | [field_textarea](testing-framework-field_textarea.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:textarea>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（チェックボックスに関する定義もここに含まれる） |

<details>
<summary>keywords</summary>

textarea.tag, base.tag, nablarch.js, base.less, 内部構造, 部品一覧, テキストエリアウィジェット部品

</details>
