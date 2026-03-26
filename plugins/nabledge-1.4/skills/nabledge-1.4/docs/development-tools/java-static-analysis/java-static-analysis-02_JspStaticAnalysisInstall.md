# JSP静的解析ツール インストールガイド

## 前提条件

Nablarch開発環境構築ガイドに従ってNablarchサンプルアプリケーションがインストールされていること。

<details>
<summary>keywords</summary>

JSP静的解析ツール, インストール前提条件, Nablarchサンプルアプリケーション

</details>

## インストール

本ツールは `<プロジェクトルート>/tool/jspanalysis` 直下に配置した状態で配布されている。ディレクトリごと任意の場所にコピーすればインストール完了。

<details>
<summary>keywords</summary>

インストール方法, jspanalysis, ツール配置, プロジェクトルート

</details>

## ツール構成

| ファイル名 | 説明 |
|---|---|
| jsp-analysis-build.properties | Antビルドファイル用設定ファイル |
| jsp-analysis-build.xml | Antビルドファイル |
| config.txt | JSP静的解析ツール設定ファイル |
| transform-to-html.xsl | JSP静的解析結果XMLをHTMLに変換する際の定義ファイル |

<details>
<summary>keywords</summary>

jsp-analysis-build.properties, jsp-analysis-build.xml, config.txt, transform-to-html.xsl, ツール構成ファイル

</details>

## Antビルドファイル用設定ファイルの書き換え

`jsp-analysis-build.properties` を実行環境に合わせて修正する。

| 設定プロパティ | 説明 | 例 |
|---|---|---|
| project.test | プロジェクトのテストディレクトリのパス | `./test` |
| project.test.lib | テスト用ライブラリが配置されたディレクトリ | `${project.test}/lib` |
| checkjspdir | チェック対象JSPディレクトリパスもしくはファイルパス。CI環境など一括チェック時はディレクトリパスを設定。ディレクトリ指定時は再帰的にチェックが実行される。 | `./main/web` |
| xmloutput | チェック結果のXMLレポートファイルの出力パス | `./build/reports/jsp/report.xml` |
| htmloutput | チェック結果のHTMLレポートファイルの出力パス | `./build/reports/jsp/report.html` |
| checkconfig | JSP静的解析ツール設定ファイルのパス | `./tool/jspanalysis/config.txt` |
| charset | チェック対象JSPファイルの文字コード | `utf-8` |
| lineseparator | チェック対象JSPファイルの改行コード | `\n` |
| xsl | XSLTファイルパス（XMLをHTMLに変換） | `./tool/jspanalysis/transform-to-html.xsl` |
| additionalext | チェック対象とする追加拡張子（カンマ区切り）。`jsp` は設定不要で必ずチェック対象。 | `tag` |
| excludePatterns | チェック対象外とするディレクトリ（ファイル）名の正規表現（カンマ区切り） | `ui_local,ui_test,ui_test/.*/set.tag` |

> **注意**: ファイルパス（ディレクトリパス）は絶対パスでの指定も可能。

<details>
<summary>keywords</summary>

project.test, project.test.lib, checkjspdir, xmloutput, htmloutput, checkconfig, charset, lineseparator, xsl, additionalext, excludePatterns, Ant設定プロパティ, JSP解析設定

</details>

## Eclipseとの連携設定

EclipseのAntビューにビルドファイルを登録してツールを起動する手順:

1. ツールバーから「ウィンドウ (Window)」→「設定 (Show View)」を選択し、Antビューを開く。
2. Antビューで「+」アイコンを押下し、ビルドスクリプトを選択する。
3. `jsp_analysis_build.xml` を選択する。
4. AntビューにAntビルドファイルが表示されることを確認する。

<details>
<summary>keywords</summary>

Eclipse連携, Antビュー, ビルドファイル登録, jsp_analysis_build.xml, Eclipse起動手順

</details>
