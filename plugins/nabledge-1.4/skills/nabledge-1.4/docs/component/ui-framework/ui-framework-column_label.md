# ラベル表示用カラムウィジェット

## コードサンプル

## コードサンプル

`table:search_result`、`table_plain`、`table_treelist` と組み合わせて使用する。

**ローカル動作:**
```jsp
<table:search_result title="検索結果" sampleResults="15">
  <column:checkbox title="選択"></column:checkbox>
  <column:label title="ログインID" sample="user001|user002|user003"></column:label>
</table:search_result>
```

**サーバ動作:**
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

column:label, table:search_result, table_plain, table_treelist, column:checkbox, ラベル表示カラム, JSPタグ, コードサンプル, ローカル動作, サーバ動作, 組み合わせ

</details>

## 仕様

## 仕様

**ローカル動作:** `sample`属性に指定した"|"区切りの文字列を順に表示する（`sampleResults`の件数が多い場合はループする）。

**属性値一覧** (◎必須 ○任意 ×無効)

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| key | 行データから値を取得するキー | 文字列 | ◎ | × | |
| title | カラムヘッダーの表示文字列 | 文字列 | ◎ | × | |
| value | カラムの表示内容 | 文字列 | ○ | ○ | 未指定時はkey属性で取得した値を使用 |
| domain | データのドメイン型 | 文字列 | ○ | ○ | 設計書ビューの当該項目に表示される。また、`<td>`のCSSクラス属性に追加される |
| cssClass | CSSクラス | 文字列 | ○ | ○ | |
| sortable | ソートリンク表示有無 | 文字列 | ○ | ○ | デフォルト'false'。`table_search_result`でのみ利用可能 |
| valueFormat | 出力値のフォーマット指定 | 文字列 | ○ | × | |
| sample | テスト用ダミー表示値 | 文字列 | × | ○ | "|"区切りで複数指定 |
| width | カラムの横幅 | 文字列 | ○ | ○ | |
| additional | 付加情報として扱うかどうか | 真偽値 | ○ | ○ | trueの場合、narrow表示モードでインライン展開パネルに表示（デフォルトfalse） |
| colspan | 横方向結合カラム数 | 数値 | ○ | ○ | 使用方法は`table_row`参照 |
| rowspan | 縦方向結合カラム数 | 数値 | ○ | ○ | 使用方法は`table_row`参照 |
| autospan | 項目値による自動カラム連結 | 真偽値 | ○ | ○ | 隣接行の値が同じ場合に上下方向でセルを自動連結。連結セルの背景色は最上位セルの背景色に一致。**注意: データのソートはサーバ側の処理で事前に行っておく必要がある。** |
| tree_indent | 階層深さに応じたインデント表示 | 文字列 | ○ | ○ | デフォルト'false'。`table_treelist`でのみ有効 |
| tree_toggler | 各階層の開閉ボタン表示 | 文字列 | ○ | ○ | デフォルト'false'。`table_treelist`でのみ有効 |
| dataFrom | 表示データの取得元 | 文字列 | × | × | 設計書表示用（「表示情報取得元.表示項目名」形式） |
| comment | 表示項目の備考 | 文字列 | × | × | 設計書の画面項目定義で「備考」に表示 |
| formatSpec | 編集仕様の説明 | 文字列 | × | × | 設計書の画面項目定義で「編集仕様」に表示 |
| initialValueDesc | 初期表示内容の説明 | 文字列 | × | × | 設計書の画面項目定義で「備考」に表示 |

> **警告**: `autospan`/`rowspan`属性を使用しているテーブルでは`additional`属性を使用することはできない。

<details>
<summary>keywords</summary>

key, title, value, domain, cssClass, sortable, valueFormat, sample, width, additional, colspan, rowspan, autospan, tree_indent, tree_toggler, dataFrom, comment, formatSpec, initialValueDesc, ラベルカラム属性, narrow表示モード, ソートリンク, 自動カラム連結, 階層インデント, 設計書ビュー, ドメイン型

</details>

## 内部構造・改修時の留意点

## 内部構造・改修時の留意点

**部品一覧:**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/column/label.tag | [column_link](ui-framework-column_link.md) |
| /WEB-INF/tags/listSearchResult/*.tag | Nablarch検索結果テーブルタグファイル |
| /css/style/nablarch.less | Nablarch関連スタイル定義（テーブルの配色など） |
| /css/style/base.less | 基本HTML要素のスタイル定義（リンクに関する定義を含む） |

<details>
<summary>keywords</summary>

label.tag, nablarch.less, base.less, 内部構造, 部品一覧, スタイル定義, listSearchResult

</details>
