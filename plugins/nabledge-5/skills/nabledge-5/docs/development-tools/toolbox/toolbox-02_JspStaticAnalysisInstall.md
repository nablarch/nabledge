# JSP静的解析ツール 設定変更ガイド

**公式ドキュメント**: [JSP静的解析ツール 設定変更ガイド](https://nablarch.github.io/docs/LATEST/doc/development_tools/toolbox/JspStaticAnalysis/02_JspStaticAnalysisInstall.html)

## 前提条件

アーキタイプからブランクプロジェクトの生成が完了していること。

<details>
<summary>keywords</summary>

JSP静的解析ツール設定変更, ブランクプロジェクト, 前提条件, アーキタイプ

</details>

## 設定ファイル構成

| ファイル名 | 説明 |
|---|---|
| pom.xml | 起動に必要な設定と、`jspanalysis.excludePatterns` を設定する。 |
| tools/nablarch-tools.xml | Antタスクの定義ファイル。通常編集することはない。 |
| tools/static-analysis/jspanalysis/config.txt | JSP静的解析ツール設定ファイル。記述方法は :ref:`01_customJspAnalysis` を参照。 |
| tools/static-analysis/jspanalysis/transform-to-html.xsl | JSP静的解析結果XMLをHTMLに変換する際の定義ファイル。記述方法は :ref:`01_outputJspAnalysis` の「JSP解析(XMLレポート出力)」を参照。 |
| nablarch-archetype-parentのpom.xml | `jspanalysis.excludePatterns` 以外を設定する。 |

<details>
<summary>keywords</summary>

pom.xml, nablarch-tools.xml, config.txt, transform-to-html.xsl, JSP静的解析ツール設定ファイル, Antタスク, 設定ファイル構成

</details>

## pom.xmlの書き換え

修正するpom.xmlの選択ルール:
- `jspanalysis.excludePatterns` の修正 → ツールを実行するプロジェクトの `pom.xml` を修正する
- それ以外の項目の修正 → `nablarch-archetype-parent` の `pom.xml` を修正する

| プロパティ名 | 説明 |
|---|---|
| jspanalysis.checkjspdir | チェック対象JSPディレクトリパスもしくはファイルパスを設定する。CI環境のように一括でチェックを実行する場合はディレクトリパスを設定する（例: `./main/web`）。ディレクトリを指定した場合は再帰的にチェックが実行される。 |
| jspanalysis.xmloutput | チェック結果のXMLレポートファイルの出力パスを設定する（例: `./build/reports/jsp/report.xml`）。 |
| jspanalysis.htmloutput | チェック結果のHTMLレポートファイルの出力パスを設定する（例: `./build/reports/jsp/report.html`）。 |
| jspanalysis.checkconfig | JSP静的解析ツール設定ファイルのファイルパスを設定する（例: `./tool/jspanalysis/config.txt`）。 |
| jspanalysis.charset | チェック対象JSPファイルの文字コードを設定する（例: `utf-8`）。 |
| jspanalysis.lineseparator | チェック対象JSPファイルで使用されている改行コードを設定する（例: `\n`）。 |
| jspanalysis.xsl | チェック結果のXMLをHTMLファイルに変換する際のXSLTファイルパスを設定する（例: `./tool/jspanalysis/transform-to-html.xsl`）。 |
| jspanalysis.additionalext | チェック対象とするJSPファイルの拡張子を設定する。複数の場合はカンマ(,)区切り。設定値に関わらず `jsp` 拡張子のファイルは必ずチェック対象となる（例: `tag`）。 |
| jspanalysis.excludePatterns | チェック対象外とするディレクトリ（ファイル）名を正規表現で設定する。複数の場合はカンマ(,)区切り（例: `ui_local,ui_test,ui_test/.*/set.tag`）。 |

> **注意**: `jspanalysis.excludePatterns` はデフォルトでコメントアウトされている。使用する場合は、`pom.xml` と `tools` ディレクトリの `nablarch-tools.xml` のコメントアウトを解除すること。

> **補足**: ファイルパス（ディレクトリパス）は絶対パスでの指定も可能。

<details>
<summary>keywords</summary>

jspanalysis.checkjspdir, jspanalysis.xmloutput, jspanalysis.htmloutput, jspanalysis.checkconfig, jspanalysis.charset, jspanalysis.lineseparator, jspanalysis.xsl, jspanalysis.additionalext, jspanalysis.excludePatterns, JSP静的解析プロパティ設定, pom.xml設定変更

</details>
