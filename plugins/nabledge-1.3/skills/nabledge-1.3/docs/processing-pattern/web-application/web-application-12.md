# JavaScriptコードを記述すると静的解析ツールでエラーが発生します。対処方法を教えてください。

## JSPでJavaScriptを記述する方法（n:scriptタグの使用）

JSPでJavaScriptコードを記述する場合、`<n:script>`タグを使用する。

- HTMLコメントタグ(`<!-- -->`)で囲んで記述すると、JSP静的解析ツールで「`<!-- (at line=XX column=XX) is forbidden.`」エラーが発生する
- HTMLコメントタグなしで記述すると、HTMLチェックツールで`InvalidHtmlException`（`Lexical error`）が発生する（`HtmlChecker`、`HtmlSyntaxChecker`、`TokenMgrError`、`ParserTokenManager` が関与）

**解決策**: `<n:script>`タグを使用する。

```jsp
<n:script type="text/javascript">
    function clearChnKbn() {
        var element = document.getElementsByTagName("select")
        for (var i = 0; i < element.length; i++) {
          var shnKbn = element[i];
            shnKbn.selectedIndex = 0;
        }
    }
</n:script>
```

`<n:script>`を使用すると、HTMLには自動的にHTMLコメントタグで囲まれた形式で出力される:

```html
<script type="text/javascript">
<!--
    function clearChnKbn() {
        var element = document.getElementsByTagName("select")
        for (var i = 0; i < element.length; i++) {
          var shnKbn = element[i];
            shnKbn.selectedIndex = 0;
        }
    }
-->
</script>
```

<details>
<summary>keywords</summary>

n:script, JavaScriptの記述方法, JSP静的解析ツール, HTMLチェックツール, InvalidHtmlException, JSPにJavaScript埋め込み, TokenMgrError, HtmlChecker, HtmlSyntaxChecker, ParserTokenManager

</details>
