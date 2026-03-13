# 更新機能での実装例

**公式ドキュメント**: [更新機能での実装例](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/session_store/update_example.html)

## 入力画面の初期表示

## 入力画面の初期表示

ブラウザを直接閉じた場合などにセッションが残っている場合があるので、初期表示時に既存セッションを削除してから新たに保存する。

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

SessionUtil, BeanUtil, ProjectForm, Project, セッションストア初期表示, 更新画面初期化, セッション削除, SessionUtil.delete, SessionUtil.put, BeanUtil.createAndCopy

</details>

## 入力画面から確認画面へ遷移

## 入力画面から確認画面へ遷移

リクエストスコープから入力情報を取得し、セッションストアの更新対象データに上書きする。

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

SessionUtil, BeanUtil, ProjectForm, Project, 入力画面確認画面遷移, セッションストアデータ取得, SessionUtil.get, BeanUtil.copy

</details>

## 確認画面から入力画面へ戻る

## 確認画面から入力画面へ戻る

セッションストアから更新対象データを取得し、Formに変換してリクエストスコープに設定する。

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

SessionUtil, BeanUtil, ProjectForm, Project, 確認画面戻る処理, セッションストアデータ取得, SessionUtil.get, BeanUtil.createAndCopy

</details>

## 更新処理を実行

## 更新処理を実行

更新処理完了後、セッションストアから更新対象データを削除する。

```java
// セッションストアから更新対象データを取得
Project project = SessionUtil.get(ctx, "project");

// 更新処理は省略

// セッションストアから更新対象データを削除
SessionUtil.delete(ctx, "project");
```

<details>
<summary>keywords</summary>

SessionUtil, Project, セッションストア削除, 更新処理後セッションクリア, SessionUtil.get, SessionUtil.delete

</details>
