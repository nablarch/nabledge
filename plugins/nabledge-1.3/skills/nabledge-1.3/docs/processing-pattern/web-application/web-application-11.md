# Javascript を使用することはできますか。

## JavaScriptの使用と制約

JavaScriptは使用可能。jQuery等のサードパーティライブラリも利用可能。

以下の点に留意:

1. 接頭辞 **`nablarch_`** で始まるグローバル変数の定義は避けること（フレームワークが使用している）
2. JavaScriptコードはHTMLの `<script>` タグではなく、JSPタグ `<n:script>` を使用して定義すること

```jsp
<%-- 外部スクリプトファイルを読み込む場合 --%>
<n:script type="text/javascript" src="/js/common.js" />

<%-- ページ内にスクリプトを直接記述する場合 --%>
<n:script type="text/javascript">
function common_validate() {
    <%--内容は省略--%>
}
</n:script>
```

<details>
<summary>keywords</summary>

JavaScript使用可否, n:script タグ, nablarch_ 接頭辞, グローバル変数制約, jQuery サードパーティライブラリ, JSP JavaScript, script タグ禁止

</details>
