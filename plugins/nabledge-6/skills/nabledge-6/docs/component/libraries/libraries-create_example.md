# 登録機能での実装例

## 入力画面の初期表示

ブラウザを直接閉じた場合などにセッションが残っている場合があるため、初期表示時にセッションを削除する。

```java
SessionUtil.delete(ctx, "project");
```

## 入力画面から確認画面へ遷移

リクエストスコープから入力情報を取得し、FormからEntityへ変換してセッションストアに保存する。

```java
ProjectForm form = context.getRequestScopedVar("form");
Project project = BeanUtil.createAndCopy(Project.class, form);
SessionUtil.put(ctx, "project", project);
```

## 確認画面から入力画面へ戻る

セッションストアから入力情報を取得し、EntityからFormへ変換してリクエストスコープに設定後、セッションストアから削除する。

```java
Project project = SessionUtil.get(ctx, "project");
ProjectForm form = BeanUtil.createAndCopy(ProjectForm.class, project);
context.setRequestScopedVar("form", form);
SessionUtil.delete(ctx, "project");
```

## 登録処理を実行

セッションストアから入力情報を取得し、登録処理後にセッションストアから削除する。

```java
Project project = SessionUtil.get(ctx, "project");
// 登録処理は省略
SessionUtil.delete(ctx, "project");
```
