# Nablarchサーブレットコンテキスト初期化リスナー

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/nablarch_servlet_context_listener.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/servlet/NablarchServletContextListener.html)

## モジュール一覧

**クラス**: `nablarch.fw.web.servlet.NablarchServletContextListener`

サーブレットコンテキストリスナーとして定義されており、ウェブアプリケーションの起動時・終了時に以下の処理を行う:
- 起動時: [repository](../../component/libraries/libraries-repository.md) の初期化処理、[log](../../component/libraries/libraries-log.md) の初期化処理
- 終了時: [log](../../component/libraries/libraries-log.md) の終了処理

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

<details>
<summary>keywords</summary>

NablarchServletContextListener, サーブレットコンテキストリスナー, 起動時初期化処理, 終了時終了処理, nablarch-fw-web, nablarch-core, nablarch-core-repository, nablarch-core-applog

</details>

## システムリポジトリを初期化する

システムリポジトリを初期化するには以下の設定が必要:
1. サーブレットコンテキストリスナーとして `NablarchServletContextListener` を登録する
2. サーブレットコンテキストの初期化パラメータとしてコンポーネント設定ファイルのパスを設定する

> **重要**: コンポーネント設定ファイルのパスのパラメータ名は **di.config** とすること。

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

<details>
<summary>keywords</summary>

NablarchServletContextListener, di.config, システムリポジトリ初期化, web.xml設定, コンポーネント設定ファイル

</details>

## 初期化の成否を後続処理で取得する

初期化成否は `NablarchServletContextListener#isInitializationCompleted` で取得可能。初期化成功時は `true` を返却。

初期化失敗時はアプリ起動も失敗するが、複数のサーブレットコンテキストリスナーを登録していた場合、本クラスの後続リスナーが実行されることがある。後続リスナーで以下のように初期化成功時のみ処理を続行する分岐が可能:

```java
public class CustomServletContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        if(NablarchServletContextListener.isInitializationCompleted()){
          // システムリポジトリを使用した処理
        }
    }
```

**実行順序の注意**:
- サーブレットコンテキストリスナーの実行順は `web.xml` に記載した順序となる
- システムリポジトリを使用するリスナーは本クラスより後に `web.xml` に記載すること
- `@WebListener` アノテーションによる登録では実行順序が保証されないため、必ず `web.xml` で定義すること

```xml
<listener>
  <listener-class>nablarch.fw.web.servlet.NablarchServletContextListener</listener-class>
</listener>
<listener>
  <listener-class>please.change.me.CustomServletContextListener</listener-class>
</listener>
```

> **補足**: 複数のサーブレットコンテキストリスナーが登録されている場合、先に実行されたリスナーの例外を検知して処理を中止するか継続するかはサーブレットコンテナの実装に依存する。

<details>
<summary>keywords</summary>

NablarchServletContextListener, isInitializationCompleted, 初期化成否確認, サーブレットコンテキストリスナー実行順序, WebListenerアノテーション

</details>
