# Nablarch 5u11 リリースノート

**公式ドキュメント**: [Nablarch 5u11 リリースノート](https://fintan.jp/page/252/)

## Nablarch 5u11 変更内容（5u10からの変更点）

## Nablarch 5u11 変更内容（5u10からの変更点）

### システムへの影響がある変更（要対応）

**No.3 リダイレクト時のステータスコード修正** (`nablarch-fw-web 1.4.2`、起因: 1.0.0/1.2.1)
301/303/307を指定しても302が返されていた不具合を修正。アプリケーションで301/303/307を指定していた場合、クライアントに正しいコードが返るようになる。リクエスト単体テストで期待値に302を指定していた場合、クライアントに戻される値が303等に変わるためテストの期待値を修正する必要がある。

**No.6 batch-ee進捗ログのキーワード変更** (`nablarch-fw-batch-ee 1.3.0`)
進捗ログに出力する全体のTPSのキーワードが`tps`から`total tps`に変更。ログ監視や解析でキーワードを使用している場合は修正が必要。

**No.26 ETL: SQL*Loader設定方法変更** (`nablarch-etl 1.2.0`)
SQL*Loaderのデータベース接続先情報の設定方法を変更。旧設定（グローバル領域/環境設定ファイルへの定義）から、`SqlLoaderConfig`をコンポーネント設定ファイルに設定する方式に変更する必要がある。参照先: Nablarch拡張コンポーネント:ETL:Extractフェーズ(SQL*Loader版)を使用する。

**No.34 テスティングフレームワーク: リダイレクトステータスコードアサート修正** (`nablarch-testing 1.1.1`、起因: 1.0.0/1.1.0)
302と303を区別していなかった不具合を修正。以下の場合にテストが落ちるようになるため対応が必要:
- 期待値:302、実際の値:303
- 期待値:303、実際の値:302

テストが落ちた場合は、設計書を参考に期待値と実際の値が一致するよう修正すること。

### 新機能・追加

**No.22 JSR310アダプタ追加** (`nablarch-jsr310-adaptor 1.0.0`)
Java 8のJSR310(Date and Time API)を扱うためのアダプタを追加。以下が可能になる:
- BeanUtilでJSR310で追加されたクラスへの型変換
- データベース入出力時のJSR310で追加されたクラスへの型変換

**No.12 データバインド: 固定長データ入出力機能追加** (`nablarch-common-databind 1.2.0`)
データバインドに固定長データの入出力機能を追加。

**No.24 固定長データ入出力機能のExampleアプリケーション追加** (`nablarch-example-batch-ee 5u11`)
データバインドへの固定長データ入出力機能追加（No.12）に伴い、当該機能のExampleアプリケーションを追加。参照先: Exampleアプリケーション

**No.14 データバインド: CSV↔MapのヘッダーレコードをBeanと同様に任意化** (`nablarch-common-databind 1.2.0`)
CSV→Map及びMap→CSV変換時にヘッダーレコードが必須だった制約を削除。Beanを使用した場合と同様に、ヘッダーレコードは必要な場合のみ使用できるよう変更。

**No.11 メール送信: トランザクション分離機能追加** (`nablarch-mail-sender 1.3.0`)
`MailRequester`にメール送信要求用のトランザクションを指定できる機能を追加。

**No.23 DomaアダプタでNablarch DBアクセス機能の併用対応** (`nablarch-doma-adaptor 1.1.0`)
domaのトランザクション制御配下でNablarchのデータベースアクセス機能が使用可能になる（例: domaを使用した場合でもNablarchのメール送信機能も同時に使用可能）。

**No.15 Dialect型変換を設定で差し替え可能に変更** (`nablarch-core-jdbc 1.3.0`)
Dialectが使用する型変換処理（`AttributeConverter`）を、Dialect自体を作成・差し替えせずに設定ファイルで指定できるよう変更。

**No.9 JSR352バッチ起動時にproperties指定可能** (`nablarch-fw-batch-ee 1.3.0`, `nablarch-fw-standalone 1.2.0`)
`nablarch.fw.batch.ee.Main`実行時にコマンドラインオプションが指定可能になる。指定したコマンドラインオプションは`javax.batch.operations.JobOperator#start`のpropertiesへ引き継がれる。

**No.7 JSR352各リスナからContext取得可能** (`nablarch-fw-batch-ee 1.3.0`)
各リスナからJobContext、StepContextを取得可能になる。

**No.8 JSR352公開API追加** (`nablarch-fw-batch-ee 1.3.0`)
以下のクラスを公開APIに追加:
- `NablarchListenerContext`
- `AbstractNablarchItemWriteListener`
- `AbstractNablarchJobListener`
- `AbstractNablarchStepListener`

**No.2 公開API追加** (`nablarch-fw-web 1.4.2`)
`nablarch.fw.web.servlet.ServletExecutionContext#getNativeHttpSession` を公開APIに変更。

**No.28/29 ワークフローライブラリ: BPMNからステートマシン定義生成ツール追加** (v1.1.0)
BPMNのバリデーションおよびワークフローライブラリ用ステートマシン定義情報の出力機能を追加。ワークフローツールをMavenプラグインに変更、出力形式はCSV（gspプラグインでロード可能）。Mavenを使用していないプロジェクトでは旧バージョンを使用すること。

**No.25 ETL進捗ログの初回TPS算出改善** (`nablarch-etl 1.2.0`)
ETLの進捗ログにおける初回TPS算出時に、カーソルを開くなどの初期化処理全体を含めていたため実際よりも小さい値が出力されていた問題を修正。算出処理を見直し、初期化処理を含まないよう改善した。

### 不具合修正

**No.1 HttpSession invalidate時のIllegalStateException抑制** (`nablarch-fw-web 1.4.2`)
既に無効化したセッションを再度無効にした際の`IllegalStateException`を抑制するよう変更。HTTPセッションのinvalidate時に`IllegalStateException`をハンドルしていた場合はその処理は不要になる。

**No.5 PostgreSQLでbatch-ee Chunk使用不可問題修正** (`nablarch-fw-batch-ee 1.3.0`, `nablarch-etl 1.2.0`)
PostgreSQLでDBをインプットとするChunkが利用できない問題を修正。ETLで提供しているDBインプットリーダにも同様の対応を実施。

**No.10 ファイルアップロード: bad requestエラー修正** (`nablarch-fw-web 1.4.2`、起因: 1.0.0/1.1.0)
`HttpCharacterEncodingHandler`をハンドラキューに設定した状態でglassfish(payara)でファイルアップロードを行うと必ずbad requestになる問題を修正（マルチパートヘッダー解析処理の仕様誤りが原因）。

**No.13 HTTPメッセージング: content-type大小文字区別不具合修正** (`nablarch-fw-messaging-http 1.0.2`、起因: 1.0.0/1.4.0)
content-type取得時に大文字・小文字を区別して「Content-Type」でなければ取得できなかった不具合を修正。

**No.4 100系ステータスコードの扱い修正** (`nablarch-fw-web 1.4.2`、起因: 1.0.0/5)
100系（100:継続、101:プロトコル切り替え等）のステータスコードをエラーコードとしてクライアントに返していた不具合を修正。

### 非推奨

**No.20 prettyPrint非推奨**（JSPカスタムタグ）
`prettyPrint`はサニタイジング対象外のタグと属性を全て列挙する必要があり設定の誤りの原因となるため非推奨。markdownの検討、またはサーバサイドで適切なバリデーションを実施しサニタイジングせずに出力する対応を推奨。

**No.21 `static_content_version`によるキャッシュ管理非推奨**（JSPカスタムタグ）
`static_content_version`を使用した静的コンテンツのバージョン管理は全アプリケーションで1つのバージョンしか指定できない問題があるため非推奨。

### 制約・注意事項

**No.33 UI開発基盤はNablarch5に対応していない**（重要）
UI開発基盤（Nablarch UI開発基盤）はNablarch5に対応していない。Nablarch5プロジェクトでUI開発基盤を使用することはできない。参照先: Nablarch開発ツール:フロントエンド上級者向けのUI開発基盤:Nablarch UI開発基盤 解説書

**No.17 JSR352 JobContext/StepContext一時領域の使用禁止**
JSR352に準拠したバッチアプリケーションにおいて、`JobContext`および`StepContext`の一時領域はアプリケーションで使用してはならない。参照先: アプリケーションフレームワーク:バッチアプリケーション編:JSR352に準拠したバッチアプリケーション:アーキテクチャ概要

**No.18 JSR352 進捗ログ開始ポイント後の重い処理に関する注意**
進捗ログの開始ポイントの後にカーソルを開く等の重い処理を行うと、進捗ログのTPSに実際よりも小さい値が出力される。パフォーマンス分析やTPS監視を行う場合は注意すること。参照先: アプリケーションフレームワーク:バッチアプリケーション編:JSR352に準拠したバッチアプリケーション:機能詳細:進捗状況のログ出力

**No.19 JSR352 エラー発生時の処理の流れとログ出力の仕組み**
JSR352に準拠したバッチアプリケーションにおける例外発生時の処理の流れおよびログ出力の仕組みが解説書に追記された。参照先: アプリケーションフレームワーク:バッチアプリケーション編:JSR352に準拠したバッチアプリケーション:アーキテクチャ概要:バッチアプリケーションの処理の流れ:例外(エラー含む)発生時の処理の流れ

### 文書修正・改善

**No.16 ウェブアプリケーション使用ハンドラ一覧の記載漏れ修正**
ウェブアプリケーションで使用するハンドラ一覧にサービス提供可否チェックハンドラが漏れていたため追記。参照先: アプリケーションフレームワーク:ウェブアプリケーション編:アーキテクチャ概要:ウェブアプリケーションで使用するハンドラ

**No.27 ETL解説書の全面見直し**
ETL解説書を全面的に見直し、以下の改善を実施。設計時に考慮すべき点（制約等）の追記、各フェーズに対する設定値の説明追加。参照先: Nablarch拡張コンポーネント:ETL

**No.30 ワークフローライブラリ: ステートマシン機能の解説追記**
ワークフローライブラリをステートマシンとして利用できることを解説書に追記。参照先: Nablarch拡張コンポーネント:ワークフローライブラリ

**No.31 ワークフロー設計ガイドの削除**
BPMNのモデリングツールの使用方法を記載した設計ガイドを解説書から削除。モデリングツールのバージョンアップによりUIが大幅に変更されるため、参照による混乱を避けるために削除された。設計ガイドへの参照はもはや有効ではない。

**No.32 ワークフローサンプルアプリケーションのNablarch5対応**
Nablarch1.4ベースで構築されていたワークフローサンプルアプリケーションをNablarch5対応に更新。他のExampleと同様にMavenプロジェクト形式に変更。

**No.35 テスティングフレームワーク: ExcelテストデータのDB型制約追記**
データベースを使用するクラスのテストにおいて、テストデータとしてExcelに記述できるカラムのデータ型に関する制約を追記。参照先: Nablarch開発ツール:大規模開発向け重厚なテスティングフレームワーク:自動テストフレームワークの使用方法:データベースを使用するクラスのテスト:注意点:Excelファイルに記述できるカラムのデータ型に関する注意点

**No.36 Javaコーディング規約 F-FMT-e05のコード例修正**
Javaコーディング規約F-FMT-e05のコード例を修正。Stringの`+`についての説明でappendを使う誤ったコード例になっていたものを、`+`を使う正しい例に修正。

### バージョンアップ手順

1. `pom.xml`の`<dependencyManagement>`セクションに指定されている`nablarch-bom`のバージョンを`5u11`に書き換える
2. Mavenのビルドを再実行する

### 修正後バージョン一覧

| モジュール | バージョン |
|---|---|
| nablarch-fw-web | 1.4.2 |
| nablarch-fw-batch-ee | 1.3.0 |
| nablarch-etl | 1.2.0 |
| nablarch-fw-standalone | 1.2.0 |
| nablarch-fw-messaging-http | 1.0.2 |
| nablarch-mail-sender | 1.3.0 |
| nablarch-common-databind | 1.2.0 |
| nablarch-core-jdbc | 1.3.0 |
| nablarch-jsr310-adaptor | 1.0.0 |
| nablarch-doma-adaptor | 1.1.0 |
| nablarch-testing | 1.1.1 |

<details>
<summary>keywords</summary>

5u11, リリースノート, バージョンアップ手順, nablarch-bom, ステータスコード, リダイレクト, 進捗ログ, TPS, SQL*Loader, SqlLoaderConfig, JSR310アダプタ, nablarch-jsr310-adaptor, 固定長データ, データバインド, nablarch-common-databind, MailRequester, メール送信トランザクション, nablarch-mail-sender, Domaアダプタ, nablarch-doma-adaptor, prettyPrint, 非推奨, static_content_version, HttpCharacterEncodingHandler, PostgreSQL, Chunk, NablarchListenerContext, AbstractNablarchJobListener, AbstractNablarchStepListener, AbstractNablarchItemWriteListener, ServletExecutionContext, getNativeHttpSession, nablarch-fw-web, nablarch-fw-batch-ee, nablarch-etl, nablarch-testing, nablarch-core-jdbc, nablarch-fw-messaging-http, IllegalStateException, HttpSession, UI開発基盤, JobContext, StepContext, 一時領域, ステートマシン, ワークフロー設計ガイド, サービス提供可否チェック, F-FMT-e05, Javaコーディング規約, Excelデータ型, ETL解説書, ワークフローサンプルアプリ, nablarch-example-batch-ee, AttributeConverter, nablarch-fw-standalone

</details>
