# 更新機能の作成

Exampleアプリケーションを元に、更新機能を解説する。

作成する機能の説明
本機能は、PUTリクエスト時にリクエストボディにJSON形式のプロジェクト情報を設定することで、
データベース上のプロジェクトIDが一致するプロジェクト情報を更新する。
動作確認手順
1. 事前にDBの状態を確認

  H2のコンソールから下記SQLを実行し、更新対象レコードを確認する。

  ```sql
  SELECT * FROM PROJECT WHERE PROJECT_ID = 1;
  ```
2. プロジェクト情報の更新

任意のRESTクライアントを使用して、以下のリクエストを送信する。

URL
[http://localhost:9080/projects](http://localhost:9080/projects)
HTTPメソッド
PUT
Content-Type
application/json
リクエストボディ
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

1. 動作確認

H2のコンソールから下記SQLを実行し、レコードが更新されていることを確認する。

```sql
SELECT * FROM PROJECT WHERE PROJECT_ID = 1;
```

## プロジェクト情報を更新する

フォームの作成
クライアントから送信された値を受け付けるフォームを作成する。

ProjectUpdateForm.java
```java
public class ProjectUpdateForm implements Serializable {

    // 一部のみ抜粋

    /** プロジェクト名 */
    @Required
    @Domain("id")
    private String projectId;

    /** プロジェクト名 */
    @Required
    @Domain("projectName")
    private String projectName;

    /** プロジェクト種別 */
    @Required
    @Domain("projectType")
    private String projectType;

    // ゲッタ及びセッタは省略
}
```

この実装のポイント
* プロパティは全てString型で宣言する。詳細は [バリデーションルールの設定方法](../../component/libraries/libraries-bean-validation.md#bean-validation-form-property) を参照。
業務アクションメソッドの実装
データベース上のプロジェクト情報を更新する処理を実装する。

ProjectAction.java
```java
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public HttpResponse update(ProjectUpdateForm form) {
    Project project = BeanUtil.createAndCopy(Project.class, form);

    UniversalDao.update(project);

    return new HttpResponse(HttpResponse.Status.OK.getStatusCode());
}
```

この実装のポイント
* リクエストボディをJSON形式で受け付けるため、 Consumes アノテーションに
  `MediaType.APPLICATION_JSON` を指定する。
* Valid アノテーションを使用して、リクエストのバリデーションを行う。
  詳細は [JAX-RS BeanValidationハンドラ](../../component/handlers/handlers-jaxrs-bean-validation-handler.md#jaxrs-bean-validation-handler) を参照。
* BeanUtil でフォームからエンティティを作成し、
  [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao) を使用してプロジェクト情報を更新する。
* 更新に成功した場合は、正常終了(ステータスコード： `200` )を表す HttpResponse を返却する。

> **Tip:**
> Exampleアプリケーションでは ErrorResponseBuilder を独自に拡張しており、
> NoDataException が発生した場合は `404` 、
> OptimisticLockException が発生した場合は `409`
> のレスポンスを生成してクライアントに返却している。
URLとのマッピングを定義
[ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#router-adaptor) を使用して、業務アクションとURLのマッピングを行う。
マッピングには [JAX-RSのPathアノテーション](../../component/adapters/adapters-router-adaptor.md#router-adaptor-path-annotation) を使用する。

ProjectAction.java
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
この実装のポイント
* `@Path` アノテーションと `@PUT` アノテーションを使用して、PUTリクエスト時にマッピングする業務アクションメソッドを定義する。
