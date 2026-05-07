# 登録機能の作成

Exampleアプリケーションを元に、登録機能を解説する。

作成する機能の説明

本機能は、POSTリクエスト時にリクエストボディにJSON形式のプロジェクト情報を設定することで、
データベースにプロジェクト情報を登録する。

動作確認手順

1. 事前にDBの状態を確認

  H2のコンソールから下記SQLを実行し、レコードが存在しないことを確認する。

  ```sql
  SELECT * FROM PROJECT WHERE PROJECT_NAME = 'プロジェクト９９９';
  ```
2. プロジェクト情報の登録

任意のRESTクライアントを使用して、以下のリクエストを送信する。

URL

[http://localhost:9080/projects](http://localhost:9080/projects)

HTTPメソッド

POST

Content-Type

application/json

リクエストボディ

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

1. 動作確認

H2のコンソールから下記SQLを実行し、レコードが1件取得できることを確認する。

```sql
SELECT * FROM PROJECT WHERE PROJECT_NAME = 'プロジェクト９９９';
```

## プロジェクト情報を登録する

フォームの作成

クライアントから送信された値を受け付けるフォームを作成する。

ProjectForm.java

```java
public class ProjectForm implements Serializable {

    // 一部のみ抜粋

    /** プロジェクト名 */
    @Required
    @Domain("projectName")
    private String projectName;

    // ゲッタ及びセッタは省略
}
```

この実装のポイント

* プロパティは全てString型で宣言する。詳細は [バリデーションルールの設定方法](../../component/libraries/libraries-bean-validation.md#bean-validation-form-property) を参照。

業務アクションメソッドの実装

プロジェクト情報をデータベースに登録する処理を実装する。

ProjectAction.java

```java
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public HttpResponse save(ProjectForm project) {
    UniversalDao.insert(BeanUtil.createAndCopy(Project.class, project));
    return new HttpResponse(HttpResponse.Status.CREATED.getStatusCode());
}
```

この実装のポイント

* リクエストをJSON形式で受け付けるため、 Consumes アノテーションに
  `MediaType.APPLICATION_JSON` を指定する。
* Valid アノテーションを使用して、リクエストのバリデーションを行う。
  詳細は [Jakarta RESTful Web Servcies Bean Validationハンドラ](../../component/handlers/handlers-jaxrs-bean-validation-handler.md#jaxrs-bean-validation-handler) を参照。
* BeanUtil でフォームをエンティティに変換し、
  [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao) を使用してプロジェクト情報をデータベースに登録する。
* 戻り値として、リソースの作成完了(ステータスコード： `201` )を表す HttpResponse を返却する。

URLとのマッピングを定義

[ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#router-adaptor) を使用して、業務アクションとURLのマッピングを行う。
マッピングには [Jakarta RESTful Web ServicesのPathアノテーション](../../component/adapters/adapters-router-adaptor.md#router-adaptor-path-annotation) を使用する。

ProjectAction.java

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
```

この実装のポイント

* `@Path` アノテーションと `@POST` アノテーションを使用して、POSTリクエスト時にマッピングする業務アクションメソッドを定義する。
