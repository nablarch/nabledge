# ラベル表示用カラムウィジェット

**公式ドキュメント**: [ラベル表示用カラムウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/column_label.html)

## コードサンプル

[column_label](testing-framework-column_label.md) は、カラムの値をラベル出力する行をテーブル中に追加するウィジェット。[table_search_result](testing-framework-table_search_result.md)、[table_plain](testing-framework-table_plain.md)、[table_treelist](testing-framework-table_treelist.md) と組み合わせて使用する。

**設計成果物（ローカル動作）**:

```jsp
<table:search_result title="検索結果" sampleResults="15">
  <column:checkbox title="選択"></column:checkbox>
  <column:label title="ログインID" sample="user001|user002|user003"></column:label>
</table:search_result>
```

**実装成果物（サーバ動作）**:

```jsp
<table:search_result
  title="検索結果"
  searchUri="/action/ss11AC/W11AC01Action/RW11AC0102"
  listSearchInfoName="11AC_W11AC01"
  resultSetName="searchResult"
  sampleResults="15">
  <column:checkbox title="選択" key="userId" name="W11AC05.systemAccountEntityArray[${count-1}].userId" offValue="0000000000"></column:checkbox>
  <column:label title="ログインID" key="loginId" sample="user001|user002|user003"></column:label>
</table:search_result>
```

<details>
<summary>keywords</summary>

column:label, table_search_result, table_plain, table_treelist, JSPウィジェット, ラベル表示, カラムウィジェット, sample属性

</details>

## 仕様

**ローカル動作時の挙動**: `sample` 属性に指定した `|` 区切りの文字列を順に表示する。テーブルの `sampleResults` に指定された件数の方が多い場合はループする。

**属性値一覧** (◎ 必須属性 / ○ 任意属性 / × 無効)

| プロパティ名 | タイプ | サーバ | ローカル | 説明 |
|---|---|---|---|---|
| key | 文字列 | ◎ | × | 行データから表示する文字列を取得するキー |
| title | 文字列 | ◎ | × | カラムヘッダに表示する文字列 |
| value | 文字列 | ○ | ○ | カラムの表示内容。指定なし時はkeyで取得した値を使用 |
| domain | 文字列 | ○ | ○ | データのドメイン型。設計書ビューの当該項目に表示され、`<td>` 要素のCSSクラス属性に追加される |
| cssClass | 文字列 | ○ | ○ | 各カラムに指定するCSSクラス |
| sortable | 文字列 | ○ | ○ | ソートリンクを表示するかどうか。デフォルト'false'。[table_search_result](testing-framework-table_search_result.md) でのみ使用可能 |
| valueFormat | 文字列 | ○ | × | 出力する値のフォーマット指定 |
| sample | 文字列 | × | ○ | テスト用ダミー表示値。"|" 区切りで複数指定 |
| width | 文字列 | ○ | ○ | カラムの横幅 |
| additional | 真偽値 | ○ | ○ | 付加情報として扱うかどうか。trueの場合narrow表示モードでインラインに展開するパネルに表示される。デフォルトfalse |
| colspan | 数値 | ○ | ○ | 横方向に結合するカラム数。使用方法は[table_row](testing-framework-table_row.md)参照 |
| rowspan | 数値 | ○ | ○ | 縦方向に結合するカラム数。使用方法は[table_row](testing-framework-table_row.md)参照 |
| autospan | 真偽値 | ○ | ○ | 隣接する行の値が同じ場合に上下方向にセルを自動連結。データのソートはサーバ側で事前に行う必要あり |
| tree_indent | 文字列 | ○ | ○ | 階層の深さに応じたインデントで表示するかどうか。デフォルト'false'。[table_treelist](testing-framework-table_treelist.md) でのみ有効 |
| tree_toggler | 文字列 | ○ | ○ | 各階層を開閉するボタンをこのカラム内に表示するかどうか。デフォルト'false'。[table_treelist](testing-framework-table_treelist.md) でのみ有効 |
| dataFrom | 文字列 | × | × | 表示するデータの取得元（「表示情報取得元.表示項目名」の形式） |
| comment | 文字列 | × | × | 設計書の画面項目定義「備考」に表示される表示項目についての備考 |
| formatSpec | 文字列 | × | × | 設計書の画面項目定義「編集仕様」に表示される編集仕様の説明 |
| initialValueDesc | 文字列 | × | × | 設計書の画面項目定義「備考」に表示される初期表示内容の説明 |

> **重要**: `autospan`/`rowspan` 属性を使用しているテーブルでは `additional` 属性を使用することはできない。

> **補足**: `autospan` で連結された各セルの背景色は、その中で一番上のセルの背景色に一致する。

<details>
<summary>keywords</summary>

key, title, value, domain, cssClass, sortable, valueFormat, sample, width, additional, colspan, rowspan, autospan, tree_indent, tree_toggler, dataFrom, comment, formatSpec, initialValueDesc, 属性一覧, ローカル動作, narrow表示モード

</details>

## 内部構造・改修時の留意点

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/label.tag | [column_link](testing-framework-column_link.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色などを定義） |
| /css/style/base.less | 基本HTMLの要素のスタイル定義（リンクに関する定義を含む） |

<details>
<summary>keywords</summary>

label.tag, nablarch.less, base.less, 部品一覧, 内部構造

</details>
