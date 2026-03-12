# 更新機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/getting_started/update/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/ws/rs/Consumes.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/validation/Valid.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/ErrorResponseBuilder.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/NoDataException.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/persistence/OptimisticLockException.html)

## プロジェクト情報を更新する

## 概要

PUTリクエスト時にリクエストボディにJSON形式のプロジェクト情報を設定することで、データベース上のプロジェクトIDが一致するプロジェクト情報を更新する。

リクエスト例（`PUT /projects`）:

```json
{
    "projectId": 1,
    "projectName": "プロジェクト９９９",
    "projectType": "development",
    "projectClass": "ss",
    "projectManager": "山田",
    "projectLeader": "田中",
    "clientId": 10,
    "projectStartDate": "20160101",
    "projectEndDate": "20161231",
    "note": "備考９９９",
    "sales": 10000,
    "costOfGoodsSold": 20000,
    "sga": 30000,
    "allocationOfCorpExpenses": 40000,
    "version": 1
}
```

## フォームの作成

**クラス**: `ProjectUpdateForm`（`Serializable`実装）

プロパティは全てString型で宣言し、`@Required`と`@Domain`アノテーションを付与する。詳細は [bean_validation-form_property](../../component/libraries/libraries-bean_validation.md) 参照。

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

## 業務アクションメソッドの実装

- JSON形式のリクエストボディを受け付けるため、`Consumes` アノテーションに`MediaType.APPLICATION_JSON`を指定する。
- `Valid` アノテーションでリクエストのバリデーションを行う。詳細は [jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md) 参照。
- `BeanUtil` でフォームからエンティティを作成し、[universal_dao](../../component/libraries/libraries-universal_dao.md) を使用してプロジェクト情報を更新する。
- 更新成功時はステータスコード`200`を表す `HttpResponse` を返す。

```java
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public HttpResponse update(ProjectUpdateForm form) {
    Project project = BeanUtil.createAndCopy(Project.class, form);
    UniversalDao.update(project);
    return new HttpResponse(HttpResponse.Status.OK.getStatusCode());
}
```

> **補足**: Exampleアプリケーションでは `ErrorResponseBuilder` を独自に拡張しており、`NoDataException` が発生した場合は`404`、`OptimisticLockException` が発生した場合は`409`のレスポンスを生成してクライアントに返却している。

## URLとのマッピングを定義

`@Path`アノテーションと`@PUT`アノテーションを使用して、PUTリクエスト時の業務アクションメソッドを定義する。[router_adaptor](../../component/adapters/adapters-router_adaptor.md) および [router_adaptor_path_annotation](../../component/adapters/adapters-router_adaptor.md) 参照。

```java
@Path("/projects")
public class ProjectAction {
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Valid
    public HttpResponse update(ProjectUpdateForm form) {
        Project project = BeanUtil.createAndCopy(Project.class, form);
        UniversalDao.update(project);
        return new HttpResponse(HttpResponse.Status.OK.getStatusCode());
    }
```

<details>
<summary>keywords</summary>

ProjectUpdateForm, ProjectAction, Project, @Required, @Domain, @Consumes, @Valid, @PUT, @Path, BeanUtil, UniversalDao, HttpResponse, ErrorResponseBuilder, NoDataException, OptimisticLockException, PUTリクエスト, REST更新処理, JSONリクエストボディ受信, フォームバリデーション

</details>
