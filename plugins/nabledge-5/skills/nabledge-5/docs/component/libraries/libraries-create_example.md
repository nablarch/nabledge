# 登録機能での実装例

**公式ドキュメント**: [登録機能での実装例](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/session_store/create_example.html)

## 入力画面の初期表示

## 入力画面の初期表示

ブラウザを直接閉じた場合などにセッションが残っている場合があるため、初期表示時にセッションを削除する。

```java
SessionUtil.delete(ctx, "project");
```

<details>
<summary>keywords</summary>

SessionUtil, セッション削除, 入力画面初期表示, セッションストア初期化

</details>

## 入力画面から確認画面へ遷移

## 入力画面から確認画面へ遷移

リクエストスコープから入力情報を取得し、`BeanUtil.createAndCopy` でFormからEntityへ変換後、セッションストアに保存する。

```java
ProjectForm form = context.getRequestScopedVar("form");
Project project = BeanUtil.createAndCopy(Project.class, form);
SessionUtil.put(ctx, "project", project);
```

<details>
<summary>keywords</summary>

SessionUtil, BeanUtil, ProjectForm, Project, セッション保存, 入力情報保存, 確認画面遷移

</details>

## 確認画面から入力画面へ戻る

## 確認画面から入力画面へ戻る

セッションストアから入力情報を取得し、`BeanUtil.createAndCopy` でEntityからFormへ変換してリクエストスコープに設定後、セッションストアから削除する。

```java
Project project = SessionUtil.get(ctx, "project");
ProjectForm form = BeanUtil.createAndCopy(ProjectForm.class, project);
context.setRequestScopedVar("form", form);
SessionUtil.delete(ctx, "project");
```

<details>
<summary>keywords</summary>

SessionUtil, BeanUtil, ProjectForm, Project, セッション読み込み, 入力画面へ戻る, セッション削除

</details>

## 登録処理を実行

## 登録処理を実行

セッションストアから入力情報を取得して登録処理を行い、完了後にセッションストアから削除する。

```java
Project project = SessionUtil.get(ctx, "project");
// 登録処理は省略
SessionUtil.delete(ctx, "project");
```

<details>
<summary>keywords</summary>

SessionUtil, Project, 登録処理, セッション削除, 登録完了後クリーンアップ

</details>
