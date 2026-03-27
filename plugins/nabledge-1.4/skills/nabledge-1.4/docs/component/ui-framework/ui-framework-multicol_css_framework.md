# マルチレイアウト用CSSフレームワーク

## 概要

マルチレイアウト用CSSフレームワークは、[css_framework](ui-framework-css_framework.md) のワイドモードをベースとしたスタイルシート群。

- UI部品ウィジェットを複数個並べて配置できる（画面ごとに自由にレイアウト）
- UI部品ウィジェットの出力幅を指定できる

## マルチレイアウトモード使用上の重要ポイント

- UI部品ウィジェットは必ず行内(`layout:row`)に配置する（ただし行を表すUI部品ウィジェット自体は除く）
- 各UI部品ウィジェット使用時には幅（グリッド数）を指定する
- 行内に配置するUI部品ウィジェットの幅の合計は業務コンテンツ部の幅（`@contentGridSpan`で定義）以内とする
- 幅の合計が業務コンテンツ部の幅を超えた場合、自動的に折り返されて次の行に出力される。折り返し位置はブラウザ依存のため、業務コンテンツ部の幅に収まるよう配置すること

<details>
<summary>keywords</summary>

マルチレイアウト用CSSフレームワーク, ワイドモード, UI部品ウィジェット配置, 出力幅指定, css_framework, マルチレイアウトモード, layout:row, layout:cell, gridSize, @contentGridSpan, UI部品ウィジェット, 業務コンテンツ部, グリッド数, 幅指定, 折り返し

</details>

## 制約事項

## 表示モードの切替機能は提供しない

画面サイズに応じた表示モードの切替機能は提供しない。画面サイズを変更した場合でも、表示モードは常にワイドモードベース。

- ワイドモードベースで複数のUI部品を並べた画面を、別モードで同じレイアウトで表示することは不可能
- モードを切り替えると画面幅が狭くなり、複数のUI部品を並べた画面でレイアウト崩れが発生する
- 各モードでレイアウト崩れを防ぐには各モードごとのレイアウト定義とテストが必要（設計コストが非常に高くなる）

画面幅が狭くなった場合でもワイドモードベースの表示のまま。非表示部分は横スクロールバーで表示。

## 出力幅の指定機能を提供しないウィジェット

タイトル行を出力するウィジェットは幅の指定機能を提供しない。タイトル行は常に業務コンテンツ領域と同じ幅で出力される。

- [../reference_jsp_widgets/field_block](ui-framework-field_block.md) (`/WEB-INF/tags/widget/field/block.tag`)
- テーブル関連ウィジェット (`/WEB-INF/tags/widget/table/*.tag`):
  - [../reference_jsp_widgets/table_plain](ui-framework-table_plain.md)
  - [../reference_jsp_widgets/table_search_result](ui-framework-table_search_result.md)
  - [../reference_jsp_widgets/table_treelist](ui-framework-table_treelist.md)
- [../reference_jsp_widgets/tab_group](ui-framework-tab_group.md) (`/WEB-INF/tags/widget/tab/*.tag`)

## 1行に複数のUI部品を並べる場合

**実装ポイント**:
- UI部品を並べる場合は行(`layout:row`)を定義する
- タイトル部・入力部の幅を統一する場合は変数(`<n:set>`)に切り出す（変数を変更するだけでサイズ変更が可能になる）
- UI部品間にマージンを設ける場合は空の列(`layout:cell` + `gridSize`指定)を配置する

```jsp
<n:form windowScopePrefixes="user">
  <n:set var="titleSize" value="10" />
  <n:set var="inputSize" value="10" />
  <layout:row>
    <field:text title="郵便番号" required="true" name="user.postNo"
        titleSize="${titleSize}" inputSize="${inputSize}">
    </field:text>
    <layout:cell gridSize="10"></layout:cell>
    <n:forInputPage>
      <button:submit label="住所検索" uri="dummy" size="10"></button:submit>
    </n:forInputPage>
  </layout:row>
  <layout:row>
    <field:pulldown title="都道府県" name="user.address1" required="true"
        listName="都道府県リスト" elementLabelProperty="name" elementValueProperty="cd"
        titleSize="${titleSize}" inputSize="${inputSize}">
    </field:pulldown>
    <field:text title="市区郡町村名" name="user.address2" required="true"
        titleSize="${titleSize}" inputSize="${inputSize}">
    </field:text>
  </layout:row>
  <layout:row>
    <n:forInputPage>
      <layout:cell gridSize="17"></layout:cell>
      <button:check size="10" uri="./確認画面_ページ.jsp"></button:check>
    </n:forInputPage>
    <n:forConfirmationPage>
      <layout:cell gridSize="10"></layout:cell>
      <button:back uri="./登録画面.jsp" size="10"></button:back>
      <layout:cell gridSize="5"></layout:cell>
      <button:confirm uri="dummy" size="10"></button:confirm>
    </n:forConfirmationPage>
  </layout:row>
</n:form>
```

<details>
<summary>keywords</summary>

表示モード切替, レイアウト崩れ, field_block, table_plain, table_search_result, table_treelist, tab_group, 出力幅制約, ワイドモードベース固定, layout:row, layout:cell, gridSize, 複数UI部品の横並び配置, マージン設定, n:set, titleSize, inputSize, field:text, field:pulldown, button:submit, button:check, button:back, button:confirm, n:forInputPage, n:forConfirmationPage, 変数切り出し

</details>

## マルチレイアウトモードの適用方法

マルチレイアウトモードをプロジェクトに適用する手順。

**1. ui_plugins/package.json の修正**

以下のプラグインを `dependencies` に追加する:

