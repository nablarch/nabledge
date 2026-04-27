# JavaScriptコードを記述すると静的解析ツールでエラーが発生します。対処方法を教えてください。

> **question:**
> JavaScriptコードをHTMLコメントタグでくくって記述したところ、JSP静的解析ツールで「<!-- (at line=XX column=XX) is forbidden.」というエラーが発生しました。

> HTMLコメントタグでくくらずに記述したところ、HTMLチェックツールで下記のようなエラーが発生しました。

> ```java
> nablarch.test.tool.htmlcheck.InvalidHtmlException: syntax check failed. file = []
>     at nablarch.test.tool.htmlcheck.HtmlChecker.doCheckSyntax(HtmlChecker.java:123)
>     ～ 省略 ～
> Caused by: nablarch.test.tool.htmlcheck.InvalidHtmlException: nablarch.test.tool.htmlcheck.parser.TokenMgrError: Lexical error at line 31, column 28.  Encountered: " " (32), after : "<"
>     at nablarch.test.tool.htmlcheck.HtmlSyntaxChecker.check(HtmlSyntaxChecker.java:44)
>     ～ 省略 ～
> Caused by: nablarch.test.tool.htmlcheck.parser.TokenMgrError: Lexical error at line 31, column 28.  Encountered: " " (32), after : "<"
>     at nablarch.test.tool.htmlcheck.parser.ParserTokenManager.getNextToken(ParserTokenManager.java:5019)
>     ～ 省略 ～
> ```

> JavaScriptコードはどのように記述すればいいのでしょうか。

> **answer:**
> JavaScriptコードを記述したい場合は、<n:script>タグを使用してください。

> JSPの記述例を下記に示します。

> ```java
> <n:script type="text/javascript">
>     function clearChnKbn() {
>         var element = document.getElementsByTagName("select")
>         for (var i = 0; i < element.length; i++) {
>           var shnKbn = element[i];
>             shnKbn.selectedIndex = 0;
>         }
>     }
> </n:script>
> ```

> HTMLには下記のように出力されます。

> ```java
> <script type="text/javascript">
> <!--
>     function clearChnKbn() {
>         var element = document.getElementsByTagName("select")
>         for (var i = 0; i < element.length; i++) {
>           var shnKbn = element[i];
>             shnKbn.selectedIndex = 0;
>         }
>     }
> -->
> </script>
> ```
