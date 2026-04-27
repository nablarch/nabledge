# Webフロントコントローラ

**目次**

* モジュール一覧
* ハンドラキューを設定する
* 委譲するWebフロントコントローラの名前を変更する

ウェブアプリケーションにおけるハンドラキューの実行の起点となるクラス。

本クラスを使用することで、クライアントから受け取ったリクエストに対する処理をハンドラキューに委譲できる。

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## ハンドラキューを設定する

リクエストに対する処理をハンドラキューに委譲するための手順を示す。

コンポーネント設定ファイルに設定する
WebFrontController をコンポーネント設定ファイルに設定し、
handlerQueue プロパティに
アプリケーションで使用するハンドラを順番に追加していく。

コンポーネント設定ファイルの設定例を以下に示す。

ポイント
* コンポーネント名は **webFrontController** とすること。

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
サーブレットフィルタを設定する
RepositoryBasedWebFrontController
をサーブレットフィルタとして web.xml に設定する。
このフィルタによって、クライアントから受け取ったリクエストに対する処理は、先ほどシステムリポジトリに登録したハンドラキューへ委譲される。

web.xml への設定例を以下に示す。

ポイント
* システムリポジトリを初期化するため、 [Nablarchサーブレットコンテキスト初期化リスナー](../../processing-pattern/web-application/web-application-nablarch-servlet-context-listener.md#nablarch-servlet-context-listener) をリスナーとして設定すること。

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

## 委譲するWebフロントコントローラの名前を変更する

ウェブアプリケーションをベースとしたアプリケーションにおいて一部のリクエストをRESTfulウェブサービスとして処理したい場合など、
ウェブアプリケーションとウェブサービスを併用したい場合が考えられる。
そのような場合は、ハンドラ構成の異なるWebフロントコントローラを複数個定義する必要がある。
RepositoryBasedWebFrontController はデフォルトでは
`webFrontController` という名前でシステムリポジトリが委譲するWebフロントコントローラを取得する。
web.xml に初期化パラメータを設定することで、システムリポジトリから取得するWebフロントコントローラの名前を変更することができる。

ウェブアプリケーション用とRESTfulウェブサービス用2つのハンドラ構成を持つWebフロントコントローラの設定例を以下に示す。

まず、コンポーネント定義で、ウェブアプリケーション用のハンドラ構成をもったWebフロントコントローラを `webFrontController` という名前で定義し、
RESTfulウェブサービス用のハンドラ構成をもったWebフロントコントローラを `webFrontController` と異なるコンポーネント名で定義する。

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

次に web.xml に上記で設定したWebフロントコントローラを使用するためのサーブレットフィルタを設定する。

ポイント
* `<init-param>` を使い `controllerName` というパラメータにシステムリポジトリから取得する際のコントローラ名を設定する。
* `<filter-mapping>` でそれぞれのWebフロントコントローラが処理対象とするURLのパターンを設定する。

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
