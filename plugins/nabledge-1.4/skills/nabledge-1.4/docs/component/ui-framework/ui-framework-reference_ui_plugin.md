# UIプラグイン一覧

## サードパーティ製ライブラリ

Nablarch UI開発基盤が依存する外部ライブラリ。プロジェクト側でのカスタマイズは不可。UI開発基盤のリリース配布物には同梱されていないため、[../development_environment/initial_setup](ui-framework-initial_setup.md) の手順で別途ダウンロードする。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| es6-promise | ES6 Promise API ポリフィル | 不可 | ES6標準のPromiseライブラリのポリフィル。一部の開発用コマンドで使用 |
| font-awesome | WebFontアイコン | 不可 | WebFontによるアイコン画像とスタイル定義 |
| jquery | jQueryライブラリ | 不可 | W3C DOM APIの互換レイヤを提供 |
| less | LESSコンパイラ | 不可 | LESS記法のスタイル定義を通常のCSSに展開するツール |
| rquirejs | AMDモジュールローダ/コンパイラ | 不可 | AMD形式のJavaScriptライブラリ管理およびminifyツール |
| requiejs-text | テキストファイルAMD拡張 | 不可 | テキストファイルをAMDモジュールとして管理するrequirejs拡張 |
| shelljs | プラットフォーム互換コマンド | 不可 | cd/grep/lnなどの主要コマンドのnode.js実装。一部の開発用コマンドで使用 |
| sugar | JavaScriptコアAPI拡張 | 不可 | String/Array/Numberなどのコアクラス拡張。ES5標準APIのポリフィルも提供 |

<details>
<summary>keywords</summary>

es6-promise, font-awesome, jquery, less, rquirejs, requiejs-text, shelljs, sugar, サードパーティライブラリ, UI開発基盤依存ライブラリ, AMDモジュール, LESSコンパイラ, jQueryライブラリ

</details>

## CSS共通スタイルプラグイン

画面の表示制御を行うスタイル定義を含むプラグイン。スタイルは全てLESS記法で記述。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-css-core | コアスタイル定義 | 不可 | reset.less（ブラウザデフォルトスタイル除去によるブラウザ間表示互換性向上）、grid.less（グリッドフレームワーク定義）、css3.less（CSS3プロパティのブラウザ互換クラス定義）を含む |
| nablarch-css-base | HTML基本要素スタイル | 非推奨 | reset.lessで除去されたHTML基本要素スタイルの再定義。修正時の影響が大きいためカスタマイズは推奨しない |
| nablarch-css-common | NAF既定CSSスタイル定義 | 可 | 精査エラーメッセージの表示色などNAF側で指定されているCSSクラスの内容を定義 |
| nablarch-css-color-default | カラースキーム定義 | 必須 | 画面全体の基本配色を定義 |
| nablarch-css-conf-wide | ワイド表示モード定義 | 可 | レスポンシブ対応画面のワイド表示モード（デバイス/ウィンドウの横論理ピクセル数が1024超）でのレイアウト定義 |
| nablarch-css-conf-compact | コンパクト表示モード定義 | 可 | レスポンシブ対応画面のコンパクト表示モード（横論理ピクセル数が640超1024未満）のレイアウト定義 |
| nablarch-css-conf-narrow | ナロー表示モード定義 | 可 | レスポンシブ対応画面のナロー表示モード（横論理ピクセル数が640未満）のレイアウト定義 |

<details>
<summary>keywords</summary>

nablarch-css-core, nablarch-css-base, nablarch-css-common, nablarch-css-color-default, nablarch-css-conf-wide, nablarch-css-conf-compact, nablarch-css-conf-narrow, CSSスタイル, レスポンシブレイアウト, グリッドフレームワーク, カラースキーム, 表示モード

</details>

## 特定端末向けパッチプラグイン

UserAgent判定により、特定の端末のみで有効となるスクリプトやスタイル定義からなるプラグイン（feature-detectionによる判定は含まない）。

