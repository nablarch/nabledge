# JSP静的解析ツール

## 概要

JSPで使用を許可する構文とタグを規定し、未許可の構文・タグの使用箇所を指摘するチェックツール。

- 使用構文・タグを限定することで保守性向上
- 使用可能な構文・タグを限定することでサニタイジング漏れを検出

> **注意**: JSPコンパイルが成功するファイルのみチェック可能。JSPコンパイルが通らないファイル（例: taglibの閉じタグが存在しない等）は正しく解析できない。

> **注意**: JSPコンパイルはリクエスト単体テスト時に行われるため、リクエスト単体テストが通っている場合はJSPコンパイルが通っていると判断できる。

<details>
<summary>keywords</summary>

JSP静的解析, JSPコンパイル, サニタイジング漏れ検出, 保守性向上, 未許可タグ検出

</details>

## 仕様 — 許可するタグの指定方法

設定ファイルに使用許可する構文・タグを定義し、定義外の構文・タグの使用箇所を指摘する。チェック結果はHTMLまたはXML形式で出力。

指定可能な構文・タグ: XMLコメント、HTMLコメント、EL式、宣言、式、スクリプトレット、ディレクティブ、アクションタグ、カスタムタグ。HTMLタグ等は指定不可。

**チェック対象外**: 使用許可タグの属性（属性以外の箇所は常にチェック対象）

EL式を禁止した場合の挙動:
- 許可タグの**属性**にEL式を指定 → 指摘しない（例: `<jsp:include page="${ Expression }" />`）
- 許可タグの**ボディ**にEL式を指定 → 指摘する
- HTMLタグの属性またはボディにEL式を指定 → 指摘する
- JavaScript中にEL式を指定 → 指摘する

> **補足**: HTMLコメントを使用不可とした場合でも、条件付きコメント（IEによる条件付きコメント）および業務画面作成支援ツールをロードするためのコメントはエラーとして検出しない。

設定ファイルの記述方法は :ref:`01_customJspAnalysis` を参照。

<details>
<summary>keywords</summary>

許可タグ指定, チェック対象外, EL式チェック, 01_customJspAnalysis, HTMLコメント例外, カスタムタグ, アクションタグ

</details>

## 仕様 — チェック対象ファイルの指定方法

チェック対象ファイル（ディレクトリ）は起動引数として指定。ディレクトリ指定時は拡張子がjspのファイルを再帰的にチェック（設定で拡張子追加可能）。

除外ファイル設定を使用することで、チェック不要なファイルへのチェックを無効化可能。

設定方法は :ref:`01_customJspAnalysisProp` を参照。

<details>
<summary>keywords</summary>

チェック対象ファイル指定, 除外ファイル設定, 01_customJspAnalysisProp, ディレクトリ再帰チェック

</details>

## 仕様 — 対象ファイル内の一部を強制的にチェック対象外にする方法

特定箇所のチェックを無効化するには、該当行のすぐ上の行にチェック無効化JSPコメントを記述する。

無効化コメントのルール:
- コメントの開始タグと終了タグを同一行に記述
- コメントは必ず `suppress jsp check` で始める（以降に無効化理由等を記述可）

無効化コメントはチェック対象外タグ扱いのため、JSPコメントを使用不可とした場合でもエラーにならない。

例:
```jsp
<%-- suppress jsp check:サーバサイドで判定し、bodyのクラスに埋め込むために必要なコード --%>
<%!
  static class UserAgent { 
  }
%>
```

<details>
<summary>keywords</summary>

suppress jsp check, JSPコメント無効化, チェック対象外強制, 特定箇所無効化

</details>

## 前提条件

- Nablarch開発環境構築ガイドに従って開発環境を構築済みであること。

<details>
<summary>keywords</summary>

前提条件, 開発環境構築, Nablarch開発環境

</details>

## 使用方法 — 設定ファイルの準備

