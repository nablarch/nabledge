# JSP自動生成ツール

## 概要

JSP自動生成ツールは、HTMLファイルをインプットとしてJSPファイルを自動生成するツール。定型的なHTML→JSP変換を自動化する。

> **注意**: 本ツールはHTML、JSPの構文チェックを行わない。構文チェックは [HTMLチェックツール](../../../guide/development_guide/08_TestTools/03_HtmlCheckTool/index.html) または [JSP静的解析ツール](../../../guide/development_guide/08_TestTools/04_JspStaticAnalysis/index.html) を参照。

<details>
<summary>keywords</summary>

JSP自動生成, HTML→JSP変換, JSPファイル自動生成, HTMLチェックツール, JSP静的解析ツール

</details>

## 要求

- HTMLタグを対応するNablarchタグに変換できる
- 不要なHTMLタグを変換時に削除できる
- HTMLファイルを指定してJSPファイルを自動生成できる（例: Eclipse上でHTMLファイルを選択して右クリックから実行）

<details>
<summary>keywords</summary>

Nablarchタグ変換, HTMLタグ変換, 不要属性削除, JSP自動生成機能

</details>

## 仕様

## HTML→JSP変換ルール

- HTMLタグとNablarchタグが1対1に対応するHTMLタグを変換対象とする
- HTMLタグの属性値をNablarchタグの対応属性にそのまま出力する
- 不要なHTMLタグの属性を変換時に削除する（HTMLタグ自体は削除しない。理由: JSP上で修正対象が分からなくなるのを防ぐため）
  - 削除対象の不要属性: 使用禁止HTMLタグの属性、Nablarchタグに存在しない属性
- Nablarchタグの必須属性は常に出力する（対応値がHTMLタグに指定されていない場合はブランク）
- 入力項目（n:textなど）の直後にn:errorタグを出力する
- JSPファイル先頭にtaglibディレクティブとpageディレクティブを出力する
- HTMLコメント(`<!-- xxx -->`)はJSPコメント(`<%-- xxx --%>`)に置換（`<script>`内JavaScriptを囲むコメントを除く）

## HTMLタグとNablarchタグの対応

| HTMLタグ | Nablarchタグ | 補足 |
|---|---|---|
| form | n:form | |
| input(type=text) | n:text | |
| textarea | n:textarea | 置き換え後、textareaタグのボディ(値)は削除される |
| input(type=password) | n:password | |
| input(type=radio) | n:radioButton | label属性をブランクで出力する |
| input(type=checkbox) | n:checkbox | label属性をブランクで出力する |
| input(type=file) | n:file | |
| input(type=hidden) | n:hidden | |
| select | n:select | listName属性、elementLabelProperty属性、elementValueProperty属性をブランクで出力する。置き換え後、selectタグのボディ(optionタグ)は削除される |
| input(type=submit, button, image) | n:submit | uri属性をブランクで出力する |
| button | n:button | uri属性をブランクで出力する |
| a | n:submitLink | uri属性をブランクで出力する |
| img | n:img | |
| link | n:link | |
| script | n:script | |

## 使用禁止HTMLタグの属性定義

使用禁止とするHTMLタグの属性は、HTMLチェックツールと同じ形式でCSVファイルに定義する。通常、本ツールとHTMLチェックツールで同じCSVファイルを使用する。`invalid.html.csv.path`で設定ファイルにパスを指定する（指定なしの場合は属性削除を行わない）。

デフォルトの定義:

```
applet,
basefont,
body,alink
body,background
body,bgcolor
body,link
body,text
body,vlink
br,clear
caption,align
center,
dir,
dl,compact
font,
h1,align
h2,align
h3,align
h4,align
h5,align
h6,align
hr,align
hr,noshade
hr,size
hr,width
html,version
iframe,align
img,align
img,border
img,hspace
img,vspace
input,align
isindex,
legend,align
li,type
li,value
listing,
menu,
object,align
object,border
object,hspace
object,vspace
ol,compact
ol,start
ol,type
p,align
plaintext,
pre,width
s,
script,language
strike,
table,align
table,bgcolor
td,bgcolor
td,height
td,nowrap
th,bgcolor
th,height
th,nowrap
tr,bgcolor
u,
ul,compact
ul,type
xmp,
td,width
th,width
div,align
```

> **注意**: CSVファイルはHTMLチェックツールと併用することを想定しているため、使用禁止タグ（appletなど）自体を含めることが可能。

## 追加するディレクティブ

JSPファイル先頭に出力するデフォルトディレクティブ（エンコーディングデフォルト: UTF-8）:

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
```

## デフォルト動作の変更設定

| キー | 説明 |
|---|---|
| invalid.html.csv.path | 使用禁止HTMLタグの属性を定義したCSVファイルのパス。指定なしの場合は属性削除を行わない |
| use.error.tag | n:errorタグを入力項目と一緒に出力するか否か。デフォルト: true |
| error.tag.position | n:errorタグの出力位置。"ABOVE"(入力項目の直前)/"BELOW"(入力項目の直後)。デフォルト: "BELOW" |
| use.directive | ディレクティブを出力するか否か。デフォルト: true |
| directive.content.type.encoding | pageディレクティブのcontentTypeに指定するエンコーディング。デフォルト: UTF-8 |
| directive.page.encoding | pageディレクティブのpageEncodingに指定するエンコーディング。デフォルト: UTF-8 |
| jsp.line.separator | JSPファイル出力時の改行コード。LF/CR/CRLF。デフォルト: LF |
| jsp.charset | JSPファイルの文字コード。デフォルト: UTF-8 |
| jsp.max.line.columns | JSPファイルの1行の最大桁数。デフォルト: 150 |
| html.charset | HTMLファイルの文字コード。デフォルト: UTF-8 |

<details>
<summary>keywords</summary>

n:form, n:text, n:textarea, n:password, n:radioButton, n:checkbox, n:file, n:hidden, n:select, n:submit, n:button, n:submitLink, n:img, n:link, n:script, n:error, HTMLタグNablarchタグ対応, タグリブディレクティブ, pageディレクティブ, invalid.html.csv.path, use.error.tag, error.tag.position, use.directive, directive.content.type.encoding, directive.page.encoding, jsp.line.separator, jsp.charset, jsp.max.line.columns, html.charset, デフォルト動作変更設定, 使用禁止HTMLタグ属性デフォルト一覧, body,bgcolor, table,bgcolor, td,bgcolor, applet, basefont

</details>

## 前提条件

開発環境構築ガイドに従って開発環境を構築済みであること。

<details>
<summary>keywords</summary>

開発環境構築, 前提条件

</details>

## 使用方法

EclipseでHTMLファイルを選択して右クリックから実行する（Eclipse設定方法は :ref:`SetUpJspGeneratorTool` 参照、実行方法は :ref:`SetUpJspGeneratorTool_howToExecuteFromEclipse` 参照）。

JSPファイルはHTMLファイルと同じ場所に生成される（Eclipse上で参照するにはHTMLファイルが含まれるディレクトリのリフレッシュが必要）。

## HTML作成時の注意点

> **重要**: 閉じタグを省略しない。特にselectタグ・textareaタグは変換時にボディを削除するため、閉じタグがない場合はファイルの一番最後まで削除される。

> **重要**: 属性はダブルクォートで囲み値を明確にする。

<details>
<summary>keywords</summary>

Eclipse設定, JSPファイル生成場所, selectタグ閉じタグ, textareaタグ閉じタグ, 属性ダブルクォート, SetUpJspGeneratorTool, HTML作成時の注意

</details>
