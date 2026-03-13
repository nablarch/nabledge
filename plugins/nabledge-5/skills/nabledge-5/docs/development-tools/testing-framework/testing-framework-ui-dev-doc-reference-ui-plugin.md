# UIプラグイン一覧

**公式ドキュメント**: [UIプラグイン一覧](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_ui_plugin/index.html)

## サードパーティ製ライブラリ

サードパーティ製ライブラリはNablarch UI開発基盤が依存している外部ライブラリを含むものであり、プロジェクト側でのカスタマイズは不可。リリース配布物には同梱されていないため、[../development_environment/initial_setup](testing-framework-initial_setup.md) の手順に従って別途ダウンロードする。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| es6-promise | ES6 Promise API ポリフィル | 不可 | ES6標準の非同期処理APIであるPromiseライブラリのポリフィル。一部の開発用コマンドで使用。 |
| font-awesome | WebFontアイコン | 不可 | WebFontによるアイコン画像とそれを表示するためのスタイル定義。 |
| jquery | jQueryライブラリ | 不可 | W3C DOM APIの互換レイヤを提供するライブラリ。 |
| less | LESSコンパイラ | 不可 | LESS記法で記述されたスタイル定義を通常のCSSに展開するツール。 |
| rquirejs | AMDモジュールローダ/コンパイラ | 不可 | AMD形式で記述されたJavaScriptライブラリを管理するライブラリおよびminifyツール。 |
| requiejs-text | テキストファイルAMD拡張 | 不可 | 通常のテキストファイルをAMDモジュールとして管理するためのrequirejs拡張。 |
| shelljs | プラットフォーム互換コマンド | 不可 | cd/grep/lnなどの主要基本コマンドのnode.jsによる実装。一部の開発用コマンドで使用。 |
| sugar | JavaScriptコアAPI拡張 | 不可 | String/Array/Numberなどのコアクラスを拡張。Array.forEachなど一部のES5標準APIのポリフィルを提供。 |

<details>
<summary>keywords</summary>

es6-promise, font-awesome, jquery, less, rquirejs, requiejs-text, shelljs, sugar, サードパーティライブラリ, 外部ライブラリ, AMDモジュールローダ, LESSコンパイラ, jQueryライブラリ

</details>

## CSS共通スタイルプラグイン

Nablarch UI開発基盤のスタイルは全てLESS記法を用いて記述している。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-css-core | コアスタイル定義 | 不可 | 共通基盤ファイルを含む: **reset.less**（各ブラウザのHTML要素に対するデフォルトスタイルを一律除去してブラウザ間の表示互換性を向上）、**grid.less**（グリッドフレームワーク定義）、**css3.less**（CSS3プロパティに相当するブラウザ互換なクラス定義） |
| nablarch-css-base | HTML基本要素スタイル | 非推奨 | reset.lessで除去されたHTMLの基本要素のスタイルを再定義する。修正時の影響が大きいのでカスタマイズは推奨しない。 |
| nablarch-css-common | NAF既定CSSスタイル定義 | 可 | 精査エラーメッセージの表示色などNAF側で指定されているCSSクラスの内容を定義する。 |
| nablarch-css-color-default | カラースキーム定義 | 必須 | 画面全体の基本配色を定義する。 |
| nablarch-css-conf-wide | ワイド表示モード定義 | 可 | レスポンシブ対応画面におけるワイド表示モード（デバイス/ウィンドウの横論理ピクセル数が1024超）での画面レイアウトを定義する。 |
| nablarch-css-conf-compact | コンパクト表示モード定義 | 可 | レスポンシブ対応画面におけるコンパクト表示モード（横論理ピクセル数が640超1024未満）における画面レイアウトを定義する。 |
| nablarch-css-conf-narrow | ナロー表示モード定義 | 可 | レスポンシブ対応画面におけるナロー表示モード（横論理ピクセル数が640未満）における画面レイアウトを定義する。 |
| nablarch-css-conf-multicol | マルチレイアウト表示モード定義 | 可 | マルチレイアウト表示モード（ワイドモードをベースとしている）における画面レイアウトを定義する。本モード使用時は画面サイズに応じた表示モードの切替（レスポンシブ対応）は使用できない。 |

