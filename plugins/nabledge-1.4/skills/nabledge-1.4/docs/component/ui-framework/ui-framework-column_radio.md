# テーブル行選択用ラジオボタンカラムウィジェット

## コードサンプル

[column_radio](ui-framework-column_radio.md) は、**UI標準 UI部品 テーブル**において、「処理対象レコード選択用ボタン」として定義されているラジオボタンを出力するウィジェット。[table_search_result](ui-framework-table_search_result.md)、[table_plain](ui-framework-table_plain.md)、[table_treelist](ui-framework-table_treelist.md) と組み合わせて使用し、一覧テーブルから後続処理の対象行を複数行選択するためのラジオボタンから成るカラムを出力する。

**設計成果物(ローカル動作)**:

```jsp
<table:search_result
  title         = "検索結果"
  sampleResults = "15">

  <column:radio
    title = "選択">
  </column:radio>

</table:search_result>
```

**実装成果物(サーバ動作)**:

```jsp
<table:search_result
  title               = "検索結果"
  searchUri           = "/action/ss11AC/W11AC01Action/RW11AC0102"
  listSearchInfoName  = "11AC_W11AC01"
  resultSetName       = "searchResult"
  sampleResults       = "15">

  <column:radio
    title    = "選択"
    key      = "userId"
    name     = "W11AC05.userId">
  </column:radio>

</table:search_result>
```

<details>
<summary>keywords</summary>

column:radio, table_search_result, table_plain, table_treelist, ラジオボタンカラム, テーブル行選択, ウィジェット使用例, JSPタグ

</details>

## 仕様

入力画面ではラジオボタンが出力され、確認画面では選択された行に「●」マークが表示される。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| key | 選択状態の場合にサーバに送信する値を行データから取得するキー | 文字列 | ◎ | × | |
| title | カラムヘッダーに表示する文字列 | 文字列 | ◎ | ◎ | |
| cssClass | 各カラムに指定するCSSクラス | 文字列 | ○ | ○ | |
| name | ラジオボタンのname属性 | 文字列 | ◎ | ○ | |
| value | ラジオボタン選択時に送信する値 | 文字列 | ○ | × | 指定されない場合、行データからkey属性に指定した名前で取得した値を利用する |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト値は'false' |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト値は'false' |
| width | カラムの横幅の指定 | 文字列 | ○ | ○ | |
| colspan | 横方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は[table_row](ui-framework-table_row.md)を参照 |
| rowspan | 縦方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は[table_row](ui-framework-table_row.md)を参照 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する「表示情報取得元」.「表示項目名」の形式で設定する |
| comment | ラジオボタンについての備考 | 文字列 | × | × | 設計書の表示時に、画面項目定義の項目定義一覧で「備考」に表示される |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に、画面項目定義の項目定義一覧で「備考」に表示される |

<details>
<summary>keywords</summary>

key, title, cssClass, name, value, disabled, readonly, width, colspan, rowspan, dataFrom, comment, initialValueDesc, 属性値一覧, ラジオボタン仕様, 入力画面, 確認画面

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/radio.tag | [column_radio](ui-framework-column_radio.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /js/jsp/taglib/nablarch.js | `<n:radioButton>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色など） |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（ラジオボタンに関する定義を含む） |

<details>
<summary>keywords</summary>

radio.tag, nablarch.js, nablarch.less, base.less, 内部構造, タグファイル, listSearchResult, n:radioButton

</details>
