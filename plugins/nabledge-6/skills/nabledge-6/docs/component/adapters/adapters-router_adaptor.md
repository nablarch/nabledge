# ルーティングアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/router_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/router/RoutesMapping.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/router/PathOptionsProviderRoutesMapping.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/router/jaxrs/JaxRsPathOptionsProvider.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsHttpRequest.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/router/PathOptionsFormatter.html)

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-router-adaptor</artifactId>
</dependency>
```

> **補足**: http-request-routerのバージョン0.1.1でテスト済み。バージョン変更時はプロジェクト側でテストを実施すること。

<details>
<summary>keywords</summary>

nablarch-router-adaptor, com.nablarch.integration, ルーティングアダプタ, モジュール依存関係, http-request-router

</details>

## ルーティングアダプタを使用するための設定を行う

### ディスパッチハンドラを設定する

`RoutesMapping` をハンドラキューの最後に設定する。

設定ポイント:
- コンポーネント名は **packageMapping** とする
- `basePackage` 属性にアクションクラスのパッケージを設定（複数パッケージの場合は共通親パッケージを設定）
- `RoutesMapping` を初期化対象リストに設定する

```xml
<component name="packageMapping" class="nablarch.integration.router.RoutesMapping">
  <property name="basePackage" value="sample.web.action" />
</component>

<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component-ref name="packageMapping" />
    </list>
  </property>
</component>

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="packageMapping"/>
    </list>
  </property>
</component>
```

### ルート定義ファイルを作成する

クラスパス直下に `routes.xml` を作成し、URLと業務アクションのマッピングを設定する。設定方法は[ライブラリのREADMEドキュメント(外部サイト)](https://github.com/kawasima/http-request-router/blob/master/README.ja.md)を参照。

<details>
<summary>keywords</summary>

RoutesMapping, nablarch.integration.router.RoutesMapping, packageMapping, basePackage, ディスパッチハンドラ設定, ルート定義ファイル, routes.xml, ハンドラキュー設定, アクションクラスマッピング, WebFrontController, nablarch.fw.web.servlet.WebFrontController, BasicApplicationInitializer, nablarch.core.repository.initialization.BasicApplicationInitializer, handlerQueue, initializeList

</details>

## 業務アクションとURLを自動的にマッピングする

`match` タグの `path` 属性に `:controller` や `:action` パラメータを使用することで、業務アクションとURLの自動マッピングが可能。

> **重要**: JBossまたはWildFlyを使用している場合、この機能は使用できない。`get` タグ等で個別にマッピングを定義すること。

> **重要**: `get` タグ等による個別定義とこの機能の併用は推奨しない。ルート定義ファイルからマッピングが読み取りづらくなるため。

有効化: クラスパス直下の `net/unit8/http/router` ディレクトリに `routes.properties` を作成し、以下を設定する。

```bash
router.controllerDetector=nablarch.integration.router.NablarchControllerDetector
```

ルート定義ファイル例:
```xml
<routes>
  <match path="/action/:controller/:action" />
</routes>
```

マッピング例:

| 業務アクション | URL |
|---|---|
| PersonAction#index | /action/person/index |
| PersonAction#search | /action/person/search |
| LoginAction#index | /action/login/index |
| ProjectUploadAction#index | /action/projectUpload/index |

<details>
<summary>keywords</summary>

NablarchControllerDetector, nablarch.integration.router.NablarchControllerDetector, routes.properties, 自動マッピング, JBoss, WildFly, :controller, :action, router.controllerDetector

</details>

## Jakarta RESTful Web ServicesのPathアノテーションでマッピングする

本アダプタのバージョン1.2.0から、Jakarta RESTful Web Servicesの`jakarta.ws.rs.Path`アノテーション（以下`Path`アノテーションと表記）を使ったルーティングのマッピングができるようになった。

> **重要**: JBossやWildflyなど、クラスパス配下のリソースをvfs（バーチャルファイルシステム）で管理するウェブアプリケーションサーバでは、`Path`アノテーションが付与されたクラスの検索ができないため本機能は使用不可。その場合はXMLを用いたルーティング定義を使用すること。

## ディスパッチハンドラの変更

XMLマッピング定義では `RoutesMapping` を使用するが、`Path`アノテーションによるマッピング定義を用いる場合は `PathOptionsProviderRoutesMapping` をディスパッチハンドラとして設定する必要がある。

```xml
<component name="packageMapping" class="nablarch.integration.router.PathOptionsProviderRoutesMapping">
  <property name="pathOptionsProvider">
    <component class="nablarch.integration.router.jaxrs.JaxRsPathOptionsProvider">
      <property name="applicationPath" value="${nablarch.webApi.applicationPath}" />
      <property name="basePackage" value="${nablarch.commonProperty.basePackage}" />
    </component>
  </property>
  <property name="methodBinderFactory">
    <component class="nablarch.fw.jaxrs.JaxRsMethodBinderFactory">
      <property name="handlerList">
        <component class="nablarch.integration.jaxrs.jersey.JerseyJaxRsHandlerListFactory"/>
      </property>
    </component>
  </property>
