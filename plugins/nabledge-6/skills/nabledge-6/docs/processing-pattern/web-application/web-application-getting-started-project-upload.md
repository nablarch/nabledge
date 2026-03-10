# アップロードを用いた一括登録機能の作成

## 作成する業務アクションメソッドの全体像

**アノテーション**: `@OnDoubleSubmission`, `@OnError`

```java
@OnDoubleSubmission
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/projectUpload/create.jsp")
public HttpResponse upload(HttpRequest request, ExecutionContext context) {
    List<PartInfo> partInfoList = request.getPart("uploadFile");
    if (partInfoList.isEmpty()) {
        throw new ApplicationException(
                MessageUtil.createMessage(MessageLevel.ERROR, "errors.upload"));
    }
    PartInfo partInfo = partInfoList.get(0);
    LoginUserPrincipal userContext = SessionUtil.get(context, "userContext");
    List<Project> projects = readFileAndValidate(partInfo, userContext);
    insertProjects(projects);
    context.setRequestScopedVar("uploadProjectSize", projects.size());
    saveFile(partInfo);
    return new HttpResponse("/WEB-INF/view/projectUpload/create.jsp");
}
```

処理の流れ：

1. ファイルを取得する
2. CSVファイルの内容をBeanにバインドしてバリデーションする
3. DBへ一括登録する
4. ファイルを保存する

## ファイルアップロード機能の実装

## ファイルアップロード画面の作成

- `n:form` の `enctype` 属性を `multipart/form-data` に指定（マルチパートファイル送信に必須）
- `n:file` の `name` 属性に指定した値が、業務アクションで `HttpRequest#getPart` に渡す登録名となる
- `n:message` で完了メッセージを表示。`option0` 属性にリクエストスコープのアップロード件数を指定
- `n:errors` でバリデーションエラーメッセージを一覧表示

```jsp
<n:form useToken="true" enctype="multipart/form-data">
    <c:if test="${not empty uploadProjectSize}">
        <ul><li class="message-info"><n:message messageId="success.upload.project" option0="${uploadProjectSize}" /></li></ul>
    </c:if>
    <n:errors errorCss="message-error"/>
    <n:file name="uploadFile" id="uploadFile"/>
    <n:button uri="/action/projectUpload/upload" allowDoubleSubmission="false" cssClass="btn btn-lg btn-light">登録</n:button>
</n:form>
```

## ファイルの取得と保存を行う業務アクションメソッドの作成

- `HttpRequest#getPart` でファイルを取得
- ファイルが未アップロードの場合、`PartInfo` リストのサイズは0となる。この値で業務例外（`ApplicationException`）を送出するなどの制御を行う
- アップロードファイルはマルチパートリクエストハンドラによって一時領域に保存され、自動削除される。永続化が必要な場合はファイルを任意のディレクトリへ移送する
- ファイルの移送はファイルパス管理を使用している場合のみ可能
- `UploadHelper#moveFileTo` の第一引数には、設定ファイルに登録されたファイル格納ディレクトリのキー名を指定

```java
public HttpResponse upload(HttpRequest request, ExecutionContext context)
        throws IOException {
    List<PartInfo> partInfoList = request.getPart("uploadFile");
    if (partInfoList.isEmpty()) {
        throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "errors.upload"));
    }
    PartInfo partInfo = partInfoList.get(0);
    saveFile(partInfo);
}

private void saveFile(final PartInfo partInfo) {
    String fileName = generateUniqueFileName(partInfo.getFileName());
    UploadHelper helper = new UploadHelper(partInfo);
    helper.moveFileTo("uploadFiles", fileName);
}
```

```xml
<!-- filepath-for-webui.xml -->
<component name="filePathSetting" class="nablarch.core.util.FilePathSetting" autowireType="None">
  <property name="basePathSettings">
    <map>
      <entry key="uploadFiles" value="file:./work/input" />
    </map>
  </property>
</component>
```

## 一括登録機能の実装

## ファイルをバインドするBeanの作成

CSVファイルとBeanプロパティの紐付けは `@Csv` で設定する。CSVフォーマット指定は `@CsvFormat` を使用する（:ref:`デフォルトのフォーマットの指定<data_bind-csv_format_set>` を使用する場合は不要）。詳細は :ref:`CSVファイルをJava Beansクラスにバインドする場合のフォーマット指定方法 <data_bind-csv_format-beans>` を参照。

- ファイルからの入力値を受け付けるため、プロパティは :ref:`String型で定義<bean_validation-form_property>` する。適切な型への変換はバリデーションを通過した安全な値に対して行う
- `@Required` や `@Domain` などのバリデーション用アノテーションを付与して :ref:`Bean Validation<bean_validation>` を実行する
- 行数プロパティのゲッタに `LineNumber` を付与することで、対象データの行番号が自動設定される