> **警告**: システムサポート外の端末を対象としたプラグインは、あらかじめ除去しておくこと。（[../development_environment/initial_setup](ui-framework-initial_setup.md) の「プロジェクトで使用するプラグインの選定」を参照）

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-device-fix-base | UserAgentによるデバイス判定 | 可 | リクエストごとにサーバサイドでUserAgent判定し、結果をJavaScriptグローバル変数および`<body>`要素のクラス属性に設定。ローカル表示ではJavaScriptによるUserAgent判定を行う |
| nablarch-device-fix-ios | ios向けパッチ | 可 | iOSの標準ブラウザにおける表示不具合を回避するスクリプトおよびスタイル定義 |
| nablarch-device-fix-android_browser | android向けパッチ | 可 | androidの標準ブラウザにおける表示不具合を回避するスクリプトおよびスタイル定義 |

<details>
<summary>keywords</summary>

nablarch-device-fix-base, nablarch-device-fix-ios, nablarch-device-fix-android_browser, UserAgent判定, デバイス判定, iOS対応, Android対応, 端末別パッチ

</details>

## 開発用ツールプラグイン

開発作業において使用する各種ツールからなるプラグイン。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-dev-tool-installer | Nablarch UI開発基盤標準プラグインインストーラー | 不可 | Nablarch UI基盤標準プラグインをプロジェクト側にインストールするスクリプト |
| nablarch-dev-tool-server | Nablarch UI開発基盤テスト用簡易サーバー | 不可 | Nablarch UI開発基盤自体の各種テストに用いる簡易アプリケーションサーバー |
| nablarch-dev-ui_test-support | Nablarch UI開発基盤テストケース用資源 | 不可 | Nablarch UI開発基盤自体のテストケースで使用するテストツール類（qunit.jsなど） |
| nablarch-dev-tool-uibuild | Webアプリケーション資源ビルドスクリプト | 可 | Webアプリケーション上で公開される資源を各プラグインから収集しサーブレットコンテキスト配下に配置するスクリプト。スクリプトのミニファイおよびスタイル定義のLESSコンパイル・ミニファイも実行 |
| nablarch-dev-tool-update_support | Nablarch標準プラグイン更新補助スクリプト | 不可 | 利用しているプラグインとリリース資材のプラグイン間でバージョンが異なるプラグイン名を出力 |

<details>
<summary>keywords</summary>

nablarch-dev-tool-installer, nablarch-dev-tool-server, nablarch-dev-ui_test-support, nablarch-dev-tool-uibuild, nablarch-dev-tool-update_support, 開発ツール, ビルドスクリプト, プラグインインストール, LESSコンパイル, ミニファイ

</details>

## JSP業務画面ローカル表示機能プラグイン

[../internals/inbrowser_jsp_rendering](ui-framework-inbrowser_jsp_rendering.md) およびその拡張機能を実現するためのスクリプト等を含むプラグイン。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-dev-ui_demo-core | ローカル表示用JSPレンダラー | 不可 | 業務画面JSPをDOMに直接変換してプレビューを表示するJavaScript |
| nablarch-dev-ui_demo-config | ローカル表示時変数定義 | 必要 | JSPのレンダリング時に参照する各種スコープ変数の値（ログインユーザ名など）を設定。ローカル表示で利用するガイドへのリンクを設定 |
| nablarch-dev-ui_demo-core-lib | ローカル表示用タグライブラリスタブ | 可 | JSP標準タグライブラリ（`<jsp:include>`など）、JSTLタグライブラリ（`<c:if>`など）、EL埋め込み関数（`${fn:replace}`など）、Nablarch標準タグライブラリ（`<n:form>`など）、その他特殊なHTMLタグ（`<style>`など）のレンダリングを行うスクリプト群 |

<details>
<summary>keywords</summary>

