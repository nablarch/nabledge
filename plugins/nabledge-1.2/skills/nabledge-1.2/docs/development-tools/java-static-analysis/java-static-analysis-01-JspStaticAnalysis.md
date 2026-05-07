# JSP静的解析ツール

## 概要

JSPで使用を許可する構文とタグを規定し、許可する構文とタグのみを使用していることをチェックする。
これにより、次のことを保証できる。

* 使用されている構文とタグを限定できるため、保守性が向上する。
* 使用できる構文とタグを限定することにより、サニタイジング漏れを検出することができる。

本ツールでは、JSPコンパイルが成功するファイルに対するチェックを行うものである。
このため、JSPコンパイルが通らないファイル（例えばtaglibのとじタグが存在していない等）の場合には、本ツールは正しくJSPファイルの解析を行うことは出来ない。

> **Note:**
> JSPコンパイルはリクエスト単体テスト時に行われるため、リクエスト単体テストが通っている場合にはJSPコンパイルが通っていると判断して良い。

## 仕様

本ツールは、 **JSPで使用を許可する構文とタグ** を設定ファイルに定義することで、設定ファイルに定義されていない構文とタグが使用されている箇所を指摘する。
チェック結果は、HTMLまたはXML形式で出力する。

本ツールで指定可能な構文とタグを下記に示す。

* XMLコメント
* HTMLコメント
* EL式
* 宣言
* 式
* スクリプトレット
* ディレクティブ
* アクションタグ
* カスタムタグ

本ツールではHTMLタグ等の上記以外の構文とタグは指定できない。

本ツールでは、下記の場所をチェック対象外とする。下記以外の場所は常にチェックする。

* 使用を許可したタグの属性

下記に例として、EL式を禁止した場合のチェック結果を示す。

* 使用を許可したタグの属性にEL式を指定した場合は、指摘しない。

  ```
  <jsp:include page="${ Expression }" />
  ```
* 使用を許可したタグのボディにEL式を指定した場合は、指摘する。

  ```
  <jsp:text>
     ${ Expression }
  </jsp:text>
  ```
* HTMLタグの属性にEL式を指定した場合は、指摘する。

  ```
  <td height="${ Expression }"> </td>
  ```
* HTMLタグのボディにEL式を指定した場合は、指摘する。

  ```
  <td> ${ Expression } </td>
  ```
* JavaScript中にEL式を指定した場合は、指摘する。

  ```
  function samplefunc() {
      var id = ${user.id}
  }
  ```