<details>
<summary>keywords</summary>

nablarch-css-core, nablarch-css-base, nablarch-css-common, nablarch-css-color-default, nablarch-css-conf-wide, nablarch-css-conf-compact, nablarch-css-conf-narrow, nablarch-css-conf-multicol, CSSスタイル, LESS, レスポンシブ, 表示モード, グリッドフレームワーク, カラースキーム, マルチレイアウト

</details>

## 表示モード切替用プラグイン

[../internals/css_framework](testing-framework-css_framework.md) の表示モード切り替えを実現するプラグイン。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-device-media_query | 表示モード切替用プラグイン | 可 | MediaQueryによって表示モードを切り替える機能を実装する。表示モード切替えの条件を変更する場合は本プラグインをカスタマイズする。プラグインは `/WEB-INF/tags/device/media.tag` として実装されている。 |

<details>
<summary>keywords</summary>

nablarch-device-media_query, MediaQuery, 表示モード切替, レスポンシブ対応

</details>

## 特定端末向けパッチプラグイン

> **重要**: システムサポート外の端末を対象としたプラグインは、あらかじめ除去しておくこと。（[../development_environment/initial_setup](testing-framework-initial_setup.md) の「プロジェクトで使用するプラグインの選定」を参照。）

UserAgent判定により特定の端末のみで有効となるスクリプトやスタイル定義からなるプラグイン群。ただし、いわゆる feature-detection により判定するものについてはここには含まない。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-device-fix-base | UserAgentによるデバイス判定 | 可 | リクエストごとにサーバサイド処理でUserAgentを判定し、その結果をJavaScriptのグローバル変数および`<body>`要素のクラス属性に設定する。ローカル表示ではJavaScriptによりUserAgentを判定。 |
| nablarch-device-fix-ios | iOS向けパッチ | 可 | iOSの標準ブラウザにおける表示不具合を回避するためのスクリプトおよびスタイル定義。 |
| nablarch-device-fix-android_browser | Android向けパッチ | 可 | Androidの標準ブラウザにおける表示不具合を回避するためのスクリプトおよびスタイル定義。 |

<details>
<summary>keywords</summary>

nablarch-device-fix-base, nablarch-device-fix-ios, nablarch-device-fix-android_browser, UserAgent, iOS, Android, 端末判定, デバイスパッチ

</details>

## 開発用ツールプラグイン

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-dev-tool-installer | Nablarch UI開発基盤 標準プラグインインストーラ | 不可 | Nablarch UI基盤標準プラグインをプロジェクト側にインストールするスクリプト。 |
| nablarch-dev-tool-server | Nablarch UI開発基盤 テスト用簡易サーバ | 不可 | Nablarch UI開発基盤自体の各種テストに用いる簡易アプリケーションサーバ。 |
| nablarch-dev-ui_test-support | Nablarch UI開発基盤 テストケース用資源 | 不可 | テストケースで使用しているテストツール類（qunit.jsなど）。 |
| nablarch-dev-tool-uibuild | ウェブアプリケーション資源 ビルドスクリプト | 可 | ウェブアプリケーション上で公開される資源を各プラグインから収集しサーブレットコンテキスト配下に配置するスクリプト。スクリプトのミニファイおよびスタイル定義のLESSコンパイルとミニファイも行う。 |
| nablarch-dev-tool-update_support | Nablarch 標準プラグイン 更新補助スクリプト | 不可 | 使用しているプラグインとリリース資材のプラグイン間でバージョンが異なるプラグイン名を出力するスクリプト。 |

<details>
<summary>keywords</summary>

nablarch-dev-tool-installer, nablarch-dev-tool-server, nablarch-dev-ui_test-support, nablarch-dev-tool-uibuild, nablarch-dev-tool-update_support, ビルドスクリプト, LESSコンパイル, ミニファイ, 開発ツール

</details>

## 業務画面JSPローカル表示機能プラグイン

