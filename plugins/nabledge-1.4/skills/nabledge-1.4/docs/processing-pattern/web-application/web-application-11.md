# Javascript を使用することはできますか。

> **question:**
> Javascript を使用することはできますか。使用できたとして、何か制約はありますか。

> **answer:**
> 使用できます。jQuery等のサードパーティライブラリを利用することも可能です。
> ただし、以下の点に留意してください。

> 1. >   フレームワークで使用しているので、接頭辞 **"nablarch_"** で始まるグローバル変数を定義するのは避けてください。
> 2. >   Javascriptコードは、<script>タグではなく、下記のようにJSPタグ<n:script>を使用して定義してください。

> ```jsp
> <%-- 外部スクリプトファイルを読み込む場合 --%>
> <n:script type="text/javascript" src="/js/common.js" />
> 
> <%-- ページ内にスクリプトを直接記述する場合 --%>
> <n:script type="text/javascript">
> function common_validate() {
>     <%--内容は省略--%>
> }
> </n:script>
> ```
