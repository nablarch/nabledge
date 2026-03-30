# JSP静的解析ツール インストールガイド

## 前提条件

## 前提条件

- Nablarch開発環境構築ガイドに従ってNablarchサンプルアプリケーションがインストールされていること

<details>
<summary>keywords</summary>

JSP静的解析ツール, インストール前提条件, Nablarchサンプルアプリケーション

</details>

## インストール

## インストール

本ツールはNablarchサンプルアプリケーションの `<プロジェクトルート>/tool/jspanalysis` 直下に配置した状態で配布されている。ディレクトリごと任意の場所にコピーすればインストールは完了する。

<details>
<summary>keywords</summary>

JSP静的解析ツール インストール, jspanalysis, ツール配置, プロジェクトルート

</details>

## ツール構成

## ツール構成

| ファイル名 | 説明 |
|---|---|
| jsp-analysis-build.properties | 環境設定ファイル |
| jsp-analysis-build.xml | Antビルドファイル |
| config.txt | JSP静的解析ツール設定ファイル |
| transform-to-html.xsl | JSP静的解析結果XMLをHTMLに変換する際の定義ファイル |

<details>
<summary>keywords</summary>

jsp-analysis-build.properties, jsp-analysis-build.xml, config.txt, transform-to-html.xsl, ツール構成ファイル

</details>

## プロパティファイルの書き換え

## プロパティファイルの書き換え

`jsp-analysis-build.properties` を各環境にあわせて設定する。パスは相対パス、絶対パスが使用可能。

| 設定プロパティ | 説明 |
|---|---|
| project.test | テストディレクトリパス |
| project.test.lib | テスト用ライブラリディレクトリパス |
| checkjspdir | チェック対象JSPディレクトリパスもしくはファイルパス |
| xmloutput | 出力先XMLファイルパス |
| checkconfig | 使用を許可するタグの設定ファイルパス |
| charset | チェック対象JSPファイルの文字コード |
| lineseparator | チェック対象JSPファイルで使用されている改行コード |
| htmloutput | チェック結果を出力するHTMLファイルパス |
| xsl | チェック結果のXMLをHTMLファイルに変換する際のXSLTファイルパス |

<details>
<summary>keywords</summary>

jsp-analysis-build.properties, project.test, project.test.lib, checkjspdir, xmloutput, checkconfig, charset, lineseparator, htmloutput, xsl, 環境設定プロパティ

</details>

## Eclipseとの連携設定

## Eclipseとの連携設定

EclipseからAntビューを使ってツールを起動する手順:

1. ツールバーから「ウィンドウ(Window)→設定(Show View)」を選択し、Antビューを開く
2. ＋印のアイコンを押下し、ビルドスクリプトを選択する
3. Antビルドファイル(`jsp_analysis_build.xml`)を選択する
4. Antビューに登録したビルドファイルが表示されることを確認する

<details>
<summary>keywords</summary>

Eclipse連携, Antビュー, ビルドファイル登録, jsp_analysis_build.xml, Eclipse起動手順

</details>
