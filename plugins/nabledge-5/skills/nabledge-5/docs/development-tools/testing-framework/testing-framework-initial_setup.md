# UI開発基盤の導入

**公式ドキュメント**: [UI開発基盤の導入](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/development_environment/initial_setup.html)

## 導入前の注意事項

本節の手順は **UI開発基盤の導入時に一度実施すればよく、各担当者が個別に実施する必要はない**。

UI開発基盤用プロジェクトテンプレートは `css_framework` を使用している。`multicol_css_framework` を使用する場合は、`[apply-multicol-layout](testing-framework-multicol_css_framework.md)` を参考に設定すること。

> **補足**: 本ドキュメントの開発作業手順は、構成管理に **Subversion** を使用する想定で記載している。**Git** を使用する場合はプロジェクト構成やコマンド名などを読み替えること。

`nablarch_plugins_bundle/bin/install.bat` の `PROJECT_ROOT` にプロジェクトルートを設定して実行する。

```bat
set PROJECT_ROOT=../../web_project
```

> **補足**: このスクリプトは完了までに通常5〜10分程度かかる。

実行後、`package.json` に指定されたプラグインが `web_project/ui_plugins/node_modules` 配下にインストールされる。

<details>
<summary>keywords</summary>

multicol_css_framework, css_framework, apply-multicol-layout, Subversion, Git, バージョン管理, プロジェクトテンプレート前提, 導入手順 一度だけ, 個別実施不要, プラグインインストール, install.bat, PROJECT_ROOT, nablarch_plugins_bundle, ui_plugins/node_modules, UIプラグイン導入

</details>

## Node.jsのインストール

