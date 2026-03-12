# 更新機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/project_update/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/NoDataException.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/OnDoubleSubmission.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/ResourceLocator.html)

## 更新内容の入力と確認

## フォームの作成

**クラス**: `ProjectTargetForm`, `ProjectUpdateForm`
**アノテーション**: `@Required`, `@Domain`

- `ProjectTargetForm`: 詳細→更新画面遷移時のパスパラメータ（`show/:projectId`の`:projectId`）でプロジェクトIDを受け取る
- `ProjectUpdateForm`: 更新画面の入力値（編集後の値）を受け取る

入力項目が登録画面と重複しても、:ref:`フォームはHTMLのフォーム単位で作成すべき<application_design-form_html>`ため、更新画面専用フォームを作成する。

```java
public class ProjectTargetForm implements Serializable {
    @Required
    @Domain("id")
    private String projectId;
    // getter/setter省略
}
```

```java
public class ProjectUpdateForm implements Serializable {
    @Required
    @Domain("projectName")
    private String projectName;
    // getter/setter省略
}
```

## 更新画面表示アクションメソッド（edit）

**アノテーション**: `@InjectForm`

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

- 編集フォームの初期値取得には`UniversalDao#findBySqlFile`で一意キー検索を行う。[テーブルJOIN結果](../../component/libraries/libraries-universal_dao.md)のため結果はBeanで受け取る。対象データ不在時は`NoDataException`が送出される。
- :ref:`楽観的ロック<universal_dao_jpa_version>`のため、編集開始時点のエンティティを:ref:`session_store`に登録する。

> **補足**: NoDataException発生時は独自エラー制御ハンドラで404エラー画面へ遷移する。[ハンドラで例外クラスに対応したエラーページに遷移させる](web-application-forward_error_page.md)を参照。

## 更新内容確認アクションメソッド（confirmOfUpdate）

**アノテーション**: `@InjectForm`, `@OnError`

```java
@InjectForm(form = ProjectUpdateForm.class, prefix = "form")
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/project/update.jsp")
public HttpResponse confirmOfUpdate(HttpRequest request, ExecutionContext context) {
    ProjectUpdateForm form = context.getRequestScopedVar("form");
    if (form.hasClientId()) {
        if (!UniversalDao.exists(Client.class, "FIND_BY_CLIENT_ID",
                new Object[] {Integer.parseInt(form.getClientId()) })) {
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

- データベース検索が必要なバリデーションは業務アクションメソッドに記述する。存在確認には`UniversalDao#exists`を使用する。詳細は[データベース検索が必要なバリデーション](../../component/libraries/libraries-bean_validation.md)を参照。
- :ref:`フォームを直接セッションストアに格納すべきではない<session_store-form>`ため、Beanへ詰め替える。
- 確認画面表示用に`ProjectProfit`オブジェクトを生成してリクエストスコープにセットする。

顧客存在確認SQL（client.sql）：

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

## 更新確認画面のJSP（update.jsp）

更新画面を確認画面として使い回す。[tag-submit_tag](../../component/libraries/libraries-tag_reference.md)の`allowDoubleSubmission="false"`で二重サブミット防止JSを追加する。詳細は:ref:`tag-double_submission`を参照。

```jsp
<n:form useToken="true">
    <n:forConfirmationPage>
        <n:submit value="確定" uri="/action/project/update"
                allowDoubleSubmission="false" type="button" />
    </n:forConfirmationPage>
</n:form>
```

<details>
<summary>keywords</summary>

ProjectTargetForm, ProjectUpdateForm, ProjectAction, ProjectDto, ProjectProfit, Project, LoginUserPrincipal, Client, @InjectForm, @OnError, @Required, @Domain, NoDataException, ApplicationException, MessageUtil, MessageLevel, UniversalDao, SessionUtil, BeanUtil, フォーム作成, 更新画面表示, バリデーション, 楽観的ロック, セッションストア, 二重サブミット防止

</details>

## データベースの更新

## データベース更新アクションメソッド（update）

**アノテーション**: `@OnDoubleSubmission`

```java
@OnDoubleSubmission
public HttpResponse update(HttpRequest request, ExecutionContext context) {
    Project targetProject = SessionUtil.delete(context, "project");
    UniversalDao.update(targetProject);
    return new HttpResponse(303, "redirect://completeOfUpdate");
}
```

- エンティティに更新値を設定し、`UniversalDao#update`でDB更新する。更新処理では:ref:`楽観的ロック<universal_dao_jpa_version>`が実行される。
- 二重サブミット防止のため`@OnDoubleSubmission`を付与する。
- ブラウザ更新での再実行防止のためレスポンスをリダイレクトする。リソースパスの書式は`ResourceLocator`を参照。リダイレクトのステータスコードは[web_feature_details-status_code](web-application-feature_details.md)を参照。

## 楽観的ロック用エンティティ定義

**クラス**: `Project`
**アノテーション**: `@Version`, `@Column`

:ref:`楽観的ロック<universal_dao_jpa_version>`を有効化するには、エンティティに`version`プロパティを作成し、ゲッタに:ref:`@Version<universal_dao_jpa_version>`を付与する。

```java
private Long version;

@Version
@Column(name = "VERSION", precision = 19, nullable = false, unique = false)
public Long getVersion() {
    return version;
}
```

## 完了画面表示アクションメソッド（completeOfUpdate）

```java
public HttpResponse completeOfUpdate(HttpRequest request, ExecutionContext context) {
    return new HttpResponse("/WEB-INF/view/project/completeOfUpdate.jsp");
}
```

## 更新完了画面のJSP（completeOfUpdate.jsp）

```jsp
<div class="message-area message-info">
    プロジェクトの更新が完了しました。
</div>
```

完了画面のタイトルは`プロジェクト変更完了画面`とし、`message-info`クラスのdiv内に更新完了メッセージを表示する。

<details>
<summary>keywords</summary>

ProjectAction, Project, @OnDoubleSubmission, @Version, @Column, UniversalDao, SessionUtil, ResourceLocator, 楽観的ロック, データベース更新, 二重サブミット防止, リダイレクト, バージョン番号

</details>