| 設定 | プラグイン名 | 説明 |
|---|---|---|
| A | `nablarch-css-conf-multicol` | multicol用変数定義（グリッド数・画面幅定義） |
| B | `nablarch-template-multicol-head` | multicol用HTML headプラグイン（表示モード切替無効化） |
| C | `nablarch-widget-multicol-row` / `nablarch-widget-multicol-cell` | 行・列定義プラグイン |

- A: `nablarch-css-conf-wide`/`compact`/`narrow` は選択しない（記述がある場合は削除）
- B: `nablarch-template-head`（通常のHTML headプラグイン）は選択しない（記述がある場合は削除）

```javascript
// dependencies の該当部分
"nablarch-css-conf-multicol": "1.0.0",
"nablarch-template-multicol-head": "1.0.0",
"nablarch-widget-multicol-row": "1.0.0",
"nablarch-widget-multicol-cell": "1.0.0"
```

**2. ui_plugins/pjconf.json の修正（詳細: [pjconf_json](ui-framework-plugin_build.md)）**

- `cssMode` に `"multicol"` を設定
- `nablarch-template-multicol-head` を明示的に定義（pjconf.jsonは後に書いた設定が優先されるため、`nablarch-template-.*` の後に定義して通常モードの `nablarch-template-head` を上書きする）

```javascript
"cssMode" : ["multicol"]
```

**3. multicol.less の修正（詳細: [ui_genless](ui-framework-plugin_build.md)、:ref:`lessImport_less`）**

`ui_plugins/css/ui_public`（または `ui_local`）の `multicol.less` を修正する（自動生成した雛形を修正）。

[サンプルのmulticol.lessのダウンロード](../../../knowledge/component/ui-framework/assets/ui-framework-multicol_css_framework/multicol.less)

**4. uiビルドコマンドの実行**

`ui_plugins/bin/ui_build.bat` を実行する。マルチカラム用CSS（`multicol.css`、`multicol-minify.css`）が各WEBプロジェクトに生成され、各種UI部品が展開される。

## 列によって異なる行数を定義する場合（rowspan相当）

**実装ポイント**:
- 列ごとに異なる行数を定義する場合は、外側の行(`layout:row`)内に列(`layout:cell`)を定義し、列内にネストした行(`layout:row`)を配置する
- ネストした行内に配置するUI部品の幅の合計は、列(`layout:cell`)の幅(`gridSize`)を超えてはならない

```jsp
<layout:row>
  <layout:cell gridSize="20">
    <layout:row>
      <field:text title="漢字氏名" name="user.kanjiName" required="true"
          titleSize="10" inputSize="10">
      </field:text>
    </layout:row>
    <layout:row>
      <field:text title="カナ氏名" name="user.kanaName" required="true"
          titleSize="10" inputSize="10">
      </field:text>
    </layout:row>
  </layout:cell>
  <field:radio title="性別" name="user.sex" required="true"
      listName="sexList" listFormat="br"
      elementLabelProperty="name" elementValueProperty="cd"
      titleSize="${titleSize}" inputSize="${inputSize}">
  </field:radio>
</layout:row>
```

<details>
<summary>keywords</summary>

package.json, pjconf.json, nablarch-css-conf-multicol, nablarch-template-multicol-head, nablarch-widget-multicol-row, nablarch-widget-multicol-cell, multicol.less, ui_build.bat, マルチレイアウトモード適用手順, cssMode, layout:row, layout:cell, gridSize, ネストした行, rowspan相当, field:text, field:radio, 列ごとに異なる行数, ネスト, 幅の合計制限

</details>

## レイアウトの調整方法

画面の表示領域幅等を変更する場合、以下のプラグインをプロジェクト側にコピーして修正する（[add_plugin](ui-framework-modifying_code_and_testing.md) 参照）。

**nablarch-css-conf-multicol の修正ポイント**

- 業務画面部全体の幅を変更: `@columns` の定義を変更
- 業務コンテンツ部の幅を変更: `@contentGridSpan` の定義を変更（`@fieldGridSpan` と `@tableGridSpan` も業務コンテンツ部の幅に合わせて変更）

```css
@columns      : 64;         // 1ページ内のグリッド数
@trackWidth   : 13px;       // 1グリッドのグリッド幅
@gutterWidth  : 2px;        // 1グリッドあたりのマージン幅
@totalWidth   : @columns * (@trackWidth + @gutterWidth);  // 1ページの横幅

@smallestFontSize : 11px;
@smallerFontSize  : 12px;
@baseFontSize     : 14px;
@largerFontSize   : 16px;
@largestFontSize  : 18px;

@labelGridSpan  : 10;       // ラベル部のグリッド数
@inputGridSpan  : 21;       // 入力欄のグリッド数
@buttonGridSpan : 8;        // 標準ボタンのグリッド数
@unitGridSpan   : 3;        // 単位表示部のグリッド数

@fieldGridSpan  : 45;       // 業務画面部に配置する要素のグリッド数
@tableGridSpan  : 45;       // 標準テーブルのグリッド数
@contentGridSpan: 45;       // 業務面部のグリッド数
@contentWidth   : @contentGridSpan * (@trackWidth + @gutterWidth);  // 業務領域の幅
```

**nablarch-template-app_aside の修正ポイント**

- サイドバーの幅を変更: `#aside` の `.grid-col()` 値を変更
- メニューなし画面のサイドバーマージン調整: `#aside.noMenu` の `.grid-col()` 値を変更

```css
#aside {
  .grid-col(16);
}

#aside.noMenu {
  .grid-col(8);
}
```

<details>
<summary>keywords</summary>

@columns, @contentGridSpan, @fieldGridSpan, @tableGridSpan, nablarch-template-app_aside, #aside, #aside.noMenu, grid-col, グリッド数設定, 画面幅変更, nablarch-css-conf-multicol

</details>
