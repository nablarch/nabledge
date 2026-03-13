# Nablarch 5u21 リリースノート

**公式ドキュメント**: [1](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/log.html#json) [2](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/mail.html) [3](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/web/feature_details/nablarch_servlet_context_listener.html) [4](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/message.html#message-multi-lang) [5](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/database/universal_dao.html#sqlcrud) [6](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/session_store.html#session-store-authentication-data) [7](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/log/http_access_log.html) [8](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Java17.html) [9](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/blank_project/CustomizeDB.html#oracle) [10](https://nablarch.github.io/docs/5u21/doc/development_tools/toolbox/SqlExecutor/SqlExecutor.html#pom-xml) [11](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/blank_project/index.html) [12](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/blank_project/beforeFirstStep.html#firststeppreamble) [13](https://nablarch.github.io/docs/5u21/doc/application_framework/adaptors/router_adaptor.html#jax-rspath) [14](https://nablarch.github.io/docs/5u21/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/JUnit5_Extension.html) [15](https://nablarch.github.io/docs/5u21/doc/_downloads/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88%E8%A8%AD%E5%AE%9A%E4%B8%80%E8%A6%A7.xlsx) [16](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/web/getting_started/index.html) [17](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/web_service/rest/getting_started/index.html) [18](https://nablarch.github.io/docs/5u21/doc/application_framework/example/index.html) [19](https://nablarch.github.io/docs/5u21/doc/extension_components/workflow/doc/index.html) [20](https://github.com/nablarch-development-standards/nablarch-style-guide/blob/3.1/java/staticanalysis/unpublished-api/README.md) [21](https://nablarch.github.io/docs/5u21/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/RequestUnitTest_rest.html#rest-test-helper) [22](https://nablarch.github.io/docs/5u21/publishedApi/nablarch-testing/publishedApiDoc/architect/nablarch/fw/web/servlet/MockServletExecutionContext.html) [23](https://nablarch.github.io/docs/5u21/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/01_Abstract.html#id17) [24](https://nablarch.github.io/docs/5u21/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/01_Abstract.html#run-ntf-on-junit5-with-vintage-engine) [25](https://github.com/nablarch-development-standards/nablarch-style-guide/blob/3.1/java/staticanalysis/spotbugs/docs/Maven-settings.md#spotbugs-maven-plugin%E3%82%92%E7%B5%84%E3%81%BF%E8%BE%BC%E3%82%80)

## アプリケーションフレームワーク変更点（No.1–15）

## アプリケーションフレームワーク変更点（No.1–15）

Nablarch 5u20からの変更点。

### No.1: JSONログ出力機能の追加（新規）

Nablarchが出力するログをJSON形式にできる機能を追加。Elasticsearch+Kibanaなどのログ解析ツールとの連携でテキストパースが不要になる。

**更新モジュール**: nablarch-core 1.6.0, nablarch-core-applog 1.3.0, nablarch-core-jdbc 1.5.0, nablarch-fw-messaging 1.2.0, nablarch-fw-standalone 1.5.0, nablarch-fw-web 1.10.0

参照: [JSONログ](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/log.html#json)

### No.2: メール送信機能の改善（変更）

メール送信のマルチプロセス化とメール送信パターンIDによる未送信データ抽出を同時使用できるよう改善。従来は同時使用時にマルチプロセス化がパターンIDを無視して悲観ロックを行い、タイミングによっては一部のメールが送信されないことがあった。

**更新モジュール**: nablarch-mail-sender 1.4.2

参照: [メール送信](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/mail.html)

### No.3: Nablarchサーブレットコンテキスト初期化リスナの初期化成否取得メソッドの追加（変更）

初期化成否を取得できるメソッドを追加。後続のサーブレットコンテキストリスナがこのメソッドで初期化失敗を判定して処理をスキップできるようになり、根本原因（システムリポジトリの初期化失敗）の特定が容易になる。

**更新モジュール**: nablarch-fw-web 1.10.0

参照: [Nablarchサーブレットコンテキスト初期化リスナ](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/web/feature_details/nablarch_servlet_context_listener.html)

### No.4: プロパティファイルによるメッセージ管理機能の設定を追加（変更）

`message-by-property-files.xml`コンポーネント定義ファイルを追加。`PropertiesStringResourceLoader`はコンポーネント定義ファイルで明示的な設定がない場合にデフォルト利用されるクラスだが、このとき実行環境のOSのデフォルトロケールが採用されるため障害の原因になる可能性がある。`message-by-property-files.xml`をimportすることでこの問題を回避できる。

**更新モジュール**: nablarch-main-default-configuration 1.4.0

参照: [メッセージ管理（多言語対応）](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/message.html#message-multi-lang)

### No.5: EntityMeta初期化時に発生したエラーをログに出力するように変更（変更）

UniversalDaoの主キー情報取得処理で例外が発生した場合、警告ログとして出力するよう変更。

> **警告**: UniversalDaoを使用していて主キー情報の取得に失敗しているが、主キーによる検索・更新・削除を行っていない場合に影響がある。ログ出力により性能劣化の可能性あり。ログ監視時に新たな警告が検知される可能性あり。主キー情報の取得に失敗することは通常起こり得ないことなので、DB設定のミスなどが考えられる。出力されるようになったログを確認して対応を検討すること。ログ出力を抑制したい場合は環境設定ファイルに`nablarch.entityMeta.hideCauseExceptionLog=true`を設定する。

**更新モジュール**: nablarch-common-dao 1.6.0

参照: [UniversalDao](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/database/universal_dao.html#sqlcrud)

### No.6: セッションIDだけを変更するAPIを追加（変更）

`SessionUtil.changeId()`メソッドを追加。セッション情報を維持したままセッションIDだけを変更できる（セッション・フィクセーション対策）。従来は`invalidate()`でセッションを破棄するしかなく、ログイン前後でセッション情報を維持するには破棄前後に詰め替え処理が必要だった。

**更新モジュール**: nablarch-fw-web 1.10.0

参照: [セッションストア](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/session_store.html#session-store-authentication-data)

### No.7: HTTPアクセスログで出力できる項目にセッションストアのIDを追加（変更）

HTTPアクセスログでセッションストアのIDを出力できるよう修正。HTTPセッションを使用しないシステムでもセッションレベルのログ追跡が可能になる。

**更新モジュール**: nablarch-fw-web 1.10.0

参照: [HTTPアクセスログ](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/libraries/log/http_access_log.html)

### No.8: ブランクプロジェクトをJava 17で動かす際の修正手順を追加（新規・解説書）

ブランクプロジェクトをJava 17で動かす際に必要な修正手順を解説書に追加。

参照: [Java 17対応手順](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Java17.html)

### No.9: OracleのJDBCドライバの入手方法の説明を修正（変更・解説書）

OracleのJDBCドライバがMavenセントラルリポジトリで公開されるようになったため、ローカルリポジトリへのインストール手順からセントラルリポジトリのJDBCドライバを使用する方法に修正。

参照: [OracleへのDB切替](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/blank_project/CustomizeDB.html#oracle)

### No.10: Nablarch SQL ExecutorのOracleのJDBCドライバdependency修正（変更・解説書）

No.9と同様にOracleのJDBCドライバにセントラルリポジトリのものを使用するようdependency記述を修正。

参照: [SQL Executor pom.xml](https://nablarch.github.io/docs/5u21/doc/development_tools/toolbox/SqlExecutor/SqlExecutor.html#pom-xml)

### No.11: 全ブランクプロジェクト Java 17対応（変更）

Java 17でもビルド・実行できるよう、使用しているライブラリとMavenプラグインのバージョンを更新。Java 17で動かす際にはNo.8の手順を実施する必要がある。

**更新モジュール**: nablarch-web 5u21, nablarch-jaxrs 5u21, nablarch-batch 5u21, nablarch-batch-ee 5u21, nablarch-container-web 5u21, nablarch-container-jaxrs 5u21, nablarch-container-batch 5u21

参照: [ブランクプロジェクト](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/blank_project/index.html)

### No.12: ブランクプロジェクトのMavenの前提バージョンを変更（変更）

Java 17対応のためMavenプラグイン更新に伴い、前提Mavenバージョンを3.0.5から**3.6.3**に変更。

参照: [ブランクプロジェクト前提条件](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/blank_project/beforeFirstStep.html#firststeppreamble)

### No.13: JAX-RSのバージョンを変更（変更）

JAX-RSのアノテーションを使ったルーティング設定で`@PATCH`を使えるよう、`javax.ws.rs-api`のバージョンを2.0から**2.1.1**に変更。

**更新モジュール**: nablarch-jaxrs 5u21, nablarch-container-jaxrs 5u21

参照: [JAX-RSルーティング](https://nablarch.github.io/docs/5u21/doc/application_framework/adaptors/router_adaptor.html#jax-rspath)

### No.14: 全ブランクプロジェクト JUnit5化（変更）

疎通確認テストをJUnit4からJUnit5ベースに書き換え。自動テストフレームワークをJUnit5で使用するための拡張機能も組み込み済み。

**更新モジュール**: nablarch-web 5u21, nablarch-jaxrs 5u21, nablarch-batch 5u21, nablarch-batch-ee 5u21, nablarch-container-web 5u21, nablarch-container-jaxrs 5u21, nablarch-container-batch 5u21

参照: [JUnit5拡張機能](https://nablarch.github.io/docs/5u21/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/JUnit5_Extension.html)

### No.15: 全ブランクプロジェクト プロパティファイルメッセージ管理設定追加（変更）

No.4で追加した`message-by-property-files.xml`をimportするよう変更。デフォルト言語がOS環境によって変動しなくなる。

**更新モジュール**: nablarch-web 5u21, nablarch-jaxrs 5u21, nablarch-batch 5u21, nablarch-batch-ee 5u21, nablarch-container-web 5u21, nablarch-container-jaxrs 5u21, nablarch-container-batch 5u21

参照: [デフォルト設定一覧](https://nablarch.github.io/docs/5u21/doc/_downloads/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88%E8%A8%AD%E5%AE%9A%E4%B8%80%E8%A6%A7.xlsx)

<details>
<summary>keywords</summary>

JSONログ出力, メール送信マルチプロセス化, セッションID変更, HTTPアクセスログ セッションストアID, PropertiesStringResourceLoader, message-by-property-files.xml, nablarch.entityMeta.hideCauseExceptionLog, UniversalDao 主キー警告ログ, SessionUtil.changeId, サーブレットコンテキスト初期化リスナ, Java 17 ブランクプロジェクト, Maven 3.6.3, JAX-RS @PATCH, JUnit5 ブランクプロジェクト, nablarch-core 1.6.0, nablarch-fw-web 1.10.0, nablarch-mail-sender 1.4.2, nablarch-common-dao 1.6.0, nablarch-main-default-configuration 1.4.0

</details>

## Example・ワークフローライブラリ変更点（No.16–20）

## Example・ワークフローライブラリ変更点（No.16–20）

### No.16: JSPとカスタムタグを使用したサンプル Java 17対応（変更）

Java 17でもビルド・実行できるよう、使用しているMavenプラグインのバージョンを更新。Java 17で動かす際にはNo.8の手順を実施する必要がある。

**更新モジュール**: nablarch-example-web 5u21

参照: [Webアプリケーション Getting Started](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/web/getting_started/index.html)

### No.17: RESTfulウェブサービスExampleのJava 17対応（変更）

No.16と同じ内容。

**更新モジュール**: nablarch-example-rest 5u21

参照: [RESTful Webサービス Getting Started](https://nablarch.github.io/docs/5u21/doc/application_framework/application_framework/web_service/rest/getting_started/index.html)

### No.18: Thymeleafを使用したサンプルのJava 17対応（変更）

No.16と同じ内容。

**更新モジュール**: nablarch-example-thymeleaf-web 5u21

参照: [Example](https://nablarch.github.io/docs/5u21/doc/application_framework/example/index.html)

### No.19: 全Example JUnit5化（変更）

JUnit4で書かれていたテストコードをJUnit5を用いたものに書き換え。

**更新モジュール**: nablarch-example-batch 5u21, nablarch-example-batch-ee 5u21, nablarch-example-db-queue 5u21, nablarch-example-http-messaging 5u21, nablarch-example-http-messaging-send 5u21, nablarch-example-mom-delayed-receive 5u21, nablarch-example-mom-delayed-send 5u21, nablarch-example-mom-sync-receive 5u21, nablarch-example-mom-sync-send-batch 5u21, nablarch-example-mom-testing-common 5u21, nablarch-example-rest 5u21, nablarch-example-web 5u21

参照: [JUnit5拡張機能](https://nablarch.github.io/docs/5u21/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/JUnit5_Extension.html)

### No.20: ワークフローライブラリExample Java 17対応（変更）

Java 17でもビルド・実行できるよう、使用しているMavenプラグインとライブラリのバージョンを更新。Java 17で動かす際にはNo.8の手順を実施する必要がある。

**更新モジュール**: nablarch-example-workflow 5u21

参照: [ワークフローライブラリ](https://nablarch.github.io/docs/5u21/doc/extension_components/workflow/doc/index.html)

<details>
<summary>keywords</summary>

Example Java 17対応, 全Example JUnit5化, ワークフローライブラリ Java 17, nablarch-example-web 5u21, nablarch-example-rest 5u21, nablarch-example-thymeleaf-web 5u21, nablarch-example-workflow 5u21, nablarch-example-batch 5u21

</details>

## テスティングフレームワーク変更点（No.21–27）

## テスティングフレームワーク変更点（No.21–27）

### No.21: 使用不許可APIチェックツールの分離（変更）

使用不許可APIチェックツールをテスティングフレームワークから分離し、独立したモジュール（`nablarch-unpublished-api-checker-findbugs`）とした。

> **警告**: 使用不許可APIチェックツールを利用している場合に影響がある。EclipseのSpotbugsプラグインやMavenのSpotbugsプラグインの設定で`nablarch-testing`の代わりに`nablarch-unpublished-api-checker-findbugs`を使用するよう修正が必要。SpotBugs 4.Xを利用する場合はNo.22で追加した`nablarch-unpublished-api-checker`を使用すること。

**更新モジュール**: nablarch-unpublished-api-checker-findbugs 1.0.0

参照: [使用不許可APIチェックツール README](https://github.com/nablarch-development-standards/nablarch-style-guide/blob/3.1/java/staticanalysis/unpublished-api/README.md)

### No.22: SpotBugs 4.Xで実行できる使用不許可APIチェックツールの追加（新規）

従来の使用不許可APIチェックツール（nablarch-unpublished-api-checker-findbugs）はSpotBugs 3.Xでは動作するが、SpotBugs 4.Xでは正しく使用不許可APIを検知できなかった。SpotBugs 4.Xでも使用不許可APIを検知できるツール（`nablarch-unpublished-api-checker`）を追加。

**更新モジュール**: nablarch-unpublished-api-checker 1.0.0

参照: [使用不許可APIチェックツール README](https://github.com/nablarch-development-standards/nablarch-style-guide/blob/3.1/java/staticanalysis/unpublished-api/README.md)

### No.23: Webサービス用テスティングフレームワーク PATCHメソッド追加（変更）

自動テストでHTTPメソッド=PATCHのリクエストを生成できるAPIを追加。あわせて任意のHTTPメソッドでリクエストを生成できるAPIも追加。

**更新モジュール**: nablarch-testing-rest 1.1.0, nablarch-example-rest 5u21

参照: [RESTfulウェブサービステスト](https://nablarch.github.io/docs/5u21/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/RequestUnitTest_rest.html#rest-test-helper)

### No.24: 自動テストフレームワーク JUnit5拡張機能の追加（新規）

JUnit5で書かれたテストの中で自動テストフレームワークを使用できるよう、拡張機能`nablarch-testing-junit5`を追加。JUnit5のネストテスト・パラメータ化テストなどと自動テストフレームワークを組み合わせて利用できる。

> **重要**: Nablarchのバージョンを上げただけでJUnitのバージョンが自動的に4から5に上がることはない。既存のJUnit4で書かれたコードはそのまま実行し続けられる。

**更新モジュール**: nablarch-testing-junit5 1.0.0, nablarch-testing-rest 1.1.0

参照: [JUnit5拡張機能](https://nablarch.github.io/docs/5u21/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/JUnit5_Extension.html)

### No.25: 自動テストフレームワーク MockServletExecutionContextの追加（変更）

`MockServletExecutionContext`を追加。`ServletExecutionContext`はHttpServletRequestなどのServlet APIに依存しておりインスタンス生成に手間がかかるが、`MockServletExecutionContext`はServlet APIのインスタンスなしでインスタンス化できる。ServletExecutionContextに依存したハンドラなどの単体テストが少ない実装コストで作成可能になる。

**更新モジュール**: nablarch-testing 1.4.0

**クラス**: `nablarch.fw.web.servlet.MockServletExecutionContext`

参照: [MockServletExecutionContext Javadoc](https://nablarch.github.io/docs/5u21/publishedApi/nablarch-testing/publishedApiDoc/architect/nablarch/fw/web/servlet/MockServletExecutionContext.html)

### No.26: 自動テストフレームワーク Excelファイルで時刻省略可能に変更（変更）

ExcelファイルのテストデータでJDBCタイムスタンプエスケープ形式（`yyyy-MM-dd HH:mm:ss.SSS`）で日時を記述する際、時刻を省略した`yyyy-MM-dd`形式を許容するよう変更。

**更新モジュール**: nablarch-testing 1.4.0

参照: [自動テストフレームワーク概要](https://nablarch.github.io/docs/5u21/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/01_Abstract.html#id17)

### No.27: 自動テストフレームワーク JUnit 5で動かすための手順を追加（新規・解説書）

自動テストフレームワークをJUnit 5のJUnit Vintageを使って実行するための手順を追加。

参照: [JUnit5 Vintage Engineでの実行手順](https://nablarch.github.io/docs/5u21/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/01_Abstract.html#run-ntf-on-junit5-with-vintage-engine)

<details>
<summary>keywords</summary>

使用不許可APIチェックツール 分離, SpotBugs 4.X対応, nablarch-unpublished-api-checker, nablarch-unpublished-api-checker-findbugs, PATCHメソッド テスト, JUnit5拡張機能 nablarch-testing-junit5, MockServletExecutionContext, Excelテストデータ 時刻省略, JUnit Vintage, nablarch-testing 1.4.0, nablarch-testing-rest 1.1.0, nablarch-testing-junit5 1.0.0

</details>

## バージョンアップ手順

## バージョンアップ手順

Nablarch 5u20から5u21へのバージョンアップ手順:

1. `pom.xml`の`<dependencyManagement>`セクションに指定されている`nablarch-bom`のバージョンを`5u21`に書き換える
2. Mavenのビルドを再実行する

<details>
<summary>keywords</summary>

バージョンアップ手順, nablarch-bom 5u21, pom.xml dependencyManagement, 5u20から5u21

</details>

## 使用不許可APIチェックツールの設定方法

## 使用不許可APIチェックツールの設定方法

SpotBugs 4.XとSpotBugs 3.Xで使用するモジュールが異なる:

- **SpotBugs 4.X**: `nablarch-unpublished-api-checker`（artifactId）
- **SpotBugs 3.X**: `nablarch-unpublished-api-checker-findbugs`（artifactId）

**SpotBugs 4.X設定例（Maven）**:
```xml
<plugin>
  <groupId>com.github.spotbugs</groupId>
  <artifactId>spotbugs-maven-plugin</artifactId>
  <version>4.5.0.0</version>
  <dependencies>
    <dependency>
      <groupId>com.github.spotbugs</groupId>
      <artifactId>spotbugs</artifactId>
      <version>4.5.0</version>
    </dependency>
  </dependencies>
  <configuration>
    <xmlOutput>true</xmlOutput>
    <excludeFilterFile>spotbugs/spotbugs_exclude_for_production.xml</excludeFilterFile>
    <jvmArgs>-Dnablarch-findbugs-config=spotbugs/published-config/production</jvmArgs>
    <maxHeap>1024</maxHeap>
    <plugins>
      <plugin>
        <groupId>com.nablarch.framework</groupId>
        <artifactId>nablarch-unpublished-api-checker</artifactId>
        <version>1.0.0</version>
      </plugin>
    </plugins>
  </configuration>
</plugin>
```

**SpotBugs 3.X設定例（Maven）**:
```xml
<plugin>
  <groupId>com.github.spotbugs</groupId>
  <artifactId>spotbugs-maven-plugin</artifactId>
  <version>3.1.3</version>
  <dependencies>
    <dependency>
      <groupId>com.github.spotbugs</groupId>
      <artifactId>spotbugs</artifactId>
      <version>3.1.3</version>
    </dependency>
  </dependencies>
  <configuration>
    <xmlOutput>true</xmlOutput>
    <excludeFilterFile>spotbugs/spotbugs_exclude_for_production.xml</excludeFilterFile>
    <jvmArgs>-Dnablarch-findbugs-config=spotbugs/published-config/production</jvmArgs>
    <maxHeap>1024</maxHeap>
    <plugins>
      <plugin>
        <groupId>com.nablarch.framework</groupId>
        <artifactId>nablarch-unpublished-api-checker-findbugs</artifactId>
        <version>1.0.0</version>
      </plugin>
    </plugins>
  </configuration>
</plugin>
```

参照: [spotbugs-maven-pluginの組み込み](https://github.com/nablarch-development-standards/nablarch-style-guide/blob/3.1/java/staticanalysis/spotbugs/docs/Maven-settings.md#spotbugs-maven-plugin%E3%82%92%E7%B5%84%E3%81%BF%E8%BE%BC%E3%82%80)

<details>
<summary>keywords</summary>

spotbugs-maven-plugin 設定, SpotBugs 4.X 設定例, SpotBugs 3.X 設定例, nablarch-unpublished-api-checker Maven設定, nablarch-findbugs-config, spotbugs_exclude_for_production.xml

</details>
