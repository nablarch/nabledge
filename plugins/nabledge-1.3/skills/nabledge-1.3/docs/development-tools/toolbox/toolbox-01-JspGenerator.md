# JSP自動生成ツール

## 概要

本ツールは、HTMLファイルをインプットとしてJSPファイルを生成する。
これにより、定型的なHTML→JSP変換を自動化する。

本ツールは、HTML、JSPの構文チェックを行わない。
HTML、JSPの構文チェックについては、 [HTMLチェックツール](../../../guide/development_guide/08_TestTools/03_HtmlCheckTool/index.html) 、 [JSP静的解析ツール](../../../guide/development_guide/08_TestTools/04_JspStaticAnalysis/index.html) を参照。

## 要求

* HTMLタグを対応するNablarchタグに変換できること。
* 不要なHTMLタグを変換時に削除できること。
* HTMLファイルを指定してJSPファイルを自動生成できること。
  (例えばEclipse上でHTMLファイルを選択、右クリックから実行など)

## 仕様

本ツールは、HTMLファイルを先頭から読み込み、HTML要素を順に変換していく。
一度、読み込んだHTML要素、および変換で追加したJSPは、以降の処理対象に含めない。

HTML→JSP変換は、下記のルールで行う。

* HTMLタグとNablarchタグが1対1に対応するHTMLタグを変換対象とする。
* HTMLタグの属性値をNablarchタグの対応する属性にそのまま出力する。
* 不要なHTMLタグの属性を変換時に削除する。
  HTMLタグの削除は行わない(JSP上で修正対象が分からなくなるのを防ぐため)。
  不要なHTMLタグの属性は下記とする。

* 使用禁止とするHTMLタグの属性
* Nablarchタグに存在しない属性

* Nablarchタグの必須属性は常に出力する。
  Nablarchタグの必須属性に対応する値がHTMLタグに指定されていない場合、必須属性の値はブランクとする。
* n:textなどの入力項目は、入力項目のすぐ後にn:errorタグを出力する。
* JSPファイルの先頭にディレクティブ(taglibディレクティブとpageディレクティブ)を出力する。
* 設定により、上記デフォルト動作の変更を可能とする。
  変更可能なデフォルト動作は下記のとおり。

* 使用禁止とするHTMLタグの属性定義
* n:errorタグの出力有無と出力位置
* ディレクティブの出力有無とエンコーディング

* HTMLコメント( **<!-- xxx -->** ) は、同じ内容のJSPコメント( **<%-- xxx --%>** ) に置換する。
  (ただし、 **<script>** 内のjavascriptを囲んでいるHTMLコメントを除く。)

**HTMLタグとNablarchタグの対応**

HTMLタグとNablarchタグの対応を下記に示す。

| HTMLタグ | Nablarchタグ | 補足説明 |
|---|---|---|
| form | n:form |  |
| input(type=text) | n:text |  |
| textarea | n:textarea | 置き換え後、textareaタグのボディ(値)は削除される。 |
| input(type=password) | n:password |  |
| input(type=radio) | n:radioButton | label属性をブランクで出力する。 |
| input(type=checkbox) | n:checkbox | label属性をブランクで出力する。 |
| input(type=file) | n:file |  |
| input(type=hidden) | n:hidden |  |
| select | n:select | listName属性、elementLabelProperty属性、elementValueProperty属性 をブランクで出力する。 置き換え後、selectタグのボディ(optionタグ)は削除される。 |
| input(type=submit, button, image) | n:submit | uri属性をブランクで出力する。 |
| button | n:button | uri属性をブランクで出力する。 |
| a | n:submitLink | uri属性をブランクで出力する。 |
| img | n:img |  |
| link | n:link |  |
| script | n:script |  |

**使用禁止とするHTMLタグの属性**

使用禁止とするHTMLタグの属性は、 [HTMLチェックツール](../../development-tools/toolbox/toolbox-03-HtmlCheckTool.md#html-check-tool) と同じ形式でCSVファイルに定義する。
記述形式の詳細については、 [HTMLチェックツール](../../development-tools/toolbox/toolbox-03-HtmlCheckTool.md#html-check-tool) を参照。
通常、使用禁止とするHTMLタグの内容を合わせるために、本ツールと [HTMLチェックツール](../../../guide/development_guide/08_TestTools/03_HtmlCheckTool/index.html) で同じCSVファイルを使用する。

デフォルトの定義を下記に示す。
CSVファイルは、 [HTMLチェックツール](../../development-tools/toolbox/toolbox-03-HtmlCheckTool.md#html-check-tool) と併用することを想定しているため、
使用禁止タグ(appletなど)を含めることが可能となっている。

```bash
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

**追加するディレクティブ**

JSPファイルの先頭に下記のディレクティブを出力する。
デフォルトのエンコーディングはUTF-8とする。

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
```

**デフォルト動作の変更方法**

設定ファイルに下記キーで設定を行うことで、デフォルト動作を変更できる。
指定可能な設定のキーを下記に示す。

| キー | 説明 |
|---|---|
| invalid.html.csv.path | 使用禁止とするHTMLタグの属性を定義したCSVファイルのパス。 指定がない場合は使用禁止とするHTMLタグの属性削除を行わない。 |
| use.error.tag | 入力項目と一緒にn:errorタグを出力するか否か。 デフォルトはtrue。 |
| error.tag.position | n:errorタグの出力位置。 入力項目のすぐ前に出力する場合は"ABOVE"。 入力項目のすぐ後に出力する場合は"BELOW"。 デフォルトは"BELOW"。 |
| use.directive | ディレクティブを出力するか否か。 デフォルトはtrue。 |
| directive.content.type.encoding | pageディレクティブのcontentTypeに指定するエンコーディング。 デフォルトはUTF-8。 |
| directive.page.encoding | pageディレクティブのpageEncodingに指定するエンコーディング。 デフォルトはUTF-8。 |
| jsp.line.separator | JSPファイル出力時に使用する改行コード。 次のいずれかを指定する。 LF(Line Feed) CR(Carriage Return) CRLF デフォルトはLF。 |
| jsp.charset | JSPファイルの文字コード。 デフォルトはUTF-8。 |
| jsp.max.line.columns | JSPファイルの1行の最大桁数。 デフォルトは150。 |
| html.charset | HTMLファイルの文字コード。 デフォルトはUTF-8。 |

## 前提条件

* 開発環境構築ガイドに従って開発環境を構築済みであること。

## 使用方法

ツールを使用する際は、 Eclipse の設定が必要になる。
設定方法は [JSP自動生成ツール インストールガイド](../../development-tools/toolbox/toolbox-02-SetUpJspGeneratorTool.md#setupjspgeneratortool) を参照。

一度上記設定を行った後は、 Eclipse上からツールを実行できる。
実行方法は、 [HTMLファイルからの起動方法](../../development-tools/toolbox/toolbox-02-SetUpJspGeneratorTool.md#setupjspgeneratortool-howtoexecutefromeclipse) を参照。

HTMLファイルと同じ場所にJSPファイルが生成される。
HTMLファイルが含まれるディレクトリをリフレッシュすることでEclipse上で参照できる。

本ツールを使用してJSPファイルを生成する場合、下記の点を考慮してHTMLファイルを作成することで、
仕様どおりの変換が行われたJSPファイルが生成される。

* 閉じタグを省略しない。特にselectタグ、textareタグは変換時にボディを削除するため、
  閉じタグがない場合はファイルの一番最後まで削除されるので注意すること。
* 属性はダブルクォートで囲み値を明確にする。
