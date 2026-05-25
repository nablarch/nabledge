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
  - s4: Java 11 以上で動かす場合
- s5: Exampleの一覧
  - s6: ウェブアプリケーション
  - s7: ウェブサービス
  - s8: バッチアプリケーション
  - s9: メッセージング

### Nablarch拡張コンポーネント
path: about/about-nablarch/about-nablarch-extension-components.json

### Nablarchでの開発に役立つコンテンツ
path: about/about-nablarch/about-nablarch-external-contents.json
- s1: Nablarchシステム開発ガイド
- s2: 開発標準

### 機能追加要望・改善要望
path: about/about-nablarch/about-nablarch-inquiry.json
- s1: JIRAへの課題起票方法

### Nablarchアプリケーションフレームワーク
path: about/about-nablarch/about-nablarch-ja-application-framework-index.json

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
- s3: Nablarchフレームワークの稼動実績

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
- s9: Java6に準拠している
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
- s3: Domaを使用してデータベースにアクセスする
  - s4: Daoインタフェースを作成する
  - s5: データベースアクセス処理を実装する
- s6: 別トランザクションで実行する
- s7: JSR352に準拠したバッチアプリケーションで使用する
- s8: JSR352に準拠したバッチアプリケーションで遅延ロードを行う
- s9: ETLで使用する
- s10: 複数のデータベースにアクセスする
- s11: DomaとNablarchのデータベースアクセスを併用する
- s12: ロガーを切り替える
- s13: java.sql.Statementに関する設定を行う

### JAX-RSアダプタ
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
- s6: JAX-RSのPathアノテーションでマッピングする
  - s7: ディスパッチハンドラを変更する
  - s8: マッピングの実装方法
  - s9: パスパラメータの定義
  - s10: ルーティング定義を一覧で確認する

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

### JAX-RS BeanValidationハンドラ
path: component/handlers/handlers-jaxrs-bean-validation-handler.json
- s4: リソース(アクション)で受け取るForm(Bean)に対してバリデーションを実行する
- s5: Bean Validationのグループを指定する

### JAX-RSレスポンスハンドラ
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

