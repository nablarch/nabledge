# 一括更新機能の作成

Exampleアプリケーションを元に一括更新機能を解説する。

作成する機能の説明
1. メニューの一括更新リンクを押下し、一括更新画面へ遷移する。

![project_bulk_update-menu.png](../../../knowledge/assets/web-application-getting-started-project-bulk-update/project_bulk_update-menu.png)

1. プロジェクト全件検索の結果が表示される。

![project_bulk_update-list.png](../../../knowledge/assets/web-application-getting-started-project-bulk-update/project_bulk_update-list.png)

1. 当該ページで更新する項目を書き換えて、更新ボタンを押下する(ページをまたいだ更新はできない)。

![project_bulk_update-list_changed.png](../../../knowledge/assets/web-application-getting-started-project-bulk-update/project_bulk_update-list_changed.png)

1. 更新確認画面が表示されるので、確定ボタンを押下する。

![project_bulk_update-confirm.png](../../../knowledge/assets/web-application-getting-started-project-bulk-update/project_bulk_update-confirm.png)

1. データベースが更新され、更新完了画面が表示される。

![project_bulk_update-complete.png](../../../knowledge/assets/web-application-getting-started-project-bulk-update/project_bulk_update-complete.png)

## 一括更新機能の作成

一括更新機能の作成方法を解説する。

