# Nablarch フォルダのコンテンツについて

## フォルダ構成

nablarchフォルダの構成:

```
nablarch/
├── release_note/              - リリースノートが格納
├── library/                   - Nablarchライブラリが格納
│   ├── fw/                    - Nablarch Application Frameworkが格納
│   │   ├── nablarch.jar       - Application Frameworkのオブジェクトコード
│   │   ├── lib/               - コンパイル時使用ライブラリ（同ディレクトリのreadme.txt参照）
│   │   ├── doc/               - Application Frameworkの解説書
│   │   ├── javadoc/           - アーキテクト向けjavadoc
│   │   └── javadoc_pg/        - アプリケーションプログラマ向けjavadoc
│   └── tfw/                   - Nablarch Testing Frameworkが格納
│       ├── nablarch-tfw.jar   - Testing Frameworkのオブジェクトコード
│       ├── lib/               - 実行に必要なライブラリ（同ディレクトリのreadme.txt参照）
│       ├── javadoc/           - アーキテクト向けjavadoc
│       └── javadoc_pg/        - アプリケーションプログラマ向けjavadoc
├── guide/                     - Nablarchガイドが格納
│   ├── development_guide/     - Nablarch開発ガイド
│   ├── environment_guide/     - Nablarch環境構築ガイド（Antビルドファイル含む）
│   │   ├── 開発環境構築ガイド.doc         - 個々の開発者向けIDE環境セットアップ手順
│   │   ├── 開発リポジトリ構築ガイド.doc   - CI/バージョン管理等の開発環境構築手順（アーキテクト向け）
│   │   └── 開発リポジトリ構築ビルドファイル - 開発リポジトリ構築用Antビルドファイル
│   └── tutorial/              - チュートリアル用サンプルアプリケーション
│       ├── Nablarch-tutorial-workspace.zip - サンプルソースコード（Eclipseワークスペース形式）
│       └── Nablarch-dev-env.zip            - 動作環境パッケージ（Eclipse 3.6、Apache Tomcat 6.0.32）
├── standard/                  - Nablarch開発標準
│   ├── coding_rule/           - コーディング規約（Java/JSP/SQL/JavaScript/シェルスクリプト）
│   ├── design_standard/       - 設計標準（UI/DB/共通コンポーネント）
│   ├── document_format/       - 設計書フォーマットとサンプル
│   ├── document_standard_style/ - ドキュメント規約
│   ├── unit_test/             - 単体テスト標準
│   └── wbs/                   - 標準WBS
├── sample/                    - Nablarchサンプル（ソースコードをプロジェクトに取り込んで利用）
│   ├── biz_sample/            - 頻繁に利用される業務機能のサンプル
│   ├── fw_integration_sample/ - Nablarch拡張実装サンプル
│   │   ├── log4j/             - log4jを使用したログ出力サンプル
│   │   ├── smime/             - bouncycastleを使用したS/MIME電子署名付きメール送信サンプル
│   │   ├── wmq/               - WebsphereMQを使用した分散トランザクションサンプル
│   │   └── db/                - 特定データベース向けNablarch拡張実装サンプル
│   ├── log_statistics_sample/ - 運用時ログ集計機能のサンプル
│   └── ui/                    - UI開発基盤サンプル（JSP/HTML作成ガイド含む）
└── toolbox/                   - Nablarch Toolbox
    ├── doc/                   - Toolboxの解説書・使用方法
    └── src/                   - Toolboxのソースコード（改修時使用）
```

Nablarchのコンテンツの見方を目的別に説明します。

- **アプリケーション開発の全体像を知りたい**: [Nablarchを使用したシステム開発における標準WBS](./standard/wbs/Nablarchを使用したシステム開発における標準WBS.xls) — 各コンテンツをどの工程でどのように使う想定かを解説

- **プログラミング・単体テストの実施方法を知りたい**:
  1. [開発環境構築ガイド](./guide/environment_guide/開発環境構築ガイド.doc) に従いサンプルアプリをインストール（必要なリソースの場所は「フォルダ構成」参照）
  2. [プログラミング・単体テストガイド](./guide/development_guide/index.html) で学習

- **Application Frameworkの詳しい仕様を知りたい**: [Application Framework解説書](./library/fw/doc/index.html)

- **開発環境（CI環境、リポジトリ等）の構築方法を知りたい**: [開発リポジトリ構築ガイド](./guide/environment_guide/開発リポジトリ構築ガイド.doc)

- **Nablarch Toolboxのツール一覧・使い方を知りたい**: [Nablarch Toolbox解説書](./toolbox/doc/index.html)

<details>
<summary>keywords</summary>

フォルダ構成, ディレクトリ構成, nablarch, Application Framework, Testing Framework, ライブラリ構成, サンプル, 開発標準, ガイド, Toolbox, Nablarchコンテンツ参照ガイド, 目的別ドキュメント案内, 標準WBS, 開発環境構築ガイド, プログラミング単体テストガイド, Application Framework解説書, Nablarch Toolbox解説書, 開発リポジトリ構築ガイド, 開発全体像, コンテンツ参照方法

</details>
