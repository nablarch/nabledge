# Nablarch 5u13 リリースノート

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/secure_handler.html#content-security-policy) [2](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/bean_validation.html#bean-validation-onerror) [3](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web_interceptor/use_token.html) [4](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/tag.html#tag-double-submission-server-side) [5](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/error_message.html) [6](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/bean_util.html#id6) [7](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/bean_validation.html#bean-validation-system-char-validator) [8](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html#java-beans) [9](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/database.html#database-replace-schema) [10](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#entityjpa) [11](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/mail.html#mail-template) [12](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/format.html) [13](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/tag.html#tag-format-value) [14](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/policy.html#deprecated-api) [15](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/platform.html#id3) [16](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/mom/architecture.html) [17](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details.html#id11) [18](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/code.html#code) [19](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/nablarch_validation.html) [20](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/log/http_access_log.html) [21](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/doma_adaptor.html#id9) [22](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/doma_adaptor.html#java-sql-statement) [23](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/mail_sender_freemarker_adaptor.html) [24](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/mail_sender_thymeleaf_adaptor.html) [25](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/mail_sender_velocity_adaptor.html) [26](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/web_thymeleaf_adaptor.html) [27](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/bean_util.html) [28](https://nablarch.github.io/docs/LATEST/doc/extension_components/report/index.html#id2) [29](https://nablarch.github.io/docs/LATEST/doc/extension_components/etl/etl_maven_plugin.html#id4) [30](https://nablarch.github.io/docs/LATEST/doc/extension_components/etl/etl_maven_plugin.html#id2) [31](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/01_ClassUnitTest/01_entityUnitTest.html#excel) [32](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/index.html) [33](https://nablarch.github.io/docs/LATEST/doc/examples/index.html) [34](https://nablarch.github.io/docs/LATEST/doc/examples/06/index.html) [35](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/guide/widget_usage/create_screen_item_list.html) [36](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/reference_jsp_widgets/table_search_result.html) [37](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/index.html) [38](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/index.html) [39](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/internals/showing_specsheet_view.html#id4) [40](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/testing.html#id5) [41](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/introduction/intention.html) [42](https://nablarch.github.io/schema/component-configuration.xsd)

## 5u13 システムへの影響がある変更

## 5u13 システムへの影響がある変更

5u12からの変更のうち、本番環境への影響の可能性がある項目。

### No.3: リダイレクト指定の変更（ウェブアプリケーション）
**モジュール**: `nablarch-fw-web 1.5.0`

> **警告**: `redirect:` の後にスラッシュを含まないパス指定（例: `redirect:foo/bar`）は不正なリダイレクト指定として例外が送出されるようになった。

正しいリダイレクト指定:
- 現在のページからの相対パス: `redirect://foo/bar`
- サーブレットコンテキストを起点とする相対パス: `redirect:///foo/bar`
- 任意スキーム: `redirect:myapp://example.com`

**対処**: `"redirect:"` を検索し、スラッシュを含まないパス指定（例: `redirect:foo/bar`）があれば上記の正しい形式に修正すること。

### No.8: BeanValidation サロゲートペア対応
**モジュール**: `nablarch-core-validation-ee 1.1.0`（起因バージョン: 1.0.0）

- `@Length` による文字列長バリデーション: サロゲートペアを1文字として数えるよう変更（以前は2文字）
- `@SystemChar` によるシステム許容文字バリデーション: サロゲートペアを指定可能に

> **警告**: サロゲートペアを2文字としてバリデーションされることを期待している場合はアプリ処理内容を見直すこと。サロゲートペアを扱っていないアプリへの影響はない。

