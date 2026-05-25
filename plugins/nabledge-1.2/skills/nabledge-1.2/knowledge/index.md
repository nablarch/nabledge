# Knowledge Index

## about/about-nablarch

### Nablarch Application Framework 概要
path: about/about-nablarch/about-nablarch-01-NablarchOutline.json
- s1: NAFのアプリケーション処理モデル
- s2: 標準ハンドラ構成
- s3: 業務アプリケーションの実装
- s4: 業務コンポーネントの責務配置
- s5: 実行コンテキストとスコープ

### 国際化対応
path: about/about-nablarch/about-nablarch-02-I18N.json
- s1: 要求
- s2: 本フレームワークの全ての機能に共通する国際化対応の実装方針
  - s3: RDBMS上データの保持方法
  - s4: 言語を指定した取得方法
  - s5: フレームワーク内で作成するログ出力メッセージの使用言語
  - s6: ファイル入出力の文字コード
- s7: Webアプリケーションに特化した国際化対応の実装方針
  - s8: 言語の選択と保持
  - s9: タイムゾーンの選択と保持
  - s10: JSPファイルおよび静的ファイルのパス

### RDBMS の使用ポリシー
path: about/about-nablarch/about-nablarch-04-RDBMS-Policy.json
- s1: RDBMS への依存の排除
  - s2: カラムの定義方法
  - s3: テーブル定義に使用するデータ型
- s4: 共通項目の更新について
- s5: フレームワークで規定するテーブルへのアクセスについて

### SqlRow等のMap実装クラスからEntityやFormを生成する方法を教えてください
path: about/about-nablarch/about-nablarch-1.json

### configファイルの設定値の取得方法を教えてください
path: about/about-nablarch/about-nablarch-2.json

### コード名称やコード存在チェック時に指定するパターンには、何を指定したらいいのでしょうか？
path: about/about-nablarch/about-nablarch-3.json

### データベースアクセスを伴う精査処理は、Actionでおこなうのでしょうか？
path: about/about-nablarch/about-nablarch-4.json

### メッセージIDと障害コードの違いは何でしょうか？
path: about/about-nablarch/about-nablarch-5.json

### DB2やSQLServerでのバイナリ型のカラムへのアクセス方法を教えてください
path: about/about-nablarch/about-nablarch-6.json

### Nablarch FAQ
path: about/about-nablarch/about-nablarch-FAQ.json
- s1: FAQ一覧

### 
path: about/about-nablarch/about-nablarch-about-nablarch-concept.json
- s1: Nablarchのコンセプト
  - s2: Robustness
  - s3: Testability
  - s4: Ready-to-Use

### 想定読者、位置付け、対象工程、注意事項
path: about/about-nablarch/about-nablarch-aboutThis.json
- s1: 想定読者
- s2: 本書の位置付け
- s3: 本書が対象とする工程
- s4: 注意事項
  - s5: 記載しているサンプルプログラムソースコードの注意事項

### Nablarchの全般的なFAQ
path: about/about-nablarch/about-nablarch-all.json

### 
path: about/about-nablarch/about-nablarch-architectural-pattern-concept.json
- s1: NAF基本アーキテクチャ
  - s2: NAFのアプリケーション動作モデル
  - s3: 標準ハンドラ構成
  - s4: アプリケーションの実行と初期化処理
  - s5: ハンドラの構造と実装
  - s6: リクエストの識別と業務処理の実行
  - s11: 処理結果の識別
  - s12: 変数スコープ
  - s14: ハンドライベントコールバック
  - s15: データリーダ
  - s16: 業務アクションハンドラの実装

### 共通方針
path: about/about-nablarch/about-nablarch-basic-policy.json

### 文字列からBigDecimal変換時に発生する可能性のあるヒープ不足について
path: about/about-nablarch/about-nablarch-bigdecimal.json

### 
path: about/about-nablarch/about-nablarch-contents.json
- s1: Nablarch の製品構成

### 業務コンポーネントの責務配置
path: about/about-nablarch/about-nablarch-determining-stereotypes.json

### 
path: about/about-nablarch/about-nablarch-development-policy.json
- s1: Nablarchの目指す姿
  - s2: lean and rapid
  - s3: long life
  - s4: mission critical
  - s5: independent
  - s6: single point of truth and multi-purpose module
  - s7: global
  - s8: testablity
  - s9: whole engineering

### ∇Nablarch ドキュメント
path: about/about-nablarch/about-nablarch-document.json

### ∇Nablarch Application Framework 解説書
path: about/about-nablarch/about-nablarch-fw.json
- s1: 目次

### Nablarch 用語集
path: about/about-nablarch/about-nablarch-glossary.json
- s1: アルファベット順
  - s2: A～G
  - s3: H～N
  - s4: O～U
  - s5: V～Z
- s6: 五十音順
  - s7: あ行
  - s8: か行
  - s9: さ行
  - s10: た行
  - s11: な行
  - s12: は行
  - s13: ま行
  - s14: や行
  - s15: ら行
  - s16: わ行

### 
path: about/about-nablarch/about-nablarch-guide.json
- s1: プログラミング・単体テストガイド
  - s2: 本書について
  - s3: Nablarchアプリケーション開発概要
  - s6: Nablarchアプリケーション開発手順
  - s7: Nablarchアプリケーション開発リファレンス

### 序 : Nablarch Application Framework (NAF)とは ?
path: about/about-nablarch/about-nablarch-introduction.json
- s1: NAFの設計思想

### NAF概要
path: about/about-nablarch/about-nablarch-overview-of-NAF.json
- s1: NAFの構成
- s2: Nablarchアプリケーション処理方式
  - s3: Nablarchアプリケーション処理方式の概要
  - s4: NAFによるNablarchアプリケーション処理方式の実装

### 動作を保証するプラットフォーム
path: about/about-nablarch/about-nablarch-platform.json
- s1: Java
- s2: アプリケーションサーバ
- s3: データベースサーバ
- s4: ブラウザ

### 
path: about/about-nablarch/about-nablarch-support-service.json
- s1: Nablarchのサポートサービスについて
  - s2: 基本サービスの内容
  - s5: オプショナルサービスの内容

### 
path: about/about-nablarch/about-nablarch-top-nablarch.json
- s1: Nablarch フォルダのコンテンツについて
  - s2: フォルダ構成
  - s3: コンテンツの見方

### 
path: about/about-nablarch/about-nablarch-top.json
- s1: Nablarch 1.2.8版
  - s2: Nablarchについて
  - s3: Nablarchのコンテンツ
  - s4: リリース情報

### 
path: about/about-nablarch/about-nablarch-versionup-policy.json
- s1: Nablarch のバージョンアップ方針
  - s2: 更新内容
  - s3: 後方互換性ポリシー
  - s7: EOSLポリシー
  - s8: バージョン番号体系
  - s14: バージョンアップ時に必要なお客様のアプリケーションへの適用作業

## component/handlers

### 
path: component/handlers/handlers-AsyncMessageReceiveAction.json
- s1: 応答不要電文受信処理用アクションハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-AsyncMessageSendAction.json
- s1: 応答不要電文送信処理用アクションハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-BatchAction.json
- s1: バッチ処理用業務アクションハンドラのテンプレートクラス
  - s2: バッチ処理用アクションハンドラのバリエーション
  - s3: 概要
  - s4: ハンドラ処理フロー

### 
path: component/handlers/handlers-DataReadHandler.json
- s1: データリードハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-DbConnectionManagementHandler.json
- s1: データベース接続管理ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-DuplicateProcessCheckHandler.json
- s1: プロセス多重起動防止ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-FileBatchAction.json
- s1: ファイル入力のバッチ業務アクションハンドラのテンプレートクラス
  - s2: 概要
  - s3: ハンドラ処理フロー

### 
path: component/handlers/handlers-FileRecordWriterDisposeHandler.json
- s1: 出力ファイル開放ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント
  - s5: 未実装機能・要望

### 
path: component/handlers/handlers-ForwardingHandler.json
- s1: 内部フォーワードハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-GlobalErrorHandler.json
- s1: グローバルエラーハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-HttpAccessLogHandler.json
- s1: HTTPアクセスログハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-HttpCharacterEncodingHandler.json
- s1: HTTP文字エンコード制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s5: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-HttpErrorHandler.json
- s1: HTTPエラー制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-HttpMethodBinding.json
- s1: 画面オンライン処理用業務アクションハンドラ
  - s2: 概要
  - s3: 業務アクションハンドラの実装内容
  - s4: 画面オンライン処理における変数スコープの利用

### 
path: component/handlers/handlers-HttpRequestJavaPackageMapping.json
- s1: HTTPリクエストディスパッチハンドラ
  - s2: 概要
  - s3: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-HttpResponseHandler.json
- s1: HTTPレスポンスハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s7: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-HttpRewriteHandler.json
- s1: HTTPリライトハンドラ
  - s2: 概要
  - s4: ハンドラ処理フロー
  - s5: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-KeitaiAccessHandler.json
- s1: 携帯端末アクセスハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-LoopHandler.json
- s1: トランザクションループ制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-Main.json
- s1: 共通起動ランチャ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: コマンドライン起動引数の扱い
  - s5: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-MessageReplyHandler.json
- s1: 電文応答制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-MessageResendHandler.json
- s1: 再送電文制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-MessagingAction.json
- s1: 同期応答電文送信処理用業務アクションハンドラのテンプレートクラス
  - s2: 概要
  - s3: ハンドラ処理フロー

### 
path: component/handlers/handlers-MessagingContextHandler.json
- s1: メッセージングコンテキスト管理ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-MultiThreadExecutionHandler.json
- s1: マルチスレッド実行制御ハンドラ
  - s2: 概要
  - s4: ハンドラ処理フロー
  - s5: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-MultipartHandler.json
- s1: マルチパートリクエストハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s5: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-NablarchServletContextListener.json
- s1: Nablarchサーブレットコンテキスト初期化リスナ
  - s2: 概要
  - s3: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-NablarchTagHandler.json
- s1: Nablarchカスタムタグ制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 改竄検知の判定について
  - s5: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-NoInputDataBatchAction.json
- s1: 入力データを使用しないバッチ処理用業務アクションハンドラのテンプレートクラス
  - s2: 概要
  - s3: ハンドラ処理フロー

### 
path: component/handlers/handlers-PermissionCheckHandler.json
- s1: 認可制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-ProcessResidentHandler.json
- s1: プロセス常駐化ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-ProcessStopHandler.json
- s1: プロセス停止制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-RequestHandlerEntry.json
- s1: リクエストハンドラエントリ
  - s2: ハンドラ処理フロー
  - s3: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-RequestPathJavaPackageMapping.json
- s1: リクエストディスパッチハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-RequestThreadLoopHandler.json
- s1: リクエストスレッド内ループ制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-ResourceMapping.json
- s1: リソースマッピングハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-RetryHandler.json
- s1: リトライ制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-ServiceAvailabilityCheckHandler.json
- s1: 開閉局制御ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-SessionConcurrentAccessHandler.json
- s1: セッション並行アクセスハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-StatusCodeConvertHandler.json
- s1: ステータスコード→プロセス終了コード変換ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-ThreadContextClearHandler.json
- s1: スレッドコンテキスト変数削除ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-ThreadContextHandler.json
- s1: スレッドコンテキスト変数管理ハンドラ
  - s2: 概要
  - s3: ハンドラ処理フロー
  - s4: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-TransactionManagementHandler.json
- s1: トランザクション制御ハンドラ
  - s2: 概要
  - s4: ハンドラ処理フロー
  - s5: 設定項目・拡張ポイント

### 
path: component/handlers/handlers-WebFrontController.json
- s1: Webフロントコントローラ (サーブレットフィルタ)
  - s2: 概要
  - s3: 処理フロー
  - s5: 設定項目・拡張ポイント

### ハンドラリファレンス
path: component/handlers/handlers-handler.json
- s1: 汎用のハンドラ
- s2: 画面オンライン処理用ハンドラ
- s3: バッチ処理用ハンドラ
- s4: メッセージング処理用ハンドラ
- s5: 業務アクションハンドラ

## component/libraries

### 障害ログの出力
path: component/libraries/libraries-01-FailureLog.json
- s1: 障害ログの出力方針
- s2: 障害ログの出力項目
- s3: 障害ログの出力方法
- s4: 障害ログの設定方法
- s5: 障害ログの出力例
- s6: 障害の連絡先情報の追加方法
- s7: アプリケーションの障害コードの変更方法
- s8: フレームワークの障害コードの変更方法
- s9: 派生元実行時情報の出力方法
- s10: プレースホルダのカスタマイズ方法

### ログ出力
path: component/libraries/libraries-01-Log.json
- s1: 概要
- s2: 特徴
  - s3: ログ出力機能の高い拡張性
  - s4: 各種ログの出力機能
- s5: 要求
  - s6: 実装済み
  - s7: 未実装
  - s8: 未検討
- s9: ログ出力要求受付処理
  - s10: クラス図
  - s14: ログレベルの定義
  - s15: ログ出力
  - s16: 初期処理と終了処理
  - s17: ロガーファクトリの設定方法
