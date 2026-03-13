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

> **補足**: テスト済みバージョンはhttp-request-router 0.1.1。バージョンを変更する場合はプロジェクト側でテストを実施すること。

<details>
<summary>keywords</summary>

nablarch-router-adaptor, RoutesMapping, http-request-router, モジュール依存関係, ルーティングアダプタ

</details>

## ルーティングアダプタを使用するための設定を行う

## ディスパッチハンドラを設定する

ディスパッチハンドラとして`RoutesMapping`をハンドラキューの最後に設定する。

- コンポーネント名は **packageMapping** とする
- `basePackage`属性にアクションクラスのパッケージを設定（複数パッケージの場合は共通の親パッケージ）
- `RoutesMapping`を初期化対象リストに追加する

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

## ルート定義ファイルを作成する

クラスパス直下に`routes.xml`を作成してURLと業務アクションのマッピングを設定する。

ルート定義ファイルの読み込みタイミング:
1. `RoutesMapping`の初期化時
2. 再読み込み設定が有効で、以下すべての条件を満たす時:
   - 最後の読み込みから指定秒数が経過している
   - URLと業務アクションのマッピング処理が行われている
   - ルート定義ファイルが変更されている

再読み込みを有効にするには`RoutesMapping#setCheckInterval(long)`に0以上の値を指定する（単位: 秒）。パフォーマンス重視の場合は-1を指定して変更確認を無効化することを推奨。

<details>
<summary>keywords</summary>

RoutesMapping, nablarch.integration.router.RoutesMapping, packageMapping, basePackage, routes.xml, ディスパッチハンドラ設定, ルート定義ファイル, setCheckInterval, 初期化設定, WebFrontController, nablarch.fw.web.servlet.WebFrontController, BasicApplicationInitializer, nablarch.core.repository.initialization.BasicApplicationInitializer

</details>

## 業務アクションとURLを自動的にマッピングする

`match`タグのpath属性に`:controller`や`:action`パラメータを使用することで業務アクションとURLの自動マッピングが可能。

> **重要**: JBossやWildFlyではこの機能は使用できない。`get`タグ等で個別にマッピングを定義すること。

> **重要**: `get`タグ等を使ったマッピング個別定義との併用は非推奨。ルート定義ファイル上からマッピングが読み取りづらくなるため。

有効にするには、クラスパス直下の`net/unit8/http/router/`ディレクトリに`routes.properties`を作成する:

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

NablarchControllerDetector, routes.properties, 自動マッピング, JBoss, WildFly, controllerDetector, URLマッピング自動化

</details>

## JAX-RSのPathアノテーションでマッピングする — ディスパッチハンドラを変更する

バージョン1.2.0から`javax.ws.rs.Path`アノテーション（以下`Path`アノテーション）を使ったルーティングマッピングが可能。

> **重要**: クラスパス配下のリソースを独自ファイルシステムで管理する一部のサーバでは使用不可。例: JBoss/WildFlyのVFS（バーチャルファイルシステム）環境では`Path`アノテーションが付いたクラスの検索ができない。そのような環境ではXMLによるルーティング定義を使用すること。

`Path`アノテーションによるマッピングを使用する場合、ディスパッチハンドラとして`RoutesMapping`の代わりに`PathOptionsProviderRoutesMapping`を設定する。

```xml
<!-- Pathアノテーションによるルーティング定義を有効にする場合の設定例 -->
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

<!-- ハンドラキュー構成 -->
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component-ref name="packageMapping"/>
    </list>
  </property>
</component>
```

`JaxRsPathOptionsProvider`に設定するプロパティ:

| プロパティ名 | 説明 |
|---|---|
| applicationPath | マッピングするパスの共通プレフィックス（JAX-RSの`ApplicationPath`アノテーションと同じ値） |
| basePackage | `Path`アノテーションが設定されたクラスを検索するルートパッケージ名 |

`PathOptionsProviderRoutesMapping`のコンポーネントは初期化対象リストへの追加が必要。

```xml
<component name="initializer"
           class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="packageMapping" />
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

PathOptionsProviderRoutesMapping, nablarch.integration.router.PathOptionsProviderRoutesMapping, JaxRsPathOptionsProvider, nablarch.integration.router.jaxrs.JaxRsPathOptionsProvider, applicationPath, basePackage, pathOptionsProvider, methodBinderFactory, JaxRsMethodBinderFactory, nablarch.fw.jaxrs.JaxRsMethodBinderFactory, JerseyJaxRsHandlerListFactory, nablarch.integration.jaxrs.jersey.JerseyJaxRsHandlerListFactory, JAX-RS, Pathアノテーション, ルーティング

</details>

## JAX-RSのPathアノテーションでマッピングする — マッピングの実装方法

アクションクラスに`@Path`アノテーションを付け、`value`で設定したパスとクラスを紐づける。HTTPメソッドアノテーション（`@GET`等）でメソッドを紐づける。

```java
@Path("/sample")
public class SampleAction {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Person> findAll() { ... }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public int register(JaxRsHttpRequest request) { ... }
}
```

| パス | HTTPメソッド | ディスパッチされるメソッド |
|---|---|---|
| `/sample` | `GET` | `SampleAction#findAll()` |
| `/sample` | `POST` | `SampleAction#register(JaxRsHttpRequest)` |

