# コード値ラベル表示用カラムウィジェット

[コード値ラベル表示用カラムウィジェット](../../component/ui-framework/ui-framework-column-code.md) は、 **UI標準 UI部品 テーブル** で、Nablarchのコード管理機能で取得したラベル、値を
カラムに出力するウィジェットである。

## コードサンプル

**設計成果物(ローカル動作)**

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

  <column:code
    title  = "性別"
    key    = "gender"
    codeId = "code1">
  </column:code>

</table:search_result>
```

## 仕様

**ローカル動作時の挙動**
カラムの内容には **sample** 属性に指定した **"|"** 区切りの文字列を順に表示する。
(テーブルのsampleResultsに指定された件数の方が多い場合はループする。)

ただし、**codeId** 属性にコードIDを指定した場合、下記のファイル内のエントリーから、
該当するコードの名称を取得し、表示する。 **pattern** 属性によるパターン指定や
**optionColumnName** 属性によるオプション名称指定も利用できる。
(**codeId** と **sample** を両方指定した場合は **sample** の値を優先する。)

**パス**
/js/devtool/resource/コード値定義.js

**属性値一覧**  [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| key | リンク文字列とするコード値 を、行データから取得するキー | 文字列 | ◎ | × |  |
| title | カラムヘッダーに表示する文字列 | 文字列 | ◎ | ◎ |  |
| cssClass | 各カラムに指定するCSSクラス | 文字列 | ○ | ○ |  |
| sortable | カラムのソートリンクを表示 するかどうか | 文字列 | ○ | ○ | デフォルトは'false' [検索結果テーブルウィジェット](../../component/ui-framework/ui-framework-table-search-result.md) でのみ利用可能 |
| sample | テスト用のダミー表示値 | 文字列 | × | ○ | "\|" 区切りで複数指定する。 |
| samplePattern | 一行あたりに出力するコード値 の件数のパターン | 文字列 | × | ○ | ","区切りで指定する。 |
| codeId | コード定義ID | 文字列 | ◎ | ○ |  |
| pattern | 使用するコードパターンの カラム名 | 文字列 | ○ | ○ | デフォルトは 'PATTERN01' |
| optionColumnName | 取得するオプション名称の カラム名 | 文字列 | ○ | ○ | デフォルトは 'OPTION01' |
| labelPattern | ラベル表示書式 | 文字列 | ○ | ○ | ラベルを整形するパターン。 プレースホルダを下記に示す。 $NAME$: コード値に対応するコード名称 $SHORTNAME$: コード値に対応するコードの略称 $OPTIONALNAME$: コード値に対応するコードのオプション名称 $OPTIONALNAME$を使用する場合は optionColumnName属性の指定が必須となる。 $VALUE$: コード値 デフォルトは”$NAME$”。 |
| listFormat | リスト表示時に使用する フォーマット | 文字列 | ○ | ○ | デフォルトは 'sp' |
| width | カラムの横幅の指定 | 文字列 | ○ | ○ |  |
| additional | 付加情報として扱うかどうか | 真偽値 | ○ | ○ | trueを指定した場合、narrow表示モードで 別形式での表示となる。下図では メールアドレス・登録日にadditional属性 を設定しており、narrow表示モードでは インラインに展開するパネルに表示される。 (デフォルトはfalse)  ![additional_column.png](../../../knowledge/assets/ui-framework-column-code/additional_column.png)  > **Warning:** > autospan/rowspan 属性を使用している > テーブルではadditional 属性を使用することは > できない。 |
| colspan | 横方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は、 [マルチレイアウトテーブル](../../component/ui-framework/ui-framework-table-row.md) を参照 |
| rowspan | 縦方向に結合するカラム数 | 数値 | ○ | ○ | 使用方法は、 [マルチレイアウトテーブル](../../component/ui-framework/ui-framework-table-row.md) を参照 |
| dataFrom | 表示するデータの取得元 | 文字列 | × | × | 画面項目定義に記載する、 「表示情報取得元」.「表示項目名」 の形式で設定する。 |
| comment | コード値表示についての備考 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |
| initialValueDesc | 初期表示内容に関する説明 | 文字列 | × | × | 設計書の表示時に、 画面項目定義の項目定義一覧で、 「備考」に表示される。 |

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/code.tag | [コード値ラベル表示用カラムウィジェット](../../component/ui-framework/ui-framework-column-code.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /js/jsp/taglib/nablarch.js | <n:code> のエミュレーション機能を実装する タグライブラリスタブJS |
| /css/style/nablarch.less | Nablarch関連スタイル定義 テーブルの配色などを定義している。 |
| /css/style/base.less | 基本HTMLの要素のスタイル定義。 リンクに関する定義もここに含まれる。 |
