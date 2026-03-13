# UI標準修正事例一覧

**公式ドキュメント**: [UI標準修正事例一覧](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_ui_standard/index.html)

## UI標準1.1. 対応する端末とブラウザ

## 対応ブラウザの追加

プロジェクト側で対応ブラウザを追加する場合は、当該の端末でのテストを十分に実施する必要がある。

テストの結果、修正を要する問題が検出された場合、既存のソースコード（プラグイン）を直接修正すると既存の対応ブラウザの挙動に問題を生じさせる危険性がある。

ブラウザ固有の特性や不具合への対処は [nablarch-device-fix](testing-framework-ui-dev-doc-reference-ui-plugin.md) プラグインとしてまとめられており、`nablarch-device-fix-base` が出力する環境固有のCSSクラスやグローバル変数を参照することで既存コードに影響しない形で特定環境向けの対応が可能。新規対応ブラウザ向けには既存の [nablarch-device-fix](testing-framework-ui-dev-doc-reference-ui-plugin.md) を参考にして新規プラグインを追加すること。

## IE6/7サポートの制約

IE6/7をサポートする場合、**対応コストの増大**に加えて、以下の制約が発生する:

1. **アイコンが表示できない**: IE6はWeb Fontをサポートしていないため
2. **マウスオーバ時の背景色反転ができない**: IE6ではリンク要素以外での`:hover`擬似セレクタが非サポートのため

IE8の制約（ボタンの角丸表現・陰影表現ができない）はIE6/7にも当てはまる。

## 表示モード変更