1. [フォームの作成](../../processing-pattern/web-application/web-application-getting-started-project-bulk-update.md#project-bulk-update-create-form)
2. [画面に更新対象を受け渡すBeanの作成](../../processing-pattern/web-application/web-application-getting-started-project-bulk-update.md#project-bulk-update-create-bean)
3. [一括更新画面を表示する業務アクションメソッドの作成](../../processing-pattern/web-application/web-application-getting-started-project-bulk-update.md#project-bulk-update-action-list)
4. [一括更新画面JSPの作成](../../processing-pattern/web-application/web-application-getting-started-project-bulk-update.md#project-bulk-update-update-jsp)
5. [更新内容を確認する業務アクションメソッドの作成](../../processing-pattern/web-application/web-application-getting-started-project-bulk-update.md#project-bulk-update-confirm-action)
6. [確認画面JSPの作成](../../processing-pattern/web-application/web-application-getting-started-project-bulk-update.md#project-bulk-update-confirm-jsp)
7. [データベースを一括更新する業務アクションメソッドの作成](../../processing-pattern/web-application/web-application-getting-started-project-bulk-update.md#project-bulk-update-bulk-update)
8. [完了画面の作成](../../processing-pattern/web-application/web-application-getting-started-project-bulk-update.md#project-bulk-update-complete-jsp)

フォームの作成
検索条件を受け付けるフォームと、更新内容を受け付けるフォームをそれぞれ作成する。

検索フォームの作成
検索フォームの実装は、 [検索機能の作成：フォームの作成](../../processing-pattern/web-application/web-application-getting-started-project-search.md#project-search-create-form) と同様であるためそちらを参照。
更新フォームの作成
複数のプロジェクトの更新情報を一括で送信するため、フォームを2種類作成する。

1. [プロジェクト１つ分の更新情報を受け付けるフォーム](../../processing-pattern/web-application/web-application-getting-started-project-bulk-update.md#project-bulk-update-create-single-pj-form)
2. [プロジェクト１つ分のフォームのリストをプロパティとして持つ親フォーム](../../processing-pattern/web-application/web-application-getting-started-project-bulk-update.md#project-bulk-update-create-multi-pj-form)

![project_bulk_update-form.png](../../../knowledge/assets/web-application-getting-started-project-bulk-update/project_bulk_update-form.png)

プロジェクト１つ分の更新情報を受け付けるフォーム
プロジェクト１つ分の更新値を受け付けるフォームを作成する。

InnerProjectForm.java
```java
public class InnerProjectForm implements Serializable {

    // 一部項目のみ抜粋

    /** プロジェクト名 */
    @Required
    @Domain("projectName")
    private String projectName;

    // ゲッタ及びセッタは省略
}
```

この実装のポイント
* 入れ子となったフォームに対しても  [Bean Validation](../../component/libraries/libraries-bean-validation.md#bean-validation) を実行するため、
  @Required や @Domain
  などのバリデーション用のアノテーションを付与する。

プロジェクト１つ分のフォームのリストをプロパティとして持つ親フォーム
複数プロジェクトの更新情報を一括で受け付けるために、プロジェクト１つ分の更新情報を受け付けるフォームのリストを定義した親フォームを作成する。

ProjectBulkForm.java
```java
public class ProjectBulkForm implements Serializable {

    /** プロジェクト情報のリスト */
    @Valid
    private List<InnerProjectForm> projectList = new ArrayList<>();

    // ゲッタ及びセッタは省略
}
```
この実装のポイント
* @Valid を付与することで、入れ子としたフォームも [Bean Validation](../../component/libraries/libraries-bean-validation.md#bean-validation) の対象に含めることができる。

業務アクションで取得した更新対象リストを画面へ受け渡すBeanの作成
業務アクションで取得した更新対象リストを画面へ受け渡すBeanを作成する。このBeanは一括更新画面と確認画面で持ちまわすため、 [セッションストア](../../component/libraries/libraries-session-store.md#session-store) に登録する。

ProjectListDto.java
```java
public class ProjectListDto implements Serializable {

    /** プロジェクトリスト */
    private List<Project> projectList = new ArrayList<>();

    // ゲッタ及びセッタは省略
}
```
この実装のポイント
* 配列やコレクション型を [セッションストア](../../component/libraries/libraries-session-store.md#session-store) に登録する場合は、シリアライズ可能なBeanのプロパティとして定義し、
  そのBeanを [セッションストア](../../component/libraries/libraries-session-store.md#session-store) に登録すること。詳細は [セッションストア使用上の制約](../../component/libraries/libraries-session-store.md#session-store-constraint) を参照。

一括更新画面を表示する業務アクションメソッドの作成
データベースから対象プロジェクトを取得し、一括更新画面に表示する業務アクションメソッドを作成する。

ProjectBulkAction.java
```java
@InjectForm(form = ProjectSearchForm.class, prefix = "searchForm",  name = "searchForm")
@OnError(type = ApplicationException.class, path = "forward://initialize")
public HttpResponse list(HttpRequest request, ExecutionContext context) {

    ProjectSearchForm searchForm = context.getRequestScopedVar("searchForm");

    // 検索実行
    ProjectSearchDto projectSearchDto
        = BeanUtil.createAndCopy(ProjectSearchDto.class, searchForm);
    EntityList<Project> projectList = searchProject(projectSearchDto, context);
    ProjectListDto projectListDto = new ProjectListDto();
    projectListDto.setProjectList(projectList);
    SessionUtil.put(context, "projectListDto", projectListDto);

    // 更新対象を画面に引き渡す
    context.setRequestScopedVar("bulkForm", projectListDto);

    // 検索条件を保存
    SessionUtil.put(context, "projectSearchDto", projectSearchDto);

    return new HttpResponse("/WEB-INF/view/projectBulk/update.jsp");
}
```
この実装のポイント
* 検索メソッドの実装方法に関しては [検索機能の作成：業務アクションの実装](../../processing-pattern/web-application/web-application-getting-started-project-search.md#project-search-create-action) と同様であるためそちらを参照。
* 確認画面から一括更新画面へ戻った際に、同条件でページングや再検索ができるように
  検索条件を [セッションストア](../../component/libraries/libraries-session-store.md#session-store) に登録して持ちまわす。

一括更新画面JSPの作成
検索結果の表示と複数のプロジェクトの情報を編集する、一括更新画面のJSPを作成する。

/src/main/webapp/WEB-INF/projectBulk/update.jsp
```jsp
<!-- 顧客検索結果の表示部分 -->
<n:form>
    <!-- 現在の検索結果の表示に使用した検索条件をパラメータとして持つURIを、
         変数としてpageスコープに登録する。
         この変数は、<app:listSearchResult>タグのページング用のURIとして使用される。-->
    <c:url value="list" var="uri">
        <!-- セッションストア上のprojectSearchDtoから検索条件を取得する -->
        <c:param name="searchForm.clientId" value="${projectSearchDto.clientId}"/>
        <c:param name="searchForm.clientName" value="${projectSearchDto.clientName}"/>
        <c:param name="searchForm.projectName" value="${projectSearchDto.projectName}"/>
        <!-- 以降も同様に検索条件パラメータであるため省略 -->

    </c:url>
    <app:listSearchResult>
    <!-- listSearchResultの属性値は省略 -->
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
                    <!-- プロジェクトIDをパラメータとするリンクを表示する -->
                    <n:a href="show/${row.projectId}">
                        <n:write name="bulkForm.projectList[${status.index}].projectId"/>
                    </n:a>
                    <n:plainHidden name="bulkForm.projectList[${status.index}].projectId"/>
                </td>
                <td>
                    <div class="form-group">
                        <n:text name="bulkForm.projectList[${status.index}].projectName"
                                maxlength="64" cssClass="form-control form-control-lg"
                                errorCss="input-error"/>
                        <n:error errorCss="message-error"
                                name="bulkForm.projectList[${status.index}].projectName" />
                    </div>
                </td>
                <!-- その他の編集項目は省略 -->

            </tr>
        </jsp:attribute>
    </app:listSearchResult>
    <div class="title-nav page-footer">
        <div class="button-nav">
            <n:button id="bottomUpdateButton" uri="/action/projectBulk/confirmOfUpdate"
                disabled="${isUpdatable}" cssClass="btn btn-lg btn-success">
                    更新</n:button>
            <n:a id="bottomCreateButton" type="button" uri="/action/project"
                cssClass="btn btn-lg btn-light" value="新規登録"></n:a>
        </div>
    </div>
</n:form>
```
この実装のポイント
* 検索結果を表示するJSPの作成方法は [検索機能の作成：検索結果表示部分の作成](../../processing-pattern/web-application/web-application-getting-started-project-search.md#project-search-create-result-jsp) と同様であるため、そちらを参照。
* 確認画面から一括更新画面に戻った際に、同条件での再検索やページングが行えるように、 [セッションストア](../../component/libraries/libraries-session-store.md#session-store) から取得した検索条件を元に検索条件パラメータを構成する。
  JSPでは、 [セッションストア](../../component/libraries/libraries-session-store.md#session-store) に登録したオブジェクトは、リクエストスコープに登録したオブジェクトと同様に扱うことができる。
* 配列型、もしくは List 型プロパティの要素は、 プロパティ名[index] 形式でアクセスできる。
  詳細は [入力/出力データへのアクセスルール](../../component/libraries/libraries-tag.md#tag-access-rule) 参照。

更新内容を確認する業務アクションメソッドの作成
更新内容を確認する業務アクションメソッドを作成する。

ProjectBulkAction.java
```java
@InjectForm(form = ProjectBulkForm.class, prefix = "bulkForm", name = "bulkForm")
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/projectBulk/update.jsp")
public HttpResponse confirmOfUpdate(HttpRequest request, ExecutionContext context) {

    ProjectBulkForm form = context.getRequestScopedVar("bulkForm");
    ProjectListDto dto = SessionUtil.get(context, "projectListDto");

    // 更新内容をセッションに上書き
    final List<InnerProjectForm> innerForms = form.getProjectList();
    dto.getProjectList()
       .forEach(project ->
               innerForms.stream()
                         .filter(innerForm ->
                                 Objects.equals(innerForm.getProjectId(), project.getProjectId()
                                                                                 .toString()))
                         .findFirst()
                         .ifPresent(innerForm -> BeanUtil.copy(innerForm, project)));

    return new HttpResponse("/WEB-INF/view/projectBulk/confirmOfUpdate.jsp");
}
```
この実装のポイント
* 更新する情報は [セッションストア](../../component/libraries/libraries-session-store.md#session-store) に保持する。

確認画面JSPの作成
変更後のプロジェクト情報を表示する画面のJSPを作成する。

/src/main/webapp/WEB-INF/projectBulk/confirmOfUpdate.jsp
```jsp
<section>
    <div class="title-nav">
        <span>プロジェクト検索一覧更新画面</span>
        <div class="button-nav">
            <n:form useToken="true">
              <!-- ボタン部分は省略 -->
            </n:form>
        </div>
    </div>
    <h2 class="font-group my-3">プロジェクト変更一覧</h2>
    <div>
        <table class="table table-striped table-hover">
            <tr>
                <th>プロジェクトID</th>
                <th>プロジェクト名</th>
                <th>プロジェクト種別</th>
                <th>開始日</th>
                <th>終了日</th>
            </tr>
            <c:forEach var="row" items="${projectListDto.projectList}">
                <tr class="<n:write name='oddEvenCss' />">
                    <td>
                        <n:write name="row.projectId" />
                    </td>
                    <!-- 他項目は省略 -->
                </tr>
            </c:forEach>
        </table>
    </div>
</section>
```

データベースを一括更新する業務アクションメソッドの作成
対象プロジェクトを一括で更新する。

ProjectBulkAction.java
```java
@OnDoubleSubmission
public HttpResponse update(HttpRequest request, ExecutionContext context) {

  ProjectListDto projectListDto = SessionUtil.get(context, "projectListDto");
  projectListDto.getProjectList().forEach(UniversalDao::update);

  return new HttpResponse(303, "redirect://completeOfUpdate");
}
```
この実装のポイント
* 基本的な実装方法は  [更新機能の作成：データベースを更新する業務アクションメソッドの作成](../../processing-pattern/web-application/web-application-getting-started-project-update.md#project-update-create-decide-action) と同様である。
* UniversalDao#update を更新件数分実行する。
  排他制御エラーが発生した場合は全件の更新がロールバックされる。

  > **Tip:**
> Exampleアプリケーションでは独自のエラー制御ハンドラを追加しているため、排他制御エラーにより OptimisticLockException が発生した場合、
  > 排他制御エラー画面へ遷移する。ハンドラによるエラー制御の作成方法は、 [ハンドラで例外クラスに対応したエラーページに遷移させる](../../processing-pattern/web-application/web-application-forward-error-page.md#forward-error-page-handler) を参照。
* UniversalDao には、エンティティのリストを引数に取る
  UniversalDao#batchUpdate メソッドも用意されているが、
  このメソッドは [バッチ実行](../../component/libraries/libraries-universal-dao.md#universal-dao-batch-execute) での使用を想定したものであり、排他制御を行わない。
  排他制御が必要である場合は、 UniversalDao#update
  を使用すること。

完了画面の表示
完了画面の実装方法は [更新機能の作成：更新完了画面の作成](../../processing-pattern/web-application/web-application-getting-started-project-update.md#project-update-create-success-jsp) と同様であるためそちらを参照。

一括更新機能の解説は以上。

[Getting Started TOPページへ](../../processing-pattern/web-application/web-application-getting-started.md#getting-started)