nablarch-dev-ui_demo-core, nablarch-dev-ui_demo-config, nablarch-dev-ui_demo-core-lib, JSPローカル表示, ブラウザ内JSPレンダリング, タグライブラリスタブ, JSTLスタブ, EL埋め込み関数

</details>

## JavaScriptユーティリティプラグイン

JavaScriptのコアライブラリをサポートするユーティリティスクリプト。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-js-util-bigdecimal | 簡易BigDecimalライブラリ | 不可 | JavaScriptのNumber型（32bit浮動少数）使用時の誤差を回避する簡易BigDecimal型実装。有効桁が15桁を超える場合は使用不可 |
| nablarch-js-util-date | 日付フォーマット変換ライブラリ | 可 | Javaのjava.util.SimpleDateFormatのサブセットとなる日付フォーマット変換を実装するユーティリティクラス |
| nablarch-js-util-consumer | 簡易Tokenizer/Parser | 不可 | ミニ言語のパーサの実装に使用する簡易パーサ |

<details>
<summary>keywords</summary>

nablarch-js-util-bigdecimal, nablarch-js-util-date, nablarch-js-util-consumer, BigDecimalライブラリ, 日付フォーマット変換, SimpleDateFormat, JavaScriptユーティリティ, Tokenizer, Parser

</details>

## UI部品ウィジェットプラグイン