- s18: 書き込み処理とフォーマット処理
  - s19: クラス図
  - s24: フレームワーク実装の設定方法
  - s27: ログライタの使用方法
  - s33: ログフォーマッタの使用方法
  - s41: カスタマイズ方法
- s45: プロパティファイルの記述ルール
  - s46: ロガーファクトリの設定
  - s47: フレームワーク実装の設定
- s53: 各種ログの出力
  - s54: ログの種類
  - s55: 各種ログの共通項目のフォーマット
  - s56: 各種ログの設定
- s57: フレームワークのログ出力方針

### 
path: component/libraries/libraries-02-01-Repository-config.json
- s1: 設定ファイルの種類とフレームワークが行うリポジトリの初期化
- s2: 環境設定ファイルからの読み込み
  - s3: 読み込む環境設定ファイル(sample.config)の記述例
  - s4: 環境設定ファイルの読み込み (通常フレームワークの責務)
  - s5: 環境設定の取得
- s6: リポジトリに保持するインスタンスの生成(DIコンテナ)
  - s7: 登録するクラスのソースコード(HelloMessageProvider)
  - s8: 登録するクラスのソースコード(HelloComponent)
  - s9: コンポーネント設定ファイルの記述(hello.xml)
  - s10: 値を取得する実装例
- s11: DIコンテナを ObjectLoader として使用する
  - s12: SystemRepository の初期化処理
  - s13: SystemRepository からのコンポーネント取得
- s14: property 要素の value 属性で設定できる型
  - s15: インジェクション対象のクラス
  - s16: コンポーネント設定ファイル
  - s17: コンポーネントを取得する実装例
- s18: List と Map をコンポーネントとして登録する
  - s19: list 要素の使用方法
  - s20: map 要素の使用方法
- s21: コンポーネント設定ファイルからの環境設定ファイル読み込み
  - s22: 読み込む環境設定ファイル(hello.config)
  - s23: コンポーネント設定ファイル
  - s24: 設定した値を取得する実装例
- s25: 複数のコンポーネント設定ファイルの読み込み
  - s26: 読み込まれるコンポーネント設定ファイル(imported1.xml)
  - s27: 読み込まれるコンポーネント設定ファイル(imported2.xml)
  - s28: imported1.xmlとimported2.xmlを読み込むコンポーネント設定ファイル
  - s29: 設定した値を取得する実装例
- s30: 環境設定ファイルに記述した値をコンポーネント設定ファイルで使用する
  - s31: 読み込む環境設定ファイル(hello.config)
  - s32: コンポーネント設定ファイル
  - s33: 設定した値を取得する実装例
  - s34: 使用できる項目
- s35: ディレクトリに配置された設定ファイルの読み込み
  - s36: コンポーネント設定ファイル
- s37: 自動インジェクション
  - s38: Helloメッセージを取得するインタフェース
  - s39: Helloメッセージを取得するインタフェースを実装したクラス
  - s40: Helloメッセージを取得するインタフェースを使用するクラス
  - s41: 設定例
  - s42: 設定したコンポーネントの取得例
- s43: ネストするコンポーネントの設定
  - s44: コンポーネント設定ファイル
  - s45: 設定したコンポーネントの取得例
- s46: 環境設定ファイル記述ルール
  - s47: デリミタ文字（'='）
  - s48: コメント文字（'#'）
  - s49: 改行文字（'\'）
  - s50: エスケープ文字（'\'）
- s51: コンポーネント設定ファイル 要素 リファレンス
  - s52: component-configuration 要素
  - s53: import 要素
  - s54: config-file 要素
  - s55: component 要素
  - s56: property 要素
  - s57: list 要素
  - s58: component-ref 要素
  - s59: value 要素
  - s60: map 要素
  - s61: entry 要素
  - s62: key-component 要素
  - s63: value-component 要素

### 
path: component/libraries/libraries-02-02-Repository-initialize.json
- s1: 初期化処理の使用手順
- s2: 初期化対象クラスの定義
- s3: コンポーネント設定ファイルの定義
- s4: 設定項目

### 
path: component/libraries/libraries-02-03-Repository-factory.json
- s1: ファクトリーインジェクションの使用手順
- s2: ファクトリークラスの実装例
- s3: コンポーネント設定ファイル
- s4: 使用例

### 
path: component/libraries/libraries-02-04-Repository-override.json
- s1: 設定値の上書きの対象
- s2: 環境設定ファイルに記述した文字列の設定値の上書き
  - s3: 環境設定ファイル(test1.conf)
  - s4: 環境設定ファイル(test2.conf)
  - s5: コンポーネント設定ファイルを読み込む
  - s6: 設定値の取得例
- s7: コンポーネントのプロパティの上書き
  - s8: 使用するクラス
  - s9: コンポーネント設定ファイルの例
  - s10: 設定したコンポーネントの取得例
- s11: コンポーネントのクラスの上書き
  - s12: 読み込み元の設定ファイル
  - s13: テスト用の設定ファイル(/opt/testconfig/testconfig.xml)
- s14: import 要素および config-file 要素による外部ファイル読み込み時の優先順位
  - s15: import-example1.xml
  - s16: import-example2.xml
  - s17: onefile-example.xml(import-example1.xml、import-example2.xmlと等価)
- s18: dir 属性を使用した読み込み時の優先順位
- s19: 設定値の上書き時の動作設定
  - s20: 設定をロードする際の実装例(通常フレームワークのブートストラップ処理で行う)
- s21: システムプロパティによる設定値の上書き
  - s22: 環境設定ファイル(hello-system-property.config)
  - s23: コンポーネント設定ファイル(hello-system-property.xml)
  - s24: 設定値のロードの実装例
  - s25: 設定したコンポーネントを取得する実装例

### コード管理
path: component/libraries/libraries-02-CodeManager.json
- s1: 概要
- s2: 特徴
  - s3: 国際化
  - s4: パターン指定によるコード値の取得
  - s5: 高速なコードへのアクセス
- s6: 要求
  - s7: 実装済み
  - s8: 未検討
- s9: 構造
  - s10: クラス図
  - s13: テーブル定義
- s17: コード値とコード名称のデータ
- s18: コード名称の取得
- s19: コード値の取得
- s20: コード値の有効性チェック
- s21: コード値のパターン
- s22: 設定方法
  - s23: 設定ファイル例
  - s24: 設定内容詳細
- s30: コード値の有効性をチェックするバリデーション
  - s31: エンティティの実装
  - s32: Validatorの設定
  - s33: 設定内容詳細

### リポジトリ
path: component/libraries/libraries-02-Repository.json
- s1: 概要
- s2: 特徴
  - s3: DIコンテナによるコンポーネントの構築
  - s4: リポジトリとDIコンテナの分離
  - s5: DIコンテナに登録したコンポーネントの初期化機能
- s6: 要求
  - s7: 実装済み
  - s8: 未検討
- s9: 構成
  - s10: クラス図
- s13: リポジトリの設定方法と使用方法
- s14: コンポーネント初期化機能
- s15: ファクトリインジェクション
- s16: 設定の上書き

### SQLログの出力
path: component/libraries/libraries-02-SqlLog.json
- s1: SQLログの出力方針
- s2: SQLログの出力項目
  - s3: SqlPStatement#retrieveメソッドの検索開始時
  - s4: SqlPStatement#retrieveメソッドの検索終了時
  - s5: SqlPStatement#executeメソッドの実行開始時
  - s6: SqlPStatement#executeメソッドの実行終了時
  - s7: SqlPStatement#executeQueryメソッドの検索開始時
  - s8: SqlPStatement#executeQueryメソッドの検索終了時
  - s9: SqlPStatement#executeUpdateメソッドの更新開始時
  - s10: SqlPStatement#executeUpdateメソッドの更新終了時
  - s11: SqlPStatement#executeBatchメソッドの更新開始時
  - s12: SqlPStatement#executeBatchメソッドの更新終了時
- s13: SQLログの出力方法
  - s14: SqlPStatement#retrieveメソッドの検索開始時
  - s15: SqlPStatement#retrieveメソッドの検索終了時
  - s16: SqlPStatement#executeメソッドの実行開始時
  - s17: SqlPStatement#executeメソッドの実行終了時
  - s18: SqlPStatement#executeQueryメソッドの検索開始時
  - s19: SqlPStatement#executeQueryメソッドの検索終了時
  - s20: SqlPStatement#executeUpdateメソッドの更新開始時
  - s21: SqlPStatement#executeUpdateメソッドの更新終了時
  - s22: SqlPStatement#executeBatchメソッドの更新開始時
  - s23: SqlPStatement#executeBatchメソッドの更新終了時
- s24: SQLログの出力例

### パフォーマンスログの出力
path: component/libraries/libraries-03-PerformanceLog.json
- s1: パフォーマンスログの出力方針
- s2: パフォーマンスログの出力項目
- s3: パフォーマンスログの出力方法
  - s4: パフォーマンスログの出力例

### トランザクション管理
path: component/libraries/libraries-03-TransactionManager.json
- s1: 概要
- s2: 特徴
  - s3: 任意のリソースに対するトランザクション制御を追加可能
  - s4: 分散トランザクション機能(未実装機能)
- s5: 要求
  - s6: 実装済み
  - s7: 未実装
- s8: 構造
  - s9: クラス図
- s13: 使用例
  - s14: データベースに対するトランザクション管理

### データベース接続部品の構造
path: component/libraries/libraries-04-Connection.json
- s1: クラス図
  - s2: 各クラスの責務
- s6: トランザクション制御、データベースアクセスの使用例
  - s7: 処理シーケンス
  - s8: Javaの実装例
- s9: 設定ファイル例(DataSourceを使用してデータベース接続を行う場合)
  - s10: 設定内容詳細
- s14: 設定ファイル例(JNDIを使用してデータベース接続を行う場合)
  - s15: 設定内容詳細

### データベースアクセス(検索、更新、登録、削除)機能
path: component/libraries/libraries-04-DbAccessSpec.json
- s1: 概要
- s2: 特徴
  - s3: JDBCのAPIを踏襲した機能
  - s4: 頻繁に使用するデータベースリソースの自動解放機能
  - s5: SQL文の実行ログ(以降SQLログ)の出力する機能
  - s6: 件数指定でデータを取得(簡易検索機能)できる機能
  - s7: Javaオブジェクトのフィールドの値を容易にデータベースに登録できる機能
  - s8: LIKE検索を簡易的に実装出来る機能
  - s9: 条件が可変のSQL文を組み立てる機能
  - s10: データベーストランザクションのタイムアウト機能
- s11: 注意点
  - s12: データベース接続のプール機能について
  - s13: SQLインジェクション対策について
- s14: 要求
  - s15: 実装済み
  - s16: 未実装
- s17: 全体構造
  - s18: クラス図
- s19: 各機能単位の構造

### HTTPアクセスログの出力
path: component/libraries/libraries-04-HttpAccessLog.json
- s1: HTTPアクセスログの出力方針
- s2: HTTPアクセスログの出力項目
- s3: HTTPアクセスログの出力方法
- s4: HTTPアクセスログの設定方法
  - s5: リクエスト処理開始時のログ出力に使用するフォーマット
  - s6: hiddenパラメータ復号後のログ出力に使用するフォーマット
  - s7: ディスパッチ先クラス決定後のログ出力に使用するフォーマット
  - s8: リクエスト処理終了時のログ出力に使用するフォーマット
- s9: HTTPアクセスログの出力例

### オブジェクトのフィールドの値のデータベースへの登録機能(オブジェクトのフィールド値を使用した検索機能)
path: component/libraries/libraries-04-ObjectSave.json
- s1: クラス図
  - s2: 各クラスの責務
- s8: 使用例
  - s9: 処理シーケンス
  - s11: Java実装例(Objectのフィールド値を登録する場合)
- s12: 設定ファイル例
  - s13: 設定内容詳細

### 認可
path: component/libraries/libraries-04-Permission.json
- s1: 概要
- s2: 特徴
  - s3: グループ単位とユーザ単位を併用した権限設定
  - s4: 自由度の高いテーブル定義
- s5: 要求
  - s6: 実装済み
  - s7: 未実装
  - s8: 未検討
- s9: 構成
  - s10: 概念モデル
  - s11: クラス図
  - s15: シーケンス図
  - s16: テーブル定義
- s25: 使用方法
  - s26: BasicPermissionFactoryの設定方法
  - s36: 特定のリクエストIDを認可判定の対象から除外する方法
  - s37: 使用例

### SQL文実行部品の構造とその使用方法
path: component/libraries/libraries-04-Statement.json
- s1: クラス図
  - s2: 各クラスの責務
- s7: 使用例
  - s8: 簡易検索の場合の処理シーケンス
  - s10: 推奨するJavaの実装例(SQL文を外部ファイル化した場合)
  - s11: Javaの実装例(SQL文指定の場合)
- s12: 設定ファイル例
  - s13: 設定内容詳細

### データベースコネクション名とトランザクション名
path: component/libraries/libraries-04-TransactionConnectionName.json
- s1: データベースコネクション名
  - s2: データベースコネクション名の使用例
