# マルチレイアウトテーブル

**公式ドキュメント**: [マルチレイアウトテーブル](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/table_row.html)

## コードサンプル

マルチレイアウトテーブル（`<table:row>`）は、行ごとに異なるカラム構成をもつテーブルである。例えば、明細テーブルにおいて、特定のコード値のブレイク毎に小計を出力する場合や1つのレコードに対して複数行を出力するような場合に使用する。

> **補足**: `<table:row>` は `<table:plain>` および `<table:search_result>` で使用可能。`<table:treelist>` には対応していない。

> **補足**: 奇数行/偶数行のCSSスタイル切替え(nablarch_even/nablarch_odd)はレコード単位。1レコードを2行で出力する場合、スタイル切替えも2行ごとになる。

## 使用方法

1. `<table:plain>` または `<table:search_result>` の `multipleRowLayout` 属性を `true` に設定する
2. これらのタグの直接の子要素として `<table:row>` を配置する
3. 各 `<table:row>` 内で `<column:xxx>` タグを使用して行レイアウトを定義する
4. `<table:row>` の `cond` 属性で行レイアウトの出力条件を指定可能（省略時は全レコードに出力）

**実装例1(1レコード複数行表示) - 設計成果物(ローカル動作)**:

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

**実装例1(1レコード複数行表示) - 実装成果物(サーバ動作)**:

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

**実装例2(cond属性による行レイアウト制御) - 設計成果物(ローカル動作)**:

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

**実装例2(cond属性による行レイアウト制御) - 実装成果物(サーバ動作)**:

```jsp
<table:plain
  title="cond属性による行レイアウト制御の例"
  resultSetName="result"
  sampleResults="4"
  multipleRowLayout="true">
  <!-- 上段行レイアウト(レコード毎に出力) -->
  <table:row>
    <column:label key="id" title="ユーザID" sample="001|002" rowspan="2"></column:label>
    <column:label key="name" title="名前" sample="なまえ|なまえ２"></column:label>
    <column:label key="number" title="ポイント" sample="98090|3400" rowspan="2"></column:label>
  </table:row>
  <!-- 下段行レイアウト(レコード毎に出力) -->
  <table:row>
    <column:label key="mail" title="メールアドレス" sample="001@example.com|002@example.com"></column:label>
  </table:row>
</table:plain>
```

> **補足**: 行ごとの背景色切替えは表示データレコード単位。同一レコードを複数行で出力した場合、背景色は同じになる。背景色制御は個別CSSで行い、`cssClass` 属性に任意クラスを割り当ててスタイル定義する。

**背景色制御の例 - table:rowの使用箇所**:

```jsp
<table:row cssClass="total">
  <%-- 集計行を出力する処理 --%>
</table:row>
```

**背景色制御の例 - スタイル定義**:

```css
tr.total {
  background-color: #FFEEDC;
}
```

<details>
<summary>keywords</summary>

マルチレイアウトテーブル, table:row, table:plain, table:search_result, multipleRowLayout, cond, cssClass, 複数行レイアウト, 行レイアウト制御, 奇数偶数行スタイル切替え, nablarch_even, nablarch_odd, table:treelist, 1レコード複数行表示, 小計, コード値ブレイク, 設計成果物, 実装成果物, ローカル動作, サーバ動作

</details>

## 仕様（属性値一覧）

**属性値一覧** [**◎** 必須属性 **○** 任意属性 **×** 無効(指定しても効果なし)]

| 属性名 | 内容 | タイプ | サーバ | ローカル | 備考 |
|---|---|---|---|---|---|
| cond | 各レコードに対してこのレイアウトによる行を出力するかどうか | 真偽値 | ○ | ○ | デフォルトは `true`（全レコードに出力） |
| cssClass | 行(tr要素)に適用するCSSクラス | 文字列 | ○ | ○ | |

<details>
<summary>keywords</summary>

属性値一覧, cond, cssClass, table:row 属性, 必須属性, 任意属性

</details>

## 内部構造・改修時の留意点

> **重要**: 本機能の実装は `<table:row>` ではなく `<table:plain>` および `<table:search_result>` 側にある。改修時はこの2つのタグ双方に反映する必要がある。

## 部品一覧

| パス | 内容 |
|---|---|
| /WEB-INF/tags/widget/table/plain.tag | 一覧テーブルウィジェット |
| /WEB-INF/tags/widget/table/search_result.tag | 検索結果テーブルウィジェット |
| /WEB-INF/tags/widget/table/row.tag | マルチレイアウトテーブル定義用ウィジェット |

<details>
<summary>keywords</summary>

内部構造, 改修, plain.tag, search_result.tag, row.tag, 部品一覧, WEB-INF

</details>