[../internals/inbrowser_jsp_rendering](testing-framework-inbrowser_jsp_rendering.md) およびその拡張機能を実現するための各種スクリプトなどを含むプラグイン群。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-dev-ui_demo-core | ローカル表示用JSPレンダラー | 不可 | 業務画面JSPをDOMに直接変換してプレビューを表示するJavaScript。 |
| nablarch-dev-ui_demo-config | ローカル表示時変数定義 | 必要 | JSPのレンダリング時に参照する各種スコープ変数の値を設定する（ログインユーザ名など）。 |
| nablarch-dev-ui_demo-core-lib | ローカル表示用タグライブラリ スタブ | 可 | 下記タグのレンダリングを行うスクリプト群: JSP標準タグライブラリ（`<jsp:include>`など）、JSTLタグライブラリ（`<c:if>`など）、EL埋め込み関数（`${fn:replace}`など）、Nablarch標準タグライブラリ（`<n:form>`など）、その他特殊な対応が必要となるHTMLタグ（`<style>`など） |
| nablarch-dev-ui_tool-base-core | 業務画面JSPローカル表示機能のベースコアプラグイン | 不要 | 業務画面JSPローカル表示機能のベースとなる機能を実装する。 |
| nablarch-dev-ui_tool-base-config | 業務画面JSPローカル表示機能の ベースコンフィギュレーションプラグイン | 必須 | 業務画面JSPローカル表示機能のリソースを管理する。 |
| nablarch-dev-ui_tool-jsp_verify | JSP検証ツールプラグイン | 可 | 業務画面JSPローカル表示機能で使用されるJSPファイルの検証。ローカル表示や設計書表示用の属性のチェックを行う。IE8の場合は検証処理は実行しない（IE8には未対応）。 |
| nablarch-dev-ui_tool-spec_view-core | 設計書ビューコアプラグイン | 不要 | [../internals/showing_specsheet_view](testing-framework-showing_specsheet_view.md) の実装。 |
| nablarch-dev-ui_tool-spec_view | 設計書ビュープラグイン | 不要 | 設計情報をJSPから取得する拡張機能（jQueryの拡張プラグインとして提供）。画面設計書ViewなどJSPの値を取得、変換する際に本拡張機能が使用できる。 |
| nablarch-dev-ui_tool-spec_view-resource | 設計書ビュー用のリソース管理プラグイン | 可 | 表示される設計書のテンプレート。フォーマットを変更する場合は、本プラグインに含まれるSpecSheetTmeplate.xlsxを修正し、htm形式で保存する。 |

<details>
<summary>keywords</summary>

nablarch-dev-ui_demo-core, nablarch-dev-ui_demo-config, nablarch-dev-ui_demo-core-lib, nablarch-dev-ui_tool-base-core, nablarch-dev-ui_tool-base-config, nablarch-dev-ui_tool-jsp_verify, nablarch-dev-ui_tool-spec_view-core, nablarch-dev-ui_tool-spec_view, nablarch-dev-ui_tool-spec_view-resource, JSPローカル表示, 設計書ビュー, JSP検証, SpecSheetTemplate

</details>

## JavaScriptユーティリティプラグイン

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-js-util-bigdecimal | 簡易BigDecimalライブラリ | 不可 | JavaScriptのNumber型（32bit浮動小数）使用時の誤差を回避するための簡易BigDecimal型実装クラス。内部的には32bit浮動小数を使用するため、有効桁が15桁を超える場合は使用できない。 |
| nablarch-js-util-date | 日付フォーマット変換ライブラリ | 可 | Javaのjava.util.SimpleDateFormatのサブセットとなる日付フォーマット変換を実装するユーティリティクラス。 |
| nablarch-js-util-consumer | 簡易Tokenizer/Parser | 不可 | ミニ言語のパーサの実装に使用する簡易パーサ。 |

<details>
<summary>keywords</summary>

nablarch-js-util-bigdecimal, nablarch-js-util-date, nablarch-js-util-consumer, BigDecimal, 日付フォーマット, SimpleDateFormat, JavaScriptユーティリティ, 浮動小数誤差

</details>

## UI部品ウィジェットプラグイン

