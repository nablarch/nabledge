# 登録内容確認画面から登録画面へ戻る

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/client_create/client_create3.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html)

## 登録内容確認画面から登録画面へ戻る実装

確認画面から登録画面へ戻る際の実装パターン。`ClientAction`に`back()`メソッドと`input()`メソッドを実装する。

**`back()`メソッド**:

```java
public HttpResponse back(HttpRequest request, ExecutionContext context) {
    Client client = SessionUtil.get(context, "client");
    ClientForm form = BeanUtil.createAndCopy(ClientForm.class, client);
    context.setRequestScopedVar("form", form);
    return new HttpResponse("forward://input");
}
```

- :ref:`session_store` から顧客情報を取得する
- `BeanUtil` を使用して顧客エンティティをフォームに変換し、リクエストスコープに登録する
- レスポンスの遷移先を初期表示処理への内部フォーワードとする（登録画面表示時にプルダウン用の業種情報を再取得するため）

**`input()`メソッド**:

```java
public HttpResponse input(HttpRequest request, ExecutionContext context) {
    SessionUtil.delete(context, "client");
    EntityList<Industry> industries = UniversalDao.findAll(Industry.class);
    context.setRequestScopedVar("industries", industries);
    return new HttpResponse("/WEB-INF/view/client/create.jsp");
}
```

- 初期表示処理で :ref:`session_store` へ登録したオブジェクトを削除する（戻るボタンを押下せずにヘッダメニューから直接登録画面に遷移された場合等を考慮）

<details>
<summary>keywords</summary>

ClientAction, SessionUtil, BeanUtil, nablarch.core.beans.BeanUtil, HttpResponse, HttpRequest, ExecutionContext, Client, ClientForm, EntityList, Industry, UniversalDao, 確認画面から戻る, セッションストア, 内部フォーワード, フォーム変換, 登録画面戻る

</details>
