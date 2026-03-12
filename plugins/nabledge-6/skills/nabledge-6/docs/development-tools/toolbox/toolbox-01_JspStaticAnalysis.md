# Jakarta Server Pages静的解析ツール

**公式ドキュメント**: [Jakarta Server Pages静的解析ツール](https://nablarch.github.io/docs/LATEST/doc/development_tools/toolbox/JspStaticAnalysis/01_JspStaticAnalysis.html)

## 概要

JSPで使用を許可する構文とタグを規定し、許可されていない構文・タグの使用箇所を指摘する静的解析ツール。`nablarch-testing-XXX.jar` に含まれる。

- 使用される構文とタグを限定することで保守性が向上する
- 使用できる構文とタグを限定することでサニタイジング漏れを検出できる

> **重要**: JSPコンパイルが成功するファイルのみを対象とする。JSPコンパイルが通らないファイル（例: taglibの閉じタグが存在しない等）は正しく解析できない。

### 設定ファイルの存在確認

toolsプロジェクトの`static-analysis/jspanalysis`ディレクトリに以下ファイルが必要:

- :download:`config.txt<../tools/JspStaticAnalysis/config.txt>` … Jakarta Server Pages静的解析ツール設定ファイル
- :download:`transform-to-html.xsl<../tools/JspStaticAnalysis/transform-to-html.xsl>` … 解析結果のXMLをHTMLに変換する定義ファイル

詳細は [02_JspStaticAnalysisInstall](toolbox-02_JspStaticAnalysisInstall.md) を参照。

### Antタスクの定義ファイル確認

toolsプロジェクトの`nablarch-tools.xml`に以下のターゲット定義が必要:

```xml
<target name="analyzeJsp" depends="analyzeJspOutputXml">
  <java classname="nablarch.test.tool.sanitizingcheck.HtmlConvert" dir="${nablarch.tools.dir}" fork="true">
    <arg value="${jspanalysis.xmloutput}" />
    <arg value="${jspanalysis.xsl}" />
    <arg value="${jspanalysis.htmloutput}" />
    <classpath><path refid="classpath.common" /></classpath>
  </java>
</target>

<target name="analyzeJspOutputXml">
  <java classname="nablarch.test.tool.sanitizingcheck.SanitizingCheckTask" dir="${nablarch.tools.dir}" fork="true">
    <arg value="${jspanalysis.checkjspdir}" />
    <arg value="${jspanalysis.xmloutput}" />
    <arg value="${jspanalysis.checkconfig}" />
    <arg value="${jspanalysis.charset}" />
    <arg value="${jspanalysis.lineseparator}" />
    <arg value="${jspanalysis.additionalexts}" />
    <!-- excludePatternsを有効にする場合はコメントアウトを解除:
    <arg value="${jspanalysis.excludePatterns}" /> -->
    <classpath><path refid="classpath.common" /></classpath>
  </java>
</target>
```

### pom.xmlの確認

チェック対象プロジェクトの`pom.xml`に以下が必要:

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-antrun-plugin</artifactId>
    </plugin>
  </plugins>
</build>
```

`jspanalysis.excludePatterns`を有効にする場合は`<properties>`に`<jspanalysis.excludePatterns></jspanalysis.excludePatterns>`を追加し、`nablarch-tools.xml`のコメントアウトも解除すること。

> **補足**: Jakarta Server Pages静的解析ツールのデフォルト設定値は`nablarch-archetype-parent`の`pom.xml`に記述:
>
> ```xml
> <jspanalysis.checkjspdir>${project.basedir}/src/main/webapp</jspanalysis.checkjspdir>
> <jspanalysis.xmloutput>${project.basedir}/target/jspanalysis-result.xml</jspanalysis.xmloutput>
> <jspanalysis.checkconfig>${nablarch.tools.dir}/static-analysis/jspanalysis/config.txt</jspanalysis.checkconfig>
> <jspanalysis.charset>UTF-8</jspanalysis.charset>
> <jspanalysis.lineseparator>\n</jspanalysis.lineseparator>
> <jspanalysis.htmloutput>${project.basedir}/target/jspanalysis-result.html</jspanalysis.htmloutput>
> <jspanalysis.xsl>${nablarch.tools.dir}/static-analysis/jspanalysis/transform-to-html.xsl</jspanalysis.xsl>
> <jspanalysis.additionalexts>tag</jspanalysis.additionalexts>
> ```
>
> 各設定項目は [02_JspStaticAnalysisInstall](toolbox-02_JspStaticAnalysisInstall.md) を参照。

### 設定ファイルの記述方法

> **重要**: 開発時にアプリケーションプログラマの都合に合わせて設定を変えてはいけない。

使用を許可する構文とタグの一覧を記載する。`--`で始まる行はコメント行。

| 構文又はタグ | JSPでの使用例 | 設定ファイルへの記述方法 |
|---|---|---|
| XMLコメント | `<%-- comment --%>` | `<%--` |
| HTMLコメント | `<!-- comment -->` | `<!--` |
| EL式 | `${10 mod 4}` | `${` |
| 宣言 | `<%! int i = 0; %>` | `<%!` |
| 式 | `<%= map.size() %>` | `<%=` |
| スクリプトレット | `<% String name = null; %>` | `<%` |
| ディレクティブ | `<%@ taglib prefix="n" uri="..." %>` | `<%@`から始まり最初の空白まで（例: `<%@ taglib`） |
| アクションタグ | `<jsp:attribute name="attrName" />` | `<jsp:`から始まり最初の空白まで（例: `<jsp:attribute`）。`<jsp:`のみ設定でアクションタグ全て許可 |
| カスタムタグ | `<n:error name="attrName" />` | アクションタグと同じ |

**デフォルトの許可設定**:

```
<n:
<c:
<%--
<%@ include
<%@ page
<%@ tag
<%@ taglib
<jsp:include
<jsp:directive.include
<jsp:directive.page
<jsp:directive.tag
<jsp:param
<jsp:params
<jsp:attribute
```

**デフォルトで除外された構文・タグ**（Nablarchカスタムタグに同等機能あり、またはセキュリティホールになりうる）:

```
<!--
<%!
${
<%
<%@ attribute
<%@ variable
<jsp:declaration
<jsp:expression
<jsp:scriptlet
<jsp:directive.attribute
<jsp:directive.variable
<jsp:body
<jsp:element
<jsp:doBody
<jsp:forward
<jsp:getProperty
<jsp:invoke
<jsp:output
<jsp:plugin
<jsp:fallback
<jsp:root
<jsp:setProperty
<jsp:text
<jsp:useBean
```

### 実行方法

カレントディレクトリを解析対象のディレクトリにし、verifyフェーズを実行:

```text
cd XXX-web
mvn verify -DskipTests=true
```

プロパティの修正は :ref:`01_customJspAnalysisProp` を参照。

### 出力結果確認方法

**HTMLレポート出力**（`analyzeJsp`ターゲット）:
- デフォルト出力先: `target/jspanalysis-result.html`（`jspanalysis.htmloutput`プロパティで変更可）
- 許可されていないタグが使用されている場合: `"構文またはタグ名" + "指摘位置" is forbidden.` エラーが表示される
  - 対処方法: プロジェクトの規約にて使用を許可されている構文とタグを使用し対処する。

**XMLレポート出力**（`analyzeJspOutputXml`ターゲット）:
- 出力先: `jspanalysis.xmloutput`プロパティで指定
- XSLT等で整形して任意のレポート作成が可能

XMLフォーマット:

| 要素名 | 説明 |
|---|---|
| result | ルートノード |
| item | 各JSPに対して作成されるノード |
| path | 該当のJSPのパスを表すノード |
| errors | 該当のJSPに対する指摘を表すノード |
| error | 個々の指摘内容 |

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<result>
  <item>
    <path>C:\tisdev\workspace\Nablarch_sample\web\management\user\USER-001.jsp</path>
    <errors>
      <error>&lt;!-- (at line=17 column=6) is forbidden.</error>
      <error>&lt;c:if (at line=121 column=2) is forbidden.</error>
    </errors>
  </item>
</result>
```

> **補足**: 本ツールの実行は、アプリケーション開発者任せではなくJenkinsのようなCIサーバで定期的に実行し、許可されていないタグが使われていないことを常に保証する必要がある。

<details>
<summary>keywords</summary>

JSP静的解析, サニタイジング漏れ検出, nablarch-testing, 保守性向上, JSPコンパイル, Jakarta Server Pages静的解析ツール, Antタスク, Maven, HTMLレポート, XMLレポート, 設定ファイル, HtmlConvert, SanitizingCheckTask, nablarch.test.tool.sanitizingcheck.HtmlConvert, nablarch.test.tool.sanitizingcheck.SanitizingCheckTask, jspanalysis.checkjspdir, jspanalysis.xmloutput, jspanalysis.htmloutput, jspanalysis.checkconfig, jspanalysis.charset, jspanalysis.lineseparator, jspanalysis.xsl, jspanalysis.additionalexts, jspanalysis.excludePatterns, maven-antrun-plugin, analyzeJsp, analyzeJspOutputXml

</details>

## 仕様

### 許可するタグの指定方法

設定ファイルに許可する構文とタグを定義することで、定義外の構文・タグを使用している箇所を指摘する。チェック結果はHTMLまたはXML形式で出力する。

**指定可能な構文とタグ**: XMLコメント、HTMLコメント、EL式、宣言、式、スクリプトレット、ディレクティブ、アクションタグ、カスタムタグ（HTMLタグ等の上記以外は指定不可）

**チェック対象外**: 使用を許可したタグの属性（上記以外の場所は常にチェックする）

EL式を禁止した場合の動作:
- 許可タグの属性にEL式を指定 → 指摘しない（例: `<jsp:include page="${ Expression }" />`）
- 許可タグのボディにEL式を指定 → 指摘する
- HTMLタグの属性にEL式を指定 → 指摘する
- HTMLタグのボディにEL式を指定 → 指摘する
- JavaScript中にEL式を指定 → 指摘する

**HTMLコメントの特例**: HTMLコメントを使用不可とした場合でも、以下はエラーとして検出しない:
- 条件付きコメント（IEによって解釈される条件付きのコメント）
- 業務画面作成支援ツールをロードするためのコメント

設定ファイルの記述方法: :ref:`01_customJspAnalysis`

### チェック対象ファイルの指定方法

チェック対象ファイル（ディレクトリ）は起動引数として指定する。ディレクトリ指定時はデフォルトでjsp拡張子のファイルを再帰的にチェック（設定で拡張子追加可能）。本番デプロイ対象外のファイル（テスト用等）が混在する場合は、除外ファイル設定でチェック対象外にできる。

設定方法: :ref:`01_customJspAnalysisProp`

### 対象ファイル内の一部を強制的にチェック対象外にする方法

アーキテクトが作成するJSP/タグファイル等でやむを得ず許可されていないタグを使用する場合、該当行の直上にチェックを無効化するJSPコメントを記述する。

**無効化コメントのルール**:
1. コメントの開始タグと終了タグを同一行に記述する
2. コメントは必ず `suppress jsp check` で始める（以降は任意のコメント、理由等を記述推奨）

無効化コメント自体はチェック対象外のタグとなるため、JSPコメントを使用不可とした場合でもエラーとならない。

```jsp
<%-- suppress jsp check:サーバサイドで判定し、bodyのクラスに埋め込むために必要なコード --%>
<%!
  static class UserAgent { 
  }
%>
```

<details>
<summary>keywords</summary>

許可タグ指定, EL式チェック, チェック対象ファイル, 除外ファイル設定, suppress jsp check, チェック無効化, HTMLコメント特例, 01_customJspAnalysis, 01_customJspAnalysisProp

</details>

## 前提条件

- アーキタイプからブランクプロジェクトの生成が完了していること

<details>
<summary>keywords</summary>

ブランクプロジェクト生成, アーキタイプ, セットアップ前提条件

</details>
