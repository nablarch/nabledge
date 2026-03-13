# リソース(アクション)クラスの実装に関して

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/feature_details/resource_signature.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsHttpRequest.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/EntityResponse.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/javax/ws/rs/PathParam.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/javax/ws/rs/QueryParam.html)

## リソースクラスのメソッドのシグネチャ

## メソッド引数

| 引数定義 | 説明 |
|---|---|
| 引数無し | パラメータやリクエストボディ不要な場合 |
| フォーム(Java Beans) | リクエストボディから変換したフォームで処理する場合 |
| `JaxRsHttpRequest` | [パスパラメータ](#s1)・[クエリパラメータ](#s2)、HTTPヘッダ値を取得する場合 |
| `ExecutionContext` | スコープ変数にアクセスしたい場合 |
| 組み合わせ | 上記の型を組み合わせ可能 |

> **補足**: 後方互換性維持のためHttpRequestも使用できるが、原則 `JaxRsHttpRequest` を使用する。

```java
// 引数無し
public HttpResponse sample() { }

// フォーム
public HttpResponse sample(SampleForm form) { }

// JaxRsHttpRequest
public HttpResponse sample(JaxRsHttpRequest request) { }

// ExecutionContext
public HttpResponse sample(ExecutionContext context) { }

// 組み合わせ
public HttpResponse sample(SampleForm form, JaxRsHttpRequest request) { }
```

## メソッド戻り値

| 戻り値の型 | 説明 |
|---|---|
| void | `204: NoContent` をクライアントに返却 |
| フォーム(Java Beans) | [body_convert_handler](../../component/handlers/handlers-body_convert_handler.md) でレスポンスボディに変換してクライアントに返却 |
| `HttpResponse` | HttpResponseの情報をそのままクライアントに返却 |

<details>
<summary>keywords</summary>

JaxRsHttpRequest, HttpRequest, ExecutionContext, HttpResponse, メソッドシグネチャ, 引数定義, 戻り値型, フォーム引数, void戻り値

</details>

## パスパラメータを扱う

パスパラメータは `JaxRsHttpRequest` から取得する。リソースメソッドの引数に `JaxRsHttpRequest` を定義し、ルーティング設定で指定したパラメータ名で `getPathParam()` を呼び出す。

ルーティング設定例（`GET /users/:id`、数値のみ許容）:

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

> **重要**: JSRで規定されている `PathParam` は使用できない。

<details>
<summary>keywords</summary>

JaxRsHttpRequest, PathParam, パスパラメータ取得, getPathParam, ルーティング設定, UniversalDao

</details>

## クエリーパラメータを扱う

クエリーパラメータは `JaxRsHttpRequest` から取得する。`getParamMap()` で取得したパラメータを `BeanUtil` の `createAndCopy()` でFormクラスにマッピングする。

ルーティング設定例（`GET /users/search`）:

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

public UserSearchForm {
  private String name;
  // 省略
}
```

> **重要**: JSRで規定されている `QueryParam` は使用できない。

<details>
<summary>keywords</summary>

JaxRsHttpRequest, BeanUtil, QueryParam, クエリーパラメータ取得, createAndCopy, getParamMap, ValidatorUtil

</details>

## レスポンスヘッダを設定する

> **重要**: アプリケーション全体で共通のレスポンスヘッダはハンドラで設定すること。セキュリティ関連のレスポンスヘッダは [secure_handler](../../component/handlers/handlers-secure_handler.md) を使用する。

`HttpResponse` を返す場合は `setHeader()` でレスポンスヘッダを指定する:

```java
public HttpResponse something(JaxRsHttpRequest request) {
    HttpResponse response = new HttpResponse();
    response.setHeader("Cache-Control", "no-store");
    return response;
}
```

`@Produces` アノテーションを使用してBeanを返す場合はそのままではレスポンスヘッダを指定できない。この場合は `EntityResponse` を返すように実装する:

```java
@Produces(MediaType.APPLICATION_JSON)
public EntityResponse something(JaxRsHttpRequest request, ExecutionContext context) {
    List<Client> clients = service.findClients(condition);
    EntityResponse response = new EntityResponse();
    response.setEntity(clients);
    response.setStatusCode(HttpResponse.Status.OK.getStatusCode());
    response.setHeader("Cache-Control", "no-store");
    return response;
}
```

<details>
<summary>keywords</summary>

HttpResponse, EntityResponse, レスポンスヘッダ設定, setHeader, @Produces, ステータスコード設定

</details>
