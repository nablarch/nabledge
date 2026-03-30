# JavaScriptコードを記述すると静的解析ツールでエラーが発生します。対処方法を教えてください。

## JSPでのJavaScript記述方法

JSPにJavaScriptコードを記述する場合は、HTMLコメントタグ（`<!-- -->`）を使用せず、`<n:script>`タグを使用すること。

- HTMLコメントタグでJavaScriptを囲むと、JSP静的解析ツールで `<!-- (at line=XX column=XX) is forbidden.` エラーが発生する
- HTMLコメントタグなしで記述すると、HTMLチェックツールで `InvalidHtmlException: Lexical error` が発生する（`HtmlChecker`、`HtmlSyntaxChecker`、`TokenMgrError`、`ParserTokenManager` などのクラスがスタックトレースに現れる）

`<n:script>`タグを使用すると、HTMLには自動的にHTMLコメント（`<!-- -->`）でくくられた`<script>`タグとして出力される。

JSP記述例:
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

HTML出力例:
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

n:script, JavaScript, JSP静的解析, HTMLチェック, InvalidHtmlException, HTMLコメントタグ, 静的解析エラー対処, HtmlChecker, HtmlSyntaxChecker, TokenMgrError, ParserTokenManager

</details>