[../internals/jsp_widgets](testing-framework-jsp_widgets.md) を実装するタグファイル・スクリプト・スタイル定義などを格納するプラグイン群。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-widget-core | JSウィジェット基盤クラス | 不可 | [../reference_jsp_widgets/index](testing-framework-ui-dev-doc-reference-jsp-widgets.md) で共通的に使用されるJavaScript部品を格納するプラグイン。jQueryのカスタムセレクタも含む。 |
| nablarch-widget-box-base | 表示領域ウィジェット共通テンプレート | 可 | 表示領域ウィジェットで共通的に使用されるCSS定義を実装する。 |
| nablarch-widget-box-content | box_contentウィジェット | 可 | [../reference_jsp_widgets/box_content](testing-framework-box_content.md) の実装。 |
| nablarch-widget-box-img | box_imgウィジェット | 可 | [../reference_jsp_widgets/box_img](testing-framework-box_img.md) の実装。 |
| nablarch-widget-box-title | box_titleウィジェット | 可 | [../reference_jsp_widgets/box_title](testing-framework-box_title.md) の実装。 |
| nablarch-widget-button | buttonウィジェット | 可 | [../reference_jsp_widgets/button_submit](testing-framework-button_submit.md) の実装。 |
| nablarch-widget-collapsible | 開閉機能スクリプト | 非推奨 | 画面内の領域を開閉する機能を実装するスクリプト。[../reference_jsp_widgets/table_treelist](testing-framework-table_treelist.md) などから使用される。 |
| nablarch-widget-column-base | カラムウィジェット共通プラグイン | 可 | カラムウィジェットで使用される共通機能（共通CSS定義、JSPローカル表示機能用ライブラリ）を実装する。 |
| nablarch-widget-column-checkbox | column_checkboxウィジェット | 可 | [../reference_jsp_widgets/column_checkbox](testing-framework-column_checkbox.md) の実装。 |
| nablarch-widget-column-code | column_codeウィジェット | 可 | [../reference_jsp_widgets/column_code](testing-framework-column_code.md) の実装。 |
| nablarch-widget-column-label | column_labelウィジェット | 可 | [../reference_jsp_widgets/column_label](testing-framework-column_label.md) の実装。 |
| nablarch-widget-column-link | column_linkウィジェット | 可 | [../reference_jsp_widgets/column_link](testing-framework-column_link.md) の実装。 |
| nablarch-widget-column-radio | column_radioウィジェット | 可 | [../reference_jsp_widgets/column_radio](testing-framework-column_radio.md) の実装。 |
| nablarch-widget-field-base | field_baseウィジェット | 可 | [../reference_jsp_widgets/field_base](testing-framework-field_base.md) の実装。 |
| nablarch-widget-field-block | field_blockウィジェット | 可 | [../reference_jsp_widgets/field_block](testing-framework-field_block.md) の実装。 |
| nablarch-widget-field-calendar | field_calendarウィジェット | 可 | [../reference_jsp_widgets/field_calendar](testing-framework-field_calendar.md) の実装。 |
| nablarch-widget-field-checkbox | field_checkboxウィジェット | 可 | [../reference_jsp_widgets/field_checkbox](testing-framework-field_checkbox.md) の実装。 |
| nablarch-widget-field-file | field_fileウィジェット | 可 | [../reference_jsp_widgets/field_file](testing-framework-field_file.md) の実装。 |
| nablarch-widget-field-hint | field_hintウィジェット | 可 | [../reference_jsp_widgets/field_hint](testing-framework-field_hint.md) の実装。 |
| nablarch-widget-field-label | field_labelウィジェット | 可 | [../reference_jsp_widgets/field_label](testing-framework-field_label.md) の実装。 |
| nablarch-widget-field-label_block | field_label_blockウィジェット | 可 | [../reference_jsp_widgets/field_label_block](testing-framework-field_label_block.md) の実装。 |
| nablarch-widget-field-label_id_value | field_label_id_valueウィジェット | 可 | [../reference_jsp_widgets/field_label_id_value](testing-framework-field_label_id_value.md) の実装。 |
| nablarch-widget-field-listbuilder | field_listbuilderウィジェット | 可 | [../reference_jsp_widgets/field_listbuilder](testing-framework-field_listbuilder.md) の実装。 |
| nablarch-widget-field-password | field_passwordウィジェット | 可 | [../reference_jsp_widgets/field_password](testing-framework-field_password.md) の実装。 |
| nablarch-widget-field-pulldown | field_pulldownウィジェット | 可 | [../reference_jsp_widgets/field_pulldown](testing-framework-field_pulldown.md) の実装。 |
| nablarch-widget-field-radio | field_radioウィジェット | 可 | [../reference_jsp_widgets/field_radio](testing-framework-field_radio.md) の実装。 |
| nablarch-widget-field-text | field_textウィジェット | 可 | [../reference_jsp_widgets/field_text](testing-framework-field_text.md) の実装。 |
| nablarch-widget-field-textarea | field_textareaウィジェット | 可 | [../reference_jsp_widgets/field_textarea](testing-framework-field_textarea.md) の実装。 |
| nablarch-widget-link | linkウィジェット | 可 | [../reference_jsp_widgets/link_submit](testing-framework-link_submit.md) の実装。 |
| nablarch-widget-multicol-cell | マルチレイアウト用列定義ウィジェット | 可 | マルチレイアウトで使用する列を表すタグ（layout:cell）を実装する。詳細は [multicol_css_framework_example](testing-framework-multicol_css_framework.md) を参照。 |
| nablarch-widget-multicol-row | マルチレイアウト用行定義ウィジェット | 可 | マルチレイアウトで使用する行を表すタグ（layout:row）を実装する。詳細は [multicol_css_framework_example](testing-framework-multicol_css_framework.md) を参照。 |
| nablarch-widget-placeholder | placeholder属性ポリフィル | 非推奨 | IEなどのplaceholder属性を実装していないブラウザ向けのポリフィル実装。 |
| nablarch-widget-readonly | 変更不可項目制御 | 非推奨 | readonly属性の拡張。通常のreadonly属性とは異なり、プルダウンやチェックボックスの選択状態の変更も抑止できる。 |
| nablarch-widget-slide-menu | スライドメニューウィジェット | 必須 | narrow/compact表示でメニューを省スペース化するサンプル機能。JavaScript/LESSの定義はそのまま使用できるが、JSPはPJ側で修正する必要がある。 |
| nablarch-widget-spec | 画面仕様記述用ウィジェット | 可 | 画面仕様の情報を記述するタグの実装。設計書ビュー表示プラグインはこのタグから情報を取得する。このタグはサーバ表示には影響を与えない。 |
| nablarch-widget-spec-meta_info | メタ情報記述用ウィジェット | 可 | 設計書作成者等の情報を記述するためのタグの実装。設計書ビュー表示プラグインはこのタグから取得した情報を使用する。このタグはサーバ表示には影響を与えない。 |
| nablarch-widget-tab | tabウィジェット | 可 | [../reference_jsp_widgets/tab_group](testing-framework-tab_group.md) の実装。 |
| nablarch-widget-table-base | テーブルウィジェットの共通プラグイン | 可 | テーブルウィジェットで共通的に使用されるCSS定義、表示モードに応じたウィジェット表示内容の切り替え用CSS定義、JSPローカル表示機能用ライブラリが実装されている。 |
| nablarch-widget-table-plain | table_plainウィジェット | 可 | [../reference_jsp_widgets/table_plain](testing-framework-table_plain.md) の実装。 |
| nablarch-widget-table-row | table_rowウィジェット | 可 | [../reference_jsp_widgets/table_row](testing-framework-table_row.md) の実装。 |
| nablarch-widget-table-search_result | table_search_resultウィジェット | 可 | [../reference_jsp_widgets/table_search_result](testing-framework-table_search_result.md) の実装。 |
| nablarch-widget-table-tree | table_treelistウィジェット | 可 | [../reference_jsp_widgets/table_treelist](testing-framework-table_treelist.md) の実装。 |
| nablarch-widget-toggle-checkbox | チェックボックスの全選択/全解除プラグイン | 可 | リンクやボタンにチェックボックス全選択/全解除の機能を持たせるためのプラグイン。 |
| nablarch-widget-tooltip | ツールチップ表示プラグイン | 可 | マウスオーバーにより補足情報をポップアップで表示する機能をもつプラグイン。 |

