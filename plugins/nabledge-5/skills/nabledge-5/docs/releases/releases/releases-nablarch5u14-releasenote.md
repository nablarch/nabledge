# Nablarch 5u14 リリースノート

**公式ドキュメント**: [Nablarch 5u14 リリースノート](https://fintan.jp/page/252/)

## Nablarch 5u14 変更内容・脆弱性対応

## システムへの影響がある変更（本番）

### No.3 汎用データフォーマット XXE脆弱性対応

- モジュール: `nablarch-core-dataformat 1.2.2`（不具合起因バージョン: 1.4.0）
- 汎用データフォーマット機能のXML読み込み時にDTDが使用できなくなった
- DTDを使用したい場合は `allowDTD` プロパティを `true` に設定（デフォルト: `false`）。読み込み対象のXMLが信頼できる、かつDTD使用が必須の場合のみ許可すること
- 参照: https://nablarch.github.io/docs/5u14/doc/application_framework/application_framework/libraries/data_io/data_format.html

### No.4 メール送信機能デフォルト値修正

- モジュール: `nablarch-mail-sender 1.4.1`（不具合起因バージョン: 1.0.3 / Nablarch 5）
- デフォルト設定一覧（nablarch-default-configuration）を使用している場合は影響なし
- デフォルト設定一覧を使用していない、かつ以下の設定値をプロジェクト独自に設定していない場合は有効となっている値を明示的に設定すること:
  - メール送信先の区分値
  - メール送信ステータス
- 参照: https://nablarch.github.io/docs/5u14/doc/application_framework/application_framework/libraries/mail.html#mail-common-settings-mail-config

### No.5 HIDDENストア脆弱性対応

- モジュール: `nablarch-fw-web 1.5.1`, `nablarch-main-default-configuration 1.1.1`（不具合起因バージョン: 1.2.2 / Nablarch 5）
- HIDDENストアでHTMLに出力していた値の内容が変わる
- 修正前の値を期待してアプリケーションで処理している場合は処理の見直しが必要
- 参照: https://nablarch.github.io/docs/5u14/doc/application_framework/application_framework/libraries/session_store.html#session-store-hidden-store

### No.17 UI開発基盤 jQueryバージョンアップ

- モジュール: `nablarch-plugins-bundle 1.0.3`
- jQuery 1.11.0 → 3.3.1 へバージョンアップ
- UI開発基盤はこの脆弱性の対象機能を使用していないが、プロジェクト独自機能でjQueryを使用する場合に脆弱性のある機能を使う危険性があるため対応
- 標準プラグインの変更点シートを参照して対応が必要
- 参照: https://jvndb.jvn.jp/ja/contents/2015/JVNDB-2015-008097.html

### No.20 CSSフレームワーク ボタンアイコン変更

- モジュール: `nablarch-plugins-bundle 1.0.3`
- 確定ボタン: thumbs-up → check-square（Font Awesome）
- キャンセルボタン: thumbs-down → ban（Font Awesome）
- 従来のアイコンに戻す場合はプロジェクト用の `cancel.tag`・`confirm.tag` を作成して変更:
  - キャンセルボタン: 該当行のアイコン指定を `icon="fa fa-thumbs-down"` に変更 [cancel.tag L30](https://github.com/nablarch/nablarch-plugins-bundle/blob/master/node_modules/nablarch-widget-button/ui_public/WEB-INF/tags/widget/button/cancel.tag#L30)
  - 確定ボタン: 該当行のアイコン指定を `icon="fa fa-thumbs-up"` に変更 [confirm.tag L29](https://github.com/nablarch/nablarch-plugins-bundle/blob/master/node_modules/nablarch-widget-button/ui_public/WEB-INF/tags/widget/button/confirm.tag#L29)
- 参照: https://nablarch.github.io/docs/5u14/doc/development_tools/ui_dev/doc/internals/css_framework.html#id12

## JSPカスタムタグ listName プロパティの仕様（No.7）

以下のJSPカスタムタグの `listName` プロパティに空のリストをセットした場合、**画面上には何も出力されない**。この挙動は5u14でドキュメントに明記された仕様。

- `select` タグ
- `radioButtons` タグ
- `checkboxes` タグ

- モジュール: `nablarch-document 5u14`
- 参照: https://nablarch.github.io/docs/5u14/doc/application_framework/application_framework/libraries/tag/tag_reference.html

## マスタデータ投入ツール マルチスレッド非対応（No.24）

> **注意**: マスタデータ投入ツールおよびテスティングフレームワークはマルチスレッドに対応していない。並列テスト実行環境での使用は不可。

- モジュール: `nablarch-document 5u14`
- 参照: https://nablarch.github.io/docs/5u14/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/02_MasterDataSetup/01_MasterDataSetupTool.html

## 主な変更点（システム影響なし）

| No. | カテゴリ | 概要 | 修正後モジュール |
|---|---|---|---|
| 1 | ウェブアプリケーション専用インターセプター | UseToken.Impl の型引数誤り修正（誤: OnDoubleSubmission → 正: UseToken）（動作変更なし） | nablarch-fw-web 1.5.1 |
| 2 | 汎用ユーティリティ | モジュール依存関係修正。Base64Util を nablarch-fw から nablarch-core へ移動（動作変更なし） | nablarch-common-encryption 1.1.1, nablarch-fw 1.2.1, nablarch-core 1.4.1 |
| 6 | ウェブアプリケーション（Getting Started） | Getting Startedの一括登録機能ガイドのサンプルCSVファイル不備を修正 | nablarch-document 5u14 |
| 7 | JSPカスタムタグ（タグリファレンス） | listNameプロパティに空のリストをセットした場合に画面に何も出力しない旨を解説書に追記 | nablarch-document 5u14 |
| 8 | Nablarchバッチアーキタイプ | メール送信バッチ監視間隔設定値を1ミリ秒→1秒に修正（不具合起因: 5u5） | nablarch-batch 5u14 |
| 9 | RESTfulウェブサービスプロジェクト（アーキタイプ） | No.10に付随するJacksonモジュールバージョンアップ対応 | nablarch-jaxrs 5u14 |
| 10 | JAX-RSアダプタ | Jackson-databind 2.8.11.1 へバージョンアップ（CVE対応。最新の2.9系ではなく影響最小の2.8系脆弱性対応済バージョンを採用） | nablarch-jackson-adaptor 1.0.4, nablarch-jersey-adaptor 1.0.3, nablarch-resteasy-adaptor 1.0.3 |
| 11 | ETL | No.10に付随するJacksonモジュールバージョンアップ対応 | nablarch-etl 1.2.1 |
| 12 | Exampleウェブアプリケーション（JSP） | SignedInAdviceクラスのsetterの実装不備（値が正しく設定されない）を修正（不具合起因: 5u6） | nablarch-example-web 5u14 |
| 13 | ExampleRESTfulウェブサービス | 未使用のDateValueクラスを削除（不具合起因: 5u9） | nablarch-example-rest 5u14 |
| 14 | ExampleJSR352バッチ | メッセージプロパティの置換文字列定義誤記により置換文字列が埋め込まれない不具合を修正（不具合起因: 5u6） | nablarch-example-batch-ee 5u14 |
| 15 | Exampleウェブアプリケーション（JSP） | USER_SESSIONテーブルのSESSION_IDカラム定義をCHARからVARCHARに変更（不具合起因: 5u6） | nablarch-example-web 5u14 |
| 16 | ExampleウェブアプリケーションHTTPメッセージング受信 | No.11に付随するJacksonモジュールバージョンアップ対応 | nablarch-example-http-messaging 5u14 |
| 18 | UI開発基盤の導入（プロジェクトテンプレート） | .gitignoreの不備によりGit利用時にデモ用サーバ起動時エラーが発生する問題を修正（不具合起因: 5u6） | nablarch-ui-development-template 1.1.1 |
| 19 | UI開発基盤の展開 | 展開手順がSVNの利用を想定していることを追記。Git利用時はプロジェクト構成やコマンド名等を読み替える必要がある | nablarch-document 5u14 |
| 21 | UI部品ウィジェット機能テスト | 5u13でリリース漏れとなっていたテストコード修正（ダイアログ・リストビルダー・ファイルアップロード等）を取り込み（動作変更なし） | nablarch-plugins-bundle 1.0.3 |
| 22 | UI開発基盤テスト実施環境 | 動作確認環境デバイスのOSを最新化し解説書の一覧を更新 | nablarch-document 5u14 |
| 23 | UI開発基盤の導入（プラグインセットアップ） | サードパーティライブラリ取得手順に含まれていた不要な手順（配置済のes6-promise取得）を削除 | nablarch-plugins-bundle 1.0.3, nablarch-document 5u14 |
| 24 | マスタデータ投入ツール | マスタデータ投入ツールおよびテスティングフレームワークがマルチスレッド未対応の旨をドキュメントに追記 | nablarch-document 5u14 |

## バージョンアップ手順

1. `pom.xml` の `<dependencyManagement>` セクションの `nablarch-bom` バージョンを `5u14` に変更
2. Maven のビルドを再実行

## HIDDENストア脆弱性（詳細）

**対象バージョン**: Nablarch 5, 5u1〜5u13（1.4以前は対象外。HIDDENストア機能は Nablarch 5 からの追加機能）

**対象システム**: NablarchのHIDDENストアを使用しているWebアプリケーション（インターネット・イントラネット問わず）

**脆弱性の概要**: key-valueオブジェクトのvalueを個別に暗号化していたため、暗号化後の値の予測・編集が可能（改ざんの恐れ）

**システム影響**:
1. 不正なデータ更新: HIDDENストアの値をDB登録している場合、バリデーションNGの値が登録される恐れ（DB登録前にHIDDENストア取得値を再バリデーションしている場合は対象外）
2. 不正な画面操作: HIDDENストアの値を画面遷移や表示切替に使用している場合、本来不可能な操作をされる恐れ（認可制御を適用している場合は不正遷移を防止可能）

**改ざんの難易度**:
- 単一の値（`java.lang.String`、`java.lang.Integer` 等）を格納: 改ざんの可能性が高い。別の箇所で入手した値を流用した改ざんが容易。値の型が汎用的であるほど流用しやすい
- 複数の値を持つオブジェクト（Entity、DTO等）を格納: 改ざんの可能性が低い。オブジェクト全体の置き換えしかできず、バリデーション済みの不正状態のオブジェクト入手が困難

**修正内容**: value個別ではなくkey-valueオブジェクト全体で暗号化し、かつシステム利用者ごとに異なる情報で暗号化処理を実施

**対象クラス**: `nablarch.common.web.session.store.HiddenStore`（リポジトリ: nablarch-fw-web）
- 修正前: https://github.com/nablarch/nablarch-fw-web/blob/1.5.0/src/main/java/nablarch/common/web/session/store/HiddenStore.java
- 修正後: https://github.com/nablarch/nablarch-fw-web/blob/1.5.1/src/main/java/nablarch/common/web/session/store/HiddenStore.java

**対応方法**:
1. 基本: Nablarch 5u14 へバージョンアップ
2. バージョンアップが困難な場合の回避策:
   - HIDDENストアから取得した値を精査する処理を必ず実装する（改ざんリスクを想定した精査処理）
   - または 5u14 の `HiddenStore` を参考にプロジェクト側で脆弱性対応済の独自 `HiddenStore` を作成して使用（5u14 でしか動作検証していないため、使用する Nablarch バージョンで正常動作するか必ず検証すること）

## 汎用データフォーマット XXE脆弱性（詳細）

**対象バージョン**: 5系と1.4系の全バージョン

**対象システム**: 汎用データフォーマット機能を使用してXML文書を読み込んでいるシステム
- XML電文を受け取るHTTPメッセージングシステム
- XMLファイルを入力する処理（バッチ、画面等の処理形態に依存しない）

**脆弱性の概要**: XMLライブラリ（JAXP）でDTDがデフォルト有効のまま使用不可設定をしていなかったため、XXE攻撃を受ける可能性がある。攻撃により情報漏えいやシステム停止が発生する恐れ

**攻撃例**:
- ファイル読み取り: `<!ENTITY sc SYSTEM "file:///path/to/secret.txt">` のようなDTD定義でシステム内部ファイルを読み取り
- DoS攻撃: `<!ENTITY xxe SYSTEM "file:///dev/random">` のようなDTD定義で処理を停止させる

**修正内容**: DTDを明示的に使用不可に設定。DTDを含むXML文書が入力された場合は `nablarch.core.dataformat.InvalidDataFormatException` がスローされる（不正なフォーマットのXML文書入力時と同じ動作）

**対応方法**:
1. 基本: Nablarch 5u14 へバージョンアップ（DTD無効化によりXXE攻撃が無効）
2. DTDを意図的に使用している場合: XML Schema 等の代替技術へ置き換えること
3. バージョンアップが困難な場合: 「XXE攻撃を受ける可能性が全くない」と判断できる場合のみリスクを許容して対応不要という選択も可能（例: システム内部で作成したXMLのみ扱う、システム間で事前に取り決めたフォーマットだけを扱う）。ただし今後の改修で扱うXML種類が増える可能性や内部関係者による攻撃には対応できない

> **警告**: JDK6 6u65 未満、JDK7 7u6 b15 未満では DTD 無効化時に NullPointerException が発生するため、JDK のバージョンアップが必要。詳細: [JDK-7157610](https://bugs.java.com/bugdatabase/view_bug.do?bug_id=7157610)

## UI開発基盤 標準プラグインの変更点（5u14）

| No. | 変更概要 | プラグイン | バージョン | 変更内容 |
|---|---|---|---|---|
| 1 | jQueryバージョンアップ | UI開発基盤 | 1.0.2 | 依存するjQueryを1.11.0から3.3.1に変更 |
| 2 | jQuery3系で削除されたAPIの修正 | 開閉可能領域ウィジェット | 1.0.1 | 削除されたAPIを代替APIに変更 |
| 3 | ボタンアイコンの変更 | ボタンウィジェット | 1.1.0 | キャンセルボタン・確認ボタンのアイコンを変更 |
| 4 | iOS10でiPadのviewportが動作しない問題に対応 | ios環境適合用プラグイン | 1.2.0 | iPadでSafari10以降を使用している場合のレイアウト崩れに対応 |
| 5 | テスト時のサイドメニューリンク切れ修正 | UI部品単体テストサポートプラグイン | 1.2.1 | ボタン系ウィジェットへのリンク切れを修正 |
| 6 | 単体テストページの追加 | Ajaxリクエスト送信ウィジェット | 1.0.1 | テストコードに単体テスト用のページを追加 |
| 7 | 単体テストページの追加 | イベントウィジェット共通部品 | 1.0.1 | テストコードのAjaxリクエスト送信ウィジェットのテストページに遷移するリンクを追加 |
| 8 | jQuery3系で削除されたAPIの修正（テストコード） | コード値表示用カラムウィジェット | 1.0.2 | テストコードで使用していたjQueryの削除APIを代替APIに変更 |
| 9 | 同上 | ラベル表示用カラムウィジェット | 1.0.2 | 同上 |
| 10 | 同上 | リンク出力用カラムウィジェット | 1.0.2 | 同上 |
| 11 | 同上 | ダイアログ表示ウィジェット | 1.0.5 | 同上 |
| 12 | 同上 | チェックボックス入力項目ウィジェット | 1.0.2 | 同上 |
| 13 | 同上 | ファイル選択項目ウィジェット | 1.0.2 | 同上 |
| 14 | 同上 | ラベル表示ウィジェット | 1.0.2 | 同上 |
| 15 | 同上 | パスワード入力項目ウィジェット | 1.0.1 | 同上 |
| 16 | 同上 | プルダウン入力項目ウィジェット | 1.0.2 | 同上 |
| 17 | 同上 | ラジオボタン入力項目ウィジェット | 1.0.2 | 同上 |
| 18 | 同上 | 単行テキスト入力ウィジェット | 1.0.2 | 同上 |
| 19 | 同上 | 複数行入力項目ウィジェット | 1.0.1 | 同上 |
| 20 | 同上 | 検索結果表示テーブルプラグイン | 1.0.2 | 同上 |
| 21 | 不安定なテストの修正 | イベントリスナー定義ウィジェット | 1.1.1 | 自動テスト時に不安定だったテストがあったため、テストコードの検証の待ち時間を増加 |
| 22 | テストコードの不備を修正 | マルチカラムレイアウト用HTML headタグコンテンツ | 1.1.1 | テストコードのJSPローカル表示機能のテスト時にテストデータ構築用のスクリプトレットコードが表示されていたため、出力しないように修正 |
| 23 | JSPローカル表示がうまく動作しないテストを修正 | リンクウィジェット | 1.0.1 | テストコードの業務画面JSPローカル表示機能で動作しないため、パスの指定方法を修正 |
| 24 | 同上 | 変更不可項目ウィジェット | 1.0.1 | 同上 |
| 25 | 同上 | ツリーリスト表示テーブルプラグイン | 1.0.1 | テストコードの業務画面JSPローカル表示機能で動作しないため、パスの指定方法を修正 |
| 26 | 同上 | スライドするメニュー | 1.1.1 | テストコードの業務画面JSPローカル表示機能で動作しないため、明示的な閉じタグを設定 |
| 27 | 同上 | 自動集計機能 | 1.0.2 | テストコードの業務画面JSPローカル表示機能テスト時に実行できないページに遷移するため、リンク先を修正 |
| 28 | 同上 | カレンダー日付入力ウィジェット | 1.0.2 | テストコードの業務画面JSPローカル表示機能テスト時のリンク切れに対応。また、nameAlias属性のテストを追加 |
| 29 | テストコードの文言を修正 | ボタンウィジェット | 1.1.0 | テストコードのテストケースの文言誤りを修正 |
| 30 | 同上 | コンテンツ用表示領域ウィジェット | 1.0.1 | テストコードのテストケースの文言の誤りを修正。また検証対象がわかりやすいように文言を修正 |
| 31 | 同上 | タイトル用表示領域ウィジェット | 1.0.1 | 同上 |
| 32 | 不要なテスト資材を削除 | プロパティ切替ウィジェット | 1.0.2 | 「イベントウィジェット共通部品」と重複するテスト用のindexページがあるため、削除 |
| 33 | 同上 | 項目内容変更ウィジェット | 1.0.1 | 同上 |

5u13以前のバージョンから5u14へアップデートする場合は、対象バージョンから今回のバージョンまでの全リリースノートの「UI開発基盤（標準プラグイン）の変更点」を確認してバージョンアップを実施すること。

標準プラグインの取込方法: https://nablarch.github.io/docs/5u14/doc/development_tools/ui_dev/doc/development_environment/update_bundle_plugin.html

<details>
<summary>keywords</summary>

Nablarch 5u14, リリースノート, HIDDENストア脆弱性, XXE脆弱性, 汎用データフォーマット, セッションストア, メール送信 デフォルト値, jQuery バージョンアップ, Jackson バージョンアップ, nablarch-fw-web, nablarch-core-dataformat, nablarch-mail-sender, nablarch-jackson-adaptor, nablarch-jersey-adaptor, nablarch-resteasy-adaptor, nablarch-main-default-configuration, HiddenStore, InvalidDataFormatException, allowDTD, listName, selectタグ, radioButtonsタグ, checkboxesタグ, マスタデータ投入ツール, マルチスレッド, バージョンアップ手順, セキュリティ脆弱性対応, 5u13からの変更点, nablarch-plugins-bundle, nablarch-common-encryption, Base64Util, SignedInAdvice, DateValue, UseToken, OnDoubleSubmission, JAXP

</details>
