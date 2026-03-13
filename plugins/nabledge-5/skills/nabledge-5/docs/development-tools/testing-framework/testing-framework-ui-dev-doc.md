# Nablarch UI開発基盤 解説書

**公式ドキュメント**: [Nablarch UI開発基盤 解説書](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/index.html)

## 前提知識と注意事項

> **重要**: UI開発基盤を使用する際には以下の知識が必要。これらの有識者がいない場合、UI開発基盤の使用は困難。
>
> - [Node.js](https://nodejs.org/en/)
> - [RequireJS](https://requirejs.org/)
> - [jQuery](https://jquery.com/)
> - [Sugar](https://sugarjs.com/)
> - [less](https://lesscss.org/)
>
> また、UI開発基盤は設計工程からJSPを作成するアプローチを採用しているが、以下の理由により「設計工程用JSPと開発工程用JSPのダブルメンテナンス」が往々にして発生する:
>
> - JSPに設計工程のみで必要な情報を埋め込むため、開発工程での可読性が著しく低下する
> - 開発時に分岐などのロジックが埋め込まれた場合、設計工程と開発工程で全く同じJSPは使用不可能

<details>
<summary>keywords</summary>

UI開発基盤, 前提知識, 必要知識, Node.js, RequireJS, jQuery, Sugar, less, JSPダブルメンテナンス, 設計工程, 開発工程

</details>
