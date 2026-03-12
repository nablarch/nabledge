# 登録機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/getting_started/create/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/ws/rs/Consumes.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/validation/Valid.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html)

## プロジェクト情報を登録する

## 動作確認手順

1. **事前にDBの状態を確認**

   H2のコンソールから下記SQLを実行し、レコードが存在しないことを確認する。

   ```sql
   SELECT * FROM PROJECT WHERE PROJECT_NAME = 'プロジェクト９９９';
   ```

2. **プロジェクト情報の登録**

   POSTリクエストで以下の情報を送信する。

   - URL: `http://localhost:9080/projects`
   - HTTPメソッド: `POST`
   - Content-Type: `application/json`

   リクエストボディ（全フィールド）:

   ```json
   {
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
       "allocationOfCorpExpenses": 40000
   }
   ```

3. **動作確認**

   H2のコンソールから下記SQLを実行し、レコードが1件取得できることを確認する。

   ```sql
   SELECT * FROM PROJECT WHERE PROJECT_NAME = 'プロジェクト９９９';
   ```

## フォームの作成

**クラス**: `public class ProjectForm implements Serializable`

- プロパティは全てString型で宣言すること（[bean_validation-form_property](../../component/libraries/libraries-bean_validation.md) 参照）

```java
@Required
@Domain("projectName")
private String projectName;
```

## 業務アクションメソッドの実装

実装ポイント:
- `Consumes` アノテーションに `MediaType.APPLICATION_JSON` を指定してJSON形式のリクエストを受け付ける
- `Valid` アノテーションでリクエストのバリデーションを実行する（[jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md) 参照）
- `BeanUtil` でフォームをエンティティに変換し、[universal_dao](../../component/libraries/libraries-universal_dao.md) でDB登録する
- 戻り値はリソース作成完了（ステータスコード `201`）を表す `HttpResponse` を返却する

## URLとのマッピングを定義

[router_adaptor](../../component/adapters/adapters-router_adaptor.md) を使用し、[router_adaptor_path_annotation](../../component/adapters/adapters-router_adaptor.md) でURLマッピングを定義する。

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

- `@Path` と `@POST` アノテーションでPOSTリクエスト時にマッピングするアクションメソッドを定義する

<details>
<summary>keywords</summary>

ProjectForm, ProjectAction, Project, BeanUtil, UniversalDao, HttpResponse, MediaType, Serializable, @Consumes, @Valid, @Required, @Domain, @Path, @POST, JSONリクエスト登録処理, RESTful APIリソース登録, HTTPステータスコード201, フォームからエンティティへの変換

</details>