> **補足**: HTTPメソッドアノテーション: `javax.ws.rs.DELETE`, `javax.ws.rs.GET`, `javax.ws.rs.HEAD`, `javax.ws.rs.OPTIONS`（JAX-RS 1.1以上）, `javax.ws.rs.PATCH`（JAX-RS 2.1以上）, `javax.ws.rs.POST`, `javax.ws.rs.PUT`

メソッドにも`@Path`を付けることでサブパスのマッピングを定義できる。

```java
@Path("/sample")
public class TestAction {

    @GET
    @Path("/foo")
    @Produces(MediaType.APPLICATION_JSON)
    public Person foo() { ... }

    @GET
    @Path("/bar")
    @Produces(MediaType.APPLICATION_JSON)
    public Person bar() { ... }
}
```

| パス | HTTPメソッド | ディスパッチされるメソッド |
|---|---|---|
| `/sample/foo` | `GET` | `TestAction#foo()` |
| `/sample/bar` | `GET` | `TestAction#bar()` |

<details>
<summary>keywords</summary>

@Path, @GET, @POST, SampleAction, TestAction, サブパスマッピング, HTTPメソッドアノテーション, javax.ws.rs.GET, javax.ws.rs.POST, javax.ws.rs.DELETE, javax.ws.rs.PATCH, javax.ws.rs.HEAD, javax.ws.rs.OPTIONS, javax.ws.rs.PUT

</details>

## JAX-RSのPathアノテーションでマッピングする — パスパラメータの定義

パスの一部を`{パラメータ名}`と記述することでパスパラメータを定義できる。`JaxRsHttpRequest#getPathParam(String)`にパラメータ名を渡して値を取得する。`{パラメータ名 : 正規表現}`と記述することで書式を正規表現で制限可能。パスパラメータの記法はJAX-RSの仕様に従う。

```java
@Path("/sample")
public class TestAction {

    @GET
    @Path("/foo/{param}")
    @Produces(MediaType.APPLICATION_JSON)
    public Person foo(JaxRsHttpRequest request) {
        String param = request.getPathParam("param");
        // 省略
    }

    @GET
    @Path("/bar/{id : \\d+}")
    @Produces(MediaType.APPLICATION_JSON)
    public Person bar(JaxRsHttpRequest request) {
        int id = Integer.parseInt(request.getPathParam("id");
        // 省略
    }
}
```

| パス | HTTPメソッド | ディスパッチされるメソッド |
|---|---|---|
| `/sample/foo/hello` | `GET` | `TestAction#foo(JaxRsHttpRequest)` |
| `/sample/foo/world` | `GET` | `TestAction#foo(JaxRsHttpRequest)` |
| `/sample/bar/123` | `GET` | `TestAction#bar(JaxRsHttpRequest)` |
| `/sample/bar/987` | `GET` | `TestAction#bar(JaxRsHttpRequest)` |

<details>
<summary>keywords</summary>

パスパラメータ, {パラメータ名}, getPathParam, JaxRsHttpRequest, nablarch.fw.jaxrs.JaxRsHttpRequest, 正規表現, \d+

</details>

## JAX-RSのPathアノテーションでマッピングする — ルーティング定義を一覧で確認する

`PathOptionsProviderRoutesMapping`が読み込んだルーティング定義は初期化時にデバッグレベルでログに出力される。

デフォルトのログ出力例:

```
2020-07-20 13:35:53.092 -DEBUG- nablarch.integration.router.PathOptionsProviderRoutesMapping [null] boot_proc = [] proc_sys = [jaxrs] req_id = [null] usr_id = [null] GET /api/bar => com.example.BarAction#findAll
GET /api/bar/fizz => com.example.BarAction#fizz
GET /api/foo => com.example.FooAction#findAll
POST /api/foo => com.example.FooAction#register
DELETE /api/foo/(:id) => com.example.FooAction#delete
GET /api/foo/(:id) => com.example.FooAction#find
POST /api/foo/(:id) => com.example.FooAction#update
```

ログのフォーマットを変更する場合は`PathOptionsFormatter`を実装したクラスを作り、`pathOptionsFormatter`プロパティに設定する。

```xml
<component name="packageMapping" class="nablarch.integration.router.PathOptionsProviderRoutesMapping">
  <property name="pathOptionsFormatter">
    <component class="com.example.CustomPathOptionsFormatter" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

PathOptionsFormatter, nablarch.integration.router.PathOptionsFormatter, pathOptionsFormatter, ルーティング定義一覧, デバッグログ, ログ出力

</details>
