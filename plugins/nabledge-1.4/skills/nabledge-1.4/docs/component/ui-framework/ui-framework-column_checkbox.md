# テーブル複数行選択用チェックボックスカラムウィジェット

## 概要とコードサンプル

[column_checkbox](ui-framework-column_checkbox.md) は、テーブルにおける「処理対象レコード選択用ボタン」として定義されているチェックボックスを出力するウィジェット。[table_search_result](ui-framework-table_search_result.md)、[table_plain](ui-framework-table_plain.md)、[table_treelist](ui-framework-table_treelist.md) と組み合わせて使用し、複数行選択用のチェックボックスカラムを出力する。

## コードサンプル

**設計成果物（ローカル動作）**:

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

**実装成果物（サーバ動作）**:

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

column:checkbox, チェックボックスカラム, 複数行選択, テーブル行選択, table_search_result, table_plain, table_treelist, 設計成果物, 実装成果物

</details>

## 仕様・属性値一覧

入力画面ではテーブル行選択用のチェックボックスが出力され、確認画面ではチェックされた行に「●」マークが表示される。

**属性値一覧**（◎ 必須属性 / ○ 任意属性 / × 無効）

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| key | チェックオン時にサーバに送信する値を行データから取得するキー | 文字列 | ◎ | × | |
| title | カラムヘッダーに表示する文字列 | 文字列 | ◎ | ◎ | |
| cssClass | 各カラムに指定するCSSクラス | 文字列 | ○ | ○ | |
| checkboxCssClass | チェックボックスに指定するCSSクラス | 文字列 | ○ | ○ | |
| name | チェックボックスのname属性 | 文字列 | ◎ | ○ | |
| value | チェックボックス選択時に送信する値 | 文字列 | ○ | × | 未指定の場合、key属性で行データから取得した値を使用 |
| offValue | チェックボックス非選択時に送信する値 | 文字列 | ○ | × | |
| disabled | サーバへの入力値送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト: false |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト: false |
| width | カラムの横幅 | 文字列 | ○ | ○ | |
| toggle | 全選択/解除操作を可能とするかどうか | 真偽値 | ○ | ○ | デフォルト: false。true設定時はタイトル部に「全選択」「全解除」リンクが出力される |
| colspan | 横方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は [table_row](ui-framework-table_row.md) を参照 |
| rowspan | 縦方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は [table_row](ui-framework-table_row.md) を参照 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 設計書表示用。「表示情報取得元.表示項目名」形式 |
| comment | チェックボックスについての備考 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義「備考」に表示 |

<details>
<summary>keywords</summary>

key, title, cssClass, checkboxCssClass, name, offValue, value, disabled, readonly, width, toggle, colspan, rowspan, dataFrom, comment, initialValueDesc, 全選択, 全解除, 属性値一覧, 確認画面, ●マーク

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/checkbox.tag | [column_checkbox](ui-framework-column_checkbox.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /js/jsp/taglib/nablarch.js | `<n:checkbox>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色など） |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（チェックボックスに関する定義を含む） |

<details>
<summary>keywords</summary>

checkbox.tag, nablarch.js, nablarch.less, base.less, 部品一覧, タグライブラリスタブ, listSearchResult

</details>
