# 一括更新機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/project_bulk_update/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Required.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Domain.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/validation/Valid.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/persistence/OptimisticLockException.html)

## 一括更新機能の作成

## フォームの作成

複数プロジェクトの一括更新では2種類のフォームを使用する。

**プロジェクト1件分フォーム** (`InnerProjectForm`): 各プロジェクトの更新値を受け付ける。入れ子フォームにも :ref:`Bean Validation<bean_validation>` を実行するため、`@Required` や `@Domain` 等のバリデーションアノテーションを付与する。

```java
public class InnerProjectForm implements Serializable {
    @Required
    @Domain("projectName")
    private String projectName;
    // 他プロパティ省略
}
```

**親フォーム** (`ProjectBulkForm`): `@Valid` を付与することで入れ子フォームも :ref:`Bean Validation<bean_validation>` の対象になる。

```java
public class ProjectBulkForm implements Serializable {
    @Valid
    private List<InnerProjectForm> projectList = new ArrayList<>();
}
```

## セッションストア登録用Bean

**クラス**: `ProjectListDto` — 更新対象リストを一括更新画面・確認画面で持ちまわすため :ref:`セッションストア<session_store>` に登録する。

```java
public class ProjectListDto implements Serializable {
    private List<Project> projectList = new ArrayList<>();
}
```

> **重要**: 配列やコレクション型を :ref:`セッションストア<session_store>` に登録する場合は、Serializableなbeanのプロパティとして定義し、そのbeanをセッションストアに登録すること。詳細は :ref:`セッションストア使用上の制約<session_store-constraint>` を参照。

## 一括更新画面表示アクション

確認画面から戻った際に同条件でページング・再検索できるよう、検索条件を :ref:`セッションストア<session_store>` に登録して持ちまわす。

**アノテーション**: `@InjectForm`, `@OnError`

```java
@InjectForm(form = ProjectSearchForm.class, prefix = "searchForm", name = "searchForm")
@OnError(type = ApplicationException.class, path = "forward://initialize")
public HttpResponse list(HttpRequest request, ExecutionContext context) {
    ProjectSearchForm searchForm = context.getRequestScopedVar("searchForm");
    ProjectSearchDto projectSearchDto = BeanUtil.createAndCopy(ProjectSearchDto.class, searchForm);
    EntityList<Project> projectList = searchProject(projectSearchDto, context);
    ProjectListDto projectListDto = new ProjectListDto();
    projectListDto.setProjectList(projectList);
    SessionUtil.put(context, "projectListDto", projectListDto);
    context.setRequestScopedVar("bulkForm", projectListDto);
    SessionUtil.put(context, "projectSearchDto", projectSearchDto);
    return new HttpResponse("/WEB-INF/view/projectBulk/update.jsp");
}
```

## 一括更新画面JSP

- :ref:`セッションストア<session_store>` に登録したオブジェクトはJSPでリクエストスコープと同様に扱える。
- 配列型・`List` 型プロパティの要素は `プロパティ名[index]` 形式でアクセスする（:ref:`tag-access_rule` 参照）。

```jsp
<n:text name="bulkForm.projectList[${status.index}].projectName"
        maxlength="64" cssClass="form-control form-control-lg" errorCss="input-error"/>
<n:plainHidden name="bulkForm.projectList[${status.index}].projectId"/>
```

## 更新確認アクション

更新情報は :ref:`セッションストア<session_store>` に保持する。

**アノテーション**: `@InjectForm`, `@OnError`

```java
@InjectForm(form = ProjectBulkForm.class, prefix = "bulkForm", name = "bulkForm")
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/projectBulk/update.jsp")
public HttpResponse confirmOfUpdate(HttpRequest request, ExecutionContext context) {
    ProjectBulkForm form = context.getRequestScopedVar("bulkForm");
    ProjectListDto dto = SessionUtil.get(context, "projectListDto");
    final List<InnerProjectForm> innerForms = form.getProjectList();
    dto.getProjectList().forEach(project ->
        innerForms.stream()
            .filter(innerForm -> Objects.equals(innerForm.getProjectId(),
                                               project.getProjectId().toString()))
            .findFirst()
            .ifPresent(innerForm -> BeanUtil.copy(innerForm, project)));
    return new HttpResponse("/WEB-INF/view/projectBulk/confirmOfUpdate.jsp");
}
```

## 確認画面JSP

確認画面では `<n:form useToken="true">` を使用して二重送信防止トークンを設定する。

```jsp
<n:form useToken="true">
    <!-- ボタン部分は省略 -->
</n:form>
```

## 一括更新実行アクション

**アノテーション**: `@OnDoubleSubmission`

```java
@OnDoubleSubmission
public HttpResponse update(HttpRequest request, ExecutionContext context) {
    ProjectListDto projectListDto = SessionUtil.get(context, "projectListDto");
    projectListDto.getProjectList().forEach(UniversalDao::update);
    return new HttpResponse(303, "redirect://completeOfUpdate");
}
```

> **重要**: `UniversalDao#batchUpdate` はバッチ実行用であり排他制御を行わない。排他制御が必要な場合は `UniversalDao#update` を使用すること。排他制御エラー（`OptimisticLockException`）発生時は全件の更新がロールバックされる。

> **Tip**: 独自のエラー制御ハンドラを追加することで、`OptimisticLockException` 発生時に排他制御エラー画面へ遷移させることができる。ハンドラによるエラー制御の作成方法は :ref:`ハンドラで例外クラスに対応したエラーページに遷移させる <forward_error_page-handler>` を参照。

<details>
<summary>keywords</summary>

InnerProjectForm, ProjectBulkForm, ProjectListDto, ProjectBulkAction, ProjectSearchForm, ProjectSearchDto, EntityList, UniversalDao, BeanUtil, SessionUtil, Project, @Valid, @Required, @Domain, @InjectForm, @OnError, @OnDoubleSubmission, ApplicationException, OptimisticLockException, useToken, 一括更新, ネストフォーム, セッションストア, 排他制御, Bean Validation

</details>
