# 登録内容確認画面から登録画面へ戻る

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/client_create/client_create3.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html)

## 登録画面へ戻る処理の実装

## 登録画面へ戻る処理の実装

`ClientAction` に `back()` メソッドと `input()` メソッドを追加する。

```java
public HttpResponse back(HttpRequest request, ExecutionContext context) {
    Client client = SessionUtil.get(context, "client");
    ClientForm form = BeanUtil.createAndCopy(ClientForm.class, client);
    context.setRequestScopedVar("form", form);
    return new HttpResponse("forward://input");
}

public HttpResponse input(HttpRequest request, ExecutionContext context) {
    SessionUtil.delete(context, "client");
    EntityList<Industry> industries = UniversalDao.findAll(Industry.class);
    context.setRequestScopedVar("industries", industries);
    return new HttpResponse("/WEB-INF/view/client/create.jsp");
}
```

実装のポイント:
- :ref:`セッションストア <session_store>` から顧客情報を取得する。
- `BeanUtil` を使用して顧客エンティティをフォームに変換し、リクエストスコープに登録する。
- レスポンスの遷移先は初期表示処理への内部フォーワードとする（登録画面を表示する際、再度プルダウンに表示する業種情報を取得するため）。
- 初期表示処理で :ref:`セッションストア <session_store>` に登録したオブジェクトを削除する（戻るボタンを押下せずヘッダメニューから直接登録画面に遷移された場合等を考慮）。

<details>
<summary>keywords</summary>

ClientAction, ClientForm, BeanUtil, nablarch.core.beans.BeanUtil, SessionUtil, HttpResponse, HttpRequest, ExecutionContext, Client, EntityList, Industry, UniversalDao, 確認画面から入力画面への戻る処理, セッションストア操作, 内部フォーワード, リクエストスコープへのフォーム登録

</details>