<details>
<summary>keywords</summary>

nablarch-widget-core, nablarch-widget-box-base, nablarch-widget-box-content, nablarch-widget-box-img, nablarch-widget-box-title, nablarch-widget-button, nablarch-widget-collapsible, nablarch-widget-column-base, nablarch-widget-column-checkbox, nablarch-widget-column-code, nablarch-widget-column-label, nablarch-widget-column-link, nablarch-widget-column-radio, nablarch-widget-field-base, nablarch-widget-field-block, nablarch-widget-field-calendar, nablarch-widget-field-checkbox, nablarch-widget-field-file, nablarch-widget-field-hint, nablarch-widget-field-label, nablarch-widget-field-label_block, nablarch-widget-field-label_id_value, nablarch-widget-field-listbuilder, nablarch-widget-field-password, nablarch-widget-field-pulldown, nablarch-widget-field-radio, nablarch-widget-field-text, nablarch-widget-field-textarea, nablarch-widget-link, nablarch-widget-multicol-cell, nablarch-widget-multicol-row, nablarch-widget-placeholder, nablarch-widget-readonly, nablarch-widget-slide-menu, nablarch-widget-spec, nablarch-widget-spec-meta_info, nablarch-widget-tab, nablarch-widget-table-base, nablarch-widget-table-plain, nablarch-widget-table-row, nablarch-widget-table-search_result, nablarch-widget-table-tree, nablarch-widget-toggle-checkbox, nablarch-widget-tooltip, ウィジェット, JSPウィジェット, フィールドウィジェット, テーブルウィジェット, カラムウィジェット

