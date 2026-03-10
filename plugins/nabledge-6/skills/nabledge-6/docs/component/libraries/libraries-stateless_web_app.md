# Webアプリケーションをステートレスにする

## 基本的な考え方

HTTPセッションはAPサーバで状態を持つためスケールアウトができない。通常の対処方法:

1. ロードバランサーでスティッキーセッションを有効にする
2. APサーバのセッションレプリケーション機能を使用する
3. APサーバのHTTPセッション保存先をNoSQLにする

1, 2は[Twelve-Factor App](https://12factor.net/ja/)の廃棄容易性の点で劣り、2, 3はAPサーバ依存となる。

NablarchのHTTPセッション依存機能を非依存のものに切り替えることでAPサーバをステートレスにできる。

## HTTPセッションに依存している機能

以下の機能はデフォルトでHTTPセッションに依存している:

- :ref:`session_store`
- :ref:`2重サブミット防止<tag-double_submission>`
- :ref:`thread_context_handler`
- :ref:`http_rewrite_handler`
- :ref:`hidden暗号化<tag-hidden_encryption>`

## HTTPセッション非依存機能の導入方法

:ref:`http-session-dependence` の各機能をHTTPセッション非依存に切り替える方法。

**セッションストア**: :ref:`db_managed_expiration` を使用する。

**2重サブミット防止**: :ref:`db_double_submit` を使用する。

**スレッドコンテキスト変数管理ハンドラ**: :ref:`スレッドコンテキストの初期化<thread_context_handler-initialization>` で以下の部品を代替に切り替える:

| HTTPセッション依存（使用しない） | 代替（HTTPセッション非依存） |
|---|---|
| `LanguageAttributeInHttpSession` | `LanguageAttributeInHttpCookie` |
| `TimeZoneAttributeInHttpSession` | `TimeZoneAttributeInHttpCookie` |
| `UserIdAttribute` | `UserIdAttributeInSessionStore` |

**HTTPリライトハンドラ**: :ref:`http_rewrite_handler` を使用しない。使用する場合はセッションスコープにアクセスしないよう設定する。

**hidden暗号化**: :ref:`hidden暗号化<tag-hidden_encryption>` はHTTPセッションに依存するため、:ref:`useHiddenEncryption <tag-use_hidden_encryption>` に `false` を設定して無効化する。

## ローカルファイルシステムの使用

アップロードファイル等をAPサーバのローカルに保存するとステートを持つことになる。APサーバがローカルにファイルを持たないよう、共有ストレージを用意する必要がある。

## HTTPセッションの誤生成を検知する

設定漏れや実装ミスによるHTTPセッションの誤生成を検知する機能。有効化するとHTTPセッション生成時に例外が送出される。

`WebFrontController` の `preventSessionCreation` プロパティに `true` を設定することで有効化（デフォルト: `false`）。

```xml
<!-- ハンドラキュー構成 -->
<component name="webFrontController"
           class="nablarch.fw.web.servlet.WebFrontController">

  <!-- HTTPセッションの誤生成を検知する -->
  <property name="preventSessionCreation" value="true" />
```