任意のディレクトリに以下のファイルを配置する:
- `config.txt` — JSP静的解析ツール設定ファイル
- `transform-to-html.xsl` — JSP静的解析結果XMLをHTMLに変換する定義ファイル
- `jsp-analysis-build.xml` — Antビルドファイル
- `jsp-analysis-build.properties` — Antビルドファイル用設定ファイル

詳細は [02_JspStaticAnalysisInstall](java-static-analysis-02_JspStaticAnalysisInstall.md) を参照。

<details>
<summary>keywords</summary>

config.txt, transform-to-html.xsl, jsp-analysis-build.xml, jsp-analysis-build.properties, 設定ファイル準備, 02_JspStaticAnalysisInstall

</details>

## 使用方法 — JSP静的解析ツール設定ファイルの記述方法

> **警告**: 開発時にアプリケーションプログラマの都合に合わせて設定を変えてはいけない。

設定ファイルに使用許可する構文・タグの一覧を記載する。`--`で始まる行はコメント行。

| 構文又はタグ | JSPでの使用例 | 設定ファイルへの記述方法 |
|---|---|---|
| XMLコメント | `<%-- comment --%>` | `<%--` |
| HTMLコメント | `<!-- comment -->` | `<!--` |
| EL式 | `${10 mod 4}` | `${` |
| 宣言 | `<%! int i = 0; %>` | `<%!` |
| 式 | `<%= map.size() %>` | `<%=` |
| スクリプトレット | `<% String name = null; %>` | `<%` |
| ディレクティブ | `<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>` | `<%@`から始まり最初の空白まで（例: `<%@ taglib`） |
| アクションタグ | `<jsp:attribute name="attrName" />` | `<jsp:`から始まり最初の空白まで。`<jsp:`のみで全アクションタグ使用可。（例: `<jsp:attribute`） |
| カスタムタグ | `<n:error name="attrName" />` | アクションタグと同じ方法 |

**デフォルト設定（使用許可）**:
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

**デフォルトで除外された構文・タグ**（Nablarchカスタムタグに同様機能があるか、セキュリティホールとなりうる）:
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

設定ファイル記述方法, デフォルト設定, 01_customJspAnalysis, 許可タグ一覧, 除外タグ一覧

</details>

## 使用方法 — Antビルドファイル用設定ファイルの修正

実行環境に合わせて `jsp-analysis-build.properties` を修正する。詳細は :ref:`01_customJspAnalysisProp` を参照。

<details>
<summary>keywords</summary>

Antビルド設定, jsp-analysis-build.properties, 01_customJspAnalysisProp, 実行環境設定

</details>

## 使用方法 — 実行方法

AntビルドファイルをEclipseのAntビューに追加し、実行したいターゲットを実行する。Antビューの設定は [how_to_setup_ant_view_in_eclipse_jsp_analysis](java-static-analysis-02_JspStaticAnalysisInstall.md) を参照。

<details>
<summary>keywords</summary>

Antビュー, Eclipse, how_to_setup_ant_view_in_eclipse_jsp_analysis, 実行方法

</details>

## 使用方法 — 出力結果確認方法

**JSP解析（HTMLレポート出力）**:
- デフォルト出力先: Ant実行ディレクトリ（`jsp-analysis-build.properties`の`htmloutput`プロパティで変更可能）
- エラー形式: `"構文またはタグ名" + "指摘位置" is forbidden.`

**JSP解析（XMLレポート出力）**:
- 出力先は`xmloutput`プロパティで指定
- 出力したXMLをXSLT等で整形することで任意のレポート作成が可能

| 要素名 | 説明 |
|---|---|
| result | ルートノード |
| item | 各JSPに対して作成されるノード |
| path | 該当JSPのパスを表すノード |
| errors | 該当JSPに対する指摘を表すノード |
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

> **注意**: 本ツールはJenkinsのようなCIサーバで定期的に実行し、許可されていないタグが使われていないことを常に保証すること。

<details>
<summary>keywords</summary>

HTMLレポート, XMLレポート, htmloutput, xmloutput, 出力結果確認, result要素, item要素, path要素, errors要素, error要素

</details>
