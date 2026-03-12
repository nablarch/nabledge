# Webフロントコントローラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/web_front_controller.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/servlet/WebFrontController.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/HandlerQueueManager.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/servlet/RepositoryBasedWebFrontController.html)

## モジュール一覧

ウェブアプリケーションにおけるハンドラキューの実行の起点となるクラス。本クラスを使用することで、クライアントから受け取ったリクエストに対する処理をハンドラキューに委譲できる。

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, com.nablarch.framework, Webフロントコントローラ, モジュール依存関係

</details>

## コンポーネント設定ファイルにハンドラキューを設定する

`WebFrontController` をコンポーネント設定ファイルに設定し、`handlerQueue` プロパティにアプリケーションで使用するハンドラを順番に追加する。

> **重要**: コンポーネント名は **webFrontController** とすること。

```xml
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler"/>
      <component class="nablarch.fw.handler.GlobalErrorHandler"/>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

WebFrontController, nablarch.fw.web.servlet.WebFrontController, handlerQueue, HttpCharacterEncodingHandler, nablarch.fw.web.handler.HttpCharacterEncodingHandler, GlobalErrorHandler, nablarch.fw.handler.GlobalErrorHandler, ハンドラキュー設定, コンポーネント設定ファイル, webFrontController

</details>

## サーブレットフィルタを設定する

`RepositoryBasedWebFrontController` をサーブレットフィルタとして `web.xml` に設定する。このフィルタによって、クライアントから受け取ったリクエストに対する処理は、システムリポジトリに登録したハンドラキューへ委譲される。

> **重要**: システムリポジトリを初期化するため、[nablarch_servlet_context_listener](web-application-nablarch_servlet_context_listener.md) をリスナーとして設定すること。

```xml
<context-param>
  <param-name>di.config</param-name>
  <param-value>web-boot.xml</param-value>
</context-param>
<listener>
  <listener-class>nablarch.fw.web.servlet.NablarchServletContextListener</listener-class>
</listener>
<filter>
  <filter-name>entryPoint</filter-name>
  <filter-class>nablarch.fw.web.servlet.RepositoryBasedWebFrontController</filter-class>
</filter>
<filter-mapping>
  <filter-name>entryPoint</filter-name>
  <url-pattern>/action/*</url-pattern>
</filter-mapping>
```

<details>
<summary>keywords</summary>

RepositoryBasedWebFrontController, nablarch.fw.web.servlet.RepositoryBasedWebFrontController, NablarchServletContextListener, nablarch.fw.web.servlet.NablarchServletContextListener, サーブレットフィルタ設定, web.xml設定, webFrontController

</details>

## 委譲するWebフロントコントローラの名前を変更する

`RepositoryBasedWebFrontController` はデフォルトで `webFrontController` という名前のコンポーネントをシステムリポジトリから取得する。`web.xml` の `<init-param>` に `controllerName` パラメータを設定することで、取得するWebフロントコントローラの名前を変更できる。ウェブアプリケーションとRESTfulウェブサービスを併用する場合など、ハンドラ構成の異なるWebフロントコントローラを複数定義する場合に使用する。

**コンポーネント定義例（複数のWebフロントコントローラ）**:

```xml
<component name="webFrontController"
          class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <!-- ウェブアプリケーション用のハンドラ構成 -->
    </list>
  </property>
</component>

<component name="jaxrsController"
          class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <!-- RESTfulウェブサービス用のハンドラ構成 -->
    </list>
  </property>
</component>
```

**web.xml設定例**:

> **ポイント**: `<init-param>` の `controllerName` パラメータにシステムリポジトリから取得するコントローラ名を設定する。`<filter-mapping>` で各WebフロントコントローラのURLパターンを設定する。

```xml
<context-param>
  <param-name>di.config</param-name>
  <param-value>web-boot.xml</param-value>
</context-param>
<listener>
  <listener-class>nablarch.fw.web.servlet.NablarchServletContextListener</listener-class>
</listener>
<filter>
  <filter-name>webEntryPoint</filter-name>
  <filter-class>nablarch.fw.web.servlet.RepositoryBasedWebFrontController</filter-class>
</filter>
<filter>
  <filter-name>jaxrsEntryPoint</filter-name>
  <filter-class>nablarch.fw.web.servlet.RepositoryBasedWebFrontController</filter-class>
  <init-param>
    <param-name>controllerName</param-name>
    <param-value>jaxrsController</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>webEntryPoint</filter-name>
  <url-pattern>/action/*</url-pattern>
  <url-pattern>/</url-pattern>
</filter-mapping>
<filter-mapping>
  <filter-name>jaxrsEntryPoint</filter-name>
  <url-pattern>/api/*</url-pattern>
</filter-mapping>
```

<details>
<summary>keywords</summary>

RepositoryBasedWebFrontController, nablarch.fw.web.servlet.RepositoryBasedWebFrontController, NablarchServletContextListener, nablarch.fw.web.servlet.NablarchServletContextListener, controllerName, webFrontController, jaxrsController, 複数Webフロントコントローラ, RESTfulウェブサービス併用, コントローラ名変更

</details>
