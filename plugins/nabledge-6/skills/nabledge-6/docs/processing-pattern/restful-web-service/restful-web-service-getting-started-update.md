# 更新機能の作成

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

プロパティは全てString型で宣言し、`@Required`と`@Domain`アノテーションを付与する。詳細は :ref:`bean_validation-form_property` 参照。

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
- `Valid` アノテーションでリクエストのバリデーションを行う。詳細は :ref:`jaxrs_bean_validation_handler` 参照。
- `BeanUtil` でフォームからエンティティを作成し、:ref:`universal_dao` を使用してプロジェクト情報を更新する。
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

`@Path`アノテーションと`@PUT`アノテーションを使用して、PUTリクエスト時の業務アクションメソッドを定義する。:ref:`router_adaptor` および :ref:`router_adaptor_path_annotation` 参照。

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
