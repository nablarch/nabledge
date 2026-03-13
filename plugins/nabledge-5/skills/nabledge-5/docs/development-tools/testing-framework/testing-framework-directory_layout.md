# 標準プロジェクト構成

**公式ドキュメント**: [標準プロジェクト構成](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/structure/directory_layout.html)

## 標準プロジェクト構成

UI開発基盤採用プロジェクトのプロジェクト直下ディレクトリ構成。

| ディレクトリ名 | 概要 | 説明 |
|---|---|---|
| `ui_demo` | 業務画面モック開発用プロジェクト | JSP画面モック格納。ビルドで各プラグインの成果物を集約して配備 |
| `ui_test` | UI開発基盤テスト用プロジェクト | プロジェクト固有UIプラグインのテスト用。ビルドで成果物・テストリソースを配備 |
| `nablarch_plugins_bundle` | Nablarch標準UIプラグイン | Nablarch UI開発基盤のリリースプラグイン一式。UI基盤アップデート時に洗い替え。**プロジェクト側での改変禁止** |
| `ui_plugins` | プロジェクト固有UIプラグイン | プロジェクトで使用するプラグインを配置。既存プラグインをカスタマイズする場合はここにコピーして修正 |
| `web_common` など | デプロイ対象プロジェクト | サーバ環境にデプロイする資源格納。実装工程以降で使用。ビルドで業務画面モック作成用プロジェクトと同等の成果物がサーブレットコンテキスト配下に配置される |

> **重要**: `nablarch_plugins_bundle` はプロジェクト側での改変禁止。UI基盤アップデート時に洗い替えを行う。

ディレクトリ構成例:

```bash
プロジェクトルート/
  ├─ nablarch_plugins_bundle/         # Nablarch標準UIプラグイン
  │     └── node_modules/
  │              ├── jquery/1.11.0/
  │              ├── nablarch_widget_filed_calendar/1.0.2/
  │              └── nablarch-css-color-default/1.0.0/
  └─ xxx_project/
         ├── ui_demo/WEB-INF/
         │     ├── ss11AC/, ss12AC/   # 業務画面JSP(サブシステム毎)
         │     ├── css/, fonts/, img/, include/, js/, tags/
         ├── ui_test/
         │     ├── css/, fonts/, img/, js/, jsp/
         │     └── WEB-INF/include/, tags/
         ├── ui_plugins/
         │     ├── package.json       # 使用プラグイン定義
         │     └── node_modules/
         │           ├── jquery/
         │           ├── nablarch-widget-field-calendar/
         │           └── xxxproject_css_color/
         ├── web_common/main/web/
         └── web_xxxx/main/web/
```

<details>
<summary>keywords</summary>

ui_demo, ui_test, nablarch_plugins_bundle, ui_plugins, web_common, UI開発基盤, プロジェクトディレクトリ構成, 業務画面モック, UIプラグイン, デプロイ対象プロジェクト

</details>