</details>

## UIイベント制御部品プラグイン

画面上のイベント制御を宣言的に定義するウィジェットを実装するプラグイン群。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-js-submit | Nablarchカスタムサブミットイベント | 不可 | Nablarchフレームワークのサブミット時処理（nablarch_submit）の実行前後に発火するjQueryグローバルカスタムイベントを定義する。 |
| nablarch-widget-event-base | イベントウィジェットベースプラグイン | 不可 | イベントウィジェットのベースプラグイン。JSPローカル表示時にイベントのエミュレーションを行うために必要な機能を実装する。 |
| nablarch-widget-event-listen | event_listenウィジェット | 不可 | 画面内で発生する指定されたイベントを監視し、各種イベントアクションを実行するウィジェットの実装。[../reference_jsp_widgets/event_listen](testing-framework-event_listen.md) |
| nablarch-widget-event-autosum | 自動集計イベント | 不可 | 自動集計イベントアクションの実装。 |
| nablarch-widget-event-dialog | ダイアログ表示イベントアクション | 不可 | ダイアログ表示イベントアクションの実装。アラート、確認ダイアログから使用される。[../reference_jsp_widgets/event_alert](testing-framework-event_alert.md) / [../reference_jsp_widgets/event_confirm](testing-framework-event_confirm.md) |
| nablarch-widget-event-send_request | event_send_requestウィジェット | 不可 | [../reference_jsp_widgets/event_send_request](testing-framework-event_send_request.md) の実装。 |
| nablarch-widget-event-toggle | event_toggle系ウィジェット | 不可 | [../reference_jsp_widgets/event_toggle_disabled](testing-framework-event_toggle_disabled.md) / [../reference_jsp_widgets/event_toggle_property](testing-framework-event_toggle_property.md) / [../reference_jsp_widgets/event_toggle_readonly](testing-framework-event_toggle_readonly.md) の実装。 |
| nablarch-widget-event-window_close | event_window_closeウィジェット | 不可 | [../reference_jsp_widgets/event_window_close](testing-framework-event_window_close.md) の実装。 |
| nablarch-widget-event-write_to | event_write_toウィジェット | 不可 | [../reference_jsp_widgets/event_write_to](testing-framework-event_write_to.md) の実装。 |

<details>
<summary>keywords</summary>

