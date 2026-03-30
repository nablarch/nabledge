# Nablarch 用語集

## アルファベット順用語集

| 用語 | 意味 |
|---|---|
| Action（業務アクションハンドラ） | 業務コンポーネントのステレオタイプの一つ。フレームワークから直接コールバックされ、業務処理のエントリーポイントとなるクラス。詳細: [fw-bussiness-component-label](about-nablarch-determining_stereotypes.md) |
| Component（業務共通コンポーネント） | 業務コンポーネントのステレオタイプの一つ。業務ロジックを実装するクラス。詳細: [fw-bussiness-component-label](about-nablarch-determining_stereotypes.md) |
| DIコンテナ | コンポーネント（オブジェクト）のインスタンス、およびコンポーネント間の依存関係を管理するコンテナ。 |
| Entity（エンティティ） | データベースから取得したデータ、およびデータベースを更新するためのデータを保持するクラス。 |
| Form（業務フォーム） | アプリケーションで使用するデータの保持と、外部入力値の精査を実行するクラス。詳細: [fw-bussiness-component-label](about-nablarch-determining_stereotypes.md) |
| Nablarch Application Framework | Nablarchを構成する４つのソフトウェアのうち、メインとなるJavaアプリケーションフレームワーク。詳細: [Nablarch Application Framework解説書](./fw/reference/index.html) |
| View（業務画面） | 業務コンポーネントのステレオタイプの一つ。画面オンライン処理において、ユーザが使用するインタフェースを提供する。詳細: [fw-bussiness-component-label](about-nablarch-determining_stereotypes.md) |
| Webフロントコントローラ | 画面オンライン実行制御基盤において、リクエスト処理を担うコントローラ。詳細: :ref:`WebFrontController` |

<details>
<summary>keywords</summary>

Action, Component, DIコンテナ, Entity, Form, Nablarch Application Framework, View, Webフロントコントローラ, 業務アクションハンドラ, 業務共通コンポーネント, 業務フォーム, 業務画面, エンティティ

</details>

## 五十音順用語集 — あ行

| 用語 | 意味 |
|---|---|
| アプリケーションプログラマ | 設計書の内容に従い、業務アプリケーションのプログラミングおよびテストを担当する人。 |
| アーキテクト | Nablarchのフレームワークや開発標準に精通し、プロジェクトへの導入を担当する人。フレームワークのカスタマイズ、方式設計、開発標準のテーラリング、プロジェクトメンバの教育などを行う。 |
| ウィンドウスコープ | ウィンドウやタブごとに個別の変数を保持するためのスコープ。詳細: [scope](about-nablarch-concept.md) |

<details>
<summary>keywords</summary>

アプリケーションプログラマ, アーキテクト, ウィンドウスコープ

</details>

## 五十音順用語集 — か行

| 用語 | 意味 |
|---|---|
| 開閉局 | 任意の単位（リクエスト、機能など）のサービス提供可否のチェックと、切り替えを行う機能。詳細: :ref:`serviceAvailable` |
| 画面オンライン実行制御基盤 | HTMLをベースとしたUIを伴う標準的なWebアプリケーションを実装する場合に使用する実行制御基盤。Java EEアプリケーションサーバ上で動作することを前提とする。詳細: [web_gui](../../processing-pattern/web-application/web-application-web_gui.md) |
| 環境設定ファイル | 環境によって変化する設定値をプロパティファイルに似た形式で記述するファイル。詳細: [repository_config_load](../../component/libraries/libraries-02_01_Repository_config.md) |
| 業務コンポーネント | Nablarch Application Frameworkをベースに開発者が作成する業務アプリケーション。４つのステレオタイプ（Action/Component/Entity/View）より構成される。 |
| クラス単体テスト | 業務アプリケーションの個々のプログラム（EntityクラスやComponentクラス）が正しく動作するかを確認するテスト。詳細: :ref:`class_unit_test` |
| コード管理 | アプリケーションで使用するコードに関する操作を容易にするための機能。コードとは、性別区分（1:男性、2:女性）や年代区分（01:10歳未満、02:10代、03:20代、04:30代、05:40代以上）のようなコード値とコード名称のことを指す。詳細: :ref:`code_manager` |
| コンポーネント | DIコンテナで管理されるオブジェクト。通常、オブジェクト一つ一つのことをコンポーネントと称するが、共通コンポーネント、業務コンポーネントのように、概念や機能のまとまりをコンポーネントと称する場合もある。 |
| コンポーネント設定ファイル | DIコンテナで管理されるコンポーネントの設定を記述するXMLファイル。クラス名、プロパティの設定値、クラス間の依存関係を記述する。詳細: [repository_config](../../component/libraries/libraries-02_01_Repository_config.md) |

<details>
<summary>keywords</summary>

