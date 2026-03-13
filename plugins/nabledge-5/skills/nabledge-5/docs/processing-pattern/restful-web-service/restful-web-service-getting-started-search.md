# 検索機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/getting_started/search/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsHttpRequest.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/ValidatorUtil.html)

## プロジェクト情報を検索する

## プロジェクト情報を検索する

GETリクエスト時にクエリパラメータで検索条件を指定すると、条件に合致するプロジェクト情報をJSON形式で返却する。検索条件として、顧客ID（完全一致）とプロジェクト名（部分一致）を指定できる。検索条件を指定しない場合は、全てのプロジェクト情報を返却する。

### フォームの作成

**クラス**: `ProjectSearchForm`

- フォームのプロパティは全てString型で宣言する（[バリデーションルールの設定方法](../../component/libraries/libraries-bean_validation.md) 参照）

```java
public class ProjectSearchForm implements Serializable {
    @Domain("id")
    private String clientId;
    @Domain("projectName")
    private String projectName;
    // ゲッタ及びセッタは省略
}
```

### 検索条件Beanの作成

**クラス**: `ProjectSearchDto`

- BeanのプロパティはSQL条件カラムの定義（型）と互換性のある型を使用すること（[universal_dao-search_with_condition](../../component/libraries/libraries-universal_dao.md) 参照）

```java
public class ProjectSearchDto implements Serializable {
    private Integer clientId;
    private String projectName;
    // ゲッタ及びセッタは省略
}
```

### SQLの作成

- SQLインジェクション防止のため、SQLは外部ファイルに記述する（[database-use_sql_file](../../component/libraries/libraries-database.md) 参照）
- Beanのプロパティ名を使ってSQLに値をバインドする（[database-input_bean](../../component/libraries/libraries-database.md) 参照）
- 指定された検索条件のみをWHERE句に含める場合は [$if構文](../../component/libraries/libraries-database.md) を使用する

```sql
FIND_PROJECT =
SELECT
    *
FROM
    PROJECT
WHERE
    $if(clientId) {CLIENT_ID = :clientId}
    AND $if(projectName) {PROJECT_NAME LIKE :%projectName%}
```

### 業務アクションメソッドの実装

**アノテーション**: `@Produces`, `@GET`, `@Path`
**クラス**: `JaxRsHttpRequest`, `BeanUtil`, `ValidatorUtil`

- JSON形式でレスポンスを返すため `@Produces(MediaType.APPLICATION_JSON)` を指定する
- クエリパラメータは `JaxRsHttpRequest` から取得する
- `BeanUtil` でリクエストパラメータからフォームを作成し、検索条件Beanにコピーする
- `ValidatorUtil#validate` でフォームのバリデーションを実行する
- [universal_dao](../../component/libraries/libraries-universal_dao.md) でSQLファイルを使いDBからプロジェクト情報を取得して返却する
- 戻り値は [body_convert_handler](../../component/handlers/handlers-body_convert_handler.md) によって自動的にJSON形式に変換されるため、アクション内での変換処理は不要

```java
@Path("/projects")
public class ProjectAction {
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Project> find(JaxRsHttpRequest req) {
        ProjectSearchForm form =
                BeanUtil.createAndCopy(ProjectSearchForm.class, req.getParamMap());
        ValidatorUtil.validate(form);
        ProjectSearchDto searchCondition = BeanUtil.createAndCopy(ProjectSearchDto.class, form);
        return UniversalDao.findAllBySqlFile(Project.class, "FIND_PROJECT", searchCondition);
    }
}
```

### URLとのマッピング定義

- [router_adaptor](../../component/adapters/adapters-router_adaptor.md) を使用して業務アクションとURLのマッピングを行う
- マッピングには [JAX-RSのPathアノテーション](../../component/adapters/adapters-router_adaptor.md) を使用する
- `@Path` アノテーションでURLパスを定義し、`@GET` アノテーションでGETリクエスト時にマッピングする業務アクションメソッドを定義する

### 動作確認手順

1. 任意のRESTクライアントを使用して以下のリクエストを送信する
   - URL: `http://localhost:9080/projects?clientId=1`
   - HTTPメソッド: GET

2. 以下のようなJSON形式のレスポンスが返却されることを確認する

```javascript
[{
    "projectId": 1,
    "projectName": "プロジェクト００１",
    "projectType": "development",
    // 省略
}]
```

<details>
<summary>keywords</summary>

ProjectSearchForm, ProjectSearchDto, Project, ProjectAction, JaxRsHttpRequest, BeanUtil, ValidatorUtil, UniversalDao, MediaType, @Produces, @GET, @Path, @Domain, RESTful検索実装, クエリパラメータ検索, JSON形式レスポンス, $if構文, BeanValidation, 完全一致, 部分一致, 動作確認

</details>
