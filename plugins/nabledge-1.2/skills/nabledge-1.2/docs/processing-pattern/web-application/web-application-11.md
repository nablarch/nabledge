# Javascript を使用することはできますか。

## JavaScriptの使用と制約

JavaScriptは使用可能。jQuery等のサードパーティライブラリも利用可能。

以下の制約に従うこと:

1. フレームワークが `"nablarch_"` 接頭辞のグローバル変数を使用しているため、`"nablarch_"` で始まるグローバル変数を定義してはならない。
2. JavaScriptコードは `<script>` タグではなく `<n:script>` タグを使用して定義すること。

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

JavaScript使用可否, n:scriptタグ, nablarch_グローバル変数, サードパーティライブラリ, jQuery, JSPスクリプト定義

</details>
