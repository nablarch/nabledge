# Nablarchのコンテンツ

## フォルダ構成

## nablarch/ フォルダ構成

| フォルダパス | 説明 |
|---|---|
| `nablarch/release_note/` | リリースノート |
| `nablarch/app_exe_env/` | アプリケーション実行環境 |
| `nablarch/app_exe_env/fw/` | Nablarch Application Framework本体 |
| `nablarch/app_exe_env/fw/dist/` | オブジェクトコード |
| `nablarch/app_exe_env/fw/lib/` | Application Frameworkのコンパイル時使用ライブラリ（詳細はreadme.txt参照） |
| `nablarch/app_exe_env/fw/src/` | ソースコード |
| `nablarch/app_exe_env/fw_doc/` | Nablarch Application Frameworkの解説書およびAPIドキュメント |
| `nablarch/app_exe_env/fw_doc/doc/` | 解説書 |
| `nablarch/app_exe_env/fw_doc/javadoc/` | javadoc（アーキテクトが使用可能なAPIのみ） |
| `nablarch/app_exe_env/fw_doc/javadoc_pg/` | javadoc（アプリケーションプログラマが使用可能なAPIのみ） |
| `nablarch/app_dev_env/` | アプリケーション開発環境 |
| `nablarch/app_dev_env/app_dev/` | アプリケーション開発基盤（開発環境構築ガイド、開発リポジトリ構築ガイド、開発リポジトリ構築ビルドファイル、開発環境パッケージ[Eclipse・Apache Tomcat含む]） |
| `nablarch/app_dev_env/ui_dev/` | Nablarch UI開発基盤（doc/, guide/, src/） |
| `nablarch/app_dev_env/mobile/` | Nablarchモバイルライブラリ |
| `nablarch/app_dev_env/mobile/doc/` | 解説書（アーキテクチャドキュメント: arch_doc/index.html） |
| `nablarch/app_dev_env/mobile/ios/` | iOS版資材（bin/, src/, appledoc/, sample/） |
| `nablarch/app_dev_env/workflow/` | Nablarchワークフローライブラリ（doc/, src/, design_guide/, tool/, sample_application/） |
| `nablarch/app_dev_env/app_lib/` | Nablarchアプリケーションライブラリ（ソースコードディレクトリから必要ファイルをプロジェクトに取り込んで利用） |
| `nablarch/app_dev_env/app_lib/biz_sample/` | 頻繁に利用される業務機能のサンプル |
| `nablarch/app_dev_env/app_lib/fw_integration_sample/` | Nablarchを拡張して特定製品に対応させる拡張モジュールのサンプル |
| `nablarch/app_dev_env/app_lib/fw_integration_sample/log4j/` | ログ出力機能でlog4j使用時のサンプル |
| `nablarch/app_dev_env/app_lib/fw_integration_sample/smime/` | メール送信機能でbouncycastleを使用し、S/MIME対応の電子署名付きメール送信を実現するサンプル |
| `nablarch/app_dev_env/app_lib/fw_integration_sample/wmq/` | メッセージング機能でWebsphereMQを使用し、分散トランザクションを実現するサンプル |
| `nablarch/app_dev_env/app_lib/fw_integration_sample/db/` | 特定データベース向けにNablarch実装を拡張する実装サンプル |
| `nablarch/app_dev_env/app_lib/messaging_simulator_sample/` | メッセージング基盤テストシミュレータのサンプル |
| `nablarch/app_dev_env/app_lib/operation_sample/` | 運用機能サンプル |
| `nablarch/app_dev_env/app_lib/operation_sample/log_statistics_sample/` | 運用時に使用するログ集計機能のサンプル |
| `nablarch/app_dev_env/tfw/` | Nablarch Testing Framework（dist/[auto_test/, test_tool/], lib/, src/） |
| `nablarch/app_dev_env/tfw_doc/` | Nablarch Testing FrameworkのAPIドキュメント |
| `nablarch/app_dev_env/tfw_doc/javadoc/` | javadoc（アーキテクトが使用可能なAPIのみ） |
| `nablarch/app_dev_env/tfw_doc/javadoc_pg/` | javadoc（アプリケーションプログラマが使用可能なAPIのみ） |
| `nablarch/app_dev_env/toolbox/` | Nablarch Toolbox（doc/, src/） |
| `nablarch/app_dev_guide/` | Nablarch開発標準およびガイド |
| `nablarch/app_dev_guide/standard/` | Nablarch開発標準（dev_process_standard/, design_standard/[UI標準・DB設計標準・共通コンポーネント設計標準], coding_rule/[Java/Objective-C/JSP/SQL/javascript/シェルスクリプト], unit_test/, document_standard_style/, document_format/） |
| `nablarch/app_dev_guide/guide/development_guide/` | Nablarch開発ガイド |
| `nablarch/app_dev_guide/guide/tutorial/` | 基本的な業務アプリケーションの実装方法を示したチュートリアル用サンプルアプリケーション |

- **アプリケーション開発の全体像を知りたい**: [Nablarchを使用したシステム開発における標準WBS](./app_dev_guide/standard/dev_process_standard/Nablarchを使用したシステム開発における標準WBS.xls) — 各コンテンツをどの工程でどのように使う想定かを解説

- **プログラミング・単体テストの実施方法を知りたい**:
  1. [開発環境構築ガイド](./app_dev_env/app_dev/開発環境構築ガイド.doc)に従いサンプルアプリをインストール（必要資源は[開発環境パッケージ](./app_dev_env/app_dev/Nablarch-dev-env.zip)に含まれる）
  2. [プログラミング・単体テストガイド](./app_dev_guide/guide/development_guide/index.html)で学習

- **Application Frameworkの詳しい仕様を知りたい**: [Application Framework解説書](./app_exe_env/fw_doc/doc/index.html)

- **開発環境（CI環境、リポジトリ等）の構築方法を知りたい**: [開発リポジトリ構築ガイド](./app_dev_env/app_dev/開発リポジトリ構築ガイド.doc)

- **Nablarch Toolboxのツール・使い方を知りたい**: [Nablarch Toolbox解説書](./app_dev_env/toolbox/doc/index.html)

<details>
<summary>keywords</summary>

フォルダ構成, ディレクトリ構造, nablarch配布パッケージ, app_exe_env, app_dev_env, app_dev_guide, Nablarch Application Framework, Nablarch Testing Framework, Nablarch Toolbox, アプリケーション開発環境, ワークフローライブラリ, モバイルライブラリ, アプリケーションライブラリ, コンテンツ案内, アプリケーション開発全体像, 開発環境構築, プログラミング・単体テストガイド, Application Framework解説書, 開発リポジトリ構築

</details>
