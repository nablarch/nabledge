# Nablarch 5u10 リリースノート

**公式ドキュメント**: [Nablarch 5u10 リリースノート](https://fintan.jp/page/252/)

## システムへの影響がある変更点（5u10）

Nablarch 5u10で既存システムへの影響がある変更点です。5u9からアップグレード時に必ず確認してください。

## BeanUtil: List・Array型のコピー対応（No.2）

**モジュール**: nablarch-core-beans 1.2.0（起因バージョン: 1.0.0(5)）

**影響対象**: `ConversionManager`の実装クラスを`BasicConversionManager`から独自クラスに差し替えているプロジェクト

**対処**: 追加メソッド`getExtensionConvertor`を実装する必要があります。
- 従来の振る舞いを維持する場合: `getExtensionConvertor`で空のListを返す
- List・任意の配列型をサポートする場合: `BasicConversionManager`を参考に実装

## BeanUtil: Timestampコピー時の精度損失（No.3）

**モジュール**: nablarch-core-beans 1.2.0（起因バージョン: 1.0.0(5)）

**影響対象**: Timestamp型同士の比較でミリ秒以下の精度が0であることを期待している処理

**対処**: `getTime` APIを使用して桁を丸める必要があります。

## セッションストア暗号化設定不備（No.4）

**モジュール**: nablarch-default-configration 1.0.5（起因バージョン: 1.0.4(5u6)）

**変更内容**: HTTPセッションストアとDBストアに格納されるセッション内容が暗号化されなくなりました。

> **重要**: 暗号化が必要な場合は、アプリケーションでセッションストアの設定をオーバーライドしてください。

## メッセージング: タイムアウトログメッセージ変更（No.11）

**モジュール**: nablarch-fw-messaging 1.1.0

**変更内容**:
- 変更前: `response timeout: could not receive a reply to the message below within (値)msec.`
- 変更後: `response timeout: could not receive a reply to the message below.`

> **重要**: タイムアウト時のログメッセージを監視している場合は、監視設定のメッセージ内容の修正が必要です。

## HIDDENストア暗号化鍵設定（No.15）

**モジュール**: nablarch-common-encryption 1.0.2（起因バージョン: 1.0.0(5)）

**変更内容**: HIDDENストアの暗号化鍵・IVにBASE64エンコードした値を設定可能になりました（従来は文字として利用可能な値のみで鍵強度に問題がありました）。

> **重要**: 鍵の強度設定を変更したい場合は、ドキュメント「セッション変数の改竄を防止する」を参照してください。

<details>
<summary>keywords</summary>

システムへの影響あり, BeanUtil, ConversionManager, BasicConversionManager, getExtensionConvertor, Timestamp精度, セッションストア暗号化, nablarch-default-configration, タイムアウトログメッセージ, HIDDENストア鍵設定, nablarch-common-encryption, 移行注意事項, アップグレード

</details>

## アプリケーションフレームワーク 変更・修正

## 汎用ユーティリティ（nablarch-core-beans 1.2.0）

- No.1 [変更] BeanUtilでコピー先プロパティが存在しない場合、デバッグログにスタックトレースを出力しないよう修正（メッセージのみ出力）
- No.2 [不具合] BeanUtilでList・任意の配列型のコピーに対応（**システムへの影響あり** → s1参照）
- No.3 [不具合] BeanUtilでTimestampコピー時のμs以下精度損失問題を修正（**システムへの影響あり** → s1参照）

## デフォルトコンフィグレーション（nablarch-default-configration 1.0.5）

- No.4 [不具合] セッションストア暗号化設定不備修正（**システムへの影響あり** → s1参照）
- No.5 [不具合] タグライブラリ用日付フォーマッタに年月フォーマッタ(yyyymm)を追加

## RESTfulウェブサービス（nablarch-fw-jaxrs 1.0.3）

- No.6 [不具合] JAX-RSリソースクラス(アクションクラス)のメソッドにInterceptorを設定可能に修正（起因: 1.0.0(5u6)）

## システムリポジトリ（nablarch-core-repository 1.2.0）

- No.7 [変更] コンポーネント定義で`IgnoreProperty`アノテーション付きsetterに値のインジェクションが行われた場合にワーニングログを出力

## バッチ

- No.8 [不具合] `FileDataReader`のJavadocにファイルなし・空ファイル時の振る舞いを追記 (nablarch-fw-batch 1.2.2、起因: 1.0.0(5))
- No.9 [変更] JSR352バッチの特定ステップにステップレベル・itemWriterレベルのリスナーを指定可能に (nablarch-fw-batch-ee 1.2.0)
- No.10 [不具合] プロセス起動直後の例外発生時に障害通知ログが出力されない問題を修正 (nablarch-fw-standalone 1.1.3、起因: 1.0.0(5))

## メッセージング（nablarch-fw-messaging 1.1.0）

- No.11 [変更] タイムアウト時のログメッセージ変更（**システムへの影響あり** → s1参照）

## 汎用データフォーマット（nablarch-core-dataformat 1.2.0）

- No.12 [変更] プロジェクト独自フィールドタイプの追加を容易に対応。デフォルトのフィールドタイプを設定ファイルに全て定義する必要がなくなりました。

## BeanValidation（nablarch-core-validation-ee 1.0.6）

- No.13 [不具合] `@SystemChar`アノテーションをコンストラクタ・パラメータ・アノテーションにも設定可能に修正（起因: 1.0.0(5u3)）

## データベースアクセス（nablarch-core-jdbc 1.2.1）

- No.14 [不具合] 以下のメソッドを非公開APIから公開APIに変更:
  - `nablarch.core.db.statement.ResultSetIterator#close`
  - `nablarch.core.db.statement.ResultSetIterator#getMetaData`

## セッションストア

- No.15 [不具合] HIDDENストア暗号化鍵設定問題（**システムへの影響あり** → s1参照）(nablarch-common-encryption 1.0.2)
- No.16 [不具合] PostgreSQL使用時のdb-store保存で一意制約違反が発生する問題を修正 (nablarch-fw-web-dbstore 1.0.4、起因: 1.0.0(5))

## JSPカスタムタグ（nablarch-fw-web-tag 1.0.7）

- No.17 [不具合] ノーマライズハンドラ使用時にリクエストパラメータに空文字が含まれているとn:formタグでNullPointerExceptionが発生する問題を修正（起因: 1.0.0(5)）

## ブランクプロジェクト

- No.32 [不具合] ウェブプロジェクトの`nablarch.customTagConfig.displayMethod`設定値を`DISABLED`→`NORMAL`に変更 (nablarch-web-archetype 5u10、起因: 5u5)
- No.33 [変更] バッチプロジェクトのビルド時に依存ライブラリをコピーするコマンドを修正。オプションはpom.xml内で定義するよう変更 (nablarch-batch-ee-archetype 5u10、nablarch-batch-archetype 5u10)
- No.34 [変更] バッチプロジェクトのビルド手順をExec Maven Plugin・Maven Assembly Pluginを使用した起動例に変更

<details>
<summary>keywords</summary>

アプリケーションフレームワーク, nablarch-core-beans, BeanUtil, IgnoreProperty, FileDataReader, JSR352リスナー, nablarch-fw-batch-ee, nablarch-fw-messaging, nablarch-core-dataformat, SystemChar, ResultSetIterator, nablarch-fw-web-dbstore, PostgreSQL一意制約, n:formタグ, NullPointerException, displayMethod, nablarch-web-archetype, nablarch-core-repository, nablarch-fw-standalone, nablarch-fw-jaxrs, nablarch-core-validation-ee, nablarch-fw-web-tag, Interceptor

</details>

## ドキュメントで追記された制約・注意事項

5u10でドキュメントに追記された重要な制約・注意事項です。

## ウェブ（nablarch-fw-web 1.4.1）

- No.18 `ResourceLocator`のclasspathスキームはファイルシステム上に存在していることが必要です。環境差異により問題が出る可能性があるため、**fileスキームの使用を推奨します**。

## 汎用データフォーマット

- No.19 アプリケーション側で入出力値を事前にチェックする必要があります。不正な値が設定されていると正しく変換処理が行われない可能性があります。
- No.20 CSVファイル読み込み時のクォート文字の扱いを追記（Variable形式で指定可能なディレクティブ一覧）

## タグライブラリ・JSPカスタムタグ

- No.21 **hidden暗号化と`<%@ page session="false" %>`は併用不可**。hidden暗号化はhttpセッションを必要とするため、`session="false"`と組み合わせると実行時に例外が発生します。
- No.22 「入力画面と確認画面を共通化する」章に入力系タグの表示制御対象および一部異なる動作をするタグを追記
- No.23 decimalフォーマットは`java.text.DecimalFormat`のデフォルト丸め動作を使用します。丸め処理が必要な場合はアプリケーション側で実装してください。

## バッチ

- No.24 JSR352・Nablarchバッチアプリケーションで悲観的ロックを実現するための実装例を追記

## ユニバーサルDAO

- No.25 **UniversalDaoはBeanのプロパティへの値の自動設定を行いません**。値の自動設定が必要な場合はデータベースアクセス(JDBCラッパー)を使用してください。

## JAX-RSレスポンスハンドラ

- No.26 エラー発生時のレスポンス生成処理の拡張例を追記:
  - エラー時のレスポンスにメッセージを設定する
  - 特定エラーの場合に個別定義したエラーレスポンスを返す

## RESTfulウェブサービス

- No.27 **ETagやIf-Matchを使用した楽観的ロックには対応していません**。楽観的ロックを行う場合はリクエストボディに直接バージョン番号を設定して実現します。

## Nablarchカスタムタグ制御ハンドラ

- No.28 **hidden暗号化機能を使用する場合、スレッドコンテキストハンドラが必要です**（リクエストIDの取得に使用するため）。

## マルチスレッド実行制御ハンドラ

- No.29 サブスレッドで例外が発生した場合、他のすべてのサブスレッドは処理を強制的に終了します。サブスレッドごとにトランザクション管理している場合の動作も追記。

## ログ出力

- No.30 ログの初期化メッセージを出力しないようにするための拡張例を追記

## システムリポジトリ

- No.31 DIコンテナのcomponentタグの`autowireType`属性に関する説明を追記

<details>
<summary>keywords</summary>

ResourceLocator, classpathスキーム, 汎用データフォーマット制約, hidden暗号化, session=false, decimalフォーマット, 悲観的ロック, UniversalDAO自動設定不可, JAX-RSレスポンスハンドラ拡張, ETag楽観的ロック非対応, スレッドコンテキストハンドラ, マルチスレッド実行制御ハンドラ, autowireType, ログ初期化メッセージ, java.text.DecimalFormat

</details>

## アダプタ・UI開発基盤・テスティングフレームワーク・その他 変更点

## アダプタ

### Domaアダプタ（nablarch-doma-adaptor 1.0.0）新規追加

- No.35 [追加] OSSのDBアクセスフレームワーク「Doma」をNablarchで使用するためのDomaアダプタを新規追加

### アダプタ全般（nablarch-jackson-adaptor 1.0.3）

- No.36 [変更] テストで使用したライブラリのスコープ変更。アダプタをdependenciesに追加するとテストで使用したOSSが依存ライブラリに自動追加されます（商用ライブラリwmqは除く）。

## Exampleアプリケーション

- No.37 [変更] スタンドアロン型アプリケーションの起動例をExec Maven Plugin・Maven Assembly Pluginを使用した方法に変更（各スタンドアロン系Example 5u10）
- No.38 [変更] ウェブアプリケーションで通知メッセージ表示にn:errorsタグを使用しないよう修正 (nablarch-example-web 5u10)

## UI開発基盤

### バグ修正

- No.39 [不具合] リストビルダーとポップアップ機能を併用した際に選択済み要素が非表示となる問題を修正 (nablarch-widget-field-listbuilder 1.0.2、起因: 1.0.0) ※Chrome・Firefoxで確認
- No.40 [不具合] 画像表示ウィジェットのコンパクトモードで画像が消える問題を修正 (nablarch-ui-development-template 1.1.0、起因: 1.0.1)
- No.41 [不具合] UIビルドコマンド実行時に生成リソース(compact.css等)に不要な文字列が出力される問題を修正 (nablarch-dev-tool-ui-build 1.0.2、起因: 1.0.0) ※Node.js 0.10.26では発生しない
- No.44 [不具合] 一覧テーブルで`resultNumName`属性のみ指定した場合にエラーが発生する問題を修正 (nablarch-widget-table-plain 1.0.2、起因: 1.0.0)
- No.45 [不具合] 画面モック起動時にthead/tbody/tfootタグがHTMLに表示されない問題を修正 (nablarch-dev-ui_demo-core-lib 1.1.1・nablarch-dev-ui_demo-core 1.0.2、起因: 1.0.0)

### 機能変更

- No.42 [変更] ビルド時に生成されるCSSをminify処理（ファイルサイズ削減）(nablarch-dev-tool-uibuild 1.1.0)
- No.43 [変更] プロダクション環境にリリースされるJSPの配置場所をWEB-INF配下に変更 (nablarch-dev-tool-uibuild 1.1.0他多数)
- No.46 [変更] UI動作確認用アプリケーションのハンドラ構成を最新化 (nablarch-dev-tool-server 1.0.2)

### 制約事項

- No.47 `event:confirm`タグと`button`タグの組み合わせでローカルJSPレンダリング機能を実行すると確認ダイアログのキャンセル処理が動作しません。その場合はサーバー表示機能を使用してください。
- No.48 イベント関連のUI部品・JavaScript部品はローカルレンダリングでの動作が不安定（ブラウザによって異なる）なため、サーバーにデプロイして確認してください。

## テスティングフレームワーク（nablarch-testing 1.1.0）

### バグ修正

- No.49 [不具合] MockMessagingClient・RequestTestingMessagingClientでログの文字化けを修正（起因: 1.0.0(5)）
- No.50 [不具合] `DbAccessTestSupport#rollbackTransactions`をpublicメソッドに変更（テストコードからトランザクション制御が可能に）（起因: 1.0.0(5)）
- No.51 [不具合] マスタデータ復旧機能で変更されていないテーブルも復旧対象として検知してしまう問題を修正（起因: 1.0.0(5)）

### 機能変更

- No.52 [変更] リクエスト単体テスト実行時のシート名指定を任意に変更（省略時はテストメソッド名と同名のシートを使用）

### ドキュメント（重要な注意事項）

- No.53 テストデータで複数のデータタイプやグループを使用する場合の注意事項を追加。守らないとテストデータが正しく読み込まれない可能性があります。
- No.54 外部キーを持つテーブルへのデータセットアップ方法の説明を追加

## ツールボックス・Nablarch実装例集・Nablarch開発標準

- No.55 [変更] SQL ExecutorはIN句の条件設定およびWITH句から始まるSQLを実行できません（制約として追記）
- No.56 [変更] CAPTCHA機能サンプル: 認証エラー時にCAPTCHA画像を再取得する方法を追記
- No.57 [変更] Shell Script自動生成ツールのタイムスタンプフォーマット統一（`y/%m/%d %H:%M:%S` → `Y/%m/%d %H:%M:%S`）
- No.58 [不具合] Shell Script自動生成ツールでJVMオプションを改行で複数指定した場合にスペースが挿入されない問題を修正
- No.59 [変更] ドメイン定義書出力時にドメインのデータ型を出力するよう改善
- No.60 [不具合] テーブル定義書ドメイン定義書整合性チェックツールが正常に動作しない問題を修正（メソッド呼び出し誤りを修正）
- No.61 [変更] Object Browser ER v9.0.0対応: テーブル定義書出力時に桁数が未指定の場合に空文字が出力されることを想定したチェックロジックに変更

<details>
<summary>keywords</summary>

Domaアダプタ, nablarch-doma-adaptor, リストビルダー, nablarch-widget-field-listbuilder, UIビルドコマンド, nablarch-dev-tool-ui-build, nablarch-dev-tool-uibuild, nablarch-ui-development-template, nablarch-widget-table-plain, MockMessagingClient, RequestTestingMessagingClient, DbAccessTestSupport, rollbackTransactions, マスタデータ復旧, リクエスト単体テストシート名, SQL Executor制約, nablarch-testing, テスティングフレームワーク, nablarch-jackson-adaptor

</details>

## バージョンアップ手順・標準プラグインの変更点

## バージョンアップ手順

1. pom.xmlの`<dependencyManagement>`セクションに指定されているnablarch-bomのバージョンを**5u10**に書き換える
2. mavenのビルドを再実行する

## 標準プラグインの変更点（UI開発基盤）

UI開発基盤を導入済みのプロジェクトは、以下のプラグインをバージョンアップしてください。取込方法: Nablarch UI開発基盤 解説書 > 開発作業手順 > Nablarch 標準プラグインの更新

| No. | 変更内容 | 標準プラグイン | バージョン |
|---|---|---|---|
| 1 | ポップアップ機能との併用不具合修正 | nablarch-widget-field-listbuilder | 1.0.2 |
| 2 | 画像表示ウィジェット不具合修正 | nablarch-ui-development-template | 1.1.0 |
| 3 | UIビルドコマンド不具合修正 | nablarch-dev-tool-ui-build | 1.0.2 |
| 4 | CSS minify対応 | nablarch-dev-tool-uibuild | 1.1.0 |
| 5 | JSP配置場所をWEB-INF配下に変更 | nablarch-dev-tool-uibuild他多数 | 1.1.0 |
| 6 | resultNumName属性のみ指定時の不具合修正 | nablarch-widget-table-plain | 1.0.2 |
| 7 | thead/tbody/tfoot表示不具合修正 | nablarch-dev-ui_demo-core-lib / nablarch-dev-ui_demo-core | 1.1.1 / 1.0.2 |
| 8 | ハンドラ構成の最新化 | nablarch-dev-tool-server | 1.0.2 |

<details>
<summary>keywords</summary>

バージョンアップ手順, nablarch-bom, 5u10, 標準プラグイン更新, pom.xml dependencyManagement, UI開発基盤プラグイン

</details>
