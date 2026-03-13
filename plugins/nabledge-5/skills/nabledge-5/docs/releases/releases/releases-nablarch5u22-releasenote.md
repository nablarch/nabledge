# Nablarch 5u22 リリースノート

**公式ドキュメント**: [1](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/libraries/log.html#log-basic-setting) [2](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/libraries/authorization/role_check.html) [3](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/web/feature_details/web_front_controller.html) [4](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/web/getting_started/project_download/index.html) [5](https://nablarch.github.io/docs/5u22/javadoc/nablarch/common/dao/UniversalDao.html) [6](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/libraries/log.html#log-rotation) [7](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/handlers/web/multipart_handler.html#multipart-handler-max-file-count) [8](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/web_service/rest/application_design.html) [9](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_NablarchBatch_Dbless.html) [10](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerBatch_Dbless.html) [11](https://nablarch.github.io/docs/5u22/doc/examples/12/index.html) [12](https://nablarch.github.io/docs/5u22/doc/examples/index.html) [13](https://github.com/nablarch-development-standards/nablarch-development-standards-tools/tree/1.2/%E3%83%90%E3%83%83%E3%83%81%E9%96%8B%E7%99%BA%E8%A3%9C%E5%8A%A9)

## Nablarch 5u22 変更内容とバージョンアップ手順

## Nablarch 5u22 変更内容（5u21からの変更点）

### アプリケーションフレームワーク

**No.1 汎用データフォーマット [変更] nablarch-core-dataformat 1.3.2（起因バージョン: 1.0.0〜1.1.0）**

`FileRecordReader`、`FixedLengthDataRecordFormatter`、`VariableLengthDataRecordFormatter`の3クラスでロガー名が誤って`FileRecordWriter`クラス名になっていた問題を修正。各クラスで自身のクラス名がロガー名として使用されるようになった。

> **警告**: ログ設定ファイル(log.properties)で`nablarch.core.dataformat.FileRecordWriter`に対して個別にロガーを設定しているアプリケーションに影響がある。バージョンアップ後はそのロガー設定が適用されなくなり、ログ出力先やログレベルが変わる可能性がある。

参照: [ログ基本設定](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/libraries/log.html#log-basic-setting)

---

**No.2 認可チェック [新規] nablarch-common-auth 1.2.0 / nablarch-common-auth-session 1.0.0 / nablarch-main-default-configuration 1.4.1**

Javaアノテーションで権限を定義するアノテーションベースの認可チェック機能を新規追加。従来の認可チェックと比較して権限モデルを簡素化し、データ管理・導入コストが低い。

参照: [アノテーションによる認可チェック](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/libraries/authorization/role_check.html)

---

**No.3 ウェブアプリケーションとRESTfulウェブサービスの併用 [変更] nablarch-fw-web 1.11.0**

`RepositoryBasedWebFrontController`（サーブレットフィルタ）が委譲するWebFrontControllerのコンポーネント名を`web.xml`の初期化パラメータで変更可能になった。これにより独自サーブレットフィルタを実装せずに、ハンドラ構成の異なるウェブアプリケーションとウェブサービスを併用できる。

参照: [Webフロントコントローラ](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/web/feature_details/web_front_controller.html)

---

**No.4 ファイルダウンロード [不具合修正] nablarch-fw-web 1.11.0（起因バージョン: 1.5.0 / 5u13〜）**

半角スペースを含むファイル名のダウンロード時の問題を修正:
- 5u13〜5u21: ファイル名が切れる
- 〜5u13: 半角スペースが`+`にエンコードされる

バージョンアップ後は半角スペースを含むファイル名のまま正しくダウンロードされる。

> **警告**: 半角スペースを含むファイル名でダウンロードするアプリケーションで、ファイル名の挙動が変わる。

参照: [ファイルダウンロード](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/web/getting_started/project_download/index.html)

---

**No.5 ユニバーサルDAO [変更] nablarch-common-dao 1.7.0**

`NoDataException`をスローせず`null`を返す1件取得メソッドを追加:
- `UniversalDao.findByIdOrNull()` — `findById()`のnull返却版
- `UniversalDao.findBySqlFileOrNull()` — `findBySqlFile()`のnull返却版

検索結果の有無による処理分岐が、例外キャッチや件数確認SQLなしで実装できる。

参照: [UniversalDao Javadoc](https://nablarch.github.io/docs/5u22/javadoc/nablarch/common/dao/UniversalDao.html)

---

**No.6 ログ出力 [変更] nablarch-core-applog 1.4.0**

日時によるログファイルローテーション機能を追加。従来はファイルサイズのみでのローテーションが可能だった。

参照: [ログローテーション](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/libraries/log.html#log-rotation)

---

**No.7 マルチパートリクエストハンドラ [変更] nablarch-fw-web 1.11.0**

マルチパートリクエストハンドラにアップロードできるファイル数の上限設定機能を追加。従来はファイルサイズの上限のみ設定可能で、ファイル数は設定できなかった。上限を超えた場合に早期に処理を中断できる。

参照: [マルチパートハンドラ ファイル数上限](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/handlers/web/multipart_handler.html#multipart-handler-max-file-count)

---

**No.8 RESTfulウェブサービス 責務配置 [変更]（解説書のみ）**

RESTfulウェブサービスのアウトプットにフォームクラスではなくDTOを使用するよう変更。フォームクラスは全プロパティをString型で定義するが、アウトプットでは各項目に応じた適切なデータ型を持つDTOを使うべきとされる。これにより静的型付けによる恩恵が得られる。

参照: [RESTful アプリケーション設計](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/web_service/rest/application_design.html)

---

**No.9 Nablarchバッチ DBlessブランクプロジェクト [変更]**

DBに接続しないNablarchバッチ用ブランクプロジェクト(`batch-dbless`, `container-batch-dbless`)を追加。以下が追加された:
- DBに接続しないブランクプロジェクトの初期セットアップ手順
- DBに接続しない最小ハンドラ構成
- トランザクション制御を行わないループ制御ハンドラ（標準ハンドラとして追加）
- DB接続設定不要のデフォルト設定ファイル
- デフォルト設定一覧に`batch-dbless`と`container-batch-dbless`を追加

モジュール: `nablarch-batch-dbless 5u22`, `nablarch-container-batch-dbless 5u22`, `nablarch-fw-standalone 1.5.1`, `nablarch-main-default-configuration 1.4.1`, `nablarch-testing 1.4.1`, `nablarch-test-default-configuration 1.2.1`

参照:
- [NablarchバッチDBless セットアップ](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_NablarchBatch_Dbless.html)
- [コンテナバッチDBless セットアップ](https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerBatch_Dbless.html)

---

**No.10-11 ブランクプロジェクト 脆弱性対応**

- **jackson-databind**: 2.10.5.1 → 2.12.7.1（複数の脆弱性対応）
  - 対象: `nablarch-jaxrs 5u22`, `nablarch-container-jaxrs 5u22`
- **H2 database**: 1.3.176 → 2.1.214（複数の脆弱性対応）
  - 対象: `nablarch-web 5u22`, `nablarch-jaxrs 5u22`, `nablarch-batch 5u22`, `nablarch-batch-ee 5u22`, `nablarch-container-web 5u22`, `nablarch-container-jaxrs 5u22`, `nablarch-container-batch 5u22`

### アダプタ

**No.12 JAX-RSアダプタ [変更]**

jackson-databind 2.10.5.1 → 2.12.7.1（脆弱性対応）。

モジュール: `nablarch-jackson-adaptor 1.0.8`, `nablarch-jersey-adaptor 1.0.7`, `nablarch-resteasy-adaptor 1.0.8`

### Example

**No.13 HTTPメッセージング [変更] nablarch-example-http-messaging 5u22**

jackson-databind 2.10.5.1 → 2.12.7.1（脆弱性対応）。変更内容はNo.10と同じ。

---

**No.14 ウェブアプリケーションとRESTfulウェブサービスの併用 [変更] nablarch-example-web 5u22**

ウェブアプリケーションのサンプルにおいて、ウェブアプリケーションとRESTfulウェブサービスを併用するためにWebFrontControllerをシステムリポジトリから取得する独自のサーブレットフィルタを実装していたが、No.3の変更により不要となったため削除した。

---

**No.15 全Example [変更] H2のバージョンアップ**

H2 database 1.3.176 → 2.1.214（脆弱性対応）。変更内容はNo.11と同じ。

対象モジュール:
- `nablarch-example-web 5u22`
- `nablarch-example-thymeleaf-web 5u22`
- `nablarch-example-rest 5u22`
- `nablarch-example-http-messaging-send 5u22`
- `nablarch-example-http-messaging 5u22`
- `nablarch-example-batch-ee 5u22`
- `nablarch-example-batch 5u22`
- `nablarch-example-mom-delayed-send 5u22`
- `nablarch-example-mom-sync-send-batch 5u22`
- `nablarch-example-mom-delayed-receive 5u22`
- `nablarch-example-mom-sync-receive 5u22`
- `nablarch-example-db-queue 5u22`

### ETL基盤

**No.16 ETL基盤 [変更] nablarch-etl 1.2.5**

jackson-databind 2.10.5.1 → 2.12.7.1（脆弱性対応）。変更内容はNo.10と同じ。

### テスティングフレームワーク

**No.17 取引単体テスト [変更] nablarch-testing 1.4.1**

同期応答メッセージ送信処理を伴う取引単体テストで日本語が文字化けしてログに出力されていた問題を修正。対象ケース:
- 要求電文のtext-encodingがUTF-8かつデータに日本語が含まれておりCSV形式でログ出力する場合
- 応答電文のデータに日本語が含まれている場合

**No.18 RESTfulウェブサービス向け単体テストフレームワーク [変更] nablarch-testing-rest 1.1.1**

jackson-databind 2.10.5.1 → 2.12.7.1（脆弱性対応）。

### Nablarch実装例集

**No.19 OIDC IDトークン認証サンプル追加 [追加] nablarch-biz-sample-all 2.0.0**

外部認証基盤からOIDCで発行されるIDトークンを用いた認証サンプルを追加。対応サービス: Amazon Cognito、Azure Active Directory B2C。

参照: [OIDC認証サンプル](https://nablarch.github.io/docs/5u22/doc/examples/12/index.html)

---

**No.20 実装例集 Nablarch5対応 [変更] nablarch-biz-sample-all 2.0.0**

実装例集をNablarch 5系に対応。Nablarch 1.4系時代に作成されメンテナンスされていなかったサンプルを5系前提に修正し、時代遅れで参照されないサンプルを削除。

モジュール: `nablarch-biz-sample-all 2.0.0`, `nablarch-smime-integration 1.2.0`, `nablarch-statistics-report 1.2.0`

参照: [実装例集](https://nablarch.github.io/docs/5u22/doc/examples/index.html)

### Nablarch開発標準

**No.21 バッチ開発補助 ShellCheck対応 [変更] nablarch-development-standards-tools 1.2**

Shell Script自動生成ツールが生成するシェルスクリプトおよびscripts.zipに含まれるシェルスクリプトでShellCheckによる警告が出ないように修正。

参照: [バッチ開発補助ツール](https://github.com/nablarch-development-standards/nablarch-development-standards-tools/tree/1.2/%E3%83%90%E3%83%83%E3%83%81%E9%96%8B%E7%99%BA%E8%A3%9C%E5%8A%A9)

---

**No.22 バッチ開発補助 ファイル受信バッチ不具合修正 [変更] nablarch-development-standards-tools 1.2（システムへの影響あり: 本番）**

Shell Script自動生成ツールのファイル受信バッチにおいて、授受先ディレクトリが存在しなかった場合の戻り値が誤って112を返していた問題を修正。正しくは113を返す。

> **警告**: 新バージョンのツールでファイル受信バッチの起動スクリプトを再生成して稼働環境に適用する場合に影響がある。戻り値112で授受先ディレクトリ非存在エラーを明示的にハンドリングしているスクリプトは、バージョンアップ後は戻り値113でハンドリングするよう修正が必要。

参照: [バッチ開発補助ツール](https://github.com/nablarch-development-standards/nablarch-development-standards-tools/tree/1.2/%E3%83%90%E3%83%83%E3%83%81%E9%96%8B%E7%99%BA%E8%A3%9C%E5%8A%A9)

---

## バージョンアップ手順

1. `pom.xml`の`<dependencyManagement>`セクションに指定されているnablarch-bomのバージョンを`5u22`に書き換える
2. Mavenビルドを再実行する

**シェルスクリプト自動生成ツールのバージョンアップ:**

以下のURLから新バージョン(1.2)をダウンロード:
[https://github.com/nablarch-development-standards/nablarch-development-standards-tools/tree/1.2/%E3%83%90%E3%83%83%E3%83%81%E9%96%8B%E7%99%BA%E8%A3%9C%E5%8A%A9](https://github.com/nablarch-development-standards/nablarch-development-standards-tools/tree/1.2/%E3%83%90%E3%83%83%E3%83%81%E9%96%8B%E7%99%BA%E8%A3%9C%E5%8A%A9)

シェル共通設定.xlsx、ジョブ実行シェルスクリプト自動生成設定.xlsxには変更がないため、既存ファイルをそのまま流用できる。

<details>
<summary>keywords</summary>

5u22 リリースノート, バージョンアップ手順, nablarch-bom 5u22, 認可チェック アノテーション, ユニバーサルDAO null返却, findByIdOrNull, findBySqlFileOrNull, NoDataException, UniversalDao, ログ 日付ローテーション, マルチパート ファイル数上限, ファイルダウンロード 半角スペース, RepositoryBasedWebFrontController, WebFrontController コンポーネント名, RESTfulウェブサービス DTO アウトプット, DBless バッチ ブランクプロジェクト, jackson-databind 脆弱性対応 2.12.7.1, H2 バージョンアップ 2.1.214, OIDC IDトークン認証 Amazon Cognito Azure AD B2C, 取引単体テスト 文字化け, ファイル受信バッチ 戻り値 113, FileRecordReader ロガー名, FixedLengthDataRecordFormatter, VariableLengthDataRecordFormatter, FileRecordWriter, nablarch-core-dataformat, nablarch-common-auth, nablarch-common-dao, nablarch-fw-web, nablarch-core-applog, nablarch-development-standards-tools, HTTPメッセージング jackson-databind Example, nablarch-example-http-messaging, ウェブアプリケーション RESTfulウェブサービス 併用 Example サーブレットフィルタ削除, nablarch-example-web, 全Example H2 バージョンアップ, nablarch-example-thymeleaf-web, nablarch-example-rest, nablarch-example-http-messaging-send, nablarch-example-batch-ee, nablarch-example-batch, nablarch-example-mom-delayed-send, nablarch-example-mom-sync-send-batch, nablarch-example-mom-delayed-receive, nablarch-example-mom-sync-receive, nablarch-example-db-queue, ETL基盤 jackson-databind, nablarch-etl

</details>
