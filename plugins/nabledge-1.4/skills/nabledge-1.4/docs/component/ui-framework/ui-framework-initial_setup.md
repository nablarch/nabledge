# UI開発基盤の導入

## 0. 事前準備

## 事前準備

本手順はUI開発基盤の導入時に一度実施すればよく、**各担当者が個別に実施する必要はない**。

> **注意**: チュートリアルプロジェクトでは `css_framework` を使用しているが、`multicol_css_framework` を使用する場合には、`apply-multicol-layout` を参考に導入用の設定を行うこと。

本手順を行うには **Node.js** のインストールが必要である。インストールイメージを下記URLから取得し、インストールする。

```
http://nodejs.org/dist/v0.10.26/
```

バージョンによってはUI開発基盤が動作しないため、動作検証済みのバージョンである **0.10.26** の使用を推奨する。

> **注意**: Node.js を必要とするのは初期環境構築作業を行う**アーキテクトのみ**である。通常の設計・開発を行う担当者はインストール不要である。

> **警告**: リポジトリへの登録を怠ると、プロジェクト側のカスタマイズとNablarch開発元の改修を正しくマージすることが困難、または不可能となる。必ず実施すること。

1. **UI開発基盤インストール作業ファイルの削除**: コミット前に以下のディレクトリを削除する。
   - `nablarch_plugins_bundle/`
   - `tutorial_project/ui_plugins/.npm/`

2. **コミット**: 上記削除後、プロジェクトのリポジトリにコミットする。削除後のファイル構成は以下の通り。

```
プロジェクトルート/
      └── tutorial_project/
            ├── tutorial/
            ├── ui_demo/
            ├── ui_plugins/
            │     ├── package.json
            │     ├── bin/
            │     │     ├── ui_build.bat
            │     │     ├── ui_build.sh
            │     └── node_modules/
            │           ├── jquery/
            │           ├── less/
            │           ├── nablarch-css-base/
            │           ├── nablarch-css-color-default/
            │           ├── nablarch-css-common/
            └── ui_test/
```

<details>
<summary>keywords</summary>

Node.js, 0.10.26, nodejs.org, 事前準備, アーキテクト, インストール不要, 動作検証済みバージョン, プロジェクト全体で一度, 各担当者が個別に実施する必要はない, multicol_css_framework, apply-multicol-layout, 開発リポジトリ登録, インストール作業ファイル削除, UI開発基盤セットアップ, nablarch_plugins_bundle, ui_plugins, コミット手順, ui_build.bat, ui_build.sh, node_modules, jquery, nablarch-css-base

</details>

## 1. UI開発基盤の取得と展開

## UI開発基盤の取得と展開

Nablarch配布アーカイブから、以下の2つのアーカイブを取得する。

- Nablarch標準プラグインバンドルアーカイブ
- チュートリアルプロジェクトアーカイブ

ローカルマシン上の任意の場所にプロジェクトルートとなるディレクトリを新規作成し、アーカイブをこのディレクトリの直下に配置してそれぞれ展開する。

展開後のディレクトリ構成は以下のようになる:

```
プロジェクトルート/
      │
      ├── nablarch_plugins_bundle/
      │     ├── bin/
      │     │     ├── setup.bat
      │     │     └── install.bat
      │     ├── node_modules/
      │     │     ├── nablarch-css-base
      │     │     ├── nablarch-css-color-default
      │     │     ├── nablarch-css-common
      │     │     │ (後略)
      │     └── package.json
      │
      └── tutorial_project/
            ├── tutorial/
            ├── ui_demo/
            ├── ui_plugins/
            │     └── package.json
            └── ui_test/
```

<details>
<summary>keywords</summary>

Nablarch標準プラグインバンドルアーカイブ, チュートリアルプロジェクトアーカイブ, nablarch_plugins_bundle, tutorial_project, プロジェクトルート, アーカイブ展開, ディレクトリ構成

</details>

## 2-1. サードパーティライブラリの取得(要オンライン)

## サードパーティライブラリの取得(要オンライン)

以下の手順（2-1〜2-3）を実行することにより、Nablarch標準プラグインバンドルの内容と、各プラグインが依存するサードパーティ製ライブラリがプロジェクトルート配下に取り込まれる。

`nablarch_plugins_bundle/bin/setup.bat` を実行する。

> **注意**: この作業はオンライン環境での実施が必要である。オフライン環境でインストールする場合は、事前にオンライン環境で上記スクリプトを実行し、`nablarch_plugins_bundle/node_modules/` 配下の内容を転送すること。

プロキシ配下でインターネットに接続している場合、以下の環境変数にプロキシアドレスを設定すること:

- **http_proxy**: 例）`http_proxy=http://proxy.example.com:8080`
- **https_proxy**: 例）`https_proxy=http://proxy.example.com:8080`

実行後、`nablarch_plugins_bundle/node_modules` 配下にサードパーティプラグイン（es6-promise, font-awesome, jquery, less 等）が追加される。

