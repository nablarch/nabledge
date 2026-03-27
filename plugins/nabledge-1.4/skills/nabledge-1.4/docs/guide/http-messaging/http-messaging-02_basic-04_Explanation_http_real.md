# HTTP同期応答型メッセージ受信処理のアプリケーション構造

## 概要

## 概要

- 業務Actionの実装内容はMOMによるメッセージング処理と同様の実装でHTTPメッセージングを実現できる
- HTTP同期応答型メッセージングのデータ形式として一般的に用いるJSON/XML形式は汎用データフォーマッターでサポートされており、固定長ファイルやCSV/TSVと同様に扱える

<details>
<summary>keywords</summary>

HTTP同期応答型メッセージング, MOMメッセージング, JSON/XMLデータ形式, 汎用データフォーマッター, HTTPメッセージング実装

</details>

## 処理の流れ

## 処理の流れ

WebコンテナからNablarch Application Frameworkへ要求電文が到達するたびに以下の処理が実行される:

1. Nablarch Application Frameworkは`messaging.config`のURIをもとに業務アクションクラスを起動する
2. 業務アクションは要求電文を受け取り業務処理を実行し、応答電文を戻り値として返却する
3. Nablarch Application Frameworkは返却された応答電文をWebコンテナへ返却する

<details>
<summary>keywords</summary>

HTTP同期応答型メッセージング処理フロー, messaging.config, 業務アクション, 要求電文, 応答電文

</details>
