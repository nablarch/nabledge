# コード値表示項目ウィジェット

## 概要

`field_label_code`はNablarchのコード管理機能から取得したラベルや値を他の入力項目と並べて表示するウィジェットである。

> 通常の変数に格納された値を表示する場合は`field_label`を使用すること。

<details>
<summary>keywords</summary>

field_label_code, field_label, コード管理機能, ウィジェット選択, コード値表示, 通常の変数

</details>

## コードサンプル

**設計成果物（ローカル動作）**
```jsp
<field:label_code
  title = "ユーザIDロック">
</field:label_code>
```

**実装成果物（サーバ動作）**
```jsp
<field:label_code
  title            = "ユーザIDロック"
  name             = "11AC_W11AC01.userIdLocked"
  codeId           = "C0000001"
  pattern          = "PATTERN01"
  optionColumnName = "OPTION01"
  labelPattern     = "$OPTIONALNAME$"
  listFormat       = "ul">
</field:code_label>
```

<details>
<summary>keywords</summary>

field:label_code, コード値表示, JSPウィジェット, ローカル動作, サーバ動作, label_code

</details>

## 仕様

**サーバ動作時の挙動**
`codeId`属性に指定したコード値の内容を表示する。詳細はNablarch標準タグライブラリの`<n:code>`タグの仕様を参照。

**ローカル動作時の挙動**
- `sample`属性が指定されている場合はその値を表示する。
- `codeId`属性が指定されている場合は `/js/devtool/resource/コード値定義.js`（ツールによってコード設計書から自動生成）のエントリーからコード名称を取得して表示する。`pattern`属性・`optionColumnName`属性も利用可能。
- `codeId`と`sample`を両方指定した場合は`sample`の値を優先する。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 項目名 | 文字列 | ◎ | ◎ | |
| name | 出力対象の値を変数スコープから取得するための名前 | 文字列 | ◎ | × | |
| sample | ローカル動作時に表示する文字列 | 文字列 | × | ○ | `"|"`区切りで複数指定可。`"[]"`で囲われた項目は選択状態で表示される |
| codeId | コード定義ID | 文字列 | ◎ | ○ | |
| pattern | 使用するコードパターンのカラム名 | 文字列 | ○ | ○ | デフォルト: `PATTERN01` |
| optionColumnName | 取得するオプション名称のカラム名 | 文字列 | ○ | ○ | デフォルト: `OPTION01` |
| labelPattern | ラベル表示書式 | 文字列 | ○ | ○ | プレースホルダ: `$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称、使用時は`optionColumnName`の指定が必須）、`$VALUE$`（コード値）。デフォルト: `"$NAME$"` |
| listFormat | リスト表示時に使用するフォーマット | 文字列 | ○ | ○ | デフォルト: `sp` |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する「表示情報取得元」.「表示項目名」の形式で設定する |
| comment | コード値表示についての備考 | 文字列 | × | × | 設計書の表示時に画面項目定義の項目定義一覧の「備考」に表示される |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に画面項目定義の項目定義一覧の「備考」に表示される |

<details>
<summary>keywords</summary>

title, name, sample, codeId, pattern, optionColumnName, labelPattern, listFormat, dataFrom, comment, initialValueDesc, コード値, ラベル表示書式, プレースホルダ, 属性一覧, n:code

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/field/label_code.tag` | `field_label_code`の実体となるタグファイル |
| `/js/jsp/taglib/nablarch.js` | `<n:code>`のエミュレーション機能を実装するタグライブラリスタブJS |

<details>
<summary>keywords</summary>

label_code.tag, nablarch.js, タグファイル, タグライブラリスタブ, 改修, n:code

</details>