<details>
<summary>keywords</summary>

setup.bat, Node.js, オンライン環境必須, プロキシ設定, http_proxy, https_proxy, サードパーティライブラリ取得, nablarch_plugins_bundle, プロジェクトルート配下に取り込まれる

</details>

## 2-2. プロジェクトで使用するプラグインの選定

## プロジェクトで使用するプラグインの選定

`tutorial_project/ui_plugins/package.json` の `dependencies` エントリを編集し、プロジェクトで使用するプラグインの名称とバージョンを選定する。不要なエントリを削除することでインストール対象から除去できる。

lessファイルを含むプラグインを削除した場合、`lessImport_less` から当該プラグインのlessファイルのimport定義を削除する必要がある。対象ファイルは以下の6ファイル:

- `tutorial_project/ui_plugins/css/ui_local/compact.less`
- `tutorial_project/ui_plugins/css/ui_local/narrow.less`
- `tutorial_project/ui_plugins/css/ui_local/wide.less`
- `tutorial_project/ui_plugins/css/ui_public/compact.less`
- `tutorial_project/ui_plugins/css/ui_public/narrow.less`
- `tutorial_project/ui_plugins/css/ui_public/wide.less`

> **ベストプラクティス**: 使用するプラグインの選別は、開発中であっても随時実施することが可能である。ただし、開発チーム側での誤用を避けるため、使用しないプラグインはなるべく早い段階で除いておくことが望ましい。

<details>
<summary>keywords</summary>

package.json, dependencies, プラグイン選定, lessImport_less, lessファイル, プラグイン除去, ui_plugins, 早い段階, 誤用防止

</details>

## 2-3. プロジェクトへのプラグインインストール

## プロジェクトへのプラグインインストール

`nablarch_plugins_bundle/bin/install.bat` を実行する（詳細は [../plugin_build](ui-framework-plugin_build.md) 参照）。

> **警告**: 初期のinstall.batはPROJECT_ROOTが設定されていないため、実行前にインストールするPJ名を設定すること。

> **注意**: このスクリプトは完了まで通常5〜10分程度かかる。

実行後:
- `tutorial_project/ui_plugins/node_modules` 配下にpackage.jsonで指定したプラグインがインストールされる
- 開発作業用コマンド（ui_build.bat, ui_build.sh）が `tutorial_project/ui_plugins/bin` 配下にインストールされる

<details>
<summary>keywords</summary>

install.bat, PROJECT_ROOT, プラグインインストール, ui_build.bat, ui_build.sh, node_modules

</details>

## 4. UI部品のビルドと配置

## UI部品のビルドと配置

`tutorial_project/ui_plugins/bin/ui_build.bat` を実行する（詳細は [../plugin_build](ui-framework-plugin_build.md) 参照）。

実行後、`tutorial_project` 配下の以下のディレクトリにUI資源が展開される:

| パス | 名称 | 用途 |
|---|---|---|
| ui_demo/ | 業務画面モック開発用プロジェクト | 設計工程で作成する業務画面JSPを格納。サーバサイドなしで画面表示・動作デモが可能 |
| ui_test/ | UI開発基盤テスト用プロジェクト | UI開発基盤のテストスイートを格納。UI基盤カスタマイズ時の既存機能への影響確認や、標準プラグインとPJカスタマイズの問題切り分けに使用 |
| tutorial/ | チュートリアルプロジェクト | サーバサイド側も含め完全に動作するアプリケーションサンプル。プロジェクトの雛形としても利用可能 |

<details>
<summary>keywords</summary>

ui_build.bat, ui_build.sh, UIビルド, ui_demo, ui_test, tutorial, UI資源展開

</details>

## 5. UIローカルデモ用プロジェクトの動作確認

## UIローカルデモ用プロジェクトの動作確認

`tutorial_project/ui_demo/ローカル画面確認.bat` を実行するとブラウザが起動し、`tutorial_project/ui_demo` 配下の全JSPファイルへのリンクが一覧表示される。各リンクを開くとJSPがJavaScriptによって解釈されデモ画面が表示される。

<details>
<summary>keywords</summary>

ローカル画面確認.bat, UIデモ確認, JSP表示確認, ui_demo

</details>

## 6. UI開発基盤テスト用プロジェクトの動作確認

## UI開発基盤テスト用プロジェクトの動作確認

`tutorial_project/ui_test/サーバ動作確認.bat` を実行するとブラウザが起動する。コンソールに以下のメッセージが表示されるまで待ち（Jettyがポート7777でリッスン開始）、その後ブラウザのリンクをクリックする:

```
Started SocketConnector@0.0.0.0:7777
```

左メニューから各UI部品の動作確認用ページに遷移できる。

<details>
<summary>keywords</summary>

サーバ動作確認.bat, Jetty, SocketConnector, ポート7777, UI部品動作確認, ui_test

</details>
