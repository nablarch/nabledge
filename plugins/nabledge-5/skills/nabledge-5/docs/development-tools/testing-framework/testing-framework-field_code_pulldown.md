# コード値プルダウン入力項目ウィジェット

**公式ドキュメント**: [コード値プルダウン入力項目ウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/field_code_pulldown.html)

## コードサンプル

## コードサンプル

**設計成果物（ローカル動作）**

```jsp
<field:code_pulldown
  title="ユーザIDロック">
</field:code_pulldown>
```

**実装成果物（サーバ動作）**

```jsp
<field:code_pulldown
  title            = "ユーザIDロック"
  name             = "11AC_W11AC01.userIdLocked"
  codeId           = "C0000001"
  pattern          = "PATTERN01"
  optionColumnName = "OPTION01"
  labelPattern     = "$OPTIONALNAME$">
</field:code_pulldown>
```

<details>
<summary>keywords</summary>

field:code_pulldown, コード値プルダウン, JSPタグ, ローカル動作, サーバ動作, codeId, code_pulldown

</details>

## 仕様

## 仕様

[field_pulldown](testing-framework-field_pulldown.md) との差分のみ記述する。

**ローカル動作時の挙動**

[field_pulldown](testing-framework-field_pulldown.md) と同様に sample に指定した項目をプルダウン候補として表示する。codeId 属性にコードIDを指定した場合は `/js/devtool/resource/コード値定義.js` 内のエントリからコード名称を取得して表示する。pattern 属性・optionColumnName 属性も使用可能。codeId と sample を両方指定した場合は sample の値を優先する。

**属性値一覧**（◎ 必須属性 / ○ 任意属性 / × 無効）

([field_base](testing-framework-field_base.md) との共通属性は省略)

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | HTMLのid属性値 | 文字列 | ○ | ○ | デフォルトはname属性値と同じ |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: false |
| disabled | サーバへの入力値送信を抑制するか | 真偽値 | ○ | ○ | デフォルト: false |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 複数入力項目をハイライトする場合のname属性（カンマ区切り） | 文字列 | ○ | × | |
| sample | ローカル動作時のプルダウンラベル | 文字列 | × | ○ | "\|"区切りで複数指定。"[]"で囲まれた項目は選択状態で表示 |
| codeId | コード定義ID | 文字列 | ◎ | ○ | |
| pattern | 使用するコードパターンのカラム名 | 文字列 | ○ | ○ | デフォルト: PATTERN01 |
| optionColumnName | 取得するオプション名称のカラム名 | 文字列 | ○ | ○ | デフォルト: OPTION01 |
| labelPattern | ラベル表示書式 | 文字列 | ○ | ○ | プレースホルダ: $NAME$（コード名称）、$SHORTNAME$（略称）、$OPTIONALNAME$（オプション名称、使用時はoptionColumnName必須）、$VALUE$（コード値）。デフォルト: "$NAME$" |
| withNoneOption | リスト先頭に選択なしオプションを追加するか | 真偽値 | ○ | ○ | デフォルト: false |
| multiple | xhtmlのmultiple属性 | 真偽値 | ○ | ○ | |
| size | xhtmlのsize属性 | 数値 | ○ | ○ | |
| dataFrom | 表示データの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式 |
| comment | プルダウンの備考 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |
| initialValueDesc | 初期表示内容の説明 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |

<details>
<summary>keywords</summary>

属性値一覧, codeId, pattern, optionColumnName, labelPattern, sample, withNoneOption, コード管理機能, プルダウン属性, コード値定義.js, id, domain, readonly, disabled, cssClass, nameAlias, multiple, size, dataFrom, comment, initialValueDesc

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/field/code_pulldown.tag | [field_code_pulldown](testing-framework-field_code_pulldown.md) |
| /WEB-INF/tags/widget/field/base.tag | [field_base](testing-framework-field_base.md) |
| /js/jsp/taglib/nablarch.js | `<n:codeSelect>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。プルダウンに関する定義も含まれる。 |

<details>
<summary>keywords</summary>

code_pulldown.tag, nablarch.js, base.less, タグライブラリスタブ, 部品一覧, n:codeSelect

</details>
