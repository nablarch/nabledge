# リソース(アクション)クラスの実装に関して

## リソースクラスのメソッドのシグネチャ

リソースクラスのメソッドの引数及び戻り値で使用できる型について示す。

メソッド引数

| 引数定義 | 説明 |
|---|---|
| 引数無し | パラメータやリクエストボディを必要としない場合には、引数無しとしてメソッドを定義できる。  例  ```java public HttpResponse sample() {   // 省略 } ``` |
| フォーム(Java Beans) | リクエストボディから変換したフォームを元に処理を行う場合には、引数としてフォームを定義する。  例  ```java public HttpResponse sample(SampleForm form) {   // 省略 } ``` |
| JaxRsHttpRequest [1] | [パスパラメータ](../../processing-pattern/restful-web-service/restful-web-service-resource-signature.md#パスパラメータを扱う) や [クエリパラメータ](../../processing-pattern/restful-web-service/restful-web-service-resource-signature.md#クエリーパラメータを扱う) を使う場合やHTTPヘッダの値などを取得したい場合には、引数として JaxRsHttpRequest を定義する。  例  ```java public HttpResponse sample(JaxRsHttpRequest request) {   // 省略 } ``` |
| ExecutionContext | ExecutionContext が提供するスコープ変数にアクセスしたい場合は、 引数として ExecutionContext を定義する。  例  ```java public HttpResponse sample(ExecutionContext context) {   // 省略 } ``` |
| 組み合わせ | 用途に応じて上記の型を組み合わせることが出来る。  例えば、HTTPヘッダ情報とリクエストボディから変換されたFormを必要とするメソッドでは、以下の定義となる。  ```java public HttpResponse sample(SampleForm form, JaxRsHttpRequest request) {   // 省略 } ``` |

後方互換性維持のためHttpRequestも使用できるが、原則JaxRsHttpRequestを使用する。

メソッド戻り値

| 戻り値の型 | 説明 |
|---|---|
| void | レスポンスのボディが空であることを示す `204: NoContent` をクライアントに返却する。 |
| フォーム(Java Beans) | メソッドから戻されたフォームを [リクエストボディ変換ハンドラ](../../component/handlers/handlers-body-convert-handler.md#リクエストボディ変換ハンドラ) で、レスポンスボディに出力する内容に変換しクライアントに返却する。 |
| HttpResponse | メソッドから戻された HttpResponse の情報を、クライアントに返却する。 |

## パスパラメータを扱う

検索や更新、削除対象のリソースを示す値をパスパラメータとして指定する場合の実装方法を示す。

URLの例

`GET /users/123` の `123` をパスパラメータとする。

ルーティングの設定

URLとアクションとのマッピング時にパスパラメータ部に任意の名前を設定する。
この例では、 `id` という名前を設定し、数値のみを許容する設定としている。

詳細は、 [ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#ルーティングアダプタ) を参照。

```xml
<routes>
  <get path="users/:id" to="UsersResource#find">
    <requirements>
      <requirement name="id" value="\d+$" />
    </requirements>
  </get>
</routes>
```

リソースクラスのメソッドの実装

パスパラメータは、 JaxRsHttpRequest から取得する。
このため、リソースのメソッドには、仮引数として JaxRsHttpRequest を定義する。

JaxRsHttpRequest に指定するパラメータ名には、
ルーティングの設定で指定したパスパラメータの名前を使用する。

```java
@Produces(MediaType.APPLICATION_JSON)
public User delete(JaxRsHttpRequest req) {
  // JaxRsHttpRequestからパスパラメータの値を取得する
  Long id = Long.valueOf(req.getPathParam("id"));
  return UniversalDao.findById(User.class, id);
}
```

> **Important:**
> JSRで規定されている PathParam は使用できないので注意すること。

## クエリーパラメータを扱う

リソースの検索処理で、検索条件をクエリーパラメータとして指定させたい場合がある。
このような場合の実装方法を以下に示す。

URLの例

`GET /users/search?name=Duke`

ルーティングの設定

ルーティングの設定では、クエリーパラメータを除いたパスを元に、リソースクラスとのマッピングを行う。

```xml
<routes>
  <get path="users/search" to="Users#search"/>
</routes>
```

リソースクラスのメソッドの実装

クエリーパラメータは、 JaxRsHttpRequest から取得する。
このため、リソースのメソッドには、仮引数として JaxRsHttpRequest を定義する。

JaxRsHttpRequest から取得したパラメータを BeanUtil を使ってFormクラスにマッピングする。

```java
public HttpResponse search(JaxRsHttpRequest req) {

  // リクエストパラメータをBeanに変換
  UserSearchForm form = BeanUtil.createAndCopy(UserSearchForm.class, req.getParamMap());

  // バリデーションの実行
  ValidatorUtil.validate(form)

  // 業務ロジックを実行する(省略)
}

// クエリーパラメータをマッピングするForm
public UserSearchForm {
  private String name;
  // 省略
}
```

> **Important:**
> JSRで規定されている QueryParam は使用できないので注意すること。

## レスポンスヘッダを設定する

リソースクラスのメソッドで個別にレスポンスヘッダを指定したい場合がある。

> **Important:**
> アプリケーション全体で共通となるレスポンスヘッダを指定したい場合はハンドラで設定すること。
> セキュリティ関連のレスポンスヘッダを指定したい場合は [セキュアハンドラ](../../component/handlers/handlers-secure-handler.md#セキュアハンドラ) を使用すればよい。

リソースクラスのメソッドで HttpResponse を作成する場合は、
HttpResponseにレスポンスヘッダを指定すればよい。

```java
public HttpResponse something(JaxRsHttpRequest request) {

    // 処理は省略

    HttpResponse response = new HttpResponse();
    response.setHeader("Cache-Control", "no-store"); // レスポンスヘッダを指定
    return response;
}
```

Producesアノテーションを使用し、リソースクラスのメソッドがエンティティ（Bean）を返す場合は、
そのままではレスポンスヘッダを指定できない。

```java
@Produces(MediaType.APPLICATION_JSON)
public List<Client> something(JaxRsHttpRequest request, ExecutionContext context) {

    // 処理は省略
    List<Client> clients = service.findClients(condition);

    return clients;
}
```

フレームワークではProducesアノテーションを使用した場合にレスポンスヘッダとステータスコードを指定するために、
EntityResponse を提供している。
エンティティの代わりにEntityResponseを返すように実装すればよい。

```java
@Produces(MediaType.APPLICATION_JSON)
public EntityResponse something(JaxRsHttpRequest request, ExecutionContext context) {

    // 処理は省略
    List<Client> clients = service.findClients(condition);

    EntityResponse response = new EntityResponse();
    response.setEntity(clients); // エンティティを指定
    response.setStatusCode(HttpResponse.Status.OK.getStatusCode()); // ステータスコードを指定
    response.setHeader("Cache-Control", "no-store"); // レスポンスヘッダを指定
    return response;
}
```
