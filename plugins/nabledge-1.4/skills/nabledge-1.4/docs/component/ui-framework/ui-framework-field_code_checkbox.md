# コード値チェックボックス入力項目ウィジェット

## コードサンプル

**設計成果物（ローカル動作）**

```jsp
<field:code_checkbox
  title      = "ユーザIDロック"
  listFormat = "ul">
</field:code_checkbox>
```

**実装成果物（サーバ動作）**

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

field:code_checkbox, JSPタグ, コードサンプル, ローカル動作, サーバ動作, codeId, labelPattern

</details>

## 仕様

[field_checkbox](ui-framework-field_checkbox.md) をNablarchのコード管理機能で取得したラベル・値でチェックボックス出力できるよう拡張したウィジェット。表示仕様などそれ以外の仕様は [field_checkbox](ui-framework-field_checkbox.md) と同じ。

**ローカル動作時の挙動（差分）**

- codeId属性にコードIDを指定した場合、`/js/devtool/resource/コード値定義.js` 内のエントリーからコード名称を取得して表示する
- pattern属性によるパターン指定、optionColumnName属性によるオプション名称指定も利用可能
- codeIdとsampleの両方を指定した場合はsampleの値を優先する

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

([field_base](ui-framework-field_base.md) との共通属性は省略)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: false |
| disabled | サーバへの入力値送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: false |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | エラーメッセージに対して複数の入力項目をハイライト表示する場合のname属性（カンマ区切り） | 文字列 | ○ | × | |
| sample | ローカル動作時に表示するチェックボックスのラベル | 文字列 | × | ○ | `\|`区切りで複数指定。`[]`で囲われた項目は選択状態で表示 |
| codeId | コード定義ID | 文字列 | ◎ | ○ | |
| pattern | 使用するコードパターンのカラム名 | 文字列 | ○ | ○ | デフォルト: PATTERN01 |
| optionColumnName | 取得するオプション名称のカラム名 | 文字列 | ○ | ○ | デフォルト: OPTION01 |
| labelPattern | ラベル表示書式 | 文字列 | ○ | ○ | プレースホルダ: $NAME$（コード名称）、$SHORTNAME$（略称）、$OPTIONALNAME$（オプション名称、optionColumnName必須）、$VALUE$（コード値）。デフォルト: $NAME$ |
| listFormat | リスト表示時に使用するフォーマット | 文字列 | ○ | ○ | デフォルト: span |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式 |
| comment | チェックボックスについての備考 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |

<details>
<summary>keywords</summary>

codeId, pattern, optionColumnName, labelPattern, listFormat, sample, domain, readonly, disabled, cssClass, nameAlias, dataFrom, comment, initialValueDesc, コード値チェックボックス, 属性一覧, ローカル動作, コード名称取得, コード管理機能

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/code_checkbox.tag | [field_code_checkbox](ui-framework-field_code_checkbox.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:codeCheckboxes>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。チェックボックスに関する定義を含む |

<details>
<summary>keywords</summary>

code_checkbox.tag, base.tag, nablarch.js, base.less, 部品一覧, タグライブラリ, n:codeCheckboxes

</details>
