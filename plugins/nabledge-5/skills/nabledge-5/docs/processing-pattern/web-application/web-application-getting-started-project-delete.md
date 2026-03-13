# 削除機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/project_delete/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html)

## 削除を行う

**アノテーション**: `@OnDoubleSubmission`  
**クラス**: `SessionUtil`, `UniversalDao`

```java
@OnDoubleSubmission
public HttpResponse delete(HttpRequest request, ExecutionContext context) {
    // 更新画面を表示する際にセッションにプロジェクト情報を格納している
    Project project = SessionUtil.delete(context, "project");
    UniversalDao.delete(project);
    return new HttpResponse(303, "redirect://completeOfDelete");
}
```

主キーが設定されたエンティティを引数に `UniversalDao#delete` を実行することで、SQLを作成せずに主キー条件での削除が可能。

> **補足**: [universal_dao](../../component/libraries/libraries-universal_dao.md) は主キーを条件とする削除のみ提供。主キー以外の条件で削除する場合は、別途SQLを作成して実行する必要がある（[SQLIDを指定してSQLを実行する](../../component/libraries/libraries-database.md) 参照）。

<details>
<summary>keywords</summary>

UniversalDao, SessionUtil, @OnDoubleSubmission, nablarch.common.dao.UniversalDao.delete(T), 削除機能, データベース削除, 主キー削除, セッションデータ削除, HttpResponse, HttpRequest, ExecutionContext, Project

</details>
