# Knowledge Index

## about/about-nablarch

### Nablarchについて
path: about/about-nablarch/about-nablarch-about-nablarch.json

### アプリケーションフレームワーク
path: about/about-nablarch/about-nablarch-application-framework-application-framework-index.json

### アーキテクチャ
path: about/about-nablarch/about-nablarch-architecture.json
- s1: Nablarchアプリケーションフレームワークの主な構成要素
- s2: ハンドラキュー(handler queue)
  - s3: インターセプタ(interceptor)
- s4: ライブラリ(library)

### 全体像
path: about/about-nablarch/about-nablarch-big-picture.json

### Nablarchのコンセプト
path: about/about-nablarch/about-nablarch-concept.json
- s1: Robustness
- s2: Testability
- s3: Ready-to-Use

### Example
path: about/about-nablarch/about-nablarch-examples.json
- s1: Exampleの実行方法
  - s2: 環境構築手順
  - s3: 実行手順
  - s4: Java 21 で動かす場合
- s5: Exampleの一覧
  - s6: ウェブアプリケーション
  - s7: ウェブサービス
  - s8: バッチアプリケーション
  - s9: メッセージング

### Nablarchでの開発に役立つコンテンツ
path: about/about-nablarch/about-nablarch-external-contents.json
- s1: Nablarchシステム開発ガイド
- s2: 開発標準

### 機能追加要望・改善要望
path: about/about-nablarch/about-nablarch-inquiry.json
- s1: JIRAへの課題起票方法

### Nablarchアプリケーションフレームワーク
path: about/about-nablarch/about-nablarch-ja-application-framework-index.json

### Jakarta EEの仕様名に関して
path: about/about-nablarch/about-nablarch-jakarta-ee.json
- s1: 省略名の表記に関して
- s2: Nablarch5と6で名称が変更になった機能について

### Nablarchのライセンスについて
path: about/about-nablarch/about-nablarch-license.json

### Nablarch のモジュール一覧
path: about/about-nablarch/about-nablarch-mvn-module.json

### Nablarch API
path: about/about-nablarch/about-nablarch-nablarch-api.json

### Nablarchアプリケーションフレームワークとは
path: about/about-nablarch/about-nablarch-nablarch.json

### 稼動環境
path: about/about-nablarch/about-nablarch-platform.json
- s1: Nablarchフレームワークの環境要件
- s2: Nablarchフレームワークのテスト環境

### 基本方針
path: about/about-nablarch/about-nablarch-policy.json
- s1: 外部から受け付ける未入力値の扱い
- s2: コレクションや配列を返すAPIは原則nullを戻さない
- s3: Nablarchは検査例外を送出しない
- s4: ログや例外のメッセージは英語で統一する
- s5: コンポーネントを差し替えることでNablarchが発行するSQLを変更できる
- s6: OSSは使用しない
- s7: 複数の例外が発生した場合は起因例外をスローする
- s8: スレッドセーフである
- s9: Java17に準拠している
- s10: アプリケーションで使用してもよいAPIについて
- s11: 文字列からBigDecimal変換時に発生する可能性のあるヒープ不足について
- s12: 非推奨(Deprecated)APIについて

### ご利用にあたって
path: about/about-nablarch/about-nablarch-terms-of-use.json
- s1: 情報の外部送信について
- s2: 情報の利用目的
- s3: 情報の送信先
- s4: 情報の種類・用途

### Nablarch のバージョンアップ方針
path: about/about-nablarch/about-nablarch-versionup-policy.json
- s1: リリース単位
- s2: バージョンアップの種類
- s3: バージョンの番号体系
- s4: 後方互換性ポリシー
  - s5: 後方互換性を維持する範囲
  - s6: 後方互換性維持の内容
  - s7: 後方互換性の例外

## about/migration

### Nablarch 5から6への移行ガイド
path: about/migration/migration-migration.json
- s1: Nablarch 5と6で大きく異なる点
  - s2: Jakarta EE 10に対応
  - s3: 動作に必要なJavaの最低バージョンを17に変更
- s4: 前提条件
- s5: 移行手順の概要
- s6: 移行手順の詳細
  - s7: Nablarchのバージョンアップ
  - s8: Jakarta EE対応
- s29: JSR352に準拠したバッチアプリケーションの移行手順
  - s30: 実行時にエラーになる場合の対処方法
- s32: 付録
  - s33: Java EEとJakarta EEの仕様の対応表

## about/release-notes

### リリース情報
path: about/release-notes/release-notes-releases.json

## check/security-check

### 1.概要
path: check/security-check/security-check-1.概要.json

### 2.チェックリスト
path: check/security-check/security-check-2.チェックリスト.json
- s1: SQLインジェクション
- s2: OSコマンド・インジェクション
- s3: パス名パラメータの未チェック／ディレクトリ・トラバーサル
- s4: セッション管理の不備
- s5: クロスサイト・スクリプティング
- s6: CSRF （クロスサイト・リクエスト・フォージェリ）
- s7: HTTPヘッダ・インジェクション
- s8: メールヘッダ・インジェクション
- s9: クリックジャッキング
- s10: バッファオーバーフロー
- s11: アクセス制御や認可制御の欠落
- s12: ※ このチェック項目の「対応済」のチェックは、実施項目のいずれかを実施した場合にチェックします。

### 3.PCIDSS対応表
path: check/security-check/security-check-3.PCIDSS対応表.json

### 改訂履歴
path: check/security-check/security-check-改訂履歴.json
- s1: 2013-09-30 00:00:00
- s2: 2020-04-28 00:00:00
- s3: 2020-05-19 00:00:00
- s4: 2022-07-12 00:00:00
- s5: 2022-07-12 00:00:00
- s6: 区分：新規、追加、変更、削除

## component/adapters

### アダプタ
path: component/adapters/adapters-adaptors.json

### Domaアダプタ
path: component/adapters/adapters-doma-adaptor.json
- s2: Domaアダプタを使用するための設定を行う
  - s3: 依存関係の設定
  - s4: 使用するRDBMSに合わせてDomaのダイアレクトやデータソースを設定する
- s5: Domaを使用してデータベースにアクセスする
  - s6: Daoインタフェースを作成する
  - s7: データベースアクセス処理を実装する
- s8: 別トランザクションで実行する
- s9: Jakarta Batchに準拠したバッチアプリケーションで使用する
- s10: Jakarta Batchに準拠したバッチアプリケーションで遅延ロードを行う
- s11: 複数のデータベースにアクセスする
- s12: DomaとNablarchのデータベースアクセスを併用する
- s13: ロガーを切り替える
- s14: java.sql.Statementに関する設定を行う
- s15: Doma 2.44.0までの実装方法から移行する
  - s16: DomaConfigを使った基本的な実装をしている場合
  - s17: DomaTransactionNotSupportedConfigを使用して遅延ロードに対応している場合
  - s18: 独自にConfigクラスを作成している場合

### Jakarta RESTful Web Servicesアダプタ
path: component/adapters/adapters-jaxrs-adaptor.json
- s2: Jersey環境下でRESTfulウェブサービスを使用する
- s3: RESTEasy環境下でRESTfulウェブサービスを使用する
- s4: 各環境下で使用するボディコンバータを変更（追加）したい

### JSR310(Date and Time API)アダプタ
path: component/adapters/adapters-jsr310-adaptor.json
- s2: 使用方法

### Lettuceアダプタ
path: component/adapters/adapters-lettuce-adaptor.json

### logアダプタ
path: component/adapters/adapters-log-adaptor.json
- s4: ロギングフレームワークを使用するための設定を行う
  - s5: slf4j
  - s6: JBoss Logging

### E-mail FreeMarkerアダプタ
path: component/adapters/adapters-mail-sender-freemarker-adaptor.json
- s2: E-mail FreeMarkerアダプタを使用するための設定を行う
- s3: メールのテンプレートを作成する
- s4: メール送信要求を登録する

### E-mail Thymeleafアダプタ
path: component/adapters/adapters-mail-sender-thymeleaf-adaptor.json
- s2: E-mail Thymeleafアダプタを使用するための設定を行う
- s3: メールのテンプレートを作成する
- s4: メール送信要求を登録する

### E-mail Velocityアダプタ
path: component/adapters/adapters-mail-sender-velocity-adaptor.json
- s2: E-mail Velocityアダプタを使用するための設定を行う
- s3: メールのテンプレートを作成する
- s4: メール送信要求を登録する

### Micrometerアダプタ
path: component/adapters/adapters-micrometer-adaptor.json
- s2: Micrometerアダプタを使用するための設定を行う
  - s3: DefaultMeterBinderListProviderをコンポーネントとして宣言する
  - s4: DefaultMeterBinderListProviderを廃棄処理対象にする
  - s5: レジストリのファクトリクラスをコンポーネントとして宣言する
  - s6: 設定ファイルを作成する
  - s7: 実行結果
- s8: レジストリファクトリ
- s9: 設定ファイル
  - s10: 配置場所
  - s11: フォーマット
  - s12: OS環境変数・システムプロパティで上書きする
  - s13: 設定のプレフィックスを変更する
  - s14: 設定ファイルの場所を変更する
- s15: DefaultMeterBinderListProviderで収集されるメトリクス
- s16: 共通のタグを設定する
- s17: 監視サービスと連携する
  - s18: Datadog と連携する
  - s19: CloudWatch と連携する
  - s20: Azure と連携する
  - s21: StatsD で連携する
  - s22: OpenTelemetry Protocol (OTLP) で連携する
- s23: アプリケーションの形式ごとに収集するメトリクスの例
  - s24: ウェブアプリケーションで収集するメトリクスの例
  - s25: バッチアプリケーションで収集するメトリクスの例
- s26: 処理時間を計測するハンドラ
  - s27: パーセンタイルを収集する
  - s28: あらかじめ用意されているHandlerMetricsMetaDataBuilderの実装
- s30: バッチのトランザクション単位の処理時間を計測する
- s31: バッチの処理件数を計測する
- s32: ログレベルごとの出力回数を計測する
  - s33: LogPublisher を設定する
  - s34: カスタムのDefaultMeterBinderListProviderを作成する
  - s35: 集計対象のログレベル
- s36: SQLの処理時間を計測する
- s37: 任意のMBeanから取得した値をメトリクスとして計測する
  - s38: Tomcatのスレッドプールの状態を取得する
  - s39: HikariCPのコネクションプールの状態を取得する

### Redisヘルスチェッカ(Lettuce)アダプタ
path: component/adapters/adapters-redishealthchecker-lettuce-adaptor.json
- s1: Redisのヘルスチェックを行う

### Redisストア(Lettuce)アダプタ
path: component/adapters/adapters-redisstore-lettuce-adaptor.json
- s1: 最小構成で動かす
  - s2: 設定内容
- s5: Redis の構成に合わせて設定する
  - s6: 構成ごとに用意されたクライアントクラス
  - s7: 使用するクライアントクラスを設定する
  - s8: 接続URIを設定する
  - s9: より高度な設定
- s11: 使用するクライアントクラスの決定の仕組み
- s12: クライアントクラスの初期化
- s13: クライアントクラスの廃棄処理
- s14: セッション情報の保存方法
- s15: 有効期限の管理方法

### ルーティングアダプタ
path: component/adapters/adapters-router-adaptor.json
- s2: ルーティングアダプタを使用するための設定を行う
  - s3: ディスパッチハンドラを設定する
  - s4: ルート定義ファイルを作成する
- s5: 業務アクションとURLを自動的にマッピングする
- s6: Jakarta RESTful Web ServicesのPathアノテーションでマッピングする
  - s7: ディスパッチハンドラを変更する
  - s8: マッピングの実装方法
  - s9: パスパラメータの定義
  - s10: インターフェースや親クラスのアノテーションを引き継ぐ
  - s11: ルーティング定義を一覧で確認する

### SLF4Jアダプタ
path: component/adapters/adapters-slf4j-adaptor.json
- s2: SLF4Jアダプタを使用する

### ウェブアプリケーション Thymeleafアダプタ
path: component/adapters/adapters-web-thymeleaf-adaptor.json
- s2: ウェブアプリケーション Thymeleafアダプタを使用するための設定を行う
  - s3: 処理対象判定について
- s4: テンプレートエンジンを使用する

### IBM MQアダプタ
path: component/adapters/adapters-webspheremq-adaptor.json
- s2: 本アダプタを使用するための設定
- s3: 分散トランザクションを使用する

## component/handlers

### HTTPエラー制御ハンドラ
path: component/handlers/handlers-HttpErrorHandler.json
- s4: 例外の種類に応じた処理とレスポンスの生成
  - s5: nablarch.fw.Result.Errorのログ出力について
- s6: デフォルトページの設定

### InjectForm インターセプタ
path: component/handlers/handlers-InjectForm.json
- s1: インターセプタクラス名
- s3: InjectFormを使用する
- s4: バリデーションエラー時の遷移先を指定する
- s5: Bean Validationのグループを指定する

### サービス提供可否チェックハンドラ
path: component/handlers/handlers-ServiceAvailabilityCheckHandler.json
- s4: リクエストに対するサービス提供可否チェック

### セッション変数保存ハンドラ
path: component/handlers/handlers-SessionStoreHandler.json
- s4: セッションストアを使用するための設定
- s5: セッション変数を直列化してセッションストアに保存する
- s6: セッションストアの改竄をチェックする
- s7: 改竄エラー時の遷移先を設定する
- s8: セッションIDを保持するクッキーの名前や属性を変更する
- s9: 有効期間をデータベースに保存する
  - s10: 使用方法

### バッチアプリケーション専用ハンドラ
path: component/handlers/handlers-batch.json

### リクエストボディ変換ハンドラ
path: component/handlers/handlers-body-convert-handler.json
- s4: 変換処理を行うコンバータを設定する
- s5: リクエストボディをFormに変換する
- s6: リソース(アクション)の処理結果をレスポンスボディに変換する

### 共通ハンドラ
path: component/handlers/handlers-common.json

### CORSプリフライトリクエストハンドラ
path: component/handlers/handlers-cors-preflight-request-handler.json
- s4: CORSを実現する

### CSRFトークン検証ハンドラ
path: component/handlers/handlers-csrf-token-verification-handler.json
- s4: CSRFトークンの生成と検証
- s5: CSRFトークンを再生成する

### データリードハンドラ
path: component/handlers/handlers-data-read-handler.json
- s4: 最大処理件数の設定

### データベース接続管理ハンドラ
path: component/handlers/handlers-database-connection-management-handler.json
- s4: データベースの接続先を設定する
- s5: アプリケーションで複数のデータベース接続（トランザクション）を使用する

### ループ制御ハンドラ
path: component/handlers/handlers-dbless-loop-handler.json

### プロセス多重起動防止ハンドラ
path: component/handlers/handlers-duplicate-process-check-handler.json
- s4: 多重起動防止チェックを行うための設定
- s5: 多重起動防止チェック処理をカスタマイズする

### 出力ファイル開放ハンドラ
path: component/handlers/handlers-file-record-writer-dispose-handler.json
- s4: ハンドラキューへの設定について

### 内部フォーワードハンドラ
path: component/handlers/handlers-forwarding-handler.json
- s4: 内部フォーワードを示すレスポンスを返却する
- s5: 内部フォーワードに指定するパスのルール
- s6: 内部リクエストIDについて

### グローバルエラーハンドラ
path: component/handlers/handlers-global-error-handler.json
- s4: 例外及びエラーに応じた処理内容
- s5: グローバルエラーハンドラでは要件を満たせない場合

### Nablarchの提供する標準ハンドラ
path: component/handlers/handlers-handlers.json

### ヘルスチェックエンドポイントハンドラ
path: component/handlers/handlers-health-check-endpoint-handler.json
- s4: ヘルスチェックのエンドポイントを作る
- s5: ヘルスチェックを追加する
- s6: ヘルスチェック結果のレスポンスを変更する

