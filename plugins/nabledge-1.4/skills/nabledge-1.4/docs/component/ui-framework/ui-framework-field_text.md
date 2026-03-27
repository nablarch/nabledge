# 単行テキスト入力項目ウィジェット

## コードサンプル

## コードサンプル

**設計成果物（ローカル動作）**:
```jsp
<field:text title="漢字氏名"
            hint="全角50文字以内で入力してください。"
            required="true"
            maxlength="50">
</field:text>
```

**実装成果物（サーバ動作）**:
```jsp
<field:text title="漢字氏名"
            required="true"
            maxlength="50"
            hint="全角50文字以内"
            name="W11AC02.users.kanjiName">
</field:text>
```

<details>
<summary>keywords</summary>

field:text, 単行テキスト入力, テキストボックス, JSP, ウィジェット使用例, ローカル動作, サーバ動作

</details>

## 仕様

## 仕様

[field_base](ui-framework-field_base.md) を用いて実装。[field_base](ui-framework-field_base.md) の共通仕様は省略。

**ローカル動作時の挙動**:
- 入力画面: `sample` に指定した文字列を初期表示するテキストボックスを表示
- 確認画面: `sample` に指定した文字列をラベル表示

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

([field_base](ui-framework-field_base.md) の共通属性は省略)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: false |
| disabled | サーバへの入力値送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: false |
| id | HTMLのid属性値（省略時はname属性と同じ値） | 文字列 | ○ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| maxlength | 入力文字数の上限 | 文字列 | ○ | ○ | |
| example | 具体的な入力例（placeholderなどの形式で表示） | 文字列 | ○ | ○ | |
| nameAlias | 複数の入力項目を一つのエラーメッセージでハイライト表示する場合に指定 | 文字列 | ○ | × | |
| valueFormat | 出力する値のフォーマット指定（確認画面用） | 文字列 | ○ | × | |
| sample | ローカル動作時にテキストボックスに表示する文字列 | 文字列 | × | ○ | |
| unit | 入力欄の右側に表示する単位 | 文字列 | ○ | ○ | 確認画面で値が空の場合は単位を表示しない。ローカル表示で使用する場合はname属性に値を設定すること。name属性が未設定の場合、確認画面では単位がブランク表示となる。 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式で設定 |
| comment | テキスト入力項目についての備考 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |
| formatSpec | 編集仕様に関する説明 | 文字列 | × | × | 設計書の画面項目定義「編集仕様」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |

<details>
<summary>keywords</summary>

field:text, 属性一覧, domain, readonly, disabled, id, maxlength, sample, unit, nameAlias, valueFormat, example, cssClass, dataFrom, comment, formatSpec, initialValueDesc, ローカル動作, 確認画面, 単行テキスト入力仕様

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

**部品一覧**:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/text.tag | [field_text](ui-framework-field_text.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:text>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。チェックボックスに関する定義もここに含まれる。 |

<details>
<summary>keywords</summary>

text.tag, base.tag, nablarch.js, base.less, 部品一覧, タグライブラリ

</details>