開閉局, 画面オンライン実行制御基盤, 環境設定ファイル, 業務コンポーネント, クラス単体テスト, コード管理, コンポーネント, コンポーネント設定ファイル

</details>

## 五十音順用語集 — さ行

| 用語 | 意味 |
|---|---|
| 実行コンテキスト | 各リクエストを処理する際に必要な情報を保持するオブジェクト。リクエストスコープ/セッションスコープへの参照やハンドラキューを管理する。詳細: [basic_architecture](about-nablarch-concept.md) |
| 自動テストフレームワーク | クラス単体テスト、リクエスト単体テストのテスト実行を自動化する機能を提供するフレームワーク。詳細: [auto-test-framework](../../development-tools/testing-framework/testing-framework-01_Abstract.md) |
| ステレオタイプ | 典型的な型（インタフェース）。アーキテクチャの代表的な構成要素を表す意味として使用する。 |
| スレッドコンテキスト | 一連の処理を実行するときに、スレッド毎に共通的に使用するデータ（ユーザID、リクエストIDなど）を保持するクラス。詳細: [thread-context-label](../../component/libraries/libraries-thread_context.md) |
| 静的データ | コードやメッセージといったRDBMSやXMLファイル等の媒体に保存される、基本的に変更の入らないデータ。詳細: :ref:`static_data_cache` |

<details>
<summary>keywords</summary>

実行コンテキスト, 自動テストフレームワーク, ステレオタイプ, スレッドコンテキスト, 静的データ

</details>

## 五十音順用語集 — た行

| 用語 | 意味 |
|---|---|
| メッセージング実行制御基盤 | 外部から送信される各要求電文に対し、電文中のリクエストIDに対応する業務アプリケーションを実装する場合に使用する実行制御基盤。 |
| 取引単体テスト | 業務的な取引単位のテスト。画面オンライン処理方式では、複数画面をまたがった遷移やJavaScriptなどクライアント側の動作が正しいことを確認する。詳細: :ref:`deal_unit_test` |

<details>
<summary>keywords</summary>

メッセージング実行制御基盤, 取引単体テスト

</details>

## 五十音順用語集 — な行

| 用語 | 意味 |
|---|---|
| 内蔵サーバ | 画面オンライン処理方式で作成したWebアプリケーションの動作確認・リクエスト単体テストを行う際に使用する軽量サーバ。詳細: [request-util-test-online](../../development-tools/testing-framework/testing-framework-02_RequestUnitTest.md) |

<details>
<summary>keywords</summary>

内蔵サーバ

</details>

## 五十音順用語集 — は行

| 用語 | 意味 |
|---|---|
| バッチ実行制御基盤 | DBやファイルなどに格納されたデータを入力とするバッチアプリケーションを実装する際に使用する実行制御基盤。 |
| ハンドラ | 入力データに対して処理を行う全てのモジュールが実装するインターフェースおよびそれを実装したクラス。リクエストハンドラ、エラーハンドラ、認証・認可ハンドラ、開閉局ハンドラなどの種類がある。詳細: [basic_architecture](about-nablarch-concept.md) |
| ハンドラキュー | 入力データを処理するハンドラを実行順に保持するキュー。 |
| ビジネスロジック | 業務に特化したロジックの実装。本書内では、例えば利率計算といったロジックだけでなく、画面入力値の精査等、業務コンポーネントに実装するロジックを全てビジネスロジックと称する。 |

<details>
<summary>keywords</summary>

バッチ実行制御基盤, ハンドラ, ハンドラキュー, ビジネスロジック

</details>

## 五十音順用語集 — ら行

| 用語 | 意味 |
|---|---|
| リクエスト | 業務処理依頼のイベント及びその依頼内容を表す入力データ。画面オンライン処理方式では基本的に入力データ=リクエストであるが、バッチ処理方式などでは、1リクエストに対して複数の入力データ(複数件のレコード)を処理することになる。 |
| リクエストID | 処理依頼（イベント）の種類につけるID。Webアプリケーションの場合はボタンやリンクの押下の種類、バッチアプリケーションの場合はバッチ処理の種類を表す。 |
| リクエスト単体テスト | 一つの処理リクエストを受け取って正しく動作するかを確認するテスト。画面オンライン処理方式では、HTTPリクエスト送信からビジネスロジックの実行、画面表示までの一連の処理を確認する。詳細: :ref:`request_unit_test` |
| リポジトリ | Nablarch Application Frameworkが提供するDIコンテナ。コンポーネント設定ファイルの内容に従い、コンポーネントのインスタンス化およびコンポーネント間の関連づけを行う。詳細: :ref:`repository` |

<details>
<summary>keywords</summary>

リクエスト, リクエストID, リクエスト単体テスト, リポジトリ

</details>
