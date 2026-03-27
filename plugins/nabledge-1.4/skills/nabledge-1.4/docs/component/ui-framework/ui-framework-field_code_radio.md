# コード値ラジオボタン入力項目ウィジェット

## コードサンプル

[field_code_radio](ui-framework-field_code_radio.md) は [field_radio](ui-framework-field_radio.md) に対して、Nablarchのコード管理機能で取得したラベル・値をもとにしたラジオボタンを出力できるよう拡張したウィジェット。表示仕様などその他の仕様は [field_radio](ui-framework-field_radio.md) と同じ。

**ローカル動作時のコード例**:
```jsp
<field:code_radio
  title      = "ユーザIDロック"
  listFormat = "ul">
</field:code_radio>
```

**サーバ動作時のコード例**:
```jsp
<field:code_radio
  title            = "ユーザIDロック"
  name             = "11AC_W11AC01.userIdLocked"
  codeId           = "C0000001"
  pattern          = "PATTERN01"
  optionColumnName = "OPTION01"
  labelPattern     = "$OPTIONALNAME$"
  listFormat       = "ul">
</field:code_radio>
```

<details>
<summary>keywords</summary>

field:code_radio, コード値ラジオボタン, コード管理機能, codeId, optionColumnName, labelPattern, listFormat

</details>

## 仕様

[field_radio](ui-framework-field_radio.md) とほぼ同じ仕様。以下は差分のみ記載。

**ローカル動作時の挙動**:
- `sample` 属性に指定したラベル分のラジオボタンを表示（[field_radio](ui-framework-field_radio.md) と同様）
- `codeId` 属性にコードIDを指定した場合、`/js/devtool/resource/コード値定義.js` のエントリーからコード名称を取得して表示
- `pattern` 属性によるパターン指定、`optionColumnName` 属性によるオプション名称指定も利用可能
- `codeId` と `sample` を両方指定した場合は `sample` の値を優先

**属性一覧** (◎ 必須属性, ○ 任意属性, × 無効)

([field_base](ui-framework-field_base.md) との共通属性は省略)

| プロパティ名 | タイプ | サーバ | ローカル | デフォルト値 | 説明 |
|---|---|---|---|---|---|
| domain | 文字列 | ○ | ○ | | 項目のドメイン型 |
| readonly | 真偽値 | ○ | ○ | false | 編集可能かどうか |
| disabled | 真偽値 | ○ | ○ | false | サーバに対する入力値の送信を抑制するかどうか |
| cssClass | 文字列 | ○ | ○ | | HTMLのclass属性値 |
| nameAlias | 文字列 | ○ | × | | 一つのエラーメッセージに対して複数の入力項目をハイライト表示する場合のname属性（カンマ区切り） |
| sample | 文字列 | × | ○ | | ローカル動作時に表示するラジオボタンのラベル（`\|` 区切りで複数指定、`[]` で囲われた項目は選択状態で表示） |
| codeId | 文字列 | ◎ | ○ | | コード定義ID |
| pattern | 文字列 | ○ | ○ | PATTERN01 | 使用するコードパターンのカラム名 |
| optionColumnName | 文字列 | ○ | ○ | OPTION01 | 取得するオプション名称のカラム名 |
| labelPattern | 文字列 | ○ | ○ | $NAME$ | ラベル表示書式。プレースホルダ: `$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称、使用時はoptionColumnName必須）、`$VALUE$`（コード値） |
| listFormat | 文字列 | ○ | ○ | span | リスト表示時に使用するフォーマット |
| dataFrom | 文字列 | × | × | | 表示情報取得元（設計書用） |
| comment | 文字列 | × | × | | ラジオボタンについての備考（設計書用） |
| initialValueDesc | 文字列 | × | × | | 初期表示内容に関する説明（設計書用） |

<details>
<summary>keywords</summary>

codeId, pattern, optionColumnName, labelPattern, listFormat, sample, readonly, disabled, nameAlias, domain, cssClass, dataFrom, comment, initialValueDesc, ラジオボタン属性一覧, ローカル動作, コード値ラジオボタン仕様

</details>

## 内部構造・改修時の留意点

**部品一覧**:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/code_radio.tag | [field_code_radio](ui-framework-field_code_radio.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](ui-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:codeRadioButtons>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（ラジオボタンに関する定義含む） |

<details>
<summary>keywords</summary>

code_radio.tag, nablarch.js, base.less, 内部構造, 部品一覧, n:codeRadioButtons

</details>
