# フロントエンド上級者向けのUI開発基盤

**公式ドキュメント**: [フロントエンド上級者向けのUI開発基盤](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/index.html)

## 概要と前提条件

> **重要**: UI開発基盤の使用には以下の知識が必要。有識者がいない場合、使用は困難。
> - [Node.js](https://nodejs.org/en/)
> - [RequireJS](https://requirejs.org/)
> - [jQuery](https://jquery.com/)
> - [Sugar](https://sugarjs.com/)
> - [less](https://lesscss.org/)
>
> また、UI開発基盤は設計工程からJSPを作成するアプローチを採用しているが、以下の理由により、設計工程用JSPと開発工程用JSPのダブルメンテナンスが往々にして発生する:
> - JSPに設計工程のみの情報を埋め込むため、開発工程での可読性が著しく低下する
> - 開発時に分岐ロジックが埋め込まれた場合、設計工程と開発工程で同一JSPは使用不可能

<details>
<summary>keywords</summary>

UI開発基盤, フロントエンド, Node.js, RequireJS, JSPダブルメンテナンス, 前提知識, 設計工程, 開発工程

</details>
