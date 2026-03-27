# Javascript を使用することはできますか。

## JavaScriptの使用可否と制約

JavaScriptは使用可能。jQuery等のサードパーティライブラリも利用可能。

ただし以下の制約あり:

1. フレームワークが使用するため、接頭辞 **"nablarch_"** で始まるグローバル変数を定義しないこと。
2. Javascriptコードは `<script>` タグではなく、JSPタグ `<n:script>` を使用して定義すること。

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

JavaScript使用, n:script, nablarch_グローバル変数, JSPタグ, jQuery, サードパーティライブラリ

</details>
