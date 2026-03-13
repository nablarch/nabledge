# Nablarch 5u26 リリースノート

**公式ドキュメント**: [1](https://nablarch.github.io/docs/5u26/doc/application_framework/application_framework/libraries/data_io/data_format.html) [2](https://nablarch.github.io/docs/5u26/doc/application_framework/adaptors/router_adaptor.html) [3](https://nablarch.github.io/docs/5u26/doc/application_framework/application_framework/blank_project/addin_gsp.html) [4](https://nablarch.github.io/docs/5u26/doc/development_tools/ui_dev/index.html) [5](https://nablarch.github.io/docs/5u26/doc/development_tools/java_static_analysis/index.html#id6) [6](https://nablarch.github.io/docs/5u26/doc/development_tools/ui_dev/doc/development_environment/update_bundle_plugin.html)

## Nablarch 5u26 変更点

## アプリケーションフレームワーク

### No.1 JSON読み取り不具合修正（汎用データフォーマット）

- **種別**: 不具合
- **モジュール**: `nablarch-core-dataformat 1.3.5`（起因バージョン: 1.3.1 / 5u19）
- **本番への影響**: あり

JSON内の値（""で囲われた項目）が区切り文字（`:`、`[`、`{`、`,`）のみで、その後にデータが続く場合、値とJSON構文の区切り文字の区別ができず解析が失敗する不具合を修正。修正後は正常に値として解析可能。

NGになる例（":"の後にデータが続く）：`{"key1": ":", "key2": "value2"}`

OKになる例（":"の後にデータが続かない）：`{"key1": ":"}`

> **重要**: 本来は値として解析できることが正しい挙動。このようなJSONを読み込めるようになることでシステム影響がある場合、値を確認して受け入れないようにするなどの修正を行うこと。

参照: [汎用データフォーマット](https://nablarch.github.io/docs/5u26/doc/application_framework/application_framework/libraries/data_io/data_format.html)

### No.2 ルート定義ファイル再読込デフォルト値修正（ウェブアプリケーション）

- **種別**: 変更
- **モジュール**: `nablarch-single-module-archetype 5u26`（起因バージョン: 5u6）
- **本番への影響**: あり

ブランクプロジェクトの `env.properties` に含まれる `nablarch.routesMapping.checkInterval` プロパティのデフォルト値が誤っていた（0以上の値が設定されていた）。負の値を設定すると変更チェックと再読込が無効になるが、正の値が設定されており、コメントも誤っていた。修正後は `-1` に設定。

対象ファイル:
- ウェブアプリケーション: `src/env/prod/resources/env.properties`
- コンテナ用ウェブアプリケーション: `src/main/resources/env.properties`

> **重要**: 変更チェックと再読込を明示的に無効化したい場合は、対象の `env.properties` に `nablarch.routesMapping.checkInterval=-1` を設定すること。プロジェクトが依存するNablarchのバージョンアップを行っても動作に変更はないが、誤ったデフォルト設定に従って無効化を期待していた場合は実際の挙動と乖離がある。

参照: [ルーティングアダプタ](https://nablarch.github.io/docs/5u26/doc/application_framework/adaptors/router_adaptor.html)

### No.3 使用不許可APIツールバージョン更新

- **種別**: 変更
- **モジュール**: `nablarch-single-module-archetype 5u26`
- **本番への影響**: なし

No.6の対応に伴い、使用不許可APIツール（`nablarch-unpublished-api-checker 1.0.1`）のバージョンを更新。

### No.4 gsp-dba-maven-plugin Java 11以降依存ライブラリ追加

- **種別**: 変更
- **モジュール**: `nablarch-single-module-archetype 5u26`（起因バージョン: 5u18）
- **本番への影響**: なし

コンテナ用ブランクプロジェクトのMavenプロファイルにgsp-dba-maven-pluginの依存関係が不足していたため追加。
- コンテナ用ウェブアプリケーション: BACKUPプロファイル
- コンテナ用RESTfulウェブサービス: gspプロファイル

参照: [gsp-dba-maven-plugin](https://nablarch.github.io/docs/5u26/doc/application_framework/application_framework/blank_project/addin_gsp.html)

## UI開発基盤

### No.5 RequireJSバージョンアップ

- **種別**: 変更
- **モジュール**: `nablarch-plugin-bundle 1.0.7`、`nablarch-ui-development-template 1.1.4`
- **本番への影響**: なし

RequireJSの脆弱性対応として2.1.11から2.3.7へバージョンアップ。バージョンアップによりモジュールr.jsの仕様が変更になったため、既存の動作に合わせるためビルドスクリプトを修正。

> **重要**: UI開発基盤を使用する場合、RequireJSのバージョンはUI開発基盤自体で使用しているバージョンに強制される。プロジェクト側で独自に作成した機能がRequireJSを利用する場合、脆弱性のある機能を使用する危険性があるため本対応を実施した。UI開発基盤自体は本脆弱性の対象となる機能を使用していないため脆弱性はない。

参照: [UI開発基盤](https://nablarch.github.io/docs/5u26/doc/development_tools/ui_dev/index.html)

## Nablarch開発標準

### No.6 使用不許可APIチェックツール Java 21対応

- **種別**: 不具合
- **モジュール**: `nablarch-unpublished-api-checker 1.0.1`（起因バージョン: 1.0.0）
- **本番への影響**: なし

Java 21でバイトコードが変わったことにより、インタフェースから `java.lang.Object` のメソッドを呼んでいる場合、設定ファイルで指定しても許可されないという不具合を修正。

例：設定ファイルで `java.lang.Object` を許可指定しても、`Map<String, String> headers = request.headers(); headers.toString();` の `toString()` が不許可と判定される問題。

参照: [使用不許可APIチェックツール](https://nablarch.github.io/docs/5u26/doc/development_tools/java_static_analysis/index.html#id6)

<details>
<summary>keywords</summary>

JSON解析不具合, 汎用データフォーマット, nablarch.routesMapping.checkInterval, ルート定義ファイル再読込, RequireJS脆弱性対応, 使用不許可APIチェックツール, Java 21対応, nablarch-core-dataformat, nablarch-unpublished-api-checker, nablarch-single-module-archetype, nablarch-plugin-bundle, gsp-dba-maven-plugin, 5u26不具合修正

</details>

## バージョンアップ手順

5u26の適用手順:

1. `pom.xml` の `<dependencyManagement>` セクションに指定されている `nablarch-bom` のバージョンを `5u26` に書き換える
2. Mavenのビルドを再実行する

<details>
<summary>keywords</summary>

バージョンアップ手順, nablarch-bom, pom.xml, dependencyManagement, Mavenビルド, 5u26適用手順

</details>

## 標準プラグインの変更点（累積：1.4.2〜5u26）

UI開発基盤（標準プラグイン）の変更点の累積テーブル（1.4.2〜5u26）。

> **重要**: アップデートする場合は、対象のバージョンから今回のバージョンまでのリリースノートの「UI開発基盤（標準プラグイン）の変更点」を全て確認してバージョンアップを実施すること。

標準プラグインの取込方法: [Nablarch 標準プラグインの更新](https://nablarch.github.io/docs/5u26/doc/development_tools/ui_dev/doc/development_environment/update_bundle_plugin.html)

---

## バージョン 1.4.2

### No.1 スライドするメニューサンプルの追加

ナローまたはコンパクト表示に対応したスライドするメニューサンプルを追加。

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-widget-slide-menu | 1.0.0 | メニューのサンプル用のプラグインを追加 |
| nablarch-device-fix-ios | 1.1.0 | 入力時にトップナビを非表示にする機能をメニュー起動用のアイコンに適用 |
| nablarch-dev-ui_test-support | 1.1.0 | テスト用のメニューに新規追加されたテストページへのリンクを追加。ナビ配下にlogo画像を追加 |
| nablarch-device-fix-android_browser | 1.0.0 | android標準ブラウザでスクロールすると動作しない問題に対応するパッチを追加 |

### No.2 確認ダイアログ表示イベントアクションのデバイス依存不具合対応

確認ダイアログで「キャンセル」を選択した場合に、特定デバイス（iPad/iPhone）でトップナビやフッタが非表示となる不具合に対応。

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-widget-event-dialog | 1.0.1 | カスタムイベントを利用して自動計算が実行されるように修正（フォーカス制御による意図しない動作を排除） |
| nablarch-widget-event-autosum | 1.0.1 | カスタムイベントで自動計算が実行されるように修正 |

### No.3 サブウィンドウ内イベント連携機能のイベント監視対象の変更

他のドメインからアクセスがあった場合にサブウィンドウ連携機能でJavaScriptエラーが発生し、他の機能も動作しなくなる問題に対応。

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-widget-event-listen | 1.0.1 | 子画面のイベント監視でwindow.openerの情報を参照したときに発生した例外を無視するように修正 |

### No.4 UI開発基盤の導入手順外のパターンへの対応

初回ビルド時に既にプラグインが構成管理ツール（Subversion等）に追加済みの場合にもビルドが実行できるように対応。

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-dev-tool-uibuild | 1.0.1 | ui_build.jsを修正。pjconf.jsonの定義修正が必要（詳細はUI開発基盤解説書＞プラグインビルドコマンド仕様を参照） |

### No.5 Nablarch標準プラグインの更新手順を追加

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-dev-tool-update_support | 1.0.0 | 新規追加（PJのUI開発基盤への取込不要） |

---

## バージョン 5

### No.1 タグファイルで設定する変数のスコープを修正

ウィジェット内で変数をリクエストスコープで設定していたため、JSP内で利用するウィジェットの組合せにより意図しない挙動をする可能性があった（例：「ラベル表示用カラムウィジェット」に「表示項目ウィジェット」の内容が出力される）。タグファイル内で設定する変数のスコープをページスコープに修正。

対象プラグイン（全て同様の変更）: nablarch-dev-ui_test-support 1.1.1、nablarch-widget-box-img 1.0.1、nablarch-widget-button 1.0.1、nablarch-widget-column-checkbox 1.0.1、nablarch-widget-column-code 1.0.1、nablarch-widget-column-label 1.0.1、nablarch-widget-column-link 1.0.1、nablarch-widget-column-radio 1.0.1、nablarch-widget-event-dialog 1.0.3、nablarch-widget-event-toggle 1.0.1、nablarch-widget-field-base 1.0.1、nablarch-widget-field-block 1.0.1、nablarch-widget-field-calendar 1.0.1、nablarch-widget-field-checkbox 1.0.1

### No.2 event:confirmタグ内のattributeのtype属性を削除

event:confirmタグ内に不要なtype属性が指定されていたため、一部のアプリケーションサーバでJSP実行時エラーが発生していた問題を修正。

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-widget-event-dialog | 1.0.3 | confirm.tagのattributeアクションタグからFQCNでクラス名を記載していないtype属性を除去 |

---

## バージョン 5u6

### No.1〜4 各種変更

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-device-fix-base | 1.0.1 | 特定端末向けパッチプラグインの注意事項コメントを追加 |
| nablarch-dev-tool-server | 1.0.1 | テスト用簡易サーバーの提供形式変更（バイナリを削除し、ビルドスクリプトを追加） |
| nablarch-dev-ui_tool-form_gen-core | - | **「Form自動生成機能」の削除**（プラグイン削除） |
| nablarch-dev-ui_tool-form_gen-resource | - | **「Form自動生成機能」の削除**（プラグイン削除） |
| nablarch-dev-ui_tool-base-core | 1.0.1 | ソースコードのコメントを修正 |
| nablarch-dev-ui_tool-spec_view-core | 1.0.1 | Form自動生成機能のテストを削除 |
| nablarch-dev-ui_test-support | 1.1.2 | Form自動生成機能のテストページへのリンクを削除 |
| nablarch-dev-ui_demo-core | 1.0.1 | コンテキストメニューからForm自動生成・ドキュメントリンクを削除 |
| nablarch-dev-ui_demo-core-lib | 1.0.1 | 依存ライブラリのバージョン変更を反映 |
| nablarch-dev-ui_demo-config | 1.0.1 | ドキュメントリンクのリソースを削除 |

---

## バージョン 5u10

### No.1〜8 各種変更

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-widget-field-listbuilder | 1.0.2 | ポップアップ機能と併用した場合の不具合修正 |
| nablarch-ui-development-template | 1.1.0 | コンパクトモードで画像表示ウィジェットの画像が消えてしまう不具合修正 |
| nablarch-dev-tool-ui-build | 1.0.2 | UIビルドコマンド実行時に生成されるリソースに不要な文字列が出力される不具合修正 |
| nablarch-dev-tool-uibuild | 1.1.0 | **生成するCSSをminifyするように修正**、**プロダクション環境にリリースされるJSPの配置場所をWEB-INF配下に変更** |
| nablarch-dev-ui_demo-core-lib | 1.1.0 | JSP配置場所の変更に対応 |
| nablarch-dev-ui_test-support | 1.1.0 | JSP配置場所の変更に対応（※既存バージョンと同名のため注意） |
| nablarch-template-app_aside | 1.2.0 | JSP配置場所の変更に対応 |
| nablarch-template-app_footer | 1.1.0 | JSP配置場所の変更に対応 |
| nablarch-template-app_header | 1.1.0 | JSP配置場所の変更に対応 |
| nablarch-template-base | 1.1.0 | JSP配置場所の変更に対応 |
| nablarch-template-head | 1.1.0 | JSP配置場所の変更に対応 |
| nablarch-template-js_include | 1.1.0 | JSP配置場所の変更に対応 |
| nablarch-template-multicol-head | 1.1.0 | JSP配置場所の変更に対応 |
| nablarch-template-page | 1.1.0 | JSP配置場所の変更に対応 |
| nablarch-widget-event-listen | 1.1.0 | JSP配置場所の変更に対応 |
| nablarch-widget-slide-menu | 1.1.0 | JSP配置場所の変更に対応 |
| nablarch-widget-table-plain | 1.0.2 | resultSetName属性を指定せずにresultNumName属性を指定できない不具合修正 |
| nablarch-dev-ui_demo-core-lib | 1.1.1 | 画面モック起動時にthead/tbody/tfootタグがHTMLに表示されない不具合修正 |
| nablarch-dev-ui_demo-core | 1.0.2 | 同上 |
| nablarch-dev-tool-server | 1.0.2 | 動作確認用アプリケーションのハンドラ構成を最新化 |

---

## バージョン 5u13

### No.1〜4 テストコード修正

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-widget-event-dialog | 1.0.4 | ダイアログのテスト文言修正、ダイアログ(alert)用テスト画面で打鍵テストができない問題に対応 |
| nablarch-widget-field-listbuilder | 1.0.3 | リストビルダーの単体テスト期待値を修正 |
| nablarch-widget-field-file | 1.0.1 | ファイルアップロードの単体テスト期待値を修正 |

---

## バージョン 5u14

### No.1 jQueryのバージョンアップ（1.11.0 → 3.3.1）

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| UI開発基盤 | 1.0.2 | **依存するjQueryのバージョンを1.11.0から3.3.1に変更** |

### No.2〜33 jQuery 3系対応・その他修正

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| 開閉可能領域ウィジェット | 1.0.1 | jQuery3系で削除されたAPIを代替APIに変更 |
| ボタンウィジェット | 1.1.0 | キャンセルボタン・確認ボタンのアイコンを変更 |
| ios環境適合用プラグイン | 1.2.0 | ios10でiPadのviewportが動作しない問題に対応（Safari10以降のレイアウト崩れ対応） |
| UI部品単体テストサポートプラグイン | 1.2.1 | テスト時のサイドメニューのリンク切れを修正 |
| Ajaxリクエスト送信ウィジェット | 1.0.1 | 単体テストページを追加 |
| イベントウィジェット共通部品 | 1.0.1 | Ajaxリクエスト送信ウィジェットのテストページへのリンクを追加 |
| コード値表示用カラムウィジェット〜複数行入力項目ウィジェット（多数） | 各1.0.x | テストコードで使用していたjQueryの削除APIを代替APIに変更 |
| イベントリスナー定義ウィジェット | 1.1.1 | 不安定なテストの検証待ち時間を増加 |
| マルチカラムレイアウト用HTML headタグコンテンツ | 1.1.1 | テストコードでスクリプトレットコードが表示されていた問題を修正 |
| リンクウィジェット、変更不可項目ウィジェット等 | 1.0.1 | JSPローカル表示機能でパスの指定方法を修正 |

---

## バージョン 5u15

### No.1 jQueryのバージョンアップ（3.3.1 → 3.4.1）

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| UI開発基盤 | 1.0.4 | **依存するjQueryのバージョンを3.3.1から3.4.1に変更** |

---

## バージョン 5u18

### No.1 jQueryのバージョンアップ（3.4.1 → 3.5.1）

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| UI開発基盤 | 1.0.5 | **依存するjQueryのバージョンを3.4.1から3.5.1に変更** |

---

## バージョン 5u19

### No.1 jQueryのバージョンアップ（3.4.1 → 3.5.1）

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-ui-development-template | 1.1.3 | **依存するjQueryのバージョンを3.4.1から3.5.1に変更** |

---

## バージョン 5u26

### No.1〜2 RequireJSのバージョンアップ（2.1.11 → 2.3.7）

| プラグイン | バージョン | 変更概要 |
|---|---|---|
| nablarch-ui-development-template | 1.1.4 | 依存するRequireJSのバージョンを2.1.11から2.3.7に変更 |
| nablarch-dev-tool-uibuild | 1.1.1 | RequireJSのバージョンアップとそれに伴うビルドツールの改修 |

<details>
<summary>keywords</summary>

標準プラグイン, RequireJS, nablarch-ui-development-template, nablarch-dev-tool-uibuild, UI開発基盤プラグイン更新, 5u26プラグイン変更, jQuery, jQueryバージョンアップ, 1.11から3.3.1, 3.3.1から3.4.1, 3.4.1から3.5.1, 5u14 jQuery, 5u15 jQuery, 5u18 jQuery, 5u19 jQuery, Form自動生成機能削除, 5u6プラグイン, JSP WEB-INF配下, 5u10プラグイン, CSSミニファイ, タグファイル変数スコープ, 確認ダイアログ不具合, 1.4.2プラグイン, nablarch-widget-slide-menu, nablarch-widget-event-dialog, nablarch-widget-event-listen, nablarch-widget-field-listbuilder, nablarch-dev-tool-uibuild, 累積変更点, クロスバージョンアップグレード

</details>
