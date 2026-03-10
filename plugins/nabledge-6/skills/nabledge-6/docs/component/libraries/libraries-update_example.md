# 更新機能での実装例

**公式ドキュメント**: [更新機能での実装例](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/session_store/update_example.html)

## 入力画面の初期表示

ブラウザを直接閉じた場合などにセッションが残っている場合があるため、入力画面初期表示時は最初にセッションを削除してから保存する。

```java
// ブラウザを直接閉じた場合などにセッションが残っている場合があるので削除
SessionUtil.delete(ctx, "project");

// 更新対象データの取得処理は省略

// 更新対象データをセッションストアに保存
SessionUtil.put(ctx, "project", project);

// EntityからFormへ変換
ProjectForm form = BeanUtil.createAndCopy(ProjectForm.class, project);

// 更新対象データをリクエストスコープに設定
context.setRequestScopedVar("form", form);
```

<details>
<summary>keywords</summary>

SessionUtil, BeanUtil, ProjectForm, セッションストア削除, 入力画面初期表示, セッション初期化, セッションストア保存

</details>

## 入力画面から確認画面へ遷移

```java
// リクエストスコープから入力情報を取得
ProjectForm form = context.getRequestScopedVar("form");

// 更新対象データをセッションストアから取得
Project project = SessionUtil.get(context, "project");

// 入力情報を更新対象データに上書き
BeanUtil.copy(form, project);
```

<details>
<summary>keywords</summary>

SessionUtil, BeanUtil, Project, ProjectForm, 確認画面遷移, セッションストア取得, 入力情報上書き

</details>

## 確認画面から入力画面へ戻る

```java
// セッションストアから更新対象データを取得
Project project = SessionUtil.get(ctx, "project");

// EntityからFormへ変換
ProjectForm form = BeanUtil.createAndCopy(ProjectForm.class, project);

// 更新対象データをリクエストスコープに設定
context.setRequestScopedVar("form", form);
```

<details>
<summary>keywords</summary>

SessionUtil, BeanUtil, Project, ProjectForm, 入力画面戻る, セッションストア取得, フォーム変換

</details>

## 更新処理を実行

```java
// セッションストアから更新対象データを取得
Project project = SessionUtil.get(ctx, "project");

// 更新処理は省略

// セッションストアから更新対象データを削除
SessionUtil.delete(ctx, "project");
```

<details>
<summary>keywords</summary>

SessionUtil, Project, セッションストア削除, 更新処理完了後セッション削除

</details>
