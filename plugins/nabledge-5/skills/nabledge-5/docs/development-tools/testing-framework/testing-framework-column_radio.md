# テーブル行選択用ラジオボタンカラムウィジェット

**公式ドキュメント**: [テーブル行選択用ラジオボタンカラムウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/column_radio.html)

## コードサンプル

[column_radio](testing-framework-column_radio.md) は、[table_search_result](testing-framework-table_search_result.md)、[table_plain](testing-framework-table_plain.md)、[table_treelist](testing-framework-table_treelist.md) と組み合わせて使用し、一覧テーブルから後続処理の対象行を複数行選択するためのラジオボタンから成るカラムを出力する。

**設計成果物（ローカル動作）**:
```jsp
<table:search_result
  title         = "検索結果"
  sampleResults = "15">
  <column:radio
    title = "選択">
  </column:radio>
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
  <column:radio
    title    = "選択"
    key      = "userId"
    name     = "W11AC05.userId">
  </column:radio>
</table:search_result>
```

<details>
<summary>keywords</summary>

column:radio, table_search_result, table_plain, table_treelist, ラジオボタンカラム, テーブル行選択, JSPウィジェット

</details>

## 仕様

入力画面ではラジオボタンが出力され、確認画面では選択行に「●」マークが表示される。

属性値凡例: ◎ 必須属性、○ 任意属性、× 無効（指定しても効果なし）

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| key | 選択状態の場合にサーバに送信する値を行データから取得するキー | 文字列 | ◎ | × | |
| title | カラムヘッダに表示する文字列 | 文字列 | ◎ | ◎ | |
| cssClass | 各カラムに指定するCSSクラス | 文字列 | ○ | ○ | |
| name | ラジオボタンのname属性 | 文字列 | ◎ | ○ | |
| value | ラジオボタン選択時に送信する値 | 文字列 | ○ | × | 指定されない場合、行データからkey属性に指定した名前で取得した値を使用する |
| disabled | サーバに対する入力値の送信を抑制するかどうか | 真偽値 | ○ | ○ | デフォルト値は'false' |
| readonly | 編集可能かどうか | 真偽値 | ○ | ○ | デフォルト値は'false' |
| width | カラムの横幅の指定 | 文字列 | ○ | ○ | |
| colspan | 横方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は [table_row](testing-framework-table_row.md) を参照 |
| rowspan | 縦方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は [table_row](testing-framework-table_row.md) を参照 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式で設定する |
| comment | ラジオボタンについての備考 | 文字列 | × | × | 設計書表示時に画面項目定義の「備考」に表示される |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書表示時に画面項目定義の「備考」に表示される |

<details>
<summary>keywords</summary>

key, title, cssClass, name, value, disabled, readonly, width, colspan, rowspan, dataFrom, comment, initialValueDesc, 属性値一覧, ラジオボタン属性, 行選択

</details>

## 内部構造・改修時の留意点

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/radio.tag | [column_radio](testing-framework-column_radio.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /js/jsp/taglib/nablarch.js | `<n:radioButton>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色などを定義） |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（ラジオボタンに関する定義を含む） |

<details>
<summary>keywords</summary>

radio.tag, listSearchResult, nablarch.js, nablarch.less, base.less, タグファイル, 内部構造, 部品一覧

</details>
