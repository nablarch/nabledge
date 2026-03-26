# リンク表示用カラムウィジェット

## コードサンプル

[column_link](ui-framework-column_link.md) は、**UI標準 UI部品 テーブル** において「レコード毎リンク」として定義されているリンクを出力するウィジェット。 [table_search_result](ui-framework-table_search_result.md) 、 [table_plain](ui-framework-table_plain.md) 、 [table_treelist](ui-framework-table_treelist.md) と組み合わせて使用し、一覧テーブルから後続処理の対象行を1行選択して処理を継続するための画面に遷移するリンクを出力する。

**ローカル動作（設計成果物）**:
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

**サーバ動作（実装成果物）**:
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
    title  = "ログインID"
    key    = "loginId"
    uri    = "/action/ss11AC/W11AC01Action/RW11AC0103"
    sample = "user001|user002|user003">
    <n:param paramName="11AC_W11AC01.systemAccount.userId" name="row.userId"></n:param>
  </column:link>

</table:search_result>
```

<details>
<summary>keywords</summary>

column_link, table_search_result, table_plain, table_treelist, リンク表示ウィジェット, 一覧テーブル行選択リンク, JSPカスタムタグ, n:param, UI標準 UI部品 テーブル, レコード毎リンク, column:checkbox

</details>

## 仕様

ローカル動作: `sample`属性の`|`区切り文字列を順に表示（`sampleResults`指定件数の方が多い場合はループ）。

属性凡例: **◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| key | リンク文字列とする値を行データから取得するキー | 文字列 | ○ | × | |
| title | カラムヘッダーに表示する文字列 | 文字列 | ◎ | ◎ | |
| value | リンクテキスト文字列 | 文字列 | ○ | ○ | 指定されない場合はkey属性で取得した行データの値を利用 |
| domain | データのドメイン型 | 文字列 | ○ | ○ | リンク表示部のCSSとして利用 |
| cssClass | 各カラムに指定するCSSクラス | 文字列 | ○ | ○ | |
| sortable | カラムのソートリンクを表示するかどうか | 文字列 | ○ | ○ | デフォルト`false`。[table_search_result](ui-framework-table_search_result.md) でのみ利用可能 |
| uri | リンク対象URI | 文字列 | ◎ | × | |
| inactive | リンクを非活性とするかどうか | 真偽値 | ○ | ○ | デフォルト`false`。trueの場合はラベル表示 |
| colspan | 横方向に結合するカラム数 | 数値 | ○ | ○ | [table_row](ui-framework-table_row.md) 参照 |
| rowspan | 縦方向に結合するカラム数 | 数値 | ○ | ○ | [table_row](ui-framework-table_row.md) 参照 |
| sample | テスト用ダミー表示値 | 文字列 | × | ○ | 「|」区切りで複数指定 |
| dummyUri | テスト用ダミー遷移先 | 文字列 | × | ○ | |
| width | カラムの横幅 | 文字列 | ○ | ○ | |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義の「表示情報取得元.表示項目名」形式（設計書専用） |
| comment | リンクについての備考 | 文字列 | × | × | 設計書の画面項目定義で「備考」に表示（設計書専用） |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義で「備考」に表示（設計書専用） |

<details>
<summary>keywords</summary>

key, title, value, domain, cssClass, sortable, uri, inactive, colspan, rowspan, sample, dummyUri, width, dataFrom, comment, initialValueDesc, リンクカラム属性, ローカル動作

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/link.tag | [column_link](ui-framework-column_link.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /js/jsp/taglib/nablarch.js | `<n:submitLink>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色など） |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（リンク関連定義を含む） |

<details>
<summary>keywords</summary>

link.tag, nablarch.js, submitLink, タグライブラリスタブ, nablarch.less, base.less, 内部構造

</details>
