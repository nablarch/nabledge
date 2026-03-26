# JSP自動生成ツール

## 概要

HTMLファイルをインプットとしてJSPファイルを生成するツール。定型的なHTML→JSP変換を自動化する。

> **注意**: HTML・JSPの構文チェックは行わない。構文チェックは [HTMLチェックツール](../../../../app_dev_guide/guide/development_guide/08_TestTools/03_HtmlCheckTool/index.html) および [JSP静的解析ツール](../../../../app_dev_guide/guide/development_guide/08_TestTools/04_JspStaticAnalysis/index.html) を参照。

<details>
<summary>keywords</summary>

JSP自動生成ツール, HTML→JSP変換, 自動変換, 構文チェック対象外

</details>

## ツール配置場所

チュートリアルプロジェクトの `tool/jspgenerator` ディレクトリに配置されている。

<details>
<summary>keywords</summary>

tool/jspgenerator, ツール配置場所, jspgenerator

</details>

## 要求

- HTMLタグを対応するNablarchタグに変換できること
- 不要なHTMLタグを変換時に削除できること
- HTMLファイルを指定してJSPファイルを自動生成できること（例: Eclipse上でHTMLファイルを選択し右クリックから実行）

<details>
<summary>keywords</summary>

HTMLタグ変換, Nablarchタグ変換, JSP自動生成, 不要タグ削除

</details>

## 仕様

HTMLファイルを先頭から読み込み、HTML要素を順に変換する。一度読み込んだHTML要素および変換で追加したJSPは以降の処理対象に含めない。

**変換ルール**:

- HTMLタグとNablarchタグが1対1に対応するHTMLタグを変換対象とする
- HTMLタグの属性値をNablarchタグの対応する属性にそのまま出力する
- 不要なHTMLタグの属性を変換時に削除する（HTMLタグ自体の削除は行わない。JSP上で修正対象が分からなくなるのを防ぐため）
  - 使用禁止とするHTMLタグの属性
  - Nablarchタグに存在しない属性
- Nablarchタグの必須属性は常に出力する。対応する値がHTMLタグに指定されていない場合、必須属性の値はブランク
- n:textなどの入力項目のすぐ後にn:errorタグを出力する
- JSPファイルの先頭にディレクティブ（taglibディレクティブとpageディレクティブ）を出力する
- HTMLコメント `<!-- xxx -->` は同じ内容のJSPコメント `<%-- xxx --%>` に置換する（`<script>`内のJavaScriptを囲んでいるHTMLコメントを除く）

**HTMLタグとNablarchタグの対応**:

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

**使用禁止とするHTMLタグの属性**:

[html_check_tool](toolbox-03-HtmlCheckTool.md) と同じ形式のCSVファイルに定義する。通常、本ツールと [HTMLチェックツール](../../../../app_dev_guide/guide/development_guide/08_TestTools/03_HtmlCheckTool/index.html) で同じCSVファイルを使用する。

CSVファイルは `html_check_tool` と併用することを想定しているため、使用禁止タグ（appletなど）を含めることが可能となっている。

デフォルト定義:

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

**追加するディレクティブ**:

JSPファイルの先頭に出力するディレクティブ（デフォルトエンコーディング: UTF-8）:

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
```

**デフォルト動作の変更方法**:

設定ファイルに以下のキーで設定することでデフォルト動作を変更できる。

| キー | 説明 |
|---|---|
| invalid.html.csv.path | 使用禁止HTMLタグの属性を定義したCSVファイルのパス。指定がない場合は属性削除を行わない |
| use.error.tag | 入力項目と一緒にn:errorタグを出力するか否か。デフォルト: true |
| error.tag.position | n:errorタグの出力位置。"ABOVE"（入力項目の前）または"BELOW"（後）。デフォルト: "BELOW" |
| use.directive | ディレクティブを出力するか否か。デフォルト: true |
| directive.content.type.encoding | pageディレクティブのcontentTypeに指定するエンコーディング。デフォルト: UTF-8 |
| directive.page.encoding | pageディレクティブのpageEncodingに指定するエンコーディング。デフォルト: UTF-8 |
| jsp.line.separator | JSPファイル出力時の改行コード。LF / CR / CRLF。デフォルト: LF |
| jsp.charset | JSPファイルの文字コード。デフォルト: UTF-8 |
| jsp.max.line.columns | JSPファイルの1行の最大桁数。デフォルト: 150 |
| html.charset | HTMLファイルの文字コード。デフォルト: UTF-8 |

<details>
<summary>keywords</summary>

n:form, n:text, n:textarea, n:password, n:radioButton, n:checkbox, n:file, n:hidden, n:select, n:submit, n:button, n:submitLink, n:img, n:link, n:script, n:error, invalid.html.csv.path, use.error.tag, error.tag.position, use.directive, directive.content.type.encoding, directive.page.encoding, jsp.line.separator, jsp.charset, jsp.max.line.columns, html.charset, 変換ルール, ディレクティブ出力, 設定キー, HTMLコメント置換, 使用禁止属性

</details>

## 前提条件

開発環境構築ガイドに従って開発環境を構築済みであること。

<details>
<summary>keywords</summary>

前提条件, 開発環境構築

</details>

## 使用方法

ツールを使用する際はEclipseの設定が必要。設定方法は :ref:`SetUpJspGeneratorTool` を参照。

設定後はEclipse上からツールを実行可能。実行方法は :ref:`SetUpJspGeneratorTool_howToExecuteFromEclipse` を参照。

HTMLファイルと同じ場所にJSPファイルが生成される。HTMLファイルが含まれるディレクトリをリフレッシュすることでEclipse上で参照できる。

HTMLファイル作成時の注意点（仕様どおりの変換を行うため）:

- **閉じタグを省略しない**: selectタグ、textareaタグは変換時にボディを削除するため、閉じタグがない場合はファイルの一番最後まで削除される
- **属性はダブルクォートで囲む**: 値を明確にする

<details>
<summary>keywords</summary>

Eclipse設定, JSP生成実行, SetUpJspGeneratorTool, 閉じタグ省略禁止, 使用方法

</details>
