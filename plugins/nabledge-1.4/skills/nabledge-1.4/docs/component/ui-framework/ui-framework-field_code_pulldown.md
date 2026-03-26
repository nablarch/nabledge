# コード値プルダウン入力項目ウィジェット

## コードサンプル

[field_code_pulldown](ui-framework-field_code_pulldown.md) は [field_pulldown](ui-framework-field_pulldown.md) について、Nablarchのコード管理機能で取得したラベル・値をもとにしたプルダウンリストを出力できるように改修したものである。表示仕様など上記以外の仕様は [field_pulldown](ui-framework-field_pulldown.md) と同じである。

**設計成果物（ローカル動作）**:
```jsp
<field:code_pulldown
  title = "ユーザIDロック">
</field:code_pulldown>
```

**実装成果物（サーバ動作）**:
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

field:code_pulldown, code_pulldown, コードサンプル, プルダウン実装例, JSP, codeId, labelPattern, optionColumnName

</details>

## 仕様

本ウィジェットの仕様は [field_pulldown](ui-framework-field_pulldown.md) とほぼ同じ。以下では差分となる内容を示す。

**ローカル動作時の挙動**:
- `codeId` 属性にコードIDを指定した場合、`/js/devtool/resource/コード値定義.js` 内のエントリーから該当コードの名称を取得して表示する。`pattern` 属性によるパターン指定・`optionColumnName` 属性によるオプション名称指定も利用可能。
- `codeId` と `sample` を両方指定した場合は **`sample` の値を優先する**。

**属性値一覧** [◎=必須属性 ○=任意属性 ×=無効（指定しても効果なし）]
（[field_base](ui-framework-field_base.md) との共通属性は省略）

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| id | HTMLのid属性値 | 文字列 | ○ | ○ | デフォルトは `name` 属性値と同じ値 |
| domain | 項目のドメイン型 | 文字列 | ○ | ○ | |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: `false` |
| disabled | サーバへの入力値送信を抑制するか | 真偽値 | ○ | ○ | デフォルト: `false` |
| cssClass | HTMLのclass属性値 | 文字列 | ○ | ○ | |
| nameAlias | 複数の入力項目をハイライト表示する場合のname属性（カンマ区切り） | 文字列 | ○ | × | |
| sample | ローカル動作時に表示するプルダウンのラベル | 文字列 | × | ○ | `"|"` 区切りで複数指定。`"[]"` で囲われた項目は選択状態で表示 |
| codeId | コード定義ID | 文字列 | ◎ | ○ | |
| pattern | 使用するコードパターンのカラム名 | 文字列 | ○ | ○ | デフォルト: `PATTERN01` |
| optionColumnName | 取得するオプション名称のカラム名 | 文字列 | ○ | ○ | デフォルト: `OPTION01` |
| labelPattern | ラベル表示書式 | 文字列 | ○ | ○ | プレースホルダ: `$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称、`optionColumnName` 必須）、`$VALUE$`（コード値）。デフォルト: `"$NAME$"` |
| withNoneOption | リスト先頭に選択なしオプションを追加するか | 真偽値 | ○ | ○ | デフォルト: `false` |
| multiple | xhtmlのmultiple属性 | 真偽値 | ○ | ○ | |
| size | xhtmlのsize属性 | 数値 | ○ | ○ | |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式 |
| comment | プルダウンについての備考 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |

<details>
<summary>keywords</summary>

codeId, pattern, optionColumnName, labelPattern, withNoneOption, sample, nameAlias, コード値プルダウン仕様, コードパターン, ラベル表示書式, コード管理機能, プルダウン属性, $NAME$, $OPTIONALNAME$, $SHORTNAME$, $VALUE$, id, domain, readonly, disabled, cssClass, multiple, size, dataFrom, comment, initialValueDesc

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/field/code_pulldown.tag` | [field_code_pulldown](ui-framework-field_code_pulldown.md) |
| `/WEB-INF/tags/widget/field/base.tag` | [field_base](ui-framework-field_base.md) |
| `/js/jsp/taglib/nablarch.js` | `<n:codeSelect>` のエミュレーション機能を実装するタグライブラリスタブJS |
| `/css/style/base.less` | 基本HTMLの要素のスタイル定義（プルダウンに関する定義を含む） |

<details>
<summary>keywords</summary>

code_pulldown.tag, nablarch.js, n:codeSelect, base.tag, base.less, 部品一覧, 内部構造, タグライブラリ

</details>
