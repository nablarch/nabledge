# JSP静的解析ツール

**公式ドキュメント**: [JSP静的解析ツール](https://nablarch.github.io/docs/LATEST/doc/development_tools/toolbox/JspStaticAnalysis/01_JspStaticAnalysis.html)

## 概要

JSPで使用を許可する構文とタグを規定し、それ以外の構文・タグの使用箇所を検出するツール。保守性向上とサニタイジング漏れの検出を目的とする。

> **重要**: JSPコンパイルが成功するファイルのみ正しく解析できる。taglibの閉じタグが存在しないなどコンパイルが通らないファイルは正しく解析できない。

**モジュール**: `nablarch-testing-XXX.jar` に含まれる。

## 設定ファイルの存在確認

`tools/static-analysis/jspanalysis/` ディレクトリに以下のファイルが存在することを確認する。

- `config.txt` … JSP静的解析ツール設定ファイル
- `transform-to-html.xsl` … JSP静的解析結果XMLをHTMLに変換する際の定義ファイル

これらファイルの詳細は `02_JspStaticAnalysisInstall` を参照のこと。

<details>
<summary>keywords</summary>

JSP静的解析, サニタイジング漏れ検出, JSPコンパイル制約, 保守性向上, nablarch-testing, JSP静的解析ツール, config.txt, transform-to-html.xsl, static-analysis/jspanalysis, 設定ファイル確認

</details>

## 仕様

## 許可するタグの指定方法

設定ファイルに定義された構文・タグのみ許可し、定義されていない構文・タグの使用箇所を指摘する。チェック結果はHTMLまたはXML形式で出力する。

指定可能な構文・タグ:
- XMLコメント
- HTMLコメント
- EL式
- 宣言
- 式
- スクリプトレット
- ディレクティブ
- アクションタグ
- カスタムタグ

HTMLタグ等の上記以外の構文・タグは指定できない。

チェック対象外: **使用を許可したタグの属性**（それ以外は常にチェック対象）

EL式を禁止した場合の挙動:
- 許可タグの**属性**にEL式 → 指摘しない（例: `<jsp:include page="${ Expression }" />`）
- 許可タグの**ボディ**にEL式 → 指摘する
- HTMLタグの属性/ボディにEL式 → 指摘する
- JavaScript中にEL式 → 指摘する

設定ファイルの記述方法は :ref:`01_customJspAnalysis` を参照。

> **注意**: HTMLコメントを使用不可とした場合でも、以下のコメントはエラーとして検出しない。
> - 条件付きコメント（IEが解釈する条件付きのコメント）
> - 業務画面作成支援ツールをロードするためのコメント

## チェック対象ファイルの指定方法

チェック対象ファイル（ディレクトリ）は起動引数として指定する。ディレクトリ指定時は拡張子がjspのファイルを再帰的にチェック（設定で拡張子追加可能）。

本番環境にデプロイされるファイルとテスト用ファイルが混在する場合は、除外ファイル設定を使用することで不要なファイルへのチェックを無効化できる。

設定方法は :ref:`01_customJspAnalysisProp` を参照。

## 対象ファイル内の一部を強制的にチェック対象外にする方法

やむを得ず許可されていないタグを使用する必要がある箇所（例: アーキテクトが作成するタグファイル内でアプリ開発者に使用させたくないタグを隠蔽する場合）は、チェック無効化機能を使用する。

該当行のすぐ上の行にJSPコメントを記述することで特定箇所のチェックを無効化できる。JSPコメントを使用不可に設定していてもエラーにはならない。

無効化コメントのルール:
- コメントの開始タグと終了タグを同一行に記述する
- コメントは必ず `suppress jsp check` で始める（以降は任意のコメント、無効化理由を記述推奨）

```jsp
<%-- suppress jsp check:サーバサイドで判定し、bodyのクラスに埋め込むために必要なコード --%>
<%!
  static class UserAgent {
  }
%>
```

## Antタスクの定義ファイル確認

`tools/nablarch-tools.xml` に以下の定義が存在することを確認する。

```xml
<project name="Nablarch Toolbox">
  <!-- 中略 -->
  <target name="analyzeJsp" depends="analyzeJspOutputXml" description="JSPの解析を行い、HTMLレポートを出力する。">
    <java classname="nablarch.test.tool.sanitizingcheck.HtmlConvert" dir="${nablarch.tools.dir}" fork="true">
      <arg value="${jspanalysis.xmloutput}" />
      <arg value="${jspanalysis.xsl}" />
      <arg value="${jspanalysis.htmloutput}" />
      <classpath>
        <path refid="classpath.common" />
      </classpath>
    </java>
  </target>

  <target name="analyzeJspOutputXml" description="JSPの解析を行い、XMLレポートを出力する。">
    <java classname="nablarch.test.tool.sanitizingcheck.SanitizingCheckTask" dir="${nablarch.tools.dir}" fork="true">
      <arg value="${jspanalysis.checkjspdir}" />
      <arg value="${jspanalysis.xmloutput}" />
      <arg value="${jspanalysis.checkconfig}" />
      <arg value="${jspanalysis.charset}" />
      <arg value="${jspanalysis.lineseparator}" />
      <arg value="${jspanalysis.additionalexts}" />
      <!-- jspanalysis.excludePatterns は pom.xml で有効化した場合のみコメントアウト解除 -->
      <!-- <arg value="${jspanalysis.excludePatterns}" /> -->
    </java>
  </target>
  <!-- 中略 -->
</project>
```

<details>
<summary>keywords</summary>

許可タグ設定, EL式チェック, 除外ファイル設定, チェック無効化, suppressコメント, JSPコメント, 01_customJspAnalysis, 01_customJspAnalysisProp, チェック対象外, nablarch-tools.xml, analyzeJsp, analyzeJspOutputXml, SanitizingCheckTask, HtmlConvert, Antタスク定義, jspanalysis.excludePatterns

</details>

## 前提条件

- アーキタイプからブランクプロジェクトの生成が完了していること。

## pom.xmlの確認

JSP静的解析ツールでチェックしたい対象プロジェクトの `pom.xml` に以下の記述が存在することを確認する。

```xml
<properties>
  <!-- 中略 -->
  <!-- jspanalysis.excludePatterns を有効にする場合は nablarch-tools.xml のコメントアウトも解除すること -->
  <!-- <jspanalysis.excludePatterns></jspanalysis.excludePatterns> -->
</properties>

<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-antrun-plugin</artifactId>
    </plugin>
  </plugins>
</build>
```

> **補足**: JSP静的解析ツールのデフォルト設定値は `nablarch-archetype-parent` の `pom.xml` に記述されている。

| プロパティ名 | デフォルト値 |
|---|---|
| `jspanalysis.checkjspdir` | `${project.basedir}/src/main/webapp` |
| `jspanalysis.xmloutput` | `${project.basedir}/target/jspanalysis-result.xml` |
| `jspanalysis.checkconfig` | `${nablarch.tools.dir}/static-analysis/jspanalysis/config.txt` |
| `jspanalysis.charset` | `UTF-8` |
| `jspanalysis.lineseparator` | `\n` |
| `jspanalysis.htmloutput` | `${project.basedir}/target/jspanalysis-result.html` |
| `jspanalysis.xsl` | `${nablarch.tools.dir}/static-analysis/jspanalysis/transform-to-html.xsl` |
| `jspanalysis.additionalexts` | `tag` |

各設定項目の詳細は `02_JspStaticAnalysisInstall` を参照のこと。

<details>
<summary>keywords</summary>

前提条件, ブランクプロジェクト, アーキタイプ, maven-antrun-plugin, nablarch-archetype-parent, jspanalysis設定プロパティ, jspanalysis.checkjspdir, jspanalysis.xmloutput, jspanalysis.checkconfig, jspanalysis.charset, jspanalysis.htmloutput, jspanalysis.xsl, jspanalysis.additionalexts, デフォルト設定値

</details>

## JSP静的解析ツール設定ファイルの記述方法

## JSP静的解析ツール設定ファイルの記述方法

プロジェクトの規約を反映するために設定ファイル (`config.txt`) を変更する。

> **重要**: 開発時にアプリケーションプログラマの都合に合わせて設定を変えてはいけない。

設定ファイルには使用を許可する構文とタグの一覧を記載する。`--` で始まる行はコメント行。

| 構文又はタグ | JSPでの使用例 | 設定ファイルへの記述方法 |
|---|---|---|
| XMLコメント | `<%-- comment --%>` | `<%--` |
| HTMLコメント | `<!-- comment -->` | `<!--` |
| EL式 | `${10 mod 4}` | `${` |
| 宣言 | `<%! int i = 0; %>` | `<%!` |
| 式 | `<%= map.size() %>` | `<%=` |
| スクリプトレット | `<% String name = null; %>` | `<%` |
| ディレクティブ | `<%@ taglib prefix="n" uri="..." %>` | `<%@` から始まり最初の空白まで（例: `<%@ taglib`） |
| アクションタグ | `<jsp:attribute name="attrName" />` | `<jsp:` から始まり最初の空白まで。`<jsp:` のみで全アクションタグ使用可能（例: `<jsp:attribute`） |
| カスタムタグ | `<n:error name="attrName" />` | アクションタグと同じ方法 |

**デフォルトで許可している構文・タグ**:
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

**デフォルトで除外している構文・タグ** (Nablarchカスタムタグに同等機能があるか、セキュリティホールとなりうるもの):
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

<details>
<summary>keywords</summary>

config.txt記述方法, 許可タグ設定, 禁止タグ検出, EL式制限, スクリプトレット制限, XMLコメント, HTMLコメント, カスタムタグ, アクションタグ, ディレクティブ, デフォルト許可構文, デフォルト除外構文

</details>

## pom.xmlの修正

## pom.xmlの修正

`pom.xml` に記述されているプロパティを、実行環境に合わせて修正すること。

詳細は `01_customJspAnalysisProp` を参照。

<details>
<summary>keywords</summary>

pom.xmlプロパティ修正, jspanalysis.excludePatterns, 実行環境設定

</details>

## 実行方法

## 実行方法

カレントディレクトリを解析対象のディレクトリにし、`verify` フェーズを実行する。

```
cd XXX-web
mvn verify -DskipTests=true
```

<details>
<summary>keywords</summary>

mvn verify, JSP静的解析実行, DskipTests, verifyフェーズ

</details>

## 出力結果確認方法

## 出力結果確認方法

### JSP解析（HTMLレポート出力）

JSPのチェックを行い、チェック結果をHTMLに出力する。

- デフォルト出力先: `target/jspanalysis-result.html`
- 出力先変更: `pom.xml` の `jspanalysis.htmloutput` プロパティで変更可
- 許可されていないタグが使用された場合: `"構文またはタグ名" + "指摘位置" is forbidden.` というエラーが表示される。プロジェクトの規約にて許可されている構文・タグを使用して対処する。

### JSP解析（XMLレポート出力）

JSPのチェックを行い、チェック結果をXMLに出力する。

- 出力先: `pom.xml` の `jspanalysis.xmloutput` プロパティで指定
- 出力したXMLをXSLT等で整形すれば任意のレポート作成が可能

| 要素名 | 説明 |
|---|---|
| `result` | ルートノード |
| `item` | 各JSPに対して作成されるノード |
| `path` | 該当JSPのパスを表すノード |
| `errors` | 該当JSPに対する指摘を表すノード |
| `error` | 個々の指摘内容 |

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<result>
  <item>
    <path>C:\tisdev\workspace\Nablarch_sample\web\management\user\USER-001.jsp</path>
    <errors>
      <error>&lt;!-- (at line=17 column=6) is forbidden.</error>
      <error>&lt;c:if (at line=121 column=2) is forbidden.</error>
      <error>&lt;!-- (at line=150 column=8) is forbidden.</error>
    </errors>
  </item>
  <item>
    <path>C:\tisdev\workspace\Nablarch_sample\web\management\user\USER-002.jsp</path>
    <errors>
      <error>&lt;!-- (at line=20 column=10) is forbidden.</error>
      <error>&lt;c:if (at line=152 column=46) is forbidden.</error>
    </errors>
  </item>
</result>
```

> **補足**: 本ツールはJenkinsのようなCIサーバで定期的に実行し、許可されていないタグが使われていないことを常に保証する必要がある。

<details>
<summary>keywords</summary>

jspanalysis-result.html, jspanalysis-result.xml, HTMLレポート, XMLレポート, is forbidden, CIサーバ, Jenkins, XMLフォーマット

</details>
