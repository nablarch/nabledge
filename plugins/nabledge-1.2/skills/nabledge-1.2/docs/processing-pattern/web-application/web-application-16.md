# JavaScriptから操作できるようにHTMLのinput(type="hidden")タグを出力することはできますか？

## n:plainHiddenタグによるinput(type="hidden")出力

`n:hidden` タグはHTMLの `input(type="hidden")` タグを出力せず、ウィンドウスコープに値を出力する。JavaScriptから操作できる `input(type="hidden")` タグを出力するには `n:hidden` ではなく `n:plainHidden` タグを使用する。

```jsp
<%-- n:plainHiddenタグの使用例 --%>
<n:plainHidden name="user.id" />
```

<details>
<summary>keywords</summary>

n:plainHidden, n:hidden, input type hidden, HTMLタグ出力, JavaScriptアクセス, ウィンドウスコープ

</details>
