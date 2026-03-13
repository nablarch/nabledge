# Nablarch 5u20 リリースノート

**公式ドキュメント**: [1](https://nablarch.github.io/docs/5u20/doc/application_framework/application_framework/handlers/common/request_handler_entry.html) [2](https://nablarch.github.io/docs/5u20/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerBatch.html) [3](https://nablarch.github.io/docs/5u20/doc/application_framework/adaptors/log_adaptor.html#id2) [4](https://nablarch.github.io/docs/5u20/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/send_sync.html#id17)

## 5u20 変更内容一覧

## アプリケーションフレームワーク

### No.1: リクエストハンドラエントリのパターン判定不具合修正（不具合）

**修正モジュール**: nablarch-core 1.5.2（起因バージョン: 1.0.0）

以下2ケースでパターン判定が誤っていたため修正:

| ケース | パターン | リクエストパス | 正しい判定結果 |
|---|---|---|---|
| ① | `/app//*` | `/app/test/index.jsp` | マッチしない |
| ② | `/app/*/*` | `/app/xxx/yyy` | マッチする |

- **ケース①対応**: ディレクトリパスが `//` で終わり、リソース名が `*` の場合、拡張子を含むパスにマッチしないよう修正。拡張子を含むパスにマッチさせたい場合は `//` に変更すること（例: `/app//*` → `/app//`）。`//` は前方一致のみで判定。
- **ケース②対応**: ディレクトリパスの一部に `*` があり、リソース名も `*` の場合、`.` を含まない任意文字列とマッチするよう修正。修正前はこのパターンを指定してもマッチすることがなかった（ハンドラが処理を行わない状態）。

> **重要**: ケース①または②に該当するパターンを使用しているアプリケーションは影響有無を確認し、必要に応じて対応すること。

参照: [リクエストハンドラエントリ](https://nablarch.github.io/docs/5u20/doc/application_framework/application_framework/handlers/common/request_handler_entry.html)

### No.2: 5u18で発生したリクエストハンドラエントリのリグレッション修正（不具合）

**修正モジュール**: nablarch-core 1.5.2（起因バージョン: 1.5.1 / 5u18）

5u18で対応した「パターンバリデーション修正」の際にリクエストパターン判定が変わるリグレッションが発生。パターン `/app/*` に対してリクエストパス `/app/test` がマッチしなくなっていたのを、5u17以前の挙動（マッチする）に戻した。

条件: ディレクトリパスに `/` だけでなく `/app` 等の階層を持ち、かつリソース名が `*` の場合に発生。`/*` のようにディレクトリパスが `/` のみのケースは該当しない。

> **重要**: 5u18または5u19を採用しており、上記条件に該当するパターンを指定しているアプリケーションは動作確認が必要。修正前はこのパターンを指定してもハンドラが処理を行わない状態だったため、修正後に有効化されることを確認すること。

参照: [リクエストハンドラエントリ](https://nablarch.github.io/docs/5u20/doc/application_framework/application_framework/handlers/common/request_handler_entry.html)

### No.3: コンテナ用ブランクプロジェクト追加（変更）

**修正モジュール**: nablarch-container-web-archetype 5u20 / nablarch-container-jaxrs-archetype 5u20 / nablarch-container-batch-archetype 5u20

- Nablarchバッチプロジェクト向けコンテナブランクプロジェクト `nablarch-container-batch-archetype` を新規追加。
- 全コンテナ用ブランクプロジェクト（nablarch-container-web、nablarch-container-jaxrs、nablarch-container-batch）において、ベースDockerイメージの指定方法をダイジェストからタグに変更。

参照: [コンテナバッチブランクプロジェクトセットアップ](https://nablarch.github.io/docs/5u20/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerBatch.html)

### No.4: JSR352バッチプロジェクト - Guavaバージョンアップ（変更）

**修正モジュール**: nablarch-batch-ee-archetype 5u20

CVE-2020-8908 対応。JSR352バッチプロジェクトの依存ライブラリGuavaを脆弱性対応済みバージョンに更新。NablarchではCVE対象機能を使用していないため、プロジェクトで個別に該当機能を使用していなければ既存プロジェクトへの影響なし。

### No.5: JSR352バッチプロジェクト - Logbackバージョンアップ（変更）

**修正モジュール**: nablarch-batch-ee-archetype 5u20

CVE-2017-5929 対応。JSR352バッチプロジェクトの依存ライブラリLogbackを脆弱性対応済みバージョンに更新。NablarchではCVE対象機能を使用していないため、プロジェクトで個別に該当機能を使用していなければ既存プロジェクトへの影響なし。

### No.6: ハンドラキューの最適化（変更）

**修正モジュール**: nablarch-web-archetype 5u20 / nablarch-jaxrs-archetype 5u20 / nablarch-batch-archetype 5u20 / nablarch-container-web-archetype 5u20 / nablarch-container-jaxrs-archetype 5u20

アーキタイプおよびExampleで以下3ハンドラのキュー順序が統一されていなかったため、すべてのアーキタイプ・Exampleで順序を統一:
- `HttpCharacterEncodingHandler`
- `ThreadContextClearHandler`
- `GlobalErrorHandler`

## アダプタ

### No.7: SLF4J logアダプタ - FATALレベルのERRORマッピング追記（変更）

SLF4JにはFATALレベルが存在しないため、SLF4J logアダプタ使用時にFATALレベルのログはERRORレベルで出力される旨をドキュメントに追記。

参照: [logアダプタ - SLF4J](https://nablarch.github.io/docs/5u20/doc/application_framework/adaptors/log_adaptor.html#id2)

## Example

### No.8: nablarch-example-batch-ee - Guavaバージョンアップ（変更）

**修正モジュール**: nablarch-example-batch-ee 5u20

変更内容はNo.4（JSR352バッチプロジェクトのGuava脆弱性対応）と同じ。CVE-2020-8908 対応。

### No.9: nablarch-example-batch-ee - Logbackバージョンアップ（変更）

**修正モジュール**: nablarch-example-batch-ee 5u20

変更内容はNo.5（JSR352バッチプロジェクトのLogback脆弱性対応）と同じ。CVE-2017-5929 対応。

### No.10: Exampleモジュール - ハンドラキューの最適化（変更）

**修正モジュール**: 以下9モジュールの 5u20
- nablarch-example-batch
- nablarch-example-http-messaging-send
- nablarch-example-mom-delayed-receive
- nablarch-example-mom-delayed-send
- nablarch-example-mom-sync-receive
- nablarch-example-mom-sync-send-batch
- nablarch-example-rest
- nablarch-example-thymeleaf-web
- nablarch-example-web

変更内容はNo.6（ハンドラキューの最適化）と同じ。`HttpCharacterEncodingHandler`・`ThreadContextClearHandler`・`GlobalErrorHandler` の順序を統一。

## テスティングフレームワーク

### No.11: 同期応答メッセージ送信テスト - Excelファイル再読み込み不具合修正（不具合）

**修正モジュール**: nablarch-testing 1.3.2（モジュール起因バージョン: 1.0.0 / Nablarch起因バージョン: 1.2.3）

同期応答メッセージ送信処理を伴う取引単体テスト用モックアップクラスにて、テスト用ExcelファイルのタイムスタンプUpdated時にファイルが再読み込みされない不具合を修正。

参照: [送受信取引テスト](https://nablarch.github.io/docs/5u20/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/send_sync.html#id17)

## Nablarch開発標準

### No.12: 外部インタフェース設計書フォーマット改善（変更）

**修正モジュール**: nablarch-development-standards 2.1

JSON/XML用外部インタフェース設計書フォーマットとサンプルを改善:
- 旧形式: オブジェクト階層を項目IDを `[ ]` で囲む記述ルールでフラット表現 → 新形式: 階層別にテーブルを分割し視認性向上
- 桁数カラムを追加

> **重要(開発)**: 新フォーマットを使用してフォーマット定義ファイルを自動生成する場合は、No.13で対応したnablarch-development-standards-tools 1.1を使用すること。旧バージョンのツールでは新フォーマットからの定義ファイル生成が不可。

### No.13: フォーマット定義ファイル自動生成ツール修正（変更）

**修正モジュール**: nablarch-development-standards-tools 1.1

No.12で変更した新フォーマットに対応するようツールを修正。

<details>
<summary>keywords</summary>

リクエストハンドラエントリ, パターンマッチング不具合, nablarch-core 1.5.2, コンテナ用ブランクプロジェクト, nablarch-container-batch-archetype, Guava脆弱性, CVE-2020-8908, Logback脆弱性, CVE-2017-5929, ハンドラキュー最適化, HttpCharacterEncodingHandler, ThreadContextClearHandler, GlobalErrorHandler, SLF4J FATALレベル, 同期応答メッセージ送信テスト, nablarch-testing 1.3.2, 外部インタフェース設計書, フォーマット定義ファイル自動生成ツール, 不具合修正, 5u18 リグレッション, nablarch-example-batch-ee, nablarch-example-batch, nablarch-example-http-messaging-send, nablarch-example-mom-delayed-receive, nablarch-example-mom-delayed-send, nablarch-example-mom-sync-receive, nablarch-example-mom-sync-send-batch, nablarch-example-rest, nablarch-example-thymeleaf-web, nablarch-example-web

</details>

## バージョンアップ手順

## バージョンアップ手順

5u20の適用手順:

1. `pom.xml` の `<dependencyManagement>` セクションに指定されている `nablarch-bom` のバージョンを `5u20` に書き換える
2. Mavenのビルドを再実行する

<details>
<summary>keywords</summary>

バージョンアップ手順, nablarch-bom, pom.xml, dependencyManagement, 5u20 適用手順

</details>
