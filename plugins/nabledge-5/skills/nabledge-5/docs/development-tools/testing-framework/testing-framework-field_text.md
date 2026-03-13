# 単行テキスト入力項目ウィジェット

**公式ドキュメント**: [単行テキスト入力項目ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_text.html)

## 単行テキスト入力項目ウィジェット コードサンプル

## 単行テキスト入力項目ウィジェット コードサンプル

`field:text` は **UI標準 UI部品 単行テキスト入力** の内容に準拠したテキストボックスを出力する。

**設計成果物(ローカル動作)**

```jsp
<field:text title="漢字氏名"
            hint="全角50文字以内で入力してください。"
            required="true"
            maxlength="50">
</field:text>
```

**実装成果物(サーバ動作)**

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

field:text, field_text, 単行テキスト入力, テキストボックス, JSPウィジェット, コードサンプル, ローカル動作, サーバ動作

</details>

## 単行テキスト入力項目ウィジェット 仕様・属性値一覧

## 単行テキスト入力項目ウィジェット 仕様・属性値一覧

このウィジェットは `field_base` を用いて実装している。`field_base` が実装する共通仕様についてはここでは記述しない。

### ローカル動作時の挙動

- 入力画面: `sample` に指定した文字列を初期表示するテキストボックスを表示する。
- 確認画面: `sample` に指定した文字列をラベル表示する。

### 属性値一覧

[◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)]（`field_base` の共通属性は省略）

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルトは `false` |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルトは `false` |
| id | HTMLのid属性値（省略時はname属性と同じ値を使用） | 文字列 | ○ | ○ | |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| maxlength | 入力文字数の上限 | 文字列 | ○ | ○ | |
| example | 具体的な入力例テキスト（placeholder等の形式で表示） | 文字列 | ○ | ○ | |
| nameAlias | 複数入力項目を一つのエラーメッセージでハイライト表示する場合に指定 | 文字列 | ○ | × | |
| valueFormat | 出力する値のフォーマット指定（確認画面用） | 文字列 | ○ | × | |
| sample | ローカル動作時にテキストボックスに表示する文字列 | 文字列 | × | ○ | |
| unit | 入力欄の右側に表示する単位 | 文字列 | ○ | ○ | 確認画面で表示値が空の場合、単位は表示しない。ローカル表示で使用する場合はname属性に値を設定すること。name属性が未設定の場合、確認画面では単位はブランク表示となる。 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 設計書の「表示情報取得元.表示項目名」形式で設定 |
| comment | テキスト入力項目についての備考 | 文字列 | × | × | 設計書の画面項目定義一覧の「備考」に表示 |
| formatSpec | 編集仕様に関する説明 | 文字列 | × | × | 設計書の画面項目定義一覧の「編集仕様」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義一覧の「備考」に表示 |

<details>
<summary>keywords</summary>

field_base, 属性値一覧, domain, readonly, disabled, id, cssClass, maxlength, example, nameAlias, valueFormat, sample, unit, dataFrom, comment, formatSpec, initialValueDesc, ローカル動作時の挙動

</details>

## 単行テキスト入力項目ウィジェット 内部構造・改修時の留意点

## 単行テキスト入力項目ウィジェット 内部構造・改修時の留意点

### 部品一覧

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/text.tag | `field_text` |
| /WEB-INF/tags/widget/field/base.tag | `field_base` |
| /js/jsp/taglib/nablarch.js | `<n:text>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（チェックボックスに関する定義も含む） |

<details>
<summary>keywords</summary>

部品一覧, text.tag, base.tag, nablarch.js, base.less, 内部構造, 改修

</details>
