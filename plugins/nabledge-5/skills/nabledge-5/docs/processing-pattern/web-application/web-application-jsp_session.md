# JSPで自動的にHTTPセッションを作成しないようにする方法

**公式ドキュメント**: [JSPで自動的にHTTPセッションを作成しないようにする方法](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/jsp_session.html)

## JSPでHTTPセッション自動作成を無効にする方法

JSPのデフォルト動作ではHTTPセッションが存在しない場合に自動的にHTTPセッションが作成される。HTTPセッションが不要な画面でもセッションが作成されサーバメモリを消費するため、JSPでHTTPセッションを自動的に作成しないようにすることを推奨する。

各JSPの先頭に以下を追加する:

```jsp
<%@ page session="false" %>
```

> **重要**: :ref:`hidden暗号化機能(非推奨機能) <tag-hidden_encryption>` を使用した場合、hidden暗号化処理内でHTTPセッションを使用するため、上記設定は使用できない。

<details>
<summary>keywords</summary>

HTTPセッション自動作成無効化, session="false", JSPセッション設定, メモリ消費抑制, hidden暗号化との非互換

</details>