nablarch-js-submit, nablarch-widget-event-base, nablarch-widget-event-listen, nablarch-widget-event-autosum, nablarch-widget-event-dialog, nablarch-widget-event-send_request, nablarch-widget-event-toggle, nablarch-widget-event-window_close, nablarch-widget-event-write_to, イベント制御, カスタムサブミット, ダイアログ, 自動集計, nablarch_submit

</details>

## 業務画面テンプレートプラグイン

[../internals/jsp_page_templates](testing-framework-jsp_page_templates.md) の実体となるタグファイルと、それに付随するスクリプトやスタイル定義から構成されるプラグイン群。各テンプレートからインクルードされる共通領域を描画するJSPのサンプルも含む。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-template-base | baseレイアウトテンプレート | 可 | [base_layout_tag](testing-framework-jsp_page_templates.md) の実装。 |
| nablarch-template-page | pageテンプレート | 可 | [page_template_tag](testing-framework-jsp_page_templates.md) の実装。 |
| nablarch-template-error | errorページテンプレート | 可 | [errorpage_template_tag](testing-framework-jsp_page_templates.md) の実装。 |
| nablarch-template-head | HTML head要素定義インクルード | 可 | [base_layout_tag](testing-framework-jsp_page_templates.md) からインクルードされる。`<title>`タグの内容、MediaQueryによる表示モード切替え、外部CSSファイルのインクルード、`<meta>`タグの内容（IEの互換モード設定など）を定義する。 |
| nablarch-template-multicol-head | マルチレイアウト用HTML head要素定義インクルード | 可 | [base_layout_tag](testing-framework-jsp_page_templates.md) からインクルードされる。`<title>`タグの内容、外部CSSファイルのインクルード、`<meta>`タグの内容（IEの互換モード設定など）を定義する。使用方法は [multicol_css_framework_setting_layout](testing-framework-multicol_css_framework.md) を参照。 |
| nablarch-template-js_include | HTML script要素定義インクルード | 可 | [base_layout_tag](testing-framework-jsp_page_templates.md) からインクルードされる。HTMLの最後（bodyタグの末端）に出力している（画面の描画とスクリプトのロードを並行に実行しユーザの体感速度を向上させるため）。 |
| nablarch-template-app_nav | アプリケーション共通ナビゲーションメニューサンプル | 必須 | 業務画面の共通ナビゲーション領域を描画するJSPおよびスタイル定義などのリソース。JSPは [page_template_tag](testing-framework-jsp_page_templates.md) からインクルードされる。内容はUI開発基盤用プロジェクトテンプレートと同じものなので、PJ側で修正する必要がある。 |
| nablarch-template-app_header | アプリケーション共通ヘッダサンプル | 必須 | 業務画面の共通ヘッダ領域を描画するJSPおよびスタイル定義などのリソース。JSPは [page_template_tag](testing-framework-jsp_page_templates.md) からインクルードされる。内容はUI開発基盤用プロジェクトテンプレートと同じものなので、PJ側で修正する必要がある。 |
| nablarch-template-app_footer | アプリケーション共通フッターサンプル | 必須 | 業務画面の共通フッター領域を描画するJSPおよびスタイル定義などのリソース。JSPは [page_template_tag](testing-framework-jsp_page_templates.md) からインクルードされる。内容はUI開発基盤用プロジェクトテンプレートと同じものなので、PJ側で修正する必要がある。 |
| nablarch-template-app_aside | アプリケーション共通サイドメニューサンプル | 必須 | 業務画面の共通サイドメニューを描画するJSPおよびスタイル定義などのリソース。JSPは [page_template_tag](testing-framework-jsp_page_templates.md) からインクルードされる。内容はUI開発基盤用プロジェクトテンプレートと同じものなので、PJ側で修正する必要がある。 |

<details>
<summary>keywords</summary>

nablarch-template-base, nablarch-template-page, nablarch-template-error, nablarch-template-head, nablarch-template-multicol-head, nablarch-template-js_include, nablarch-template-app_nav, nablarch-template-app_header, nablarch-template-app_footer, nablarch-template-app_aside, base_layout_tag, page_template_tag, errorpage_template_tag, JSPテンプレート, ナビゲーション, ヘッダ, フッタ

</details>
