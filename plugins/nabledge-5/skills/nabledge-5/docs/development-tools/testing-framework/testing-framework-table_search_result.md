# 検索結果テーブルウィジェット

**公式ドキュメント**: [検索結果テーブルウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/table_search_result.html)

## コードサンプル

**設計成果物(ローカル動作)**

```jsp
<table:search_result
  title         = "検索結果"
  sampleResults = "15">

  <column:checkbox
    title = "選択">
  </column:checkbox>

  <column:link
    title  = "ログインID"
    sample = "user001|user002|user003">
  </column:link>

</table:search_result>
```

**実装成果物(サーバ動作)**

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

  <column:link
    title    = "ログインID"
    key      = "loginId"
    uri      = "/action/ss11AC/W11AC01Action/RW11AC0103"
    sortable = "true"
    sample   = "user001|user002|user003">
    <n:param paramName="11AC_W11AC01.systemAccount.userId" name="row.userId"></n:param>
  </column:link>

</table:search_result>
```

<details>
<summary>keywords</summary>

table:search_result, column:checkbox, column:link, コードサンプル, JSPウィジェット, ローカル動作, サーバ動作, 検索結果テーブル

</details>

## 仕様

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 見出し文字列 | 文字列 | ◎ | ◎ | |
| showTitle | 見出し文字列を表示するか否か | 真偽値 | ○ | ○ | デフォルト: `true` |
| id | テーブルを一意に識別するid | 文字列 | × | ○ | ページ内に複数テーブルが存在する場合は必須。tableをラップするdivタグに設定される |
| searchUri | 検索処理を行うリクエストのURI | 文字列 | ○ | × | ページング・ソート機能使用時は必須 |
| listSearchInfoName | 検索条件を格納する変数名 | 文字列 | ◎ | × | |
| resultSetName | 検索結果を格納する変数名 | 文字列 | ○ | × | [1] |
| resultNumName | 検索結果件数を格納する変数名 | 文字列 | ○ | × | [1] |
| resultSetCss | 検索結果表示領域に適用するCSSクラス | 文字列 | ○ | ○ | |
| usePaging | ページングを使用するか否か | 真偽値 | ○ | ○ | 空文字列を設定するとサーバ(true扱い)とローカル(false扱い)で動作が異なるため、明示的に`true`または`false`を設定すること。未記述時はサーバ・ローカルともに`true`扱い |
| sampleResults | サンプルで表示する件数 | 数値 | × | ◎ | |
| sortCondition | テーブルの初期ソート条件 | 文字列 | × | × | 設計書の画面概要一覧の「ソート条件」に表示 |
| multipleRowLayout | 複数行レイアウト機能を有効にするかどうか | 真偽値 | ○ | ○ | 詳細は [table_row](testing-framework-table_row.md) を参照 |
| comment | テーブルについての備考 | 文字列 | × | × | 設計書の画面概要一覧の「備考」に表示 |
| estimatedMaxSearchResults | 検索結果として想定される最大件数 | 文字列 | × | × | 設計書の画面概要一覧の「想定検索最大件数」に表示 |

[1] resultSetNameとresultNumNameはどちらか一方は必ず設定する必要がある。

> **重要**: `usePaging`に空文字列を設定した場合、サーバとローカルで動作が異なる（サーバ: `true`として扱われるが、ローカル: `false`として解釈される）。本属性を記述する場合は明示的に`true`または`false`を設定すること。

<details>
<summary>keywords</summary>

title, showTitle, id, searchUri, listSearchInfoName, resultSetName, resultNumName, resultSetCss, usePaging, sampleResults, sortCondition, multipleRowLayout, comment, estimatedMaxSearchResults, 属性一覧, ページング, ソート機能, 検索結果件数

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/table/search_result.tag | 検索結果テーブルウィジェット |

<details>
<summary>keywords</summary>

search_result.tag, 部品パス, タグファイル, 内部構造

</details>