[../internals/jsp_widgets](ui-framework-jsp_widgets.md) を実装するタグファイル・スクリプト・スタイル定義などを格納するプラグイン。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-widget-core | JSウィジェット基盤クラス | 不可 | [../reference_jsp_widgets/index](ui-framework-reference_jsp_widgets.md) で共通的に使用されるJavaScript部品。jQueryのカスタムセレクタを含む |
| nablarch-widget-button | [../reference_jsp_widgets/button_submit](ui-framework-button_submit.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-collapsible | 開閉機能スクリプト | 非推奨 | 画面内の領域を開閉する機能を実装するスクリプト。[../reference_jsp_widgets/table_treelist](ui-framework-table_treelist.md) などから使用 |
| nablarch-widget-column-checkbox | [../reference_jsp_widgets/column_checkbox](ui-framework-column_checkbox.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-column-code | [../reference_jsp_widgets/column_code](ui-framework-column_code.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-column-label | [../reference_jsp_widgets/column_label](ui-framework-column_label.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-column-link | [../reference_jsp_widgets/column_link](ui-framework-column_link.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-column-radio | [../reference_jsp_widgets/column_radio](ui-framework-column_radio.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-base | [../reference_jsp_widgets/field_base](ui-framework-field_base.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-block | [../reference_jsp_widgets/field_block](ui-framework-field_block.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-calendar | [../reference_jsp_widgets/field_calendar](ui-framework-field_calendar.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-checkbox | [../reference_jsp_widgets/field_checkbox](ui-framework-field_checkbox.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-file | [../reference_jsp_widgets/field_file](ui-framework-field_file.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-hint | [../reference_jsp_widgets/field_hint](ui-framework-field_hint.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-label | [../reference_jsp_widgets/field_label](ui-framework-field_label.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-label_block | [../reference_jsp_widgets/field_label_block](ui-framework-field_label_block.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-label_id_value | [../reference_jsp_widgets/field_label_id_value](ui-framework-field_label_id_value.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-listbuilder | [../reference_jsp_widgets/field_listbuilder](ui-framework-field_listbuilder.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-password | [../reference_jsp_widgets/field_password](ui-framework-field_password.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-pulldown | [../reference_jsp_widgets/field_pulldown](ui-framework-field_pulldown.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-radio | [../reference_jsp_widgets/field_radio](ui-framework-field_radio.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-text | [../reference_jsp_widgets/field_text](ui-framework-field_text.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-field-textarea | [../reference_jsp_widgets/field_textarea](ui-framework-field_textarea.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-link | [../reference_jsp_widgets/link_submit](ui-framework-link_submit.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-placeholder | placeholder属性ポリフィル | 非推奨 | IEなどplaceholder属性を実装していないブラウザ向けのポリフィル実装 |
| nablarch-widget-readonly | 変更不可項目制御 | 非推奨 | readonly属性の拡張。通常のreadonly属性とは異なり、プルダウンやチェックボックスの選択状態の変更も抑止可能 |
| nablarch-widget-tab | [../reference_jsp_widgets/tab_group](ui-framework-tab_group.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-table-plain | [../reference_jsp_widgets/table_plain](ui-framework-table_plain.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-table-row | [../reference_jsp_widgets/table_row](ui-framework-table_row.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-table-search_result | [../reference_jsp_widgets/table_search_result](ui-framework-table_search_result.md) | 可 | 左記ウィジェットの実装 |
| nablarch-widget-table-tree | [../reference_jsp_widgets/table_treelist](ui-framework-table_treelist.md) | 可 | 左記ウィジェットの実装 |

<details>
<summary>keywords</summary>

nablarch-widget-core, nablarch-widget-button, nablarch-widget-collapsible, nablarch-widget-column-checkbox, nablarch-widget-column-code, nablarch-widget-column-label, nablarch-widget-column-link, nablarch-widget-column-radio, nablarch-widget-field-base, nablarch-widget-field-block, nablarch-widget-field-calendar, nablarch-widget-field-checkbox, nablarch-widget-field-file, nablarch-widget-field-hint, nablarch-widget-field-label, nablarch-widget-field-label_block, nablarch-widget-field-label_id_value, nablarch-widget-field-listbuilder, nablarch-widget-field-password, nablarch-widget-field-pulldown, nablarch-widget-field-radio, nablarch-widget-field-text, nablarch-widget-field-textarea, nablarch-widget-link, nablarch-widget-placeholder, nablarch-widget-readonly, nablarch-widget-tab, nablarch-widget-table-plain, nablarch-widget-table-row, nablarch-widget-table-search_result, nablarch-widget-table-tree, JSPウィジェット, UI部品, フォームフィールド, テーブル, タブ

</details>

## UIイベント制御部品プラグイン

画面上のイベント制御を宣言的に定義する各種ウィジェットを実装するプラグイン。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-js-submit | Nablarchカスタムサブミットイベント | 不可 | Nablarchフレームワークのサブミット時処理（nablarch_submit）の実行前後に発火するjQueryグローバルカスタムイベントを定義 |
| nablarch-widget-event-listen | [../reference_jsp_widgets/event_listen](ui-framework-event_listen.md) | 不可 | 画面内で発生する指定イベントを監視し、各種イベントアクションを実行するウィジェットの実装 |
| nablarch-widget-event-autosum | 自動集計イベント | 不可 | 自動集計イベントアクションの実装 |
| nablarch-widget-event-dialog | ダイアログ表示イベントアクション（[../reference_jsp_widgets/event_alert](ui-framework-event_alert.md)、[../reference_jsp_widgets/event_confirm](ui-framework-event_confirm.md)） | 不可 | ダイアログ表示イベントアクションの実装（アラート、確認ダイアログから使用） |
| nablarch-widget-event-send_request | [../reference_jsp_widgets/event_send_request](ui-framework-event_send_request.md) | 不可 | 左記イベントアクションの実装 |
| nablarch-widget-event-toggle | [../reference_jsp_widgets/event_toggle_disabled](ui-framework-event_toggle_disabled.md)、[../reference_jsp_widgets/event_toggle_property](ui-framework-event_toggle_property.md)、[../reference_jsp_widgets/event_toggle_readonly](ui-framework-event_toggle_readonly.md) | 不可 | 左記イベントアクションの実装 |
| nablarch-widget-event-window_close | [../reference_jsp_widgets/event_window_close](ui-framework-event_window_close.md) | 不可 | 左記イベントアクションの実装 |
| nablarch-widget-event-write_to | [../reference_jsp_widgets/event_write_to](ui-framework-event_write_to.md) | 不可 | 左記イベントアクションの実装 |

<details>
<summary>keywords</summary>

nablarch-js-submit, nablarch-widget-event-listen, nablarch-widget-event-autosum, nablarch-widget-event-dialog, nablarch-widget-event-send_request, nablarch-widget-event-toggle, nablarch-widget-event-window_close, nablarch-widget-event-write_to, イベント制御, カスタムイベント, サブミットイベント, ダイアログ, 自動集計, nablarch_submit

</details>

## 業務画面テンプレートプラグイン

[../internals/jsp_page_templates](ui-framework-jsp_page_templates.md) の実体となるタグファイルと、それに付随するスクリプトやスタイル定義から構成されるプラグイン。各テンプレートからインクルードされる共通領域を描画するJSPのサンプルも含む。

| プラグインID | 名称 | カスタマイズ | 概要 |
|---|---|---|---|
| nablarch-template-base | [base_layout_tag](ui-framework-jsp_page_templates.md) | 可 | 左記テンプレートの実装 |
| nablarch-template-page | [page_template_tag](ui-framework-jsp_page_templates.md) | 可 | 左記テンプレートの実装 |
| nablarch-template-error | [errorpage_template_tag](ui-framework-jsp_page_templates.md) | 可 | 左記テンプレートの実装 |
| nablarch-template-head | HTML head要素定義インクルード | 可 | head要素の内容（`<title>`タグ、MediaQueryによる表示モード切替、外部CSSインクルード、`<meta>`タグ）を出力するJSP。[base_layout_tag](ui-framework-jsp_page_templates.md) からインクルードされる |
| nablarch-template-js_include | HTML script要素定義インクルード | 可 | scriptタグの内容を出力するJSP。[base_layout_tag](ui-framework-jsp_page_templates.md) からインクルードされる。HTMLの最後（bodyタグ末端）に出力することで、画面描画とスクリプトロードを並行実行しユーザの体感速度を向上 |
| nablarch-template-app_nav | アプリケーション共通ナビゲーションメニューサンプル | 必須 | 業務画面の共通ナビゲーション領域を描画するJSPおよびスタイル定義。[page_template_tag](ui-framework-jsp_page_templates.md) からインクルード。チュートリアルアプリケーションと同内容のためPJ側で修正が必要 |
| nablarch-template-app_header | アプリケーション共通ヘッダーサンプル | 必須 | 業務画面の共通ヘッダー領域を描画するJSPおよびスタイル定義。[page_template_tag](ui-framework-jsp_page_templates.md) からインクルード。PJ側で修正が必要 |
| nablarch-template-app_footer | アプリケーション共通フッターサンプル | 必須 | 業務画面の共通フッター領域を描画するJSPおよびスタイル定義。[page_template_tag](ui-framework-jsp_page_templates.md) からインクルード。PJ側で修正が必要 |
| nablarch-template-app_aside | アプリケーション共通サイドメニューサンプル | 必須 | 業務画面の共通サイドメニューを描画するJSPおよびスタイル定義。[page_template_tag](ui-framework-jsp_page_templates.md) からインクルード。PJ側で修正が必要 |
| nablarch-widget-slide_menu | スライドするメニューサンプル | 必須 | narrow/compact表示でメニューを省スペース化するサンプル機能。JavaScript/LESSの定義はそのまま利用可能だが、JSPはPJ側で修正が必要 |

<details>
<summary>keywords</summary>

nablarch-template-base, nablarch-template-page, nablarch-template-error, nablarch-template-head, nablarch-template-js_include, nablarch-template-app_nav, nablarch-template-app_header, nablarch-template-app_footer, nablarch-template-app_aside, nablarch-widget-slide_menu, ページテンプレート, レイアウトテンプレート, ナビゲーション, ヘッダー, フッター, サイドメニュー, base_layout_tag, page_template_tag, errorpage_template_tag

</details>
