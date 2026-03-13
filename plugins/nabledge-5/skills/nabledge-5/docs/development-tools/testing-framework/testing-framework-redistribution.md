# UI開発基盤の展開

**公式ドキュメント**: [UI開発基盤の展開](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/development_environment/redistribution.html)

## UI開発基盤の用途と展開概要

UI開発基盤の展開には、用途に応じた以下の3種類がある。

1. **画面設計担当者向けワークスペース**: 外部設計工程において、業務画面設計者が作業するためのワークスペース。
2. **開発担当者向けワークスペース**: PG/UT工程において、画面機能の実装担当者が作業するためのワークスペース。
3. **UIデモ実行用アーカイブ**: 業務画面のUIデモを実施するためのアーカイブ。本ファイルとブラウザがあればUIデモを実施できる。客先に送信してミーティングで使用したり、開発リポジトリに直接アクセスできない顧客側の担当者にUIを直接確認してもらう場合などに用いる。

<details>
<summary>keywords</summary>

開発基盤の用途, 3種類のワークスペース, 画面設計担当者, 開発担当者, UIデモ実行用アーカイブ, 客先送信, ミーティング, 開発リポジトリにアクセスできない

</details>

## 画面設計担当者向けワークスペースの取得

画面設計担当者向けワークスペースは、リポジトリの `ui_demo/` ディレクトリをローカルディスクの任意の位置にチェックアウトして取得する。

```
プロジェクトルート/
      │  
      └── web_project/
            ├── web/
            ├── ui_demo/        #### ← ここからチェックアウト####
            │     ├── .project
            │     ├── ローカル画面確認.bat
            │
            ├── ui_plugins/
            └── ui_test/
```

> **補足**: チェックアウトしたワークスペースの使用方法については `ui_dev-howto_make_jsp` を参照すること。

<details>
<summary>keywords</summary>

画面設計担当者, ui_demo, チェックアウト, 外部設計工程, 業務画面設計

</details>

## 開発担当者向けワークスペースの展開

開発担当者向けワークスペースは、リポジトリの `web_project/` ディレクトリをローカルディスクの任意の位置にチェックアウトして展開する。

```
プロジェクトルート/
      │  
      └── web_project/      #### ← ここからチェックアウト####
            ├── web/
            │     ├── .classpath
            │     ├── .project
            │  
            ├── ui_demo/
            │     ├── .project
            │     ├── ローカル画面確認.bat
            │  
            ├── ui_plugins/
            └── ui_test/
                  ├── .classpath
                  ├── .project
```

> **補足（Eclipse使用時）**: `ui_plugins/tool/wtptool` を ant で実行すると、`ui_plugins` 配下の jsp、tag ファイルの入力補完や構文チェックが有効になる。

> **重要**: リクエスト単体テストで HTML を確認したとき、動的読み込み（XHR）が許可されず JavaScript が動作しない。そのため、開発担当者向けワークスペースに展開する前には `main/webapp/WEB-INF/include/js_include.jsp` を確認し、本番用（minify された JS ファイルを読み込む設定）に切り替えること。

<details>
<summary>keywords</summary>

開発担当者, web_project, チェックアウト, wtptool, ant, jsp入力補完, js_include.jsp, minify, XHR, 単体テスト, JavaScriptが動作しない

</details>

## UIデモ実行用アーカイブの作成手順

UIデモ実行用アーカイブは、リポジトリの `ui_demo/` ディレクトリをエクスポートし、圧縮して作成する。

1. UI開発基盤リポジトリの `ui_demo/` ディレクトリをローカルディスクの任意の位置にエクスポートする。

```
プロジェクトルート/
      │  
      └── web_project/
            ├── web/
            ├── ui_demo/        #### ← ここからエクスポート####
            │     ├── .project
            │     ├── ローカル画面確認.bat
            │
            ├── ui_plugins/
            └── ui_test/
```

> **補足**: エクスポート後、デモに不要な業務画面 JSP を削除してもよい。削除内容は `ローカル画面確認.bat` で表示されるリンク一覧に自動的に反映される。

2. エクスポートしたディレクトリを圧縮ソフトで圧縮する（ファイル名は任意）。

<details>
<summary>keywords</summary>

UIデモ実行用アーカイブ, ui_demo, ローカル画面確認.bat, アーカイブ作成, JSP削除, エクスポート, 圧縮

</details>

## UIデモ実行用アーカイブの確認手順

展開ディレクトリ直下の `ローカル画面確認.bat` を実行するとブラウザが起動し、業務画面 JSP のリンク一覧が表示される。デモ表示したい画面のリンクをクリックする。

1. 作成したアーカイブを任意の別ディレクトリに展開する。
2. 展開したディレクトリ直下の `ローカル画面確認.bat` を実行する。
3. ブラウザが起動し、各業務画面 JSP のリンク一覧が表示されるので、デモ表示を行いたい画面のリンクをクリックする。

<details>
<summary>keywords</summary>

UIデモ確認, ローカル画面確認.bat, UIデモ実行, 業務画面JSP, ブラウザ起動

</details>
