# JavaScriptから操作できるようにHTMLのinput(type="hidden")タグを出力することはできますか？

> **question:**
> JavaScriptから操作できるようにHTMLのinput(type="hidden")タグを出力することはできますか？

> n:hiddenタグを使用するとHTMLにinput(type="hidden")タグが出力されません。

> **answer:**
> n:hiddenタグはHTMLのタグを出力せずに、ウィンドウスコープに値を出力します。

> HTMLのinput(type="hidden")タグを出力する場合は、n:plainHiddenタグを使用します。

> ```jsp
> <%-- n:plainHiddenタグの使用例 --%>
> <n:plainHidden name="user.id" />
> ```