- s3: トランザクション名
  - s4: トランザクション名の使用例
  - s5: JdbcTransactionを使用した場合のトランザクション名とデータベースコネクション名の関係

### トランザクションタイムアウト機能
path: component/libraries/libraries-04-TransactionTimeout.json
- s1: 処理シーケンス
  - s2: 各処理の概要
- s3: トランザクションタイムアウトを使用するための設定
- s4: 注意点
  - s5: クエリタイムアウト時の動作について
  - s6: アプリケーションロジックでの処理遅延について

### ファイルダウンロード
path: component/libraries/libraries-05-FileDownload.json
- s1: 概要
- s2: 特徴
  - s3: 実装の容易性
  - s4: サイズが大きいファイルをダウンロードする場合でもメモリリソースを圧迫しない
- s5: 要求
  - s6: 実装済み
  - s7: 未実装
- s8: 構成
  - s9: クラス図
  - s10: 各クラスの責務
  - s13: クラス詳細
  - s15: シーケンス図
- s16: 設定の記述
  - s17: HTTPレスポンスの設定
  - s20: ファイル名のエンコーダの設定の記述
- s27: 使用例

### 開閉局
path: component/libraries/libraries-05-ServiceAvailability.json
- s1: 概要
  - s2: 概要図
- s3: 特徴
- s4: 要求
  - s5: 実装済み
  - s6: 未実装
  - s7: 未検討
  - s8: 取り下げ
- s9: 構成
  - s10: クラス図
  - s11: 各クラスの責務
  - s14: シーケンス図
  - s17: テーブル定義の例
- s19: 設定の記述
  - s20: 全処理方式共通

### 静的データのキャッシュ
path: component/libraries/libraries-05-StaticDataCache.json
- s1: 概要
- s2: 特徴
  - s3: 静的データキャッシュの実装負荷軽減
  - s4: インデックス機能
- s5: 要求
  - s6: 実装済み
  - s7: 未検討
- s8: 構成
  - s9: クラス図
- s12: キャッシュした静的データの取得
  - s13: IDを指定した静的データの取得
  - s16: インデックスを使用した静的データの取得
- s17: キャッシュにデータをロードする方法
  - s18: オンデマンドロード
  - s19: 一括ロード
- s20: オンデマンドロードの使用方法
  - s21: IDを指定してデータを取得する際に必要なデータロードの実装方法
  - s24: インデックスを指定してデータを取得する際に必要なデータロードの実装方法
- s25: 一括ロード
  - s26: データロードの実装方法
  - s28: 設定例
- s29: 設定内容詳細
  - s30: nablarch.core.cache.BasicStaticDataCacheの設定
- s31: 静的データの再読み込み
  - s32: 実装例

### ファイルアップロード
path: component/libraries/libraries-06-FileUpload.json
- s1: 概要
- s2: ファイルアップロード機能に関する設定
- s3: アプリケーション実装方法

### 採番機能
path: component/libraries/libraries-06-IdGenerator.json
- s1: 概要
- s2: 特徴
  - s3: 採番方法を選択可能
  - s4: 採番した値をフォーマット出来る機能
- s5: 要求
  - s6: 実装済み
  - s7: 未実装機能
- s8: 構造
  - s9: クラス図
  - s10: 各クラスの責務
- s13: テーブルを使用した採番機能
  - s14: 採番テーブルの構造
  - s15: シーケンス図
  - s18: 使用例

### 日付の管理機能
path: component/libraries/libraries-06-SystemTimeProvider.json
- s1: 概要
- s2: 特徴
  - s3: 高い拡張性
  - s4: 業務日付は複数設定が可能
- s5: 要求
  - s6: 実装済み
  - s7: 未実装
- s8: 構造
  - s9: システム日時機能
  - s14: 業務日付機能
- s27: 日付ユーティリティ

### 
path: component/libraries/libraries-07-BasicRules.json
- s1: 命名ルール
- s2: taglibディレクティブの指定方法
- s3: URIの指定方法
- s4: HTMLエスケープと改行、半角スペース変換
  - s5: HTMLエスケープ
  - s6: 改行、半角スペース変換
  - s7: HTMLエスケープせずに値を出力する方法
- s8: 言語毎のリソースパスの切り替え
- s9: 静的コンテンツのクライアント側でのキャッシュについて

### JSPカスタムタグライブラリの使用方法
path: component/libraries/libraries-07-CustomTag.json
- s1: 解説に使用する実装例の説明
  - s2: ユーザ登録機能の画面遷移
  - s3: ディスパッチャの設定
  - s4: アクションのシグネチャ
- s5: カスタムタグ全体に関わる仕様
- s6: カスタムタグごとの仕様
  - s7: 入力に関するカスタムタグ
  - s8: 表示に関するカスタムタグ
  - s9: フォームのサブミット制御に関するカスタムタグ
  - s10: アプリケーション開発を容易にするカスタムタグ
  - s11: その他のカスタムタグ

### 
path: component/libraries/libraries-07-DisplayTag.json
- s1: 値のフォーマット出力
  - s2: フォーマット出力の使用例
  - s3: アプリケーションでのフォーマットの変更方法
- s4: エラー表示
  - s5: errorsタグ
  - s6: errorタグ
  - s7: エラーの原因となった入力項目のハイライト表示
- s9: コード値の表示
  - s10: codeSelectタグ、codeRadiobuttonsタグ、codeCheckboxesタグ、codeタグ
  - s12: codeRadiobuttonsタグ、codeCheckboxesタグ
  - s13: codeSelectタグ
  - s14: codeタグ
  - s15: codeCheckboxタグ
- s16: メッセージの表示

### 
path: component/libraries/libraries-07-FacilitateTag.json
- s1: 検索結果の一覧表示
  - s2: 検索結果の一覧表示の全体構造
  - s3: DbAccessSupportクラス
  - s4: ListSearchInfoクラス
  - s5: listSearchResultタグ
  - s10: 検索結果の並び替え
  - s13: 1画面にすべての検索結果を一覧表示する場合の実装方法
  - s14: 検索結果の一覧表示機能のデフォルト値設定
  - s15: 検索結果の一覧表示機能の画面表示のカスタマイズ方法
- s16: 入力画面と確認画面の共通化をサポートするカスタムタグ
  - s17: 入力画面と確認画面の表示切り替え
  - s21: 確認画面での入力項目の表示

### 
path: component/libraries/libraries-07-FormTag.json
- s1: 入力フォームのname属性
  - s2: エンティティのプロパティにアクセスする場合の実装例
  - s3: Listのプロパティにアクセスする場合の実装例
- s4: 入力データの保持
  - s5: windowScopePrefixes属性の使用方法
  - s6: 複数画面に跨る画面遷移時のwindowScopePrefixes属性の指定方法
  - s7: アクションの実装方法
- s8: hiddenタグの暗号化
  - s9: hiddenタグの暗号化機能の処理イメージ
  - s10: hiddenタグの暗号化機能の設定
  - s11: hiddenの暗号化処理
  - s12: hiddenの復号処理
- s13: 入力データの復元
- s14: 入力項目の確認画面用の出力
  - s15: textタグの出力例
  - s16: passwordタグの出力例
  - s17: selectタグの出力例

### フォーム内の入力要素を出力するカスタムタグ
path: component/libraries/libraries-07-FormTagList.json
- s1: passwordタグ
- s2: radioButtonタグ
- s3: checkboxタグ
- s4: compositeKeyRadioButtonタグ、compositeKeyCheckboxタグ
- s5: List型変数に対応するカスタムタグの共通属性
- s6: radioButtonsタグ、checkboxesタグ
- s7: selectタグ

### カスタムタグライブラリに関する設定
path: component/libraries/libraries-07-HowToSettingCustomTag.json
- s1: NablarchTagHandlerの設定
- s2: カスタムタグのデフォルト値の設定

### メッセージ管理
path: component/libraries/libraries-07-Message.json
- s1: 概要
- s2: 特徴
  - s3: メッセージの取得
  - s4: 国際化
  - s5: メッセージのフォーマット
  - s6: メッセージのキャッシュ
- s7: 要求
  - s8: 実装済み
- s9: 構造
  - s10: クラス図
  - s11: インタフェース定義
  - s12: クラス定義
  - s13: テーブル定義
- s16: メッセージの取得
- s17: メッセージのフォーマット
  - s18: メッセージテーブル
  - s19: 実装例
- s20: 国際化
  - s21: メッセージテーブル
  - s22: 実装例
- s23: オプションパラメータの国際化
  - s24: メッセージテーブル
  - s25: StringResourceを使用する実装例
  - s26: Messageを使用する実装例
- s27: 例外によるメッセージの通知
  - s28: 例外を送出するクラス
  - s29: 例外からエラーメッセージを受けとるクラス。
- s30: 設定の記述
  - s31: 設定ファイル例
  - s32: 設定内容詳細

### 変数に値を設定するsetタグ
path: component/libraries/libraries-07-OtherTag.json

### 
path: component/libraries/libraries-07-SubmitTag.json
- s1: ボタン又はリンクによるフォームのサブミット
  - s2: サブミット先の指定方法
  - s3: サブミットを制御するJavaScript関数
  - s4: アプリケーションでonclick属性を指定する場合の制約
  - s5: アプリケーションでformタグのname属性を指定する場合の制約
  - s6: ボタン又はリンク毎にパラメータを変更する方法
  - s7: 認可判定と開閉局判定の結果に応じた表示切り替え
  - s8: 複数ウィンドウを立ち上げる方法
  - s9: ファイルダウンロードの実現方法
- s10: 二重サブミットの防止
  - s11: リクエストの二重送信防止
  - s12: 処理済みリクエストの受信防止
- s13: ブラウザのキャッシュ防止

### タグリファレンス
path: component/libraries/libraries-07-TagReference.json
- s1: カスタムタグ一覧
- s2: 共通属性
  - s3: 全てのHTMLタグ
  - s4: フォーカスを取得可能なHTMLタグ
- s5: 個別属性
  - s6: formタグ
  - s7: textタグ
  - s8: textareaタグ
  - s9: passwordタグ
  - s10: radioButtonタグ
  - s11: checkboxタグ
  - s12: compositeKeyCheckboxタグ
  - s13: compositeKeyRadioButtonタグ
  - s14: fileタグ
  - s15: hiddenタグ
  - s16: plainHiddenタグ
  - s17: selectタグ
  - s18: radioButtonsタグ
  - s19: checkboxesタグ
  - s20: submitタグ
  - s21: buttonタグ
  - s22: submitLinkタグ
  - s23: popupSubmitタグ
  - s24: popupButtonタグ
  - s25: popupLinkタグ
  - s26: downloadSubmitタグ
  - s27: downloadButtonタグ
  - s28: downloadLinkタグ
  - s29: paramタグ
  - s30: changeParamNameタグ
  - s31: aタグ
  - s32: imgタグ
  - s33: linkタグ
  - s34: scriptタグ
  - s35: errorsタグ
  - s36: errorタグ
  - s37: noCacheタグ
  - s38: codeSelectタグ
  - s39: codeRadioButtonsタグ
  - s40: codeCheckboxesタグ
  - s41: codeCheckboxタグ
  - s42: codeタグ
  - s43: messageタグ
  - s44: listSearchResultタグ
  - s45: listSearchSortSubmitタグ
  - s46: writeタグ
  - s47: prettyPrintタグ
  - s48: rawWriteタグ
  - s50: includeタグ
  - s51: includeParamタグ
  - s52: confirmationPageタグ
  - s53: ignoreConfirmationタグ
  - s54: forInputPageタグ
  - s55: forConfirmationPageタグ

### JSPカスタムタグライブラリ
path: component/libraries/libraries-07-WebView.json
- s1: 概要
- s2: 特徴
  - s3: 生産性の向上
  - s4: 画面設計の柔軟性
- s5: 要求
  - s6: 実装済み
  - s7: 未実装
  - s8: 未検討
  - s9: 取り下げ
- s10: カスタムタグライブラリの使用方法
- s11: タグリファレンス
- s12: カスタムタグライブラリに関する設定

### バリデーション機能の構造
path: component/libraries/libraries-08-01-validation-architecture.json
- s1: クラス図
  - s2: インタフェース定義
  - s3: クラス定義
- s4: バリデーションの処理の流れ
- s5: 設定例
- s6: 設定内容詳細
  - s7: nablarch.core.validation.ValidationManager の設定

### バリデーション機能の基本的な使用方法
path: component/libraries/libraries-08-02-validation-usage.json
- s1: バリデーションの実行と入力値の変換
  - s2: Formの実装
  - s3: Action からのバリデーションメソッドの呼び出し
  - s4: バリデーション結果のエラーメッセージ生成
- s5: Entity の使用
  - s6: テーブル構造とEntity
- s7: バリデーション対象のプロパティ指定
- s8: 1つのForm内の複数項目にまたがる入力チェック
- s9: 値の変換
- s10: 入力値のトリム
  - s11: 様々なMapオブジェクトの精査と変換
- s13: プロパティに紐付くメッセージの作成

