# アップロードを用いた一括登録機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/project_upload/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpRequest.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/upload/PartInfo.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/upload/util/UploadHelper.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/Csv.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/csv/CsvFormat.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Required.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Domain.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/LineNumber.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/databind/ObjectMapper.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/ValidatorUtil.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/javax/validation/Validator.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/ApplicationException.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/Message.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html)

## 作成する業務アクションメソッドの全体像

**アノテーション**: `@OnDoubleSubmission`, `@OnError`

処理の流れ:
1. :ref:`ファイルを取得する<project_upload-file_upload_action>`
2. :ref:`CSVファイルの内容をBeanにバインドしてバリデーションする<project_upload-validation>`
3. :ref:`DBへ一括登録する<project_upload-bulk_insert>`
4. :ref:`ファイルを保存する<project_upload-file_upload_action>`

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

## ファイルの内容をバインドするBeanの作成

**アノテーション**: `@Csv`, `@CsvFormat`, `@Required`, `@Domain`, `@LineNumber`

CSVファイルとBeanプロパティの紐付けには `@Csv` を使用する。CSVフォーマット指定には `@CsvFormat` を使用する。デフォルトフォーマット（[data_bind-csv_format_set](../../component/libraries/libraries-data_bind.md)）を使用する場合は `@CsvFormat` 不要。アノテーション設定の詳細は [data_bind-csv_format-beans](../../component/libraries/libraries-data_bind.md) を参照。

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

- プロパティに `@Required` や `@Domain` などのアノテーションを付与して [bean_validation](../../component/libraries/libraries-bean_validation.md) を行う。
- ファイル入力値はプロパティをString型で定義し（[bean_validation-form_property](../../component/libraries/libraries-bean_validation.md)）、型変換はバリデーション通過後に行う。
- 行数プロパティのゲッタに `LineNumber` を付与することで、対象データの行番号が自動設定される。

> **補足**: 入力必須バリデーションのエラーメッセージをファイルアップロード向けのメッセージに変更可能。:ref:`client_create_validation_rule` を参照。

## CSVファイルのBeanバインドとバリデーション

**クラス**: `ProjectUploadAction`, `PartInfo`, `ObjectMapper`, `ObjectMapperFactory`, `ValidatorUtil`, `MessageUtil`, `Message`, `ApplicationException`, `InvalidDataFormatException`

ファイルをBeanにバインドして取得するには [データバインド](../../component/libraries/libraries-data_bind.md) が提供する `ObjectMapper` を使用する。`ObjectMapper#read` でバインド済みBeanを順次取得する。

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
        // ファイルフォーマットが不正な行がある場合はその時点で解析終了
        messages.add(MessageUtil.createMessage(
            MessageLevel.ERROR, "errors.upload.format", e.getLineNumber()));
    }

    if (!messages.isEmpty()) {
        throw new ApplicationException(messages);
    }
    return projects;
}

private List<Message> validate(final ProjectUploadDto projectUploadDto) {
    List<Message> messages = new ArrayList<>();

    // 単項目バリデーション。Dtoに定義したアノテーションを元にBean Validationを実行する
    try {
        ValidatorUtil.validate(projectUploadDto);
    } catch (ApplicationException e) {
        messages.addAll(e.getMessages()
                .stream()
                .map(message -> MessageUtil.createMessage(MessageLevel.ERROR,
                        "errors.upload.validate", projectUploadDto.getLineNumber(), message))
                .collect(Collectors.toList()));
    }

    // 顧客存在チェック
    if (!existsClient(projectUploadDto)) {
        messages.add(MessageUtil.createMessage(MessageLevel.ERROR,
                "errors.upload.client", projectUploadDto.getLineNumber()));
    }

    return messages;
}
```

- `ValidatorUtil#getValidator` で `Validator` を生成することで任意のBeanに [bean_validation](../../component/libraries/libraries-bean_validation.md) を実行できる。
- 単項目バリデーションエラーは `ApplicationException` をcatchし、`MessageUtil.createMessage` で行番号付きメッセージ（`errors.upload.validate`）に変換して収集する。
- 業務ルール検証（顧客存在チェック等）もバリデーションメソッド内でまとめて実施する。
- バリデーションエラーが発生しても最終行まで検証を継続し、全行分のエラーメッセージを `ApplicationException` にまとめて送出することで [tag-errors_tag](../../component/libraries/libraries-tag_reference.md) で画面出力できる。
- バリデーションメッセージに項目名を付与する方法は [bean_validation-property_name](../../component/libraries/libraries-bean_validation.md) を参照。

