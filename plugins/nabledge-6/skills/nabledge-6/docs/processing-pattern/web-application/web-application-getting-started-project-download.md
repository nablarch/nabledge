# ファイルダウンロード機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/project_download/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/Csv.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/CsvFormat.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/ObjectMapper.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/download/FileResponse.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html)

## CSVファイルのダウンロードを行う

### ダウンロードボタンの作成

ファイルダウンロードアクション (`/action/project/download`) へのGETリクエストリンクを配置し、現在の検索条件をクエリパラメータとして渡す。

```jsp
<c:url value="/action/project/download" var="download_uri">
    <c:param name="searchForm.clientId" value="${searchForm.clientId}"/>
    <c:param name="searchForm.clientName" value="${searchForm.clientName}"/>
    <c:param name="searchForm.projectName" value="${searchForm.projectName}"/>
    <c:param name="searchForm.projectType" value="${searchForm.projectType}"/>
    <c:forEach items="${searchForm.projectClass}" var="projectClass">
        <c:param name="searchForm.projectClass" value="${projectClass}" />
    </c:forEach>
    <c:param name="searchForm.projectStartDateBegin" value="${searchForm.projectStartDateBegin}"/>
    <c:param name="searchForm.projectStartDateEnd" value="${searchForm.projectStartDateEnd}"/>
    <c:param name="searchForm.projectEndDateBegin" value="${searchForm.projectEndDateBegin}"/>
    <c:param name="searchForm.projectEndDateEnd" value="${searchForm.projectEndDateEnd}"/>
    <c:param name="searchForm.sortKey" value="${searchForm.sortKey}"/>
    <c:param name="searchForm.sortDir" value="${searchForm.sortDir}"/>
    <c:param name="searchForm.pageNumber" value="${searchForm.pageNumber}"/>
</c:url>
<n:a href="${download_uri}">
    <n:write name="label" />
    <n:img src="/images/download.png" alt="ダウンロード" />
</n:a>
```

### ファイルをバインドするBeanの作成

**アノテーション**: `@Csv`, `@CsvFormat`

- CSVヘッダーとBeanプロパティの紐付けには `@Csv` を使用する。
- CSVフォーマット指定には `@CsvFormat` を使用する。:ref:`デフォルトフォーマット<data_bind-csv_format_set>` を使用する場合は `@CsvFormat` は不要。
- アノテーション設定の詳細は :ref:`data_bind-csv_format-beans` を参照。

```java
@Csv(headers = { /** ヘッダを記述 **/},
        properties = { /** バインド対象のプロパティ **/},
        type = Csv.CsvType.CUSTOM)
@CsvFormat(charset = "Shift_JIS", fieldSeparator = ',', ignoreEmptyLine = true,
        lineSeparator = "\r\n", quote = '"',
        quoteMode = CsvDataBindConfig.QuoteMode.NORMAL, requiredHeader = true, emptyToNull = true)
public class ProjectDownloadDto implements Serializable {
    private String projectName;
    private String projectType;
}
```

### 業務アクションメソッドの作成

**クラス**: `FileResponse`, `ObjectMapper`, `ObjectMapperFactory`, `TempFileUtil`, `DeferredEntityList`, `UniversalDao`  
**アノテーション**: `@InjectForm`, `@OnError`

- BeanをCSVファイルに出力するには :ref:`データバインド<data_bind>` の `ObjectMapper` を使用する。
- ファイルをダウンロードレスポンスとして返すには `FileResponse` を使用する（詳細: :ref:`data_bind-file_download`）。
- 大量データ取得時はメモリ逼迫防止のため `UniversalDao#defer` で :ref:`遅延ロード<universal_dao-lazy_load>` する。
- レスポンスのContent-Typeは `HttpResponse#setContentType` で設定する（詳細: :ref:`data_format-file_download`）。
- ダウンロードファイル名は `HttpResponse#setContentDisposition` で設定する（詳細: :ref:`data_format-file_download`）。

```java
@InjectForm(form = ProjectSearchForm.class, prefix = "searchForm", name = "searchForm")
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/project/index.jsp")
public HttpResponse download(HttpRequest request, ExecutionContext context) {
    ProjectSearchForm searchForm = context.getRequestScopedVar("searchForm");
    ProjectSearchDto searchCondition = BeanUtil.createAndCopy(ProjectSearchDto.class, searchForm);
    LoginUserPrincipal userContext = SessionUtil.get(context, "userContext");
    searchCondition.setUserId(userContext.getUserId());

    final Path path = TempFileUtil.createTempFile();
    try (DeferredEntityList<ProjectDownloadDto> searchList = (DeferredEntityList<ProjectDownloadDto>) UniversalDao
                .defer()
                .findAllBySqlFile(ProjectDownloadDto.class, "SEARCH_PROJECT", searchCondition);
         ObjectMapper<ProjectDownloadDto> mapper = ObjectMapperFactory.create(ProjectDownloadDto.class,
                TempFileUtil.newOutputStream(path))) {
        for (ProjectDownloadDto dto : searchList) {
            mapper.write(dto);
        }
    }

    FileResponse response = new FileResponse(path.toFile(), true);
    response.setContentType("text/csv; charset=Shift_JIS");
    response.setContentDisposition("プロジェクト一覧.csv");
    return response;
}
```

<details>
<summary>keywords</summary>

CSVファイルダウンロード, ファイルダウンロード, データバインド, 遅延ロード, Content-Disposition, FileResponse, ObjectMapper, ObjectMapperFactory, TempFileUtil, DeferredEntityList, UniversalDao, ProjectDownloadDto, @Csv, @CsvFormat, @InjectForm, @OnError, BeanUtil, HttpResponse, HttpRequest, ExecutionContext, CsvDataBindConfig, LoginUserPrincipal, SessionUtil, ProjectSearchForm, ProjectSearchDto, ApplicationException

</details>
