# 検索機能の作成

Exampleアプリケーションを元に、検索機能を解説する。

作成する機能の説明
本機能は、GETリクエスト時にクエリパラメータに検索条件を付与することで、
条件に合致するプロジェクト情報をJSON形式で返却する。

検索条件として、 `顧客ID(完全一致)`  、 `プロジェクト名(部分一致)` を指定できる。
検索条件を指定しない場合は、全てのプロジェクト情報を返却する。
動作確認手順
1. プロジェクト情報の検索

ここでは、顧客IDが 1 のプロジェクト情報を検索する。

任意のRESTクライアントを使用して、以下のリクエストを送信する。

URL
[http://localhost:9080/projects?clientId=1](http://localhost:9080/projects?clientId=1)
HTTPメソッド
GET

1. 検索結果の確認

1.を実行した結果、以下のようなJSON形式のレスポンスが返却されることを確認する。

```javascript
[{
    "projectId":1,
    "projectName":"プロジェクト００１",
    "projectType":"development",

    // 省略

}]
```

## プロジェクト情報を検索する

フォームの作成
クライアントから送信された値を受け付けるフォームを作成する。

ProjectSearchForm.java
```java
public class ProjectSearchForm implements Serializable {

    /** 顧客ID */
    @Domain("id")
    private String clientId;

    /** プロジェクト名 */
    @Domain("projectName")
    private String projectName;

    // ゲッタ及びセッタは省略
}
```
この実装のポイント
* プロパティは全てString型で宣言する。詳細は [バリデーションルールの設定方法](../../component/libraries/libraries-bean-validation.md#bean-validation-form-property) を参照。
検索条件を保持するBeanの作成
検索条件を保持するBeanを作成する。

ProjectSearchDto.java
```java
public class ProjectSearchDto implements Serializable {

    /** 顧客ID */
    private Integer clientId;

    /** プロジェクト名 */
    private String projectName;

    // ゲッタ及びセッタは省略
```
この実装のポイント
* Beanのプロパティは、[対応する条件カラムの定義(型)と互換性のある型とする](../../component/libraries/libraries-universal-dao.md#universal-dao-search-with-condition) こと。
検索に使用するSQLの作成
検索に使用するSQLを作成する。

Project.sql
```none
FIND_PROJECT =
SELECT
    *
FROM
    PROJECT
WHERE
    $if(clientId) {CLIENT_ID = :clientId}
    AND $if(projectName) {PROJECT_NAME LIKE :%projectName%}
```
この実装のポイント
* SQLインジェクションを防ぐため、SQLは外部ファイルに記述する。詳細は [SQLをファイルで管理する](../../component/libraries/libraries-database.md#database-use-sql-file) を参照。
* Beanのプロパティ名を使って、SQLに値をバインドする。詳細は [Beanオブジェクトを入力としてSQLを実行する](../../component/libraries/libraries-database.md#database-input-bean) を参照。
* 検索条件として指定された項目のみを条件に含める場合には、 [$if 構文を使用してSQL文を構築](../../component/libraries/libraries-database.md#database-use-variable-condition) する。
業務アクションメソッドの実装
検索条件をもとにデータベースから検索する処理を実装する。

ProjectAction.java
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
この実装のポイント
* 検索結果をJSON形式でクライアントに返却するため、 Produces アノテーションに
  `MediaType.APPLICATION_JSON` を指定する。
* クエリパラメータは JaxRsHttpRequest から取得する。
* BeanUtil を使用してリクエストパラメータからフォームを作成する。
* ValidatorUtil#validate
  を使用してフォームのバリデーションを行う。
* フォームの値を BeanUtil を使用して検索条件Beanにコピーする。
* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#universal-dao) を使用して取得したプロジェクト情報のリストを戻り値として返却する。
* 戻り値のオブジェクトは [リクエストボディ変換ハンドラ](../../component/handlers/handlers-body-convert-handler.md#body-convert-handler) によってJSON形式に変換されるため、
  業務アクションメソッド内で変換処理を実装する必要はない。
URLとのマッピングを定義
[ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#router-adaptor) を使用して、業務アクションとURLのマッピングを行う。
マッピングには [JAX-RSのPathアノテーション](../../component/adapters/adapters-router-adaptor.md#router-adaptor-path-annotation) を使用する。

ProjectAction.java
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
この実装のポイント
* `@Path` アノテーションと `@GET` アノテーションを使用して、GETリクエスト時にマッピングする業務アクションメソッドを定義する。
