# JavaScriptから操作できるようにHTMLのinput(type="hidden")タグを出力することはできますか？

## n:plainHiddenタグによるHTMLのhidden入力フィールド出力

## n:plainHiddenタグによるHTMLのhidden入力フィールド出力

`n:hidden`タグはHTMLタグを出力せず、ウィンドウスコープに値を出力する。

> **重要**: JavaScriptから操作できるHTMLの`input(type="hidden")`タグを出力する場合は、`n:hidden`ではなく`n:plainHidden`タグを使用すること。

```jsp
<%-- n:plainHiddenタグの使用例 --%>
<n:plainHidden name="user.id" />
```

<details>
<summary>keywords</summary>

n:plainHidden, n:hidden, input type hidden, JavaScriptから操作可能なhidden入力フィールド, ウィンドウスコープ, hidden タグ出力

</details>
