# リポジトリ

## 概要

リポジトリは設定値やフレームワークが提供するクラスのインスタンスなどを保持する入れ物。コンポーネント間の関連を構築するためDIコンテナの機能を持つ。

- 初期化処理はフレームワークの他の機能が行う（Webアプリケーションでは :ref:`NablarchServletContextListener` が行う）
- アプリケーションプログラマは本機能を環境設定の取得に使用する
- 環境設定の取得方法: :ref:`repository_get_config`

<details>
<summary>keywords</summary>

リポジトリ, DIコンテナ, SystemRepository, 設定値取得, コンポーネント管理, NablarchServletContextListener, repository_get_config

</details>

## 特徴

## DIコンテナによるコンポーネントの構築

以下のDIコンテナ機能を使用できる:
- セッタインジェクションおよびフィールドインジェクション
- 環境依存する設定項目の集約
- プロパティの簡易設定（文字列、boolean型、int型・long型の数値、文字列配列）
- インタフェースによる自動インジェクション
- プロパティ名による自動インジェクション

## リポジトリとDIコンテナの分離

SpringFrameworkなど他のDIコンテナ実装を使用した場合でも、本フレームワークおよびリポジトリの機能を使用できるよう、DIコンテナ機能とリポジトリ機能を分離して実装している。

## DIコンテナに登録したコンポーネントの初期化機能

コンポーネントのプロパティ設定後に独自初期化処理が必要な場合、本機能で初期化処理を行う。コンポーネントの依存関係による初期化順序の制約を考慮し、初期化順序を指定できる。詳細: :ref:`repository_initialize`

<details>
<summary>keywords</summary>

セッタインジェクション, フィールドインジェクション, 自動インジェクション, コンポーネント初期化, 初期化順序, DIコンテナ機能, repository_initialize

</details>

## 要求

## 実装済み機能

- ビジネスロジックのあらゆる箇所で設定値・コンポーネントを取得可能
- ファイルから設定値を読み込み可能
- ディレクトリ指定でそのディレクトリ以下のファイルをまとめて読み込み可能
- 設定値を複数ファイルに分割して定義可能
- 環境依存項目を環境設定ファイルに記述可能
- 設定値をJava起動オプション（-Dオプション）の値で上書き可能
- コンポーネント設定ファイルの定義を元にインスタンス間の関連を生成するDI機能
- DIの実行時、プロパティに一致する型のインスタンスを自動設定
- ファクトリインジェクション機能（OSSやサードパーティ製品のクラスをDIコンテナ上に作成）
- 複数のコンポーネント設定ファイルで同じ設定名を使用することで設定値を上書き可能
- 設定名が重複した際、例外を送出するかワーニングログを出力するかを選択可能
- DIコンテナに登録したクラスの初期化処理を実行可能
- DIコンテナを変更可能

## 未検討機能

- アプリケーションを停止することなく設定変更を反映
- バイナリデータの設定（暗号化鍵など）

<details>
<summary>keywords</summary>

環境設定ファイル, -Dオプション, 設定値上書き, ファクトリインジェクション, DI機能, 設定名重複

</details>

## 構成

## インタフェース

| インタフェース名 | 概要 |
|---|---|
| `nablarch.core.repository.ObjectLoader` | SystemRepositoryに保持するオブジェクトを読み込む |
| `nablarch.core.repository.di.ComponentDefinitionLoader` | コンポーネントの定義を読み込む |
| `nablarch.core.repository.initialization.ApplicationInitializer` | コンポーネントの初期化を行う |
| `nablarch.core.repository.initialization.Initializable` | 初期化処理を行う |
| `nablarch.core.repository.initialization.ComponentFactory` | コンポーネントの作成を行う（FactoryInjection機能で使用） |

## クラス

| クラス名 | 概要 |
|---|---|
| `nablarch.core.repository.SystemRepository` | 設定値およびコンポーネントを保持する |
| `nablarch.core.repository.ConfigFileLoader` | 環境設定ファイルから文字列の設定値を読み込む |
| `nablarch.core.repository.di.DiContainer` | DIコンテナ機能を実現。コンポーネント生成の責務を持つ。他ObjectLoaderが読み出した設定値も読み込める |
| `nablarch.core.repository.di.ComponentDefinition` | DiContainerがコンポーネント生成に使用する定義を保持する |
| `nablarch.core.repository.di.config.xml.XmlComponentDefinitionLoader` | XMLファイルからコンポーネントの定義を読み込む |
| `nablarch.core.repository.initialization.BasicApplicationInitializer` | Initializableを実装したコンポーネントを指定した順序で初期化する |

![リポジトリクラス図](../../../knowledge/component/libraries/assets/libraries-02_Repository/02_Repository_ClassDiagram.jpg)

<details>
<summary>keywords</summary>

ObjectLoader, ComponentDefinitionLoader, ApplicationInitializer, Initializable, ComponentFactory, SystemRepository, ConfigFileLoader, DiContainer, ComponentDefinition, XmlComponentDefinitionLoader, BasicApplicationInitializer

</details>

## リポジトリの設定方法と使用方法

リポジトリは設定ファイルに記載した内容を元にフレームワークが初期化を行うことで使用できる。設定ファイルの記述方法と設定値/コンポーネントの取得方法: [02/02_01_Repository_config](libraries-02_01_Repository_config.md)

<details>
<summary>keywords</summary>

コンポーネント設定ファイル, 設定値取得, 02/02_01_Repository_config

</details>

## コンポーネント初期化機能

DIコンテナはコンポーネントに必要な初期化処理を行うコンポーネント初期化機能を提供する（詳細: [initialize-label](#s2)）。設定方法の詳細: [02/02_02_Repository_initialize](libraries-02_02_Repository_initialize.md)

<details>
<summary>keywords</summary>

BasicApplicationInitializer, Initializable, コンポーネント初期化, initialize-label, 02/02_02_Repository_initialize

</details>

## ファクトリインジェクション

フレームワーク外のソフトウェアに含まれるクラスがJava Beansとして実装されていない場合、通常のリポジトリ設定では使用できない。ファクトリインジェクションを使用することで、これらのクラスをコンポーネントとして取り扱える。詳細: [02/02_03_Repository_factory](libraries-02_03_Repository_factory.md)

<details>
<summary>keywords</summary>

ファクトリインジェクション, ComponentFactory, Java Beans, 02/02_03_Repository_factory

</details>

## 設定の上書き

テスト時に本番環境向け設定の一部を変更（例：一部機能をスタブに置き換え）してテストを実行する場合に使用する機能。設定の上書き方法の詳細: [02/02_04_Repository_override](libraries-02_04_Repository_override.md)

<details>
<summary>keywords</summary>

設定の上書き, テスト設定, スタブ, 02/02_04_Repository_override

</details>
