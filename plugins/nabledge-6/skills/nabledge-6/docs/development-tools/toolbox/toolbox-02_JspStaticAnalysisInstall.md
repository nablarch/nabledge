# Jakarta Server Pages静的解析ツール 設定変更ガイド

## 前提条件

- アーキタイプからブランクプロジェクトの生成が完了していること。

## 設定ファイル構成

| ファイル名 | 説明 |
|---|---|
| pom.xml | 起動に必要な設定と、jspanalysis.excludePatternsを設定する。 |
| tools/nablarch-tools.xml | Antタスクの定義ファイル。内部でAntを使用しているため存在する。利用者はMaven経由で実行するため通常意識することはない。 |
| tools/static-analysis/jspanalysis/config.txt | Jakarta Server Pages静的解析ツール設定ファイル。記述方法は、:ref:`01_customJspAnalysis` を参照。 |
| tools/static-analysis/jspanalysis/transform-to-html.xsl | 解析結果のXMLをHTMLに変換する際の定義ファイル。記述方法は、:ref:`01_outputJspAnalysis` の「JSP解析(XMLレポート出力)」を参照。 |
| nablarch-archetype-parentのpom.xml | jspanalysis.excludePatterns以外を設定する。 |

## pom.xmlの書き換え

jspanalysis.excludePatternsの修正はツールを実行するプロジェクトのpom.xmlを修正する。それ以外の項目の修正はnablarch-archetype-parentのpom.xmlを修正する。

| プロパティ名 | 説明 |
|---|---|
| jspanalysis.checkjspdir | チェック対象JSPディレクトリパスもしくはファイルパスを設定する。CI環境など一括チェックの場合はディレクトリパスを設定する。ディレクトリを指定した場合は再帰的にチェックが実行される。例: `./main/web` |
| jspanalysis.xmloutput | チェック結果のXMLレポートファイルの出力パスを設定する。例: `./build/reports/jsp/report.xml` |
| jspanalysis.htmloutput | チェック結果のHTMLレポートファイルの出力パスを設定する。例: `./build/reports/jsp/report.html` |
| jspanalysis.checkconfig | Jakarta Server Pages静的解析ツール設定ファイルのファイルパスを設定する。例: `./tool/jspanalysis/config.txt` |
| jspanalysis.charset | チェック対象JSPファイルの文字コードを設定する。例: `utf-8` |
| jspanalysis.lineseparator | チェック対象JSPファイルで使用されている改行コードを設定する。例: `\n` |
| jspanalysis.xsl | チェック結果のXMLをHTMLファイルに変換する際のXSLTファイルパスを設定する。例: `./tool/jspanalysis/transform-to-html.xsl` |
| jspanalysis.additionalext | チェック対象とするJSPファイルの拡張子を設定する。複数の拡張子はカンマ(,)区切りで指定する。拡張子`jsp`のファイルは必ずチェック対象となる。例: `tag` |
| jspanalysis.excludePatterns | チェック対象外とするディレクトリ（ファイル）名を正規表現で設定する。複数のパターンはカンマ(,)区切りで指定する。デフォルトではコメントアウトされている。使用する場合は、pom.xmlとtools/nablarch-tools.xmlのコメントアウトを解除すること。例: `ui_local,ui_test,ui_test/.*/set.tag` |

> **補足**: ファイルパス(ディレクトリパス)は、絶対パスでの指定も可能。
