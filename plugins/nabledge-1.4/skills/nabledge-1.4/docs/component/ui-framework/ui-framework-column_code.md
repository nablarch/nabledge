# コード値ラベル表示用カラムウィジェット

## コードサンプル

**設計成果物（ローカル動作）**

```jsp
<table:search_result
  title         = "検索結果"
  sampleResults = "15">

  <column:checkbox
    title = "選択">
  </column:checkbox>

  <column:code
    title="性別">
  </column:code>

</table:search_result>
```

**実装成果物（サーバ動作）**

```jsp
<table:search_result
  title               = "検索結果"
  searchUri           = "/action/ss11AC/W11AC01Action/RW11AC0102"
  listSearchInfoName  = "11AC_W11AC01"
  resultSetName       = "searchResult"
  sampleResults       = "15">

  <column:checkbox
    title    = "選択"
    key      = "userId"
    name     = "W11AC05.systemAccountEntityArray[${count-1}].userId"
    offValue = "0000000000">
  </column:checkbox>

  <column:code
    title  = "性別"
    key    = "gender"
    codeId = "code1">
  </column:code>

</table:search_result>
```

<details>
<summary>keywords</summary>

column:code, table:search_result, column:checkbox, コードサンプル, JSPウィジェット, コード値表示, codeId, key

</details>

## 仕様

**ローカル動作時の挙動**

- `sample` 属性の `"|"` 区切り文字列を順に表示（`sampleResults` の件数が多い場合はループ）
- `codeId` 属性指定時は `/js/devtool/resource/コード値定義.js` からコード名称を取得。`pattern` 属性によるパターン指定や `optionColumnName` 属性によるオプション名称指定も利用可能
- `codeId` と `sample` を両方指定した場合は `sample` の値を優先

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| key | 行データからコード値を取得するキー | 文字列 | ◎ | × | |
| title | カラムヘッダーに表示する文字列 | 文字列 | ◎ | ◎ | |
| cssClass | 各カラムに指定するCSSクラス | 文字列 | ○ | ○ | |
| sortable | カラムのソートリンクを表示するかどうか | 文字列 | ○ | ○ | デフォルト`'false'`。[table_search_result](ui-framework-table_search_result.md) でのみ利用可能 |
| sample | テスト用のダミー表示値 | 文字列 | × | ○ | `"|"` 区切りで複数指定 |
| samplePattern | 一行あたりに出力するコード値の件数のパターン | 文字列 | × | ○ | `","` 区切りで指定 |
| codeId | コード定義ID | 文字列 | ◎ | ○ | |
| pattern | 使用するコードパターンのカラム名 | 文字列 | ○ | ○ | デフォルト`'PATTERN01'` |
| optionColumnName | 取得するオプション名称のカラム名 | 文字列 | ○ | ○ | デフォルト`'OPTION01'` |
| labelPattern | ラベル表示書式 | 文字列 | ○ | ○ | プレースホルダ: `$NAME$`(コード名称)、`$SHORTNAME$`(略称)、`$OPTIONALNAME$`(オプション名称)、`$VALUE$`(コード値)。デフォルト`"$NAME$"`。`$OPTIONALNAME$` 使用時は `optionColumnName` の指定が必須 |
| listFormat | リスト表示時のフォーマット | 文字列 | ○ | ○ | デフォルト`'sp'` |
| width | カラムの横幅 | 文字列 | ○ | ○ | |
| additional | 付加情報として扱うかどうか | 真偽値 | ○ | ○ | `true` の場合、narrow表示モードで別形式表示。デフォルト`false`。**autospan/rowspan属性を使用しているテーブルでは使用不可** |
| colspan | 横方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は [table_row](ui-framework-table_row.md) を参照 |
| rowspan | 縦方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は [table_row](ui-framework-table_row.md) を参照 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 設計書用（画面項目定義の「表示情報取得元」.「表示項目名」形式） |
| comment | コード値表示についての備考 | 文字列 | × | × | 設計書用（画面項目定義の「備考」に表示） |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書用（画面項目定義の「備考」に表示） |

![additional属性のnarrow表示モード例](../../../knowledge/component/ui-framework/assets/ui-framework-column_code/additional_column.png)

> **警告**: autospan/rowspan属性を使用しているテーブルでは `additional` 属性を使用することはできない。

<details>
<summary>keywords</summary>

key, title, cssClass, sortable, sample, samplePattern, codeId, pattern, optionColumnName, labelPattern, listFormat, width, additional, colspan, rowspan, dataFrom, comment, initialValueDesc, コード値ラベル, 属性値一覧, ローカル動作, $NAME$, $SHORTNAME$, $OPTIONALNAME$, $VALUE$

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/code.tag | [column_code](ui-framework-column_code.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /js/jsp/taglib/nablarch.js | `<n:code>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色など） |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（リンクに関する定義を含む） |

<details>
<summary>keywords</summary>

column/code.tag, nablarch.js, nablarch.less, base.less, タグファイル, 部品構成

</details>
