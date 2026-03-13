# 一覧テーブルウィジェット

**公式ドキュメント**: [一覧テーブルウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/table_plain.html)

## 一覧テーブルウィジェット概要

## 一覧テーブルウィジェット概要

`table:plain` は **UI標準 UI部品 テーブル** の内容に準拠した簡素な一覧テーブルを画面に表示するUI部品。テーブル内の各カラムの内容は、カラムの種別ごとに用意された個別のウィジェットを配置することによって定義する。

以下の機能が必要な場合は `table_search_result` を使用すること:
- 検索結果件数の自動表示
- ページング処理
- 各カラムの値に沿ったソート処理

各カラムウィジェット: `column_label`, `column_code`, `column_link`, `column_checkbox`, `column_radio`

<details>
<summary>keywords</summary>

table:plain, table_search_result, 一覧テーブル, JSPウィジェット, ページング不要テーブル, column:label, column:code, column:link, column:checkbox, column:radio

</details>

## コードサンプル

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

table:plain, column:checkbox, column:link, sampleResults, searchUri, resultSetName, ローカル動作, サーバ動作

</details>

## 仕様（属性値一覧）

## 仕様（属性値一覧）

**ローカル動作時の挙動**: `sampleResults` に指定した件数分のデータ行を表示。各カラムの内容は `sample` 属性の `"|"` 区切り文字列を順に表示（レコード件数がサンプル数より多い場合はループ）。`sampleResults` が1ページの表示総件数を超えた場合でもページ遷移リンクは常に1。

`resultSetName` と `resultNumName` はどちらか一方は必ず設定すること。

**属性値一覧** (◎ 必須 ○ 任意 × 無効):

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 見出し文字列 | 文字列 | ◎ | ◎ | |
| showTitle | 見出し文字列を表示するか否か | 真偽値 | ○ | ○ | デフォルト: `true` |
| id | テーブルを一意に識別するid | 文字列 | ○ | ○ | ページ内に複数テーブルが存在する場合は必須。tableをラップするdivタグに設定される |
| resultSetName | 検索結果を格納する変数名 | 文字列 | ○ | × | resultSetNameまたはresultNumNameのどちらか一方は必須 |
| resultNumName | 検索結果件数を格納する変数名 | 文字列 | ○ | × | resultSetNameまたはresultNumNameのどちらか一方は必須 |
| resultSetCss | 検索結果表示領域に適用するCSSクラス | 文字列 | ○ | ○ | |
| sampleResults | サンプルで表示する件数 | 数値 | × | ◎ | |
| multipleRowLayout | 複数行レイアウト機能を有効にするかどうか | 真偽値 | ○ | ○ | 詳細は `table_row` を参照 |
| comment | テーブルについての備考 | 文字列 | × | × | 設計書の画面概要一覧表示の「備考」に表示 |
| estimatedMaxSearchResults | 検索結果として想定される最大件数 | 文字列 | × | × | 設計書の画面概要一覧表示の「想定検索最大件数」に表示 |

<details>
<summary>keywords</summary>

title, showTitle, id, resultSetName, resultNumName, resultSetCss, sampleResults, multipleRowLayout, comment, estimatedMaxSearchResults, 属性値一覧, 必須属性, 任意属性

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

テーブル機能は内部的に Nablarchが提供している `<listSearchResult:table>` タグで実装。Nablarch側の設定変更でページングリストの出力パターン等を変更可能。詳細は「Nablarch アーキテクチャ解説書」を参照。

**部品一覧**:

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/table/plain.tag | 一覧テーブルウィジェット |
| /WEB-INF/tags/widget/column/\*.tag | テーブルカラムウィジェット群 |
| /WEB-INF/tags/listSearchResult/\*.tag | Nablarch検索結果テーブルタグファイル |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色など） |
| /css/style/content.less | 業務画面領域スタイル定義（テーブルサイズ） |

<details>
<summary>keywords</summary>

listSearchResult:table, plain.tag, 内部構造, ページングリスト, nablarch.less, content.less

</details>
