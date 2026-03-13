# 更新機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/getting_started/update/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/javax/ws/rs/Consumes.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/validation/Valid.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/ErrorResponseBuilder.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/NoDataException.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/javax/persistence/OptimisticLockException.html)

## プロジェクト情報を更新する

RESTful WebサービスのPUTリクエストによる更新機能の実装パターン。

## フォームの作成

**クラス**: `ProjectUpdateForm`

```java
public class ProjectUpdateForm implements Serializable {
    @Required
    @Domain("id")
    private String projectId;

    @Required
    @Domain("projectName")
    private String projectName;

    @Required
    @Domain("projectType")
    private String projectType;
    // ゲッタ及びセッタは省略
}
```

プロパティは全てString型で宣言する（ [bean_validation-form_property](../../component/libraries/libraries-bean_validation.md) 参照）。

## 業務アクションメソッドの実装

```java
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public HttpResponse update(ProjectUpdateForm form) {
    Project project = BeanUtil.createAndCopy(Project.class, form);
    UniversalDao.update(project);
    return new HttpResponse(HttpResponse.Status.OK.getStatusCode());
}
```

- JSONリクエストボディを受け付けるため、`Consumes` アノテーションに `MediaType.APPLICATION_JSON` を指定する。
- `Valid` アノテーションでリクエストのバリデーションを行う（ [jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md) 参照）。
- `BeanUtil` でフォームからエンティティを作成し、[universal_dao](../../component/libraries/libraries-universal_dao.md) でプロジェクト情報を更新する。
- 更新成功時はステータスコード200の `HttpResponse` を返却する。

> **補足**: Exampleアプリケーションでは `ErrorResponseBuilder` を独自に拡張しており、`NoDataException` が発生した場合は404、`OptimisticLockException` が発生した場合は409のレスポンスを生成してクライアントに返却している。

## URLマッピングの定義

[router_adaptor](../../component/adapters/adapters-router_adaptor.md) を使用し、[JAX-RSのPathアノテーション](../../component/adapters/adapters-router_adaptor.md) でURLマッピングを行う。

```java
@Path("/projects")
public class ProjectAction {
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Valid
    public HttpResponse update(ProjectUpdateForm form) {
        ...
    }
}
```

`@Path` アノテーションと `@PUT` アノテーションを組み合わせて、PUTリクエスト時にマッピングする業務アクションメソッドを定義する。

<details>
<summary>keywords</summary>

ProjectUpdateForm, Project, @Required, @Domain, @Consumes, @Valid, @Path, @PUT, NoDataException, OptimisticLockException, BeanUtil, UniversalDao, HttpResponse, ErrorResponseBuilder, RESTful更新機能, JSONリクエストボディ, バリデーション, UniversalDao更新, URLマッピング

</details>
