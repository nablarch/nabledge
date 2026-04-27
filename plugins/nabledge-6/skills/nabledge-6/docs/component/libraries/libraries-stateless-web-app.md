# Webアプリケーションをステートレスにする

**目次**

* 基本的な考え方
* HTTPセッションに依存している機能
* HTTPセッション非依存機能の導入方法

  * セッションストア
  * 2重サブミット防止
  * スレッドコンテキスト変数管理ハンドラ
  * HTTPリライトハンドラ
  * hidden暗号化
* ローカルファイルシステムの使用
* HTTPセッションの誤生成を検知する

## 基本的な考え方

サーブレットAPIが提供するHTTPセッションはAPサーバで状態を持ってしまうため、そのままではスケールアウトができない。
通常、APサーバのスケールアウトを行うには以下のような対処が必要となる。

1. ロードバランサーでスティッキーセッションを有効にする
2. APサーバのセッションレプリケーション機能を使用する
3. APサーバのHTTPセッション保存先をNoSQLにする

1, 2は [Twelve-Factor App](https://12factor.net/ja/) で言うところの廃棄容易性の点で劣り、2, 3はAPサーバ依存となる。

Nablarchが使用する機能では、HTTPセッションに依存しているものがあるが、
これらの機能をHTTPセッション非依存のものに切り替えることで、
APサーバをステートレスにできる。

## HTTPセッションに依存している機能

以下の機能は、デフォルトではHTTPセッションに依存している。

* [セッションストア](../../component/libraries/libraries-session-store.md#session-store)
* [2重サブミット防止](../../component/libraries/libraries-tag.md#tag-double-submission)
* [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler)
* [HTTPリライトハンドラ](../../component/handlers/handlers-http-rewrite-handler.md#http-rewrite-handler)
* [hidden暗号化](../../component/libraries/libraries-tag.md#tag-hidden-encryption)

## HTTPセッション非依存機能の導入方法

[HTTPセッションに依存している機能](../../component/libraries/libraries-stateless-web-app.md#http-session-dependence) の各機能について以下の通り設定することでHTTPセッションへの依存をなくすことができる。

### セッションストア

* [有効期間をデータベースに保存する](../../component/handlers/handlers-SessionStoreHandler.md#db-managed-expiration)

### 2重サブミット防止

* [データベースを使用した二重サブミット防止](../../component/libraries/libraries-db-double-submit.md#db-double-submit)

### スレッドコンテキスト変数管理ハンドラ

[スレッドコンテキストの初期化](../../component/handlers/handlers-thread-context-handler.md#thread-context-handler-initialization) に以下の部品を使用しない。

* LanguageAttributeInHttpSession
* TimeZoneAttributeInHttpSession
* UserIdAttribute

それぞれ、HTTPセッションを使用しない実装として以下の部品で代替できる。

* LanguageAttributeInHttpCookie
* TimeZoneAttributeInHttpCookie
* UserIdAttributeInSessionStore

### HTTPリライトハンドラ

[HTTPリライトハンドラ](../../component/handlers/handlers-http-rewrite-handler.md#http-rewrite-handler) を使用しない。
使用する場合にはセッションスコープにアクセスしないよう設定する。

### hidden暗号化

Nablarchでは [hidden暗号化](../../component/libraries/libraries-tag.md#tag-hidden-encryption) の機能を提供している。
この機能はHTTPセッションに依存しているため、使用しないよう [useHiddenEncryption](../../component/libraries/libraries-tag.md#tag-use-hidden-encryption) に `false` を設定する。

## ローカルファイルシステムの使用

アップロードしたファイルなどをAPサーバのローカルに保存してしまうと、ステートを持つことになってしまう。
このような場合は、共有のストレージを用意するなどして、APサーバがローカルにファイルを持たないようにする必要がある。

## HTTPセッションの誤生成を検知する

設定漏れや実装ミスによって誤ってHTTPセッションを生成してしまうことを防ぐために、HTTPセッションの生成を検知する機能を提供している。
この機能を有効にすると、HTTPセッションを生成しようとしたときに例外が送出されるようになる。

この機能は、 WebFrontController の `preventSessionCreation` プロパティに `true` を設定することで有効にできる（デフォルトは `false` で無効になっている）。

具体的には、 WebFrontController のコンポーネントを定義した設定ファイルで、次のように記述することで検知機能を有効にできる。

```xml
<!-- ハンドラキュー構成 -->
<component name="webFrontController"
           class="nablarch.fw.web.servlet.WebFrontController">

  <!-- HTTPセッションの誤生成を検知する -->
  <property name="preventSessionCreation" value="true" />
```
