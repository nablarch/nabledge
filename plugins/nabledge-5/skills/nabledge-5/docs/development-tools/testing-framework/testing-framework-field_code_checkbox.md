# コード値チェックボックス入力項目ウィジェット

**公式ドキュメント**: [コード値チェックボックス入力項目ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_code_checkbox.html)

## コードサンプル

**設計成果物(ローカル動作)**

```jsp
<field:code_checkbox
  title      = "ユーザIDロック"
  listFormat = "ul">
</field:code_checkbox>
```

**実装成果物(サーバ動作)**

```jsp
<field:code_checkbox
  title            = "ユーザIDロック"
  name             = "11AC_W11AC01.userIdLocked"
  codeId           = "C0000001"
  pattern          = "PATTERN01"
  optionColumnName = "OPTION01"
  labelPattern     = "$OPTIONALNAME$"
  listFormat       = "ul">
</field:code_checkbox>
```

<details>
<summary>keywords</summary>

field:code_checkbox, JSP使用例, コードチェックボックスサンプル, codeId, listFormat, optionColumnName, labelPattern

</details>

## 仕様

[field_checkbox](testing-framework-field_checkbox.md) とほぼ同じ仕様。以下は差分のみ記載。

**ローカル動作時の挙動**

- `codeId` 属性にコードIDを指定した場合、`/js/devtool/resource/コード値定義.js` 内のエントリからコード名称を取得して表示する。`pattern`・`optionColumnName` 属性も使用可能。
- `codeId` と `sample` を両方指定した場合は `sample` の値を優先する。

**属性値一覧** ([field_base](testing-framework-field_base.md) との共通属性は省略)

◎ 必須属性 ○ 任意属性 × 無効(指定しても効果なし)

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: false |
| disabled | 入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: false |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 複数入力項目ハイライト用のname属性(カンマ区切り) | 文字列 | ○ | × | |
| sample | ローカル動作時のチェックボックスラベル | 文字列 | × | ○ | \|区切りで複数指定。[]で囲んだ項目は選択状態で表示 |
| codeId | コード定義ID | 文字列 | ◎ | ○ | |
| pattern | 使用するコードパターンのカラム名 | 文字列 | ○ | ○ | デフォルト: PATTERN01 |
| optionColumnName | 取得するオプション名称のカラム名 | 文字列 | ○ | ○ | デフォルト: OPTION01 |
| labelPattern | ラベル表示書式 | 文字列 | ○ | ○ | プレースホルダ: $NAME$(コード名称), $SHORTNAME$(略称), $OPTIONALNAME$(オプション名称、使用時はoptionColumnName必須), $VALUE$(コード値)。デフォルト: $NAME$ |
| listFormat | リスト表示フォーマット | 文字列 | ○ | ○ | デフォルト: span |
| dataFrom | 表示データの取得元 | 文字列 | × | × | 設計書用(表示情報取得元.表示項目名形式) |
| comment | チェックボックスの備考 | 文字列 | × | × | 設計書の備考欄に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の備考欄に表示 |

<details>
<summary>keywords</summary>

codeId, pattern, optionColumnName, labelPattern, listFormat, domain, readonly, disabled, cssClass, nameAlias, sample, dataFrom, comment, initialValueDesc, コード値チェックボックス属性, ローカル動作, $NAME$, $SHORTNAME$, $OPTIONALNAME$, $VALUE$, コード管理機能

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/code_checkbox.tag | [field_code_checkbox](testing-framework-field_code_checkbox.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:codeCheckboxes>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。チェックボックスに関する定義も含まれる。 |

<details>
<summary>keywords</summary>

code_checkbox.tag, base.tag, nablarch.js, base.less, n:codeCheckboxes, 部品構成, コードチェックボックス実装ファイル

</details>
