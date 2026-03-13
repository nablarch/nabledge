# 検索機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/project_search/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/interceptor/InjectForm.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html)

## 検索する

### フォームの作成

**クラス**: `ProjectSearchForm extends SearchFormBase implements Serializable`

入力値プロパティは全てString型で宣言する（[bean_validation-form_property](../../component/libraries/libraries-bean_validation.md) 参照）。ドメインバリデーションには `@Domain` アノテーションを使用する。

```java
@Domain("projectName")
private String projectName;

@Domain("date")
private String projectStartDateBegin;
```

### 検索条件入力JSPの作成

GETリクエストには [tag-form_tag](../../component/libraries/libraries-tag_reference.md) の`method`属性に`GET`を指定する。GETの場合、ボタン/リンクにNablarchカスタムタグは使用できないためHTMLで作成する（:ref:`tag-using_get` 参照）。

```jsp
<n:form method="GET" action="list">
    <n:text id="projectName" name="searchForm.projectName" size="25" maxlength="64"
            cssClass="form-control" errorCss="input-error form-control" placeholder="プロジェクト名"/>
    <n:error errorCss="message-error" name="searchForm.projectName" />
    <input type="submit" value="検索" />
</n:form>
```

### 検索条件Beanの作成

**クラス**: `ProjectSearchDto implements Serializable`

フォームから検索条件Beanへの値移送には `BeanUtil` を使用する。プロパティ名が同一の項目を移送するため、フォームと検索条件Beanのプロパティ名を一致させる必要がある。型互換があれば型変換した上で移送可能（[utility-conversion](../../component/libraries/libraries-bean_util.md) 参照）。Beanのプロパティはカラムの型に合わせたJava型で定義する（例: `java.sql.Date`）。

### 検索SQLの作成

SQLインジェクション防止のためSQLは外部ファイルに記述する（[database-use_sql_file](../../component/libraries/libraries-database.md) 参照）。Beanのプロパティ名でSQLに値をバインドする（[database-input_bean](../../component/libraries/libraries-database.md) 参照）。

- 入力された項目のみをWHERE句に含める場合: [$if構文を使用](../../component/libraries/libraries-database.md)
- ソートキーを画面から選択可能とする場合: [$sort構文を使用](../../component/libraries/libraries-database.md)

```sql
SEARCH_PROJECT =
SELECT PROJECT_ID, PROJECT_NAME, PROJECT_TYPE, PROJECT_CLASS,
       PROJECT_START_DATE, PROJECT_END_DATE, VERSION
FROM PROJECT
WHERE
    USER_ID = :userId
    AND $if(clientId)     {CLIENT_ID = :clientId}
    AND $if(projectName) {PROJECT_NAME LIKE  :%projectName%}
    AND $if(projectType) {PROJECT_TYPE = :projectType}
    AND $if(projectClass) {PROJECT_CLASS IN (:projectClass[])}
    AND $if(projectStartDateBegin) {PROJECT_START_DATE >= :projectStartDateBegin}
    AND $if(projectStartDateEnd) {PROJECT_START_DATE <= :projectStartDateEnd}
    AND $if(projectEndDateBegin) {PROJECT_END_DATE >= :projectEndDateBegin}
    AND $if(projectEndDateEnd) {PROJECT_END_DATE <= :projectEndDateEnd}
$sort(sortId){
    (idAsc PROJECT_ID)
    (idDesc PROJECT_ID DESC)
    (nameAsc PROJECT_NAME, PROJECT_ID)
    (nameDesc PROJECT_NAME DESC, PROJECT_ID DESC)
    (startDateAsc PROJECT_START_DATE, PROJECT_ID)
    (startDateDesc PROJECT_START_DATE DESC, PROJECT_ID DESC)
    (endDateAsc PROJECT_END_DATE, PROJECT_ID)
    (endDateDesc PROJECT_END_DATE DESC, PROJECT_ID DESC)
}
```

### 業務アクションの実装

**アノテーション**: `@InjectForm`, `@OnError`

外部入力値のため `InjectForm` でバリデーション必須。バリデーション済みフォームはリクエストスコープから取得する。`BeanUtil` でフォームの値を検索条件Beanにコピーする。

```java
@InjectForm(form = ProjectSearchForm.class, prefix = "searchForm", name = "searchForm")
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/project/index.jsp")
public HttpResponse list(HttpRequest request, ExecutionContext context) {
    ProjectSearchForm searchForm = context.getRequestScopedVar("searchForm");
    ProjectSearchDto searchCondition = BeanUtil.createAndCopy(ProjectSearchDto.class, searchForm);
    List<Project> searchList = searchProject(searchCondition, context);
    context.setRequestScopedVar("searchResult", searchList);
    return new HttpResponse("/WEB-INF/view/project/index.jsp");
}
```

`UniversalDao#findAllBySqlFile` の第二引数にSQLID（例: `"SEARCH_PROJECT"`）を指定する。ページング検索は `UniversalDao#per` と `UniversalDao#page` を使用する（[universal_dao-paging](../../component/libraries/libraries-universal_dao.md) 参照）。セッションからログインユーザーコンテキストを取得し、検索条件Beanの`userId`に設定する（`USER_ID = :userId`は必須条件のため必須）。

```java
private List<Project> searchProject(ProjectSearchDto searchCondition,
                                    ExecutionContext context) {
    LoginUserPrincipal userContext = SessionUtil.get(context, "userContext");
    searchCondition.setUserId(userContext.getUserId());
    return UniversalDao
        .page(searchCondition.getPageNumber())
        .per(20L)
        .findAllBySqlFile(Project.class, "SEARCH_PROJECT", searchCondition);
}
```

### 検索結果JSPの作成

GETリクエストのURLにパラメータを付与する場合はJSTLの`<c:url>`タグやEL式を使用する。値の出力には [tag-write_tag](../../component/libraries/libraries-tag_reference.md) を使用し、`valueFormat`属性で日付等のフォーマットを指定できる（:ref:`tag-format_value` 参照）。`<app:listSearchResult>`の使用方法は [list_search_result](../../guide/biz-samples/biz-samples-03.md) を参照。

```jsp
<n:write name="row.projectStartDate" valueFormat="dateTime{yyyy/MM/dd}"/>
```

<details>
<summary>keywords</summary>

ProjectSearchForm, SearchFormBase, ProjectSearchDto, BeanUtil, InjectForm, UniversalDao, @InjectForm, @OnError, @Domain, ApplicationException, LoginUserPrincipal, SessionUtil, プロジェクト検索, 検索条件フォーム, UniversalDao検索, ページング, 動的SQL, $if構文, $sort構文, ドメインバリデーション

</details>
