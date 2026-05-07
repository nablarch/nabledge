# 更新機能の作成

Exampleアプリケーションを元に更新機能を解説する。

作成する機能の説明

1. プロジェクト一覧のプロジェクトIDを押下する。

![project_update_detail_link.png](../../../knowledge/assets/web-application-getting-started-project-update/project_update_detail_link.png)

1. 対象プロジェクトの詳細画面が表示されるので、変更ボタンを押下する。

![project_update_detail.png](../../../knowledge/assets/web-application-getting-started-project-update/project_update_detail.png)

1. 更新する項目を書き換えて、更新ボタンを押下する。

![project_update_update.png](../../../knowledge/assets/web-application-getting-started-project-update/project_update_update.png)

1. 更新確認画面が表示されるので、確定ボタンを押下する。

![project_update_confirm.png](../../../knowledge/assets/web-application-getting-started-project-update/project_update_confirm.png)

1. データベースが更新され、更新完了画面が表示される。

![project_update_complete.png](../../../knowledge/assets/web-application-getting-started-project-update/project_update_complete.png)

## 更新内容の入力と確認

更新機能の実装方法のうち、更新内容の入力及び確認について以下の順に解説する。

1. [フォームの作成](../../processing-pattern/web-application/web-application-getting-started-project-update.md#project-update-create-form)
2. [更新画面を表示する業務アクションメソッドの作成](../../processing-pattern/web-application/web-application-getting-started-project-update.md#project-update-create-edit-action)
3. [更新画面のJSPの作成](../../processing-pattern/web-application/web-application-getting-started-project-update.md#project-update-create-update-jsp)
4. [更新内容の確認を行う業務アクションメソッドの作成](../../processing-pattern/web-application/web-application-getting-started-project-update.md#project-update-create-confirm-action)
5. [更新確認画面のJSPの作成](../../processing-pattern/web-application/web-application-getting-started-project-update.md#project-update-create-confirm-jsp)

フォームの作成

詳細画面から更新画面へ遷移する際のパラメータを受け付けるフォームと、更新画面編集欄への入力値を受け付けるフォームを作成する。

詳細画面から更新画面へ遷移する際にパラメータを受け付けるフォーム

詳細画面から更新画面へ遷移する際にパスパラメータ(「show/:projectId」の「:projectId」部分)として渡される、
対象のプロジェクトIDを受け付けるフォームを作成する。

ProjectTargetForm.java

```java
public class ProjectTargetForm implements Serializable {

    /** プロジェクトID */
    @Required
    @Domain("id")
    private String projectId;

    // ゲッタ及びセッタは省略
```

更新画面から入力された値を受け付けるフォーム

更新画面から入力された、編集後の値を受け付けるフォームを作成する。

ProjectUpdateForm.java

```java
public class ProjectUpdateForm implements Serializable {

    // 一部のみ抜粋

    /** プロジェクト名 */
    @Required
    @Domain("projectName")
    private String projectName;

    /**
     * プロジェクト名を取得する。
     *
     * @return プロジェクト名
     */
    public String getProjectName() {
        return this.projectName;
    }

    /**
     * プロジェクト名を設定する。
     *
     * @param projectName 設定するプロジェクト名
     */
    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }
}
```

この実装のポイント

* 入力項目がプロジェクト登録画面と重複しているが、
  責務配置上 [フォームはHTMLのフォーム単位で作成すべきである](../../processing-pattern/web-application/web-application-application-design.md#application-design-form-html) ため、プロジェクト更新画面専用のフォームを作成する。

更新画面を表示する業務アクションメソッドの作成

データベースから現在の情報を取得し、更新画面を表示する業務アクションメソッドを作成する。

ProjectAction.java

```java
@InjectForm(form = ProjectTargetForm.class)
public HttpResponse edit(HttpRequest request, ExecutionContext context) {

    // 更新処理で使用するセッション情報を削除しておく。
    SessionUtil.delete(context, "project");

    ProjectTargetForm targetForm = context.getRequestScopedVar("form");
    LoginUserPrincipal userContext = SessionUtil.get(context, "userContext");

    // 他のユーザによって対象プロジェクトが削除されている場合NoDataExceptionを送出
    ProjectDto dto = UniversalDao.findBySqlFile(ProjectDto.class, "FIND_BY_PROJECT",
            new Object[]{targetForm.getProjectId(), userContext.getUserId()});

    // 出力情報をリクエストスコープにセット
    context.setRequestScopedVar("form", dto);

    SessionUtil.put(context, "project", BeanUtil.createAndCopy(Project.class, dto));

    return new HttpResponse("/WEB-INF/view/project/update.jsp");
}
```

この実装のポイント

* 編集フォームに初期表示する値を取得するために、
  UniversalDao#findBySqlFile
  を使用して一意キー検索を行う。
  [テーブルをJOINした結果を取得する](../../component/libraries/libraries-universal-dao.md#universal-dao-join) ために、検索結果はBeanで受け付ける。
  一意キー検索では、対象データが存在しない場合 NoDataException を送出する。

  > **Tip:**
> Exampleアプリケーションでは、独自のエラー制御ハンドラを追加しているため、 NoDataException が発生した場合は404エラー画面へ遷移する。
  > ハンドラによるエラー制御の作成方法は、 [ハンドラで例外クラスに対応したエラーページに遷移させる](../../processing-pattern/web-application/web-application-forward-error-page.md#forward-error-page-handler) を参照。
* 編集中に他ユーザによる更新が行われる可能性を考慮し、編集開始時点のバージョン番号を用いて [楽観的ロック](../../component/libraries/libraries-universal-dao.md#universal-dao-jpa-version) (後述)を行うため、
  編集開始時点のエンティティを [セッションストア](../../component/libraries/libraries-session-store.md#session-store) に登録する。

更新画面のJSPの作成

画面の作成については、登録編の [登録画面初期表示の作成](../../processing-pattern/web-application/web-application-client-create1.md#client-create-1) にて説明済みであるため省略する。

更新内容の確認を行う業務アクションメソッドの作成

更新内容をバリデーションし、確認画面を表示する業務アクションメソッドを作成する。
[Bean Validation](../../component/libraries/libraries-bean-validation.md#bean-validation) に加えて、業務アクションメソッド内に、データベース検索を伴うバリデーションを実装する。

ProjectAction.java

```java
@InjectForm(form = ProjectUpdateForm.class, prefix = "form")
@OnError(type = ApplicationException.class,
        path = "/WEB-INF/view/project/update.jsp")
public HttpResponse confirmOfUpdate(HttpRequest request, ExecutionContext context) {
    ProjectUpdateForm form = context.getRequestScopedVar("form");

    // データベースを検索して入力されたIDを持つ顧客が存在するか確認する
    if (form.hasClientId()) {
        if (!UniversalDao.exists(Client.class, "FIND_BY_CLIENT_ID",
                new Object[] {Integer.parseInt(form.getClientId()) })) {
                    throw new ApplicationException(
                        MessageUtil.createMessage(MessageLevel.ERROR,
                            "errors.nothing.client", form.getClientId()));

        }
    }

    Project project = SessionUtil.get(context, "project");

    // フォームの値をセッションへ上書きする
    BeanUtil.copy(form, project);

    // 出力情報をリクエストスコープにセット
    context.setRequestScopedVar("form", BeanUtil.createAndCopy(ProjectDto.class, form));
    context.setRequestScopedVar("profit", new ProjectProfit(
            project.getSales(),
            project.getCostOfGoodsSold(),
            project.getSga(),
            project.getAllocationOfCorpExpenses()
    ));

    return new HttpResponse("/WEB-INF/view/project/confirmOfUpdate.jsp");
}
```

この実装のポイント

* データベース検索が必要なバリデーションは業務アクションメソッドに記述する。
  データの存在確認をする場合、 UniversalDao#exists
  を使用する。詳細は、 [データベース検索が必要なバリデーション](../../component/libraries/libraries-bean-validation.md#bean-validation-database-validation) を参照。
* 責務配置上 [フォームを直接セッションストアに格納すべきではない](../../component/libraries/libraries-session-store.md#session-store-form) ため、Beanへ詰め替える。

SQLの作成

顧客の存在確認に使用するために、顧客IDから顧客情報を取得するSQLを作成する。

client.sql

```sql
FIND_BY_CLIENT_ID =
SELECT
    CLIENT_ID,
    CLIENT_NAME,
    INDUSTRY_CODE
FROM
    CLIENT
WHERE
    CLIENT_ID = :clientId
```

この実装のポイント

* 存在確認用のSQLはSELECT文として作成する。

更新確認画面のJSPの作成

更新画面を使い回して、更新確認画面を作成する。

/src/main/webapp/WEB-INF/view/project/update.jsp

```jsp
<n:form useToken="true">
  <!-- 登録内容の確認部分 -->
    <div class="title-nav page-footer">
        <!-- ページ下部のボタン部分 -->
        <div class="button-nav">
            <n:forInputPage>
                <!-- 入力画面向けボタン部分 -->
            </n:forInputPage>
            <n:forConfirmationPage>
                <!-- 確認画面向けボタン部分 -->
                <n:submit value = "確定" uri="/action/project/update" id="bottomSubmitButton"
                        cssClass="btn btn-lg btn-success"
                        allowDoubleSubmission="false" type="button" />
            </n:forConfirmationPage>
        </div>
    </div>
</n:form>
```

この実装のポイント

* 更新画面を確認画面として使い回す方法は、 [登録機能の確認画面作成](../../processing-pattern/web-application/web-application-client-create2.md#client-create-forconfirmationpage) にて説明済みであるため省略する。
* 二重サブミットを防ぐJavaScriptを追加するために、 [submitタグ](../../component/libraries/libraries-tag-reference.md#tag-submit-tag) の allowDoubleSubmission 属性にfalseを指定する。
  詳細は [二重サブミットを防ぐ](../../component/libraries/libraries-tag.md#tag-double-submission) を参照。

## データベースの更新

更新機能の実装方法のうち、更新内容の確認について以下の順に解説する。

1. [業務アクションメソッドの作成](../../processing-pattern/web-application/web-application-getting-started-project-update.md#project-update-create-decide-action)
2. [更新完了画面の作成](../../processing-pattern/web-application/web-application-getting-started-project-update.md#project-update-create-success-jsp)

業務アクションメソッドの作成

データベースを更新し、変更を確定する業務アクションメソッドを作成する。
[楽観的ロック](../../component/libraries/libraries-universal-dao.md#universal-dao-jpa-version) を行うためのエンティティ定義も合わせて解説する。

データベース更新を行う業務アクションメソッドの作成

データベースを更新し、完了画面表示メソッドへリダイレクトする業務アクションメソッドを作成する。

ProjectAction.java

```java
@OnDoubleSubmission
public HttpResponse update(HttpRequest request, ExecutionContext context) {
    Project targetProject = SessionUtil.delete(context, "project");
    UniversalDao.update(targetProject);

    return new HttpResponse(303, "redirect://completeOfUpdate");
}
```

この実装のポイント

* エンティティに更新したい値を設定し、 UniversalDao#update を使用してデータベースを更新する。
  更新処理では楽観的ロックが実行される。
* 二重サブミットを防止するために、 @OnDoubleSubmission を付与する。
* ブラウザ更新での再実行を防ぐために、レスポンスをリダイレクトする。

  * リソースパスの書式については ResourceLocator を参照。
  * リダイレクトに指定するステータスコードについては、 [ステータスコード](../../processing-pattern/web-application/web-application-feature-details.md#web-feature-details-status-code) を参照。

楽観的ロックの対象となるエンティティの作成

[楽観的ロック](../../component/libraries/libraries-universal-dao.md#universal-dao-jpa-version) を有効化したエンティティを作成する。

Project.java

```java
// その他のプロパティは省略

/** バージョン番号 */
private Long version;

/**
 * バージョン番号を返します。
 *
 * @return バージョン番号
 */
@Version
@Column(name = "VERSION", precision = 19, nullable = false, unique = false)
public Long getVersion() {
    return version;
}

/**
 * バージョン番号を設定します。
 *
 * @param version バージョン番号
 */
public void setVersion(Long version) {
    this.version = version;
}
```

この実装のポイント

* [楽観的ロック](../../component/libraries/libraries-universal-dao.md#universal-dao-jpa-version) を行うために、エンティティに version プロパティを作成し
  ゲッタに [@Version](../../component/libraries/libraries-universal-dao.md#universal-dao-jpa-version) を付与する。

完了画面を表示する業務アクションメソッドの作成

更新メソッドのリダイレクト先となる、完了画面を表示する業務アクションメソッドを作成する。

ProjectAction.java

```java
public HttpResponse completeOfUpdate(HttpRequest request, ExecutionContext context) {
    return new HttpResponse("/WEB-INF/view/project/completeOfUpdate.jsp");
}
```

更新完了画面の作成

更新完了画面を作成する。

/src/main/webapp/WEB-INF/view/project/completeOfUpdate.jsp

```jsp
<n:form>
    <div class="title-nav">
        <h1 class="page-title">プロジェクト変更完了画面</h1>
        <div class="button-nav">
          <!-- 省略 -->
        </div>
    </div>
    <div class="message-area message-info">
        プロジェクトの更新が完了しました。
    </div>
    <!-- 省略 -->
</n:form>
```

更新機能の解説は以上。

[Getting Started TOPページへ](../../processing-pattern/web-application/web-application-getting-started.md#getting-started)
