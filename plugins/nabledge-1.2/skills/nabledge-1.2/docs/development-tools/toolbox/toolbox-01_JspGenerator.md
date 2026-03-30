# JSP自動生成ツール

## 概要

HTMLファイルからJSPファイルを生成するツール。定型的なHTML→JSP変換を自動化する。

本ツールはHTML・JSPの構文チェックを行わない。構文チェックは [html_check_tool](toolbox-03-HtmlCheckTool.md)（HTMLチェックツール）または `JSP静的解析ツール <../../../guide/development_guide/08_TestTools/04_JspStaticAnalysis/index.html>`_ を参照。

<details>
<summary>keywords</summary>

JSP自動生成, HTML→JSP変換, HTMLチェックツール, JSP静的解析ツール, HTMLファイル変換

</details>

## 要求

- HTMLタグを対応するNablarchタグに変換できること
- 不要なHTMLタグを変換時に削除できること
- HTMLファイルを指定してJSPファイルを自動生成できること（例: Eclipse上でHTMLファイルを選択、右クリックから実行）

<details>
<summary>keywords</summary>

HTMLタグ変換, Nablarchタグ変換, JSP自動生成, Eclipse, 不要属性削除

</details>

## 仕様

HTMLファイルを先頭から読み込み、HTML要素を順に変換する。一度読み込んだHTML要素・変換で追加したJSPは以降の処理対象に含めない。

**HTML→JSP変換ルール**

1. HTMLタグとNablarchタグが1対1に対応するHTMLタグを変換対象とする
2. HTMLタグの属性値をNablarchタグの対応する属性にそのまま出力する
3. 不要なHTMLタグの属性を削除する（HTMLタグ自体は削除しない）。削除対象: 使用禁止HTMLタグの属性、Nablarchタグに存在しない属性
4. Nablarchタグの必須属性は常に出力する。対応する値がHTMLタグに指定されていない場合はブランク
5. n:textなどの入力項目の直後にn:errorタグを出力する
6. JSPファイルの先頭にディレクティブ（taglibディレクティブとpageディレクティブ）を出力する
7. HTMLコメント（`<!-- xxx -->`）を同内容のJSPコメント（`<%-- xxx --%>`）に置換する（`<script>`内のjavascriptを囲むHTMLコメントを除く）

**HTMLタグとNablarchタグの対応**

| HTMLタグ | Nablarchタグ | 補足 |
|---|---|---|
| form | n:form | |
| input(type=text) | n:text | |
| textarea | n:textarea | 置き換え後、textareaタグのボディ（値）は削除される |
| input(type=password) | n:password | |
| input(type=radio) | n:radioButton | label属性をブランクで出力する |
| input(type=checkbox) | n:checkbox | label属性をブランクで出力する |
| input(type=file) | n:file | |
| input(type=hidden) | n:hidden | |
| select | n:select | listName属性、elementLabelProperty属性、elementValueProperty属性をブランクで出力する。置き換え後、selectタグのボディ（optionタグ）は削除される |
| input(type=submit, button, image) | n:submit | uri属性をブランクで出力する |
| button | n:button | uri属性をブランクで出力する |
| a | n:submitLink | uri属性をブランクで出力する |
| img | n:img | |
| link | n:link | |
| script | n:script | |

**使用禁止とするHTMLタグの属性**

[html_check_tool](toolbox-03-HtmlCheckTool.md) と同じ形式のCSVファイルに定義する。本ツールとHTMLチェックツールで同じCSVファイルを使用することを推奨。

CSVファイルは [html_check_tool](toolbox-03-HtmlCheckTool.md) と併用することを想定しているため、使用禁止タグ（appletなど）を含めることが可能となっている。デフォルト定義:

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

**追加するディレクティブ**（デフォルトエンコーディング: UTF-8）

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
```

**デフォルト動作の変更設定**

| キー | 説明 |
|---|---|
| invalid.html.csv.path | 使用禁止HTMLタグの属性を定義したCSVファイルのパス。指定がない場合は属性削除を行わない |
| use.error.tag | 入力項目と一緒にn:errorタグを出力するか否か。デフォルト: true |
| error.tag.position | n:errorタグの出力位置。"ABOVE"（入力項目の直前）または"BELOW"（直後）。デフォルト: "BELOW" |
| use.directive | ディレクティブを出力するか否か。デフォルト: true |
| directive.content.type.encoding | pageディレクティブのcontentTypeのエンコーディング。デフォルト: UTF-8 |
| directive.page.encoding | pageディレクティブのpageEncodingのエンコーディング。デフォルト: UTF-8 |
| jsp.line.separator | JSPファイルの改行コード（LF/CR/CRLF）。デフォルト: LF |
| jsp.charset | JSPファイルの文字コード。デフォルト: UTF-8 |
| jsp.max.line.columns | JSPファイルの1行の最大桁数。デフォルト: 150 |
| html.charset | HTMLファイルの文字コード。デフォルト: UTF-8 |

<details>
<summary>keywords</summary>

n:form, n:text, n:textarea, n:password, n:radioButton, n:checkbox, n:file, n:hidden, n:select, n:submit, n:button, n:submitLink, n:img, n:link, n:script, n:error, invalid.html.csv.path, use.error.tag, error.tag.position, use.directive, directive.content.type.encoding, directive.page.encoding, jsp.line.separator, jsp.charset, jsp.max.line.columns, html.charset, HTMLタグ変換仕様, ディレクティブ設定, 使用禁止属性定義, タグ対応

</details>

## 前提条件

開発環境構築ガイドに従って開発環境を構築済みであること。

<details>
<summary>keywords</summary>

開発環境構築, 前提条件

</details>

## 使用方法

EclipseでツールをするにはEclipseの設定が必要。設定方法は :ref:`SetUpJspGeneratorTool` を参照。設定後はEclipse上からツールを実行できる。実行方法は :ref:`SetUpJspGeneratorTool_howToExecuteFromEclipse` を参照。

HTMLファイルと同じ場所にJSPファイルが生成される。HTMLファイルが含まれるディレクトリをリフレッシュすることでEclipse上で参照できる。

**HTMLファイル作成時の注意点**

> **警告**: selectタグ・textareaタグは変換時にボディを削除するため、閉じタグがない場合はファイルの最後まで削除される。閉じタグを省略しないこと。

- 属性はダブルクォートで囲み値を明確にする

<details>
<summary>keywords</summary>

Eclipse設定, SetUpJspGeneratorTool, SetUpJspGeneratorTool_howToExecuteFromEclipse, JSP生成, HTMLファイル作成, 閉じタグ, ダブルクォート, 使用方法

</details>
