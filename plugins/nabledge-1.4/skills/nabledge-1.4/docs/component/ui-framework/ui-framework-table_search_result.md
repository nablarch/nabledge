# 検索結果テーブルウィジェット

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

table:search_result, column:checkbox, column:link, n:param, 検索結果テーブル, JSPタグ, コードサンプル, ローカル動作, サーバ動作

</details>

## 仕様

ローカル動作時の挙動は [table_plain](ui-framework-table_plain.md) と同じ。

**属性値一覧** (◎ 必須属性 / ○ 任意属性 / × 無効)

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 見出し文字列 | 文字列 | ◎ | ◎ | |
| showTitle | 見出し文字列を表示するか否か | 真偽値 | ○ | ○ | デフォルト: `true` |
| id | テーブルを一意に識別するid | 文字列 | × | ○ | ページ内に複数のテーブルが存在する場合は必須。id属性はtableをラップするdivタグに設定される。 |
| searchUri | 検索処理を行うリクエストのURI | 文字列 | ○ | × | ページング及びソート機能を使用する場合は必須。 |
| listSearchInfoName | 検索条件を格納する変数名 | 文字列 | ◎ | × | |
| resultSetName | 検索結果を格納する変数名 | 文字列 | ○ | × | resultSetNameとresultNumNameはどちらか一方は必ず設定する必要がある。 |
| resultNumName | 検索結果件数を格納する変数名 | 文字列 | ○ | × | resultSetNameとresultNumNameはどちらか一方は必ず設定する必要がある。 |
| resultSetCss | 検索結果表示領域に適用するCSSクラス | 文字列 | ○ | ○ | |
| usePaging | ページングを使用するか否か | 真偽値 | ○ | ○ | デフォルト: `true` |
| sampleResults | サンプルで表示する件数 | 数値 | × | ◎ | |
| sortCondition | テーブルの初期ソート条件 | 文字列 | × | × | 設計書の表示時に画面概要の「ソート条件」に表示される。 |
| multipleRowLayout | 複数行レイアウト機能を有効にするかどうか | 真偽値 | ○ | ○ | 詳細は [table_row](ui-framework-table_row.md) を参照。 |
| comment | テーブルについての備考 | 文字列 | × | × | 設計書の表示時に画面概要の「備考」に表示される。 |
| estimatedMaxSearchResults | 検索結果として想定される最大件数 | 文字列 | × | × | 設計書の表示時に画面概要の「想定検索最大件数」に表示される。 |

<details>
<summary>keywords</summary>

title, searchUri, listSearchInfoName, resultSetName, resultNumName, usePaging, sampleResults, showTitle, resultSetCss, multipleRowLayout, estimatedMaxSearchResults, sortCondition, comment, id, ページング, ソート, 属性一覧

</details>

## 内部構造・改修時の留意点

内部構造・改修時の留意点は [table_plain](ui-framework-table_plain.md) と同じ。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/table/search_result.tag | 検索結果テーブルウィジェット |

<details>
<summary>keywords</summary>

search_result.tag, 内部構造, 部品一覧, 検索結果テーブルウィジェット

</details>
