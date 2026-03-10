# リソース(アクション)クラスの実装に関して

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsHttpRequest.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/ws/rs/PathParam.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/ws/rs/QueryParam.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/EntityResponse.html)

## リソースクラスのメソッドのシグネチャ

## メソッド引数

| 引数定義 | 説明 |
|---|---|
| 引数無し | パラメータやリクエストボディが不要な場合 |
| フォーム(Java Beans) | リクエストボディから変換したフォームで処理する場合 |
| `JaxRsHttpRequest` | :ref:`rest_feature_details-path_param`、:ref:`rest_feature_details-query_param`、HTTPヘッダを取得する場合 |
| `ExecutionContext` | スコープ変数にアクセスする場合 |
| 組み合わせ | 上記の型を任意に組み合わせ可能 |

> **補足**: HttpRequestも後方互換性維持のため使用できるが、原則 `JaxRsHttpRequest` を使用すること。

組み合わせ例:
```java
public HttpResponse sample(SampleForm form, JaxRsHttpRequest request) {
  // 省略
}
```

## メソッド戻り値

| 戻り値の型 | 説明 |
|---|---|
| void | `204: NoContent` をクライアントに返却 |
| フォーム(Java Beans) | :ref:`body_convert_handler` でレスポンスボディに変換してクライアントに返却 |
| `HttpResponse` | HttpResponseの情報をそのままクライアントに返却 |

<details>
<summary>keywords</summary>

JaxRsHttpRequest, ExecutionContext, HttpResponse, メソッドシグネチャ, 引数, 戻り値, リソースクラス, void, Java Beans, HttpRequest

</details>

## パスパラメータを扱う

パスパラメータは `JaxRsHttpRequest` から取得する。メソッドの引数に `JaxRsHttpRequest` を定義し、ルーティング設定で指定したパスパラメータ名を `getPathParam()` に渡す。

ルーティング設定（詳細は :ref:`router_adaptor` を参照）:
```xml
<routes>
  <get path="users/:id" to="UsersResource#find">
    <requirements>
      <requirement name="id" value="\d+$" />
    </requirements>
  </get>
</routes>
```

実装例:
```java
@Produces(MediaType.APPLICATION_JSON)
public User delete(JaxRsHttpRequest req) {
  Long id = Long.valueOf(req.getPathParam("id"));
  return UniversalDao.findById(User.class, id);
}
```

> **重要**: Jakarta RESTful Web Servicesで規定されている `PathParam` は使用できない。

<details>
<summary>keywords</summary>

JaxRsHttpRequest, PathParam, パスパラメータ, getPathParam, ルーティング設定, router_adaptor, UniversalDao

</details>

## クエリーパラメータを扱う

クエリパラメータは `JaxRsHttpRequest` から取得する。メソッドの引数に `JaxRsHttpRequest` を定義し、`getParamMap()` で取得後、`BeanUtil` でFormにマッピングする。

ルーティング設定（クエリパラメータを除いたパスでマッピング）:
```xml
<routes>
  <get path="users/search" to="Users#search"/>
</routes>
```

実装例:
```java
public HttpResponse search(JaxRsHttpRequest req) {
  UserSearchForm form = BeanUtil.createAndCopy(UserSearchForm.class, req.getParamMap());
  ValidatorUtil.validate(form);
  // 業務ロジックを実行する(省略)
}
```

> **重要**: Jakarta RESTful Web Servicesで規定されている `QueryParam` は使用できない。

<details>
<summary>keywords</summary>

JaxRsHttpRequest, BeanUtil, QueryParam, クエリパラメータ, getParamMap, BeanUtil.createAndCopy, UserSearchForm, ValidatorUtil

</details>

## レスポンスヘッダを設定する

> **重要**: アプリケーション全体で共通のレスポンスヘッダはハンドラで設定すること。セキュリティ関連のレスポンスヘッダは :ref:`secure_handler` を使用すること。

`HttpResponse` を返す場合は `setHeader()` で指定する:
```java
public HttpResponse something(JaxRsHttpRequest request) {
    HttpResponse response = new HttpResponse();
    response.setHeader("Cache-Control", "no-store");
    return response;
}
```

`@Produces` アノテーションを使用してエンティティ（Bean）を返す場合、レスポンスヘッダを直接指定できない。代わりに `EntityResponse` を使用する:
```java
@Produces(MediaType.APPLICATION_JSON)
public EntityResponse<List<Client>> something(JaxRsHttpRequest request, ExecutionContext context) {
    List<Client> clients = service.findClients(condition);
    EntityResponse<List<Client>> response = new EntityResponse<>();
    response.setEntity(clients);
    response.setStatusCode(HttpResponse.Status.OK.getStatusCode());
    response.setHeader("Cache-Control", "no-store");
    return response;
}
```

<details>
<summary>keywords</summary>

HttpResponse, EntityResponse, レスポンスヘッダ, setHeader, @Produces, ステータスコード, secure_handler, setStatusCode, setEntity

</details>