### 階層構造を持つFormのバリデーション
path: component/libraries/libraries-08-03-validation-recursive.json
- s1: 複数の Form に対するバリデーション
- s2: Form の配列を入力する際のバリデーション
  - s3: Form の実装
  - s4: JSPファイル の実装
  - s5: Action の実装
- s6: 可変配列長の Form 配列を入力する際の実装例
  - s7: Form の実装
  - s8: JSPの実装
- s9: 画面入力用プロパティとデータベースアクセス用プロパティの変換

### 
path: component/libraries/libraries-08-04-validation-form-inheritance.json
- s1: Form の継承とバリデーション条件の継承
- s2: 国際化したプロパティの表示名称の取得方法
  - s3: @PropertyName の messageId 属性を使用する方法
  - s4: プロパティ名に対応する表示名称を使用する方法
  - s5: 2つの方法の選択基準

### バリデータの追加・変更
path: component/libraries/libraries-08-05-custom-validator.json
- s1: アノテーションの作成
- s2: バリデータの作成
- s3: バリデータを設定ファイルに登録
- s4: バリデータを明示的に呼び出す場合

### バリデータの明示的な呼び出し
path: component/libraries/libraries-08-06-direct-call-of-validators.json

### 排他制御機能
path: component/libraries/libraries-08-ExclusiveControl.json
- s1: 概要
- s2: 特徴
  - s3: 排他制御の実装負荷軽減
- s4: 要求
  - s5: 実装済み
- s6: 排他制御の実現方法
  - s7: 排他制御用テーブル
  - s8: 悲観的ロックと楽観的ロックの動作イメージ
- s9: 構造
  - s10: クラス図
  - s11: 各クラスの責務
- s14: 悲観的ロック
- s15: 楽観的ロック
  - s16: シーケンス図
  - s17: 使用例

### バリデーションとFormの生成
path: component/libraries/libraries-08-Validation.json
- s1: 概要
- s2: 特徴
  - s3: アノテーションによる条件の記述
  - s4: メッセージ機能を使用
- s5: 要求
  - s6: 実装済み
  - s7: 未実装
  - s8: 未検討

### 数値型項目の場合の桁数精査の方法を教えて下さい
path: component/libraries/libraries-1.json

### 精査エラーのメッセージを、任意の項目に対応させて画面表示させる方法を教えてください
path: component/libraries/libraries-2.json

### カンマ編集された値を数値型として精査することは出来ますか?
path: component/libraries/libraries-3.json

### ユーティリティ
path: component/libraries/libraries-99-Utility.json
- s1: 日付ユーティリティ
  - s2: クラス概要
  - s3: 機能一覧

### 入力値のバリデーション
path: component/libraries/libraries-core-library-validation.json

### 
path: component/libraries/libraries-enterprise-messaging.json
- s1: システム間メッセージング機能
  - s2: 全体構成
  - s3: 基本概念
  - s4: メッセージング基盤API
  - s5: メッセージングプロバイダ

### 
path: component/libraries/libraries-file-access.json
- s1: ファイルアクセス機能
  - s2: 論理パス
  - s4: ファイルアクセスAPI

### ファイルアップロード業務処理用ユーティリティ
path: component/libraries/libraries-file-upload-utility.json
- s1: 概要
- s2: 要求
  - s3: 実装済み
  - s4: 未実装機能
- s5: 特徴
- s6: 構造
  - s7: クラス図
  - s9: シーケンス図
- s10: 使用方法
  - s11: ファイルを一時ディレクトリから移動する
  - s12: ファイルをバイナリとして読み込む
  - s13: ファイルをデータベースに登録する

### メール送信
path: component/libraries/libraries-mail.json
- s1: 概要
- s2: 構造
  - s3: クラス図
  - s4: 各クラスの責務
  - s11: テーブル定義
- s16: メール送信要求API
  - s17: メール送信要求
  - s18: メール送信要求実装例
- s19: 逐次メール送信バッチ
- s20: 設定の記述
  - s21: 共通設定項目
  - s24: メール送信要求API用設定項目
  - s27: 逐次メール送信バッチ用設定項目
- s30: 設定項目詳細
  - s31: nablarch.common.mail.MailRequestTableの設定
  - s32: nablarch.common.mail.MailRecipientTableの設定(全て必須)
  - s33: nablarch.common.mail.MailAttachedFileTableの設定(すべて必須)
  - s34: nablarch.common.mail.MailTemplateTableの設定(すべて必須)
  - s35: nablarch.common.mail.MailConfigの設定
  - s36: nablarch.common.mail.MailRequestConfigの設定(すべて必須)
  - s37: nablarch.common.mail.MailSessionConfigの設定

### 
path: component/libraries/libraries-messaging-sender-util.json
- s1: 同期応答メッセージ送信ユーティリティ
  - s2: 使用方法
  - s3: 設定項目

### 
path: component/libraries/libraries-messaging-sending-batch.json
- s1: 応答不要メッセージ送信常駐バッチ
  - s2: 基本構造
  - s3: 標準ハンドラ構成と主要処理フロー

### 
path: component/libraries/libraries-record-format.json
- s1: 汎用データフォーマット機能
  - s2: 基本構造
  - s3: 使用例
  - s4: フォーマット定義ファイルの書式
  - s5: マルチフォーマット形式の利用
  - s6: フィールドタイプ・フィールドコンバータ定義一覧
  - s7: 可変長ファイルにおけるタイトル行の読み書き

### 同一スレッド内でのデータ共有(スレッドコンテキスト)
path: component/libraries/libraries-thread-context.json
- s1: クラス図
  - s2: インタフェース定義
  - s3: クラス定義
- s4: 使用方法
- s5: RequestIdAttribute
- s6: InternalRequestIdAttribute
- s7: UserIdAttribute
- s8: LanguageAttribute
- s9: TimeZoneAttribute
- s10: ExecutionIdAttribute
- s11: 設定例
- s12: 設定の記述
  - s13: ThreadContextHandlerの設定
  - s14: UserIdAttributeの設定
  - s15: RequestIdAttributeの設定
  - s16: InternalRequestIdAttributeの設定
  - s17: LanguageAttributeの設定
  - s18: TimeZoneAttributeの設定
  - s19: ExecutionIdAttributeの設定

### 拡張バリデータ・コンバータ
path: component/libraries/libraries-validation-advanced-validators.json
- s1: 年月日コンバータ
  - s2: 精査仕様
  - s3: 変換仕様
  - s4: 実装例
- s5: 年月コンバータ
  - s6: 精査仕様
  - s7: 変換仕様
  - s8: 実装例

### 
path: component/libraries/libraries-validation-basic-validators.json
- s1: 基本バリデータ・コンバータ
  - s2: 基本バリデータ・コンバータ一覧
  - s3: システム許容文字のバリデーション
  - s13: 基本コンバータ、バリデータの設定値

### バリデーションに関するFAQ
path: component/libraries/libraries-validation-index.json

## component/readers

### データベースレコードリーダ
path: component/readers/readers-DatabaseRecordReader.json

### ファイルデータリーダ
path: component/readers/readers-FileDataReader.json

### 要求電文(FWヘッダ)リーダ
path: component/readers/readers-FwHeaderReader.json

### 受信電文リーダ
path: component/readers/readers-MessageReader.json

### 
path: component/readers/readers-ResumeDataReader.json
- s1: レジュームデータリーダ
  - s2: 設定項目

### 
path: component/readers/readers-ValidatableFileDataReader.json
- s1: 事前精査機能付きファイルデータリーダ
  - s2: 事前精査処理の実装例

### データリーダリファレンス
path: component/readers/readers-reader.json

## development-tools/java-static-analysis

### JSP静的解析ツール
path: development-tools/java-static-analysis/java-static-analysis-01-JspStaticAnalysis.json
- s1: 概要
- s2: 仕様
- s3: 前提条件
- s4: 使用方法
  - s5: 設定ファイルの準備
  - s6: JSP静的解析ツール設定ファイルの記述方法
  - s7: 実行方法
  - s8: 出力結果確認方法

### JSP静的解析ツール インストールガイド
path: development-tools/java-static-analysis/java-static-analysis-02-JspStaticAnalysisInstall.json
- s1: 前提条件
- s2: インストール
- s3: ツール構成
- s4: プロパティファイルの書き換え
- s5: Eclipseとの連携設定
  - s6: Antビュー起動
  - s7: ビルドファイル登録

### JSP静的解析ツール
path: development-tools/java-static-analysis/java-static-analysis-04-JspStaticAnalysis.json

### Java静的解析ツール
path: development-tools/java-static-analysis/java-static-analysis-05-JavaStaticAnalysis.json

### 使用不許可APIチェックツール
path: development-tools/java-static-analysis/java-static-analysis-UnpublishedApi.json
- s1: 概要
- s2: 前提条件
- s3: 仕様
  - s4: 継承・インタフェース実装に関するチェック仕様
- s5: 設定ファイル
  - s6: 設定ファイル配置方法
  - s7: 設定ファイル記述方法
- s8: Eclipse Pluginとして使用
- s9: FindBugsのAntタスクとして使用

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
  - s15: セルへの特殊な記述方法
- s16: 注意事項
  - s17: テストメソッドの実行順序に依存しないテストを作成する
  - s18: テストデータは全てExcelシートに記述する

### クラス単体テストの実施方法
path: development-tools/testing-framework/testing-framework-01-ClassUnitTest.json

### 単体テスト概要
path: development-tools/testing-framework/testing-framework-01-UnitTestOutline.json
- s1: 単体テスト方法
  - s2: クラス単体テスト概要
  - s3: リクエスト単体テスト概要
  - s9: 取引単体テスト概要

### Form/Entityのクラス単体テスト
path: development-tools/testing-framework/testing-framework-01-entityUnitTest.json
- s1: Form/Entity単体テストの書き方
  - s2: テストデータの作成
  - s3: テストクラスの作成
  - s4: 文字種と文字列長の単項目精査テストケース
  - s7: その他の単項目精査のテストケース
  - s10: バリデーションメソッドのテストケース
  - s16: コンストラクタに対するテストケース
  - s18: setter、getterに対するテストケース
  - s20: プロパティ名の一覧を簡易的に取得する手順
  - s21: 自動テストフレームワーク設定値

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

### Componentのクラス単体テスト
path: development-tools/testing-framework/testing-framework-02-componentUnitTest.json
- s1: Component単体テストの書き方
  - s2: テストケース実行のパターン分け
  - s3: テストデータとテストクラスの作成

### リクエスト単体テストの実施方法(バッチ)
path: development-tools/testing-framework/testing-framework-02-requestunittest-batch.json
- s1: テストクラスの書き方
- s2: テストメソッド分割
- s3: テストデータの書き方
  - s4: テストクラスで共通のデータベース初期値
  - s5: テストケース一覧
  - s7: 各種準備データ
  - s11: 各種期待値
- s15: テストメソッドの書き方
  - s16: スーパクラスについて
  - s17: テストメソッド作成
  - s18: スーパクラスのメソッド呼び出し
- s19: テスト起動方法
- s20: テスト結果検証
  - s21: データベースの結果検証
  - s22: ファイルの結果検証
  - s23: ログの結果検証

### リクエスト単体テストの実施方法（応答不要メッセージ受信処理）
path: development-tools/testing-framework/testing-framework-02-requestunittest-delayed-receive.json
- s1: 概要
  - s2: テスト対象の成果物
- s3: テストクラスの書き方
- s4: データシートの書き方
  - s5: 正常系のケース

### リクエスト単体テストの実施方法（応答不要メッセージ送信処理）
path: development-tools/testing-framework/testing-framework-02-requestunittest-delayed-send.json
- s1: 概要
  - s2: テスト対象の成果物
- s3: テストクラスの書き方
- s4: データシートの書き方
  - s5: 正常系ケースの準備
  - s6: 異常系ケースの準備

### リクエスト単体テストの実施方法
path: development-tools/testing-framework/testing-framework-02-requestunittest-index.json
- s1: テストクラスの書き方
- s2: テストメソッド分割
- s3: テストデータの書き方
  - s4: テストクラスで共通のデータベース初期値
  - s5: テストケース一覧
  - s6: ユーザ情報
  - s7: Cookie情報
  - s8: リクエストパラメータ
  - s10: 各種期待値
- s13: テストメソッドの書き方
  - s14: スーパクラスについて
  - s15: テストメソッド作成
  - s16: スーパクラスのメソッド呼び出し
  - s23: ダウンロードファイルのテスト
- s24: テスト起動方法
- s25: テスト結果確認（目視）
  - s26: HTMLダンプ出力結果
- s27: リクエスト単体テストクラス作成時の注意点
  - s28: ThreadContextへの値設定は不要
  - s29: テストクラスでのトランザクション制御は不要

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

### リクエスト単体テストの実施方法(同期応答メッセージ送信処理)
path: development-tools/testing-framework/testing-framework-02-requestunittest-send-sync.json
- s1: 出力ライブラリ(同期応答メッセージ送信処理)の構造とテスト範囲
- s2: テストの実施方法
  - s3: テストデータの書き方
  - s6: テスト結果検証

