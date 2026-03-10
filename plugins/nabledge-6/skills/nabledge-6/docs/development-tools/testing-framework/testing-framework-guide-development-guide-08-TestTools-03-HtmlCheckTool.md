# HTMLチェックツール

**公式ドキュメント**: [HTMLチェックツール](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/08_TestTools/03_HtmlCheckTool/index.html)

## 目的

HTMLチェックツールの目的:
- 終了タグ忘れ等の構文不正により、想定している画面表示とは異なる画面がユーザに表示されることを防ぐ。
- プロジェクトの規約により禁止されているタグが使用されることを防ぐ。

<details>
<summary>keywords</summary>

HTMLチェックツール, 構文チェック, 禁止タグ検出, 終了タグ忘れ防止, HTML不正検出

</details>

## 仕様

リクエスト単体テストに標準で組み込まれており、リクエスト単体テスト実行時に本ツールも実行される。

チェック仕様:
- デフォルトではHTML4.01に準拠して構文チェックを行う（設定変更でカスタマイズ可能）。HTML4.01との一部相違点あり。
- 開始タグ・終了タグの記述漏れをチェック。HTML4.01で省略可能なタグも省略を許可しない。
- 設定ファイルに記載されたタグ・属性が使用されていないかチェック。デフォルト設定では[W3C公式サイト](https://www.w3.org/TR/html401/)にて非推奨とされているタグ・属性が設定されている（カスタマイズ方法は「使用禁止タグ・属性のカスタマイズ方法」を参照）。
- 大文字・小文字の区別は行わない（例: `<tr>`, `<TR>`, `<Tr>`, `<tR>`）。
- boolean属性は使用可能（例: `<textarea disabled>`）。
- 属性指定のクォーテーション省略を許可しない（○ `<table align="center">` × `<table align=center>`）。

> **補足**: HTMLに直接記述したJavaScriptに「-」が2つ以上連続で現れた場合はテスト失敗となる（例: デクリメント演算子`count--`、文字列`"--"`）。
>
> テスト失敗となるJavaScript実装例:
> ```jsp
> var message = "--"   // 文字列で「-」が連続する。
>   , count = 10;
> count--;             //  デクリメント演算子で「-」が連続する。
> ```
>
> エラーメッセージ:
> ```
> Lexical error at line 965, column 31.  Encountered: "-" (45), after : "--"
> ```
>
> 対応方法: JavaScriptはHTML(JSP)に直接記述せず、外部ファイル化して対応すること。

<details>
<summary>keywords</summary>

HTML4.01準拠, タグ構文チェック, boolean属性, クォーテーション省略禁止, W3C非推奨タグ, HTMLチェック仕様, JavaScript連続ハイフン

</details>

## HTML4.01との相違点

ボディが空のタグを許容する（クライアントサイドでのDOM操作が一般化しているため、HTML4.01の仕様とは異なる扱い）。

```html
<!-- 空のspanタグ -->
<span id="foo"></span>

<!-- optionのないselectタグ -->
<select id="bar"></select>
```

<details>
<summary>keywords</summary>

HTML4.01との相違点, 空タグ許容, 空のspanタグ, optionのないselectタグ, DOM操作

</details>

## 前提条件

HTMLチェックツールを使用するための前提条件:
- リクエスト単体テストを実行可能であること。

<details>
<summary>keywords</summary>

前提条件, リクエスト単体テスト実行, HTMLチェックツール使用条件

</details>

## 使用禁止タグ・属性のカスタマイズ方法

デフォルトの設定をそのまま使用する場合、プロジェクト開始時に設定変更を行う必要はない。

`htmlCheckerConfig`プロパティに設定ファイルへのパスを指定する。設定ファイルを配布時とは異なる場所に配置する場合はこのプロパティを修正する。

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="htmlCheckerConfig" value="test/resources/httprequesttest/html-check-config.csv" />
</component>
```

設定ファイルの記述方法:
- 一行にカンマ区切りでタグ名と属性名を記述する。
- 一つのタグに複数の属性を設定する場合は複数行で記述する。
- 属性欄を省略するとタグ自体の使用を指摘する。属性欄省略時もカンマは省略不可。

```
body,bgcolor
body,link
body,text
table,align
table,bgcolor
td,bgcolor
td,height
td,nowrap
th,bgcolor
th,height
th,nowrap
tr,bgcolor
```

属性欄省略例（タグ自体を禁止）:
```
body,
```

<details>
<summary>keywords</summary>

htmlCheckerConfig, 使用禁止タグ設定, タグ・属性カスタマイズ, 禁止タグ変更, html-check-config.csv, HttpTestConfiguration

</details>

## HTMLチェック実行要否の設定方法

`checkHtml`プロパティで制御する。`true`でHTMLチェックを実施、`false`で実施しない。

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="checkHtml" value="true" />
</component>
```

<details>
<summary>keywords</summary>

checkHtml, HTMLチェック有効化, チェック実行要否, HTMLチェック無効化, HttpTestConfiguration

</details>

## HTMLチェック内容の変更

**クラス**: `nablarch.test.core.http.HttpTestConfiguration`

`htmlChecker`プロパティを変更することでHTMLチェック内容を変更できる。`HtmlChecker`インターフェースを実装したクラスを設定する。

実装例（`<html>`タグで始まることをチェック）:

```java
public class SimpleHtmlChecker implements HtmlChecker {
    private String encoding;

    @Override
    public void checkHtml(File html) throws InvalidHtmlException {
        StringBuilder sb = new StringBuilder();
        InputStreamReader reader = null;
        try {
            reader = new InputStreamReader(new FileInputStream(html), encoding);
            char[] buf = new char[1024];
            int len = 0;
            while ((len = reader.read(buf)) > 0) {
                sb.append(buf, 0, len);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            FileUtil.closeQuietly(reader);
        }
        if (!sb.toString().trim().startsWith("<html>")) {
            throw new InvalidHtmlException("html not starts with <html>");
        }
    }

    public void setEncoding(String encoding) {
        this.encoding = encoding;
    }
}
```

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="htmlChecker" ref="htmlChecker" />
</component>

<component name="htmlChecker" class="nablarch.test.core.http.example.htmlcheck.SimpleHtmlChecker">
    <property name="encoding" value="UTF-8"/>
</component>
```

<details>
<summary>keywords</summary>

htmlChecker, HtmlChecker, HttpTestConfiguration, HTMLチェック内容変更, SimpleHtmlChecker, InvalidHtmlException

</details>

## テスト実行時指摘確認方法

リクエスト単体テスト実行時、自動生成されたHTMLファイルに指摘が存在した場合、該当テストケースは失敗する。JUnitコンソールに指摘箇所と指摘内容が出力される。

![JUnitコンソールへの指摘箇所・指摘内容の出力例](../../knowledge/development-tools/testing-framework/assets/testing-framework-guide-development-guide-08-TestTools-03-HtmlCheckTool/how-to-trace-html.png)

該当HTMLの出力元となるJSPを修正し、テストを再実行する。

<details>
<summary>keywords</summary>

テスト失敗, JUnitコンソール, 指摘箇所確認, JSP修正, HTMLチェック結果表示

</details>
