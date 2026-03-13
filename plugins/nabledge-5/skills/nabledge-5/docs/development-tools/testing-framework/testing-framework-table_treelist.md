# 階層(ツリー)表示テーブルウィジェット

**公式ドキュメント**: [階層(ツリー)表示テーブルウィジェット](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/table_treelist.html)

## コードサンプル

## ローカル動作

```jsp
<table:treelist
  title="リクエストID一覧"
  name="treeStatus"
  key="id"
  hierarchy="chars:6|2|2"
  sampleResults="5">

  <column:label
    title="リクエストID"
    key="id"
    tree_indent="true"
    tree_toggler="true"
    sample="RW11AA|RW11AA0101|RW11AA0102|RW11AB|RW11AB0101">
  </column:label>

  <column:label
    title="リクエスト名"
    key="name"
    tree_indent="true"
    sample="ログイン機能|ログイン画面初期表示処理|ログイン処理|メニュー|メニュー表示処理">
  </column:label>

  <column:checkbox
    title="閉局中"
    name="availableRequestIds"
    key="id">
  </column:checkbox>

</table:treelist>
```

## サーバ動作

```jsp
<table:treelist
  title="リクエストID一覧"
  name="formdata.treeStatus"
  key="id"
  hierarchy="chars:6|2|2"
  resultSetName="searchResult"
  sampleResults="5">

  <column:label
    title="リクエストID"
    key="id"
    tree_indent="true"
    tree_toggler="true"
    sample="RW11AA|RW11AA0101|RW11AA0102|RW11AB|RW11AB0101">
  </column:label>

  <column:label
    title="リクエスト名"
    key="name"
    tree_indent="true"
    sample="ログイン機能|ログイン画面初期表示処理|ログイン処理|メニュー|メニュー表示処理">
  </column:label>

  <column:checkbox
    title="閉局中"
    name="formdata.availableRequestIds"
    key="id">
  </column:checkbox>

</table:treelist>
```

<details>
<summary>keywords</summary>

table:treelist, コードサンプル, ローカル動作, サーバ動作, column:label, column:checkbox, resultSetName, sampleResults, tree_toggler, tree_indent, hierarchy

</details>

## 仕様

- ページング機能には対応していない。
- 階層表示を使用するには、少なくとも一つのカラムが `tree_toggler="true"` の [column_link](testing-framework-column_link.md) である必要がある。
- [column_label](testing-framework-column_label.md) で `tree_indent="true"` を指定すると、カラム内の表示項目が階層の深さに応じてインデントされる。

## 階層構造の定義

**key** 属性値のカラム値に従って自動的にソート・階層化。**hirarchy** 属性値の定義式で階層構造を指定する:

1. `chars:(数値)|(数値)|...|(数値)` — id属性値を先頭からの文字数で分割して階層を決定
2. `separator:(区切り文字列)` — id属性値を区切り文字列で分割して階層を決定

## ローカル動作時の挙動

**sampleResults** に指定した件数分だけデータ行を表示。カラム内容は各カラムウィジェットの **sample** 属性に指定した `"|"` 区切り文字列を順に表示（レコード件数の方が多い場合はループ）。

## 属性値一覧

◎=必須、○=任意、×=無効

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| title | 見出し文字列 | 文字列 | ◎ | ◎ | |
| id | テーブルを一意に識別するid | 文字列 | × | × | ページ内に複数のテーブルが存在する場合は必須 |
| name | ツリーの開閉状態を保持するフォーム要素名 | 文字列 | ◎ | ◎ | |
| key | 階層構造を決定するレコードの属性名 | 文字列 | ◎ | ◎ | |
| hirarchy | 階層構造を決定する定義式 | 文字列 | ◎ | ◎ | |
| resultSetName | 検索結果を格納する変数名 | 文字列 | ◎ | × | |
| resultSetCss | 検索結果表示領域に適用するCSSクラス | 文字列 | ○ | ○ | |
| sampleResults | サンプルで表示する件数 | 数値 | × | ◎ | |
| sortCondition | テーブルの初期ソート条件 | 文字列 | × | × | 設計書の表示時に「ソート条件」に表示される |
| comment | テーブルについての備考 | 文字列 | × | × | 設計書の表示時に「備考」に表示される |
| estimatedMaxSearchResults | 検索結果として想定される最大件数 | 文字列 | × | × | 設計書の表示時に「想定検索最大件数」に表示される |

<details>
<summary>keywords</summary>

ページング非対応, tree_toggler, tree_indent, 階層構造定義, hirarchy, chars, separator, 属性値一覧, resultSetName, sampleResults, key属性, 階層テーブル, title, id, name, resultSetCss, sortCondition, comment, estimatedMaxSearchResults

</details>

## 内部構造・改修時の留意点

テーブル機能は内部的に `<listSearchResult:table>` タグで実装。Nablarch側の設定変更によってページングリストの出力パターンなどを変更できる。

## 部品一覧

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/table/treelist.tag | ツリーリストウィジェット |
| /WEB-INF/tags/widget/column/*.tag | テーブルカラムウィジェット群 |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色など） |
| /css/style/content.less | 業務画面領域スタイル定義（テーブルサイズ） |
| /js/nablarch/ui/TreeList.js | ツリーリストUI部品 |
| /css/ui/treelist.less | ツリーリストのスタイル定義（各階層ごとの配色など） |

<details>
<summary>keywords</summary>

listSearchResult:table, TreeList.js, treelist.tag, 内部構造, 部品一覧, nablarch.less, treelist.less, content.less

</details>
