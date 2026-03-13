# コード値ラジオボタン入力項目ウィジェット

**公式ドキュメント**: [コード値ラジオボタン入力項目ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_code_radio.html)

## コードサンプル

[field_code_radio](testing-framework-field_code_radio.md) はNablarchのコード管理機能で取得したラベル・値をもとにしたラジオボタンを出力するウィジェット。[field_radio](testing-framework-field_radio.md) を改修したもの。表示仕様などそれ以外の仕様は [field_radio](testing-framework-field_radio.md) と同じ。

**設計成果物（ローカル動作）**:
```jsp
<field:code_radio
  title      = "ユーザIDロック"
  listFormat = "ul">
</field:code_radio>
```

**実装成果物（サーバ動作）**:
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

field:code_radio, コードラジオボタン, コード管理機能, ラジオボタン入力, codeId, listFormat, field_radio

</details>

## 仕様（属性値一覧）

本ウィジェットの仕様は [field_radio](testing-framework-field_radio.md) とほぼ同じ。以下は差分のみ記載。

**ローカル動作時の挙動**:
- [field_radio](testing-framework-field_radio.md) と同様、`sample` に指定したラベル分だけラジオボタンとラベルを表示する。
- `codeId` 属性にコードIDを指定した場合、`/js/devtool/resource/コード値定義.js` 内のエントリからコード名称を取得して表示。`pattern` 属性・`optionColumnName` 属性も使用可能。
- `codeId` と `sample` を両方指定した場合は `sample` を優先する。

**属性値一覧**（[field_base](testing-framework-field_base.md) との共通属性は省略）:

凡例: ◎=必須 ○=任意 ×=無効

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: false |
| disabled | サーバへの入力値送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: false |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 複数入力項目を1エラーメッセージでハイライトする場合のname属性をカンマ区切りで指定 | 文字列 | ○ | × | |
| sample | ローカル動作時に表示するラジオボタンのラベル | 文字列 | × | ○ | `\|`区切りで複数指定。`[]`で囲まれた項目は選択状態で表示 |
| codeId | コード定義ID | 文字列 | ◎ | ○ | |
| pattern | 使用するコードパターンのカラム名 | 文字列 | ○ | ○ | デフォルト: PATTERN01 |
| optionColumnName | 取得するオプション名称のカラム名 | 文字列 | ○ | ○ | デフォルト: OPTION01 |
| labelPattern | ラベル表示書式 | 文字列 | ○ | ○ | プレースホルダ: `$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称、使用時はoptionColumnName必須）、`$VALUE$`（コード値）。デフォルト: `$NAME$` |
| listFormat | リスト表示時のフォーマット | 文字列 | ○ | ○ | デフォルト: span |
| dataFrom | 表示データの取得元 | 文字列 | × | × | 画面項目定義の「表示情報取得元.表示項目名」形式で設定 |
| comment | ラジオボタンの備考 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |

<details>
<summary>keywords</summary>

codeId, pattern, optionColumnName, labelPattern, listFormat, domain, readonly, disabled, cssClass, nameAlias, sample, dataFrom, comment, initialValueDesc, コードパターン, ラベル表示書式, $NAME$, $SHORTNAME$, $OPTIONALNAME$, $VALUE$, ローカル動作

</details>

## 内部構造・改修時の留意点

**部品一覧**:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/code_radio.tag | [field_code_radio](testing-framework-field_code_radio.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:codeRadioButtons>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（ラジオボタンに関する定義を含む） |

<details>
<summary>keywords</summary>

code_radio.tag, base.tag, nablarch.js, base.less, タグライブラリスタブ, n:codeRadioButtons, 内部構造

</details>