</component>
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component-ref name="packageMapping"/>
    </list>
  </property>
</component>
```

`JaxRsPathOptionsProvider` の必須プロパティ:

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| applicationPath | ○ | パスに共通するプレフィックス（`jakarta.ws.rs.ApplicationPath`アノテーションの値と同一） |
| basePackage | ○ | `Path`アノテーションが設定されたクラスを検索するルートパッケージ名 |

`PathOptionsProviderRoutesMapping` のコンポーネントは初期化対象のリストへの追加が必要:

```xml
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="packageMapping" />
    </list>
  </property>
</component>
```

## マッピングの実装方法

アクションクラスを`Path`アノテーションで注釈してパスと紐づけ、さらにHTTPメソッドアノテーション（`@GET`等）でメソッドと紐づける。

```java
@Path("/sample")
public class SampleAction {
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Person> findAll() { }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public int register(JaxRsHttpRequest request) { }
}
```

| パス | HTTPメソッド | ディスパッチされるメソッド |
|---|---|---|
| `/sample` | `GET` | `SampleAction#findAll()` |
| `/sample` | `POST` | `SampleAction#register(JaxRsHttpRequest)` |

> **補足**: 標準のHTTPメソッドアノテーション: `jakarta.ws.rs.DELETE`, `jakarta.ws.rs.GET`, `jakarta.ws.rs.HEAD`, `jakarta.ws.rs.OPTIONS`, `jakarta.ws.rs.PATCH`, `jakarta.ws.rs.POST`, `jakarta.ws.rs.PUT`

メソッドレベルに`Path`アノテーションを付けることでサブパスを定義可能:

```java
@Path("/sample")
public class TestAction {
    @GET
    @Path("/foo")
    @Produces(MediaType.APPLICATION_JSON)
    public Person foo() { }

    @GET
    @Path("/bar")
    @Produces(MediaType.APPLICATION_JSON)
    public Person bar() { }
}
```

| パス | HTTPメソッド | ディスパッチされるメソッド |
|---|---|---|
| `/sample/foo` | `GET` | `TestAction#foo()` |
| `/sample/bar` | `GET` | `TestAction#bar()` |

## パスパラメータの定義

パスパラメータはhttp-request-routerの記法ではなく、Jakarta RESTful Web Servicesの仕様に従った形式で記述する。

- `{パラメータ名}`: パスの一部をパラメータとして定義
- `{パラメータ名 : 正規表現}`: 正規表現でパラメータの書式を制約（例: `\\d+`で数値のみ）

`JaxRsHttpRequest#getPathParam(String)` でパスパラメータ値を取得する。

```java
@Path("/sample")
public class TestAction {
    @GET
    @Path("/foo/{param}")
    public Person foo(JaxRsHttpRequest request) {
        String param = request.getPathParam("param");
    }

    @GET
    @Path("/bar/{id : \\d+}")
    public Person bar(JaxRsHttpRequest request) {
        int id = Integer.parseInt(request.getPathParam("id"));
    }
}
```

| パス | HTTPメソッド | ディスパッチされるメソッド |
|---|---|---|
| `/sample/foo/hello` | `GET` | `TestAction#foo(JaxRsHttpRequest)` |
| `/sample/foo/world` | `GET` | `TestAction#foo(JaxRsHttpRequest)` |
| `/sample/bar/123` | `GET` | `TestAction#bar(JaxRsHttpRequest)` |
| `/sample/bar/987` | `GET` | `TestAction#bar(JaxRsHttpRequest)` |

## インターフェースや親クラスのアノテーション引き継ぎ

アクションクラスは、実装しているインターフェースや継承している親クラスの`Path`アノテーションおよびHTTPメソッドアノテーションを引き継ぐことができる。

**例1: インターフェースにアノテーションを定義し、実装クラスで引き継ぐ**

```java
@Path("/sample")
public interface TestApi {
    @GET
    @Path("/foo/{param}")
    @Produces(MediaType.APPLICATION_JSON)
    Person foo(JaxRsHttpRequest request);

    @GET
    @Path("/bar/{id : \\d+}")
    @Produces(MediaType.APPLICATION_JSON)
    Person bar(JaxRsHttpRequest request);
}

public class TestAction implements TestApi {
    @Override
    public Person foo(JaxRsHttpRequest request) { }

    @Override
    public Person bar(JaxRsHttpRequest request) { }
}
```

