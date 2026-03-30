# HTMLチェックツール

**公式ドキュメント**: [HTMLチェックツール](http://www.w3.org/TR/html401/)

## 目的

HTMLチェックツールの目的:
- 終了タグ忘れ等の構文不正により、想定とは異なる画面がユーザーに表示されることを防ぐ
- プロジェクト規約により禁止されているタグが使用されることを防ぐ

<details>
<summary>keywords</summary>

HTMLチェックツール, 構文チェック, 禁止タグ, 画面表示不具合防止, 終了タグ忘れ

</details>

## 仕様

リクエスト単体テスト実行時に自動生成されたHTMLファイルに対してチェックを行い、不正なHTMLを検出した場合テスト失敗とする。本ツールはリクエスト単体テストに標準で組み込まれており、リクエスト単体テスト実行時に自動実行される。

チェック仕様:
- デフォルトでHTML4.01に準拠した構文チェックを実施（設定変更でカスタマイズ可能）
- 開始タグ・終了タグの記述漏れをチェック。HTML4.01で省略可能と規定されているタグも省略不可
- 設定ファイルに記載されたタグ・属性の使用有無をチェック（設定方法は [01_custom](#) 参照）
- 大文字・小文字の区別なし（例: `<tr>`, `<TR>`, `<Tr>`, `<tR>` はすべて同等）
- boolean属性は使用可（例: `<textarea disabled>`）
- 属性値のクォーテーション省略は不可（`<table align="center">` は可、`<table align=center>` は不可）

デフォルト設定: [W3C公式サイト](http://www.w3.org/TR/html401/)で非推奨とされているタグ・属性が禁止設定に含まれる。設定ファイルのカスタマイズで変更可能（カスタマイズ方法は [01_custom](#) 参照）。

> **注意**: JavaScriptをHTML(JSP)に直接記述した場合、「-」が2つ以上連続するとテスト失敗となる（デクリメント演算子 `--` や文字列中の `"--"` 含む）。対応方法: JavaScriptを外部ファイルに記述する。

<details>
<summary>keywords</summary>

HTML4.01, 構文チェック, タグ属性チェック, boolean属性, クォーテーション省略, リクエスト単体テスト, JavaScript, W3C非推奨タグ, htmlCheckerConfig

</details>

## HTML4.01との相違点

動的なDOM操作が一般化しているため、本ツールはHTML4.01と異なり**ボディが空のタグを許容**する。

以下はエラーにならない:
```html
<!-- 空のspanタグ -->
<span id="foo"></span>

<!-- optionのないselectタグ -->
<select id="bar"></select>
```

<details>
<summary>keywords</summary>

空ボディタグ, span, select, DOM操作, HTML4.01相違点

</details>

## 使用禁止タグ・属性のカスタマイズ方法

**前提条件**: リクエスト単体テストを実行可能であること。

**クラス**: `nablarch.test.core.http.HttpTestConfiguration`

設定ファイルのパスは `htmlCheckerConfig` プロパティで指定する。配布時と異なる場所に設定ファイルを配置する場合はこのプロパティを修正する。

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="htmlCheckerConfig" value="test/resources/httprequesttest/html-check-config.csv" />
</component>
```

設定ファイルの記述方法: タグ名と属性名をカンマ区切りで1行に記述。1つのタグに複数の属性を設定する場合は複数行で記述する。デフォルト設定（W3C非推奨タグ・属性）:
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

タグ自体の使用を禁止する場合は属性名を空にする（カンマは省略不可）:
```
body,
```

<details>
<summary>keywords</summary>

htmlCheckerConfig, HttpTestConfiguration, 禁止タグ設定, 禁止属性設定, html-check-config.csv, nablarch.test.core.http.HttpTestConfiguration

</details>

## HTMLチェック実行要否の設定方法

**クラス**: `nablarch.test.core.http.HttpTestConfiguration`

`checkHtml` プロパティで制御:
- `true`: HTMLチェックを実施
- `false`: HTMLチェックを実施しない

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="checkHtml" value="true" />
</component>
```

<details>
<summary>keywords</summary>

checkHtml, HttpTestConfiguration, HTMLチェック有効化, HTMLチェック無効化, nablarch.test.core.http.HttpTestConfiguration

</details>

## HTMLチェック内容の変更

**クラス**: `nablarch.test.core.http.HttpTestConfiguration`

`htmlChecker` プロパティを変更することでHTMLチェック内容をカスタマイズできる。`HtmlChecker` インターフェースを実装したクラスを作成し、`checkHtml(File html) throws InvalidHtmlException` メソッドにチェックロジックを実装する。

実装例（`<html>` タグで始まることを検証するシンプルなチェッカ）:
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

設定例:
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

htmlChecker, HtmlChecker, HttpTestConfiguration, カスタムHTMLチェッカ, InvalidHtmlException, SimpleHtmlChecker, nablarch.test.core.http.HttpTestConfiguration

</details>

## テスト実行時指摘確認方法

リクエスト単体テスト実行時、HTMLファイルに指摘が存在した場合、該当テストケースが失敗する。JUnitコンソールに指摘箇所と指摘内容が出力される。

![JUnitコンソールの指摘確認画面](../../../knowledge/development-tools/toolbox/assets/toolbox-03-HtmlCheckTool/how-to-trace-html.png)

対応方法: 該当HTMLの出力元となるJSPを修正し、テストを再実行する。

<details>
<summary>keywords</summary>

JUnit, テスト失敗, 指摘確認, HTMLエラー確認, JSP修正

</details>