[ui_standard_2_1](#s3) を参照。

## 共通エラー画面の構成を変更したい

共通エラー画面のテンプレートは **nablarch-template-error** プラグインで定義されている。構成を変更する場合は、このプラグイン内の各ファイルを修正すること。

<details>
<summary>keywords</summary>

nablarch-device-fix, nablarch-device-fix-base, 対応ブラウザ追加, IE6/7サポート制約, IE6/7対応コスト, Web Font非サポート, hover擬似セレクタ非サポート, 表示モード変更, 共通エラー画面, nablarch-template-error, エラー画面テンプレート, プラグイン修正

</details>

## UI標準1.2. 使用技術

## JavaScriptライブラリ・外部スタイルシートの追加

| 修正内容 | 修正対象プラグイン |
|---|---|
| 外部スタイルシートの追加 | **nablarch-template-head** |
| JavaScriptの追加（minifyなし） | **nablarch-template-js_include** |
| JavaScriptの追加（minifyあり） | **nablarch-dev-tool-ui-build** |

## UI標準3. UI部品 (UI部品カタログ)

UI部品（UI部品カタログ）に関するセクション。各UI部品は専用プラグインで実装されており、UI部品を修正する場合は対応するプラグインを修正すること。

<details>
<summary>keywords</summary>

nablarch-template-head, nablarch-template-js_include, nablarch-dev-tool-ui-build, JavaScriptライブラリ追加, 外部スタイルシート追加, UI部品カタログ, データ表示部品, 入力フォーム部品, コントロール部品, UI部品修正

</details>

## UI標準2. 画面構成

## 画面の配色変更

**nablarch-css-color-default** プラグイン内のスタイル定義で一括変更可能。

デフォルトの配色は以下のとおり:

```css
// Nablarchブランドカラーを基調とした配色設定
@baseColor  : rgb(255, 255, 255); // 白
@mainColor1 : rgb(235, 92,  21);  // オレンジ
@mainColor2 : rgb(76,  42,  26);  // こげ茶
@subColor   : rgb(170, 10,  10);  // 赤
```

| パラメータ | 役割 |
|---|---|
| @baseColor | 背景色 |
| @mainColor1 | 前景色1（メニュー・見出し・入力部品などの主要要素） |
| @mainColor2 | 前景色2（主に文字色） |
| @subColor | 差し色（アクセントが必要な場合） |

> **補足**: @mainColor2が基本文字色になるので、@mainColor2の@baseColorに対するコントラストが@mainColor1より強くなるように設定するとよい。

## システムロゴ画像の差し替え

**nablarch-template-app_header** プラグインの内容を差し替えること。

## ヘッダ領域の修正

- トップナビゲーション部: **nablarch-template-app_nav** プラグイン
- それ以外の部分: **nablarch-template-app_header** プラグイン

## サイドメニュー領域の修正

**nablarch-template-app_aside** プラグインの内容を修正する。ナロー・コンパクトモード時のスライド表示には **nablarch-widget-slide_menu** プラグインを使用。

> **重要**: **nablarch-widget-slide_menu** プラグインは **nablarch-template-app_aside** に依存しているため、使用する際には両方のプラグインが必要。

## フッター領域の修正

**nablarch-template-app_aside** プラグインの内容を修正すること。

## 共通エラーメッセージ表示の調整

| 調整内容 | 修正対象 |
|---|---|
| 表示スタイル | **nablarch-css-common** の `ui_public/css/common/nablarch.less` |
| 表示内容 | **nablarch-template-page** の `ui_public/WEB-INF/include/app_error.jsp` |
| 表示位置 | **nablarch-template-page** の `ui_public/WEB-INF/tags/template/page_template.tag`（インクルードファイルの読み込み位置を修正） |

## UI部品の表示・挙動を修正したい

UI部品を修正する場合は、対応するプラグインをそれぞれ修正すること。

**データ表示部品**

| UI部品 | UIウィジェット | 修正対象プラグイン |
|---|---|---|
| テーブル | [../reference_jsp_widgets/table_plain](testing-framework-table_plain.md) | **nablarch-widget-table-plain** |
| | [../reference_jsp_widgets/table_search_result](testing-framework-table_search_result.md) | **nablarch-widget-table-search_result** |
| | [../reference_jsp_widgets/table_row](testing-framework-table_row.md) | **nablarch-widget-table-row** |
| | [../reference_jsp_widgets/column_label](testing-framework-column_label.md) | **nablarch-widget-column-label** |
| | [../reference_jsp_widgets/column_link](testing-framework-column_link.md) | **nablarch-widget-column-link** |
| | [../reference_jsp_widgets/column_checkbox](testing-framework-column_checkbox.md) | **nablarch-widget-column-checkbox** |
| | [../reference_jsp_widgets/column_radio](testing-framework-column_radio.md) | **nablarch-widget-column-radio** |
| 画像 | [../reference_jsp_widgets/box_img](testing-framework-box_img.md) | **nablarch-widget-box-img** |
| 階層(ツリー)表示 | [../reference_jsp_widgets/table_treelist](testing-framework-table_treelist.md) | **nablarch-widget-table-tree** |

**入力フォーム部品**

| UI部品 | UIウィジェット | 修正対象プラグイン |
|---|---|---|
| チェックボックス | [../reference_jsp_widgets/field_checkbox](testing-framework-field_checkbox.md) | **nablarch-widget-field-checkbox** |
| | [../reference_jsp_widgets/field_code_checkbox](testing-framework-field_code_checkbox.md) | |
| ラジオボタン | [../reference_jsp_widgets/field_radio](testing-framework-field_radio.md) | **nablarch-widget-field-radio** |
| | [../reference_jsp_widgets/field_code_radio](testing-framework-field_code_radio.md) | |
| プルダウンリスト | [../reference_jsp_widgets/field_pulldown](testing-framework-field_pulldown.md) | **nablarch-widget-field-pulldown** |
| | [../reference_jsp_widgets/field_code_pulldown](testing-framework-field_code_pulldown.md) | |
| リストビルダー | [../reference_jsp_widgets/field_listbuilder](testing-framework-field_listbuilder.md) | **nablarch-widget-field-listbuilder** |
| 単行テキスト入力 | [../reference_jsp_widgets/field_text](testing-framework-field_text.md) | **nablarch-widget-field-text** |
| 複数行テキスト入力 | [../reference_jsp_widgets/field_textarea](testing-framework-field_textarea.md) | **nablarch-widget-field-textarea** |
| パスワード入力 | [../reference_jsp_widgets/field_password](testing-framework-field_password.md) | **nablarch-widget-field-password** |
| ファイル選択 | [../reference_jsp_widgets/field_file](testing-framework-field_file.md) | **nablarch-widget-field-file** |
| カレンダー日付入力 | [../reference_jsp_widgets/field_calendar](testing-framework-field_calendar.md) | **nablarch-widget-field-calendar** |
| 自動集計 | | **nablarch-widget-event-autosum** |
| フォーカス移動制御 | [base_layout_tag](testing-framework-jsp_page_templates.md) (**tabIndexOrder** 属性値の解説を参照) | **nablarch-template-base** |

**コントロール部品**

| UI部品 | UIウィジェット | 修正対象プラグイン |
|---|---|---|
| ボタン | [../reference_jsp_widgets/button_block](testing-framework-button_block.md) [../reference_jsp_widgets/button_submit](testing-framework-button_submit.md) | **nablarch-widget-button** |
| リンク | [../reference_jsp_widgets/link_submit](testing-framework-link_submit.md) | **nablarch-widget-link** |

<details>
<summary>keywords</summary>

nablarch-css-color-default, @baseColor, @mainColor1, @mainColor2, @subColor, nablarch-template-app_header, nablarch-template-app_nav, nablarch-template-app_aside, nablarch-widget-slide_menu, nablarch-template-page, nablarch-css-common, 画面配色変更, システムロゴ差し替え, 共通エラーメッセージ表示調整, ヘッダ・サイドメニュー・フッター修正, UIウィジェット, nablarch-widget-table-plain, nablarch-widget-table-search_result, nablarch-widget-table-row, nablarch-widget-column-label, nablarch-widget-column-link, nablarch-widget-column-checkbox, nablarch-widget-column-radio, nablarch-widget-box-img, nablarch-widget-table-tree, nablarch-widget-field-checkbox, nablarch-widget-field-radio, nablarch-widget-field-pulldown, nablarch-widget-field-listbuilder, nablarch-widget-field-text, nablarch-widget-field-textarea, nablarch-widget-field-password, nablarch-widget-field-file, nablarch-widget-field-calendar, nablarch-widget-event-autosum, nablarch-template-base, nablarch-widget-button, nablarch-widget-link, フォーカス移動制御, tabIndexOrder, プラグイン修正対象

</details>

## UI標準2.1. 端末の画面サイズと表示モード

## 表示モード切替条件の変更

表示モードの切替条件は **nablarch-device-media_query** プラグインのタグファイル（`/ui_public/WEB-INF/tags/device/media.tag`）内にCSS Media Queryの条件として定義されている。切替条件の変更や特定モードの無効化はこのプラグインをカスタマイズすること。

> **補足**: **nablarch-template-head** の `html_head.jsp` で使用されることで、htmlのheadタグ内にmedia.tagの内容が出力される。

## 表示モード切替の無効化（常にワイドモード）

`ui_public/WEB-INF/include/html_head.jsp` 内で以下の2行以外の全ての `<n:link>` タグとIEコンディショナルコメントを削除すること。これによりウィンドウサイズにかかわらず常にワイドモードで表示される。

```jsp
<n:link rel="stylesheet" type="text/css" href="/css/font-awesome.min.css" />
<n:link rel="stylesheet" type="text/css" href="/css/built/wide-minify.css" />
```

## 精査エラー時の開閉可能領域の制御を変更したい

開閉可能領域は **nablarch-widget-collapsible** にて実装されている。

- 入力項目に紐づくエラー（単項目精査エラーなど）がある場合: その入力項目のform内にある開閉可能領域が開く
- 入力項目に紐づかないエラー（ページ上部のエラー表示）がある場合: 業務領域にある開閉可能領域が開く

制御を変更したい場合は、**nablarch-widget-collapsible** を修正すること。

<details>
<summary>keywords</summary>

nablarch-device-media_query, media.tag, CSS Media Query, 表示モード切替条件変更, 表示モード無効化, ワイドモード固定, 開閉可能領域, nablarch-widget-collapsible, 精査エラー, エラー表示制御, 単項目精査エラー

</details>

## UI標準2.2. ワイド表示モードの画面構成

## ワイドモードの共通サイズ調整

ワイドモードの共通的なサイズ設定は **nablarch-css-conf-wide** プラグインで規定されている（グリッド数、1グリッドの横幅、グリッド間の間隔、フォントサイズ、入力フィールドやテーブルのグリッド数）。これらの設定値を変更することで全体的なサイズ調整が可能。

## ワイドモード固有のスタイル修正

ファイル名の末尾が **-wide.less** となっているスタイル定義はワイドモードでのみ読み込まれる。ワイドモードでのみ表示調整が必要な場合は各プラグインの上記ファイルを修正する。

例: **nablarch-template-app_header** では以下のように表示モードごとに読み込まれるスタイルファイルが分かれている:

| 表示モード | 読み込まれるスタイルファイル |
|---|---|
| ワイド | header.less、header-wide.less |
| コンパクト | header.less、header-compact.less |
| ナロー | header.less、header-narrow.less |

<details>
<summary>keywords</summary>

nablarch-css-conf-wide, -wide.less, ワイドモードサイズ調整, グリッド設定, ワイドモード固有スタイル

</details>

## UI標準2.3. コンパクト表示モードの画面構成

## コンパクトモード固有のスタイル修正

ファイル名の末尾が **-compact.less** のスタイルファイルはコンパクト表示モードでのみ読み込まれる。コンパクトモードの表示調整は対象プラグインのこの条件に合致するスタイルファイルを修正すること。該当するファイルがない場合は新たに追加してもよい。

<details>
<summary>keywords</summary>

-compact.less, コンパクトモード表示調整, コンパクトモード固有スタイル

</details>

## UI標準2.4. ナロー表示モードの画面構成

## ナローモード固有のスタイル修正

ファイル名の末尾が **-narrow.less** のスタイルファイルはナロー表示モードでのみ読み込まれる。ナローモードの表示調整は対象プラグインのこの条件に合致するスタイルファイルを修正すること。該当するファイルがない場合は新たに追加すること。

## テーブルの横スクロール防止（ナロー表示）

設定によりナロー表示時にカラムの一部をデフォルト非表示にし、タップ操作で表示・非表示を切り替えることができる。詳細は [../reference_jsp_widgets/column_label](testing-framework-column_label.md) の **additional** 属性の解説を参照すること。

<details>
<summary>keywords</summary>

-narrow.less, ナローモード表示調整, additional属性, テーブル横スクロール防止, column_label, カラム非表示

</details>

## UI標準2.5.画面内の入出力項目に関する共通仕様

## ドメイン型に応じた入出力項目のスタイル調整

domain属性値は当該項目のclass属性にそのまま追加されるため、ドメインIDと同名のスタイルクラスを定義することでそのドメイン型の入出力項目のスタイルを一括指定できる。

```css
.Money {
  align: right;
}
```

## タブキーによるフォーカス移動順番の制御

[base_layout_tag](testing-framework-jsp_page_templates.md) の **tagIndexOrder** 属性で制御可能。

> **補足**: タブ移動順序を画面ごとに定義するとテスト工数への影響が大きいため、顧客の特段の要望がない限りブラウザ既定の動作とすること。

## 注記の表示調整

- 注記自体の表示: **nablarch-widget-field-hint** プラグインの各ファイルを修正
- フィールド内での注記の表示位置: **nablarch-widget-field-base** の `ui_public/WEB-INF/tags/widget/field/inputbase.tag`（`<field:internal_hint>` の配置を変更）

## 必須入力項目の表示形式変更

**nablarch-widget-field-base** プラグインの `ui_public/WEB-INF/tags/widget/base.tag` を修正すること。

## 単項目精査エラーメッセージの表示変更

- エラーメッセージの表示位置: **nablarch-widget-field-base** の `ui_public/WEB-INF/tags/widget/field/inputbase.tag`（`<div class="fielderror">` の配置を変更）
- エラーメッセージの表示スタイル: 同プラグインの `ui_public/css/field/base.less`（**.fielderror** クラスを修正）

## ナロー表示モードでのボタン表示順変更

**nablarch-widget-button** プラグインの `ui_public/css/button/base-narrow.less` を修正すること。

## 認可権限がない場合のボタン／リンク表示方法変更

**nablarch-widet-button** プラグインの `ui_public/WEB-INF/tags/widget/button/*.tag` にて表示制御を行っている。表示制御を変更する場合は **displayMethod** の内容を修正すること。

<details>
<summary>keywords</summary>

nablarch-widget-field-hint, nablarch-widget-field-base, nablarch-widget-button, nablarch-widet-button, base_layout_tag, tagIndexOrder, domain属性, displayMethod, ドメイン型スタイル一括指定, 必須入力項目表示形式, 単項目精査エラーメッセージ, ナロー表示ボタン順序, 認可権限ボタン表示

</details>

## UI標準2.6. WEB標準に準拠しないブラウザでの表示制約

## ブラウザ間の表示差異の極小化（IE8の陰影・角丸を無効化）

IE8でサポートされていない陰影表現および角丸ボックス表示は **nablarch-css-core** プラグインの `ui_public/css/core/css3.less` 内に定義されている。

以下のスタイルルールを削除すると全ブラウザで陰影表現および角丸ボックス表示が無効化される:

- **.border-radius**
- **.rounded**
- **.drop-shadow**
- **.box-shadow**

<details>
<summary>keywords</summary>

nablarch-css-core, css3.less, .border-radius, .rounded, .drop-shadow, .box-shadow, IE8表示制約, 陰影・角丸無効化

</details>