### 取引単体テストの実施方法
path: development-tools/testing-framework/testing-framework-03-DealUnitTest.json
- s1: テスト準備
- s2: テスト実施
- s3: テスト結果エビデンスの収集
- s4: テスト結果エビデンスの収集

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
- s10: システム日時を任意の値に固定したい
  - s11: 設定ファイル例
- s12: シーケンスオブジェクトを使った採番のテストをしたい
  - s13: 設定ファイルの例
  - s14: Excelファイル記述例
- s15: ThreadContextにユーザID、リクエストIDなどを設定したい
  - s16: テストソースコード実装例
  - s17: テストデータ記述例
- s18: 任意のディレクトリのExcelファイルを読み込みたい
  - s19: テストソースコード実装例
- s20: テスト実行前後に共通処理を行いたい。
  - s21: 注意事項
- s23: デフォルト以外のトランザクションを使用したい
- s24: 本フレームワークのクラスを継承せずに使用したい
  - s25: テストソースコード実装例
- s26: クラスのプロパティを検証したい
  - s27: テストソースコード実装例
  - s28: Excelファイル記述例
- s29: テストデータに空白、空文字やnullを記述したい
- s30: テストデータに空行を記述したい
- s31: マスタデータを変更してテストを行いたい
- s32: テストデータ読み込みディレクトリを変更したい

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

### 取引単体テストの実施方法（同期応答メッセージ受信処理)
path: development-tools/testing-framework/testing-framework-03-dealunittest-real.json

### 同期応答メッセージ送信処理を伴う取引単体テストの実施方法
path: development-tools/testing-framework/testing-framework-03-dealunittest-send-sync.json
- s1: モックアップクラスを使用した取引単体テストの実施方法
  - s2: Excelファイルの書き方
  - s7: Excelファイルの配置場所の設定
  - s8: 要求電文のログ出力
  - s9: フレームワークで使用するクラスの設定

### マスタデータ復旧機能
path: development-tools/testing-framework/testing-framework-04-MasterDataRestore.json
- s1: 概要
- s2: 特徴
- s3: 動作イメージ
- s4: 環境構築
  - s5: バックアップ用スキーマの作成、データ投入
  - s6: コンポーネント設定ファイルに監視対象テーブルを記載
  - s9: ログ出力設定

### 単体テスト実施方法
path: development-tools/testing-framework/testing-framework-05-UnitTestGuide.json

### 自動テストフレームワークの使用方法
path: development-tools/testing-framework/testing-framework-06-TestFWGuide.json

### リクエスト単体テスト（画面オンライン処理）
path: development-tools/testing-framework/testing-framework-06-testfwguide-02-RequestUnitTest.json
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

### Actionクラス内で実行するSQL文の条件網羅テストを簡単に実施する方法はありますか？
path: development-tools/testing-framework/testing-framework-3.json

### Excelのテストデータに設定した整数値が、テスト実行時には小数部ありの数値となってしまいます。回避方法を教えてください
path: development-tools/testing-framework/testing-framework-4.json

### Windows上で成功していた画面オンライン処理のリクエスト単体テストをLinux上で実行すると、IOExceptionが発生してテストが失敗してしまいます。対処方法を教えてください
path: development-tools/testing-framework/testing-framework-5.json

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
  - s16: ディレクティブのデフォルト値

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
- s11: テストデータ
  - s12: メッセージ

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
- s9: テストデータ
  - s10: 同期応答メッセージ送信処理

### リクエスト単体テストの実施方法(ファイルアップロード)
path: development-tools/testing-framework/testing-framework-fileupload.json
- s1: アップロードファイルの記述方法
- s2: バイナリファイルの場合
- s3: 固定長ファイル、CSVファイルの場合

### 
path: development-tools/testing-framework/testing-framework-mail.json
- s1: リクエスト単体テストの実施方法(メール送信)
  - s2: メール送信処理の構造とテスト範囲
  - s3: テストの実施方法

### テストに関するFAQ
path: development-tools/testing-framework/testing-framework-test.json

## development-tools/toolbox

### Form自動生成ツール
path: development-tools/toolbox/toolbox-01-EntityGenerator.json
- s1: 概要
- s2: 利用の準備
  - s3: 環境設定ファイル
  - s6: コンポーネント定義ファイル
- s10: 自動生成ツールの実行手順
- s11: 自動生成ツールの仕様詳細
  - s12: Entity 出力の仕様

### JSP自動生成ツール
path: development-tools/toolbox/toolbox-01-JspGenerator.json
- s1: 概要
- s2: 要求
- s3: 仕様
- s4: 前提条件
- s5: 使用方法

### マスタデータ投入ツール
path: development-tools/toolbox/toolbox-01-MasterDataSetupTool.json
- s1: 概要
- s2: 特徴
- s3: 使用方法
  - s4: 前提条件
  - s5: データ作成方法
  - s6: 実行方法

### リクエスト単体データ作成ツール
path: development-tools/toolbox/toolbox-01-httpdumptool-01-HttpDumpTool.json
- s1: 概要
- s2: 特徴
- s3: 使用方法
  - s4: 前提条件
  - s5: 入力となるHTML生成
  - s6: ツール起動
  - s7: データ入力
  - s8: Excelダウンロード
  - s9: データ編集

### リクエスト単体データ作成ツール
path: development-tools/toolbox/toolbox-01-httpdumptool-index.json

### マスタデータ投入ツール インストールガイド
path: development-tools/toolbox/toolbox-02-ConfigMasterDataSetupTool.json
- s1: 前提事項
- s2: 提供方法
  - s3: プロパティファイルの書き換え
  - s4: 配置
- s5: Eclipseとの連携設定
  - s6: Antビュー起動
  - s7: ビルドファイル登録

### マスタデータ投入ツール
path: development-tools/toolbox/toolbox-02-MasterDataSetup.json

### リクエスト単体データ作成ツール インストールガイド
path: development-tools/toolbox/toolbox-02-SetUpHttpDumpTool.json
- s1: 前提事項
- s2: 提供方法
- s3: Eclipseとの連携
  - s4: 設定画面起動
  - s5: 外部プログラム選択
  - s6: 起動用バッチファイル（シェルスクリプト）選択
  - s7: HTMLファイルからの起動方法

### JSP自動生成ツール インストールガイド
path: development-tools/toolbox/toolbox-02-SetUpJspGeneratorTool.json
- s1: 前提事項
- s2: 提供方法
- s3: Eclipseとの連携
  - s4: 設定画面起動
  - s5: 外部プログラム選択
  - s6: 起動用バッチファイル選択
  - s7: HTMLファイルからの起動方法
  - s8: 作成したファイルの表示

### HTMLチェックツール
path: development-tools/toolbox/toolbox-03-HtmlCheckTool.json
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
path: development-tools/toolbox/toolbox-08-TestTools.json

### 環境設定ファイル自動生成ツール
path: development-tools/toolbox/toolbox-ConfigGenerator.json
- s1: 概要
- s2: 利用の準備
  - s3: 入力元となる設計書に関する設定
  - s4: ファイル生成に関する設定
- s5: 自動生成ツールの実行手順
  - s6: 「処理方式名」「環境名」を事前に定義して実行する場合
  - s7: 対話形式で生成を実行する場合

### Shell Script自動生成ツール
path: development-tools/toolbox/toolbox-ShellGenerator.json
- s1: 概要
- s2: 使用方法

### 
path: development-tools/toolbox/toolbox-tool.json
- s1: Nablarch Toolbox

## guide/libraries

### サンプルアプリケーションの概要
path: guide/libraries/libraries-01-sendUserResisteredMailSpec.json

### メール送信処理のアプリケーション構造
path: guide/libraries/libraries-02-basic.json
- s1: 概要
- s2: メール送信のパターン
- s3: テーブル定義
  - s4: メール送信要求
  - s5: メール送信先
  - s6: メール添付ファイル
  - s7: メールテンプレート

### メール送信の実装方法
path: guide/libraries/libraries-03-sendUserRegisterdMail.json
- s1: 実装例
- s2: 送信要求データオブジェクトへの設定項目

### 業務アプリケーションの実装方法 (メール送信処理編)
path: guide/libraries/libraries-04-Explanation-mail.json

### 業務アプリケーションの実装方法 (その他の処理)
path: guide/libraries/libraries-04-Explanation-other.json

## guide/mom-messaging

### ユーザ削除情報電文送信処理の仕様
path: guide/mom-messaging/mom-messaging-01-userDeleteInfoMessageSendSpec.json
- s1: 機能概要
- s2: エンティティ情報
- s3: 電文仕様

### ユーザ登録情報電文受信処理の仕様
path: guide/mom-messaging/mom-messaging-01-userRegisterMessageReceiveSpec.json
- s1: 機能概要
- s2: 電文仕様
- s3: エンティティ情報

### ユーザ情報登録サービスの仕様
path: guide/mom-messaging/mom-messaging-01-userResisterMessageSpec.json
- s1: 機能概要
- s2: 要求電文仕様
- s3: 応答電文仕様
- s4: ステータスコード/障害コード仕様
- s5: エンティティ情報

### ユーザ情報登録サービスの仕様
path: guide/mom-messaging/mom-messaging-01-userSendSyncMessageSpec.json
- s1: 機能概要
- s2: 要求電文仕様
- s3: 応答電文仕様

### 応答不要メッセージ受信処理
path: guide/mom-messaging/mom-messaging-03-mqDelayedReceive.json
- s1: アプリケーション開発者が実装する成果物
- s2: フォーマット定義ファイル
- s3: 一時テーブルの定義
  - s4: 実際のテーブル定義の例
- s5: Formクラス
- s6: SQLファイル

### 応答不要メッセージ送信処理
path: guide/mom-messaging/mom-messaging-03-mqDelayedSend.json
- s1: アプリケーション開発者が実装する成果物
- s2: フォーマット定義ファイル
- s3: 一時テーブル
  - s4: 実際のテーブル定義の例
- s5: Formクラス
- s6: SQLファイル

### 同期応答型メッセージ受信処理
path: guide/mom-messaging/mom-messaging-03-userQueryMessageAction.json
- s1: 電文受信時の処理
- s2: エラー時の処理

### 同期応答メッセージ送信処理
path: guide/mom-messaging/mom-messaging-03-userSendSyncMessageAction.json
- s1: アプリケーションプログラマが実装する成果物
- s2: フォーマット定義ファイル
  - s3: 要求電文のフォーマット定義ファイル
  - s4: 応答電文のフォーマット定義ファイル
- s5: 同期応答メッセージ送信処理を行うActionクラス

### 業務アプリケーションの実装方法 (応答不要メッセージ受信処理編)
path: guide/mom-messaging/mom-messaging-04-Explanation-delayed-receive.json

### 業務アプリケーションの実装方法 (応答不要メッセージ送信処理編)
path: guide/mom-messaging/mom-messaging-04-Explanation-delayed-send.json

### 業務アプリケーションの実装方法 (メッセージング処理編)
path: guide/mom-messaging/mom-messaging-04-Explanation-messaging.json

### 業務アプリケーションの実装方法 (同期応答メッセージ受信処理編)
path: guide/mom-messaging/mom-messaging-04-Explanation-real.json

### 業務アプリケーションの実装方法 (同期応答メッセージ送信処理編)
path: guide/mom-messaging/mom-messaging-04-Explanation-send-sync.json

### 応答不要型メッセージ受信処理のアプリケーション構造
path: guide/mom-messaging/mom-messaging-04-explanation-delayed-receive-02-basic.json
- s1: 概要
- s2: クラス構造
- s3: 処理の流れ

### 応答不要メッセージ送信処理のアプリケーション構造
path: guide/mom-messaging/mom-messaging-04-explanation-delayed-send-02-basic.json
- s1: 概要
- s2: クラス構造
- s3: 処理の流れ

### 同期応答型メッセージ受信処理のアプリケーション構造
path: guide/mom-messaging/mom-messaging-04-explanation-real-02-basic.json
- s1: 概要
- s2: 電文フォーマット定義ファイル
- s3: クラス構造
- s4: メソッド詳細
  - s5: 電文受信時のコールバック
  - s6: エラー発生時のコールバック
- s7: 処理の流れ

### 同期応答メッセージ送信処理のアプリケーション構造
path: guide/mom-messaging/mom-messaging-04-explanation-send-sync-02-basic.json
- s1: 概要
- s2: クラス構造
- s3: 処理の流れ

## guide/nablarch-batch

### ユーザ情報削除バッチの仕様
path: guide/nablarch-batch/nablarch-batch-01-userDeleteBatchSpec.json
- s1: 機能概要
- s2: エンティティ情報
- s3: ファイル情報
  - s4: 障害通知仕様

### ユーザ情報入力バッチの仕様
path: guide/nablarch-batch/nablarch-batch-01-userInputBatchSpec.json
- s1: 機能概要
- s2: エンティティ情報
- s3: ファイル情報
- s4: 障害通知仕様

### バッチ共通のアプリケーション構造
path: guide/nablarch-batch/nablarch-batch-02-basic.json
- s1: 概要
  - s2: 作業単位
