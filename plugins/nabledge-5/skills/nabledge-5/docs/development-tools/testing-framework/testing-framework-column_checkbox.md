# テーブル複数行選択用チェックボックスカラムウィジェット

**公式ドキュメント**: [テーブル複数行選択用チェックボックスカラムウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/column_checkbox.html)

## コードサンプル

`[column_checkbox](testing-framework-column_checkbox.md)` は、**UI標準 UI部品 テーブル** において「処理対象レコード選択用ボタン」として定義されているチェックボックスを出力するウィジェット。[table_search_result](testing-framework-table_search_result.md)、[table_plain](testing-framework-table_plain.md)、[table_treelist](testing-framework-table_treelist.md) と組み合わせて使用し、一覧テーブルから後続処理の対象行を複数行選択するためのチェックボックスカラムを出力する。

**設計成果物（ローカル動作）**

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

column:checkbox, table:search_result, table:plain, table:treelist, チェックボックスカラム, テーブル行選択, JSPコードサンプル, ローカル動作, サーバ動作, 処理対象レコード選択用ボタン, UI標準 UI部品 テーブル

</details>

## 仕様・属性値一覧

入力画面ではテーブル行を選択するためのチェックボックスが出力され、確認画面ではチェックされた行に「●」マークが表示される。

**属性値一覧** （◎=必須、○=任意、×=無効）

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| key | チェックオン時にサーバへ送信する値を行データから取得するキー | 文字列 | ◎ | × | |
| title | カラムヘッダに表示する文字列 | 文字列 | ◎ | ◎ | |
| cssClass | 各カラムに指定するCSSクラス | 文字列 | ○ | ○ | |
| checkboxCssClass | チェックボックスに指定するCSSクラス | 文字列 | ○ | ○ | |
| name | チェックボックスのname属性 | 文字列 | ◎ | ○ | |
| value | チェックボックス選択時に送信する値 | 文字列 | ○ | × | 指定なしの場合、key属性で取得した行データの値を使用 |
| offValue | チェックボックス非選択時に送信する値 | 文字列 | ○ | × | |
| disabled | サーバへの入力値送信を抑制するか | 真偽値 | ○ | ○ | デフォルト: false |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: false |
| width | カラムの横幅 | 文字列 | ○ | ○ | |
| toggle | 全選択/解除操作を可能とするか | 真偽値 | ○ | ○ | デフォルト: false（一括選択/解除は不可）。> **補足**: trueを設定した場合、タイトル部に「全選択」「全解除」のリンクが出力され、全選択/解除操作が可能となる |
| colspan | 横方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は[table_row](testing-framework-table_row.md)を参照 |
| rowspan | 縦方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は[table_row](testing-framework-table_row.md)を参照 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元.表示項目名」の形式で設定 |
| comment | チェックボックスについての備考 | 文字列 | × | × | 設計書表示時に画面項目定義の「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書表示時に画面項目定義の「備考」に表示 |

<details>
<summary>keywords</summary>

key, title, cssClass, checkboxCssClass, name, value, offValue, disabled, readonly, width, toggle, colspan, rowspan, dataFrom, comment, initialValueDesc, チェックボックス属性, 全選択/解除, 確認画面, 属性値一覧

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/checkbox.tag | [column_checkbox](testing-framework-column_checkbox.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /js/jsp/taglib/nablarch.js | `<n:checkbox>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色などを定義） |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（チェックボックスに関する定義を含む） |

<details>
<summary>keywords</summary>

checkbox.tag, nablarch.js, nablarch.less, base.less, 内部構造, タグファイル, タグライブラリスタブ, 改修, listSearchResult

</details>