### ホットデプロイハンドラ
path: component/handlers/handlers-hot-deploy-handler.json
- s4: ホットデプロイ対象のパッケージを指定する

### HTTPアクセスログハンドラ
path: component/handlers/handlers-http-access-log-handler.json
- s4: アクセスログ出力内容の切り替え

### HTTP文字エンコード制御ハンドラ
path: component/handlers/handlers-http-character-encoding-handler.json
- s4: 規定の文字エンコーディングを設定する
- s5: レスポンスに対する規定の文字エンコーディングの設定を切り替える
- s6: 一律ではなくリクエストごとに文字エンコーディングを変更したい

### HTTPメッセージングエラー制御ハンドラ
path: component/handlers/handlers-http-messaging-error-handler.json
- s4: 例外の種類に応じたログ出力とレスポンス生成
  - s5: nablarch.fw.Result.Errorのログ出力について
- s6: レスポンスボディが空の場合のデフォルトレスポンスの設定

### HTTPメッセージングリクエスト変換ハンドラ
path: component/handlers/handlers-http-messaging-request-parsing-handler.json
- s4: HTTPリクエストを要求電文に変換する
- s5: 巨大なサイズのリクエストを防ぐ

### HTTPメッセージングレスポンス変換ハンドラ
path: component/handlers/handlers-http-messaging-response-building-handler.json
- s4: レスポンスヘッダに設定される値
- s5: フレームワーク制御ヘッダのレイアウトを変更する

### HTTPメッセージング専用ハンドラ
path: component/handlers/handlers-http-messaging.json

### HTTPリクエストディスパッチハンドラ
path: component/handlers/handlers-http-request-java-package-mapping.json
- s4: ディスパッチの設定
- s5: アクションが複数のパッケージに配置される場合の設定

### HTTPレスポンスハンドラ
path: component/handlers/handlers-http-response-handler.json
- s4: 応答の変換方法
- s5: カスタムレスポンスライター
- s6: HTTPステータスコードの変更
- s7: 言語毎のコンテンツパスの切り替え
- s8: 本ハンドラ内で発生した致命的エラーの対応

### HTTPリライトハンドラ
path: component/handlers/handlers-http-rewrite-handler.json
- s4: 書き換えの設定
- s5: 変数に値を設定

### HTTPアクセスログ（RESTfulウェブサービス用）ハンドラ
path: component/handlers/handlers-jaxrs-access-log-handler.json
- s4: アクセスログ出力内容の切り替え

### Jakarta RESTful Web Servcies Bean Validationハンドラ
path: component/handlers/handlers-jaxrs-bean-validation-handler.json
- s4: リソース(アクション)で受け取るForm(Bean)に対してバリデーションを実行する
- s5: Bean Validationのグループを指定する

### Jakarta RESTful Web Servicesレスポンスハンドラ
path: component/handlers/handlers-jaxrs-response-handler.json
- s4: 例外及びエラーに応じたレスポンスの生成
- s5: 例外及びエラーに応じたログ出力
- s6: 拡張例
  - s7: エラー時のレスポンスにメッセージを設定する
  - s8: 特定のエラーの場合に個別に定義したエラーレスポンスを返却する
  - s9: クライアントに返すレスポンスに共通処理を追加する

### 携帯端末アクセスハンドラ
path: component/handlers/handlers-keitai-access-handler.json
- s4: JavaScript出力が抑制されるタグ
- s5: URLの関連付け

### トランザクションループ制御ハンドラ
path: component/handlers/handlers-loop-handler.json
- s4: トランザクション制御対象を設定する
- s5: コミット間隔を指定する
- s6: トランザクション終了時に任意の処理を実行したい

### 共通起動ランチャ
path: component/handlers/handlers-main.json
- s3: アプリケーションを起動する
- s4: アプリケーション起動に任意のオプションを設定する
- s5: 例外及びエラーに応じた処理内容

### 電文応答制御ハンドラ
path: component/handlers/handlers-message-reply-handler.json
- s4: フレームワーク制御ヘッダの設定

### 再送電文制御ハンドラ
path: component/handlers/handlers-message-resend-handler.json
- s4: 応答電文の保存先について
- s5: 同一電文(再送電文)の判定方法
- s6: フレームワーク制御ヘッダの設定

### メッセージングコンテキスト管理ハンドラ
path: component/handlers/handlers-messaging-context-handler.json
- s4: MQの接続先を設定する

### MOMメッセージング専用ハンドラ
path: component/handlers/handlers-mom-messaging.json

### マルチスレッド実行制御ハンドラ
path: component/handlers/handlers-multi-thread-execution-handler.json
- s4: スレッド数を指定する
- s5: スレッド起動前後で任意の処理を実行したい
- s6: データベース接続に関する設定について
- s7: サブスレッドでの例外発生時の振る舞い

### マルチパートリクエストハンドラ
path: component/handlers/handlers-multipart-handler.json
- s4: このハンドラの動作条件
- s5: アップロードファイルの一時保存先を指定する
- s6: 巨大なファイルのアップロードを防ぐ
- s7: ファイルの大量アップロードを防ぐ
- s8: 一時ファイルの削除（クリーニング）を行う
- s9: マルチパート解析エラー及びファイルサイズ上限超過時の遷移先画面を設定する
- s10: アップロードしたファイルを読み込む

### Nablarchカスタムタグ制御ハンドラ
path: component/handlers/handlers-nablarch-tag-handler.json
- s4: 復号に失敗(改竄エラー、セッション無効化エラー)した場合のエラーページを設定する

### ノーマライズハンドラ
path: component/handlers/handlers-normalize-handler.json
- s4: 標準で提供しているノーマライズ処理
- s5: ノーマライズ処理を追加する

### OnDoubleSubmissionインターセプタ
path: component/handlers/handlers-on-double-submission.json
- s1: インターセプタクラス名
- s3: OnDoubleSubmissionを使用する
- s4: OnDoubleSubmissionのデフォルト値を指定する
- s5: OnDoubleSubmissionの振る舞いを変更する

### OnErrorインターセプタ
path: component/handlers/handlers-on-error.json
- s1: インターセプタクラス名
- s3: OnErrorを使用する
- s4: エラー時の遷移先画面に表示するデータを取得する
- s5: 複数のレスポンスを指定する

### OnErrorsインターセプタ
path: component/handlers/handlers-on-errors.json
- s1: インターセプタクラス名
- s3: OnErrorsを使用する

### 認可チェックハンドラ
path: component/handlers/handlers-permission-check-handler.json
- s4: リクエストに対する認可チェック
- s5: 権限がない場合に表示するエラーページを指定する
- s6: 特定のリクエストを認可チェックから除外する

### POST再送信防止ハンドラ
path: component/handlers/handlers-post-resubmit-prevent-handler.json
- s4: ポスト再送信防止の使用方法
- s5: リクエスト先と遷移先パスのマッピングを行う

### プロセス常駐化ハンドラ
path: component/handlers/handlers-process-resident-handler.json
- s4: データの監視間隔を設定する
- s5: プロセス常駐化ハンドラの終了方法
- s6: 後続ハンドラで発生した例外の扱い

### プロセス停止制御ハンドラ
path: component/handlers/handlers-process-stop-handler.json
- s4: プロセス停止制御を行うための設定

### リクエストハンドラエントリ
path: component/handlers/handlers-request-handler-entry.json
- s4: 本ハンドラの使用例
- s5: リクエストパターン指定のバリエーション

### リクエストディスパッチハンドラ
path: component/handlers/handlers-request-path-java-package-mapping.json
- s4: ベースパッケージ、ベースパスの設定
- s5: 複数パッケージのクラスにディスパッチする
- s6: クラス名のプレフィクス、サフィックスの設定
- s7: 複雑なパッケージへのディスパッチ
- s8: ディスパッチ対象クラスを遅延実行する

### リクエストスレッド内ループ制御ハンドラ
path: component/handlers/handlers-request-thread-loop-handler.json
- s4: サービス閉塞中の待機時間を設定する
- s5: 本ハンドラの停止方法
- s6: 後続ハンドラで発生した例外(エラー)に応じた処理内容

### リソースマッピングハンドラ
path: component/handlers/handlers-resource-mapping.json
- s4: 静的リソースのダウンロード

### RESTfulウェブサービス専用ハンドラ
path: component/handlers/handlers-rest.json

### リトライハンドラ
path: component/handlers/handlers-retry-handler.json
- s4: リトライの上限を設定する

### セキュアハンドラ
path: component/handlers/handlers-secure-handler.json
- s4: デフォルトで適用されるヘッダの値を変更したい
- s5: デフォルト以外のレスポンスヘッダを設定する
- s6: Content Security Policy(CSP)に対応する
  - s7: 固定のContent-Security-Policyヘッダを設定する
  - s8: nonceを生成してContent-Security-Policyヘッダに設定する
  - s9: report-only モードで動作させる

### セッション並行アクセスハンドラ
path: component/handlers/handlers-session-concurrent-access-handler.json

### スタンドアローン型アプリケーション共通ハンドラ
path: component/handlers/handlers-standalone.json

### ステータスコード→プロセス終了コード変換ハンドラ
path: component/handlers/handlers-status-code-convert-handler.json
- s4: ステータスコード→プロセス終了コード変換

### スレッドコンテキスト変数削除ハンドラ
path: component/handlers/handlers-thread-context-clear-handler.json
- s4: スレッドコンテキストの削除処理

### スレッドコンテキスト変数管理ハンドラ
path: component/handlers/handlers-thread-context-handler.json
- s4: リクエスト毎にスレッドコンテキストの初期化を行う
  - s5: ユーザIDを設定する
- s6: スレッドコンテキストの属性値を設定/取得する
- s7: ユーザが言語を選択する画面を作る
- s8: ユーザがタイムゾーンを選択する画面を作る

### トランザクション制御ハンドラ
path: component/handlers/handlers-transaction-management-handler.json
- s4: トランザクション制御対象を設定する
- s5: 特定の例外の場合にトランザクションをコミットさせる
- s6: トランザクション終了時に任意の処理を実行したい
- s7: アプリケーションで複数のトランザクションを使用する

### UseTokenインターセプタ
path: component/handlers/handlers-use-token.json
- s1: インターセプタクラス名
- s3: UseTokenを使用する

### ウェブアプリケーション専用インターセプタ
path: component/handlers/handlers-web-interceptor.json

### ウェブアプリケーション専用ハンドラ
path: component/handlers/handlers-web.json

## component/libraries

### ハンドラによる認可チェック
path: component/libraries/libraries-authorization-permission-check.json
- s1: 機能概要
  - s2: リクエスト単位で認可チェックを行うことができる
  - s3: グループ単位とユーザ単位を併用した権限設定ができる
- s5: 使用方法
  - s6: 認可チェックを使うための設定
  - s7: サーバサイドで認可チェックを行う
  - s8: 権限に応じて画面表示を制御する
  - s9: 権限データにアクセスする
- s10: 拡張例

### BeanUtil
path: component/libraries/libraries-bean-util.json
- s2: 使用方法
- s3: BeanUtilの型変換ルール
- s4: 型変換ルールを追加する
- s5: 型変換時に許容するフォーマットを指定する
  - s6: デフォルト(システム共通)の許容するフォーマットを設定する
  - s7: コピー対象のプロパティに対して許容するフォーマットを設定する
  - s8: BeanUtil呼び出し時に許容するフォーマットを設定する
- s9: BeanUtilでレコードを使用する
  - s10: 使用方法

### Bean Validation
path: component/libraries/libraries-bean-validation.json
- s1: 機能概要
  - s2: ドメインバリデーションができる
  - s3: よく使われるバリデータが提供されている
- s5: 使用方法
  - s6: Bean Validationを使うための設定
  - s7: バリデーションエラー時のエラーメッセージを定義する
  - s8: バリデーションルールの設定方法
  - s9: ドメインバリデーションを使う
  - s10: 文字種バリデーションを行う
  - s11: 相関バリデーションを行う
  - s12: データベースとの相関バリデーションを行う
  - s13: 特定の項目に紐づくバリデーションエラーのメッセージを作りたい
  - s14: 一括登録のようなBeanを複数入力する機能でバリデーションを行う
  - s15: ネストしたBeanをバリデーションする際の注意点
  - s16: ウェブアプリケーションのユーザ入力値のチェックを行う
  - s17: RESTfulウェブサービスのユーザ入力値のチェックを行う
  - s18: バリデーションエラー時にもリクエストパラメータをリクエストスコープから取得したい
  - s19: バリデーションエラー時のメッセージに項目名を含めたい
  - s20: バリデーションの明示的な実行
  - s21: バリデーションエラー時に任意の処理を行いたい
  - s22: Bean Validationのグループ機能を使用したい
- s23: 拡張例
  - s24: プロジェクト固有のアノテーションとバリデーションロジックを追加したい

### コード管理
path: component/libraries/libraries-code.json
- s1: 機能概要
  - s2: 国際化に対応できる
  - s3: コード情報はテーブルで管理する
- s5: 使用方法
  - s6: コード管理機能を使用する為の初期設定
  - s7: 機能毎に使用するコード情報を切り替える
  - s8: 名称の多言語化対応
  - s9: 画面などで表示する名称のソート順を定義する
  - s10: 名称、略称以外の名称を定義する
  - s11: 入力値が有効なコード値かチェックする

### 登録機能での実装例
path: component/libraries/libraries-create-example.json
- s1: 入力画面の初期表示
- s2: 入力画面から確認画面へ遷移
- s3: 確認画面から入力画面へ戻る
- s4: 登録処理を実行

### データバインド
path: component/libraries/libraries-data-bind.json
- s1: 機能概要
  - s2: データをJava Beansオブジェクトとして扱うことができる
  - s3: データをMapオブジェクトとして扱うことができる
  - s4: データファイルのフォーマットをアノテーションで指定できる
- s6: 使用方法
  - s7: データをJava Beansオブジェクトとして読み込む
  - s8: Java Beansオブジェクトの内容をデータファイルに書き込む
  - s9: データをMapオブジェクトとして読み込む
  - s10: Mapオブジェクトの内容をデータファイルに書き込む
  - s11: ファイルのデータの論理行番号を取得する
  - s12: データの入力値をチェックする
  - s13: ファイルダウンロードで使用する
  - s14: アップロードファイルのデータを読み込む
  - s15: CSVファイルのフォーマットを指定する
  - s16: 固定長ファイルのフォーマットを指定する
  - s17: 固定長ファイルに複数のフォーマットを指定する
  - s18: 出力するデータの表示形式をフォーマットする
- s19: 拡張例
  - s20: Java Beansクラスにバインドできるファイル形式を追加する
- s21: CSVファイルのフォーマットとして指定できるフォーマットセット

### 様々なフォーマットのデータへのアクセス
path: component/libraries/libraries-data-converter.json

### 汎用データフォーマット
path: component/libraries/libraries-data-format.json
- s1: 機能概要
  - s2: 標準でサポートするフォーマットが豊富
  - s3: 様々な文字セットや文字種、データ形式に対応
  - s4: パディングやトリミングなどの変換処理に対応
- s6: 使用方法
  - s7: 入出力データのフォーマットを定義する
  - s8: ファイルにデータを出力する
  - s9: ファイルダウンロードで使用する
  - s10: アップロードしたファイルを読み込む
  - s11: JSONやXMLの階層構造のデータを読み書きする
  - s13: XMLで名前空間を使う
  - s14: XMLで属性を持つ要素にコンテンツを定義する
  - s15: 文字の置き換え(寄せ字)を行う
  - s16: 出力するデータの表示形式をフォーマットする
- s17: 拡張例
  - s18: フィールドタイプを追加する
  - s19: XMLで属性を持つ要素のコンテンツ名を変更する

### データバインドと汎用データフォーマットの比較表
path: component/libraries/libraries-data-io-functional-comparison.json

### ユニバーサルDAOとJakarta Persistenceとの機能比較
path: component/libraries/libraries-database-functional-comparison.json

