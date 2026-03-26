# 一覧テーブルウィジェット

## 概要

[table_plain](ui-framework-table_plain.md) は簡素な一覧テーブルを表示するUI部品。

以下の機能が必要な場合は [table_search_result](ui-framework-table_search_result.md) を使用すること:
- 検索結果件数の自動表示
- ページング処理
- 各カラムの値に沿ったソート処理

カラムウィジェット: [column_label](ui-framework-column_label.md), [column_code](ui-framework-column_code.md), [column_link](ui-framework-column_link.md), [column_checkbox](ui-framework-column_checkbox.md), [column_radio](ui-framework-column_radio.md)

<details>
<summary>keywords</summary>

table:plain, table_plain, table_search_result, 一覧テーブル, UI部品, ページング, ソート, 検索結果件数

</details>

## コードサンプル

**設計成果物（ローカル動作）**:
```jsp
<table:plain
  title         = "アカウント選択"
  sampleResults = "15">

  <column:checkbox
    title = "選択">
  </column:checkbox>

  <column:link
    title  = "ログインID"
    sample = "user001|user002|user003">
  </column:link>

</table:plain>
```

**実装成果物（サーバ動作）**:
```jsp
<table:plain
  title         = "アカウント選択"
  searchUri     = "/action/ss11AC/W11AC01Action/RW11AC0102"
  resultSetName = "searchResult"
  sampleResults = "15">

  <column:checkbox
    title    = "選択"
    key      = "userId"
    name     = "W11AC05.systemAccountEntityArray[${count-1}].userId"
    offValue = "0000000000">
  </column:checkbox>

  <column:link
    title  = "ログインID"
    key    = "loginId"
    uri    = "/action/ss11AC/W11AC01Action/RW11AC0103"
    sample = "user001|user002|user003">
    <n:param paramName="11AC_W11AC01.systemAccount.userId" name="row.userId"></n:param>
  </column:link>

</table:plain>
```

<details>
<summary>keywords</summary>

table:plain, column:checkbox, column:link, sampleResults, searchUri, resultSetName, n:param, JSPコードサンプル, ローカル動作, サーバ動作

</details>

## 仕様

**ローカル動作時の挙動**:
- `sampleResults` に指定した件数分のデータ行を表示。カラム内容は各カラムウィジェットの `sample` 属性の `"|"` 区切り文字列を順に表示（レコード件数が多い場合はループ）。
- `sampleResults` の値が1ページの表示総件数を超えた場合でも、ページ遷移リンクの表示は常に1。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]:

| 属性名 | 内容 | 型 | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 見出し文字列 | 文字列 | ◎ | ◎ | |
| showTitle | 見出し文字列を表示するか否か | 真偽値 | ○ | ○ | デフォルト: `true` |
| id | テーブルを一意に識別するid | 文字列 | ○ | ○ | ページ内に複数テーブルが存在する場合は必須。tableをラップするdivタグに設定される。 |
| resultSetName | 検索結果を格納する変数名 | 文字列 | ○ | × | resultSetNameとresultNumNameのどちらか一方は必ず設定すること |
| resultNumName | 検索結果件数を格納する変数名 | 文字列 | ○ | × | resultSetNameとresultNumNameのどちらか一方は必ず設定すること |
| resultSetCss | 検索結果表示領域に適用するCSSクラス | 文字列 | ○ | ○ | |
| sampleResults | サンプルで表示する件数 | 数値 | × | ◎ | |
| multipleRowLayout | 複数行レイアウト機能を有効にするかどうか | 真偽値 | ○ | ○ | 詳細は [table_row](ui-framework-table_row.md) を参照 |
| comment | テーブルについての備考 | 文字列 | × | × | 設計書の画面概要一覧の「備考」に表示 |
| estimatedMaxSearchResults | 検索結果として想定される最大件数 | 文字列 | × | × | 設計書の画面概要一覧の「想定検索最大件数」に表示 |

> **注意**: `resultSetName` と `resultNumName` はどちらか一方は必ず設定する必要がある。

<details>
<summary>keywords</summary>

title, showTitle, id, resultSetName, resultNumName, resultSetCss, sampleResults, multipleRowLayout, comment, estimatedMaxSearchResults, 属性値一覧

</details>

## 内部構造・改修時の留意点

テーブル機能は内部的に `<listSearchResult:table>` タグで実装されており、Nablarch側の設定変更でページングリストの出力パターンなどを変更可能。

**部品一覧**:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/table/plain.tag | 一覧テーブルウィジェット |
| /WEB-INF/tags/widget/column/*.tag | テーブルカラムウィジェット群 |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色など） |
| /css/style/content.less | 業務画面領域スタイル定義（テーブルサイズ定義） |

<details>
<summary>keywords</summary>

listSearchResult:table, plain.tag, nablarch.less, content.less, ページングリスト, カラムウィジェット, 部品一覧

</details>
