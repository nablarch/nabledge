# Webフロントコントローラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/web_front_controller.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/servlet/WebFrontController.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/HandlerQueueManager.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/servlet/RepositoryBasedWebFrontController.html)

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, com.nablarch.framework, モジュール依存関係, WebFrontController モジュール

</details>

## ハンドラキューを設定する

WebFrontControllerはウェブアプリケーションにおけるハンドラキューの実行の起点となるクラス。本クラスを使用することで、クライアントから受け取ったリクエストに対する処理をハンドラキューに委譲できる。

## コンポーネント設定ファイルへの設定

`WebFrontController` をコンポーネント設定ファイルに設定し、`handlerQueue` プロパティにハンドラを順番に追加する。

> **重要**: コンポーネント名は **webFrontController** とすること。

```xml
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler"/>
      <component class="nablarch.fw.handler.GlobalErrorHandler"/>
      <!-- 省略 -->
    </list>
  </property>
</component>
```

## サーブレットフィルタの設定

`RepositoryBasedWebFrontController` をサーブレットフィルタとして `web.xml` に設定する。これにより、リクエスト処理がシステムリポジトリに登録したハンドラキューへ委譲される。

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

WebFrontController, RepositoryBasedWebFrontController, nablarch.fw.web.servlet.WebFrontController, nablarch.fw.web.servlet.RepositoryBasedWebFrontController, NablarchServletContextListener, handlerQueue, ハンドラキュー設定, サーブレットフィルタ設定, webFrontController, HttpCharacterEncodingHandler, GlobalErrorHandler, ハンドラキューの実行の起点, リクエスト処理委譲

</details>

## 委譲するWebフロントコントローラの名前を変更する

ウェブアプリケーションとウェブサービスを併用する場合など、ハンドラ構成の異なるWebFrontControllerを複数定義できる。`RepositoryBasedWebFrontController` はデフォルトで `webFrontController` という名前でシステムリポジトリからWebFrontControllerを取得する。`web.xml` の初期化パラメータ `controllerName` に取得名を設定することで変更可能。

コンポーネント定義例（ウェブアプリケーション用とRESTfulウェブサービス用）:

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

`web.xml` 設定例:

> **重要**: `<init-param>` で `controllerName` パラメータにシステムリポジトリから取得するコントローラ名を設定すること。`<filter-mapping>` でそれぞれのWebFrontControllerが処理対象とするURLパターンを設定すること。

```xml
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

WebFrontController, RepositoryBasedWebFrontController, nablarch.fw.web.servlet.RepositoryBasedWebFrontController, controllerName, 複数ハンドラ構成, ウェブアプリケーションとウェブサービス併用, jaxrsController, init-param

</details>