- s3: クラス構造
  - s4: DBを入力とするバッチを実装する場合
  - s5: ファイルを入力とするバッチを実装する場合
- s6: 処理の流れ
  - s7: フレームワーク動作イメージ
  - s8: コマンドライン引数
- s9: メソッド詳細
  - s10: 初期化処理
  - s11: リーダ作成
  - s12: 1作業単位毎の処理
  - s13: エラー発生時の処理
  - s16: 終了処理

### データベースを入力とするバッチ
path: guide/nablarch-batch/nablarch-batch-03-dbInputBatch.json
- s1: 初期化処理
- s2: リーダ作成
- s3: １件ごとの処理
- s4: エラー発生時の処理
- s5: 終了処理
- s6: ログ出力

### 業務アプリケーションの実装方法 (バッチ処理編)
path: guide/nablarch-batch/nablarch-batch-04-Explanation-batch.json

### ファイルを入力とするバッチ
path: guide/nablarch-batch/nablarch-batch-04-fileInputBatch.json
- s1: フォーマット定義ファイル
- s2: 初期化処理
- s3: リーダ生成
- s4: ファイルバリデータ生成
- s5: ファイルバリデータ実装
  - s6: ヘッダーレコードの精査処理
  - s7: データレコードの精査処理
  - s8: トレーラレコードの精査処理
  - s9: エンドレコードの精査処理
  - s10: バリデータクラスの終了処理
- s11: １件ごとの処理
  - s12: ヘッダーレコードの処理
  - s13: データレコードの処理
  - s14: トレーラレコードの処理
  - s15: エンドレコードの処理。
- s16: エラー発生時の処理
- s17: 終了処理

### ファイルを出力するバッチ
path: guide/nablarch-batch/nablarch-batch-05-fileOutputBatch.json
- s1: 初期化処理
- s2: リーダ作成
- s3: １件ごとの処理
- s4: エラー処理
- s5: 終了処理

### 常駐バッチ
path: guide/nablarch-batch/nablarch-batch-06-residentBatch.json

## guide/web-application

### データベースアクセス実装例集
path: guide/web-application/web-application-01-DbAccessSpec-Example.json
- s1: 本ページの構成
- s2: 基本的な実装
- s3: 簡易検索機能
  - s4: 条件に紐付くデータの全件検索処理
  - s5: 範囲指定での検索処理
  - s6: 取得したSqlResultSetの使用方法
- s7: 大量データの検索機能
- s8: 更新(insert、update、delete)
  - s9: 1件のデータを更新する場合
  - s10: 複数件を一括で更新する場合
- s11: バイナリデータへのアクセス
  - s12: バイナリデータの検索方法
  - s13: バイナリデータの登録方法
  - s14: ファイルの内容をバイナリデータとして登録する方法
  - s15: バイナリデータをファイルとして出力する方法
- s16: オブジェクトのフィールドの値の登録機能(オブジェクト(Form)編)
  - s17: 1件のデータを更新する場合
  - s18: 複数件を更新する場合
- s19: オブジェクトのフィールドの値の登録機能(Mapのサブクラス編)
  - s20: 1件のデータを更新する場合
  - s21: 複数件を更新する場合
- s22: オブジェクトのフィールドの値の検索機能(オブジェクト(Form)編)
  - s23: 簡易検索機能を使用する場合
  - s24: like条件をもつ簡易検索の場合
  - s25: 可変条件のSQLの場合
  - s26: IN句の条件が動的に変わる場合
  - s27: ORDER BY句を動的に変更する場合
  - s28: 大量データを検索する場合
- s29: オブジェクトのフィールドの値の検索機能(Mapのサブクラス編)

### サンプルアプリケーションの概要
path: guide/web-application/web-application-01-sampleApplicationExplanation.json
- s1: 画面遷移
- s2: サンプルアプリケーションの機能と説明する処理
- s3: 主な仕様
  - s4: ユーザ情報照会機能
  - s5: ユーザ情報登録機能
  - s6: ユーザ情報更新機能
- s7: サンプルアプリケーションの実行方法

### 説明に使用する機能について
path: guide/web-application/web-application-01-spec.json
- s1: 実施する作業概要
- s2: 前提条件
- s3: 既存のユーザ情報更新機能の動作確認
- s4: ユーザ情報更新機能の仕様

### Appendix A: ウィンドウスコープ概要
path: guide/web-application/web-application-02-WindowScope.json
- s1: 動作イメージ
- s2: セッションスコープとの使い分け
- s3: 詳細情報

### 画面初期表示
path: guide/web-application/web-application-02-basic.json
- s1: 本項で説明する内容
  - s2: 説明内容
  - s3: 作成内容
- s4: 作成手順
  - s5: ビジネスロジック(Component)の作成
  - s6: ビジネスロジックを呼び出す処理(Action)の作成
  - s9: View(JSP)の作成
- s10: 次に読むもの

### 開発フロー
path: guide/web-application/web-application-02-flow.json
- s1: 開発手順詳細

### 業務アプリケーション開発手順
path: guide/web-application/web-application-03-DevelopmentStep.json
- s1: 更新機能の開発手順

### マスタデータのセットアップ
path: guide/web-application/web-application-03-datasetup.json

### 一覧検索
path: guide/web-application/web-application-03-listSearch.json
- s1: 本項で説明する内容
  - s2: 説明内容
  - s3: 作成内容
- s4: 作成手順
  - s5: 検索条件を保持するForm(SearchForm)の作成
  - s7: ビジネスロジック(Action)の作成
  - s13: リクエストに対応するメソッドの作成
  - s14: View(JSP)の作成
- s15: 次に読むもの

### 業務アプリケーションの実装方法 (画面オンライン処理編)
path: guide/web-application/web-application-04-Explanation.json

### Entityクラス（精査処理）の実装
path: guide/web-application/web-application-04-create-entity.json

### 入力内容の精査
path: guide/web-application/web-application-04-validation.json
- s1: 本項で説明する内容
  - s2: 説明内容
  - s3: 作成内容
- s4: 作成手順
  - s5: Formの生成
  - s13: Actionの作成
  - s17: View(JSP)の作成
- s18: 次に読むもの

### Formクラスの実装
path: guide/web-application/web-application-05-create-form.json

### 画面遷移処理
path: guide/web-application/web-application-05-screenTransition.json
- s1: 本項で説明する内容
  - s2: 説明内容
  - s3: 作成内容
- s4: 作成手順
  - s5: View(JSP)の作成
- s9: 次に読むもの

### 更新画面初期表示の実装
path: guide/web-application/web-application-06-initial-view.json

### 入力画面と確認画面の共通化
path: guide/web-application/web-application-06-sharingInputAndConfirmationJsp.json
- s1: 本項で説明する内容
  - s2: 説明内容
  - s3: 作成内容
- s4: 作成手順
  - s5: View(JSP)の作成
- s10: 共通化の指針
- s11: 次に読むもの

### 確認画面の実装
path: guide/web-application/web-application-07-confirm-view.json

### 登録処理
path: guide/web-application/web-application-07-insert.json
- s1: 本項で説明する内容
  - s2: 説明内容
  - s3: 作成内容
- s4: 作成手順
  - s5: 二重サブミットの防止
  - s11: 自動設定項目の指定(Entityの編集)
  - s12: ビジネスロジック(Component)の作成
  - s13: Actionの作成
  - s14: JSPの作成
- s15: 次に読むもの

### 完了画面の実装
path: guide/web-application/web-application-08-complete.json

### 開発を容易にするためのユーティリティ
path: guide/web-application/web-application-08-utilities.json

### 
path: guide/web-application/web-application-09-confirm-operation.json
- s1: 動作確認をする為のサンプルアプリケーションの修正
- s2: 動作確認の実施

### フレームワークAPIの使用例集
path: guide/web-application/web-application-09-examples.json

### 一覧表示から個別の情報を扱う画面への遷移
path: guide/web-application/web-application-10-submitParameter.json
- s1: 本項で説明する内容
  - s2: 説明内容
  - s3: 作成内容
- s4: 作成手順
  - s5: View(JSP)の作成
  - s9: 更新画面初期表示までの実装
- s10: 次に読むもの

### 排他制御
path: guide/web-application/web-application-11-exclusiveControl.json
- s1: 本項で説明する内容
  - s2: 説明内容
  - s3: 作成内容
- s4: 作成手順
  - s5: 概要
  - s6: 主キークラス(ExclusiveCtrlSystemAccountContext)の作成
  - s7: Actionの作成
- s8: 次に読むもの

### 携帯端末(フィーチャーフォン)向け画面を実装する際の留意点
path: guide/web-application/web-application-12-keitai.json
- s1: 本項で説明する内容
- s2: 携帯端末でサポートされるNablarchの機能
- s3: 携帯端末で使用できないカスタムタグライブラリ

### 画面オンライン処理の実装例集
path: guide/web-application/web-application-CustomTag.json
- s1: 基本的な説明
- s2: 画面の入出力に関する実装例
- s3: 画面遷移に関する実装例
- s4: よくある業務処理の実装例

### 
path: guide/web-application/web-application-DB.json

### 
path: guide/web-application/web-application-Log.json

### その他実装例集
path: guide/web-application/web-application-Other.json
- s1: 本ページの構成
- s2: ログの出力方法
- s3: 設定値の取得方法
- s4: メッセージの取得方法
- s5: エラーメッセージの通知方法
- s6: データベースアクセスを伴う精査を行う方法
- s7: エラーメッセージを任意の個所に表示する方法
- s8: コード名称と値の取得方法
- s9: コード値のバリデーション方法
- s10: 正常な画面遷移においてメッセージを表示する方法

### ログ出力の設定方法とログの見方(画面オンライン処理編)
path: guide/web-application/web-application-Web-Log.json
- s1: 開発時のログ出力の設定方法
- s2: 開発時のログの見方
  - s3: リクエスト処理を正常に完了した場合
  - s8: JSPで例外が発生した場合
  - s9: リクエストURLに対応するアクションが見つからない場合
  - s10: リクエストURLに対応するアクションのメソッドが見つからない場合

### 
path: guide/web-application/web-application-basic.json
- s1: taglibディレクティブの指定方法
- s2: URIの指定方法
  - s3: 絶対URLによる指定
  - s4: コンテキストルートからの相対パスによる指定
  - s5: HTTPとHTTPSの切り替え
- s6: JSPとActionクラスの間でデータを受け渡す方法
  - s7: Map型/フォームのプロパティを受け渡す場合
  - s8: List型/配列の要素のプロパティを受け渡す場合
- s9: ウィンドウスコープの使用法
  - s10: windowScopePrefixes属性の使用方法
  - s11: 複数画面に跨る画面遷移時のwindowScopePrefixes属性の指定方法
  - s12: アクションの実装方法
- s13: JSP上で変数に値を設定する方法

### 
path: guide/web-application/web-application-function.json
- s1: ファイルダウンロードの実現方法
  - s2: ファイルのダウンロード方法
  - s3: BLOB型カラムのダウンロード方法
  - s4: データレコードのダウンロード方法
  - s5: 別ウィンドウを開きダウンロードを開始したい場合
- s6: ファイルアップロードの実現方法
  - s7: ファイルアップロード画面の作成方法（JSP）
  - s8: アップロードファイルの取得方法（サーバサイド）
  - s9: アップロードファイルの保存方法
  - s10: アップロードファイルを読み込む方法
  - s11: アップロードファイルをDBに登録する方法
- s16: 検索結果の一覧表示
  - s17: ページングを使用した一覧表示
  - s18: 特定の一覧表示で表示件数と検索結果件数(上限)を個別に設定する方法
  - s19: 検索結果の並び替え
  - s20: ページングを使用しない一覧表示
- s21: 複合キーを使用したデータの一覧画面から、ラジオボタン・チェックボックスでデータを選択する
  - s22: 複合キーを用いたUIの実装
  - s23: 複合キーを用いた排他制御の実装
- s24: Javascriptの使用

### フォーム内の入力要素を出力するカスタムタグ
path: guide/web-application/web-application-inputAndOutput.json
- s1: コード値の表示方法
  - s2: codeSelectタグ
  - s3: codeRadioButtonsタグ
  - s4: codeCheckboxesタグ
  - s5: codeCheckboxタグ
  - s8: codeタグ
- s11: 入力/選択項目での初期値設定
- s12: 入力項目の確認画面用の出力
- s13: エラーメッセージの表示、エラー項目のハイライト
- s14: メッセージの表示
- s15: 出力フォーマットの変更方法
- s16: HTMLエスケープせずに値を出力する方法
- s17: hiddenタグの暗号化機能の解除

### 
path: guide/web-application/web-application-screenTransition.json
- s1: ボタン又はリンクによるサブミット
  - s2: サブミット先の指定方法
  - s3: アプリケーションでonclick属性を指定する場合
- s4: Enterキー押下時にデフォルトで動作するサブミットボタンを設定する方法
- s5: 一覧照会画面から詳細画面へ遷移する場合
- s6: 複数ウィンドウを立ち上げたい場合
  - s7: 別ウィンドウにサブミットする場合のJSPの実装例
  - s8: 別ウィンドウから元画面に値を設定する場合のJSPの実装例
