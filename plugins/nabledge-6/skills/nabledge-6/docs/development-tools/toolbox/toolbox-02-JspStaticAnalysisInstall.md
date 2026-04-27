# Jakarta Server Pages静的解析ツール 設定変更ガイド

**目次**

* 前提条件
* 設定ファイル構成
* pom.xmlの書き換え

[Jakarta Server Pages静的解析ツール](../../development-tools/toolbox/toolbox-JspStaticAnalysis.md) の設定変更方法について説明する。

## 前提条件

* アーキタイプからブランクプロジェクトの生成が完了していること。

## 設定ファイル構成

設定ファイルの構成は下表の通り。

| ファイル名 | 説明 |
|---|---|
| pom.xml | 起動に必要な設定と、jspanalysis.excludePatternsを設定する。 |
| tools/nablarch-tools.xml | Antタスクの定義ファイル [1] 。通常編集することはない。 |
| tools/static-analysis/jspanalysis/config.txt | Jakarta Server Pages静的解析ツール設定ファイル。記述方法は、 [Jakarta Server Pages静的解析ツール設定ファイルの記述方法](../../development-tools/toolbox/toolbox-01-JspStaticAnalysis.md#01-customjspanalysis) を参照。 |
| tools/static-analysis/jspanalysis/transform-to-html.xsl | 解析結果のXMLをHTMLに変換する際の定義ファイル。  記述方法は、 [出力結果確認方法](../../development-tools/toolbox/toolbox-01-JspStaticAnalysis.md#01-outputjspanalysis) の「JSP解析(XMLレポート出力)」を参照。 |
| nablarch-archetype-parentのpom.xml | jspanalysis.excludePatterns以外を設定する。 |

内部でAntを使用しているため存在する。利用者はMaven経由で実行するため通常意識することはない。

## pom.xmlの書き換え

Jakarta Server Pages静的解析ツール用のプロパティを実行環境にあわせて修正する際は、jspanalysis.excludePatternsの修正であればツールを実行するプロジェクトのpom.xmlを修正する。それ以外の項目の修正であればnablarch-archetype-parentのpom.xmlを修正する。

| 設定プロパティ | 説明 |
|---|---|
| jspanalysis.checkjspdir | チェック対象JSPディレクトリパスもしくはファイルパスを設定する。  CI環境のように一括でチェックを実行する場合には、  ディレクトリパスを設定する。  例:  ``` ./main/web ```  ディレクトリを指定した場合は、再帰的にチェックが実行される。 |
| jspanalysis.xmloutput | チェック結果のXMLレポートファイルの出力パスを設定する。  例:  ``` ./build/reports/jsp/report.xml ``` |
| jspanalysis.htmloutput | チェック結果のHTMLレポートファイルの出力パスを設定する。  例:  ``` ./build/reports/jsp/report.html ``` |
| jspanalysis.checkconfig | Jakarta Server Pages静的解析ツール設定ファイルのファイルパスを設定する。  例:  ``` ./tool/jspanalysis/config.txt ``` |
| jspanalysis.charset | チェック対象JSPファイルの文字コードを設定する。  例:  ``` utf-8 ``` |
| jspanalysis.lineseparator | チェック対象JSPファイルで使用されている改行コードを   設定する。  例:  ``` \\n ``` |
| jspanalysis.xsl | チェック結果のXMLをHTMLファイルに変換する際のXSLT   ファイルパスを設定する。  例:  ``` ./tool/jspanalysis/transform-to-html.xsl ``` |
| jspanalysis.additionalext | チェック対象とするJSPファイルの拡張子を設定する。  複数の拡張子を指定する場合には、カンマ(,)区切りで指定する。  この設定値の内容にかかわらず、拡張子が `jsp` のファイル   は必ずチェック対象となる。  例:  ``` tag ``` |
| jspanalysis.excludePatterns [2] | チェック対象外とするディレクトリ（ファイル）名を正規表現で設   定する。  複数のパターンを設定する場合にはカンマ(,)区切りで指定する。  例:  ``` ui_local,ui_test,ui_test/.*/set.tag ``` |

本設定は、デフォルトではコメントアウトしている。本設定を使用する場合は、pom.xmlと、toolsディレクトリのnablarch-tools.xmlについてコメントアウトを解除すること。

> **Tip:**
> ファイルパス(ディレクトリパス)は、絶対パスでの指定も可能となっている。
