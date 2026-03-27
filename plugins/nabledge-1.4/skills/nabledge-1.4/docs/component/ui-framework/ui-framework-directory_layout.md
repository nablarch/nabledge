# 標準プロジェクト構成

## 標準プロジェクト構成

| ディレクトリ名 | 概要 | 詳細 |
|---|---|---|
| **ui_demo** | 業務画面モック開発用プロジェクト | 外部設計工程で作成したJSP画面モックを格納。ビルドコマンドで各プラグイン成果物を集約・配備。 |
| **ui_test** | UI開発基盤テスト用プロジェクト | プロジェクト固有UIプラグインのテスト用。ビルドコマンドで成果物およびテスト用リソースを配備。 |
| **nablarch_plugins_bundle** | Nablarch標準UIプラグイン | リリース物をそのまま格納。**UI基盤のアップデートを行う際に洗い替えを行う。プロジェクト側での改変は禁止。** |
| **ui_plugins** | プロジェクト固有UIプラグイン | プロジェクトで使用するプラグインを配置。既存プラグインをカスタマイズする場合はここにコピーして修正する。 |
| **web_common** など | デプロイ対象プロジェクト | サーバ環境にデプロイされる資源を格納。実装工程以降で使用する。ビルドコマンドで、**業務画面モック作成用プロジェクト**と同等のビルド成果物がサーブレットコンテキスト配下に配置される。 |

```bash
プロジェクトルート/
  │
  ├─ nablarch_plugins_bundle/         # Nablarch標準UIプラグイン
  │     └── node_modules/
  │              │
  │              ├── jquery/                         # jqueryプラグイン
  │              │     └── 1.11.0/
  │              │
  │              ├── nablarch_widget_filed_calendar/ # カレンダー日付入力ウィジェットプラグイン
  │              │     └── 1.0.2/
  │              │
  │              └── nablarch-css-color-default/     # カラースキームテーマ(Nablarchブランドカラー)プラグイン
  │                     └── 1.0.0/
  │
  └─ xxx_project/             # プロジェクトトップ
         │
         ├── ui_demo/              # 業務画面モック開発用プロジェクト
         │     ├── ss11AC/         # 業務画面JSP(サブシステム毎)
         │     ├── ss12AC/
         │     ├── css/
         │     ├── fonts/
         │     ├── img/
         │     ├── include/
         │     ├── js/
         │     └── WEB-INF/
         │           └── tags/
         │
         ├── ui_test/              # UI開発基盤テスト用プロジェクト
         │     ├── css/
         │     ├── fonts/
         │     ├── img/
         │     ├── include/
         │     ├── js/
         │     ├── jsp/
         │     └── WEB-INF/
         │           └── tags/
         │
         ├── ui_plugins/            # UI開発基盤プロジェクトカスタマイズ用フォルダ
         │     ├── package.json     # 利用プラグイン定義
         │     └── node_modules/
         │           ├── jquery/                         # jqueryプラグイン
         │           │     ├── dist/
         │           │     │     └── jquery.js
         │           │     └── src/
         │           ├── nablarch-widget-field-calendar/
         │           │     ├── package.json
         │           │     ├── bin/
         │           │     ├── ui_public/
         │           │     ├── ui_local/
         │           │     └── ui_test/
         │           └── xxxproject_css_color/
         │                 ├── package.json
         │                 ├── bin/
         │                 ├── ui_public/
         │                 ├── ui_local/
         │                 └── ui_test/
         │
         ├── web_common/             # デプロイ対象プロジェクト#1
         │     └── main/web/
         │
         └── web_xxxx/               # デプロイ対象プロジェクト#2
               └── main/web/
```

<details>
<summary>keywords</summary>

ui_demo, ui_test, nablarch_plugins_bundle, ui_plugins, web_common, 標準プロジェクト構成, UI開発基盤, ディレクトリ構成, プラグイン管理, 業務画面モック

</details>
