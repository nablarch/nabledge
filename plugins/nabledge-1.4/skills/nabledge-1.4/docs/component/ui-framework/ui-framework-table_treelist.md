# 階層(ツリー)表示テーブルウィジェット

## 概要

階層(ツリー)表示テーブルウィジェット（`[table_treelist](ui-framework-table_treelist.md)`）はデータベースなどの検索結果を、UI標準UI部品「階層(ツリー)表示」に準拠した階層テーブルとして画面に出力するUI部品。特定カラムの値によって自動的にソート・階層化して表示する。

> **重要**: ページング機能には対応していない。

カラムウィジェット（カラムの種別ごとに個別ウィジェットを配置してカラム内容を定義する）:
- [column_label](ui-framework-column_label.md)
- [column_code](ui-framework-column_code.md)
- [column_link](ui-framework-column_link.md)
- [column_checkbox](ui-framework-column_checkbox.md)
- [column_radio](ui-framework-column_radio.md)

- [column_label](ui-framework-column_label.md) に `tree_indent="true"` を指定すると、カラム内の表示項目が階層の深さに応じてインデントされて表示される。
- 階層表示を利用するには、少なくとも1つのカラムが `tree_toggler="true"` を指定した [column_link](ui-framework-column_link.md) である必要がある。

<details>
<summary>keywords</summary>

階層ツリー表示テーブル, tree_toggler, tree_indent, column_link, column_label, column_code, column_checkbox, column_radio, ページング非対応, ソート・階層化表示

</details>

## コードサンプル

**ローカル動作時**

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

**サーバ動作時**

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

table:treelist, treelist JSP, ローカル動作, サーバ動作, sampleResults, resultSetName, hierarchy

</details>

## 仕様

**階層構造の定義**

検索結果は `key` 属性値に指定したカラムの値に従って自動的にソート・階層化して表示する。階層構造は `hirarchy` 属性値に指定した定義式で定まり、以下2つの書式のいずれかで定義する。

1. `chars:(数値)|(数値)|...|(数値)` — 各要素のid属性値を先頭からの文字数で分割して階層を決定
2. `separator:(区切り文字列)` — 各要素のid属性値を区切り文字列で分割して階層を決定

**ローカル動作時の挙動**

`sampleResults` に指定した件数分だけデータ行を表示する。カラムの内容は各カラムウィジェットの `sample` 属性に指定した `"|"` 区切りの文字列を順に表示する（レコード件数の方が多い場合はループする）。

**属性値一覧** [◎ 必須属性 / ○ 任意属性 / × 無効]

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
| sortCondition | テーブルの初期ソート条件 | 文字列 | × | × | 設計書表示時に画面概要一覧の「ソート条件」に表示 |
| comment | テーブルについての備考 | 文字列 | × | × | 設計書表示時に「備考」に表示 |
| estimatedMaxSearchResults | 検索結果として想定される最大件数 | 文字列 | × | × | 設計書表示時に「想定検索最大件数」に表示 |

<details>
<summary>keywords</summary>

階層構造定義, chars書式, separator書式, hirarchy, key属性, name属性, title属性, id属性, resultSetName, resultSetCss, sampleResults, sortCondition, comment, estimatedMaxSearchResults, 属性値一覧

</details>

## 内部構造・改修時の留意点

テーブル機能は内部的に Nablarch が提供している `<listSearchResult:table>` タグで実装されており、Nablarch側の設定変更によってページングリストの出力パターンなどを変更できる。

**部品一覧**

| パス | 内容 |
|---|---|
| `/WEB-INF/tags/widget/table/treelist.tag` | ツリーリストウィジェット |
| `/WEB-INF/tags/widget/column/*.tag` | テーブルカラムウィジェット群 |
| `/WEB-INF/tags/listSearchResult/*.tag` | Nablarch検索結果テーブルタグファイル |
| `/css/style/nablarch.less` | Nablarch関連スタイル定義（テーブルの配色などを定義） |
| `/css/style/content.less` | 業務画面領域スタイル定義（テーブルサイズを定義） |
| `/js/nablarch/ui/TreeList.js` | ツリーリストUI部品 |
| `/css/ui/treelist.less` | ツリーリストのスタイル定義（各階層ごとの配色などを定義） |

<details>
<summary>keywords</summary>

listSearchResult:table, treelist.tag, TreeList.js, treelist.less, nablarch.less, content.less, 部品一覧

</details>