> **補足**: 入力必須項目のバリデーションエラーメッセージをファイルアップロード向けのメッセージに変更する場合は :ref:`入力値のチェックルールを設定する<client_create_validation_rule>` を参照。

```java
@Csv(headers = { /** ヘッダを記述 **/},
        properties = { /** バインド対象のプロパティ **/},
        type = Csv.CsvType.CUSTOM)
@CsvFormat(charset = "Shift_JIS", fieldSeparator = ',', ignoreEmptyLine = true,
        lineSeparator = "\r\n", quote = '"',
        quoteMode = CsvDataBindConfig.QuoteMode.NORMAL, requiredHeader = true, emptyToNull = true)
public class ProjectUploadDto implements Serializable {
    @Required(message = "{nablarch.core.validation.ee.Required.upload}")
    @Domain("projectName")
    private String projectName;

    private Long lineNumber;

    @LineNumber
    public Long getLineNumber() {
        return lineNumber;
    }
}
```

## CSVのバインドとバリデーション

ファイルのBeanバインドには :ref:`データバインド<data_bind>` の `ObjectMapper` を使用する。`ObjectMapper#read()` でバインド済みBeanを取得できる。

- `ValidatorUtil#getValidator` で `Validator` オブジェクトを生成し、任意のBeanに :ref:`Bean Validation<bean_validation>` を実行できる
- エラー発生時もバリデーションを中止せず最終行まで検証する場合は、全エラーメッセージを `Message` のリストに収集し、`ApplicationException` を送出することで :ref:`tag-errors_tag` で画面出力できる
- バリデーションメッセージへのプロパティ名付与については :ref:`バリデーションエラー時のメッセージに項目名を含めたい<bean_validation-property_name>` を参照

```java
private List<Project> readFileAndValidate(final PartInfo partInfo, final LoginUserPrincipal userContext) {
    List<Message> messages = new ArrayList<>();
    List<Project> projects = new ArrayList<>();

    try (final ObjectMapper<ProjectUploadDto> mapper
             = ObjectMapperFactory.create(ProjectUploadDto.class, partInfo.getInputStream())) {
        ProjectUploadDto projectUploadDto;
        while ((projectUploadDto = mapper.read()) != null) {
            messages.addAll(validate(projectUploadDto));
            projects.add(createProject(projectUploadDto, userContext.getUserId()));
        }
    } catch (InvalidDataFormatException e) {
        messages.add(
            MessageUtil.createMessage(MessageLevel.ERROR, "errors.upload.format", e.getLineNumber()));
    }

    if (!messages.isEmpty()) {
        throw new ApplicationException(messages);
    }
    return projects;
}
```

`validate()` メソッドでは、アノテーションベースの単項目バリデーションと業務ルールチェックを組み合わせる。`ValidatorUtil.validate()` を try/catch で囲み、`ApplicationException` に含まれる各エラーメッセージを `MessageUtil.createMessage()` で行番号付きのメッセージに変換してリストに追加する。その後、業務ルールチェック（顧客存在チェックなど）の失敗も同じリストに追加して返す。

```java
private List<Message> validate(final ProjectUploadDto projectUploadDto) {
    List<Message> messages = new ArrayList<>();

    // 単項目バリデーション（Bean Validationアノテーションに基づく）
    try {
        ValidatorUtil.validate(projectUploadDto);
    } catch (ApplicationException e) {
        messages.addAll(e.getMessages()
                .stream()
                .map(message -> MessageUtil.createMessage(MessageLevel.ERROR,
                        "errors.upload.validate", projectUploadDto.getLineNumber(), message))
                .collect(Collectors.toList()));
    }

    // 顧客存在チェック（業務ルール）
    if (!existsClient(projectUploadDto)) {
        messages.add(MessageUtil.createMessage(MessageLevel.ERROR,
                "errors.upload.client", projectUploadDto.getLineNumber()));
    }

    return messages;
}
```

## DBへの一括登録

一括登録は `UniversalDao#batchInsert` を使用する。一度に登録する件数が膨大になるとパフォーマンス低下を招くため、1回あたりの件数に上限を設ける（例：100件ごとに実行）。

```java
public HttpResponse upload(HttpRequest request, ExecutionContext context) throws IOException {
    // バリデーションの実行は前述
    insertProjects(projects);
    // ファイル保存は前述
}

private void insertProjects(List<Project> projects) {
    List<Project> insertProjects = new ArrayList<Project>();
    for (Project project : projects) {
        insertProjects.add(project);
        if (insertProjects.size() >= 100) {
            UniversalDao.batchInsert(insertProjects);
            insertProjects.clear();
        }
    }
    if (!insertProjects.isEmpty()) {
        UniversalDao.batchInsert(insertProjects);
    }
}
```