設定ファイルの記述方法は [JSP静的解析ツール設定ファイルの記述方法](../../development-tools/java-static-analysis/java-static-analysis-01-JspStaticAnalysis.md#jsp静的解析ツール設定ファイルの記述方法) を参照のこと。

## 前提条件

* Nablarch開発環境構築ガイドに従って開発環境を構築済みであること。

## 使用方法

### 設定ファイルの準備

任意のディレクトリに、本ツールを実行するために必要な以下のファイルを配置する。

* config.txt … JSP静的解析ツール設定ファイル
* transform-to-html.xsl … JSP静的解析結果XMLをHTMLに変換する際の定義ファイル
* jsp-analysis-build.xml … Antビルドファイル
* jsp-analysis-build.properties … 環境設定ファイル

これらファイルについての詳細は [JSP静的解析ツール インストールガイド](../../development-tools/java-static-analysis/java-static-analysis-02-JspStaticAnalysisInstall.md) を参照のこと。

### JSP静的解析ツール設定ファイルの記述方法

プロジェクトの規約を反映するために設定ファイルを変更する。

> **Warning:**
> 開発時にアプリケーションプログラマの都合に合わせて設定を変えてはいけない。

設定ファイルには使用を許可する構文とタグの一覧を下表に従って記載する。
「--」で始まる行はコメント行とする。

| 構文又はタグ | JSPでの使用例 | 設定ファイルへの記述方法 |
|---|---|---|
| XMLコメント | <%-- comment --%> | <%-- |
| HTMLコメント | <!-- comment --> | <!-- |
| EL式 | ${10 mod 4} | ${ |
| 宣言 | <%! int i = 0; %> | <%! |
| 式 | <%= map.size() %> | <%= |
| スクリプトレット | <%  String name = null; %> | <% |
| ディレクティブ | <%@ taglib prefix="n" uri="[http://tis.co.jp/nablarch](http://tis.co.jp/nablarch)" %> | 「<%@」から始まり、最初の空白までの部分を記述する。  例：） <%@ taglib |
| アクションタグ | <jsp:attribute name="attrName" /> | 「<jsp:」から始まり、最初の空白までの部分を記述する。 「<jsp:」のみを設定した場合、アクションタグ全てが 使用可能となる。  例：） <jsp:attribute |
| カスタムタグ | <n:error name="attrName" /> | 設定方法は、アクションタグと同じ。 |

デフォルトの設定は下記のとおりである。

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

デフォルトの設定で除外した構文とタグは下記のとおりである。

これらは、Nablarchカスタムタグに同様の機能を有するか、セキュリティホールとなりうる可能性がある構文とタグである。

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

> **Note:**
> 以下で述べるプロパティとは、すべてjsp-analysis-build.propertiesのプロパティを指す。

> jsp-analysis-build.propertiesの各プロパティの意味は、 [プロパティファイルの書き換え](../../development-tools/java-static-analysis/java-static-analysis-02-JspStaticAnalysisInstall.md#プロパティファイルの書き換え) を参照のこと。

nablarch-tfw.jarが配置されているディレクトリを確認し（デフォルトでは 「<プロジェクトルート>/test/lib」ディレクトリ ）、
common.project.test.lib プロパティにそのパスが設定する。

チェック対象のJSPを変更したい場合は、 checkjspdir プロパティを変更する。
checkjspdir プロパティには、jsp-analysis-build.xmlが配置されているフォルダからの相対パス、または絶対パスを設定する。

```
checkjspdir=../../main/web
```

プロパティの設定が完了したら、 jsp-analysis-build.xml をEclipseのAntビューに追加し、実行したいターゲットを実行する。
Antビューの設定に関しては、 [Eclipseとの連携設定](../../development-tools/java-static-analysis/java-static-analysis-02-JspStaticAnalysisInstall.md#eclipseとの連携設定) を参照のこと。

![startJspAnalysis.png](../../../knowledge/assets/java-static-analysis-01-JspStaticAnalysis/startJspAnalysis.png)

### 出力結果確認方法

* JSP解析(HTMLレポート出力)

  JSPのチェックを行い、チェック結果をHTMLに出力する。

  デフォルトの設定では、HTMLは Ant を実行したディレクトリに出力される。
  出力先は、 jsp-analysis-build.properties の htmloutput プロパティの設定で変更できる。

  出力内容の例を以下に示す。

  ![how-to-trace-jsp.png](../../../knowledge/assets/java-static-analysis-01-JspStaticAnalysis/how-to-trace-jsp.png)

  上記の例では、指摘内容は2通りあり、各指摘への対処方法は次のとおりである。

  * 許可されていないタグが使用されている場合。

    「"構文またはタグ名" + "指摘位置" is forbidden.」というエラー内容が表示される。
    プロジェクトの規約にて使用を許可されている構文とタグを使用し対処する。
* JSP解析(XMLレポート出力)

  JSPのチェックを行い、チェック結果をXMLに出力する。

  XMLの出力先は jsp-analysis-build.properties の xmloutputプロパティにて指定する。

  出力したXMLをXSLT等で整形すれば、任意のレポート作成が可能である。

  出力されるXMLフォーマットは次のとおりである。

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
        <error>&lt;!-- (at line=150 column=8) is forbidden.</error>
        <error>&lt;!-- (at line=151 column=8) is forbidden.</error>
        <error>&lt;!-- (at line=160 column=8) is forbidden.</error>
      </errors>
    </item>
    <item>
      <path>C:\tisdev\workspace\Nablarch_sample\web\management\user\USER-002.jsp</path>
      <errors>
        <error>&lt;!-- (at line=20 column=10) is forbidden.</error>
        <error>&lt;c:if (at line=152 column=46) is forbidden.</error>
      </errors>
    </item>
    <item>
      <path>C:\tisdev\workspace\Nablarch_sample\web\management\user\USER-004.jsp</path>
      <errors>
        <error>&lt;!-- (at line=16 column=10) is forbidden.</error>
      </errors>
    </item>
  </result>
  ```