- s9: 二重サブミットの防止
- s10: 入力画面と確認画面の共通化をサポートするカスタムタグ
- s11: ブラウザのキャッシュ防止

## processing-pattern/mom-messaging

### 
path: processing-pattern/mom-messaging/mom-messaging-messaging-receive.json
- s1: 応答不要メッセージング実行制御基盤
  - s2: 業務アクションハンドラの実装
  - s3: 標準ハンドラ構成と主要処理フロー

### 
path: processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.json
- s1: 同期応答メッセージング実行制御基盤
  - s2: 基本構造
  - s3: 業務アクションハンドラの実装
  - s4: 標準ハンドラ構成と主要処理フロー

### メッセージング実行制御基盤
path: processing-pattern/mom-messaging/mom-messaging-messaging.json

## processing-pattern/nablarch-batch

### バッチの処理対象件数をログに出力する方法はありますか？
path: processing-pattern/nablarch-batch/nablarch-batch-1.json

### データベースをインプットとするバッチ処理の場合で、精査が不要な場合でもEntityは作成する必要はありますか？
path: processing-pattern/nablarch-batch/nablarch-batch-2.json

### ファイル読み込み処理で、想定するレコード識別子以外の値がファイルに存在した場合の動作を教えてください
path: processing-pattern/nablarch-batch/nablarch-batch-3.json

### 入出力ファイルの各項目の項目IDは、対応するテーブルのカラム名と一致させたほうが良いのでしょうか？
path: processing-pattern/nablarch-batch/nablarch-batch-4.json

### バッチアプリケーションを自動テスト以外の方法で起動する方法を教えてください
path: processing-pattern/nablarch-batch/nablarch-batch-5.json

### データベースをインプットとするバッチ処理でも、画面処理と同じようにFormは必要ですか？
path: processing-pattern/nablarch-batch/nablarch-batch-6.json

### バッチ処理を実行すると **DuplicateProcess** が発生し、処理が異常終了してしまいます。対処方法を教えてください
path: processing-pattern/nablarch-batch/nablarch-batch-7.json

### バッチ処理を実行するとProcessStop(kill process.)が発生し、処理が異常終了してしまいます。対処方法を教えてください
path: processing-pattern/nablarch-batch/nablarch-batch-8.json

### 入力データが存在しないバッチ処理はどのように作成するのでしょうか？
path: processing-pattern/nablarch-batch/nablarch-batch-9.json

### バッチ実行制御基盤
path: processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.json

### バッチに関するFAQ
path: processing-pattern/nablarch-batch/nablarch-batch-batch-index.json

### 
path: processing-pattern/nablarch-batch/nablarch-batch-batch-resident.json
- s1: 常駐バッチ実行制御基盤
  - s2: 基本構造
  - s3: 業務アクションハンドラの実装
  - s4: 標準ハンドラ構成と主要処理フロー

### 
path: processing-pattern/nablarch-batch/nablarch-batch-batch-single-shot.json
- s1: 都度起動バッチ実行制御基盤
  - s2: 基本構造
  - s3: 業務アクションハンドラの実装
  - s4: 標準ハンドラ構成と主要処理フロー

## processing-pattern/web-application

### 入力値で精査エラーが発生した場合に戻り先画面の情報はどのように取得したらよいですか？
path: processing-pattern/web-application/web-application-1.json

### 出力するHTMLの文字コードを変更したいのですが
path: processing-pattern/web-application/web-application-10.json

### Javascript を使用することはできますか。
path: processing-pattern/web-application/web-application-11.json

### JavaScriptコードを記述すると静的解析ツールでエラーが発生します。対処方法を教えてください。
path: processing-pattern/web-application/web-application-12.json

### テストケース毎に言語を設定する方法を教えてください
path: processing-pattern/web-application/web-application-13.json

### Firefoxで2重サブミット防止が効かないことがあるようなのですが?
path: processing-pattern/web-application/web-application-14.json

### 送信ボタンやリンクを押すと、IEでのみ「オブジェクトでサポートされていないプロパティまたはメソッドです」と表示され画面が遷移しません。
path: processing-pattern/web-application/web-application-15.json

### JavaScriptから操作できるようにHTMLのinput(type="hidden")タグを出力することはできますか？
path: processing-pattern/web-application/web-application-16.json

### 一覧画面で表示する検索結果件数の表示フォーマットを変更することはできますか？
path: processing-pattern/web-application/web-application-2.json

### 子画面を開くタグのname属性には、何を指定したらいいのでしょうか?
path: processing-pattern/web-application/web-application-3.json

### 子画面を開く際に画面サイズや、属性を指定する事は出来ますか?
path: processing-pattern/web-application/web-application-4.json

### codeSelectやselectタグで、先頭に空白要素を追加する方法を教えてください
path: processing-pattern/web-application/web-application-5.json

### 画面に表示するエラーメッセージを途中で改行することは出来ますか?
path: processing-pattern/web-application/web-application-6.json

### コード値精査時に指定するパターンには何を指定するのでしょうか？
path: processing-pattern/web-application/web-application-7.json

### 画面にワーニングメッセージを表示する方法を教えてください
path: processing-pattern/web-application/web-application-8.json

### ユーザに権限があるかを簡単に確認する方法はありますか？
path: processing-pattern/web-application/web-application-9.json

### 
path: processing-pattern/web-application/web-application-web-gui.json
- s1: 画面オンライン実行制御基盤
  - s2: 業務アクションハンドラの実装
  - s3: 標準ハンドラ構成と主要処理フロー

### 画面オンライン開発に関するFAQ
path: processing-pattern/web-application/web-application-web.json

## releases/releases

### ■Nablarch 1.2.3 リリースノート
path: releases/releases/releases-nablarch-1.2.3-releasenote-1.2.3.json
- s1: エンジニアリング基盤
- s2: アプリケーション実行環境
- s3: SessionConcurrentAccessHandlerとサーバーサイドの2重サブミット制御を併用すると2重サブミット制御が機能しない可能性がある不具合に対応
- s4: インターセプタの実行順を指定する方法がない不具合に対応
- s5: HttpResponseHandlerがリダイレクト時にHTTPヘッダを設定していない問題に対応
- s6: @Digits が付いた項目に"+"だけを入力すると、NumberFormatExceptionが発生する不具合に対応
- s7: n:buttonタグ、n:popupButtonタグでdisplayMethodにNODISPLAYを指定した場合、終了タグのみが出力されてしまう不具合を修正。
- s8: HttpSessionがinvalidateされた場合に、カスタムタグで例外が発生する可能性がある不具合に対応
- s9: URLに「$」を含むとHTTPリライト機能で例外が発生する不具合に対応
- s10: DBを入力とするバッチをマルチスレッドで実行した場合、スレッド内で無限ループが発生する可能性がある不具合に対応
- s11: バッチアクションの終了処理で例外が発生した場合、メイン処理で発生した例外を消失する可能性がある不具合に対応
- s12: 常駐バッチにて出力ファイル開放ハンドラがファイルを閉じない可能性がある不具合に対応
- s13: ファイルアップロード上限エラー発生時に不正ファイルが残る不具合の対応
- s14: ExecutionContextのセッションスコープに並行アクセスで書き込みが行われた場合、無限ループ等の問題が発生する可能性がある不具合に対応
- s15: アプリケーション開発環境
- s16: FW制御ヘッダーにアプリケーション独自の項目を追加した際の自動テスト対応
- s17: テストデータ記載時に、全てのカラムが空文字となるテストデータを作成すると、当該レコードが無視されてしまう不具合の対応
- s18: 性能改善

### ■バージョンアップ手順
path: releases/releases/releases-nablarch-1.2.3-releasenote-バージョンアップ手順.json

### ■Nablarch 1.2.4 リリースノート
path: releases/releases/releases-nablarch-1.2.4-releasenote-1.2.4.json
- s2: フォーマット機能で大きな桁数の数値を表示しようとするとOutOfMemoryErrorが起こる可能性がある不具合を修正
- s3: BigDecimalの桁数をチェックするように変更

### ■バージョンアップ手順
path: releases/releases/releases-nablarch-1.2.4-releasenote-バージョンアップ手順.json

### 分類
path: releases/releases/releases-nablarch-1.2.4-releasenote-分類.json

### ■Nablarch 1.2.5 リリースノート
path: releases/releases/releases-nablarch-1.2.5-releasenote-1.2.5.json
- s2: ThreadLocal変数を適切に削除していない不具合を修正
- s3: マルチパートリクエストのboundary内のヘッダ行のサイズチェック処理を追加
- s4: ResourceLocatorで発生する可能性のあるStackOverflowErrorへの対応
- s5: リダイレクト時のクエリストリング指定の追加
- s6: セッション並行アクセスハンドラのMANUAL/SERIALIZEポリシーを削除
- s7: プリミティブ配列を値に持つMapをログにダンプできるように変更
- s8: データタイプ・コンバータの初期化時にnullが指定された場合に適切な例外を送出するように変更
- s9: 例外メッセージの不統一を修正
- s10: テスト時にコンバータの設定をデフォルトに戻せない問題に対応
- s11: 書き込み時の値にnullが指定された場合の挙動を修正
- s12: マルチレイアウトの識別項目がnullの場合の挙動を修正
- s13: required-decimal-pointディレクティブの指定が符号なし数値で有効にならない問題に対応
- s14: 固定長のバイナリ型で、出力対象のバイト長を考慮しない問題を修正
- s15: 符号付き数値のデータタイプで、指定した桁数より大きい桁数の値を出力できてしまう不具合を修正
- s16: テンプレートの置き換え文字にnullが指定された場合の挙動を修正
- s17: BigDecimal型の値に対して数値桁のバリデーション(@Digits)を行うとエラーになる不具合に対応
- s18: コード名とコードパターンのテーブルで、IDカラムのカラム名が異なる場合動作しない不具合を修正
- s19: 複数の値を出力するタグでプリミティブ配列を扱えるように修正
- s20: n:textareaで表示するデータの先頭改行が削除されないように修正
- s21: 配列やコレクションの要素にnullが格納された場合の挙動を修正
- s22: n:form配下の要素の属性指定により、サブミット処理が正常に動作しない不具合を修正
- s23: 空白を含むパスを使用できない仕様を追記
- s24: テスティングフレームワーク
- s25: 不要なログの設定ファイルを削除
- s26: BigDecimal型の値が"0E-7"のような指数表現になる不具合を修正
- s27: アクションの返すパスのアサート方法を変更

### ■バージョンアップ手順
path: releases/releases/releases-nablarch-1.2.5-releasenote-バージョンアップ手順.json

### 分類
path: releases/releases/releases-nablarch-1.2.5-releasenote-分類.json

### ■Nablarch 1.2.6 リリースノート
path: releases/releases/releases-nablarch-1.2.6-releasenote-1.2.6.json
- s2: サロゲートペアを使用できない問題に対応
- s3: DIコンテナでstaticなプロパティにインジェクションされる問題に対応
- s4: ハンドラでExecutionContext複製時に型が引き継がれない問題に対応
- s5: 公開APIを追加
- s6: String配列に対するバリデーションで実行時例外が発生する可能性がある問題に対応
- s7: NumberRangeが少数有りの場合(小数部桁数が大きい場合)にバリデーションが正しく行えない問題に対応
- s8: サロゲートペアを使用できない問題に対応
- s9: FileDataReaderのJavadocに説明を追記
- s10: JMSヘッダに値が設定されない問題に対応
- s11: プロセス起動直後の処理で例外が発生した場合に障害通知ログが出力されない問題に対応
- s12: ResourceLocatorに指定可能なclasspathスキームの注意点を追記
- s13: リダイレクト時にステータスコードが必ず302になる不具合を修正
- s14: HttpCharacterEncodingHandlerでファイルアップロード時のヘッダーの解析処理を修正
- s15: n:formタグで例外が発生する問題に対応
- s16: テスティングフレームワーク
- s17: DbAccessTestSupportの一部メソッドをpublicに変更
- s18: マスタデータ復旧機能で、変更されていないテーブルを復旧対象としてしまう不具合を修正
- s19: リクエスト単体テストで、リダイレクト時のステータスコードが正しくアサートされない不具合を修正
- s20: セルへの特殊な記述方法での半角記号の扱いを見直し
- s21: ワークフローライブラリ
- s22: アプリケーションライブラリ

### ■NumberRangeの対応方法
path: releases/releases/releases-nablarch-1.2.6-releasenote-NumberRangeの対応方法.json

### ■バージョンアップ手順
path: releases/releases/releases-nablarch-1.2.6-releasenote-バージョンアップ手順.json

### ■リポジトリを1.2.5までと同じ動作にする方法
path: releases/releases/releases-nablarch-1.2.6-releasenote-リポジトリを1.2.5までと同じ動作にする方法.json

### 分類
path: releases/releases/releases-nablarch-1.2.6-releasenote-分類.json