`TestApi`インターフェースにパスパラメータやHTTPメソッドを定義し、メソッドの実装は`TestAction`クラスで行っている。`TestAction`クラスのメソッドには`Path`アノテーションやHTTPメソッドに関するアノテーションは注釈されていないが、実行時には`TestApi`インターフェースのメソッドに注釈されたアノテーションが定義として使用される。

> **補足**: 型定義に`Path`アノテーションが注釈されているクラス/インターフェースが重要。継承・実装の階層をたどり、最初に見つかった`Path`アノテーションが型定義に注釈されているクラス/インターフェースに宣言されているメソッドのみがリクエストを受け付けるメソッドとして認識される。

**例2: アクションクラスが独自メソッドを追加する場合の注意**

```java
@Path("/sample")  // Pathアノテーションが型定義に注釈されている
public interface TestApi {
    // TestApiインターフェースにはPathアノテーションが型定義に注釈されているため、fooメソッドはリクエストを受け付けるメソッドとして認識される
    @GET
    @Path("/foo/{param}")
    @Produces(MediaType.APPLICATION_JSON)
    Person foo(JaxRsHttpRequest request);
}

public class TestAction implements TestApi {
    @Override
    public Person foo(JaxRsHttpRequest request) { }

    // TestActionクラスにはPathアノテーションが注釈されていないため、barメソッドはリクエストを受け付けるメソッドとしては認識されない
    @GET
    @Path("/bar/{id : \\d+}")
    @Produces(MediaType.APPLICATION_JSON)
    public Person bar(JaxRsHttpRequest request) { }
}
```

この例では`TestApi`インターフェースに`Path`アノテーションが注釈されているため、`foo`メソッドがリクエストを受け付けるメソッドとして認識され、`TestAction`クラスに宣言されている`bar`メソッドには`@GET`アノテーションなどが注釈されているがこれはリクエストを受け付けるメソッドとしては無視される。

| クラス/インターフェース | 宣言されているメソッド | リクエストを受け付けられるか？ |
|---|---|---|
| `TestApi` | `foo` | ○ |
| `TestAction` | `bar` | × |

どの型定義に`Path`アノテーションが注釈されているか、そしてそのクラスにアノテーションで注釈されたメソッドが定義されているかによって、リクエストを受け付けるメソッドが決まることに注意すること。

## ルーティング定義の確認

`PathOptionsProviderRoutesMapping` が読み込んだルーティング定義は、初期化時にデバッグレベルでログに出力される。

デフォルトでは次のようなフォーマットでルーティングの一覧が出力される:

```text
2020-07-20 13:35:53.092 -DEBUG- nablarch.integration.router.PathOptionsProviderRoutesMapping [null] boot_proc = [] proc_sys = [jaxrs] req_id = [null] usr_id = [null] GET /api/bar => com.example.BarAction#findAll
GET /api/bar/fizz => com.example.BarAction#fizz
GET /api/foo => com.example.FooAction#findAll
POST /api/foo => com.example.FooAction#register
DELETE /api/foo/(:id) => com.example.FooAction#delete
GET /api/foo/(:id) => com.example.FooAction#find
POST /api/foo/(:id) => com.example.FooAction#update
```

ログフォーマットを変更する場合は、`PathOptionsFormatter` を実装したクラスを作成し、`PathOptionsProviderRoutesMapping`の`pathOptionsFormatter`プロパティに設定する:

```xml
<component name="packageMapping" class="nablarch.integration.router.PathOptionsProviderRoutesMapping">
  <property name="pathOptionsFormatter">
    <component class="com.example.CustomPathOptionsFormatter" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

PathOptionsProviderRoutesMapping, JaxRsPathOptionsProvider, JaxRsMethodBinderFactory, JerseyJaxRsHandlerListFactory, RoutesMapping, JaxRsHttpRequest, PathOptionsFormatter, BasicApplicationInitializer, WebFrontController, @Path, @GET, @POST, @DELETE, @HEAD, @OPTIONS, @PATCH, @PUT, @Produces, applicationPath, basePackage, pathOptionsProvider, pathOptionsFormatter, methodBinderFactory, handlerQueue, initializeList, Pathアノテーション ルーティング, JAX-RS マッピング, パスパラメータ, ルーティング定義確認, アノテーション引き継ぎ, インターフェース継承

</details>
