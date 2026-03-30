# Nablarch フォルダのコンテンツについて

## フォルダ構成

nablarchフォルダの構成:

- `nablarch/`
  - `release_note/` — リリースノートが格納
  - `library/` — Nablarchライブラリが格納
    - `fw/` — Nablarch Application Frameworkが格納
      - `nablarch.jar` — Application Frameworkのオブジェクトコード
      - `lib/` — Application Frameworkのコンパイル時に使用したライブラリ（詳細はreadme.txt参照）
      - `doc/` — Application Frameworkの解説書
      - `javadoc/` — Application FrameworkのJavadoc（アーキテクトが使用可能なAPIのみ）
      - `javadoc_pg/` — Application FrameworkのJavadoc（アプリケーションプログラマが使用可能なAPIのみ）
    - `tfw/` — Nablarch Testing Frameworkが格納
      - `nablarch-tfw.jar` — Testing Frameworkのオブジェクトコード
      - `lib/` — Testing Frameworkの実行に必要なライブラリ（詳細はreadme.txt参照）
      - `javadoc/` — Testing FrameworkのJavadoc（アーキテクトが使用可能なAPIのみ）
      - `javadoc_pg/` — Testing FrameworkのJavadoc（アプリケーションプログラマが使用可能なAPIのみ）
  - `guide/` — Nablarchガイドが格納
    - `development_guide/` — Nablarch開発ガイド
    - `environment_guide/` — Nablarch環境構築ガイド
      - `開発環境構築ガイド.doc` — 開発者がPC用の統合開発環境をセットアップする手順
      - `開発リポジトリ構築ガイド.doc` — アプリケーション開発環境（CI、バージョン管理、IDE）の構築手順（アーキテクト向け）
      - `開発リポジトリ構築ビルドファイル` — 開発リポジトリ構築に必要なAntビルドファイル
    - `tutorial/` — チュートリアル用サンプルアプリケーション
      - `Nablarch-sample-workspace.zip` — サンプルのソースコード（Eclipse Workspace形式）
      - `Nablarch-dev-env.zip` — サンプル動作に必要なソフトウェアパッケージ（Eclipse 3.6、Apache Tomcat 6.0.32）
  - `standard/` — Nablarch開発標準
    - `coding_rule/` — コーディング規約（Java、JSP、SQL、シェルスクリプト）
    - `design_standard/` — 設計標準（ユーザインターフェース標準、共通コンポーネント設計標準）
    - `document_format/` — 設計書のフォーマットとサンプル
    - `document_standard_style/` — ドキュメント規約
    - `unit_test/` — 単体テスト標準
    - `wbs/` — Nablarchを使用したシステム開発における標準WBS
  - `sample/` — Nablarchサンプル
    - `fw_integration_sample/` — Nablarch拡張モジュールのサンプル
      - `log4j/` — ログ出力機能でlog4jを使用する場合のサンプル
        - `doc/` — サンプルの設定、使用方法についての解説書
        - `src/` — サンプルのソースコード
      - `smime/` — bouncycastleを使用したS/MIME対応電子署名付きメール送信サンプル
        - `doc/` — サンプルの設定、使用方法についての解説書
        - `src/` — サンプルのソースコード
      - `wmq/` — WebsphereMQを使用した分散トランザクションのメッセージングサンプル
        - `doc/` — サンプルの設定、使用方法についての解説書
        - `src/` — サンプルのソースコード
    - `log_statistics_sample/` — 運用時に使用するログ集計機能のサンプル
      - `doc/` — サンプルの設定、使用方法についての解説書
      - `src/` — サンプルのソースコード
  - `toolbox/` — Nablarch Toolbox
    - `doc/` — Toolboxの解説書（使用方法はこのドキュメントを参照）
    - `src/` — Toolboxのソースコード（Toolbox改修時に使用）

<details>
<summary>keywords</summary>

フォルダ構成, nablarch, Application Framework, Testing Framework, Nablarchガイド, Nablarch開発標準, コーディング規約, チュートリアル, Nablarch Toolbox, サンプル, log4j, smime, bouncycastle, WebsphereMQ

</details>
