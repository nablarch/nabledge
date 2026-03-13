# Nablarch 5u19 リリースノート

**公式ドキュメント**: [1](https://fintan.jp/page/252/) [2](https://nablarch.github.io/docs/5u19/doc/application_framework/application_framework/libraries/repository.html#repository-user-environment-configuration) [3](https://nablarch.github.io/docs/5u19/doc/application_framework/application_framework/libraries/tag.html#dynamic-attribute) [4](https://nablarch.github.io/docs/5u19/doc/application_framework/application_framework/handlers/rest/cors_preflight_request_handler.html#cors-preflight-request-handler-setting) [5](https://nablarch.github.io/docs/5u19/doc/application_framework/application_framework/libraries/repository.html#listmap) [6](https://nablarch.github.io/docs/5u19/doc/application_framework/application_framework/cloud_native/distributed_tracing/index.html) [7](https://nablarch.github.io/docs/5u19/doc/application_framework/application_framework/nablarch/platform.html#id3) [8](https://nablarch.github.io/docs/5u19/doc/application_framework/adaptors/micrometer_adaptor.html) [9](https://nablarch.github.io/docs/5u19/doc/application_framework/adaptors/micrometer_adaptor.html#azure) [10](https://nablarch.github.io/docs/5u19/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/http_send_sync.html) [11](https://nablarch.github.io/docs/5u18/doc/development_tools/ui_dev/doc/development_environment/update_bundle_plugin.html)

## 5u19 変更点一覧

## Nablarch 5u19 変更点一覧（5u18からの変更）

### システムへの影響がある変更（本番）

**No.1 汎用データフォーマット: JSONの読み取り修正**
- モジュール: `nablarch-core-dataformat 1.3.1`（起因バージョン: 1.0.0〜1.4.0）
- > **重要**: 以下③④のケースに該当する値を扱うアプリは本番影響あり。これまで読み取られなかった値が読み取られるようになるため、アプリの要件を確認し修正すること。
- 修正ケース（詳細はs2参照）:
  - ①入れ子配列かつ内部配列がオブジェクトの最後の項目でない場合の実行時例外（本番影響なし）
  - ②オブジェクトの最後の項目の値が":"1文字の場合の実行時例外（本番影響なし）
  - ③オブジェクトの最後の項目の値が"{", "}", "[", "]"の1文字の場合に該当項目が読み取られない（**本番影響あり**）
  - ④配列の値が"}", "["の1文字の場合に該当配列要素が読み取られない（**本番影響あり**）

**No.3 ウェブアプリ/RESTfulウェブサービス: レスポンスボディ空の場合Content-Type未設定に変更**
- モジュール: `nablarch-fw-web 1.3.0`、`nablarch-fw-jaxrs 1.2.0`
- > **重要**: 以下のいずれかの場合に影響あり:
  - WebアプリでContent-Typeなしレスポンスを見るクライアント処理がある（ブラウザのみ使用の場合は影響なし）
  - RESTfulウェブサービスで5u18リリースノートのContent-Type後方互換維持設定（`setContentTypeForResponseWithNoBody`）を入れている（5u19で設定変更が必要）
- 互換性維持方法はs3参照

**No.4 システムリポジトリ: 存在しない環境依存値参照時に例外送出**
- モジュール: `nablarch-core-repository 1.6.0`
- > **重要**: コンポーネント定義で存在しない環境依存値を参照している場合、初期化失敗で異常終了する。起動ログに以下のWARNINGが出ているアプリは影響を受ける:
  ```
  property value was not found. parameter = ${XXXX}
  ```
  設定見直しができない場合は後方互換設定（s4参照）で従来動作に戻せる。
- 参照: https://nablarch.github.io/docs/5u19/doc/application_framework/application_framework/libraries/repository.html#repository-user-environment-configuration

### システムへの影響がある変更（開発）

**No.16 テスティングフレームワーク: Content-Typeなしレスポンスのダンプファイルに拡張子が付与されない**
- モジュール: `nablarch-testing 1.3.1`
- > **重要**: 以下を全て満たす場合に影響あり:
  - ボディがないレスポンスを返す処理がある
  - テスティングフレームワークで出力したダンプファイルを読み込んで何らかの処理をしている
  - 読み込み時に拡張子によって処理結果が変わる
- 影響がある場合はs3参照（Content-Typeの互換性維持設定）

### システムへの影響がない変更

| No. | カテゴリ | 内容 | モジュール |
|---|---|---|---|
| 2 | システムリポジトリ | バッチアプリのオブジェクト廃棄処理が実行されない問題修正（5u18で追加した廃棄処理がバッチのみ動作しなかった） | nablarch-fw-standalone 1.4.0 |
| 5 | JSPカスタムタグ | 動的属性対応（HTML5カスタムデータ属性出力可能化、HTML5追加のinput type属性に対応するカスタムタグ追加） | nablarch-fw-web-tag 1.3.0 |
| 6 | RESTfulウェブサービス | CORSプリフライトリクエスト判定からAccess-Control-Request-Headersヘッダ存在条件を除外（一部ブラウザが送信しないため）。判定条件: HTTPメソッド=OPTIONS、Originヘッダ存在、Access-Control-Request-Methodヘッダ存在 | nablarch-fw-jaxrs 1.2.0 |
| 7 | システムリポジトリ | list要素の値の型（文字列またはJava Beansオブジェクト）を解説書に追記 | - |
| 8 | クラウドネイティブ | AWS・Azureでの分散トレーシング方法のガイド追記 | - |
| 9 | 稼働環境 | テスト環境のAPサーバ・DB更新。データベース: Oracle Database 12c/19c、IBM Db2 10.5/11.5、SQL Server 2017/2019、PostgreSQL 10.0/11.5/12.2/13.2。アプリケーションサーバ: Oracle WebLogic Server 12.2.1.3、WebSphere Application Server 9.0.5、WildFly 23.0.0.Final、Apache Tomcat 9.0.24 | - |
| 10 | ブランクプロジェクト | jackson-databindをXXE脆弱性対応版(2.10.5.1)にアップ（nablarch-jackson-adaptor 1.0.7、nablarch-jersey-adaptor 1.0.6、nablarch-resteasy-adaptor 1.0.7、nablarch-etl 1.2.4、nablarch-testing-rest 1.0.1他）。**なおNablarchでは、jackson-databindの脆弱性に繋がる機能は使用していない。** | 複数 |
| 11 | ブランクプロジェクト | 環境設定ファイル拡張子をconfigからpropertiesに統一（推奨はpropertiesのため）。対象: nablarch-web 5u19、nablarch-jaxrs 5u19、nablarch-batch 5u19、nablarch-batch-ee 5u19、nablarch-container-web 5u19、nablarch-container-jaxrs 5u19 | nablarch-web 5u19他複数 |
| 12 | Micrometerアダプタ | メトリクス収集機能追加（HTTP処理時間/パーセンタイル、バッチ処理時間/件数、ログ出力回数、SQL処理時間、MBeanからの情報収集） | nablarch-core-applog 1.2.0、nablarch-fw 1.5.0、nablarch-fw-jaxrs 1.2.0、nablarch-micrometer-adaptor 1.1.0 |
| 13 | Micrometerアダプタ | Azure Application Insightsへのカスタムメトリクス送信対応 | nablarch-micrometer-adaptor 1.1.0 |
| 14 | Example | JUnit 4.13.1未満の一時ディレクトリ脆弱性対応（4.13.1にアップ。本番環境では影響なし）。対象: nablarch-testing 1.3.1、nablarch-testing-rest 1.0.1、sql-executor 1.3.0他 | nablarch-testing 1.3.1他 |
| 15 | UI開発基盤 | jQueryを3.5.1にバージョンアップ（新規導入用テンプレートのみ。既存導入済みプロジェクトへの影響なし） | nablarch-ui-development-template 1.1.3、nablarch-plugins-bundle 1.0.6 |
| 17 | テスティングフレームワーク | HTTP同期応答メッセージ送信処理のリクエスト単体テストにおける障害系テスト時の例外記載漏れを解説書に追記 | - |

<details>
<summary>keywords</summary>

JSONの読み取り失敗, Content-Type, 環境依存値 例外送出, 5u19変更点, リリースノート, システム影響, nablarch-core-dataformat, nablarch-fw-web, nablarch-core-repository, nablarch-fw-standalone, Micrometerアダプタ, jackson-databind XXE脆弱性, nablarch-fw-web-tag 動的属性, CORSプリフライト, nablarch-testing-rest, nablarch-etl, sql-executor, nablarch-batch-ee, nablarch-fw-jaxrs, nablarch-micrometer-adaptor, nablarch-testing

</details>

## JSONの読み取り失敗ケース詳細

## JSONの読み取り失敗ケース（nablarch-core-dataformat 5u19修正対象）

### ①入れ子配列でオブジェクトの最後の項目でない場合
- **影響（5u19修正前）**: 実行時例外が発生する
- 5u19修正後: 正しく読み取られる（アプリへの本番影響なし）

### ②オブジェクトの最後の項目の値が":"1文字の場合
- **影響（5u19修正前）**: 実行時例外が発生する
- ":"を値に持つ項目より後に項目がある場合は例外は発生しない（最後の項目のみNGだった）
- 5u19修正後: 正しく読み取られる（アプリへの本番影響なし）

### ③オブジェクトの最後の項目の値が"{", "}", "[", "]"の1文字の場合
- **影響（5u19修正前）**: 該当項目（keyも値も）が読み取られない。空のオブジェクトになる
- 最後の項目でなければ記述した通りに読み取られる
- > **重要**: 5u19修正後は読み取られるようになる。③に該当する値を扱うアプリは**本番影響あり**。アプリの要件確認・修正が必要

### ④配列の値が"}", "["の1文字の場合
- **影響（5u19修正前）**: 該当配列要素が読み取られない（空配列として読み取られる）
- > **重要**: 5u19修正後は読み取られるようになる。④に該当する値を扱うアプリは**本番影響あり**。アプリの要件確認・修正が必要

<details>
<summary>keywords</summary>

JSONの読み取り失敗, 入れ子配列, オブジェクト最後の項目, nablarch-core-dataformat, JSON解析バグ, 汎用データフォーマット, 配列要素 読み取られない

</details>

## Content-Typeの互換性維持方法

## Content-Typeの互換性維持方法

ボディが空の場合に自動でContent-Typeに`text/plain;charset=UTF-8`を付与するための互換性維持設定。

### 5u18のNo.6対応設定済みの場合
5u18で`JaxRsResponseHandler`の`setContentTypeForResponseWithNoBody`プロパティを設定している場合:
- > **重要**: このプロパティは5u19で**廃止**。コンポーネント定義から`setContentTypeForResponseWithNoBody`プロパティを削除すること。

### Content-Type互換性維持の設定方法（5u19以降）
`webConfig`コンポーネントを定義し、`addDefaultContentTypeForNoBodyResponse`プロパティに`true`を設定する。

<details>
<summary>keywords</summary>

Content-Type互換性, addDefaultContentTypeForNoBodyResponse, setContentTypeForResponseWithNoBody, JaxRsResponseHandler, webConfig, ボディ空レスポンス, text/plain;charset=UTF-8

</details>

## 環境依存値の設定方法（後方互換）

## 環境依存値の動作後方互換性維持方法

存在しない環境依存値をコンポーネント定義から参照した場合に、5u18以前と同様にWARNINGログを出力して環境依存値のキーを設定値に採用する方法。

### 設定方法
プロジェクトの環境設定ファイル（`common.properties`または`common.config`）に以下を追記する:

```
nablarch.diContainer.allowEmptyValue=true
```

<details>
<summary>keywords</summary>

環境依存値, 後方互換, allowEmptyValue, nablarch.diContainer.allowEmptyValue, common.properties, property value was not found, WARNINGログ

</details>

## バージョンアップ手順

## バージョンアップ手順

1. `pom.xml`の`<dependencyManagement>`セクションに指定されている`nablarch-bom`のバージョンを`5u19`に書き換える
2. Mavenのビルドを再実行する

<details>
<summary>keywords</summary>

バージョンアップ手順, nablarch-bom, pom.xml, 5u19適用手順, dependencyManagement

</details>

## UI開発基盤（標準プラグイン）の変更点

## UI開発基盤（標準プラグイン）の変更点

アップデートする場合は、対象バージョンから今回のバージョンまでのリリースノートの「UI開発基盤（標準プラグイン）の変更点」を**全て確認**してバージョンアップを実施すること。

標準プラグインの取込方法: https://nablarch.github.io/docs/5u18/doc/development_tools/ui_dev/doc/development_environment/update_bundle_plugin.html

---

### 1.4.2での変更

| No. | タイトル | 標準プラグイン | バージョン | 変更概要 |
|---|---|---|---|---|
| 1 | スライドするメニューサンプルの追加 | nablarch-widget-slide-menu | 1.0.0 | メニューのサンプル用のプラグインを追加 |
| 1 | スライドするメニューサンプルの追加 | nablarch-device-fix-ios | 1.1.0 | 入力時にトップナビを非表示にする機能をメニュー起動用アイコンに適用 |
| 1 | スライドするメニューサンプルの追加 | nablarch-dev-ui_test-support | 1.1.0 | テスト用メニューに新規テストページへのリンクを追加、ナビ配下にlogo画像を追加 |
| 1 | スライドするメニューサンプルの追加 | nablarch-device-fix-android_browser | 1.0.0 | android標準ブラウザでスクロールしないようにするパッチを追加 |
| 2 | 確認ダイアログ表示イベントアクションのディバイス依存不具合に対応 | nablarch-widget-event-dialog | 1.0.1 | フォーカス制御をカスタムイベント方式に変更し意図しない動作を修正 |
| 2 | 確認ダイアログ表示イベントアクションのディバイス依存不具合に対応 | nablarch-widget-event-autosum | 1.0.1 | カスタムイベントで自動計算が実行されるように修正 |
| 3 | サブウィンドウ内イベント連携機能のイベント監視対象の変更 | nablarch-widget-event-listen | 1.0.1 | window.opener参照時の例外を無視するよう修正（セキュリティ制約によるJSエラー回避） |
| 4 | UI開発基盤の導入手順外のパターンへの対応 | nablarch-dev-tool-uibuild | 1.0.1 | 初回ビルド時にプラグインが構成管理ツールに追加済みの場合もビルド実行できるように対応 |
| 5 | Nablarch標準プラグインの更新手順を追加 | nablarch-dev-tool-update_support | 1.0.0 | 新規追加（PJのUI開発基盤に取り込む必要なし） |

---

### Nablarch 5での変更

| No. | タイトル | 標準プラグイン | バージョン | 変更概要 |
|---|---|---|---|---|
| 1 | タグファイルで設定する変数のスコープを修正 | nablarch-dev-ui_test-support | 1.1.1 | タグファイル内変数スコープをリクエストスコープからページスコープに修正 |
| 1 | タグファイルで設定する変数のスコープを修正 | nablarch-widget-box-img〜nablarch-widget-field-calendar（計13プラグイン） | 1.0.1 | 同上 |
| 2 | event:confirmタグ内のattributeのtype属性を削除 | nablarch-widget-event-dialog | 1.0.3 | confirm.tagのattributeアクションタグの不正なtype属性を除去（一部APサーバで実行時エラーが発生していた） |

---

### 5u6での変更

| No. | タイトル | 標準プラグイン | バージョン | 変更概要 |
|---|---|---|---|---|
| 1 | 特定端末向けパッチプラグインの注意事項を記載 | nablarch-device-fix-base | 1.0.1 | コメントを追加 |
| 2 | Nablarch UI開発基盤 テスト用簡易サーバーの提供形式を変更 | nablarch-dev-tool-server | 1.0.1 | バイナリを削除し、ビルドスクリプトを追加 |
| 3 | 「Form自動生成機能」の削除 | nablarch-dev-ui_tool-form_gen-core | - | プラグインを削除 |
| 3 | 「Form自動生成機能」の削除 | nablarch-dev-ui_tool-form_gen-resource | - | プラグインを削除 |
| 3 | 「Form自動生成機能」の削除 | nablarch-dev-ui_tool-base-core | 1.0.1 | ソースコードのコメントを修正 |
| 3 | 「Form自動生成機能」の削除 | nablarch-dev-ui_tool-spec_view-core | 1.0.1 | 当該機能のテストを削除 |
| 3 | 「Form自動生成機能」の削除 | nablarch-dev-ui_test-support | 1.1.2 | 当該機能のテストページへのリンクを削除 |
| 3 | 「Form自動生成機能」の削除 | nablarch-dev-ui_demo-core | 1.0.1 | コンテキストメニューからリンクを削除 |
| 3 | 「Form自動生成機能」の削除 | nablarch-dev-ui_demo-core-lib | 1.0.1 | 依存ライブラリのバージョン変更を反映 |
| 4 | 「ローカル画面表示からドキュメントへのリンク」機能の削除 | nablarch-dev-ui_demo-core | 1.0.1 | コンテキストメニューからリンクを削除 |
| 4 | 「ローカル画面表示からドキュメントへのリンク」機能の削除 | nablarch-dev-ui_demo-config | 1.0.1 | ドキュメントリンクのリソースを削除 |

---

### 5u10での変更

| No. | タイトル | 標準プラグイン | バージョン | 変更概要 |
|---|---|---|---|---|
| 1 | ポップアップ機能と併用した場合の不具合に対応 | nablarch-widget-field-listbuilder | 1.0.2 | 不具合修正 |
| 2 | 画像表示ウィジェットをコンパクトモードで表示した際に画像が消えてしまう不具合に対応 | nablarch-ui-development-template | 1.1.0 | 不具合修正 |
| 3 | UIビルドコマンドの実行時に生成されるリソースに不要な文字列が出力されることがある不具合を修正 | nablarch-dev-tool-ui-build | 1.0.2 | 不具合修正 |
| 4 | 生成するCSSをminifyするように修正 | nablarch-dev-tool-uibuild | 1.1.0 | CSSのサイズをminifyするよう変更 |
| 5 | プロダクション環境にリリースされるJSPの配置場所をWEB-INF配下に変更 | nablarch-dev-tool-uibuild他複数 | 1.1.0 | JSPの配置場所の変更 |
| 6 | resultSetName属性を指定せずにresultNumName属性を指定できない不具合に対応 | nablarch-widget-table-plain | 1.0.2 | 不具合修正 |
| 7 | 画面モック起動時にthead, tbody, tfootタグがHTMLに表示されない不具合に対応 | nablarch-dev-ui_demo-core-lib | 1.1.1 | 不具合修正 |
| 7 | 画面モック起動時にthead, tbody, tfootタグがHTMLに表示されない不具合に対応 | nablarch-dev-ui_demo-core | 1.0.2 | 不具合修正 |
| 8 | 動作確認用アプリケーションのハンドラ構成を最新化 | nablarch-dev-tool-server | 1.0.2 | ハンドラ構成の最新化 |

---

### 5u13での変更

| No. | タイトル | 標準プラグイン | バージョン | 変更概要 |
|---|---|---|---|---|
| 1 | ダイアログのテストで表示される文言を修正 | nablarch-widget-event-dialog | 1.0.4 | テストコードの文言修正 |
| 2 | ダイアログ(alert)用のテスト画面で打鍵テストができない問題に対応 | nablarch-widget-event-dialog | 1.0.4 | テストコード修正 |
| 3 | リストビルダーの単体テストの期待値を修正 | nablarch-widget-field-listbuilder | 1.0.3 | テストコードの文言修正 |
| 4 | ファイルアップロードの単体テストの期待値を修正 | nablarch-widget-field-file | 1.0.1 | テストコードの文言修正 |

---

### 5u14での変更

| No. | タイトル | 標準プラグイン | バージョン | 変更概要 |
|---|---|---|---|---|
| 1 | jQueryのバージョンをアップデート | UI開発基盤 | 1.0.2 | 依存するjQueryのバージョンを1.11.0から3.3.1に変更 |
| 2 | jQuery3系で削除されたAPIの修正 | 開閉可能領域ウィジェット | 1.0.1 | 削除されたAPIを代替APIに変更 |
| 3 | ボタンアイコンの変更 | ボタンウィジェット | 1.1.0 | キャンセルボタン、確認ボタンのアイコンを変更 |
| 4 | ios10でiPadのviewportが動作しない問題に対応 | ios環境適合用プラグイン | 1.2.0 | iPadでSafari10以降を使用している場合に発生するレイアウト崩れに対応 |
| 5 | テスト時のサイドメニューのリンク切れを修正 | UI部品単体テストサポートプラグイン | 1.2.1 | ボタン系ウィジェットへのリンク切れを修正 |
| 6〜7 | 単体テストページの追加 | Ajaxリクエスト送信ウィジェット、イベントウィジェット共通部品 | 1.0.1 | テストコードに単体テスト用のページを追加 |
| 8〜20 | jQuery3系で削除されたAPIの修正（テストコード） | 各種ウィジェット（コード値表示用カラム、ラベル表示用カラム、リンク出力用カラム、ダイアログ表示、チェックボックス、ファイル選択、ラベル表示、パスワード、プルダウン、ラジオボタン、単行テキスト、複数行テキスト、検索結果表示テーブル） | 各1.0.1〜1.0.2 | テストコードで使用していたjQueryの削除APIを代替APIに変更 |
| 21 | 不安定なテストの修正 | イベントリスナー定義ウィジェット | 1.1.1 | テスト検証の待ち時間を増加 |
| 22 | テストコードの不備を修正 | マルチカラムレイアウト用HTML headタグコンテンツ | 1.1.1 | テストコードのスクリプトレットコードが表示されていた問題を修正 |
| 23〜26 | JSPローカル表示がうまく動作しないテストを修正 | リンクウィジェット、変更不可項目ウィジェット、ツリーリスト表示テーブルプラグイン、スライドするメニュー | 各1.0.1〜1.1.1 | パスの指定方法や明示的な閉じタグを修正 |
| 27〜28 | テストコードの不備を修正 | 自動集計機能、カレンダー日付入力ウィジェット | 各1.0.2 | リンク先修正、nameAlias属性テスト追加 |
| 29〜31 | テストコードの文言を修正 | ボタンウィジェット、コンテンツ用表示領域ウィジェット、タイトル用表示領域ウィジェット | 各1.0.1〜1.1.0 | テストケースの文言誤りを修正 |
| 32〜33 | 不要なテスト資材を削除 | プロパティ切替ウィジェット、項目内容変更ウィジェット | 各1.0.1〜1.0.2 | 重複するテスト用indexページを削除 |

---

### 5u15での変更

| No. | タイトル | 標準プラグイン | バージョン | 変更概要 |
|---|---|---|---|---|
| 1 | jQueryのバージョンをアップデート | UI開発基盤 | 1.0.4 | 依存するjQueryのバージョンを3.3.1から3.4.1に変更 |

---

### 5u18での変更

| No. | タイトル | 標準プラグイン | バージョン | 変更概要 |
|---|---|---|---|---|
| 1 | jQueryのバージョンをアップデート | UI開発基盤 | 1.0.5 | 依存するjQueryのバージョンを3.4.1から3.5.1に変更 |

---

### 5u19での変更

| No. | タイトル | 標準プラグイン | バージョン | 変更概要 |
|---|---|---|---|---|
| 1 | jQueryのバージョンをアップデート | nablarch-ui-development-template | 1.1.3 | 依存するjQueryのバージョンを3.4.1から3.5.1に変更（新規導入用テンプレートのみ。既存導入済みプロジェクトへの影響なし） |

<details>
<summary>keywords</summary>

UI開発基盤, 標準プラグイン, jQuery, nablarch-ui-development-template, プラグイン変更点, jQueryバージョンアップ, 3.5.1, nablarch-plugins-bundle, nablarch-widget, UIプラグイン累積変更

</details>
