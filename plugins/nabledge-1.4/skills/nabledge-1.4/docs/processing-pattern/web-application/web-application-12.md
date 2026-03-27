# JavaScriptコードを記述すると静的解析ツールでエラーが発生します。対処方法を教えてください。

## JSPでのJavaScriptコード記述方法

## JSPでのJavaScriptコード記述方法

JSPにJavaScriptコードを記述する場合は `<n:script>` タグを使用すること。

- HTMLコメントタグ（`<!-- -->`）でくくって記述すると、JSP静的解析ツールで `<!-- (at line=XX column=XX) is forbidden.` エラーが発生する。
- HTMLコメントタグなしで直接記述すると、HTMLチェックツールで `InvalidHtmlException` が発生する。

**JSP記述例**:
```xml
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

`<n:script>` タグを使用すると、HTML出力時に自動的にHTMLコメントで囲まれた `<script>` タグとして出力される:
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

n:script, JavaScriptコード, JSP静的解析エラー, HTMLコメントタグ, HTMLチェックツール, InvalidHtmlException, 静的解析ツール対処, HtmlChecker, HtmlSyntaxChecker, TokenMgrError, ParserTokenManager

</details>
