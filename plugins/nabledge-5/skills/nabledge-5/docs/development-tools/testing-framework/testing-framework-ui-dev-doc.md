# Nablarch UI開発基盤 解説書

* `Bullet list ends without a blank line; unexpected unindent.`
* `/`

> **Important:**
> UI開発基盤を使用する際には、以下の知識が必要となる。
> これらの有識者がいない場合、UI開発基盤の使用は困難である。

> * >   [Node.js](https://nodejs.org/en/)
> * >   [RequireJS](https://requirejs.org/)
> * >   [jQuery](https://jquery.com/)
> * >   [Sugar](https://sugarjs.com/)
> * >   [less](https://lesscss.org/)

> また、UI開発基盤は設計工程からJSPを作成するアプローチを採用しているが、以下の理由により、「設計工程用JSPと開発工程用JSPのダブルメンテナンス」が往々にして発生する

> * >   JSPに設計工程のみで必要な情報を埋め込むことになるため、開発工程での可読性が著しく低下する。
> * >   開発時に分岐などのロジックが埋め込まれた場合、設計工程と開発工程で全く同じJSPは使用不可能である。

**目次**

[本書の内容](../../development-tools/testing-framework/testing-framework-about-this-book.md)

[本書の構成](../../development-tools/testing-framework/testing-framework-book-layout.md)

[関連文書](../../development-tools/testing-framework/testing-framework-related-documents.md)

**I: はじめに**

1. [Nablarch UI開発基盤の特徴](../../development-tools/testing-framework/testing-framework-intention.md)
2. [設計指針](../../development-tools/testing-framework/testing-framework-grand-design.md)
3. [UI開発ワークフロー](../../development-tools/testing-framework/testing-framework-ui-development-workflow.md)

**II: 開発作業手順**

1. [UI開発基盤の導入](../../development-tools/testing-framework/testing-framework-initial-setup.md)
2. [UI開発基盤の展開](../../development-tools/testing-framework/testing-framework-redistribution.md)
3. [UI標準のカスタマイズとUI開発基盤への反映](../../development-tools/testing-framework/testing-framework-modifying-code-and-testing.md)
4. [Nablarch 標準プラグインの更新](../../development-tools/testing-framework/testing-framework-update-bundle-plugin.md)

**III: プロジェクトのファイル構成と変更管理**

1. [標準プロジェクト構成](../../development-tools/testing-framework/testing-framework-directory-layout.md)
2. [UIプラグイン](../../development-tools/testing-framework/testing-framework-plugins.md)

**IV: アーキテクチャ詳説**

1. [全体構造](../../development-tools/testing-framework/testing-framework-architecture-overview.md)
2. [業務画面テンプレート](../../development-tools/testing-framework/testing-framework-jsp-page-templates.md)
3. [UI部品ウィジェット](../../development-tools/testing-framework/testing-framework-jsp-widgets.md)
4. [CSSフレームワーク](../../development-tools/testing-framework/testing-framework-css-framework.md)
5. [マルチレイアウト用CSSフレームワーク](../../development-tools/testing-framework/testing-framework-multicol-css-framework.md)
6. [JavaScript UI部品](../../development-tools/testing-framework/testing-framework-js-framework.md)
7. [業務画面JSPローカル表示機能](../../development-tools/testing-framework/testing-framework-inbrowser-jsp-rendering.md)
8. [設計書ビュー表示機能](../../development-tools/testing-framework/testing-framework-showing-specsheet-view.md)
9. [プラグインビルドコマンド仕様](../../development-tools/testing-framework/testing-framework-plugin-build.md)

**V: リファレンス**

1. [UI標準修正事例一覧](../../development-tools/testing-framework/testing-framework-ui-dev-doc-reference-ui-standard.md)
2. [UI部品ウィジェット一覧](../../development-tools/testing-framework/testing-framework-ui-dev-doc-reference-jsp-widgets.md)
3. [JavaScript UI部品一覧](../../development-tools/testing-framework/testing-framework-reference-js-framework.md)
4. [UIプラグイン一覧](../../development-tools/testing-framework/testing-framework-ui-dev-doc-reference-ui-plugin.md)

**VI: 補足資料**

1. [基盤部品のテスト実施項目](../../development-tools/testing-framework/testing-framework-testing.md)
2. [既知の問題](../../development-tools/testing-framework/testing-framework-known-issues.md)
