# 登録機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/getting_started/create/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/javax/ws/rs/Consumes.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/validation/Valid.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html)

## プロジェクト情報を登録する

## フォームの作成

フォームのプロパティは全てString型で宣言する（詳細: [bean_validation-form_property](../../component/libraries/libraries-bean_validation.md)）。

**クラス**: `ProjectForm`

```java
public class ProjectForm implements Serializable {
    @Required
    @Domain("projectName")
    private String projectName;
    // ゲッタ及びセッタは省略
}
```

## 業務アクションメソッドの実装

- JSON形式でリクエストを受け付けるため、`Consumes` に `MediaType.APPLICATION_JSON` を指定する。
- `Valid` アノテーションでリクエストのバリデーションを行う（詳細: [jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md)）。
- `BeanUtil` でフォームをエンティティに変換し、[universal_dao](../../component/libraries/libraries-universal_dao.md) でDB登録する。
- 戻り値はリソース作成完了（ステータスコード `201`）を表す `HttpResponse` を返す。

```java
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public HttpResponse save(ProjectForm project) {
    UniversalDao.insert(BeanUtil.createAndCopy(Project.class, project));
    return new HttpResponse(HttpResponse.Status.CREATED.getStatusCode());
}
```

## URLとのマッピングを定義

[router_adaptor](../../component/adapters/adapters-router_adaptor.md) を使用してURLマッピングを行う（[JAX-RSのPathアノテーション](../../component/adapters/adapters-router_adaptor.md) 使用）。`@Path` と `@POST` でPOSTリクエスト時にマッピングする業務アクションメソッドを定義する。

```java
@Path("/projects")
public class ProjectAction {
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Valid
    public HttpResponse save(ProjectForm project) {
        UniversalDao.insert(BeanUtil.createAndCopy(Project.class, project));
        return new HttpResponse(HttpResponse.Status.CREATED.getStatusCode());
    }
}
```

<details>
<summary>keywords</summary>

ProjectForm, ProjectAction, Project, BeanUtil, HttpResponse, UniversalDao, MediaType, Serializable, @Required, @Domain, @Consumes, @Valid, @Path, @POST, JSON登録, RESTful POST, フォームバリデーション, ユニバーサルDAO登録, HTTPレスポンス201

</details>
