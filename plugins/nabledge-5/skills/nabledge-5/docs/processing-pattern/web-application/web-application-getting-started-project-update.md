# 更新機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/project_update/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/NoDataException.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/OnDoubleSubmission.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/ResourceLocator.html)

## 更新内容の入力と確認

## フォームの作成

更新機能では2種類のフォームを作成する。

**詳細画面→更新画面遷移時のパラメータ受付フォーム** (`ProjectTargetForm.java`):
```java
public class ProjectTargetForm implements Serializable {
    @Required
    @Domain("id")
    private String projectId;
    // ゲッタ及びセッタは省略
}
```

**更新画面入力値受付フォーム** (`ProjectUpdateForm.java`):
```java
public class ProjectUpdateForm implements Serializable {
    @Required
    @Domain("projectName")
    private String projectName;
    // ゲッタ・セッタあり
}
```

> **補足**: 入力項目が登録画面と重複していても、:ref:`フォームはHTMLのフォーム単位で作成すべきである<application_design-form_html>` ため、更新画面専用フォームを作成する。

## 更新画面を表示する業務アクションメソッド

`ProjectAction.java`:
```java
@InjectForm(form = ProjectTargetForm.class)
public HttpResponse edit(HttpRequest request, ExecutionContext context) {
    SessionUtil.delete(context, "project");
    ProjectTargetForm targetForm = context.getRequestScopedVar("form");
    LoginUserPrincipal userContext = SessionUtil.get(context, "userContext");
    ProjectDto dto = UniversalDao.findBySqlFile(ProjectDto.class, "FIND_BY_PROJECT",
            new Object[]{targetForm.getProjectId(), userContext.getUserId()});
    context.setRequestScopedVar("form", dto);
    SessionUtil.put(context, "project", BeanUtil.createAndCopy(Project.class, dto));
    return new HttpResponse("/WEB-INF/view/project/update.jsp");
}
```

- 編集フォームの初期値取得には `UniversalDao#findBySqlFile` で一意キー検索を行う。テーブルJOINの結果はBeanで受け付ける。対象データが存在しない場合は `NoDataException` を送出する。
- 楽観的ロックのため、編集開始時点のエンティティを :ref:`session_store` に登録する。

> **補足**: `NoDataException` 発生時の404エラー画面遷移はハンドラで制御する。詳細は [forward_error_page-handler](web-application-forward_error_page.md) を参照。

## 更新内容の確認を行う業務アクションメソッド

`ProjectAction.java`:
```java
@InjectForm(form = ProjectUpdateForm.class, prefix = "form")
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/project/update.jsp")
public HttpResponse confirmOfUpdate(HttpRequest request, ExecutionContext context) {
    ProjectUpdateForm form = context.getRequestScopedVar("form");
    if (form.hasClientId()) {
        if (!UniversalDao.exists(Client.class, "FIND_BY_CLIENT_ID",
                new Object[] {Integer.parseInt(form.getClientId())})) {
            throw new ApplicationException(
                MessageUtil.createMessage(MessageLevel.ERROR,
                    "errors.nothing.client", form.getClientId()));
        }
    }
    Project project = SessionUtil.get(context, "project");
    BeanUtil.copy(form, project);
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

- DBを検索して存在確認が必要なバリデーションは業務アクションメソッド内に記述する。存在確認には `UniversalDao#exists` を使用する。詳細は [bean_validation-database_validation](../../component/libraries/libraries-bean_validation.md) を参照。
- :ref:`フォームを直接セッションストアに格納すべきではない<session_store-form>` ため、Beanへ詰め替えてから保存する。

**SQL (client.sql)**:
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

存在確認用SQLはSELECT文として作成する。

## 更新確認画面のJSP

更新画面を使い回して確認画面とする。二重サブミット防止のため [tag-submit_tag](../../component/libraries/libraries-tag_reference.md) の `allowDoubleSubmission` 属性に `false` を指定する（詳細は :ref:`tag-double_submission` 参照）。

`update.jsp`:
```jsp
<n:form useToken="true">
    <n:forConfirmationPage>
        <n:submit value="確定" uri="/action/project/update" id="bottomSubmitButton"
                cssClass="btn btn-raised btn-success"
                allowDoubleSubmission="false" type="button" />
    </n:forConfirmationPage>
</n:form>
```

<details>
<summary>keywords</summary>

ProjectTargetForm, ProjectUpdateForm, LoginUserPrincipal, ProjectDto, MessageUtil, ProjectProfit, @Required, @Domain, @InjectForm, @OnError, UniversalDao, NoDataException, ApplicationException, BeanUtil, SessionUtil, Client, MessageLevel, 更新フォーム作成, 楽観的ロック, DB検索バリデーション, 二重サブミット防止, allowDoubleSubmission, session_store

</details>

## データベースの更新

## DB更新を行う業務アクションメソッド

`ProjectAction.java`:
```java
@OnDoubleSubmission
public HttpResponse update(HttpRequest request, ExecutionContext context) {
    Project targetProject = SessionUtil.delete(context, "project");
    UniversalDao.update(targetProject);
    return new HttpResponse(303, "redirect://completeOfUpdate");
}
```

- `UniversalDao#update` でDB更新。更新時に楽観的ロック（:ref:`universal_dao_jpa_version`）が実行される。
- 二重サブミット防止のため `@OnDoubleSubmission` を付与する。
- ブラウザ更新による再実行防止のためレスポンスをリダイレクトする。リソースパスの書式は `ResourceLocator` を参照。ステータスコードは [web_feature_details-status_code](web-application-feature_details.md) を参照。

## 楽観的ロック用エンティティの定義

:ref:`楽観的ロック<universal_dao_jpa_version>` を有効化するにはエンティティに `version` プロパティを作成し、ゲッタに :ref:`@Version <universal_dao_jpa_version>` を付与する。

`Project.java`:
```java
private Long version;

@Version
@Column(name = "VERSION", precision = 19, nullable = false, unique = false)
public Long getVersion() {
    return version;
}
public void setVersion(Long version) {
    this.version = version;
}
```

## 完了画面を表示する業務アクションメソッド

`ProjectAction.java`:
```java
public HttpResponse completeOfUpdate(HttpRequest request, ExecutionContext context) {
    return new HttpResponse("/WEB-INF/view/project/completeOfUpdate.jsp");
}
```

`completeOfUpdate.jsp`:
```jsp
<div class="message-area message-info">
    プロジェクトの更新が完了しました。
</div>
```

<details>
<summary>keywords</summary>

Project, @OnDoubleSubmission, @Version, @Column, UniversalDao, SessionUtil, ResourceLocator, 楽観的ロック, DB更新, リダイレクト, 二重サブミット防止, 完了画面表示

</details>
