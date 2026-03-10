# 削除機能の作成

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