## DBへの一括登録

**クラス**: `UniversalDao`

一括登録には `UniversalDao#batchInsert` を使用する。一度に登録する件数が膨大になるとパフォーマンス低下の可能性があるため、1回あたりの件数に上限を設定する（例: 100件ごと）。

```java
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

<details>
<summary>keywords</summary>

ProjectUploadAction, HttpRequest, ExecutionContext, PartInfo, LoginUserPrincipal, ApplicationException, HttpResponse, SessionUtil, MessageUtil, MessageLevel, @OnDoubleSubmission, @OnError, Project, CSVファイルアップロード, 一括登録, 業務アクションメソッド, ファイル取得, バリデーション, ProjectUploadDto, ObjectMapper, ObjectMapperFactory, ValidatorUtil, UniversalDao, InvalidDataFormatException, CsvDataBindConfig, Validator, @Csv, @CsvFormat, @Required, @Domain, @LineNumber, CSVファイル一括登録, ファイルバインド, Bean Validation, batchInsert, アップロード処理

</details>

## ファイルアップロード機能の実装

## ファイルアップロード画面の作成

JSP実装ポイント:
- マルチパートファイル送信のため、[tag-form_tag](../../component/libraries/libraries-tag_reference.md) の `enctype` 属性に `multipart/form-data` を指定する
- [tag-file_tag](../../component/libraries/libraries-tag_reference.md) でファイルアップロード欄を作成。`name` 属性の値が `HttpRequest#getPart` の引数となる
- アップロード完了メッセージは [tag-message_tag](../../component/libraries/libraries-tag_reference.md) で表示。件数は `option0` 属性にリクエストスコープの値を指定する
- [tag-errors_tag](../../component/libraries/libraries-tag_reference.md) でバリデーションエラーメッセージ一覧を表示（:ref:`エラーメッセージの一覧表示 <tag-write_error_errors_tag>` 参照）

```jsp
<n:form useToken="true" enctype="multipart/form-data">
    <n:file name="uploadFile" id="uploadFile"/>
    <n:message messageId="success.upload.project" option0="${uploadProjectSize}" />
    <n:errors errorCss="message-error"/>
    <n:button uri="/action/projectUpload/upload" allowDoubleSubmission="false">登録</n:button>
</n:form>
```

## ファイルの取得と保存

- `HttpRequest#getPart` でファイルを取得する
- 取得した `PartInfo` リストのサイズが0の場合はファイル未アップロード → `ApplicationException` を送出する
- アップロードファイルは [マルチパートリクエストハンドラ](../../component/handlers/handlers-multipart_handler.md) により一時領域に自動保存・自動削除される。永続化が必要な場合は任意のディレクトリへ移送する
- ファイルの移送は [ファイルパス管理](../../component/libraries/libraries-file_path_management.md) を使用している場合のみ可能
- `UploadHelper#moveFileTo` でファイルを移送。第一引数に設定ファイルに登録されたディレクトリのキー名を指定する

```java
private void saveFile(final PartInfo partInfo) {
    String fileName = generateUniqueFileName(partInfo.getFileName());
    UploadHelper helper = new UploadHelper(partInfo);
    helper.moveFileTo("uploadFiles", fileName);
}
```

`FilePathSetting` 設定例（`filepath-for-webui.xml`）:
```xml
<component name="filePathSetting"
        class="nablarch.core.util.FilePathSetting" autowireType="None">
  <property name="basePathSettings">
    <map>
      <entry key="uploadFiles" value="file:./work/input" />
    </map>
  </property>
</component>
```

<details>
<summary>keywords</summary>

PartInfo, UploadHelper, FilePathSetting, HttpRequest, ApplicationException, getPart, moveFileTo, n:file, n:form, マルチパートフォーム, ファイルアップロード画面, ファイル保存, filePathSetting, multipart/form-data

</details>
