# マルチレイアウトテーブル

## コードサンプル

`:doc:table_row` は、行ごとに異なるカラム構成をもつテーブルである。例えば、明細テーブルにおいて、特定のコード値のブレイク毎に小計を出力する場合や、1つのレコードに対して複数行を出力するような場合に使用する。

> **注意**: [table_row](ui-framework-table_row.md) は [table_plain](ui-framework-table_plain.md) および [table_search_result](ui-framework-table_search_result.md) で使用可能。[table_treelist](ui-framework-table_treelist.md) には対応していない。

> **注意**: 奇数行・偶数行のCSSスタイル切替え(nablarch_even/nablarch_odd)はレコード単位で行われる。1レコードを2行で出力する場合、スタイル切替えも2行ごとになる。

[table_plain](ui-framework-table_plain.md) または [table_search_result](ui-framework-table_search_result.md) の `multipleRowLayout` 属性を `true` に設定し、これらタグの直接の子要素として `<table:row>` を配置する。各 `<table:row>` 内では `<column:xxx>` タグで行レイアウトを定義する。`cond` 属性で行を出力する条件を指定できる（省略時は全レコードに出力）。

**実装例1) 1レコードを複数行で表示**

設計成果物（ローカル動作）— `key` 属性および `resultSetName` 属性なし:

```jsp
<table:plain
  title="1レコード複数行表示の記述例"
  sampleResults="4"
  multipleRowLayout="true">
  <!-- 上段の行レイアウト -->
  <table:row>
    <column:label title="ユーザID" rowspan="2" sample="001|002"></column:label>
    <column:label title="名前" sample="なまえ|なまえ２"></column:label>
    <column:label title="ポイント" sample="98090|3400"></column:label>
  </table:row>
  <!-- 下段の行レイアウト -->
  <table:row>
    <column:label title="メールアドレス" sample="001@example.com|002@example.com"></column:label>
    <column:label title="登録日" sample="2013/12/12|2014/01/05"></column:label>
  </table:row>
</table:plain>
```

実装成果物（サーバ動作）— `key` 属性および `resultSetName` 属性あり:

```jsp
<table:plain
  title="1レコード複数行表示の記述例"
  resultSetName="result"
  sampleResults="4"
  multipleRowLayout="true">
  <!-- 上段の行レイアウト -->
  <table:row>
    <column:label key="id" title="ユーザID" rowspan="2" sample="001|002"></column:label>
    <column:label key="name" title="名前" sample="なまえ|なまえ２"></column:label>
    <column:label key="number" title="ポイント" sample="98090|3400"></column:label>
  </table:row>
  <!-- 下段の行レイアウト -->
  <table:row>
    <column:label key="mail" title="メールアドレス" sample="001@example.com|002@example.com"></column:label>
    <column:label key="date" title="登録日" sample="2013/12/12|2014/01/05"></column:label>
  </table:row>
</table:plain>
```

**実装例2) cond属性で特定位置に追加行を表示**

設計成果物（ローカル動作）— `key` 属性および `resultSetName` 属性なし:

```jsp
<table:plain
  title="cond属性による行レイアウト制御の例"
  sampleResults="4"
  multipleRowLayout="true">
  <!-- 上段行レイアウト(レコード毎に出力) -->
  <table:row>
    <column:label title="ユーザID" sample="001|002" rowspan="2"></column:label>
    <column:label title="名前" sample="なまえ|なまえ２"></column:label>
    <column:label title="ポイント" sample="98090|3400" rowspan="2"></column:label>
  </table:row>
  <!-- 下段行レイアウト(レコード毎に出力) -->
  <table:row>
    <column:label title="メールアドレス" sample="001@example.com|002@example.com"></column:label>
  </table:row>
</table:plain>
```

実装成果物（サーバ動作）— `key` 属性および `resultSetName` 属性あり:

```jsp
<table:plain
  title="cond属性による行レイアウト制御の例"
  resultSetName="result"
  sampleResults="4"
  multipleRowLayout="true">
  <!-- 上段行レイアウト（レコード毎に出力） -->
  <table:row>
    <column:label key="id" title="ユーザID" sample="001|002" rowspan="2"></column:label>
    <column:label key="name" title="名前" sample="なまえ|なまえ２"></column:label>
    <column:label key="number" title="ポイント" sample="98090|3400" rowspan="2"></column:label>
  </table:row>
  <!-- 下段行レイアウト（レコード毎に出力） -->
  <table:row>
    <column:label key="mail" title="メールアドレス" sample="001@example.com|002@example.com"></column:label>
  </table:row>
</table:plain>
```

> **注意**: 同じレコードの複数行は背景色が同じになる。背景色の制御は `cssClass` 属性に任意クラスを割り当て、そのクラスのCSSスタイル定義で行う。

```jsp
<table:row cssClass="total">
  <%-- 集計行を出力する処理 --%>
</table:row>
```

```css
tr.total {
  background-color: #FFEEDC;
}
```

<details>
<summary>keywords</summary>

マルチレイアウトテーブル, table:row, multipleRowLayout, 複数行表示, cond属性, 行レイアウト制御, cssClass, nablarch_even, nablarch_odd, 行ごとに異なるカラム構成, コードブレイク, 小計, いつ使う, 使用場面, ローカル動作, サーバ動作, 設計成果物, 実装成果物

</details>

## 仕様

**属性値一覧** [◎ 必須属性 ○ 任意属性 × 無効]

| 名称 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| cond | 各レコードに対してこのレイアウトによる行を出力するかどうか | 真偽値 | ○ | ○ | デフォルトは `true`（全レコードに出力） |
| cssClass | 行(tr要素)に適用するCSSクラス | 文字列 | ○ | ○ | |

<details>
<summary>keywords</summary>

cond, cssClass, 属性値一覧, 行レイアウト条件, table:row属性

</details>

## 内部構造・改修時の留意点

> **重要**: 本機能の実装は `<table:row>` ではなく `<table:plain>` および `<table:search_result>` 側にある。改修時はこの2つのタグ双方に反映する必要がある。

**部品一覧**

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/table/plain.tag | 一覧テーブルウィジェット |
| /WEB-INF/tags/widget/table/search_result.tag | 検索結果テーブルウィジェット |
| /WEB-INF/tags/widget/table/row.tag | マルチレイアウトテーブル定義用ウィジェット |

<details>
<summary>keywords</summary>

plain.tag, search_result.tag, row.tag, 改修, 部品一覧, table:plain, table:search_result

</details>