### ユニバーサルDAOとJSR317(JPA2.0)との機能比較
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
  - s2: [MOMメッセージング](../../component/libraries/libraries-mom-system-messaging.md#momメッセージング) と同じ作り方ができる
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

### JSPカスタムタグ
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
- s51: [タグリファレンス](../../component/libraries/libraries-tag-reference.md#タグリファレンス)

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
- s24: Entityに使用できるJPAアノテーション
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

### 本書の内容
path: development-tools/testing-framework/testing-framework-about-this-book.json

### 全体構造
path: development-tools/testing-framework/testing-framework-architecture-overview.json
- s1: 本番環境での外部ライブラリへの依存
- s2: サーバ動作時の構成
- s3: ローカル動作時の構成

### 本書の構成
path: development-tools/testing-framework/testing-framework-book-layout.json

### コンテンツ用表示領域ウィジェット
path: development-tools/testing-framework/testing-framework-box-content.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 画像表示ウィジェット
path: development-tools/testing-framework/testing-framework-box-img.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### タイトル用表示領域ウィジェット
path: development-tools/testing-framework/testing-framework-box-title.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### ボタン配置ブロック
path: development-tools/testing-framework/testing-framework-button-block.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### ボタンウィジェット
path: development-tools/testing-framework/testing-framework-button-submit.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### テーブル複数行選択用チェックボックスカラムウィジェット
path: development-tools/testing-framework/testing-framework-column-checkbox.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### コード値ラベル表示用カラムウィジェット
path: development-tools/testing-framework/testing-framework-column-code.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### ラベル表示用カラムウィジェット
path: development-tools/testing-framework/testing-framework-column-label.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### リンク表示用カラムウィジェット
path: development-tools/testing-framework/testing-framework-column-link.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### テーブル行選択用ラジオボタンカラムウィジェット
path: development-tools/testing-framework/testing-framework-column-radio.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### UI開発基盤設定ファイル
path: development-tools/testing-framework/testing-framework-configuration-files.json
- s1: タグ定義
- s2: 配置場所
- s3: 用途
- s4: 記述書式

### 業務画面JSPから画面項目定義を作成する
path: development-tools/testing-framework/testing-framework-create-screen-item-list.json

### 業務画面テンプレートとUI部品を使用して業務画面JSPを作成する
path: development-tools/testing-framework/testing-framework-create-with-widget.json
- s1: 画面のテンプレートを用意する
- s2: 画面をブラウザで表示する
- s3: UI部品（ウィジェット）を配置していく
- s4: ウィジェットに定義されている属性について
- s5: 画面遷移について
- s6: ウィジェットの作成について
- s7: 入力画面と確認画面の共用
- s8: 業務画面JSPの例
  - s9: 入力画面
  - s10: 確認画面
  - s11: 一覧・検索画面
  - s12: 詳細画面

### CSSフレームワーク
path: development-tools/testing-framework/testing-framework-css-framework.json
- s1: 概要
- s2: 表示モード切替え
- s3: ファイル構成
  - s4: 構成ファイル一覧
- s5: グリッドベースレイアウト
  - s6: グリッドレイアウトフレームワークの使用方法
- s7: アイコンの使用

### 統合開発環境を使用して業務画面JSPを作成する
path: development-tools/testing-framework/testing-framework-develop-environment.json
- s1: 統合開発環境の補完機能を使用する
- s2: 統合開発環境のドキュメント参照機能を使用する

### Nablarch開発ツール
path: development-tools/testing-framework/testing-framework-development-tools.json

### 標準プロジェクト構成
path: development-tools/testing-framework/testing-framework-directory-layout.json

### 二重サブミット防止機能のテスト実施方法
path: development-tools/testing-framework/testing-framework-double-transmission.json
- s1: リクエスト単体テストでの二重サブミット防止機能のテスト実施方法
- s2: 取引単体テストでの二重サブミット防止機能のテスト実施方法

### アラートダイアログ表示イベントアクション
path: development-tools/testing-framework/testing-framework-event-alert.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 確認ダイアログ表示イベントアクション
path: development-tools/testing-framework/testing-framework-event-confirm.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### サブウィンドウ内イベント定義
path: development-tools/testing-framework/testing-framework-event-listen-subwindow.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### ページ内イベント定義
path: development-tools/testing-framework/testing-framework-event-listen.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### XHRリクエスト送信イベントアクション
path: development-tools/testing-framework/testing-framework-event-send-request.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### disabled 項目切替えイベントアクション
path: development-tools/testing-framework/testing-framework-event-toggle-disabled.json

### 属性値の動的切替
path: development-tools/testing-framework/testing-framework-event-toggle-property.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### readonly 項目切替えイベントアクション
path: development-tools/testing-framework/testing-framework-event-toggle-readonly.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### ウィンドウクローズイベントアクション
path: development-tools/testing-framework/testing-framework-event-window-close.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 項目内容変更イベントアクション
path: development-tools/testing-framework/testing-framework-event-write-to.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 入力項目ウィジェット共通テンプレート
path: development-tools/testing-framework/testing-framework-field-base.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 入力フォームブロック
path: development-tools/testing-framework/testing-framework-field-block.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### カレンダー日付入力ウィジェット
path: development-tools/testing-framework/testing-framework-field-calendar.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### チェックボックス入力項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-checkbox.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### コード値チェックボックス入力項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-code-checkbox.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### コード値プルダウン入力項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-code-pulldown.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### コード値ラジオボタン入力項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-code-radio.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### ファイル選択ウィジェット
path: development-tools/testing-framework/testing-framework-field-file.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 入力内容注記表示ウィジェット
path: development-tools/testing-framework/testing-framework-field-hint.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 表示ブロックウィジェット
path: development-tools/testing-framework/testing-framework-field-label-block.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### コード値表示項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-label-code.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### ID:値セット項目表示ウィジェット
path: development-tools/testing-framework/testing-framework-field-label-id-value.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 表示項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-label.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### リストビルダー入力項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-listbuilder.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### パスワード入力ウィジェット
path: development-tools/testing-framework/testing-framework-field-password.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### プルダウン入力項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-pulldown.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### ラジオボタン入力項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-radio.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 単行テキスト入力項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-text.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 複数行テキスト入力項目ウィジェット
path: development-tools/testing-framework/testing-framework-field-textarea.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### リクエスト単体テストの実施方法(ファイルアップロード)
path: development-tools/testing-framework/testing-framework-fileupload.json
- s1: アップロードファイルの記述方法
- s2: バイナリファイルの場合
- s3: 固定長ファイル、CSVファイルの場合

### 設計指針
path: development-tools/testing-framework/testing-framework-grand-design.json
- s1: 業務画面JSPの記述
- s2: UI標準と共通部品

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

### 業務画面JSPローカル表示機能
path: development-tools/testing-framework/testing-framework-inbrowser-jsp-rendering.json
- s1: 概要
  - s2: ローカルJSPレンダリング機能の有効化
  - s3: 業務画面JSPを記述する際の制約事項
- s4: ローカル表示の仕組み
- s5: 構造
  - s6: 構成ファイル一覧

### UI開発基盤の導入
path: development-tools/testing-framework/testing-framework-initial-setup.json
- s1: 0. 事前準備
  - s2: 1. Node.jsのインストール
  - s3: 2. 環境変数 **JAVA_HOME** の設定
- s4: 1. プロジェクトの作成
  - s5: 1. プロジェクトルートの作成
  - s6: 2. UI開発基盤の取得
  - s7: 3. UI開発基盤用プロジェクトテンプレートの取得
  - s8: 4. ブランクプロジェクトのセットアップ
- s9: 2. Nablarch UI開発基盤のインストール
  - s10: 1. プラグインのセットアップ
  - s11: 2. プロジェクトで使用するプラグインの選定
  - s12: 3. プロジェクトへのプラグインインストール
  - s13: 4. UI部品のビルドと配置
  - s14: 5. UIローカルデモ用プロジェクトの動作確認
  - s15: 6. UI開発基盤テスト用プロジェクトの動作確認
  - s16: 7. 開発リポジトリへの登録

### Nablarch UI開発基盤の特徴
path: development-tools/testing-framework/testing-framework-intention.json
- s1: 画面設計工程における作業工数、仕様齟齬の発生リスクを極小化する
  - s2: 問題点
  - s3: アプローチ
  - s4: メリット
- s5: マルチブラウザ、マルチデバイス環境における開発・テストにかかる工数を抑制できる
  - s6: 問題点
  - s7: アプローチ
  - s8: メリット

### JavaScript UI部品
path: development-tools/testing-framework/testing-framework-js-framework.json
- s1: 概要
  - s2: 使用例
  - s3: 依存ライブラリ
- s4: 初期処理
  - s5: スクリプトロード時の挙動
  - s6: ドキュメントロード時の挙動
  - s7: UI部品の再初期化
- s8: ファイル構成
- s9: 新規 JavaScript UI部品の作成方法
  - s10: 作成するファイル
  - s11: ウィジェットの実装例

### 業務画面テンプレート
path: development-tools/testing-framework/testing-framework-jsp-page-templates.json
- s1: 概要
- s2: ファイル構成
  - s3: 概要
  - s4: 構成ファイル一覧
- s5: 業務画面テンプレートの詳細仕様
  - s6: 業務画面ベースレイアウト
  - s7: 業務画面標準テンプレート
  - s8: エラー画面テンプレート
- s9: ローカル動作時の挙動

### UI部品ウィジェット
path: development-tools/testing-framework/testing-framework-jsp-widgets.json
- s1: 概要
  - s2: ウィジェットの使用
  - s3: ウィジェットの分類
- s4: 構造
  - s5: タグファイル実装例
  - s6: 構成ファイル一覧
- s7: ローカル動作時の挙動

### 既知の問題
path: development-tools/testing-framework/testing-framework-known-issues.json

### リンクウィジェット
path: development-tools/testing-framework/testing-framework-link-submit.json
- s1: コードサンプル
- s2: 仕様

### リクエスト単体テストの実施方法(メール送信)
path: development-tools/testing-framework/testing-framework-mail.json
- s1: メール送信処理の構造とテスト範囲
- s2: テストの実施方法

### UI標準のカスタマイズとUI開発基盤への反映
path: development-tools/testing-framework/testing-framework-modifying-code-and-testing.json
- s1: UI標準のカスタマイズ
- s2: UI開発基盤の修正
  - s3: 1. 修正要件の確認
  - s4: 2. 修正箇所の特定
  - s5: 3. プラグインの追加
  - s6: 4. ビルドと修正確認
  - s7: 5. リポジトリへの反映

### マルチレイアウト用CSSフレームワーク
path: development-tools/testing-framework/testing-framework-multicol-css-framework.json
- s1: 概要
- s2: 制約事項
  - s3: 表示モードの切替機能は提供しない
  - s4: 一部UI部品ウィジェットは出力幅の指定機能を提供しない
- s5: マルチレイアウトモードの適用方法
- s6: レイアウトの調整方法
- s7: 使用例
  - s8: 1行に複数のUI部品を並べる場合
  - s9: 列によって異なる行数を定義する場合

### プラグインビルドコマンド仕様
path: development-tools/testing-framework/testing-framework-plugin-build.json
- s1: 概要
- s2: 想定されるプロジェクト構成ごとの設定例
  - s3: デプロイ対象プロジェクトが１つの場合
  - s4: デプロイ対象プロジェクト複数の場合(プラグインは共通)
  - s5: デプロイ対象プロジェクト複数の場合(プラグインも個別)
- s6: プラグインビルドで使用するコマンドや設定ファイルの詳細仕様
- s7: 設定ファイル
  - s8: ビルドコマンド用設定ファイル
  - s9: lessインポート定義ファイル
- s10: ファイルの自動生成
  - s11: CSSの自動生成
  - s12: JavaScriptの自動生成
- s13: プラグイン、外部ライブラリの展開
  - s14: プラグインの展開
  - s15: 外部ライブラリの展開
- s16: ビルドコマンド
  - s17: インストールコマンド
  - s18: UIビルドコマンド
  - s19: lessインポート定義雛形生成コマンド
  - s20: ローカル動作確認用サーバ起動コマンド
  - s21: サーバ動作確認用サーバ起動コマンド

### UIプラグイン
path: development-tools/testing-framework/testing-framework-plugins.json
- s1: UIプラグインの構造
- s2: UIプラグインのバージョンについて

### 業務画面JSP作成時のディレクトリ構造
path: development-tools/testing-framework/testing-framework-project-structure.json

### UI開発基盤の展開
path: development-tools/testing-framework/testing-framework-redistribution.json
- s1: 画面設計担当者向けワークスペースの取得
- s2: 開発担当者向けワークスペースの展開
- s3: UIデモ実行用アーカイブの作成
  - s4: 作成手順
  - s5: 確認手順

### JavaScript UI部品一覧
path: development-tools/testing-framework/testing-framework-reference-js-framework.json
- s1: UI部品
- s2: ユーティリティ

### 関連文書
path: development-tools/testing-framework/testing-framework-related-documents.json

### 設計書ビュー表示機能
path: development-tools/testing-framework/testing-framework-showing-specsheet-view.json
- s1: 概要
- s2: 使用方法
- s3: 関連ファイル

### 設計書作成者情報ウィジェット
path: development-tools/testing-framework/testing-framework-spec-author.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 画面表示パターン定義ウィジェット
path: development-tools/testing-framework/testing-framework-spec-condition.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 設計書作成日付情報ウィジェット
path: development-tools/testing-framework/testing-framework-spec-created-date.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 設計情報コメントウィジェット
path: development-tools/testing-framework/testing-framework-spec-desc.json
- s1: 仕様
- s2: 内部構造・改修時の留意点

### 画面レイアウト定義用ウィジェット
path: development-tools/testing-framework/testing-framework-spec-layout.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 設計書更新者情報ウィジェット
path: development-tools/testing-framework/testing-framework-spec-updated-by.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 設計書更新日付情報ウィジェット
path: development-tools/testing-framework/testing-framework-spec-updated-date.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 項目間・セマンティック精査仕様定義ウィジェット
path: development-tools/testing-framework/testing-framework-spec-validation.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### タブウィジェット
path: development-tools/testing-framework/testing-framework-tab-group.json
- s1: コードサンプル
- s2: 仕様

### 一覧テーブルウィジェット
path: development-tools/testing-framework/testing-framework-table-plain.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### マルチレイアウトテーブル
path: development-tools/testing-framework/testing-framework-table-row.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 検索結果テーブルウィジェット
path: development-tools/testing-framework/testing-framework-table-search-result.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### 階層(ツリー)表示テーブルウィジェット
path: development-tools/testing-framework/testing-framework-table-treelist.json
- s1: コードサンプル
- s2: 仕様
- s3: 内部構造・改修時の留意点

### UI部品の実装サンプルで提供しているEclipse補完テンプレート
path: development-tools/testing-framework/testing-framework-template-list.json
- s1: Eclipse補完テンプレートの導入方法
- s2: Eclipse補完テンプレートの一覧
  - s3: 入力・表示系ウィジェットのテンプレート
  - s4: テーブル系ウィジェットのテンプレート
  - s5: ボタン・リンク系ウィジェットのテンプレート
  - s6: タブ系ウィジェットのテンプレート
  - s7: 表示領域系ウィジェットのテンプレート
  - s8: 入力画面・確認画面切り替え用のテンプレート
  - s9: JSPファイルのテンプレート
  - s10: 設計情報用タグのテンプレート

### テスティングフレームワーク
path: development-tools/testing-framework/testing-framework-testing-framework.json

### 基盤部品のテスト実施項目
path: development-tools/testing-framework/testing-framework-testing.json
- s1: テスト方針
- s2: テスト実施環境
- s3: 実施テスト内容
  - s4: UI部品ウィジェット機能テスト
  - s5: UI部品ウィジェット性能テスト
  - s6: UI部品ウィジェット組み合わせテスト
  - s7: 結合テスト
  - s8: ローカル表示テスト
  - s9: 表示方向切替えテスト

### 
path: development-tools/testing-framework/testing-framework-ui-dev-doc-reference-jsp-widgets.json
- s1: UI部品ウィジェット一覧
- s2: 設計情報記述用ウィジェット一覧

### UIプラグイン一覧
path: development-tools/testing-framework/testing-framework-ui-dev-doc-reference-ui-plugin.json
- s1: サードパーティ製ライブラリ
- s2: CSS共通スタイルプラグイン
- s3: 表示モード切替用プラグイン
- s4: 特定端末向けパッチプラグイン
- s5: 開発用ツールプラグイン
- s6: 業務画面JSPローカル表示機能プラグイン
- s7: JavaScriptユーティリティプラグイン
- s8: UI部品ウィジェットプラグイン
- s9: UIイベント制御部品プラグイン
- s10: 業務画面テンプレートプラグイン

### UI標準修正事例一覧
path: development-tools/testing-framework/testing-framework-ui-dev-doc-reference-ui-standard.json
- s1: UI標準1.1. 対応する端末とブラウザ
  - s2: 対応ブラウザを追加したい
  - s3: どうしてもIE6/7はサポートできないのか?
  - s4: 表示モードを変更したい
- s5: UI標準1.2. 使用技術
  - s6: 使用するJavaScriptライブラリを追加したい
- s7: UI標準2. 画面構成
  - s8: 画面の配色を変更したい
  - s9: システムロゴ画像を差し替えたい
  - s10: ヘッダ領域の表示内容を修正したい
  - s11: サイドメニュー領域の表示内容を修正したい
  - s12: フッター領域の表示内容を修正したい
  - s13: 共通エラー・メッセージ表示領域の表示を調整したい
- s14: UI標準2.1. 端末の画面サイズと表示モード
  - s15: 表示モードの切替条件を変更したい
  - s16: 表示モードの切替えを無効化したい
- s17: UI標準2.2. ワイド表示モードの画面構成
  - s18: ワイドモードにおける画面内の要素のサイズを全体的に調整したい
  - s19: 特定の画面要素についてワイドモードでの表示を調整したい
- s20: UI標準2.3. コンパクト表示モードの画面構成
  - s21: コンパクトモードでの表示内容を調整したい
- s22: UI標準2.4. ナロー表示モードの画面構成
  - s23: ナローモードでの表示内容を調整したい
  - s24: テーブル表示で横スクロールが発生しないようにしたい
- s25: UI標準2.5.画面内の入出力項目に関する共通仕様
  - s26: ドメイン型に応じて入出力項目の表示を調整したい
  - s27: タブキーによるフォーカス移動順番を制御したい
  - s28: 入力内容の注記部分の表示を調整したい
  - s29: 必須入力項目の表示形式を変更したい
  - s30: 単項目精査エラーメッセージの表示を変更したい
  - s31: ナロー表示モードでのボタン表示順を変更したい
  - s32: 認可権限がない場合のボタン／リンクの表示方法を変更したい
- s33: UI標準2.6. WEB標準に準拠しないブラウザでの表示制約
  - s34: ブラウザ間の表示差異を極小化したい(IE8の表示に他のブラウザをあわせたい)
- s35: UI標準2.11. 共通エラー画面の構成
  - s36: 共通エラー画面の構成を変更したい
- s37: UI標準3. UI部品 (UI部品カタログ)
  - s38: UI部品の表示・挙動を修正したい
- s39: 開閉可能領域
  - s40: 精査エラー時の開閉可能領域の制御を変更したい

### Nablarch UI開発基盤 解説書
path: development-tools/testing-framework/testing-framework-ui-dev-doc.json

### JSP/HTML作成ガイド
path: development-tools/testing-framework/testing-framework-ui-dev-guide.json
- s1: 業務画面JSP作成フロー
- s2: 業務画面JSP作成に使用する開発環境
- s3: 業務画面JSPの作成方法
- s4: 画面項目定義一覧の作成方法

### フロントエンド上級者向けのUI開発基盤
path: development-tools/testing-framework/testing-framework-ui-dev.json

### UI開発ワークフロー
path: development-tools/testing-framework/testing-framework-ui-development-workflow.json
- s1: UI開発ワークフロー

### Nablarch 標準プラグインの更新
path: development-tools/testing-framework/testing-framework-update-bundle-plugin.json
- s1: 1. UI開発基盤の更新方針
- s2: 2. 作業時のディレクトリ構成
- s3: 3. 標準プラグインの更新
  - s4: 1. プラグインのセットアップ
  - s5: 2. 現在のプラグインのバージョンの確認
  - s6: 3. プラグインのマージ

### UI部品の実装サンプルで提供しているウィジェットの一覧
path: development-tools/testing-framework/testing-framework-widget-list.json

## development-tools/toolbox

### JSP静的解析ツール
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
  - s10: JSP静的解析ツールでチェックしたい対象の存在するプロジェクトのpom.xmlの確認
  - s11: JSP静的解析ツール設定ファイルの記述方法
  - s12: pom.xmlの修正の修正
  - s13: 実行方法
  - s14: 出力結果確認方法

### JSP静的解析ツール 設定変更ガイド
path: development-tools/toolbox/toolbox-02-JspStaticAnalysisInstall.json
- s1: 前提条件
- s2: 設定ファイル構成
- s3: pom.xmlの書き換え

### JSP静的解析ツール
path: development-tools/toolbox/toolbox-JspStaticAnalysis.json

### 業務画面JSP検証ツール
path: development-tools/toolbox/toolbox-JspVerifier.json
- s1: 概要
- s2: 初期環境構築
  - s3: Node.jsのインストール
  - s4: 環境変数の確認
  - s5: 依存パッケージのインストール
  - s6: 正常に使用できることの確認
  - s7: 環境依存設定値の修正
- s8: ツールの使用方法
  - s9: batファイルでの実行
  - s10: コマンドラインからの実行
- s11: 設定方法
  - s12: 既定の設定内容

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

## extension/etl

### ETL Mavenプラグイン
path: extension/etl/etl-etl-maven-plugin.json
- s2: 使用方法
  - s3: コントロールファイルを生成するための設定
  - s4: コントロールファイルを生成する
  - s5: コンパイル時に自動的にコントロールファイルを生成する

### ETL
path: extension/etl/etl-etl.json
- s2: ETLの各フェーズの仕様
  - s3: Extractフェーズ
  - s4: Transformフェーズ
  - s5: Loadフェーズ
- s6: ETLを使用するバッチの設計ポイント
  - s7: ファイル取り込み処理
  - s8: ファイル出力処理
- s9: 使用方法
  - s10: ETL JOBを実行するための設定
  - s11: ETL用環境設定ファイルを作成する
  - s12: JOB定義ファイルとETL用JOB設定ファイルを作成する
  - s13: テーブルクリーニングステップを利用してテーブルのデータを削除する
  - s14: Extractフェーズ(Chunk)を使用する
  - s15: Extractフェーズ(SQL*Loader版)を使用する
  - s16: Transformフェーズでバリデーションを行う
  - s17: Loadフェーズでファイルにデータを出力する
  - s18: Loadフェーズでデータベースのデータの洗い替えを行う
  - s19: Loadフェーズでデータベースのデータのマージを行う
  - s20: Loadフェーズでデータベースへ登録する
  - s21: ETLが使用するメッセージを定義する
- s22: 拡張例
  - s23: ETL用JOB設定ファイルを配置するディレクトリのパスを変更する

## extension/report

### 帳票ライブラリ
path: extension/report/report-report.json
- s1: 概要
- s2: 要求
  - s3: 実装済み
  - s4: 未実装
  - s5: 取り下げ
- s6: 構造
  - s7: クラス図
  - s8: インターフェース定義
  - s9: クラス定義
- s10: 実装例
  - s11: 帳票テンプレートのコンパイル
  - s12: 帳票テンプレートの配置
  - s14: 帳票テンプレートの言語指定
  - s15: 帳票テンプレートのコンパイルAntタスク

## extension/workflow

### ワークフローライブラリ
path: extension/workflow/workflow-doc.json
- s1: 機能概要
  - s2: ワークフローが実現できる
  - s3: ステートマシンが実現できる
- s5: 使用方法
  - s6: ワークフロー(ステートマシン)の定義及び進行に必要なテーブルの作成と設定
  - s7: ワークフローやステートマシンを定義する
  - s8: ワークフロー(ステートマシン)を開始する
  - s9: ワークフローのタスクに担当者やグループを割り当てる
  - s10: ワークフローのタスクに担当者やグループを複数割り当てる
  - s11: ワークフローの状態を遷移(タスクを完了)させる
  - s12: アプリケーションでの処理結果に応じて遷移先のタスクを変更する
  - s13: ワークフローの状態を元の状態に戻す（差し戻し）
  - s14: ワークフローの申請を再度行う（再申請）
  - s15: ワークフロー申請の取り消しを行う
  - s16: ワークフロー申請を却下する
  - s17: ワークフロー申請の引き戻しを行う
  - s18: ステートマシンの状態を遷移させる
  - s19: ステートマシンでサブプロセスを定義する
  - s20: ワークフロー（ステートマシン）の現在の状態を取得する
  - s21: ワークフロー（ステートマシン）の定義を変更する
- s22: XORゲートウェイの進行先ノードの判定方法
- s23: マルチインスタンスの完了条件の判定方法

### ワークフロー定義データ生成ツール
path: extension/workflow/workflow-tool.json
- s2: 使用方法
  - s3: プラグインに対する設定
  - s4: プラグインを実行する
  - s5: バリデーション内容
  - s6: Java11で使用する場合の設定

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
- s4: 提供パッケージ
- s5: 機能
  - s6: 実装済み
  - s7: 前提としている仕様
- s8: 構成
  - s9: クラス図
- s13: 使用方法
  - s14: FileManagementUtilの使用方法

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
- s1: 提供パッケージ
- s2: 概要
  - s3: 本サンプルで取り扱う範囲
- s4: 使用方法
  - s5: 依存ライブラリの追加
  - s6: log.propertiesの設定
  - s7: Logbookの構成
  - s8: JAX-RSクライアントにLogbookを登録
  - s9: リクエスト/レスポンスのログを出力

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

### JSR352に準拠したバッチアプリケーション
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

### JSR352に準拠したバッチアプリケーションの悲観的ロック
path: processing-pattern/jakarta-batch/jakarta-batch-pessimistic-lock.json

### 進捗状況のログ出力
path: processing-pattern/jakarta-batch/jakarta-batch-progress-log.json
- s1: 進捗ログで出力される内容
- s2: 進捗ログを専用のログファイルに出力するための設定を追加する
- s3: Batchletステップで進捗ログを出力する
- s4: Chunkステップで進捗ログを出力する

### JSR352バッチアプリケーションの起動
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

### JSRに準拠したバッチアプリケーションとNablarchバッチアプリケーションとの機能比較
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
  - s4: 標準ハンドラ構成

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

### JAX-RSサポート/JSR339/HTTPメッセージングの機能比較
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

### FreeMarkerを使用した画面開発
path: processing-pattern/web-application/web-application-freemarker.json
- s1: FreeMarkerを依存ライブラリに追加する
- s2: FreeMarkerServletの設定を行う
- s3: テンプレートファイル(ftlファイル)を作成しActionを実装する
- s4: 2重サブミットを防止する

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

### ■Nablarch 5 リリースノート
path: releases/releases/releases-nablarch5-releasenote-5.json
- s1: エンジニアリング基盤
- s2: アプリケーション実行環境
- s3: SqlRowのNumber型対応（getInteger／getLong／getBigDecimal）
- s4: SQLクエリ結果のキャッシュ
- s5: DatabaseMetaDataアクセス用のAPI追加
- s6: TooManyResultExceptionのアクセス修飾子変更
- s7: RDBMS間での差異を吸収するデータベース方言(Dialect)機能を追加
- s8: ストアド・プロシージャ実行機能を追加
- s9: ParameterizedSqlPStatementに使用可能なメソッドを追加
- s10: データベースアクセスで使用するStatementのリソース解放処理の改善
- s11: SQLクエリ結果のキャッシュ機能を使用した場合、例外が発生する可能性がある不具合に対応
- s12: データベースコネクション名が重複している場合に、データベース接続が開放されない不具合に対応
- s13: シーケンスを使用した採番機能を追加
- s14: Entityを使ってデータベースアクセスを行う機能を追加
- s15: ValidationUtilの拡張
- s16: ドメインを指定してバリデーションを行う機能を追加
- s17: 定型的な精査処理の実装を簡略化することができるアノテーションを追加
- s18: フォームに@PropertyNameが付けられていない場合に発生する警告を削除。
- s19: @Digits が付いた項目に"+"だけを入力すると、NumberFormatExceptionが発生する不具合に対応
- s20: 保存先を切り替え可能なセッションストア機能を追加
- s21: n:buttonタグ、n:popupButtonタグでdisplayMethodにNODISPLAYを指定した場合、終了タグのみが出力されてしまう不具合を修正。
- s22: Nablarchのカスタムタグを用いてGETリクエストを使用できるよう機能を変更
- s23: HttpSessionがinvalidateされた場合に、カスタムタグで例外が発生する可能性がある不具合に対応
- s24: メールヘッダ・インジェクション攻撃への対策（保険的対策）
- s25: JavaBeans操作用ユーティリティを追加
- s26: XMLのデータを読み込む際にルート要素が欠落すると例外が発生する不具合に対応
- s27: JSON形式データのパースにおける不具合の対応
- s28: リクエストパスとリクエストIDのマッピングを変更
- s29: UserAgent情報取得用に拡張ポイントの追加
- s30: リダイレクト時のクエリストリング指定の追加
- s31: HttpSessionの不要な生成処理を改善
- s32: HttpCookieの属性を追加
- s33: URLに「$」を含むとHTTPリライト機能で例外が発生する不具合に対応
- s34: IE11を使用して日本語のファイル名をダウンロードするとファイル名が化ける問題に対応
- s35: HTTPレスポンスハンドラで行っていたHTTPレスポンスコードの付け替え仕様の変更
- s36: ステータスコード毎のデフォルト遷移先の設定にてServlet標準の仕組みを使えるよう変更
- s37: SessionConcurrentAccessHandlerとサーバーサイドの2重サブミット制御を併用すると2重サブミット制御が機能しない可能性がある不具合に対応
- s38: 常駐バッチの機能改善
- s39: レジューム機能の性能改善
- s40: DBを入力とするバッチをマルチスレッドで実行した場合、スレッド内で無限ループが発生する可能性がある不具合に対応
- s41: バッチアクションの終了処理で例外が発生した場合、メイン処理で発生した例外を消失する可能性がある不具合に対応
- s42: 常駐バッチにて出力ファイル開放ハンドラがファイルを閉じない可能性がある不具合に対応
- s43: HTTPメッセージング実行制御基盤の電文ログ出力処理の追加
- s44: HTTPメッセージング実行制御基盤にて業務トランザクションをロールバックした際に例外処理が呼び出されない不具合の対応
- s45: HTTPメッセージング実行制御基盤にてエラー応答電文が返却されない不具合の対応
- s46: HTTPメッセージング送信処理の応答電文読込時の不具合の対応
- s47: HTTPメッセージングの応答電文のリクエストIDにリクエストパスが設定される不具合の対応
- s48: メッセージング実行制御基盤のXMLパース性能の改善
- s49: HTTPメッセージング実行制御基盤のDoS攻撃対策
- s50: XML,JSON形式データのパースにおける不具合の対応
- s51: HTTPメッセージング実行制御基盤にて再送制御ハンドラを利用できない不具合の対応
- s52: HTTPメッセージング実行制御基盤にて応答電文作成時にフォーマットエラーが発生した際に業務処理がロールバックされない不具合の対応
- s53: 画面オンライン実行基盤やHTTPメッセージ実行基盤にて、HTTPレスポンスの送信方法を変更可能な設定を追加
- s54: クリックジャッキング攻撃への対策
- s55: ホットデプロイ機能を追加
- s56: レスポンスに対する文字エンコーディングの設定有無を指定できる設定項目をHTTP文字エンコード制御ハンドラに追加
- s57: FailureLogUtil#logWarnメソッドをアーキテクト向けに公開
- s58: XMLファイルの循環参照を検出するよう改善
- s59: ログメッセージのスペルミスを修正
- s60: jarファイルの分割提供
- s61: XML,JSON形式データのノード名に関する制約事項の明記による改善
- s62: ファイルダウンロード機能における設定項目の最小値明記による改善
- s63: システム間メッセージング機能
- s64: 公開APIの追加
- s65: Javadoc記載不備の対応
- s66: リトライ制御ハンドラの設定項目を追記
- s67: セッション並行アクセスハンドラを非推奨に変更
- s68: POST再送信防止ハンドラを非推奨に変更
- s69: アプリケーション開発環境
- s70: Mavenを使用した環境構築手順への変更
- s71: 最新の開発環境への変更
- s72: デフォルト設定の追加
- s73: Maven アーキタイプの提供
- s74: 開発環境パッケージの提供終了
- s75: 開発環境パッケージの提供終了
- s76: UI 開発基盤のカスタマイズ性の向上
- s77: Windows 7/IE11をサポートブラウザに追加
- s78: マルチフィールドレイアウト機能の追加
- s79: codeName属性の削除
- s80: 精査エラー時に開閉可能領域の開閉状態が誤って判定される不具合の対応
- s81: IE8,9で20件程度の画像ウィジェットを指定すると、後半の画像が表示されないことに対する改善
- s82: Nablarch標準プラグインの更新手順を追加
- s83: スライドするメニューサンプルの追加
- s84: 確認ダイアログ表示イベントアクションのディバイス依存不具合に対応
- s85: UI開発基盤の導入手順外のパターンへの対応
- s86: サブウィンドウ内イベント連携機能にクロスドメイン対応の追加
- s87: 解説書への追記
- s88: タグファイルで設定する変数のスコープを修正
- s89: event:confirmタグの不要な属性を削除
- s90: UIプラグイン一覧に記載が漏れていたプラグインを追記
- s91: CAPTCHA機能のサンプル実装の追加
- s92: UserAgent情報取得機能のサンプル実装の追加
- s93: HTMLメールを送信する機能のサンプル実装の追加
- s94: データベース方言(Dialect)機能の追加に伴い削除
- s95: メッセージング基盤テストシミュレータのサンプル実装の追加
- s96: モバイルライブラリの新規追加
- s97: JasperReportsを利用したPDF帳票出力機能を追加
- s98: テストデータでの改行コード記述機能追加
- s99: テストデータ記載時に、全てのカラムが空文字となるテストデータを作成すると、当該レコードが無視されてしまう不具合の対応
- s100: テストショットが複数含まれるテストシートにて、固定長/可変長のテストデータに空行を使用できない不具合の対応
- s101: HTTPメッセージング同期送信時の例外をアプリケーションで判定する場合の自動テスト対応
- s102: 画面オンライン処理のリクエスト単体テスト実行時のエラーメッセージの改善
- s103: assertEntityメソッドのエラーメッセージの改善
- s104: 常駐バッチの機能改善に伴うリクエスト単体テスト用のハンドラを追加
- s105: アプリケーションフレームワークのデータベース方言(Dialect)機能の追加に合わせて、データベーススキーマの設定値を追加
- s106: warディレクトリを複数指定してリクエスト単体できるよう設定値を追加
- s107: 外部キーが設定されたテーブルを使用できるよう改善
- s108: 使用不許可APIがチェックされない不具合に対応
- s109: 可変長データ形式の場合の必須入力項目チェックの改善
- s110: 仕様の記述不備の対応
- s111: ファイル転送処理方式サンプルを追加
- s112: SQL文を対話的に実行するツールを追加
- s113: ドメイン定義書自動生成ツールを追加
- s114: 環境設定ファイル自動生成ツールが作成するxmlファイルから読み込むファイルを自動生成したファイルのみにするよう修正
- s115: アプリケーション開発標準/ガイド
- s116: Objective-Cコーディング規約策定
- s117: UI標準に認可と開閉局に関する記載を追記
- s118: UI標準内の文言修正
- s119: 新機能導入に関連した設計標準の更改
- s120: メニュー領域の変更
- s121: Arrays.toArrayメソッドの不適切な使用例を修正
- s122: 業務コンポーネント責務配置ドキュメント追加
- s123: 常駐バッチの機能改善に伴うチュートリアルの変更
- s124: 二重サブミット防止機能のテスト方法を追記
- s125: 入力データを使用しないバッチ処理の実装方法を追記
- s126: チュートリアルのリクエスト単体テストで テスト前処理を実装しても起動されない不具合に対応
- s127: メニュー領域の変更

### 分類
path: releases/releases/releases-nablarch5-releasenote-分類.json

### ■データベースアクセス機能の変更内容
path: releases/releases/releases-nablarch5-releasenote-別紙_データベースアクセス機能の変更内容.json
- s1: 設定追加
- s2: 設定削除
- s3: 3
- s4: 4
- s5: 5
- s6: アーキテクト向け公開APIのインタフェース変更 ※データベースアクセス機能を拡張していない場合は対応不要です。

### 別紙_分割後jarの取り込み
path: releases/releases/releases-nablarch5-releasenote-別紙_分割後jarの取り込み.json

### ■UI開発基盤（標準プラグイン）の変更履歴
path: releases/releases/releases-nablarch5-releasenote-別紙_標準プラグインの変更履歴.json
- s1: スライドするメニューサンプルの追加
- s2: サンプルを追加しました。
- s3: nablarch-dev-ui_test-support
- s4: メニューのテストに伴い、ナビ配下にあるlogo画像を追加しました。
- s5: nablarch-device-fix-android_browser
- s6: スクロールしないようにするパッチを追加しました。
- s7: ※詳細は、既知の問題#9352を参照してください。
- s8: 確認ダイアログ表示イベントアクションの
- s9: ディバイス依存不具合に対応
- s10: 特定のディバイス（iPad,iPhone）でトップナビやフッタが
- s11: 非表示となる不具合に対応しました。
- s12: nablarch-widget-event-autosum
- s13: サブウィンドウ内イベント連携機能の
- s14: イベント監視対象の変更
- s15: セキュリティの制約に起因したJavaScriptエラーが発生します。
- s16: JavaScriptエラーが発生すると、サブウィンドウ連携機能以外の
- s17: JavaScriptも動作しなくなってしまうため、エラーが発生しないように
- s18: 対応しました。
- s19: UI開発基盤の導入手順外の
- s20: パターンへの対応
- s21: (Subversion等)に追加済みの場合にもビルドが
- s22: 実行できるように対応しました。
- s23: Nablarch標準プラグインの更新手順を
- s24: 追加
- s25: タグファイルで設定する変数のスコープを修正
- s26: 設定していたため、JSP内で利用するウィジェットの組合せにより、
- s27: 意図しない挙動(表示)をする可能性がありました。
- s28: nablarch-widget-column-checkbox
- s29: 例：「ラベル表示用カラムウィジェット」に「表示項目ウィジェット」の
- s30: 内容が出力されてしまう。
- s31: nablarch-widget-column-link
- s32: 上記の事象を解消するためにタグファイル内で設定する変数の
- s33: スコープをページスコープに修正しました。
- s34: nablarch-widget-event-toggle
- s35: nablarch-widget-field-base
- s36: nablarch-widget-field-block
- s37: nablarch-widget-field-calendar
- s38: nablarch-widget-field-checkbox
- s39: nablarch-widget-field-hint
- s40: nablarch-widget-field-label
- s41: nablarch-widget-field-label_id_value
- s42: nablarch-widget-field-listbuilder
- s43: nablarch-widget-field-pulldown
- s44: nablarch-widget-field-radio
- s45: nablarch-widget-field-text
- s46: nablarch-widget-tab
- s47: nablarch-widget-table-plain
- s48: nablarch-widget-table-search_result
- s49: event:confirmタグ内のattributeの
- s50: type属性を削除
- s51: JSPを実行時に実行時エラーが発生していました。
- s52: 不要なtype属性を削除しました。

### ■Nablarch 5u1 リリースノート
path: releases/releases/releases-nablarch5u1-releasenote-5u1.json
- s1: エンジニアリング基盤
- s2: アプリケーション実行環境
- s3: Cookieの設定と取得に関する不具合に対応
- s4: HiddenStoreに保存した値を削除できない不具合に対応
- s5: インターセプタの実行順を指定する方法がない不具合に対応
- s6: JSPからセッションストアの値を参照できない不具合に対応
- s7: HiddenStoreを使用してinvalidate後に値を保存できない不具合に対応
- s8: SessionStoreHandlerでセッションIDが改竄された場合にシステムエラーとなる問題に対応
- s9: HttpResponseHandlerがリダイレクト時にHTTPヘッダを設定していない問題に対応
- s10: アプリケーション開発環境
- s11: 制約の追加
- s12: テスト時にしか使用しないAPIの移動

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u1-releasenote-バージョンアップ手順.json

### 分類
path: releases/releases/releases-nablarch5u1-releasenote-分類.json

### ■テスト用APIの移動内容
path: releases/releases/releases-nablarch5u1-releasenote-別紙_テスト用APIの移動内容.json
- s1: HttpRequest
- s2: HttpCookie

### ■Nablarch 5u10 リリースノート
path: releases/releases/releases-nablarch5u10-releasenote-5u10.json
- s2: BeanUtilでコピー先のプロパティが存在しない場合にデバッグログにスタックトレースを出力しないように修正
- s3: BeanUtilでListや配列をコピーできない問題に対応
- s4: BeanUtilでコピー時にTimestampの精度が落ちていた問題に対応
- s5: セッションストアのエンコードで不要な暗号化が行われる問題に対応
- s6: タグライブラリ用の日付フォーマッタに年月のフォーマッタを追加
- s7: リソースクラス(アクションクラス)のメソッドにInterceptorが設定できない問題に対応
- s8: 無効なプロパティへの設定があった場合ワーニングログを出力するよう変更
- s9: FileDataReaderのJavadocに説明を追記
- s10: JSR352のバッチアプリケーションで、特定のステップでリスナーを指定できるよう機能追加
- s11: プロセス起動直後の処理で例外が発生した場合に障害通知ログが出力されない問題に対応
- s12: タイムアウト時に出力するログメッセージを改善
- s13: フィールドタイプの追加を容易に行えるように修正
- s14: BeanValidation用アノテーションの対象を統一
- s15: 公開APIを追加
- s16: HIDDENストアの暗号化の鍵設定が暗号の強度を下げていた問題に対応
- s17: PostgreSQL使用時にdb-storeの保存で発生する一意制約違反問題に対応
- s18: n:formタグで例外が発生する問題に対応
- s19: ResourceLocatorに指定可能なclasspathスキームの注意点を追記
- s20: アプリケーションで入出力値のチェックをすることを追記
- s21: CSV読み込み時のクォート文字の扱いを追記
- s22: hidden暗号化とsession="false"に関する注意点を追記
- s23: 入力画面と確認画面を共通化するに対象のタグを追記
- s24: decimalフォーマットの注意点を追記
- s25: 悲観的ロックの実装例を追記
- s26: データベースアクセス時に値の自動設定ができないことを明記
- s27: エラー発生時のレスポンス生成処理の拡張例を追記
- s28: ETagやIf-Matchを使用した楽観的ロックには対応していないことを追記
- s29: hidden暗号化を使用する場合の制約を追記
- s30: サブスレッドでの例外発生時の振る舞いを追記
- s31: ログの初期化メッセージを出力しないようにする拡張例を追記
- s32: 自動インジェクションに関する説明を追記
- s33: nablarch.customTagConfig.displayMethodの設定値を変更
- s34: ブランクプロジェクトのビルド時に依存ライブラリをコピーするコマンドを修正
- s35: ブランクプロジェクトのビルド手順を修正
- s36: アダプタ
- s37: Domaアダプタを追加
- s38: テストで使用したOSSなどのバージョンを明記
- s39: Example
- s40: スタンドアロン型アプリケーションの実行方法を修正
- s41: 通知メッセージの表示でn:errorsタグを使用しないように修正
- s42: UI開発基盤 ※既にUI開発基盤を導入済みのPJにおいては、左記の変更内容の取込をプラグイン単位で実施します。変更内容とプラグインの対応については、 「標準プラグインの変更点」シートを参照ください。
- s43: ポップアップ機能と併用した場合の不具合に対応
- s44: 画像表示ウィジェットをコンパクトモードで表示した際に画像が消えてしまう不具合に対応
- s45: UIビルドコマンドの実行時に生成されるリソースに不要な文字列が出力されることがある不具合を修正
- s46: 生成するCSSをminifyするように修正
- s47: プロダクション環境にリリースされるJSPの配置場所をWEB-INF配下に変更
- s48: resultSetName属性を指定せずにresultNumName属性を指定できない不具合に対応
- s49: 画面モック起動時にthead, tbody, tfootタグがHTMLに表示されない不具合に対応
- s50: 動作確認用アプリケーションのハンドラ構成を最新化
- s51: ローカルJSPレンダリング機能でのタグの組み合わせによる制限事項を追記
- s52: ローカルJSPレンダリング機能でのイベント関連の制約を追加
- s53: テスティングフレームワーク
- s54: MockMessagingClientで出力されるログが文字化けされる不具合に対応
- s55: DbAccessTestSupportの一部メソッドをpublicに変更
- s56: マスタデータ復旧機能で、変更されていないテーブルを復旧対象としてしまう不具合を修正
- s57: リクエスト単体テスト時にシート名の指定を任意に変更
- s58: テストデータで複数のデータタイプまたはグループを使用する場合の注意事項を追加
- s59: 外部キーを持つテーブルへのデータセットアップに関する説明が不足していたため追加
- s60: ツールボックス
- s61: SQL Executorの制約を追記
- s62: Nablarch実装例集
- s63: 認証エラー時のCAPTCHA機能の再取得例を追記
- s64: Nablarch開発標準
- s65: シェル内でタイムスタンプのフォーマットが統一されていない箇所がある
- s66: JVMのオプションが改行を使って複数記述されている場合に、スペースが入らない不具合に対応
- s67: ドメイン定義書出力の改善
- s68: ツールが正常に動作しない
- s69: Object Browser ER v9.0.0対応

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u10-releasenote-バージョンアップ手順.json

### ■UI開発基盤（標準プラグイン）の変更点
path: releases/releases/releases-nablarch5u10-releasenote-標準プラグインの変更点.json
- s1: ポップアップ機能と併用した場合の不具合に対応
- s2: 画像表示ウィジェットをコンパクトモードで表示した際に画像が消えてしまう不具合に対応
- s3: UIビルドコマンドの実行時に生成されるリソースに不要な文字列が出力されることがある不具合を修正
- s4: 生成するCSSをminifyするように修正
- s5: プロダクション環境にリリースされるJSPの配置場所をWEB-INF配下に変更
- s6: resultSetName属性を指定せずにresultNumName属性を指定できない不具合に対応
- s7: 画面モック起動時にthead, tbody, tfootタグがHTMLに表示されない不具合に対応
- s8: 動作確認用アプリケーションのハンドラ構成を最新化

### ■Nablarch 5u11 リリースノート
path: releases/releases/releases-nablarch5u11-releasenote-5u11.json
- s2: HttpSessionのinvalidate時に発生する例外の扱いを見直し
- s3: 公開APIを追加
- s4: リダイレクト時にステータスコードが必ず302になる不具合を修正
- s5: 100系のステータスコードの扱いを修正
- s6: batch-eeのChunkが特定のDBで利用できない問題を修正
- s7: 進捗ログに出力する内容を変更
- s8: 各リスナからContextを取得できるように変更
- s9: 公開APIを追加
- s10: JSR352バッチ起動時にproperteisを指定できるように変更
- s11: HttpCharacterEncodingHandlerでファイルアップロード時のヘッダーの解析処理を修正
- s12: メール送信要求時のトランザクションを分離できる機能を追加
- s13: 固定長データの入出力機能を追加
- s14: content-typeの大文字・小文字を区別していた不具合を修正
- s15: CSVデータとMapとの変換時にヘッダが必須となっていた制約を削除
- s16: Dialectが使用する型変換を設定で差し替えできるよう変更
- s17: ウェブアプリケーションで使用するハンドラの記載漏れを修正
- s18: ジョブ、ステップの一時領域の注意点を追記
- s19: 進捗ログの開始ポイントについての注意点を追記
- s20: エラー発生時の仕組みについて追記
- s21: prettyPrintは利便性が低く設定の誤りの原因となる可能性が高いため非推奨に変更
- s22: 静的コンテンツのバージョン管理の仕組みを非推奨に変更
- s23: アダプタ
- s24: JSR310アダプタを追加
- s25: domaとNablarchのデータベースアクセス機能を併用できる機能を追加
- s26: Example
- s27: 固定長データの入出力機能のExample
- s28: ETL基盤
- s29: 進捗ログの改善を実施
- s30: SQL*Loader用の設定方法を変更
- s31: 解説書の記載内容を全面的に見直し
- s32: ワークフローライブラリ
- s33: BPMNからステートマシン定義を出力する機能を追加
- s34: Mavenプラグインに変更
- s35: ステートマシン機能を追加
- s36: ワークフロー設計ガイドを削除
- s37: Nablarch5対応を実施
- s38: UI開発基盤
- s39: Nablarch5に対応していないことを明記
- s40: テスティングフレームワーク
- s41: リクエスト単体テストで、リダイレクト時のステータスコードが正しくアサートされない不具合を修正
- s42: テストデータとして記述できる型の制約を追記
- s43: Nablarch開発標準
- s44: F-FMT-e05のコード例の誤りを修正

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u11-releasenote-バージョンアップ手順.json

### ■Nablarch 5u12 リリースノート
path: releases/releases/releases-nablarch5u12-releasenote-5u12.json
- s2: String配列に対するバリデーションで実行時例外が発生する可能性がある問題に対応
- s3: NumberRangeが少数有りの場合(小数部桁数が大きい場合)にバリデーションが正しく行えない問題に対応
- s4: カラムの型がCLOBの場合に登録(更新)や取得が行えない問題に対応
- s5: XML作成処理の性能改善
- s6: JMSヘッダに値が設定されない問題に対応
- s7: 送信時のデフォルトContent-Typeを修正
- s8: 5u6で変更となったメッセージフォーマット機能に5u5以前と同じ仕様のフォーマッタを追加
- s9: ユニバーサルDAO及びJDBCラッパーの型変換方法を一貫性がある仕様に修正
- s10: フレームワーク専用APIであることをJavadocに追記
- s11: 「コンポーネント設定ファイル」の表記ゆれを修正
- s12: 「HTTPメッセージング」ライブラリを推奨しない機能に変更
- s13: 「HTTPメッセージング」を推奨できない理由に追記
- s14: トランザクション設定例の記載誤りを修正
- s15: コンポーネントのインスタンス生成単位やライフサイクルを追記
- s16: ユニバーサルDAOの別トランザクション機能の制約を明記
- s17: コンポーネントの上書きはBeanのみ(mapやlistは対象外)であることを明記
- s18: Temporalアノテーションが使用可能となっていましたが使用していないため記述を削除
- s19: JSR352バッチと通常のNablarchとのアーキテクチャ相違点を追記
- s20: BeanUtilの章を汎用ユーティリティから分離
- s21: ブランクプロジェクトの稼働確認用ソースコードのコンパイルエラーに対応
- s22: アダプタ
- s23: 対応している型を明記
- s24: Example
- s25: プロジェクト一覧のソートプルダウンと実際のソート結果が一致するように変更
- s26: コンテキストパス指定時に顧客検索が動作するように変更
- s27: ProjectUpdateFormのsetterを適切な実装に変更
- s28: ETL基盤
- s29: nablarch-etlの最新バージョンに対応
- s30: テスティングフレームワーク
- s31: セルへの特殊な記述方法での半角記号の扱いを見直し
- s32: gsp-dba-maven-pluginの使用を推奨に変更
- s33: NTFでデフォルトで提供する「タイプ識別子とデータ型」の対応を解説書に記載
- s34: NTF(HTTP同期応答メッセージ送信)で複数メッセージ(複数リクエストID)を送信する場合のテストデータの書き方を解説書に追記
- s35: Nablarch開発標準
- s36: select *禁止規約の内容を変更

### ■NumberRangeの対応方法
path: releases/releases/releases-nablarch5u12-releasenote-NumberRangeの対応方法.json

### データベースアクセスの型変換機能削除の対応方法
path: releases/releases/releases-nablarch5u12-releasenote-データベースアクセスの型変換機能削除の対応方法.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u12-releasenote-バージョンアップ手順.json

### ■Nablarch 5u13 リリースノート
path: releases/releases/releases-nablarch5u13-releasenote-5u13.json
- s2: セキュアハンドラにContent-Security-Policyレスポンスヘッダを設定できる機能を追加
- s3: バリデーションエラー時にリクエストスコープから入力値を参照できるように変更
- s4: 任意のスキームを含むURIへリダイレクトできるように変更
- s5: Content-Dispositionにfilename*パラメーターを出力するように変更
- s6: 二重サブミット防止機能をJSP以外でも使えるように変更
- s7: バリデーションエラーのメッセージをJSPのカスタムタグ以外でも扱えるように変更
- s8: BeanUtilによるコピー処理で日付と数値のフォーマットパターンを設定できるように変更
- s9: サロゲートペアを使用できない問題に対応
- s10: サロゲートペアを使用できない問題に対応
- s11: スタンドアローンのアプリケーションでセッションストアが使用できてしまう問題に対応
- s12: DIコンテナでstaticなプロパティにインジェクションされる問題に対応
- s13: XMLスキーマ定義をgithub.ioで公開
- s14: 環境設定ファイルにJavaのプロパティファイルを使えるように変更
- s15: SQL文中のスキーマを環境毎に切り替える機能を追加
- s16: 自動採番カラムを持つテーブルに対して一括登録(batchInsert)が行えないデータベースの場合に出力されるエラーメッセージの改善
- s17: フィールドにアノテーションを設定できるように変更
- s18: 定型メール機能についてテンプレートエンジンを切り替えられるように変更
- s19: サロゲートペアを使用できない問題に対応
- s20: 日付や数値などのデータを文字列にフォーマットするフォーマッタを追加
- s21: 非推奨APIの見直しと非推奨理由を追記
- s22: Nablarchフレームワークのテスト環境のブラウザバージョンを最新化
- s23: Nablarchフレームワークのテスト環境のJavaとDBのバージョンを最新化
- s24: MOMメッセージングは固定長のみに対応していることを追記
- s25: 共通項目(登録ユーザや更新ユーザなどのカラム)に対する値の自動設定方法を追記
- s26: JSP以外を使用した画面開発の方法を追記
- s27: コード値のenum化について追記
- s28: サロゲートペアを使用する方法を追記
- s29: HTTPアクセスログのマスキングの設定例を修正
- s30: nablarch-archetype-parentからh2のJDBCドライバの依存関係を削除
- s31: アダプタ
- s32: Domaとアプリケーションからのログ出力を統一するロガーを追加
- s33: java.sql.Statementに関する設定をカスタマイズできるように変更
- s34: E-mail FreeMarkerアダプタを追加
- s35: E-mail Thymeleafアダプタを追加
- s36: E-mail Velocityアダプタを追加
- s37: ウェブアプリケーション Thymeleafアダプタを追加
- s38: ルーティングアダプタが使用しているhttp-request-routerのバージョンを最新化
- s39: BeanUtilによるコピー処理で日付のフォーマットパターンを指定できるように変更
- s40: Example
- s41: 顧客検索一覧画面でエラーメッセージが正しく表示されない問題に対応
- s42: プロジェクト変更画面で「戻る」遷移ができない問題に対応
- s43: 一括更新画面で画面にない項目がnullで更新される問題に対応
- s44: 不要なプロファイルの削除
- s45: 新規追加したフォーマッタを使用するように変更
- s46: Thymeleafアダプタを使用したExampleを追加
- s47: 新規追加したフォーマッタを使用するように変更
- s48: 新規追加したフォーマッタを使用するように変更
- s49: 今後はメンテナンスされない旨を明記
- s50: ETL基盤
- s51: プラグインの入力として指定するJava Beansの制約を追記
- s52: プラグインのバージョン指定について説明を追記
- s53: 帳票ライブラリ
- s54: 今後はメンテナンスされない旨を明記
- s55: UI開発基盤 ※既にUI開発基盤を導入済みのPJにおいては、左記の変更内容の取込をプラグイン単位で実施します。変更内容とプラグインの対応については、 「標準プラグインの変更点」シートを参照ください。
- s56: ダイアログのテストで表示される文言を修正
- s57: ダイアログ(alert)用のテスト画面で打鍵テストができない問題に対応
- s58: リストビルダーの単体テストの期待値を修正
- s59: ファイルアップロードの単体テストの期待値を修正
- s60: 設計書ビューの画面設計ボタンは機能しないことを追記
- s61: 検索結果テーブルウィジェットのusePaging属性の仕様を明記
- s62: UI開発基盤の使用上の注意点を変更
- s63: 画面項目定義データ自動生成ツールに関する記載を削除
- s64: UI開発基盤のテスト環境のブラウザバージョンを最新化
- s65: ブラウザバージョンについて注意書きを追加
- s66: テスティングフレームワーク
- s67: クラス単体テストでテスト可能なプロパティの型を追加
- s68: OneShotLoopHandlerにて起動時に作成した型のExecutionContextをサブスレッドで使用するように対応
- s69: テスティングフレームワークが対応していない基盤及びライブラリを明記
- s70: Nablarch実装例集
- s71: 実装例集が準拠しているNablarchバージョンを明記
- s72: CAPTCHA機能サンプルに注意点を追記
- s73: Nablarch開発標準
- s74: 画面項目定義データ自動生成ツールに関する記載を削除
- s75: Shell Script自動生成ツールの前提を追記
- s76: モジュールのバージョン番号に関する補足
- s77: 次のモジュールはリリースノートで説明されていませんが、バージョン番号のみが更新されています。
- s78: ・nablarch-fw(1.1.2→1.2.0)
- s79: 5u13の検証とテストは上記のバージョンで行われており、プロジェクトのアップグレードに影響はありません。

### ■Domaのロガーを5u12までと同じ動作にする方法
path: releases/releases/releases-nablarch5u13-releasenote-Domaのロガーを5u12までと同じ動作にする方法.json

### ■システムリポジトリを5u12までと同じ動作にする方法
path: releases/releases/releases-nablarch5u13-releasenote-システムリポジトリを5u12までと同じ動作にする方法.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u13-releasenote-バージョンアップ手順.json

### ■定型メール送信要求を5u12までと同じ動作にする方法
path: releases/releases/releases-nablarch5u13-releasenote-定型メール送信要求を5u12までと同じ動作にする方法.json

### ■UI開発基盤（標準プラグイン）の変更点
path: releases/releases/releases-nablarch5u13-releasenote-標準プラグインの変更点.json
- s1: ダイアログのテストで表示される文言を修正
- s2: ダイアログ(alert)用のテスト画面で打鍵テストができない問題に対応
- s3: リストビルダーの単体テストの期待値を修正
- s4: ファイルアップロードの単体テストの期待値を修正

### ■Nablarch 5u14 リリースノート
path: releases/releases/releases-nablarch5u14-releasenote-5u14.json
- s2: UseToken.Implの実装ミスを修正
- s3: モジュールの依存関係を修正
- s4: XXE脆弱性対応
- s5: メール送信機能のデフォルト値を修正
- s6: HIDDENストア脆弱性対応
- s7: 一括登録機能ガイドページ内のサンプルファイル不備
- s8: listNameが空の場合に画面に何も出力しない仕様の明記
- s9: アーキタイプが生成するconfigファイルの設定値（メール送信バッチの監視間隔）の間違い
- s10: Jacksonモジュールのバージョンアップ
- s11: アダプタ
- s12: Jacksonモジュールのバージョンアップ
- s13: ETL基盤
- s14: Jacksonモジュールのバージョンアップ
- s15: Example
- s16: setterの実装不備を修正
- s17: 未使用クラスを削除
- s18: メッセージに置換文字列が埋め込まれない不具合を修正
- s19: USER_SESSIONの定義を修正
- s20: Jacksonモジュールのバージョンアップ
- s21: UI開発基盤 ※既にUI開発基盤を導入済みのPJにおいては、左記の変更内容の取込をプラグイン単位で実施します。変更内容とプラグインの対応については、 「標準プラグインの変更点」シートを参照ください。
- s22: 利用するjQueryのバージョンアップ
- s23: Git利用時に発生するデモ用サーバ起動時のエラーに対応
- s24: 展開手順がSVNの利用を想定していることを追記
- s25: キャンセルボタンで使用しているアイコンを適切なアイコンに修正
- s26: テストコード修正に関する5u13リリース漏れを追加
- s27: UI開発基盤の動作確認環境デバイスのOSのバージョンアップ
- s28: 導入手順に不要な手順が含まれていたので修正
- s29: テスティングフレームワーク
- s30: マスタデータ投入ツールがマルチスレッド対応していないことをドキュメントに注記

### HIDDENストア脆弱性
path: releases/releases/releases-nablarch5u14-releasenote-HIDDENストア脆弱性.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u14-releasenote-バージョンアップ手順.json

### ■ボタンのアイコンを変更
path: releases/releases/releases-nablarch5u14-releasenote-ボタンのアイコンを変更する場合.json

### ■UI開発基盤（標準プラグイン）の変更点
path: releases/releases/releases-nablarch5u14-releasenote-標準プラグインの変更点.json
- s1: 5u14
- s2: 5u14
- s3: 5u14
- s4: 5u14
- s5: 5u14
- s6: 5u14
- s7: 5u14
- s8: 5u14
- s9: 5u14
- s10: 5u14
- s11: 5u14
- s12: 5u14
- s13: 5u14
- s14: 5u14
- s15: 5u14
- s16: 5u14
- s17: 5u14
- s18: 5u14
- s19: 5u14
- s20: 5u14
- s21: 5u14
- s22: 5u14
- s23: 5u14
- s24: 5u14
- s25: 5u14
- s26: 5u14
- s27: 5u14
- s28: 5u14
- s29: 5u14
- s30: 5u14
- s31: 5u14
- s32: 5u14
- s33: 5u14

### ■【不具合報告】Nablarch 汎用データフォーマット XXE脆弱性について
path: releases/releases/releases-nablarch5u14-releasenote-汎用データフォーマットXXE脆弱性.json

### ■Nablarch 5u15 リリースノート
path: releases/releases/releases-nablarch5u15-releasenote-5u15.json
- s2: セッションストアにネストしたクラスを格納できない問題に対応
- s3: アプリケーションフレームワークのJava11対応
- s4: アプリケーションフレームワークのテスト環境を更新
- s5: システムリポジトリのスコープに関する注意書きを修正
- s6: ドメインバリデーションに複数のバリデーションルールを設定した場合の仕様を追記
- s7: メッセージングログのプレースホルダの仕様を追記
- s8: ブランクプロジェクトのJava11対応
- s9: ブランクプロジェクトが使用しているモジュールの脆弱性対応
- s10: ブランクプロジェクトのデフォルトのコネクションプールを変更
- s11: アダプタ
- s12: RESTfulウェブサービスが使用しているモジュールの脆弱性対応
- s13: Example
- s14: ExampleのJava11対応
- s15: Exampleのコネクションプールを変更
- s16: Exampleが使用しているモジュールの脆弱性対応
- s17: 実行手順の記載を改善
- s18: 実行手順の記載を改善
- s19: 実行手順の記載を改善
- s20: 相関バリデーションで実行時エラーが発生する問題に対応
- s21: ETL基盤
- s22: ETLが使用しているモジュールの脆弱性対応
- s23: ワークフローライブラリ
- s24: ワークフロー定義データ生成ツールをJava11で使用する場合の設定方法を追記
- s25: UI開発基盤 ※既にUI開発基盤を導入済みのPJにおいては、左記の変更内容の取込をプラグイン単位で実施します。変更内容とプラグインの対応については、 「標準プラグインの変更点」シートを参照ください。
- s26: UI開発基盤が使用しているモジュールの脆弱性対応
- s27: テスティングフレームワーク
- s28: テスティングフレームワークのJava11対応
- s29: Nablarch開発ツール
- s30: ブラックリストの設定方法を追記

### ■HttpServerクラスを使っている場合の対応方法
path: releases/releases/releases-nablarch5u15-releasenote-HttpServerクラスを使っている場合の対応方法.json

### ■テスティングフレームワークの設定変更方法
path: releases/releases/releases-nablarch5u15-releasenote-テスティングフレームワークの設定変更方法.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u15-releasenote-バージョンアップ手順.json

### ■UI開発基盤（標準プラグイン）の変更点
path: releases/releases/releases-nablarch5u15-releasenote-標準プラグインの変更点.json

### ■Nablarch 5u16 リリースノート
path: releases/releases/releases-nablarch5u16-releasenote-5u16.json
- s2: セッション有効期間の保存先にDBを追加
- s3: トークンの保存先にDBを追加
- s4: HTTPセッションの誤使用を検知する機能を追加
- s5: OS環境変数で環境依存値を上書きする機能を追加
- s6: ログ出力を行っているロガー名を取得できるプレースホルダの追加
- s7: クエリ文字列を取得できるプレースホルダの追加
- s8: 結合対象の値がnullの場合に任意の文字に置換できる文字列結合メソッドを追加
- s9: スコープ付きDIコンテナの追加
- s10: Webアプリケーションをステートレスにする方法を追記
- s11: バッチアプリケーションの推奨方式を変更
- s12: ユーザIDの設定方法を明記
- s13: プロジェクト新規作成時の注意書きを追記
- s14: アプリケーションフレームワークのテスト環境を更新
- s15: Jacksonモジュールの脆弱性対応
- s16: ログフォーマットの見直し
- s17: Waitt Maven Pluginのバージョンアップ
- s18: アダプタ
- s19: Jackson1系対応機能の廃止
- s20: Jacksonモジュールの脆弱性対応
- s21: log4jアダプタの廃止
- s22: Example
- s23: Webアプリケーションをステートレスにする設定に変更
- s24: Jacksonモジュールの脆弱性対応
- s25: Waitt Maven Pluginのバージョンアップ
- s26: Waitt Maven Pluginのバージョンアップ
- s27: ETL基盤
- s28: Jacksonモジュールの脆弱性対応
- s29: テスティングフレームワーク
- s30: 「同期応答メッセージ送信処理を伴う取引単体テストの実施方法」に手順を追加
- s31: Nablarch開発ツール
- s32: 配布用zipの作成ができる機能を追加
- s33: IN句を使用できるように対応
- s34: PostgreSQLでSQL Executorを使用できるように対応

### ■Jackson1系の使用有無判断方法
path: releases/releases/releases-nablarch5u16-releasenote-Jackson1系の使用有無判断方法.json

### ■Jackson1系の設定変更方法
path: releases/releases/releases-nablarch5u16-releasenote-Jackson1系の設定変更方法.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u16-releasenote-バージョンアップ手順.json

### ■Nablarch 5u17 リリースノート
path: releases/releases/releases-nablarch5u17-releasenote-5u17.json
- s2: CSRF対策機能を追加

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u17-releasenote-バージョンアップ手順.json

### ■Nablarch 5u18 リリースノート
path: releases/releases/releases-nablarch5u18-releasenote-5u18.json
- s2: データ出力でバッファサイズを指定できるように変更
- s3: BasicCommitLogger#initializeメソッドをsynchronizedに変更
- s4: 二重サブミット防止機能で使用するトークンのデフォルトをUUIDに変更
- s5: Referrer-Policyヘッダを付与できるように変更
- s6: Cache-Controlヘッダを付与できるように変更
- s7: ボディがないレスポンスにContent-Typeを設定しないように変更
- s8: Producesを使用したリソースメソッドでレスポンスヘッダを指定できるように変更
- s9: ErrorResponseBuilderの処理中に例外が発生した場合はステータスコード500のレスポンスを返すように変更
- s10: CORS(Cross-Origin Resource Sharing)を追加
- s11: 言語とタイムゾーンをクッキーに保持する場合にhttpOnly属性を設定できるように変更
- s12: CSRFトークンの検証失敗時にログを出力するように変更
- s13: ヘルスチェックのエンドポイントを作成するためのハンドラを追加
- s14: アノテーションを付与したクラスのオブジェクトを構築する機能を追加
- s15: オブジェクトの廃棄処理を実行する仕組みを追加
- s16: DataReader#readメソッドのJavadocを変更
- s17: リクエストハンドラエントリのリクエストパターンのバリデーションに対応できていない問題を修正
- s18: SynchronousFileLogWriterの使用想定をドキュメントに追記
- s19: ファクトリクラスを入れ子で使用できない制約を追記
- s20: List型の型パラメータに対応していない制約と対応方法を明示するように変更
- s21: ブランクプロジェクトをEclipseで開いた場合に発生するエラーの対応方法を追記
- s22: Guavaのバージョンアップ
- s23: コンテナ用ブランクプロジェクトを追加
- s24: Hibernate Validatorのバージョンアップ
- s25: アダプタ
- s26: テンプレートのプレースホルダにList型の変数を使用できない問題を修正
- s27: SLF4Jアダプタを追加
- s28: Redisストア(Lettuce)アダプタを追加
- s29: JAX-RSのPathアノテーションでマッピングする機能を追加
- s30: Micrometerアダプタを追加
- s31: RESTEasy用アダプタの依存からJackson Databindを削除
- s32: UI開発基盤 ※既にUI開発基盤を導入済みのPJにおいては、左記の変更内容の取込をプラグイン単位で実施します。変更内容とプラグインの対応については、 「標準プラグインの変更点」シートを参照ください。
- s33: jQueryのバージョンアップ
- s34: テスティングフレームワーク
- s35: RESTfulウェブサービス向け単体テストフレームワークを追加

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u18-releasenote-バージョンアップ手順.json

### ■UI開発基盤（標準プラグイン）の変更点
path: releases/releases/releases-nablarch5u18-releasenote-標準プラグインの変更点.json
- s1: スライドするメニューサンプルの追加
- s2: nablarch-device-fix-ios
- s3: nablarch-dev-ui_test-support
- s4: nablarch-device-fix-android_browser
- s5: 確認ダイアログ表示イベントアクションのディバイス依存不具合に対応
- s6: nablarch-widget-event-autosum
- s7: サブウィンドウ内イベント連携機能のイベント監視対象の変更
- s8: UI開発基盤の導入手順外のパターンへの対応
- s9: Nablarch標準プラグインの更新手順を追加
- s10: タグファイルで設定する変数のスコープを修正
- s11: nablarch-widget-box-img
- s12: nablarch-widget-button
- s13: nablarch-widget-column-checkbox
- s14: nablarch-widget-column-code
- s15: nablarch-widget-column-label
- s16: nablarch-widget-column-link
- s17: nablarch-widget-column-radio
- s18: nablarch-widget-event-dialog
- s19: nablarch-widget-event-toggle
- s20: nablarch-widget-field-base
- s21: nablarch-widget-field-block
- s22: nablarch-widget-field-calendar
- s23: nablarch-widget-field-checkbox
- s24: event:confirmタグ内のattributeのtype属性を削除
- s25: 特定端末向けパッチプラグインの注意事項を記載
- s26: Nablarch UI開発基盤 テスト用簡易サーバーの提供形式を変更
- s27: 「Form自動生成機能」の削除
- s28: nablarch-dev-ui_tool-form_gen-resource
- s29: nablarch-dev-ui_tool-base-core
- s30: nablarch-dev-ui_tool-spec_view-core
- s31: nablarch-dev-ui_test-support
- s32: nablarch-dev-ui_demo-core
- s33: nablarch-dev-ui_demo-core-lib
- s34: 「ローカル画面表示からドキュメントへのリンク」機能の削除
- s35: nablarch-dev-ui_demo-config
- s36: ポップアップ機能と併用した場合の不具合に対応
- s37: 画像表示ウィジェットをコンパクトモードで表示した際に画像が消えてしまう不具合に対応
- s38: UIビルドコマンドの実行時に生成されるリソースに不要な文字列が出力されることがある不具合を修正
- s39: 生成するCSSをminifyするように修正
- s40: プロダクション環境にリリースされるJSPの配置場所をWEB-INF配下に変更
- s41: nablarch-dev-ui_demo-core-lib
- s42: nablarch-dev-ui_test-support
- s43: nablarch-template-app_aside
- s44: nablarch-template-app_footer
- s45: nablarch-template-app_header
- s46: nablarch-template-app_header
- s47: nablarch-template-base
- s48: nablarch-template-head
- s49: nablarch-template-js_include
- s50: nablarch-template-multicol-head
- s51: nablarch-template-page
- s52: nablarch-widget-event-listen
- s53: nablarch-widget-slide-menu
- s54: nablarch-ui-development-template
- s55: resultSetName属性を指定せずにresultNumName属性を指定できない不具合に対応
- s56: 画面モック起動時にthead, tbody, tfootタグがHTMLに表示されない不具合に対応
- s57: nablarch-dev-ui_demo-core
- s58: 動作確認用アプリケーションのハンドラ構成を最新化
- s59: ダイアログのテストで表示される文言を修正
- s60: ダイアログ(alert)用のテスト画面で打鍵テストができない問題に対応
- s61: リストビルダーの単体テストの期待値を修正
- s62: ファイルアップロードの単体テストの期待値を修正
- s63: jQueryのバージョンをアップデート
- s64: jQuery3系で削除されたAPIの修正
- s65: ボタンアイコンの変更
- s66: ios10でiPadのviewportが動作しない問題に対応
- s67: テスト時のサイドメニューのリンク切れを修正
- s68: 単体テストページの追加
- s69: 単体テストページの追加
- s70: jQuery3系で削除されたAPIの修正（テストコード）
- s71: 9
- s72: 10
- s73: 11
- s74: 12
- s75: 13
- s76: 14
- s77: 15
- s78: 16
- s79: 17
- s80: 18
- s81: 19
- s82: 20
- s83: 不安定なテストの修正
- s84: テストコードの不備を修正
- s85: JSPローカル表示がうまく動作しないテストを修正
- s86: 24
- s87: 25
- s88: 26
- s89: 27
- s90: 28
- s91: テストコードの文言を修正
- s92: 30
- s93: 31
- s94: 不要なテスト資材を削除
- s95: 33
- s96: jQueryのバージョンをアップデート
- s97: jQueryのバージョンをアップデート

### ■Nablarch 5u19 リリースノート
path: releases/releases/releases-nablarch5u19-releasenote-5u19.json
- s2: JSONの読み取りに失敗する問題を修正
- s3: バッチアプリケーションの場合にオブジェクトの廃棄処理が実行されない問題を修正
- s4: レスポンスボディが空の場合に自動でContent-Typeを設定しないように修正
- s5: コンポーネント定義で指定した環境依存値が存在しない場合例外を送出するように修正
- s6: 任意の属性を使用できるように修正
- s7: CORSのプリフライトリクエストとして判定する条件を修正
- s8: list要素に設定できる値の型に関する制約を追記
- s9: AWS・Azureでの分散トレーシング方法を追記
- s10: アプリケーションフレームワークのテスト環境を更新
- s11: jackson-databindのバージョンアップ
- s12: 環境設定ファイルの拡張子を".properties"に統一
- s13: アダプタ
- s14: メトリクスを収集するための機能を追加
- s15: Azure 対応
- s16: Example
- s17: JUnit4バージョンアップ
- s18: UI開発基盤 ※既にUI開発基盤を導入済みのPJにおいては、左記の変更内容の取込をプラグイン単位で実施します。変更内容とプラグインの対応については、 「標準プラグインの変更点」シートを参照ください。
- s19: 新規開発用テンプレートのjQueryバージョンが古い問題に対応
- s20: テスティングフレームワーク
- s21: Content-Typeが無いレスポンスのダンプファイルを出力できるように修正
- s22: HTTP同期応答メッセージ送信処理のリクエスト単体テスト実施方法の記載漏れ追記
- s23: 「」

### Content-Typeの互換性維持方法
path: releases/releases/releases-nablarch5u19-releasenote-Content-Typeの互換性維持方法.json

### JSON読み取り失敗ケース
path: releases/releases/releases-nablarch5u19-releasenote-JSON読み取り失敗ケース.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u19-releasenote-バージョンアップ手順.json

### ■UI開発基盤（標準プラグイン）の変更点
path: releases/releases/releases-nablarch5u19-releasenote-標準プラグインの変更点.json
- s1: スライドするメニューサンプルの追加
- s2: nablarch-device-fix-ios
- s3: nablarch-dev-ui_test-support
- s4: nablarch-device-fix-android_browser
- s5: 確認ダイアログ表示イベントアクションのディバイス依存不具合に対応
- s6: nablarch-widget-event-autosum
- s7: サブウィンドウ内イベント連携機能のイベント監視対象の変更
- s8: UI開発基盤の導入手順外のパターンへの対応
- s9: Nablarch標準プラグインの更新手順を追加
- s10: タグファイルで設定する変数のスコープを修正
- s11: nablarch-widget-box-img
- s12: nablarch-widget-button
- s13: nablarch-widget-column-checkbox
- s14: nablarch-widget-column-code
- s15: nablarch-widget-column-label
- s16: nablarch-widget-column-link
- s17: nablarch-widget-column-radio
- s18: nablarch-widget-event-dialog
- s19: nablarch-widget-event-toggle
- s20: nablarch-widget-field-base
- s21: nablarch-widget-field-block
- s22: nablarch-widget-field-calendar
- s23: nablarch-widget-field-checkbox
- s24: event:confirmタグ内のattributeのtype属性を削除
- s25: 特定端末向けパッチプラグインの注意事項を記載
- s26: Nablarch UI開発基盤 テスト用簡易サーバーの提供形式を変更
- s27: 「Form自動生成機能」の削除
- s28: nablarch-dev-ui_tool-form_gen-resource
- s29: nablarch-dev-ui_tool-base-core
- s30: nablarch-dev-ui_tool-spec_view-core
- s31: nablarch-dev-ui_test-support
- s32: nablarch-dev-ui_demo-core
- s33: nablarch-dev-ui_demo-core-lib
- s34: 「ローカル画面表示からドキュメントへのリンク」機能の削除
- s35: nablarch-dev-ui_demo-config
- s36: ポップアップ機能と併用した場合の不具合に対応
- s37: 画像表示ウィジェットをコンパクトモードで表示した際に画像が消えてしまう不具合に対応
- s38: UIビルドコマンドの実行時に生成されるリソースに不要な文字列が出力されることがある不具合を修正
- s39: 生成するCSSをminifyするように修正
- s40: プロダクション環境にリリースされるJSPの配置場所をWEB-INF配下に変更
- s41: nablarch-dev-ui_demo-core-lib
- s42: nablarch-dev-ui_test-support
- s43: nablarch-template-app_aside
- s44: nablarch-template-app_footer
- s45: nablarch-template-app_header
- s46: nablarch-template-app_header
- s47: nablarch-template-base
- s48: nablarch-template-head
- s49: nablarch-template-js_include
- s50: nablarch-template-multicol-head
- s51: nablarch-template-page
- s52: nablarch-widget-event-listen
- s53: nablarch-widget-slide-menu
- s54: nablarch-ui-development-template
- s55: resultSetName属性を指定せずにresultNumName属性を指定できない不具合に対応
- s56: 画面モック起動時にthead, tbody, tfootタグがHTMLに表示されない不具合に対応
- s57: nablarch-dev-ui_demo-core
- s58: 動作確認用アプリケーションのハンドラ構成を最新化
- s59: ダイアログのテストで表示される文言を修正
- s60: ダイアログ(alert)用のテスト画面で打鍵テストができない問題に対応
- s61: リストビルダーの単体テストの期待値を修正
- s62: ファイルアップロードの単体テストの期待値を修正
- s63: jQueryのバージョンをアップデート
- s64: jQuery3系で削除されたAPIの修正
- s65: ボタンアイコンの変更
- s66: ios10でiPadのviewportが動作しない問題に対応
- s67: テスト時のサイドメニューのリンク切れを修正
- s68: 単体テストページの追加
- s69: 単体テストページの追加
- s70: jQuery3系で削除されたAPIの修正（テストコード）
- s71: 9
- s72: 10
- s73: 11
- s74: 12
- s75: 13
- s76: 14
- s77: 15
- s78: 16
- s79: 17
- s80: 18
- s81: 19
- s82: 20
- s83: 不安定なテストの修正
- s84: テストコードの不備を修正
- s85: JSPローカル表示がうまく動作しないテストを修正
- s86: 24
- s87: 25
- s88: 26
- s89: 27
- s90: 28
- s91: テストコードの文言を修正
- s92: 30
- s93: 31
- s94: 不要なテスト資材を削除
- s95: 33
- s96: jQueryのバージョンをアップデート
- s97: jQueryのバージョンをアップデート
- s98: jQueryのバージョンをアップデート

### 環境依存値の設定方法
path: releases/releases/releases-nablarch5u19-releasenote-環境依存値の設定方法.json

### ■Nablarch 5u2 リリースノート
path: releases/releases/releases-nablarch5u2-releasenote-5u2.json
- s1: エンジニアリング基盤
- s2: アプリケーション実行環境
- s3: Boolean型への対応を追加
- s4: HTTPセッションが無効化されない不具合に対応
- s5: セッションストア機能が使用するCookieにHttpOnly属性を追加
- s6: 画面の再表示を行うと、改竄エラー画面に遷移する不具合に対応
- s7: アプリケーション開発環境
- s8: archetypeで生成したwebプロジェクトに、HttpCharacterEncodingHandlerが設定されていない不具合に対応
- s9: ブランクプロジェクト作成時のTODOコメントの不具合に対応
- s10: ブランクプロジェクト作成後、batch実行時にエラーになる不具合に対応
- s11: データ投入処理が非常に遅い不具合に対応

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u2-releasenote-バージョンアップ手順.json

### 分類
path: releases/releases/releases-nablarch5u2-releasenote-分類.json

### ■Nablarch 5u20 リリースノート
path: releases/releases/releases-nablarch5u20-releasenote-5u20.json
- s2: リクエストハンドラエントリのリクエストパターンの判定処理の不具合を修正
- s3: 5u18でリクエストハンドラエントリに埋め込まれたリクエストパターンの判定処理の不具合を修正
- s4: コンテナ用ブランクプロジェクトを追加
- s5: Guavaのバージョンアップ
- s6: Logbackのバージョンアップ
- s7: ハンドラキューの最適化
- s8: アダプタ
- s9: SLF4JではFATALレベルがERRORレベルにマッピングされることを追記
- s10: Example
- s11: Guavaのバージョンアップ
- s12: Logbackのバージョンアップ
- s13: ハンドラキューの最適化
- s14: テスティングフレームワーク
- s15: 同期応答メッセージ送信処理を伴う取引単体テストの実施方法で使用する応答電文のExcelファイルが再読み込みされない不具合に対応
- s16: Nablarch開発標準
- s17: 外部インタフェース設計書
- s18: 設計書フォーマットの変更にあわせるための修正

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u20-releasenote-バージョンアップ手順.json

### ■Nablarch 5u21 リリースノート
path: releases/releases/releases-nablarch5u21-releasenote-5u21.json
- s2: JSONログ出力機能の追加
- s3: メール送信機能の改善
- s4: Nablarchサーブレットコンテキスト初期化リスナの初期化成否取得メソッドの追加
- s5: プロパティファイルによるメッセージ管理機能の設定を追加
- s6: EntityMeta初期化時に発生したエラーをログに出力するように変更
- s7: セッションIDだけを変更するAPIを追加
- s8: HTTPアクセスログで出力できる項目にセッションストアのIDを追加
- s9: ブランクプロジェクトを Java 17 で動かす際に必要になる修正手順を追加
- s10: OracleのJDBCドライバの入手方法の説明を修正
- s11: セントラルリポジトリのOracleのJDBCドライバを使用するようにdependencyを修正
- s12: Java 17 に対応
- s13: ブランクプロジェクトで使用するMavenの前提バージョンを変更
- s14: JAX-RSのバージョンを変更
- s15: JUnit5を使用するように変更
- s16: プロパティファイルによるメッセージ管理機能の設定を追加
- s17: Example
- s18: Java 17 に対応
- s19: Java 17 に対応
- s20: Java 17 に対応
- s21: JUnit5を使用するように変更
- s22: ワークフローライブラリ
- s23: Java 17 に対応
- s24: テスティングフレームワーク
- s25: 使用不許可APIチェックツールの分離
- s26: SpotBugs 4.Xで実行できる使用不許可APIチェックツールの追加
- s27: PATCHメソッドの追加
- s28: JUnit5で使用するための拡張機能を追加
- s29: ServletExecutionContextのモッククラスを追加
- s30: Excelファイルに日付のテストデータを記述するときに、時刻の省略ができるように変更
- s31: JUnit 5 で動かすための手順を追加

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u21-releasenote-バージョンアップ手順.json

### 使用不許可APIチェックツールの設定方法
path: releases/releases/releases-nablarch5u21-releasenote-使用不許可APIチェックツールの設定方法.json

### ■Nablarch 5u22 リリースノート
path: releases/releases/releases-nablarch5u22-releasenote-5u22.json
- s2: ロガー名が適切に設定されていない問題に対応
- s3: アノテーションによる認可チェックを追加
- s4: Webフロントコントローラのコンポーネント名を動的に取得するように変更
- s5: 半角スペースを含む名前のファイルをダウンロードする場合にファイル名が切れる問題に対応
- s6: ユニバーサルDAOでNoDataExceptionを出さないメソッドを追加
- s7: 日付ローテーション
- s8: アップロードファイル数に上限を設定できる機能を追加
- s9: 責務配置にDTOを追加
- s10: DBに接続しないケースのブランクプロジェクトを追加
- s11: https://nablarch.github.io/docs/5u22/doc/application_framework/application_framework/blank_project/setup_containerBlankProject/setup_ContainerBatch_Dbless.html
- s12: jackson-databindのバージョンアップ
- s13: H2のバージョンアップ
- s14: アダプタ
- s15: jackson-databindのバージョンアップ
- s16: Example
- s17: jackson-databindのバージョンアップ
- s18: Webフロントコントローラのコンポーネント名を動的に取得するように変更
- s19: H2のバージョンアップ
- s20: ETL基盤
- s21: jackson-databindのバージョンアップ
- s22: テスティングフレームワーク
- s23: ログ出力時の日本語文字化けに対応
- s24: jackson-databindのバージョンアップ
- s25: Nablarch実装例集
- s26: OpenID Connect（OIDC）のIDトークンを用いた認証サンプルを追加
- s27: Nablarch5対応
- s28: Nablarch開発標準
- s29: ShellCheck対応
- s30: ファイル受信バッチの不具合修正

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u22-releasenote-バージョンアップ手順.json

### ■Nablarch 5u23 リリースノート
path: releases/releases/releases-nablarch5u23-releasenote-5u23.json
- s2: RESTfulウェブサービス用のHTTPアクセスログハンドラを追加
- s3: 日付バリデーションを追加
- s4: 列挙値バリデーションを追加
- s5: Bean Validationのグループ機能に対応
- s6: https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/web_interceptor/InjectForm.html#bean-validation
- s7: https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/rest/jaxrs_bean_validation_handler.html#bean-validation
- s8: DBアクセス失敗時の例外ハンドリングを改善
- s9: https://nablarch.github.io/docs/5u23/doc/application_framework/application_framework/handlers/common/database_connection_management_handler.html
- s10: IntelliJ IDEA用Inspectionプロファイルの提供を廃止
- s11: HTTPアクセスログハンドラの変更
- s12: テスト時のHTTPメソッド指定の追加
- s13: メール送信で利用するステータス更新用のトランザクションマネージャーをデフォルト設定から読み込むよう変更
- s14: CSRFトークン検証ハンドラの追加
- s15: 疎通確認用JSPをWEB-INF配下に移動
- s16: Example
- s17: HTTPアクセスログハンドラの変更
- s18: テスト時のHTTPメソッド指定処理の変更
- s19: 単体テストで使用するハンドラの独自実装を廃止
- s20: 日付バリデーションの変更
- s21: 列挙値バリデーションの変更
- s22: Formの単体テストの追加
- s23: テスティングフレームワーク
- s24: RESTfulウェブサービスのテストでコンポーネント設定を上書きできるように変更
- s25: WebアプリケーションのテストでHTTPメソッドおよびクエリパラメータを設定できるように変更
- s26: RESTfulウェブサービスのテストで複数のクッキーを引き継げるように変更
- s27: 不要なディレクトリが作成されないように変更
- s28: Form/Entityの単体テストをBeanValidationに対応
- s29: Nablarch実装例集
- s30: Logbookを用いたリクエスト/レスポンスログ出力の実装例を追加

### ■DBアクセス失敗時の例外ハンドリングの変更点
path: releases/releases/releases-nablarch5u23-releasenote-DBアクセス失敗時の例外ハンドリング.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u23-releasenote-バージョンアップ手順.json

### ■Nablarch 5u24 リリースノート
path: releases/releases/releases-nablarch5u24-releasenote-5u24.json
- s2: 件数取得SQLをカスタマイズできるようにDialectインターフェースを拡張しました
- s3: https://nablarch.github.io/docs/5u24/doc/application_framework/application_framework/libraries/database/universal_dao.html#universal_dao-customize_sql_for_counting
- s4: JSON形式のファイルを読み込む際、値の最後がエスケープ文字だとエラーが発生する問題に対応
- s5: HTTPリクエストからリクエストパラメータを取得するAPIをアーキテクト向け公開APIに変更
- s6: RESTfulウェブサービス専用のHTTPリクエストクラスを追加
- s7: ブランクプロジェクトを Java 21 で動かす際に必要になる修正手順を追加
- s8: アプリケーションフレームワークのテスト環境を更新
- s9: Java 21 に対応
- s10: アダプタ
- s11: 使用するIBM MQのバージョンを変更
- s12: Nablarch実装例集
- s13: IBM MQとの通信にIBM MQアダプタを使用するように変更
- s14: Example
- s15: HTTPリクエストからリクエストパラメータを取得する共通部品を追加
- s16: テスティングフレームワーク
- s17: HTTPリクエストからリクエストパラメータを取得する処理を追加
- s18: https://nablarch.github.io/docs/5u24/publishedApi/nablarch-testing/publishedApiDoc/programmer/nablarch/test/core/http/HttpRequestTestSupport.html#getParam-nablarch.fw.web.HttpRequest-java.lang.String-

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u24-releasenote-バージョンアップ手順.json

### ■件数取得SQLの拡張ポイント追加
path: releases/releases/releases-nablarch5u24-releasenote-件数取得SQLの拡張ポイント追加.json

### ■Nablarch 5u25 リリースノート
path: releases/releases/releases-nablarch5u25-releasenote-5u25.json
- s2: 公開APIの追加
- s3: CSPのscript-srcにunsafe-inline以外を指定できるように改善
- s4: 明示的にバリデーションを実行するための使用方法を追加
- s5: テスト環境のデータベースを更新
- s6: Maven Archetype Plugin 3.xに対応
- s7: アダプタ
- s8: テストで使用しているJacksonのバージョンを更新
- s9: OpenTelemetry Protocol（OTLP）用のレジストリファクトリを追加
- s10: Example
- s11: CSP対応

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u25-releasenote-バージョンアップ手順.json

### ■Nablarch 5u26 リリースノート
path: releases/releases/releases-nablarch5u26-releasenote-5u26.json
- s2: JSONの読み取りに失敗する問題を修正
- s3: ルート定義ファイル再読込に関するデフォルト値、コメント変更
- s4: 使用不許可APIツールのバージョン更新
- s5: gsp-dba-maven-pluginをJava 11以降で実行するための依存ライブラリ追加
- s6: UI開発基盤 ※既にUI開発基盤を導入済みのPJにおいては、左記の変更内容の取込をプラグイン単位で実施します。変更内容とプラグインの対応については、 「標準プラグインの変更点」シートを参照ください。
- s7: RequireJSのバージョンアップ
- s8: Nablarch開発標準
- s9: Java 21でjava.lang.Objectのメソッドが許可できない場合がある問題に対応

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u26-releasenote-バージョンアップ手順.json

### ■UI開発基盤（標準プラグイン）の変更点
path: releases/releases/releases-nablarch5u26-releasenote-標準プラグインの変更点.json
- s1: スライドするメニューサンプルの追加
- s2: nablarch-device-fix-ios
- s3: nablarch-dev-ui_test-support
- s4: nablarch-device-fix-android_browser
- s5: 確認ダイアログ表示イベントアクションのディバイス依存不具合に対応
- s6: nablarch-widget-event-autosum
- s7: サブウィンドウ内イベント連携機能のイベント監視対象の変更
- s8: UI開発基盤の導入手順外のパターンへの対応
- s9: Nablarch標準プラグインの更新手順を追加
- s10: タグファイルで設定する変数のスコープを修正
- s11: nablarch-widget-box-img
- s12: nablarch-widget-button
- s13: nablarch-widget-column-checkbox
- s14: nablarch-widget-column-code
- s15: nablarch-widget-column-label
- s16: nablarch-widget-column-link
- s17: nablarch-widget-column-radio
- s18: nablarch-widget-event-dialog
- s19: nablarch-widget-event-toggle
- s20: nablarch-widget-field-base
- s21: nablarch-widget-field-block
- s22: nablarch-widget-field-calendar
- s23: nablarch-widget-field-checkbox
- s24: event:confirmタグ内のattributeのtype属性を削除
- s25: 特定端末向けパッチプラグインの注意事項を記載
- s26: Nablarch UI開発基盤 テスト用簡易サーバーの提供形式を変更
- s27: 「Form自動生成機能」の削除
- s28: nablarch-dev-ui_tool-form_gen-resource
- s29: nablarch-dev-ui_tool-base-core
- s30: nablarch-dev-ui_tool-spec_view-core
- s31: nablarch-dev-ui_test-support
- s32: nablarch-dev-ui_demo-core
- s33: nablarch-dev-ui_demo-core-lib
- s34: 「ローカル画面表示からドキュメントへのリンク」機能の削除
- s35: nablarch-dev-ui_demo-config
- s36: ポップアップ機能と併用した場合の不具合に対応
- s37: 画像表示ウィジェットをコンパクトモードで表示した際に画像が消えてしまう不具合に対応
- s38: UIビルドコマンドの実行時に生成されるリソースに不要な文字列が出力されることがある不具合を修正
- s39: 生成するCSSをminifyするように修正
- s40: プロダクション環境にリリースされるJSPの配置場所をWEB-INF配下に変更
- s41: nablarch-dev-ui_demo-core-lib
- s42: nablarch-dev-ui_test-support
- s43: nablarch-template-app_aside
- s44: nablarch-template-app_footer
- s45: nablarch-template-app_header
- s46: nablarch-template-app_header
- s47: nablarch-template-base
- s48: nablarch-template-head
- s49: nablarch-template-js_include
- s50: nablarch-template-multicol-head
- s51: nablarch-template-page
- s52: nablarch-widget-event-listen
- s53: nablarch-widget-slide-menu
- s54: nablarch-ui-development-template
- s55: resultSetName属性を指定せずにresultNumName属性を指定できない不具合に対応
- s56: 画面モック起動時にthead, tbody, tfootタグがHTMLに表示されない不具合に対応
- s57: nablarch-dev-ui_demo-core
- s58: 動作確認用アプリケーションのハンドラ構成を最新化
- s59: ダイアログのテストで表示される文言を修正
- s60: ダイアログ(alert)用のテスト画面で打鍵テストができない問題に対応
- s61: リストビルダーの単体テストの期待値を修正
- s62: ファイルアップロードの単体テストの期待値を修正
- s63: jQueryのバージョンをアップデート
- s64: jQuery3系で削除されたAPIの修正
- s65: ボタンアイコンの変更
- s66: ios10でiPadのviewportが動作しない問題に対応
- s67: テスト時のサイドメニューのリンク切れを修正
- s68: 単体テストページの追加
- s69: 単体テストページの追加
- s70: jQuery3系で削除されたAPIの修正（テストコード）
- s71: 9
- s72: 10
- s73: 11
- s74: 12
- s75: 13
- s76: 14
- s77: 15
- s78: 16
- s79: 17
- s80: 18
- s81: 19
- s82: 20
- s83: 不安定なテストの修正
- s84: テストコードの不備を修正
- s85: JSPローカル表示がうまく動作しないテストを修正
- s86: 24
- s87: 25
- s88: 26
- s89: 27
- s90: 28
- s91: テストコードの文言を修正
- s92: 30
- s93: 31
- s94: 不要なテスト資材を削除
- s95: 33
- s96: jQueryのバージョンをアップデート
- s97: jQueryのバージョンをアップデート
- s98: jQueryのバージョンをアップデート
- s99: RequireJSのバージョンをアップデート
- s100: RequireJSのバージョンをアップデート

### ■Nablarch 5u3 リリースノート
path: releases/releases/releases-nablarch5u3-releasenote-5u3.json
- s1: エンジニアリング基盤
- s2: アプリケーション実行環境
- s3: ドメインバリデーションとその他のバリデーションを併用できない不具合に対応
- s4: SQLのバッチ実行に対応
- s5: 他スキーマへのアクセスに対応
- s6: メタデータの取得コンポーネントを差し替え可能に変更
- s7: アプリケーション開発環境
- s8: 数値型のテーブル項目に対して準備データにnullを指定できない不具合に対応
- s9: アプリケーション開発標準/ガイド
- s10: 開発リポジトリ構築ガイドのページにNablarchモジュール一覧へのリンクを追加

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u3-releasenote-バージョンアップ手順.json

### 分類
path: releases/releases/releases-nablarch5u3-releasenote-分類.json

### ■Nablarch 5u4 リリースノート
path: releases/releases/releases-nablarch5u4-releasenote-5u4.json
- s1: エンジニアリング基盤
- s2: アプリケーション開発環境
- s3: Excelに記載した順番とは逆順でテストデータが投入される不具合に対応
- s4: DbAccessTestSupportを使用したテストでエラーとなる不具合に対応
- s5: モジュールの依存定義が不足している不具合に対応

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u4-releasenote-バージョンアップ手順.json

### 分類
path: releases/releases/releases-nablarch5u4-releasenote-分類.json

### ■Nablarch 5u5 リリースノート
path: releases/releases/releases-nablarch5u5-releasenote-5u5.json
- s1: エンジニアリング基盤
- s2: アプリケーション実行環境
- s3: データベースストアで一意制約違反が発生する可能性がある不具合に対応
- s4: Beanを入力とする検索・登録機能でgetter経由で値にアクセスしていない不具合に対応
- s5: バッチアクションのベースクラスの一部メソッドを公開APIに変更
- s6: ファイルアップロード時にHiddenストアの内容を復元できない不具合に対応
- s7: エラー発生時の遷移先指定の実装を容易にするため、HttpErrorResponseにコンストラクタを追加
- s8: カスタムタグを拡張できるように、タグライブラリの公開APIを変更
- s9: セッション並行アクセスハンドラと2重サブミット制御を併用した場合に、セッション並行アクセスハンドラで楽観ロックエラーが発生する不具合に対応
- s10: ErrorOnSessionWriteConflictアノテーションを非推奨に変更
- s11: ExecutionContextのセッションスコープに並行アクセスで書き込みが行われた場合、無限ループ等の問題が発生する可能性がある不具合に対応
- s12: TransactionContextに@Published(tag = "architect")を追加
- s13: BasicDbConnectionFactoryForDataSourceのstatementReuseのデフォルト値の変更
- s14: allowNullValueの設定を省略した場合のデフォルト動作をnullを許容するに変更
- s15: JavaDocの改善
- s16: BeanUtilでネストしたプロパティに対応
- s17: Mapの値としてString配列を許容
- s18: @InjectFormで使用するバリデーションを差し替えられるようにリファクタリングを実施
- s19: Nablarch以外のルーティングライブラリを適用しやすいようにサポートクラスを追加
- s20: RESTful Webサービス等で使用するHTTPステータスコードの追加
- s21: デフォルトの言語でも動作するように変更
- s22: 多重起動チェックハンドラの実体を差し替え可能に変更
- s23: 今後の機能拡張に向けたリファクタリング
- s24: 応答不要電文受信処理用アクションハンドラの設定項目の記載誤りを修正
- s25: セッションストアに格納できるオブジェクトの制約について追記
- s26: SynchronousFileLogWriter の解説書記載間違い
- s27: その他ドキュメントの改善
- s28: アプリケーション開発環境
- s29: テスティングフレームワークでソートを抑止する設定で実行した場合、マスタデータの復旧に失敗する不具合の対応
- s30: リクエスト単体テストとSessionStoreの併用が可能になるよう対応
- s31: アプリケーション開発環境
- s32: ブランクプロジェクト・関連ドキュメントの刷新
- s33: テスティングフレームワークの依存関係が不足している
- s34: アーキタイプから生成したプロジェクトでmail-senderでメール送信すると、メールの本文が不適切な文字列になっている
- s35: db-for-webui_ut.xmlファイル内に使用されていないプレースホルダがある
- s36: 設定ファイルの変更が反映されない
- s37: 開発リポジトリ構築ガイドと開発環境構築・利用ガイドの記載誤り
- s38: デフォルト設定の文字集合定義名の記載誤り
- s39: SessionStoreHandlerの設定値追加
- s40: 全角カタカナにメッセージIDが設定されていない
- s41: デフォルトコンフィグレーションの設定誤り
- s42: CAPTCHA機能サンプルの導入手順追加
- s43: 一部のツールを非推奨に変更
- s44: メッセージテーブル登録用データ作成ツールが不要な空行を出力する
- s45: メッセージテーブル登録用データ作成ツールで文字コード/改行コードの指定を可能に変更
- s46: 使用許可API一覧作成ツールを使用してJavadocを生成すると、外部Javadocへのリンクが作成できない
- s47: 親子関係があるクラスで使用許可API作成ツールを使用してJavaDocを出力した場合の不具合
- s48: 使用不許可APIチェックツールが公開された内部クラスを誤検知する
- s49: リクエストテーブル登録用データ作成ツールが不要な空行を出力する
- s50: リクエストテーブル登録用データ作成ツールで文字コード/改行コードの指定を可能に変更
- s51: コードテーブル登録用データ出力ツールで文字コード/改行コードの指定を可能に変更
- s52: テーブル定義書及びドメイン定義書出力手順で使用するObject Browser ERの定義ファイル不正
- s53: 排他制御主キークラス自動生成ツールでパッケージ名未入力時にコンパイルエラーになる
- s54: 排他制御主キークラス自動生成ツールで定義不備の場合に正常終了してしまう
- s55: 排他制御主キークラス自動生成ツールで出力エラー時にエラーメッセージが表示する修正
- s56: 排他制御主キークラス自動生成ツールで項目名に改行コードがある場合にエラーにならない
- s57: 排他制御主キークラス自動生成ツールでデータタイプ対応表シートが無い場合のエラーメッセージの変更
- s58: 認可データ設定ツールがCSVを出力するように変更
- s59: 外部インターフェース用Form自動生成ツールでオプション指定しても有効にならないものがある
- s60: Nablarch使用許可APIの最新版の追加
- s61: ドメイン定義書自動生成ツールの制約事項の追記
- s62: ドメイン定義書自動生成ツールの解説書の記載誤り
- s63: ドメイン定義書の最新化
- s64: プログラミング・単体テストガイド内の誤字の修正

### データベース機能のバージョンアップ対応
path: releases/releases/releases-nablarch5u5-releasenote-データベース機能のバージョンアップ対応.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u5-releasenote-バージョンアップ手順.json

### ブランクプロジェクト・ドキュメントの刷新について
path: releases/releases/releases-nablarch5u5-releasenote-ブランクプロジェクト・ドキュメントの刷新について.json
- s1: ブランクプロジェクト構成の変更
- s2: ブランクプロジェクトの前提DBの変更
- s3: ブランクプロジェクトの設定ファイルの簡素化
- s4: ドキュメントの再構成
- s5: デフォルト設定一覧の追加
- s6: 使用するデータベースの変更手順の追加
- s7: 共通プロジェクトの追加手順の追加
- s8: メール送信バッチの疎通確認手順の追加
- s9: MOMメッセージング実行基盤の設定手順の追加
- s10: GSPプラグインの初期設定手順の追加
- s11: マスタデータ復旧機能の使用手順の追加
- s12: ツールの組み込み
- s13: Java7/8でmavenコマンドからFindbugsを動作させる設定のデフォルト組み込みと手順化
- s14: Excelファイルからconfigファイルを自動生成しない変更
- s15: hiddenタグの暗号化の初期設定を無効に変更

### 認可データ設定ツールのバージョンアップ方法
path: releases/releases/releases-nablarch5u5-releasenote-認可データ設定ツールのバージョンアップ方法.json

### 非推奨ツールについて
path: releases/releases/releases-nablarch5u5-releasenote-非推奨ツールについて.json
- s1: Form自動生成ツール
- s2: JSP自動生成ツール
- s3: SQL自動生成ツール
- s4: 環境設定ファイル自動生成ツール
- s5: ※上記ツールを既にお使いの場合は継続利用いただけます。jarファイルで提供しているツールについては、ツールのjarファイルをバージョンアップした後も利用いただけます。

### ■Nablarch 5u6 リリースノート
path: releases/releases/releases-nablarch5u6-releasenote-5u6.json
- s2: OSS化に伴うmaven pomファイルの更新
- s3: リクエストパラメータの値をノーマライズするハンドラを追加
- s4: HTTPレスポンスハンドラからセキュリティ関連の実装をセキュアハンドラに移動
- s5: データバインドを使用して容易にダウンロード機能を実装できるようにFileResponseクラスを追加
- s6: boundary内のヘッダ行のサイズチェック処理を追加
- s7: RESTfulウェブサービスの実行制御基盤を追加
- s8: BeanValidationHandlerのバリデーション処理をBean Validationに委譲するように変更
- s9: JSR352に準拠したバッチアプリケーションの実行制御基盤を追加
- s10: 依存関係の見直し
- s11: ログのマスキング機能の変更
- s12: H2に対応したダイアレクトを追加
- s13: データバインドを追加
- s14: ObjectMapperでオートクローズ(try-with-resources構文)を使用できるように変更
- s15: Java EE7のBean Validation(JSR349)に準拠したバリデーション機能を追加
- s16: InjectFormでバリデーションした際のエラーメッセージの格納順を変更
- s17: BeanValidationのエラーメッセージをNablarchのメッセージ管理から取得するように変更
- s18: 範囲バリデーション系のメッセージを種類ごとに定義できるように変更
- s19: 指定した項目のみバリデーションを行うAPIを追加
- s20: グループシーケンスの設定機能を削除
- s21: エラーメッセージに項目名を付加する機能を追加
- s22: InjectFormアノテーションで指定したプレフィックス以外のリクエストパラメータがフォームにコピーされる不具合を修正
- s23: Digitsアノテーションで小数部のバリデーションが行われない不具合を修正
- s24: BigDecimal型の値に対して数値桁のバリデーション(@Digits)を行うとエラーになる不具合に対応
- s25: エラーメッセージをValidationManagerではなくMessageUtilから取得するように修正
- s26: メッセージの定義場所にプロパティファイルを追加
- s27: CodeUtil使用時に指定するパターン/オプション名称のカラム名で、大文字/小文字を区別しないで動作するように変更
- s28: コード名とコードパターンのテーブルで、IDカラムのカラム名が異なる場合動作しない不具合を修正
- s29: セッションの追跡に使用するクッキーをセッションクッキーに変更
- s30: セッションIDの改竄チェック処理を削除
- s31: SessionUtil#deleteで削除したセッションの値を取得出来るように変更
- s32: 同時に複数リクエストが送信された場合に、セッションストアの無効化が行われない不具合を修正
- s33: 性能改善
- s34: スレッドコンテキストの言語とタイムゾーンに依存しないようにフレームワーク全体を修正
- s35: コンポーネント定義に不備がある場合のエラー表示の改善
- s36: Publishedアノテーションの追加
- s37: webプロファイル/batchプロファイルの更新
- s38: 後方互換用モジュールのartifactIdの誤字を修正
- s39: HiddenStoreの設定の追加
- s40: StaticDataCacheを参照するコンポーネントの定義の変更
- s41: 文字集合の初期設定値の追加
- s42: メッセージIDに不適切なものがある
- s43: JavaDocの改善
- s44: ドキュメント全面改訂
- s45: ウィンドウスコープを使用しない場合に、 textタグ のvalueFormat属性に関する制約を追記
- s46: bom及びブランクプロジェクトのバージョン体系の変更
- s47: 新しい実行基盤のアーキタイプを追加
- s48: ブランクプロジェクト・関連ドキュメントの刷新
- s49: 共通コンポーネント用プロジェクトのサンプルの修正
- s50: メッセージ送受信処理のサンプルアプリケーションの修正
- s51: 応答不要メッセージ送受信処理のサンプルアプリケーションの修正
- s52: ブランクプロジェクトのServlet APIバージョンの変更
- s53: メッセージの取得方法の変更
- s54: 静的コンテンツの出力にNablarchを通さない変更
- s55: デフォルトで組み込むツールの変更
- s56: ウェブアプリケーションの設定値の変更
- s57: 設定値に対するコメントの記載間違い
- s58: デフォルト設定一覧の記載間違い
- s59: SQLServer用のMAIL_ATTACHED_FILEテーブルの定義の間違い
- s60: アダプタ
- s61: ルーティングアダプタを追加
- s62: JAX-RSアダプタを追加
- s63: ソースコード公開からオブジェクトコード(JAR)公開に変更
- s64: ソースコード公開からオブジェクトコード(JAR)公開に変更
- s65: Example
- s66: Exampleを追加
- s67: ETL基盤
- s68: ETLを追加
- s69: ETL Mavenプラグインを追加
- s70: Publishedアノテーションの追加
- s71: 依存関係の見直し
- s72: JavaDocの改善
- s73: 帳票ライブラリ
- s74: オブジェクトコードをリリースに追加
- s75: ワークフローライブラリ
- s76: オブジェクトコードをリリースに追加
- s77: Javadocの誤字を修正
- s78: UI開発基盤 ※既にUI開発基盤を導入済みのPJにおいては、左記の変更内容の取込をプラグイン単位で実施します。変更内容とプラグインの対応については、 「標準プラグインの変更点」シートを参照ください。
- s79: 特定端末向けパッチプラグインの注意事項を追記
- s80: UI開発基盤の導入手順を最新化
- s81: Nablarch UI開発基盤 テスト用簡易サーバーの提供形式を変更
- s82: 「Form自動生成機能」の削除
- s83: 「ローカル画面表示からドキュメントへのリンク」機能の削除
- s84: テスティングフレームワーク
- s85: BOOLEAN型/BIT型カラムのデータを投入できない不具合を修正
- s86: 不要なログの設定ファイルを削除
- s87: BigDecimal型の値が"0E-7"のような指数表現になる不具合を修正
- s88: 同期応答メッセージ送信のリクエスト単体テストにおける期待値の書き方に関する制約を追記
- s89: "(ダブルクォート)を単独でセルに記載する方法を追記
- s90: ツールボックス
- s91: toolboxのOSS版分離
- s92: Nablarch実装例集
- s93: ドメイン定義書自動生成ツールをBean Validationに対応
- s94: Nablarch開発標準
- s95: SonarQubeの設定に関する記述の変更
- s96: 開発環境構築・利用ガイドがリンクされていない
- s97: 開発プロセス支援ツールの新規提供

### X-Frame-Optoinsの設定
path: releases/releases/releases-nablarch5u6-releasenote-X-Frame-Optoinsの設定.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u6-releasenote-バージョンアップ手順.json

### メッセージ分割
path: releases/releases/releases-nablarch5u6-releasenote-メッセージ分割.json

### ■UI開発基盤（標準プラグイン）の変更点
path: releases/releases/releases-nablarch5u6-releasenote-標準プラグインの変更点.json
- s1: 特定端末向けパッチプラグインの注意事項を記載
- s2: Nablarch UI開発基盤 テスト用簡易サーバーの提供形式を変更
- s3: 「Form自動生成機能」の削除
- s4: 「ローカル画面表示からドキュメントへのリンク」機能の削除

### ■Nablarch 5u7 リリースノート
path: releases/releases/releases-nablarch5u7-releasenote-5u7.json
- s2: ResourceLocatorで発生する可能性のあるStackOverflowErrorへの対応
- s3: プリミティブ配列を値に持つMapをログにダンプできるように変更
- s4: 複数の値を出力するタグでプリミティブ配列を扱えるように修正
- s5: n:textareaで表示するデータの先頭改行が削除されないように修正
- s6: 配列要素の孫要素を出力できない問題に対応
- s7: 属性を持つ要素にコンテンツを定義できない問題に対応
- s8: BeanUtilでnullの要素を１つだけ持つプロパティの値をコピーできない不具合に対応
- s9: Interceptor.Implを公開APIに変更
- s10: nablarch-bomに定義されているnablarch-wmq-adaptorのバージョンが誤っていたので修正
- s11: モジュールのバイトコードをJava6に準拠するように修正
- s12: XML、JSONで使用可能なデータタイプ名が誤っていたので修正
- s13: 空白を含むパスを使用できない仕様を追記
- s14: テスティングフレームワーク
- s15: アクションの返すパスのアサート方法を変更

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u7-releasenote-バージョンアップ手順.json

### ■Nablarch 5u8 リリースノート
path: releases/releases/releases-nablarch5u8-releasenote-5u8.json
- s2: DatabaseRecordReaderに任意の処理を追加できる拡張ポイントを追加
- s3: セッションストアにセッション変数が存在しない場合に送出していた例外を専用例外に変更
- s4: メール送信機能のマルチプロセス化に対応
- s5: テンプレートの置き換え文字にnullが指定された場合の挙動を修正
- s6: 配列やコレクションの要素にnullが格納された場合の挙動を修正
- s7: データタイプ・コンバータの初期化時にnullが指定された場合に適切な例外を送出するように変更
- s8: 例外メッセージの不統一を修正
- s9: テスト時にコンバータの設定をデフォルトに戻せない問題に対応
- s10: 書き込み時の値にnullが指定された場合の挙動を修正
- s11: マルチレイアウトの識別項目がnullの場合の挙動を修正
- s12: required-decimal-pointディレクティブの指定が符号なし数値で有効にならない問題に対応
- s13: 固定長のバイナリ型で、出力対象のバイト長を考慮しない問題を修正
- s14: エラーメッセージに含まれるプロパティ名が誤っていた問題を修正
- s15: JSPで自動的にHTTPセッションを作成しないようにする方法を追記
- s16: マルチプロセス化の方法を追記
- s17: マルチプロセス化の方法を追記
- s18: HIDDENストアの特徴にある誤った内容を削除
- s19: デフォルト設定一覧に、メール送信バッチのマルチプロセス用カラムの設定を追加
- s20: 「現在のトランザクションとは異なるトランザクションで実行する」の実装例の誤りを修正
- s21: 文字集合の包含関係を表す図の誤りを修正
- s22: メール送信バッチをマルチプロセスで動作するように変更
- s23: メール送信バッチをマルチプロセスで動作するように変更
- s24: Example
- s25: JSPで自動的にHTTPセッションを作成しないように変更
- s26: 常駐バッチ実行時にレコードを削除しないように変更
- s27: 常駐バッチをマルチプロセスで起動しても動作するように変更
- s28: テーブルをキューとしたメッセージングをマルチプロセスで起動しても動作するように変更
- s29: Nablarch実装例集
- s30: 汎用データフォーマットの不具合対応に合わせて修正

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u8-releasenote-バージョンアップ手順.json

### ■Nablarch 5u9 リリースノート
path: releases/releases/releases-nablarch5u9-releasenote-5u9.json
- s2: ThreadLocal変数を適切に削除していない不具合を修正
- s3: BigDecimalの桁数をチェックするように変更
- s4: ノーマライズハンドラで未入力値（リクエストパラメータが空文字列だった場合）をnullに変換するように変更
- s5: バッチの起動クラスを追加
- s6: バッチの進捗状況をログに出力する機能を追加
- s7: DatabaseTableQueueReader#writeLogメソッドをオーバーライドできない不具合を修正
- s8: 運用担当者向けのログ出力を行うユーティリティを追加
- s9: システムリポジトリのロード時に出力しているログのログレベルを変更
- s10: BeanUtilで行っていたBeanの型変換をDialectで行うように修正
- s11: オブジェクトを使用したデータベースアクセス時にフィールドの値を使用する機能を追加
- s12: 集約関数を使ったSQLを実行した場合に、エラーになる可能性がある不具合を修正
- s13: IN句を使用したSQLで検索結果のキャッシュ機能が正しく動作しない不具合を修正
- s14: IN句を使用したSQLでSQLログが正しく出力されない不具合を修正
- s15: CSVデータ読込時に未入力値（空文字列）をnullに変換する機能を追加
- s16: 可変長、固定長ファイル読込時に未入力値（空文字列）をnullに変換する機能を追加
- s17: 符号付き数値のデータタイプで、指定した桁数より大きい桁数の値を出力できてしまう不具合を修正
- s18: メール送信が失敗した場合でも処理を継続するように変更
- s19: 送信日時を設定するように変更
- s20: n:form配下の要素の属性指定により、サブミット処理が正常に動作しない不具合を修正
- s21: フォーマット機能で大きな桁数の数値を表示しようとするとOutOfMemoryErrorが起こる可能性がある不具合を修正
- s22: Nablarchアプリケーションフレームワークの基本方針を追加
- s23: Nablarchとして推奨する運用設計についての記載を追加
- s24: 都度起動バッチの最小ハンドラ構成を変更
- s25: BeanUtilで精度の高い型から低い型に値を変換する際の注意点を追加
- s26: 符号付き数値文字列の符号文字の変更手順を追加
- s27: 先頭に配置すべきハンドラが複数存在していた問題を修正
- s28: UI開発基盤の解説書に制約を追加
- s29: 多言語化対応を行う際のコンポーネント定義例を修正
- s30: 別ウィンドウ/タブを開くボタン/リンクを非推奨に変更
- s31: checkstyleとfindbugsの設定を削除
- s32: maven-archetype-pluginのバージョンを固定化するようにしました
- s33: 余分な設定の削除及び記載間違いの修正
- s34: 実行基盤列の不具合
- s35: 一部の設定の不足
- s36: プロパティファイルの設定の追加
- s37: アダプタ
- s38: logアダプタを追加
- s39: ETL基盤
- s40: ETL設定の改善
- s41: 各種DB対応
- s42: ETL設定のテンプレートを追加
- s43: UI開発基盤 ※既にUI開発基盤を導入済みのPJにおいては、左記の変更内容の取込をプラグイン単位で実施します。変更内容とプラグインの対応については、 「標準プラグインの変更点」シートを参照ください。
- s44: UI開発基盤の導入手順にある「UI部品のビルドと配置」ができない不具合を修正
- s45: ツールボックス
- s46: 効率的なJava静的チェックを追加
- s47: Nablarch開発標準
- s48: システム機能設計書(画面)に画面項目の初期値を書く欄を追加
- s49: システム機能設計書(画面)から異常時の画面遷移先の欄を削除
- s50: システム機能設計書(画面)の画面名を記述する個所を削減
- s51: バリデーションの順序とバリデーションエラーの場合に後続のバリデーションを継続するかどうかを記述するよう、システム機能設計書(画面)のサンプルを変更
- s52: システム機能設計書(画面)の記述例にサブウィンドウの設計の場合の例を追加
- s53: システム機能設計書(画面)にバイナリファイルアップロードの設計書の注意点を追記
- s54: システム機能設計書(バッチ)とシステム機能設計書(メッセージ)から欄「I/O」の削除
- s55: システム機能設計書(バッチ)記載の起動パラメータとコード上のパラメータ名の対応明確化
- s56: システム機能設計書(バッチ)に、障害発生時のメッセージ指定欄を追加
- s57: システム機能設計書(メッセージ)のサンプルに、応答不要型の設計方針ガイドを追加
- s58: リクエストIDの記述を削除
- s59: ドメイン定義書にドメインと紐づく単項目バリデーションの仕様を記述できるように変更
- s60: メール設計書の埋め込み文字列の表記方法を意味を推測しやすいように変更
- s61: 外部インターフェース一覧、サブシステムインターフェース一覧 の不要な欄の削除
- s62: 外部インターフェース設計書、サブシステムインターフェース設計書にインターフェース固有のフレームワーク制御ヘッダについての記述
- s63: 外部インタフェース設計書、サブシステムインタフェース設計書の補足コメントの修正
- s64: 非推奨の排他制御機能用の設計書を削除
- s65: 非推奨の排他制御機能用の欄を削除
- s66: 二重サブミット防止の記述を削除
- s67: シート名を内容が推測しやすいものに変更
- s68: 入力される値が限定される欄の入力形式をドロップダウンリストによる入力に変更
- s69: 変更履歴シート、Excelのシート内に記述するヘッダ表の改善
- s70: Excelファイルの目次の削除
- s71: 設計ドキュメント変更内容の反映
- s72: 「取引」の説明強化
- s73: 開発プロセス支援ツールの関連情報追加
- s74: 設計書フォーマットの変更にあわせるための修正

### ETLの設定変更内容
path: releases/releases/releases-nablarch5u9-releasenote-ETLの設定変更内容.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch5u9-releasenote-バージョンアップ手順.json

### メール送信の設定変更内容
path: releases/releases/releases-nablarch5u9-releasenote-メール送信の設定変更内容.json

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
- s2: 前提
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
- s10: 補足

### コンテナ用ウェブプロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-ContainerWeb.json
- s1: 生成するプロジェクトの概要
- s2: ブランクプロジェクト作成
  - s3: mvnコマンドの実行
  - s4: プロジェクト情報の入力
- s5: 疎通確認
- s6: コンテナイメージを作成する
- s7: コンテナイメージを実行する
- s8: 補足

### コンテナ用RESTfulウェブサービスプロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-ContainerWebService.json
- s1: 事前準備
- s2: 生成するプロジェクトの概要
- s3: ブランクプロジェクト作成
  - s4: mvnコマンドの実行
- s6: 疎通確認
- s7: コンテナイメージを作成する
- s8: コンテナイメージを実行する
- s9: 補足

### Java11で使用する場合のセットアップ方法
path: setup/blank-project/blank-project-setup-Java11.json
- s1: 依存モジュールの追加
- s2: gsp-dba-maven-pluginが使用する依存モジュールの追加
- s3: 自動テストで使用するJettyのモジュール変更(ウェブプロジェクト または RESTfulウェブサービスプロジェクトの場合のみ)
- s4: Javaバージョンの変更

### Java17で使用する場合のセットアップ方法
path: setup/blank-project/blank-project-setup-Java17.json
- s1: 依存モジュールの追加
- s2: gsp-dba-maven-pluginがJava17で動くように設定する
- s3: 自動テストで使用するJettyのモジュール変更(ウェブプロジェクト または RESTfulウェブサービスプロジェクトの場合のみ)
- s4: --add-opensオプションの追加（JSR352に準拠したバッチプロジェクトの場合のみ）
- s5: Javaバージョンの変更

### Java21で使用する場合のセットアップ方法
path: setup/blank-project/blank-project-setup-Java21.json
- s1: 依存モジュールの追加
- s2: gsp-dba-maven-pluginがJava21で動くように設定する
- s3: 自動テストで使用するJettyのモジュール変更(ウェブプロジェクト または RESTfulウェブサービスプロジェクトの場合のみ)
- s4: --add-opensオプションの追加（JSR352に準拠したバッチプロジェクトの場合のみ）
- s5: 標準エンコーディングの変更（標準エンコーディングをJava17以前と同じく実行環境依存にしたい場合）
- s6: Javaバージョンの変更

### JSR352に準拠したバッチプロジェクトの初期セットアップ
path: setup/blank-project/blank-project-setup-Jbatch.json
- s1: 生成するプロジェクトの概要
- s2: ブランクプロジェクト作成
  - s3: mvnコマンドの実行
- s5: 疎通確認
  - s6: 自動テスト
  - s7: 起動テスト
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
- s15: 補足

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
- s9: 補足（web.xml）
- s10: 補足

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
- s13: 補足

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
