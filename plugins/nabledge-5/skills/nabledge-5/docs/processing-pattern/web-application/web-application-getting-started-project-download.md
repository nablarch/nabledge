# ファイルダウンロード機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/project_download/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/Csv.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/CsvFormat.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/ObjectMapper.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/download/FileResponse.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html)

## CSVファイルのダウンロードを行う

## ダウンロードボタン（JSP）

ファイルダウンロードメソッドへのGETリクエストを送信するリンクを配置する。

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

## ダウンロード用DTO

**アノテーション**: `@Csv`, `@CsvFormat`

CSVのヘッダとプロパティの紐付けは `@Csv` を使用する。CSVフォーマットの指定は `@CsvFormat` を使用する。デフォルトフォーマット（[data_bind-csv_format_set](../../component/libraries/libraries-data_bind.md)）を使用する場合は `@CsvFormat` 不要。アノテーション設定の詳細は [data_bind-csv_format-beans](../../component/libraries/libraries-data_bind.md) 参照。

```java
@Csv(headers = { /* ヘッダ */ }, properties = { /* プロパティ */ }, type = Csv.CsvType.CUSTOM)
@CsvFormat(charset = "Shift_JIS", fieldSeparator = ',', ignoreEmptyLine = true,
        lineSeparator = "\r\n", quote = '"',
        quoteMode = CsvDataBindConfig.QuoteMode.NORMAL, requiredHeader = true, emptyToNull = true)
public class ProjectDownloadDto implements Serializable { ... }
```

## 業務アクション（ダウンロード処理）

- BeanをCSVファイルに書き出すには `ObjectMapper` を使用（[data_bind](../../component/libraries/libraries-data_bind.md) 提供）
- ダウンロードレスポンスには `FileResponse` を使用（[data_bind-file_download](../../component/libraries/libraries-data_bind.md) 参照）
- 大量データ取得時はメモリ逼迫防止のため `UniversalDao#defer` で遅延ロード（[universal_dao-lazy_load](../../component/libraries/libraries-universal_dao.md)）
- コンテンツタイプは `HttpResponse#setContentType` で設定（[data_format-file_download](../../component/libraries/libraries-data_format.md) 参照）
- ダウンロードファイル名は `HttpResponse#setContentDisposition` で設定（[data_format-file_download](../../component/libraries/libraries-data_format.md) 参照）

```java
@InjectForm(form = ProjectSearchForm.class, prefix = "searchForm", name = "searchForm")
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/project/index.jsp")
public HttpResponse download(HttpRequest request, ExecutionContext context) {
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

ProjectDownloadDto, ProjectSearchForm, ObjectMapper, ObjectMapperFactory, FileResponse, TempFileUtil, DeferredEntityList, UniversalDao, HttpRequest, HttpResponse, ExecutionContext, CsvDataBindConfig, ApplicationException, @Csv, @CsvFormat, @InjectForm, @OnError, CSVファイルダウンロード, 遅延ロード, ファイルレスポンス, データバインド, コンテンツタイプ設定

</details>
