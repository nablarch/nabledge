# 検索機能の作成

## 検索する

**フォームの作成**

**クラス**: `ProjectSearchForm extends SearchFormBase`
**アノテーション**: `@Domain`

- 入力値を受け付けるプロパティは全てString型で宣言する（:ref:`バリデーションルールの設定方法 <bean_validation-form_property>` 参照）

```java
public class ProjectSearchForm extends SearchFormBase implements Serializable {
    @Domain("projectName")
    private String projectName;

    @Domain("date")
    private String projectStartDateBegin;
}
```

**検索条件入力JSP（GETフォーム）**

- GETリクエストで送信する場合は :ref:`tag-form_tag` の `method` 属性に `GET` を指定する
- GETの場合、ボタン・リンクにカスタムタグを使用できないため、HTMLで作成する（:ref:`tag-using_get` 参照）

```jsp
<n:form method="GET" action="list">
    <n:text name="searchForm.projectName" size="25" maxlength="64" />
    <n:error name="searchForm.projectName" />
    <input type="submit" id="search" value="検索" />
</n:form>
```

**検索条件Bean**

**クラス**: `ProjectSearchDto`

- `BeanUtil` でフォームから検索条件Beanに値を移送する。プロパティ名が同一の項目を移送するため、フォームとBeanのプロパティ名を一致させる必要がある
- 互換性のある型であれば型変換して移送できる（:ref:`BeanUtilの型変換ルール<utility-conversion>` 参照）
- Beanのプロパティは対応するDBカラムの型に合わせたJavaの型で定義する（:ref:`universal_dao-search_with_condition` 参照）

```java
public class ProjectSearchDto implements Serializable {
    private String projectName;
    private java.sql.Date projectStartDateBegin;
}
```

**検索SQL**

- SQLインジェクション防止のため、SQLは外部ファイルに記述する（:ref:`database-use_sql_file` 参照）
- Beanのプロパティ名でSQLに値をバインドする（:ref:`database-input_bean` 参照）
- 入力された項目のみを条件とする場合は `$if` 構文を使用する（:ref:`database-use_variable_condition` 参照）
- ソートキーを画面から選択可能とする場合は `$sort` 構文を使用する（:ref:`database-make_order_by` 参照）

```sql
SEARCH_PROJECT =
SELECT
    PROJECT_ID,
    PROJECT_NAME,
    PROJECT_TYPE,
    PROJECT_CLASS,
    PROJECT_START_DATE,
    PROJECT_END_DATE,
    VERSION
FROM
    PROJECT
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

**業務アクションの実装**

**アノテーション**: `@InjectForm`, `@OnError`

- 外部からの入力値はバリデーションのため `InjectForm` を付与する
- `InjectForm` によるバリデーション済みのフォームはリクエストスコープから取り出せる
- `BeanUtil` でフォームの値を検索条件Beanにコピーする
- `UniversalDao#findAllBySqlFile` の第二引数に :ref:`SQLID <database-execute_sqlid>` を指定してSQL検索を実行する
- ページング検索は `UniversalDao#page` と `UniversalDao#per` を使用する（:ref:`universal_dao-paging` 参照）

```java
@InjectForm(form = ProjectSearchForm.class, prefix = "searchForm", name = "searchForm")
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/project/index.jsp")
public HttpResponse list(HttpRequest request, ExecutionContext context) {
    ProjectSearchForm searchForm = context.getRequestScopedVar("searchForm");
    ProjectSearchDto searchCondition =
            BeanUtil.createAndCopy(ProjectSearchDto.class, searchForm);
    List<Project> searchList = searchProject(searchCondition, context);
    context.setRequestScopedVar("searchResult", searchList);
    return new HttpResponse("/WEB-INF/view/project/index.jsp");
}

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

**検索結果の表示**

- GETリクエストのURLにパラメータを含める場合はJSTLの `<c:url>` タグやEL式を使用する
- Exampleアプリケーションでは、ルーティングを以下のように設定しているため、末尾にプロジェクトIDを付与したURLが `ProjectAction#show` に紐づけられる。そのため `<n:a href="show/${row.projectId}">` のようにEL式でプロジェクトIDをURLに付与できる（詳細は [ライブラリのREADMEドキュメント](https://github.com/kawasima/http-request-router/blob/master/README.ja.md) 参照）

```xml
<routes>
    <match path="/action/:controller/:action/:projectId">
        <requirements>
            <requirement name="projectId" value="\d+$" />
        </requirements>
    </match>
    <!-- その他の設定は省略 -->
</routes>
```

- 値の出力には :ref:`tag-write_tag` を使用する。日付・金額等をフォーマットする場合は `valueFormat` 属性で形式を指定する（:ref:`tag-format_value` 参照）
- `<app:listSearchResult>` の使用方法は :ref:`list_search_result` 参照

```jsp
<app:listSearchResult>
    <jsp:attribute name="headerRowFragment">
        <tr>
            <th>プロジェクトID</th>
            <th>プロジェクト名</th>
            <th>プロジェクト種別</th>
            <th>開始日</th>
            <th>終了日</th>
        </tr>
    </jsp:attribute>
    <jsp:attribute name="bodyRowFragment">
        <tr class="info">
            <td>
                <n:a href="show/${row.projectId}">
                    <n:write name="row.projectId"/>
                </n:a>
            </td>
            <td>
                <n:write name="row.projectName" />
            </td>
            <td>
                <n:write name="row.projectStartDate" valueFormat="dateTime{yyyy/MM/dd}"/>
            </td>
        </tr>
    </jsp:attribute>
</app:listSearchResult>
```
