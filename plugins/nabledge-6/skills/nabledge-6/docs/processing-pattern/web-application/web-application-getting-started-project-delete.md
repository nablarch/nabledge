# 削除機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/project_delete/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html)

## 削除を行う

**アノテーション**: `@OnDoubleSubmission`

**業務アクションメソッド** (`ProjectAction.java`):

```java
@OnDoubleSubmission
public HttpResponse delete(HttpRequest request, ExecutionContext context) {
    // 更新画面を表示する際にセッションにプロジェクト情報を格納している
    Project project = SessionUtil.delete(context, "project");
    UniversalDao.delete(project);
    return new HttpResponse(303, "redirect://completeOfDelete");
}
```

- 主キーを条件とした削除は、主キーが設定されたエンティティを引数に `UniversalDao#delete` を実行することで、SQLを作成せずに実行できる。
- セッションからプロジェクト情報を取得して削除する際は `SessionUtil.delete(context, "project")` を使用する。更新画面を表示する際にセッションにプロジェクト情報を格納しているため、削除時にセッションから取得できる。

> **補足**: :ref:`universal_dao` は主キーを条件とする削除のみ提供。主キー以外を条件に削除する場合は別途SQLを作成して :ref:`SQLIDを指定してSQLを実行する<database-execute_sqlid>` で実行する。

<details>
<summary>keywords</summary>

UniversalDao, SessionUtil, HttpRequest, ExecutionContext, HttpResponse, Project, @OnDoubleSubmission, ProjectAction, プロジェクト削除, 主キー削除, 二重サブミット防止, UniversalDao#delete

</details>