Node.js v0.10.26 のインストールが必要。インストールイメージは [http://nodejs.org/dist/v0.10.26/](http://nodejs.org/dist/v0.10.26/) から取得する。

> **補足**: バージョンによってはUI開発基盤が動作しないため、動作検証済みの v0.10.26 の使用を推奨する。

> **補足**: Node.js が必要なのは初期環境構築を担当するアーキテクトのみ。通常の設計・開発担当者はインストール不要。

`web_project/ui_plugins/pjconf.json` の `pathSettings/webProjectPath` にデプロイ対象プロジェクトを設定して `web_project/ui_plugins/bin/ui_build.bat` を実行する。

```javascript
{
  "pathSettings" :
  { "projectRootPath"   : "../.."
  , "webProjectPath"    : "web/src/main/webapp"
  , "demoProjectPath"   : "ui_demo"
  , "testProjectPath"   : "ui_test"
  , "pluginProjectPath" : "ui_plugins"
  }
}
```

展開先:

| パス | 名称 | 用途 |
|---|---|---|
| `ui_demo/` | 業務画面モック開発用プロジェクト | 設計工程で作成する業務画面JSPを格納。サーバサイドなしで画面表示・動作デモが可能 |
| `ui_test/` | UI開発基盤テスト用プロジェクト | UI基盤のテストスイートを格納。UI基盤カスタマイズ時の影響確認や標準プラグインとPJカスタマイズの問題切り分けに使用 |
| `web/` | デプロイ対象プロジェクト | 実際にサーバ環境にデプロイされる資源を格納 |

<details>
<summary>keywords</summary>

Node.js インストール, 動作検証済みバージョン, v0.10.26, UI開発基盤前提条件, アーキテクト, UI部品ビルド, ui_build.bat, pjconf.json, pathSettings, webProjectPath, ui_demo, ui_test, web/, UIビルド配置

</details>

## 環境変数 JAVA_HOME の設定

環境変数 `JAVA_HOME` にJDKのインストールディレクトリパスを設定すること（`[ui_demo](testing-framework-plugin_build.md)` の動作前提）。

`web_project/ui_demo/ローカル画面確認.bat` を実行するとブラウザが起動し、`web_project/ui_demo` 配下の全JSPファイルへのリンクが表示される。各リンクを開くとJavaScriptで解釈されたデモ画面が表示される。

<details>
<summary>keywords</summary>

JAVA_HOME, 環境変数設定, JDK, ui_demo前提条件, UIローカルデモ, ローカル画面確認.bat, JSP表示確認, デモ画面

</details>

## プロジェクトルートの作成

ローカルマシン上の任意の場所にプロジェクトルートとなるディレクトリを新規作成する。

`web_project/ui_test/サーバ動作確認.bat` を実行する。コンソールに以下のメッセージが表示されるまで待つ。

```
Started SocketConnector@0.0.0.0:7777
```

メッセージ確認後、ブラウザに表示されているリンクを押すと別の画面に遷移する。左のメニューから各UI部品の動作確認用ページに遷移できる。

<details>
<summary>keywords</summary>

プロジェクトルート作成, ディレクトリ作成, UI開発基盤導入, UI開発基盤テスト, サーバ動作確認.bat, SocketConnector, Jetty, UI部品動作確認

</details>

## UI開発基盤の取得

以下コマンドでUI開発基盤を取得し、プロジェクトルート直下に配置する:

```bash
cd <<プロジェクトルート>>
git clone https://github.com/nablarch/nablarch-plugins-bundle.git
```

> **重要**: リポジトリへの登録を怠ると、プロジェクト側のカスタマイズとNablarch開発元の改修を正しくマージすることが困難または不可能になるため、必ず実施すること。

コミット前に以下のディレクトリを削除する:

- `nablarch_plugins_bundle/`
- `web_project/ui_plugins/.npm/`

<details>
<summary>keywords</summary>

nablarch-plugins-bundle, UI開発基盤取得, git clone, nablarch-plugins-bundle取得, リポジトリ登録, nablarch_plugins_bundle削除, ui_plugins/.npm削除, コミット, マージ競合防止

</details>

## UI開発基盤用プロジェクトテンプレートの取得

以下コマンドでUI開発基盤用プロジェクトテンプレートを取得し、プロジェクトルート直下に配置する:

```bash
cd <<プロジェクトルート>>
git clone https://github.com/nablarch/nablarch-ui-development-template.git web_project
```

<details>
<summary>keywords</summary>

nablarch-ui-development-template, プロジェクトテンプレート取得, git clone, web_project

</details>

## ブランクプロジェクトのセットアップ

`[../../../../application_framework/application_framework/blank_project/setup_blankProject/setup_Web](../../setup/blank-project/blank-project-setup_Web.md)` に従ってブランクプロジェクトをセットアップする。

> **補足**: ブランクプロジェクト生成時、`artifactId` に `web` を指定すること。

> **注意**: mavenのインストールや設定をしていない場合には、以下を参考にそれぞれを実施してからセットアップを行うこと。
> - `[../../../../application_framework/application_framework/blank_project/maven](../../setup/blank-project/blank-project-maven.md)`
> - `[../../../../application_framework/application_framework/blank_project/beforeFirstStep](../../setup/blank-project/blank-project-beforeFirstStep.md)`

<details>
<summary>keywords</summary>

ブランクプロジェクト セットアップ, artifactId web, setup_Web, maven, mavenインストール前提, beforeFirstStep

</details>

## プラグインのセットアップ

`nablarch_plugins_bundle/bin/setup.bat` を実行する。

プロキシ配下でインターネット接続する場合、以下の環境変数にプロキシアドレスを設定すること:
- `http_proxy`: 例）`http://proxy.example.com:8080`
- `https_proxy`: 例）`http://proxy.example.com:8080`

setup.bat が実行する処理:
1. `[ui_test_server](#)` で使用するモジュールのビルド（`nablarch-dev-tool-server/ui_test/tools` 配下に追加）
2. サードパーティライブラリの取得（`nablarch_plugins_bundle/node_modules` 配下に追加）

<details>
<summary>keywords</summary>

setup.bat, プラグインセットアップ, http_proxy, https_proxy, プロキシ設定, サードパーティライブラリ取得

</details>

## プロジェクトで使用するプラグインの選定

`web_project/ui_plugins/package.json` の `dependencies` セクションで使用するプラグインを管理する。不要なプラグインはエントリを削除することでインストール対象から除外できる。各プラグインの内容は `[../structure/plugins](testing-framework-plugins.md)` を参照すること。

プラグインを削除する場合、そのプラグインが less ファイルを含んでいれば、以下6ファイルの `:ref:`lessImport_less`` から当該プラグインの less import 定義も削除する必要がある:
- `web_project/ui_plugins/css/ui_local/compact.less`
- `web_project/ui_plugins/css/ui_local/narrow.less`
- `web_project/ui_plugins/css/ui_local/wide.less`
- `web_project/ui_plugins/css/ui_public/compact.less`
- `web_project/ui_plugins/css/ui_public/narrow.less`
- `web_project/ui_plugins/css/ui_public/wide.less`

> **補足**: 使用するプラグインの選別は、開発中であっても随時実施可能である。ただし、開発チーム側での誤用を避けるため、使用しないプラグインはなるべく早い段階で除いておくことが望ましい。

<details>
<summary>keywords</summary>

package.json, プラグイン選定, less import, lessImport_less, dependencies, プラグイン除外, プラグイン早期除外, 開発チーム誤用防止

</details>
