# Nablarchサーブレットコンテキスト初期化リスナー

## モジュール一覧

サーブレットコンテキストリスナーとして定義されており、ウェブアプリケーションの起動時・終了時に以下の処理を行う。

- 起動時: :ref:`repository` の初期化処理、:ref:`log` の初期化処理
- 終了時: :ref:`log` の終了処理

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-repository</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-applog</artifactId>
</dependency>
```

## システムリポジトリを初期化する

システムリポジトリの初期化に必要な設定:

1. サーブレットコンテキストリスナーとして `nablarch.fw.web.servlet.NablarchServletContextListener` を登録する
2. サーブレットコンテキストの初期化パラメータとして、コンポーネント設定ファイルのパスを設定する

> **重要**: コンポーネント設定ファイルパスのパラメータ名は **di.config** とすること。

`web.xml` 設定例:
```xml
<context-param>
  <param-name>di.config</param-name>
  <param-value>web-boot.xml</param-value>
</context-param>

<listener>
  <listener-class>nablarch.fw.web.servlet.NablarchServletContextListener</listener-class>
</listener>
```

## 初期化の成否を後続処理で取得する

`NablarchServletContextListener#isInitializationCompleted` で初期化成否を取得できる。成功時は `true` を返す。

本クラスの初期化失敗時はアプリケーション起動も失敗するが、複数のサーブレットコンテキストリスナーが登録されている場合、後続リスナーが実行されることがある。`isInitializationCompleted()` を使用して後続リスナーで分岐できる。

```java
public class CustomServletContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        if(NablarchServletContextListener.isInitializationCompleted()){
          // システムリポジトリを使用した処理
        }
    }
```

> **重要**: `@WebListener` アノテーションによる登録では実行順序が保証されない。必ず `web.xml` で定義すること。本クラスを使用するサーブレットコンテキストリスナーは本クラスより後に `web.xml` に記載すること。

`web.xml` 設定例（実行順序制御）:
```xml
<listener>
  <listener-class>nablarch.fw.web.servlet.NablarchServletContextListener</listener-class>
</listener>
<listener>
  <listener-class>please.change.me.CustomServletContextListener</listener-class>
</listener>
```

> **補足**: 複数のサーブレットコンテキストリスナーが登録されている場合、先に実行されたリスナーの例外を検知して処理を中止するか無視して後続を継続するかはサーブレットコンテナの実装に依存する。
