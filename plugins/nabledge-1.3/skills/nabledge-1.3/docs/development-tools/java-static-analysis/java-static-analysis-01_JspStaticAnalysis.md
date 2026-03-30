# JSP静的解析ツール

## 概要

JSP静的解析ツールは、JSPで使用を許可する構文とタグを設定ファイルで規定し、許可されていない構文・タグの使用箇所を指摘するツール。

- 使用構文・タグを限定することで保守性が向上する
- 使用できる構文・タグを限定することでサニタイジング漏れを検出できる

> **注意**: 本ツールはJSPコンパイルが成功するファイルのみチェック対象とする。JSPコンパイルが通らないファイル（例: taglibの閉じタグが存在しない等）は正しく解析できない。

> **注意**: JSPコンパイルはリクエスト単体テスト時に行われるため、リクエスト単体テストが通っている場合はJSPコンパイルが通っていると判断してよい。

<details>
<summary>keywords</summary>

JSP静的解析, 構文チェック, タグチェック, サニタイジング漏れ検出, JSPコンパイル

</details>

## 仕様

設定ファイルに**使用を許可する構文とタグ**を定義することで、定義されていない構文・タグの使用箇所を指摘する。チェック結果はHTMLまたはXML形式で出力する。

**指定可能な構文とタグ**:
- XMLコメント
- HTMLコメント
- EL式
- 宣言
- 式
- スクリプトレット
- ディレクティブ
- アクションタグ
- カスタムタグ

HTMLタグ等、上記以外の構文・タグは指定不可。

**チェック対象外**: 使用を許可したタグの**属性**は常にチェック対象外。それ以外の場所は常にチェックする。

EL式を禁止した場合の動作例:
- `<jsp:include page="${ Expression }" />` の属性 → **指摘しない**（許可タグの属性のため）
- `<jsp:text>` ボディ内の `${ Expression }` → **指摘する**
- `<td height="${ Expression }">` のHTMLタグ属性 → **指摘する**
- `<td> ${ Expression } </td>` のHTMLタグボディ → **指摘する**
- JavaScript中の `${user.id}` → **指摘する**

> **注意**: HTMLコメントを使用不可とした場合でも、条件付きコメント（IEによる条件付きコメント）および業務画面作成支援ツールをロードするためのコメントはエラーとして検出しない。

<details>
<summary>keywords</summary>

EL式, XMLコメント, HTMLコメント, 宣言, 式, スクリプトレット, ディレクティブ, アクションタグ, カスタムタグ, チェック対象外, タグ属性, チェック仕様

</details>

## 前提条件

**前提条件**: Nablarch開発環境構築ガイドに従って開発環境を構築済みであること。

<details>
<summary>keywords</summary>

前提条件, 開発環境構築

</details>

## 設定ファイルの準備

任意のディレクトリに以下のファイルを配置する:
- `config.txt` — JSP静的解析ツール設定ファイル
- `transform-to-html.xsl` — JSP静的解析結果XMLをHTMLに変換する定義ファイル
- `jsp-analysis-build.xml` — Antビルドファイル
- `jsp-analysis-build.properties` — 環境設定ファイル

各ファイルの詳細は `02_JspStaticAnalysisInstall` を参照のこと。

<details>
<summary>keywords</summary>

設定ファイル準備, config.txt, transform-to-html.xsl, jsp-analysis-build.xml, jsp-analysis-build.properties

</details>

## JSP静的解析ツール設定ファイルの記述方法

> **警告**: 開発時にアプリケーションプログラマの都合に合わせて設定を変えてはいけない。

設定ファイルに使用を許可する構文・タグの一覧を記述する。`--` で始まる行はコメント行。

| 構文又はタグ | JSPでの使用例 | 設定ファイルへの記述方法 |
|---|---|---|
| XMLコメント | `<%-- comment --%>` | `<%--` |
| HTMLコメント | `<!-- comment -->` | `<!--` |
| EL式 | `${10 mod 4}` | `${` |
| 宣言 | `<%! int i = 0; %>` | `<%!` |
| 式 | `<%= map.size() %>` | `<%=` |
| スクリプトレット | `<% String name = null; %>` | `<%` |
| ディレクティブ | `<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>` | `<%@` から始まり最初の空白まで（例: `<%@ taglib`） |
| アクションタグ | `<jsp:attribute name="attrName" />` | `<jsp:` から始まり最初の空白まで。`<jsp:` のみで全アクションタグ許可（例: `<jsp:attribute`） |
| カスタムタグ | `<n:error name="attrName" />` | アクションタグと同じ方法 |

**デフォルト許可設定:**

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

**デフォルト除外設定**（Nablarchカスタムタグに同様の機能があるか、セキュリティホールとなりうる構文・タグ）:

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

設定ファイル記述方法, デフォルト設定, 許可構文, 許可タグ, コメント行

</details>

## 実行方法

以下のプロパティはすべて `jsp-analysis-build.properties` のプロパティを指す。

| プロパティ名 | 説明 |
|---|---|
| `common.project.test.lib` | `nablarch-tfw.jar` が配置されているディレクトリのパス（デフォルト: `<プロジェクトルート>/test/lib`） |
| `checkjspdir` | チェック対象JSPのパス（`jsp-analysis-build.xml` からの相対パスまたは絶対パス）（例: `../../main/web`） |
| `additionalext` | `.jsp` 以外もチェック対象とする拡張子（例: `tag,inc,fragment`）。`jsp` は設定によらず常にチェック対象 |

`jsp-analysis-build.xml` をEclipseのAntビューに追加し、実行したいターゲットを実行する。

![Antビューでのチェック実行](../../../knowledge/development-tools/java-static-analysis/assets/java-static-analysis-01_JspStaticAnalysis/startJspAnalysis.png)

<details>
<summary>keywords</summary>

common.project.test.lib, nablarch-tfw.jar, checkjspdir, additionalext, Antビルド, Antビュー, Eclipse

</details>

## 出力結果確認方法

**JSP解析（HTMLレポート出力）**

チェック結果をHTMLに出力する。出力先は `htmloutput` プロパティで変更可能（デフォルト: Ant実行ディレクトリ）。

エラー内容: `"構文またはタグ名" + "指摘位置" is forbidden.`  
対処: プロジェクトの規約で許可されている構文・タグを使用する。

![HTMLレポート出力例](../../../knowledge/development-tools/java-static-analysis/assets/java-static-analysis-01_JspStaticAnalysis/how-to-trace-jsp.png)

**JSP解析（XMLレポート出力）**

チェック結果をXMLに出力する。出力先は `xmloutput` プロパティで指定する。出力したXMLをXSLT等で整形すれば任意のレポート作成が可能。

| 要素名 | 説明 |
|---|---|
| `result` | ルートノード |
| `item` | 各JSPに対して作成されるノード |
| `path` | 該当JSPのパス |
| `errors` | 該当JSPに対する指摘 |
| `error` | 個々の指摘内容 |

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

<details>
<summary>keywords</summary>

htmloutput, xmloutput, HTMLレポート, XMLレポート, チェック結果出力, forbidden

</details>
