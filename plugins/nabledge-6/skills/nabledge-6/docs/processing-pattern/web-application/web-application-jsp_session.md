# JSPで自動的にHTTPセッションを作成しないようにする方法

**公式ドキュメント**: [JSPで自動的にHTTPセッションを作成しないようにする方法](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/jsp_session.html)

## JSPでHTTPセッションを自動的に作成しないようにする方法

JSPのデフォルト動作ではHTTPセッションが存在しない場合に自動的にHTTPセッションが作成される。メモリの無駄な消費を防ぐため、各JSPの先頭に以下の設定を追加してHTTPセッションの自動作成を無効にすることを推奨する。

```jsp
<%@ page session="false" %>
```

> **重要**: :ref:`hidden暗号化機能(非推奨機能) <tag-hidden_encryption>` を使用した場合、hidden暗号化処理内でHTTPセッションを使用するため、上記設定を使用することは出来ない。

<details>
<summary>keywords</summary>

HTTPセッション自動作成防止, JSPセッション設定, page session false, メモリ消費削減, hidden暗号化機能, tag-hidden_encryption

</details>
