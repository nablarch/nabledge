# 一括更新機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/project_bulk_update/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Required.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Domain.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/javax/validation/Valid.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/javax/persistence/OptimisticLockException.html)

## 一括更新機能の作成

## 一括更新機能の作成

### 機能概要

一括更新画面では、当該ページで表示されているプロジェクトの更新項目を書き換えて更新ボタンを押下する。**ページをまたいだ更新はできない**ことに注意。

### フォームの作成

複数プロジェクトの更新情報を一括送信するため、2種類のフォームを作成する。

**InnerProjectForm.java**（プロジェクト1つ分の更新情報）:
```java
public class InnerProjectForm implements Serializable {
    @Required
    @Domain("projectName")
    private String projectName;
    // ゲッタ及びセッタは省略
}
```

入れ子となったフォームに対しても [Bean Validation](../../component/libraries/libraries-bean_validation.md) を実行するため、`@Required` や `@Domain` などのバリデーション用アノテーションを付与する。

**ProjectBulkForm.java**（親フォーム）:
```java
public class ProjectBulkForm implements Serializable {
    @Valid
    private List<InnerProjectForm> projectList = new ArrayList<>();
    // ゲッタ及びセッタは省略
}
```

`@Valid` を付与することで、入れ子フォームも [Bean Validation](../../component/libraries/libraries-bean_validation.md) の対象に含まれる。

### 更新対象リストを画面へ受け渡すBeanの作成

**ProjectListDto.java**（一括更新画面・確認画面で :ref:`セッションストア <session_store>` に登録して持ちまわすBean）:
```java
public class ProjectListDto implements Serializable {
    private List<Project> projectList = new ArrayList<>();
    // ゲッタ及びセッタは省略
}
```

> **重要**: 配列やコレクション型を :ref:`セッションストア <session_store>` に登録する場合は、シリアライズ可能なBeanのプロパティとして定義し、そのBeanを :ref:`セッションストア <session_store>` に登録すること。詳細は [セッションストア使用上の制約](../../component/libraries/libraries-session_store.md) を参照。

### 一括更新画面を表示する業務アクションメソッド

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
    // 確認画面から戻った際に同条件で再検索・ページングできるよう検索条件も保存
    SessionUtil.put(context, "projectSearchDto", projectSearchDto);
    return new HttpResponse("/WEB-INF/view/projectBulk/update.jsp");
}
```

### 一括更新画面JSPの実装ポイント

- :ref:`セッションストア <session_store>` に登録したオブジェクトは、リクエストスコープに登録したオブジェクトと同様にJSPから参照できる。
- 配列型またはList型プロパティの要素は `プロパティ名[index]` 形式でアクセスする（詳細: :ref:`tag-access_rule`）。

```jsp
<n:text name="bulkForm.projectList[${status.index}].projectName"
        maxlength="64" cssClass="form-control" errorCss="input-error input-text"/>
<n:error errorCss="message-error"
        name="bulkForm.projectList[${status.index}].projectName" />
```

### 更新内容を確認する業務アクションメソッド

```java
@InjectForm(form = ProjectBulkForm.class, prefix = "bulkForm", name = "bulkForm")
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/projectBulk/update.jsp")
public HttpResponse confirmOfUpdate(HttpRequest request, ExecutionContext context) {
    ProjectBulkForm form = context.getRequestScopedVar("bulkForm");
    ProjectListDto dto = SessionUtil.get(context, "projectListDto");
    final List<InnerProjectForm> innerForms = form.getProjectList();
    dto.getProjectList()
       .forEach(project ->
               innerForms.stream()
                         .filter(innerForm -> Objects.equals(innerForm.getProjectId(),
                                 project.getProjectId().toString()))
                         .findFirst()
                         .ifPresent(innerForm -> BeanUtil.copy(innerForm, project)));
    return new HttpResponse("/WEB-INF/view/projectBulk/confirmOfUpdate.jsp");
}
```

更新する情報は :ref:`セッションストア <session_store>` に保持する。

### 確認画面JSPの実装ポイント

```jsp
<n:form useToken="true">
  <!-- ボタン部分は省略 -->
</n:form>
```

### データベースを一括更新する業務アクションメソッド

```java
@OnDoubleSubmission
public HttpResponse update(HttpRequest request, ExecutionContext context) {
    ProjectListDto projectListDto = SessionUtil.get(context, "projectListDto");
    projectListDto.getProjectList().forEach(UniversalDao::update);
    return new HttpResponse(303, "redirect://completeOfUpdate");
}
```

- `UniversalDao#update` を更新件数分実行する。排他制御エラーが発生した場合は全件の更新がロールバックされる。
- `UniversalDao#batchUpdate` は [バッチ実行](../../component/libraries/libraries-universal_dao.md) での使用を想定したものであり排他制御を行わない。排他制御が必要な場合は `UniversalDao#update` を使用すること。

> **補足**: `OptimisticLockException` が発生した場合、独自エラーハンドラを追加することで排他制御エラー画面へ遷移させることができる。詳細は [forward_error_page-handler](web-application-forward_error_page.md) 参照。

<details>
<summary>keywords</summary>

InnerProjectForm, ProjectBulkForm, ProjectListDto, ProjectBulkAction, ProjectSearchForm, ProjectSearchDto, UniversalDao, SessionUtil, BeanUtil, EntityList, @Valid, @Required, @Domain, @InjectForm, @OnError, @OnDoubleSubmission, OptimisticLockException, 一括更新, セッションストア, 入れ子フォーム, Bean Validation, 排他制御, List型プロパティのインデックスアクセス, useToken, 二重送信防止, ページをまたいだ更新

</details>
