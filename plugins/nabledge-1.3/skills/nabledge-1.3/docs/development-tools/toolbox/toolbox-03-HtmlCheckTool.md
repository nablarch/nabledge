# HTMLチェックツール

**公式ドキュメント**: [HTMLチェックツール](http://www.w3.org/TR/html401/)

## 目的

HTMLチェックツールの目的:

- 終了タグ忘れ等の構文不正により、想定している画面表示とは異なる画面がユーザーに表示されることを防ぐ。
- プロジェクトの規約により禁止されているタグが使用されることを防ぐ。

<details>
<summary>keywords</summary>

HTMLチェックツール, 構文チェック, 終了タグ検出, 禁止タグ検出, HTML検証

</details>

## 仕様

リクエスト単体テストに標準で組み込まれており、リクエスト単体テスト実行時に本ツールも実行される。不正なHTMLを検出した場合、テスト失敗となる。

チェック仕様:

- デフォルトでは HTML4.01 に準拠して構文チェックを行う（設定変更でカスタマイズ可能）。
- 開始タグ・終了タグの記述漏れをチェックする。HTML4.01 で省略可能と規定されているタグについても、省略を許可しない。
- 設定ファイルに記載されたタグ・属性を使用していないかチェックを行う。デフォルトでは [W3C公式サイト](http://www.w3.org/TR/html401/) にて非推奨とされているタグ・属性が設定されている（カスタマイズ方法は [01_custom](#) を参照）。
- 大文字・小文字の区別は行わない（例：`<tr>`, `<TR>`, `<Tr>`, `<tR>`）。
- boolean属性は使用可能（例：`<textarea disabled>`）。
- 属性指定におけるクォーテーション省略を許可しない（例：`<table align="center">` は可、`<table align=center>` は不可）。

> **注意**: HTMLに直接記述したJavaScriptに「-」が2つ以上連続で現れた場合は、テスト失敗となる。対応方法: JavaScriptをHTML(JSP)に直接記述せず、外部ファイル化して記述する。

### HTML4.01との相違点

ボディが空のタグを許容する。

```html
<!-- 空のspanタグ -->
<span id="foo"></span>

<!-- optionのないselectタグ -->
<select id="bar"></select>
```

<details>
<summary>keywords</summary>

HTML4.01, 構文チェック仕様, boolean属性, クォーテーション省略禁止, JavaScript連続ハイフン禁止, 空タグ許容, HTML4.01との相違点, タグ省略不可

</details>

## 使用方法

**クラス**: `nablarch.test.core.http.HttpTestConfiguration`

### 前提条件

リクエスト単体テストを実行可能であること。

### 使用禁止タグ・属性のカスタマイズ方法

`htmlCheckerConfig` プロパティに設定ファイルのパスを指定する（デフォルト設定をそのまま使用する場合は変更不要）。

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="htmlCheckerConfig" value="test/resources/httprequesttest/html-check-config.csv" />
</component>
```

設定ファイル形式: 1行にカンマ区切りでタグ名と属性名を記述する。

```
body,bgcolor
table,align
td,nowrap
```

属性欄を省略するとタグ自体の使用を禁止する（カンマは省略不可）:

```
body,
```

### HTMLチェック実行要否の設定

`checkHtml` プロパティで制御する（`true`: HTMLチェックを実施、`false`: 実施しない）。

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="checkHtml" value="true" />
</component>
```

### HTMLチェック内容の変更

`htmlChecker` プロパティに `HtmlChecker` インターフェース実装クラスを指定することでカスタマイズできる。`checkHtml(File html)` メソッドを実装し、無効なHTMLの場合は `InvalidHtmlException` をスローする。

```xml
<component name="httpTestConfiguration" class="nablarch.test.core.http.HttpTestConfiguration">
    <property name="htmlChecker" ref="htmlChecker" />
</component>

<component name="htmlChecker" class="nablarch.test.core.http.example.htmlcheck.SimpleHtmlChecker">
    <property name="encoding" value="UTF-8"/>
</component>
```

### テスト実行時指摘確認方法

指摘が存在した場合、該当テストケースが失敗する。JUnitコンソールに指摘箇所と内容が出力される。

![JUnitコンソールの出力例](../../../knowledge/development-tools/toolbox/assets/toolbox-03-HtmlCheckTool/how-to-trace-html.png)

<details>
<summary>keywords</summary>

htmlCheckerConfig, checkHtml, htmlChecker, HtmlChecker, InvalidHtmlException, HttpTestConfiguration, 使用禁止タグカスタマイズ, HTMLチェック有効化, カスタムHTMLチェッカー

</details>
