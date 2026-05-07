# ファイルダウンロード機能の作成

Exampleアプリケーションを元に、CSVファイルをダウンロードする機能を解説する。

作成する機能の説明

1. プロジェクト一覧画面の、検索結果右横のダウンロードボタンを押下する。

![project_download-list.png](../../../knowledge/assets/web-application-getting-started-project-download/project_download-list.png)

1. 現在の検索結果を出力したCSVファイルがダウンロードされる。

![project_download-download.png](../../../knowledge/assets/web-application-getting-started-project-download/project_download-download.png)

## CSVファイルのダウンロードを行う

CSVファイルをダウンロードする機能の実装方法を解説する。

プロジェクト検索機能の作成方法については、 [検索機能の作成](../../processing-pattern/web-application/web-application-getting-started-project-search.md#検索機能の作成) を参照すること。

1. [ダウンロードボタンの作成](../../processing-pattern/web-application/web-application-getting-started-project-download.md#csvファイルのダウンロードを行う)
2. [ファイルをバインドするBeanの作成](../../processing-pattern/web-application/web-application-getting-started-project-download.md#csvファイルのダウンロードを行う)
3. [業務アクションメソッドの作成](../../processing-pattern/web-application/web-application-getting-started-project-download.md#csvファイルのダウンロードを行う)

ダウンロードボタンの作成

ファイルダウンロードメソッドへのGETリクエストを送信するリンクを配置する。

/src/main/webapp/WEB-INF/view/project/index.jsp

```jsp
<!-- ダウンロードボタン周辺のみ記載 -->
<div style="float:left;">
    <span class="font-group">
    検索結果
    </span>
    <span class="search-result-count">
        <c:if test="${not empty searchResult}">
            <n:write name="searchResult.pagination.resultCount" />
        </c:if>
        <c:if test="${empty searchResult}">
            0
        </c:if>
    </span>
    <!-- 現在の検索条件をパラメータとして設定 -->
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
</div>
```

ファイルをバインドするBeanの作成

ファイルの内容をバインドするBeanを作成する。

ProjectDownloadDto.java

```java
@Csv(headers = { /** ヘッダを記述 **/},
        properties = { /** バインド対象のプロパティ **/},
        type = Csv.CsvType.CUSTOM)
@CsvFormat(charset = "Shift_JIS", fieldSeparator = ',',ignoreEmptyLine = true,
        lineSeparator = "\r\n", quote = '"',
        quoteMode = CsvDataBindConfig.QuoteMode.NORMAL, requiredHeader = true, emptyToNull = true)
public class ProjectDownloadDto implements Serializable {

    // 一部項目のみ抜粋。ゲッタ及びセッタは省略

    /** プロジェクト名 */
    private String projectName;

    /** プロジェクト種別 */
    private String projectType;
}
```

この実装のポイント

* ダウンロードするCSVファイルの内容と、Beanのプロパティとの紐付けの設定は、 @Csv を使用する。
  受け付けるCSVのフォーマットの指定は、 @CsvFormat を使用する。
  （ [デフォルトのフォーマットの指定](../../component/libraries/libraries-data-bind.md#csvファイルのフォーマットとして指定できるフォーマットセット) を使用する場合は、 @CsvFormat は不要）
  アノテーションの設定方法の詳細は、 [CSVファイルをJava Beansクラスにバインドする場合のフォーマット指定方法](../../component/libraries/libraries-data-bind.md#csvファイルのフォーマットを指定する) を参照。

業務アクションメソッドの作成

検索結果をCSVファイルに書きこむ業務アクションメソッドを作成する。

ProjectAction.java

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

この実装のポイント

* 検索処理の実装方法については  [検索機能の作成：業務アクションの実装](../../processing-pattern/web-application/web-application-getting-started-project-search.md#検索する) を参照。
* Beanをファイルにバインドして出力するには、 [データバインド](../../component/libraries/libraries-data-bind.md#データバインド) が提供する、
  ObjectMapper を使用する。
* ファイルに出力されたデータをダウンロードさせるには、 FileResponse を使用する。
  詳細は、 [データバインドをダウンロードで使用する](../../component/libraries/libraries-data-bind.md#ファイルダウンロードで使用する) を参照。
* 大量のデータを読み込む場合は、メモリの逼迫を防ぐために UniversalDao#defer を使用して、
  検索結果を [遅延ロード](../../component/libraries/libraries-universal-dao.md#検索結果を遅延ロードする) する。
* レスポンスのコンテンツタイプは
  HttpResponse#setContentType を使用して設定する。
  詳細は [汎用データフォーマットをダウンロードで使用する](../../component/libraries/libraries-data-format.md#ファイルダウンロードで使用する) を参照。
* ダウンロードファイルのファイル名は
  HttpResponse#setContentDisposition を使用して設定する。
  詳細は [汎用データフォーマットをダウンロードで使用する](../../component/libraries/libraries-data-format.md#ファイルダウンロードで使用する) を参照。

ファイルダウンロード機能の解説は以上。

[Getting Started TOPページへ](../../processing-pattern/web-application/web-application-getting-started.md#getting-started)