### データベースアクセス
path: component/libraries/libraries-database-management.json

### データベースアクセス(JDBCラッパー)
path: component/libraries/libraries-database.json
- s1: 機能概要
  - s2: データベースの方言を意識することなく使用できる
  - s3: SQLはロジックではなくSQLファイルに記述する
  - s4: Beanのプロパティ値をSQLのバインド変数に埋め込むことができる
  - s5: like検索を容易に実装できる
  - s6: 実行時のBeanオブジェクトの状態を元にSQL文を動的に構築できる
  - s7: SQLのクエリ結果をキャッシュできる
- s9: 使用方法
  - s10: データベースに対する接続設定
  - s11: データベース製品に対応したダイアレクトを使用する
  - s12: SQLをファイルで管理する
  - s13: SQLIDを指定してSQLを実行する
  - s14: ストアードプロシージャを実行する
  - s15: 検索範囲を指定してSQLを実行する
  - s16: Beanオブジェクトを入力としてSQLを実行する
  - s17: 型を変換する
  - s18: SQL実行時に共通的な値を自動的に設定したい
  - s19: like検索を行う
  - s20: like検索時のエスケープ文字及びエスケープ対象文字を定義する
  - s21: 可変条件を持つSQLを実行する
  - s22: in句の条件数が可変となるSQLを実行する
  - s23: order byのソート項目を実行時に動的に切り替えてSQLを実行する
  - s24: バイナリ型のカラムにアクセスする
  - s25: 桁数の大きい文字列型のカラム(例えばCLOB)にアクセスする
  - s26: データベースアクセス時に発生する例外の種類
  - s27: 一意制約違反をハンドリングして処理を行う
  - s28: 処理が長いトランザクションはエラーとして処理を中断させる
  - s29: 現在のトランザクションとは異なるトランザクションでSQLを実行する
  - s30: 検索結果をキャッシュする（同じSQLで同じ条件の場合にキャッシュしたデータを扱いたい)
  - s31: java.sql.Connection を使って処理を行う
  - s32: SQL文中のスキーマを環境毎に切り替える
- s33: 拡張例
  - s34: データベースへの接続法を追加する
  - s35: ダイアレクトを追加する
  - s36: データベースアクセス時の例外クラスを切り替える

### 日付管理
path: component/libraries/libraries-date.json
- s1: 機能概要
  - s2: システム日時(OS日時)と業務日付の切り替えができる
- s4: 使用方法
  - s5: システム日時の管理機能を使うための設定
  - s6: システム日時を取得する
  - s7: 業務日付管理機能を使うための設定
  - s8: 業務日付を取得する
  - s9: 業務日付を任意の日付に上書く
  - s10: 業務日付を更新する
- s11: 拡張例
  - s12: システム日時を切り替える
  - s13: 業務日付を切り替える

### データベースを使用した二重サブミット防止
path: component/libraries/libraries-db-double-submit.json
- s1: 機能概要
- s3: 使用方法

### 排他制御
path: component/libraries/libraries-exclusive-control.json
- s1: 機能概要
  - s2: 楽観的ロック/悲観的ロックができる
- s4: 使用方法
  - s5: 排他制御を使うために準備する
  - s6: 楽観的ロックを行う
  - s7: 一括更新で楽観的ロックを行う
  - s8: 悲観的ロックを行う
- s9: 拡張例

### 障害ログの出力
path: component/libraries/libraries-failure-log.json
- s1: 障害ログの出力方針
- s2: 使用方法
  - s3: 障害ログを出力する
  - s4: 障害ログの設定
  - s5: 障害ログに連絡先情報を追加する
  - s6: フレームワークの障害コードを変更する
  - s7: 派生元実行時情報を出力する
  - s8: プレースホルダに対する出力処理をカスタマイズする
  - s9: JSON形式の構造化ログとして出力する

### ファイルパス管理
path: component/libraries/libraries-file-path-management.json
- s1: 機能概要
  - s2: ディレクトリや拡張子を論理名で管理できる
- s4: 使用方法
  - s5: ディレクトリと拡張子を設定する
- s6: 論理名が示すファイルパスを取得する

### フォーマット定義ファイルの記述ルール
path: component/libraries/libraries-format-definition.json
- s1: フォーマット定義ファイルの共通の記法
  - s2: 文字コード
  - s3: リテラル表記
  - s4: コメント
- s5: フォーマット定義ファイルの構造
- s6: ディレクティブ宣言部の定義
  - s7: 共通で使用可能なディレクティブ一覧
  - s8: Fixed(固定長)形式で指定可能なディレクティブ一覧
  - s9: Variable(可変長)形式で指定可能なディレクティブ一覧
  - s10: JSON形式で指定可能なディレクティブ一覧
  - s11: XML形式で指定可能なディレクティブ一覧
- s12: レコードフォーマット定義部
  - s13: フィールド定義
  - s14: マルチフォーマット形式のレコードを定義する
  - s15: フィールドタイプ一覧
  - s16: フィールドコンバータ一覧
- s17: 項目定義の省略について

### フォーマッタ
path: component/libraries/libraries-format.json
- s1: 機能概要
- s3: 使用方法
  - s4: フォーマッタの設定
  - s5: フォーマッタを使用する
- s6: フォーマッタの設定を変更する
- s7: フォーマッタを追加する

### サロゲートキーの採番
path: component/libraries/libraries-generator.json
- s1: 機能概要
  - s2: シーケンスを使った値の採番が出来る
  - s3: テーブルを使った値の採番が出来る
- s5: 使用方法
  - s6: ユニバーサルDAO用に採番を設定する
- s7: 拡張例
  - s8: テーブル採番やシーケンス採番を置き換える

### HTTPアクセスログの出力
path: component/libraries/libraries-http-access-log.json
- s1: HTTPアクセスログの出力方針
- s2: 使用方法
  - s3: HTTPアクセスログの設定
  - s4: JSON形式の構造化ログとして出力する
  - s5: セッションストアIDについて

