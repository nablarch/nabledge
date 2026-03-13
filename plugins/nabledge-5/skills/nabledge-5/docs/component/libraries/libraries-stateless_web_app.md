# Webアプリケーションをステートレスにする

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/stateless_web_app.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/LanguageAttributeInHttpSession.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/TimeZoneAttributeInHttpSession.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/handler/threadcontext/UserIdAttribute.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/LanguageAttributeInHttpCookie.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/TimeZoneAttributeInHttpCookie.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/handler/threadcontext/UserIdAttributeInSessionStore.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/servlet/WebFrontController.html)

## 基本的な考え方

HTTPセッションはAPサーバで状態を持つため、スケールアウトに際して以下の対処が必要となる:

1. ロードバランサーでスティッキーセッションを有効にする
2. APサーバのセッションレプリケーション機能を使用する
3. APサーバのHTTPセッション保存先をNoSQLにする

[Twelve-Factor App](https://12factor.net/ja/) の廃棄容易性の観点で1と2は劣り、2と3はAPサーバ依存となる。

Nablarchが使用する機能のHTTPセッション依存をなくすことでAPサーバをステートレスにできる。

<details>
<summary>keywords</summary>

HTTPセッション, ステートレス, スケールアウト, スティッキーセッション, Twelve-Factor App, 廃棄容易性, セッションレプリケーション

</details>

## HTTPセッションに依存している機能

以下の機能はデフォルトでHTTPセッションに依存している:

- :ref:`session_store`
- :ref:`2重サブミット防止<tag-double_submission>`
- [thread_context_handler](../handlers/handlers-thread_context_handler.md)
- [http_rewrite_handler](../handlers/handlers-http_rewrite_handler.md)
- :ref:`hidden暗号化<tag-hidden_encryption>`

<details>
<summary>keywords</summary>

HTTPセッション依存, session_store, thread_context_handler, http_rewrite_handler, hidden暗号化, tag-double_submission

</details>

## HTTPセッション非依存機能の導入方法

各機能について以下の通り設定することでHTTPセッションへの依存をなくすことができる。

**セッションストア**

:ref:`db_managed_expiration` を使用する。

**2重サブミット防止**

:ref:`db_double_submit` を使用する。

**スレッドコンテキスト変数管理ハンドラ**

[スレッドコンテキストの初期化](../handlers/handlers-thread_context_handler.md) で以下のHTTPセッション依存クラスを使用しない:

- `LanguageAttributeInHttpSession`
- `TimeZoneAttributeInHttpSession`
- `UserIdAttribute`

代わりにHTTPセッションを使用しない以下のクラスで代替する:

- `LanguageAttributeInHttpCookie`
- `TimeZoneAttributeInHttpCookie`
- `UserIdAttributeInSessionStore`

**HTTPリライトハンドラ**

[http_rewrite_handler](../handlers/handlers-http_rewrite_handler.md) を使用しない。使用する場合はセッションスコープにアクセスしないよう設定する。

**hidden暗号化**

:ref:`hidden暗号化<tag-hidden_encryption>` はHTTPセッションに依存しているため、:ref:`useHiddenEncryption <tag-use_hidden_encryption>` に `false` を設定して使用しない。

<details>
<summary>keywords</summary>

HTTPセッション非依存, LanguageAttributeInHttpCookie, TimeZoneAttributeInHttpCookie, UserIdAttributeInSessionStore, LanguageAttributeInHttpSession, TimeZoneAttributeInHttpSession, UserIdAttribute, db_managed_expiration, db_double_submit, useHiddenEncryption

</details>

## ローカルファイルシステムの使用

アップロードしたファイルなどをAPサーバのローカルに保存するとステートを持つことになる。共有ストレージを用意するなどして、APサーバがローカルにファイルを持たないようにする必要がある。

<details>
<summary>keywords</summary>

ローカルファイルシステム, アップロードファイル, 共有ストレージ, ステートレス

</details>

## HTTPセッションの誤生成を検知する

`WebFrontController` の `preventSessionCreation` プロパティを `true` に設定すると、HTTPセッションを生成しようとしたときに例外が送出される（デフォルト: `false`）。

```xml
<component name="webFrontController"
           class="nablarch.fw.web.servlet.WebFrontController">
  <property name="preventSessionCreation" value="true" />
</component>
```

<details>
<summary>keywords</summary>

preventSessionCreation, WebFrontController, HTTPセッション誤生成検知, セッション生成検知, nablarch.fw.web.servlet.WebFrontController

</details>
