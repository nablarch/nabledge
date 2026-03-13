# Nablarch 5u23 リリースノート

**公式ドキュメント**: [1](https://fintan.jp/page/252/) [2](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/libraries/log/jaxrs_access_log.html) [3](https://nablarch.github.io/docs/5u23/publishedApi/nablarch-all/publishedApiDoc/programmer/nablarch/core/validation/ee/DateFormat.html) [4](https://nablarch.github.io/docs/5u23/publishedApi/nablarch-all/publishedApiDoc/programmer/nablarch/core/validation/ee/EnumElement.html) [5](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/libraries/validation/bean_validation.html#bean-validation-use-groups) [6](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/web_interceptor/InjectForm.html#bean-validation) [7](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/rest/jaxrs_bean_validation_handler.html#bean-validation) [8](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/standalone/retry_handler.html) [9](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/common/database_connection_management_handler.html) [10](https://nablarch.github.io/docs/5u23/doc/development_tools/java_static_analysis/index.html) [11](https://nablarch.github.io/docs/5u23/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/index.html#request-test-user-info) [12](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/libraries/mail.html#mail-send) [13](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html) [14](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/blank_project/MavenModuleStructures/index.html#pj-web) [15](https://nablarch.github.io/docs/5u23/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/rest.html#cookie) [16](https://nablarch.github.io/docs/5u23/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/01_ClassUnitTest/01_entityUnitTest/01_entityUnitTestWithBeanValidation.html) [17](https://nablarch.github.io/docs/5u23/doc/examples/13/index.html)

## 5u23 変更一覧

## アプリケーションフレームワーク

### 新規追加

**No.1 RESTfulウェブサービス用HTTPアクセスログハンドラ追加** (nablarch-fw-jaxrs 1.3.0)
- リクエスト/レスポンスボディをログ出力可能
- 秘匿情報のマスク処理対応
- 参照: [JAX-RS HTTPアクセスログ](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/libraries/log/jaxrs_access_log.html)

**No.2 日付バリデーション `@DateFormat` 追加** (nablarch-core-validation-ee 1.2.0)
- 指定フォーマット（SimpleDateFormat準拠）への一致チェック（日付・日時・時刻対応）
- 実在日付チェック（例: 2023/1/32はエラー）
- 参照: [DateFormat Javadoc](https://nablarch.github.io/docs/5u23/publishedApi/nablarch-all/publishedApiDoc/programmer/nablarch/core/validation/ee/DateFormat.html)

**No.3 列挙値バリデーション `@EnumElement` 追加** (nablarch-core-validation-ee 1.2.0)
- 入力値が指定列挙型のいずれかの値に一致することを検証
- 参照: [EnumElement Javadoc](https://nablarch.github.io/docs/5u23/publishedApi/nablarch-all/publishedApiDoc/programmer/nablarch/core/validation/ee/EnumElement.html)

**No.4 Bean Validationグループ機能対応** (nablarch-core-validation-ee 1.2.0, nablarch-fw-web 1.12.0, nablarch-fw-jaxrs 1.3.0)
- `ValidatorUtil`にグループ指定可能なAPIを追加
- `@InjectForm`アノテーションにグループ指定属性を追加
- JAX-RS BeanValidationハンドラで`@ConvertGroup`アノテーションによるグループ指定が可能に
- 参照: [Bean Validationグループ](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/libraries/validation/bean_validation.html#bean-validation-use-groups), [InjectFormのグループ指定](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/web_interceptor/InjectForm.html#bean-validation), [JAX-RS BeanValidationハンドラ](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/rest/jaxrs_bean_validation_handler.html#bean-validation)

### 変更

**No.5 DBアクセス失敗時の例外ハンドリング改善** (nablarch-core-jdbc 1.7.0, nablarch-common-jdbc 1.2.0)

> **重要**: データベースアクセスを行うアプリケーションに影響があります。基本的に対応不要ですが、DBアクセス例外を想定したテストや独自コネクションクローズハンドリングを実装している場合は見直しが必要です。詳細は「DBアクセス失敗時の例外ハンドリング変更点」セクション参照。

- 参照: [リトライハンドラ](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/standalone/retry_handler.html), [DB接続管理ハンドラ](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/common/database_connection_management_handler.html)

**No.6 IntelliJ IDEA Inspectionプロファイル提供廃止** (nablarch-document 5u23)
- 現行IntelliJ IDEAはデフォルト設定で十分な検出が可能なため廃止
- カスタマイズが必要な場合はデフォルトプロファイルをベースに独自カスタマイズすること
- 参照: [Java静的解析](https://nablarch.github.io/docs/5u23/doc/development_tools/java_static_analysis/index.html)

## ブランクプロジェクト

**No.7** RESTfulウェブサービスプロジェクト: 新HTTPアクセスログハンドラ（No.1）を使用するよう変更 (nablarch-jaxrs 5u23, nablarch-container-jaxrs 5u23)

**No.8** Webアプリケーションプロジェクト: 疎通確認テストで明示的にHTTPメソッドを指定するよう変更 (nablarch-web 5u23, nablarch-container-web 5u23)
- 参照: [リクエスト単体テスト](https://nablarch.github.io/docs/5u23/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/index.html#request-test-user-info)

**No.9** バッチプロジェクト: メール送信のステータス更新用トランザクションマネージャーをデフォルト設定から読み込むよう変更 (nablarch-batch 5u23, nablarch-container-batch 5u23, nablarch-main-default-configuration 1.5.0)
- 参照: [メール送信](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/libraries/mail.html#mail-send)

**No.10** Webアプリケーションプロジェクト: ブランクプロジェクト作成時点でCSRFトークン検証ハンドラが有効になるよう変更 (nablarch-web 5u23, nablarch-container-web 5u23)
- 参照: [CSRFトークン検証ハンドラ](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html)

**No.11** Webアプリケーションプロジェクト: 疎通確認用JSPをWEB-INF配下に移動（直接起動防止） (nablarch-web 5u23, nablarch-container-web 5u23)
- 参照: [Webプロジェクト構成](https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/blank_project/MavenModuleStructures/index.html#pj-web)

## Example

**No.12** ウェブ/RESTfulウェブサービス: HTTPアクセスログハンドラの変更 (nablarch-example-web 5u23, nablarch-example-rest 5u23)
- No.1の新しいHTTPアクセスログハンドラを使用するよう変更
- ウェブではRESTfulウェブサービスを併用しているため、RESTfulウェブサービスの部分のみ変更

**No.13** ウェブ: テスト時のHTTPメソッド指定処理の変更 (nablarch-example-web 5u23)
- リクエスト単体テストでHTTPメソッドを指定する際、これまでexampleで独自実装していた処理をNo.19の機能を使用するよう変更

**No.14** ウェブ: 単体テストで使用するハンドラの独自実装を廃止 (nablarch-example-web 5u23)
- CSRFトークン検証ハンドラを無効化するための独自実装ハンドラを削除し、テスティングフレームワーク提供のクラスを使用するよう変更

**No.15** ウェブ/ウェブ（Thymeleaf）/RESTfulウェブサービス/HTTPメッセージング（受信）/MONによるメッセージング（同期応答メッセージ受信）: 日付バリデーションの変更 (nablarch-example-web 5u23, nablarch-example-thymeleaf-web 5u23, nablarch-example-rest 5u23, nablarch-example-http-messaging 5u23, nablarch-example-mom-sync-receive 5u23)
- 日付バリデーション処理で、これまでexampleで独自実装していた処理をNo.2の機能を使用するよう変更

**No.16** ウェブ/ウェブ（Thymeleaf）/RESTfulウェブサービス/HTTPメッセージング（受信）: 列挙値バリデーションの変更 (nablarch-example-web 5u23, nablarch-example-thymeleaf-web 5u23, nablarch-example-rest 5u23, nablarch-example-http-messaging 5u23)
- 列挙値バリデーション処理で、これまでexampleで独自実装していた処理をNo.3の機能を使用するよう変更

**No.17** ウェブ/RESTfulウェブサービス/Nablarchバッチ/HTTPメッセージング（受信）/MONによるメッセージング（同期応答メッセージ受信）: Formの単体テストの追加 (nablarch-example-web 5u23, nablarch-example-rest 5u23, nablarch-example-batch 5u23, nablarch-example-http-messaging 5u23, nablarch-example-mom-sync-receive 5u23)
- Formの精査のテストをNo.22の機能を使用して実装

## テスティングフレームワーク

**No.18** RESTfulウェブサービスのテストでunit-test.xmlによるコンポーネント設定上書きが可能に (nablarch-fw-web 1.12.0)

**No.19** WebアプリケーションのテストでHTTPメソッドおよびクエリパラメータ設定が可能に (nablarch-testing 1.5.0)
- 従来: リクエスト時のHTTPメソッドがPOSTに固定
- 変更後: 任意のHTTPメソッドとクエリパラメータを指定可能
- 参照: [リクエスト単体テスト](https://nablarch.github.io/docs/5u23/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/index.html#request-test-user-info)

**No.20** RESTfulウェブサービスのテストで複数Cookieの引き継ぎが可能に (nablarch-fw-web 1.12.0, nablarch-testing-rest 1.2.0)
- 従来: Set-Cookieヘッダのうち取得可能なCookieは1件のみ
- 変更後: すべてのSet-CookieヘッダのCookieを取得可能
- `RequestResponceCookieManager`を追加（任意のCookieを引き継ぎ可能）。従来は`NablarchSIDManager`のみ提供
- 参照: [取引単体テスト Cookie](https://nablarch.github.io/docs/5u23/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/rest.html#cookie)

**No.21** リクエスト単体テスト実施時にhttp_dumpディレクトリが不要に作成される問題を修正 (nablarch-testing 1.5.0)

**No.22** Form/EntityのBeanValidation単体テスト対応 (nablarch-testing 1.5.0)
- Bean Validationを使ったForm/Entityの精査をテスティングフレームワークで自動テスト可能に
- 参照: [BeanValidation単体テスト](https://nablarch.github.io/docs/5u23/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/01_ClassUnitTest/01_entityUnitTest/01_entityUnitTestWithBeanValidation.html)

## Nablarch実装例集

**No.23** Logbookを用いたリクエスト/レスポンスログ出力の実装例追加 (nablarch-biz-sample-all 2.1.0)
- 外部REST APIへのリクエスト送信時にLogbookでアクセスログを出力する実装例
- 参照: [実装例集 No.13](https://nablarch.github.io/docs/5u23/doc/examples/13/index.html)

<details>
<summary>keywords</summary>

@DateFormat, @EnumElement, @InjectForm, @ConvertGroup, DateFormat, EnumElement, ValidatorUtil, RequestResponceCookieManager, NablarchSIDManager, RESTfulウェブサービス HTTPアクセスログ, 日付バリデーション, 列挙値バリデーション, Bean Validationグループ機能, IntelliJ IDEA Inspectionプロファイル廃止, CSRFトークン検証ハンドラ, メール送信トランザクションマネージャー, リクエスト単体テスト HTTPメソッド, Form Entity BeanValidation単体テスト, Logbook アクセスログ, nablarch-example-web, nablarch-example-rest, nablarch-example-thymeleaf-web, nablarch-example-http-messaging, nablarch-example-mom-sync-receive, nablarch-example-batch

</details>

## バージョンアップ手順

1. pom.xmlの`<dependencyManagement>`セクションのnablarch-bomバージョンを`5u23`に書き換える
2. Mavenのビルドを再実行する

<details>
<summary>keywords</summary>

バージョンアップ手順, nablarch-bom, pom.xml, dependencyManagement, 5u23 適用手順, Maven ビルド

</details>

## DBアクセス失敗時の例外ハンドリング変更点

## 変更点

DBアクセス失敗時の例外ハンドリングについて以下2点の変更を実施。

**変更1: DB接続異常時は必ずリトライ可能な例外をスロー**
- 従来: コネクション初期化・コミット処理で例外が発生した場合、原因に関わらずリトライ不可な例外をスロー
- 変更後: DB接続の異常が原因の場合は必ずリトライ可能な例外（`Retryable`インターフェース実装）をスロー
- DB接続異常以外の原因（一意制約違反、SQL不備など）は従来通りリトライ不可な例外をスロー

**変更2: コネクションクローズ時の例外をスローしない**
- 従来: コネクションクローズ時に例外が発生すると、業務処理の例外が隠蔽されコネクションクローズ時の例外がスローされていた
- 変更後: コネクションクローズ時の例外はスローせずログ出力のみ（業務処理例外が隠蔽されなくなる）

## 既存アプリケーションへの影響

基本的に対応不要。ただし以下の場合は対応が必要：

> **重要**:
> - DBアクセス例外を想定したテストを実施している場合: 例外の種類や挙動が変わるため期待値の変更が必要になる場合がある
> - 独自実装のハンドラでコネクションのクローズ時に発生した例外をハンドリングしている場合: 独自実装を見直すこと

## 影響を受ける標準クラス

以下の標準クラスを使用している場合に影響があります（独自実装に差し替えている場合は影響なし）：

- **クラス**: `ConnectionFactory` — データベース接続管理ハンドラのDB接続先設定
- **クラス**: `DbAccessExceptionFactory` — DBアクセス時の例外クラスを切り替える
- **クラス**: `DbConnectionManagementHandler` — データベース接続管理ハンドラ
- **クラス**: `SimpleDbTransactionExecutor` — 現在のトランザクションとは異なるトランザクションでSQLを実行する

<details>
<summary>keywords</summary>

DBアクセス失敗, 例外ハンドリング, リトライ, ConnectionFactory, DbAccessExceptionFactory, DbConnectionManagementHandler, SimpleDbTransactionExecutor, コネクションクローズ例外, Retryable, DB接続異常

</details>