参照: [BeanValidationのシステム許容文字バリデーション](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/bean_validation.html#bean-validation-system-char-validator)

### No.9: Nablarchバリデーション サロゲートペア対応
**モジュール**: `nablarch-core-validation 1.1.0`（起因バージョン: 1.0.0）

`@Length` の文字列長バリデーションがサロゲートペアを1文字として数えるよう変更（No.8の文字列長バリデーションと同様）。

> **警告**: No.8と同様。サロゲートペアを扱っていないアプリへの影響はない。

### No.10: スタンドアローンアプリでのセッションストア使用禁止
**モジュール**: `nablarch-core 1.4.0`, `nablarch-fw-standalone 1.3.0`（起因バージョン: 5u5）

バッチ・MOM受信等のスタンドアローン型アプリで以下のメソッドを呼び出すと実行時例外が送出される（実装箇所: `nablarch.fw.StandaloneExecutionContext`）:
- `ExecutionContext#getSessionStoreMap`
- `ExecutionContext#setSessionStoreMap`
- `ExecutionContext#getSessionStoredVar`
- `ExecutionContext#setSessionStoredVar`

> **警告**: バッチ・MOM受信等でセッションストアを使用しているPJは影響あり。セッションストアの代わりにセッションスコープを使用するよう修正すること。セッションストアを使用していないPJへの影響はない。

### No.11: DIコンテナでstaticプロパティへのインジェクション禁止
**モジュール**: `nablarch-core 1.4.0`, `nablarch-core-repository 1.3.0`, `nablarch-fw-web 1.5.0`（起因バージョン: 1.0.0）

staticなプロパティへのインジェクションを行うと以下の例外が発生:

```
nablarch.core.repository.di.ContainerProcessException: static property injection not allowed. component=[foo] property=[bar]
```

> **警告**: staticなプロパティへのDIインジェクションを使用している場合は影響あり。5u12までと同じ動作にしたい場合は「システムリポジトリを5u12までと同じ動作にする方法」を参照。

### No.16: ユニバーサルDAO ColumnMetaコンストラクタ変更
**モジュール**: `nablarch-common-dao 1.5.0`

`@Access` アノテーションによるフィールドへのアノテーション設定対応に伴い、アーキテクト向け公開クラス `ColumnMeta` のコンストラクタが変更された。

> **警告**: ユニバーサルDAOを拡張しているアプリはコンパイルエラーが発生する可能性がある。`EntityMeta` のプロダクトコードを参考に `ColumnMeta` のインスタンス化部分を修正すること。通常のアプリへの影響はない。

参照: [ユニバーサルDAO Entity/JPA](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#entityjpa)

### No.17: 定型メールテンプレートエンジン設定変更
**モジュール**: `nablarch-mail-sender 1.4.0`

デフォルトのテンプレートエンジンは5u12と同一。ただし `MailRequester` のコンポーネント定義をカスタマイズしている（デフォルト設定を上書きしている）場合、5u12と同じテンプレートエンジンを使用する場合でも設定変更が必要。

> **警告**: `MailRequester` のコンポーネント定義を上書きしているアプリは設定変更が必要。詳細は「定型メール送信要求を5u12までと同じ動作にする方法」参照。

参照: [定型メールのテンプレートエンジン](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/mail.html#mail-template)

### No.18: StringUtil サロゲートペア対応
**モジュール**: `nablarch-core 1.4.0`（起因バージョン: 1.0.0）

`StringUtil` で文字列長を扱う処理がサロゲートペアを1文字として扱うよう変更（以前は2文字）。

> **警告**: `StringUtil` でサロゲートペアを2文字として扱うことを期待している場合はアプリ処理内容を見直すこと。サロゲートペアを扱っていないアプリへの影響はない。

### No.30: Domaロガー変更
**モジュール**: `nablarch-doma-adaptor 1.2.0`

デフォルトで `NablarchJdbcLogger` を使用するよう変更（5u12まで: `UtilLoggingJdbcLogger` / java.util.logging / ログレベルFINE）。

> **警告**: 5u12までと同じ動作（`UtilLoggingJdbcLogger`）にしたい場合は「Domaのロガーを5u12までと同じ動作にする方法」を参照。

参照: [Domaアダプタ ログ出力統一](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/doma_adaptor.html#id9)

<details>
<summary>keywords</summary>

リダイレクト, redirect:, サロゲートペア, @Length, @SystemChar, BeanValidation, セッションストア, スタンドアローン, staticプロパティ, DIコンテナ, ContainerProcessException, ColumnMeta, EntityMeta, MailRequester, StringUtil, NablarchJdbcLogger, Domaロガー, ExecutionContext, StandaloneExecutionContext, nablarch-core, nablarch-core-validation-ee, nablarch-core-validation, nablarch-fw-standalone, nablarch-core-repository, nablarch-mail-sender, nablarch-common-dao, 後方互換, バージョンアップ影響, 不正なリダイレクト指定, static property injection not allowed

</details>

## 5u13 機能追加・改善（システムへの影響なし）

## 5u13 機能追加・改善（システムへの影響なし）

### No.1: セキュアハンドラ Content-Security-Policy ヘッダ設定
**モジュール**: `nablarch-fw-web 1.5.0`

セキュアハンドラでContent-Security-Policy（XSS等の攻撃防止）レスポンスヘッダを設定可能。

参照: [セキュアハンドラ CSP](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/secure_handler.html#content-security-policy)

### No.2: バリデーションエラー時のリクエストスコープへの入力値設定
**モジュール**: `nablarch-fw-web 1.5.0`

BeanValidation使用時のみ。バリデーションエラー発生時に入力値を設定したフォームをリクエストスコープに設定できる機能を追加。

> **重要**: この機能は後方互換への影響があり打鍵テスト以外で影響確認が困難なため、**デフォルトで無効**。

参照: [BeanValidation バリデーションエラー時の入力値設定](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/bean_validation.html#bean-validation-onerror)

### No.4: Content-Dispositionにfilename*パラメーター出力
**モジュール**: `nablarch-fw-web 1.5.0`

ファイルダウンロード時のContent-DispositionレスポンスヘッダにRFC6266準拠のfilename*パラメーターを出力。以前はfilenameパラメーターのみで一部ブラウザで文字化けが発生していた。

### No.5: @UseTokenインターセプター追加（二重サブミット防止のJSP以外への対応）
**モジュール**: `nablarch-fw-web 1.5.0`, `nablarch-fw-web-tag 1.1.0`

`@UseToken` インターセプターを追加し、二重サブミット防止機能を `nablarch-fw-web-tag` から `nablarch-fw-web` に移動。JSP以外のテンプレートエンジンからも使用可能に。

参照: [@UseTokenインターセプター](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web_interceptor/use_token.html)

### No.6: バリデーションエラーメッセージのリクエストスコープへの格納
**モジュール**: `nablarch-fw-web 1.5.0`

バリデーションエラーメッセージをリクエストスコープに格納。JSP以外のテンプレートエンジンでも利用可能。JSPでもerror/errorsタグなしでエラーメッセージ表示が可能（後方互換維持）。

参照: [エラーメッセージの表示](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/error_message.html)

### No.7: BeanUtil フォーマットパターン設定
**モジュール**: `nablarch-core-beans 1.3.0`

BeanUtilのコピー処理で、日付・数値と文字列の型変換時のフォーマットパターンを設定可能。設定方法:
1. コンポーネント設定ファイルによる全体的な設定
2. アノテーションによる特定プロパティへの設定
3. コピーメソッドに渡すオプションによる実行時設定

参照: [BeanUtil フォーマットパターン](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/bean_util.html#id6)

### No.12: XMLスキーマをgithub.ioで公開
コンポーネント設定ファイルのXMLスキーマを以下のURIで公開:
`https://nablarch.github.io/schema/component-configuration.xsd`

### No.13: 環境設定ファイルにJavaプロパティファイル形式を使用可能
**モジュール**: `nablarch-core-repository 1.3.0`

環境設定ファイルの拡張子が `.properties` の場合、Javaプロパティファイルの書式でパース可能。

参照: [システムリポジトリ Java Beans](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html#java-beans)

### No.14: SQL文中スキーマの環境毎切り替え
**モジュール**: `nablarch-core-jdbc 1.4.0`

SQLファイル内のSQL文にスキーマを表すプレースホルダを使用可能。環境毎にスキーマを切り替え可能。

参照: [データベースアクセス スキーマ切り替え](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/database.html#database-replace-schema)

### No.15: batchInsertエラーメッセージ改善
**モジュール**: `nablarch-core-jdbc 1.4.0`, `nablarch-common-dao 1.5.0`

自動採番カラムを持つテーブルへの一括登録（batchInsert）が行えないデータベース（DB2、SQLServer）使用時にわかりやすいエラーメッセージを持つ例外を送出。対処はデータベース設計の見直しまたは1件毎登録への変更が必要。

### No.16: ユニバーサルDAO フィールドへのアノテーション設定
**モジュール**: `nablarch-common-dao 1.5.0`

`@Access` アノテーションで設定することで、EntityクラスのフィールドにJPAアノテーションを設定可能。Lombok使用時等、getterを明示的に実装しない場合に有用。`@Access` を明示的に指定しない場合は従来通りgetterのアノテーションを参照。

なお、この変更に伴い、アーキテクト向け公開クラス `ColumnMeta` のコンストラクタが変更されている。ユニバーサルDAOを拡張している場合に影響を受ける可能性があり、その場合は `EntityMeta` のプロダクトコードを参考に `ColumnMeta` クラスをインスタンス化する部分のコードを修正すること（詳細はs1参照）。

参照: [ユニバーサルDAO Entity/JPA](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/universal_dao.html#entityjpa)

### No.19: フォーマッタ追加
**モジュール**: `nablarch-core 1.4.0`, `nablarch-fw-web-tag 1.1.0`

日付・数値等のデータを文字列にフォーマットするフォーマッタを追加。画面・ファイル・メッセージング等の出力機能から共通フォーマッタを呼び出し可能。出力フォーマットの設定を1箇所に集約できる。

参照: [フォーマッタ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/format.html)

### No.20: 非推奨APIの見直しと非推奨理由を追記
**モジュール**: `nablarch-common-exclusivecontrol 1.1.0`, `nablarch-fw-web-tag 1.1.0`, `nablarch-core-jdbc 1.4.0`, `nablarch-core-validation 1.1.0`, `nablarch-common-dao 1.5.0`, `nablarch-fw-standalone 1.3.0`, `nablarch-common-encryption 1.1.0`, `nablarch-fw-web 1.1.0`, `nablarch-backward-compatibility 1.1.0`

NablarchのAPIにDeprecatedを付与する方針が解説書に追記された。方針に従い、上記9モジュールについて非推奨APIの見直しと非推奨理由の明確化（Javadocへの記載）が行われた。

参照: [Nablarch Deprecated APIポリシー](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/policy.html#deprecated-api)

### No.21, No.22: テスト環境のブラウザ・Java・DBバージョンを最新化

Nablarchフレームワークのテスト環境のブラウザバージョンを一般的に使われているバージョンに最新化した。以下のブラウザでテストを実施している:
- Internet Explorer 11
- Microsoft Edge
- Mozilla Firefox
- Google Chrome
- Safari

また、テスト環境のJavaとDBのバージョンも最新化された。

参照: [Nablarch稼動環境](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/platform.html#id3)

### No.23: MOMメッセージングは固定長のみ対応

MOMメッセージングは固定長のみの対応となっていたが、そのことが明記されていなかったため解説書に追記された。

> **重要**: MOMメッセージングでは可変長フォーマットは使用できない。データフォーマットを選択する際は、MOMメッセージングが固定長のみ対応であることを考慮すること。

参照: [MOMメッセージング アーキテクチャ](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/messaging/mom/architecture.html)

### No.26: コード値のenum化について追記

Domaアダプタを使用することで、DBに登録するコード値についてもenum化できる旨が解説書に追記された。

参照: [コード管理](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/code.html#code)

### No.29: nablarch-archetype-parentからh2 JDBCドライバの依存関係を削除

`nablarch-archetype-parent` からh2のJDBCドライバの依存関係が削除された。gspが使うJDBCドライバは各プロジェクトで使用するデータベースに合わせて定義する仕様のため。

### No.31: Domaアダプタ java.sql.Statement設定カスタマイズ
**モジュール**: `nablarch-doma-adaptor 1.2.0`

プロジェクト全体のjava.sql.Statement設定（最大行数制限値、フェッチサイズ、クエリタイムアウト、バッチサイズ）をカスタマイズ可能。以前はDAO単位のみ設定可能だった。

参照: [Domaアダプタ java.sql.Statement設定](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/doma_adaptor.html#java-sql-statement)

### No.32-35: メールテンプレートエンジンアダプタおよびウェブアプリThymeleafアダプタ追加
- **`nablarch-mail-sender-freemarker-adaptor 1.0.0`**: FreeMarkerを定型メール送信で使用可能 → [参照](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/mail_sender_freemarker_adaptor.html)
- **`nablarch-mail-sender-thymeleaf-adaptor 1.0.0`**: Thymeleafを定型メール送信で使用可能 → [参照](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/mail_sender_thymeleaf_adaptor.html)
- **`nablarch-mail-sender-velocity-adaptor 1.0.0`**: Velocityを定型メール送信で使用可能 → [参照](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/mail_sender_velocity_adaptor.html)
- **`nablarch-web-thymeleaf-adaptor 1.0.0`**: ThymeleafをWebアプリのHTML出力に使用可能 → [参照](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/web_thymeleaf_adaptor.html)

### No.36: ルーティングアダプタ http-request-router最新化
**モジュール**: `nablarch-router-adaptor 1.1.0`

パスパラメータに非ASCII文字を使用した場合に `HttpRequest` から取得した値が2重エンコードされる問題が修正されたhttp-request-routerの最新版を使用。

### No.37: JSR310アダプタ BeanUtilフォーマットパターン指定
**モジュール**: `nablarch-jsr310-adaptor 1.1.0`

BeanUtilのコピー処理と文字列変換時のフォーマットパターン設定が可能。設定方法はNo.7と同様（コンポーネント設定ファイル/アノテーション/コピーメソッドオプション）。

参照: [BeanUtil](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/bean_util.html)

### No.47: ETL Mavenプラグイン入力Java BeansはWorkItemを継承すること

ETL Mavenプラグインの入力パラメータとして指定するJava BeansクラスはWorkItemを継承していることが必須である旨が解説書に追記された。

> **重要**: ETL Mavenプラグインの入力パラメータとして指定するJava BeansクラスはWorkItemを継承していなければならない。この制約を満たさない場合、ETL処理が正常に動作しない。

参照: [ETL Mavenプラグイン 入力パラメータ](https://nablarch.github.io/docs/LATEST/doc/extension_components/etl/etl_maven_plugin.html#id4)

### No.48: ETL Mavenプラグインのバージョン指定

ETL Mavenプラグインのバージョンはプロジェクトで使用するNablarchのバージョンと一致させる必要がある。バージョンを一致させることにより、プロジェクトで使用するETLとプラグインが使用するETLが異なることがなくなり、予期しないトラブルを未然に回避できる。

参照: [ETL Mavenプラグイン バージョン指定](https://nablarch.github.io/docs/LATEST/doc/extension_components/etl/etl_maven_plugin.html#id2)

### No.49: 帳票ライブラリは今後メンテナンスされない
**モジュール**: `nablarch-report 1.1.0`

帳票ライブラリ（nablarch-report）は依存ライブラリが現在入手困難となっているため今後メンテナンスを行わない。これに伴い帳票サンプルも今後メンテナンスを行わない旨と代替手段がREADMEに明記された。

> **重要**: 帳票ライブラリの採用を検討しているプロジェクト、または既に使用しているプロジェクトは、今後バグ修正や機能追加が行われないことを考慮すること。代替手段については解説書のREADMEを参照。

参照: [帳票ライブラリ](https://nablarch.github.io/docs/LATEST/doc/extension_components/report/index.html#id2)

### No.56: UI開発基盤の使用上の注意点

UI開発基盤の使用上の注意に以下が追記された:
- UI開発基盤を使用する際は、Node.js等の知識が必須であること
- 「設計工程用JSPと開発工程用JSPのダブルメンテナンス」が往々にして発生すること

これらの点に十分注意して、UI開発基盤の採用要否を判断すること。

参照: [UI開発基盤](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/index.html)

### No.60: テスティングフレームワーク java.util.Date型プロパティ対応
**モジュール**: `nablarch-testing 1.2.0`

クラス単体テストでテスト可能なプロパティの型に `java.util.Date` 型を追加。Excel記述形式も明記。以前は `java.util.Date` 型のプロパティをアサートしようとすると例外が発生していた。

参照: [クラス単体テスト Excel形式](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/01_ClassUnitTest/01_entityUnitTest.html#excel)

### No.62: テスティングフレームワークが対応していない基盤およびライブラリ

以下の基盤やライブラリについてはテスティングフレームワークが対応していないことが解説書に明記された:

- **RESTfulサービス**: テスティングフレームワーク非対応
- **JSR352バッチ**: テスティングフレームワーク非対応
- **Bean Validation**: テスティングフレームワーク非対応

> **重要**: これらの基盤・ライブラリを使用するアプリケーションのテストには、Nablarchのテスティングフレームワークを使用できない。別途テスト方法を検討すること。

参照: [テスティングフレームワーク](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/index.html)

### No.64: CAPTCHA機能サンプルの注意点

CAPTCHA機能サンプルは、使用しているOSSの画像認証が短時間で突破される可能性があるため注意点が追記された。代替手段として、Google reCAPTCHAが記載された。

参照: [CAPTCHA機能サンプル](https://nablarch.github.io/docs/LATEST/doc/examples/06/index.html)

<details>
<summary>keywords</summary>

Content-Security-Policy, CSPヘッダ, セキュアハンドラ, @UseToken, 二重サブミット防止, バリデーションエラーメッセージ, リクエストスコープ, BeanUtil, フォーマットパターン, XMLスキーマ, component-configuration.xsd, プロパティファイル, スキーマ切り替え, batchInsert, フォーマッタ, FreeMarker, Thymeleaf, Velocity, テンプレートエンジン, java.sql.Statement, JSR310, nablarch-core, nablarch-core-beans, nablarch-core-jdbc, nablarch-doma-adaptor, nablarch-web-thymeleaf-adaptor, nablarch-mail-sender-freemarker-adaptor, nablarch-mail-sender-thymeleaf-adaptor, nablarch-mail-sender-velocity-adaptor, nablarch-jsr310-adaptor, java.util.Date, nablarch-testing, Content-Disposition, filename*, nablarch-fw-web, @Access, nablarch-router-adaptor, http-request-router, ColumnMeta, EntityMeta, MOMメッセージング, 固定長, 可変長, h2, JDBCドライバ, nablarch-archetype-parent, ブランクプロジェクト, JDBC依存関係, WorkItem, ETL Mavenプラグイン, ETL Maven, 帳票ライブラリ, nablarch-report, メンテナンス終了, テスティングフレームワーク対象外, RESTfulサービス, JSR352, Bean Validation非対応, 非推奨API, Deprecated, 稼動環境, テスト環境, ブラウザ, コード管理, enum化, コード値, Node.js, UI開発基盤採用, JSPダブルメンテナンス, CAPTCHA, reCAPTCHA, 画像認証

</details>

## バージョンアップ手順

## バージョンアップ手順（5u12 → 5u13）

1. `pom.xml` の `<dependencyManagement>` セクションに指定されている `nablarch-bom` のバージョンを `5u13` に変更する
2. Mavenのビルドを再実行する

<details>
<summary>keywords</summary>

nablarch-bom, pom.xml, dependencyManagement, バージョンアップ, 5u13, Maven

</details>

## Domaのロガーを5u12までと同じ動作にする方法

## Domaのロガーを5u12までと同じ動作にする方法

5u13からDomaのロガーとして `NablarchJdbcLogger` が提供され、デフォルトで使用される。

5u12まで（`UtilLoggingJdbcLogger` / java.util.logging / ログレベルFINE）と同じ動作にしたい場合は以下の手順を実施:

1. `UtilLoggingJdbcLogger` のインスタンスを生成する `ComponentFactory` を実装する
2. コンポーネント定義に設定する

**ComponentFactory実装例**:
```java
package com.example;

import java.util.logging.Level;
import org.seasar.doma.jdbc.JdbcLogger;
import org.seasar.doma.jdbc.UtilLoggingJdbcLogger;
import nablarch.core.repository.di.ComponentFactory;

public class JdbcLoggerFactory implements ComponentFactory<JdbcLogger> {

    @Override
    public JdbcLogger createObject() {
        return new UtilLoggingJdbcLogger(Level.FINE);
    }
}
```

**コンポーネント定義例**:
```xml
<component class="com.example.JdbcLoggerFactory" name="domaJdbcLogger" />
```

<details>
<summary>keywords</summary>

Domaロガー, NablarchJdbcLogger, UtilLoggingJdbcLogger, ComponentFactory, JdbcLogger, domaJdbcLogger, java.util.logging, nablarch-doma-adaptor, ログ移行, Level.FINE

</details>

## 定型メール送信要求を5u12までと同じ動作にする方法

## 定型メール送信要求を5u12までと同じ動作にする方法

5u13から定型メール送信要求でFreeMarker等のテンプレートエンジンを使用可能になった。これに伴い `MailRequester` の `mailTemplateTable` プロパティが `TinyTemplateEngineMailProcessor` に移動した。

5u12と同じ動作（Nablarch簡易テンプレート処理）にするには:
1. `MailRequester` の `templateEngineMailProcessor` プロパティに `TinyTemplateEngineMailProcessor` を設定する
2. `TinyTemplateEngineMailProcessor` の `mailTemplateTable` プロパティを設定する

**5u12までのコンポーネント定義**:
```xml
<component name="mailRequester" class="nablarch.common.mail.MailRequester">
    <property name="mailTemplateTable" ref="mailTemplateTable" />
    <!-- 他の設定は省略 -->
</component>
```

**5u13以降（5u12と同じ動作にする場合）のコンポーネント定義**:
```xml
<component name="mailRequester" class="nablarch.common.mail.MailRequester">
    <property name="templateEngineMailProcessor">
        <component class="nablarch.common.mail.TinyTemplateEngineMailProcessor">
            <property name="mailTemplateTable" ref="mailTemplateTable" />
        </component>
    </property>
    <!-- 他の設定は省略 -->
</component>
```

<details>
<summary>keywords</summary>

MailRequester, TinyTemplateEngineMailProcessor, mailTemplateTable, templateEngineMailProcessor, 定型メール, テンプレートエンジン移行, nablarch.common.mail

</details>

## システムリポジトリを5u12までと同じ動作にする方法（staticプロパティ）

## システムリポジトリを5u12までと同じ動作にする方法（staticプロパティへのインジェクション許容）

5u13からstaticなプロパティへのDIインジェクションが禁止され、使用するとDIコンテナ構築時に `ContainerProcessException: static property injection not allowed` が発生する。

5u12までと同じ動作（staticプロパティへのインジェクションを許容）にするには以下の設定を行う:

### ウェブアプリケーション・ウェブサービスの場合

`web.xml` に以下の `<context-param>` を追加:

```xml
<context-param>
    <!-- staticなプロパティへのインジェクションを許容する設定 -->
    <param-name>di.allow-static-property</param-name>
    <param-value>true</param-value>
</context-param>
```

### バッチアプリケーション・メッセージングの場合

`java` コマンドにシステムプロパティ `nablarch.diContainer.allowStaticInjection` を `true` に設定:

```
java -Dnablarch.diContainer.allowStaticInjection=true <その他のオプション> nablarch.fw.batch.ee.Main <プログラム引数>
```

> **注意**: staticプロパティへのインジェクションは、同一クラスを異なるコンポーネント名で定義した際に初期化順序によって設定値が変わるという特定困難なバグの原因となる。5u13ではこの問題を防ぐためデフォルトで禁止された。

<details>
<summary>keywords</summary>

staticプロパティ, DIコンテナ, ContainerProcessException, di.allow-static-property, nablarch.diContainer.allowStaticInjection, web.xml, システムリポジトリ, インジェクション移行, DiContainer, NablarchServletContextListener

</details>

## UI開発基盤 標準プラグインの変更点（5u13）

## UI開発基盤 標準プラグインの変更点（5u13）

UI開発基盤の変更内容と対応する標準プラグインのバージョンを示す。既にUI開発基盤を導入済みのプロジェクトは、プラグイン単位で変更内容を取り込む。取込方法は「Nablarch UI開発基盤 解説書 ＞ 開発作業手順 ＞ Nablarch 標準プラグインの更新」を参照。

| No | タイトル | 標準プラグイン | プラグインバージョン | 変更概要 |
|----|----------|---------------|-------------------|---------|
| 1 | ダイアログのテストで表示される文言を修正 | nablarch-widget-event-dialog | 1.0.4 | テストコードの文言修正 |
| 2 | ダイアログ(alert)用のテスト画面で打鍵テストができない問題に対応 | nablarch-widget-event-dialog | 1.0.4 | テストコード修正 |
| 3 | リストビルダーの単体テストの期待値を修正 | nablarch-widget-field-listbuilder | 1.0.3 | テストコードの文言修正 |
| 4 | ファイルアップロードの単体テストの期待値を修正 | nablarch-widget-field-file | 1.0.1 | テストコードの文言修正 |

<details>
<summary>keywords</summary>

nablarch-widget-event-dialog, nablarch-widget-field-listbuilder, nablarch-widget-field-file, 標準プラグイン, UI開発基盤プラグイン, プラグイン更新, 1.0.4, 1.0.3, 1.0.1

</details>
