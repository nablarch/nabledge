# HTMLチェックツール

## 目的・仕様・HTML4.01との相違点

## 目的・仕様

**目的**:
- 終了タグ忘れ等の構文不正による意図しない画面表示を防ぐ。
- プロジェクト規約で禁止されているタグの使用を防ぐ。

リクエスト単体テスト実行時に自動生成されたHTMLファイルに対してチェックし、不正なHTMLを検出した場合はテスト失敗とする。本ツールはリクエスト単体テストに標準組み込み済み。

**チェック仕様**:
- デフォルトはHTML4.01に準拠した構文チェック（設定変更でカスタマイズ可能）
- 開始タグ・終了タグの記述漏れをチェック（HTML4.01で省略可能なタグも省略を許可しない）
- 設定ファイルに記載されたタグ・属性の使用チェック（デフォルトは[W3C公式サイト](http://www.w3.org/TR/html401/)で非推奨のタグ・属性が設定済み）
- 大文字・小文字の区別は行わない（例: `<tr>`, `<TR>`, `<Tr>`, `<tR>` はすべて同一）
- boolean属性は使用可能（例: `<textarea disabled>`）
- 属性指定のクォーテーション省略は不可（○: `<table align="center">` ×: `<table align=center>`）

> **注意**: HTMLに直接記述したJavaScriptに「-」が2つ以上連続する場合（文字列リテラル `"--"` やデクリメント演算子 `count--` など）、テストが失敗する。
>
> エラーメッセージ例:
> ```
> Lexical error at line 965, column 31.  Encountered: "-" (45), after : "--"
> ```
>
> 対応方法: JavaScriptはHTML(JSP)に直接記述せず、外部ファイル化すること。

## HTML4.01との相違点

クライアントサイドでの動的DOM操作が一般化しているため、ボディが空のタグを許容する（HTML4.01との相違点）。以下はエラーとならない例:

- `<span id="foo"></span>` — 空のspanタグ
- `<select id="bar"></select>` — optionのないselectタグ

<details>
<summary>keywords</summary>

HTMLチェックツール, HTML構文チェック, タグ検証, 非推奨タグ検出, 空タグ許容, リクエスト単体テスト, HTML4.01, JavaScriptハイフン連続エラー, Lexical error

</details>

## 前提条件

HTMLチェックツールを使用するための前提条件:

- リクエスト単体テストを実行可能であること。

<details>
<summary>keywords</summary>

前提条件, リクエスト単体テスト

</details>

## 使用禁止タグ・属性のカスタマイズ方法

デフォルトの設定をそのまま使用する場合、プロジェクト開始時に下記に述べる設定変更を行う必要はない。

テストプロジェクトの自動テスト用設定ファイルで `htmlCheckerConfig` プロパティに禁止タグ・属性を記述したCSVファイルのパスを指定する。設定ファイルを配布時と異なる場所に配置する場合はこのプロパティを修正する。

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="htmlCheckerConfig" value="test/resources/httprequesttest/html-check-config.csv" />
</component>
```

**設定ファイル（CSV）の記述方法**:

1行にカンマ区切りでタグ名と属性名を記述する。1つのタグに複数の属性を設定する場合は複数行で記述する。

デフォルトの設定内容（W3C非推奨タグ・属性）:

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

属性欄を省略するとタグ自体の使用を指摘する（カンマは省略不可）:

```
body,
```

<details>
<summary>keywords</summary>

htmlCheckerConfig, HttpTestConfiguration, nablarch.test.core.http.HttpTestConfiguration, 禁止タグ設定, 禁止属性設定, CSVカスタマイズ

</details>

## HTMLチェック実行要否の設定方法

`checkHtml` プロパティでHTMLチェックの実施有無を制御する。`true` の場合チェックを実施、`false` の場合は実施しない。

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="checkHtml" value="true" />
</component>
```

<details>
<summary>keywords</summary>

checkHtml, HttpTestConfiguration, HTMLチェック有効化, HTMLチェック無効化

</details>

## HTMLチェック内容の変更

`nablarch.test.core.http.HttpTestConfiguration` クラスの `htmlChecker` プロパティを変更することでHTMLチェック内容を変更できる。`HtmlChecker` インターフェースを実装し、`checkHtml(File html)` メソッドで検証ロジックを実装する。チェック失敗時は `InvalidHtmlException` をスローする。

実装例（`<html>` タグで始まるかチェックする `SimpleHtmlChecker`）:

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
<component name="httpTestConfiguration"
    class="nablarch.test.core.http.HttpTestConfiguration">
  <property name="htmlChecker" ref="htmlChecker" />
</component>

<component name="htmlChecker" class="nablarch.test.core.http.example.htmlcheck.SimpleHtmlChecker">
  <property name="encoding" value="UTF-8"/>
</component>
```

<details>
<summary>keywords</summary>

htmlChecker, HtmlChecker, InvalidHtmlException, SimpleHtmlChecker, nablarch.test.core.http.HttpTestConfiguration, カスタムHTMLチェック実装, HTMLチェッカ拡張

</details>

## テスト実行時指摘確認方法

リクエスト単体テスト実行時、自動生成されたHTMLファイルに指摘が存在した場合、該当するテストケースは失敗する。JUnitコンソールに指摘箇所と指摘内容が出力される。

![JUnitコンソールの指摘確認例](../../../knowledge/development-tools/toolbox/assets/toolbox-03-HtmlCheckTool/how-to-trace-html.png)

指摘が出た場合は、該当するHTMLの出力元となるJSPを修正し、テストを再実行する。

<details>
<summary>keywords</summary>

テスト失敗, JUnitコンソール, 指摘確認, HTMLエラー確認

</details>
