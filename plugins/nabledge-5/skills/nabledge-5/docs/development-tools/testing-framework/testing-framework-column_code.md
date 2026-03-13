# コード値ラベル表示用カラムウィジェット

**公式ドキュメント**: [コード値ラベル表示用カラムウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/column_code.html)

## コードサンプル

**ローカル動作**

```jsp
<table:search_result
  title         = "検索結果"
  sampleResults = "15">

  <column:checkbox
    title = "選択">
  </column:checkbox>

  <column:code
    title="性別">
  </column:code>

</table:search_result>
```

**サーバ動作**

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

  <column:code
    title  = "性別"
    key    = "gender"
    codeId = "code1">
  </column:code>

</table:search_result>
```

<details>
<summary>keywords</summary>

column:code, コードサンプル, JSPウィジェット, ローカル動作, サーバ動作

</details>

## 仕様

**ローカル動作時の挙動**

- `sample`属性の`|`区切り文字列を順番に表示（sampleResultsの件数が多い場合はループ）
- `codeId`指定時: `/js/devtool/resource/コード値定義.js`内エントリからコード名称を取得。`pattern`属性・`optionColumnName`属性も使用可
- `codeId`と`sample`を両方指定した場合は`sample`優先

**属性値一覧** [◎ 必須 ○ 任意 × 無効]

| 属性名 | 型 | サーバ | ローカル | デフォルト | 説明 |
|---|---|---|---|---|---|
| key | 文字列 | ◎ | × | | 行データからコード値を取得するキー |
| title | 文字列 | ◎ | ◎ | | カラムヘッダの文字列 |
| cssClass | 文字列 | ○ | ○ | | 各カラムのCSSクラス |
| sortable | 文字列 | ○ | ○ | false | ソートリンク表示フラグ。[table_search_result](testing-framework-table_search_result.md) でのみ使用可能 |
| sample | 文字列 | × | ○ | | テスト用ダミー表示値。`\|`区切りで複数指定 |
| samplePattern | 文字列 | × | ○ | | 一行あたりのコード値件数パターン。`,`区切り |
| codeId | 文字列 | ◎ | ○ | | コード定義ID |
| pattern | 文字列 | ○ | ○ | PATTERN01 | 使用するコードパターンのカラム名 |
| optionColumnName | 文字列 | ○ | ○ | OPTION01 | 取得するオプション名称のカラム名 |
| labelPattern | 文字列 | ○ | ○ | $NAME$ | ラベル表示書式。プレースホルダ: `$NAME$`=コード名称, `$SHORTNAME$`=略称, `$OPTIONALNAME$`=オプション名称（optionColumnName必須）, `$VALUE$`=コード値 |
| listFormat | 文字列 | ○ | ○ | sp | リスト表示フォーマット |
| width | 文字列 | ○ | ○ | | カラムの横幅 |
| additional | 真偽値 | ○ | ○ | false | trueの場合、narrow表示モードで別形式表示（インラインパネルに展開） |
| colspan | 数値 | ○ | ○ | | 横方向結合カラム数（[table_row](testing-framework-table_row.md) 参照） |
| rowspan | 数値 | ○ | ○ | | 縦方向結合カラム数（[table_row](testing-framework-table_row.md) 参照） |
| dataFrom | 文字列 | × | × | | 設計書用：表示情報取得元.表示項目名の形式 |
| comment | 文字列 | × | × | | 設計書用：画面項目定義の備考欄に表示 |
| initialValueDesc | 文字列 | × | × | | 設計書用：初期表示内容の説明。画面項目定義の備考欄に表示 |

> **重要**: `additional`属性はautospan/rowspan属性を使用しているテーブルでは使用できない。

<details>
<summary>keywords</summary>

key, title, codeId, pattern, optionColumnName, labelPattern, sample, sortable, additional, cssClass, samplePattern, listFormat, width, colspan, rowspan, dataFrom, comment, initialValueDesc, コード値ラベル表示, 属性一覧, ローカル動作仕様

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/code.tag | [column_code](testing-framework-column_code.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /js/jsp/taglib/nablarch.js | `<n:code>` のエミュレーション機能を実装するタグライブラリスタブJS |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色など） |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（リンクに関する定義を含む） |

<details>
<summary>keywords</summary>

code.tag, nablarch.js, 内部構造, 部品一覧, タグファイル

</details>
