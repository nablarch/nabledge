# 検索機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/getting_started/search/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/ws/rs/Produces.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsHttpRequest.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/ValidatorUtil.html)

## プロジェクト情報を検索する

## 機能概要

- 検索条件として、`顧客ID(完全一致)`、`プロジェクト名(部分一致)` を指定できる。
- 検索条件を指定しない場合は、全てのプロジェクト情報を返却する。

## 動作確認

- テストURL: `http://localhost:9080/projects?clientId=1`（顧客IDが1のプロジェクトを検索）
- HTTPメソッド: GET
- レスポンス例（フィールド: `projectId`、`projectName`、`projectType`）:

```javascript
[{
    "projectId": 1,
    "projectName": "プロジェクト００１",
    "projectType": "development",
    // 省略
}]
```

## フォームの作成

**クラス**: `ProjectSearchForm`

- プロパティは全てString型で宣言する。詳細は :ref:`バリデーションルールの設定方法 <bean_validation-form_property>` を参照。

```java
public class ProjectSearchForm implements Serializable {
    @Domain("id")
    private String clientId;

    @Domain("projectName")
    private String projectName;
    // ゲッタ及びセッタは省略
}
```

## 検索条件Beanの作成

**クラス**: `ProjectSearchDto`

- BeanのプロパティはDB検索条件カラムの型と互換性のある型とする。詳細は :ref:`対応する条件カラムの定義(型)と互換性のある型とする<universal_dao-search_with_condition>` を参照。

```java
public class ProjectSearchDto implements Serializable {
    private Integer clientId;
    private String projectName;
    // ゲッタ及びセッタは省略
}
```

## SQLの作成

- SQLインジェクションを防ぐため、SQLは外部ファイルに記述する。詳細は :ref:`database-use_sql_file` を参照。
- Beanのプロパティ名を使ってSQLに値をバインドする。詳細は :ref:`database-input_bean` を参照。
- 検索条件として指定された項目のみを条件に含める場合は :ref:`$if 構文を使用してSQL文を構築<database-use_variable_condition>` する。

```sql
FIND_PROJECT =
SELECT * FROM PROJECT
WHERE
    $if(clientId) {CLIENT_ID = :clientId}
    AND $if(projectName) {PROJECT_NAME LIKE :%projectName%}
```

## 業務アクションメソッド

- 検索結果をJSON形式で返却するため `Produces` アノテーションに `MediaType.APPLICATION_JSON` を指定する。
- クエリパラメータは `JaxRsHttpRequest` から取得する。
- `BeanUtil` でリクエストパラメータからフォームを作成し、`ValidatorUtil#validate` でバリデーションを行う。
- フォームの値を `BeanUtil` で検索条件Beanにコピーし、:ref:`universal_dao` で検索する。
- 戻り値は :ref:`body_convert_handler` によってJSON形式に変換されるため、業務アクションメソッド内での変換処理は不要。

```java
@Produces(MediaType.APPLICATION_JSON)
public List<Project> find(JaxRsHttpRequest req) {

    // リクエストパラメータをBeanに変換
    ProjectSearchForm form =
            BeanUtil.createAndCopy(ProjectSearchForm.class, req.getParamMap());

    // BeanValidation実行
    ValidatorUtil.validate(form);

    ProjectSearchDto searchCondition = BeanUtil.createAndCopy(ProjectSearchDto.class, form);
    return UniversalDao.findAllBySqlFile(Project.class, "FIND_PROJECT", searchCondition);
}
```

## URLとのマッピング

- :ref:`router_adaptor` を使用して業務アクションとURLのマッピングを行う。マッピングには :ref:`Jakarta RESTful Web ServicesのPathアノテーション <router_adaptor_path_annotation>` を使用する。
- `@Path` アノテーションと `@GET` アノテーションを使用して、GETリクエスト時にマッピングする業務アクションメソッドを定義する。

```java
@Path("/projects")
public class ProjectAction {
  @GET
  @Produces(MediaType.APPLICATION_JSON)
  public List<Project> find(JaxRsHttpRequest req) {

      // リクエストパラメータをBeanに変換
      ProjectSearchForm form =
              BeanUtil.createAndCopy(ProjectSearchForm.class, req.getParamMap());

      // BeanValidation実行
      ValidatorUtil.validate(form);

      ProjectSearchDto searchCondition = BeanUtil.createAndCopy(ProjectSearchDto.class, form);
      return UniversalDao.findAllBySqlFile(Project.class, "FIND_PROJECT", searchCondition);
  }
```

<details>
<summary>keywords</summary>

ProjectSearchForm, ProjectSearchDto, ProjectAction, Project, BeanUtil, JaxRsHttpRequest, ValidatorUtil, UniversalDao, MediaType, @Produces, @Path, @GET, @Domain, RESTful検索処理, クエリパラメータ, UniversalDao検索, JSON返却, BeanValidation

</details>
