# リンク表示用カラムウィジェット

**公式ドキュメント**: [リンク表示用カラムウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/column_link.html)

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

column:link, table:search_result, リンクカラム実装例, JSPコードサンプル, column:link使用例, n:param, ローカル動作, サーバ動作

</details>

## 仕様

ローカル動作時: `sample`属性に指定した`"|"`区切りの文字列を順にカラム内容として表示する。テーブルの`sampleResults`の件数の方が多い場合はループする。

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| key | リンク文字列とする値を行データから取得するキー | 文字列 | ○ | × | |
| title | カラムヘッダに表示する文字列 | 文字列 | ◎ | ◎ | |
| value | リンクテキスト文字列 | 文字列 | ○ | ○ | 未指定時はkey属性で行データから取得した値を使用 |
| domain | データのドメイン型 | 文字列 | ○ | ○ | 指定されたドメイン型はリンク表示部のCSSとして使用 |
| cssClass | 各カラムに指定するCSSクラス | 文字列 | ○ | ○ | |
| sortable | カラムのソートリンクを表示するかどうか | 文字列 | ○ | ○ | デフォルト`'false'`。[table_search_result](testing-framework-table_search_result.md) でのみ使用可能 |
| uri | リンク対象URI | 文字列 | ◎ | × | |
| inactive | リンクを非活性とするかどうか | 真偽値 | ○ | ○ | デフォルト`'false'`。`true`の場合リンクを非活性としラベル表示 |
| colspan | 横方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は[table_row](testing-framework-table_row.md)を参照 |
| rowspan | 縦方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は[table_row](testing-framework-table_row.md)を参照 |
| sample | テスト用のダミー表示値 | 文字列 | × | ○ | `"|"`区切りで複数指定 |
| dummyUri | テスト用のダミー遷移先 | 文字列 | × | ○ | |
| width | カラムの横幅 | 文字列 | ○ | ○ | |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 「表示情報取得元」.「表示項目名」の形式。設計書表示用 |
| comment | リンクについての備考 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の画面項目定義の「備考」に表示 |

<details>
<summary>keywords</summary>

key, title, value, domain, cssClass, sortable, uri, inactive, colspan, rowspan, sample, dummyUri, width, dataFrom, comment, initialValueDesc, column:link属性一覧, リンク非活性, ソートリンク, ローカル動作挙動

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/link.tag | [column_link](testing-framework-column_link.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /js/jsp/taglib/nablarch.js | `<n:submitLink>`のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色など） |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（リンクに関する定義を含む） |

<details>
<summary>keywords</summary>

link.tag, nablarch.js, nablarch.less, base.less, column_link内部構造, タグファイル, カスタマイズ

</details>