### ■Nablarch 1.2.7 リリースノート
path: releases/releases/releases-nablarch-1.2.7-releasenote-1.2.7.json
- s2: リクエストハンドラエントリのリクエストパターンのバリデーションに対応できていない問題を修正
- s3: テスティングフレームワーク
- s4: ワークフローライブラリ
- s5: アプリケーションライブラリ

### ■バージョンアップ手順
path: releases/releases/releases-nablarch-1.2.7-releasenote-バージョンアップ手順.json

### 分類
path: releases/releases/releases-nablarch-1.2.7-releasenote-分類.json

### ■Nablarch 1.2.8 リリースノート
path: releases/releases/releases-nablarch-1.2.8-releasenote-1.2.8.json
- s2: ロガー名が適切に設定されていない問題に対応
- s3: テスティングフレームワーク
- s4: 同期応答メッセージ送信処理を伴う取引単体テストの実施方法で使用する応答電文のExcelファイルが再読み込みされない不具合に対応
- s5: ワークフローライブラリ
- s6: アプリケーションライブラリ

### ■バージョンアップ手順
path: releases/releases/releases-nablarch-1.2.8-releasenote-バージョンアップ手順.json

### 分類
path: releases/releases/releases-nablarch-1.2.8-releasenote-分類.json

### ■Nablarch Toolboxリリースノート
path: releases/releases/releases-nablarch-toolbox-1.2.0-releasenote-detail.json
- s1: Toolbox
- s2: Javaコンパイラのバージョン変更。
- s3: SQL自動生成ツールで SELECT 文が正しく生成されない不具合を修正。
- s4: Entity自動テスト生成ツールを削除。
- s5: Form自動生成ツールのエラー出力を修正。
- s6: 外部インタフェース設計書も入力とできるよう、Form自動生成ツールに機能追加。
- s7: シェルスクリプト自動生成ツールにより生成した常駐バッチ起動シェルスクリプトがジョブを非同期で起動していない不具合の修正。
- s8: JSP自動生成ツールに HTMLコメントを JSPコメントに変換する機能を追加。
- s9: Form自動生成ツールの修正。
- s10: 排他制御主キークラス自動生成ツールの修正。

### ■Nablarchガイド 1.2.0版リリースノート
path: releases/releases/releases-nablarch-ガイド-1.2.0-releasenote-detail.json
- s1: 開発ガイド
- s2: Nablarch Testing Frameworkの変更に伴う修正。
- s3: 誤字脱字の修正。
- s4: バッチ共通のアプリケーション構造の記述間違いの修正。
- s5: HTTPリクエスト単体テストを実施するための環境設定ファイル(http-test-configuration.xml)の設定値の記述漏れの修正。
- s6: HTMLチェックツールの使用ガイドにJavaScriptをHTMLに直接記述する場合の注意点を追記。
- s7: 環境構築ガイド
- s8: 開発環境構築ガイドの手順の抜けの修正。
- s9: 設計標準策定ガイド
- s10: 対象なし。
- s11: チュートリアル用コンテンツ
- s12: 都度起動バッチの設定ファイルにPasswordEncrypterが設定されていない。
- s13: チュートリアルアプリケーションでクラス名が命名ルールに則っていないものの修正。
- s14: jspGen.batのclasspathの修正。
- s15: 自動テストの親クラスにプロジェクト固有のクラスを使用するよう修正。
- s16: HTTP文字エンコード制御ハンドラの拡張例を追加。
- s17: アノテーションに従った精査処理をプログラム中から呼び出す機能を追加。

### ■Nablarchガイド 1.2.1版リリースノート
path: releases/releases/releases-nablarch-ガイド-1.2.1-releasenote-detail.json
- s1: 開発ガイド
- s2: 固定長ファイルを入力とするテストにて、符号無(有)数値のデータ項目を指定したテストが実施できない不具合の修正。
- s3: 環境構築ガイド
- s4: 対象なし
- s5: チュートリアル用コンテンツ
- s6: 画面オンラインの開閉局制御と認可制御を内部リクエストIDで動作するように変更。
- s7: 固定長ファイルを入力とするテストにて、符号無(有)数値のデータ項目を指定したテストを実施できるように変更。
- s8: 画面オンラインで閉局エラーが発生した場合に障害通知ログが出力される不具合の修正。
- s9: メールアドレス精査の精査内容の修正。

### ■Nablarchガイド 1.2.2版リリースノート
path: releases/releases/releases-nablarch-ガイド-1.2.2-releasenote-detail.json
- s1: 開発ガイド
- s2: メールへのファイル添付方法の実装例を変更
- s3: 使用不許可APIチェックツール用の設定ファイルを、用途ごとに分割
- s4: 環境構築ガイド
- s5: 対象なし
- s6: チュートリアル用コンテンツ
- s7: 対象なし

### ■Nablarchサンプル 1.2.0版リリースノート
path: releases/releases/releases-nablarch-サンプル-1.2.0-releasenote-detail.json
- s1: 業務機能サンプル
- s2: 対象なし。
- s3: 拡張モジュールサンプル
- s4: S/MIMEに対応した電子署名付きメール送信機能を実現するサンプルを追加。
- s5: 運用機能サンプル
- s6: 運用時に使用するログ集計機能のサンプルを追加。

### ■Nablarchライブラリ1.2.0版リリースノート
path: releases/releases/releases-nablarch-ライブラリ-1.2.0-releasenote-detail.json
- s1: 画面オンライン実行制御基盤
- s2: n:formタグのaction属性をURLエンコードするよう修正。
- s3: n:formタグにsecure属性を追加。
- s4: クッキーが使用できない環境でリダイレクト時にセッションが引き継げなくなる不具合を解消。
- s5: ファイルアップロードサイズの上限を超えた場合に表示する画面を変更可能にする機能追加。
- s6: submitLinkタグに指定した属性を非活性時のJSPでも参照できる機能を追加。
- s7: 静的コンテンツのURLを属性に持つタグに対して、静的コンテンツのキャッシュ期間を限定できる機能を追加。
- s8: Nablarch Application Frameworkが出力するCookieにSecure属性を指定する機能を追加。
- s9: 言語ごとにリソースを切り替える機能が動作しない不具合の修正。
- s10: タイムゾーンをスレッドローカルに設定していると、 YYYYMMDDFormatterが正しく動作しない不具合の修正。
- s11: HTTPリクエストパラメータの文字コードを動的に変更できる機能の追加。
- s12: エラー画面を表示する際に、taglibでDBアクセスエラーが発生するとエラー画面が表示されない不具合の修正。
- s13: カスタムタグでポップアップした子画面を、親画面から操作できるように修正。
- s14: 画面表示が完了するまでサブミットできないように修正。
- s15: 年月日フォーマット入力において、"2012 Nov 10" など、数字以外での月の表現をした際にも入力文字として受け付けられるように修正。
- s16: Cookieの値として使用できなかった記号を使用できるように修正。
- s17: 排他制御の更新確認を行った際、例外が発生することがある不具合を修正。
- s18: アップロードファイルのフォーマット処理でレイアウト定義ファイルが存在しない場合にファイルを作成してしまう不具合の修正。
- s19: バッチ実行制御基盤
- s20: ファイルが存在しなかった場合のエラーメッセージの修正。
- s21: メッセージング実行制御基盤
- s22: 対象なし。
- s23: 共通(制御基盤によらない)
- s24: HTTPアクセスログの出力項目を追加。
- s25: Javaコンパイラのバージョン変更。
- s26: 設定ファイルのコンポーネント定義で、コンポーネント名が重複していると、例外が発生する不具合の修正。
- s27: JTAを利用していない場合でも、トランザクションタイムアウトを制御できる機能の追加。
- s28: アノテーションに従った精査処理をプログラム中から呼び出す機能を追加。
- s29: コード管理機能にて、存在しないパターン名を指定したときのエラーメッセージの修正。
- s30: メール送信要求テーブルにメール送信パターンID（任意カラム）を追加。
- s31: データソースでプールの空きがなかった場合の動作を修正。
- s32: NablarchTesting Framework
- s33: リダイレクト時のステータスコードのアサート方法の変更。
- s34: Javaコンパイラのバージョン変更。
- s35: JDK1.6、ojdbc6.jar、GenericJdbcDbInfoの組み合わせでは、NCHARが扱えない不具合の修正。
- s36: バッチ起動引数の数が不正なテストを簡便に実施する機能の追加。
- s37: Mapを引数とするコンストラクタを持たないEntityクラスでもクラス単体テストが実施できるよう機能追加。
- s38: JSP静的解析ツールで、ネスとしたHTMLコメント内部のJSPタグのチェックができない不具合に対応。
- s39: *.xlsx形式のファイルに対応。
- s40: FAQ
- s41: 誤字脱字の修正。
- s42: バイナリ型カラムへのアクセス方法を追記。
- s43: APIドキュメント
- s44: Nablarch Application Framework、Nablarch Testing Frameworkの変更に伴う修正。
- s45: nablarch.core.validation.ValidationContext
- s46: Javadocのリンク切れ修正。
- s47: Nablarch Application Framework解説書
- s48: Nablarch Application Framework、Nablarch Testing Frameworkの変更に伴う修正。
- s49: 誤字脱字、体裁の修正。
- s50: サーブレットincludeされたタグの中で<n:noCache>を使用しないことを明記。
- s51: HTTPステータスコードの取り扱いを追記。
- s52: BasicStatementFactory の設定に関する情報を追記
- s53: プロセス停止制御ハンドラの記述不備を修正。
- s54: マルチスレッド実行制御ハンドラの記述不備を修正。
- s55: プロセス多重起動防止ハンドラの記述不備を修正。

### ■Nablarchライブラリ1.2.1版リリースノート
path: releases/releases/releases-nablarch-ライブラリ-1.2.1-releasenote-detail.json
- s1: 画面オンライン実行制御基盤
- s2: PKが同じ複数テーブルで個別にバージョン番号を更新すると排他制御エラーになることがある不具合の修正。
- s3: 別ウィンドウにフォーマットした入力値を連携すると精査エラーになる不具合の修正。
- s4: マルチパートリクエストの処理中に内部フォワードが動作しない不具合の修正。
- s5: 内部フォワード後にフォワード先のリクエストIDを取得できる機能の追加。
- s6: 内部フォワード後にフォワード先のリクエストIDで開閉局と認可のチェックをできるように変更。
- s7: autocomplete属性の追加
- s8: JSP処理中にユーザが別操作を行った場合に出力されるログのログレベルの変更
- s9: WebLogicでファイルアップロード完了前にクライアントが通信を切断した場合に出力されるログのログレベルの変更。
- s10: 排他制御機能を使用した場合にシステムエラーが発生する場合がある不具合の修正。
- s11: URLのパスに予約文字が含まれていると障害通知ログが出力される場合がある不具合の修正。
- s12: ファイルアップロード時の一時保存ファイルが消失する場合がある不具合の修正。
- s13: バッチ実行制御基盤
- s14: 常駐バッチのリトライ制御にて、リトライのたびに障害通知ログが出力される不具合の修正。
- s15: 常駐バッチで実行時IDを発行するタイミングの変更。
- s16: メッセージング実行制御基盤
- s17: ProcessAbnormalEndが送出された場合にFATALログが2回出力される不具合の修正。
- s18: 共通(制御基盤によらない)
- s19: 日付ユーティリティの解説書から不要な記載の削除。
- s20: NablarchTesting Framework
- s21: HTMLチェックの内容を変更できる拡張ポイントの追加。
- s22: FAQ
- s23: 対象なし
- s24: APIドキュメント
- s25: 使用可能APIの変更。
- s26: Nablarch Application Framework解説書
- s27: リクエストIDと実行時IDの定義の追加。

### ■Nablarchライブラリ1.2.2版リリースノート
path: releases/releases/releases-nablarch-ライブラリ-1.2.2-releasenote-detail.json
- s1: 画面オンライン実行制御基盤
- s2: WebLogicでPOSTデータ送信中にクライアントが通信を切断した場合に出力されるログのログレベルの変更
- s3: バッチ実行制御基盤
- s4: 対象なし
- s5: メッセージング実行制御基盤
- s6: 対象なし
- s7: 共通(制御基盤によらない)
- s8: 対象なし
- s9: NablarchTesting Framework
- s10: 画面オンライン処理のリクエスト単体テストにてリソースファイルの修正が反映されない不具合の修正
- s11: FAQ
- s12: 対象なし
- s13: APIドキュメント
- s14: 公開APIを追加
- s15: Nablarch Application Framework解説書
- s16: 対象なし

### ■Nablarch開発標準 1.2.0版リリースノート
path: releases/releases/releases-nablarch-開発標準-1.2.0-releasenote-detail.json
- s1: 設計標準
- s2: 対象なし。
- s3: ドキュメント規約
- s4: 対象なし。
- s5: 設計書フォーマット
- s6: ドメイン定義書の修正。
- s7: 外部インターフェース設計書の修正。
- s8: コーディング規約
- s9: 誤記、体裁不備の修正
- s10: SQLコーディング規約の追加。
- s11: Javaコーディング規約記載のNAF使用可能APIの参照先変更。
- s12: 単体テスト
- s13: 誤字の修正。
