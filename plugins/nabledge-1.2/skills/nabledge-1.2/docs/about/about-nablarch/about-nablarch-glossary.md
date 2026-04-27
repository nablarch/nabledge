# Nablarch 用語集

本書で使用する用語と、その用語の本書における意味を下記に示す。

## アルファベット順

### A～G

| 用語 | 意味 |
|---|---|
| Action（業務アクションハンドラ ） | 業務コンポーネントのステレオタイプの一つ。フレームワークから直接コールバックされ、業務処理のエントリーポイントとなるクラス。詳細については、 [業務コンポーネントの責務配置](../../about/about-nablarch/about-nablarch-determining-stereotypes.md#fw-bussiness-component-label) を参照。 |
| Component（業務共通コンポーネント） | 業務コンポーネントのステレオタイプの一つ。業務ロジックを実装するクラス。詳細については、 [業務コンポーネントの責務配置](../../about/about-nablarch/about-nablarch-determining-stereotypes.md#fw-bussiness-component-label) を参照。 |
| DIコンテナ | コンポーネント（オブジェクト）のインスタンス、およびコンポーネント間の依存関係を管理するコンテナ。 |
| Entity（エンティティ） | データベースから取得したデータ、およびデータベースを更新するためのデータを保持するクラス。 |
| Form（業務フォーム） | アプリケーションで使用するデータの保持と、外部入力値の精査を実行するクラス。詳細については、 [業務コンポーネントの責務配置](../../about/about-nablarch/about-nablarch-determining-stereotypes.md#fw-bussiness-component-label) を参照。 |

### H～N

| 用語 | 意味 |
|---|---|
| Nablarch Application Framework | Nablarchを構成する４つのソフトウェアのうち、メインとなるJavaアプリケーションフレームワーク。詳細については、 [Nablarch Application Framework解説書](./fw/reference/index.html) を参照。 |

### O～U

### V～Z

| 用語 | 意味 |
|---|---|
| View（業務画面） | 業務コンポーネントのステレオタイプの一つ。画面オンライン処理において、ユーザが使用するインタフェースを提供する。詳細については、 [業務コンポーネントの責務配置](../../about/about-nablarch/about-nablarch-determining-stereotypes.md#fw-bussiness-component-label) を参照。 |
| Webフロントコントローラ | 画面オンライン実行制御基盤において、リクエスト処理を担うコントローラ。詳細については、 [Webフロントコントローラ (サーブレットフィルタ)](../../component/handlers/handlers-WebFrontController.md#webfrontcontroller) を参照。 |

## 五十音順

### あ行

| 用語 | 意味 |
|---|---|
| アプリケーションプログラマ | 設計書の内容に従い、業務アプリケーションのプログラミングおよびテストを担当する人。 |
| アーキテクト | Nablarchのフレームワークや開発標準に精通し、プロジェクトへの導入を担当する人。フレームワークのカスタマイズ、方式設計、開発標準のテーラリング、プロジェクトメンバの教育などを行う。 |
| ウィンドウスコープ | ウィンドウやタブごとに個別の変数を保持するためのスコープ。詳細については、 [変数スコープ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#scope) を参照。 |

### か行

| 用語 | 意味 |
|---|---|
| 開閉局 | 任意の単位（リクエスト、機能など）のサービス提供可否のチェックと、切り替えを行う機能。詳細については、 [開閉局](../../component/libraries/libraries-05-ServiceAvailability.md#serviceavailable) を参照。 |
| 画面オンライン実行制御基盤 | HTMLをベースとしたUIを伴う標準的なWebアプリケーションを実装する場合に使用する実行制御基盤。Java EEアプリケーションサーバ上で動作することを前提とする。詳細については、 [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md#web-gui) を参照。 |
| 環境設定ファイル | 環境によって変化する設定値をプロパティファイルに似た形式で記述するファイル。詳細については、 [環境設定ファイルからの読み込み](../../component/libraries/libraries-02-01-Repository-config.md#repository-config-load) を参照。 |
| 業務コンポーネント | Nablarch Application Frameworkをベースに開発者が作成する業務アプリケーション。４つのステレオタイプ（Action/Component/Entity/View）より構成される。 |
| クラス単体テスト | 業務アプリケーションの個々のプログラム（Entityクラス/Componentクラス）が正しく動作するかを確認するテスト。詳細については、 [クラス単体テスト概要](../../development-tools/testing-framework/testing-framework-01-UnitTestOutline.md#class-unit-test) を参照。 |
| コード管理 | アプリケーションで使用するコードに関する操作を容易にするための機能。この機能が扱うコードとは、性別区分(1:男性、2:女性)や年代区分(01:10歳未満、02:10代、03:20代、04:30代、05:40代以上)のようなコードの値(コード値)とその意味を表わす文字列(コード名称)のことを表す。詳細については、 [コード管理](../../component/libraries/libraries-02-CodeManager.md#code-manager) を参照。 |
| コンポーネント | DIコンテナで管理されるオブジェクト。通常、オブジェクト一つ一つのことをコンポーネントと称するが、共通コンポーネント、業務コンポーネントのように、概念や機能のまとまりをコンポーネントと称する場合もある。 |
| コンポーネント設定ファイル | DIコンテナで管理されるコンポーネントの設定を記述するファイル。XML形式でクラス名やプロパティの設定値、クラス間の依存関係を記述する。詳細については、 [設定ファイルの種類とフレームワークが行うリポジトリの初期化](../../component/libraries/libraries-02-01-Repository-config.md#repository-config) を参照。 |

### さ行

| 用語 | 意味 |
|---|---|
| 実行コンテキスト | 各リクエストを処理する際に必要な情報を保持するオブジェクト。リクエストスコープ/セッションスコープへの参照や、ハンドラキューを管理している。詳細については、 [NAF基本アーキテクチャ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#basic-architecture) を参照。 |
| 自動テストフレームワーク | クラス単体テスト、リクエスト単体テストについて、テスト実行を自動化する機能を提供するフレームワーク。詳細については、 [自動テストフレームワーク](../../development-tools/testing-framework/testing-framework-01-Abstract.md#auto-test-framework) を参照。 |
| ステレオタイプ | 典型的な型（インタフェース）。本書内では、アーキテクチャの代表的な構成要素を表す意味として使用している。 |
| スレッドコンテキスト | 一連の処理を実行するときに、スレッド毎に共通的に使用するデータ（ユーザID、リクエストIDなど）を保持するクラス。詳細については、 [同一スレッド内でのデータ共有(スレッドコンテキスト)](../../component/libraries/libraries-thread-context.md#thread-context-label) を参照。 |
| 静的データ | コードやメッセージといったRDBMSやXMLファイル等の媒体に保存される、基本的に変更の入らないデータ。詳細については、 [静的データのキャッシュ](../../component/libraries/libraries-05-StaticDataCache.md#static-data-cache) を参照。 |

### た行

| 用語 | 意味 |
|---|---|
| メッセージング実行制御基盤 | 外部から送信される各要求電文に対し、電文中のリクエストIDに対応する業務アプリケーションを実装する場合に使用する実行制御基盤。 |
| 取引単体テスト | 業務的な取引単位のテスト。画面オンライン処理方式では、複数画面をまたがって遷移した場合の動作が正しいことや、JavaScriptなどのクライアント側の動作が正しいことを確認するテストを取引単体テストと定義する。詳細については、 [取引単体テスト概要](../../development-tools/testing-framework/testing-framework-01-UnitTestOutline.md#deal-unit-test) を参照。 |

### な行

| 用語 | 意味 |
|---|---|
| 内蔵サーバ | 画面オンライン処理方式で作成したWebアプリケーションの動作確認・リクエスト単体テストを行う際に使用する軽量サーバ。詳細については、 [リクエスト単体テスト（画面オンライン処理）](../../development-tools/testing-framework/testing-framework-06-testfwguide-02-RequestUnitTest.md#request-util-test-online) を参照。 |

### は行

| 用語 | 意味 |
|---|---|
| バッチ実行制御基盤 | DBやファイルなどに格納されたデータを入力とするバッチアプリケーションを実装する際に使用する実行制御基盤。 |
| ハンドラ | 入力データに対して処理を行う全てのモジュールが実装するインターフェースおよびそれを実装したクラス。ハンドラには、リクエストハンドラ（リクエストプロセッサ）、エラーハンドラ、認証・認可ハンドラ、開閉局ハンドラなどの種類がある。詳細については、 [NAF基本アーキテクチャ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#basic-architecture) を参照。 |
| ハンドラキュー | 入力データを処理するハンドラを実行順に保持するキュー。 |
| ビジネスロジック | アプリケーションの構成要素のうち、業務に特化したロジックの実装。本書内では、例えば利率計算といったロジックだけでなく、画面入力値の精査等、業務コンポーネントに実装するロジックを全てビジネスロジックと称する。 |

### ま行

対象用語なし。

### や行

対象用語なし。

### ら行

| 用語 | 意味 |
|---|---|
| リクエスト | 業務処理依頼のイベント及びその依頼内容を表す入力データ。画面オンライン処理方式では基本的に 入力データ=リクエストであるが、バッチ処理方式などでは、1リクエストに対して複数の入力データ(複数件のレコード)を処理することになる。 |
| リクエストID | 処理依頼（イベント）の種類につけるID。Webアプリケーションの場合はボタンやリンクの押下の種類、バッチアプリケーションの場合はバッチ処理の種類を表す。 |
| リクエスト単体テスト | 一つの処理リクエストを受け取って正しく動作するかを確認するテスト。画面オンライン処理方式では、HTTPリクエスト送信から、ビジネスロジックの実行、画面表示までの一連の処理を確認することをリクエスト単体テストと定義する。詳細については、 [リクエスト単体テスト概要](../../development-tools/testing-framework/testing-framework-01-UnitTestOutline.md#request-unit-test) を参照。 |
| リポジトリ | Nablarch Application Frameworkが提供するDIコンテナ。コンポーネント設定ファイルの内容に従い、コンポーネントのインスタンス化、およびコンポーネント間の関連づけを行う。詳細については、 [リポジトリ](../../component/libraries/libraries-02-Repository.md#repository) を参照。 |

### わ行

対象用語なし。