### HTTPメッセージング
path: component/libraries/libraries-http-system-messaging.json
- s1: 機能概要
  - s2: [MOMメッセージング](../../component/libraries/libraries-mom-system-messaging.json#momメッセージング) と同じ作り方ができる
- s4: 使用方法
  - s5: HTTPメッセージングを使うための設定
  - s6: メッセージを受信する(HTTPメッセージ受信)
  - s7: メッセージを送信する(HTTPメッセージ送信)
- s8: 拡張例
  - s9: フレームワーク制御ヘッダの読み書きを変更する
  - s10: HTTPメッセージ送信のHTTPクライアント処理を変更する
- s11: 送受信電文のデータモデル

### HTTPアクセスログ（RESTfulウェブサービス用）の出力
path: component/libraries/libraries-jaxrs-access-log.json
- s1: HTTPアクセスログ（RESTfulウェブサービス用）の出力方針
- s2: 使用方法
  - s3: HTTPアクセスログ（RESTfulウェブサービス用）の設定
  - s4: JSON形式の構造化ログとして出力する
  - s5: セッションストアIDについて

### 認可チェック
path: component/libraries/libraries-libraries-permission-check.json

### Nablarchが提供するライブラリ
path: component/libraries/libraries-libraries.json

### ログ出力
path: component/libraries/libraries-log.json
- s1: 機能概要
  - s2: ログ出力機能の実装を差し替えることができる
  - s3: 各種ログの出力機能を予め提供している
- s5: 使用方法
  - s6: ログを出力する
  - s7: ログ出力の設定
  - s8: ログ出力の設定を上書く
  - s9: ログのフォーマットを指定する
  - s10: 各種ログの設定
  - s11: ログファイルのローテーションを行う
- s12: 拡張例
  - s13: LogWriterを追加する
  - s14: LogFormatterを追加する
  - s15: ログの出力項目(プレースホルダ)を追加する
  - s16: ログの初期化メッセージを出力しないようにする
- s17: JSON形式の構造化ログとして出力する
  - s18: LogWriterで使用するフォーマッタをJsonLogFormatterに変更する
  - s19: 各種ログで使用するフォーマッタをJSONログ用に差し替える
  - s20: NablarchバッチのログをJSON形式にする
- s24: SynchronousFileLogWriterを使用するにあたっての注意事項
- s25: LogPublisherの使い方
- s26: ログレベルの定義
- s27: フレームワークのログ出力方針
- s28: log4jとの機能比較

### メール送信
path: component/libraries/libraries-mail.json
- s1: 機能概要
  - s2: テンプレートを使った定型メールを送信できる。
  - s3: キャンペーン通知のような大量メールの一斉送信には対応していない
- s5: 使用方法
  - s6: メール送信を使うための設定
  - s7: メール送信要求を登録する
  - s8: メールを送信する(メール送信バッチを実行する)
  - s9: メール送信時のエラー処理
  - s10: メール送信をマルチプロセス化する
  - s11: メールヘッダインジェクション攻撃への対策
- s12: 拡張例
  - s13: 電子署名を付加したりメール本文を暗号化するなどメール送信処理を変更する
  - s14: メール送信に失敗した際の処理を変更する
  - s15: メール送信要求時に使用するトランザクションを指定する

### メッセージ管理
path: component/libraries/libraries-message.json
- s1: 機能概要
  - s2: メッセージの定義場所を指定できる
  - s3: メッセージをフォーマットすることが出来る
- s5: 使用方法
  - s6: プロパティファイルの作成単位
  - s7: プロパティファイルにメッセージを定義する
  - s8: 多言語化対応
  - s9: メッセージを持つ業務例外を送出する
  - s10: 埋め込み文字を使用する
  - s11: 画面の固定文言をメッセージから取得する
  - s12: メッセージレベルを使い分ける
- s13: 拡張例
  - s14: プロパティファイル名や格納場所を変更する
  - s15: メッセージをデータベースで管理する
  - s16: メッセージのフォーマット方法を変更する

### メッセージングログの出力
path: component/libraries/libraries-messaging-log.json
- s1: メッセージングログの出力方針
- s2: 使用方法
  - s3: メッセージングログの設定
  - s4: JSON形式の構造化ログとして出力する

### MOMメッセージング
path: component/libraries/libraries-mom-system-messaging.json
- s1: 機能概要
  - s2: 多様なMOMに対応できる
- s4: 使用方法
  - s5: MOMメッセージングを使うための設定
  - s6: 応答不要でメッセージを送信する(応答不要メッセージ送信)
  - s7: 同期応答でメッセージを送信する(同期応答メッセージ送信)
  - s8: 応答不要でメッセージを受信する(応答不要メッセージ受信)
  - s9: 同期応答でメッセージを受信する(同期応答メッセージ受信)
- s10: 拡張例
  - s11: フレームワーク制御ヘッダの読み書きを変更する
- s12: 送受信電文のデータモデル

### 
path: component/libraries/libraries-multi-format-example.json
- s1: Fixed(固定長)のマルチフォーマット定義のサンプル集
- s2: Variable(可変長)でマルチフォーマット定義のサンプル集

### Nablarch Validation
path: component/libraries/libraries-nablarch-validation.json
- s1: 機能概要
  - s2: バリデーションと型変換及び値の正規化ができる
  - s3: ドメインバリデーションができる
  - s4: よく使われるバリデータ及びコンバータが提供されている
- s6: 使用方法
  - s7: 使用するバリデータとコンバータを設定する
  - s8: バリデーションルールを設定する
  - s9: ドメインバリデーションを使う
  - s10: バリデーション対象のBeanを継承する
  - s11: バリデーションを実行する
  - s12: バリデーションの明示的な実行
  - s13: 文字種バリデーションを行う
  - s14: 相関バリデーションを行う
  - s15: 一括登録のようなBeanの配列を入力とする機能でバリデーションを行う
  - s16: ラジオボタンやリストボックスの選択値に応じてバリデーション項目を変更する
  - s17: 特定の項目に紐づくバリデーションエラーのメッセージを作りたい
  - s18: バリデーションエラー時のメッセージに項目名を埋め込みたい
  - s19: 数値型への型変換
  - s20: データベースとの相関バリデーションを行う
  - s21: ウェブアプリケーションのユーザ入力値のチェックを行う
- s22: 拡張例
  - s23: プロジェクト固有のバリデータを追加したい
  - s24: プロジェクト固有のコンバータを追加したい
  - s25: バリデーション対象のBeanオブジェクトの生成方法を変更したい

### パフォーマンスログの出力
path: component/libraries/libraries-performance-log.json
- s1: パフォーマンスログの出力方針
- s2: 使用方法
  - s3: パフォーマンスログを出力する
  - s4: パフォーマンスログの設定
  - s5: JSON形式の構造化ログとして出力する

### システムリポジトリ
path: component/libraries/libraries-repository.json
- s1: 機能概要
  - s2: DIコンテナによるオブジェクトの構築ができる
  - s3: オブジェクトの初期化ができる
- s5: 使用方法
  - s6: xmlにルートノードを定義する
  - s7: Java Beansオブジェクトを設定する
  - s8: Java Beansオブジェクトの設定を上書きする
  - s9: 文字列や数値、真偽値を設定値として使う
  - s10: ListやMapを設定値として使う
  - s11: コンポーネントを自動的にインジェクションする
  - s12: コンポーネント設定ファイル(xml)を分割する
  - s13: 依存値を設定する
  - s14: コンポーネント設定ファイルから環境依存値を参照する
  - s15: システムプロパティを使って環境依存値を上書きする
  - s16: OS環境変数を使って環境依存値を上書きする
  - s17: ファクトリクラスで生成したオブジェクトをインジェクションする
  - s18: アノテーションを付与したクラスのオブジェクトを構築する
  - s22: オブジェクトの初期化処理を行う
  - s23: オブジェクトの廃棄処理を行う
  - s24: DIコンテナの情報をシステムリポジトリに設定する
  - s25: システムリポジトリからオブジェクトを取得する
- s26: 環境設定ファイルの記述ルール

### アノテーションによる認可チェック
path: component/libraries/libraries-role-check.json
- s1: 機能概要
  - s2: 煩雑なデータ管理をせずに認可チェックができる
  - s3: アノテーションで認可チェックができる
  - s4: ハンドラによる認可チェックとの使い分け
- s6: 使用方法
  - s7: 事前準備
  - s12: アクションのメソッドにアノテーションでロールを割り当てる
  - s13: アノテーションに割り当てた CheckRole の設定を一覧で確認する
  - s14: プログラムで判定する
  - s15: JSPで判定する
- s16: 仕組み
- s17: 拡張方法

### サービス提供可否チェック
path: component/libraries/libraries-service-availability.json
- s1: 機能概要
  - s2: リクエスト単位でサービス提供可否をチェックできる
- s4: 使用方法
  - s5: サービス提供可否チェックを使うための設定
  - s6: サービス提供可否をチェックする
  - s7: サービス提供可否に応じて画面表示を制御する
- s8: 拡張例

### セッションストア
path: component/libraries/libraries-session-store.json
- s1: 機能概要
  - s2: セッション変数の保存先を選択できる
  - s3: セッション変数の直列化の仕組みを選択できる
  - s6: 保存対象はシリアライズ可能なJava Beansオブジェクトであること
- s7: 使用方法
  - s8: セッションストアを使用するための設定
  - s9: 入力～確認～完了画面間で入力情報を保持する
  - s10: 認証情報を保持する
  - s11: JSPからセッション変数の値を参照する
  - s12: HIDDENストアの暗号化設定をカスタマイズする
  - s13: セッション変数に値が存在しない場合の遷移先画面を指定する
- s14: 拡張例
  - s15: セッション変数の保存先を追加する
- s16: セッションストアの特長と選択基準
- s17: 有効期間の管理方法

### SQLログの出力
path: component/libraries/libraries-sql-log.json
- s1: SQLログの出力方針
- s2: 使用方法
  - s3: SQLログの設定
  - s4: JSON形式の構造化ログとして出力する

### Webアプリケーションをステートレスにする
path: component/libraries/libraries-stateless-web-app.json
- s1: 基本的な考え方
- s2: HTTPセッションに依存している機能
- s3: HTTPセッション非依存機能の導入方法
  - s4: セッションストア
  - s5: 2重サブミット防止
  - s6: スレッドコンテキスト変数管理ハンドラ
  - s7: HTTPリライトハンドラ
  - s8: hidden暗号化
- s9: ローカルファイルシステムの使用
- s10: HTTPセッションの誤生成を検知する

### 静的データのキャッシュ
path: component/libraries/libraries-static-data-cache.json
- s1: 機能概要
  - s2: 任意のデータをキャッシュできる
- s4: 使用方法
  - s5: 任意のデータをキャッシュする
  - s6: データのキャッシュタイミングを制御する

### システム間メッセージング
path: component/libraries/libraries-system-messaging.json

### タグリファレンス
path: component/libraries/libraries-tag-reference.json
- s1: 共通属性
  - s2: 全てのHTMLタグ
  - s3: フォーカスを取得可能なHTMLタグ
  - s4: 動的属性の使用
- s5: 個別属性
  - s6: formタグ
  - s7: textタグ
  - s8: searchタグ
  - s9: telタグ
  - s10: urlタグ
  - s11: emailタグ
  - s12: dateタグ
  - s13: monthタグ
  - s14: weekタグ
  - s15: timeタグ
  - s16: datetimeLocalタグ
  - s17: numberタグ
  - s18: rangeタグ
  - s19: colorタグ
  - s20: textareaタグ
  - s21: passwordタグ
  - s22: radioButtonタグ
  - s23: checkboxタグ
  - s24: compositeKeyCheckboxタグ
  - s25: compositeKeyRadioButtonタグ
  - s26: fileタグ
  - s27: hiddenタグ
  - s28: plainHiddenタグ
  - s29: hiddenStoreタグ
  - s30: selectタグ
  - s31: radioButtonsタグ
  - s32: checkboxesタグ
  - s33: submitタグ
  - s34: buttonタグ
  - s35: submitLinkタグ
  - s36: popupSubmitタグ
  - s37: popupButtonタグ
  - s38: popupLinkタグ
  - s39: downloadSubmitタグ
  - s40: downloadButtonタグ
  - s41: downloadLinkタグ
  - s42: paramタグ
  - s43: changeParamNameタグ
  - s44: aタグ
  - s45: imgタグ
  - s46: linkタグ
  - s47: scriptタグ
  - s48: errorsタグ
  - s49: errorタグ
  - s50: noCacheタグ
  - s51: codeSelectタグ
  - s52: codeRadioButtonsタグ
  - s53: codeCheckboxesタグ
  - s54: codeCheckboxタグ
  - s55: codeタグ
  - s56: cspNonceタグ
  - s57: messageタグ
  - s58: writeタグ
  - s59: prettyPrintタグ
  - s60: rawWriteタグ
  - s61: setタグ
  - s62: includeタグ
  - s63: includeParamタグ
  - s64: confirmationPageタグ
  - s65: ignoreConfirmationタグ
  - s66: forInputPageタグ
  - s67: forConfirmationPageタグ

### Jakarta Server Pagesカスタムタグ
path: component/libraries/libraries-tag.json
- s1: 機能概要
  - s2: HTMLエスケープ漏れを防げる
  - s3: 入力画面と確認画面のJSPを共通化して実装を減らす
- s5: 使用方法
  - s6: カスタムタグの設定
  - s7: カスタムタグを使用する(taglibディレクティブの指定方法)
  - s8: 入力フォームを作る
  - s9: 選択項目(プルダウン/ラジオボタン/チェックボックス)を表示する
  - s10: チェックボックスでチェックなしに対する値を指定する
  - s11: 入力データを画面間で持ち回る(ウィンドウスコープ)
  - s12: クライアントに保持するデータを暗号化する(hidden暗号化)
  - s13: 複合キーのラジオボタンやチェックボックスを作る
  - s14: 複数のボタン/リンクからフォームをサブミットする
  - s15: サブミット前に処理を追加する
  - s16: プルダウン変更などの画面操作でサブミットする
  - s17: ボタン/リンク毎にパラメータを追加する
  - s18: 認可チェック/サービス提供可否に応じてボタン/リンクの表示/非表示を切り替える
  - s19: 別ウィンドウ/タブを開くボタン/リンクを作る(ポップアップ)
  - s20: ファイルをダウンロードするボタン/リンクを作る
  - s21: 二重サブミットを防ぐ
  - s23: 入力画面と確認画面を共通化する
  - s24: 変数に値を設定する
  - s25: GETリクエストを使用する
  - s26: 値を出力する
  - s27: HTMLエスケープせずに値を出力する
  - s28: フォーマットして値を出力する
  - s29: エラー表示を行う
  - s30: コード値を表示する
  - s31: メッセージを出力する
  - s32: 言語毎にリソースパスを切り替える
  - s33: ブラウザのキャッシュを防止する
  - s34: 静的コンテンツの変更時にクライアント側のキャッシュを参照しないようにする
  - s35: 論理属性を指定する
  - s36: 任意の属性を指定する
  - s38: Content Security Policy(CSP)に対応する
- s41: 拡張例
  - s42: フォーマッタを追加する
  - s43: ボタン/リンクの表示制御に使う判定処理を変更する
  - s44: クライアント側の二重サブミット防止で、二重サブミット発生時の振る舞いを追加する
  - s45: サーバ側の二重サブミット防止で、トークンの発行処理を変更する
- s46: カスタムタグのルール
  - s47: 命名ルール
  - s48: 入力/出力データへのアクセスルール
  - s49: URIの指定方法
  - s50: HTMLエスケープと改行、半角スペース変換
- s51: [タグリファレンス](../../component/libraries/libraries-tag-reference.json#タグリファレンス)

### トランザクション管理
path: component/libraries/libraries-transaction.json
- s1: 機能概要
  - s2: 各種リソースに対するトランザクション制御が出来る
- s4: 使用方法
  - s5: データベースに対するトランザクション制御
  - s6: データベースに対するトランザクションタイムアウトを適用する
- s7: 拡張例
  - s8: トランザクション対象のリソースを追加する

### ユニバーサルDAO
path: component/libraries/libraries-universal-dao.json
- s1: 機能概要
  - s2: SQLを書かなくても単純なCRUDができる
  - s3: 検索結果をBeanにマッピングできる
- s5: 使用方法
  - s6: ユニバーサルDAOを使うための設定を行う
  - s7: 任意のSQL(SQLファイル)で検索する
  - s8: テーブルをJOINした検索結果を取得する
  - s9: 検索結果を遅延ロードする
  - s10: 条件を指定して検索する
  - s11: 型を変換する
  - s12: ページングを行う
  - s13: サロゲートキーを採番する
  - s14: バッチ実行(一括登録、更新、削除)を行う
  - s15: 楽観的ロックを行う
  - s16: 悲観的ロックを行う
  - s17: 排他制御の考え方
  - s18: データサイズの大きいバイナリデータを登録（更新）する
  - s19: データサイズの大きいテキストデータを登録（更新）する
  - s20: 現在のトランザクションとは異なるトランザクションで実行する
- s21: 拡張例
  - s22: DatabaseMetaDataから情報を取得できない場合に対応する
  - s23: ページング処理の件数取得用SQLを変更する
- s24: Entityに使用できるJakarta Persistenceアノテーション
- s25: Beanに使用できるデータタイプ

### 更新機能での実装例
path: component/libraries/libraries-update-example.json
- s1: 入力画面の初期表示
- s2: 入力画面から確認画面へ遷移
- s3: 確認画面から入力画面へ戻る
- s4: 更新処理を実行

### 汎用ユーティリティ
path: component/libraries/libraries-utility.json

### Bean ValidationとNablarch Validationの機能比較
path: component/libraries/libraries-validation-functional-comparison.json

### 入力値のチェック
path: component/libraries/libraries-validation.json

## development-tools/java-static-analysis

### 効率的なJava静的チェック
path: development-tools/java-static-analysis/java-static-analysis-java-static-analysis.json
- s1: Inspectionを行う
- s2: フォーマットを統一する
- s3: 許可していないAPIが使用されていないかチェックする
  - s4: nablarch-intellij-pluginを使用する
  - s5: 使用不許可APIチェックツールを使用する

## development-tools/testing-framework

### 自動テストフレームワーク
path: development-tools/testing-framework/testing-framework-01-Abstract.json
- s1: 特徴
  - s2: JUnit4ベース
  - s3: テストデータの外部化
  - s4: Nablarchに特化したテスト補助機能を提供
- s5: 自動テストフレームワークの構成
- s6: テストメソッド記述方法
- s7: Excelによるテストデータ記述
  - s8: 命名規約
  - s11: シート内の構造
  - s12: コメント
  - s13: マーカーカラム
  - s14: セルの書式
  - s15: 日付の記述方法
  - s16: セルへの特殊な記述方法
- s17: 注意事項
  - s18: テストメソッドの実行順序に依存しないテストを作成する
  - s19: テストデータは全てExcelシートに記述する
  - s20: 複数のデータタイプ使用時はデータタイプごとにまとめてデータを記述する
- s21: JUnit 5で自動テストフレームワークを動かす
  - s22: JUnit Vintage
  - s23: 前提条件
  - s24: 依存関係の追加

### リクエスト単体データ作成ツール
path: development-tools/testing-framework/testing-framework-01-HttpDumpTool.json
- s1: 概要
- s2: 特徴
- s3: 使用方法
  - s4: 前提条件
  - s5: 入力となるHTML生成
  - s6: ツール起動
  - s7: データ入力
  - s8: Excelダウンロード
  - s9: データ編集

### マスタデータ投入ツール
path: development-tools/testing-framework/testing-framework-01-MasterDataSetupTool.json
- s1: 概要
- s2: 特徴
- s3: 使用方法
  - s4: 前提条件
  - s5: データ作成方法
  - s6: 実行方法

### Bean Validationに対応したForm/Entityのクラス単体テスト
path: development-tools/testing-framework/testing-framework-01-entityUnitTestWithBeanValidation.json
- s1: Form/Entity単体テストの書き方
  - s2: テストデータの作成
  - s3: テストクラスの作成
  - s4: 文字種と文字列長の単項目精査テストケース
  - s7: その他の単項目精査のテストケース
  - s10: 項目間精査のテストケース
  - s13: setter、getterに対するテストケース
  - s15: 自動テストフレームワーク設定値

### マスタデータ投入ツール インストールガイド
path: development-tools/testing-framework/testing-framework-02-ConfigMasterDataSetupTool.json
- s1: 前提事項
- s2: 提供方法
  - s3: プロパティファイルの書き換え
- s4: Eclipseとの連携設定
  - s5: Antビュー起動
  - s6: ビルドファイル登録

### データベースを使用するクラスのテスト
path: development-tools/testing-framework/testing-framework-02-DbAccessTest.json
- s1: 概要
  - s2: 全体像
- s4: 基本的なテスト方法
  - s5: 参照系のテスト
  - s11: 更新系のテスト
- s17: データベーステストデータの省略記述方法
  - s18: DBに準備データのカラムを省略する場合
  - s19: DB期待値のカラムを省略する場合
  - s20: 具体例
  - s24: デフォルト値
  - s25: デフォルト値の変更方法
- s28: 注意点
  - s29: setUpDbメソッドに関する注意点
  - s30: assertTableEqualsメソッドに関する注意点
  - s31: assertSqlResultSetEqualsメソッドに関する注意点
  - s32: クラス単体テストにおける登録・更新系テストの注意点
  - s33: 外部キーが設定されたテーブルにデータをセットアップしたい
  - s34: Excelファイルに記述できるカラムのデータ型に関する注意点

### リクエスト単体テスト（ウェブアプリケーション）
path: development-tools/testing-framework/testing-framework-02-RequestUnitTest.json
- s1: 概要
  - s2: 全体像
  - s3: 主なクラス, リソース
  - s4: 前提事項
- s5: 構造
  - s6: BasicHttpRequestTestTemplate
  - s7: AbstractHttpRequestTestTemplate
  - s8: TestCaseInfo
  - s9: HttpRequestTestSupport
  - s15: 実行
  - s17: 結果確認
  - s19: HTMLダンプ出力
- s21: 各種設定値
  - s22: コンポーネント設定ファイル設定項目一覧
  - s23: コンポーネント設定ファイルの記述例
  - s24: その他の設定

### リクエスト単体データ作成ツール インストールガイド
path: development-tools/testing-framework/testing-framework-02-SetUpHttpDumpTool.json
- s1: 前提事項
- s2: 提供方法
- s3: Eclipseとの連携
  - s4: 設定画面起動
  - s5: 外部プログラム選択
  - s6: 起動用バッチファイル（シェルスクリプト）選択
  - s7: HTMLファイルからの起動方法

### Action/Componentのクラス単体テスト
path: development-tools/testing-framework/testing-framework-02-componentUnitTest.json
- s1: Action/Component単体テストの書き方
  - s2: テストケース実行のパターン分け
  - s3: テストデータとテストクラスの作成

### Nablarch Validationに対応したForm/Entityのクラス単体テスト
path: development-tools/testing-framework/testing-framework-02-entityUnitTestWithNablarchValidation.json
- s1: Form/Entity単体テストの書き方
  - s2: テストデータの作成
  - s3: テストクラスの作成
  - s4: 文字種と文字列長の単項目精査テストケース
  - s7: その他の単項目精査のテストケース
  - s10: バリデーションメソッドのテストケース
  - s16: コンストラクタに対するテストケース
  - s18: setter、getterに対するテストケース
  - s19: 自動テストフレームワーク設定値

### リクエスト単体テストの実施方法(バッチ)
path: development-tools/testing-framework/testing-framework-02-requestunittest-batch.json
- s1: テストクラスの書き方
- s2: テストメソッド分割
- s3: テストデータの書き方
  - s4: テストクラスで共通のデータベース初期値
  - s5: テストケース一覧
  - s7: 各種準備データ
  - s12: 各種期待値
- s16: テストメソッドの書き方
  - s17: スーパクラスについて
  - s18: テストメソッド作成
  - s19: スーパクラスのメソッド呼び出し
- s20: テスト起動方法
- s21: テスト結果検証
  - s22: データベースの結果検証
  - s23: ファイルの結果検証
  - s24: ログの結果検証

### リクエスト単体テストの実施方法（応答不要メッセージ受信処理）
path: development-tools/testing-framework/testing-framework-02-requestunittest-delayed-receive.json
- s1: 概要
  - s2: テスト対象の成果物
- s3: テストクラスの書き方
- s4: テストデータの書き方
  - s5: 各種期待値

### リクエスト単体テストの実施方法（応答不要メッセージ送信処理）
path: development-tools/testing-framework/testing-framework-02-requestunittest-delayed-send.json
- s1: 概要
  - s2: テスト対象の成果物
- s3: テストクラスの書き方
- s4: テストデータの書き方
  - s5: 要求電文の期待値および、返却する応答電文（レスポンスメッセージ）の準備

### リクエスト単体テストの実施方法(HTTP同期応答メッセージ送信処理)
path: development-tools/testing-framework/testing-framework-02-requestunittest-http-send-sync.json
- s1: テストデータの書き方
  - s2: 電文を1回送信する場合の要求電文の期待値および、返却する応答電文（レスポンスメッセージ）の例
  - s3: 電文を2回以上送信する場合の要求電文の期待値および、返却する応答電文（レスポンスメッセージ）の例
  - s5: モックアップを使用するための記述
  - s6: 要求電文のアサート
- s7: フレームワークで使用するクラスの設定
  - s8: モックアップクラスの設定

### リクエスト単体テストの実施方法(同期応答メッセージ受信処理)
path: development-tools/testing-framework/testing-framework-02-requestunittest-real.json
- s1: テストクラスの書き方
- s2: テストメソッド分割
- s3: テストデータの書き方
  - s4: テストクラスで共通のデータベース初期値
  - s5: テストショット一覧
  - s6: 各種準備データ
  - s9: 各種期待値
- s12: テストメソッドの書き方
  - s13: スーパクラスについて
  - s14: テストメソッド作成
  - s15: スーパクラスのメソッド呼び出し
- s16: テスト起動方法
- s17: テスト結果検証

### リクエスト単体テストの実施方法
path: development-tools/testing-framework/testing-framework-02-requestunittest-rest.json
- s1: 前提条件
- s2: テストクラスの書き方
  - s3: フレームワークで用意されたテストクラスのスーパークラスを継承する
  - s4: JUnit4のアノテーションを使用する
  - s5: 事前準備補助機能を使ってリクエストを生成する
  - s6: リクエストを送信する
  - s7: 結果を確認する
- s8: テストデータの書き方
  - s9: テストクラスで共通のデータベース初期値
  - s10: テストメソッド毎のデータベース初期値

### リクエスト単体テストの実施方法(同期応答メッセージ送信処理)
path: development-tools/testing-framework/testing-framework-02-requestunittest-send-sync.json
- s1: 出力ライブラリ(同期応答メッセージ送信処理)の構造とテスト範囲
- s2: テストの実施方法
  - s3: テストデータの書き方
  - s6: テスト結果検証

### 目的別API使用方法
path: development-tools/testing-framework/testing-framework-03-Tips.json
- s1: Excelファイルから、入力パラメータや戻り値に対する期待値などを取得したい
  - s2: テストソースコード実装例
  - s3: Excelファイル記述例
- s4: 同じテストメソッドをテストデータを変えて実行したい
  - s5: テストソースコード実装例
  - s6: Excelファイル記述例
- s7: 一つのシートに複数テストケースのデータを記載したい
  - s8: テストソースコード実装例
  - s9: Excelファイル記述例
  - s10: 注意事項
- s11: システム日時を任意の値に固定したい
  - s12: 設定ファイル例
- s13: シーケンスオブジェクトを使った採番のテストをしたい
  - s14: 設定ファイルの例
  - s15: Excelファイル記述例
- s16: ThreadContextにユーザID、リクエストIDなどを設定したい
  - s17: テストソースコード実装例
  - s18: テストデータ記述例
- s19: 任意のディレクトリのExcelファイルを読み込みたい
  - s20: テストソースコード実装例
- s21: テスト実行前後に共通処理を行いたい。
  - s22: 注意事項
- s24: デフォルト以外のトランザクションを使用したい
- s25: 本フレームワークのクラスを継承せずに使用したい
  - s26: テストソースコード実装例
- s27: クラスのプロパティを検証したい
  - s28: テストソースコード実装例
  - s29: Excelファイル記述例
- s30: テストデータに空白、空文字、改行やnullを記述したい
- s31: テストデータに空行を記述したい
- s32: マスタデータを変更してテストを行いたい
- s33: テストデータ読み込みディレクトリを変更したい
- s34: メッセージング処理でテストデータに対し定型的な変換処理を追加したい
  - s35: 実装するインタフェース
  - s36: システムリポジトリ登録内容
  - s37: システムリポジトリ登録例
  - s38: Excelファイル記述例

### 取引単体テストの実施方法（バッチ）
path: development-tools/testing-framework/testing-framework-03-dealunittest-batch.json
- s1: テストケース分割方針
  - s2: 複雑なテストケースの場合
  - s3: 非常に簡単なテストケースの場合
- s4: 基本的な記述方法
- s5: 1テストケースを複数シートを分割する場合
- s6: 1シートに複数ケースを含める場合

### 取引単体テストの実施方法（応答不要メッセージ受信処理）
path: development-tools/testing-framework/testing-framework-03-dealunittest-delayed-receive.json

### 取引単体テストの実施方法（応答不要メッセージ送信処理）
path: development-tools/testing-framework/testing-framework-03-dealunittest-delayed-send.json

### HTTP同期応答メッセージ送信処理を伴う取引単体テストの実施方法
path: development-tools/testing-framework/testing-framework-03-dealunittest-http-send-sync.json
- s1: モックアップクラスを使用した取引単体テストの実施方法
  - s2: Excelファイルの書き方
  - s5: フレームワークで使用するクラスの設定

### 取引単体テストの実施方法（同期応答メッセージ受信処理)
path: development-tools/testing-framework/testing-framework-03-dealunittest-real.json

### 取引単体テストの実施方法
path: development-tools/testing-framework/testing-framework-03-dealunittest-rest.json
- s1: 取引単体テストのテストクラス例
- s2: Cookieなど前のレスポンスの情報を引き継ぐ方法
  - s3: `RequestResponseProcessor` の実装クラスを作成する
  - s4: コンポーネント設定ファイルに `defaultProcessor` という名前で実装クラスを設定する

### 同期応答メッセージ送信処理を伴う取引単体テストの実施方法
path: development-tools/testing-framework/testing-framework-03-dealunittest-send-sync.json
- s1: モックアップクラスを使用した取引単体テストの実施方法
  - s2: Excelファイルの書き方
  - s7: 要求電文のログ出力
  - s8: フレームワークで使用するクラスの設定

### マスタデータ復旧機能
path: development-tools/testing-framework/testing-framework-04-MasterDataRestore.json
- s1: 概要
- s2: 特徴
- s3: 必要となるスキーマ
- s4: 動作イメージ
- s5: 環境構築
  - s6: バックアップ用スキーマの作成、データ投入
  - s7: 外部キーが設定されたテーブルを使用する場合について
  - s8: コンポーネント設定ファイルに監視対象テーブルを記載
  - s11: ログ出力設定

### JUnit 5用拡張機能
path: development-tools/testing-framework/testing-framework-JUnit5-Extension.json
- s1: 概要
- s2: 前提条件
- s4: 基本的な使い方
- s5: Extension クラスと合成アノテーションの一覧
  - s6: BasicHttpRequestTest の使い方の補足
- s7: 独自の拡張を加える
  - s8: 独自拡張クラスを作成する
  - s9: 独自拡張用のExtensionを作成する
  - s10: ExtendWithでテストクラスに適用する
  - s11: BasicHttpRequestTestTemplateを拡張する場合はアノテーションも作成する
  - s12: 事前処理・事後処理を実装する
  - s13: JUnit 4のTestRuleを再現する
- s14: RegisterExtensionで使用する

### リクエスト単体テスト（バッチ処理）
path: development-tools/testing-framework/testing-framework-RequestUnitTest-batch.json
- s1: 概要
  - s2: 全体像
- s3: 主なクラス, リソース
- s4: 構造
  - s5: StandaloneTestSupportTemplate
  - s6: TestShot
  - s7: BatchRequestTestSupport
  - s8: MainForRequestTesting
  - s9: FileSupport
- s10: テストデータ
  - s11: 固定長ファイル
  - s14: 可変長ファイル
- s15: 各種設定値
  - s16: 常駐バッチのテスト用ハンドラ構成
  - s17: ディレクティブのデフォルト値

### リクエスト単体テスト（HTTP同期応答メッセージ送信処理）
path: development-tools/testing-framework/testing-framework-RequestUnitTest-http-send-sync.json

### リクエスト単体テスト（メッセージ受信処理）
path: development-tools/testing-framework/testing-framework-RequestUnitTest-real.json
- s1: 概要
  - s2: 全体像
- s3: 主なクラス, リソース
- s4: 構造
  - s5: StandaloneTestSupportTemplate
  - s6: TestShot
  - s7: MessagingRequestTestSupport
  - s8: MessagingReceiveTestSupport
  - s9: MainForRequestTesting
  - s10: MQSupport
  - s11: TestDataConvertor
- s12: テストデータ
  - s13: メッセージ

### リクエスト単体テスト（RESTfulウェブサービス）
path: development-tools/testing-framework/testing-framework-RequestUnitTest-rest.json
- s1: 概要
  - s2: 全体像
  - s3: 主なクラス, リソース
  - s5: 設定
- s6: 構造
  - s7: SimpleRestTestSupport
  - s8: RestTestSupport
  - s9: データベース関連機能
  - s10: 事前準備補助機能
  - s11: 実行
  - s12: 結果確認
- s15: 各種設定値
  - s16: コンポーネント設定ファイル設定項目一覧

### リクエスト単体テスト（同期応答メッセージ送信処理）
path: development-tools/testing-framework/testing-framework-RequestUnitTest-send-sync.json
- s1: 概要
  - s2: 全体像
- s3: 主なクラス, リソース
- s4: 構造
  - s5: StandaloneTestSupportTemplate
  - s6: AbstractHttpRequestTestTemplate
  - s7: RequestTestingMessagingProvider
  - s8: MessageSender
  - s9: TestDataConvertor
- s10: テストデータ
  - s11: 同期応答メッセージ送信処理

### Nablarch開発ツール
path: development-tools/testing-framework/testing-framework-development-tools.json

### 二重サブミット防止機能のテスト実施方法
path: development-tools/testing-framework/testing-framework-double-transmission.json
- s1: リクエスト単体テストでの二重サブミット防止機能のテスト実施方法
- s2: 取引単体テストでの二重サブミット防止機能のテスト実施方法

### リクエスト単体テストの実施方法(ファイルアップロード)
path: development-tools/testing-framework/testing-framework-fileupload.json
- s1: アップロードファイルの記述方法
- s2: バイナリファイルの場合
- s3: 固定長ファイル、CSVファイルの場合

### Form/Entityの単体テスト
path: development-tools/testing-framework/testing-framework-guide-development-guide-05-UnitTestGuide-01-ClassUnitTest-01-entityUnitTest.json

### クラス単体テストの実施方法
path: development-tools/testing-framework/testing-framework-guide-development-guide-05-UnitTestGuide-01-ClassUnitTest.json

### リクエスト単体テストの実施方法
path: development-tools/testing-framework/testing-framework-guide-development-guide-05-UnitTestGuide-02-RequestUnitTest.json
- s1: テストクラスの書き方
- s2: テストメソッド分割
- s3: テストデータの書き方
  - s4: テストクラスで共通のデータベース初期値
  - s5: テストケース一覧
  - s6: ユーザ情報
  - s7: Cookie情報
  - s8: クエリパラメータ情報
  - s9: リクエストパラメータ
  - s11: 各種期待値
- s14: テストメソッドの書き方
  - s15: スーパクラスについて
  - s16: テストメソッド作成
  - s17: スーパクラスのメソッド呼び出し
  - s24: ダウンロードファイルのテスト
- s25: テスト起動方法
- s26: テスト結果確認（目視）
  - s27: HTMLダンプ出力結果
- s28: リクエスト単体テストクラス作成時の注意点
  - s29: ThreadContextへの値設定は不要
  - s30: テストクラスでのトランザクション制御は不要

### 取引単体テストの実施方法
path: development-tools/testing-framework/testing-framework-guide-development-guide-05-UnitTestGuide-03-DealUnitTest.json
- s1: テスト準備
- s2: テスト実施
- s3: テスト結果エビデンスの収集
- s4: テスト結果エビデンスの収集

### 単体テスト実施方法
path: development-tools/testing-framework/testing-framework-guide-development-guide-05-UnitTestGuide.json

### 自動テストフレームワークの使用方法
path: development-tools/testing-framework/testing-framework-guide-development-guide-06-TestFWGuide.json

### リクエスト単体データ作成ツール
path: development-tools/testing-framework/testing-framework-guide-development-guide-08-TestTools-01-HttpDumpTool.json

### マスタデータ投入ツール
path: development-tools/testing-framework/testing-framework-guide-development-guide-08-TestTools-02-MasterDataSetup.json

### HTMLチェックツール
path: development-tools/testing-framework/testing-framework-guide-development-guide-08-TestTools-03-HtmlCheckTool.json
- s1: 目的
- s2: 仕様
  - s3: HTML4.01との相違点
- s4: 使用方法
  - s5: 前提条件
  - s6: 使用禁止タグ・属性のカスタマイズ方法
  - s7: HTMLチェック実行要否の設定方法
  - s8: HTMLチェック内容の変更
  - s9: テスト実行時指摘確認方法

### プログラミング工程で使用するツール
path: development-tools/testing-framework/testing-framework-guide-development-guide-08-TestTools.json

### リクエスト単体テストの実施方法（HTTP同期応答メッセージ受信処理）
path: development-tools/testing-framework/testing-framework-http-real.json
- s1: テストデータの書き方
  - s2: テストショット一覧
  - s3: 各種準備データ
  - s5: 各種期待値

### リクエスト単体テストの実施方法(メール送信)
path: development-tools/testing-framework/testing-framework-mail.json
- s1: メール送信処理の構造とテスト範囲
- s2: テストの実施方法

### テスティングフレームワーク
path: development-tools/testing-framework/testing-framework-testing-framework.json

## development-tools/toolbox

### Jakarta Server Pages静的解析ツール
path: development-tools/toolbox/toolbox-01-JspStaticAnalysis.json
- s1: 概要
- s2: 仕様
  - s3: 許可するタグの指定方法
  - s4: チェック対象ファイルの指定方法
  - s5: 対象ファイル内の一部を強制的にチェック対象外にする方法
- s6: 前提条件
- s7: 使用方法
  - s8: 設定ファイルの存在確認
  - s9: Antタスクの定義ファイル確認
  - s10: Jakarta Server Pages静的解析ツールでチェックしたい対象の存在するプロジェクトのpom.xmlの確認
  - s11: Jakarta Server Pages静的解析ツール設定ファイルの記述方法
  - s12: pom.xmlの修正の修正
  - s13: 実行方法
  - s14: 出力結果確認方法

### Jakarta Server Pages静的解析ツール 設定変更ガイド
path: development-tools/toolbox/toolbox-02-JspStaticAnalysisInstall.json
- s1: 前提条件
- s2: 設定ファイル構成
- s3: pom.xmlの書き換え

### Jakarta Server Pages静的解析ツール
path: development-tools/toolbox/toolbox-JspStaticAnalysis.json

### Nablarch OpenAPI Generator
path: development-tools/toolbox/toolbox-NablarchOpenApiGenerator.json
- s1: ツールの概要
- s2: 前提条件
- s3: 動作概要
- s4: 運用方法
- s5: 使用方法
  - s6: Mavenプラグインの設定
  - s7: 実行方法
  - s8: 出力先
  - s9: Generatorの設定項目
  - s10: Bean Validationを使用するソースコードを生成する
  - s11: CLIとして実行する
- s12: ソースコード生成仕様
  - s13: リソース(アクション)インターフェース生成仕様
  - s14: モデル生成仕様
  - s15: 生成されるソースコードが依存するモジュール
  - s16: OpenAPIドキュメントのデータ型およびフォーマットとJavaのデータ型の対応仕様
  - s17: OpenAPIドキュメントのバリデーション定義とBean Validationの対応仕様
  - s20: バリデーションに関する運用上の注意点
- s23: OpenAPIドキュメントと生成されるソースコードの例
  - s24: OpenAPIドキュメントのパスおよびオペレーションの定義とソースコードの生成例
  - s25: OpenAPIドキュメントのスキーマの定義とソースコードの生成例
  - s26: Bean Validationを使用するソースコードの生成例
  - s27: ドメインバリデーションを使用するソースコードの生成例
  - s28: ファイルアップロードの定義例
  - s29: ファイルダウンロードの定義例

### Nablarch SQL Executor
path: development-tools/toolbox/toolbox-SqlExecutor.json
- s1: 概要
- s2: 想定使用方法
  - s3: 本ツールの想定使用方法
  - s4: DB接続方法の選択
- s6: 配布方法
  - s7: 前提条件
  - s8: ソースコード取得
  - s9: DB設定変更
  - s15: 起動確認
  - s16: 配布ファイル作成
- s17: 配布されたツールの使用方法
  - s18: 前提条件
  - s19: 配布されたファイルの起動
  - s20: 配布時に設定済みのDB以外に接続したい場合
- s21: 操作方法
  - s22: 基本的な操作方法
  - s23: SQLExecutorでの記法
- s28: FAQ

### アプリケーション開発時に使える便利なツール
path: development-tools/toolbox/toolbox-toolbox.json

## guide/biz-samples

### データベースを用いたパスワード認証機能サンプル
path: guide/biz-samples/biz-samples-01.json
- s1: 提供パッケージ
- s2: 概要
- s3: 構成
  - s4: クラス図
- s9: 使用方法
  - s10: SystemAccountAuthenticatorの使用方法
  - s11: AuthenticaionUtilの使用方法

### PBKDF2を用いたパスワード暗号化機能サンプル
path: guide/biz-samples/biz-samples-0101-PBKDF2PasswordEncryptor.json
- s1: 提供パッケージ
- s2: 概要
- s3: 要求
  - s4: 実装済み
  - s5: 未検討
- s6: パスワード暗号化機能の詳細
- s7: 設定方法
  - s8: ストレッチング回数の設定値について

### 検索結果の一覧表示
path: guide/biz-samples/biz-samples-03.json
- s1: 提供パッケージ
- s2: 概要
- s3: 構成
  - s4: クラス図
- s6: UniversalDaoクラス
- s7: ListSearchInfoクラス
- s8: Paginationクラス
- s9: EntityListクラス
- s10: listSearchResultタグ
  - s11: listSearchResultタグの主要な属性
  - s12: 検索結果件数
  - s13: ページング
  - s14: 検索結果
- s15: 業務アプリケーションへのサンプル実装(タグファイル)の取り込み方法
- s16: タグリファレンス
  - s17: listSearchResultタグ

### フォーマッタ機能の拡張
path: guide/biz-samples/biz-samples-04.json

### データフォーマッタの拡張
path: guide/biz-samples/biz-samples-0401-ExtendedDataFormatter.json
- s1: 概要
  - s2: 提供パッケージ
  - s3: FormUrlEncodedデータフォーマッタの構成
- s4: 使用方法
  - s5: FormUrlEncodedデータフォーマッタの使用方法
  - s6: フォーマット定義ファイルの記述例
  - s7: フィールドタイプ・フィールドコンバータ定義一覧
  - s8: 同一キーで複数の値を取り扱う場合
  - s9: テストデータの記述方法

### データフォーマッタ機能におけるフィールドタイプの拡張
path: guide/biz-samples/biz-samples-0402-ExtendedFieldType.json
- s1: 概要
  - s2: 提供パッケージ
  - s3: フィールドタイプの構成
  - s4: フィールドタイプの使用方法
  - s5: フィールドタイプ・フィールドコンバータ定義一覧

### データベースを用いたファイル管理機能サンプル
path: guide/biz-samples/biz-samples-05.json
- s1: 概要
  - s2: ファイルアップロード時
  - s3: ファイルダウンロード時
- s4: 機能
  - s5: 実装済み
  - s6: 前提としている仕様
- s7: 構成
  - s8: クラス図
- s12: 使用方法
  - s13: FileManagementUtilの使用方法

### HTMLメール送信機能サンプル
path: guide/biz-samples/biz-samples-08.json
- s1: 概要
- s2: 要求
  - s3: 実装済み
  - s4: 取り下げ
- s5: 構成
  - s6: メールの形式
  - s7: クラス図
  - s10: データモデル
- s13: 実装例
  - s14: HTMLメールの送信
  - s15: コンテンツの動的な切替
  - s17: 電子署名の併用
  - s18: タグを埋めこむ

### bouncycastleを使用した電子署名つきメールの送信サンプルの使用方法
path: guide/biz-samples/biz-samples-09.json
- s1: 環境準備
- s2: 電子署名付きメール送信機能の構造
- s3: 設定ファイルの準備
  - s4: 証明書に関する設定方法
- s5: 実行方法

### ログ集計サンプルの使用方法
path: guide/biz-samples/biz-samples-10.json
- s1: 提供サンプル一覧

### メッセージング基盤テストシミュレータサンプル
path: guide/biz-samples/biz-samples-11.json
- s1: 用途
  - s2: 疎通テスト
  - s3: 結合テスト
  - s4: 負荷テスト
- s5: 特徴
  - s6: 取引単体テストと同じ手順でテストデータを作成できる
  - s7: 特殊および複雑なテストケースにも、カスタマイズすることで対応可能(メッセージ受信)
  - s8: マルチスレッドで要求電文を送信することが可能（メッセージ送信）
- s9: 要求
  - s10: シミュレータがメッセージ受信する場合
  - s11: シミュレータがメッセージ送信する場合
- s12: 使用方法
  - s13: シミュレータの実行モジュールを作成する
  - s14: シミュレータを起動する
- s15: 拡張例
  - s16: メッセージ送信時にリクエスト送信回数を指定する
  - s17: メッセージ受信時にリクエストの種類に応じてレスポンスを切り替える
  - s18: メッセージ受信時に意図的にレスポンスを遅延させる

### OIDCのIDトークンを用いた認証サンプル
path: guide/biz-samples/biz-samples-12.json
- s1: 提供パッケージ
- s2: 概要
  - s3: 本サンプルで取り扱う範囲
- s4: 構成
  - s5: クラス図
  - s6: 各クラスの責務
- s10: 使用方法
  - s11: 依存ライブラリの追加
  - s12: 環境依存値の設定
  - s13: コンポーネント定義の設定
  - s14: IDトークンの検証
  - s15: 認証用業務アクションのパス設定
  - s16: 認証および成功時のログイン状態設定

### Logbookを用いたリクエスト/レスポンスログ出力サンプル
path: guide/biz-samples/biz-samples-13.json
- s1: 概要
  - s2: 本サンプルで取り扱う範囲
- s3: 使用方法
  - s4: 依存ライブラリの追加
  - s5: log.propertiesの設定
  - s6: Logbookの構成
  - s7: JAX-RSクライアントにLogbookを登録
  - s8: リクエスト/レスポンスのログを出力

### オンラインアクセスログ集計機能
path: guide/biz-samples/biz-samples-OnlineAccessLogStatistics.json
- s1: サンプル構成
  - s2: 処理の流れ
- s3: 各サンプルの仕様及び実行手順
  - s4: オンラインアクセスログ解析バッチ
  - s7: オンラインアクセスログ解析結果集計バッチ
  - s10: オンラインアクセスログ集計結果レポートサンプル
  - s12: オンラインアクセスログ解析及び集計サンプルの設定

### 目的別の実装サンプル集
path: guide/biz-samples/biz-samples-biz-samples.json

## guide/nablarch-patterns

### Nablarchでの非同期処理
path: guide/nablarch-patterns/nablarch-patterns-Nablarchでの非同期処理.json
- s1: メール送信を行う場合

### Nablarchアンチパターン
path: guide/nablarch-patterns/nablarch-patterns-Nablarchアンチパターン.json
- s1: Webアプリケーション
  - s2: コンポーネントライフサイクルの誤解によるマルチスレッドバグ
- s3: Nablarchバッチ
  - s4: N+1問題
  - s9: フレームワーク制御下にないループ処理
  - s11: 解決法
- s12: Jakarta Batchに準拠したバッチ
  - s13: Batchletの誤用

### Nablarchバッチ処理パターン
path: guide/nablarch-patterns/nablarch-patterns-Nablarchバッチ処理パターン.json
- s1: 起動方法による分類
- s2: 入出力による分類
  - s3: FILE to DB
  - s4: DB to DB
  - s5: DB to FILE
  - s6: 上記以外の組み合わせ(FILE to FILE)
- s7: 注意点
  - s8: ファイルの移動、コピー

## processing-pattern/db-messaging

### アプリケーションの責務配置
path: processing-pattern/db-messaging/db-messaging-application-design.json

### アーキテクチャ概要
path: processing-pattern/db-messaging/db-messaging-architecture.json
- s1: 構成
- s2: リクエストパスによるアクションとリクエストIDの指定
- s3: 処理の流れ
- s4: 使用するハンドラ
- s5: ハンドラの最小構成
- s6: 使用するデータリーダ
- s7: 使用するアクションのテンプレートクラス

### テーブルをキューとして使ったメッセージング
path: processing-pattern/db-messaging/db-messaging-db.json

### データベースをキューとしたメッセージングのエラー処理
path: processing-pattern/db-messaging/db-messaging-error-processing.json
- s1: エラーとなったデータを除外し処理を継続する
- s2: プロセスを異常終了させる

### 機能詳細
path: processing-pattern/db-messaging/db-messaging-feature-details.json
- s1: アプリケーションの起動方法
- s2: システムリポジトリの初期化
- s3: データベースアクセス
- s4: 入力値のチェック
- s5: 排他制御
- s6: 実行制御
- s7: マルチプロセス化

### Getting Started
path: processing-pattern/db-messaging/db-messaging-getting-started.json

### メッセージング編
path: processing-pattern/db-messaging/db-messaging-messaging.json

### マルチプロセス化
path: processing-pattern/db-messaging/db-messaging-multiple-process.json

### テーブルキューを監視し未処理データを取り込むアプリケーションの作成
path: processing-pattern/db-messaging/db-messaging-table-queue.json
- s1: アクションクラスを作成する
- s2: テーブルを監視するためのリーダを生成する
- s3: 未処理データを元に業務処理を実行する
- s4: 処理済みデータのステータスを更新する

## processing-pattern/http-messaging

### アプリケーションの責務配置
path: processing-pattern/http-messaging/http-messaging-application-design.json

### アーキテクチャ概要
path: processing-pattern/http-messaging/http-messaging-architecture.json
- s1: HTTPメッセージングの構成
- s2: HTTPメッセージングの処理の流れ
- s3: HTTPメッセージングで使用するハンドラ
- s4: HTTPメッセージングの最小ハンドラ構成
- s5: HTTPメッセージングで使用するアクション

### 機能詳細
path: processing-pattern/http-messaging/http-messaging-feature-details.json
- s1: Nablarchの初期化
- s2: 入力値のチェック
- s3: データベースアクセス
- s4: 排他制御
- s5: URIとアクションクラスのマッピング
- s6: 国際化対応
- s7: 認証
- s8: 認可チェック
- s9: エラー時に返却するレスポンス

### 登録機能の作成
path: processing-pattern/http-messaging/http-messaging-getting-started-save.json
- s1: 登録を行う

### Getting Started
path: processing-pattern/http-messaging/http-messaging-getting-started.json

### HTTPメッセージング編
path: processing-pattern/http-messaging/http-messaging-http-messaging.json

## processing-pattern/jakarta-batch

### アプリケーションの責務配置
path: processing-pattern/jakarta-batch/jakarta-batch-application-design.json
- s1: Batchletステップの場合
- s2: Chunkステップの場合

### アーキテクチャ概要
path: processing-pattern/jakarta-batch/jakarta-batch-architecture.json
- s1: バッチアプリケーションの構成
- s2: バッチの種類
- s3: バッチアプリケーションの処理の流れ
  - s4: Batchlet
  - s5: Chunk
  - s6: 例外(エラー含む)発生時の処理の流れ
- s9: バッチアプリケーションで使用するリスナー
- s10: 最小のリスナー構成
- s11: リスナーの指定方法

### データベースを入力とするChunkステップ
path: processing-pattern/jakarta-batch/jakarta-batch-database-reader.json

### 機能詳細
path: processing-pattern/jakarta-batch/jakarta-batch-feature-details.json
- s1: バッチアプリケーションの起動方法
- s2: システムリポジトリの初期化
- s3: バッチジョブに適用するリスナーの定義方法
- s4: 入力値のチェック
- s5: データベースアクセス
- s6: ファイル入出力
- s7: 排他制御
- s8: ジョブ定義のxmlの作成方法
- s9: MOMメッセージ送信
- s10: 運用設計

### 対象テーブルのデータを削除するバッチの作成(Batchletステップ)
path: processing-pattern/jakarta-batch/jakarta-batch-getting-started-batchlet.json
- s1: 対象テーブルのデータを削除する

### データを導出するバッチの作成(Chunkステップ)
path: processing-pattern/jakarta-batch/jakarta-batch-getting-started-chunk.json
- s1: データを導出する
  - s2: 入力データソースからデータを読み込む
  - s3: 業務ロジックを実行する
  - s4: 永続化処理を行う
  - s5: JOB設定ファイルを作成する

### Getting Started
path: processing-pattern/jakarta-batch/jakarta-batch-getting-started.json

### Jakarta Batchに準拠したバッチアプリケーション
path: processing-pattern/jakarta-batch/jakarta-batch-jsr352.json

### 運用方針
path: processing-pattern/jakarta-batch/jakarta-batch-operation-policy.json
- s1: 障害監視
- s2: ログの出力方針

### 運用担当者向けのログ出力
path: processing-pattern/jakarta-batch/jakarta-batch-operator-notice-log.json
- s1: 運用担当者向けログの出力内容
- s2: 運用担当者向けのログを専用のログファイルに出力するための設定を追加する
- s3: 運用担当者向けのログを出力する

### Jakarta Batchに準拠したバッチアプリケーションの悲観的ロック
path: processing-pattern/jakarta-batch/jakarta-batch-pessimistic-lock.json

### 進捗状況のログ出力
path: processing-pattern/jakarta-batch/jakarta-batch-progress-log.json
- s1: 進捗ログで出力される内容
- s2: 進捗ログを専用のログファイルに出力するための設定を追加する
- s3: Batchletステップで進捗ログを出力する
- s4: Chunkステップで進捗ログを出力する

### Jakarta Batchアプリケーションの起動
path: processing-pattern/jakarta-batch/jakarta-batch-run-batch-application.json
- s1: バッチアプリケーションを起動する
- s2: バッチアプリケーションの終了コード
- s3: システムリポジトリを初期化する

## processing-pattern/mom-messaging

### アプリケーションの責務配置
path: processing-pattern/mom-messaging/mom-messaging-application-design.json

### アーキテクチャ概要
path: processing-pattern/mom-messaging/mom-messaging-architecture.json
- s1: MOMメッセージングの構成
- s2: 要求電文によるアクションとリクエストIDの指定
- s3: MOMメッセージングの処理の流れ
- s4: MOMメッセージングで使用するハンドラ
  - s5: 同期応答メッセージングの最小ハンドラ構成
  - s6: 応答不要メッセージングの最小ハンドラ構成
- s7: MOMメッセージングで使用するデータリーダ
- s8: MOMメッセージングで使用するアクション

### 機能詳細
path: processing-pattern/mom-messaging/mom-messaging-feature-details.json
- s1: アプリケーションの起動方法
- s2: システムリポジトリの初期化
- s3: データベースアクセス
- s4: 入力値のチェック
- s5: 排他制御
- s6: 実行制御
- s7: MOMメッセージング
- s8: 出力するデータの表示形式のフォーマット

### Getting Started
path: processing-pattern/mom-messaging/mom-messaging-getting-started.json

### MOMによるメッセージング
path: processing-pattern/mom-messaging/mom-messaging-mom.json

## processing-pattern/nablarch-batch

### アプリケーションの責務配置
path: processing-pattern/nablarch-batch/nablarch-batch-application-design.json

### アーキテクチャ概要
path: processing-pattern/nablarch-batch/nablarch-batch-architecture.json
- s1: Nablarchバッチアプリケーションの構成
- s2: リクエストパスによるアクションとリクエストIDの指定
- s3: Nablarchバッチアプリケーションの処理の流れ
- s4: Nablarchバッチアプリケーションで使用するハンドラ
  - s5: 都度起動バッチの最小ハンドラ構成
  - s6: 常駐バッチの最小ハンドラ構成
- s7: Nablarchバッチアプリケーションで使用するデータリーダ
- s8: Nablarchバッチアプリケーションで使用するアクション

### バッチアプリケーション編
path: processing-pattern/nablarch-batch/nablarch-batch-batch.json

### 機能詳細
path: processing-pattern/nablarch-batch/nablarch-batch-feature-details.json
- s1: バッチアプリケーションの起動方法
- s2: システムリポジトリの初期化
- s3: 入力値のチェック
- s4: データベースアクセス
- s5: ファイル入出力
- s6: 排他制御
- s7: バッチ処理の実行制御
- s8: MOMメッセージ送信
- s9: バッチ実行中の状態の保持
- s10: 常駐バッチのマルチプロセス化

### Jakarta Batchに準拠したバッチアプリケーションとNablarchバッチアプリケーションとの機能比較
path: processing-pattern/nablarch-batch/nablarch-batch-functional-comparison.json

### ファイルをDBに登録するバッチの作成
path: processing-pattern/nablarch-batch/nablarch-batch-getting-started-nablarch-batch.json
- s1: ファイルをDBに登録する
  - s2: 入力データソースからデータを読み込む
  - s3: 業務ロジックを実行する

### Getting Started
path: processing-pattern/nablarch-batch/nablarch-batch-getting-started.json

### Nablarchバッチアプリケーションのエラー処理
path: processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-error-process.json
- s1: バッチ処理をリランできるようにする
- s2: バッチ処理でエラー発生時に処理を継続する
- s3: バッチ処理を異常終了にする

### 常駐バッチアプリケーションのマルチプロセス化
path: processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-multiple-process.json

### Nablarchバッチアプリケーションの悲観的ロック
path: processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-pessimistic-lock.json

### バッチアプリケーションで実行中の状態を保持する
path: processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch-retention-state.json

### Nablarchバッチアプリケーション
path: processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch.json

## processing-pattern/restful-web-service

### RESTFulウェブサービスの責務配置
path: processing-pattern/restful-web-service/restful-web-service-application-design.json

### アーキテクチャ概要
path: processing-pattern/restful-web-service/restful-web-service-architecture.json
- s1: RESTfulウェブサービスの構成
- s2: RESTfulウェブサービスの処理の流れ
- s3: RESTfulウェブサービスで使用するハンドラ
  - s4: 最小ハンドラ構成

### 機能詳細
path: processing-pattern/restful-web-service/restful-web-service-feature-details.json
- s1: Nablarchの初期化
- s2: 入力値のチェック
- s3: データベースアクセス
- s4: 排他制御
- s5: URIとリソース(アクション)クラスのマッピング
- s6: パスパラメータやクエリーパラメータ
- s7: レスポンスヘッダ
- s8: 国際化対応
- s9: 認証
- s10: 認可チェック
- s11: エラー時に返却するレスポンス
- s12: Webアプリケーションのスケールアウト設計
- s13: CSRF対策
- s14: CORS
- s15: OpenAPIドキュメントからのソースコード生成

### Jakarta RESTful Web Servicesサポート/Jakarta RESTful Web Services/HTTPメッセージングの機能比較
path: processing-pattern/restful-web-service/restful-web-service-functional-comparison.json

### 登録機能の作成
path: processing-pattern/restful-web-service/restful-web-service-getting-started-create.json
- s1: プロジェクト情報を登録する

### 検索機能の作成
path: processing-pattern/restful-web-service/restful-web-service-getting-started-search.json
- s1: プロジェクト情報を検索する

### 更新機能の作成
path: processing-pattern/restful-web-service/restful-web-service-getting-started-update.json
- s1: プロジェクト情報を更新する

### Getting Started
path: processing-pattern/restful-web-service/restful-web-service-getting-started.json

### リソース(アクション)クラスの実装に関して
path: processing-pattern/restful-web-service/restful-web-service-resource-signature.json
- s1: リソースクラスのメソッドのシグネチャ
- s2: パスパラメータを扱う
- s3: クエリーパラメータを扱う
- s4: レスポンスヘッダを設定する

### RESTfulウェブサービス編
path: processing-pattern/restful-web-service/restful-web-service-rest.json

### ウェブサービス編
path: processing-pattern/restful-web-service/restful-web-service-web-service.json

## processing-pattern/web-application

### アプリケーションの責務配置
path: processing-pattern/web-application/web-application-application-design.json

### アーキテクチャ概要
path: processing-pattern/web-application/web-application-architecture.json
- s1: ウェブアプリケーションの構成
- s2: ウェブアプリケーションの処理の流れ
- s3: ウェブアプリケーションで使用するハンドラ
  - s4: 最小ハンドラ構成

### 登録画面初期表示の作成
path: processing-pattern/web-application/web-application-client-create1.json

### 登録内容の確認
path: processing-pattern/web-application/web-application-client-create2.json

### 登録内容確認画面から登録画面へ戻る
path: processing-pattern/web-application/web-application-client-create3.json

### データベースへの登録
path: processing-pattern/web-application/web-application-client-create4.json

### バリデーションエラーのメッセージを画面表示する
path: processing-pattern/web-application/web-application-error-message.json

### 機能詳細
path: processing-pattern/web-application/web-application-feature-details.json
- s1: Nablarchの初期化
- s2: 入力値のチェック
- s3: データベースアクセス
- s4: 排他制御
- s5: ファイルアップロード
- s6: ファイルダウンロード
- s7: URIとアクションクラスのマッピング
- s8: 2重サブミット防止
- s9: 入力データの保持
- s10: ページネーション
- s11: 画面の作成
- s12: 国際化対応
- s13: 認証
- s14: 認可チェック
- s15: ステータスコード
- s16: エラー時の画面遷移とステータスコード
- s17: MOMメッセージ送信
- s18: Webアプリケーションのスケールアウト設計
- s19: CSRF対策
- s20: ウェブアプリケーションとRESTfulウェブサービスの併用
- s21: Content Security Policy(CSP)対応

### エラー時の遷移先の指定方法
path: processing-pattern/web-application/web-application-forward-error-page.json
- s1: ハンドラで共通の振る舞いを定義する
- s2: 1つの例外クラスに対して複数の遷移先がある場合の実装方法

### 登録機能の作成(ハンズオン形式)
path: processing-pattern/web-application/web-application-getting-started-client-create.json
- s1: 顧客登録機能の仕様

### ポップアップ画面の作成
path: processing-pattern/web-application/web-application-getting-started-popup.json
- s1: ポップアップ(ダイアログ)画面を表示する

### 一括更新機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-bulk-update.json
- s1: 一括更新機能の作成

### 削除機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-delete.json
- s1: 削除を行う

### ファイルダウンロード機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-download.json
- s1: CSVファイルのダウンロードを行う

### 検索機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-search.json
- s1: 検索する

### 更新機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-update.json
- s1: 更新内容の入力と確認
- s2: データベースの更新

### アップロードを用いた一括登録機能の作成
path: processing-pattern/web-application/web-application-getting-started-project-upload.json
- s1: 作成する業務アクションメソッドの全体像
- s2: ファイルアップロード機能の実装
- s3: 一括登録機能の実装

### Getting Started
path: processing-pattern/web-application/web-application-getting-started.json

### JSPで自動的にHTTPセッションを作成しないようにする方法
path: processing-pattern/web-application/web-application-jsp-session.json

### Nablarchサーブレットコンテキスト初期化リスナー
path: processing-pattern/web-application/web-application-nablarch-servlet-context-listener.json
- s2: システムリポジトリを初期化する
- s3: 初期化の成否を後続処理で取得する

### その他のテンプレートエンジンを使用した画面開発
path: processing-pattern/web-application/web-application-other.json

### Webフロントコントローラ
path: processing-pattern/web-application/web-application-web-front-controller.json
- s2: ハンドラキューを設定する
- s3: 委譲するWebフロントコントローラの名前を変更する

### ウェブアプリケーション編
path: processing-pattern/web-application/web-application-web.json

## releases/releases

### ■Nablarch 6 リリースノート
path: releases/releases/releases-nablarch6-releasenote-6.json
- s2: Jakarta EE 10対応
- s3: 必要Javaバージョンの変更
- s4: アダプタ
- s5: Nablarch 6 対応（動作検証中）
- s6: Example
- s7: Nablarch 6 対応
- s8: ETL基盤
- s9: 解説書からの削除
- s10: 帳票ライブラリ
- s11: 解説書からの削除
- s12: ワークフローライブラリ
- s13: 解説書からの削除
- s14: テスティングフレームワーク
- s15: Nablarch 6 対応
- s16: Nablarch実装例集
- s17: 実装例集の一時削除

### ■バージョンアップ手順
path: releases/releases/releases-nablarch6-releasenote-バージョンアップ手順.json

### ■モジュールバージョン一覧
path: releases/releases/releases-nablarch6-releasenote-モジュールバージョン一覧.json
- s1: ブランクプロジェクト
- s2: Example
- s3: Example
- s4: Example
- s5: Example
- s6: Example
- s7: Example
- s8: Example
- s9: Example
- s10: Example
- s11: Example
- s12: Example
- s13: Example
- s14: Example
- s56: テスティングフレームワーク
- s57: テスティングフレームワーク
- s58: テスティングフレームワーク
- s59: アダプタ
- s60: アダプタ
- s61: アダプタ
- s62: アダプタ
- s63: アダプタ
- s64: アダプタ
- s65: アダプタ
- s66: アダプタ
- s67: アダプタ
- s68: アダプタ
- s69: アダプタ
- s70: アダプタ
- s71: アダプタ
- s72: アダプタ
- s73: アダプタ
- s74: アダプタ
- s75: 開発ツール

### ■Nablarch 6u1 リリースノート
path: releases/releases/releases-nablarch6u1-releasenote-6u1.json
- s2: システム日時をLocalDateTime型で取得できる機能を追加
- s3: ユニバーサルDAOのエンティティ生成機能をDate and Time APIに対応
- s4: BeanUtilをレコードに対応
- s5: JSON形式のファイルを読み込む際、値の最後がエスケープ文字だとエラーが発生する問題に対応
- s6: 件数取得SQLをカスタマイズできるようにDialectインターフェースを拡張しました
- s7: https://nablarch.github.io/docs/6u1/doc/application_framework/application_framework/libraries/database/universal_dao.html#universal_dao-customize_sql_for_counting
- s8: HTTPリクエストからリクエストパラメータを取得するAPIをアーキテクト向け公開APIに変更
- s9: RESTfulウェブサービス専用のHTTPリクエストクラスを追加
- s10: 分散トレーシングの依存ライブラリのバージョンを変更
- s11: ブランクプロジェクトを Java 21 で動かす際に必要になる修正手順を追加
- s12: アプリケーションフレームワークのテスト環境を更新
- s13: Java 21 に対応
- s14: アダプタ
- s15: SLF4Jのバージョンを2.0.11に変更
- s16: SLF4Jのバージョンを2.0.11に変更
- s17: Lettuceのバージョンを6.2.3.RELEASEに変更
- s18: 使用するIBM MQのバージョンを変更
- s19: Example
- s20: HTTPリクエストからリクエストパラメータを取得する共通部品を追加
- s21: テスティングフレームワーク
- s22: HTTPリクエストからリクエストパラメータを取得する処理を追加
- s23: https://nablarch.github.io/docs/6u1/publishedApi/nablarch-testing/publishedApiDoc/programmer/nablarch/test/core/http/HttpRequestTestSupport.html#getParam-nablarch.fw.web.HttpRequest-java.lang.String-

### ■バージョンアップ手順
path: releases/releases/releases-nablarch6u1-releasenote-バージョンアップ手順.json

### ■件数取得SQLの拡張ポイント追加
path: releases/releases/releases-nablarch6u1-releasenote-件数取得SQLの拡張ポイント追加.json

### ■Nablarch 6u2 リリースノート
path: releases/releases/releases-nablarch6u2-releasenote-6u2 (6u1からの変更点).json
- s2: 公開APIの追加
- s3: JSR310アダプタの標準機能への取り込み
- s4: 業務画面JSP検証ツールの削除
- s5: CSPのscript-srcにunsafe-inline以外を指定できるように改善
- s6: Jettyの一時ディレクトリのデフォルト値を変更
- s7: Java標準APIのJavadocリンク先をJava 17のJavadocに変更
- s8: テスト環境のアプリケーションサーバを更新
- s9: テスト環境のデータベースを更新
- s10: マイグレーションガイドに6u2のリリース内容を反映
- s11: 明示的にバリデーションを実行するための使用方法を追加
- s12: 静的解析ツールのバージョン更新
- s13: デフォルトのTomcat 10のコンテナイメージの更新
- s14: Mavenプラグインのバージョン更新
- s15: 不要なMavenプラグイン設定の削除
- s16: Maven Archetype Plugin 3.xに対応
- s17: maven-clean-plugin 設定の削除
- s18: アプリケーションのJSTLの除外設定を追加
- s19: Jacksonのバージョン更新
- s20: Logback、SLF4Jのバージョン更新
- s21: JBeretに関連するライブラリのバージョン更新
- s22: アダプタ
- s23: OpenTelemetry Protocol（OTLP）用のレジストリファクトリを追加
- s24: JBoss Loggingのバージョン更新
- s25: Domaのバージョン更新
- s26: Jacksonのバージョン更新
- s27: DataDogの利用手順変更
- s28: Example
- s29: CSP対応
- s30: Jersey、Jacksonのバージョン更新
- s31: ActiveMQ Artemisのバージョン更新
- s32: テスティングフレームワーク
- s33: Java EEの仕様名等をJakarta EEのものに変更
- s34: Jetty12のバージョン更新
- s35: Junit 5のバージョン更新
- s36: 実装サンプル集
- s37: Nablarch 6 対応
- s38: Nablarch開発標準
- s39: Jakarta EE 10対応による修正
- s40: JSP自動生成ツールの記載削除
- s41: Bean Validationを使用する記載に修正
- s42: 業務画面JSP検証ツールの記載削除

### ■Nablarch 6u2 リリースノート
path: releases/releases/releases-nablarch6u2-releasenote-6u2（5u25からの変更点）.json
- s2: Jakarta EE 10対応
- s3: Java EEの仕様名等をJakarta EEのものに変更
- s4: 必要Javaバージョンの変更
- s5: 公開APIの追加
- s6: システム日時をLocalDateTime型で取得できる機能を追加
- s7: ユニバーサルDAOのエンティティ生成機能をDate and Time APIに対応
- s8: BeanUtilをレコードに対応
- s9: JSR310アダプタの標準機能への取り込み
- s10: 業務画面JSP検証ツールの削除
- s11: Jettyの一時ディレクトリのデフォルト値を変更
- s12: Java標準APIのJavadocリンク先をJava 17のJavadocに変更
- s13: テスト環境のアプリケーションサーバを更新
- s14: 分散トレーシングの依存ライブラリのバージョンを変更
- s15: ウェブ、RESTfulウェブサービスプロジェクトの疎通確認で不要な手順を削除
- s16: 静的解析ツールのバージョン更新
- s17: デフォルトのTomcat 10のコンテナイメージの更新
- s18: Mavenプラグインのバージョン更新
- s19: 不要なMavenプラグイン設定の削除
- s20: Maven Archetype Plugin 3.xに対応
- s21: maven-clean-plugin 設定の削除
- s22: Jacksonのバージョン更新
- s23: Logback、SLF4Jのバージョン更新
- s24: JBeretに関連するライブラリのバージョン更新
- s25: アダプタ
- s26: Nablarch 6 対応
- s27: SLF4Jのバージョン更新
- s28: SLF4Jのバージョン更新
- s29: JBoss Loggingのバージョン更新
- s30: Domaのバージョン更新
- s31: Jacksonのバージョン更新
- s32: Example
- s33: Nablarch 6 対応
- s34: Jersey、Jacksonのバージョン更新
- s35: ActiveMQ Artemisのバージョン更新
- s36: ETL基盤
- s37: 解説書からの削除
- s38: 帳票ライブラリ
- s39: 解説書からの削除
- s40: ワークフローライブラリ
- s41: 解説書からの削除
- s42: UI開発基盤
- s43: 解説書からの削除
- s44: テスティングフレームワーク
- s45: Nablarch 6 対応
- s46: Junit 5のバージョン更新
- s47: 実装サンプル集
- s48: Nablarch 6 対応
- s49: Nablarch開発標準
- s50: Jakarta EE 10対応による修正
- s51: JSP自動生成ツールの記載削除
- s52: Bean Validationを使用する記載に修正
- s53: 業務画面JSP検証ツールの記載削除

### ■バージョンアップ手順
path: releases/releases/releases-nablarch6u2-releasenote-バージョンアップ手順.json

### ■モジュールバージョン一覧
path: releases/releases/releases-nablarch6u2-releasenote-モジュールバージョン一覧.json
- s1: ブランクプロジェクト
- s2: Example
- s3: Example
- s4: Example
- s5: Example
- s6: Example
- s7: Example
- s8: Example
- s9: Example
- s10: Example
- s11: Example
- s12: Example
- s13: Example
- s14: Example
- s15: 実装サンプル集
- s57: テスティングフレームワーク
- s58: テスティングフレームワーク
- s59: テスティングフレームワーク
- s60: アダプタ
- s61: アダプタ
- s62: アダプタ
- s63: アダプタ
- s64: アダプタ
- s65: アダプタ
- s66: アダプタ
- s67: アダプタ
- s68: アダプタ
- s69: アダプタ
- s70: アダプタ
- s71: アダプタ
- s72: アダプタ
- s73: アダプタ
- s74: アダプタ
- s75: アダプタ
- s76: 開発ツール

### ■Nablarch 6u3 リリースノート
path: releases/releases/releases-nablarch6u3-releasenote-6u3.json
- s2: 親クラス・インタフェースでのリソース定義に対応 (No.24.OpenAPI対応に伴う変更)
- s3: https://nablarch.github.io/docs/6u3/doc/application_framework/adaptors/router_adaptor.html
- s4: EntityResponseの型パラメータ追加 (No.24.OpenAPI対応に伴う変更)
- s5: Date and Time APIサポート拡充 (No.24.OpenAPI対応に伴う変更)
- s6: マルチパート用のBodyConverter追加 (No.24.OpenAPI対応に伴う変更)
- s7: MapからBeanへ移送するメソッドのパフォーマンス改善
- s8: JSONの読み取りに失敗する問題を修正
- s9: BeanValidationStrategyのバリデーション処理をカスタマイズできるように修正
- s10: 公開APIの追加
- s11: ResumeDataReaderのJavadoc改善
- s12: TableIdGeneratorのJavadoc改善
- s13: Base64UtilのJavadoc・解説書改善
- s14: https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/libraries/utility.html
- s15: PublishedアノテーションのJavadoc改善
- s16: 初期化が必要なコンポーネントに対する説明の改善
- s17: マルチパートリクエストのサポート
- s18: Tomcatベースイメージの更新
- s19: gsp-dba-maven-pluginのバージョン更新
- s20: 使用不許可APIツールのバージョン更新
- s21: アダプタ
- s22: Date and Time APIのサポート (No.24.OpenAPI対応に伴う変更)
- s23: マルチパートリクエストのサポート (No.24.OpenAPI対応に伴う変更)
- s24: Example
- s25: jQuery、Bootstrapのバージョンアップ
- s26: マルチパートリクエストのサポート (No.24.OpenAPI対応に伴う変更)
- s27: gsp-dba-maven-pluginのバージョン更新
- s28: 実装サンプル集
- s29: タグファイルのスタイル適用設定修正
- s30: Nablarch開発標準
- s31: Nablarch OpenAPI Generatorのリリース
- s32: 解説書の手順と実際のモジュールの構成差異を修正
- s33: Java21でjava.lang.Objectのメソッドが許可できない場合がある問題に対応

### ■バージョンアップ手順
path: releases/releases/releases-nablarch6u3-releasenote-バージョンアップ手順.json

### ■Jakarta RESTful Web Servicesアダプタでマルチパートリクエストを扱うための設定変更手順
path: releases/releases/releases-nablarch6u3-releasenote-マルチパートリクエストのサポート対応.json

## setup/blank-project

### 使用するRDBMSの変更手順
path: setup/blank-project/blank-project-CustomizeDB.json
- s1: 前提
- s2: Mavenリポジトリへのファイル登録
  - s3: JDBCドライバの登録
- s9: ファイル修正
  - s10: propertiesファイルの修正
  - s17: pom.xmlファイルの修正
  - s25: (本番環境でJNDIからコネクションを取得するプロジェクトの場合)コンポーネント設定ファイル (src/main/resources/)
  - s26: (本番環境でローカルにコネクションプールを作成するプロジェクトの場合)data-source.xml  (src/main/resources/)
  - s27: unit-test.xml  (src/test/resources)
- s28: Nablarchが使用するテーブル作成とデータの投入
  - s29: テーブル作成
  - s30: データの投入
- s31: 動作確認

### 初期セットアップ手順
path: setup/blank-project/blank-project-FirstStep.json

### 初期セットアップ手順（コンテナ）
path: setup/blank-project/blank-project-FirstStepContainer.json

### Mavenアーキタイプの構成
path: setup/blank-project/blank-project-MavenModuleStructures.json
- s1: 全体構成の概要
- s2: 各構成要素の詳細
  - s3: nablarch-archetype-parent(親プロジェクト)
  - s6: pj-webプロジェクト
  - s9: pj-jaxrsプロジェクト
  - s11: pj-batch-eeプロジェクト
  - s14: pj-batchプロジェクト
  - s17: pj-batch-dblessプロジェクト
  - s20: pj-container-webプロジェクト
  - s23: pj-container-jaxrsプロジェクト
  - s25: pj-container-batchプロジェクト
  - s27: pj-container-batch-dblessプロジェクト
  - s29: 各プロジェクト共通の設定
  - s35: ビルド設定
- s38: 【参考】プロジェクト分割方針
  - s39: 推奨するプロジェクト構成の方針
  - s40: プロジェクトを過度に分割した場合の問題点

### 初期セットアップ後に必要となる設定変更
path: setup/blank-project/blank-project-ModifySettings.json

### テーブルをキューとして使ったメッセージングを再び起動したい場合にすること
path: setup/blank-project/blank-project-ResiBatchReboot.json
- s1: 概要
- s2: 手順

### gsp-dba-maven-plugin(DBA作業支援ツール)の初期設定方法
path: setup/blank-project/blank-project-addin-gsp.json
- s1: 概要
- s2: generate-entityゴールがJava17以降で動くように設定する
- s3: ファイル修正
  - s4: pom.xmlファイルの修正
  - s7: data-model.edm  (src/main/resources/entity)の準備
- s8: 動作確認
- s9: データモデリングツールについての補足

### 初期セットアップの前に
path: setup/blank-project/blank-project-beforeFirstStep.json
- s1: ブランクプロジェクト（プロジェクトのひな形）について
  - s2: ブランクプロジェクトの種類
  - s3: ブランクプロジェクトの設計思想と留意事項
- s4: 初期セットアップの前提
- s5: Mavenの設定
- s6: 使用するNablarchのバージョンの指定
- s7: 初期セットアップを行う際の共通的な注意点

### ブランクプロジェクト
path: setup/blank-project/blank-project-blank-project.json

### 初期セットアップ手順　補足事項
path: setup/blank-project/blank-project-firststep-complement.json
- s1: H2のデータの確認方法
- s2: アーキタイプから生成したプロジェクトに組み込まれているツール

### Apache Mavenについて
path: setup/blank-project/blank-project-maven.json
- s1: Mavenとは
- s2: Mavenリポジトリ
- s3: Mavenのインストール方法
- s4: Mavenの設定
- s5: Mavenのゴール
- s6: Mavenのよくあるトラブル
  - s7: Return code is: 503 , ReasonPhrase:Service Unavailable.が返ってくる
  - s8: mvnコマンドの結果が期待と異なる

### コンテナ用Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-ContainerBatch-Dbless.json
- s1: 生成するプロジェクトの概要
- s2: ブランクプロジェクト作成
  - s3: mvnコマンドの実行
  - s4: プロジェクト情報の入力
- s5: 疎通確認
- s6: コンテナイメージを作成する
- s7: コンテナイメージを実行する

### コンテナ用Nablarchバッチプロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-ContainerBatch.json
- s1: 生成するプロジェクトの概要
- s2: ブランクプロジェクト作成
  - s3: mvnコマンドの実行
  - s4: プロジェクト情報の入力
- s5: 疎通確認
- s6: コンテナイメージを作成する
- s7: コンテナイメージを実行する
  - s8: 都度起動バッチ
  - s9: テーブルをキューとして使ったメッセージング
- s10: データベースに関する設定を行う
- s11: 補足

### コンテナ用ウェブプロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-ContainerWeb.json
- s1: 生成するプロジェクトの概要
- s2: ブランクプロジェクト作成
  - s3: mvnコマンドの実行
  - s4: プロジェクト情報の入力
- s5: 疎通確認
- s6: コンテナイメージを作成する
- s7: コンテナイメージを実行する
- s8: データベースに関する設定を行う
- s9: 補足

### コンテナ用RESTfulウェブサービスプロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-ContainerWebService.json
- s1: 事前準備
- s2: 生成するプロジェクトの概要
- s3: ブランクプロジェクト作成
  - s4: mvnコマンドの実行
- s6: 疎通確認
- s7: コンテナイメージを作成する
- s8: コンテナイメージを実行する
- s9: データベースに関する設定を行う
- s10: 補足

### Java21で使用する場合のセットアップ方法
path: setup/blank-project/blank-project-setup-Java21.json
- s1: 標準エンコーディングの変更（標準エンコーディングをJava17以前と同じく実行環境依存にしたい場合）
- s2: Javaバージョンの変更

### Jakarta Batchに準拠したバッチプロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-Jbatch.json
- s1: 生成するプロジェクトの概要
- s2: ブランクプロジェクト作成
  - s3: mvnコマンドの実行
- s5: 疎通確認
  - s6: 自動テスト
  - s7: 起動テスト
  - s12: データベースに関する設定を行う
  - s13: 補足

### Nablarchバッチ（DB接続無し）プロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-NablarchBatch-Dbless.json
- s1: 生成するプロジェクトの概要
- s2: ブランクプロジェクト作成
  - s3: mvnコマンドの実行
  - s4: プロジェクト情報の入力
- s5: 疎通確認(都度起動バッチ)
  - s6: 自動テスト(都度起動バッチ)
  - s7: 起動テスト(都度起動バッチ)
- s10: 補足

### Nablarchバッチプロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-NablarchBatch.json
- s1: 生成するプロジェクトの概要
- s2: ブランクプロジェクト作成
  - s3: mvnコマンドの実行
  - s4: プロジェクト情報の入力
- s5: 疎通確認(都度起動バッチ)
  - s6: 自動テスト(都度起動バッチ)
  - s7: 起動テスト(都度起動バッチ)
- s10: 疎通確認(テーブルをキューとして使ったメッセージング)
  - s11: 起動テスト(テーブルをキューとして使ったメッセージング)
  - s14: 疎通確認になぜか失敗する場合
- s15: データベースに関する設定を行う
- s16: 補足

### ウェブプロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-Web.json
- s1: 生成するプロジェクトの概要
- s2: ブランクプロジェクト作成
  - s3: mvnコマンドの実行
  - s4: プロジェクト情報の入力
- s5: 疎通確認
  - s6: 自動テスト
  - s7: 起動確認
  - s8: 疎通確認になぜか失敗する場合
- s9: データベースに関する設定を行う
- s10: 補足（web.xml）
- s11: 補足

### RESTfulウェブサービスプロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-WebService.json
- s1: 事前準備
- s2: 生成するプロジェクトの概要
- s3: ブランクプロジェクト作成
  - s4: mvnコマンドの実行
- s6: 疎通確認
  - s7: 自動テスト
  - s8: 起動確認
  - s12: 疎通確認になぜか失敗する場合
- s13: データベースに関する設定を行う
- s14: 補足

## setup/cloud-native

### AWSにおける分散トレーシング
path: setup/cloud-native/cloud-native-aws-distributed-tracing.json
- s1: 依存関係の追加
- s2: 受信HTTPリクエスト
- s3: 送信HTTP呼び出し
- s4: SQLクエリ

### Azureにおける分散トレーシング
path: setup/cloud-native/cloud-native-azure-distributed-tracing.json
- s1: Azureで分散トレーシングを行う方法

### Nablarchクラウドネイティブ対応
path: setup/cloud-native/cloud-native-cloud-native.json

### Dockerコンテナ化
path: setup/cloud-native/cloud-native-containerize.json
- s1: クラウド環境に適したシステムに必要なこと
  - s2: クラウドネイティブ
  - s3: The Twelve-Factor App
- s4: Nablarchウェブアプリケーションに必要な修正
- s5: Nablarchバッチアプリケーションに必要な修正
- s6: コンテナ用のアーキタイプ

### 分散トレーシング
path: setup/cloud-native/cloud-native-distributed-tracing.json

## setup/configuration

### デフォルト設定一覧
path: setup/configuration/configuration-configuration.json

## setup/setting-guide

### 使用可能文字の追加手順
path: setup/setting-guide/setting-guide-CustomizeAvailableCharacters.json
- s1: 概要
- s2: 使用可能な文字集合定義
  - s3: 文字集合の包含関係
  - s4: 文字集合定義の所在
- s5: 設定方法
  - s6: メッセージIDを設定するだけで使用できる使用可能文字
  - s7: メッセージIDを指定するだけでは使用できない使用可能文字
  - s8: 単独で使用できない使用可能文字
- s9: メッセージIDを指定するだけでは使用できない使用可能文字の設定方法

### メッセージID及びメッセージ内容の変更手順
path: setup/setting-guide/setting-guide-CustomizeMessageIDAndMessage.json
- s1: 概要
- s2: エラー内容とメッセージIDの紐付けの変更方法
- s3: メッセージIDとメッセージの紐付けの変更方法

### Nablarchフレームワークが使用するテーブル名の変更手順
path: setup/setting-guide/setting-guide-CustomizeSystemTableName.json
- s1: 概要
- s2: 変更方法

### デフォルト設定値からの設定変更方法
path: setup/setting-guide/setting-guide-CustomizingConfigurations.json
- s1: 設定ファイルの構成
- s2: カスタマイズ方法
  - s3: カスタマイズのパターン
- s4: カスタマイズ作業手順
  - s5: 環境設定値の書き換え
  - s8: 環境設定値の上書き
  - s9: コンポーネント定義の上書き
  - s12: ハンドラ構成のカスタマイズ
- s13: 設定変更例

### 処理方式、環境に依存する設定の管理方法
path: setup/setting-guide/setting-guide-ManagingEnvironmentalConfiguration.json
- s1: 概要
- s2: アプリケーション設定の整理
  - s3: アプリケーション設定の整理
- s4: アプリケーション設定ファイル切り替えの前提と仕組み
  - s5: アプリケーション設定ファイル切り替えの前提
  - s6: アプリケーション設定切り替えの仕組み
- s9: 環境ごとにコンポーネントを切り替える方法(モックに切り替える方法)
  - s10: コンポーネント設定ファイル(xmlファイル)の作成方法
- s11: 環境ごとに環境設定値を切り替える方法
- s12: 定義されている環境を増やす方法
  - s13: プロファイルの定義
  - s14: ディレクトリの追加
  - s15: アプリケーション設定ファイルの作成及び修正

### 環境設定値の項目名ルール
path: setup/setting-guide/setting-guide-config-key-naming.json
- s1: 全般的なルール
- s2: 共通プレフィックス
- s3: 単一のコンポーネント内でのみ使用される設定項目
- s4: 複数のコンポーネント定義に跨る設定項目
- s5: DBテーブルのスキーマ情報

### Nablarchアプリケーションフレームワーク設定ガイド
path: setup/setting-guide/setting-guide-setting-guide.json
